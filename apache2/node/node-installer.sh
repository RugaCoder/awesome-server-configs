#!/usr/bin/sh

# Node installer by RugaCoder
# Disclaimer this script is provided as it is without any guarantee 
# its impacts author will not be responsible for any impact from it

sudo apt update
sudo apt upgrade

curl -sL https://deb.nodesource.com/setup_14.x | sudo bash -

sudo apt -y install nodejs

node -v 

echo "Congratulations your node is installed to the latest version"

# Installing npm package manager 

sudo apt install npm

curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update && sudo apt install yarn 
