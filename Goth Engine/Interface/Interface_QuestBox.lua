
local quest_window={};
quest_window.x=1800;
quest_window.y=2400;
quest_window.name=nil;
quest_window.texture=nil;
quest_window.row={};
quest_window.number={};

local hint_window={};
hint_window.x=quest_window.x+450;
hint_window.y=quest_window.y+2800;
hint_window.name=nil;
hint_window.texture=nil;
hint_window.row={};

local exit_window={};
exit_window.x=hint_window.x+1400;
exit_window.y=hint_window.y+1100;
exit_window.texture=nil;
exit_window.text={};

local deleteText={};
deleteText.x=hint_window.x+250;
deleteText.y=hint_window.y+100;
deleteText.question=nil;
deleteText.yes={};
deleteText.no={};

local quest_max_number=15;
local hint_draw_number=3;
local player={};

function Interface_QuestBox_Init()
	quest_window.texture=CreateTexture(quest_window.x,quest_window.y,quest_window.x+4600,hint_window.y-200,"Frame_GMPA.TGA");
	quest_window.name=GDraw.new(quest_window.x+100,quest_window.y-225,"Quests","Font_Old_20_White_Hi.TGA",255,255,255);
	
	hint_window.texture=CreateTexture(hint_window.x,hint_window.y,hint_window.x+3800,hint_window.y+1000,"Frame_GMPA.TGA");
	hint_window.name=GDraw.new(hint_window.x+100,hint_window.y-225,"Hint","Font_Old_20_White_Hi.TGA",255,255,255);
	
	exit_window.texture=CreateTexture(exit_window.x,exit_window.y,exit_window.x+800,exit_window.y+400,"Frame_GMPA.TGA");
	
	deleteText.question=GDraw.new(deleteText.x,deleteText.y,"Do you want to delete it?","Font_Old_20_White_Hi.TGA",255,255,255);
	
	for i = 0, GetMaxPlayers() - 1 do
		quest_window.row[i]={};
		for j = 0, quest_max_number-1 do
			quest_window.row[i][j]=GDraw.new(quest_window.x+200,quest_window.y+200+j*150,"","Font_Old_10_White_Hi.TGA",255,255,255);
		end

		quest_window.number[i]=GDraw.new(quest_window.x+4200,hint_window.y-500,"","Font_Old_10_White_Hi.TGA",255,255,255);

		hint_window.row[i]={};
		for j = 0, hint_draw_number-1 do
			hint_window.row[i][j]=GDraw.new(hint_window.x+200,hint_window.y+200+j*150,"","Font_Old_10_White_Hi.TGA",255,255,255);
		end
		
		exit_window.text[i]=GDraw.new(exit_window.x+150,exit_window.y+50,"Exit","Font_Old_20_White_Hi.TGA",255,255,255);
		
		deleteText.yes[i]=GDraw.new(deleteText.x+850,deleteText.y+300,"Yes","Font_Old_20_White_Hi.TGA",255,255,255);
		deleteText.no[i]=GDraw.new(deleteText.x+1850,deleteText.y+300,"No","Font_Old_20_White_Hi.TGA",255,255,255);
		
		player[i]={};
		player[i].quests={};
		player[i].quests.number=0;
		player[i].quests.text={};
		player[i].row=0;
		player[i].deleteDialog=false;
		player[i].deleteSelect=1;
	end
	Character_Quest_Init_Box(Interface_QuestBox_Show,Interface_QuestBox_Refresh,Interface_QuestBox_Hide,Interface_QuestBox_Key);
	Character_Quest_Short(40, hint_draw_number, 30);
	Character_Quest_MaxQuest(quest_max_number);

	Help_AddHelp("quest","You can move w,a,s,d (or arrow) and selected is CTRL.")
end

function Interface_QuestBox_Show(playerid)
	player[playerid].quests.number=0;
	player[playerid].deleteDialog=false;
	ShowDraw(playerid,GDraw.id(quest_window.name));
	ShowTexture(playerid,quest_window.texture);
	ShowDraw(playerid,GDraw.id(quest_window.number[playerid]));
	
	ShowTexture(playerid,hint_window.texture);
	Interface_QuestBox_HintShow(playerid);
	
	ShowTexture(playerid,exit_window.texture);
	ShowDraw(playerid,GDraw.id(exit_window.text[playerid]));
	
	SetPlayerEnable_OnPlayerKey(playerid,1);
end

function Interface_QuestBox_Refresh(playerid)
	player[playerid].row=0;
	local number=0;
	number,player[playerid].quests.text=Character_Quest_Player(playerid);
	if player[playerid].quests.number>number then
		while player[playerid].quests.number~=number do
			player[playerid].quests.number=player[playerid].quests.number-1;
			HideDraw(playerid,GDraw.id(quest_window.row[playerid][ player[playerid].quests.number ]));
		end
	elseif player[playerid].quests.number<number then
		while player[playerid].quests.number~=number do
			ShowDraw(playerid,GDraw.id(quest_window.row[playerid][ player[playerid].quests.number ]));
			player[playerid].quests.number=player[playerid].quests.number+1;
		end
	end
	
	if number~=0 then
		GDraw.message_color(quest_window.row[playerid][0],string.format("%d. %s",1,player[playerid].quests.text[0]),255,255,0);
		for i=1, number-1 do
			GDraw.message_color(quest_window.row[playerid][i],string.format("%d. %s",i+1,player[playerid].quests.text[i]),255,255,255);
		end
		GDraw.color(exit_window.text[playerid],255,255,255);
	else
		GDraw.color(exit_window.text[playerid],255,255,0);
	end
	Interface_QuestBox_Hint(playerid);
	GDraw.message(quest_window.number[playerid],string.format("%d/%d",number,quest_max_number));
