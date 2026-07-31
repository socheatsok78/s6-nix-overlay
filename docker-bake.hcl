group "default" {
  targets = [
    "s6-overlay-container",
    "s6-overlay-container-layered",
  ]
}

target "s6-overlay-container" {
  context = "."
  dockerfile = "flake.nix"
  target = "s6-overlay-container"
  platforms = ["linux/amd64", "linux/arm64"]
  tags = [
    "s6-overlay-container:dev"
  ]
}

target "s6-overlay-container-layered" {
  context = "."
  dockerfile = "flake.nix"
  target = "s6-overlay-container-layered"
  platforms = ["linux/amd64", "linux/arm64"]
  tags = [
    "s6-overlay-container-layered:dev"
  ]
}
