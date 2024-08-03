#!/bin/bash

# Log start time
echo "Starting remove_resources.sh at $(date)" >> /home/azuser/Project7/Shell-Script/remove_resources.log

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
    echo "Error: No configuration file provided." >> /home/azuser/Project7/Shell-Script/remove_resources.log
    echo "Usage: $0 <config-file>" >> /home/azuser/Project7/Shell-Script/remove_resources.log
    exit 1
fi

CONFIG_FILE=$1
read_config "$CONFIG_FILE"

# Check if required variables are set
if [[ -z $RESOURCE_GROUP_NAME ]]; then
    echo "Error: Configuration file is missing resource group name." >> /home/azuser/Project7/Shell-Script/remove_resources.log
    exit 1
fi

# List and delete resources in the resource group
echo "Deleting all resources in resource group $RESOURCE_GROUP_NAME..." >> /home/azuser/Project7/Shell-Script/remove_resources.log

# Delete all resources in the resource group
az group delete --name $RESOURCE_GROUP_NAME --yes --no-wait >> /home/azuser/Project7/Shell-Script/remove_resources.log 2>&1

if [[ $? -eq 0 ]]; then
    echo "Resources in resource group $RESOURCE_GROUP_NAME deleted successfully at $(date)." >> /home/azuser/Project7/Shell-Script/remove_resources.log
else
    echo "Error: Failed to delete resources in resource group $RESOURCE_GROUP_NAME at $(date)." >> /home/azuser/Project7/Shell-Script/remove_resources.log
fi

