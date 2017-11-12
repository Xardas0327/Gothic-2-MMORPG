
local servername=nil;

local checkarrow=1000;
local checkfirearrow=1001;
local checkmagicarrow=1002;
local checkbolt=1003;
local checkmagicbolt=1004;

local player={};
for i = 0, GetMaxPlayers() - 1 do
	player[i]={};
	player[i].giveitem=false;
	player[i].giveGold=false;
	player[i].hasarrow=nil;
	
end

function Character_Item_Init()
	servername=Setting_GetServerName();
	EnableDropAfterDeath(0);
	Character_Trade_Func(Character_Item_Give,Character_Item_Remove);
	Character_Quest_HasItemFunc(Character_Item_Has);
	Human_Quest_ItemFunc(Character_Item_Give,Character_Item_Remove);
end

function Character_Item_Create(name)
	local handler=MySQL_Get();
	if handler~=nil then
		mysql_query(handler,string.format("CREATE TABLE `%s_%s_item`(`itemid` VARCHAR(50) PRIMARY KEY, `amount` INT NOT NULL, `equipped` INT default 0)",servername,name));
	else
		Log_System("Character Item: Database lost.");
	end
end

function Character_Item_Delete(name)
	local handler=MySQL_Get();
	if handler~=nil then
		mysql_query(handler,string.format("DROP TABLE `%s_%s_item`",servername,name));
	else
		Log_System("Character Item: Database lost.");
	end
end

function Character_Item_Load(playerid,name)
	local handler=MySQL_Get();
	if handler~=nil then
		player[playerid].giveitem=false;
		local items = mysql_query(handler, string.format("SELECT `itemid`,`amount`,`equipped` FROM `%s_%s_item`",servername,name));
		if items then
			ClearInventory(playerid);
			for items,item in mysql_rows_assoc(items) do
				local equipped=tonumber(item['equipped']);
				if equipped==0 then
					Character_Item_Give(playerid, item['itemid'], tonumber(item['amount']));
				elseif equipped==1 then
					EquipItem(playerid, item['itemid']);
					Character_Item_Give(playerid, item['itemid'], tonumber(item['amount'])-1);
				end
			end
			mysql_free_result(items);
			player[playerid].giveitem=true;
			player[playerid].giveGold=false;
			player[playerid].hasarrow=SetTimerEx("Character_Item_HasArrow",1000,1,playerid);
			
			return true;
		else
			SendPlayerMessage(playerid,255,255,0,"(Server): Database Error. The character's items lost.");
		end
	else
		SendPlayerMessage(playerid,255,255,0,"(Server): Database Error.");
		Log_System("Character Item: Database lost.");
	end
	return false;
end

function Character_Item_Give(playerid,item_instance,amount,show)
	if show==nil then
		show=false;
	end
	
	if item_instance=="ITMI_GOLD" then
		local account=Player_GetAccount(playerid);
		local character=GPlayer.GetCharacter(account);
		
		local gold=GCharacter.GetGold(character);
		GCharacter.SetGold(character,gold+amount);
		
		if player[playerid].giveitem then
			player[playerid].giveGold=true;
		end
	end
	
	GiveItem(playerid, item_instance, amount);
	if show then
		SendPlayerMessage(playerid,192,192,192,string.format("%s %d",item_instance,amount));
	end
end

function Character_Item_Take(playerid, item_instance, amount, unsin)
	local handler=MySQL_Get();
	if handler~=nil then
		local account=Player_GetAccount(playerid);
		
		if GPlayer.IsLoginCharacter(account) and player[playerid].giveitem and not(unsin==-1 or unsin==-3) then
			Character_Quest_Take(playerid, item_instance, amount);
			
			local character=GPlayer.GetCharacter(account);
			local name=GCharacter.GetName(character);
			
			local result = mysql_query(handler, string.format("SELECT `itemid` FROM `%s_%s_item` WHERE `itemid`=%q",servername,name,item_instance));
			if result then		
				local item = mysql_fetch_assoc(result);
				mysql_free_result(result);
				if (not item) then
					Log_Player(playerid,string.format("Take item: %s %d",item_instance,amount));
					mysql_query(handler,string.format("INSERT INTO `%s_%s_item`(`itemid`,`amount`) VALUES (%q,%d)",servername,name,item_instance,amount));
				else
					Log_Player(playerid,string.format("Item: %s +%d",item_instance,amount));
					mysql_query(handler,string.format("UPDATE `%s_%s_item` SET `amount`=`amount`+%d WHERE `itemid`=%q",servername,name,amount,item_instance));
				end
				
				if item_instance=="ITMI_GOLD" then
					if player[playerid].giveGold then
						player[playerid].giveGold=false;
					else
						local gold=GCharacter.GetGold(character);
					
						GCharacter.SetGold(character,gold+amount);
					end
				end
			else
				SendPlayerMessage(playerid,255,255,0,"(Server): Database Error.");
			end
		end
	else
		SendPlayerMessage(playerid,255,255,0,"(Server): Database Error.");
		Log_System("Character Item: Database lost.");
	end
