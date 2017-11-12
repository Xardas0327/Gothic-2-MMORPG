
local servername=nil;
local tradename=nil;
local goldname=nil;
local exitname=nil;
local tradenumber=1; --base value

local box_show=nil;
local box_refresh=nil;
local box_traderefresh=nil;
local box_goldrefresh=nil;
local box_hide=nil;
local box_ready=nil;
local box_key=nil;

local give_item=nil;
local remove_item=nil;

local player={}
for i = 0, GetMaxPlayers() - 1 do
	player[i]={};
	player[i].target=nil;
	player[i].ready=false;
	player[i].active=false;
	player[i].inventory={};
	player[i].giveinventory={};
	player[i].giveinventory.value=0;
	player[i].giveinventory.gold=0;
	player[i].giveinventory.number=0;
	player[i].giveinventory.item={};
end

function Character_Trade_Init()
	servername=Setting_GetServerName();
end

function Character_Trade_Func(givef,removef)
	give_item=givef;
	remove_item=removef;
end

function Character_Trade_Init_Box(show,refresh,traderefresh,goldrefresh,hide,ready,key)
	box_show=show;
	box_refresh=refresh;
	box_traderefresh=traderefresh;
	box_goldrefresh=goldrefresh;
	box_hide=hide;
	box_ready=ready;
	box_key=key;
end

function Character_Trade_Init_Use(name)
	tradename="/"..name;
	Help_AddFunc("play",tradename);
	Help_AddFunc("trade",tradename);
end

function Character_Trade_Gold_Init_Use(name)
	goldname="/"..name;
	Help_AddFunc("trade",goldname);
end

function Character_Trade_Exit_Init_Use(name)
	exitname="/"..name;
	Help_AddFunc("trade",exitname);
end

function Character_Trade_CommandText(playerid, cmdtext)	
	local account=Player_GetAccount(playerid);
	
	if Player_Is(playerid) and GPlayer.IsLoginCharacter(account) then
		local cmd,params = GetCommand(cmdtext);
		
		if cmdtext==tradename and (not Character_Party_IsInvitee(playerid)) then
			Character_Trade(playerid);
		elseif player[playerid].active then
			if cmd==goldname then
				Character_Trade_Gold(playerid,params);
			elseif cmdtext=="/help" then
				Help_Message(playerid,"trade");
			elseif cmdtext==exitname then
				Character_Trade_Hide(playerid);
			end
		end
	end
end

function Character_Trade(playerid)
	local focus=GetFocus(playerid);
	if focus~=-1 then
		local account=Player_GetAccount(focus);
		if focus~=-1 and Player_Is(playerid) and GPlayer.IsLoginCharacter(account) and not(GPlayer.IsBusy(account)) and GetDistancePlayers(playerid,focus)<350 then
			PlayAnimation(playerid,"S_FISTRUN");
			PlayAnimation(focus,"S_FISTRUN");
			SetPlayerAngle(playerid,GetAngleToPlayer(playerid,focus));	
			SetPlayerAngle(focus,GetAngleToPlayer(focus,playerid));
				
			Character_Trade_Show(playerid,focus);
			Character_Trade_Show(focus,playerid);
			
			if goldname~=nil then
				SendPlayerMessage(playerid,255,255,0,string.format("%s If the gold is positive, you give it. If number is negative, you take back it.",goldname));
				SendPlayerMessage(focus,255,255,0,string.format("%s If the gold is positive, you give it. If number is negative, you take back it.",goldname));
			end
		end
	end
end

function Character_Trade_MaxItem(number)
	if number>0 then
		tradenumber=number;
	else
		Log_System(string.format("Character Trade: The trade items must be more 0, that's why it is %d.",tradenumber));
	end
end

function Character_Trade_Show(playerid,targetid)
	player[playerid].active=true;
	player[playerid].ready=false;
	player[playerid].target=targetid;
	FreezePlayer(playerid,1);
	SetPlayerEnable_OnPlayerKey(playerid,1);
	box_show(playerid);
	Character_Trade_Refresh(playerid);
end

