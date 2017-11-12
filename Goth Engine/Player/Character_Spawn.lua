
local servername=nil;
local posTimer={};

function Character_Spawn_Init()
	servername=Setting_GetServerName();
end

function Character_Spawn_Delete(name)
	local handler=MySQL_Get();
	if handler~=nil then
		mysql_query(handler, string.format("DELETE FROM `character_spawn` WHERE `charname`=%q AND `servername`=%q",name,servername));
	else
		Log_System("Character Spawn: Database lost.");
	end
end

function Character_Spawn(playerid,name)
	local handler=MySQL_Get();
	if handler~=nil then
		local spawnresult = mysql_query(handler, string.format("SELECT `x`,`y`,`z`,`angle` FROM `character_spawn` WHERE `charname`=%q AND `servername`=%q",name,servername));
		if spawnresult then 
			local spawn = mysql_fetch_assoc(spawnresult);
			mysql_free_result(spawnresult);
			local place;
			local account=Player_GetAccount(playerid);
			if (not spawn) or GPlayer.IsDead(account) then
				spawn = mysql_query(handler, string.format("SELECT `x`,`y`,`z`,`angle` FROM `character_spawn_init` WHERE `servername`=%q",servername));
				local rand = random(mysql_num_rows(spawn));
				mysql_free_result(spawn);
				spawn = mysql_query(handler, string.format("SELECT `x`,`y`,`z`,`angle` FROM `character_spawn_init` WHERE `id`=%d AND `servername`=%q",rand,servername));
				place = mysql_fetch_assoc(spawn);
				mysql_free_result(spawn);
			else
				place=spawn;
			end
					
			SetPlayerPos(playerid,tonumber(place['x']),tonumber(place['y']),tonumber(place['z']));
			SetPlayerAngle(playerid,tonumber(place['angle']));
			
			posTimer[playerid]=SetTimerEx("Character_Spawn_Save",10000,1,playerid);
			
			return true;
		else
			SendPlayerMessage(playerid,255,255,0,"(Server): Database Error");
		end
	else
		SendPlayerMessage(playerid,255,255,0,"(Server): Database Error");
		Log_System("Character Spawn: Database lost.");
	end
	return false;
end

function Character_Spawn_Save(playerid)
	local handler=MySQL_Get();
	if handler~=nil then
		local account=Player_GetAccount(playerid);
		if Player_Is(playerid) and GPlayer.IsLoginCharacter(account) then
			local character=GPlayer.GetCharacter(account);
			local name=GCharacter.GetName(character);
			
			local spawn = mysql_query(handler, string.format("SELECT `charname` FROM `character_spawn` WHERE `charname`=%q AND `servername`=%q",name,servername));
			local place = mysql_fetch_row(spawn);
			mysql_free_result(spawn);
			local x,y,z = GetPlayerPos(playerid);
			if (not place) then
				mysql_query(handler, string.format("INSERT INTO `character_spawn`(`servername`,`charname`,`x`,`y`,`z`,`angle`) values(%q,%q,%d,%d,%d,%d)",servername,name,x,y,z,GetPlayerAngle(playerid)));
			else
				mysql_query(handler, string.format("UPDATE `character_spawn` SET `x`=%d,`y`=%d,`z`=%d,`angle`=%d WHERE `charname`=%q AND `servername`=%q",x,y,z,GetPlayerAngle(playerid),name,servername));
			end
		else
			if posTimer[playerid]~=nil and IsTimerActive(posTimer[playerid]) then
				KillTimer(posTimer[playerid]);
			end
		end
	else
		SendPlayerMessage(playerid,255,255,0,"(Server): Database Error");
		Log_System("Character Spawn: Database lost.");
	end
end

function Character_Spawn_Dead(playerid)
	if posTimer[playerid]~=nil and IsTimerActive(posTimer[playerid]) then
		KillTimer(posTimer[playerid]);
	end
end

function Character_Spawn_Logout(playerid)
	if posTimer[playerid]~=nil and IsTimerActive(posTimer[playerid]) then
		KillTimer(posTimer[playerid]);
	end
	Character_Spawn_Save(playerid);
end