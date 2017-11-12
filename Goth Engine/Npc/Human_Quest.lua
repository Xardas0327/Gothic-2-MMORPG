
local servername=nil;
local human={};

local row={};
row.length=40;	--base value
row.number=1;	--base value

local hint={};
hint.shortlength=40;	--base value
hint.number=3;	--base value
hint.length=30;	--base value


local player={}
for i = 0, GetMaxPlayers() - 1 do
	player[i]={};
	player[i].target=nil;
	player[i].active=false;
	player[i].closew=false;
end

local box_show=nil;
local box_refresh=nil;
local box_hide=nil;

local add_quest=nil;
local remove_quest=nil;
local give_item=nil;
local remove_item=nil;
local xp_increase=nil;

function Human_Quest_Init()
	servername=Setting_GetServerName();
end

function Human_Quest_Init_Box(show,refresh,hide)
	box_show=show;
	box_refresh=refresh;
	box_hide=hide;
end

function Human_Quest_QuestFunc(funcadd,funcremove)
	add_quest=funcadd;
	remove_quest=funcremove;
end

function Human_Quest_ItemFunc(givef,removef)
	give_item=givef;
	remove_item=removef;
end

function Human_Quest_XpFunc(xpfunc)
	xp_increase=xpfunc;
end

function Human_Quest_Row(number,length)
	if number>0 and length>0 then
		row.number=number;
		row.length=length;
	else
		Log_System(string.format("Human Quest: The row number and row's length must be more 0, that's why row number is %d, and row's length is %d.",row.number,row.length));
	end
end

function Human_Quest_Short(length, dnumber, dlength)
	if length>0 and dnumber>0 and dlength>0 then
		hint.shortlength=length;
		hint.number=dnumber;
		hint.length=dlength;
	else
		Log_System(string.format("Human Quest: The quest short length, hint number and hint's length must be more 0, that's why they are %d,%d,%d.",hint.shortlength,hint.number,hint.length));
	end
end

function Human_Quest(npcid,argument)
	local handler=MySQL_Get();
	if handler~=nil then
		if Human_Quest_Check(GetPlayerName(npcid),argument) then
			human[npcid]={};
			human[npcid]=argument;
			
			human[npcid].angle=GetPlayerAngle(npcid);
			
			human[npcid].player={};
			for i = 0, GetMaxPlayers() - 1 do
				human[npcid].player[i]={};
				human[npcid].player[i].stand=0;
				human[npcid].player[i].ready=false;
				human[npcid].player[i].complete=false;
			end;
			mysql_query(handler,string.format("CREATE TABLE IF NOT EXISTS `%s_quest`(`servername` VARCHAR(50) NOT NULL, `charname` VARCHAR(50) NOT NULL, `stand` INT default 0, PRIMARY KEY(`servername`,`charname`));",GetPlayerName(npcid)));
			return Human_Quest_Show;	

		else
			Log_System(string.format("Human Quest: %s don't give quest.",GetPlayerName(npcid)));
		end
	else
		Log_System("Human Quest: Database lost.");
	end
	return nil;
end

function Human_Quest_Search(name)
	for k,v in pairs(human) do
		if GetPlayerName(k)==name then
			return k;
		end
	end
	
	return nil;
end

function Human_Quest_Player_Exist(npcname,playerid)
	local handler=MySQL_Get();
	if handler~=nil then
		local players=mysql_query(handler,string.format("SELECT `charname` FROM `%s_quest` WHERE `charname`=%q AND `servername`=%q",npcname,GetPlayerName(playerid),servername));
		local i=Human_Quest_Search(npcname);
		if players and i~=nil then
			local player = mysql_fetch_assoc(players);
			mysql_free_result(players);
			if player then
				return true;
			end
		else
			SendPlayerMessage(playerid,255,255,0,"(Server): Database Error.");
		end
	else
		Log_System("Human Quest: Database lost.");
	end
	return false;
end

function Human_Quest_Player_Delete(playername)
	local handler=MySQL_Get();
	if handler~=nil then
		for k,v in pairs(human) do
			mysql_query(handler,string.format("DELETE FROM `%s_quest` WHERE `charname`=%q AND `servername`=%q",GetPlayerName(k),playername,servername));
		end
	else
		Log_System("Human Quest: Database lost.");
	end
