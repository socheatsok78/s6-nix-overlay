{
  lib,
  runCommand,
}:
{
  name,
  dependencies ? [ ],
  run,
  finish ? null,

  user-bundle ? "user",

  # logging
  producer-for ? null,
}:
let
  # deps, check if dependencies are derivations or strings, and get their names
  deps = lib.map (dep: if lib.isDerivation dep then dep.name else dep) dependencies;
  producer = if lib.isDerivation producer-for then producer-for.name else producer-for;
in
runCommand "s6-${name}-svc"
  {
    dependencies = deps;
    producer-for = producer;
  }
  ''
    svc_name="s6-${name}-svc"
    svc_dir="$out/etc/s6-overlay/s6-rc.d/$svc_name"
    user_bundle_dir="$out/etc/s6-overlay/user-bundles.d/${user-bundle}/contents.d"

    mkdir -p $svc_dir
    mkdir -p $user_bundle_dir

    # Add service to user bundle
    touch "$user_bundle_dir/$svc_name"

    # Create service directory and files
    echo longrun > $svc_dir/type

    ${lib.optionalString (deps != [ ]) ''
      mkdir -p $svc_dir/dependencies.d
      ${lib.concatMapStrings (dep: ''
        touch $svc_dir/dependencies.d/${dep}
      '') deps}
    ''}

    ${lib.optionalString (run != null) ''
      cat > $svc_dir/run <<'EOF'
      ${run}
      EOF
      chmod +x $svc_dir/run
    ''}

    ${lib.optionalString (finish != null) ''
      cat > $svc_dir/finish <<'EOF'
      ${finish}
      EOF
      chmod +x $svc_dir/finish
    ''}

    ${lib.optionalString (producer != null) ''
      echo "${producer}" > "$svc_dir/producer-for"
    ''}
  ''
