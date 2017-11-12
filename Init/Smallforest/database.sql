/*
	Human: 9
	Monster: 42
	Item: 53
*/

-- Human
INSERT INTO `human`(`servername`,`humanname`,`immortal`,`bodyform`,`bodyid`,`headform`,`headid`,`red`,`green`,`blue`,`armor`,`meele`,`ranged`,`event`,`x`,`y`,`z`,`angle`) VALUES
('gothicmmo','Roger',1,'Hum_Body_Naked0',1,'Hum_Head_Psionic',18,150,0,255,'ITAR_DJG_CRAWLER','ITMW_ADDON_KNIFE01','ITRW_BOW_H_01','Roger_Quest',5443,498,-23275,333),
('gothicmmo','Hunter',1,'Hum_Body_Naked0',2,'Hum_Head_Bald',98,150,0,255,'ITAR_LEATHER_L','ITMW_SHORTSWORD2','ITRW_BOW_L_04',NULL,5115,526,-23476,21),
('gothicmmo','Farmer',1,'Hum_Body_Naked0',2,'Hum_Head_Bald',22,255,255,255,'ITAR_BAU_L','ITMW_1H_BAU_AXE',NULL,NULL,14014,1862,-17126,202),
('gothicmmo','Farmer',1,'Hum_Body_Naked0',2,'Hum_Head_Pony',29,255,255,255,'ITAR_BAU_L','ITMW_1H_BAU_AXE',NULL,NULL,13189,1706,-17944,354),
('gothicmmo','Farmer',1,'Hum_Body_Babe0',5,'Hum_Head_Babe',148,255,255,255,'ITAR_BAUBABE_L',NULL,NULL,NULL,14701,1696,-13684,267),
('gothicmmo','Lee',1,'Hum_Body_Naked0',1,'Hum_Head_Bald',87,255,255,255,'ITAR_BAU_M','ITMW_1H_BAU_AXE',NULL,'Lee_Quest',13689,1803,-15189,266),
('gothicmmo','Abhen',1,'Hum_Body_Naked0',2,'Hum_Head_Bald',128,255,255,255,'ITAR_BAU_L','ITMW_1H_BAU_AXE',NULL,'Abhen_Quest',16031,2051,-14615,227),
('gothicmmo','Valentino',1,'Hum_Body_Naked0',1,'Hum_Head_Pony',81,255,255,255,'ITAR_BAU_L','ITMW_1H_BAU_AXE',NULL,'Valentino_Quest',12360,1724,-18969,171),
('gothicmmo','Rebeca',1,'Hum_Body_Babe0',6,'Hum_Head_Babe',158,255,255,255,'ITAR_BAUBABE_M',NULL,NULL,'Rebeca_Speech',14752,1892,-16663,260);
	
-- Monsters
INSERT INTO `monster`(`servername`,`monstername`,`form`,`x`,`y`,`z`,`angle`) VALUES
('gothicmmo','Young Bloodfly','ybloodfly',5038,33,-7564,162),
('gothicmmo','Young Bloodfly','ybloodfly',2371,296,-13265,265),
('gothicmmo','Young Bloodfly','ybloodfly',5562,652,-19461,164),
('gothicmmo','Young Gaint Rat','ygiant_rat',2773,304,-9533,265),
('gothicmmo','Young Gaint Rat','ygiant_rat',2974,257,-8915,270),
('gothicmmo','Young Gaint Rat','ygiant_rat',4496,419,-14515,98),
('gothicmmo','Gaint Rat','giant_rat',5775,523,-24949,353),
('gothicmmo','Young Wolf','ywolf',3955,55,-11300,232),
('gothicmmo','Young Wolf','ywolf',4747,59,-11882,155),
('gothicmmo','Young Wolf','ywolf',4064,165,-12291,252),

('gothicmmo','Young Wolf','ywolf',4033,491,-16152,284),
('gothicmmo','Young Wolf','ywolf',3579,492,-16804,212),
('gothicmmo','Young Wolf','ywolf',3484,646,-20522,251),
('gothicmmo','Wolf','wolf',2854,419,-20923,57),
('gothicmmo','Wolf','wolf',4531,560,-17133,300),
('gothicmmo','Boss of Goblin','gobbo_warrior',-1684,651,-8646,236),
('gothicmmo','Black Goblin','gobbo_black',-1777,669,-10994,21),
('gothicmmo','Black Goblin','gobbo_black',-1823,685,-10594,164),
('gothicmmo','Goblin','gobbo_green',-3280,681,-11685,249),
('gothicmmo','Goblin','gobbo_green',-3206,546,-13084,193),

('gothicmmo','Young Goblin','ygobbo_green',-3210,485,-13783,198),
('gothicmmo','Young Goblin','ygobbo_green',-3368,360,-14113,346),
('gothicmmo','Goblin','gobbo_green', -2995,267,-15789,162),
('gothicmmo','Goblin','gobbo_green',-2413,251,-18267,197),
('gothicmmo','Young Goblin','ygobbo_green',-2037,324,-18219,171),
('gothicmmo','Young Goblin','ygobbo_green',-1090,281,-20034,216),
('gothicmmo','Goblin','gobbo_green',-1106,220,-20877,46),
('gothicmmo','Sheep','sheep',16302,2084,-14766,14),
('gothicmmo','Sheep','sheep',16504,2092,-14505,264),
('gothicmmo','Sheep','sheep',16169,2042,-14058,168),

