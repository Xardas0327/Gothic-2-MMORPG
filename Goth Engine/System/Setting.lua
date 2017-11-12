local GothVersion=1.1;
local serverName=nil;


function Setting_SetDescription(text)
	SetServerDescription(text.."\nGothEngine version: "..tostring(GothVersion));
end

function Setting_SetGamemode(text)
	SetGamemodeName(text);
end

function Setting_SetServerName(name)
	serverName=name;
end

function Setting_GetServerName()
	return serverName;
end