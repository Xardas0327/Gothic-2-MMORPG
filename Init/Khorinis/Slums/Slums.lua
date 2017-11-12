--[[
   Trainer:	2
   Vendor:	4
   Speech:	2
	Quest:	6
]]
function Ned_Trainer(id)
	return Human_Trainer(id,"str");
end

function Kenny_Trainer(id)
	return Human_Trainer(id,"dex");
end

function Sarah_Vendor(id)
	local vendor={};
	vendor.number=3;
	vendor.item={};
	vendor.item[0]="ITFO_ADDON_SHELLFLESH";
	vendor.item[1]="ITFO_FISH";
	vendor.item[2]="ITFO_SMELLYFISH";
	
	return Human_Vendor(id,vendor);
end

function Jack_Vendor(id)
	local vendor={};
	vendor.number=6;
	vendor.item={};
	vendor.item[0]="ITFO_APPLE";
	vendor.item[1]="ITFO_CHEESE";
	vendor.item[2]="ITFO_BREAD";
	vendor.item[3]="ITFO_HONEY";
	vendor.item[4]="ITFO_WATER";
	vendor.item[5]="ITFO_MILK"; 
	
	return Human_Vendor(id,vendor);
end

function Fred_Vendor(id)
	local vendor={};
	vendor.number=5;
	vendor.item={};
	vendor.item[0]="ITFO_BACON";
	vendor.item[1]="ITFOMUTTONRAW";
	vendor.item[2]="ITFOMUTTON";
	vendor.item[3]="ITFO_SAUSAGE";
	vendor.item[4]="ITFO_SCHAFSWURST";
	
	return Human_Vendor(id,vendor);
end

function Plek_Vendor(id)
	local vendor={};
	vendor.number=4;
	vendor.item={};
	vendor.item[0]="ITFO_BEER";
	vendor.item[1]="ITFO_BOOZE";
	vendor.item[2]="ITFO_WINE";
	vendor.item[3]="ITFO_ADDON_RUM";
	
	return Human_Vendor(id,vendor);
end

function Tren_Speech(id)
	local speech={};
	speech.talknumber=1;
	speech.talk={};
	speech.talk[0]={};
	speech.talk[0][0]="Sorry, man.";
	speech.talk[0][1]="I cannot offer you any courtesans";
	speech.talk[0][2]="at this time. Come back later.";
	
	return Human_Speech(id,speech);
end

function Ben_Speech(id)
	local speech={};
	speech.talknumber=1;
	speech.talk={};
	speech.talk[0]={};
	speech.talk[0][0]="If you come in here and steal something,";
	speech.talk[0][1]="I will kill you.";
	
	return Human_Speech(id,speech);
end

function Iris_Quest(id)	
	local quest={};
	quest.questtype="bring";
	quest.mark="ITPL_MUSHROOM_01";
	quest.markamount=4;
	quest.xp=100;
	quest.reward="ITAR_VLK_H";
	quest.rewardamount=1;
	quest.talknumber=5;
	quest.stop=3;
	quest.talk={};
	quest.talk[0]={};
	quest.talk[0][0]="Hi.";
	quest.talk[0][1]="Can you help me?";
	quest.talk[1]={};
	quest.talk[1][0]="If my husband was still alive,";
	quest.talk[1][1]="he would be 52 years old today.";
	quest.talk[1][2]="That's why I'm cooking his favourite soup.";
	quest.talk[2]={};
	quest.talk[2][0]="I must get 4 dark mushrooms.";
	quest.talk[2][1]="But I have to keep an eye on the soup.";
	quest.talk[2][2]="Could you fetch them for me?";
	quest.talk[3]={};
	quest.talk[3][0]="Oh, Thanks.";
	quest.talk[3][1]="You're a good man.";
	quest.talk[3][2]="Could you do me a favor?";
	quest.talk[4]={};
	quest.talk[4][0]="These clothes belonged to my husband.";
	quest.talk[4][1]="Please, take it away.";
	quest.waittalk={};
	quest.waittalk[1]="Have you got them?";
	quest.endtalk={};
	quest.endtalk[1]="You're a good man.";
	quest.questshort="Bring 4 dark mushrooms to Iris";
	quest.hint={};
	quest.hint[0]="Dark mushrooms are often";
	quest.hint[1]="found near trees.";	
	
	return Human_Quest(id,quest);
end

function Eev_Quest(id)	
	local quest={};
	quest.questtype="bring";
	quest.mark="ITMI_SILVERRING";
	quest.markamount=1;
	quest.xp=130;
	quest.reward="ITMI_GOLD";
	quest.rewardamount=20;
	quest.talknumber=3;
	quest.stop=2;
	quest.talk={};
	quest.talk[0]={};
	quest.talk[0][0]="Please help me!";
	quest.talk[0][1]="I can’t find my ring.";
	quest.talk[1]={};
	quest.talk[1][0]="It is only a silver ring.";
	quest.talk[1][1]="But my brother made it for me.";
	quest.talk[2]={};
	quest.talk[2][0]="Thank you.";
	quest.talk[2][1]="I don’t have a lot of money";
	quest.talk[2][2]="but I can give you 20 coins."
	quest.waittalk={};
	quest.waittalk[1]="Where is it?";
	quest.endtalk={};
	quest.endtalk[1]="You're my hero.";
	quest.questshort="Ring of Eev";
	quest.hint={};
	quest.hint[0]="Look for the ring in the house";
	quest.hint[1]="or around it.";	
	
	return Human_Quest(id,quest);
