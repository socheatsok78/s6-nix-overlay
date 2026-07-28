{
  pkgs ? import <nixpkgs> { },
}:
rec {
  s6-overlay-version = import ./version.nix;

  s6-overlay-helpers = pkgs.callPackage ./pkgs/s6-overlay-helpers.nix { };

  s6-overlay-noarch = pkgs.callPackage ./pkgs/s6-overlay-noarch.nix {
    inherit s6-overlay-version;
  };

  s6-overlay = pkgs.callPackage ./pkgs/s6-overlay.nix {
    inherit
      s6-overlay-version
      s6-overlay-noarch
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
}
