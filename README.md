# Docker image with Docker client empowered

This image is used to build other docker images on GitLab. It has additional tools like `docker/buildx` or `awslabs/amazon-ecr-credential-helper`

## Building

### Docker-compose

```sh
docker-compose build --pull
```

### Docker only

```sh
DOCKER_VERSION="20.10.17"
DOCKER_BUILDX_VERSION="0.8.2"
DOCKER_AWS_ECR_CREDENTIAL_HELPER_VERSION="0.5.0"
docker build --pull --build-arg "DOCKER_VERSION=$DOCKER_VERSION" \
    --build-arg "DOCKER_BUILDX_VERSION=$DOCKER_BUILDX_VERSION" \
    --build-arg "DOCKER_AWS_ECR_CREDENTIAL_HELPER_VERSION=$DOCKER_AWS_ECR_CREDENTIAL_HELPER_VERSION" \
    --tag "docker.io/openswoolebundle/docker-client:$DOCKER_VERSION" .

docker run --rm -ti -v "/var/run/docker.sock:/var/run/docker.sock" "docker.io/openswoolebundle/docker-client:$DOCKER_VERSION" info
```

docker push docker.io/openswoolebundle/docker-client

## GitLab Examples

### Running build commands using `docker/buildx`

```yaml
build-docker-image:
  stage: build
  image: docker.io/openswoolebundle/docker-client:latest
  variables:
    DOCKER_TLS_CERTDIR: /certs
    DOCKER_BUILDX_CONTEXT_CREATE: "1"
    DOCKER_BUILDX_BUILDER_CREATE: "1"
  services:
    - docker:19.03.5-dind
  before_script:
    - docker-use-buildx
  script:
    - >-
        docker build
        --tag "$IMAGE_NAME:$IMAGE_TAG"
        --cache-from "type=registry,ref=$IMAGE_NAME"
        --cache-to "type=registry,ref=$IMAGE_NAME,mode=max"
        --output "type=registry" .
```

### Authorize AWS ECR

```yaml
build-docker-image:
  stage: build
  image: docker.io/openswoolebundle/docker-client:latest
  variables:
    DOCKER_TLS_CERTDIR: /certs
    AWS_ACCOUNT_ID: xxxxx
    AWS_DEFAULT_REGION: xxxxx
    AWS_ACCESS_KEY_ID: xxxxx
    AWS_SECRET_ACCESS_KEY: xxxxx
  services:
    - docker:20.10.17-dind
  before_script:
    - aws-ecr-login
  script:
    - docker build --tag "$AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$IMAGE_NAME:$IMAGE_TAG" .
    - docker push "$AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$IMAGE_NAME:$IMAGE_TAG" .
```

### Authorize GitLab Registry

```yaml
build-docker-image:
  stage: build
  image: docker.io/openswoolebundle/docker-client:latest
  variables:
    DOCKER_TLS_CERTDIR: /certs
  services:
    - docker:20.10.17-dind
  before_script:
    - gitlab-docker-registry-login
  script:
    - docker build --tag "$CI_REGISTRY_IMAGE:$IMAGE_TAG" .
    - docker push "$CI_REGISTRY_IMAGE:$IMAGE_TAG" .
```

## Local Examples using Docker-compose

### Exposed local daemon via unix socket

```sh
# Build
docker-compose build --pull

# Use
docker-compose run --rm local docker ps

# or
docker-compose run --rm local sh

cd workspace/nginx
./build-and-run.sh
# ...
# <b>Hello Docker!</b>
```

### Docker in Docker (dind)

```sh
# Start docker daemon in docker (dind)
docker-compose up -d dind

# Build
docker-compose build --pull

# Start
docker-compose run --rm remote docker ps

# or
docker-compose run --rm remote sh

cd workspace/nginx
./build-and-run.sh
# ...
# <b>Hello Docker!</b>

```

### Docker in Docker (dind) with buildx

```sh
# Start docker daemon in docker (dind)
docker-compose up -d dind

# Build
docker-compose build --pull

# Start
docker-compose run --rm remote sh

docker-use-buildx
cd workspace/nginx
./buildx-and-run.sh
# ...
# <b>Hello Docker!</b>

```

### Clean-up

```sh
docker-compose down -v
```
