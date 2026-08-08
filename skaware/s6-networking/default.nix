{
  fetchSkarnetUrl,
  s6-networking,
}:
s6-networking.overrideAttrs (
  final: prev: {
    version = "2.8.0.1";
    src =
      fetchSkarnetUrl prev.pname final.version
        "sha256-bwEcM7oFhs5Y/u4M+FSgsIfpCC/b0kq7eGFIRjgw80E=";
  }
)
