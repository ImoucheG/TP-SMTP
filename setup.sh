# Setup SMTP Server
# Update System
cp -R ./config/ /tmp/
cd /tmp/
#
apt-get update -y && apt-get upgrade -y
apt-get install -y sudo

# SSH Configuration
apt-get install -y openssh-server
cp ./config/ssh/sshd_config /etc/ssh/sshd_config

# BIND Installation
apt-get install resolvconf -y
cp ./config/misc/base /etc/resolvconf/resolv.conf.d/base
resolvconf -u

cp ./config/misc/hostname /etc/hostname
/etc/init.d/hostname.sh start

cp ./config/misc/hosts /etc/hosts
cp ./config/misc/hosts.conf /etc/hosts.conf

apt-get install -y bind9 dnsutils
cp -r ./config/bind9/* /etc/bind/
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
# Domain : server.gira.labos-nantes.ovh (should be : gira.labos-nantes.ovh ?)
apt-get install -y postfix postfix-mysql
wget http://imoucheg.com/postfixadmin-2.93.tar.gz
tar -xzf postfixadmin-2.93.tar.gz
mv postfixadmin-2.93 /var/www/postfixadmin
mysql -u root -pmysql < ./config/postfix/setup.sql
chown -R root:www-data /var/www/postfixadmin/
chmod -R 775 /var/www/postfixadmin/

# Password postfixadmin: postfix2015
# Users : 
#	- g.imouche@gira.labos-nantes.ovh::gimouche2015
#	- a.rousseau@gira.labos-nantes.ovh::arousseau2015
#	- admin@gira.labos-nantes.ovh::admin2015
cp ./config/postfixadmin/config.inc.php /var/www/postfixadmin/
cp /etc/postfix/main.cf /etc/postfix/main.cf_bak
cp -r ./config/postfix/* /etc/postfix/
mysql -u root -pmysql postfix < ./config/postfixadmin/postfix.sql

# SSL certificates generation
openssl genrsa -out ca.key.pem 4096 -subj '/CN=EPSI/O=EPSI/C=mail.gira.labos-nantes.ovh'
openssl req -x509 -new -nodes -days 2048 -sha256 -key ca.key.pem -out ca.cert.pem -subj '/C=FR/ST=France/L=Nantes/O=EPSI/OU=EPSI/CN=mail.gira.labos-nantes.ovh'
openssl genrsa -out mailserver.key 4096 -subj '/CN=EPSI/O=EPSI/C=mail.gira.labos-nantes.ovh'
openssl req -new -sha256 -key mailserver.key -out mailserver.csr -subj '/C=FR/ST=France/L=Nantes/O=EPSI/OU=EPSI/CN=mail.gira.labos-nantes.ovh'
openssl x509 -req -days 1460 -sha256 -in mailserver.csr -CA ca.cert.pem -CAkey ca.key.pem -CAcreateserial -out mailserver.crt
chmod 444 ca.cert.pem
chmod 444 mailserver.crt
chmod 400 ca.key.pem
chmod 400 mailserver.key
mv ca.key.pem /etc/ssl/private/
mv ca.cert.pem /etc/ssl/certs/
mv mailserver.key /etc/ssl/private/
mv mailserver.crt /etc/ssl/certs/
openssl dhparam -out /etc/postfix/dh2048.pem 2048
openssl dhparam -out /etc/postfix/dh512.pem 512

# Dovecot Installation
apt-get install -y dovecot-core dovecot-imapd dovecot-lmtpd dovecot-mysql
mkdir -p /var/mail/vhosts/gira.labos-nantes.ovh
groupadd -g 5000 vmail
useradd -g vmail -u 5000 vmail -d /var/mail/
chown -R vmail:vmail /var/mail/
cp -r ./config/dovecot/* /etc/dovecot/
chown -R vmail:dovecot /etc/dovecot/
chmod -R o-rwx /etc/dovecot/

# Spamassassin Installation
apt-get install -y spamc spamassassin --fix-missing
groupadd spamassassin
useradd -s /sbin/nologin -d /usr/local/spamassassin -g spamassassin spamassassin
mkdir -p /usr/local/spamassassin/log
chown spamassassin:spamassassin -R /usr/local/spamassassin.
# Configuration files not used due to amavis spamassassin daemon
#cp ./config/spamassassin/spamassassin /etc/default/spamassassin
#cp ./config/spamassassin/local.cf /etc/spamassassin/local.cf

# ClamAV Installation
apt-get install -y clamav clamav-daemon clamav-freshclam
/etc/init.d/clamav-daemon stop
#feshclam # commented due to time it takes

# Amavis Installation
apt-get install -y amavisd-new
cp ./config/amavis/05-node_id /etc/amavis/conf.d/05-node_id
apt-get install -y amavisd-new
chmod 775 -R /var/lib/amavis/tmp/
adduser clamav amavis
adduser amavis clamav
cp ./config/clamav/clamd.conf /etc/clamav/clamd.conf
cp ./config/amavis/15-content_filter_mode /etc/amavis/conf.d/15-content_filter_mode
cp ./config/amavis/50-user /etc/amavis/conf.d/50-user

# Roundcube installation
wget http://sourceforge.net/projects/roundcubemail/files/roundcubemail/1.1.3/roundcubemail-1.1.3-complete.tar.gz
tar -xzf roundcubemail-1.1.3-complete.tar.gz
mv roundcubemail-1.1.3 /var/www/roundcube
mysql -u root -pmysql < ./config/roundcube/setup.sql
mysql -u root -pmysql -Droundcubemail < /var/www/roundcube/SQL/mysql.initial.sql
cp ./config/roundcube/config.inc.php /var/www/rouncube/config/
chown -R root:www-data /var/www/roundcube/
chmod -R 775 /var/www/roundcube/

# Reload configuration
/etc/init.d/apache2 reload
/etc/init.d/amavis force-reload
/etc/init.d/bind9 reload
/etc/init.d/clamav-daemon reload
/etc/init.d/spamassassin reload
/etc/init.d/postfix reload
/etc/init.d/dovecot reload

# Restart daemon
/etc/init.d/apache2 restart
/etc/init.d/bind9 restart
/etc/init.d/clamav-daemon restart
/etc/init.d/amavis restart
/etc/init.d/spamassassin restart
/etc/init.d/postfix restart
/etc/init.d/dovecot restart
echo "The mailserver is installed"
