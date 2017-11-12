--[[
   Trainer:	1
   Vendor:	5
   Speech:	2
	Quest:	1
]]

function Annie_Trainer(id)
	return Human_Trainer(id,"mana");
end

function Harad_Vendor(id)
	local vendor={};
	vendor.number=5;
	vendor.item={};
	vendor.item[0]="ITMW_SHORTSWORD1";
	vendor.item[1]="ITMW_1H_COMMON_01";
	vendor.item[2]="ITMW_1H_VLK_SWORD";
	vendor.item[3]="ITMW_SCHWERT1";
	vendor.item[4]="ITMI_HAMMER";
	
	return Human_Vendor(id,vendor);
end

function Renor_Vendor(id)
	local vendor={};
	vendor.number=5;
	vendor.item={};
	vendor.item[0]="ITMW_2H_AXE_L_01";
	vendor.item[1]="ITMW_2H_BAU_AXE";
	vendor.item[2]="ITMW_2H_SLD_SWORD";
	vendor.item[3]="ITMW_ADDON_STAB05";
	vendor.item[4]="ITMISWORDRAW";
	
	return Human_Vendor(id,vendor);
end

function Eghu_Vendor(id)
	local vendor={};
	vendor.number=10;
	vendor.item={};
	vendor.item[0]="ITMI_PANFULL";
	vendor.item[1]="ITMI_BROOM";
	vendor.item[2]="ITMI_LUTE";
	vendor.item[3]="ITMI_INNOSSTATUE";
	vendor.item[4]="ITFO_MILK";
	vendor.item[5]="ITFO_BREAD";
	vendor.item[6]="ITFO_CORAGONSBEER";
	vendor.item[7]="ITAR_VLK_L";
	vendor.item[8]="ITAR_VLK_M";
	vendor.item[9]="ITAR_VLK_H";
	
	return Human_Vendor(id,vendor);
end

function Orgoo_Vendor(id)
	local vendor={};
	vendor.number=6;
	vendor.item={};
	vendor.item[0]="ITSC_LIGHT";
	vendor.item[1]="ITSC_LIGHTHEAL";
	vendor.item[2]="ITSC_INSTANTFIREBALL";
	vendor.item[3]="ITSC_ZAP";
	vendor.item[4]="ITSC_LIGHTNINGFLASH";
	vendor.item[5]="ITSC_ICECUBE";
	
	return Human_Vendor(id,vendor);
end

function Bosper_Vendor(id)
	local vendor={};
	vendor.number=10;
	vendor.item={};
	vendor.item[0]="ITRW_BOW_L_01";
	vendor.item[1]="ITRW_BOW_L_02";
	vendor.item[2]="ITRW_BOW_L_03";
	vendor.item[3]="ITRW_ARROW";
	vendor.item[4]="ITRW_ADDON_FIREARROW";
	vendor.item[5]="ITRW_CROSSBOW_L_01";
	vendor.item[6]="ITRW_MIL_CROSSBOW";
	vendor.item[7]="ITRW_CROSSBOW_L_02";
	vendor.item[8]="ITRW_BOLT";	
	vendor.item[9]="ITAR_LEATHER_L";	
	
	return Human_Vendor(id,vendor);
end

function Matteo_Speech(id)
	local speech={};
	speech.talknumber=1;
	speech.talk={};
	speech.talk[0]={};
	speech.talk[0][0]="If you want to buy something,";
	speech.talk[0][1]="you should go out.";
	speech.talk[0][2]="My son Eghu is a vendor.";
	
	return Human_Speech(id,speech);
end

function Hren_Speech(id)
	local speech={};
	speech.talknumber=1;
	speech.talk={};
	speech.talk[0]={};
	speech.talk[0][0]="Do you want to buy a wardrobe,";
	speech.talk[0][1]="a chest or a cupboard? You can find";
	speech.talk[0][2]="them here! They are very cheap.";
	
	return Human_Speech(id,speech);
end

function Flower_Quest(id)	
	local quest={};
	quest.questtype="bring";
	quest.mark="ITAT_WOLFFUR";
	quest.markamount=10;
	quest.xp=150;
	quest.reward="ITAR_LEATHER_L";
	quest.rewardamount=1;
	quest.talknumber=4;
	quest.stop=2;
	quest.talk={};
	quest.talk[0]={};
	quest.talk[0][0]="Hi.";
	quest.talk[0][1]="I have an offer to you.";
	quest.talk[1]={};
	quest.talk[1][0]="If you bring me 10 wolf pelts,";
	quest.talk[1][1]="I will give a leather armour for you.";
	quest.talk[2]={};
	quest.talk[2][0]="These are excellent.";
	quest.talk[2][1]="Here you are.";
	quest.talk[3]={};
	quest.talk[3][0]="If it is damaged, you can come back"
	quest.talk[3][1]="and I will fix it."
	quest.waittalk={};
	quest.waittalk[1]="When will you get them for me?";
	quest.endtalk={};
	quest.endtalk[1]="Is it damaged?";
	quest.questshort="Skins to Flower";
	quest.hint={};
	quest.hint[0]="You can find wolves";
	quest.hint[1]="in the forest.";
	
	return Human_Quest(id,quest);
end