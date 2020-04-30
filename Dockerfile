ARG DOCKER_VERSION="19.03.8"
FROM docker:${DOCKER_VERSION} as client

RUN apk add --update jq bash curl git openssh-client && \
    apk add --update --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community pass && \
    apk upgrade && \
    rm -rf /var/cache/apk/*

ARG DOCKER_BUILDX_VERSION="0.4.0"
ARG DOCKER_AWS_ECR_CREDENTIAL_HELPER_VERSION="0.4.0"
ARG DOCKER_PASS_CREDENTIAL_HELPER_VERSION="0.6.3"

# install docker buildx
RUN wget "https://github.com/docker/buildx/releases/download/v${DOCKER_BUILDX_VERSION}/buildx-v${DOCKER_BUILDX_VERSION}.linux-amd64" && \
    mkdir -p ~/.docker/cli-plugins && \
    mv "buildx-v${DOCKER_BUILDX_VERSION}.linux-amd64" ~/.docker/cli-plugins/docker-buildx && \
    chmod a+x ~/.docker/cli-plugins/docker-buildx && \
    # install AWS ECR credential helper
    wget "https://amazon-ecr-credential-helper-releases.s3.us-east-2.amazonaws.com/${DOCKER_AWS_ECR_CREDENTIAL_HELPER_VERSION}/linux-amd64/docker-credential-ecr-login" && \
    mv docker-credential-ecr-login /usr/bin/docker-credential-ecr-login && \
    chmod a+x /usr/bin/docker-credential-ecr-login && \
    # install docker pass credential helper
    wget "https://github.com/docker/docker-credential-helpers/releases/download/v${DOCKER_PASS_CREDENTIAL_HELPER_VERSION}/docker-credential-pass-v${DOCKER_PASS_CREDENTIAL_HELPER_VERSION}-amd64.tar.gz" && \
    tar -xvf "docker-credential-pass-v${DOCKER_PASS_CREDENTIAL_HELPER_VERSION}-amd64.tar.gz" && \
    mv docker-credential-pass /usr/bin/docker-credential-pass && \
    chmod a+x /usr/bin/docker-credential-pass && \
    rm "docker-credential-pass-v${DOCKER_PASS_CREDENTIAL_HELPER_VERSION}-amd64.tar.gz"

COPY scripts/gitlab-docker-registry-login.sh /usr/bin/gitlab-docker-registry-login
COPY scripts/docker-registry-login.sh /usr/bin/docker-registry-login
COPY scripts/aws-ecr-login.sh /usr/bin/aws-ecr-login
COPY scripts/docker-use-buildx.sh /usr/bin/docker-use-buildx
COPY scripts/docker-use-pass.sh /usr/bin/docker-use-pass

# setup gpg and initialize pass
RUN sh /usr/bin/docker-use-pass

FROM client as compose

ARG DOCKER_COMPOSE_VERSION="1.25.5"

# install docker-compose
RUN apk add python3 openssl && \
    apk add -t .build-deps py3-pip g++ libffi-dev python3-dev openssl-dev make && \
    pip3 install docker-compose=="$DOCKER_COMPOSE_VERSION" && \
    apk del .build-deps
