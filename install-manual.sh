#!/bin/bash

# Set the script to exit immediately on any errors
set -e

# Determine the OS type (Linux or macOS)
OS=$(uname)
echo "💻 Check your OS SYSTEM:"
echo $OS


if [ "$OS" == "Linux" ]; then
  :
elif [ "$OS" == "Darwin" ]; then
  :
else
  echo "💻❌ Unsupported OS: $OS.\n🔚 Exit"
  exit 1
fi


packages=("python3" "ffmpeg")

# Install packages based on the OS type
if [ "$OS" == "Linux" ]; then
  echo "Updating package lists..."
  sudo apt-get update

  echo "Installing required packages..."
  for package in "${packages[@]}"; do
    sudo apt-get install -y "$package"
    done

elif [ "$OS" == "Darwin" ]; then
  echo "Checking for Homebrew installation..."
  if ! command -v brew &> /dev/null; then
    echo "❌ Homebrew not found. You need to install Homebrew..."
    exit 1
  fi

  echo "Installing required packages..."
  for package in "${packages[@]}"; do
    brew install "$package"
    done
else
  :
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

read -p "📟 Please enter your telegram bot token: " TG_TOKEN  < /dev/tty
if [ -z "$TG_TOKEN" ]; then
    echo "No input token!"
    exit 1
fi

read -p "🧂 Please enter salt hash if exists. If not - press Enter - it will be generated: " SALT  < /dev/tty
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
  DEMON_CONTENT=$(curl -sL https://andrewalevin.github.io/ytb2audiobot-install/template-ytb2audiobot.service)

  FILE_SERVICE_NAME="ytb2audiobot.service"

  FILE_SERVICE_PATH="/etc/systemd/system/$FILE_SERVICE_NAME"

  echo -e "${DEMON_CONTENT//\ROOT_DIR/$(pwd)}" | sudo tee "$FILE_SERVICE_NAME"

  sudo cp "$FILE_SERVICE_NAME" "$FILE_SERVICE_PATH"

  sudo systemctl daemon-reload

  sudo systemctl enable "$FILE_SERVICE"

  sudo systemctl start "$FILE_SERVICE"

  sudo systemctl status "$FILE_SERVICE"


elif [ "$OS" == "Darwin" ]; then
  DEMON_CONTENT=$(curl -sL https://andrewalevin.github.io/ytb2audiobot-install/template-com.andrewlevin.ytb2audiobot.plist)
  PLIST_FILE="com.andrewlevin.ytb2audiobot.plist"

  echo -e "${DEMON_CONTENT//\ROOT_DIR/$(pwd)}" > "/etc/systemd/system/$PLIST_FILE"

  ./reload-demon-darwin.sh

fi


echo "Installation and setup completed successfully!"





