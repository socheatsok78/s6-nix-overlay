buildxflags := --allow=security.insecure --set="*.platform=" --load
.EXPORT_ALL_VARIABLES:
S6_OVERLAY_VERSION ?= $(shell cat version.nix | xargs)
print:
	docker buildx bake --print
s6-overlay-image:
	docker buildx bake $(@) --print
	docker buildx bake $(@) $(buildxflags)
s6-overlay-image-layered:
	docker buildx bake $(@) --print
	docker buildx bake $(@) $(buildxflags)
update:
	nix flake update --commit-lock-file
