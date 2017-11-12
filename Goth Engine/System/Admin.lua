
local helpname=nil;
local messagename=nil;
local pmname=nil;
local kickname=nil;
local banname=nil;
local timename=nil;
local teleportname=nil;
local posname=nil;
local distancename=nil;

function Admin_Help_Init_Use(name)
	helpname="/"..name;
end

function Admin_Message_Init_Use(name)
	messagename="/"..name;
end

function Admin_PrivateMessage_Init_Use(name)
	pmname="/"..name;
end

function Admin_Kick_Init_Use(name)
	kickname="/"..name;
end

function Admin_Ban_Init_Use(name)
	banname="/"..name;
end

function Admin_Time_Init_Use(name)
	timename="/"..name;
end

function Admin_Teleport_Init_Use(name)
	teleportname="/"..name;
end

function Admin_Position_Init_Use(name)
	posname="/"..name;
end

function Admin_Distance_Init_Use(name)
	distancename="/"..name;
end

function Admin_CommandText(playerid, cmdtext)
	local account=Player_GetAccount(playerid);
	
	if Player_Is(playerid) and GPlayer.IsLoginCharacter(account) then
		if GPlayer.IsAdmin(account) then
			local cmd,params = GetCommand(cmdtext);
			
			if cmdtext==helpname then
				Admin_Help(playerid);
			elseif cmd==messagename then
				Admin_Message(playerid,params);
			elseif cmd==pmname then
				Admin_PrivateMessage(playerid,params);
			elseif cmd==kickname then
				Admin_Kick(playerid,params);
			elseif cmd==banname then
				Admin_Ban(playerid,params);
			elseif cmd==timename then
				Admin_Time(playerid,params);
			elseif cmd==teleportname then
				Admin_Teleport(playerid,params);
			elseif cmd==posname then
				Admin_Position(playerid,params);
			elseif cmd==distancename then
				Admin_Distance(playerid,params);
			end
		else
			if cmdtext=="/admin" then
				Admin_Activation(playerid);
			end
		end
	end
end

function Admin_Activation(playerid)
	local handler=MySQL_Get();
	if handler~=nil then
		local account=Player_GetAccount(playerid);
		local accountName=GPlayer.GetAccountName(account);
		local exist = mysql_query(handler,string.format("SELECT `accname` FROM `account` WHERE `accname`=%q AND `admin`=1",accountName));
		if exist then
			local acc = mysql_fetch_assoc(exist);
			mysql_free_result(exist);
			if acc then
				GPlayer.SetAdmin(account,true);
				local message=string.format("%s account has been admin.",accountName);
				Admin_AllAdminMessage(message);
				Log_System(message);
				Log_Player(playerid,message);
			end
		end
	end
end

function Admin_Help(playerid)
	local message="";
	
	if messagename~=nil then
		message=message.." "..messagename
	end
	
	if pmname~=nil then
		message=message.." "..pmname
	end
	
	if kickname~=nil then
		message=message.." "..kickname
	end
	
	if banname~=nil then
		message=message.." "..banname
	end
	
	if timename~=nil then
		message=message.." "..timename
	end
	
	if teleportname~=nil then
		message=message.." "..teleportname
	end
	
	if posname~=nil then
		message=message.." "..posname
	end
	
	if distancename~=nil then
		message=message.." "..distancename
	end
	
	if message=="" then
		message="Command isn't."
	end
	
	SendPlayerMessage(playerid,255,255,0,string.format("(Server): %s",message));
end

function Admin_Message(playerid,params)
	local result, message=sscanf(params,"s");
	if result == 1 then
		SendMessageToAll(255,255,0,string.format("(Server): %s",message));
	else
		SendPlayerMessage(playerid,255,255,0,string.format("(Server): use %s (message)",messagename));
	end
end

function Admin_PrivateMessage(playerid,params)
	local result, name, message=sscanf(params,"ss");
	if result == 1 then
		id=Player_GetIdByCharacter(name);
		if id==nil then
			SendPlayerMessage(playerid,255,255,0,"(Server): Nobody has got the name.");
		else
			SendPlayerMessage(playerid,255,128,0,string.format("(Server): %s",message));
			SendPlayerMessage(id,255,128,0,string.format("(Server): %s",message));
		end
	else
		SendPlayerMessage(playerid,255,255,0,string.format("(Server): use %s (playername) (message)",pmname));
	end
