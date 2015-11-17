Script utilisé sous Debian 8.

# On met à jour le poste#
apt-get update -y && apt-get upgrade -y

# On installe MySqlServer #
debconf-set-selections <<< 'mysql-server mysql-server/root_password password 3p$!’
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password 3p$!’
apt-get install -y mysql-server
# On installe apache 2 #
apt-get install -y apache2
# On installe PHP avec ses dépendances # 
apt-get  install -y php5 libapache2-mod-php5
# On redémarre le serveur apache #
service apache2 restart
