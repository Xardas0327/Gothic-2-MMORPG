
local createname=nil;
local loginname=nil;
local username=nil;
local pwname=nil;

local menu_show=nil;
local menu_refresh=nil;
local menu_hide=nil;

function Account_Menu_Init(show,refresh,hide)
	menu_show=show;
	menu_refresh=refresh;
	menu_hide=hide;
end

function Account_Menu_Show(playerid)
	if menu_show~=nil then
		menu_show(playerid);
	end
end

function Account_Menu_Refresh(playerid)
	if menu_refresh~=nil then
		menu_refresh(playerid);
	end
end

function Account_Menu_Hide(playerid)
	if menu_hide~=nil then
		menu_hide(playerid);
	end
end

function Account_Create_Init_Use(name)
	createname="/"..name;
	Help_AddFunc("account",createname);
end

function Account_Login_Init_Use(name)
	loginname="/"..name;
	Help_AddFunc("account",loginname);
end

function Account_UsernameChange_Init_Use(name)
	username="/"..name;
	Help_AddFunc("account",username);
end

function Account_PasswordChange_Init_Use(name)
	pwname="/"..name;
	Help_AddFunc("character",pwname);
end

function Account_CommandText(playerid, cmdtext)
	if MySQL_Online() then
		local cmd,params = GetCommand(cmdtext);
		local account=Player_GetAccount(playerid);
		
		if not(Player_Is(playerid)) then	
			if cmd==createname then
				Account_Create(playerid,params);
			elseif cmd==loginname then
				Account_Login(playerid,params);
			elseif cmd==username then
				Account_Username_Change(playerid,params);
			elseif cmdtext=="/help" then
				Help_Message(playerid,"account");
			end
		elseif not(GPlayer.IsLoginCharacter(account)) then
			if cmd==pwname then
				Account_Password_Change(playerid,params);
			end
		end
	else
		SendPlayerMessage(playerid,255,255,0,string.format("(Server): Database isn't connected."));
	end
end

function Account_Create(playerid,params)
	local handler=MySQL_Get();
	if handler~=nil then
		local result,pass=sscanf(params,"s");
		if result==1 then	
			local name=GetPlayerName(playerid);
			if string.len(pass)>2 and string.len(pass)<17 and Character_Username_Check(name) then
				local exist = mysql_query(handler,string.format("SELECT `accname` FROM `account` WHERE `accname`=%q",name));
				if exist then
					local acc = mysql_fetch_assoc(exist);
					mysql_free_result(exist);
					if not acc then
						mysql_query(handler,string.format("INSERT INTO `account`(`accname`, `pswd`) VALUES (%q,%q)",name,MD5(pass)));
						SendPlayerMessage(playerid,255,255,0,"(Server): The username is ready.");
					else
						SendPlayerMessage(playerid,255,255,0,"(Server): The username is busy.");
					end
				else
					SendPlayerMessage(playerid,255,255,0,"(Server): Database Error");
				end
			else
				SendPlayerMessage(playerid,255,255,0,"(Server): You use alphanumeric characters (A-Z,a-z,0-9) in username. It's length is 3 to 16.");
				SendPlayerMessage(playerid,255,255,0,"(Server): The password's length is 3 to 16.");
			end
		else
			SendPlayerMessage(playerid,255,255,0,string.format("(Server): use %s (password)",createname));
		end
	else
		SendPlayerMessage(playerid,255,255,0,"(Server): Database Error");
		Log_System("Account: Database lost.");
	end
end