end

function Grenour_Quest(id)	
	local quest={};
	quest.questtype="bring";
	quest.mark="ITFOMUTTONRAW";
	quest.markamount=1;
	quest.xp=20;
	quest.reward="ITFO_FISHSOUP";
	quest.rewardamount=1;
	quest.talknumber=4;
	quest.stop=3;
	quest.repeated=2;
	quest.talk={};
	quest.talk[0]={};
	quest.talk[0][0]="Fish, fish and only fish.";
	quest.talk[0][1]="Sorry, but my wife is the vendor, not me.";
	quest.talk[1]={};
	quest.talk[1][0]="I don't want to eat fish.";
	quest.talk[1][1]="Do you have some meat?";
	quest.talk[2]={};
	quest.talk[2][0]="I have fish soup.";
	quest.talk[2][1]="I will give a bowl of soup, if you bring me";
	quest.talk[2][2]="some meat.";
	quest.talk[3]={};
	quest.talk[3][0]="Hmmm meat. It's perfect.";
	quest.talk[3][1]="Take your soup.";
	quest.waittalk={};
	quest.waittalk[1]="Have you got it?";
	quest.questshort="Meat to Grenour";
	quest.hint={};
	quest.hint[1]="Almost all meat is edible.";		
	
	return Human_Quest(id,quest);
end

function Proner_Quest(id)	
	local quest={};
	quest.questtype="bring";
	quest.mark="ITPL_HEALTH_HERB_01";
	quest.markamount=2;
	quest.xp=20;
	quest.reward="ITPO_HEALTH_01";
	quest.rewardamount=1;
	quest.talknumber=4;
	quest.stop=3;
	quest.repeated=2;
	quest.talk={};
	quest.talk[0]={};
	quest.talk[0][0]="Hi.";
	quest.talk[0][1]="Sorry, I'm not a vendor. I am an alchemist.";
	quest.talk[1]={};
	quest.talk[1][0]="I can create Essence of Healing.";
	quest.talk[1][1]="If you drink it,";
	quest.talk[1][2]="your injuries will be healed.";
	quest.talk[2]={};
	quest.talk[2][0]="If you bring me 2 healing plants,";
	quest.talk[2][1]="I can create the Essence of Healing.";
	quest.talk[3]={};
	quest.talk[3][1]="Here you are.";
	quest.waittalk={};
	quest.waittalk[1]="Have you got them?";
	quest.questshort="Essence of Healing";
	quest.hint={};
	quest.hint[0]="It isn't difficult to find";	
	quest.hint[1]="the plants in a forest.";	
	
	return Human_Quest(id,quest);
end

function Dragomir_Quest(id)	
	local quest={};
	quest.questtype="bring";
	quest.mark="ITRW_DRAGOMIRSARMBRUST_MIS";
	quest.markamount=1;
	quest.xp=150;
	quest.reward="ITMI_GOLD";
	quest.rewardamount=50;
	quest.talknumber=3;
	quest.stop=2;
	quest.talk={};
	quest.talk[0]={};
	quest.talk[0][0]="Oh, man. I'm in trouble.";
	quest.talk[0][1]="Hagen doesn't know yet,";
	quest.talk[0][2]="but I lost my crossbow.";
	quest.talk[1]={};
	quest.talk[1][0]="Yesterday I was very drunk.";
	quest.talk[1][1]="I remember falling into a bush after leaving";
	quest.talk[1][2]="the tavern, and I also heard sheep."; 
	quest.talk[2]={};
	quest.talk[2][0]="Thank you man.";
	quest.talk[2][1]="Here. Take this,"; 
	quest.talk[2][2]="but don't drink it away."; 
	quest.waittalk={};
	quest.waittalk[1]="Oh shit. I hope it will be.";
	quest.endtalk={};
	quest.endtalk[1]="I hope you won't drink away my gift.";
	quest.questshort="Dragomir's crossbow";
	quest.hint={};
	quest.hint[0]="Look for the crossbow";
	quest.hint[1]="near the tavern.";		
	
	return Human_Quest(id,quest);
end

function Grawel_Quest(id)	
	local quest={};
	quest.questtype="bring";
	quest.mark="ITMI_HAMMER";
	quest.markamount=2;
	quest.xp=100;
	quest.reward="ITMI_GOLD";
	quest.rewardamount=50;
	quest.talknumber=3;
	quest.stop=2;
	quest.talk={};
	quest.talk[0]={};
	quest.talk[0][0]="The boat is ready soon.";
	quest.talk[0][1]="But the work is slow.";
	quest.talk[0][2]="Two hammers were stolen.";
	quest.talk[1]={};
	quest.talk[1][0]="Could you find them?";
	quest.talk[1][1]="I will pay for it.";
	quest.talk[2]={};
	quest.talk[2][0]="Oh, great.";
	quest.talk[2][1]="I hope it is enough.";
	quest.waittalk={};
	quest.waittalk[0]="If hammers aren't found,";
	quest.waittalk[1]="the boat won't be ready on time.";
	quest.endtalk={};
	quest.endtalk[1]="We will be ready soon.";
	quest.questshort="Hammers for workers";
	quest.hint={};
	quest.hint[0]="Either search for them";
	quest.hint[1]="or buy them";	
	
	return Human_Quest(id,quest);
end