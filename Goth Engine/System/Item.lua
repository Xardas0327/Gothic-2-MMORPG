
local item={};

function Item_Init()
	local handler=MySQL_Get();
	if handler~=nil then
		local items=mysql_query(handler,"SELECT `name`,`value`,`respawn` FROM `items`");
		
		if items then
			for items,it in mysql_rows_assoc(items) do
				item[it['name']]={};
				item[it['name']].name=Item_Name_Cut(it['name']);
				item[it['name']].value=tonumber(it['value']);
				item[it['name']].respawn=tonumber(it['respawn']);		
			end
			mysql_free_result(items);
		else
			Log_System("Item: Database lost.");
		end
	else
		Log_System("Item: Database lost.");
	end
end

function Item_Name_Cut(name)
	local begin=string.find(name, "_ADDON_");
	local ennd=nil;
	
	if begin~=nil then
		name=string.gsub(name, "_ADDON_", "_");
	end
	begin,ennd=string.find(name, "_ADDON");
	if begin~=nil and ennd==string.len(name) then
		name=string.gsub(name, "_ADDON", "");
	end
	
	local begin=string.find(name, "_MIS");
	if begin~=nil then
		name=string.gsub(name, "_MIS", "");
	end
	
	begin,ennd=string.find(name, "_MISSION");
	if begin~=nil and ennd==string.len(name) then
		name=string.gsub(name, "_MISSION", "");
	end
	
	return name;
end

function Item_Name(index)
	return item[string.upper(index)].name;
end

function Item_Value(index)
	return item[string.upper(index)].value;
end

function Item_Respawn(index)
	return item[string.upper(index)].respawn;
end

function Item_Exist(index)
	return item[string.upper(index)]~=nil;
end