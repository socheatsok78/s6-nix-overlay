let
  isReserved = n: n == "lib" || n == "overlays" || n == "modules";
  nameValuePair = n: v: {
    name = n;
    value = v;
  };
in
{
  default =
    final: prev:
    let
      nurAttrs = import ../packages.nix { pkgs = prev; };
    in
    builtins.listToAttrs (
      map (n: nameValuePair n nurAttrs.${n}) (
        builtins.filter (n: !isReserved n) (builtins.attrNames nurAttrs)
      )
    );
}
