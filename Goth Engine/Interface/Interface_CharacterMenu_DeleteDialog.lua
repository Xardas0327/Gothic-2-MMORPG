
local window={};
window.texture=nil;
window.x=3500;
window.y=3800;
window.sure=nil;
window.row={};
local otherhide=nil;

local player={};
function Interface_CharacterMenu_DeleteDialog_Init()
	window.texture=CreateTexture(window.x,window.y,window.x+1500,window.y+700,"Frame_GMPA.TGA");
	window.sure=GDraw.new(window.x+450,window.y+50,"Sure?","Font_Old_20_White_Hi.TGA",255,255,255);
	
	for i = 0, GetMaxPlayers() - 1 do
		window.row[i]={};
		window.row[i][0]=GDraw.new(window.x+150,window.y+400,"Yes","Font_Old_20_White_Hi.TGA",255,255,255);
		window.row[i][1]=GDraw.new(window.x+1000,window.y+400,"No","Font_Old_20_White_Hi.TGA",255,255,255);
		
		player[i]={};
		player[i].active=false;
		player[i].row=1;
		player[i].name=nil;
	end
end

function Interface_CharacterMenu_DeleteDialog_Otherhide(func)
	otherhide=func;
end

function Interface_CharacterMenu_DeleteDialog_OtherhideUse(playerid)
	if otherhide~=nil then
		otherhide(playerid);
	else
		Interface_CharacterMenu_DeleteDialog_Hide(playerid);
	end
end

function Interface_CharacterMenu_DeleteDialog_Show(playerid,name)
	player[playerid].name=name;
	ShowTexture(playerid,window.texture);
	ShowDraw(playerid,GDraw.id(window.sure));
	
	for i = 0,1 do
		ShowDraw(playerid,GDraw.id(window.row[playerid][i]));
	end
	player[playerid].active=true;
	Interface_CharacterMenu_DeleteDialog_Refresh(playerid);
end

function Interface_CharacterMenu_DeleteDialog_Refresh(playerid)
	player[playerid].row=1; --no
	GDraw.color(window.row[playerid][0],255,255,255);
	GDraw.color(window.row[playerid][1],255,255,0);
end

function Interface_CharacterMenu_DeleteDialog_Move(playerid,move)
	local new=player[playerid].row;
	if new+move>=0 and new+move<2 then
		new=new+move;
	end
		
	if player[playerid].row~=new then
		if new==0 then --yes
			GDraw.color(window.row[playerid][0],255,255,0);
			GDraw.color(window.row[playerid][1],255,255,255);
		else
			GDraw.color(window.row[playerid][0],255,255,255);
			GDraw.color(window.row[playerid][1],255,255,0);
		end
		player[playerid].row=new;
	end
end

function Interface_CharacterMenu_DeleteDialog_Hide(playerid)
	HideTexture(playerid,window.texture);
	HideDraw(playerid,GDraw.id(window.sure));
	
	for i = 0,1 do
		HideDraw(playerid,GDraw.id(window.row[playerid][i]));
	end
	player[playerid].active=false;
end

function Interface_CharacterMenu_DeleteDialog_Active(playerid)
	return player[playerid].active;
end

function Interface_CharacterMenu_DeleteDialog_Key(playerid,keydown)
	if player[playerid].active then
		if keydown == KEY_A or keydown == KEY_LEFT then
			Interface_CharacterMenu_DeleteDialog_Move(playerid,-1);
		elseif keydown == KEY_D or keydown == KEY_RIGHT then
			Interface_CharacterMenu_DeleteDialog_Move(playerid,1);
		elseif keydown == KEY_LCONTROL or keydown == KEY_RCONTROL then
			if player[playerid].row==0 then --Yes
				Interface_CharacterMenu_DeleteDialog_OtherhideUse(playerid);
				Character_Delete(playerid,player[playerid].name);
			else --No
				Interface_CharacterMenu_DeleteDialog_Hide(playerid);
			end
		end		
	end
end