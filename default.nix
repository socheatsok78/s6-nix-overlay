{
  pkgs ? import <nixpkgs> { },
}:
let
  s6-overlay-version = import ./version.nix;

  fetchSkarnetUrl =
    pname: version: sha256:
    pkgs.fetchurl {
      url = "https://skarnet.org/software/${pname}/${pname}-${version}.tar.gz";
      inherit sha256;
    };
in
rec {
  # The `lib`, `modules`, and `overlays` names are special
  lib = import ./lib {
    inherit
      pkgs
      s6-overlay
      s6-overlay-helpers
      ;
  }; # functions

  # core packages
  bearssl = pkgs.bearssl.overrideAttrs (final: prev: { });
  execline = pkgs.execline.overrideAttrs (
    final: prev: {
      version = "2.9.9.2";
      src =
        fetchSkarnetUrl prev.pname final.version
          "sha256-kI7U2zprOiOiBdj9TPKnEIkVbyrq4PVGVgRar60t7jI=";
    }
  );
  s6 = pkgs.s6.overrideAttrs (
    final: prev: {
      version = "2.15.1.0";
      src =
        fetchSkarnetUrl prev.pname final.version
          "sha256-6rnEbiK2axYTX5oF7Gig6ih9kGC4TRDe+qosqtFYq1I=";
    }
  );
  s6-dns = pkgs.s6-dns.overrideAttrs (
    final: prev: {
      version = "2.4.1.3";
      src =
        fetchSkarnetUrl prev.pname final.version
          "sha256-+enetGSMVQeoSFVINkvRxW2r2jlLye4tfxy7FqA2zXY=";
    }
  );
  s6-linux-init = pkgs.s6-linux-init.overrideAttrs (
    final: prev: {
      version = "1.2.0.2";
      src =
        fetchSkarnetUrl prev.pname final.version
          "sha256-b60BTaFiwMgZJBl8V9FuGnXBM7NKIOQjQxobdB6Qex0=";
    }
  );
  s6-linux-utils = pkgs.s6-linux-utils.overrideAttrs (
    final: prev: {
      version = "2.6.4.1";
      src =
        fetchSkarnetUrl prev.pname final.version
          "sha256-FuGltaK0qYZ0tKlxlhKtt5WI48IMQIM2AnjqOPLTISk=";
    }
  );
  s6-networking = pkgs.s6-networking.overrideAttrs (
    final: prev: {
      version = "2.8.0.1";
      src =
        fetchSkarnetUrl prev.pname final.version
          "sha256-bwEcM7oFhs5Y/u4M+FSgsIfpCC/b0kq7eGFIRjgw80E=";
    }
  );
  s6-portable-utils = pkgs.s6-portable-utils.overrideAttrs (
    final: prev: {
      version = "2.3.1.2";
      src =
        fetchSkarnetUrl prev.pname final.version
          "sha256-z7kBhtDA6yBOHlxvk3nplBPFRrzPOLtudhd/gjcao6o=";
    }
  );
  s6-rc = pkgs.s6-rc.overrideAttrs (
    final: prev: {
      version = "0.7.0.0";
      src =
        fetchSkarnetUrl prev.pname final.version
          "sha256-v1uM4NpaTucNZCuBi2HZkWp6m2SkV1lfOIET5UoYhog=";
    }
  );
  skalibs = pkgs.skalibs.overrideAttrs (
    final: prev: {
      version = "2.15.1.0";
      src =
        fetchSkarnetUrl prev.pname final.version
          "sha256-+ckF50k1xv6RHH40Tj6J1fvSAUwaBGULUksVzptWNdE=";
    }
  );

  # s6-overlay packages
  s6-overlay-helpers = pkgs.callPackage ./pkgs/s6-overlay-helpers.nix {
    inherit execline skalibs;
  };
  s6-overlay-noarch = pkgs.callPackage ./pkgs/s6-overlay-noarch.nix {
    inherit s6-overlay-version;
  };
  s6-overlay = pkgs.callPackage ./pkgs/s6-overlay.nix {
    inherit
      s6-overlay-version
      s6-overlay-noarch

      bearssl
      execline
      s6
      s6-dns
      s6-linux-init
      s6-linux-utils
      s6-networking
      s6-portable-utils
      s6-rc
      skalibs
      ;

    s6-overlay-helpers = s6-overlay-helpers.override { withNsss = true; };
  };

  # s6-overlay images
  s6-overlay-image = lib.s6-overlay-tools.buildImage {
    name = "s6-overlay-image";
    tag = s6-overlay-version;
  };
  s6-overlay-image-layered = lib.s6-overlay-tools.buildLayeredImage {
    name = "s6-overlay-image-layered";
    tag = s6-overlay-version;
  };

  # example images
  hello-image = lib.s6-overlay-tools.buildImage {
    name = "hello-image";
    tag = "dev";
    paths = [ pkgs.hello ];
    config = {
      Cmd = [
        "${pkgs.lib.getExe pkgs.hello}"
      ];
    };
  };
  hello-image-layered = lib.s6-overlay-tools.buildLayeredImage {
    name = "hello-image-layered";
    tag = "dev";
    contents = [ pkgs.hello ];
    config = {
      Cmd = [
        "${pkgs.lib.getExe pkgs.hello}"
      ];
    };
  };
}
