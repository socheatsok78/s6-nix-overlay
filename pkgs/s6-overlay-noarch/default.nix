# s6-overlay-noarch

{
  lib,
  stdenv,
  fetchFromGitHub,
  execline,
  s6-overlay-version,
}:
stdenv.mkDerivation rec {
  pname = "s6-overlay";
  version = s6-overlay-version;

  src = fetchFromGitHub {
    owner = "just-containers";
    repo = "s6-overlay";
    rev = "v${version}";
    hash = "sha256-wAiPj/WINo/vHkrrBKYzknqfy9TokscjUNO/2559E1c=";
  };

  buildPhase = ''
    runHook preBuild
    make rootfs-overlay-noarch
    runHook postBuild
  '';

  postBuild = ''
    substituteInPlace output/rootfs-overlay-noarch/command/* \
      --replace "#!/command/execlineb" "#!${lib.getExe execline}"
  '';

  installPhase = ''
    runHook preInstall
    cp -r output/rootfs-overlay-noarch/. $out
    runHook postInstall
  '';

  meta = {
    description = "s6 overlay for containers (includes execline, s6-linux-utils & a custom init)";
    homepage = "https://github.com/just-containers/s6-overlay/";
    platforms = lib.platforms.linux;
    maintainers = [ ];
    license = lib.licenses.isc;
  };
}
