Project  - Shell Scripts for Azure Automation
Overview
This repository contains shell scripts for automating Azure resource management tasks. The scripts include:

create_resource.sh: Creates Azure resources.
upload.sh: Uploads files to an Azure storage container.
remove_resources.sh: Deletes Azure resources.
Prerequisites
Before running the scripts, you need to set up your environment:

1. Install Git
For Ubuntu/Linux:

# Update the package index
sudo apt update

# Install Git
sudo apt install git

# Verify the installation
git --version

2. Install Azure CLI
Follow these steps to install the Azure CLI on Ubuntu/Linux:

Update repository information and install prerequisites:
sudo apt update
sudo apt install -y ca-certificates curl apt-transport-https lsb-release GnuPG

Download and install the Microsoft signing key:
curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null

Add the Azure CLI software repository:

AZ_REPO=$(lsb_release -cs)
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | sudo tee /etc/apt/sources.list.d/azure-cli.list

Update repository information and install Azure CLI:
sudo apt update
sudo apt install -y azure-cli

Verify the installation:
az --version

3. Clone the Repository
Clone this repository to your local machine:
git clone https://github.com/SibiSM/Shell-Script.git
cd Shell-Script

4. Azure Authentication
Login to your Azure account:
az login

Script Usage
1. Create Resources
Run the create_resource.sh script with the configuration file:
./create_resource.sh /path/to/your/configuration.txt

2. Upload Files
Run the upload.sh script with the configuration file:
./upload.sh /path/to/your/configuration.txt

3. Remove Resources
Set up a cron job to run the remove_resources.sh script every 5 minutes:
Edit the crontab:

crontab -e
Add the following line to the crontab file:

*/5 * * * * /path/to/your/remove_resources.sh /path/to/your/configuration.txt >> /path/to/your/project7.log 2>&1

Logging
project7.log: Contains logs for the execution of the project7.sh script.
remove_resources.log: Contains logs for the execution of the remove_resources.sh script.


Notes
Ensure that the paths specified in the crontab and script commands are correct and point to the appropriate files on your system.
Verify that the configuration file (configuration.txt) contains the correct values for your Azure setup.
