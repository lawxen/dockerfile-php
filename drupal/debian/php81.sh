PHP_VERSION=8.1
DRUPAL_VERSION=10
docker buildx build --platform linux/amd64,linux/arm64 --build-arg MY_PHP_VERSION=$PHP_VERSION --build-arg MY_DRUPAL_VERSION=${DRUPAL_VERSION} -t lawxen/drupal:php${PHP_VERSION}-debian --push .