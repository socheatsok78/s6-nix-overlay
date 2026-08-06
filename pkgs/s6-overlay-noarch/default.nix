# s6-overlay-noarch

{
  lib,
  stdenv,
  fetchFromGitHub,
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

  installPhase = ''
    runHook preInstall
    cp -r output/rootfs-overlay-noarch/. $out
    runHook postInstall
  '';

  meta = {
    license = lib.licenses.isc;
  };
}
