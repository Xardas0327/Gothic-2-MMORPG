
local servername=nil;
local nextlevel=30;
local maxlevel=nil;
local hpManaTimer={};

local gtfp={};
gtfp.x=2000;
gtfp.y=4500;

function Character_Stat_Init()
	servername=Setting_GetServerName();
	Human_Quest_XpFunc(Character_Stat_Xp_Increase);
end

function Character_Stat_Create(name)
	local handler=MySQL_Get();
	if handler~=nil then
		mysql_query(handler,string.format("INSERT INTO `character_stat`(`servername`,`charname`) VALUES (%q,%q)",servername,name));
	else
		Log_System("Character Stat: Database lost.");
	end
end

function Character_Stat_Delete(name)
	local handler=MySQL_Get();
	if handler~=nil then
		mysql_query(handler,string.format("DELETE FROM `character_stat` WHERE `servername`=%q AND `charname`=%q",servername,name));
	else
		Log_System("Character Stat: Database lost.");
	end
end

function Character_Stat_Load(playerid,name)
	local handler=MySQL_Get();
	
	if handler~=nil then
		local statresult = mysql_query(handler, string.format("SELECT `lvl`,`mc`,`xp`,`nextlvl`,`lp`,`str`,`dex`,`maxhp`,`hp`,`maxmana`,`mana`,`oneh`,`twoh`,`bow`,`cbow`,`acrobatic` FROM `character_stat` WHERE `servername`=%q AND `charname`=%q",servername,name));
		if statresult then
			stat = mysql_fetch_assoc(statresult);
			mysql_free_result(statresult);
			if stat then
				local account=Player_GetAccount(playerid);
				local character=GPlayer.GetCharacter(account);
				
				GCharacter.SetLevel(character,tonumber(stat['lvl']));
				GCharacter.SetMagicCircle(character,tonumber(stat['mc']));
				GCharacter.SetXp(character,tonumber(stat['xp']));
				GCharacter.SetXpNextLvl(character,tonumber(stat['nextlvl']));
				GCharacter.SetLearnPoint(character,tonumber(stat['lp']));
				GCharacter.SetStrength(character,tonumber(stat['str']));
				GCharacter.SetDexterity(character,tonumber(stat['dex']));
				GCharacter.SetMaxHealth(character,tonumber(stat['maxhp']));
				GCharacter.SetMaxMana(character,tonumber(stat['maxmana']));
				GCharacter.SetOneHand(character,tonumber(stat['oneh']));
				GCharacter.SetTwoHand(character,tonumber(stat['twoh']));
				GCharacter.SetBow(character,tonumber(stat['bow']));
				GCharacter.SetCrossBow(character,tonumber(stat['cbow']));
				GCharacter.SetAcrobatic(character,tonumber(stat['acrobatic']));
				
				if (not GPlayer.IsDead(account)) then
					GCharacter.SetHealth(character,tonumber(stat['hp']));
					GCharacter.SetMana(character,tonumber(stat['mana']));
				else
					GCharacter.SetHealth(character,tonumber(stat['maxhp']));
					GCharacter.SetMana(character,tonumber(stat['maxmana']));
				end
				
				hpManaTimer[playerid]=SetTimerEx("Character_Stat_Save",10000,1,playerid);
				
				return true;
			else
				SendPlayerMessage(playerid,255,255,0,string.format("(Server): Database Error. The character's stat lost."));
			end;
		else
			SendPlayerMessage(playerid,255,255,0,"(Server): Database Error");
		end
	else
		SendPlayerMessage(playerid,255,255,0,"(Server): Database Error");
		Log_System("Character Stat: Database lost.");
	end
	return false;
end

function Character_Stat_Max_Level(number)
	if number==nil or number>-1 then
		maxlevel=number;
		local message="";
		if number~=nil then
			message=string.format("Character Stat: The max level is %d.",number);
		else
			message="Character Stat: The max level is infinite.";
		end
		Admin_AllAdminMessage(message);
		Log_System(message);
	else
		 Log_System("Character Stat: The new maxlevel is positiv or nil (the nil is infinite).");
	end
end

