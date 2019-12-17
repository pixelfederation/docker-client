#!/bin/sh

DOCKER_CONFIG_FILE="${DOCKER_CONFIG:-"$HOME/.docker"}/config.json"
if [ ! -f "$DOCKER_CONFIG_FILE" ]; then
    echo '{}' > "$DOCKER_CONFIG_FILE"
fi

AWS_ACCOUNT_ID="${AWS_ACCOUNT_ID:?"Provide \"AWS_ACCOUNT_ID\" variable with value of AWS ECR Account ID"}"
AWS_DEFAULT_REGION="${AWS_DEFAULT_REGION:?"Provide \"AWS_DEFAULT_REGION\" variable with with value of AWS ECR Region"}"

JSON_TEMPLATE="{ \"credHelpers\": { \"$AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com\": \"ecr-login\" } }"
DOCKER_CONFIG="$(cat "$DOCKER_CONFIG_FILE")"
echo "$JSON_TEMPLATE" | jq -s ".[0] * $DOCKER_CONFIG" > "$DOCKER_CONFIG_FILE"
