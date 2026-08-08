{
  pkgs,
  s6-overlay,
  s6-overlay-helpers,
}:
with pkgs.lib;
{
  buildImage =
    {
      name,
      tag,
      paths ? [ ],
      config ? { },

      services ? [ ],
    }:
    pkgs.callPackage ./s6-overlay.nix {
      inherit
        name
        tag
        paths
        config
        services
        ;

      inherit s6-overlay;
      s6-overlay-helpers = s6-overlay-helpers.override { withNsss = true; };
    };

  buildLayeredImage =
    {
      name,
      tag,
      contents ? [ ],
      config ? { },

      services ? [ ],
    }:
    pkgs.callPackage ./s6-overlay-layered.nix {
      inherit
        name
        tag
        contents
        config
        services
        ;
      inherit s6-overlay;
      s6-overlay-helpers = s6-overlay-helpers.override { withNsss = true; };
    };
}
