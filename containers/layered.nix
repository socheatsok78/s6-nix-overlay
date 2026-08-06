# An example of how to use the s6-overlay package
{
  stdenv,
  dockerTools,
  buildEnv,
  s6-overlay,
  s6-overlay-helpers,
  s6-overlay-version,
}:
dockerTools.buildLayeredImage {
  name = "docker-image-s6-overlay-layered";
  tag = s6-overlay-version;

  contents = [ s6-overlay ];
  config = {
    Entrypoint = [ "/init" ];
  };

  # sutuid bit for s6-overlay-suexec
  enableFakechroot = stdenv.isLinux;
  fakeRootCommands = ''
    mkdir -p ./command
    cp ${s6-overlay-helpers}/bin/s6-overlay-suexec ./command/s6-overlay-suexec
    chmod 4755 ./command/s6-overlay-suexec
    chown 0:0 ./command/s6-overlay-suexec

    # gets rid of a pesky warning
    rm -rf /var /run
    mkdir -p /var/run
    ln -s /run /var/run
  '';
}
