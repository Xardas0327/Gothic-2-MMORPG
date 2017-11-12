
local window={};
window.texture=nil;
window.x=3750;
window.y=2400;
window.row={};
local otherhide=nil;

local player={};

function Interface_CharacterMenu_Option_Init()
	window.texture=CreateTexture(window.x,window.y,window.x+1000,window.y+1300,"Frame_GMPA.TGA");
	for i = 0, GetMaxPlayers() - 1 do
		window.row[i]={};
		window.row[i][0]=GDraw.new(window.x+150,window.y+50,"Login","Font_Old_20_White_Hi.TGA",255,255,255);
		window.row[i][1]=GDraw.new(window.x+150,window.y+350,"Back","Font_Old_20_White_Hi.TGA",255,255,255);
		window.row[i][2]=GDraw.new(window.x+150,window.y+850,"Delete","Font_Old_20_White_Hi.TGA",255,255,255);
		
		player[i]={};
		player[i].active=false;
		player[i].row=0;
		player[i].name=nil;
	end
	Interface_CharacterMenu_DeleteDialog_Init();
	Interface_CharacterMenu_DeleteDialog_Otherhide(Interface_CharacterMenu_Option_Hide);
end

function Interface_CharacterMenu_Option_Otherhide(func)
	otherhide=func;
end

function Interface_CharacterMenu_Option_OtherhideUse(playerid)
	if otherhide~=nil then
		otherhide(playerid);
	end
end

function Interface_CharacterMenu_Option_Show(playerid,name)
	player[playerid].name=name;
	ShowTexture(playerid,window.texture);
	for i = 0,2 do
		ShowDraw(playerid,GDraw.id(window.row[playerid][i]));
	end
	player[playerid].active=true;
	Interface_CharacterMenu_Option_Refresh(playerid);
end

function Interface_CharacterMenu_Option_Refresh(playerid)
	player[playerid].row=0;
	GDraw.color(window.row[playerid][0],255,255,0)
	GDraw.color(window.row[playerid][1],255,255,255);
	GDraw.color(window.row[playerid][2],255,255,255);
end

function Interface_CharacterMenu_Option_Move(playerid,move)
	local new=player[playerid].row;
	if new+move>=0 and new+move<3 then
		new=new+move
	end
		
	if player[playerid].row~=new then
		GDraw.color(window.row[playerid][new],255,255,0);
		GDraw.color(window.row[playerid][ player[playerid].row ],255,255,255);
		
		player[playerid].row=new;
	end
end

function Interface_CharacterMenu_Option_Hide(playerid)
	Interface_CharacterMenu_DeleteDialog_Hide(playerid);
	HideTexture(playerid,window.texture);
	for i = 0,2 do
		HideDraw(playerid,GDraw.id(window.row[playerid][i]));
	end
	player[playerid].active=false;
end

function Interface_CharacterMenu_Option_Active(playerid)
	return player[playerid].active;
end

function Interface_CharacterMenu_Option_Key(playerid,keydown)
	if player[playerid].active then
		if (not Interface_CharacterMenu_DeleteDialog_Active(playerid)) then
			if keydown == KEY_W or keydown == KEY_UP then
				Interface_CharacterMenu_Option_Move(playerid,-1);
			elseif keydown == KEY_S or keydown == KEY_DOWN then
				Interface_CharacterMenu_Option_Move(playerid,1);
			elseif keydown == KEY_LCONTROL or keydown == KEY_RCONTROL then
				if player[playerid].row==0 then --Login
					Interface_CharacterMenu_Option_OtherhideUse(playerid);
					Character_Login(playerid,player[playerid].name);
				elseif player[playerid].row==1 then --Back
					Interface_CharacterMenu_Option_Hide(playerid);		
				elseif player[playerid].row==2 then --Delete
					Interface_CharacterMenu_DeleteDialog_Show(playerid,player[playerid].name);
				end
			end
		else
			Interface_CharacterMenu_DeleteDialog_Key(playerid,keydown);
		end
	end
end