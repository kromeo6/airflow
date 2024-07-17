#!/bin/bash

# Define variables
REPO_DIR="$(pwd)"
DOCKER_COMPOSE_FILE="$REPO_DIR/docker-compose.yml"
DOCKER_HUB_REPO="yourdockerhubusername/yourimagename"
DOCKER_HUB_USERNAME="your_dockerhub_username"
DOCKER_HUB_PASSWORD="your_dockerhub_password"

# Function to parse the Docker Compose file and get the image tag
get_image_tag() {
    grep 'image: '"$DOCKER_HUB_REPO" "$DOCKER_COMPOSE_FILE" | sed 's/.*://' | tr -d '[:space:]'
}

# Step 1: Parse Docker Compose file and get the current image tag
CURRENT_TAG=$(get_image_tag)
echo "Current tag: $CURRENT_TAG"

# Step 2: Pull changes from GitHub
git pull origin main

# Step 3: Parse Docker Compose file again and get the new tag
NEW_TAG=$(get_image_tag)
echo "New tag: $NEW_TAG"

# Step 4: Compare old and new tags
if [ "$CURRENT_TAG" == "$NEW_TAG" ]; then
    echo "Tags are the same. No deployment needed."
    exit 0
else
    echo "Tags are different. Proceeding with deployment."

    # Step 5: Docker login
    echo "$DOCKER_HUB_PASSWORD" | docker login -u "$DOCKER_HUB_USERNAME" --password-stdin

    # Step 6: Pull the new image from Docker Hub and deploy
    docker pull "$DOCKER_HUB_REPO:$NEW_TAG"
    docker compose up -d
    echo "Deployment completed."
fi
