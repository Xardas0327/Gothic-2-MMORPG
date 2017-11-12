
local player={};
local selected_number=8;
local selected_numberformat="<-- %d -->";
local selected_stringformat="<-- %s -->";
local createname=nil;
local gender=nil;
local skin=nil;
local body=nil;

local window={};
window.texture=nil;
window.x=100;
window.y=2400;
window.width=3300;
window.height=3500;
window.character_name={};
window.row={};

local menuVisibleFunc=nil;

function Interface_CharacterMenu_Create_Init()
	window.texture=CreateTexture(window.x,window.y,window.x+window.width,window.y+window.height,"Frame_GMPA.TGA");
	
	gender=Character_Body_Gender();
	skin=Character_Body_Skin();
	body=Character_Body_All();
	
	for i = 0, GetMaxPlayers() - 1 do		
		player[i]={};
		player[i].active=false;
		player[i].row=0;
		player[i].selected=1;
		player[i].name="";
		player[i].gender=1;
		player[i].skin=1;
		player[i].face_type=1;
		player[i].face_id=1;
		player[i].body_id=1;
		player[i].fatness=1;
		
		window.character_name[i]={};
		window.character_name[i].title=GDraw.new(window.x+150,window.y+100,"Name:","Font_Old_20_White_Hi.TGA",255,255,255);
		window.character_name[i].selected=GDraw.new(window.x+1000,window.y+100,"","Font_Old_20_White_Hi.TGA",255,255,255);
		
		window.row[i]={};
		for j = 0, selected_number-1 do	
			window.row[i][j]={};
			window.row[i][j].title=nil;
			window.row[i][j].selected=nil;
		end
		
		window.row[i][0].title=GDraw.new(window.x+150,window.y+550,"Gender:","Font_Old_20_White_Hi.TGA",255,255,255);
		window.row[i][0].selected=GDraw.new(window.x+1250,window.y+550,string.format(selected_stringformat,gender.type[1]),"Font_Old_20_White_Hi.TGA",255,255,255);
		
		window.row[i][1].title=GDraw.new(window.x+150,window.y+850,"Skin:","Font_Old_20_White_Hi.TGA",255,255,255);
		window.row[i][1].selected=GDraw.new(window.x+1250,window.y+850,string.format(selected_stringformat,skin.type[1]),"Font_Old_20_White_Hi.TGA",255,255,255);
		
		window.row[i][2].title=GDraw.new(window.x+150,window.y+1150,"Face:","Font_Old_20_White_Hi.TGA",255,255,255);
		window.row[i][2].selected=GDraw.new(window.x+1500,window.y+1150,string.format(selected_numberformat,1),"Font_Old_20_White_Hi.TGA",255,255,255);
		window.row[i][3].selected=GDraw.new(window.x+1500,window.y+1450,string.format(selected_numberformat,1),"Font_Old_20_White_Hi.TGA",255,255,255);
		
		window.row[i][4].title=GDraw.new(window.x+150,window.y+1750,"Body:","Font_Old_20_White_Hi.TGA",255,255,255);
		window.row[i][4].selected=GDraw.new(window.x+1500,window.y+1750,string.format(selected_numberformat,1),"Font_Old_20_White_Hi.TGA",255,255,255);
		window.row[i][5].selected=GDraw.new(window.x+1500,window.y+2050,string.format(selected_numberformat,1),"Font_Old_20_White_Hi.TGA",255,255,255);
		
		window.row[i][6].title=GDraw.new(window.x+1200,window.y+2500,"Accept","Font_Old_20_White_Hi.TGA",255,255,255);
		window.row[i][7].title=GDraw.new(window.x+1200,window.y+2800,"Cancel","Font_Old_20_White_Hi.TGA",255,255,255);
	end
end

function Interface_CharacterMenu_Create_OtherMenuVisible(func)
	menuVisibleFunc=func;
end

function Interface_CharacterMenu_Create_OtherMenuVisibleUse(playerid,visible)
	if menuVisibleFunc~=nil then
		menuVisibleFunc(playerid,visible);
	end
