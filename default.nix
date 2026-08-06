{
  pkgs ? import <nixpkgs> { },
}:
rec {
  s6-overlay-version = import ./version.nix;

  # execline
  execline = pkgs.callPackage ./pkgs/execline { };

  # libs
  skalibs = pkgs.callPackage ./pkgs/skalibs { };
  skalibs_2_10 = pkgs.callPackage ./pkgs/skalibs/2_10.nix { };
  sdnotify-wrapper = pkgs.callPackage ./pkgs/sdnotify-wrapper { };

  # s6 tooling
  s6 = pkgs.callPackage ./pkgs/s6 { };
  s6-dns = pkgs.callPackage ./pkgs/s6-dns { };
  s6-linux-init = pkgs.callPackage ./pkgs/s6-linux-init { };
  s6-linux-utils = pkgs.callPackage ./pkgs/s6-linux-utils { };
  s6-networking = pkgs.callPackage ./pkgs/s6-networking { };
  s6-portable-utils = pkgs.callPackage ./pkgs/s6-portable-utils { };
  s6-rc = pkgs.callPackage ./pkgs/s6-rc { };

  s6-overlay-helpers = pkgs.callPackage ./pkgs/s6-overlay-helpers { };

  s6-overlay-noarch = pkgs.callPackage ./pkgs/s6-overlay-noarch {
    inherit s6-overlay-version;
  };

  s6-overlay = pkgs.callPackage ./pkgs/s6-overlay {
    inherit
      s6-overlay-version
      s6-overlay-noarch
      s6
      s6-rc
      s6-linux-init
      s6-portable-utils
      execline
      ;

    s6-overlay-helpers = s6-overlay-helpers.override { withNsss = true; };
  };

  s6-overlay-container = pkgs.callPackage ./containers/generic.nix {
    inherit
      s6-overlay-version
      s6-overlay
      s6-overlay-helpers
      ;
  };

  s6-overlay-container-layered = pkgs.callPackage ./containers/layered.nix {
    inherit
      s6-overlay-version
      s6-overlay-helpers
      s6-overlay
      ;
  };

  # Set the default package to s6-overlay-container-layered
  default = s6-overlay-container-layered;
}
