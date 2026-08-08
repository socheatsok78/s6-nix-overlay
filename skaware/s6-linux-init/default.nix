{
  fetchSkarnetUrl,
  s6-linux-init,
}:
s6-linux-init.overrideAttrs (
  final: prev: {
    version = "1.2.0.2";
    src =
      fetchSkarnetUrl prev.pname final.version
        "sha256-b60BTaFiwMgZJBl8V9FuGnXBM7NKIOQjQxobdB6Qex0=";
  }
)
