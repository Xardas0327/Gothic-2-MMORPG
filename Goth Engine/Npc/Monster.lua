--[[
	Animations
	S_FISTRUN: stand
	S_FISTRUNL: run
	S_FISTATTACK: attack
	T_WARN: warn
	T_STUMBLEB: stumble
	
]]

local monster={};

function Monster_Init()
	local handler=MySQL_Get();
	if handler~=nil then
		local servername=Setting_GetServerName();
		local animals=mysql_query(handler,string.format("SELECT `monstername`,`form`,`x`,`y`,`z`,`angle` FROM `monster` WHERE `servername`=%q",servername));
		if animals then
			local i=0;
			for animals,animal in mysql_rows_assoc(animals) do	
				local id=CreateNPC(animal['monstername']);
				monster[id]={};
				SetPlayerInstance(id,animal['form']);
				SetPlayerColor(id,255,255,255);
				
				monster[id].x=tonumber(animal['x']);
				monster[id].y=tonumber(animal['y']);
				monster[id].z=tonumber(animal['z']);
				monster[id].angle=tonumber(animal['angle']);
				
				local result=mysql_query(handler,string.format("SELECT `lvl`,`hp`,`mana`,`str`,`dex`,`xp`,`hitdistance`,`markdistance` FROM `monster_stat` WHERE `form`=%q",animal['form']));
				local stat=mysql_fetch_assoc(result);
				mysql_free_result(result);
				SetPlayerLevel(id,tonumber(stat['lvl']));
				SetPlayerMaxHealth(id,tonumber(stat['hp']));
				SetPlayerHealth(id,tonumber(stat['hp']));
				SetPlayerMaxMana(id,tonumber(stat['mana']));
				SetPlayerMana(id,tonumber(stat['mana']));
				SetPlayerStrength(id,tonumber(stat['str']));
				SetPlayerDexterity(id,tonumber(stat['dex']));
				monster[id].xp=tonumber(stat['xp']);
				monster[id].hitdistance=tonumber(stat['hitdistance']);
				monster[id].markdistance=tonumber(stat['markdistance']);
				
				monster[id].target=nil;
				monster[id].newtarget=nil;
				monster[id].hited=false;
				monster[id].tired=true;
				monster[id].stamina=0;
				monster[id].fightend=false;
				monster[id].death=false;
				monster[id].attackMode=false;
				monster[id].ai= SetTimerEx("Monster_Ai",1000,1,id);
				
				SpawnPlayer(id);
				SetPlayerPos(id,monster[id].x,monster[id].y,monster[id].z);
				SetPlayerAngle(id,monster[id].angle);
				Log_System(string.format("Monster: %s (id: %d)",animal['monstername'],id));
				i=i+1;
			end
			Log_System(string.format("Monster: %d",i));
			
			Respawn_AddText(string.format("%s animals live in forests and around them.",i),1400,"Font_Old_20_White_Hi.TGA");
			
			mysql_free_result(animals);
		else
			Log_System("Monster: Database lost.");
		end
	else
		Log_System("Monster: Database lost.");
	end
end

function Monster_Is(id)
	if id==nil then
		return false;
	end
	
	return monster[id]~=nil;
end

function Monster_Standard(id)
	monster[id].target=nil;
	monster[id].newtarget=nil;
	monster[id].fightend=true;
	monster[id].stamina=0;
	monster[id].tired=true;
	monster[id].attackMode=false;
	PlayAnimation(id,"S_FISTRUN");
end

function Monster_Spawn(id)
	if monster[id]~=nil then
		SetPlayerPos(id,monster[id].x,monster[id].y,monster[id].z);
		SetPlayerAngle(id,monster[id].angle);
	end
end

function Monster_Ai(id)
	if monster[id].attackMode then
		Monster_Attack(id);
	else
		Monster_Search(id);
	end
end

