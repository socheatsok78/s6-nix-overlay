{
  lib,
  runCommand,
}:
{
  name,
  services ? [ ],
  dependencies ? [ ],
  run,
  finish ? null,

  user-bundle ? "user",
}:
runCommand "${name}-s6-longrun-svc" { } ''
  svc_name="${name}-s6-longrun-svc"
  svc_dir="$out/etc/s6-overlay/s6-rc.d/$svc_name"
  user_bundle_dir="$out/etc/s6-overlay/user-bundles.d/${user-bundle}/contents.d"

  mkdir -p $svc_dir
  mkdir -p $user_bundle_dir

  # Add service to user bundle
  touch "$user_bundle_dir/$svc_name"

  # Create service directory and files
  echo longrun > $svc_dir/type

  ${lib.optionalString (dependencies != [ ]) ''
    mkdir -p $svc_dir/dependencies.d
    ${lib.concatMapStrings (dep: ''
      touch $svc_dir/dependencies.d/${dep}
    '') dependencies}
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
''
