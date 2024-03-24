PHP_VERSION=7.4
DRUPAL_VERSION=9
docker buildx build --platform linux/amd64,linux/arm64 --build-arg MY_PHP_VERSION=${PHP_VERSION} --build-arg MY_DRUPAL_VERSION=${DRUPAL_VERSION} -t lawxen/drupal:php${PHP_VERSION}-debian --push .