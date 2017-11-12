
local servername=nil;
local charmax=1;

local createname=nil;
local loginname=nil;
local logoutname=nil;
local deletename=nil;
local listname=nil;

local menu_show=nil;
local menu_refresh=nil;
local menu_hide=nil;

function Character_Init()
	servername=Setting_GetServerName();
	
	Character_Stat_Init();
	Character_Spawn_Init();
	Character_Item_Init();
	Character_Quest_Init();
	Character_Trade_Init();
end

function Character_Menu_Init(show,refresh,hide)
	menu_show=show;
	menu_refresh=refresh;
	menu_hide=hide;
end

function Character_Menu_Show(playerid)
	if menu_show~=nil then
		menu_show(playerid);
	end
end

function Character_Menu_Refresh(playerid)
	if menu_refresh~=nil then
		menu_refresh(playerid);
	end
end

function Character_Menu_Hide(playerid)
	if menu_hide~=nil then
		menu_hide(playerid);
	end
end

function Character_Create_Init_Use(name)
	createname="/"..name;
	Help_AddFunc("character",createname);
end

function Character_Login_Init_Use(name)
	loginname="/"..name;
	Help_AddFunc("character",loginname);
end

function Character_Logout_Init_Use(name)
	logoutname="/"..name;
	Help_AddFunc("play",logoutname);
end

function Character_Delete_Init_Use(name)
	deletename="/"..name;
	Help_AddFunc("character",deletename);
end

function Character_List_Init_Use(name)
	listname="/"..name;
	Help_AddFunc("character",listname);
end

function Character_MaxChar(number)
	if number>0 then
		charmax=number;
	else
		Log_System(string.format("The character's number must be greater then 0, that's why it is %d.",charmax));
	end
end

function Character_CommandText(playerid, cmdtext)
	local account=Player_GetAccount(playerid);
	
	if Player_Is(playerid) then
		local account=Player_GetAccount(playerid);
		
		if not(GPlayer.IsLoginCharacter(account)) then
			local cmd,params = GetCommand(cmdtext);
			if cmd==createname then
				Character_Create(playerid,params);
			elseif cmd==deletename then
				Character_Delete(playerid,params);
			elseif cmd==loginname then
				Character_Login(playerid,params);
			elseif cmdtext==listname then
				Character_List(playerid);
			elseif cmdtext=="/help" then
				Help_Message(playerid,"character");
			end
		else
			if cmdtext==logoutname then
				Character_Logout(playerid);
			elseif cmdtext=="/help" and (not GPlayer.IsBusy(account)) then
				Help_Message(playerid,"play");
			end
		end
	end
	
end

function Characrter_Error(playerid)
	if not(Player_Is(playerid)) then
		SendPlayerMessage(playerid,255,255,0,"(Server): You aren't login in a account.");
	else
		SendPlayerMessage(playerid,255,255,0,"(Server): You logout from the character.");
	end
end

function Character_Create(playerid,params,body_type,body_id,face_type,face_id,fatness)
	local handler=MySQL_Get();
	if handler~=nil then
		local account=Player_GetAccount(playerid);
		if Player_Is(playerid) and not(GPlayer.IsLoginCharacter(account)) then
			local result,newcharname=sscanf(params,"s");
			if result==1 then
				if Character_Username_Check(newcharname)	then
					local t=mysql_query(handler,string.format("SELECT * FROM `characters` WHERE `servername`=%q AND `charname`=%q",servername,newcharname));
					if t then
						local exist= mysql_fetch_assoc(t);
						mysql_free_result(t);
						if not exist then
							local accountName=GPlayer.GetAccountName(account);
							local characters = mysql_query(handler,string.format("SELECT `charid` FROM `characters` WHERE `servername`=%q AND `accname`=%q",servername,accountName));
							if characters then
								local number=mysql_num_rows(characters);
								if number<charmax then
									newcharname=string.lower(newcharname);
									newcharname=string.gsub(newcharname,"^%l", string.upper);
									
									if(body_type==nil or body_id==nil or face_type==nil or face_id==nil or fatness==nil) then
										local default_body=Character_Body_Default();
										body_type=default_body["body_type"];
										body_id=default_body["body_id"];
										face_type=default_body["face_type"];
										face_id=default_body["face_id"];
										fatness=default_body["fatness"];
									end
									
									Log_Player(playerid,string.format("New Character: %s %s %d %s %d %.1f",newcharname,body_type,body_id,face_type,face_id,fatness));
									number=number+1;
									mysql_query(handler,string.format("INSERT INTO `characters`(`accname`,`charname`,`body_type`,`body_id`,`face_type`,`face_id`,`fatness`,`servername`,`charid`) VALUES (%q,%q,%q,%d,%q,%d,%.1f,%q,%d)",accountName,newcharname,body_type,body_id,face_type,face_id,fatness,servername,number));
									Character_Stat_Create(newcharname);
									Character_Item_Create(newcharname);
									Character_Quest_Create(newcharname);
									Character_Menu_Refresh(playerid);
								else
									SendPlayerMessage(playerid,255,255,0,string.format("(Server): The character's number is max (%d).",charmax));
								end
							else
								SendPlayerMessage(playerid,255,255,0,"(Server): Database Error.");
							end				
						else
							SendPlayerMessage(playerid,255,255,0,"(Server): The character's name is busy.");
						end
					else
						SendPlayerMessage(playerid,255,255,0,"(Server): Database Error.");
					end
				else
					SendPlayerMessage(playerid,255,255,0,"(Server): You use alphanumeric characters (A-Z,a-z,0-9) in character name. It's length is 3 to 16.");
				end
			else
				SendPlayerMessage(playerid,255,255,0,string.format("(Server): use %s (new character name)",createname));
			end
		else
			Characrter_Error(playerid);
		end
	else
		SendPlayerMessage(playerid,255,255,0,"(Server): Database Error.");
		Log_System("Character: Database lost.");
	end
