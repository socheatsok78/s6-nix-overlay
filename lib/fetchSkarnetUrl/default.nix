{ pkgs }:
pname: version: sha256:
pkgs.fetchurl {
  url = "https://skarnet.org/software/${pname}/${pname}-${version}.tar.gz";
  inherit sha256;
}
