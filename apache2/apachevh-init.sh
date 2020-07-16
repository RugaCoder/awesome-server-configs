#!/bin/bash
# Server automations
# author @RugaCoder <fruganyumisa@gmail.com>

echo "Welcome to Automatic Virtualhost creator"

if [ "$(whoami)" != 'root' ]; then
echo "You have to execute this script as root user"
exit 1;
fi
read -p "Enter the server name your want (without www) : " servn
read -p "Enter a CNAME (e.g. :www or dev for dev.website.com) : " cname
read -p "Enter the path of directory you wanna use (e.g. : /var/www/, dont forget the /): " dir
read -p "Enter the user you wanna use (e.g. : apache) : " usr
read -p "Enter the listened IP for the server (e.g. : *): " listen
if ! mkdir -p $dir$servn; then
echo "Web directory already Exist !"
else
echo "Web directory created with success !"
fi

chown -R $usr:$usr $dir$servn
chmod -R '755' $dir$servn
mkdir /var/log/$servn

alias=$cname.$servn
if [[ "${cname}" == "" ]]; then
alias=$servn
fi

echo "#### $cname $servn
<VirtualHost $listen:80>
ServerName $servn
ServerAlias $alias
DocumentRoot $dir$cname_$servn
<Directory $dir$cname_$servn>
Options Indexes FollowSymLinks MultiViews
AllowOverride All
Order allow,deny
Allow from all
Require all granted
</Directory>
</VirtualHost>" > /etc/apache2/sites-available/$servn.conf
if ! echo -e /etc/apache2/sites-available/$servn.conf; then
echo "Virtual host wasn't created !"
else
echo "Virtual host created !"
fi
echo "Would you like me to create ssl virtual host [y/n]? "
read q
if [[ "${q}" == "yes" ]] || [[ "${q}" == "y" ]]; then
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/certs/$servn/$servn.key -out/etc/ssl/certs/$servn/$servn.crt
if ! echo -e /etc/ssl/certs/$servn/$servn.key; then
echo "Certificate key wasn't created !"
else
echo "Certificate key created !"
fi
if ! echo -e /etc/httpd/conf.d/$cname_$servn.crt; then
echo "Certificate wasn't created !"
else
echo "Certificate created !"
fi

echo "#### ssl $cname $servn
<VirtualHost $listen:443>
SSLEngine on
SSLCertificateFile /etc/ssl/certs/$servn/$servn.crt
SSLCertificateKeyFile /etc/ssl/certs/$servn/$servn.key
ServerName $servn
ServerAlias $alias
DocumentRoot $dir$cname_$servn
<Directory $dir$servn>
Options Indexes FollowSymLinks MultiViews
AllowOverride All
Order allow,deny
Allow from all
Satisfy Any
</Directory>
</VirtualHost>" > /etc/httpd/conf.d/ssl.$cname_$servn.conf
if ! echo -e /etc/httpd/conf.d/ssl.$cname_$servn.conf; then
echo "SSL Virtual host wasn't created !"
else
echo "SSL Virtual host created !"
fi
fi

echo "127.0.0.1 $servn" >> /etc/hosts
if [ "$alias" != "$servn" ]; then
echo "127.0.0.1 $alias" >> /etc/hosts
fi
echo "Testing configuration"
service apache2 configtest
echo "Would you like me to restart the server [y/n]? "
read q
if [[ "${q}" == "yes" ]] || [[ "${q}" == "y" ]]; then
service apache2 restart
fi
echo "======================================"
echo "All works done! You should be able to see your website at http://$servn"
echo ""
echo "Share the love! <3"
echo "======================================"
echo ""
echo "Wanna contribute to improve this script? Found a bug? https://github.com/RugaCoder/awesome-server-configs/issues"