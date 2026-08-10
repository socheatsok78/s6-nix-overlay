{
  pkgs,
  execline,
  s6-overlay,
  s6-overlay-helpers,
}:
rec {
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

  mkLogConsumer = pkgs.callPackage ./mkLogConsumer { };
  mkLongrunService = pkgs.callPackage ./mkLongrunService { };
  mkOneshotService = pkgs.callPackage ./mkOneshotService { };

  # mkService is an alias for mkLongrunService
  mkService = mkLongrunService;
}
