#!/bin/bash

# Function to prompt user
confirm() {
    read -r -p "$1 [Y/n]: " response
    case "$response" in
        [nN][oO]|[nN])
            return 1
            ;;
        *)
            return 0
            ;;
    esac
}

# Copy a file (example)
copy_file() {
    cp /path/to/source /path/to/destination
    echo "File copied."
}

# Enable a service (example)
enable_service() {
    sudo systemctl enable your-service-name
    echo "Service enabled."
}

# Start a service (example)
start_service() {
    sudo systemctl start your-service-name
    echo "Service started."
}

# Ask for confirmation to copy file
if confirm "Do you want to copy the file?"; then
    copy_file
else
    echo "File copy skipped."
fi

# Ask for confirmation to enable the service
if confirm "Do you want to enable the service?"; then
    enable_service
else
    echo "Service enablement skipped."
fi

# Ask for confirmation to start the service
if confirm "Do you want to start the service?"; then
    start_service
else
    echo "Service start skipped."
fi