end

function Human_Quest_Show(playerid,npcid)
	local handler=MySQL_Get();
	if handler~=nil then
		local account=Player_GetAccount(playerid);
		
		if not(GPlayer.IsBusy(account)) then
			player[playerid].active=true;
			
			GPlayer.SetBusy(account,true);
			SetPlayerAngle(npcid,GetAngleToPlayer(npcid,playerid));	
			SetPlayerAngle(playerid,GetAngleToPlayer(playerid,npcid));	
			player[playerid].target=npcid;
			
			local playername=GetPlayerName(playerid);
			local players=mysql_query(handler,string.format("SELECT `stand` FROM `%s_quest` WHERE `charname`=%q and `servername`=%q",GetPlayerName(npcid),GetPlayerName(playerid),servername));
			if players  then
				local player = mysql_fetch_assoc(players);
				mysql_free_result(players);
				if player then
					human[npcid].player[playerid].stand=tonumber(player['stand']);
				else
					human[npcid].player[playerid].stand=0;
					mysql_query(handler,string.format("INSERT INTO `%s_quest`(`servername`,`charname`) VALUES (%q,%q)",GetPlayerName(npcid),servername,playername));
				end
			else
				SendPlayerMessage(playerid,255,255,0,"(Server): Database Error.");
			end
			
			box_show(playerid);	
			Human_Quest_Refresh(playerid);
		end
	else
		Log_System("Human Quest: Database lost.");
	end
end

function Human_Quest_Refresh(playerid)
	local handler=MySQL_Get();
	if handler~=nil then
		local account=Player_GetAccount(playerid);
		if account~=nil and GPlayer.IsLoginCharacter(account) then	
			local target=player[playerid].target;
			if not(player[playerid].closew) then
				PlayGesticulation(target);
				local message=nil;
				local questready=true;
				if(human[target].player[playerid].stand<human[target].stop) then
					message=human[target].talk[ human[target].player[playerid].stand ];
					
					if human[target].player[playerid].stand==human[target].stop-1 then -- The player is received the quest.
						SendPlayerMessage(playerid,255,255,0,"New Quest");
						human[target].player[playerid].ready=false;
						questready=add_quest(playerid,GetPlayerName(target),human[target].questtype,human[target].mark,human[target].markamount,human[target].questshort,human[target].hint);		
						player[playerid].closew=true;
						mysql_query(handler,string.format("UPDATE `%s_quest` SET `stand`=%d WHERE `charname`=%q AND `servername`=%q",GetPlayerName(target),human[target].player[playerid].stand,GetPlayerName(playerid),servername));
					end
					
					human[target].player[playerid].stand=human[target].player[playerid].stand+1;
				elseif human[target].player[playerid].ready then
					message=human[target].talk[ human[target].player[playerid].stand ];
					
					SendPlayerMessage(playerid,255,255,0,"Quest Complete");
					remove_quest(playerid,GetPlayerName(target))
					if human[target].questtype=="bring" then
						remove_item(playerid, human[target].mark,human[target].markamount);
					end
					xp_increase(playerid, human[target].xp,string.format("Quest: %s's quest complete.",GetPlayerName(target)));
					if human[target].reward~=nil then
						give_item(playerid,human[target].reward,human[target].rewardamount,true);
					end
					human[target].player[playerid].ready=false;
					human[target].player[playerid].complete=true;
					mysql_query(handler,string.format("UPDATE `%s_quest` SET `stand`=%d WHERE `charname`=%q AND `servername`=%q",GetPlayerName(target),human[target].player[playerid].stand,GetPlayerName(playerid),servername));	
					
					human[target].player[playerid].stand=human[target].player[playerid].stand+1;
				elseif human[target].player[playerid].stand==human[target].stop then -- if the quest isn't ready then the message is this one.
					message=human[target].waittalk;
					player[playerid].closew=true;
				elseif human[target].player[playerid].stand<human[target].talknumber then
					message=human[target].talk[ human[target].player[playerid].stand ];
					human[target].player[playerid].stand=human[target].player[playerid].stand+1;
				elseif human[target].player[playerid].stand>=human[target].talknumber then -- if the quest is ready, but it isn't repeated then the message is this one.
					message=human[target].endtalk;
					player[playerid].closew=true;
				end
				
				if human[target].player[playerid].stand>=human[target].talknumber then
					player[playerid].closew=true;
				end
				
				if not(questready) then -- If it is false then the player can't accept the quest. 
					human[target].player[playerid].stand=0;
					player[playerid].closew=true;
				end
				box_refresh(playerid,"Human_Quest_Refresh",message);
			else
				if human[target].player[playerid].complete and human[target].repeated~=nil then -- If the quest is repeated then the quest begin again.
					human[target].player[playerid].stand=human[target].repeated-1;
					human[target].player[playerid].complete=false;
				end
				mysql_query(handler,string.format("UPDATE `%s_quest` SET `stand`=%d WHERE `charname`=%q and `servername`=%q",GetPlayerName(target),human[target].player[playerid].stand,GetPlayerName(playerid),servername));
				Human_Quest_Hide(playerid);
			end
		end
	else
		Log_System("Human Quest: Database lost.");
	end
