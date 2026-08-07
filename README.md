> [!CAUTION]
> This is an experimental project and is not intended for production use. Use at your own risk.

## About
An experimental `s6-overlay` image built on top of [Nix].

## Packages

```sh
nix flake show github:socheatsok78/s6-nix-overlay
└───packages
    ├───supported-platforms
    │   ├───bearssl: package 'bearssl-0.6'
    │   ├───execline: package 'execline-2.9.9.2'
    │   ├───s6: package 's6-2.15.1.0'
    │   ├───s6-dns: package 's6-dns-2.4.1.3'
    │   ├───s6-linux-init: package 's6-linux-init-1.2.0.2'
    │   ├───s6-linux-utils: package 's6-linux-utils-2.6.4.1'
    │   ├───s6-networking: package 's6-networking-2.8.0.1'
    │   ├───s6-overlay: package 's6-overlay-3.2.3.2'
    │   ├───s6-overlay-helpers: package 's6-overlay-helpers-0.1.2.2'
    │   ├───s6-overlay-image: package 'docker-image-s6-overlay-3.2.3.2.tar.gz'
    │   ├───s6-overlay-image-layered: package 'docker-image-s6-overlay-layered-3.2.3.2.tar.gz'
    │   ├───s6-overlay-noarch: package 's6-overlay-3.2.3.2'
    │   ├───s6-portable-utils: package 's6-portable-utils-2.3.1.2'
    │   ├───s6-rc: package 's6-rc-0.7.0.0'
    │   └───skalibs: package 'skalibs-2.15.1.0'
```

## Container Images

There are two type of container images that can be built from this overlay:
- `s6-overlay-image`: a single layer image that contains all the packages in the overlay.
- `s6-overlay-image-layered`: a layered image that contains the all the packages in the overlay, but each package is in its own layer.

## Building the image

This project uses the [buildkit-nix/nixfile-frontend] to build the container images.

First create a buildx builder with the following command:
```sh
# Due to the way Nix builds packages, we need to allow "security.insecure" entitlements.
# This ensures that Nix can access some of the system features that are required for building packages.
docker buildx create --name "nix-builder" --driver docker-container --driver-opt "network=host" --buildkitd-flags "--allow-insecure-entitlement security.insecure --allow-insecure-entitlement network.host"
```

Then build the image using the following command:
```sh
docker buildx --builder "nix-builder" bake https://github.com/socheatsok78/s6-nix-overlay.git <target>
```

Where `<target>` is either `s6-overlay-image` or `s6-overlay-image-layered`.

By default, the images will be built for both the `linux/amd64` and `linux/arm64` platforms. You can build for your local platform only by specifying the `--set="*.platform="` option.


## License
This project is licensed under the ISC License- see the [LICENSE] file for details.

[Nix]: https://nixos.org/
[buildkit-nix/nixfile-frontend]: https://github.com/socheatsok78/buildkit-nix
[LICENSE]: https://github.com/socheatsok78/s6-nix-overlay/blob/main/LICENSE
