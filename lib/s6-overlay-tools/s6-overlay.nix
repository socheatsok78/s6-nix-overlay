{
  dockerTools,
  buildEnv,
  s6-overlay,
  s6-overlay-helpers,

  name,
  tag,
  paths ? [ ],
  config ? { },
}:
dockerTools.buildImage {
  inherit name tag;

  copyToRoot = buildEnv {
    name = "s6-overlay-env";
    paths = [
      s6-overlay
    ]
    ++ paths;
    pathsToLink = [
      "/bin"
      "/sbin"
      "/command"
      "/etc"
      "/lib"
      "/libexec"
      "/package"
      "/"
    ];
  };
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
  runAsRoot = ''
    mkdir -p ./command
    cp ${s6-overlay-helpers}/bin/s6-overlay-suexec ./command/s6-overlay-suexec
    chmod 4755 ./command/s6-overlay-suexec
    chown 0:0 ./command/s6-overlay-suexec
  '';
}