('gothicmmo','Aggressive Field Raider','giant_bug',11358,1512,-15036,348),
('gothicmmo','Aggressive Field Raider','giant_bug',10588,1451,-14284,3),
('gothicmmo','Aggressive Field Raider','giant_bug',9624,1341,-13154,125),
('gothicmmo','Aggressive Field Raider','giant_bug',10998,1420,-11715,97),
('gothicmmo','Aggressive Field Raider','giant_bug',11291,1491,-11071,127),
('gothicmmo','Aggressive Field Raider','giant_bug',12486,1522,-11527,273),
('gothicmmo','Young Wolf','ywolf',20832,1677,-8071,145),
('gothicmmo','Wolf','wolf',21333,1601,-8408,189),
('gothicmmo','Wolf','wolf',21083,1635,-9078,299),
('gothicmmo','Black Wolf','blackwolf',21771,1662,-9037,334),

('gothicmmo','Gluttonous Scavenger','scavenger',13121,1700,-20473,240),
('gothicmmo','Scavenger','scavenger',12768,1731,-20906,39);

-- World Items
INSERT INTO `world_items`(`servername`,`itemname`,`x`,`y`,`z`) VALUES
('gothicmmo','ITPL_MUSHROOM_01',3401,648,-18284),
('gothicmmo','ITPL_MUSHROOM_01',4068,445,-14424),
('gothicmmo','ITPL_MUSHROOM_01',2587,403,-21008),
('gothicmmo','ITPL_MUSHROOM_01',2463,413,-20919),
('gothicmmo','ITPL_MUSHROOM_01',5304,521,-24033),
('gothicmmo','ITPL_MUSHROOM_02',2418,383,-21121),
('gothicmmo','ITPL_MUSHROOM_02',5471,483,-17211),
('gothicmmo','ITPL_MUSHROOM_02',4981,107,-12795),
('gothicmmo','ITRW_ARROW',5419,514,-23810),
('gothicmmo','ITPL_BLUEPLANT',3769,242,-12499),

('gothicmmo','ITPL_BLUEPLANT',3458,479,-16804),
('gothicmmo','ITPL_BLUEPLANT',6572,434,-24215),
('gothicmmo','ITPL_BLUEPLANT',2428,292,-12969),
('gothicmmo','ITPL_BLUEPLANT',6898,341,-7377),
('gothicmmo','ITPL_HEALTH_HERB_01',6645,617,-9343),
('gothicmmo','ITPL_HEALTH_HERB_01',2961,333,-12739),
('gothicmmo','ITPL_HEALTH_HERB_01',2254,620,-18818),
('gothicmmo','ITPL_HEALTH_HERB_01',3727,770,-19251),
('gothicmmo','ITPL_HEALTH_HERB_01',3104,355,-14174),
('gothicmmo','ITPL_HEALTH_HERB_01',4876,715,-18875),

('gothicmmo','ITPL_HEALTH_HERB_02',6570,466,-24868),
('gothicmmo','ITPL_MANA_HERB_01',2941,837,-19176),
('gothicmmo','ITPL_MANA_HERB_01',3690,384,-22794),
('gothicmmo','ITPL_MANA_HERB_01',2768,691,-19716),
('gothicmmo','ITPL_MANA_HERB_02',317,68,-7912),
('gothicmmo','ITPL_SPEED_HERB_01',5744,409,-17097),
('gothicmmo','ITPL_SPEED_HERB_01',3665,117,-11355),
('gothicmmo','ITFOMUTTONRAW',-1596,670,-10816),
('gothicmmo','ITFOMUTTON',-1629,676,-10701),
('gothicmmo','ITFOMUTTON',-1750,696,-10722),

('gothicmmo','ITPL_FORESTBERRY',-2677,561,-14413),
('gothicmmo','ITPL_FORESTBERRY',-4134,509,-12058),
('gothicmmo','ITPL_FORESTBERRY',-4003,643,-11708),
('gothicmmo','ITPL_PLANEBERRY',-2337,212,-19120),
('gothicmmo','ITPL_PLANEBERRY',-2553,209,-19014),
('gothicmmo','ITPL_PLANEBERRY',-2198,373,-17535),
('gothicmmo','ITPL_PLANEBERRY',-1902,397,-18020),
('gothicmmo','ITPL_PLANEBERRY',-3672,309,-13802),
('gothicmmo','ITPL_PLANEBERRY',-3531,241,-14446),
('gothicmmo','ITPL_HEALTH_HERB_01',16859,2420,-10878),

('gothicmmo','ITPL_HEALTH_HERB_01',16460,2698,-9533),
('gothicmmo','ITPL_HEALTH_HERB_01',17248,2665,-9405),
('gothicmmo','ITPL_HEALTH_HERB_02',16700,2704,-9796),
('gothicmmo','ITPL_MANA_HERB_01',15813,2602,-9092),
('gothicmmo','ITPL_MANA_HERB_02',17109,2676,-9097),
('gothicmmo','ITPL_MANA_HERB_02',20972,1857,-7415),
('gothicmmo','ITPL_MUSHROOM_02',16411,2682,-7940),
('gothicmmo','ITPL_PERM_HERB',16651,2747,-8445),
('gothicmmo','ITPL_MUSHROOM_01',11716,1703,-18153),
('gothicmmo','ITPL_MUSHROOM_01',11845,1707,-17953),

('gothicmmo','ITPL_HEALTH_HERB_01',10340,1694,-20498),
('gothicmmo','ITPL_MANA_HERB_01',9656,1537,-21264),
('gothicmmo','ITPL_BLUEPLANT',10574,1698,-19419);