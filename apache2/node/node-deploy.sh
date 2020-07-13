#!/usr/bin/sh

# Node installer by RugaCoder
# Disclaimer this script is provided as it is without any guarantee 
# its impacts author will not be responsible for any impact from it

echo "Welcome to our node deployment assistant \n "

echo "Please enter the git url for your project using https or ssh if you use ssh make sure ssh keys exist\n"
read giturl

echo "Please enter the name  for  your node project\n"

read projectname
cd /opt/
sleep 1

git clone $giturl $projectname 
cd $projectname

if pwd = $projectname
then
    npm install pm2@latest -g
    yarn
    yarn build
    pm2 start npm --name $projectname --log /var/log/portal.log


fi 