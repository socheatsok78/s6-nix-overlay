> [!CAUTION]
> This is an experimental project and is not intended for production use. Use at your own risk.

## About
An experimental [s6-overlay] tooling for [Nix] that provides a wrapper to the `nixpkgs.dockerTools` to build `s6-overlay` images.

## Usage

The `s6-nix-overlay` offer a wrapper to the `nixpkgs.dockerTools` to build `s6-overlay` images. You can use it in your own flake like this:

```nix
{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    # add s6-nix-overlay as an input
    s6-nix-overlay = {
      url = "github:socheatsok78/s6-nix-overlay";

      # it is not recommended to follow nixpkgs, since it can lead to unexpected breakages,
      # but if you want to follow nixpkgs, you can uncomment the following line
      # inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      s6-nix-overlay,
    }:
    let
      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system; };

          # import s6-nix-overlay and use its pinned version of nixpkgs
          s6-overlay = import s6-nix-overlay {
            # instead of using nixpkgs from your flake,
            # we use the one from s6-nix-overlay, which is pinned to a specific version of nixpkgs
            pkgs = import s6-nix-overlay.nixpkgs { inherit system; };
          };
        in
        rec {
          # define a service
          hello-service = s6-overlay.lib.mkLongrunService {
              name = "hello-service";
              run = ''
                  #!/bin/sh
                  ${pkgs.getExe pkgs.hello}
              '';
          };

          # define a layered image that includes the service and the hello package
          hello = s6-overlay.dockerTools.buildLayeredImage {
            name = "hello-image";
            tag = "dev";
            contents = [
              # to use the /bin/sh shell, which is not provide by default in the s6-overlay image,
              # we need to include it explicitly or provide your own. e.g: pkgs.busybox, pkgs.bash, pkgs.zsh, etc.
              # pkgs.busybox
              pkgs.dockerTools.binSh

              pkgs.hello
              hello-service
            ];
          };
        }
      );
    };
}
```

Currently the following function are available:
- `s6-overlay.dockerTools.buildImage`: builds a single layer image with all the packages in the overlay.
- `s6-overlay.dockerTools.buildLayeredImage`: builds a layered image with each package in its own layer.

> [!NOTE]
> Please refer to [nixpkgs manual for `pkgs.dockerTools`](https://nixos.org/manual/nixpkgs/stable/#sec-pkgs-dockerTools) for more details.

### Define a service

There are two types of service, a `longrun` and `oneshot` service. Services are just derivations.

Use the following function to define a service:

```nix
# longrun
s6-overlay.lib.mkLongrunService {
    name = "hello-service";
    run = ''
        #!/bin/sh
        echo "Hello, World!"
    '';
};

# oneshot
s6-overlay.lib.mkOneshotService {
    name = "hello-service";
    up = "<path-to-up-script>";
};
```

See [`s6-overlay.lib.mkLongrunService`](lib/mkLongrunService/default.nix) & [`s6-overlay.lib.mkOneshotService`](lib/mkOneshotService/default.nix) for more details.

## s6-overlay packages

The release are pinned to the version specified in the [s6-overlay] releases. The following packages are available in the overlay:

```sh
nix flake show github:socheatsok78/s6-nix-overlay
└───packages
    └───supported-platforms
    │   ├───bearssl: package 'bearssl-0.6'
    │   ├───execline: package 'execline-2.9.9.2'
    │   ├───s6: package 's6-2.15.1.0'
    │   ├───s6-dns: package 's6-dns-2.4.1.3'
    │   ├───s6-linux-init: package 's6-linux-init-1.2.0.2'
    │   ├───s6-linux-utils: package 's6-linux-utils-2.6.4.1'
    │   ├───s6-networking: package 's6-networking-2.8.0.1'
    │   ├───s6-overlay: package 's6-overlay-3.2.3.2'
    │   ├───s6-overlay-helpers: package 's6-overlay-helpers-0.1.2.2'
    │   ├───s6-overlay-image: package 'docker-image-s6-overlay-image.tar.gz'
    │   ├───s6-overlay-image-layered: package 'docker-image-s6-overlay-image-layered.tar.gz'
    │   ├───s6-overlay-noarch: package 's6-overlay-3.2.3.2'
    │   ├───s6-portable-utils: package 's6-portable-utils-2.3.1.2'
    │   ├───s6-rc: package 's6-rc-0.7.0.0'
    │   └───skalibs: package 'skalibs-2.15.1.0'
```

The `s6-overlay-image` and `s6-overlay-image-layered` packages are just examples, use the `s6-overlay.dockerTools.buildImage` and `s6-overlay.dockerTools.buildLayeredImage` functions to build your own images.

## Sample Container Images

There are two type of sample container images that can be built from this overlay:
- `s6-overlay-image`: a single layer image that contains all the packages in the overlay.
- `s6-overlay-image-layered`: a layered image that contains the all the packages in the overlay, but each package is in its own layer.

> This project uses the [buildkit-nix/nixfile-frontend] to build the container images.

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

[s6-overlay]: https://github.com/just-containers/s6-overlay
[Nix]: https://nixos.org/
[buildkit-nix/nixfile-frontend]: https://github.com/socheatsok78/buildkit-nix
[LICENSE]: https://github.com/socheatsok78/s6-nix-overlay/blob/main/LICENSE
