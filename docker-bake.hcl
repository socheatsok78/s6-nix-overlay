variable "GITHUB_REPOSITORY" {
    default = "socheatsok78/s6-overnix"
}
variable "GITHUB_REPOSITORY_OWNER" {
    default = "socheatsok78"
}

variable "S6_OVERLAY_VERSION" {
    default = "dev"
}

target "docker-metadata-action" {}
target "github-metadata-action" {}

group "default" {
  targets = [
    "s6-overlay-image",
    "s6-overlay-image-layered",
  ]
}

target "s6-overlay-image" {
  context = "."
  dockerfile = "flake.nix"
  target = "s6-overlay-image"
  entitlements = [ "security.insecure" ]
  args = {
    security = "insecure"
  }
  platforms = [
    "linux/amd64",
    "linux/arm64",
  ]
  tags = [
    "${GITHUB_REPOSITORY_OWNER}/s6-overlay:${S6_OVERLAY_VERSION}",
    "ghcr.io/${GITHUB_REPOSITORY_OWNER}/s6-overlay:${S6_OVERLAY_VERSION}",
  ]
}

target "s6-overlay-image-layered" {
  context = "."
  dockerfile = "flake.nix"
  target = "s6-overlay-image-layered"
  platforms = [
    "linux/amd64",
    "linux/arm64",
  ]
  tags = [
    "${GITHUB_REPOSITORY_OWNER}/s6-overlay-layered:${S6_OVERLAY_VERSION}",
    "ghcr.io/${GITHUB_REPOSITORY_OWNER}/s6-overlay-layered:${S6_OVERLAY_VERSION}",
  ]
}
