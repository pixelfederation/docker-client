# https://github.com/moby/moby/releases
ARG DOCKER_VERSION="20.10.5"

# https://github.com/docker/compose/releases
ARG DOCKER_COMPOSE_VERSION="1.29.0"

FROM docker:${DOCKER_VERSION} as client

RUN apk add --update jq bash curl git openssh-client pass && \
    apk upgrade && \
    rm -rf /var/cache/apk/*

# https://github.com/docker/buildx/releases
ARG DOCKER_BUILDX_VERSION="0.5.1"
# https://github.com/awslabs/amazon-ecr-credential-helper/releases
ARG DOCKER_AWS_ECR_CREDENTIAL_HELPER_VERSION="0.5.0"
# https://github.com/docker/docker-credential-helpers/releases
ARG DOCKER_PASS_CREDENTIAL_HELPER_VERSION="0.6.3"

# install docker buildx
RUN wget "https://github.com/docker/buildx/releases/download/v${DOCKER_BUILDX_VERSION}/buildx-v${DOCKER_BUILDX_VERSION}.linux-amd64" && \
    mkdir -p ~/.docker/cli-plugins && \
    mv "buildx-v${DOCKER_BUILDX_VERSION}.linux-amd64" ~/.docker/cli-plugins/docker-buildx && \
    chmod a+x ~/.docker/cli-plugins/docker-buildx && \
    # install AWS ECR credential helper
    wget "https://amazon-ecr-credential-helper-releases.s3.us-east-2.amazonaws.com/${DOCKER_AWS_ECR_CREDENTIAL_HELPER_VERSION}/linux-amd64/docker-credential-ecr-login" && \
    mv docker-credential-ecr-login /usr/local/bin/docker-credential-ecr-login && \
    chmod a+x /usr/local/bin/docker-credential-ecr-login && \
    # install docker pass credential helper
    wget "https://github.com/docker/docker-credential-helpers/releases/download/v${DOCKER_PASS_CREDENTIAL_HELPER_VERSION}/docker-credential-pass-v${DOCKER_PASS_CREDENTIAL_HELPER_VERSION}-amd64.tar.gz" && \
    tar -xvf "docker-credential-pass-v${DOCKER_PASS_CREDENTIAL_HELPER_VERSION}-amd64.tar.gz" && \
    mv docker-credential-pass /usr/local/bin/docker-credential-pass && \
    chmod a+x /usr/local/bin/docker-credential-pass && \
    rm "docker-credential-pass-v${DOCKER_PASS_CREDENTIAL_HELPER_VERSION}-amd64.tar.gz"

COPY scripts/gitlab-docker-registry-login.sh /usr/local/bin/gitlab-docker-registry-login
COPY scripts/docker-registry-login.sh /usr/local/bin/docker-registry-login
COPY scripts/aws-ecr-login.sh /usr/local/bin/aws-ecr-login
COPY scripts/docker-use-buildx.sh /usr/local/bin/docker-use-buildx
COPY scripts/docker-use-pass.sh /usr/local/bin/docker-use-pass

# setup gpg and initialize pass
RUN sh /usr/local/bin/docker-use-pass

FROM docker/compose:${DOCKER_COMPOSE_VERSION} as compose-source

FROM client as compose

COPY --from=compose-source /usr/local/bin/docker-compose /usr/local/bin/docker-compose
