#!/bin/bash

# Set the script to exit immediately on any errors
set -e

# Determine the OS type (Linux or macOS)
OS=$(uname)
echo "OS SYSTEM:"
echo $OS


# Install packages based on the OS type
if [ "$OS" == "Linux" ]; then
  echo "Updating package lists..."
  sudo apt-get update

  echo "Installing required packages..."
  sudo apt-get install -y python3 ffmpeg

elif [ "$OS" == "Darwin" ]; then
  echo "Checking for Homebrew installation..."
  if ! command -v brew &> /dev/null; then
    echo "Homebrew not found. Installing Homebrew..."
    exit 1
  fi

  echo "Installing required packages..."
  brew install python3
  brew install ffmpeg

else
  echo "Unsupported OS: $OS"
  exit 1
fi

# Check if the virtual environment directory exists
if [ ! -d "venv" ]; then
    # Create a Python virtual environment
  echo "No VENV. Creating Python virtual environment..."
  python3 -m venv venv
fi



# Activate the virtual environment
echo "Activating virtual environment..."
source venv/bin/activate

echo "Installing Python dependencies..."
pip install ytb2audiobot


echo ""
echo "All Right!"
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

# Write to .env file
echo -e "TG_TOKEN='$TG_TOKEN'\nSALT='$SALT'" > .env

# Confirm that the file has been written
echo ".env file has been created with TG_TOKEN and SALT."


DEMON_CONTENT=""


if [ "$OS" == "Linux" ]; then
  DEMON_CONTENT=$(curl -s file:///Users/andrewlevin/Desktop/ytb2audiobotDocker/installation/template-ytb2audiobot.service)

  CONTENT="${DEMON_CONTENT//\ROOT_DIR/$(pwd)}"

  echo -e "$CONTENT" > "ytb2audiobot.service"
q
  ./reload-demon-linux.sh

elif [ "$OS" == "Darwin" ]; then
  DEMON_CONTENT=$(curl -s file:///Users/andrewlevin/Desktop/ytb2audiobotDocker/installation/template-com.andrewlevin.ytb2audiobot.plist)

  CONTENT="${DEMON_CONTENT//\ROOT_DIR/$(pwd)}"

  PLIST_FILE="com.andrewlevin.ytb2audiobot.plist"

  echo -e "$CONTENT" > "$PLIST_FILE"

  ./reload-demon-darwin.sh

fi


echo "Installation and setup completed successfully!"





