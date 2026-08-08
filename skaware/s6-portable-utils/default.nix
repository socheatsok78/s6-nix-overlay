{
  fetchSkarnetUrl,
  s6-portable-utils,
}:
s6-portable-utils.overrideAttrs (
  final: prev: {
    version = "2.3.1.2";
    src =
      fetchSkarnetUrl prev.pname final.version
        "sha256-z7kBhtDA6yBOHlxvk3nplBPFRrzPOLtudhd/gjcao6o=";
  }
)
