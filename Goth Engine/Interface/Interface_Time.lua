
local realtime={};
realtime.x=6600;
realtime.y=200;
realtime.draw={};

local gametime={};
gametime.x=realtime.x;
gametime.y=realtime.y+200;
gametime.draw=nil;

function Interface_Time_Init()
	for i = 0, GetMaxPlayers() - 1 do
		realtime.draw[i] = GDraw.new(realtime.x,realtime.y,"00:00","Font_Old_10_White_Hi.TGA",255,255,255);
	end
	gametime.draw=GDraw.new(gametime.x,gametime.y,"00:00","Font_Old_10_White_Hi.TGA",255,255,255);
	Time_Init(Interface_Time_Show,Interface_Time_Hide,Interface_Time_RefreshReal,Interface_Time_RefreshGame);
end

function Interface_Time_Show(playerid)
	ShowDraw(playerid,GDraw.id(realtime.draw[playerid])); 
	ShowDraw(playerid,GDraw.id(gametime.draw));
end

function Interface_Time_RefreshReal(playerid,hour,minute,second)
	 GDraw.message(realtime.draw[playerid],string.format("Real time: %02d:%02d:%02d",hour,minute,second));
end

function Interface_Time_RefreshGame(hour,minute)
	 GDraw.message(gametime.draw,string.format("Game time: %d:%02d",hour,minute));
end

function Interface_Time_Hide(playerid)
	HideDraw(playerid,GDraw.id(realtime.draw[playerid])); 
	HideDraw(playerid,GDraw.id(gametime.draw));
end