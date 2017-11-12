/*
	Human: 17
	Item: 12
*/
-- Human
INSERT INTO `human`(`servername`,`humanname`,`immortal`,`bodyform`,`bodyid`,`headform`,`headid`,`red`,`green`,`blue`,`armor`,`meele`,`ranged`,`event`,`x`,`y`,`z`,`angle`) VALUES
('gothicmmo','Harad',1,'Hum_Body_Naked0',1,'Hum_Head_Pony',60,255,255,255,'ITAR_SMITH','ITMW_1H_MACE_L_04',NULL,'Harad_Vendor',5758,368,-1363,120),
('gothicmmo','Renor',1,'Hum_Body_Naked0',2,'Hum_Head_Pony',15,255,255,255,'ITAR_SMITH',NULL,NULL,'Renor_Vendor',5691,368,-1571,210),
('gothicmmo','Citizen',1,'Hum_Body_Babe0',11,'Hum_Head_Babe',149,255,255,255,'ITAR_VLKBABE_M',NULL,NULL,NULL,6114,365,-365,71),
('gothicmmo','Eghu',1,'Hum_Body_Naked0',1,'Hum_Head_Bald',70,255,255,255,'ITAR_VLK_L',NULL,NULL,'Eghu_Vendor',7034,368,-5175,86),
('gothicmmo','Citizen',1,'Hum_Body_Babe0',6,'Hum_Head_Babe',142,255,255,255,'ITAR_VLKBABE_L',NULL,NULL,NULL,6538,368,-5211,180),
('gothicmmo','Matteo',1,'Hum_Body_Naked0',1,'Hum_Head_Bald',86,255,255,255,'ITAR_VLK_H',NULL,NULL,'Matteo_Speech',6344,368,-4669,40),
('gothicmmo','Hren',1,'Hum_Body_Naked0',1,'Hum_Head_Bald',88,255,255,255,'ITAR_VLK_M',NULL,NULL,'Hren_Speech',6891,368,-2736,220),
('gothicmmo','Bosper',1,'Hum_Body_Naked0',2,'Hum_Head_Bald',95,255,255,255,'ITAR_LEATHER_L','ITMW_SHORTSWORD2','ITRW_BOW_L_03_MIS','Bosper_Vendor',8196,368,-3398,256),
('gothicmmo','Flower',1,'Hum_Body_Babe0',6,'Hum_Head_Babe',141,255,255,255,'ITAR_VLKBABE_H','ITMW_1H_SWORD_L_03',NULL,'Flower_Quest',7976,368,-3666,159),
('gothicmmo','Annie',1,'Hum_Body_Babe0',5,'Hum_Head_Babe',146,255,255,255,'ITAR_KDF_L',NULL,NULL,'Annie_Trainer',7580,368,-1973,8);
	
INSERT INTO `human`(`servername`,`humanname`,`immortal`,`bodyform`,`bodyid`,`headform`,`headid`,`red`,`green`,`blue`,`str`,`armor`,`meele`,`ranged`,`event`,`x`,`y`,`z`,`angle`) VALUES
('gothicmmo','Guard',1,'Hum_Body_Naked0',1,'Hum_Head_Pony',1,255,255,255,170,'ITAR_PAL_H','ITMW_2H_BLESSED_03','ITRW_CROSSBOW_H_01','Human_Guard',9270,688,-4522,254),
('gothicmmo','Guard',1,'Hum_Body_Naked0',2,'Hum_Head_Bald',8,255,255,255,170,'ITAR_DJG_H','ITMW_2H_SPECIAL_04','ITRW_CROSSBOW_H_02','Human_Guard',9328,688,-4874,260);
	
INSERT INTO `human`(`servername`,`humanname`,`immortal`,`bodyform`,`bodyid`,`headform`,`headid`,`red`,`green`,`blue`,`armor`,`meele`,`ranged`,`event`,`x`,`y`,`z`,`angle`) VALUES
('gothicmmo','Guard',1,'Hum_Body_Naked0',1,'Hum_Head_Psionic',1,255,255,255,'ITAR_MIL_L','ITMW_SHORTSWORD1','ITRW_CROSSBOW_L_02','Human_Guard',8274,368,-6607,183),
('gothicmmo','Guard',1,'Hum_Body_Naked0',1,'Hum_Head_Bald',47,255,255,255,'ITAR_SLD_M','ITMW_SHORTSWORD1','ITRW_BOW_L_04','Human_Guard',7682,368,-6517,184),
('gothicmmo','Guard',1,'Hum_Body_Naked0',1,'Hum_Head_Bald',92,255,255,255,'ITAR_MIL_M','ITMW_SHORTSWORD1',NULL,'Human_Guard',6412,368,-5705,90),
('gothicmmo','Guard',1,'Hum_Body_Naked0',2,'Hum_Head_Bald',15,255,255,255,'ITAR_MIL_L','ITMW_SHORTSWORD1',NULL,'Human_Guard',5405,363,-2186,94),
('gothicmmo','Orgoo',1,'Hum_Body_Naked0',1,'Hum_Head_Bald',56,255,255,255,'ITAR_DEMENTOR',NULL,NULL,'Orgoo_Vendor',6733,222,-562,206);
	
-- World Items
INSERT INTO `world_items`(`servername`,`itemname`,`x`,`y`,`z`) VALUES
 ('gothicmmo','ITPL_MUSHROOM_01',6153,368,-3446),
 ('gothicmmo','ITPL_MUSHROOM_01',6166,366,-3758),
 ('gothicmmo','ITPL_MUSHROOM_02',5940,367,-3631),
 ('gothicmmo','ITRW_ARROW',8486,454,-3319),
 ('gothicmmo','ITPL_FORESTBERRY',8376,368,-4459),
 ('gothicmmo','ITPL_FORESTBERRY',8440,368,-4349),
 ('gothicmmo','ITPL_FORESTBERRY',8503,364,-4240),
 ('gothicmmo','ITPL_FORESTBERRY',8552,368,-5236),
 ('gothicmmo','ITPL_FORESTBERRY',8838,368,-5597),
 ('gothicmmo','ITPL_FORESTBERRY',8779,688,-4475),

 ('gothicmmo','ITPL_FORESTBERRY',8896,688,-5125),
 ('gothicmmo','ITPL_FORESTBERRY',9049,688,-5519);