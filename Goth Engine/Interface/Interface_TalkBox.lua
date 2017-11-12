
local window={};
window.x=1750;
window.y=5800;
window.texture=nil;
window.row={};

function Interface_TalkBox_Init()
	window.texture=CreateTexture(window.x,window.y,window.x+5000,window.y+1000,"Frame_GMPA.TGA");

	for i = 0, GetMaxPlayers() - 1 do
		window.row[i]={};
		for j = 0,2 do
			window.row[i][j]= GDraw.new(window.x+100,window.y+(j+1)*200,"","Font_Old_10_White_Hi.TGA",255,255,255);
		end
	end
	Human_Speech_Init_Box(Interface_TalkBox_Show,Interface_TalkBox_Refresh,Interface_TalkBox_Hide);
	Human_Speech_Row(3,45);
	Human_Quest_Init_Box(Interface_TalkBox_Show,Interface_TalkBox_Refresh,Interface_TalkBox_Hide);
	Human_Quest_Row(3,45);
end

function Interface_TalkBox_Show(playerid)
	ShowTexture(playerid,window.texture);
	Interface_Npcname_Show(playerid,window.x+100,window.y-225)
	for i=0,2 do
		ShowDraw(playerid,GDraw.id(window.row[playerid][i]));
	end
end

function Interface_TalkBox_Refresh(playerid,funcname,talk)
	local ready=0;
	for i=0,2 do
		if talk[i]~=nil then
			GDraw.message(window.row[playerid][i],talk[i]);
			ready=ready+1;
		else
			GDraw.message(window.row[playerid][i],"");
		end
	end
	SetTimerEx(funcname,ready*2200,0,playerid);
end

function Interface_TalkBox_Hide(playerid)
	HideTexture(playerid,window.texture);
	Interface_Npcname_Hide(playerid);
	for i=0,2 do
		HideDraw(playerid,GDraw.id(window.row[playerid][i]));
	end
end