FROM --platform=$BUILDPLATFORM ghcr.io/socheatsok78/nix-sandbox:2.35.1 AS nix-sandbox

FROM --platform=$BUILDPLATFORM nix-sandbox AS s6-overlay-container
WORKDIR /tmp
RUN --mount=type=bind,target=/tmp,rw \
    mkdir -p /out \
    && nix build .#s6-overlay-container \
    && cp -r result/* /out/

FROM --platform=$BUILDPLATFORM nix-sandbox AS s6-overlay-container-layered
WORKDIR /tmp
RUN --mount=type=bind,target=/tmp,rw \
    mkdir -p /out \
    && nix build .#s6-overlay-container-layered \
    && cp -r result/* /out/
