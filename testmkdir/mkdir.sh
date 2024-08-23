#!/bin/bash

# Base directory name
dirname="ytb2audiobot"

# Initialize counter
counter=1

# Loop to find a directory name that doesn't exist
while true; do
    # If counter is 0, use the base name; otherwise, append the counter to the name
    if [ $counter -eq 1 ]; then
        dir="$dirname"
    else
        dir="${dirname}${counter}"
    fi

    # Check if directory exists
    if [ ! -d "$dir" ]; then
        # Directory doesn't exist, create it
        mkdir "$dir"
        echo "Directory created: $dir"
        break
    fi

    # Increment counter for the next loop
    counter=$((counter + 1))
done