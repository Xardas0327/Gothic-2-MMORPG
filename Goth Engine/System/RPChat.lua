
local player={};
local init=false;
local privatename=nil;
local returnname=nil;
local partyname=nil;

function RPChat_Private_Init_Use(name)
	privatename="/"..name;
	Help_AddFunc("play",privatename);
end

function RPChat_Return_Init_Use(name)
	returnname="/"..name;
	Help_AddFunc("play",returnname);
end

function RPChat_Party_Init_Use(name)
	partyname="/"..name;
	Help_AddFunc("play",partyname);
end

function RPChat_Init()
	for i = 0, GetMaxPlayers() - 1 do
		player[i]=nil;
	end
	EnableChat(0); 
	init=true;
	Log_System("RPChat: It is active.");
end

function RPChat_CommandText(playerid, cmdtext)
	if init and Player_Is(playerid) then
		local account=Player_GetAccount(playerid);
		
		if GPlayer.IsLoginCharacter(account) then
			local cmd,params = GetCommand(cmdtext);
			
			if cmd==privatename then
				RPChat_Private(playerid, params);
			elseif cmd==returnname then
				RPChat_Return(playerid, params);
			elseif cmd==partyname then
				RPChat_Party(playerid, params);
			end
		end
	end
end

function RPChat_Length_Check(text)
	local rcon,other = GetCommand(text);
	if string.len(text)<=100 and rcon~="rcon" then
		return true;
	end
	return false;
end

function RPChat_Cut(name,text)
	local message1=name .. ": ";
	local message2=nil;
	if (string.len(message1)+string.len(text))>60 then
		message2="";
		for i=0, string.len(name) do
			message2=message2 .. " ";
		end
		
		for i in string.gmatch(text, "%S+") do
			if string.len(message1)<60 then
				message1=message1 .." " ..i;
			else
				message2=message2 .." " ..i;
			end
		end
	else
		message1=message1..text;
	end
			
	return message1, message2;
end

function RPChat_Send(playerid, text)
	local account=Player_GetAccount(playerid);
	
	if init and Player_Is(playerid) and GPlayer.IsLoginCharacter(account) then
		if RPChat_Length_Check(text) then
			local character=GPlayer.GetCharacter(account);
			
			local message1, message2=RPChat_Cut(GCharacter.GetName(character),text);
			if message2==nil then
				for i = 0, GetMaxPlayers() - 1 do
					if Player_Is(i) then
						if GetDistancePlayers(playerid,i) < 1000 then
							SendPlayerMessage(i,255,255,255,message1);
							Log_Player(i,message1);
						end
					end
				end			
			else
				for i = 0, GetMaxPlayers() - 1 do
					if Player_Is(i) then
						if GetDistancePlayers(playerid,i) < 1000 then
							SendPlayerMessage(i,255,255,255,message1);
							SendPlayerMessage(i,255,255,255,message2);
							Log_Player(i,message1);
							Log_Player(i,message2);
						end
					end
				end
			end
		else
			SendPlayerMessage(playerid,255,255,0,string.format("(Server): The text is very long. (max 100 characters)"));
		end
	end
end

function RPChat_Private(playerid, params)
	local result,takename,message = sscanf(params,"ss");		
	if result == 1 then
		local takeid=Player_GetIdByCharacter(takename);
		if takeid~=nil then
			if playerid == takeid then
				SendPlayerMessage(playerid,255,255,0,"(Server): You can't send message to yourself.");
			else
				RPChat_Private_Send(playerid, takeid, message);
			end
		else
			SendPlayerMessage(playerid,255,255,0,"(Server): Nobody has got the name.");
		end
	else
		SendPlayerMessage(playerid,255,255,0,string.format("(Server): use %s (name) (message)",privatename));
	end
end

function RPChat_Return(playerid, params)
		if player[playerid]~=nil then
			if params~="" then
				RPChat_Private_Send(playerid, player[playerid], params);
			end
		else
		SendPlayerMessage(playerid,255,255,0,string.format("(Server): You didn't send private message."));
	end
end

function RPChat_Private_Send(sendid, takeid, text)
	local sendAccount=Player_GetAccount(sendid);
	
	if init and GPlayer.IsLoginCharacter(sendAccount) then
		local takeAccount=Player_GetAccount(sendid);
		
		if GPlayer.IsLoginCharacter(takeAccount) then
			if RPChat_Length_Check(text) then
				local sendCharacter=GPlayer.GetCharacter(sendAccount);
				local message1, message2=RPChat_Cut(GCharacter.GetName(sendCharacter),text);
				
				if message2==nil then
					SendPlayerMessage(sendid,255,128,0,message1);
					SendPlayerMessage(takeid,255,128,0,message1);
					Log_Player(sendid,message1);
					Log_Player(takeid,message1);
				else
					SendPlayerMessage(sendid,255,128,0,message1);
					SendPlayerMessage(sendid,255,128,0,message2);
					SendPlayerMessage(takeid,255,128,0,message1);
					SendPlayerMessage(takeid,255,128,0,message2);
					Log_Player(sendid,message1);
					Log_Player(takeid,message1);
					Log_Player(sendid,message2);
					Log_Player(takeid,message2);
				end
				player[takeid]=sendid;
			else
				SendPlayerMessage(sendid,255,255,0,string.format("(Server): The text is very long. (max 100 characters)"));
			end
		else
			local takeCharacter=GPlayer.GetCharacter(takeAccount);
			SendPlayerMessage(sendid,255,255,0,string.format("(Server): %s is offline.",GCharacter.GetName(takeCharacter)));
		end
	end
end

function RPChat_Party(playerid, params)
	if Character_Party_Have(playerid) then
		local result,text = sscanf(params,"s");
		if result==1 then
			local number,partners=Character_Party_Partners(playerid);
			local account=Player_GetAccount(playerid);
			local character=GPlayer.GetCharacter(account);
			
			local message1, message2=RPChat_Cut(GCharacter.GetName(character),text);
			if message2==nil then
				SendPlayerMessage(playerid,64,224,208,message1);
				Log_Player(playerid,message1);
				for i=0,number-1 do
					SendPlayerMessage(partners[i],64,224,208,message1);
					Log_Player(partners[i],message1);
				end
			else
				SendPlayerMessage(playerid,64,224,208,message1);
				SendPlayerMessage(playerid,64,224,208,message2);
				Log_Player(playerid,message1);
				Log_Player(playerid,message2);
				for i=0,number-1 do
					SendPlayerMessage(partners[i],64,224,208,message1);
					SendPlayerMessage(partners[i],64,224,208,message2);
					Log_Player(partners[i],message1);
					Log_Player(players[i],message2);
				end
			end
		else
			SendPlayerMessage(playerid,255,255,0,string.format("(Server): use %s (message)",partyname));
		end
	else
		SendPlayerMessage(playerid,255,255,0,"(Server): You aren't in a party.");
	end
end

function RPChat_Disconnect(playerid)
	player[playerid]=nil;
end