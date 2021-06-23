#! /bin/bash
 
# Création d'un groupe de ressources
az group create --name tp1-sasha-braus --location eastus
 
#commande avec valeur par default
 
az configure --defaults group=tp1-sasha-braus location=eastus
 
# Create a virtual machine configuration
az vm create \
  --resource-group tp1-sasha-braus \
  --name tp1-sasha-braus-vm \
  --image UbuntuLTS \
  --admin-username michael \
  --generate-ssh-keys
 
# Create an inbound network security group rule for port 80
az vm open-port \
  --port 80 \
  --name tp1-sasha-braus-vm \
  --resource-group tp1-sasha-braus

# Connexion à la machine virtuelle
chmod 400 /home/michael/.ssh/id_rsa.pub
ipAzAddress=$(az vm show -d -g tp1-sasha-braus -n tp1-sasha-braus-vm --query publicIps -o tsv)
ssh michael@$ipAzAddress

# Installation du serveur web
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo npm install -g pm2
sudo apt-get install -y nginx
sudo pm2 start -f index.js