function Character_Stat_Xp_Increase(playerid, number,why)
	local handler=MySQL_Get();
	if handler~=nil then
		Log_Player(playerid,why);
		local account=Player_GetAccount(playerid);
		local character=GPlayer.GetCharacter(account);
		local lvl=GCharacter.GetLevel(character);
		
		if maxlevel==nil or lvl<maxlevel then
			local oldxp=GCharacter.GetXp(character);
			local xp=oldxp+number;
			local message="";
			local nextlvl=GCharacter.GetXpNextLvl(character);
			local characterName=GCharacter.GetName(character);
			GCharacter.SetXp(character,xp);
			
			if xp>=nextlvl then		
				lvl=lvl+1;
				GCharacter.SetLevel(character,lvl);
				message=string.format("LEVEL %d",lvl);
				Log_Player(playerid,message);
				
				if maxlevel~=nil and lvl==maxlevel then
					xp=nextlvl;
					GCharacter.SetXp(character,xp);
				end
				
				nextlvl=nextlvl+(lvl+1)*500;
				GCharacter.SetXpNextLvl(character,nextlvl);
				
				local lp=GCharacter.GetLearnPoint(character)+10;
				GCharacter.SetLearnPoint(character,lp);
				
				local hp=40+lvl*12;
				GCharacter.SetMaxHealth(character,hp);
				GCharacter.SetHealth(character,GCharacter.GetHealth(character)+12);
				
				mysql_query(handler,string.format("UPDATE `character_stat` SET `lp`=%d, `lvl`=%d, `xp`=%d, `nextlvl`=%d, `maxhp`=%d  WHERE `charname`=%q AND `servername`=%q",lp,lvl,xp,nextlvl,hp,characterName,servername));
				GameTextForPlayer(playerid,gtfp.x+1500,gtfp.y,message,"Font_Old_20_White_Hi.TGA",255,255,255,2000);
			else
				mysql_query(handler,string.format("UPDATE `character_stat` SET `xp`=%d WHERE `charname`=%q AND `servername`=%q",xp,characterName,servername));
				message=string.format("Experience: %d+%d=%d",oldxp,number,xp)
				Log_Player(playerid,message);
				GameTextForPlayer(playerid,gtfp.x+1000,gtfp.y,message,"Font_Old_10_White_Hi.TGA",255,255,255,2000);
			end
		end
	else
		SendPlayerMessage(playerid,255,255,0,"(Server): Database Error");
		Log_System("Character Stat: Database lost.");
	end
end

function  Character_Stat_Relp(playerid)
	local handler=MySQL_Get();
	if handler~=nil then
		Log_Player(playerid,"(S)he forgot everything.");
		local account=Player_GetAccount(playerid);
		local character=GPlayer.GetCharacter(account);
		
		GCharacter.SetMagicCircle(character,0);
		local lp=GCharacter.GetLevel(character)*10;
		GCharacter.SetLearnPoint(character,lp);
		GCharacter.SetStrength(character,10);
		GCharacter.SetDexterity(character,10);
		GCharacter.SetMaxMana(character,10);
		GCharacter.SetMana(character,10);
		GCharacter.SetOneHand(character,10);
		GCharacter.SetTwoHand(character,10);
		GCharacter.SetBow(character,10);
		GCharacter.SetCrossBow(character,10);
		GCharacter.SetAcrobatic(character,0);
		
		mysql_query(handler,string.format("UPDATE `character_stat` SET `lp`=%d, `str`=10, `dex`=10, `mana`=10, `maxmana`=10, `oneh`=10, `twoh`=10, `bow`=10, `cbow`=10 ,`acrobatic`=0 WHERE `charname`=%q AND `servername`=%q",lp,GCharacter.GetName(character),servername));
		Character_Item_UnequipWeapons(playerid);
		GameTextForPlayer(playerid,gtfp.x+1000,gtfp.y,string.format("You forgot everything."),"Font_Old_20_White_Hi.TGA",255,255,255,2000);
	else
		SendPlayerMessage(playerid,255,255,0,"(Server): Database Error");
		Log_System("Character Stat: Database lost.");
	end
end

function  Character_Stat_Few_Lp(playerid)
	GameTextForPlayer(playerid,gtfp.x,gtfp.y,string.format("You don't have enough learn points."),"Font_Old_20_White_Hi.TGA",255,255,255,2000);
end

