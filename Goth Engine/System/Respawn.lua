local respawn=1;
local refreshTime=5;
local refreshHint=10;
local message={};
local number=0;

local player={};
for i = 0, GetMaxPlayers() - 1 do
	player[i]={};
	player[i].preIndex=nil;
	player[i].spendTime=0;
end

function Respawn_Get()
	return respawn;
end

function Respawn_Set(second)
	if second>0 then
		respawn=second;
		SetRespawnTime(respawn*1000);
	else
		Log_System(string.format("Respawn: The Respawn time must be more 0, that's why it is %d second.",respawn));
	end
end

function Respawn_AddText(text,x,font)
	message[number]={}
	message[number].text=text;
	message[number].x=x;
	message[number].font=font;
	number=number+1;
end

function Respawn_Show(playerid)
	waitTime=respawn-player[playerid].spendTime;
	
	if waitTime<=0 then
		player[playerid].preIndex=nil;
		player[playerid].spendTime=0;
	else
		SendPlayerMessage(playerid,255,255,0,string.format("Respawn: %d second",waitTime));
		
		if (waitTime % refreshHint==0) and number~=0 then
			local rand; 
			
			repeat
				rand=random(number);
			until( rand~=player[playerid].preIndex or number<2 )
			
			player[playerid].preIndex=rand;
		
			GameTextForPlayer(playerid,message[rand].x,4500,message[rand].text,message[rand].font,255,255,255,(refreshHint-1)*1000);
		end
		
		player[playerid].spendTime=player[playerid].spendTime+refreshTime;
		
		SetTimerEx("Respawn_Show",refreshTime*1000,0,playerid);
	end
	
end