{
  localSystem ? builtins.currentSystem,
  system ? localSystem,
}:
let
  flake = builtins.getFlake (builtins.toString ./.);
in
flake.packages.${system}
