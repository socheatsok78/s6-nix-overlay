{
  fetchSkarnetUrl,
  s6,
}:
s6.overrideAttrs (
  final: prev: {
    version = "2.15.1.0";
    src =
      fetchSkarnetUrl prev.pname final.version
        "sha256-6rnEbiK2axYTX5oF7Gig6ih9kGC4TRDe+qosqtFYq1I=";
  }
)
