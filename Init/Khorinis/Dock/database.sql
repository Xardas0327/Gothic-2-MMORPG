/*
	Spawns: 15
	Human: 12
	Item: 18
*/
-- Spawns
INSERT INTO `character_spawn_init`(`servername`,`id`,`x`,`y`,`z`,`angle`) VALUES
('gothicmmo',0,-10235,-14,-14472,127),
('gothicmmo',1,-9414,-14,-16160,334),
('gothicmmo',2,-9941,-497,-15582,164),
('gothicmmo',3,-9710,-497,-13706,225),
('gothicmmo',4,-9348,-18,-17318,8),
('gothicmmo',5,-10525,490,-16222,51),
('gothicmmo',6,-9385,487,-15950,54),
('gothicmmo',7,-10454,292,-18045,64),
('gothicmmo',8,-10078,286,-18907,17),
('gothicmmo',9,-9523,288,-19264,37),

('gothicmmo',10,-10214,1108,-19034,354),
('gothicmmo',11,-9685,559,-12515,150),
('gothicmmo',12,-9595,-17,-12375,157),
('gothicmmo',13,-10097,143,-11192,133),
('gothicmmo',14,-10077,-14,-13624,133);

-- Human
INSERT INTO `human`(`servername`,`humanname`,`immortal`,`bodyform`,`bodyid`,`headform`,`headid`,`red`,`green`,`blue`,`armor`,`meele`,`ranged`,`event`,`x`,`y`,`z`,`angle`) VALUES
('gothicmmo','Captain',1,'Hum_Body_Naked0',1,'Hum_Head_Bald',60,255,255,255,'ITAR_PIR_H_Addon','itmw_piratensaebel',NULL,'Captian_Speech',-10088,490,-16454,0),
('gothicmmo','Bob',1,'Hum_Body_Naked0',3,'Hum_Head_Bald',130,255,255,255,'ITAR_PIR_M_Addon','itmw_piratensaebel',NULL,'Bob_Quest',-11019,-14,-14651,88),
('gothicmmo','Aaron',1,'Hum_Body_Naked0',1,'Hum_Head_Psionic',1,255,255,255,'ITAR_PIR_L_Addon','ITMW_1H_VLK_DAGGER','ITRW_CROSSBOW_L_02','Aaron_Speech',-9983,561,-12032,5),
('gothicmmo','Ron',1,'Hum_Body_Naked0',8,'Hum_Head_Pony',160,255,255,255,'ITAR_PIR_L_Addon','ITMW_1H_VLK_DAGGER','ITRW_CROSSBOW_L_02','Ron_Speech',-9738,923,-17784,228),
('gothicmmo','Uron',1,'Hum_Body_Naked0',10,'Hum_Head_Pony',32,255,255,255,NULL,NULL,NULL,'Uron_Quest',-4095,-392,-18875,341),	
('gothicmmo','Oll',1,'Hum_Body_Naked0',1,'Hum_Head_Bald',39,255,255,255,NULL,NULL,NULL,'Oll_Speech',-4061,-365,-18341,220),	
('gothicmmo','Hun',1,'Hum_Body_Naked0',2,'Hum_Head_Bald',122,255,255,255,'ITAR_PRISONER',NULL,NULL,'Hun_Vendor',-5997,-116,-11171,17),
('gothicmmo','Greg',1,'Hum_Body_Naked0',8,'Hum_Head_Bald',22,255,255,255,NULL,NULL,NULL,'Greg_Speech',-9573,-457,-5807,294),
('gothicmmo','Kronk',1,'Hum_Body_Naked0',2,'Hum_Head_Pony',29,255,255,255,'ITAR_NOV_L','itmw_1h_nov_mace',NULL,'Kronk_Speech',-7502,-132,-14622,270);

INSERT INTO `human`(`servername`,`humanname`,`immortal`,`bodyform`,`bodyid`,`headform`,`headid`,`red`,`green`,`blue`,`str`,`armor`,`meele`,`ranged`,`event`,`x`,`y`,`z`,`angle`) VALUES
('gothicmmo','Guard',1,'Hum_Body_Naked0',3,'Hum_Head_Bald',4,255,255,255,100,'ITAR_SLD_H','ITMW_ADDON_HACKER_2H_01','ITRW_CROSSBOW_M_02','Human_Guard',-8192,-139,-12974,108),
	
('gothicmmo','Guard',1,'Hum_Body_Naked0',1,'Hum_Head_Pony',111,255,255,255,120,'ITAR_PAL_M','ITMW_2H_BLESSED_03',NULL,'Human_Guard',-6586,-117,-8969,183),
('gothicmmo','Guard',1,'Hum_Body_Naked0',10,'Hum_Head_Bald',19,255,255,255,120,'ITAR_CORANGAR','ITMW_2H_BLESSED_03',NULL,'Human_Guard',-7206,-108,-8927,154);

-- World Items
INSERT INTO `world_items`(`servername`,`itemname`,`x`,`y`,`z`) VALUES
('gothicmmo','ITMW_1H_BAU_MACE',-5192,-105,-12943),
('gothicmmo','ITMW_1H_BAU_MACE',-5327,-64,-12214),
('gothicmmo','ITMW_1H_BAU_MACE',-5997,-243,-12956),
('gothicmmo','ITMW_1H_BAU_MACE',-5919,-366,-14373),
('gothicmmo','ITMW_1H_BAU_MACE',-6329,-114,-11467),
('gothicmmo','ITMW_1H_BAU_MACE',-3731,-335,-18643),
('gothicmmo','ITMW_1H_BAU_MACE',-4465,-295,-15793),
('gothicmmo','ITFO_FISH',-8399,-132,-5601),
('gothicmmo','ITFO_FISH',-5663,-124,-10256),
('gothicmmo','ITFO_FISH',-5788,-125,-10285),

('gothicmmo','ITFO_FISH',-5349,-53,-10912),
('gothicmmo','ITFO_FISH',-5569,-53,-11509),
('gothicmmo','ITFO_FISH',-5963,-485,-14803),
('gothicmmo','ITFO_FISH',-4967,-224,-14980),
('gothicmmo','ITMW_1H_MISC_SWORD',-14140,-122,-8884),
('gothicmmo','ITMW_1H_MISC_AXE',-14820,-124,-8828),
('gothicmmo','ITRW_ARROW',-4935,-65,-10699);

INSERT INTO `world_items`(`servername`,`itemname`,`number`,`x`,`y`,`z`) VALUES
('gothicmmo','ITMI_GOLD',2,-6907,-121,-12957);