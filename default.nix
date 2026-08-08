{
  pkgs ? import <nixpkgs> { },
}:
let
  s6-overlay-version = import ./version.nix;
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

  # The `dockerTools` name is special
  dockerTools = lib.dockerTools;

  # core packages
  bearssl = pkgs.bearssl.overrideAttrs (final: prev: { });
  execline = pkgs.callPackage ./skaware/execline {
    fetchSkarnetUrl = lib.fetchSkarnetUrl;
  };
  s6 = pkgs.callPackage ./skaware/s6 {
    fetchSkarnetUrl = lib.fetchSkarnetUrl;
  };
  s6-dns = pkgs.callPackage ./skaware/s6-dns {
    fetchSkarnetUrl = lib.fetchSkarnetUrl;
  };
  s6-linux-init = pkgs.callPackage ./skaware/s6-linux-init {
    fetchSkarnetUrl = lib.fetchSkarnetUrl;
  };
  s6-linux-utils = pkgs.callPackage ./skaware/s6-linux-utils {
    fetchSkarnetUrl = lib.fetchSkarnetUrl;
  };
  s6-networking = pkgs.callPackage ./skaware/s6-networking {
    fetchSkarnetUrl = lib.fetchSkarnetUrl;
  };
  s6-portable-utils = pkgs.callPackage ./skaware/s6-portable-utils {
    fetchSkarnetUrl = lib.fetchSkarnetUrl;
  };
  s6-rc = pkgs.callPackage ./skaware/s6-rc {
    fetchSkarnetUrl = lib.fetchSkarnetUrl;
  };
  skalibs = pkgs.callPackage ./skaware/skalibs {
    fetchSkarnetUrl = lib.fetchSkarnetUrl;
  };

  # s6-overlay packages
  s6-overlay-helpers = pkgs.callPackage ./pkgs/s6-overlay-helpers {
    inherit execline skalibs;
  };
  s6-overlay-noarch = pkgs.callPackage ./pkgs/s6-overlay-noarch {
    inherit s6-overlay-version;
  };
  s6-overlay = pkgs.callPackage ./pkgs/s6-overlay {
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
  s6-overlay-image = dockerTools.buildImage {
    name = "s6-overlay-image";
    tag = s6-overlay-version;
  };
  s6-overlay-image-layered = dockerTools.buildLayeredImage {
    name = "s6-overlay-image-layered";
    tag = s6-overlay-version;
  };

  # example images
  hello-image = pkgs.callPackage ./examples/hello-image {
    inherit execline dockerTools;
    mkLongrunService = lib.mkLongrunService;
    mkOneshotService = lib.mkOneshotService;
  };
  hello-image-layered = pkgs.callPackage ./examples/hello-image-layered {
    inherit execline dockerTools;
    mkLongrunService = lib.mkLongrunService;
    mkOneshotService = lib.mkOneshotService;
  };
}