function  Character_Stat_Mc_Increase(playerid, number)
	local handler=MySQL_Get();
	if handler~=nil then
		local account=Player_GetAccount(playerid);
		local character=GPlayer.GetCharacter(account);
		
		local mc=GCharacter.GetMagicCircle(character);
		if mc<6 then
			local lp=GCharacter.GetLearnPoint(character);
			if lp>=number then
				lp=lp-number;
				GCharacter.SetLearnPoint(character,lp);
				mc=mc+1;
				GCharacter.SetMagicCircle(character,mc);
				local message=string.format("Magic Circle: %d ",mc);
				Log_Player(playerid,message);
				
				mysql_query(handler,string.format("UPDATE `character_stat` SET `lp`=%d, `mc`=%d  WHERE `charname`=%q AND `servername`=%q",lp,mc,GCharacter.GetName(character),servername));
				GameTextForPlayer(playerid,gtfp.x+1000,gtfp.y,message,"Font_Old_20_White_Hi.TGA",255,255,255,2000);
				return true;
			else
				Character_Stat_Few_Lp(playerid);
			end;
		else
			GameTextForPlayer(playerid,gtfp.x,gtfp.y,string.format("Your magic knowledge is perfect."),"Font_Old_20_White_Hi.TGA",255,255,255,2000);
		end;
	else
		SendPlayerMessage(playerid,255,255,0,"(Server): Database Error");
		Log_System("Character Stat: Database lost.");
	end
	return false;
end

function Character_Stat_Lp_reduction(number)
	return  math.floor(number/nextlevel+1);
end

function Character_Stat_Nextlevel_Change(number)
	if number%5==0 then
		nextlevel=number;
		local message=string.format("Character Stat: The new nextlevel is %d.",number);
		Admin_AllAdminMessage(message);
		Log_System(message);
	else
		 Log_System(string.format("Character Stat: The new nextlevel don't divisible 5, that's why it is %d.",nextlevel));
	end
end

function Character_Stat_Nextlevel()
	return nextlevel;
end

function  Character_Stat_Str_Increase(playerid, number)
	local handler=MySQL_Get();
	if handler~=nil then
		local account=Player_GetAccount(playerid);
		local character=GPlayer.GetCharacter(account);
		local lp=GCharacter.GetLearnPoint(character);
		
		if lp>=number then
			lp=lp-number;
			GCharacter.SetLearnPoint(character,lp);
			
			local str=GCharacter.GetStrength(character);
			number=number/Character_Stat_Lp_reduction(str);
			local newstr= str+number;
			GCharacter.SetStrength(character, newstr);
			
			local message=string.format("Strength: %d+%d=%d ",str,number,newstr);			
			Log_Player(playerid,message);
			mysql_query(handler,string.format("UPDATE `character_stat` SET `lp`=%d, `str`=%d  WHERE `charname`=%q AND `servername`=%q",lp,newstr,GCharacter.GetName(character),servername));
			GameTextForPlayer(playerid,gtfp.x+1000,gtfp.y,message,"Font_Old_20_White_Hi.TGA",255,255,255,2000);
			return true;
		else
			Character_Stat_Few_Lp(playerid);
		end
	else
		SendPlayerMessage(playerid,255,255,0,"(Server): Database Error");
		Log_System("Character Stat: Database lost.");
	end
	return false;
end

function  Character_Stat_Dex_Increase(playerid, number)
	local handler=MySQL_Get();
	if handler~=nil then
		local account=Player_GetAccount(playerid);
		local character=GPlayer.GetCharacter(account);
		local lp=GCharacter.GetLearnPoint(character);
		
		if lp>=number then
			lp=lp-number;
			GCharacter.SetLearnPoint(character,lp);
			
			local dex=GCharacter.GetDexterity(character);
			number=number/Character_Stat_Lp_reduction(dex);
			local newdex= dex+number;
			GCharacter.SetDexterity(character,newdex);
			
			local message=string.format("Dexterity: %d+%d=%d ",dex,number,newdex);			
			Log_Player(playerid,message);		
			mysql_query(handler,string.format("UPDATE `character_stat` SET `lp`=%d, `dex`=%d  WHERE `charname`=%q AND `servername`=%q",lp,newdex,GCharacter.GetName(character),servername));
			GameTextForPlayer(playerid,gtfp.x+1000,gtfp.y,message,"Font_Old_20_White_Hi.TGA",255,255,255,2000);
			return true;
		else
			Character_Stat_Few_Lp(playerid);
		end
	else
		SendPlayerMessage(playerid,255,255,0,"(Server): Database Error");
		Log_System("Character Stat: Database lost.");
	end
	return false;
