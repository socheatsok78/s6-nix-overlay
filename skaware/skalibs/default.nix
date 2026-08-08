{
  fetchSkarnetUrl,
  skalibs,
}:
skalibs.overrideAttrs (
  final: prev: {
    version = "2.15.1.0";
    src =
      fetchSkarnetUrl prev.pname final.version
        "sha256-+ckF50k1xv6RHH40Tj6J1fvSAUwaBGULUksVzptWNdE=";
  }
)
