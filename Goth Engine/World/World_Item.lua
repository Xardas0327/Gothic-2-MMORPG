
local world_items={};
local respawn={};

function World_Item_Init()
	local handler=MySQL_Get();
	if handler~=nil then
		local servername=Setting_GetServerName();
		local items=mysql_query(handler,string.format("SELECT `itemname`,`number`,`x`,`y`,`z` FROM `world_items` WHERE `servername`=%q",servername));
		if items then
			local i=0;
			for items,item in mysql_rows_assoc(items) do
				local name=item['itemname'];
				if world_items[name]==nil then
					world_items[name]={};
				end
				local id	=item['x']..'-'..item['y']..'-'..item['z'];
				local piece	=tonumber(item['number']);
				local x		=tonumber(item['x']);
				local y		=tonumber(item['y']);
				local z		=tonumber(item['z']);
				
				world_items[name][id]={};
				world_items[name][id].piece=piece;
				world_items[name][id].x=x;
				world_items[name][id].y=y;
				world_items[name][id].z=z;
				
				CreateItem(name,piece,x,y,z,"NEWWORLD\\NEWWORLD.ZEN");
				i=i+1;
			end
			Log_System(string.format("World Item: %d",i));
			
			Respawn_AddText(string.format("You can find %d items on this world.",i),1500,"Font_Old_20_White_Hi.TGA");
			
			mysql_free_result(items);
		else
			Log_System("World Item: Database lost.");
		end
	else
		Log_System("World Item: Database lost.");
	end
end

function World_Item_Take(itemid,item_instance, x, y, z)
	if itemid>=0 and world_items[item_instance]~=nil then
		local id=tostring(x)..'-'..tostring(y)..'-'..tostring(z);
		if world_items[item_instance][id]~=nil then
			local j=0;
			while respawn[j]~=nil do
				j=j+1;
			end
			respawn[j]=world_items[item_instance][id];
			respawn[j].name=item_instance;
			SetTimerEx("World_Item_Spawn",Item_Respawn(item_instance)*60*1000,0,j);
		end
	end
end

function World_Item_Spawn(id)
	CreateItem(respawn[id].name,respawn[id].piece,respawn[id].x,respawn[id].y,respawn[id].z,"NEWWORLD\\NEWWORLD.ZEN");
	respawn[id]=nil;
end