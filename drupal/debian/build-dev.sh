# This is for local test only
# docker buildx build --load -f Dockerfile-dev.template --platform linux/arm64 --build-arg MY_PHP_VERSION=8.3 -t lawxen/drupal:php8.3-debian-dev .

# Php7.4
docker buildx build -f Dockerfile-dev.template --platform linux/amd64,linux/arm64 --build-arg MY_PHP_VERSION=7.4 --build-arg XDEBUG_VERSION=-3.1.5 -t lawxen/drupal:php7.4-debian-dev --push .

# Php8.0
docker buildx build -f Dockerfile-dev.template --platform linux/amd64,linux/arm64 --build-arg MY_PHP_VERSION=8.0 -t lawxen/drupal:php8.0-debian-dev --push .

# Php8.1
docker buildx build -f Dockerfile-dev.template --platform linux/amd64,linux/arm64 --build-arg MY_PHP_VERSION=8.1 -t lawxen/drupal:php8.1-debian-dev --push .

# Php8.2
docker buildx build -f Dockerfile-dev.template --platform linux/amd64,linux/arm64 --build-arg MY_PHP_VERSION=8.2 -t lawxen/drupal:php8.2-debian-dev --push .

# Php8.3
docker buildx build -f Dockerfile-dev.template --platform linux/amd64,linux/arm64 --build-arg MY_PHP_VERSION=8.3 -t lawxen/drupal:php8.3-debian-dev --push .
docker buildx build -f Dockerfile-dev.template --platform linux/amd64,linux/arm64 --build-arg MY_PHP_VERSION=8.3 --build-arg MY_DRUPAL_VERSION=-d10 -t lawxen/drupal:php8.3-debian-d10-dev --push .