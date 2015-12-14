cd /tmp/
openssl genrsa -out ca.key.pem 4096 -subj '/CN=EPSI/O=EPSI/C=gira.labos-nantes.ovh'
openssl req -x509 -new -nodes -days 2048 -sha256 -key ca.key.pem -out ca.cert.pem -subj '/C=FR/ST=France/L=Nantes/O=EPSI/OU=EPSI/CN=gira.labos-nantes.ovh'
openssl genrsa -out mailserver.key 4096 -subj '/CN=EPSI/O=EPSI/C=gira.labos-nantes.ovh'
openssl req -new -sha256 -key mailserver.key -out mailserver.csr -subj '/C=FR/ST=France/L=Nantes/O=EPSI/OU=EPSI/CN=gira.labos-nantes.ovh'
openssl x509 -req -days 1460 -sha256 -in mailserver.csr -CA ca.cert.pem -CAkey ca.key.pem -CAcreateserial -out mailserver.crt
chmod 444 ca.cert.pem
chmod 444 mailserver.crt
chmod 400 ca.key.pem
chmod 400 mailserver.key
mv ca.key.pem private/
mv ca.cert.pem certs/
mv mailserver.key private/
mv mailserver.crt certs/
openssl dhparam -out /etc/postfix/dh2048.pem 2048
openssl dhparam -out /etc/postfix/dh512.pem 512