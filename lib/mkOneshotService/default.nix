{
  lib,
  runCommand,
}:
{
  name,
  services ? [ ],
  dependencies ? [ ],
  up,
  down ? null,

  user-bundle ? "user",
}:
runCommand "${name}-s6-oneshot-svc" { } ''
  svc_name="${name}-s6-oneshot-svc"
  svc_dir="$out/etc/s6-overlay/s6-rc.d/$svc_name"
  user_bundle_dir="$out/etc/s6-overlay/user-bundles.d/${user-bundle}/contents.d"

  mkdir -p $svc_dir
  mkdir -p $user_bundle_dir

  # Add service to user bundle
  touch "$user_bundle_dir/$svc_name"

  # Create service directory and files
  echo oneshot > $svc_dir/type

  ${lib.optionalString (dependencies != [ ]) ''
    mkdir -p $svc_dir/dependencies.d
    ${lib.concatMapStrings (dep: ''
      touch $svc_dir/dependencies.d/${dep}
    '') dependencies}
  ''}

  ${lib.optionalString (up != null) ''
    cat > $svc_dir/up <<'EOF'
    ${up}
    EOF
    chmod +x $svc_dir/up
  ''}

  ${lib.optionalString (down != null) ''
    cat > $svc_dir/down <<'EOF'
    ${down}
    EOF
    chmod +x $svc_dir/down
  ''}
''
