# PHP7.4
docker buildx build -f debian.dev.Dockerfile --platform linux/amd64,linux/arm64 --build-arg TAG_FROM=php7.4-fpm -t lawxen/drupal:php7.4-fpm-dev --push .

# PHP8.0
docker buildx build -f debian.dev.Dockerfile --platform linux/amd64,linux/arm64 --build-arg TAG_FROM=php8.0-fpm -t lawxen/drupal:php8.0-fpm-dev --push .

# PHP8.1
docker buildx build -f debian.dev.Dockerfile --platform linux/amd64,linux/arm64 --build-arg TAG_FROM=php8.1-fpm -t lawxen/drupal:php8.1-fpm-dev --push .

# PHP8.2
docker buildx build -f debian.dev.Dockerfile --platform linux/amd64,linux/arm64 --build-arg TAG_FROM=php8.2-fpm -t lawxen/drupal:php8.2-fpm-dev --push .

# PHP8.3
docker buildx build -f debian.dev.Dockerfile --platform linux/amd64,linux/arm64 --build-arg TAG_FROM=php8.3-fpm -t lawxen/drupal:php8.3-fpm-dev --push .
docker buildx build -f debian.dev.Dockerfile --platform linux/amd64,linux/arm64 --build-arg TAG_FROM=php8.3-fpm --build-arg KEEP_DRUPAL_FILES=1 -t lawxen/drupal:10-php8.3-fpm-dev --push .

# This is for local test only
# docker buildx build --load -f debian.dev.Dockerfile --platform linux/arm64 --build-arg TAG_FROM=php8.3-fpm -t lawxen/drupal:php8.3-fpm-dev .