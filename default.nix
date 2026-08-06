{
  pkgs ? import <nixpkgs> { },
}:
let
  s6-overlay-version = import ./version.nix;
in rec {

  bearssl = pkgs.bearssl.overrideAttrs {};
  execline = pkgs.execline.overrideAttrs {};
  s6 = pkgs.s6.overrideAttrs {};
  s6-dns = pkgs.s6-dns.overrideAttrs {};
  s6-linux-init = pkgs.s6-linux-init.overrideAttrs {};
  s6-linux-utils = pkgs.s6-linux-utils.overrideAttrs {};
  s6-networking = pkgs.s6-networking.overrideAttrs {};
  s6-portable-utils = pkgs.s6-portable-utils.overrideAttrs {};
  s6-rc = pkgs.s6-rc.overrideAttrs {};
  skalibs = pkgs.skalibs.overrideAttrs {};

  s6-overlay-helpers = pkgs.callPackage ./pkgs/s6-overlay-helpers.nix { };

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

  s6-overlay-container = pkgs.callPackage ./containers/generic.nix {
    inherit
      s6-overlay
      s6-overlay-helpers
      s6-overlay-version
      ;
  };

  s6-overlay-container-layered = pkgs.callPackage ./containers/layered.nix {
    inherit
      s6-overlay
      s6-overlay-helpers
      s6-overlay-version
      ;
  };
}
