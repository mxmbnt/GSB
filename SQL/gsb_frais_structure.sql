-- Adminer 4.7.9 MySQL dump

SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

SET NAMES utf8mb4;

DROP TABLE IF EXISTS `Etat`;
CREATE TABLE `Etat` (
  `id` char(2) NOT NULL,
  `libelle` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `Etat` (`id`, `libelle`) VALUES
('CL',	'Saisie clôturée'),
('CR',	'Fiche créée, saisie en cours'),
('RB',	'Remboursée'),
('VA',	'Validée et mise en paiement');

DROP TABLE IF EXISTS `FicheFrais`;
CREATE TABLE `FicheFrais` (
  `idVisiteur` char(4) NOT NULL,
  `mois` char(6) NOT NULL,
  `nbJustificatifs` int(11) DEFAULT NULL,
  `montantValide` decimal(10,2) DEFAULT NULL,
  `dateModif` date DEFAULT NULL,
  `idEtat` char(2) DEFAULT 'CR',
  PRIMARY KEY (`idVisiteur`,`mois`),
  KEY `idEtat` (`idEtat`),
  CONSTRAINT `FicheFrais_ibfk_1` FOREIGN KEY (`idEtat`) REFERENCES `Etat` (`id`),
  CONSTRAINT `FicheFrais_ibfk_2` FOREIGN KEY (`idVisiteur`) REFERENCES `Visiteur` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `FicheFrais` (`idVisiteur`, `mois`, `nbJustificatifs`, `montantValide`, `dateModif`, `idEtat`) VALUES
('',	'02',	0,	0.00,	'2022-03-01',	'CL'),
('',	'03',	0,	0.00,	'2022-03-01',	'CR'),
('a131',	'02',	0,	0.00,	'2022-03-11',	'CL'),
('a131',	'03',	0,	0.00,	'2022-03-11',	'CR'),
('a17',	'03',	0,	0.00,	'2022-03-02',	'CR'),
('e10',	'03',	0,	0.00,	'2022-03-02',	'CR');

DROP TABLE IF EXISTS `FraisForfait`;
CREATE TABLE `FraisForfait` (
  `id` char(3) NOT NULL,
  `libelle` char(20) DEFAULT NULL,
  `montant` decimal(5,2) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `FraisForfait` (`id`, `libelle`, `montant`) VALUES
('ETP',	'Forfait Etape',	110.00),
('KM',	'Frais Kilométrique',	0.62),
('NUI',	'Nuitée Hôtel',	80.00),
('REP',	'Repas Restaurant',	25.00);

DROP TABLE IF EXISTS `LigneFraisForfait`;
CREATE TABLE `LigneFraisForfait` (
  `idVisiteur` char(4) NOT NULL,
  `mois` char(6) NOT NULL,
  `idFraisForfait` char(3) NOT NULL,
  `quantite` int(11) DEFAULT NULL,
  PRIMARY KEY (`idVisiteur`,`mois`,`idFraisForfait`),
  KEY `idFraisForfait` (`idFraisForfait`),
  CONSTRAINT `LigneFraisForfait_ibfk_1` FOREIGN KEY (`idVisiteur`, `mois`) REFERENCES `FicheFrais` (`idVisiteur`, `mois`),
  CONSTRAINT `LigneFraisForfait_ibfk_2` FOREIGN KEY (`idFraisForfait`) REFERENCES `FraisForfait` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `LigneFraisForfait` (`idVisiteur`, `mois`, `idFraisForfait`, `quantite`) VALUES
('a131',	'03',	'ETP',	0),
('a131',	'03',	'KM',	0),
('a131',	'03',	'NUI',	0),
('a131',	'03',	'REP',	0),
('a17',	'03',	'ETP',	25),
('a17',	'03',	'KM',	25),
('a17',	'03',	'NUI',	25),
('a17',	'03',	'REP',	25),
('e10',	'03',	'ETP',	1),
('e10',	'03',	'KM',	12),
('e10',	'03',	'NUI',	123),
('e10',	'03',	'REP',	1234);

DROP TABLE IF EXISTS `LigneFraisHorsForfait`;
CREATE TABLE `LigneFraisHorsForfait` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `idVisiteur` char(4) NOT NULL,
  `mois` char(6) NOT NULL,
  `libelle` varchar(100) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `montant` decimal(10,2) DEFAULT NULL,
  `modedepaiement` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idVisiteur` (`idVisiteur`,`mois`),
  KEY `date` (`date`),
  KEY `mdp` (`modedepaiement`),
  CONSTRAINT `LigneFraisHorsForfait_ibfk_1` FOREIGN KEY (`idVisiteur`, `mois`) REFERENCES `FicheFrais` (`idVisiteur`, `mois`),
  CONSTRAINT `LigneFraisHorsForfait_ibfk_2` FOREIGN KEY (`modedepaiement`) REFERENCES `ModePaim` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `LigneFraisHorsForfait` (`id`, `idVisiteur`, `mois`, `libelle`, `date`, `montant`, `modedepaiement`) VALUES
(1,	'e10',	'03',	'randiom',	'2022-03-02',	552.00,	1),
(2,	'a17',	'03',	'Maxime',	'2021-12-31',	250.00,	NULL);

DROP TABLE IF EXISTS `ModePaim`;
CREATE TABLE `ModePaim` (
  `id` int(11) NOT NULL,
  `lib` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `ModePaim` (`id`, `lib`) VALUES
(1,	'carte bleu'),
(2,	'cheque'),
(3,	'espece'),
(4,	'crypto');

DROP TABLE IF EXISTS `TypeEnergie`;
CREATE TABLE `TypeEnergie` (
  `libelleenergie` char(20) NOT NULL,
  PRIMARY KEY (`libelleenergie`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `TypeEnergie` (`libelleenergie`) VALUES
('thermique');

DROP TABLE IF EXISTS `Visiteur`;
CREATE TABLE `Visiteur` (
  `id` char(4) NOT NULL,
  `nom` char(30) DEFAULT NULL,
  `prenom` char(30) DEFAULT NULL,
  `login` char(20) DEFAULT NULL,
  `mdp` char(20) DEFAULT NULL,
  `adresse` char(30) DEFAULT NULL,
  `cp` char(5) DEFAULT NULL,
  `ville` char(30) DEFAULT NULL,
  `dateEmbauche` date DEFAULT NULL,
  `numero` varchar(20) DEFAULT NULL,
  `idVoiture` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `numero` (`numero`),
  KEY `idVoiture` (`idVoiture`),
  CONSTRAINT `Visiteur_ibfk_2` FOREIGN KEY (`idVoiture`) REFERENCES `Voiture` (`numero`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `Visiteur` (`id`, `nom`, `prenom`, `login`, `mdp`, `adresse`, `cp`, `ville`, `dateEmbauche`, `numero`, `idVoiture`) VALUES
('a131',	'Prevel',	'Laurian',	'laurian',	'salut',	'1 rue Petit',	'46200',	'Lalbenque',	'2005-12-21',	'0707070707',	NULL),
('a17',	'Bonnet',	'Maxime',	'maxime',	'maxime',	'1 rue Petit',	'46200',	'Lalbenque',	'1998-11-23',	'0789069142',	NULL),
('a55',	'Bedos',	'Christian',	'cbedos',	'gmhxd',	'1 rue Peranud',	'46250',	'Montcuq',	'1995-01-12',	'',	NULL),
('a93',	'Tusseau',	'Louis',	'ltusseau',	'ktp3s',	'22 rue des Ternes',	'46123',	'Gramat',	'2000-05-01',	'',	NULL),
('b13',	'Bentot',	'Pascal',	'pbentot',	'doyw1',	'11 allée des Cerises',	'46512',	'Bessines',	'1992-07-09',	'',	NULL),
('b16',	'Bioret',	'Luc',	'lbioret',	'hrjfs',	'1 Avenue gambetta',	'46000',	'Cahors',	'1998-05-11',	'',	NULL),
('b19',	'Bunisset',	'Francis',	'fbunisset',	'4vbnd',	'10 rue des Perles',	'93100',	'Montreuil',	'1987-10-21',	'',	NULL),
('b25',	'Bunisset',	'Denise',	'dbunisset',	's1y1r',	'23 rue Manin',	'75019',	'paris',	'2010-12-05',	'',	NULL),
('b28',	'Cacheux',	'Bernard',	'bcacheux',	'uf7r3',	'114 rue Blanche',	'75017',	'Paris',	'2009-11-12',	'',	NULL),
('b34',	'Cadic',	'Eric',	'ecadic',	'6u8dc',	'123 avenue de la République',	'75011',	'Paris',	'2008-09-23',	'',	NULL),
('b4',	'Charoze',	'Catherine',	'ccharoze',	'u817o',	'100 rue Petit',	'75019',	'Paris',	'2005-11-12',	'',	NULL),
('b50',	'Clepkens',	'Christophe',	'cclepkens',	'bw1us',	'12 allée des Anges',	'93230',	'Romainville',	'2003-08-11',	'',	NULL),
('b59',	'Cottin',	'Vincenne',	'vcottin',	'2hoh9',	'36 rue Des Roches',	'93100',	'Monteuil',	'2001-11-18',	'',	NULL),
('c14',	'Daburon',	'François',	'fdaburon',	'7oqpv',	'13 rue de Chanzy',	'94000',	'Créteil',	'2002-02-11',	'',	NULL),
('c3',	'De',	'Philippe',	'pde',	'gk9kx',	'13 rue Barthes',	'94000',	'Créteil',	'2010-12-14',	'',	NULL),
('c54',	'Debelle',	'Michel',	'mdebelle',	'od5rt',	'181 avenue Barbusse',	'93210',	'Rosny',	'2006-11-23',	'',	NULL),
('d13',	'Debelle',	'Jeanne',	'jdebelle',	'nvwqq',	'134 allée des Joncs',	'44000',	'Nantes',	'2000-05-11',	'',	NULL),
('d51',	'Debroise',	'Michel',	'mdebroise',	'sghkb',	'2 Bld Jourdain',	'44000',	'Nantes',	'2001-04-17',	'',	NULL),
('e10',	'coru',	'em',	'admin2',	'password',	'next',	'42170',	'st just',	'2022-03-02',	'',	NULL),
('e22',	'Desmarquest',	'Nathalie',	'ndesmarquest',	'f1fob',	'14 Place d Arc',	'45000',	'Orléans',	'2005-11-12',	'',	NULL),
('e24',	'Desnost',	'Pierre',	'pdesnost',	'4k2o5',	'16 avenue des Cèdres',	'23200',	'Guéret',	'2001-02-05',	'',	NULL),
('e39',	'Dudouit',	'Frédéric',	'fdudouit',	'44im8',	'18 rue de l église',	'23120',	'GrandBourg',	'2000-08-01',	'',	NULL),
('e49',	'Duncombe',	'Claude',	'cduncombe',	'qf77j',	'19 rue de la tour',	'23100',	'La souteraine',	'1987-10-10',	'',	NULL),
('e5',	'Enault-Pascreau',	'Céline',	'cenault',	'y2qdu',	'25 place de la gare',	'23200',	'Gueret',	'1995-09-01',	'',	NULL),
('e52',	'Eynde',	'Valérie',	'veynde',	'i7sn3',	'3 Grand Place',	'13015',	'Marseille',	'1999-11-01',	'',	NULL),
('f21',	'Finck',	'Jacques',	'jfinck',	'mpb3t',	'10 avenue du Prado',	'13002',	'Marseille',	'2001-11-10',	'',	NULL),
('f39',	'Frémont',	'Fernande',	'ffremont',	'xs5tq',	'4 route de la mer',	'13012',	'Allauh',	'1998-10-01',	'',	NULL),
('f4',	'Gest',	'Alain',	'agest',	'dywvt',	'30 avenue de la mer',	'13025',	'Berre',	'1985-11-01',	'',	NULL);

DROP TABLE IF EXISTS `Voiture`;
CREATE TABLE `Voiture` (
  `numero` varchar(20) NOT NULL,
  `type` char(20) DEFAULT NULL,
  PRIMARY KEY (`numero`),
  KEY `type` (`type`),
  CONSTRAINT `Voiture_ibfk_2` FOREIGN KEY (`type`) REFERENCES `TypeEnergie` (`libelleenergie`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
INSERT INTO `Voiture` (`numero`, `type`) VALUES
('aa-22',	'thermique');

-- 2022-03-15 07:43:15