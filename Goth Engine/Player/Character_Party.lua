
local maxnumber=3;	--base value
local timer_time=10;

local party={};
for i = 0, GetMaxPlayers() - 1 do
	party[i]={};
	party[i].number=0;
	party[i].player={};
	party[i].invited=nil;
	party[i].invite=nil;
	party[i].timer=nil;
end;

local invitename=nil;
local leavename=nil;
local mypartyname=nil;
local messagename=nil;
local joinname=nil;

local box_show=nil;
local box_refresh=nil;
local box_hide=nil;
local box_offershow=nil;
local box_offerhide=nil;

function Character_Party_Invite_Init_Use(name)
	invitename="/"..name;
	Help_AddFunc("play",invitename);
end

function Character_Party_Leave_Init_Use(name)
	leavename="/"..name;
	Help_AddFunc("play",leavename);
end

function Character_Party_Myparty_Init_Use(name)
	mypartyname="/"..name;
	Help_AddFunc("play",mypartyname);
end

function Character_Party_Join_Init_Use(name)
	joinname="/"..name;
	Help_AddFunc("play",joinname);
end

function Character_Party_CommandText(playerid, cmdtext)
	local account=Player_GetAccount(playerid);
	
	if Player_Is(playerid) and GPlayer.IsLoginCharacter(account) then
		local cmd,params = GetCommand(cmdtext);
		
		if cmd==invitename then
			Character_Party_Invite(playerid,params);
		elseif cmdtext==leavename then
			Character_Party_Leave(playerid);
		elseif cmdtext==mypartyname then
			Character_Party_Myparty(playerid);
		elseif cmdtext==joinname then
			Character_Party_Join(playerid);
		end
	end
end

function Character_Party_Maxnumber(number)
	if number>0 then
		maxnumber=number;
	else
		Log_System(string.format("Character Party: The party number must be more 0, that's why it is %d.",maxnumber));
	end
end

function Character_Party_Init_Box(show,refresh,hide)
	box_show=show;
	box_refresh=refresh;
	box_hide=hide;
end

function Character_Party_Init_OfferBox(offershow,offerhide)
	box_offershow=offershow;
	box_offerhide=offerhide;
end

function Character_Party_Show(playerid)
	if box_show~=nil then
		box_show(playerid);
		Character_Party_Refresh(playerid);
	end
end

function Character_Party_Refresh(playerid)
	if box_refresh~=nil then
		for i=0,party[playerid].number-1 do
			box_refresh(party[playerid].player[i]);
		end
	end
end

function Character_Party_Hide(playerid)
	if box_hide~=nil then
		box_hide(playerid);
		Character_Party_Refresh(playerid);
	end
end

function Character_Party_OfferShow(playerid)
	if box_offershow~=nil then
		box_offershow(playerid);
	else
		SendPlayerMessage(playerid,255,255,0,string.format("Do you join to %s?",Character_Party_Invited(playerid)));
	end
end

function Character_Party_OfferHide(playerid)
	if box_offerhide~=nil then
		box_offerhide(playerid);
	end
end

function Character_Party_Invite(playerid,params)
	if party[playerid].invite==nil then
		if party[playerid].number<maxnumber then
			local result, name=sscanf(params,"s");
			if result==1 then
				local id=Player_GetIdByCharacter(name);
				if id~=nil then
					if id~=playerid then
						local account=Player_GetAccount(id);
						local character=GPlayer.GetCharacter(account);
						
						if not(GPlayer.IsBusy(account)) then
							if party[id].number==0 then
								party[playerid].invite=id;
								party[id].invited=playerid;
								party[id].timer=SetTimerEx("Character_Party_Timeout",timer_time*1000,0,id);
								Character_Party_OfferShow(id);
							else
								SendPlayerMessage(playerid,255,255,0,string.format("%s has got a party.",name));
							end
						else
							SendPlayerMessage(playerid,255,255,0,string.format("%s is busy.",name));
						end
					else
						SendPlayerMessage(playerid,255,255,0,"You don't invite yourself.");
					end
				else
					SendPlayerMessage(playerid,255,255,0,"Nobody has got the name.");
				end
			else
				SendPlayerMessage(playerid,255,255,0,string.format("(Server): use %s (name)",invitename));
			end
		else
			SendPlayerMessage(playerid,255,255,0,"Party is full.");
		end
	else
		local account=Player_GetAccount(party[playerid].invite);
		local character=GPlayer.GetCharacter(account);
		local characterName=GCharacter.GetName(character);
		SendPlayerMessage(playerid,255,255,0,string.format("You invited %s. Only (s)he hasn't answered.",characterName));
	end