end

function  Character_Stat_Mana_Increase(playerid, number)
	local handler=MySQL_Get();
	if handler~=nil then
		local account=Player_GetAccount(playerid);
		local character=GPlayer.GetCharacter(account);
		local lp=GCharacter.GetLearnPoint(character);
		
		if lp>=number then
			lp=lp-number;
			GCharacter.SetLearnPoint(character,lp);
			
			local mana=GCharacter.GetMaxMana(character);
			number=number/Character_Stat_Lp_reduction(mana);
			local newmana= mana+number;
			GCharacter.SetMaxMana(character,newmana);
			GCharacter.SetMana(character,GCharacter.GetMana(character)+number);

			local message=string.format("Mana: %d+%d=%d ",mana,number,newmana);	
			Log_Player(playerid,message);
			mysql_query(handler,string.format("UPDATE `character_stat` SET `lp`=%d, `maxmana`=%d  WHERE `charname`=%q AND `servername`=%q",lp,newmana,GCharacter.GetName(character),servername));
			GameTextForPlayer(playerid,gtfp.x+1000,gtfp.y,message,"Font_Old_20_White_Hi.TGA",255,255,255,2000);
			return true;
		else
			Character_Stat_Few_Lp(playerid);
		end
	else
		SendPlayerMessage(playerid,255,255,0,"(Server): Database Error");
		Log_System("Character Stat: Database lost.");
	end
	return false;
end

function  Character_Stat_Oneh_Increase(playerid, number)
	local handler=MySQL_Get();
	if handler~=nil then
		local account=Player_GetAccount(playerid);
		local character=GPlayer.GetCharacter(account);
		local oneh=GCharacter.GetOneHand(character);
		
		if oneh<100 then
			local lp=GCharacter.GetLearnPoint(character);
			
			if lp>=number then
				local newoneh=oneh+number/Character_Stat_Lp_reduction(oneh);			
				if newoneh>100 then
					number=(100-oneh)*Character_Stat_Lp_reduction(oneh);
					newoneh=100;
				end
				lp=lp-number;
				GCharacter.SetLearnPoint(character,lp);
				GCharacter.SetOneHand(character,newoneh);

				local message=string.format("One-handed: %d%%+%d%%=%d%% ",oneh,number/Character_Stat_Lp_reduction(oneh),newoneh);
				Log_Player(playerid,message);
				mysql_query(handler,string.format("UPDATE `character_stat` SET `lp`=%d, `oneh`=%d  WHERE `charname`=%q AND `servername`=%q",lp,newoneh,GCharacter.GetName(character),servername));
				GameTextForPlayer(playerid,gtfp.x+1000,gtfp.y,message,"Font_Old_20_White_Hi.TGA",255,255,255,2000);
				return true;
			else
				Character_Stat_Few_Lp(playerid);
			end
		else
			GameTextForPlayer(playerid,gtfp.x,gtfp.y,string.format("Your one-handed knowledge is perfect."),"Font_Old_20_White_Hi.TGA",255,255,255,2000);
		end
	else
		SendPlayerMessage(playerid,255,255,0,"(Server): Database Error");
		Log_System("Character Stat: Database lost.");
	end
	return false;
end

function  Character_Stat_Twoh_Increase(playerid, number)
	local handler=MySQL_Get();
	if handler~=nil then
		local account=Player_GetAccount(playerid);
		local character=GPlayer.GetCharacter(account);
		local twoh=GCharacter.GetTwoHand(character);
		
		if twoh<100 then
			local lp=GCharacter.GetLearnPoint(character);
			
			if lp>=number then
				local newtwoh=twoh+number/Character_Stat_Lp_reduction(twoh);			
				if newtwoh>100 then
					number=(100-twoh)*Character_Stat_Lp_reduction(twoh);
					newtwoh=100;
				end
				lp=lp-number;
				GCharacter.SetLearnPoint(character,lp);
				GCharacter.SetTwoHand(character,newtwoh);

				local message=string.format("Two-handed: %d%%+%d%%=%d%% ",twoh,number/Character_Stat_Lp_reduction(twoh),newtwoh);
				Log_Player(playerid,message);				
				mysql_query(handler,string.format("UPDATE `character_stat` SET `lp`=%d, `twoh`=%d  WHERE `charname`=%q AND `servername`=%q",lp,newtwoh,GCharacter.GetName(character),servername));
				GameTextForPlayer(playerid,gtfp.x+1000,gtfp.y,message,"Font_Old_20_White_Hi.TGA",255,255,255,2000);
				return true;
			else
				Character_Stat_Few_Lp(playerid);
			end
		else
			GameTextForPlayer(playerid,gtfp.x,gtfp.y,string.format("Your two-handed knowledge is perfect."),"Font_Old_20_White_Hi.TGA",255,255,255,2000);
		end
	else
		SendPlayerMessage(playerid,255,255,0,"(Server): Database Error");
		Log_System("Character Stat: Database lost.");
	end
	return false;
