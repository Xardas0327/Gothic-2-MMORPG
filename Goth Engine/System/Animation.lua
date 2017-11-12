
local helpname=nil;
local sitname=nil;
local sleepname=nil;
local peename=nil;
local trainohname=nil;
local inspectohname=nil;
local prayname=nil;
local searchname=nil;
local plundername=nil;
local guardoname=nil;
local guardtname=nil;

function Animation_Help_Init_Use(name)
	helpname="/"..name;
	Help_AddFunc("play",helpname);
end

function Animation_Sit_Init_Use(name)
	sitname="/"..name;
end

function Animation_Sleep_Init_Use(name)
	sleepname="/"..name;
end

function Animation_Pee_Init_Use(name)
	peename="/"..name;
end

function Animation_Trainoh_Init_Use(name)
	trainohname="/"..name;
end

function Animation_Inspectoh_Init_Use(name)
	inspectohname="/"..name;
end

function Animation_Pray_Init_Use(name)
	prayname="/"..name;
end

function Animation_Search_Init_Use(name)
	searchname="/"..name;
end

function Animation_Plunder_Init_Use(name)
	plundername="/"..name;
end

function Animation_Guardo_Init_Use(name)
	guardoname="/"..name;
end

function Animation_Guardt_Init_Use(name)
	guardtname="/"..name;
end

function Animation_CommandText(playerid, cmdtext)
	local account=Player_GetAccount(playerid);
	
	if Player_Is(playerid) and GPlayer.IsLoginCharacter(account) and not(GPlayer.IsBusy(account)) then
		if cmdtext==helpname then
			Animation_Help(playerid);
		elseif cmdtext==sitname then
			PlayAnimation(playerid,"T_STAND_2_SIT");			
		elseif cmdtext==sleepname then
			PlayAnimation(playerid,"T_STAND_2_SLEEPGROUND");
		elseif cmdtext==peename then
			PlayAnimation(playerid,"T_STAND_2_PEE");
		elseif cmdtext==trainohname then
			PlayAnimation(playerid,"T_1HSFREE");
		elseif cmdtext==inspectohname then
			PlayAnimation(playerid,"T_1HSINSPECT");			
		elseif cmdtext==prayname then
			PlayAnimation(playerid,"S_PRAY");
		elseif cmdtext==searchname then
			PlayAnimation(playerid,"T_SEARCH");
		elseif cmdtext==plundername then
			PlayAnimation(playerid,"T_PLUNDER");		
		elseif cmdtext==guardoname then
			PlayAnimation(playerid,"S_LGUARD");
		elseif cmdtext==guardtname then
			PlayAnimation(playerid,"S_HGUARD");
		end
	end
end

function Animation_Help(playerid)
	local message="Animation:";
	local message2="	";
	
	if sitname~=nil then
		message=message.." "..sitname
	end
	
	if sleepname~=nil then
		message=message.." "..sleepname
	end
	
	if peename~=nil then
		message=message.." "..peename
	end
	
	if trainohname~=nil then
		message=message.." "..trainohname
	end
	
	if inspectohname~=nil then
		message=message.." "..inspectohname
	end
	
	if prayname~=nil then
		message=message.." "..prayname
	end
	
	if searchname~=nil then
		if string.len(message)<60 then
			message=message.." "..searchname
		else
			message2=message2.." "..searchname
		end
	end
	
	if plundername~=nil then
		if string.len(message)<60 then
			message=message.." "..plundername
		else
			message2=message2.." "..plundername
		end
	end
	
	if guardoname~=nil then
		if string.len(message)<60 then
			message=message.." "..guardoname
		else
			message2=message2.." "..guardoname
		end
	end
	
	if guardtname~=nil then
		if string.len(message)<60 then
			message=message.." "..guardtname
		else
			message2=message2.." "..guardtname
		end
	end
	
	if message=="Animation:" then
		message="Animation isn't."
	end
	
	SendPlayerMessage(playerid,255,255,0,string.format("(Server): %s",message));
	if string.len(message)>=60 then
		SendPlayerMessage(playerid,255,255,0,message2);
	end
	SendPlayerMessage(playerid,255,255,0,"(Server): If you want to abort the animations, you move left or right.");
end