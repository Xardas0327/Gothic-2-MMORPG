
local window={};
window.texture=nil;
window.x=100;
window.y=2400;
window.row={};

local new_character_button={};
new_character_button.texture=nil;
new_character_button.draw={};
new_character_button.text="New Character";

local charmax=9;
local player_spawn={}
player_spawn.x=-14069;
player_spawn.y=2364;
player_spawn.z=-7599;
player_spawn.angle=319;
player_spawn.camera=50;

local player={};

function Interface_CharacterMenu_Init()
	window.texture=CreateTexture(window.x,window.y,window.x+3000,window.y+350*(charmax),"Frame_GMPA.TGA");
	for i = 0, GetMaxPlayers() - 1 do
		player[i]={};
		player[i].number=0;
		player[i].row=0;
		player[i].name={};
		player[i].active=false;
		
		window.row[i]={};
		
		for j = 0, charmax - 1 do
			player[i].name[j]="";
			window.row[i][j]=GDraw.new(window.x+150,window.y+50+300*j,"","Font_Old_20_White_Hi.TGA",255,255,255);
		end
		
		new_character_button.texture=CreateTexture(window.x+350,window.y+350*(charmax)+50,window.x+2500,window.y+350*(charmax)+500,"Frame_GMPA.TGA");
		new_character_button.draw[i]=GDraw.new(window.x+500,window.y+350*(charmax)+100,new_character_button.text,"Font_Old_20_White_Hi.TGA",255,255,255);
	end
	Interface_CharacterMenu_Option_Init();
	Interface_CharacterMenu_Option_Otherhide(Interface_CharacterMenu_Hide);
	Character_MaxChar(charmax);
	Character_Menu_Init(Interface_CharacterMenu_Show,Interface_CharacterMenu_Refresh,Interface_CharacterMenu_Hide);
	
	Interface_CharacterMenu_Create_Init();
	Interface_CharacterMenu_Create_OtherMenuVisible(Interface_CharacterMenu_Visible);
	
	Help_AddHelp("character","You can move w,a,s,d (or arrow) and selected is CTRL.")
end

function Interface_CharacterMenu_CommandText(playerid, cmdtext)
	Interface_CharacterMenu_Create_CommandText(playerid, cmdtext)
end

function Interface_CharacterMenu_Spawn(x,y,z,angle,camera)
	player_spawn.x=x;
	player_spawn.y=y;
	player_spawn.z=z;
	player_spawn.angle=angle;
	player_spawn.camera=camera;
end

function Interface_CharacterMenu_Show(playerid)
	SetPlayerPos(playerid,player_spawn.x,player_spawn.y,player_spawn.z);
	SetPlayerAngle(playerid,player_spawn.angle);
	SetPlayerEnable_OnPlayerKey(playerid,1);
	
	local account=Player_GetAccount(playerid);
	GPlayer.SetBusy(account,true);
	if (not player[playerid].active) then
		Interface_CharacterMenu_Visible(playerid,true);
		player[playerid].active=true;
		
		Camera_OppositePlayer(playerid,player_spawn.camera,player_spawn.x,player_spawn.y,player_spawn.z,player_spawn.angle);
	end
end

function Interface_CharacterMenu_Refresh(playerid)
	local number,charname=Character_List(playerid);
	if number~=nil and charname~=nil then
		player[playerid].row=0;
		player[playerid].number=number;
		
		for i=0,  number-1 do
			player[playerid].name[i]=charname[i]
		end
			
		for i=number,charmax -1 do
			player[playerid].name[i]="";
		end
		
		if number~=0 then
			GDraw.message_color(window.row[playerid][0],string.format("%d. %s",1,player[playerid].name[0]),255,255,0);
			for i=1, charmax-1 do
				GDraw.message_color(window.row[playerid][i],string.format("%d. %s",i+1,player[playerid].name[i]),255,255,255);
			end
			GDraw.message_color(new_character_button.draw[playerid],new_character_button.text,255,255,255);
		else
			for i=0, charmax-1 do
				GDraw.message_color(window.row[playerid][i],string.format("%d. %s",i+1,player[playerid].name[i]),255,255,255);
			end
			GDraw.message_color(new_character_button.draw[playerid],new_character_button.text,255,255,0);
		end
		
	else
		SendPlayerMessage(playerid,255,255,0,"(Server): Database Error.");
	end
end

function Interface_CharacterMenu_Move(playerid,move)
	local new=player[playerid].row+move;
	
	if new<0 then
		new=player[playerid].number;
	end
	
	if new>player[playerid].number then
		new=0;
	end
						
	if new~=player[playerid].number then
		GDraw.color(window.row[playerid][new],255,255,0);
	else
		GDraw.message_color(new_character_button.draw[playerid],new_character_button.text,255,255,0);
	end
		
	if player[playerid].row~=player[playerid].number then
		GDraw.color(window.row[playerid][player[playerid].row],255,255,255);
	else
		GDraw.message_color(new_character_button.draw[playerid],new_character_button.text,255,255,255);
	end
		
	player[playerid].row=new;
end

function Interface_CharacterMenu_Hide(playerid)
	Interface_CharacterMenu_Option_Hide(playerid);
	Interface_CharacterMenu_Create_Hide(playerid);
	Interface_CharacterMenu_Visible(playerid,false);
	
	SetPlayerEnable_OnPlayerKey(playerid,0);
	local account=Player_GetAccount(playerid);
	GPlayer.SetBusy(account,false);
	player[playerid].active=false;
	
	Camera_Default(playerid);
end

function Interface_CharacterMenu_Key(playerid,keydown)
	local account=Player_GetAccount(playerid);
	
	if Player_Is(playerid) and (not GPlayer.IsLoginCharacter(account)) then
		if  (not Interface_CharacterMenu_Option_Active(playerid)) and (not Interface_CharacterMenu_Create_Active(playerid)) then
			if (keydown == KEY_W or keydown == KEY_UP) and player[playerid].number~=0 then
				Interface_CharacterMenu_Move(playerid,-1);
			elseif (keydown == KEY_S or keydown == KEY_DOWN) and player[playerid].number~=0 then
				Interface_CharacterMenu_Move(playerid,1);
			elseif keydown == KEY_LCONTROL or keydown == KEY_RCONTROL then
				if player[playerid].row~=player[playerid].number then
					Interface_CharacterMenu_Option_Show(playerid,player[playerid].name[ player[playerid].row ]);
				else
					Interface_CharacterMenu_Create_Show(playerid);
				end
			end
		else
			if Interface_CharacterMenu_Option_Active(playerid) then
				Interface_CharacterMenu_Option_Key(playerid,keydown);
			elseif Interface_CharacterMenu_Create_Active(playerid) then
				Interface_CharacterMenu_Create_Key(playerid,keydown)
			end
		end
	end
end

function Interface_CharacterMenu_Visible(playerid,visible)
	if visible then
		ShowTexture(playerid,window.texture);
		for i = 0,charmax -1 do
			ShowDraw(playerid,GDraw.id(window.row[playerid][i]));
		end
		Interface_CharacterMenu_Refresh(playerid);
		
		ShowTexture(playerid,new_character_button.texture);
		ShowDraw(playerid,GDraw.id(new_character_button.draw[playerid]));
	else
		HideTexture(playerid,window.texture);
		for i = 0,charmax -1 do
			HideDraw(playerid,GDraw.id(window.row[playerid][i]));
		end
		
		HideTexture(playerid,new_character_button.texture);
		HideDraw(playerid,GDraw.id(new_character_button.draw[playerid]));
	end
end
