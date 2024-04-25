# PHP7.4
docker buildx build -f alpine/Dockerfile.template --platform linux/amd64,linux/arm64 --build-arg TAG_FROM=php7.4-fpm-alpine -t lawxen/drupal:php7.4-fpm-alpine --push .

# PHP8.0
docker buildx build -f alpine/Dockerfile.template --platform linux/amd64,linux/arm64 --build-arg TAG_FROM=php8.0-fpm-alpine -t lawxen/drupal:php8.0-fpm-alpine --push .

# PHP8.1
docker buildx build -f alpine/Dockerfile.template --platform linux/amd64,linux/arm64 --build-arg TAG_FROM=php8.1-fpm-alpine -t lawxen/drupal:php8.1-fpm-alpine --push .
docker buildx build -f alpine/Dockerfile.template --platform linux/amd64,linux/arm64 --build-arg TAG_FROM=9-php8.1-fpm-alpine --build-arg KEEP_DRUPAL_FILES=1 -t lawxen/drupal:9-php8.1-fpm-alpine --push .

# PHP8.2
docker buildx build -f alpine/Dockerfile.template --platform linux/amd64,linux/arm64 --build-arg TAG_FROM=php8.2-fpm-alpine -t lawxen/drupal:php8.2-fpm-alpine --push .

# PHP8.3
docker buildx build -f alpine/Dockerfile.template --platform linux/amd64,linux/arm64 --build-arg TAG_FROM=php8.3-fpm-alpine -t lawxen/drupal:php8.3-fpm-alpine --push .
docker buildx build -f alpine/Dockerfile.template --platform linux/amd64,linux/arm64 --build-arg TAG_FROM=php8.3-fpm-alpine --build-arg KEEP_DRUPAL_FILES=1 -t lawxen/drupal:10-php8.3-fpm-alpine --push .

# This is for local test only
# docker buildx build --load -f alpine/Dockerfile.template --platform linux/arm64 --build-arg TAG_FROM=php8.3-fpm-alpine -t lawxen/drupal:php8.3-fpm-alpine .
# docker buildx build --load --no-cache -f alpine/Dockerfile.template --platform linux/arm64 --build-arg TAG_FROM=php8.3-fpm-alpine -t lawxen/drupal:php8.3-fpm-alpine .