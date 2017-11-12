
local human={};
local player={};
local exitname=nil;
local goldname=nil;

local box_show=nil;
local box_refresh=nil;
local box_takerefresh=nil;
local box_valuerefresh=nil;
local box_hide=nil;
local box_key=nil;

local sellitem=5;	--base value
local takeitem=5;	--base value

for i = 0, GetMaxPlayers() - 1 do
	player[i]={};
	player[i].target=nil;
	player[i].active=false;
	player[i].takeinventory={};
	player[i].takeinventory.value=0;
	player[i].takeinventory.gold=0;
	player[i].takeinventory.number=0;
	player[i].takeinventory.item={};
end

function Human_Vendor(npcid,argument)
	if Human_Vendor_Check(GetPlayerName(npcid),argument) then
		human[npcid]={};
		human[npcid].number=argument.number;
		human[npcid].item={};
		for i=0,human[npcid].number-1 do
			human[npcid].item[i]={};
			human[npcid].item[i].id=argument.item[i]
			human[npcid].item[i].name=Item_Name(argument.item[i]);
			human[npcid].item[i].value=Item_Value(argument.item[i]);
		end
		human[npcid].angle=GetPlayerAngle(npcid);

		return Human_Vendor_Show;	
	else
		Log_System(string.format("Human Vendor: %s isn't vendor.",GetPlayerName(npcid)));
	end
	return nil;
end

function Human_Vendor_MaxItem(sell,take)
	if sell>0  and take>0 then
		sellitem=sell;
		takeitem=take;
	else
		Log_System(string.format("Human Vendor: The sell and take items must be more 0, that's why they are %d and %d.",sellitem,takeitem));
	end
end

function Human_Vendor_Init_Box(show,refresh,takerefresh,valuerefresh,hide,key)
	box_show=show;
	box_refresh=refresh;
	box_takerefresh=takerefresh;
	box_valuerefresh=valuerefresh;
	box_hide=hide;
	box_key=key;
end

function Human_Vendor_Exit_Init_Use(name)
	exitname="/"..name;
	Help_AddFunc("vendor",exitname);
end

function Human_Vendor_Gold_Init_Use(name)
	goldname="/"..name;
	Help_AddFunc("vendor",goldname);
end

function Human_Vendor_CommandText(playerid, cmdtext)
	local account=Player_GetAccount(playerid);
	
	if player[playerid].active and GPlayer.IsLoginCharacter(account) then
		local cmd,params = GetCommand(cmdtext);
		if cmdtext==exitname then
			Human_Vendor_Hide(playerid);
		elseif cmd==goldname then
			Human_Vendor_Gold(playerid,params);
		elseif cmdtext=="/help" then
			Help_Message(playerid,"vendor");
		end
	end
end

function Human_Vendor_Show(playerid,npcid)
	local account=Player_GetAccount(playerid);
	
	if not(GPlayer.IsBusy(account)) then
		player[playerid].active=true;
		
		GPlayer.SetBusy(account,true);
		SetPlayerAngle(npcid,GetAngleToPlayer(npcid,playerid));	
		SetPlayerAngle(playerid,GetAngleToPlayer(playerid,npcid));	
		box_show(playerid);
		player[playerid].target=npcid;
		
		if goldname~=nil then
			SendPlayerMessage(playerid,255,255,0,string.format("%s If the gold is positive, you give it. If number is negative, you take back it.",goldname));
		end
		
		Human_Vendor_Refresh(playerid);
	end
end

function Human_Vendor_Refresh(playerid)
	player[playerid].takeinventory.value=0;
	player[playerid].takeinventory.gold=0;
	player[playerid].takeinventory.number=0;
	Character_Trade_Refresh(playerid);
	box_refresh(playerid);
end

function Human_Vendor_GiveRefresh(playerid,index,amount)
	if Character_Trade_GiveRefresh(playerid,index,amount) then
		Human_Vendor_Value(playerid);		
	end
end

