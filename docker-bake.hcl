variable "GITHUB_REPOSITORY" {
    default = "socheatsok78/s6-overnix"
}
variable "GITHUB_REPOSITORY_OWNER" {
    default = "socheatsok78"
}

variable "S6_OVERLAY_VERSION" {
    validation {
      condition = S6_OVERLAY_VERSION != ""
      error_message = "S6_OVERLAY_VERSION must be set"
    }
}

target "docker-metadata-action" {}
target "github-metadata-action" {}

group "default" {
  targets = [
    "s6-overlay",
    "s6-overlay-layered",
  ]
}

target "s6-overlay" {
  context = "."
  dockerfile = "flake.nix"
  target = "s6-overlay-image"
  platforms = [
    "linux/amd64",
    "linux/arm64",
  ]
  tags = [
    "${GITHUB_REPOSITORY_OWNER}/s6-overlay:${S6_OVERLAY_VERSION}",
    "ghcr.io/${GITHUB_REPOSITORY_OWNER}/s6-overlay:${S6_OVERLAY_VERSION}",
  ]
}

target "s6-overlay-layered" {
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
