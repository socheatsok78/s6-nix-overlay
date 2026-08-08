{
  fetchSkarnetUrl,
  s6-dns,
}:
s6-dns.overrideAttrs (
  final: prev: {
    version = "2.4.1.3";
    src =
      fetchSkarnetUrl prev.pname final.version
        "sha256-+enetGSMVQeoSFVINkvRxW2r2jlLye4tfxy7FqA2zXY=";
  }
)