end

function Admin_Kick(playerid,params)
	local result, name, reason=sscanf(params,"ss");
	if result == 1 then
		id=Player_GetIdByCharacter(name);
		if id==nil then
			SendPlayerMessage(playerid,255,255,0,"(Server): Nobody has got the name.");
		else
			SendPlayerMessage(id,255,128,0,string.format("Kick: %s",reason));
			local message=string.format("%s kicked %s",GetPlayerName(playerid),name);
			Log_Player(id,message);
			Admin_AllAdminMessage(message);
			Kick(id);
		end
	else
		SendPlayerMessage(playerid,255,255,0,string.format("(Server): use %s (playername) (reason)",kickname));
	end
end

function Admin_Ban(playerid,params)
	local result, name, reason=sscanf(params,"ss");
	if result == 1 then
		id=Player_GetIdByCharacter(name);
		if id==nil then
			SendPlayerMessage(playerid,255,255,0,"(Server): Nobody has got the name.");
		else
			SendPlayerMessage(id,255,128,0,string.format("Ban: %s",reason));
			local message=string.format("%s banned %s",GetPlayerName(playerid),name);
			Log_Player(id,message);
			Admin_AllAdminMessage(message);
			Ban(id);
		end
	else
		SendPlayerMessage(playerid,255,255,0,string.format("(Server): use %s (playername) (reason)",banname));
	end
end

function Admin_Time(playerid,params)
	local result,hour,minute = sscanf(params,"dd");
		
	if result == 1 and hour>=0 and hour<24 and minute>=0 and minute<60 then		
		SendMessageToAll(255,255,0,"(Server): GameTime is changed");
		SetTime(hour,minute);
	else
		SendPlayerMessage(playerid,255,255,0,string.format("(Server): use %s (hour) (minute)",timename));
	end
end

function Admin_Teleport(playerid,params)
	local result, id=sscanf(params,"d");
	if result == 1 then
		if (not Player_Is(id)) and (not Npc_Is(id)) then
			SendPlayerMessage(playerid,255,255,0,"(Server): The id isn't used.");
		else
			local x,y,z = GetPlayerPos(id);
			SetPlayerPos(playerid,x,y+100,z);
			Admin_AllAdminMessage(string.format("%s teleport for %d.",GetPlayerName(playerid),id));
		end
	else
		SendPlayerMessage(playerid,255,255,0,string.format("(Server): use %s (id)",teleportname));
	end
end

function Admin_Position(playerid,params)
	local result, s=sscanf(params,"s");
	if result == 1 then
		local x,y,z = GetPlayerPos(playerid);
		local a=GetPlayerAngle(playerid);
		local message=string.format("%s: %d,%d,%d   angle: %d",params,x,y,z,a);
		Log_Admin("spawn",message)
		SendPlayerMessage(playerid,255,255,0,message);
	else
		SendPlayerMessage(playerid,255,255,0,string.format("(Server): use %s (string)",posname));
	end
end

function Admin_Distance(playerid,params)
	local result, id=sscanf(params,"d");
	if result == 1 then
		if Player_Is(id) or Npc_Is(id) then
			SendPlayerMessage(playerid,255,255,0,string.format("Distance between you and %s: %d", GetPlayerName(id), GetDistancePlayers(playerid,id)));
		else
			SendPlayerMessage(playerid,255,255,0,string.format("(Server): Player ID %d is not connected with server.",id));
		end
	else
		SendPlayerMessage(playerid,255,255,0,string.format("(Server): use %s (playerid)",distancename));
	end
end

function Admin_AllAdminMessage(message)
	local account=nil;
	for i = 0, GetMaxPlayers() - 1 do
		account=Player_GetAccount(i);
		if Player_Is(i) and GPlayer.IsAdmin(account) then
			SendPlayerMessage(i,255,128,0,message);
		end
	end
end