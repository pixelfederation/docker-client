# Contributing guide

## Local development

### Environment

Required tools

* [`git`](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
* [`docker`](https://docs.docker.com/get-docker/)
* [`docker-compose`](https://docs.docker.com/compose/install/)

### Adding a new feature

1. (optionally) create issue on github / gitlab with requested feature description and possible implementation, then discuss with maintainers
2. create a new feature branch from latest `master`

    example:

    ```sh
    git fetch --all
    git pull origin master
    git checkout -b feature/my-new-shiny-feature
    ```

3. make changes in codebase
4. build changes and test it locally

    example:

    ```sh
    docker-compose build --pull
    ```
5. commit changes, and push to your fork, then create Merge Request / Pull Request, please stick to [conventional-changelog](https://github.com/conventional-changelog/conventional-changelog/tree/master/packages/conventional-changelog-angular) convention when making commits

6. make sure tests passes on CI
7. wait for maintainer to review and eventually merge your Merge Request / Pull Request

## Upgrading dependencies

### Source list of external dependencies

* `docker` - https://github.com/docker/docker-ce/releases
* `docker buildx` - https://github.com/docker/buildx/releases
* `docker-compose` - https://github.com/docker/compose/releases
* `trivy` - https://github.com/aquasecurity/trivy/releases
* `amazon-ecr-credential-helper` - https://github.com/awslabs/amazon-ecr-credential-helper/releases
* `docker-credential-helpers` - https://github.com/docker/docker-credential-helpers/releases

