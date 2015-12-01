# Setup SMTP Server
# Update System
#apt-get update -y && apt-get upgrade -y
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
echo "\ngira.labos-nantes.ovh" >> /etc/hostname
/etc/init.d/hostname.sh start
echo "\n127.0.0.1 localhost.labos-nantes.ovh localhost" >> /etc/hosts
echo "\n192.168.56.101 gira.labos-nantes.ovh gira" >> /etc/hosts
echo "\norder hosts, bind" >> /etc/hosts.conf
echo "\nmulti on" >> /etc/hosts.conf
echo "\ndomain labos-nantes.ovh" >> /etc/resolv.conf
echo "\nsearch labos-nantes.ovh" >> /etc/resolv.conf
echo "\nnameserver 192.168.56.101" >> /etc/resolv.conf
apt-get install -y bind9 dnsutils
cp -R /media/sf_VMShared/TP-SMTP/config_bind9/* /etc/bind
service bind9 restart
mysql -u root -pmysql -e "CREATE database postfix;"
mysql -u root -pmysql -e "CREATE USER 'postfix'@'localhost' IDENTIFIED BY 'postfix';"
mysql -u root -pmysql -e "GRANT USAGE ON *.* TO 'postfix'@'localhost';"
mysql -u root -pmysql -e "GRANT ALL PRIVILEGES ON postfix.* TO 'postfix'@'localhost';"
cd /var/www
wget http://imoucheg.com/postfixadmin-2.93.tar.gz
tar -xzf postfixadmin-2.93.tar.gz
mv postfixadmin-2.93 postfixadmin
rm -rf postfixadmin-2.93.tar.gz
chown -R www-data:www-data postfixadmin
apt-get install -y php5-imap
cp /media/sf_VMShared/TP-SMTP/config_postfixadmin/postfixadmin.conf /etc/nginx/sites-enabled/
cp /media/sf_VMShared/TP-SMTP/config_postfixadmin/config.inc.php /var/www/postfixadmin/
service nginx restart