end

function Character_Party_Accept(playerid,answer)
	if IsTimerActive(party[playerid].timer)==1 then
		KillTimer(party[playerid].timer);
	end
	
	local invited=party[playerid].invited;
	if answer then
		if party[playerid].number==0 then
			if party[invited].number~=maxnumber then
				party[playerid].player[0]=invited;
				party[invited].player[ party[invited].number ]=playerid;
				
				for i=0,party[invited].number-1 do
					party[playerid].player[i+1]=party[invited].player[i];
					
					local party_player=party[invited].player[i];
					party[party_player].player[ party[invited].number ]=playerid;
					party[party_player].number=party[invited].number+1;
				end
				party[invited].number=party[invited].number+1;
				party[playerid].number=party[invited].number;
				Character_Party_Show(playerid);
				if party[invited].number==1 then
					Character_Party_Show(invited);
				end
			else
				SendPlayerMessage(playerid,255,255,0,"Party is full.");
			end
		else
			SendPlayerMessage(playerid,255,255,0,"You have got a party.");
			local account=Player_GetAccount(party[playerid].invite);
			local character=GPlayer.GetCharacter(account);
			local characterName=GCharacter.GetName(character);
			SendPlayerMessage(invited,255,255,0,string.format(" %s is in a party.",characterName));
		end
	else
		local account=Player_GetAccount(playerid);
		local character=GPlayer.GetCharacter(account);
		local characterName=GCharacter.GetName(character);
		SendPlayerMessage(invited,255,255,0,string.format(" %s didn't join in the party.",characterName));
	end
	party[invited].invite=nil;
	party[playerid].invited=nil;
	Character_Party_OfferHide(playerid);
end

function Character_Party_Leave(playerid)
	if party[playerid].number~=0 then
		for i=0,party[playerid].number-1 do
			local j=0;
			
			local party_player=party[playerid].player[i];
			while j<party[party_player].number and party[party_player].player[j]~=playerid do
				j=j+1;
			end
			if j<party[party_player].number then
				for k=j+1, party[party_player].number-1 do
					party[party_player].player[k-1]=party[party_player].player[k];
				end
				party[party_player].number=party[party_player].number-1;
			end
		end
		Character_Party_Hide(playerid);
		party[playerid].number=0;
	else
		SendPlayerMessage(playerid,255,255,0,"(Server): You aren't in a party.");
	end
end

function Character_Party_Timeout(playerid)
	Character_Party_Accept(playerid,false);
end

function Character_Party_Myparty(playerid)
	if party[playerid].number==0 then
		SendPlayerMessage(playerid,255,255,0,"(Server): You aren't in a party.");
	else
		local message="In my party:"
		for i=0,party[playerid].number-1 do
			local account=Player_GetAccount(party[playerid].player[i]);
			local character=GPlayer.GetCharacter(account);
			local characterName=GCharacter.GetName(character);
			
			message=message.." "..characterName;
		end
		SendPlayerMessage(playerid,255,255,0,message);
	end
end

function Character_Party_Join(playerid)
	if party[playerid].invited~=nil then
		Character_Party_Accept(playerid,true);
	else
		SendPlayerMessage(playerid,255,255,0,"(Server): You aren't invited.");
	end
end

function Character_Party_RamdomPlayer(playerid)
	if party[playerid].number==0 then
		return playerid;
	else
		local rand=random(party[playerid].number+1);
		if rand==party[playerid].number or GetDistancePlayers(playerid,party[playerid].player[rand])>3000 then
			return playerid;
		else
			return party[playerid].player[rand];
		end
	end
end

function Character_Party_Partners(playerid)
	return party[playerid].number, party[playerid].player;
end

function Character_Party_Have(playerid)
	return party[playerid].number~=0;
end

function Character_Party_Invited(playerid)
	return party[playerid].invited;
end

function Character_Party_IsInvitee(playerid)
	return party[playerid].invited~=nil;
end

function Character_Party_Logout(playerid)
	if party[playerid].invited~=nil then
		Character_Party_Accept(playerid,false);
	end
	if party[playerid].invite~=nil then
		Character_Party_Accept(party[playerid].invite,false);
	end
	if party[playerid].number~=0 then
		Character_Party_Leave(playerid);
	end
end