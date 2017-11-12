
local help={};

function Help_Connect(playerid)
	if  MySQL_Online() then
		SendPlayerMessage(playerid,255,255,0,"Firstly: Press SHIFT (and wait a moment)");
		SendPlayerMessage(playerid,255,255,0,"The graphic setting: F1-F4.");
		SendPlayerMessage(playerid,255,255,0,"This is english keyboard system.");
		SendPlayerMessage(playerid,255,255,0,"If you should help, you write /help (Press T for the chat).");
	else
		SendPlayerMessage(playerid,255,255,0,string.format("(Server): Database isn't connected."));
		SendPlayerMessage(playerid,255,255,0,string.format("   Please leave the game and try again later."));
	end
end

function Help_New(newtype)
	if help[newtype]==nil then
		help[newtype]={};
		help[newtype].hnumber=0;
		help[newtype].help={};
		help[newtype].fnumber=0;
		help[newtype].func={};
		help[newtype].func[0]="Commands: "
	end
end

function Help_AddHelp(helptype,message)
	Help_New(helptype);
	if Help_MessageLength(message) then
		help[helptype].help[help[helptype].hnumber]=message;
		help[helptype].hnumber=help[helptype].hnumber+1;
	else
		Log_System("Player Help: This message length is more 60 characters: "..message);
	end
end

function Help_AddFunc(helptype,func)
	Help_New(helptype);
	if help[helptype].fnumber==0 then
		help[helptype].func[0]=help[helptype].func[0]..func;
		help[helptype].fnumber=help[helptype].fnumber+1;
	else
		if Help_MessageLength(help[helptype].func[help[helptype].fnumber-1]) then
			help[helptype].func[help[helptype].fnumber-1]=help[helptype].func[help[helptype].fnumber-1].." "..func;
		else
			help[helptype].func[help[helptype].fnumber]=" ";
			help[helptype].func[help[helptype].fnumber]=help[helptype].func[help[helptype].fnumber].." "..func;
			help[helptype].fnumber=help[helptype].fnumber+1;
		end
	end
end

function Help_Message(playerid,helptype)
	if help[helptype]~=nil then
		for i=0,help[helptype].fnumber-1 do
			SendPlayerMessage(playerid,255,255,0,"(Server): "..help[helptype].func[i]);
		end
		for i=0,help[helptype].hnumber-1 do
			SendPlayerMessage(playerid,255,255,0,"(Server): "..help[helptype].help[i]);
		end
	end
end

function Help_MessageLength(message)
	if string.len(message)>60 then
		return false;
	end
	return true;
end