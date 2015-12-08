# Setup SMTP Server
# Update System
cp -R ./config/ /tmp/
cd /tmp/

apt-get update -y && apt-get upgrade -y
apt-get install -y sudo

# Add user EPSI
useradd epsi
adduser epsi root
adduser epsi sudo

# Install MySQL Server
echo 'mysql-server mysql-server/root_password password mysql' | debconf-set-selections
echo 'mysql-server mysql-server/root_password_again password mysql' | debconf-set-selections
apt-get install -y mysql-server
mysql_install_db

# Install Apache
apt-get install -y apache2

# Install PHP
apt-get install -y php5 libapache2-mod-php5 php5-fpm php5-mysql php5-imap
service apache2 restart

# Install Domain
apt-get install resolvconf -y
cp ./config/misc/resolv.conf /etc/resolvconf/resolv.conf.d/base

cp ./config/misc/hostname /etc/hostname
/etc/init.d/hostname.sh start

cp ./config/misc/hosts /etc/hosts
cp ./config/misc/hosts.conf /etc/hosts.conf

apt-get install -y bind9 dnsutils
cp -R ./config/bind9/* /etc/bind/
service bind9 restart

cp ./config/misc/interfaces /etc/network/interfaces
ifdown eth0 eth1
ifup eth0 eth1

# Install PostfixAdmin
#login : admin@labos-nantes.ovh
#password : admin2015
# LOCAL ONLY & DOMAIN : hostone.gira.labos-nantes.ovh 
apt-get install -y postfix postfix-mysql
mysql -u root -pmysql < ./config/postfix/setup.sql
cd /var/www/

wget http://sourceforge.net/projects/postfixadmin/files/postfixadmin/postfixadmin-2.93/postfixadmin-2.93.tar.gz
tar -xzf postfixadmin-2.93.tar.gz
mv postfixadmin-2.93 postfixadmin
rm -rf postfixadmin-2.93.tar.gz
chown -R root:root postfixadmin

cd /tmp/
# Configuration PostfixAdmin #
service apache2 restart
# VirtualHost APACHE 2.0 #
# Listen 8080 #
cat ./config/apache2/ports.conf >> /etc/apache2/ports.conf
cat ./config/apache2/000-default.conf >> /etc/apache2/sites-enabled/000-default.conf

# Restart Apache #
service apache2 restart
# Password postfixadmin: postfix2015
# User : g.imouche@gira.labos-nantes.ovh::gimouche2015 // a.rousseau@gira.labos-nantes.ovh::arousseau2015

cp ./config/postfixadmin/config.inc.php /var/www/postfixadmin/
mysql -u root -pmysql postfix < ./config/postfixadmin/postfix.sql
cp /etc/postfix/main.cf /etc/postfix/main.cf_bak
cp -R ./config/postfix/* /etc/postfix/
# Generation SSL #
# cd /etc/ssl
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

cd /tmp/
apt-get install -y dovecot-core dovecot-imapd dovecot-lmtpd dovecot-mysql
mkdir -p /var/mail/vhosts/labos-nantes.ovh
groupadd -g 5000 vmail
useradd -g vmail -u 5000 vmail -d /var/mail/
chown -R vmail:vmail /var/mail/
cp -R ./config/dovecot/* /etc/dovecot/
chown -R vmail:dovecot /etc/dovecot/
chmod -R o-rwx /etc/dovecot/
service postfix restart
service dovecot restart