local player={};

function Player_Init(id)
	player[id]=nil;
end

function Player_Is(id)
	return player[id]~=nil;
end

function Player_LoginAccount(id,name)
	player[id]=GPlayer.new(id,name);
end

function Player_LogoutAccount(id)
	player[id]=nil;
end

function Player_GetAccount(id)
	return player[id];
end

function Player_IsActiveAccount(name)
	local i=0;
	for id,account in pairs(player) do
		if Player_Is(id) and GPlayer.GetAccountName(account)==name then
			return true;
		end
	end
	
	return false;
end

function Player_GetIdByCharacter(name)
	for id,account in pairs(player) do
		if Player_Is(id) then
			local character=GPlayer.GetCharacter(account);
			if  character~=nil and GCharacter.GetName(character)==name  then
				return GCharacter.GetId(character);
			end
		end
	end

	return nil;
end

function Player_Hit(playerid, killerid)
	if (not Npc_Is(playerid)) then
		if  player[playerid]~=nil then
			if not(GPlayer.IsLoginCharacter(player[playerid])) then
				SendPlayerMessage(playerid,255,255,0,"(Server): You musn't hit a player, who don't login a character.");
				Kick(killerid);
			end
			
			GPlayer.PlayerHit(player[playerid]);
		else
			SetPlayerHealth(playerid,GPlayer_GetBusyHealth());
		end
	end
end

function Player_Spawn(playerid)
	if (not Npc_Is(playerid)) and player[playerid]==nil then
		local health=GPlayer_GetBusyHealth();
		SetPlayerHealth(playerid,health);
	end
end