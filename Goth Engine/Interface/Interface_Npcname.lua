local name_draw={};
for i = 0, GetMaxPlayers() - 1 do
	name_draw[i]= GDraw.new(0,0,"","Font_Old_20_White_Hi.TGA",255,255,255);
end

function Interface_Npcname_Show(playerid,x,y)
	local npcid=GetFocus(playerid);
	if Human_Is(npcid) then
		local red,green,blue=GetPlayerColor(npcid);
		GDraw.update(name_draw[playerid],x,y,GetPlayerName(npcid),"Font_Old_20_White_Hi.TGA",red,green,blue);
		ShowDraw(playerid,GDraw.id(name_draw[playerid]));
	end
end

function Interface_Npcname_Hide(playerid)
	HideDraw(playerid,GDraw.id(name_draw[playerid]));
end