end

function Human_Quest_Hide(playerid)
	if player[playerid].active then
		box_hide(playerid);
		local account=Player_GetAccount(playerid);
		GPlayer.SetBusy(account,false);
		player[playerid].closew=false;
		player[playerid].active=false;
		SetPlayerAngle(player[playerid].target,human[player[playerid].target].angle);
	end
end

function Human_Quest_Add(playerid,npcname)
	local i=Human_Quest_Search(npcname);
	human[i].player[playerid].ready=false;
	add_quest(playerid,GetPlayerName(i),human[i].questtype,human[i].mark,human[i].markamount,human[i].questshort,human[i].hint);
end

function Human_Quest_Delete(playerid,npcname)
	local handler=MySQL_Get();
	if handler~=nil then
		local i=Human_Quest_Search(npcname);
		mysql_query(handler,string.format("UPDATE `%s_quest` SET `stand`=0 WHERE `charname`=%q AND `servername`=%q",npcname,GetPlayerName(playerid),servername));
		human[i].player[playerid].ready=false;
	else
		SendPlayerMessage(playerid,255,255,0,"(Server): Database Error.");
		Log_System("Human Quest: Database lost.");
	end
end

function Human_Quest_Ready(playerid,npcname,value)
	local i=Human_Quest_Search(npcname);
	human[i].player[playerid].ready=value;
end

function Human_Quest_Logout(playerid)
	if player[playerid].active then
		Human_Quest_Hide(playerid);
	end
end

