## Create and use a builder instance with driver "docker-container" if you haven't do it.
Which make buildx can build multi platform images on same tag.
```
docker buildx create --use --name docker-container --driver docker-container
```

## Build
```
docker buildx build --platform linux/amd64,linux/arm64 -t lawxen/drupal:d9-php74 --push .
```

## Build with no cache
```
docker buildx build --platform linux/amd64,linux/arm64 --no-cache -t lawxen/drupal:d9-php74 --push .
```

# Push
```
docker push lawxen/drupal:d9-php74
```