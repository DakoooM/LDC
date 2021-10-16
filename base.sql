CREATE TABLE `players` (
  `Id` int(11) NOT NULL,
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
  `status` longtext DEFAULT '{"water":100,"hunger":100}'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `players` (`Id`, `license`, `name`, `grade`, `money`, `bank_money`, `inventory`, `skin`, `clothes`, `job`, `job_grade`, `pos`, `status`) VALUES
(126, 'license:19ed2979f14577b17d851f7760196458e38a20fb', '{\"ddn\":\"23/03/1994\",\"prenom\":\"Joseph\",\"nom\":\"Albert\",\"taille\":193}', 'dev', 3390, 13000, '{\"WEAPON_PISTOL\":{\"count\":3,\"name\":\"WEAPON_PISTOL\",\"label\":\"Pistolet\"},\"bread\":{\"count\":37,\"name\":\"bread\",\"label\":\"Pain\"}}', '{\"mom\":3,\"eyesbrowColor\":1,\"beard\":2,\"makeup\":3,\"ageing\":3,\"blemishes\":1,\"beardColor\":1,\"dad\":2,\"lipstickColor\":1,\"resem\":0.5,\"sex\":1,\"face\":0.5,\"eyesColor\":3,\"hairColor\":1,\"eyesbrow\":2,\"lipstick\":1,\"hair\":2}', '{\"shoes2\":0,\"torso2\":0,\"pants2\":0,\"tshirts2\":0,\"pants\":24,\"tshirts\":4,\"arms\":27,\"torso\":3,\"shoes\":10}', 'unemployed', 1, '{\"y\":-1033.6351318359376,\"x\":222.05274963378907,\"w\":170.0787353515625,\"z\":29.3641357421875}', '{\"water\":0,\"hunger\":65}'),
(128, 'license:d3335a3aa03572bcb7c721629cb81a1e953989ad', '{\"taille\":150,\"ddn\":\"15/02/2000\",\"prenom\":\"KADOR\",\"nom\":\"Dakor\"}', 'dev', 4850, 12500, '{\"WEAPON_PISTOL\":{\"count\":1,\"name\":\"WEAPON_PISTOL\",\"label\":\"Pistolet\"},\"ammobox\":{\"count\":176,\"name\":\"ammobox\",\"label\":\"Boite de munitions\"}}', '{\"sex\":1,\"hair\":21,\"mom\":3,\"eyesbrowColor\":1,\"eyesColor\":32,\"beardColor\":1,\"beard\":27,\"dad\":4,\"lipstickColor\":1,\"hairColor\":1,\"resem\":0.5,\"face\":0.5}', '{\"torso2\":3,\"shoes2\":0,\"arms\":12,\"pants\":24,\"tshirts2\":0,\"shoes\":10,\"pants2\":0,\"tshirts\":15,\"torso\":111}', 'unemployed', 1, '{\"x\":-1.38461685180664,\"y\":-904.7077026367188,\"z\":30.4425048828125,\"w\":161.57479858398438}', '{\"hunger\":96,\"water\":0}');

CREATE TABLE `player_veh` (
  `id` int(11) NOT NULL,
  `owner` longtext NOT NULL,
  `plate` longtext DEFAULT '0',
  `model` longtext DEFAULT NULL,
  `label` longtext DEFAULT NULL,
  `color1` longtext DEFAULT NULL,
  `color2` longtext DEFAULT NULL,
  `parked` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `player_veh` (`id`, `owner`, `plate`, `model`, `label`, `color1`, `color2`, `parked`) VALUES
(30, 'license:d3335a3aa03572bcb7c721629cb81a1e953989ad', '46OOG309', 'f620', NULL, '[]', '[]', 0),
(31, 'license:d3335a3aa03572bcb7c721629cb81a1e953989ad', '75ZDQ413', 'zion2', NULL, '[]', '[]', 0),
(32, 'license:d3335a3aa03572bcb7c721629cb81a1e953989ad', '75JTC712', 'oracle', NULL, '[]', '[]', 1),
(33, 'license:d3335a3aa03572bcb7c721629cb81a1e953989ad', '45TTE448', 'sentinel', NULL, '{\"CouleurRed\":167,\"CouleurBlue\":105,\"CouleurGreen\":147}', '{\"CouleurRed\":100,\"CouleurBlue\":10,\"CouleurGreen\":15}', 1);

CREATE TABLE `society_accounts` (
  `id` int(11) NOT NULL,
  `society` varchar(50) DEFAULT NULL,
  `money` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `players`
  ADD PRIMARY KEY (`Id`) USING BTREE;

ALTER TABLE `player_veh`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `society_accounts`
  ADD PRIMARY KEY (`id`) USING BTREE;

ALTER TABLE `players`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=129;

ALTER TABLE `player_veh`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

ALTER TABLE `society_accounts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;