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

# Read configuration file
CONFIG_FILE=$1
read_config "$CONFIG_FILE"

# Check if required variables are set
if [[ -z $STORAGE_ACCOUNT_NAME || -z $RESOURCE_GROUP_NAME || -z $CONTAINER_NAME || -z $FILE_PATH ]]; then
    echo "Error: Configuration file is missing required values."
    exit 1
fi

# Check if the file exists
if [[ ! -f $FILE_PATH ]]; then
    echo "Error: File $FILE_PATH not found."
    exit 1
fi

# Get the storage account key
STORAGE_ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query "[0].value" --output tsv)

# Upload the file
echo "Uploading file $FILE_PATH to container $CONTAINER_NAME in storage account $STORAGE_ACCOUNT_NAME..."
az storage blob upload --account-name $STORAGE_ACCOUNT_NAME --container-name $CONTAINER_NAME --file $FILE_PATH --name $(basename $FILE_PATH) --account-key $STORAGE_ACCOUNT_KEY

if [[ $? -eq 0 ]]; then
    echo "File $FILE_PATH uploaded successfully."
else
    echo "Error: File upload failed."
fi

