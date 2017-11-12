
local window={};
window.texture=nil;
window.x=100;
window.y=2400;
window.name={};

local player_spawn={}
player_spawn.x=-14069;
player_spawn.y=2364;
player_spawn.z=-7599;
player_spawn.angle=319;
player_spawn.camera=50;

function Interface_AccountMenu_Init()
	window.texture=CreateTexture(window.x,window.y,window.x+4600,window.y+500,"Frame_GMPA.TGA");
	for i = 0, GetMaxPlayers() - 1 do
		window.name[i]=GDraw.new(window.x+150,window.y+50,"","Font_Old_20_White_Hi.TGA",255,255,255);
	end
	Account_Menu_Init(Interface_AccountMenu_Show,Interface_AccountMenu_Refresh,Interface_AccountMenu_Hide);
	Interface_CharacterMenu_Spawn(player_spawn.x,player_spawn.y,player_spawn.z,player_spawn.angle,player_spawn.camera);
end

function Interface_AccountMenu_Spawn(x,y,z,angle,camera)
	player_spawn.x=x;
	player_spawn.y=y;
	player_spawn.z=z;
	player_spawn.angle=angle;
	player_spawn.camera=camera;
end

function Interface_AccountMenu_Show(playerid)
	ShowTexture(playerid,window.texture);
	ShowDraw(playerid,GDraw.id(window.name[playerid]));
	Interface_AccountMenu_Refresh(playerid);
	SetPlayerPos(playerid,player_spawn.x,player_spawn.y,player_spawn.z);
	SetPlayerAngle(playerid,player_spawn.angle);
	Camera_OppositePlayer(playerid,player_spawn.camera,player_spawn.x,player_spawn.y,player_spawn.z,player_spawn.angle);
end

function Interface_AccountMenu_Refresh(playerid)
	GDraw.message(window.name[playerid],string.format("Username: %s",GetPlayerName(playerid)));
end

function Interface_AccountMenu_Hide(playerid)
	HideTexture(playerid,window.texture);
	HideDraw(playerid,GDraw.id(window.name[playerid]));
	Camera_Default(playerid);
end