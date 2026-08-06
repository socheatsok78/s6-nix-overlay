{
  stdenv,
  dockerTools,
  buildEnv,
  s6-overlay,
  s6-overlay-helpers,
  s6-overlay-version,
}:
dockerTools.buildLayeredImage {
  name = "docker-image-s6-overlay-layered-${s6-overlay-version}";
  tag = s6-overlay-version;

  contents = [ s6-overlay ];
  config = {
    Entrypoint = [ "/init" ];
  };

  extraCommands = ''
    rm -rf var run
    mkdir -p var run
    ln -s /run var/run
  '';

  # sutuid bit for s6-overlay-suexec
  enableFakechroot = false;
  fakeRootCommands = ''
    mkdir -p ./command
    cp ${s6-overlay-helpers}/bin/s6-overlay-suexec ./command/s6-overlay-suexec
    chmod 4755 ./command/s6-overlay-suexec
    chown 0:0 ./command/s6-overlay-suexec
  '';
}
