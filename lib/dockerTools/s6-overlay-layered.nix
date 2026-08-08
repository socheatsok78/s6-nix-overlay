{
  stdenv,
  dockerTools,
  s6-overlay,
  s6-overlay-helpers,

  name,
  tag,
  contents ? [ ],
  config ? { },
}:
dockerTools.buildLayeredImage {
  inherit tag;
  name = "docker-image-${name}";

  contents = [
    s6-overlay
  ] ++ contents;
  config = {
    Entrypoint = [ "/init" ];
  }
  // config;

  extraCommands = ''
    rm -rf var run
    mkdir -p var run
    ln -s /run var/run
  '';

  # sutuid bit for s6-overlay-suexec
  enableFakechroot = stdenv.isLinux;
  fakeRootCommands = ''
    mkdir -p ./command
    cp ${s6-overlay-helpers}/bin/s6-overlay-suexec ./command/s6-overlay-suexec
    chmod 4755 ./command/s6-overlay-suexec
    chown 0:0 ./command/s6-overlay-suexec
  '';
}
