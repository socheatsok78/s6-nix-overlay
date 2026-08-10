# syntax=socheatsok78/nixfile-frontend:experimental
{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    # add s6-nix-overlay as an input
    s6-nix-overlay = {
      url = "path:../."; # <-development
      # url = "github:socheatsok78/s6-nix-overlay";

      # it is not recommended to follow nixpkgs, since it can lead to unexpected breakages,
      # but if you want to follow nixpkgs, you can uncomment the following line
      # inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      s6-nix-overlay,
    }:
    let
      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system; };

          # import s6-nix-overlay and use its pinned version of nixpkgs
          s6-overlay = import s6-nix-overlay {
            # instead of using nixpkgs from your flake,
            # we use the one from s6-nix-overlay, which is pinned to a specific version of nixpkgs
            pkgs = import s6-nix-overlay.nixpkgs { inherit system; };
          };
        in
        rec {
          myapp = pkgs.hello;

          # define a service
          myapp-service = s6-overlay.lib.mkLongrunService {
            name = "myapp-service";
            producer-for = myapp-log;
            dependencies = [
              "base"
              myapp-log-prepare
            ];
            run = ''
              #!/bin/sh
              ${pkgs.lib.getExe myapp}
            '';
          };

          # logging
          myapp-log-prepare = s6-overlay.lib.mkOneshotService {
            name = "myapp-log-prepare";
            dependencies = [ "base" ];
            up = ''
              if { mkdir -p /var/log/myapp }
              if { chown nobody:nogroup /var/log/myapp }
              chmod 02755 /var/log/myapp
            '';
          };
          myapp-log = s6-overlay.lib.mkLoggingService {
            name = "myapp-log";
            consumer-for = myapp-service;
            run = ''
              #!/bin/sh
              exec logutil-service /var/log/myapp
            '';
          };

          # define a layered image that includes the service and the hello package
          hello = s6-overlay.dockerTools.buildLayeredImage {
            name = "hello-image";
            tag = "dev";
            contents = [
              # to use the /bin/sh shell, which is not provide by default in the s6-overlay image,
              # we need to include it explicitly or provide your own. e.g: pkgs.busybox, pkgs.bash, pkgs.zsh, etc.
              # pkgs.busybox
              pkgs.dockerTools.binSh

              pkgs.hello
              myapp-service
              myapp-log-prepare
              myapp-log
            ];
          };
        }
      );
    };
}
