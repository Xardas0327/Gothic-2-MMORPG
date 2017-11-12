
local window={};
window.x=2500;
window.y=3800;
window.texture=nil;
window.row={};

local player={};

function Interface_PartyBox_Offer_Init()
	window.texture=CreateTexture(window.x,window.y,window.x+3000,window.y+700,"Frame_GMPA.TGA");
	for i = 0, GetMaxPlayers() - 1 do
		window.row[i]={};
		window.row[i][0]=GDraw.new(window.x+150,window.y+50,"Do you join to ?","Font_Old_10_White_Hi.TGA",255,255,255);
		window.row[i][1]=GDraw.new(window.x+800,window.y+400,"Yes","Font_Old_20_White_Hi.TGA",255,255,255);
		window.row[i][2]=GDraw.new(window.x+1700,window.y+400,"No","Font_Old_20_White_Hi.TGA",255,255,255);
		
		player[i]={};
		player[i].active=false;
		player[i].row=2;
	end	
	Character_Party_Init_OfferBox(Interface_PartyBox_Offer_Show,Interface_PartyBox_Offer_Hide);
end

function Interface_PartyBox_Offer_Show(playerid)
	player[playerid].active=true;
	player[playerid].row=2;
	ShowTexture(playerid,window.texture);
	for i = 0, 2 do
		ShowDraw(playerid,GDraw.id(window.row[playerid][i]));
	end
	SetPlayerEnable_OnPlayerKey(playerid,1);
	Interface_PartyBox_Offer_Refresh(playerid);
end

function Interface_PartyBox_Offer_Refresh(playerid)
	GDraw.message(window.row[playerid][0],string.format("Do you join to %s?",GetPlayerName(Character_Party_Invited(playerid))));
	GDraw.color(window.row[playerid][1],255,255,255);
	GDraw.color(window.row[playerid][2],255,255,0);
end

function Interface_PartyBox_Offer_Move(playerid,move)
	local new=player[playerid].row;
	if new+move>0 and new+move<3 then
		new=new+move
	end
		
	if player[playerid].row~=new then
		if new==1 then
			GDraw.color(window.row[playerid][1],255,255,0);
			GDraw.color(window.row[playerid][2],255,255,255);
		else
			GDraw.color(window.row[playerid][1],255,255,255);
			GDraw.color(window.row[playerid][2],255,255,0);
		end
		player[playerid].row=new;
	end
end

function Interface_PartyBox_Offer_Hide(playerid)
	HideTexture(playerid,window.texture);
	for i = 0, 2 do
		HideDraw(playerid,GDraw.id(window.row[playerid][i]));
	end
	player[playerid].active=false;
	SetPlayerEnable_OnPlayerKey(playerid,0);
end

function Interface_PartyBox_Offer_Key(playerid,keydown)
	if player[playerid].active then
		if keydown == KEY_A or keydown == KEY_LEFT then
			Interface_PartyBox_Offer_Move(playerid,-1)
		elseif keydown == KEY_D or keydown == KEY_RIGHT then
			Interface_PartyBox_Offer_Move(playerid,1)
		elseif keydown == KEY_LCONTROL or keydown == KEY_RCONTROL then
			if player[playerid].row==1 then --Yes
				Character_Party_Accept(playerid,true);
			else --No
				Character_Party_Accept(playerid,false);
			end
		end		
	end
end