-- --------------------------------------------------------
-- Hôte :                        127.0.0.1
-- Version du serveur:           10.4.13-MariaDB - mariadb.org binary distribution
-- SE du serveur:                Win64
-- HeidiSQL Version:             11.0.0.5919
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Listage de la structure de la base pour afrw
CREATE DATABASE IF NOT EXISTS `LDC` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `LDC`;

-- Listage de la structure de la table afrw. items
CREATE TABLE IF NOT EXISTS `items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `typeitems` longtext DEFAULT NULL,
  `pos` varchar(255) DEFAULT NULL,
  `player` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

-- Listage des données de la table afrw.items : ~0 rows (environ)
/*!40000 ALTER TABLE `items` DISABLE KEYS */;
INSERT INTO `items` (`id`, `typeitems`, `pos`, `player`) VALUES
	(1, '1', '{"z":30.99853515625,"w":328.81890869140627,"x":213.70550537109376,"y":-809.3142700195313}', NULL);
/*!40000 ALTER TABLE `items` ENABLE KEYS */;

-- Listage de la structure de la table afrw. players
CREATE TABLE IF NOT EXISTS `players` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `license` varchar(255) NOT NULL DEFAULT '0',
  `name` varchar(255) NOT NULL,
  `grade` varchar(100) DEFAULT NULL,
  `money` int(11) DEFAULT NULL,
  `bank_money` int(11) DEFAULT NULL,
  `inventory` text NOT NULL,
  `skin` longtext DEFAULT NULL,
  `clothes` longtext DEFAULT NULL,
  `job` varchar(50) DEFAULT NULL,
  `job_grade` int(11) DEFAULT NULL,
  `pos` varchar(255) DEFAULT NULL,
  `status` longtext DEFAULT NULL,
  `vip` int(11) DEFAULT 0,
  PRIMARY KEY (`Id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=127 DEFAULT CHARSET=utf8;

-- Listage des données de la table afrw.players : ~0 rows (environ)
/*!40000 ALTER TABLE `players` DISABLE KEYS */;
INSERT INTO `players` (`Id`, `license`, `name`, `grade`, `money`, `bank_money`, `inventory`, `skin`, `clothes`, `job`, `job_grade`, `pos`, `status`, `vip`) VALUES
	(126, 'license:19ed2979f14577b17d851f7760196458e38a20fb', '{"taille":193,"nom":"Albert","prenom":"Joseph","ddn":"23/03/1994"}', 'dev', 4000, 13000, '{"bread":{"label":"Pain","name":"bread","count":28},"WEAPON_PISTOL50":{"label":"Pistolet calibre 50","name":"WEAPON_PISTOL50","count":1}}', '{"dad":2,"ageing":3,"eyesbrow":2,"blemishes":1,"makeup":81,"eyesbrowColor":1,"resem":0.5,"beard":2,"mom":3,"sex":1,"lipstick":10,"hair":2,"hairColor":1,"beardColor":1,"face":0.5,"lipstickColor":1,"eyesColor":3}', '{"pants2":0,"shoes2":0,"arms":27,"tshirts2":0,"shoes":10,"tshirts":4,"torso2":0,"torso":3,"pants":24}', 'unemployed', 1, '{"w":158.7401580810547,"z":30.846923828125,"y":-795.3098754882813,"x":213.6527557373047}', '{"water":63,"hunger":63}', 1);
/*!40000 ALTER TABLE `players` ENABLE KEYS */;

-- Listage de la structure de la table afrw. players_clothes
CREATE TABLE IF NOT EXISTS `players_clothes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `license` varchar(100) DEFAULT NULL,
  `label` varchar(100) DEFAULT NULL,
  `value` longtext DEFAULT NULL,
  `type` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=90 DEFAULT CHARSET=utf8mb4;

-- Listage des données de la table afrw.players_clothes : ~0 rows (environ)
/*!40000 ALTER TABLE `players_clothes` DISABLE KEYS */;
/*!40000 ALTER TABLE `players_clothes` ENABLE KEYS */;

-- Listage de la structure de la table afrw. player_veh
CREATE TABLE IF NOT EXISTS `player_veh` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner` longtext NOT NULL,
  `plate` longtext DEFAULT '0',
  `model` longtext DEFAULT NULL,
  `label` longtext DEFAULT NULL,
  `color1` longtext DEFAULT NULL,
  `color2` longtext DEFAULT NULL,
  `parked` int(11) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=latin1;

-- Listage des données de la table afrw.player_veh : ~1 rows (environ)
/*!40000 ALTER TABLE `player_veh` DISABLE KEYS */;
INSERT INTO `player_veh` (`id`, `owner`, `plate`, `model`, `label`, `color1`, `color2`, `parked`) VALUES
	(25, 'license:19ed2979f14577b17d851f7760196458e38a20fb', '35SHL509', 'blista', NULL, '[]', '[]', 1);
/*!40000 ALTER TABLE `player_veh` ENABLE KEYS */;

-- Listage de la structure de la table afrw. properties
CREATE TABLE IF NOT EXISTS `properties` (
  `propertyID` int(11) NOT NULL AUTO_INCREMENT,
  `owner` varchar(100) DEFAULT NULL,
  `ownerName` varchar(100) DEFAULT NULL,
  `label` varchar(100) NOT NULL,
  `tower_label` varchar(100) DEFAULT NULL,
  `price` int(11) DEFAULT NULL,
  `entering` varchar(255) DEFAULT NULL,
  `interiors` int(11) DEFAULT NULL,
  `propertyType` int(11) DEFAULT NULL,
  `propertyMoney` int(11) DEFAULT 0,
  `maxStorage` int(11) DEFAULT 0,
  PRIMARY KEY (`propertyID`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4;

-- Listage des données de la table afrw.properties : ~2 rows (environ)
/*!40000 ALTER TABLE `properties` DISABLE KEYS */;
INSERT INTO `properties` (`propertyID`, `owner`, `ownerName`, `label`, `tower_label`, `price`, `entering`, `interiors`, `propertyType`, `propertyMoney`, `maxStorage`) VALUES
	(33, '-', '-', 'Matriix', NULL, 200, '{"x":-9.11,"y":-1090.72,"z":26.67}', 2, 1, 0, 250),
	(34, '-', '-', 'Alexi', NULL, 100, '{"y":-1090.4,"z":26.67,"x":-9.97}', 1, 1, 0, 50);
/*!40000 ALTER TABLE `properties` ENABLE KEYS */;

-- Listage de la structure de la table afrw. society_accounts
CREATE TABLE IF NOT EXISTS `society_accounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `society` varchar(50) DEFAULT NULL,
  `money` int(11) DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;

-- Listage des données de la table afrw.society_accounts : ~0 rows (environ)
/*!40000 ALTER TABLE `society_accounts` DISABLE KEYS */;
/*!40000 ALTER TABLE `society_accounts` ENABLE KEYS */;

-- Listage de la structure de la table afrw. typeitems
CREATE TABLE IF NOT EXISTS `typeitems` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `label` longtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

-- Listage des données de la table afrw.typeitems : ~0 rows (environ)
/*!40000 ALTER TABLE `typeitems` DISABLE KEYS */;
INSERT INTO `typeitems` (`id`, `name`, `label`) VALUES
	(1, 'pain', 'Pain');
/*!40000 ALTER TABLE `typeitems` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
