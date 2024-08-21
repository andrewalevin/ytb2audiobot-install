#!/bin/bash

# Set the script to exit immediately on any errors
set -e

# sudo apt-get update

echo ""
echo "All Right!"


# Prompt for input token
read -p "📟 Please enter your telegram bot token: " TG_TOKEN
echo "Betven READ"
read -p "📟 Please enter your telegram bot token: " TG_TOKEN

if [ -z "$TG_TOKEN" ]; then
    echo "No input token!"
    exit 1
fi

read -p "🧂 Please enter salt : " SALT