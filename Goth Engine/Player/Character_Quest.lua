
local servername=nil;
local openName=nil;
local closeName=nil;
local removequestname=nil;
local has_item=nil;

local quest_max_number=0; --base value
local hint_number=0; --base value

local quest={};
for i = 0, GetMaxPlayers() - 1 do
	quest[i]={};
	quest[i].row=0;
	quest[i].number=0;
	quest[i].bring=false;
	quest[i].kill=false;
	quest[i].mission={};
end

local player={}
for i = 0, GetMaxPlayers() - 1 do
	player[i]={};
	player[i].active=false;
	player[i].loaded=false;
end

local box_show=nil;
local box_refresh=nil;
local box_hide=nil;
local box_key=nil;

function Character_Quest_Init_Box(show,refresh,hide,key)
	box_show=show;
	box_refresh=refresh;
	box_hide=hide;
	box_key=key;
end

function Character_Quest_Init()
	servername=Setting_GetServerName();
	Human_Quest_QuestFunc(Character_Quest_Add,Character_Quest_Remove);
end

function Character_Quest_Create(name)
	local handler=MySQL_Get();
	if handler~=nil then
		mysql_query(handler,string.format("CREATE TABLE `%s_%s_quest`(`npc` VARCHAR(50) PRIMARY KEY, `current` INT default 0, `ready` BOOLEAN default true)",servername,name));
	else
		Log_System("Character Quest: Database lost.");
	end
end

function Character_Quest_Delete(name)
	local handler=MySQL_Get();
	if handler~=nil then
		Human_Quest_Player_Delete(name);
		mysql_query(handler,string.format("DROP TABLE `%s_%s_quest`",servername,name));
	else
		Log_System("Character Quest: Database lost.");
	end
end

function Character_Quest_HasItemFunc(func)
	has_item=func;
end

function Character_Quest_OpenInitUse(name)
	openName="/"..name;
	Help_AddFunc("play",openName);
end

function Character_Quest_CloseInitUse(name)
	closeName="/"..name;
	Help_AddFunc("quest",closeName);
end

function Character_Quest_Remove_Init_Use(name)
	removequestname="/"..name;
	Help_AddFunc("quest",removequestname);
end

function Character_Quest_CommandText(playerid, cmdtext)
	local account=Player_GetAccount(playerid);
	
	if Player_Is(playerid) and GPlayer.IsLoginCharacter(account) then		
		if player[playerid].active then
			if cmdtext==closeName then
				Character_Quest_Hide(playerid);
			elseif cmdtext==removequestname then
				Character_Quest_Remove(playerid);
			elseif cmdtext=="/help" then
				Help_Message(playerid,"quest");
			end
		else
			if cmdtext==openName then
				Character_Quest_Show(playerid);
			end
		end
	end
end

function Character_Quest_MaxQuest(number)
	if number>0 then
		quest_max_number=number;
		for i = 0, GetMaxPlayers() - 1 do
			for j = 0, quest_max_number-1 do
				quest[i].mission[j]={};
				quest[i].mission[j].npc="";
				quest[i].mission[j].questtype="";
				quest[i].mission[j].mark="";
				quest[i].mission[j].markamount=0;
				quest[i].mission[j].current=0;
				quest[i].mission[j].text="";
				quest[i].mission[j].hint={};
			end
		end
	else
		Log_System("Character Quest: The questnumber must be more 0.");
	end
end

function Character_Quest_Short(length, dnumber, dlength)
	if length>0 and dnumber>0 and dlength>0 then
		hint_number=dnumber;
		Human_Quest_Short(length, dnumber, dlength);
	else
		Log_System("Character Quest: The quest short length, hint number and hint's length must be more 0.");
	end
end

function Character_Quest_Load(playerid)
	local handler=MySQL_Get();
	if handler~=nil then
		local account=Player_GetAccount(playerid);
		local character=GPlayer.GetCharacter(account);
		local name=GCharacter.GetName(character);
		
		player[playerid].loaded=false;
		local quests=mysql_query(handler, string.format("SELECT `npc`,`ready` FROM `%s_%s_quest`",servername,name));
		if quests then
			local number=mysql_num_rows(quests);
			quest[playerid].number=0;
			quest[playerid].bring=false;
			quest[playerid].kill=false;
			if number~=0 then
				for quests,q in mysql_rows_assoc(quests) do
					if Human_Quest_Player_Exist(q['npc'],playerid) then
						if tonumber(q['ready'])==1 then
							Human_Quest_Add(playerid,q['npc']);
						end
					else
						if tonumber(q['ready'])==1 then
							SendPlayerMessage(playerid,255,255,0,string.format("(Server): %s, who give a quest lost, that's why her(his) quest was deleted.",q['npc']));
						end
						mysql_query(handler, string.format("DELETE FROM `%s_%s_quest` WHERE `npc`=%q",servername,name,q['npc']));
					end
				end
			end
			player[playerid].loaded=true;
			mysql_free_result(quests);
			return true;
		else
			SendPlayerMessage(playerid,255,255,0,"(Server): Database Error. The character's quests lost.");
		end
	else
		SendPlayerMessage(playerid,255,255,0,"(Server): Database Error.");
		Log_System("Character Quest: Database lost.");
	end
	return false;
