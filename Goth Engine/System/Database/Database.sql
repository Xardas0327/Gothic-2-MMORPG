DROP DATABASE IF EXISTS gothic;
CREATE DATABASE gothic;
USE gothic;

create table account (
	accname VARCHAR(64) PRIMARY KEY NOT NULL,
	pswd BINARY(32) NOT NULL,
	`admin` INT NOT NULL DEFAULT 0,
	zone INT DEFAULT 0,
	lastlogin DATE DEFAULT NULL
);

create table characters (
	accname VARCHAR(64) NOT NULL,
	servername VARCHAR(64) NOT NULL,
	charid INT NOT NULL,
	charname VARCHAR(64) NOT NULL,
	body_type VARCHAR(64) NOT NULL,
	body_id INT NOT NULL,
	face_type VARCHAR(64) NOT NULL,
	face_id INT NOT NULL,
	fatness FLOAT(3,1) NOT NULL DEFAULT 0.0,
	lastlogin DATE DEFAULT NULL,
	PRIMARY KEY (charname,servername),
	FOREIGN KEY (accname) REFERENCES account(accname)
);

create table character_stat(
	servername VARCHAR(64) NOT NULL,
	charname VARCHAR(64) NOT NULL,
	lvl INT DEFAULT 0,
	mc INT DEFAULT 0,
	xp INT DEFAULT 0,
	nextlvl INT DEFAULT 500,
	lp INT DEFAULT 0,
	str INT DEFAULT 10,
	dex INT DEFAULT 10,
	hp INT DEFAULT 40,
	maxhp INT DEFAULT 40,
	mana INT DEFAULT 10,
	maxmana INT DEFAULT 10,
	oneh INT DEFAULT 10,
	twoh INT DEFAULT 10,
	bow INT DEFAULT 10,
	cbow INT DEFAULT 10,
	acrobatic INT DEFAULT 0,
	PRIMARY KEY (charname,servername),
	FOREIGN KEY (charname,servername) REFERENCES characters(charname,servername)
);

create table character_spawn(
	servername VARCHAR(64) NOT NULL,
	charname VARCHAR(64) NOT NULL,
	x INT NOT NULL,
	y INT NOT NULL,
	z INT NOT NULL,
	angle INT NOT NULL,
	PRIMARY KEY (charname,servername),
	FOREIGN KEY (charname,servername) REFERENCES characters(charname,servername)
);

create table character_spawn_init(
	servername VARCHAR(64) NOT NULL,
	id INT NOT NULL,
	x INT NOT NULL,
	y INT NOT NULL,
	z INT NOT NULL,
	angle INT NOT NULL,
	PRIMARY KEY(servername,id)
);

/* character item template 
	Only the table's name is changed.
	The server create the tables.
	
create table servername_charactername_item(
	itemid VARCHAR(64) PRIMARY KEY,
	amount INT NOT NULL, 
	equipped INT DEFAULT 0);
*/

/* character quest template 
	Only the table's name is changed.
	The server create the tables.
	
create table servername_charactername_quest(
	npc VARCHAR(64) PRIMARY KEY,
	current INT DEFAULT 0,
	ready BOOLEAN DEFAULT true
	);
*/

create table monster_stat(
	form VARCHAR(64) PRIMARY KEY,
	lvl INT NOT NULL,
	hp INT NOT NULL,
	mana INT DEFAULT 0,
	str INT NOT NULL,
	dex INT NOT NULL,
	xp INT NOT NULL,
	hitdistance INT NOT NULL,
	markdistance INT NOT NULL
);

create table monster(
	servername VARCHAR(64) NOT NULL,
	monstername VARCHAR(64) NOT NULL,
	form VARCHAR(64) NOT NULL,
	x INT NOT NULL,
	y INT NOT NULL,
	z INT NOT NULL,
	angle INT NOT NULL,
	PRIMARY KEY(servername,x,y,z),
	FOREIGN KEY (form) REFERENCES monster_stat(form)
);

CREATE TABLE items(
    name VARCHAR(64) PRIMARY KEY,
	value INT DEFAULT 0,
	respawn INT DEFAULT 2
);
	
create table loot(
	servername VARCHAR(64) NOT NULL,
	npcname VARCHAR(64) NOT NULL,
	itemname VARCHAR(64) NOT NULL,
	number INT DEFAULT 1,
	percent INT NOT NULL,
	FOREIGN KEY (itemname) REFERENCES items(name)
);

CREATE TABLE world_items(
	servername VARCHAR(64) NOT NULL,
	itemname VARCHAR(64) NOT NULL,
	number INT DEFAULT 1,
	x INT NOT NULL,
	y INT NOT NULL,
	z INT NOT NULL,
	FOREIGN KEY (itemname) REFERENCES items(name)
);

create table human(
	servername VARCHAR(64) NOT NULL,
	humanname VARCHAR(64) NOT NULL,
	immortal INT NOT NULL DEFAULT 0,
	bodyform VARCHAR(64) NOT NULL,
	bodyid INT NOT NULL,
	headform VARCHAR(64) NOT NULL,
	headid INT NOT NULL,
	fatness FLOAT(3,1) NOT NULL DEFAULT 0.0,
	red INT NOT NULL DEFAULT 255,
	green INT NOT NULL DEFAULT 255,
	blue INT NOT NULL DEFAULT 255,
	lvl INT NOT NULL DEFAULT 1,
	hp INT NOT NULL DEFAULT 40,
	mana INT NOT NULL DEFAULT 10,
	str INT NOT NULL DEFAULT 10,
	dex INT NOT NULL DEFAULT 10,
	oneh INT NOT NULL DEFAULT 10,
	twoh INT NOT NULL DEFAULT 10,
	bow INT NOT NULL DEFAULT 10,
	cbow INT NOT NULL DEFAULT 10,
	armor VARCHAR(64) DEFAULT NULL,
	meele VARCHAR(64) DEFAULT NULL,
	ranged VARCHAR(64) DEFAULT NULL,
	`event` VARCHAR(64) DEFAULT NULL,
	x INT NOT NULL,
	y INT NOT NULL,
	z INT NOT NULL,
	angle INT NOT NULL,
	PRIMARY KEY(servername,x,y,z)
);

/* human quest template 
	Only the table's name is changed.
	The server create the tables.
	
create table npcname_quest(
	servername VARCHAR(64) NOT NULL,
	charname VARCHAR(64) NOT NULL,
	stand INT DEFAULT 0,
	PRIMARY KEY(servername,charname)
	);
*/