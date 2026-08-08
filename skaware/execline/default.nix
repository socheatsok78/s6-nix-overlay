{
  fetchSkarnetUrl,
  execline,
}:
execline.overrideAttrs (
  final: prev: {
    version = "2.9.9.2";
    src =
      fetchSkarnetUrl prev.pname final.version
        "sha256-kI7U2zprOiOiBdj9TPKnEIkVbyrq4PVGVgRar60t7jI=";

    meta.mainProgram = "execlineb";
  }
)