function Account_Login(playerid,params)
	local handler=MySQL_Get();
	if handler~=nil then
		local result,pass=sscanf(params,"s");
		if result==1 then
			local name=GetPlayerName(playerid);
			local exist = mysql_query(handler,string.format("SELECT `accname`, `pswd` FROM `account` WHERE `accname`=%q and `pswd`=%q",name,MD5(pass)));
			if exist  then
				local acc = mysql_fetch_assoc(exist);
				mysql_free_result(exist);
				if acc then
					if Player_IsActiveAccount(name) then
						SendPlayerMessage(playerid,255,255,0,"(Server): The username is active.");
					else
						mysql_query(handler,string.format("UPDATE `account` SET `lastlogin`=CURTIME() WHERE `accname`=%q",name));
						Account_Menu_Hide(playerid);
						Player_LoginAccount(playerid,name);
						Time_Show(playerid);
						Character_Menu_Show(playerid);
						Log_Player(playerid,"Login");
					end
				else
					SendPlayerMessage(playerid,255,255,0,"(Server): The username or the password is wrong.");
				end
			else
				SendPlayerMessage(playerid,255,255,0,"(Server): Database Error.");
			end
		else
			SendPlayerMessage(playerid,255,255,0,string.format("(Server): use %s (password)",loginname));
		end
	else
		SendPlayerMessage(playerid,255,255,0,"(Server): Database Error");
		Log_System("Account: Database lost.");
	end
end

function Account_Username_Change(playerid,params)
	local result,newname=sscanf(params,"s");
	if result==1 then
		if Character_Username_Check(newname) then
			SetPlayerName(playerid,newname);
			Account_Menu_Refresh(playerid);
		else
			SendPlayerMessage(playerid,255,255,0,"(Server): You use alphanumeric characters (A-Z,a-z,0-9) in username. It's length is 3 to 16.");
		end
	else
		SendPlayerMessage(playerid,255,255,0,string.format("(Server): use %s (new username)",username));
	end
end

function Account_Password_Change(playerid,params)
	local handler=MySQL_Get();
	if handler~=nil then
		local result,oldpw,newpw=sscanf(params,"ss");
		if result==1 then
			local account=Player_GetAccount(playerid);
			local name=GPlayer.GetAccountName(account);
			local exist = mysql_query(handler,string.format("SELECT `accname`, `pswd` FROM `account` WHERE `accname`=%q and `pswd`=%q",name,MD5(oldpw)));
			if exist  then
				local acc = mysql_fetch_row(exist);
				mysql_free_result(exist);
				if acc then
					if string.len(newpw)>2 and string.len(newpw)<17 then
						mysql_query(handler,string.format("UPDATE `account` SET `pswd`=%q WHERE `accname`=%q",MD5(newpw),name));
						SendPlayerMessage(playerid,255,255,0,"(Server): Password is changed.");
						Log_Player(playerid,"Password Change");
					else
						SendPlayerMessage(playerid,255,255,0,"(Server): The password's length is 3 to 16.");
					end
				else
					SendPlayerMessage(playerid,255,255,0,"(Server): The password is wrong.");
				end
			else
				SendPlayerMessage(playerid,255,255,0,"(Server): Database Error.");
			end
		else
			SendPlayerMessage(playerid,255,255,0,string.format("(Server): use %s (old password) (new password)",pwname));
		end
	else
		SendPlayerMessage(playerid,255,255,0,"(Server): Database Error");
		Log_System("Account: Database lost.");
	end
end

function Account_Disconnect(playerid, reason)
	Character_Disconnect(playerid);
	Time_Hide(playerid);
	if Player_Is(playerid) then		
		local message="";		
		if reason == 0 then
			message="Disconnected";
		elseif reason == 1 then
			message="Crash or lost.";
		elseif reason == 2 then
			message="Kick";
		elseif reason == 3 then
			message="Ban";
		end
		Log_Player(playerid,message);
		Player_LogoutAccount(playerid);
	else
		Account_Menu_Hide(playerid);
	end
end

function Account_Spawn(playerid)
	if (not Npc_Is(playerid)) then
		FreezePlayer(playerid, 1);
		if (not Player_Is(playerid)) then
			Account_Menu_Show(playerid);
		else
			Character_Respawn(playerid);
		end
	end
end