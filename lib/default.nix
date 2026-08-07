{ pkgs }:

with pkgs.lib;
{
  # Add your library functions here
  #
  # hexint = x: hexvals.${toLower x};

  s6-overlay-tools = import ./s6-overlay-tools.nix { inherit pkgs; };
}