end

function Interface_CharacterMenu_Create_Name_Init_Use(name)
	createname="/"..name;
end

function Interface_CharacterMenu_Create_CommandText(playerid, cmdtext)
	local account=Player_GetAccount(playerid);
	
	if Player_Is(playerid) and (not GPlayer.IsLoginCharacter(account)) and player[playerid].active then
		local cmd,params = GetCommand(cmdtext);
		if cmd==createname then
			Interface_CharacterMenu_Create_AddName(playerid,params);
		end
	end
end

function Interface_CharacterMenu_Create_Show(playerid)
	if (not player[playerid].active) then
		Interface_CharacterMenu_Create_OtherMenuVisibleUse(playerid,false);
		ShowTexture(playerid,window.texture);
		
		ShowDraw(playerid,GDraw.id(window.character_name[playerid].title));
		ShowDraw(playerid,GDraw.id(window.character_name[playerid].selected));
		
		for i = 0,selected_number -1 do
			if window.row[playerid][i].title~=nil then
				ShowDraw(playerid,GDraw.id(window.row[playerid][i].title));
			end
			if window.row[playerid][i].selected~=nil then
				ShowDraw(playerid,GDraw.id(window.row[playerid][i].selected));
			end
		end
		
		SetPlayerAdditionalVisual(playerid,body["Male"]["Body"].types[1],body["Male"]["White"]["Body"].types[1],body["Male"]["Face"].types[1],body["Male"]["White"]["Face"].types[1]);
		SetPlayerFatness(playerid,0);
		
		player[playerid].name="";
		player[playerid].gender=1;
		player[playerid].skin=1;
		player[playerid].face_type=1;
		player[playerid].face_id=1;
		player[playerid].body_id=1;
		player[playerid].fatness=1;
		
		Interface_CharacterMenu_Create_Refresh(playerid);
		
		player[playerid].active=true;
		
		if createname~=nil then
			SendPlayerMessage(playerid,255,255,0,string.format("%s command give name to the new character",createname));
		end
	end
end

function Interface_CharacterMenu_Create_Refresh(playerid)
	player[playerid].row=0;
	
	GDraw.message(window.character_name[playerid].selected,"");
	
	GDraw.color(window.row[playerid][0].title,255,255,0);
	GDraw.message_color(window.row[playerid][0].selected,string.format(selected_stringformat,gender.type[1]),255,255,0);
	
	for i = 1,selected_number -1 do
		if window.row[playerid][i].title~=nil then
			GDraw.color(window.row[playerid][i].title,255,255,255);
		end
	end
	GDraw.message_color(window.row[playerid][1].selected,string.format(selected_stringformat,skin.type[1]),255,255,255);
	
	for i = 2,selected_number-1 do
		if window.row[playerid][i].selected~=nil then
			GDraw.message_color(window.row[playerid][i].selected,string.format(selected_numberformat,1),255,255,255);
		end
	end
end

function Interface_CharacterMenu_Create_Move(playerid,move)
	local new=player[playerid].row;
	if new+move>=0 and new+move<selected_number then
		new=new+move;
	end
		
	if player[playerid].row~=new then
		local row=player[playerid].row;
		if window.row[playerid][row].title~=nil then
			GDraw.color(window.row[playerid][row].title,255,255,255);
		elseif row-1>=0 and window.row[playerid][row-1].title~=nil then
			GDraw.color(window.row[playerid][row-1].title,255,255,255);
		end
		
		if window.row[playerid][row].selected~=nil then
			GDraw.color(window.row[playerid][row].selected,255,255,255);
		end
		
		if window.row[playerid][new].title~=nil then
			GDraw.color(window.row[playerid][new].title,255,255,0);
		elseif new-1>=0 and window.row[playerid][new-1].title~=nil then
			GDraw.color(window.row[playerid][new-1].title,255,255,0);
		end
		
		if window.row[playerid][new].selected~=nil then
			GDraw.color(window.row[playerid][new].selected,255,255,0);
		end
		
		player[playerid].row=new;
	end
end