end

function Character_Quest_Add(playerid,npcname,questtype,mark,amount,questshort,hint)
	local handler=MySQL_Get();
	if handler~=nil then
		local quest_number=quest[playerid].number;
		if quest_number<quest_max_number then	
			quest[playerid].mission[quest_number].npc=npcname;
			quest[playerid].mission[quest_number].questtype=questtype;
			quest[playerid].mission[quest_number].mark=mark;
			quest[playerid].mission[quest_number].markamount=amount;
			quest[playerid].mission[quest_number].text=questshort;
			quest[playerid].mission[quest_number].current=0;
			
			for i=0, hint_number-1 do
				quest[playerid].mission[quest_number].hint[i]=hint[i];
			end
			
			local account=Player_GetAccount(playerid);
			local character=GPlayer.GetCharacter(account);
			local name=GCharacter.GetName(character);
			
			local result=mysql_query(handler, string.format("SELECT `npc` FROM `%s_%s_quest` WHERE `npc`=%q",servername,name,npcname));
			if result then
				local mission = mysql_fetch_assoc(result);
				mysql_free_result(result);
				if mission then
					mysql_query(handler,string.format("UPDATE `%s_%s_quest` SET `ready`=1 WHERE `npc`=%q",servername,name,npcname));
				else
					mysql_query(handler,string.format("INSERT INTO `%s_%s_quest`(`npc`) VALUES (%q)",servername,name,npcname));
				end
			else
				SendPlayerMessage(playerid,255,255,0,"(Server): Database Error.");
			end
			
			if player[playerid].loaded then
				Log_Player(playerid,string.format("Quest: %s gave a quest.",quest[playerid].mission[quest_number].npc));
			end
			
			if questtype=="bring" then
				quest[playerid].bring=true;
				quest[playerid].mission[quest_number].current=has_item(playerid,mark);
				if quest[playerid].mission[quest_number].current>=quest[playerid].mission[quest_number].markamount then
					Human_Quest_Ready(playerid,quest[playerid].mission[quest_number].npc,true);
				end
			end
			
			if questtype=="kill" then
				quest[playerid].kill=true;
				local result=mysql_query(handler, string.format("SELECT `current` FROM `%s_%s_quest` WHERE `npc`=%q",servername,name,npcname));
				if result then
					local current = mysql_fetch_assoc(result);
					mysql_free_result(result);
					if current then
						quest[playerid].mission[quest_number].current=tonumber(current['current']);
						if quest[playerid].mission[quest_number].current>=quest[playerid].mission[quest_number].markamount then
							Human_Quest_Ready(playerid,quest[playerid].mission[quest_number].npc,true);
						end
					else
						SendPlayerMessage(playerid,255,255,0,"(Server): Database Error.");
					end
				else
					SendPlayerMessage(playerid,255,255,0,"(Server): Database Error.");
				end
			end
			
			quest[playerid].number=quest[playerid].number+1;
			
			return true;
		else
			GameTextForPlayer(playerid,2500,4500,string.format("You have got %d quest.",quest_max_number),"Font_Old_20_White_Hi.TGA",255,255,255,2000);
		end
	else
		SendPlayerMessage(playerid,255,255,0,"(Server): Database Error.");
		Log_System("Character Quest: Database lost.");
	end
	return false;
end

function Character_Quest_Remove(playerid,npcname)
	local handler=MySQL_Get();
	if handler~=nil then
		if quest[playerid].number~=0 then
			if npcname~=nil then
				local j=0;
				while quest[playerid].mission[j].npc~=npcname do
					j=j+1;
				end
				quest[playerid].row=j;
			else
				Human_Quest_Delete(playerid,quest[playerid].mission[quest[playerid].row].npc)
				Log_Player(playerid,string.format("Quest: (S)he drop %s's quest.",quest[playerid].mission[quest[playerid].row].npc));
			end		
			
			local account=Player_GetAccount(playerid);
			local character=GPlayer.GetCharacter(account);
			local characterName=GCharacter.GetName(character);
			local questtype=quest[playerid].mission[quest[playerid].row].questtype;
			
			mysql_query(handler,string.format("UPDATE `%s_%s_quest` SET `ready`=0,`current`=0 WHERE `npc`=%q",servername,characterName,quest[playerid].mission[quest[playerid].row].npc));
			
			for i = quest[playerid].row+1, quest[playerid].number-1 do
				quest[playerid].mission[i-1].npc=quest[playerid].mission[i].npc;
				quest[playerid].mission[i-1].questtype=quest[playerid].mission[i].questtype;
				quest[playerid].mission[i-1].mark=quest[playerid].mission[i].mark;
				quest[playerid].mission[i-1].markamount=quest[playerid].mission[i].markamount;
				quest[playerid].mission[i-1].text=quest[playerid].mission[i].text;
				for j=0, hint_number-1 do
					quest[playerid].mission[i-1].hint[j]=quest[playerid].mission[i].hint[j];
				end
			end	
			quest[playerid].number=quest[playerid].number-1;
			
			local i=0;
			while i<quest[playerid].number and quest[playerid].mission[i].questtype~=questtype do
				i=i+1;
			end
			if i==quest[playerid].number then
				if questtype=="bring" then
					quest[playerid].bring=false;
				end
				
				if questtype=="kill" then
					quest[playerid].kill=false;
				end
			end
			
			if npcname==nil then
				Character_Quest_Refresh(playerid);
			end
		end
	else
		SendPlayerMessage(playerid,255,255,0,"(Server): Database Error.");
		Log_System("Character Quest: Database lost.");
	end