end

function Interface_QuestBox_Move(playerid,move)	
	if player[playerid].quests.number~=0 then
		local new=player[playerid].row+move;
		
		if new<0 then
			new=player[playerid].quests.number;
		end
		
		if new>player[playerid].quests.number then
			new=0;
		end
		
		if new==player[playerid].quests.number then
			GDraw.color(exit_window.text[playerid],255,255,0);
		else
			GDraw.color(quest_window.row[playerid][new],255,255,0);
		end
		
		if player[playerid].row==player[playerid].quests.number then
			GDraw.color(exit_window.text[playerid],255,255,255);
		else
			GDraw.color(quest_window.row[playerid][ player[playerid].row ],255,255,255);
		end
			
		Character_Quest_Move(playerid,new);
		player[playerid].row=new;
		Interface_QuestBox_Hint(playerid);
	end
end

function Interface_QuestBox_Hide(playerid)
	HideDraw(playerid,GDraw.id(quest_window.name));
	HideTexture(playerid,quest_window.texture);
	HideDraw(playerid,GDraw.id(quest_window.number[playerid]));
	for i = 0, player[playerid].quests.number-1 do
		HideDraw(playerid,GDraw.id(quest_window.row[playerid][i]));
	end
	
	HideTexture(playerid,hint_window.texture);
	Interface_QuestBox_HintHide(playerid);
	
	HideTexture(playerid,exit_window.texture);
	HideDraw(playerid,GDraw.id(exit_window.text[playerid]));
	
	local focus=GetFocus(playerid);
	if (not Human_Is(focus)) then
		SetPlayerEnable_OnPlayerKey(playerid,0);
	end
end

function Interface_QuestBox_HintShow(playerid)
	ShowDraw(playerid,GDraw.id(hint_window.name));
	for i = 0, hint_draw_number-1 do
		ShowDraw(playerid,GDraw.id(hint_window.row[playerid][i]));
	end
end

function Interface_QuestBox_Hint(playerid)
	if player[playerid].row~=player[playerid].quests.number then
		local hint=Character_Quest_Hint(playerid,player[playerid].row);
		for i=0,hint_draw_number-1 do
			if hint[i]~=nil then
				GDraw.message(hint_window.row[playerid][i],hint[i]);
			else
				GDraw.message(hint_window.row[playerid][i],"");
			end
		end
	else
		for i=0,hint_draw_number-1 do
			GDraw.message(hint_window.row[playerid][i],"");
		end
	end
end

function Interface_QuestBox_HintHide(playerid)
	HideDraw(playerid,GDraw.id(hint_window.name));
	for i = 0, hint_draw_number-1 do
		HideDraw(playerid,GDraw.id(hint_window.row[playerid][i]));
	end
end

function Interface_QuestBox_DeleteShow(playerid)
	player[playerid].deleteDialog=true;
	player[playerid].deleteSelect=1;
	
	Interface_QuestBox_HintHide(playerid);
	ShowDraw(playerid,GDraw.id(deleteText.question));
	ShowDraw(playerid,GDraw.id(deleteText.yes[playerid]));
	ShowDraw(playerid,GDraw.id(deleteText.no[playerid]));
	
	Interface_QuestBox_DeleteRefresh(playerid);
end

function Interface_QuestBox_DeleteRefresh(playerid)
	GDraw.color(deleteText.yes[playerid],255,255,255);
	GDraw.color(deleteText.no[playerid],255,255,0);
end

function Interface_QuestBox_DeleteMove(playerid,move)	
	local new=player[playerid].deleteSelect;
	if new+move>=0 and new+move<2 then
		new=new+move;
	end
		
	if player[playerid].deleteSelect~=new then
		if new==0 then --yes
			GDraw.color(deleteText.yes[playerid],255,255,0);
			GDraw.color(deleteText.no[playerid],255,255,255);
		else
			GDraw.color(deleteText.yes[playerid],255,255,255);
			GDraw.color(deleteText.no[playerid],255,255,0);
		end
		player[playerid].deleteSelect=new;
	end
end

function Interface_QuestBox_DeleteHide(playerid)
	player[playerid].deleteDialog=false;
	Interface_QuestBox_HintShow(playerid);
	HideDraw(playerid,GDraw.id(deleteText.question));
	HideDraw(playerid,GDraw.id(deleteText.yes[playerid]));
	HideDraw(playerid,GDraw.id(deleteText.no[playerid]));
end

function Interface_QuestBox_Key(playerid,keydown)
	if (keydown == KEY_W or keydown == KEY_UP) and (not player[playerid].deleteDialog) then
		Interface_QuestBox_Move(playerid,-1);
	elseif (keydown == KEY_S or keydown == KEY_DOWN) and (not player[playerid].deleteDialog) then
		Interface_QuestBox_Move(playerid,1);
	elseif (keydown == KEY_A or keydown == KEY_LEFT) and player[playerid].deleteDialog then
		Interface_QuestBox_DeleteMove(playerid,-1);
	elseif (keydown == KEY_D or keydown == KEY_RIGHT) and player[playerid].deleteDialog then
		Interface_QuestBox_DeleteMove(playerid,1);
	elseif (keydown == KEY_LCONTROL or keydown == KEY_RCONTROL) then
		if player[playerid].row==player[playerid].quests.number then
			Character_Quest_Hide(playerid);
		else
			if player[playerid].deleteDialog then
				if player[playerid].deleteSelect==0 then --yes
					Character_Quest_Remove(playerid);
				end
				Interface_QuestBox_DeleteHide(playerid);
			else
				Interface_QuestBox_DeleteShow(playerid);
			end
		end
	end
end