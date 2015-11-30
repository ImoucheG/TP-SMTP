# Setup SMTP Server
# Update System
apt-get update -y && apt-get upgrade -y
apt-get install -y sudo
# Add user EPSI
useradd epsi
adduser epsi root
adduser epsi sudo
# Install MysqlServer
echo 'mysql-server mysql-server/root_password password 3p$!' | debconf-set-selections
echo 'mysql-server mysql-server/root_password_again password 3p$!' | debconf-set-selections
apt-get install -y mysql-server
mysql_install_db
# Install Nginx
apt-get install -y nginx
# Install PHP
apt-get install -y php5-fpm php5-mysql
service nginx restart
#Domain

