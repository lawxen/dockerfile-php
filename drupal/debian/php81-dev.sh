PHP_VERSION=8.1
docker buildx build -f Dockerfile-dev.template --platform linux/amd64,linux/arm64 --build-arg MY_PHP_VERSION=${PHP_VERSION} -t lawxen/drupal:php${PHP_VERSION}-debian-dev --push .