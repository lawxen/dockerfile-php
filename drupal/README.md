## Create a new builder instance
`docker buildx create --use`

## Build

php8.3-fpm
```
docker buildx build --platform linux/amd64,linux/arm64 --build-arg MY_PHP_VERSION=8.3 --build-arg MY_DRUPAL_VERSION=10 -t lawxen/drupal:php8.3-debian --push .

docker buildx build --platform linux/amd64,linux/arm64 --build-arg MY_PHP_VERSION=8.3 --build-arg MY_DRUPAL_VERSION=10 --build-arg KEEP_DRUPAL_FILES=1 -t lawxen/drupal:php8.3-debian-d10 --push .
```

dev:
```
docker buildx build -f Dockerfile-dev --platform linux/amd64,linux/arm64 --build-arg MY_PHP_VERSION=8.3 -t lawxen/drupal:php8.3-debian-dev --push .

docker buildx build -f Dockerfile-dev --platform linux/amd64,linux/arm64 --build-arg MY_PHP_VERSION=8.3 --build-arg MY_DRUPAL_VERSION=-d10 -t lawxen/drupal:php8.3-debian-d10-dev --push .
```