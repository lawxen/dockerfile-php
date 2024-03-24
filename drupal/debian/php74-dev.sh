PHP_VERSION=7.4
DRUPAL_VERSION=9
XDEBUG_VERSION="-3.1.5"
docker buildx build -f Dockerfile-dev --platform linux/amd64,linux/arm64 --build-arg MY_PHP_VERSION=${PHP_VERSION} --build-arg XDEBUG_VERSION=${XDEBUG_VERSION} -t lawxen/drupal:php${PHP_VERSION}-debian-dev --push .