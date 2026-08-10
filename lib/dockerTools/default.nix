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
    }:
    pkgs.callPackage ./buildImage.nix {
      inherit
        name
        tag
        paths
        config
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
    }:
    pkgs.callPackage ./buildLayeredImage.nix {
      inherit
        name
        tag
        contents
        config
        ;
      inherit s6-overlay;
      s6-overlay-helpers = s6-overlay-helpers.override { withNsss = true; };
    };
}
