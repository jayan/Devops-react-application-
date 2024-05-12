#!/bin/bash

# Incremented count for image name
IMAGE_COUNT=$(($(docker images | grep -c "^react") + 1))

# Build and tag the Docker image without using cache
docker build --no-cache -t "react:${IMAGE_COUNT}" .

# Echo the image name
echo "Built Docker image: react:${IMAGE_COUNT}"
