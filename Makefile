.EXPORT_ALL_VARIABLES:
S6_OVERLAY_VERSION ?= $(shell cat version.nix | xargs)
print:
	docker buildx bake --print
s6-overlay:
	docker buildx bake s6-overlay --set="*.platform="
s6-overlay-layered:
	docker buildx bake s6-overlay-layered --set="*.platform="
