## Setup SMTP Server ##
## Update System ##
#apt-get update -y && apt-get upgrade -y
apt-get install sudo
adduser epsi sudo
adduser epsi root
## Install MysqlServer ##
debconf-set-selections <<< "mysql-server mysql-server/root_password password 3p$!"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password 3p$!"
apt-get install -y mysql-server
mysql_install_db
## Install Nginx ##
apt-get install -y nginx
apt-get install -y php5-fpm php5-mysql
service nginx restart
## DNS ##