end

function  Character_Stat_Bow_Increase(playerid, number)
	local handler=MySQL_Get();
	if handler~=nil then
		local account=Player_GetAccount(playerid);
		local character=GPlayer.GetCharacter(account);
		local bow=GCharacter.GetBow(character);
		
		if bow<100 then
			local lp=GCharacter.GetLearnPoint(character);
			
			if lp>=number then
				local newbow=bow+number/Character_Stat_Lp_reduction(bow);			
				if newbow>100 then
					number=(100-bow)*Character_Stat_Lp_reduction(bow);
					newbow=100;
				end
				lp=lp-number;
				GCharacter.SetLearnPoint(character,lp);
				GCharacter.SetBow(character,newbow);
				
				local message=string.format("Bow: %d%%+%d%%=%d%% ",bow,number/Character_Stat_Lp_reduction(bow),newbow);
				Log_Player(playerid,message);				
				mysql_query(handler,string.format("UPDATE `character_stat` SET `lp`=%d, `bow`=%d  WHERE `charname`=%q AND `servername`=%q",lp,newbow,GCharacter.GetName(character),servername));
				GameTextForPlayer(playerid,gtfp.x+1000,gtfp.y,message,"Font_Old_20_White_Hi.TGA",255,255,255,2000);
				return true;
			else
				Character_Stat_Few_Lp(playerid);
			end
		else
			GameTextForPlayer(playerid,gtfp.x,gtfp.y,string.format("Your bow knowledge is perfect."),"Font_Old_20_White_Hi.TGA",255,255,255,2000);
		end
	else
		SendPlayerMessage(playerid,255,255,0,"(Server): Database Error");
		Log_System("Character Stat: Database lost.");
	end
	return false;
end

function  Character_Stat_CBow_Increase(playerid, number)
	local handler=MySQL_Get();
	if handler~=nil then
		local account=Player_GetAccount(playerid);
		local character=GPlayer.GetCharacter(account);
		local cbow=GCharacter.GetCrossBow(character);
		
		if cbow<100 then
			local lp=GCharacter.GetLearnPoint(character);
			
			if lp>=number then
				local newcbow=cbow+number/Character_Stat_Lp_reduction(cbow);			
				if newcbow>100 then
					number=(100-cbow)*Character_Stat_Lp_reduction(cbow);
					newcbow=100;
				end
				lp=lp-number;
				GCharacter.SetLearnPoint(character,lp);
				GCharacter.SetCrossBow(self,newcbow);
				
				local message=string.format("Crossbow: %d%%+%d%%=%d%% ",cbow,number/Character_Stat_Lp_reduction(cbow),newcbow);
				Log_Player(playerid,message);			
				mysql_query(handler,string.format("UPDATE `character_stat` SET `lp`=%d, `cbow`=%d  WHERE `charname`=%q AND `servername`=%q",lp,newcbow,GCharacter.GetName(character),servername));
				GameTextForPlayer(playerid,gtfp.x+1000,gtfp.y,message,"Font_Old_20_White_Hi.TGA",255,255,255,2000);		
				return true;
			else
				Character_Stat_Few_Lp(playerid);
			end
		else
			GameTextForPlayer(playerid,gtfp.x,gtfp.y,string.format("Your crossbow knowledge is perfect."),"Font_Old_20_White_Hi.TGA",255,255,255,2000);
		end
	else
		SendPlayerMessage(playerid,255,255,0,"(Server): Database Error");
		Log_System("Character Stat: Database lost.");
	end
	return false;
end

