--[[
	arguments: mc,str,dex,mana,oneh,twoh,bow,cbow,acrobatic,relp
]]

local trainer={};

local player={}
for i = 0, GetMaxPlayers() - 1 do
	player[i]={};
	player[i].target=nil;
	player[i].active=false;
	player[i].lp={};
	for j = 0,2 do
		player[i].lp[j]=0;
	end
end

local acrobatic_price=10; --base value

local box_show=nil;
local box_refresh=nil;
local box_hide=nil;
local box_key=nil;

function Human_Trainer_Init_Box(show,refresh,hide,key)
	box_show=show;
	box_refresh=refresh;
	box_hide=hide;
	box_key=key;
end

function Human_Trainer(npcid,argument)
	
	local ready=false;
	trainer[npcid]={};
	argument=string.lower(argument);
	
	if argument=="mc" then
		trainer[npcid].get=GCharacter.GetMagicCircle;
		trainer[npcid].set=Character_Stat_Mc_Increase;
		trainer[npcid].text="Magic Circle";

		ready=true;
	end
	
	if argument=="str" then
		trainer[npcid].get=GCharacter.GetStrength;
		trainer[npcid].set=Character_Stat_Str_Increase;
		trainer[npcid].text="Strength";

		ready=true;
	end
	
	if argument=="dex" then
		trainer[npcid].get=GCharacter.GetDexterity;
		trainer[npcid].set=Character_Stat_Dex_Increase;
		trainer[npcid].text="Dexterity";

		ready=true;
	end
	
	if argument=="mana" then
		trainer[npcid].get=GCharacter.GetMaxMana;
		trainer[npcid].set=Character_Stat_Mana_Increase;
		trainer[npcid].text="Mana";

		ready=true;
	end
	
	if argument=="oneh" then
		trainer[npcid].get=GCharacter.GetOneHand;
		trainer[npcid].set=Character_Stat_Oneh_Increase;
		trainer[npcid].text="One-hand";

		ready=true;
	end
	
	if argument=="twoh" then
		trainer[npcid].get=GCharacter.GetTwoHand;
		trainer[npcid].set=Character_Stat_Twoh_Increase;
		trainer[npcid].text="Two-hand";

		ready=true;
	end
	
	if argument=="bow" then
		trainer[npcid].get=GCharacter.GetBow;
		trainer[npcid].set=Character_Stat_Bow_Increase;
		trainer[npcid].text="Bow";

		ready=true;
	end
	
	if argument=="cbow" then
		trainer[npcid].get=GCharacter.GetCrossBow;
		trainer[npcid].set=Character_Stat_CBow_Increase;
		trainer[npcid].text="Crossbow";

		ready=true;
	end
	
	if argument=="acrobatic" then
		trainer[npcid].get=GCharacter.GetAcrobatic;
		trainer[npcid].set=Character_Stat_Acrobatic;
		trainer[npcid].text="Acrobatic";

		ready=true;
	end
	
	if argument=="relp" then
		trainer[npcid].set=Character_Stat_Relp;
		trainer[npcid].text="I want to forget everything.";

		ready=true;
	end
	
	if ready then
		trainer[npcid].angle=GetPlayerAngle(npcid);
		return Human_Trainer_Show;
	else
		Log_System(string.format("Human Trainer: %s argument doesn't exist, that is why %s isn't trainer.",argument,GetPlayerName(npcid)));
		return nil;
	end
end

function Human_Trainer_Acrobatic_Price(new)
	if new>0 then
		acrobatic_price=new
		local message=string.format("Human Trainer: The acrobatic's price is %d.",new);
		Admin_AllAdminMessage(message);
		Log_System(message);
	else
		Log_System(string.format("Human Trainer: The acrobatic's price is more 0. That is why it is %d.",acrobatic_price));
	end
end

function Human_Trainer_CommandText(playerid, cmdtext)
	local account=Player_GetAccount(playerid);
	
	if player[playerid].active and GPlayer.IsLoginCharacter(account) then
		if cmdtext=="/help" then
			Help_Message(playerid,"trainer");
		end
	end
end

