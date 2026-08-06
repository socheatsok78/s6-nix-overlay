# s6-overlay.nix

{
  lib,
  symlinkJoin,

  s6-overlay-version,
  s6-overlay-noarch,
  s6-overlay-helpers,

  bearssl,
  execline,
  s6-dns,
  s6-linux-init,
  s6-linux-utils,
  s6-networking,
  s6-portable-utils,
  s6-rc,
  s6,
  skalibs,
}:
symlinkJoin {
  pname = "s6-overlay";
  version = s6-overlay-version;

  paths = [
    s6-overlay-noarch
    s6-overlay-helpers

    bearssl
    execline
    s6
    s6-dns
    s6-linux-init
    s6-linux-utils
    s6-networking
    s6-portable-utils
    s6-rc
    skalibs
  ];

  meta = {
    description = "s6 overlay for containers (includes execline, s6-linux-utils & a custom init)";
    homepage = "https://github.com/just-containers/s6-overlay/";
    platforms = lib.platforms.linux;
    maintainers = [ ];
    license = lib.licenses.isc;
  };
}
