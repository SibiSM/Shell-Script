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
if [[ -z $VM_NAME || -z $STORAGE_ACCOUNT_NAME || -z $RESOURCE_GROUP_NAME || -z $CONTAINER_NAME || -z $LOCATION ]]; then
    echo "Error: Configuration file is missing required values."
    exit 1
fi

# Create Resource Group
echo "Creating Resource Group: $RESOURCE_GROUP_NAME"
az group create --name $RESOURCE_GROUP_NAME --location $LOCATION

# Create VM
echo "Creating VM: $VM_NAME"
az vm create --resource-group $RESOURCE_GROUP_NAME --name $VM_NAME --image Ubuntu2204 --admin-username azureuser --generate-ssh-keys --location $LOCATION

# Create Storage Account
echo "Creating Storage Account: $STORAGE_ACCOUNT_NAME"
az storage account create --name $STORAGE_ACCOUNT_NAME --resource-group $RESOURCE_GROUP_NAME --location $LOCATION --sku Standard_LRS

# Create Container in Storage Account
echo "Creating Container: $CONTAINER_NAME"
STORAGE_ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query "[0].value" --output tsv)
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME --account-key $STORAGE_ACCOUNT_KEY

echo "All resources created successfully."

