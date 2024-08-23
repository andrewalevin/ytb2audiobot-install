#!/bin/bash

# Set the script to exit immediately on any errors
set -e

# Prompt for input token
read -p "📟 Please enter your telegram bot token: " TG_TOKEN
if [ -z "$TG_TOKEN" ]; then
    echo "No input token!"
    exit 1
fi

read -p "🧂 Please enter salt hash if exists. If not - press Enter - it will be generated: " SALT

# Check if the user provided a salt
if [ -z "$SALT" ]; then
    SALT=$(openssl rand -hex 32)
    echo "Generated random salt: $SALT"
fi

if [[ -z "$TG_TOKEN" || -z "$SALT" ]]; then
  echo "TG_TOKEN and SALT must be set."
  exit 1
fi

CONTENT=$(curl -s file:///Users/andrewlevin/Desktop/ytb2audiobotDocker/template-docker-compose.yaml)

CONTENT="${CONTENT//YOUR_BOT_TOKEN/$TG_TOKEN}"

CONTENT="${CONTENT//YOUR_SALT/$SALT}"

COMPOSE_FILE="docker-compose.yaml"

echo "$CONTENT"

echo -e "$CONTENT" > "$COMPOSE_FILE"

docker-compose up -d

echo "Installation and setup completed successfully!"





