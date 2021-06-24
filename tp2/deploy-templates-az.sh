#! /bin/bash

# Créer un réseau virtuel à l’aide d’Azure CLI

# Créer un template pour les éléments suivants :
    # Réseau virtuel
    # Sous-réseau
    # Passerelle NAT
    # Groupe de sécurité
    # VM avec commande pour installer une application Flask, voir ici : 
       # https://docs.microsoft.com/fr-fr/azure-stack/user/azure-stack-dev-start-howto-vm-python?view=azs-2102#install-python

ResourceGroupName="mikasa-ackerman-VNetQS-rg"
Location="eastus"

# Créer un groupe de ressources et un réseau virtuel
# Create a resource group  
az group create \
    --name $ResourceGroupName \
    --location $Location

# Create a virtual network with a subnet
az network vnet create \
  --name mikasa-ackerman-VNet \
  --resource-group $ResourceGroupName \
  --location $Location \
  --address-prefix 10.0.0.0/16 \
  --subnet-name  mikasa-ackerman-Subnet \
  --address-prefix 10.0.0.0/16
  --subnet-prefix 10.0.1.0/24

# Create a network security group for subnet
az network nsg create \
  --resource-group $ResourceGroupName \
  --name mikasa-ackerman-Nsg \
  --location $Location

# Create a public IP address for the web server VM.
az network public-ip create \
  --resource-group $ResourceGroupName \
  --name mikasa-ackerman-PublicIP-Web

# Create a NIC for the web server VM.
az network nic create \
  --resource-group $ResourceGroupName \
  --name mikasa-ackerman-Nic-Web \
  --vnet-name MyVnet \
  --subnet mikasa-ackerman-Subnet \
  --network-security-group mikasa-ackerman-Nsg \
  --public-ip-address mikasa-ackerman-PublicIP-Web

# Create a Web Server VM in the subnet
az vm create \
  --resource-group $ResourceGroupName \
  --name mikasa-ackerman-Web \
  --nicsmikasa-ackerman-Nic-Web \
  --image UbuntuLTS \
  --admin-username michael \
  --generate-ssh-keys
