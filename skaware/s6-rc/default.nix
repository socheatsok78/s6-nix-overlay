{
  fetchSkarnetUrl,
  s6-rc,
}:
s6-rc.overrideAttrs (
  final: prev: {
    version = "0.7.0.0";
    src =
      fetchSkarnetUrl prev.pname final.version
        "sha256-v1uM4NpaTucNZCuBi2HZkWp6m2SkV1lfOIET5UoYhog=";
  }
)
