
local window={};
window.x=1000;
window.y=5800;
window.texture=nil;
window.row={};

local player={};

function Interface_TrainerBox_Init()
	window.texture=CreateTexture(window.x,window.y,window.x+2500,window.y+1000,"Frame_GMPA.TGA");
	for i = 0, GetMaxPlayers() - 1 do
		window.row[i]={};
		window.row[i][0]= GDraw.new(window.x+100,window.y+150,"1","Font_Old_10_White_Hi.TGA",255,255,255);
		window.row[i][1]= GDraw.new(window.x+100,window.y+300,"5","Font_Old_10_White_Hi.TGA",255,255,255);
		window.row[i][2]= GDraw.new(window.x+100,window.y+600,"next","Font_Old_10_White_Hi.TGA",255,255,255);
		window.row[i][3]= GDraw.new(window.x+100,window.y+750,"Exit","Font_Old_10_White_Hi.TGA",255,255,255);
	end

	for i = 0, GetMaxPlayers() - 1 do
		 player[i]={};
		 player[i].row=0;
		 player[i].text={};
	end
	Human_Trainer_Init_Box(Interface_TrainerBox_Show,Interface_TrainerBox_Refresh,Interface_TrainerBox_Hide,Interface_TrainerBox_Key);
	Help_AddHelp("trainer","You can move w,s (or arrow) and selected is CTRL.");
end

function Interface_TrainerBox_Show(playerid)
	ShowTexture(playerid,window.texture);
	Interface_Npcname_Show(playerid,window.x+100,window.y-225);
	
	for i=0,3 do
		ShowDraw(playerid,GDraw.id(window.row[playerid][i]));
	end
end

function Interface_TrainerBox_Refresh(playerid,text)
	player[playerid].text=text;
	local onlyexit=true;
	
	if text[0]~=nil then
		GDraw.message_color(window.row[playerid][0],text[0],255,255,0);
		player[playerid].row=0;
		onlyexit=false;
	else
		GDraw.message(window.row[playerid][0],"");
	end
	
	for i=1,2 do
		if text[i]~=nil then
			GDraw.message_color(window.row[playerid][i],text[i],255,255,255);
		else
			GDraw.message(window.row[playerid][i],"");
		end
	end
	
	if onlyexit then
		player[playerid].row=3;
		GDraw.color(window.row[playerid][3],255,255,0);
	else
		GDraw.color(window.row[playerid][3],255,255,255);
	end
end

function Interface_TrainerBox_Move(playerid,move)
	if not( player[playerid].text[0]==nil and player[playerid].text[1]==nil and player[playerid].text[2]==nil) then
		local new=player[playerid].row;
		
		if new+move>=0 and new+move<4 then
			new=new+move
			while player[playerid].text[new]==nil and new+move>=0 and new+move<4 do
				new=new+move
			end
		end
		
		if player[playerid].row~=new then
			GDraw.color(window.row[playerid][ player[playerid].row ],255,255,255);
			GDraw.color(window.row[playerid][new],255,255,0);
			player[playerid].row=new;
		end
	end
end

function Interface_TrainerBox_Hide(playerid)
	HideTexture(playerid,window.texture);
	Interface_Npcname_Hide(playerid);
	for i = 0,3 do
		HideDraw(playerid,GDraw.id(window.row[playerid][i]));
	end
end

function Interface_TrainerBox_Key(playerid,keydown)
	if keydown == KEY_W or keydown == KEY_UP then
		Interface_TrainerBox_Move(playerid,-1);
	elseif keydown == KEY_S or keydown == KEY_DOWN then
		Interface_TrainerBox_Move(playerid,1);
	elseif keydown == KEY_LCONTROL or keydown == KEY_RCONTROL then
		Human_Trainer_Learn(playerid,player[playerid].row);
	end
end