function Interface_CharacterMenu_Create_Selected(playerid,move)
	local change=false;
	
	if player[playerid].row==0 then
		new=player[playerid].gender;
		if new+move>0 and new+move<=gender.length then
			new=new+move;
		end
		
		if player[playerid].gender~=new then
			change=true;
			player[playerid].skin=1;
			player[playerid].face_type=1;
			player[playerid].face_id=1;
			player[playerid].body_id=1;
			player[playerid].fatness=1;
			
			GDraw.message(window.row[playerid][0].selected,string.format(selected_stringformat,gender.type[new]));
			GDraw.message(window.row[playerid][1].selected,string.format(selected_stringformat,skin.type[1]));
			
			for i = 2,selected_number-1 do
				if window.row[playerid][i].selected~=nil then
					GDraw.message(window.row[playerid][i].selected,string.format(selected_numberformat,1));
				end
			end
			
			player[playerid].gender=new;
		end
	elseif player[playerid].row==1 then
		new=player[playerid].skin;
		if new+move>0 and new+move<=skin.length then
			new=new+move;
		end
		
		if player[playerid].skin~=new then
			change=true;
			player[playerid].face_type=1;
			player[playerid].face_id=1;
			player[playerid].body_id=1;
			player[playerid].fatness=1;
			
			GDraw.message(window.row[playerid][1].selected,string.format(selected_stringformat,skin.type[new]));
			
			for i = 2,selected_number-1 do
				if window.row[playerid][i].selected~=nil then
					GDraw.message(window.row[playerid][i].selected,string.format(selected_numberformat,1));
				end
			end
			
			player[playerid].skin=new;
		end
	elseif player[playerid].row==2 then
		new=player[playerid].face_type;
		local player_gender=gender.type[player[playerid].gender];
		
		if new+move>0 and new+move<=body[player_gender]["Face"].length then
			new=new+move;
		end
		
		if player[playerid].face_type~=new then
			change=true;
			player[playerid].fatness=1;
			
			GDraw.message(window.row[playerid][2].selected,string.format(selected_numberformat,new));
			GDraw.message(window.row[playerid][5].selected,string.format(selected_numberformat,1));
			
			player[playerid].face_type=new;
		end
	elseif player[playerid].row==3 then
		new=player[playerid].face_id;
		local player_gender=gender.type[player[playerid].gender];
		local player_skin=skin.type[player[playerid].skin];
		
		if new+move>0 and new+move<=body[player_gender][player_skin]["Face"].length then
			new=new+move;
		end
		
		if player[playerid].face_id~=new then
			change=true;
			player[playerid].fatness=1;
			
			GDraw.message(window.row[playerid][3].selected,string.format(selected_numberformat,new));
			GDraw.message(window.row[playerid][5].selected,string.format(selected_numberformat,1));
			
			player[playerid].face_id=new;
		end
	elseif player[playerid].row==4 then
		new=player[playerid].body_id;
		local player_gender=gender.type[player[playerid].gender];
		local player_skin=skin.type[player[playerid].skin];
		
		if new+move>0 and new+move<=body[player_gender][player_skin]["Body"].length then
			new=new+move;
		end
		
		if player[playerid].body_id~=new then
			change=true;			
			player[playerid].fatness=1;
		
			GDraw.message(window.row[playerid][4].selected,string.format(selected_numberformat,new));
			GDraw.message(window.row[playerid][5].selected,string.format(selected_numberformat,1));
			
			player[playerid].body_id=new;
		end
	elseif player[playerid].row==5 then
		new=player[playerid].fatness;
		
		if new+move>0 and new+move<=(body["Fatness"].maximum-body["Fatness"].minimum)*10 then
			new=new+move;
		end
		
		if player[playerid].fatness~=new then
			change=true;			
			GDraw.message(window.row[playerid][5].selected,string.format(selected_numberformat,new));
			
			player[playerid].fatness=new;
		end
	end
	
	if change then
		local player_gender=gender.type[player[playerid].gender];
		local player_skin=skin.type[player[playerid].skin];
		
		local body_type=body[player_gender]["Body"].types[1];
		local body_id=body[player_gender][player_skin]["Body"].types[player[playerid].body_id];
		local face_type=body[player_gender]["Face"].types[player[playerid].face_type];
		local face_id=body[player_gender][player_skin]["Face"].types[player[playerid].face_id];
		
		SetPlayerAdditionalVisual(playerid,body_type,body_id,face_type,face_id);
		SetPlayerFatness(playerid,body["Fatness"].minimum+0.1*(player[playerid].fatness-1));
	end
