#!/bin/bash

# Log start time
echo "Starting project7.sh at $(date)" >> /home/azuser/Project7/Shell-Script/project7.log

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
    echo "Error: No configuration file provided." >> /home/azuser/Project7/Shell-Script/project7.log
    echo "Usage: $0 <config-file>" >> /home/azuser/Project7/Shell-Script/project7.log
    exit 1
fi

CONFIG_FILE=$1
read_config "$CONFIG_FILE"

# Check if required variables are set
if [[ -z $UPLOAD_SCRIPT ]]; then
    echo "Error: Configuration file is missing upload script file name." >> /home/azuser/Project7/Shell-Script/project7.log
    exit 1
fi

# Run upload script
SCRIPT_DIR=$(dirname "$0")
echo "Running $SCRIPT_DIR/$UPLOAD_SCRIPT with config $CONFIG_FILE" >> /home/azuser/Project7/Shell-Script/project7.log
"$SCRIPT_DIR/$UPLOAD_SCRIPT" "$CONFIG_FILE"
if [[ $? -ne 0 ]]; then
    echo "Error: Failed to upload file." >> /home/azuser/Project7/Shell-Script/project7.log
    exit 1
fi

echo "File upload completed successfully at $(date)." >> /home/azuser/Project7/Shell-Script/project7.log

