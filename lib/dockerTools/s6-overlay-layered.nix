{
  lib,
  stdenv,
  dockerTools,
  s6-overlay,
  s6-overlay-helpers,

  name,
  tag,
  contents ? [ ],
  config ? { },

  # services is a list of longrun or oneshot services as derivations,
  # which will be linked into /etc/s6-overlay/s6-rc.d
  services ? [ ],
}:
dockerTools.buildLayeredImage {
  inherit tag;
  name = "docker-image-${name}";

  contents = [
    dockerTools.binSh
    dockerTools.usrBinEnv
    dockerTools.caCertificates
    s6-overlay
  ]
  ++ contents
  ++ services;
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