function Character_Trade_Refresh(playerid)
	local handler=MySQL_Get();
	if handler~=nil then
		player[playerid].giveinventory.number=0;
		player[playerid].giveinventory.gold=0;
		player[playerid].giveinventory.value=0;
		
		local account=Player_GetAccount(playerid);
		local character=GPlayer.GetCharacter(account);
		local characterName=GCharacter.GetName(character);
						
		local items= mysql_query(handler, string.format("SELECT `itemid`,`amount`,`equipped` FROM `%s_%s_item` ORDER BY `itemid`",servername,characterName));
		if items then
			player[playerid].inventory.number=0;
			player[playerid].inventory.gold=GCharacter.GetGold(character);
			player[playerid].inventory.item={};
			for items,item in mysql_rows_assoc(items) do
				local value=Item_Value(item['itemid']);
				local amount=0;
				if tonumber(item['equipped'])==1 then
					amount=tonumber(item['amount'])-1;
				else
					amount=tonumber(item['amount']);
				end
				
				if value>0 and amount>0  then
					local inventory_number=player[playerid].inventory.number;
					player[playerid].inventory.item[inventory_number]={};
					player[playerid].inventory.item[inventory_number].id=item['itemid'];
					player[playerid].inventory.item[inventory_number].name=Item_Name(item['itemid']);
					player[playerid].inventory.item[inventory_number].value=value;
					player[playerid].inventory.item[inventory_number].amount=amount;
					player[playerid].inventory.number=player[playerid].inventory.number+1;
				end
			end
			mysql_free_result(items);
			box_refresh(playerid);
		else
			SendPlayerMessage(playerid,255,255,0,"(Server): Database Error. The character's items lost.");
		end
	else
		SendPlayerMessage(playerid,255,255,0,"(Server): Database Error. The character's items lost.");
	end
end

function Character_Trade_GiveRefresh(playerid,index,amount)
	local ready=false;
	if amount>0 and player[playerid].inventory.number~=0 then
		local i=0;
		while i<player[playerid].giveinventory.number and player[playerid].giveinventory.item[i].name~=player[playerid].inventory.item[index].name do
			i=i+1;
		end
		if i<player[playerid].giveinventory.number then
			if player[playerid].giveinventory.item[i].amount+amount<=player[playerid].inventory.item[index].amount then
				player[playerid].giveinventory.item[i].amount=player[playerid].giveinventory.item[i].amount+amount;
				player[playerid].giveinventory.value=player[playerid].giveinventory.value+amount*player[playerid].inventory.item[index].value;
				ready=true;
			end
		else
			if player[playerid].giveinventory.number<tradenumber then
				local giveinventory_number=player[playerid].giveinventory.number;
				player[playerid].giveinventory.item[giveinventory_number]={};
				player[playerid].giveinventory.item[giveinventory_number].id=player[playerid].inventory.item[index].id;
				player[playerid].giveinventory.item[giveinventory_number].name=player[playerid].inventory.item[index].name;
				player[playerid].giveinventory.item[giveinventory_number].amount=amount;
				player[playerid].giveinventory.item[giveinventory_number].value=player[playerid].inventory.item[index].value;
				player[playerid].giveinventory.number=player[playerid].giveinventory.number+1;
				player[playerid].giveinventory.value=player[playerid].giveinventory.value+amount*player[playerid].inventory.item[index].value;
				ready=true;
			end
		end
	end
	
	if amount<0 and player[playerid].giveinventory.number~=0 then
		local oldamount=player[playerid].giveinventory.item[index].amount;
		player[playerid].giveinventory.item[index].amount=player[playerid].giveinventory.item[index].amount+amount;
		if player[playerid].giveinventory.item[index].amount<1 then	
			player[playerid].giveinventory.value=player[playerid].giveinventory.value-oldamount*player[playerid].giveinventory.item[index].value;
			for i=index+1, player[playerid].giveinventory.number-1 do
				player[playerid].giveinventory.item[i-1]=player[playerid].giveinventory.item[i];
			end
			player[playerid].giveinventory.number=player[playerid].giveinventory.number-1;
		else
			player[playerid].giveinventory.value=player[playerid].giveinventory.value+amount*player[playerid].giveinventory.item[index].value;
		end
		ready=true;
	end
	
	if ready then
		box_traderefresh(playerid,amount);
	end
	return ready;
end

