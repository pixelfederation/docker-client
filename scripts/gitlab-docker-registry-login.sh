#!/bin/sh

CI_REGISTRY_USER="${CI_REGISTRY_USER:?"Provide \"CI_REGISTRY_USER\" variable with GitLab registry user name"}"
CI_REGISTRY_PASSWORD="${CI_REGISTRY_PASSWORD:?"Provide \"CI_REGISTRY_PASSWORD\" variable with GitLab registry user password"}"
CI_REGISTRY="${CI_REGISTRY:?"Provide \"CI_REGISTRY\" variable with GitLab registry url"}"

echo "$CI_REGISTRY_PASSWORD" | docker login --password-stdin --username "$CI_REGISTRY_USER" "$CI_REGISTRY"
