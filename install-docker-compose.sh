#!/bin/bash

# Set the script to exit immediately on any errors
set -e

# Prompt for input token
# shellcheck disable=SC2162
read -p "📟 Please enter your telegram bot token: " TG_TOKEN < /dev/tty
if [ -z "$TG_TOKEN" ]; then
    echo "🚫 No input token!"
    echo "🪂 Exit."
    exit 1
fi

# shellcheck disable=SC2162
read -p "🧂 Please enter salt hash if exists. If not - press Enter - it will be generated: " SALT < /dev/tty

# Check if the user provided a salt
if [ -z "$SALT" ]; then
    SALT=$(openssl rand -hex 32)
    echo "💚 Generated random salt: $SALT"
fi

if [[ -z "$TG_TOKEN" || -z "$SALT" ]]; then
  echo "💚 TG_TOKEN and SALT must be set."
  exit 1
  echo "🪂 Exit."
fi

CONTENT=$(curl -s file:///Users/andrewlevin/Desktop/ytb2audiobotDocker/template-docker-compose.yaml)

CONTENT="${CONTENT//YOUR_BOT_TOKEN/$TG_TOKEN}"

CONTENT="${CONTENT//YOUR_SALT/$SALT}"

echo -e "$CONTENT" > "docker-compose.yaml"

docker-compose up -d

echo "💚 Installation and setup completed successfully!"