end

function Character_Quest_Take(playerid, item_instance, amount)
	if quest[playerid].bring then
		for i=0, quest[playerid].number-1 do
			if quest[playerid].mission[i].mark==item_instance then
				quest[playerid].mission[i].current=quest[playerid].mission[i].current+amount;
				
				if quest[playerid].mission[i].current>=quest[playerid].mission[i].markamount then
					Human_Quest_Ready(playerid,quest[playerid].mission[i].npc,true);
				end
			end
		end
	end
end

function Character_Quest_Drop(playerid, item_instance, amount)
	if quest[playerid].bring then
		for i=0, quest[playerid].number-1 do
			if quest[playerid].mission[i].mark==item_instance then
				quest[playerid].mission[i].current=quest[playerid].mission[i].current-amount;
				if quest[playerid].mission[i].current<0 then
					quest[playerid].mission[i].current=0;
				end
				if quest[playerid].mission[i].current<quest[playerid].mission[i].markamount then
					Human_Quest_Ready(playerid,quest[playerid].mission[i].npc,false);
				end
			end
		end
	end
end

function Character_Quest_Kill(deathid, playerid)
	local handler=MySQL_Get();
	if handler~=nil then
		if playerid~=-1 and Player_Is(playerid) and quest[playerid].kill then
			for i=0, quest[playerid].number-1 do
				if quest[playerid].mission[i].mark==GetPlayerName(deathid) then
					if quest[playerid].mission[i].current<quest[playerid].mission[i].markamount then
						quest[playerid].mission[i].current=quest[playerid].mission[i].current+1;
						local account=Player_GetAccount(playerid);
						local character=GPlayer.GetCharacter(account);
						local characterName=GCharacter.GetName(character);
						mysql_query(handler,string.format("UPDATE `%s_%s_quest` SET `current`=`current`+1 WHERE `npc`=%q",servername,characterName,quest[playerid].mission[i].npc));
						if quest[playerid].mission[i].current>=quest[playerid].mission[i].markamount then
							Human_Quest_Ready(playerid,quest[playerid].mission[i].npc,true);
						end
					end
				end
			end	
		end
	else
		SendPlayerMessage(playerid,255,255,0,"(Server): Database Error.");
		Log_System("Character Quest: Database lost.");
	end
end

function Character_Quest_Show(playerid)
	local account=Player_GetAccount(playerid);
	
	if not(GPlayer.IsBusy(account)) then
		player[playerid].active=true;
		GPlayer.SetBusy(account,true);
		FreezePlayer(playerid,1);

		box_show(playerid);
		
		Character_Quest_Refresh(playerid);
	end
end

function Character_Quest_Refresh(playerid)
	quest[playerid].row=0;
	box_refresh(playerid);
end

function Character_Quest_Move(playerid,new)
	quest[playerid].row=new;
end

function Character_Quest_Hint(playerid,row)
	local hint={};
	if quest[playerid].number~=0 then
		if quest[playerid].mission[row].current>=quest[playerid].mission[row].markamount then
			hint[0]=string.format("Go back to %s.",quest[playerid].mission[row].npc)
		else
			hint=quest[playerid].mission[row].hint;
		end
	end
	return hint;
end

function Character_Quest_Hide(playerid)
	if player[playerid].active then
		box_hide(playerid);
		
		FreezePlayer(playerid,0);
		local account=Player_GetAccount(playerid);
		GPlayer.SetBusy(account,false);
		player[playerid].active=false;
	end
end

function Character_Quest_Key(playerid,keydown)
	if player[playerid].active then
		box_key(playerid,keydown);
	end
end

function Character_Quest_Logout(playerid)
	if player[playerid].active then
		Character_Quest_Hide(playerid);
	end
end

function Character_Quest_Player(playerid)
	local text={};
	for i=0, quest[playerid].number-1 do
		text[i]=quest[playerid].mission[i].text;
	end
	
	return quest[playerid].number,text;
end