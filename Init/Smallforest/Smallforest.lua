--[[
	Speech:	1
	Quest:	4
]]

function Rebeca_Speech(id)
	local speech={};
	speech.talknumber=1;
	speech.talk={};
	speech.talk[0]={};
	speech.talk[0][0]="Did you see Valentino?";
	speech.talk[0][1]="He said we will meet here,";
	speech.talk[0][2]="but I have been waiting for an hour.";
	
	return Human_Speech(id,speech);
end

function Roger_Quest(id)	
	local quest={};
	quest.questtype="kill";
	quest.mark="Boss of Goblin";
	quest.markamount=1;
	quest.xp=500;
	quest.reward="ITMI_GOLD";
	quest.rewardamount=400;
	quest.talknumber=3;
	quest.stop=2;
	quest.talk={};
	quest.talk[0]={};
	quest.talk[0][0]="If I were you, I’d be more careful.";
	quest.talk[0][1]="There is a cave nearby with lots";
	quest.talk[0][2]="of goblins inside.";
	quest.talk[1]={};
	quest.talk[1][0]="I think they have a boss.";
	quest.talk[1][1]="If you kill it, I will pay you";
	quest.talk[1][2]="a lot of golds.";
	quest.talk[2]={};
	quest.talk[2][0]="You did it? Really?";
	quest.talk[2][1]="I really underestimated you.";
	quest.talk[2][2]="Here is your 400 coins.";
	quest.waittalk={};
	quest.waittalk[1]="Is it done?";
	quest.endtalk={};
	quest.endtalk[1]="I underestimated you.";
	quest.questshort="Boss of goblins";
	quest.hint={};
	quest.hint[0]="There is only one cave";
	quest.hint[1]="in this forest.";		
	
	return Human_Quest(id,quest);
end

function Lee_Quest(id)	
	local quest={};
	quest.questtype="kill";
	quest.mark="Aggressive Field Raider";
	quest.markamount=6;
	quest.xp=250;
	quest.reward="ITMI_GOLD";
	quest.rewardamount=100;
	quest.talknumber=3;
	quest.stop=2;
	quest.talk={};
	quest.talk[0]={};
	quest.talk[0][0]="Oh, man.";
	quest.talk[0][1]="See. My land is occupied by Field Raiders.";
	quest.talk[1]={};
	quest.talk[1][1]="Please, kill them.";
	quest.talk[2]={};
	quest.talk[2][0]="My land is clean.";
	quest.talk[2][1]="Thank you.";
	quest.talk[2][2]="I hope you will accept this gift."
	quest.waittalk={};
	quest.waittalk[1]="Innos help me.";
	quest.endtalk={};
	quest.endtalk[1]="We’ll continue the work.";
	quest.questshort="Land of Lee";
	quest.hint={};
	quest.hint[0]="Kill 6 Aggressive";
	quest.hint[1]="Field Raiders.";		
	
	return Human_Quest(id,quest);
end

function Abhen_Quest(id)	
	local quest={};
	quest.questtype="kill";
	quest.mark="Black Wolf";
	quest.markamount=1;
	quest.xp=150;
	quest.reward="ITPO_SPEED";
	quest.rewardamount=3;
	quest.talknumber=3;
	quest.stop=2;
	quest.talk={};
	quest.talk[0]={};
	quest.talk[0][0]="Hi.";
	quest.talk[0][1]="Last night I saw some wolves on the hill.";
	quest.talk[1]={};
	quest.talk[1][0]="The pack leader is a big black wolf.";
	quest.talk[1][1]="If you kill it, I will give some";
	quest.talk[1][2]="potions.";
	quest.talk[2]={};
	quest.talk[2][0]="Done?";
	quest.talk[2][1]="Take the potions.";
	quest.talk[2][2]="I got them from a mage."
	quest.waittalk={};
	quest.waittalk[1]="It’s still alive!";
	quest.endtalk={};
	quest.endtalk[1]="This work is boring.";
	quest.questshort="Black Wolf";
	quest.hint={};
	quest.hint[1]="The wolves are near the hill.";
	
	return Human_Quest(id,quest);
end

function Valentino_Quest(id)	
	local quest={};
	quest.questtype="bring";
	quest.mark="ITRI_VALENTINOSRING";
	quest.markamount=1;
	quest.xp=200;
	quest.talknumber=3;
	quest.stop=2;
	quest.talk={};
	quest.talk[0]={};
	quest.talk[0][0]="Please help me.";
	quest.talk[0][1]="I was praying to Innos, but suddenly";
	quest.talk[0][2]="2 scavengers appeared";
	quest.talk[1]={};
	quest.talk[1][0]="I ran away, but my ring was stolen.";
	quest.talk[1][1]="I wanted to propose to Rebeca with this ring.";
	quest.talk[1][2]="What am I doing?";
	quest.talk[2]={};
	quest.talk[2][0]="Oh Innos. Thanks.";
	quest.talk[2][1]="I promise, that I will invite you";
	quest.talk[2][2]="to wedding.";
	quest.waittalk={};
	quest.waittalk[1]="Oh Innos. What am I doing?";
	quest.endtalk={};
	quest.endtalk[1]="I'm inviting you to my wedding.";
	quest.questshort="Ring of Valentino";
	quest.hint={};
	quest.hint[1]="There are 2 scavengers near.";
	
	return Human_Quest(id,quest);
end