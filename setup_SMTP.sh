## Setup SMTP Server ##
## Update System ##
apt-get update -y && apt-get upgrade -y
apt-get install sudo
adduser epsi sudo
adduser epsi root
## Install MysqlServer ##
su epsi
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password 3p$!"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password 3p$!"
sudo apt-get install -y mysql-server
sudo mysql_install_db
## Install Nginx ##
sudo apt-get install -y nginx
sudo apt-get install -y php5-fpm php5-mysql
service nginx restart
## DNS ## 