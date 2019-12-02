# Docker image with Docker client empowered

This image is used to build other docker images on GitLab. It has additional tools like `docker/buildx` or `awslabs/amazon-ecr-credential-helper`

## Building

```sh
DOCKER_VERSION="19.03.5"
DOCKER_BUILDX_VERSION="0.3.1"
DOCKER_AWS_ECR_CREDENTIAL_HELPER_VERSION="0.3.1"
docker build --pull --build-arg "DOCKER_VERSION=$DOCKER_VERSION" \
    --build-arg "DOCKER_BUILDX_VERSION=$DOCKER_BUILDX_VERSION" \
    --build-arg "DOCKER_AWS_ECR_CREDENTIAL_HELPER_VERSION=$DOCKER_AWS_ECR_CREDENTIAL_HELPER_VERSION" \
    --tag "registry.gitlab.com/swoole-bundle/docker-client:$DOCKER_VERSION" .

docker run --rm -ti -v "/var/run/docker.sock:/var/run/docker.sock" "registry.gitlab.com/swoole-bundle/docker-client:$DOCKER_VERSION" info
```

docker push registry.gitlab.com/swoole-bundle/docker-client

## Examples

### Running build commands using `docker/buildx`

```yaml
build-docker-image:
  stage: build
  image: registry.gitlab.com/swoole-bundle/docker-client:latest
  variables:
    DOCKER_TLS_CERTDIR: "" # won't work with TLS enabled on gitlab shared runners
  services:
    - docker:19.03.5-dind
  before_script:
    - docker-use-buildx
    - docker buildx create --use
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
  image: registry.gitlab.com/swoole-bundle/docker-client:latest
  variables:
    DOCKER_TLS_CERTDIR: /certs
    AWS_ACCOUNT_ID: xxxxx
    AWS_DEFAULT_REGION: xxxxx
    AWS_ACCESS_KEY_ID: xxxxx
    AWS_SECRET_ACCESS_KEY: xxxxx
  services:
    - docker:19.03.5-dind
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
  image: registry.gitlab.com/swoole-bundle/docker-client:latest
  variables:
    DOCKER_TLS_CERTDIR: /certs
  services:
    - docker:19.03.5-dind
  before_script:
    - gitlab-docker-registry-login
  script:
    - docker build --tag "$CI_REGISTRY_IMAGE:$IMAGE_TAG" .
    - docker push "$CI_REGISTRY_IMAGE:$IMAGE_TAG" .
```
