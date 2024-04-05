PHP_VERSION=8.2
DRUPAL_VERSION=10
docker buildx build -f Dockerfile.template --platform linux/amd64,linux/arm64 --build-arg MY_PHP_VERSION=$PHP_VERSION --build-arg MY_DRUPAL_VERSION=${DRUPAL_VERSION} -t lawxen/drupal:php${PHP_VERSION}-debian --push .
docker buildx build -f Dockerfile.template --platform linux/amd64,linux/arm64 --build-arg MY_PHP_VERSION=$PHP_VERSION --build-arg MY_DRUPAL_VERSION=${DRUPAL_VERSION} --build-arg KEEP_DRUPAL_FILES=1 -t lawxen/drupal:php${PHP_VERSION}-debian-d${DRUPAL_VERSION} --push .