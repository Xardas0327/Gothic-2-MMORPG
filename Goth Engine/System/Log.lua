
function Log_Account_Path(name)
	local path=string.format("%s\\Player\\%s",Log_System_Path(),name);
	os.execute( string.format("mkdir %s",path));
	
	return path;
end
function Log_System_Path()
	local path=string.format("Log\\%s\\%s\\%s",os.date("%Y"),os.date("%m"),os.date("%d"));
	os.execute( string.format("mkdir %s",path));
	
	return path;
end

function Log_Player(playerid,message)
	if Player_Is(playerid) then
		local account=Player_GetAccount(playerid);
		local path=Log_Account_Path(GPlayer.GetAccountName(account));
		
		if GPlayer.IsLoginCharacter(account) then
			local character=GPlayer.GetCharacter(account);
			LogString(string.format("%s\\%s",path,GCharacter.GetName(character)),message);
		else
			LogString(string.format("%s\\Account",path),message);
		end
	end
end

function Log_System(message)
	local path=Log_System_Path();
	LogString(string.format("%s\\system",path),message);
end

function Log_Debug(message)
	local path=Log_System_Path();
	LogString(string.format("%s\\debug",path),message);
end

function Log_Admin(filename,message)
	LogString(string.format("Log\\%s",filename),message);
end