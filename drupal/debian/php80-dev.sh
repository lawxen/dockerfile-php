PHP_VERSION=8.0
DRUPAL_VERSION=9
docker buildx build -f Dockerfile-dev.template --platform linux/amd64,linux/arm64 --build-arg MY_PHP_VERSION=${PHP_VERSION} -t lawxen/drupal:php${PHP_VERSION}-debian-dev --push .
docker buildx build -f Dockerfile-dev.template --platform linux/amd64,linux/arm64 --build-arg MY_PHP_VERSION=${PHP_VERSION} --build-arg MY_DRUPAL_VERSION=-d${DRUPAL_VERSION} -t lawxen/drupal:php${PHP_VERSION}-debian-d${DRUPAL_VERSION}-dev --push .