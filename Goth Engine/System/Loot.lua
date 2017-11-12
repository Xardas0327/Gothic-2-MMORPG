
local npc={};

function Loot_Init()
	local handler=MySQL_Get();
	if handler~=nil then
		local servername=Setting_GetServerName();
		local loot=mysql_query(handler,string.format("SELECT `npcname`,`itemname`,`number`,`percent` FROM `loot` WHERE `servername`=%q",servername));
		
		if loot then
			for loot,npcloot in mysql_rows_assoc(loot) do
				local name=npcloot['npcname'];
				if npc[name]==nil then
					npc[name]={};
					npc[name].number=0;
					npc[name].loot={};
				end
				npc[name].loot[npc[name].number]={};
				npc[name].loot[npc[name].number].name=npcloot['itemname'];
				npc[name].loot[npc[name].number].number=tonumber(npcloot['number']);
				npc[name].loot[npc[name].number].percent=tonumber(npcloot['percent']);
				npc[name].number=npc[name].number+1;
			end
			
			mysql_free_result(loot);
		else
			Log_System("Loot: Database lost.");
		end
	else
		Log_System("Loot: Database lost.");
	end
end

function Loot_Player(playerid,name)	
	if npc[name]~=nil then
		for j=0, npc[name].number-1 do
			local amount=0;
			local id=Character_Party_RamdomPlayer(playerid);
			for k=0, npc[name].loot[j].number-1 do
				local rand=random(100);
				if rand<npc[name].loot[j].percent then
					amount=amount+1;
				end
			end
			if amount>0 then
				Character_Item_Give(id,npc[name].loot[j].name,amount,true);
			end
		end
	end
end