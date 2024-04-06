# This is for local test only
# docker buildx build --load -f Dockerfile.template --platform linux/arm64 --build-arg MY_PHP_VERSION=${PHP_VERSION} --build-arg MY_DRUPAL_VERSION=${DRUPAL_VERSION} -t lawxen/drupal:php${PHP_VERSION}-alpine .

# PHP7.4
docker buildx build -f Dockerfile.template --platform linux/amd64,linux/arm64 --build-arg MY_PHP_VERSION=7.4 --build-arg MY_DRUPAL_VERSION=9 -t lawxen/drupal:php7.4-alpine --push .

# PHP8.0
docker buildx build -f Dockerfile.template --platform linux/amd64,linux/arm64 --build-arg MY_PHP_VERSION=8.0 --build-arg MY_DRUPAL_VERSION=9 -t lawxen/drupal:php8.0-alpine --push .

# PHP8.1
docker buildx build -f Dockerfile.template --platform linux/amd64,linux/arm64 --build-arg MY_PHP_VERSION=8.1 --build-arg MY_DRUPAL_VERSION=10 -t lawxen/drupal:php8.1-alpine --push .

# PHP8.2
docker buildx build -f Dockerfile.template --platform linux/amd64,linux/arm64 --build-arg MY_PHP_VERSION=8.2 --build-arg MY_DRUPAL_VERSION=10 -t lawxen/drupal:php8.2-alpine --push .

# PHP8.3
docker buildx build -f Dockerfile.template --platform linux/amd64,linux/arm64 --build-arg MY_PHP_VERSION=8.3 --build-arg MY_DRUPAL_VERSION=10 -t lawxen/drupal:php8.3-alpine --push .
docker buildx build -f Dockerfile.template --platform linux/amd64,linux/arm64 --build-arg MY_PHP_VERSION=8.3 --build-arg MY_DRUPAL_VERSION=10 --build-arg KEEP_DRUPAL_FILES=1 -t lawxen/drupal:php8.3-alpine-d10 --push .