function Human_Quest_Check(npcname,quest)
	local ready=true;
	
	if quest==nil then
		Log_System(string.format("Human Quest: %s's quest is wrong.",npcname));
		ready=false;
	else		
		if type(quest.questtype)~="string" or (quest.questtype~="bring" and quest.questtype~="kill") then
			Log_System(string.format("Human Quest: %s's quest: the questtype is wrong.",npcname));
			ready=false;
		end
		
		if type(quest.mark)~="string" or (quest.questtype=="bring" and not(Item_Exist(quest.mark))) then
			print(quest.mark)
			Log_System(string.format("Human Quest: %s's quest: the mark is wrong.",npcname));
			ready=false;
		end
		
		if type(quest.markamount)~="number" or quest.markamount<=0 then
			Log_System(string.format("Human Quest: %s's quest: the markamount is wrong.",npcname));
			ready=false;
		end
		
		if type(quest.xp)~="number" or quest.xp<=0 then
			Log_System(string.format("Human Quest: %s's quest: the xp is wrong.",npcname));
			ready=false;
		end
		
		if (quest.reward==nil and quest.rewardamount~=nil) or (quest.reward~=nil and (type(quest.reward)~="string" or not(Item_Exist(quest.reward)))) then
			Log_System(string.format("Human Quest: %s's quest: the reward is wrong.",npcname));
			ready=false;
		end
		
		if (quest.reward~=nil and quest.rewardamount==nil) or (quest.reward~=nil and (type(quest.rewardamount)~="number" or quest.rewardamount<=0)) then
			Log_System(string.format("Human Quest: %s's quest: the rewardamount is wrong.",npcname));
			ready=false;
		end
		
		if type(quest.talknumber)~="number" or quest.talknumber<=0 then
			Log_System(string.format("Human Quest: %s's quest: the talknumber is wrong.",npcname));
			ready=false;
		else
			if type(quest.stop)~="number" or quest.stop<=0 or quest.stop>=quest.talknumber then
				Log_System(string.format("Human Quest: %s's quest: the stop is wrong.",npcname));
				ready=false;
			end
			
			if quest.repeated~=nil and (type(quest.repeated)~="number" or quest.repeated<=0 or quest.repeated>quest.stop) then
				Log_System(string.format("Human Quest: %s's quest: the repeated is wrong.",npcname));
				ready=false;
			end
			
			for i=0, quest.talknumber-1 do
				if quest.talk[i]==nil then
					Log_System(string.format("Human Quest: %s's quest: the %d. talk is wrong.",npcname,i+1));
					ready=false;
				else
					if Human_Quest_WrongTalk(quest.talk[i]) then
						Log_System(string.format("Human Quest: %s's quest: the %d. talk is wrong.",npcname,i+1));
						ready=false;
					else
						for j=0, row.number-1 do
							if quest.talk[i][j]~=nil and (type(quest.talk[i][j])~="string" or string.len(quest.talk[i][j])<=0 or string.len(quest.talk[i][j])>row.length) then
								Log_System(string.format("Human Quest: %s's quest: the %d. talk %d. row wrong.(its max length is %d)",npcname,i+1,j+1,row.length));
								ready=false;
							end
						end
					end
				end
			end
		end

		if quest.waittalk==nil then
			Log_System(string.format("Human Quest: %s's quest: the wait talk is wrong.",npcname));
			ready=false;
		else
			if Human_Quest_WrongTalk(quest.waittalk) then
				Log_System(string.format("Human Quest: %s's quest: the wait talk is wrong.",npcname));
				ready=false;
			else
				for i=0, row.number-1 do
					if quest.waittalk[i]~=nil and (type(quest.waittalk[i])~="string" or string.len(quest.waittalk[i])<=0 or string.len(quest.waittalk[i])>row.length) then
						Log_System(string.format("Human Quest: %s's quest: the wait talk %d. row is wrong.(its max length is %d)",npcname,i+1,row.length));
						ready=false;
					end
				end
			end
		end
		
		if quest.repeated==nil and quest.endtalk==nil then
			Log_System(string.format("Human Quest: %s's quest: the end talk is wrong.",npcname));
			ready=false;
		else
			if quest.endtalk~=nil then
				if Human_Quest_WrongTalk(quest.endtalk) then
					Log_System(string.format("Human Quest: %s's quest: the end talk is wrong.",npcname));
					ready=false;
				else
					for i=0, row.number-1 do
						if quest.endtalk[i]~=nil and (type(quest.endtalk[i])~="string" or string.len(quest.endtalk[i])<=0 or string.len(quest.endtalk[i])>row.length) then
							Log_System(string.format("Human Quest: %s's quest: the end talk %d. row wrong.(its max length is %d)",npcname,i+1,row.length));
							ready=false;
						end
					end
				end
			end
		end
		
		if type(quest.questshort)~="string" or string.len(quest.questshort)<=0 or string.len(quest.questshort)>hint.shortlength then
			Log_System(string.format("Human Quest: %s's quest: the quest short length is is wrong.(its max length is %d)",npcname,hint.shortlength));
			ready=false;
		end
		if quest.hint==nil then
			Log_System(string.format("Human Quest: %s's quest: the hint is wrong.",npcname));
			ready=false;
		else
			local nilnumber=0;
			for i=0,hint.number-1 do
				if quest.hint[i]==nil then
					nilnumber=nilnumber+1;
				end
			end
			if nilnumber==hint.number then
				Log_System(string.format("Human Quest: %s's quest: the hint is wrong.",npcname));
				ready=false;
			else
				for i=0, 2 do
					if quest.hint[i]~=nil and (type(quest.hint[i])~="string" or string.len(quest.hint[i])<=0 or string.len(quest.hint[i])>hint.length) then
						Log_System(string.format("Human Quest: %s's quest: the hint %d. row wrong.(its max length is %d)",npcname,i+1,hint.length));
						ready=false;
					end
				end
			end
		end
	end
	return ready;
end

function Human_Quest_WrongTalk(talk)
	local nilnumber=0;
	for i=0,row.number-1 do
		if talk[i]==nil then
			nilnumber=nilnumber+1;
		end
	end
	return nilnumber==row.number;
end