end

function Character_Delete(playerid,params)
	local handler=MySQL_Get();
	if handler~=nil then
		local account=Player_GetAccount(playerid);
		if Player_Is(playerid) and not(GPlayer.IsLoginCharacter(account)) then
			local result,charname=sscanf(params,"s");
			if result==1 then
				local accountName=GPlayer.GetAccountName(account);
				local character=mysql_query(handler, string.format("SELECT `charname`, `charid` FROM characters WHERE `accname`=%q AND `servername`=%q AND `charname`=%q",accountName,servername,charname));
				if character then
					local charname=mysql_fetch_assoc(character);
					mysql_free_result(character);
					if charname then
						Log_Player(playerid,string.format("Delete Character: %s",charname['charname']));
						mysql_query(handler, string.format("UPDATE `characters` SET `charid`=`charid`-1 WHERE `accname`=%q AND `servername`=%q AND `charid`>%d",accountName,servername,tonumber(charname['charid'])));
						Character_Stat_Delete(charname['charname']);
						Character_Spawn_Delete(charname['charname']);
						Character_Item_Delete(charname['charname']);
						Character_Quest_Delete(charname['charname'])
						mysql_query(handler, string.format("DELETE FROM `characters` WHERE `charname`=%q AND `servername`=%q;",charname['charname'],servername));
						Character_Menu_Refresh(playerid);
					else
						SendPlayerMessage(playerid,255,255,0,"(Server): The character lost (Database Error) or doesn't your.");
					end
				else
					SendPlayerMessage(playerid,255,255,0,"(Server): Database Error.");
				end
			else
				SendPlayerMessage(playerid,255,255,0,string.format("(Server): use %s (character name)",deletename));
			end
		else
			Characrter_Error(playerid);
		end
	else
		SendPlayerMessage(playerid,255,255,0,"(Server): Database Error.");
		Log_System("Character: Database lost.");
	end
end

function Character_Start(playerid,name,waittime)
	local handler=MySQL_Get();
	if handler~=nil then
		local account=Player_GetAccount(playerid);
		GPlayer.LoginCharacter(account,name);
		
		local character=mysql_query(handler,string.format("SELECT `body_type`,`body_id`,`face_type`,`face_id`,`fatness` FROM `characters` WHERE `servername`=%q AND `accname`=%q AND `charname`=%q",servername,GPlayer.GetAccountName(account),name));
		if character then
			body = mysql_fetch_assoc(character);
			mysql_free_result(character);
			if body then
				SetPlayerAdditionalVisual(playerid,body['body_type'],tonumber(body['body_id']),body['face_type'],tonumber(body['face_id']));
				SetPlayerFatness(playerid,tonumber(body['fatness']));
				SetTimerEx("Character_Load",waittime,0,playerid);
			else
				SendPlayerMessage(playerid,255,255,0,"The character lost (Database Error) or doesn't your.");
			end
		else
			SendPlayerMessage(playerid,255,255,0,"(Server): Database Error.");
		end
	end
end

function Character_Load(playerid)
	local account=Player_GetAccount(playerid);
	if Player_Is(playerid) and GPlayer.IsLoginCharacter(account) then
		local character=GPlayer.GetCharacter(account);
		local characterName=GCharacter.GetName(character);
		
		local stat=Character_Stat_Load(playerid,characterName);
		local item=Character_Item_Load(playerid,characterName);
		local spawn=Character_Spawn(playerid,characterName);
		local quest=Character_Quest_Load(playerid);
		
		local ready=stat and item and spawn and quest;
	
		if ready then
			FreezePlayer(playerid, 0);
			GPlayer.SetDead(account,false);
		else
			if stat then
				Character_Stat_Logout(playerid);
			end
			
			if item then
				Character_Item_Logout(playerid);
			end
			
			if spawn then
				Character_Spawn_Logout(playerid);
			end
			
			if quest then
				Character_Quest_Logout(playerid);
			end
			
			Character_Logout(playerid);
		end
	end
end

