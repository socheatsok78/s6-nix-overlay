{
  pkgs,
  execline,
  s6-overlay,
  s6-overlay-helpers,
}:
with pkgs.lib;
{
  # Add your library functions here
  #
  # hexint = x: hexvals.${toLower x};

  command = import ./command {
    inherit pkgs;
    inherit execline s6-overlay;
  };

  fetchSkarnetUrl = import ./fetchSkarnetUrl { inherit pkgs; };

  dockerTools = import ./dockerTools {
    inherit pkgs;
    inherit
      s6-overlay
      s6-overlay-helpers
      ;
  };

  mkLongrunService = pkgs.callPackage ./mkLongrunService { };
  mkLoggingService = pkgs.callPackage ./mkLoggingService { };
  mkOneshotService = pkgs.callPackage ./mkOneshotService { };
}
