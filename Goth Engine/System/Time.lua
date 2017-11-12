
local init=false;
local realtime_changename=nil;
local draw_show=nil;
local draw_hide=nil;
local draw_changereal=nil;
local draw_changegame=nil;
local player={};

function Time_Init(show,hide,changereal,changegame)
	for i = 0, GetMaxPlayers() - 1 do
		player[i]={};
		player[i].zone=0;
		player[i].real_timer=0;
	end
	
	draw_show=show;
	draw_hide=hide;
	draw_changereal=changereal;
	draw_changegame=changegame;  
	
	SetTimer("Time_Game_Clock",1000,1);
	Log_System("Time: It is active.");
	init=true;
end

function Time_Real_Change_Init_Use(name)
	realtime_changename="/"..name;
	Help_AddFunc("character",realtime_changename);
	Help_AddFunc("play",realtime_changename);
end

function Time_CommandText(playerid, cmdtext)
	if Player_Is(playerid) and init then
		local cmd,params = GetCommand(cmdtext);
		
		if cmd==realtime_changename then
			Time_Real_Change(playerid,params);
		end
	end
end

function Time_Real_Change(playerid,params)
	local handler=MySQL_Get();
	if handler~=nil then
		local result,number= sscanf(params,"d");
		if number~=0 then
			local account=Player_GetAccount(playerid);
			player[playerid].zone=math.floor(player[playerid].zone+number) % 24;
			
			mysql_query(handler,string.format("UPDATE `account` SET `zone`=%d WHERE `accname`=%q",player[playerid].zone,GPlayer.GetAccountName(account)));	
			
			SendPlayerMessage(playerid,255,255,0,string.format("(Server): The real time changed."));
		else
			SendPlayerMessage(playerid,255,255,0,string.format("(Server): use %s (number) and the number isn't 0.",realtime_changename));
		end
	else
		SendPlayerMessage(playerid,255,255,0,"(Server): Database Error.");
	end
end

function Time_Real_Clock(playerid)
	if init then
		local realhours = tonumber(os.date("%H"))+player[playerid].zone;
		local realminutes = tonumber(os.date("%M"));
		local realseconds = tonumber(os.date("%S"));
		
		if realhours > 23 then
			realhours=realhours-24;
		elseif realhours<0 then
			realhours=24+realhours;
		end
		
		draw_changereal(playerid,realhours,realminutes,realseconds);
	end
end

function Time_Game_Clock()
      local hours, minutes = GetTime();
      draw_changegame(hours,minutes);
end

function Time_Show(playerid)
	if init then
		local handler=MySQL_Get();
		
		if handler==nil or (not Player_Is(playerid)) then
			player[playerid].zone=0;
		else
			local account=Player_GetAccount(playerid);
			local result=mysql_query(handler,string.format("SELECT `zone` FROM `account` WHERE `accname`=%q",GPlayer.GetAccountName(account)));
			if result then
				local zone=mysql_fetch_row(result);
				mysql_free_result(result)
				if zone then
					player[playerid].zone=zone[1];
				else
					SendPlayerMessage(playerid,255,255,0,"(Server): Database Error.");
				end
			else
				SendPlayerMessage(playerid,255,255,0,"(Server): Database Error.");
			end
		end
		player[playerid].real_timer=SetTimerEx("Time_Real_Clock",1000,1,playerid);
		draw_show(playerid);
	end
end

function Time_Hide(playerid)
	if init then
		if IsTimerActive(player[playerid].real_timer)==1 then
			KillTimer(player[playerid].real_timer);
			draw_hide(playerid);
		end
	end
end