function  Character_Stat_Acrobatic(playerid, number)
	local handler=MySQL_Get();
	if handler~=nil then
		local account=Player_GetAccount(playerid);
		local character=GPlayer.GetCharacter(account);
		
		if GCharacter.GetAcrobatic(character)==0 then
			local lp=GCharacter.GetLearnPoint(character);
			
			if lp>=number then
				lp=lp-number;
				GCharacter.SetLearnPoint(character,lp);
				GCharacter.SetAcrobatic(character,1);
				
				local message=string.format("The acrobatic is learned.");
				Log_Player(playerid,message);
				mysql_query(handler,string.format("UPDATE `character_stat` SET `lp`=%d, `acrobatic`=1  WHERE `charname`=%q and `servername`=%q",lp,GCharacter.GetName(character),servername));
				GameTextForPlayer(playerid,gtfp.x+1000,gtfp.y,message,"Font_Old_20_White_Hi.TGA",255,255,255,2000);
				return true;
			else
				Character_Stat_Few_Lp(playerid);
			end
		else
			GameTextForPlayer(playerid,gtfp.x,gtfp.y,string.format("You have learned the acrobatic."),"Font_Old_20_White_Hi.TGA",255,255,255,2000);
		end
	else
		SendPlayerMessage(playerid,255,255,0,"(Server): Database Error");
		Log_System("Character Stat: Database lost.");
	end
	return false;
end

function  Character_Stat_ChangeStrength(playerid, newValue)
	Anticheat_Strength(playerid, newValue);
end

function  Character_Stat_ChangeDexterity(playerid, newValue)
	Anticheat_Dexterity(playerid, newValue);
end

function  Character_Stat_ChangeHealth(playerid, newValue)
	local busyHealth=GPlayer_GetBusyHealth();
	if Player_Is(playerid) and busyHealth~=newValue and (not Anticheat_Health(playerid, newValue)) then
 		local account=Player_GetAccount(playerid);
 		local character=GPlayer.GetCharacter(account);
 		if character~=nil then
			GCharacter.ChangeHealth(character , newValue);
 		end
 	end
 end

function  Character_Stat_ChangeMaxHealth(playerid, newValue)
	Anticheat_MaxHealth(playerid, newValue);
end

function  Character_Stat_ChangeMana(playerid, newValue)
	if Player_Is(playerid) and (not Anticheat_Mana(playerid, newValue)) then
 		local account=Player_GetAccount(playerid);
 		local character=GPlayer.GetCharacter(account);
 		if character~=nil then
			GCharacter.ChangeMana(character,newValue);
		end
	end
end

function  Character_Stat_ChangeMaxMana(playerid, newValue)
	Anticheat_MaxMana(playerid, newValue);
end

function  Character_Stat_ChangeSkillWeapon(playerid, skillId, newValue)
	Anticheat_SkillWeapon(playerid, skillID, newValue);
end

function  Character_Stat_ChangeAcrobatic(playerid, newValue)
	Anticheat_Acrobatic(playerid, newValue);
end

function  Character_Stat_Save(playerid)
	local handler=MySQL_Get();
	if handler~=nil then
		local account=Player_GetAccount(playerid);
		if Player_Is(playerid) and GPlayer.IsLoginCharacter(account) then
			local character=GPlayer.GetCharacter(account);
			local characterName=GCharacter.GetName(character);
			
			mysql_query(handler,string.format("UPDATE `character_stat` SET `hp`=%d, `mana`=%d  WHERE `charname`=%q AND `servername`=%q",GCharacter.GetHealth(character),GCharacter.GetMana(character),characterName,servername));
		else
			if hpManaTimer[playerid]~=nil and IsTimerActive(hpManaTimer[playerid]) then
				KillTimer(hpManaTimer[playerid]);
			end
		end
	else
		SendPlayerMessage(playerid,255,255,0,"(Server): Database Error");
		Log_System("Character Stat: Database lost.");
	end
end

function  Character_Stat_Dead(playerid)
	if hpManaTimer[playerid]~=nil and IsTimerActive(hpManaTimer[playerid]) then
		KillTimer(hpManaTimer[playerid]);
	end
end

function  Character_Stat_Logout(playerid)
	if hpManaTimer[playerid]~=nil and IsTimerActive(hpManaTimer[playerid]) then
		KillTimer(hpManaTimer[playerid]);
	end
	Character_Stat_Save(playerid);
end