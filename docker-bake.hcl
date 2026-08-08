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

target "entitlements" {
  entitlements = [ "security.insecure" ]
  args = {
    security = "insecure"
  }
}

target "s6-overlay-image" {
  inherits = [
    "entitlements",
    "docker-metadata-action",
    "github-metadata-action",
  ]
  context = "."
  dockerfile = "flake.nix"
  target = "s6-overlay-image"
  platforms = [
    "linux/amd64",
    "linux/arm64",
  ]
  tags = [
    "${GITHUB_REPOSITORY_OWNER}/s6-nix-overlay:${S6_OVERLAY_VERSION}",
    "ghcr.io/${GITHUB_REPOSITORY_OWNER}/s6-nix-overlay:${S6_OVERLAY_VERSION}",
  ]
}

target "s6-overlay-image-layered" {
  inherits = [
    "entitlements",
    "docker-metadata-action",
    "github-metadata-action",
  ]
  context = "."
  dockerfile = "flake.nix"
  target = "s6-overlay-image-layered"
  platforms = [
    "linux/amd64",
    "linux/arm64",
  ]
  tags = [
    "${GITHUB_REPOSITORY_OWNER}/s6-nix-overlay:${S6_OVERLAY_VERSION}-layered",
    "ghcr.io/${GITHUB_REPOSITORY_OWNER}/s6-nix-overlay:${S6_OVERLAY_VERSION}-layered",
  ]
}


// example of how to use s6-overlay-layered in a docker image
target "hello-image" {
  inherits = [
    "entitlements",
    "docker-metadata-action",
    "github-metadata-action",
  ]
  dockerfile = "flake.nix"
  target = "hello-image"
  tags = [
    "hello-image:dev"
  ]
}

target "hello-image-layered" {
  inherits = [
    "entitlements",
    "docker-metadata-action",
    "github-metadata-action",
  ]
  dockerfile = "flake.nix"
  target = "hello-image-layered"
  tags = [
    "hello-image-layered:dev"
  ]
}
