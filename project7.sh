#!/bin/bash

# Function to read configuration file
read_config() {
    while IFS='=' read -r key value; do
        if [[ $key =~ ^[[:space:]]*# || $key =~ ^[[:space:]]*$ ]]; then
            continue
        fi
        eval "$key=\"$value\""
    done < "$1"
}

# Check if configuration file is passed as an argument
if [[ -z $1 ]]; then
    echo "Error: No configuration file provided."
    echo "Usage: $0 <config-file>"
    exit 1
fi

CONFIG_FILE=$1
read_config "$CONFIG_FILE"

# Check if required variables are set
if [[ -z $CREATE_SCRIPT || -z $UPLOAD_SCRIPT ]]; then
    echo "Error: Configuration file is missing script file names."
    exit 1
fi

# Run create script
./$CREATE_SCRIPT "$CONFIG_FILE"
if [[ $? -ne 0 ]]; then
    echo "Error: Failed to create resources."
    exit 1
fi

# Run upload script
./$UPLOAD_SCRIPT "$CONFIG_FILE"
if [[ $? -ne 0 ]]; then
    echo "Error: Failed to upload file."
    exit 1
fi

echo "All tasks completed successfully."

