
local handler={};
handler.online=false;
local timer=nil;

function MySQL_Init(ip,user,password,database)
	handler.MySQL=mysql_connect(ip,user,password,database);
	
	if handler.MySQL==nil or not(mysql_ping(handler.MySQL)) then
		if  handler.MySQL~=nil then
			mysql_close(handler[i].MySQL);
		end
		Log_System(string.format("Database: %s is not connected.",database));
	else
		handler.online=true;
		handler.ip=ip;
		handler.user=user;
		handler.password=password;
		handler.database=database;
		timer= SetTimer("MySQL_Check",1000,1);
	end
end

function MySQL_Check()
	if not(mysql_ping(handler.MySQL)) then
		mysql_close(handler.MySQL);
		handler.MySQL= mysql_connect(handler.ip,handler.user, handler.password, handler.database);
		
		if handler.MySQL==nil then
			SendMessageToAll(255,255,0,string.format("(Server): Database isn't connected."));
			SendMessageToAll(255,255,0,string.format("   Please leave the game and try again later."));
			Log_System(string.format("Database: %s database lost.",handler.database));
			for i = 0, GetMaxPlayers()-1 do
				if Player_Is(i) then
					Kick(i);
				end
			end
			handler.online=false;
			if IsTimerActive(timer) then
				KillTimer(timer);
			end
			timer = SetTimerEx("MySQL_Reconnect",1000,1);
		end
	end
end

function MySQL_Reconnect()
	handler.MySQL= mysql_connect(handler.ip,handler.user, handler.password, handler.database);
	if handler.MySQL~=nil then
		handler.online=true;
		if IsTimerActive(timer) then
			KillTimer(timer);
		end
		timer= SetTimer("MySQL_Check",1000,1);
		Log_System(string.format("Database: %s database online again.",handler.database));
		SendMessageToAll(255,255,0,string.format("(Server): Database is online."));
	end
end

function MySQL_Get()
	if handler.online then
		return handler.MySQL;
	end
	
	return nil;
end

function MySQL_Online()
	return handler.online;
end