end

function Interface_CharacterMenu_Create_Hide(playerid)
	if player[playerid].active then
		Interface_CharacterMenu_Create_OtherMenuVisibleUse(playerid,true);
		HideTexture(playerid,window.texture);
		
		HideDraw(playerid,GDraw.id(window.character_name[playerid].title));
		HideDraw(playerid,GDraw.id(window.character_name[playerid].selected));
		
		for i = 0,selected_number -1 do
			if window.row[playerid][i].title~=nil then
				HideDraw(playerid,GDraw.id(window.row[playerid][i].title));
			end
			if window.row[playerid][i].selected~=nil then
				HideDraw(playerid,GDraw.id(window.row[playerid][i].selected));
			end
		end
		
		local default_body=Character_Body_Default();
		SetPlayerAdditionalVisual(playerid,default_body["body_type"],default_body["body_id"],default_body["face_type"],default_body["face_id"]);
		SetPlayerFatness(playerid,default_body["fatness"]);
	
		player[playerid].active=false;
	end
end

function Interface_CharacterMenu_Create_Active(playerid)
	return player[playerid].active;
end

function Interface_CharacterMenu_Create_Key(playerid,keydown)

	if player[playerid].active then
		if keydown == KEY_W or keydown == KEY_UP then
			Interface_CharacterMenu_Create_Move(playerid,-1);
		elseif keydown == KEY_S or keydown == KEY_DOWN then
			Interface_CharacterMenu_Create_Move(playerid,1);
		elseif keydown == KEY_A or keydown == KEY_LEFT then
			Interface_CharacterMenu_Create_Selected(playerid,-1);
		elseif keydown == KEY_D or keydown == KEY_RIGHT then
			Interface_CharacterMenu_Create_Selected(playerid,1);
		elseif keydown == KEY_LCONTROL or keydown == KEY_RCONTROL then
			if player[playerid].row==selected_number-2 then
				if player[playerid].name~="" then
					Interface_CharacterMenu_Create_Hide(playerid);
					
					local player_gender=gender.type[player[playerid].gender];
					local player_skin=skin.type[player[playerid].skin];
					local body_type=body[player_gender]["Body"].types[1];
					local body_id=body[player_gender][player_skin]["Body"].types[player[playerid].body_id];
					local face_type=body[player_gender]["Face"].types[player[playerid].face_type];
					local face_id=body[player_gender][player_skin]["Face"].types[player[playerid].face_id];
					local fatness=body["Fatness"].minimum+0.1*(player[playerid].fatness-1);
					Character_Create(playerid,player[playerid].name,body_type,body_id,face_type,face_id,fatness);
				else
					SendPlayerMessage(playerid,255,255,0,"(Server): The character doesn't have name.");
				end
			elseif player[playerid].row==selected_number-1 then
				Interface_CharacterMenu_Create_Hide(playerid);
			end
		end
	end
end

function Interface_CharacterMenu_Create_AddName(playerid,params)
	local result,name=sscanf(params,"s");
	if result==1 then
		if Character_Username_Check(name) then
			name=string.lower(name);
			name=string.gsub(name,"^%l", string.upper);
			player[playerid].name=name;
			
			GDraw.message(window.character_name[playerid].selected,name);
		else
			SendPlayerMessage(playerid,255,255,0,"(Server): You use alphanumeric characters (A-Z,a-z,0-9) in character name. It's length is 3 to 16.");
		end
	else
		SendPlayerMessage(playerid,255,255,0,string.format("(Server): use %s (new character name)",createname));
	end
end