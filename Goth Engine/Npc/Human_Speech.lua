
local human={};
local player={};
local row={};
row.length=40; --base value
row.number=1; --base value
for i = 0, GetMaxPlayers() - 1 do
	player[i]={};
	player[i].target=nil;
	player[i].active=false;
	player[i].stand=0;
end

local box_show=nil;
local box_refresh=nil;
local box_hide=nil;

function Human_Speech_Init_Box(show,refresh,hide)
	box_show=show;
	box_refresh=refresh;
	box_hide=hide;
end

function Human_Speech(npcid,argument)
	if Human_Speech_Check(GetPlayerName(npcid),argument) then
		human[npcid]={};
		human[npcid]=argument;
		
		human[npcid].angle=GetPlayerAngle(npcid);

		return Human_Speech_Show;	
	else
		Log_System(string.format("Human Speech: %s don't give speech.",GetPlayerName(npcid)));
	end
	return nil;
end

function Human_Speech_Row(number,length)
	if number>0 and length>0 then
		row.number=number;
		row.length=length;
	else
		Log_System(string.format("Human Speech: The row number and row's length must be more 0, that's why row number is %d, and row's length is %d.",row.number,row.length));
	end
end

function Human_Speech_Show(playerid,npcid)
	local account=Player_GetAccount(playerid);
	
	if not(GPlayer.IsBusy(account)) then
		player[playerid].active=true;
		
		GPlayer.SetBusy(account,true);
		SetPlayerAngle(npcid,GetAngleToPlayer(npcid,playerid));	
		SetPlayerAngle(playerid,GetAngleToPlayer(playerid,npcid));	
		box_show(playerid);
		player[playerid].target=npcid;		
		Human_Speech_Refresh(playerid);
	end
end

function Human_Speech_Refresh(playerid)
	local account=Player_GetAccount(playerid);
	
	if account~=nil and GPlayer.IsLoginCharacter(account) then
		local target=player[playerid].target;
		local stand=player[playerid].stand;
		if stand<human[target].talknumber then
			PlayGesticulation(target);
			box_refresh(playerid,"Human_Speech_Refresh",human[target].talk[stand]);
			player[playerid].stand=player[playerid].stand+1;
		else
			Human_Speech_Hide(playerid);
		end
	end
end

function Human_Speech_Hide(playerid)
	if player[playerid].active then
		player[playerid].stand=0;
		box_hide(playerid);
		
		local account=Player_GetAccount(playerid);
		GPlayer.SetBusy(account,false);
		player[playerid].active=false;
		SetPlayerAngle(player[playerid].target,human[ player[playerid].target ].angle);
	end
end

function Human_Speech_Logout(playerid)
	if player[playerid].active then
		Human_Speech_Hide(playerid);
	end
end

function Human_Speech_Check(npcname,text)
	local ready=true;
	
	if text==nil then
		Log_System(string.format("Human Speech: %s's speech is wrong.",npcname));
		ready=false;
	else				
		if type(text.talknumber)~="number" or text.talknumber<=0 then
			Log_System(string.format("Human Speech: %s's speech: the talknumber is wrong.",npcname));
			ready=false;
		else			
			for i=0, text.talknumber-1 do
				if text.talk[i]==nil then
					Log_System(string.format("Human Speech: %s's speech: the %d. talk is wrong.",npcname,i+1));
					ready=false;
				else
					local nilnumber=0;
					for j=0,row.number-1 do
						if text.talk[i][j]==nil then
							nilnumber=nilnumber+1;
						end
					end
					if nilnumber==row.number then
						Log_System(string.format("Human Speech: %s's speech: the %d. talk is wrong.",npcname,i+1));
						ready=false;
					else
						for j=0, row.number-1 do
							if text.talk[i][j]~=nil and (type(text.talk[i][j])~="string" or string.len(text.talk[i][j])<=0 or string.len(text.talk[i][j])>row.length) then
								Log_System(string.format("Human Speech: %s's speech: the %d. talk %d. row is wrong.(its max length is %d)",npcname,i+1,j+1,row.length));
								ready=false;
							end
						end
					end
				end
			end
		end
	end
	return ready;
end