end

function Character_Item_Drop(playerid, item_instance, amount)
	Character_Item_Remove_Database(playerid, item_instance, amount);
end

function Character_Item_Remove(playerid, item_instance, amount)
	Character_Item_Remove_Database(playerid, item_instance, amount);
	RemoveItem(playerid, item_instance, amount);
end

function Character_Item_Remove_Database(playerid, item_instance, amount)
	local handler=MySQL_Get();
	if handler~=nil then
		local account=Player_GetAccount(playerid);
		
		if GPlayer.IsLoginCharacter(account) then
			Character_Quest_Drop(playerid, item_instance, amount);
			
			local character=GPlayer.GetCharacter(account);
			local name=GCharacter.GetName(character);
			
			local oldamount = mysql_query(handler, string.format("SELECT `amount` FROM `%s_%s_item` WHERE `itemid`=%q",servername,name,item_instance));
			if oldamount then
				oldamount = mysql_fetch_assoc(oldamount);	
				if oldamount then
					oldamount=tonumber(oldamount['amount']);
					if oldamount>amount then
						Log_Player(playerid,string.format("Item: %s -%d",item_instance,amount));
						mysql_query(handler,string.format("UPDATE `%s_%s_item` SET `amount`=`amount`-%d WHERE `itemid`=%q",servername,name,amount,item_instance));
					else
						Log_Player(playerid,string.format("Drop item: %s %d",item_instance,amount));
						mysql_query(handler,string.format("DELETE FROM `%s_%s_item` WHERE `itemid`=%q",servername,name,item_instance));
					end
					
					if item_instance=="ITMI_GOLD" then					
						local gold=GCharacter.GetGold(character);
						
						GCharacter.SetGold(character,gold-amount);
					end
				end
			else
				SendPlayerMessage(playerid,255,255,0,"(Server): Database Error.");
			end
		end
	else
		SendPlayerMessage(playerid,255,255,0,"(Server): Database Error.");
		Log_System("Character Item: Database lost.");
	end
end

function Character_Item_Use(playerid, item_instance, amount)
	if Player_Is(playerid) and item_instance~=nil and amount~=nil then
		Character_Item_Drop(playerid, item_instance, amount);
	end
end

function Character_Item_Cast(playerid, item_instance)
	if Player_Is(playerid) then
		local itemtype=string.sub(item_instance,1,4);
		if itemtype=="ITSC" then
			Character_Item_Drop(playerid, item_instance, 1);
		end
	end
end

function Character_Item_SpellSetup(playerid, spellInstance)
	local handler=MySQL_Get();
	if handler~=nil then
		local account=Player_GetAccount(playerid);
		if GPlayer.IsLoginCharacter(account) then
			local character=GPlayer.GetCharacter(account);
			local name=GCharacter.GetName(character);
			
			if spellInstance~="NULL" then
				mysql_query(handler,string.format("UPDATE `%s_%s_item` SET `equipped`=1 WHERE `itemid`=%q",servername,name,spellInstance));
			else
				mysql_query(handler,string.format("UPDATE `%s_%s_item` SET `equipped`=0 WHERE `itemid` LIKE %q OR `itemid` LIKE %q",servername,name,"ITSC%","ITRU%"));
			end
		end
	else
		SendPlayerMessage(playerid,255,255,0,"(Server): Database Error.");
		Log_System("Character Item: Database lost.");
	end
end

function  Character_Item_UnequipWeapons(playerid)
	local handler=MySQL_Get();
	if handler~=nil then
		local account=Player_GetAccount(playerid);
		
		if Player_Is(playerid) and GPlayer.IsLoginCharacter(account) then
			local character=GPlayer.GetCharacter(account);
			local name=GCharacter.GetName(character);
			
			mysql_query(handler,string.format("UPDATE `%s_%s_item` SET `equipped`=0 WHERE `itemid` LIKE %q OR `itemid` LIKE %q",servername,name,"ITMW%","ITRW%"));
			UnequipMeleeWeapon(playerid);
			UnequipRangedWeapon(playerid);
		end
	else
		SendPlayerMessage(playerid,255,255,0,"(Server): Database Error.");
		Log_System("Character Item: Database lost.");
	end
end

