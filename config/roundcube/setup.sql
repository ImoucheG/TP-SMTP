CREATE DATABASE roundcubemail;
CREATE USER 'roundcube'@'localhost' IDENTIFIED BY 'roundcube';
GRANT ALL PRIVILEGES ON roundcubemail.* TO roundcube@localhost IDENTIFIED BY 'roundcube';
FLUSH PRIVILEGES;