function Character_Login(playerid,params)
	local handler=MySQL_Get();
	if handler~=nil then
		local account=Player_GetAccount(playerid);
		if Player_Is(playerid) and not(GPlayer.IsLoginCharacter(account)) then
			local result,charname=sscanf(params,"s");
			if result==1 then
				local character=mysql_query(handler,string.format("SELECT `charname`,`body_type`,`body_id`,`face_type`,`face_id`,`fatness` FROM `characters` WHERE `servername`=%q AND `accname`=%q AND `charname`=%q",servername,GPlayer.GetAccountName(account),charname));
				if character then
					charname = mysql_fetch_assoc(character);
					mysql_free_result(character);
					if charname then
						Character_Start(playerid,charname['charname'],0);
						Log_Player(playerid,"Login");
						mysql_query(handler,string.format("UPDATE `characters` SET `lastlogin`=CURTIME() WHERE `charname`=%q AND `servername`=%q",charname['charname'],servername));
					else
						SendPlayerMessage(playerid,255,255,0,"The character lost (Database Error) or doesn't your.");
					end
				else
					SendPlayerMessage(playerid,255,255,0,"(Server): Database Error.");
				end
			else
				SendPlayerMessage(playerid,255,255,0,string.format("(Server): use %s (character name)",loginname));
			end
		else
			Characrter_Error(playerid);
		end
	else
		SendPlayerMessage(playerid,255,255,0,"(Server): Database Error.");
		Log_System("Character: Database lost.");
	end
end

function Character_List(playerid)
	local handler=MySQL_Get();
	if handler~=nil then
		local account=Player_GetAccount(playerid);
		if Player_Is(playerid) and not(GPlayer.IsLoginCharacter(account)) then
			local characters=mysql_query(handler,string.format("SELECT `charname` FROM `characters` WHERE `servername`=%q AND `accname`=%q ORDER BY `charid`",servername,GPlayer.GetAccountName(account)));
			if characters then
				local number=0;
				local charname={};
				for characters,character in mysql_rows_assoc(characters) do
					charname[number]=character['charname'];
					number=number+1;
				end
				mysql_free_result(characters);
				
				if listname~=nil then
					if number==0 then
						SendPlayerMessage(playerid,255,255,0,"You don't have character.");
					else
						local message="Your characters: ";
						for i=0, charname.number-1 do
							message=message..charname[i]..", ";
						end
						SendPlayerMessage(playerid,255,255,0,message);
					end
				end
				
				return number,charname;
			else
				SendPlayerMessage(playerid,255,255,0,"(Server): Database Error.");
			end
		else
			Characrter_Error(playerid);
		end
	else
		SendPlayerMessage(playerid,255,255,0,"(Server): Database Error.");
		Log_System("Character: Database lost.");
	end
	return nil;
end

function Character_Logout(playerid)
	local account=Player_GetAccount(playerid);
	if GPlayer.IsLoginCharacter(account) then
		Character_Disconnect(playerid);
		
		local default_body=Character_Body_Default();
		SetPlayerAdditionalVisual(playerid,default_body["body_type"],default_body["body_id"],default_body["face_type"],default_body["face_id"]);
		SetPlayerFatness(playerid,default_body["fatness"]);
		
		GPlayer.LogoutCharacter(account);
		FreezePlayer(playerid, 1);
		PlayAnimation(playerid,"S_FISTRUN");
		
		Character_Menu_Show(playerid);
	else
		SendPlayerMessage(playerid,255,255,0,"(Server): You aren't login in a character.");
	end
end

function Character_Disconnect(playerid)
	if Player_Is(playerid) then
		local account=Player_GetAccount(playerid);
		if GPlayer.IsLoginCharacter(account) then
			Human_Logout(playerid);
			
			Character_Party_Logout(playerid);
			Character_Stat_Logout(playerid);
			Character_Spawn_Logout(playerid);
			Character_Item_Logout(playerid);
			Character_Quest_Logout(playerid);
			Log_Player(playerid,"Logout");
		else
			Character_Menu_Hide(playerid);
		end
	end
end

function Character_Respawn(playerid)
	if Player_Is(playerid) then
		FreezePlayer(playerid, 1)
		local account=Player_GetAccount(playerid);
		if (not GPlayer.IsLoginCharacter(account)) then
			GPlayer.SetBusy(account,true);
			Character_Menu_Show(playerid);
		else
			local character=GPlayer.GetCharacter(account);
			local characterName=GCharacter.GetName(character);
			Character_Start(playerid,characterName,1500);
		end
	end
end

function Character_Death(playerid)
	if Player_Is(playerid) then
		local account=Player_GetAccount(playerid);
		GPlayer.SetDead(account,true);
		Character_Item_Dead(playerid);
		Character_Spawn_Dead(playerid);
		Character_Stat_Dead(playerid);
		
		Respawn_Show(playerid);
	end
end

function Character_Username_Check(name)
	if string.len(name)>2 and string.len(name)<17 then
		if string.gsub(name, "%w", "")=="" then
			return true;
		end
	end
	return false;
end