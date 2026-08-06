.EXPORT_ALL_VARIABLES:
S6_OVERLAY_VERSION ?= $(shell cat version.nix | xargs)
print:
	docker buildx bake --print
s6-overlay-image:
	docker buildx bake s6-overlay-image --set="*.platform="
s6-overlay-image-layered:
	docker buildx bake s6-overlay-image-layered --set="*.platform="