function  Character_Item_EquippedItem(playerid, currItem, oldItem)
	local handler=MySQL_Get();
	if handler~=nil then
		local account=Player_GetAccount(playerid);
		if Player_Is(playerid) and GPlayer.IsLoginCharacter(account) and (not GPlayer.IsDead(account)) then
			local character=GPlayer.GetCharacter(account);
			local name=GCharacter.GetName(character);
			
			if oldItem~="NULL" then
				mysql_query(handler,string.format("UPDATE `%s_%s_item` SET `equipped`=0 WHERE `itemid`=%q",servername,name,oldItem));
			end
			
			if currItem~="NULL" then
				mysql_query(handler,string.format("UPDATE `%s_%s_item` SET `equipped`=1 WHERE `itemid`=%q",servername,name,currItem));
			end
		end
	else
		SendPlayerMessage(playerid,255,255,0,"(Server): Database Error.");
		Log_System("Character Item: Database lost.");
	end
end

function Character_Item_Has(playerid,item)
	local handler=MySQL_Get();
	if handler~=nil then
		local account=Player_GetAccount(playerid);
		local character=GPlayer.GetCharacter(account);
		local name=GCharacter.GetName(character);
		
		local query = mysql_query(handler, string.format("SELECT `amount` FROM `%s_%s_item` WHERE `itemid`=%q",servername,name,item));
		if query then
			local item = mysql_fetch_assoc(query);
			mysql_free_result(query);
			
			if item then
				return tonumber(item['amount']);
			end
		else
			SendPlayerMessage(playerid,255,255,0,"(Server): Database Error. The character's items lost.");
		end
	else
		SendPlayerMessage(playerid,255,255,0,"(Server): Database Error.");
		Log_System("Character Item: Database lost.");
	end
	
	return 0;
end

function Character_Item_HasArrow(playerid)
	HasItem(playerid,"ITRW_ARROW",checkarrow);
	HasItem(playerid,"ITRW_ADDON_FIREARROW",checkfirearrow);
	HasItem(playerid,"ITRW_ADDON_MAGICARROW",checkmagicarrow);
	HasItem(playerid,"ITRW_BOLT",checkbolt);
	HasItem(playerid,"ITRW_ADDON_MAGICBOLT",checkmagicbolt);
end

function Character_Item_CheckArrow(playerid,amount,checkid)
	local handler=MySQL_Get();
	if handler~=nil then
		if checkid>=checkarrow and checkid<=checkmagicbolt then
			local account=Player_GetAccount(playerid);
			local character=GPlayer.GetCharacter(account);
			local name=GCharacter.GetName(character);
			
			local item;
			if checkid==checkarrow then
				item="ITRW_ARROW";
			end
			
			if checkid==checkfirearrow then
				item="ITRW_ADDON_FIREARROW";
			end
			
			if checkid==checkmagicarrow then
				item="ITRW_ADDON_MAGICARROW";
			end
			
			if checkid==checkbolt then
				item="ITRW_BOLT";
			end
			
			if checkid==checkmagicbolt then
				item="ITRW_ADDON_MAGICBOLT";
			end
			
			local itemAmount=Character_Item_Has(playerid,item);
			
			if  amount==nil then
				amount=0;
			end
			
			if amount==0 then
				mysql_query(handler,string.format("DELETE FROM `%s_%s_item` WHERE `itemid`=%q",servername,name,item));
			else
				mysql_query(handler,string.format("UPDATE `%s_%s_item` SET amount=%d WHERE `itemid`=%q",servername,name,amount,item));
			end
			
			Character_Quest_Drop(playerid, item, itemAmount-amount);
		end
	else
		SendPlayerMessage(playerid,255,255,0,"(Server): Database Error.");
		Log_System("Character Item: Database lost.");
	end
end

function  Character_Item_ChangeGold(playerid, newValue)
	Anticheat_Gold(playerid, newValue);
end

function Character_Item_Dead(playerid)
	if player[playerid].hasarrow~=nil and IsTimerActive(player[playerid].hasarrow) then
		KillTimer(player[playerid].hasarrow);
	end
end

function Character_Item_Logout(playerid)
	Character_Trade_Logout(playerid);
	if player[playerid].hasarrow~=nil and IsTimerActive(player[playerid].hasarrow) then
		KillTimer(player[playerid].hasarrow);
	end
	
	local handler=MySQL_Get();
	if handler~=nil then -- for anticheat
		local account=Player_GetAccount(playerid);
		local character=GPlayer.GetCharacter(account);
		local name=GCharacter.GetName(character);
		local gold=GCharacter.GetGold(character);

		mysql_query(handler,string.format("DELETE FROM `%s_%s_item` WHERE `itemid`='ITMI_GOLD'",servername,name));
		if gold~=0 then
			mysql_query(handler,string.format("INSERT INTO `%s_%s_item`(`itemid`,`amount`) VALUES ('ITMI_GOLD',%d)",servername,name,gold));
		end
	end
	
	ClearInventory(playerid);
end