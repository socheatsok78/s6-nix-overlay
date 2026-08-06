{
  pkgs ? import <nixpkgs> { },
}:
rec {
  s6-overlay-version = import ./version.nix;

  execline = pkgs.execline.override {};
  s6 = pkgs.s6.override {};
  s6-rc = pkgs.s6-rc.override {};
  s6-linux-init = pkgs.s6-linux-init.override {};
  s6-portable-utils = pkgs.s6-portable-utils.override {};

  s6-overlay-helpers = pkgs.callPackage ./pkgs/s6-overlay-helpers.nix { };

  s6-overlay-noarch = pkgs.callPackage ./pkgs/s6-overlay-noarch.nix {
    inherit s6-overlay-version;
  };

  s6-overlay = pkgs.callPackage ./pkgs/s6-overlay.nix {
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
      s6-overlay
      s6-overlay-helpers
      ;
  };

  # Set the default package to s6-overlay-container-layered
  default = s6-overlay-container-layered;
}
