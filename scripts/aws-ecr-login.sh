#!/bin/sh

AWS_ACCOUNT_ID="${AWS_ACCOUNT_ID:?"Provide \"AWS_ACCOUNT_ID\" variable with value of AWS ECR Account ID"}"
AWS_DEFAULT_REGION="${AWS_DEFAULT_REGION:?"Provide \"AWS_DEFAULT_REGION\" variable with with value of AWS ECR Region"}"

JSON_TEMPLATE="{ \"credHelpers\": { \"$AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com\": \"ecr-login\" } }"
DOCKER_CONFIG="$(cat ~/.docker/config.json)"
echo "$JSON_TEMPLATE" | jq -s ".[0] * $DOCKER_CONFIG" > ~/.docker/config.json
