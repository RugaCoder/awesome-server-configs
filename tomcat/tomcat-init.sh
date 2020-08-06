#!/usr/bin/sh

# @author Frances Ruganyumisa 
# Tomcat installation and configurations 

# Checking if the script is run with root privileges

if [ "$(whoami)" != 'root' ]; then
echo "You have to execute this script as root user"
exit 1;
fi

sudo apt update
sudo apt upgrade

echo "****************Installing JDK 8*************************\n"
sudo apt install openjdk-8-jre-headless

echo "****************Creating tomcat group*********************\n"
sudo groupadd tomcat

echo "*****************Creating tomcat user with the home dir /opt/tomcat \n This user is in the tomcat group\n"
sudo useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat

echo "*****************Performing some intial tomcat configs**********"
cd /tmp
wget http://apache.mirrors.ionfish.org/tomcat/tomcat-8/v8.5.5/bin/apache-tomcat-8.5.5.tar.gz
sudo mkdir /opt/tomcat
sudo tar xzvf apache-tomcat-8*tar.gz -C /opt/tomcat --strip-components=1
cd /opt/tomcat
sudo chgrp -R tomcat /opt/tomcat
sudo chmod g+x conf
sudo chown -R tomcat webapps/ work/ temp/ logs/
echo "*********Please copy path for jdk as will be needed ahead********************\n"
sudo update-java-alternatives -l

echo "**********Creating tomcat service*************\n"

echo "
[Unit]
Description=Apache Tomcat Web Application Container
After=network.target

[Service]
Type=forking

Environment=JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64/jre
Environment=CATALINA_PID=/opt/tomcat/temp/tomcat.pid
Environment=CATALINA_HOME=/opt/tomcat
Environment=CATALINA_BASE=/opt/tomcat
Environment='CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC'
Environment='JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom'

ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh

User=tomcat
Group=tomcat
UMask=0007
RestartSec=10
Restart=always

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/tomcat.service

if !echo -e /etc/systemd/system/tomcat.service; then
echo "Tomcat service not created an error occured"
fi

echo "*********************Reloading the damon to load tomcat service***************************\n"
sudo systemctl daemon-reload

echo "*****************Checking the status of tomcat*****************\n"
sudo systemctl status tomcat

echo "*********** To access the management via web edit the users.xml file************\n"


