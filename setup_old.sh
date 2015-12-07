# Setup SMTP Server
# Update System
apt-get update -y && apt-get upgrade -y
apt-get install -y sudo
# Add user EPSI
useradd epsi
adduser epsi root
adduser epsi sudo
# Install MysqlServer
echo 'mysql-server mysql-server/root_password password mysql' | debconf-set-selections
echo 'mysql-server mysql-server/root_password_again password mysql' | debconf-set-selections
apt-get install -y mysql-server
mysql_install_db
# Install Nginx
apt-get install -y nginx
# Install PHP
apt-get install -y php5-fpm php5-mysql
service nginx restart
# Install Domain
echo "\nhostone.labos-nantes.ovh" >> /etc/hostname
/etc/init.d/hostname.sh start
echo "\n127.0.0.1 localhost.labos-nantes.ovh localhost" >> /etc/hosts
echo "\n192.168.56.101 hostone.labos-nantes.ovh hostone" >> /etc/hosts
echo "\norder hosts, bind" >> /etc/hosts.conf
echo "\nmulti on" >> /etc/hosts.conf
echo "\ndomain labos-nantes.ovh" >> /etc/resolv.conf
echo "\nsearch labos-nantes.ovh" >> /etc/resolv.conf
echo "\nnameserver 192.168.56.101" >> /etc/resolv.conf
apt-get install -y bind9 dnsutils
cp -R /media/sf_VMShared/TP-SMTP/config_bind9/* /etc/bind
service bind9 restart
# Install PostfixAdmin
#login : admin@labos-nantes.ovh
#password : admin2015
# !!!ATTENTION !!!Pour l'installation choisir : local only & comme domain : labos-nantes.ovh !!!!! ATTENTION
apt-get install -y postfix postfix-mysql
mysql -u root -pmysql -e "CREATE database postfix;"
mysql -u root -pmysql -e "CREATE USER 'postfix'@'localhost' IDENTIFIED BY 'postfix';"
mysql -u root -pmysql -e "GRANT USAGE ON *.* TO 'postfix'@'localhost';"
mysql -u root -pmysql -e "GRANT ALL PRIVILEGES ON postfix.* TO 'postfix'@'localhost';"
cd /var/www
wget http://sourceforge.net/projects/postfixadmin/files/postfixadmin/postfixadmin-2.93/postfixadmin-2.93.tar.gz
tar -xzf postfixadmin-2.93.tar.gz
mv postfixadmin-2.93 postfixadmin
rm -rf postfixadmin-2.93.tar.gz
chown -R root:www-data postfixadmin
apt-get install -y php5-imap
cp /media/sf_VMShared/TP-SMTP/config_postfixadmin/postfixadmin.conf /etc/nginx/sites-enabled/
cp /media/sf_VMShared/TP-SMTP/config_postfixadmin/config.inc.php /var/www/postfixadmin/
mysql -u root -pmysql postfix < /media/sf_VMShared/TP-SMTP/config_postfixadmin/postfix.sql
service nginx restart
## COnfiguration Postfix
cp /etc/postfix/main.cf /etc/postfix/main.cf_bak
cp -R /media/sf_VMShared/TP-SMTP/config_postfix/* /etc/postfix
#Installation DOVECOT
apt-get install -y dovecot-core dovecot-imapd dovecot-lmtpd dovecot-mysql
mkdir -p /var/mail/vhosts/labos-nantes.ovh
groupadd -g 5000 vmail 
useradd -g vmail -u 5000 vmail -d /var/mail
chown -R vmail:vmail /var/mail
cp -R /media/sf_VMShared/TP-SMTP/conf_dovecot/* /etc/dovecot
chown -R vmail:dovecot /etc/dovecot
chmod -R o-rwx /etc/dovecot 
service postfix restart
service dovecot restart