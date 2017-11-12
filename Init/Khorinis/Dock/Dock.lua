--[[
	Vendor:	1
	Speech:	6
	Quest:	2
]]

function Hun_Vendor(id)
	local vendor={};
	vendor.number=3;
	vendor.item={};
	vendor.item[0]="ITMW_1H_BAU_MACE";
	vendor.item[1]="ITMW_1H_VLK_DAGGER";
	vendor.item[2]="ITFO_FISH";
	
	return Human_Vendor(id,vendor);
end

function Captian_Speech(id)
	local speech={};
	speech.talknumber=2;
	speech.talk={};
	speech.talk[0]={};
	speech.talk[0][0]="We have arrived. This is Khorinis.";
	speech.talk[0][1]="Don’t you worry!";
	speech.talk[1]={};
	speech.talk[1][0]="The Brotherhood of Tooshoo will protect you";
	speech.talk[1][1]="from everything in the city.";	
	
	return Human_Speech(id,speech);
end

function Ron_Speech(id)
	local speech={};
	speech.talknumber=1;
	speech.talk={};
	speech.talk[0]={};
	speech.talk[0][0]="Mind yourself!";
	speech.talk[0][1]="Don’t get in trouble!";
	
	return Human_Speech(id,speech);
end

function Aaron_Speech(id)
	local speech={};
	speech.talknumber=1;
	speech.talk={};
	speech.talk[0]={};
	speech.talk[0][0]="Finally I can relax.";
	speech.talk[0][1]="I suggest that you also relax.";
	
	return Human_Speech(id,speech);
end

function Oll_Speech(id)
	local speech={};
	speech.talknumber=1;
	speech.talk={};
	speech.talk[0]={};
	speech.talk[0][0]="I didn’t think";
	speech.talk[0][1]="that I was saved by pirates.";
	
	return Human_Speech(id,speech);
end

function Kronk_Speech(id)
	local speech={};
	speech.talknumber=3;
	speech.talk={};
	speech.talk[0]={};
	speech.talk[0][0]="Welcome!";
	speech.talk[0][1]="My name is Kronk.";
	speech.talk[0][2]="This is Khorinis.";
	speech.talk[1]={};
	speech.talk[1][0]="The Brotherhood of Tooshoo resides here.";
	speech.talk[1][1]="It was founded to put an end to the wars.";
	speech.talk[2]={};
	speech.talk[2][0]="More and more people are joining us.";
	speech.talk[2][1]="We have fire, water and dark mages.";
	speech.talk[2][2]="Even pirates have joined us.";
	
	return Human_Speech(id,speech);
end

function Greg_Speech(id)
	local speech={};
	speech.talknumber=1;
	speech.talk={};
	speech.talk[0]={};
	speech.talk[0][0]="I am really curious.";
	speech.talk[0][1]="What do you think it is on that small island?";
	
	return Human_Speech(id,speech);
end

function Bob_Quest(id)
	local quest={};
	quest.questtype="bring";
	quest.mark="ITFO_CHEESE";
	quest.markamount=1;
	quest.xp=200;
	quest.reward="ITMW_SHORTSWORD3";
	quest.rewardamount=1;
	quest.talknumber=3;
	quest.stop=1;
	quest.talk={};
	quest.talk[0]={};
	quest.talk[0][0]="Hi. I shouldn’t ask this.";
	quest.talk[0][1]="Could you get me some cheese?";
	quest.talk[0][2]="I haven’t eaten in 3 weeks.";
	quest.talk[1]={};
	quest.talk[1][0]="Oh, Thanks!";
	quest.talk[1][1]="Wait a minute.";
	quest.talk[2]={};
	quest.talk[2][0]="This is my old weapon.";
	quest.talk[2][1]="I hope you can use it.";
	quest.waittalk={};
	quest.waittalk[0]="Oh Adanos!";
	quest.waittalk[1]="I didn’t eat for a very long time.";
	quest.endtalk={};
	quest.endtalk[0]="This cheese is delicious.";
	quest.endtalk[1]="Thanks again.";
	quest.questshort="Bring some cheese to Bob";
	quest.hint={};
	quest.hint[0]="A vendor should sell cheese";
	quest.hint[1]="in Khorinis.";
	
	return Human_Quest(id,quest);
end

function Uron_Quest(id)
	local quest={};
	quest.questtype="bring";
	quest.mark="ITFO_FISH";
	quest.markamount=2;
	quest.xp=100;
	quest.reward="ITRW_BOLT";
	quest.rewardamount=7;
	quest.talknumber=2;
	quest.stop=1;
	quest.talk={};
	quest.talk[0]={};
	quest.talk[0][0]="We are very-very hungry.";
	quest.talk[0][1]="Could you give us some food?";
	quest.talk[0][2]="Fish will be good too.";
	quest.talk[1]={};
	quest.talk[1][0]="Thanks!";
	quest.talk[1][1]="I've found a few bolts.";
	quest.talk[1][2]="Here you are.";
	quest.waittalk={};
	quest.waittalk[1]="I'm sooo hungry.";
	quest.endtalk={};
	quest.endtalk[1]="You saved our life.";
	quest.questshort="Bring some fish to Uron and Oll";
	quest.hint={};
	quest.hint[0]="You can find fish";
	quest.hint[1]="in Dock.";
	
	return Human_Quest(id,quest);
end