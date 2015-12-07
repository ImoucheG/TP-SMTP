# Setup SMTP Server
# Update System
cp -R ./config/ /tmp/
cd /tmp/TP-SMTP/

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
apt-get install -y php5-fpm php5-mysql php5-imap
service nginx restart

# Install Domain
cat ./config/misc/hostname >> /etc/hostname
service hostname start

cat ./config/misc/hosts >> /etc/hosts
cat ./config/misc/hosts.conf >> /etc/hosts.conf
cat ./config/misc/resolv.conf >> /etc/resolv.conf
apt-get install -y bind9 dnsutils
cp -R ./config/bind9/* /etc/bind/
service bind9 restart

# Install PostfixAdmin
#login : admin@labos-nantes.ovh
#password : admin2015
# !!!ATTENTION !!!Pour l'installation choisir : local only & comme domain : labos-nantes.ovh !!!!! ATTENTION
apt-get install -y postfix postfix-mysql
mysql -u root -pmysql < ./config/postfix/setup.sql
cd /var/www/
wget http://sourceforge.net/projects/postfixadmin/files/postfixadmin/postfixadmin-2.93/postfixadmin-2.93.tar.gz
tar -xzf postfixadmin-2.93.tar.gz
mv postfixadmin-2.93 postfixadmin
rm -rf postfixadmin-2.93.tar.gz
chown -R root:www-data postfixadmin

cd /tmp/TP-SMTP/
cp ./config/postfixadmin/postfixadmin.conf /etc/nginx/sites-enabled/
cp ./config/postfixadmin/config.inc.php /var/www/postfixadmin/
mysql -u root -pmysql postfix < ./config/postfixadmin/postfix.sql
service nginx restart

## COnfiguration Postfix
cp /etc/postfix/main.cf /etc/postfix/main.cf_bak
cp -R ./config/postfix/* /etc/postfix/

#Installation DOVECOT
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