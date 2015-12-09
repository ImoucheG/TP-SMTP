CREATE database postfix;
CREATE USER 'postfix'@'localhost' IDENTIFIED BY 'postfix';
GRANT USAGE ON *.* TO 'postfix'@'localhost';
GRANT ALL PRIVILEGES ON postfix.* TO 'postfix'@'localhost';