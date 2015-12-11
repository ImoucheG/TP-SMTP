# Setup SMTP Server
# Update System
cp -R ./config/ /tmp/
cd /tmp/
#
#apt-get update -y && apt-get upgrade -y
apt-get install -y sudo

# Add user EPSI
useradd epsi
adduser epsi root
adduser epsi sudo

# BIND Installation
apt-get install resolvconf -y
cp ./config/misc/base /etc/resolvconf/resolv.conf.d/base
resolvconf -u

cp ./config/misc/hostname /etc/hostname
/etc/init.d/hostname.sh start

cp ./config/misc/hosts /etc/hosts
cp ./config/misc/hosts.conf /etc/hosts.conf

apt-get install -y bind9 dnsutils
cp -R ./config/bind9/* /etc/bind/
/etc/init.d/named restart
service bind9 restart

cp ./config/misc/interfaces /etc/network/interfaces
ifdown eth0 eth1
ifup eth0 eth1

# MySQL Server Installation
echo 'mysql-server mysql-server/root_password password mysql' | debconf-set-selections
echo 'mysql-server mysql-server/root_password_again password mysql' | debconf-set-selections
apt-get install -y mysql-server
mysql_install_db

# Apache Installation
apt-get install -y apache2
cat ./config/apache2/ports.conf >> /etc/apache2/ports.conf
cat ./config/apache2/000-default.conf >> /etc/apache2/sites-enabled/000-default.conf

# PHP Installation
apt-get install -y php5 libapache2-mod-php5 php5-fpm php5-mysql php5-imap

# Postfix Installation ('Local Only')
# Login : admin@labos-nantes.ovh (should be : admin@gira.labos-nantes.ovh ?)
# Password : admin2015
# Domain : hostone.gira.labos-nantes.ovh (should be : gira.labos-nantes.ovh ?)
apt-get install -y postfix postfix-mysql
wget http://sourceforge.net/projects/postfixadmin/files/postfixadmin/postfixadmin-2.93/postfixadmin-2.93.tar.gz
tar -xzf postfixadmin-2.93.tar.gz
mv postfixadmin-2.93 /var/www/postfixadmin
chown -R root:www-data /var/www/postfixadmin
chmod -R 775 /var/www/postfixadmin
mysql -u root -pmysql < ./config/postfix/setup.sql

# Password postfixadmin: postfix2015
# Users : 
#	- g.imouche@gira.labos-nantes.ovh::gimouche2015
#	- a.rousseau@gira.labos-nantes.ovh::arousseau2015
cp ./config/postfixadmin/config.inc.php /var/www/postfixadmin/
cp /etc/postfix/main.cf /etc/postfix/main.cf_bak
cp -R ./config/postfix/* /etc/postfix/
mysql -u root -pmysql postfix < ./config/postfixadmin/postfix.sql

# Generation SSL #
cd /tmp/config/ssl/
mv hostone.gira.labos-nantes.ovh.key /etc/ssl/private/
mv hostone.gira.labos-nantes.ovh.crt /etc/ssl/certs/
mv cakey.pem /etc/ssl/private/
mv cacert.pem /etc/ssl/certs/

service apache2 restart

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
cat ./config/misc/resolv.conf >> /etc/resolv.conf
service bind9 restart
service postfix restart
service dovecot restart