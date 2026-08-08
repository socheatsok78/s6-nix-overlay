{
  lib,
  dockerTools,
  mkLongrunService,
  mkOneshotService,
  execline,
  hello,
}:
let
  hello-longrun-service = mkLongrunService {
    name = "hello";
    run = ''
      #!${lib.getExe execline} -P
      ${lib.getExe hello}
    '';
  };
  hello-oneshot-service = mkOneshotService {
    name = "hello";
    up = ''
      #!${lib.getExe execline} -P
      ${lib.getExe hello}
    '';
  };
in
dockerTools.buildImage {
  name = "hello-image";
  tag = "dev";
  paths = [
    hello
    hello-longrun-service
    hello-oneshot-service
  ];
  config = {
    Cmd = [
      "${lib.getExe hello}"
    ];
  };
}