function Monster_Search(id)
	if monster[id].target==nil and GetPlayerHealth(id) > 0 then
		local i=0;
		local maxPlayer=GetMaxPlayers();
		while (i<maxPlayer and (not monster[id].attackMode)) do
			if Player_Is(i) then
				local account=Player_GetAccount(i);
				local character=GPlayer.GetCharacter(account);
				
				if character~=nil and GCharacter.GetHealth(character) > 0 then
					if GetDistancePlayers(id,i) <= monster[id].markdistance then
						monster[id].target=i;
						monster[id].attackMode=true;
					end
				end
			end
			i=i+1;
		end
		
		local maxhp=GetPlayerMaxHealth(id);
		local hp=GetPlayerHealth(id);
		
		if monster[id].fightend and monster[id].target==nil then
			SetPlayerPos(id,monster[id].x,monster[id].y,monster[id].z);
			SetPlayerAngle(id,monster[id].angle);
			monster[id].fightend=false;
		elseif monster[id].target==nil and maxhp > hp then
			local heal=math.floor(maxhp/100);
			if heal==0 then
				heal=1
			end
			if maxhp<hp+heal then
				SetPlayerHealth(id,maxhp);
			else
				SetPlayerHealth(id,hp+heal);
			end
		end
	end
end

function Monster_Attack(id) 
	local target=monster[id].target;
	if Player_Is(target) then
		local account=Player_GetAccount(target);
		local character=GPlayer.GetCharacter(account);
				
		if character~=nil and GCharacter.GetHealth(character) > 0 then
			local distance = GetDistancePlayers(id,target);
				
			if distance>monster[id].markdistance then
				Monster_Standard(id);
			else
			
				SetPlayerAngle(id,GetAngleToPlayer(id,target));	
				if distance > monster[id].hitdistance and monster[id].tired then
					PlayAnimation(id,"T_WARN");
					monster[id].stamina=monster[id].stamina+1;
					if(monster[id].stamina>=3) then
						monster[id].tired=false;
					end
				elseif distance > monster[id].hitdistance then
					PlayAnimation(id,"S_FISTRUNL");
					monster[id].stamina=monster[id].stamina-0.5;
					if(monster[id].stamina<=0) then
						monster[id].stamina=0;
						monster[id].tired=true;
					end					
				else
					monster[id].stamina=monster[id].stamina+0.1;
					if not(monster[id].hited) then
						PlayAnimation(id,"S_FISTATTACK");
						HitPlayer(id,target);
					else
						PlayAnimation(id,"S_FISTRUN");
						monster[id].hited=false;
					end
				end
			end
		else
			Monster_Standard(id);
		end
	end
end

function Monster_Take_Damage(id, hitid)
	if monster[id]~=nil then
		PlayAnimation(id,"T_STUMBLEB");
		monster[id].hited=true;
		if monster[id].target==hitid then
			monster[id].newtarget=nil;
		elseif monster[id].newtarget==hitid then
			monster[id].target=hitid
		else
			monster[id].newtarget=hitid;
		end
	end
end

function Monster_Death(deathid, killerid)
	if monster[deathid]~=nil then
		if monster[deathid].target==nil then
			monster[deathid].target=killerid;
		end
		if Player_Is(monster[deathid].target) then
			local number,partners=Character_Party_Partners(monster[deathid].target);
			Character_Quest_Kill(deathid,monster[deathid].target);
			Character_Stat_Xp_Increase(monster[deathid].target, math.floor(monster[deathid].xp/(number+1)),string.format("Kill %s",GetPlayerName(deathid)));
			for i=0,number-1 do
				if GetDistancePlayers(monster[deathid].target,partners[i])<3000 then
					Character_Quest_Kill(deathid,partners[i]);
					Character_Stat_Xp_Increase(partners[i], math.floor(monster[deathid].xp/(number+1)),string.format("Kill %s",GetPlayerName(deathid)));
				end
			end
			Loot_Player(monster[deathid].target,GetPlayerName(deathid));
		end
		Monster_Standard(deathid);
	end
	
	if monster[killerid]~=nil then
		if monster[killerid].newtarget~=nil then
			monster[killerid].target=monster[killerid].newtarget;
		else
			Monster_Standard(killerid);
		end
		if Player_Is(deathid) then
			Log_Player(deathid,string.format("%s kill (s)he.",GetPlayerName(killerid)));
		end
	end
end