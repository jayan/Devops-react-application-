#!/bin/bash

# Docker Hub username
DOCKER_USERNAME="cjayanth"

# Check the argument passed
if [[ "$1" == "devchanged" ]]; then
    echo "Tagging and pushing image to dev repository..."
    IMAGE_COUNT="$2"  # Use the count passed as an argument
    docker tag "react:${IMAGE_COUNT}" "${DOCKER_USERNAME}/dev:Latest${IMAGE_COUNT}"
    docker push "${DOCKER_USERNAME}/dev:Latest${IMAGE_COUNT}"
    export IMAGE_NAME="react:${IMAGE_COUNT}"  # Export before running docker-compose
    docker compose up -d
elif [[ "$1" == "devmergedmaster" ]]; then
    echo "Tagging and pushing image to prod repository..."
    IMAGE_COUNT="$2"  # Use the count passed as an argument
    docker tag "react:${IMAGE_COUNT}" "${DOCKER_USERNAME}/prod:Latest${IMAGE_COUNT}"
    docker push "${DOCKER_USERNAME}/prod:Latest${IMAGE_COUNT}"
    docker push "${DOCKER_USERNAME}/dev:Latest${IMAGE_COUNT}"
    export IMAGE_NAME="react:${IMAGE_COUNT}"  # Export before running docker-compose
    docker compose up -d
else
    echo "Invalid argument. Please provide either 'devchanged' or 'devmergedmaster'."
    exit 1
fi
