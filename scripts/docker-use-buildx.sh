#!/bin/sh

docker buildx version
docker buildx install

DOCKER_BUILDX_CONTEXT_FROM="${DOCKER_BUILDX_CONTEXT_FROM:-default}"
DOCKER_BUILDX_CONTEXT="${DOCKER_BUILDX_CONTEXT:-buildx}"
DOCKER_BUILDX_BUILDER="${DOCKER_BUILDX_BUILDER:-builder0}"
DOCKER_BUILDX_CONTEXT_CREATE="${DOCKER_BUILDX_BUILDER_CREATE:-0}"
DOCKER_BUILDX_BUILDER_CREATE="${DOCKER_BUILDX_BUILDER_CREATE:-0}"

if [ "$DOCKER_BUILDX_CONTEXT_CREATE" = "1" ]; then
    docker context create "$DOCKER_BUILDX_CONTEXT" --from "$DOCKER_BUILDX_CONTEXT_FROM" || true

    if [ "$DOCKER_BUILDX_BUILDER_CREATE" = "1" ]; then
        docker buildx create "$DOCKER_BUILDX_CONTEXT" --name "$DOCKER_BUILDX_BUILDER" --use || true
    fi
else
    if [ "$DOCKER_BUILDX_BUILDER_CREATE" = "1" ]; then
        docker buildx create --name "$DOCKER_BUILDX_BUILDER" --use || true
    fi
fi