function Human_Trainer_Show(playerid,npcid)
	local account=Player_GetAccount(playerid);
	
	if (not GPlayer.IsBusy(account)) then
		player[playerid].active=true;
		
		GPlayer.SetBusy(account,true);
		SetPlayerAngle(npcid,GetAngleToPlayer(npcid,playerid));	
		SetPlayerAngle(playerid,GetAngleToPlayer(playerid,npcid));	
		box_show(playerid);
		player[playerid].target=npcid;
		Human_Trainer_Refresh(playerid);
	end
end

function Human_Trainer_Refresh(playerid)
	local message={};	
	message[3]="Exit";
	local npcid=player[playerid].target;
	
	if trainer[npcid].set==Character_Stat_Relp then
		message[0]=trainer[npcid].text;
		message[1]=nil;
		message[2]=nil;
	else
		local stat=0;
		local missing=0;
		
		local account=Player_GetAccount(playerid);
		local character=GPlayer.GetCharacter(account);
		
		if trainer[npcid].text=="One-hand" or trainer[npcid].text=="Two-hand"
			or trainer[npcid].text=="Bow" or trainer[npcid].text=="Crossbow" then
			stat=trainer[npcid].get(character);
			missing=math.min(Character_Stat_Lp_reduction(stat)*Character_Stat_Nextlevel(),100)-stat;
			
		elseif trainer[npcid].text=="Magic Circle" then
			stat=trainer[npcid].get(character);
			missing=6-stat;
			
		elseif trainer[npcid].text=="Acrobatic" then
			stat=trainer[npcid].get(character);
			missing=1-stat;
			
		else 
			stat=trainer[npcid].get(character);
			missing=Character_Stat_Lp_reduction(stat)*Character_Stat_Nextlevel()-stat;
		end
		
		if missing==0 then
			message[0]=nil;
		else
			if trainer[npcid].text=="Magic Circle" then
				player[playerid].lp[0]=(stat+1)*5;
			elseif trainer[npcid].text=="Acrobatic" then
				player[playerid].lp[0]=acrobatic_price;
			else
				player[playerid].lp[0]=Character_Stat_Lp_reduction(stat);
			end
			message[0]=string.format("%s +1 (%d lp)",trainer[npcid].text,player[playerid].lp[0]);
		end
		
		if missing<=5 or trainer[npcid].text=="Magic Circle" or trainer[npcid].text=="Acrobatic" then
			message[1]=nil;
		else
			player[playerid].lp[1]=Character_Stat_Lp_reduction(stat)*5;
			message[1]=string.format("%s +5 (%d lp)",trainer[npcid].text,player[playerid].lp[1]);
		end
		
		if missing<=1 or trainer[npcid].text=="Acrobatic" then
			message[2]=nil;
		else
			if trainer[npcid].text=="Magic Circle" then
				local x=6
				player[playerid].lp[2]=0;
				while x>stat do
					player[playerid].lp[2]=player[playerid].lp[2]+x*5;
					x=x-1;
				end
			else
				player[playerid].lp[2]=Character_Stat_Lp_reduction(stat)*missing;
			end
			message[2]=string.format("%s +%d (%d lp)",trainer[npcid].text,missing,player[playerid].lp[2]);
		end
	end
	box_refresh(playerid,message);
end

function Human_Trainer_Hide(playerid)
	if player[playerid].active then
		box_hide(playerid);
		player[playerid].active=false;
		
		local account=Player_GetAccount(playerid);
		GPlayer.SetBusy(account,false);
		SetPlayerAngle(player[playerid].target,trainer[player[playerid].target].angle);
	end
end

function Human_Trainer_Active(playerid)
	return player[playerid].active;
end

function Human_Trainer_Logout(playerid)
	if player[playerid].active then
		Human_Trainer_Hide(playerid);
	end
end


function Human_Trainer_Learn(playerid,row)
	if row==3 then
		Human_Trainer_Hide(playerid);
	else
		local target=player[playerid].target;
		if trainer[target].set==Character_Stat_Relp then
			trainer[target].set(playerid);
			Human_Trainer_Hide(playerid);
		else
			if trainer[target].set(playerid,player[playerid].lp[row]) then
				Human_Trainer_Refresh(playerid);
			end
		end
	end
end

function Human_Trainer_Key(playerid,keydown)	
	if player[playerid].active then
		box_key(playerid,keydown);
	end
end