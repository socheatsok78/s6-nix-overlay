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
  consumer-for ? null,
}:
let
  pipeline = name + "-pipeline";
  # deps, check if dependencies are derivations or strings, and get their names
  deps = lib.map (dep: if lib.isDerivation dep then dep.name else dep) dependencies;
  consumer = if lib.isDerivation consumer-for then consumer-for.name else consumer-for;
in
runCommand "${name}-s6-logging-svc"
  {
    dependencies = deps;

    # consumer
    consumer-for = consumer;
    pipeline-name = pipeline;
  }
  ''
    pipeline_name="${pipeline}"
    svc_name="${name}-s6-logging-svc"
    svc_dir="$out/etc/s6-overlay/s6-rc.d/$svc_name"
    user_bundle_dir="$out/etc/s6-overlay/user-bundles.d/${user-bundle}/contents.d"

    mkdir -p $svc_dir
    mkdir -p $user_bundle_dir

    # Add service to user bundle
    touch "$user_bundle_dir/$pipeline_name"

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

    echo "${pipeline}" > "$svc_dir/pipeline-name"

    ${lib.optionalString (consumer != null) ''
      echo "${consumer}" > "$svc_dir/consumer-for"
    ''}
  ''
