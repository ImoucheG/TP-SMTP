CREATE DATABASE postfix;
CREATE USER 'postfix'@'localhost' IDENTIFIED BY 'postfix';
GRANT USAGE ON postfix.* TO 'postfix'@'localhost';
GRANT ALL PRIVILEGES ON postfix.* TO 'postfix'@'localhost';
FLUSH PRIVILEGES;