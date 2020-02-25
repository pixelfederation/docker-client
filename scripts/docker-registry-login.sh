#!/bin/sh

DOCKER_USERNAME="${DOCKER_USERNAME:?"Provide \"DOCKER_USERNAME\" variable with Docker registry user name"}"
DOCKER_PASSWORD="${DOCKER_PASSWORD:?"Provide \"DOCKER_PASSWORD\" variable with Docker registry user password"}"
DOCKER_REGISTRY="${DOCKER_REGISTRY:?"Provide \"DOCKER_REGISTRY\" variable with Docker registry URL"}"

echo "$DOCKER_PASSWORD" | docker login --password-stdin --username "$DOCKER_USERNAME" "$DOCKER_REGISTRY"
