-- MySQL dump 10.13  Distrib 5.5.46, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: postfix
-- ------------------------------------------------------
-- Server version	5.5.46-0+deb8u1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `postfix`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `postfix` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `postfix`;

--
-- Table structure for table `admin`
--

DROP TABLE IF EXISTS `admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `admin` (
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `superadmin` tinyint(1) NOT NULL DEFAULT '0',
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`username`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='Postfix Admin - Virtual Admins';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin`
--

LOCK TABLES `admin` WRITE;
/*!40000 ALTER TABLE `admin` DISABLE KEYS */;
INSERT INTO `admin` VALUES ('admin@gira.labos-nantes.ovh','$1$9ec5c07d$cdRNcyq9PFQglUwa6VimG.',1,'2015-12-09 14:03:01','2015-12-09 14:03:01',1);
/*!40000 ALTER TABLE `admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `alias`
--

DROP TABLE IF EXISTS `alias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `alias` (
  `address` varchar(255) NOT NULL,
  `goto` text NOT NULL,
  `domain` varchar(255) NOT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`address`),
  KEY `domain` (`domain`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='Postfix Admin - Virtual Aliases';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alias`
--

LOCK TABLES `alias` WRITE;
/*!40000 ALTER TABLE `alias` DISABLE KEYS */;
INSERT INTO `alias` VALUES ('abuse@gira.labos-nantes.ovh','admin@gira.labos-nantes.ovh','gira.labos-nantes.ovh','2015-12-09 14:04:04','2015-12-14 07:36:01',1),('hostmaster@gira.labos-nantes.ovh','admin@gira.labos-nantes.ovh','gira.labos-nantes.ovh','2015-12-09 14:04:04','2015-12-14 07:36:08',1),('postmaster@gira.labos-nantes.ovh','admin@gira.labos-nantes.ovh','gira.labos-nantes.ovh','2015-12-09 14:04:04','2015-12-14 07:36:14',1),('webmaster@gira.labos-nantes.ovh','admin@gira.labos-nantes.ovh','gira.labos-nantes.ovh','2015-12-09 14:04:04','2015-12-14 07:36:22',1),('a.rousseau@gira.labos-nantes.ovh','a.rousseau@gira.labos-nantes.ovh','gira.labos-nantes.ovh','2015-12-09 14:04:47','2015-12-09 14:04:47',1),('g.imouche@gira.labos-nantes.ovh','g.imouche@gira.labos-nantes.ovh','gira.labos-nantes.ovh','2015-12-09 14:05:12','2015-12-09 14:05:12',1),('admin@gira.labos-nantes.ovh','admin@gira.labos-nantes.ovh','gira.labos-nantes.ovh','2015-12-14 07:35:47','2015-12-14 07:35:47',1);
/*!40000 ALTER TABLE `alias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `alias_domain`
--

DROP TABLE IF EXISTS `alias_domain`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `alias_domain` (
  `alias_domain` varchar(255) NOT NULL,
  `target_domain` varchar(255) NOT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`alias_domain`),
  KEY `active` (`active`),
  KEY `target_domain` (`target_domain`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='Postfix Admin - Domain Aliases';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alias_domain`
--

LOCK TABLES `alias_domain` WRITE;
/*!40000 ALTER TABLE `alias_domain` DISABLE KEYS */;
/*!40000 ALTER TABLE `alias_domain` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `config`
--

DROP TABLE IF EXISTS `config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `config` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(20) NOT NULL DEFAULT '',
  `value` varchar(20) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 COMMENT='PostfixAdmin settings';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `config`
--

LOCK TABLES `config` WRITE;
/*!40000 ALTER TABLE `config` DISABLE KEYS */;
INSERT INTO `config` VALUES (1,'version','1795');
/*!40000 ALTER TABLE `config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `domain`
--

DROP TABLE IF EXISTS `domain`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `domain` (
  `domain` varchar(255) NOT NULL,
  `description` varchar(255) CHARACTER SET utf8 NOT NULL,
  `aliases` int(10) NOT NULL DEFAULT '0',
  `mailboxes` int(10) NOT NULL DEFAULT '0',
  `maxquota` bigint(20) NOT NULL DEFAULT '0',
  `quota` bigint(20) NOT NULL DEFAULT '0',
  `transport` varchar(255) NOT NULL,
  `backupmx` tinyint(1) NOT NULL DEFAULT '0',
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`domain`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='Postfix Admin - Virtual Domains';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `domain`
--

LOCK TABLES `domain` WRITE;
/*!40000 ALTER TABLE `domain` DISABLE KEYS */;
INSERT INTO `domain` VALUES ('ALL','',0,0,0,0,'',0,'2015-12-09 14:02:57','2015-12-09 14:02:57',1),('gira.labos-nantes.ovh','',10,10,10,2048,'virtual',0,'2015-12-09 14:04:04','2015-12-09 14:04:04',1);
/*!40000 ALTER TABLE `domain` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `domain_admins`
--

DROP TABLE IF EXISTS `domain_admins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `domain_admins` (
  `username` varchar(255) NOT NULL,
  `domain` varchar(255) NOT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  KEY `username` (`username`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='Postfix Admin - Domain Admins';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `domain_admins`
--

LOCK TABLES `domain_admins` WRITE;
/*!40000 ALTER TABLE `domain_admins` DISABLE KEYS */;
INSERT INTO `domain_admins` VALUES ('admin@gira.labos-nantes.ovh','ALL','2015-12-09 14:03:01',1);
/*!40000 ALTER TABLE `domain_admins` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fetchmail`
--

DROP TABLE IF EXISTS `fetchmail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fetchmail` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `domain` varchar(255) DEFAULT '',
  `mailbox` varchar(255) NOT NULL,
  `src_server` varchar(255) NOT NULL,
  `src_auth` enum('password','kerberos_v5','kerberos','kerberos_v4','gssapi','cram-md5','otp','ntlm','msn','ssh','any') DEFAULT NULL,
  `src_user` varchar(255) NOT NULL,
  `src_password` varchar(255) NOT NULL,
  `src_folder` varchar(255) NOT NULL,
  `poll_time` int(11) unsigned NOT NULL DEFAULT '10',
  `fetchall` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `keep` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `protocol` enum('POP3','IMAP','POP2','ETRN','AUTO') DEFAULT NULL,
  `usessl` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `sslcertck` tinyint(1) NOT NULL DEFAULT '0',
  `sslcertpath` varchar(255) CHARACTER SET utf8 DEFAULT '',
  `sslfingerprint` varchar(255) DEFAULT '',
  `extra_options` text,
  `returned_text` text,
  `mda` varchar(255) NOT NULL,
  `date` timestamp NOT NULL DEFAULT '2000-01-01 06:00:00',
  `created` timestamp NOT NULL DEFAULT '2000-01-01 06:00:00',
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `active` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fetchmail`
--

LOCK TABLES `fetchmail` WRITE;
/*!40000 ALTER TABLE `fetchmail` DISABLE KEYS */;
/*!40000 ALTER TABLE `fetchmail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log`
--

DROP TABLE IF EXISTS `log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `log` (
  `timestamp` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `username` varchar(255) NOT NULL,
  `domain` varchar(255) NOT NULL,
  `action` varchar(255) NOT NULL,
  `data` text NOT NULL,
  KEY `timestamp` (`timestamp`),
  KEY `domain_timestamp` (`domain`,`timestamp`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='Postfix Admin - Log';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log`
--

LOCK TABLES `log` WRITE;
/*!40000 ALTER TABLE `log` DISABLE KEYS */;
INSERT INTO `log` VALUES ('2015-12-09 14:03:01','SETUP.PHP (172.16.4.50)','','create_admin','admin@gira.labos-nantes.ovh'),('2015-12-09 14:04:04','admin@gira.labos-nantes.ovh (172.16.4.50)','gira.labos-nantes.ovh','create_domain','gira.labos-nantes.ovh'),('2015-12-09 14:04:47','admin@gira.labos-nantes.ovh (172.16.4.50)','gira.labos-nantes.ovh','create_alias','a.rousseau@gira.labos-nantes.ovh'),('2015-12-09 14:04:47','admin@gira.labos-nantes.ovh (172.16.4.50)','gira.labos-nantes.ovh','create_mailbox','a.rousseau@gira.labos-nantes.ovh'),('2015-12-09 14:05:12','admin@gira.labos-nantes.ovh (172.16.4.50)','gira.labos-nantes.ovh','create_alias','g.imouche@gira.labos-nantes.ovh'),('2015-12-09 14:05:12','admin@gira.labos-nantes.ovh (172.16.4.50)','gira.labos-nantes.ovh','create_mailbox','g.imouche@gira.labos-nantes.ovh'),('2015-12-14 07:35:47','admin@gira.labos-nantes.ovh (172.16.4.50)','gira.labos-nantes.ovh','create_alias','admin@gira.labos-nantes.ovh'),('2015-12-14 07:35:47','admin@gira.labos-nantes.ovh (172.16.4.50)','gira.labos-nantes.ovh','create_mailbox','admin@gira.labos-nantes.ovh'),('2015-12-14 07:36:01','admin@gira.labos-nantes.ovh (172.16.4.50)','gira.labos-nantes.ovh','edit_alias','abuse@gira.labos-nantes.ovh'),('2015-12-14 07:36:08','admin@gira.labos-nantes.ovh (172.16.4.50)','gira.labos-nantes.ovh','edit_alias','hostmaster@gira.labos-nantes.ovh'),('2015-12-14 07:36:14','admin@gira.labos-nantes.ovh (172.16.4.50)','gira.labos-nantes.ovh','edit_alias','postmaster@gira.labos-nantes.ovh'),('2015-12-14 07:36:22','admin@gira.labos-nantes.ovh (172.16.4.50)','gira.labos-nantes.ovh','edit_alias','webmaster@gira.labos-nantes.ovh');
/*!40000 ALTER TABLE `log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mailbox`
--

DROP TABLE IF EXISTS `mailbox`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mailbox` (
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `name` varchar(255) CHARACTER SET utf8 NOT NULL,
  `maildir` varchar(255) NOT NULL,
  `quota` bigint(20) NOT NULL DEFAULT '0',
  `local_part` varchar(255) NOT NULL,
  `domain` varchar(255) NOT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`username`),
  KEY `domain` (`domain`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='Postfix Admin - Virtual Mailboxes';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mailbox`
--

LOCK TABLES `mailbox` WRITE;
/*!40000 ALTER TABLE `mailbox` DISABLE KEYS */;
INSERT INTO `mailbox` VALUES ('a.rousseau@gira.labos-nantes.ovh','$1$f8b89e1b$Pi.9rZjX3ItmeIHEh8LWB/','Arthur Rousseau','gira.labos-nantes.ovh/a.rousseau/',0,'a.rousseau','gira.labos-nantes.ovh','2015-12-09 14:04:47','2015-12-09 14:04:47',1),('g.imouche@gira.labos-nantes.ovh','$1$50d4b40d$KtIAfegzBdvpQ/P9COeSg/','Guillaume Imouche','gira.labos-nantes.ovh/g.imouche/',0,'g.imouche','gira.labos-nantes.ovh','2015-12-09 14:05:12','2015-12-09 14:05:12',1),('admin@gira.labos-nantes.ovh','$1$f552573f$C2y3ArY.37hnd/vlltBg50','Administrator','gira.labos-nantes.ovh/admin/',0,'admin','gira.labos-nantes.ovh','2015-12-14 07:35:47','2015-12-14 07:35:47',1);
/*!40000 ALTER TABLE `mailbox` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `quota`
--

DROP TABLE IF EXISTS `quota`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `quota` (
  `username` varchar(255) NOT NULL,
  `path` varchar(100) NOT NULL,
  `current` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`username`,`path`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quota`
--

LOCK TABLES `quota` WRITE;
/*!40000 ALTER TABLE `quota` DISABLE KEYS */;
/*!40000 ALTER TABLE `quota` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `quota2`
--

DROP TABLE IF EXISTS `quota2`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `quota2` (
  `username` varchar(100) NOT NULL,
  `bytes` bigint(20) NOT NULL DEFAULT '0',
  `messages` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`username`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quota2`
--

LOCK TABLES `quota2` WRITE;
/*!40000 ALTER TABLE `quota2` DISABLE KEYS */;
/*!40000 ALTER TABLE `quota2` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vacation`
--

DROP TABLE IF EXISTS `vacation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `vacation` (
  `email` varchar(255) NOT NULL,
  `subject` varchar(255) CHARACTER SET utf8 NOT NULL,
  `body` text CHARACTER SET utf8 NOT NULL,
  `activefrom` timestamp NOT NULL DEFAULT '2000-01-01 06:00:00',
  `activeuntil` timestamp NOT NULL DEFAULT '2000-01-01 06:00:00',
  `cache` text NOT NULL,
  `domain` varchar(255) NOT NULL,
  `interval_time` int(11) NOT NULL DEFAULT '0',
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`email`),
  KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Postfix Admin - Virtual Vacation';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vacation`
--

LOCK TABLES `vacation` WRITE;
/*!40000 ALTER TABLE `vacation` DISABLE KEYS */;
/*!40000 ALTER TABLE `vacation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vacation_notification`
--

DROP TABLE IF EXISTS `vacation_notification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `vacation_notification` (
  `on_vacation` varchar(255) CHARACTER SET latin1 NOT NULL,
  `notified` varchar(255) CHARACTER SET latin1 NOT NULL,
  `notified_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`on_vacation`,`notified`),
  CONSTRAINT `vacation_notification_pkey` FOREIGN KEY (`on_vacation`) REFERENCES `vacation` (`email`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Postfix Admin - Virtual Vacation Notifications';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vacation_notification`
--

LOCK TABLES `vacation_notification` WRITE;
/*!40000 ALTER TABLE `vacation_notification` DISABLE KEYS */;
/*!40000 ALTER TABLE `vacation_notification` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2015-12-14  7:43:18