function Human_Vendor_TakeRefresh(playerid,index,amount)
	local ready=false;
	if amount>0 and human[player[playerid].target].number~=0 then
		local i=0;
		while i<player[playerid].takeinventory.number and player[playerid].takeinventory.item[i].name~=human[player[playerid].target].item[index].name do
			i=i+1;
		end
		if i<player[playerid].takeinventory.number then
			player[playerid].takeinventory.item[i].amount=player[playerid].takeinventory.item[i].amount+amount;
			ready=true;
		else
			if player[playerid].takeinventory.number<takeitem then
				local takeinventory_number=player[playerid].takeinventory.number;
				player[playerid].takeinventory.item[takeinventory_number]={};
				player[playerid].takeinventory.item[takeinventory_number].id=human[player[playerid].target].item[index].id;
				player[playerid].takeinventory.item[takeinventory_number].name=human[player[playerid].target].item[index].name;
				player[playerid].takeinventory.item[takeinventory_number].amount=amount;
				player[playerid].takeinventory.item[takeinventory_number].value=human[player[playerid].target].item[index].value;
				player[playerid].takeinventory.number=player[playerid].takeinventory.number+1;
				ready=true;
			end
		end
	end
	
	if amount<0 and player[playerid].takeinventory.number~=0 then
		local oldamount=player[playerid].takeinventory.item[index].amount;
		player[playerid].takeinventory.item[index].amount=player[playerid].takeinventory.item[index].amount+amount;
		if player[playerid].takeinventory.item[index].amount<1 then
			for i=index+1,  player[playerid].takeinventory.number-1 do
				player[playerid].takeinventory.item[i-1]=player[playerid].takeinventory.item[i];
			end
			player[playerid].takeinventory.number=player[playerid].takeinventory.number-1;
		end
		ready=true;
	end
	
	if ready then
		box_takerefresh(playerid);
		Human_Vendor_Value(playerid);
	end
end

function Human_Vendor_Gold(playerid,params)
	if Character_Trade_Gold(playerid,params) then
		Human_Vendor_Value(playerid);
	end
end

function Human_Vendor_Value(playerid)
	local buy=0;
	for i=0,player[playerid].takeinventory.number-1 do
		buy=buy+player[playerid].takeinventory.item[i].value*player[playerid].takeinventory.item[i].amount
	end
	if Character_Trade_GiveInventoryValue(playerid)>buy then
		player[playerid].takeinventory.value=Character_Trade_GiveInventoryValue(playerid);
		player[playerid].takeinventory.gold=player[playerid].takeinventory.value-buy;
	else
		player[playerid].takeinventory.value=buy;
		player[playerid].takeinventory.gold=0;
	end
	box_valuerefresh(playerid);
end

function Human_Vendor_Hide(playerid)
	if player[playerid].active then
		box_hide(playerid);
		
		local account=Player_GetAccount(playerid);
		GPlayer.SetBusy(account,false);
		player[playerid].active=false;
		SetPlayerAngle(player[playerid].target,human[player[playerid].target].angle);
		FreezePlayer(playerid,0);
	end
end

function Human_Vendor_Accept(playerid)
	if player[playerid].takeinventory.value>Character_Trade_GiveInventoryValue(playerid) then
		SendPlayerMessage(playerid,255,255,0,string.format("%s: Two value isn't equal.",GetPlayerName(player[playerid].target)));
	else
		Character_Trade_Accept(playerid);
		for i=0,player[playerid].takeinventory.number-1 do
			Character_Item_Give(playerid,player[playerid].takeinventory.item[i].id,player[playerid].takeinventory.item[i].amount);
		end
		if player[playerid].takeinventory.gold>0 then
			Character_Item_Give(playerid,"ITMI_GOLD",player[playerid].takeinventory.gold);
		end
		Human_Vendor_Hide(playerid);
	end
end

function Human_Vendor_Logout(playerid)
	Human_Vendor_Hide(playerid);
end

function Human_Vendor_Key(playerid,keydown)
	if player[playerid].active then
		box_key(playerid,keydown);
	end
end

function Human_Vendor_Check(npcname,items)
	local ready=true;
	
	if items==nil then
		Log_System(string.format("Human Vendor: %s's items wrong.",npcname));
		ready=false;
	else
		if type(items.number)~="number" or items.number<=0 and items.number>sellitem then
			Log_System(string.format("Human Vendor: %s's vendor: the number is wrong.",npcname));
			ready=false;
		else
			if items.item==nil then
				Log_System(string.format("Human Vendor: %s's vendor: the items is wrong.",npcname));
				ready=false;
			else
				for i=0, items.number-1 do
					if type(items.item[i])~="string" or not(Item_Exist(items.item[i])) then
						Log_System(string.format("Human Vendor: %s's vendor: the %d. item is wrong.",npcname,i+1));
						ready=false;
					end
				end
			end
		end
	end

	return ready;
end

function Human_Vendor_Active(playerid)
	return player[playerid].active;
end

function Human_Vendor_Item(playerid,index)
	return human[player[playerid].target].item[index];
end

function Human_Vendor_ItemNumber(playerid)
	return human[player[playerid].target].number;
end


function Human_Vendor_TakeInventoryItem(playerid,index)
	return player[playerid].takeinventory.item[index];
end

function Human_Vendor_TakeInventoryNumber(playerid)
	return player[playerid].takeinventory.number;
end

function Human_Vendor_TakeInventoryGold(playerid)
	return player[playerid].takeinventory.gold;
end

function Human_Vendor_TakeInventoryValue(playerid)
	return player[playerid].takeinventory.value;
end