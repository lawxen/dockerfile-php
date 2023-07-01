## Create a new builder instance
Which make buildx can build multi platform images on same tag.
```
docker buildx create --use --name docker-container --driver docker-container
```

## Build
```
docker buildx build --platform linux/amd64,linux/arm64 -t lawxen/php:symfony-php81-dev --push .
```

## Build with no cache
```
docker buildx build --platform linux/amd64,linux/arm64 --no-cache -t lawxen/php:symfony-php81-dev --push .
```