
local maxpartners=2;
local window={};
window.x=6200;
window.y=800;
window.name=nil;
window.texture=nil;
window.row={};

local player={};

function Interface_PartyBox_Init()
	window.name=GDraw.new(window.x+100,window.y-225,"Party","Font_Old_20_White_Hi.TGA",255,255,255);
	window.texture=CreateTexture(window.x,window.y,window.x+1800,window.y+800,"Frame_GMPA.TGA");
	for i = 0, GetMaxPlayers() - 1 do
		player[i]=0;
		window.row[i]={};
		for j = 0,maxpartners-1 do
			window.row[i][j]=GDraw.new(window.x+200,window.y+200+j*300,"","Font_Old_10_White_Hi.TGA",255,255,255);
		end
	end	
	Interface_PartyBox_Offer_Init();
	Character_Party_Maxnumber(maxpartners);
	Character_Party_Init_Box(Interface_PartyBox_Show,Interface_PartyBox_Refresh,Interface_PartyBox_Hide);
end

function Interface_PartyBox_Show(playerid)
	player[playerid]=0;
	ShowTexture(playerid,window.texture);
	ShowDraw(playerid,GDraw.id(window.name));
	Interface_PartyBox_Refresh(playerid);
end

function Interface_PartyBox_Refresh(playerid)
	local number,partners=Character_Party_Partners(playerid);	
	if number~=0 then
		if player[playerid]>number then
			while player[playerid]~=number do
				player[playerid]=player[playerid]-1;
				HideDraw(playerid,GDraw.id(window.row[playerid][ player[playerid] ]));
			end
		elseif player[playerid]<number then
			while player[playerid]~=number do
				ShowDraw(playerid,GDraw.id(window.row[playerid][ player[playerid] ]));
				player[playerid]=player[playerid]+1;
			end
		end
		for i=0,number-1 do
			GDraw.message(window.row[playerid][i],GetPlayerName(partners[i]));
		end
	else
		Interface_PartyBox_Hide(playerid);
	end
end

function Interface_PartyBox_Hide(playerid)
	HideTexture(playerid,window.texture);
	HideDraw(playerid,GDraw.id(window.name));
	for i = 0,player[playerid]-1 do
		HideDraw(playerid,GDraw.id(window.row[playerid][i]));
	end
end