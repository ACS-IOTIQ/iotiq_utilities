#!/bin/bash
set -e

# Variables
LOCAL_DIR="$HOME/iotiq_utilities"
COMPOSE_DIR="$LOCAL_DIR/scripts/backend"
IMAGE_NAME="acsiotiq/iotiq_utility_backend:latest"
DOCKERFILE_PATH="$COMPOSE_DIR/Dockerfile"
BACKEND_DIR="$LOCAL_DIR/backend"

# Go to local repo and pull latest changes
echo "Pulling latest changes in $LOCAL_DIR..."
cd "$LOCAL_DIR"
git pull origin main

# Build the Docker image
echo "Building Docker image..."
docker build -t "$IMAGE_NAME" -f "$DOCKERFILE_PATH" "$BACKEND_DIR"

# Push the Docker image
echo "Pushing Docker image to registry..."
docker push "$IMAGE_NAME"

# Restart the docker-compose
echo "Restarting backend via Docker Compose..."
cd "$COMPOSE_DIR"
docker compose up -d --build

echo "Deployment completed successfully!"
