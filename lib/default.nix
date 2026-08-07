{
  pkgs,
  s6-overlay,
  s6-overlay-helpers,
}:
with pkgs.lib;
{
  # Add your library functions here
  #
  # hexint = x: hexvals.${toLower x};

  dockerTools = import ./dockerTools {
    inherit
      pkgs
      s6-overlay
      s6-overlay-helpers
      ;
  };
}
