#!/bin/sh

IMAGE_NOW="local-build:$(date +%s)"
docker build . -t "$IMAGE_NOW"
docker stop nginx || true
docker rm nginx || true
docker run -d -p 8080:80 --name nginx "$IMAGE_NOW"
wget dind:8080 -qO /dev/stdout
