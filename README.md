Build example:
`docker build -f drupal/alpine/php8.3/base/Dockerfile .`

## Create a new builder instance
Which make buildx can build multi platform images on same tag.
```
docker buildx create --use --name docker-container --driver docker-container
```

## Build
```
docker buildx build -f drupal/debian/php8.0/debian/Dockerfile --platform linux/amd64,linux/arm64 -t lawxen/drupal:php8.0-debian --push .
```

## Build with no cache
```
docker buildx build -f drupal/alpine/php8.3/alpine/Dockerfile --platform linux/amd64,linux/arm64 --no-cache -t lawxen/drupal:d9-php80 --push .
```