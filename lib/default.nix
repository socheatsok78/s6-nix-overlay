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

  s6-overlay-tools = import ./s6-overlay-tools {
    inherit
      pkgs
      s6-overlay
      s6-overlay-helpers
      ;
  };
}
