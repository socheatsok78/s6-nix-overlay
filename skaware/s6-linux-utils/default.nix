{
  fetchSkarnetUrl,
  s6-linux-utils,
}:
s6-linux-utils.overrideAttrs (
  final: prev: {
    version = "2.6.4.1";
    src =
      fetchSkarnetUrl prev.pname final.version
        "sha256-FuGltaK0qYZ0tKlxlhKtt5WI48IMQIM2AnjqOPLTISk=";
  }
)