function Character_Trade_Gold(playerid,params)
	local ready=false;
	local result,gold=sscanf(params,"d");
	if result==1 and gold~=0 then
		gold=math.floor(gold);
		if gold>0 then
			if gold<=player[playerid].inventory.gold then
				player[playerid].inventory.gold=player[playerid].inventory.gold-gold;
				player[playerid].giveinventory.gold=player[playerid].giveinventory.gold+gold;
					
				player[playerid].giveinventory.value=player[playerid].giveinventory.value+gold;
				ready=true;
			else
				SendPlayerMessage(playerid,255,255,0,string.format("(Server): You haven't got %d gold.",gold));
			end
		else
			gold=gold*-1;
			if gold<=player[playerid].giveinventory.gold then
				player[playerid].inventory.gold=player[playerid].inventory.gold+gold;
				player[playerid].giveinventory.gold=player[playerid].giveinventory.gold-gold;
				
				player[playerid].giveinventory.value=player[playerid].giveinventory.value-gold;
				ready=true;
			else
				SendPlayerMessage(playerid,255,255,0,string.format("(Server): You don't want to give %d gold.",gold));
			end
		end
			
		if ready then
			box_goldrefresh(playerid)
		end
	else
		SendPlayerMessage(playerid,255,255,0,string.format("(Server): use %s (gold amount)",goldname));
		SendPlayerMessage(playerid,255,255,0,"If number is positive, you give it. If number is negative, you take back it.");
	end
	return ready;
end

function Character_Trade_Hide(playerid)
	if player[playerid].active then
		box_hide(playerid);
		SetPlayerEnable_OnPlayerKey(playerid,0);
		FreezePlayer(playerid,0);
		player[playerid].active=false;
		Character_Trade_Hide(player[playerid].target);
	end
end

function Character_Trade_Check(playerid)
	if player[playerid].active then
		if player[player[playerid].target].ready then
			player[playerid].ready=true;
			Character_Trade_Accept(playerid);
			Character_Trade_Accept(player[playerid].target);		
			Character_Trade_Hide(playerid);
		else
			if player[playerid].ready then
				player[playerid].ready=false;
			else
				player[playerid].ready=true;
			end
			box_ready(playerid);
		end
	end
end

function Character_Trade_Accept(playerid)
	for i=0,player[playerid].giveinventory.number-1 do
		remove_item(playerid,player[playerid].giveinventory.item[i].id,player[playerid].giveinventory.item[i].amount);
	end
	if player[playerid].giveinventory.gold>0 then
		remove_item(playerid,"ITMI_GOLD",player[playerid].giveinventory.gold);
	end
	if player[playerid].ready then
		for i=0,player[playerid].giveinventory.number-1 do
			give_item(player[playerid].target,player[playerid].giveinventory.item[i].id,player[playerid].giveinventory.item[i].amount);
		end
		if player[playerid].giveinventory.gold>0 then
			give_item(player[playerid].target,"ITMI_GOLD",player[playerid].giveinventory.gold);
		end
	end
	player[playerid].ready=false;
end

function Character_Trade_Key(playerid,keydown)
	if player[playerid].active then
		box_key(playerid,keydown);
	end
end

function Character_Trade_Logout(playerid)
	Character_Trade_Hide(playerid);
end

function Character_Trade_Active(playerid)
	return player[playerid].active;
end

function Character_Trade_Ready(playerid)
	return player[playerid].ready;
end

function Character_Trade_Target(playerid)
	return player[playerid].target;
end

function Character_Trade_InventoryItem(playerid,index)
	return player[playerid].inventory.item[index];
end

function Character_Trade_InventoryNumber(playerid)
	return player[playerid].inventory.number;
end

function Character_Trade_InventoryGold(playerid)
	return player[playerid].inventory.gold;
end

function Character_Trade_GiveInventoryItem(playerid,index)
	return player[playerid].giveinventory.item[index];
end

function Character_Trade_GiveInventoryNumber(playerid)
	return player[playerid].giveinventory.number;
end

function Character_Trade_GiveInventoryGold(playerid)
	return player[playerid].giveinventory.gold;
end

function Character_Trade_GiveInventoryValue(playerid)
	return player[playerid].giveinventory.value;
end