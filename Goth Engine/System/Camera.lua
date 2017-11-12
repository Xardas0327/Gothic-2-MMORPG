local camera={};

function Camera_OppositePlayer(playerid,distance, x, y, z, angle)
	Camera_Destroy(playerid);
	
	if x==nil or y==nil or z==nil or angle==nil then
		x, y, z = GetPlayerPos(playerid);
		angle = GetPlayerAngle(playerid);
	end
	
	x = x + (math.sin(angle * 3.14 / 180.0) * distance);
	z = z + (math.cos(angle * 3.14 / 180.0) * distance);
	
	camera[playerid] = Vob.Create("", GetPlayerWorld(playerid), x, y, z);
	camera[playerid]:SetRotation(0, angle + 180, 0);
	SetCameraBehindVob(playerid,camera[playerid]);
end

function Camera_Default(playerid)
	Camera_Destroy(playerid);	
	SetDefaultCamera(playerid);
end

function Camera_Destroy(playerid)
	if camera[playerid]~=nil then
		camera[playerid]:Destroy();
		camera[playerid]=nil;
	end
end