

CREATE TABLE IF NOT EXISTS cric_bloc (
  id int(10) unsigned NOT NULL AUTO_INCREMENT,
  x smallint(6) DEFAULT NULL,
  y smallint(6) DEFAULT NULL,
  width smallint(6) DEFAULT NULL,
  height smallint(6) DEFAULT NULL,
  content longtext NOT NULL,
  id_mag int(11) NOT NULL DEFAULT '0',
  id_page int(11) NOT NULL DEFAULT '0',
  `type` varchar(3) NOT NULL,
  `level` tinyint(4) NOT NULL,
  PRIMARY KEY (id)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 ;



CREATE TABLE IF NOT EXISTS cric_page (
  id int(10) unsigned NOT NULL AUTO_INCREMENT,
  page tinyint(3) NOT NULL DEFAULT '0',
  id_mag int(11) NOT NULL DEFAULT '0',
  title varchar(150) NOT NULL,
  PRIMARY KEY (id)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 ;
