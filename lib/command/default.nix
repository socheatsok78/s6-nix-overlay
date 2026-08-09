{
  pkgs,
  execline,
  s6-overlay,
}:
{
  # execlineb
  execline = "${pkgs.lib.getExe execline}";

  # s6-overlay
  logutil-newfifo = "${s6-overlay}/command/logutil-newfifo";
  logutil-service = "${s6-overlay}/command/logutil-service";
  printcontenv = "${s6-overlay}/command/printcontenv";
  with-contenv = "${s6-overlay}/command/with-contenv";
  with-retries = "${s6-overlay}/command/with-retries";
}
