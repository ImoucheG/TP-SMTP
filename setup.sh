# Enter absolute path of this script #
echo "Enter the absolute path of this script :"
read ABSOLUTE_PATH
# Update the system #
#apt-get update -y && apt-get upgrade -y
# Install package SUDO #
apt-get install -y sudo
# Create users and groups #
useradd epsi
adduser epsi root
adduser epsi sudo
# Install MySQL Server #
echo 'mysql-server mysql-server/root_password password mysql' | debconf-set-selections
echo 'mysql-server mysql-server/root_password_again password mysql' | debconf-set-selections
apt-get install -y mysql-server
mysql_install_db
# Install APACHE 2.0 #
apt-get install -y apache2
# Install PHP #
apt-get install -y php5 libapache2-mod-php5 php5-mysql
# Restart Apache 2 #
service apache2 restart
# Install DOMAIN #
# Declare hostname #
echo "hostone" > /etc/hostname
/etc/init.d/hostname.sh start
echo "\n127.0.0.1 localhost.gira.labos-nantes.ovh localhost" > /etc/hosts
echo "\n172.16.4.1 hostone.gira.labos-nantes.ovh hostone" >> /etc/hosts
echo "\ndomain gira.labos-nantes.ovh" >> /etc/resolv.conf
echo "\nsearch gira.labos-nantes.ovh" >> /etc/resolv.conf
echo "\nnameserver 172.16.4.1" >> /etc/resolv.conf
apt-get install -y bind9 dnsutils
cp -R $ABSOLUTE_PATH/config_bind9/* /etc/bind
service bind9 restart
# Install Postfix #
#login : admin@labos-nantes.ovh
#password : admin2015
# LOCAL ONLY & DOMAIN : hostone.gira.labos-nantes.ovh 
apt-get install -y postfix postfix-mysql
# Create Database of POSTFIX | User : postfix ; password : postfix #
mysql -u root -pmysql -e "CREATE database postfix;"
mysql -u root -pmysql -e "CREATE USER 'postfix'@'localhost' IDENTIFIED BY 'postfix';"
mysql -u root -pmysql -e "GRANT USAGE ON *.* TO 'postfix'@'localhost';"
mysql -u root -pmysql -e "GRANT ALL PRIVILEGES ON postfix.* TO 'postfix'@'localhost';"
# Install postfixadmin #
cd /var/www
# DDL the archive #
wget http://sourceforge.net/projects/postfixadmin/files/postfixadmin/postfixadmin-2.93/postfixadmin-2.93.tar.gz
tar -xzf postfixadmin-2.93.tar.gz
mv postfixadmin-2.93 postfixadmin
rm -rf postfixadmin-2.93.tar.gz
chown -R root:root postfixadmin
# Install PHP IMAP #
apt-get install -y php5-imap
# Configuration PostfixAdmin #
service apache2 restart
# VirtualHost APACHE 2.0 #
# Listen 8080 #
echo "\nListen 8080" >> /etc/apache2/ports.conf
echo "\n<VirtualHost 172.16.4.1:8080>" >> /etc/apache2/sites-enabled/000-default.conf
echo "\n 	DocumentRoot /var/www/postfixadmin/" >> /etc/apache2/sites-enabled/000-default.conf
echo "\n 	<Directory / >" >> /etc/apache2/sites-enabled/000-default.conf
echo "\n 		DirectoryIndex login.php" >> /etc/apache2/sites-enabled/000-default.conf
echo "\n 		AllowOverride All" >> /etc/apache2/sites-enabled/000-default.conf
echo "\n 		Require all granted" >> /etc/apache2/sites-enabled/000-default.conf
echo "\n 	</Directory>" >> /etc/apache2/sites-enabled/000-default.conf
echo "\n</VirtualHost>" >> /etc/apache2/sites-enabled/000-default.conf
# Restart Apache #
service apache2 restart
# Password postfixadmin: postfix2015
# User : g.imouche@gira.labos-nantes.ovh::gimouche2015 // a.rousseau@gira.labos-nantes.ovh::arousseau2015
cp $ABSOLUTE_PATH/config_postfixadmin/config.inc.php /var/www/postfixadmin/
mysql -u root -pmysql postfix < $ABSOLUTE_PATH/config_postfixadmin/postfix.sql
cp /etc/postfix/main.cf /etc/postfix/main.cf_bak
cp -R $ABSOLUTE_PATH/config_postfix/* /etc/postfix
# Generation SSL #
cd /etc/ssl
#openssl genrsa -out ca.key.pem 4096
#openssl req -x509 -new -nodes -days 1460 -sha256 -key ca.key.pem -out ca.cert.pem
#openssl genrsa -out mailserver.key 4096
#openssl req -new -sha256 -key mailserver.key -out mailserver.csr
#openssl x509 -req -days 1460 -sha256 -in mailserver.csr -CA ca.cert.pem -CAkey ca.key.pem -CAcreateserial -out mailserver.crt
#chmod 444 ca.cert.pem
#chmod 444 mailserver.crt
#chmod 400 ca.key.pem
#chmod 400 mailserver.key
#mv ca.key.pem private/
#mv ca.cert.pem certs/
#mv mailserver.key private/
#mv mailserver.crt certs/
#openssl dhparam -out /etc/postfix/dh2048.pem 2048
#openssl dhparam -out /etc/postfix/dh512.pem 512
# A mettre au propre avec une bonne config
#Installation DOVECOT
apt-get install -y dovecot-core dovecot-imapd dovecot-lmtpd dovecot-mysql
mkdir -p /var/mail/vhosts/gira.labos-nantes.ovh
groupadd -g 5000 vmail 
useradd -g vmail -u 5000 vmail -d /var/mail
chown -R vmail:vmail /var/mail
cp -R $ABSOLUTE_PATH/config_dovecot/* /etc/dovecot
chown -R vmail:dovecot /etc/dovecot
chmod -R o-rwx /etc/dovecot 
service postfix restart
service dovecot restart