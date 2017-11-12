
local inventory_window={};
inventory_window.x=300;
inventory_window.y=2400;
inventory_window.active_texture=nil;
inventory_window.passive_texture=nil;
inventory_window.name=nil;
inventory_window.rownumber=11;
inventory_window.title={};
inventory_window.row={};
inventory_window.page={};
inventory_window.gold={};

local trade_rownumber=8;
local trade_window={};
trade_window.x=inventory_window.x+500;
trade_window.y=inventory_window.y+2900;
trade_window.active_texture=nil;
trade_window.passive_texture=nil;
trade_window.name=nil;
trade_window.title={};
trade_window.row={};
trade_window.item={};
trade_window.gold={};
trade_window.value={};

local receive_window={};
receive_window.x=trade_window.x+3200;
receive_window.y=trade_window.y;
receive_window.active_texture=nil;
receive_window.passive_texture=nil;
receive_window.name=nil;
receive_window.title={};
receive_window.row={};
receive_window.item={};
receive_window.gold={};
receive_window.value={};

local accept_window={};
accept_window.x=trade_window.x+1700;
accept_window.y=trade_window.y+2200;
accept_window.active_texture=nil;
accept_window.passive_texture=nil;
accept_window.text={};

local cancel_window={};
cancel_window.x=trade_window.x+3200;
cancel_window.y=trade_window.y+2200;
cancel_window.active_texture=nil;
cancel_window.passive_texture=nil;
cancel_window.text={};

local player={};

function Interface_TradeBox_Init()
	inventory_window.active_texture=CreateTexture(inventory_window.x,inventory_window.y,inventory_window.x+3500,inventory_window.y+2500,"Frame_GMPA.TGA");
	inventory_window.passive_texture=CreateTexture(inventory_window.x,inventory_window.y,inventory_window.x+3500,inventory_window.y+2500,"DLG_CONVERSATION.TGA");
	inventory_window.name=GDraw.new(inventory_window.x+100,inventory_window.y-225,"Inventory","Font_Old_20_White_Hi.TGA",255,255,255);
	inventory_window.title[0]=GDraw.new(inventory_window.x+100,inventory_window.y+200,"Name","Font_Old_10_White_Hi.TGA",255,255,255);
	inventory_window.title[1]=GDraw.new(inventory_window.x+2400,inventory_window.y+200,"Value","Font_Old_10_White_Hi.TGA",255,255,255);
	inventory_window.title[2]=GDraw.new(inventory_window.x+2900,inventory_window.y+200,"Amount","Font_Old_10_White_Hi.TGA",255,255,255);

	trade_window.active_texture=CreateTexture(trade_window.x,trade_window.y,trade_window.x+3000,trade_window.y+2000,"Frame_GMPA.TGA");
	trade_window.passive_texture=CreateTexture(trade_window.x,trade_window.y,trade_window.x+3000,trade_window.y+2000,"DLG_CONVERSATION.TGA");
	trade_window.name=GDraw.new(trade_window.x+100,trade_window.y-225,"Give","Font_Old_20_White_Hi.TGA",255,255,255);
	trade_window.title[0]=GDraw.new(trade_window.x+100,trade_window.y+200,"Name","Font_Old_10_White_Hi.TGA",255,255,255);
	trade_window.title[1]=GDraw.new(trade_window.x+2400,trade_window.y+200,"Amount","Font_Old_10_White_Hi.TGA",255,255,255);

	receive_window.active_texture=CreateTexture(receive_window.x,receive_window.y,receive_window.x+3000,receive_window.y+2000,"Frame_GMPA.TGA");
	receive_window.passive_texture=CreateTexture(receive_window.x,receive_window.y,receive_window.x+3000,receive_window.y+2000,"DLG_CONVERSATION.TGA");
	receive_window.name=GDraw.new(receive_window.x+100,receive_window.y-225,"Receive","Font_Old_20_White_Hi.TGA",255,255,255);
	receive_window.title[0]=GDraw.new(receive_window.x+100,receive_window.y+200,"Name","Font_Old_10_White_Hi.TGA",255,255,255);
	receive_window.title[1]=GDraw.new(receive_window.x+2400,receive_window.y+200,"Amount","Font_Old_10_White_Hi.TGA",255,255,255);

	accept_window.active_texture=CreateTexture(accept_window.x,accept_window.y,accept_window.x+1300,accept_window.y+500,"Frame_GMPA.TGA");
	accept_window.passive_texture=CreateTexture(accept_window.x,accept_window.y,accept_window.x+1300,accept_window.y+500,"DLG_CONVERSATION.TGA");
	
	cancel_window.active_texture=CreateTexture(cancel_window.x,cancel_window.y,cancel_window.x+1300,cancel_window.y+500,"Frame_GMPA.TGA");
	cancel_window.passive_texture=CreateTexture(cancel_window.x,cancel_window.y,cancel_window.x+1300,cancel_window.y+500,"DLG_CONVERSATION.TGA");
	
	for i = 0, GetMaxPlayers() - 1 do
		inventory_window.row[i]={};
		for j=0, inventory_window.rownumber-1 do
			inventory_window.row[i][j]={};
			inventory_window.row[i][j].name=GDraw.new(inventory_window.x+100,inventory_window.y+200+(j+1)*150,"","Font_Old_10_White_Hi.TGA",255,255,255);
			inventory_window.row[i][j].value=GDraw.new(inventory_window.x+2400,inventory_window.y+200+(j+1)*150,"","Font_Old_10_White_Hi.TGA",255,255,255);
			inventory_window.row[i][j].amount=GDraw.new(inventory_window.x+2900,inventory_window.y+200+(j+1)*150,"","Font_Old_10_White_Hi.TGA",255,255,255);
		end
		inventory_window.page[i]=GDraw.new(inventory_window.x+1300,inventory_window.y+200+(inventory_window.rownumber+2)*150,"<-- 1/2 -->","Font_Old_10_White_Hi.TGA",255,255,255);
		inventory_window.gold[i]=GDraw.new(inventory_window.x+2500,inventory_window.y+200+(inventory_window.rownumber+2)*150,"Gold: 100000","Font_Old_10_White_Hi.TGA",255,255,255);

		trade_window.item[i]=GDraw.new(trade_window.x+100,trade_window.y+200+(trade_rownumber+2)*150,"Item: 0/9","Font_Old_10_White_Hi.TGA",255,255,255);
		trade_window.gold[i]=GDraw.new(trade_window.x+1000,trade_window.y+200+(trade_rownumber+2)*150,"Gold: 0","Font_Old_10_White_Hi.TGA",255,255,255);
		trade_window.value[i]=GDraw.new(trade_window.x+2000,trade_window.y+200+(trade_rownumber+2)*150,"Value: 0","Font_Old_10_White_Hi.TGA",255,255,255);

		receive_window.item[i]=GDraw.new(receive_window.x+100,receive_window.y+200+(trade_rownumber+2)*150,"Item: 0/9","Font_Old_10_White_Hi.TGA",255,255,255);
		receive_window.gold[i]=GDraw.new(receive_window.x+1000,receive_window.y+200+(trade_rownumber+2)*150,"Gold: 0","Font_Old_10_White_Hi.TGA",255,255,255);
		receive_window.value[i]=GDraw.new(receive_window.x+2000,receive_window.y+200+(trade_rownumber+2)*150,"Value: 0","Font_Old_10_White_Hi.TGA",255,255,255);

		trade_window.row[i]={};
		receive_window.row[i]={};
		for j=0, trade_rownumber-1 do
			trade_window.row[i][j]={};
			trade_window.row[i][j].name=GDraw.new(trade_window.x+100,trade_window.y+200+(j+1)*150,"","Font_Old_10_White_Hi.TGA",255,255,255);
			trade_window.row[i][j].amount=GDraw.new(trade_window.x+2400,trade_window.y+200+(j+1)*150,"","Font_Old_10_White_Hi.TGA",255,255,255);
			
			receive_window.row[i][j]={};
			receive_window.row[i][j].name=GDraw.new(receive_window.x+100,receive_window.y+200+(j+1)*150,"","Font_Old_10_White_Hi.TGA",255,255,255);
			receive_window.row[i][j].amount=GDraw.new(receive_window.x+2400,receive_window.y+200+(j+1)*150,"","Font_Old_10_White_Hi.TGA",255,255,255);
		end
		
		accept_window.text[i]=GDraw.new(accept_window.x+100,accept_window.y+50,"ACCEPT","Font_Old_20_White_Hi.TGA",255,255,255);
		
		cancel_window.text[i]=GDraw.new(cancel_window.x+100,cancel_window.y+50,"CANCEL","Font_Old_20_White_Hi.TGA",255,255,255);
		
		player[i]={};
		player[i].active_texture=""; --value: inventory,trade,accept,ready
		player[i].row=0;
		player[i].page=1;
		player[i].maxpage=0;
		player[i].pageitem=0;
		player[i].tradenumber=0;
	end	
	Character_Trade_MaxItem(trade_rownumber);
	Character_Trade_Init_Box(Interface_TradeBox_Show,Interface_TradeBox_Refresh,Interface_TradeBox_GiveRefresh,Interface_TradeBox_GoldRefresh,Interface_TradeBox_Hide,Interface_TradeBox_Ready,Interface_TradeBox_Key)
	Help_AddHelp("trade","You can move w,a,s,d (or arrow).");
	Help_AddHelp("trade","Selected is CTRL and window change is TAB.");
end

function Interface_TradeBox_Show(playerid)
	CloseInventory(playerid);
	
	player[playerid].active_texture="inventory";
	ShowTexture(playerid,inventory_window.active_texture);
	ShowDraw(playerid,GDraw.id(inventory_window.name));
	for i=0,2 do
		ShowDraw(playerid,GDraw.id(inventory_window.title[i]));
	end
	ShowDraw(playerid,GDraw.id(inventory_window.page[playerid]));
	ShowDraw(playerid,GDraw.id(inventory_window.gold[playerid]));
	
	ShowTexture(playerid,trade_window.passive_texture);
	ShowDraw(playerid,GDraw.id(trade_window.name));
	ShowDraw(playerid,GDraw.id(trade_window.item[playerid]));
	ShowDraw(playerid,GDraw.id(trade_window.gold[playerid]));
	ShowDraw(playerid,GDraw.id(trade_window.value[playerid]));	
	for i=0,1 do
		ShowDraw(playerid,GDraw.id(trade_window.title[i]));
	end
	
	if Character_Trade_Active(playerid) then
		ShowTexture(playerid,receive_window.passive_texture);
		ShowDraw(playerid,GDraw.id(receive_window.name));
		ShowDraw(playerid,GDraw.id(receive_window.item[playerid]));
		ShowDraw(playerid,GDraw.id(receive_window.gold[playerid]));
		ShowDraw(playerid,GDraw.id(receive_window.value[playerid]));
		for i=0,1 do
			ShowDraw(playerid,GDraw.id(receive_window.title[i]));
		end
	end
	
	ShowTexture(playerid,accept_window.passive_texture);
	ShowDraw(playerid,GDraw.id(accept_window.text[playerid]));
	
	ShowTexture(playerid,cancel_window.passive_texture);
	ShowDraw(playerid,GDraw.id(cancel_window.text[playerid]));
end

function Interface_TradeBox_Refresh(playerid)
	player[playerid].tradenumber=0;
	player[playerid].page=1;
	player[playerid].pageitem=0;
	local inventory_number=Character_Trade_InventoryNumber(playerid);
	if inventory_number~=0 then
		if inventory_number%inventory_window.rownumber==0 then
			player[playerid].maxpage=inventory_number/inventory_window.rownumber;
		else
			player[playerid].maxpage=math.floor(inventory_number/inventory_window.rownumber)+1;
		end
		
		Interface_TradeBox_Page(playerid,0);
	end

	GDraw.message(inventory_window.page[playerid],string.format("<-- 1/%d -->",player[playerid].maxpage),255,255,255);
	GDraw.message(inventory_window.gold[playerid],string.format("Gold: %d",Character_Trade_InventoryGold(playerid)),255,255,255);
	
	GDraw.message(trade_window.item[playerid],string.format("Item: 0/%d",trade_rownumber));
	GDraw.message(trade_window.gold[playerid],"Gold: 0");
	GDraw.message(trade_window.value[playerid],"Value: 0");
	GDraw.message(receive_window.item[playerid],string.format("Item: 0/%d",trade_rownumber));
	GDraw.message(receive_window.gold[playerid],"Gold: 0");
	GDraw.message(receive_window.value[playerid],"Value: 0");
	GDraw.color(accept_window.text[playerid],255,255,255);
	GDraw.color(cancel_window.text[playerid],255,255,255);
	
	Interface_TradeBox_GiveRefresh(playerid);
end

function Interface_TradeBox_Page(playerid,move)
	if player[playerid].active_texture=="inventory" and player[playerid].maxpage>0 then
		local new=player[playerid].page+move;
		
		local itemNumber=player[playerid].maxpage;
		
		if new<=0 then
			new=itemNumber;
		end
		
		if new>itemNumber then
			new=1;
		end
		
		player[playerid].row=0;
		player[playerid].page=new;
		local pageitem=0;
		if player[playerid].page==player[playerid].maxpage then
			pageitem=Character_Trade_InventoryNumber(playerid)%inventory_window.rownumber;
			if pageitem==0 then
				pageitem=inventory_window.rownumber;
			end
		else
			pageitem=inventory_window.rownumber;
		end
		if player[playerid].pageitem>pageitem then
			while player[playerid].pageitem~=pageitem do
				player[playerid].pageitem=player[playerid].pageitem-1;
				HideDraw(playerid,GDraw.id(inventory_window.row[playerid][ player[playerid].pageitem ].name));
				HideDraw(playerid,GDraw.id(inventory_window.row[playerid][ player[playerid].pageitem ].value));
				HideDraw(playerid,GDraw.id(inventory_window.row[playerid][ player[playerid].pageitem ].amount));
			end
		elseif player[playerid].pageitem<pageitem then
			while player[playerid].pageitem~=pageitem do
				ShowDraw(playerid,GDraw.id(inventory_window.row[playerid][ player[playerid].pageitem ].name));
				ShowDraw(playerid,GDraw.id(inventory_window.row[playerid][ player[playerid].pageitem ].value));
				ShowDraw(playerid,GDraw.id(inventory_window.row[playerid][ player[playerid].pageitem ].amount));
				player[playerid].pageitem=player[playerid].pageitem+1;
			end
		end
		local index=Interface_TradeBox_InventoryRowIndex(playerid);
		local item=Character_Trade_InventoryItem(playerid,index);
		GDraw.message_color(inventory_window.row[playerid][0].name,item.name,255,255,0);
		GDraw.message_color(inventory_window.row[playerid][0].value,tostring(item.value),255,255,0);
		GDraw.message_color(inventory_window.row[playerid][0].amount,tostring(item.amount),255,255,0);
		
		for i=1,player[playerid].pageitem-1 do
			item=Character_Trade_InventoryItem(playerid,index+i);
			GDraw.message_color(inventory_window.row[playerid][i].name,item.name,255,255,255);
			GDraw.message_color(inventory_window.row[playerid][i].value,tostring(item.value),255,255,255);
			GDraw.message_color(inventory_window.row[playerid][i].amount,tostring(item.amount),255,255,255);
		end
			
		for i=player[playerid].pageitem, inventory_window.rownumber-1 do
			GDraw.message(inventory_window.row[playerid][i].name,"");
			GDraw.message(inventory_window.row[playerid][i].value,"");
			GDraw.message(inventory_window.row[playerid][i].amount,"");
		end
		GDraw.message(inventory_window.page[playerid],string.format("<-- %d/%d -->",player[playerid].page,player[playerid].maxpage));
	elseif player[playerid].active_texture=="accept" then
		local new=player[playerid].row;
		
		if new+move>=0 and new+move<2 then
			new=new+move;
		end
		
		if new~=player[playerid].row then
			if new==0 then
				GDraw.color(accept_window.text[playerid],255,255,0);
				GDraw.color(cancel_window.text[playerid],255,255,255);
			else
				GDraw.color(accept_window.text[playerid],255,255,255);
				GDraw.color(cancel_window.text[playerid],255,255,0);
			end
			
			player[playerid].row=new;
		end	
	end
end

function Interface_TradeBox_GiveRefresh(playerid)
	local givenumber=Character_Trade_GiveInventoryNumber(playerid);
	local targetid=Character_Trade_Target(playerid);
	if player[playerid].tradenumber>givenumber then
		while player[playerid].tradenumber~=givenumber do
			player[playerid].tradenumber=player[playerid].tradenumber-1;
			HideDraw(playerid,GDraw.id(trade_window.row[playerid][ player[playerid].tradenumber ].name));
			HideDraw(playerid,GDraw.id(trade_window.row[playerid][ player[playerid].tradenumber ].amount));
			
			if Character_Trade_Active(playerid) then
				HideDraw(targetid,GDraw.id(receive_window.row[targetid][ player[playerid].tradenumber ].name));
				HideDraw(targetid,GDraw.id(receive_window.row[targetid][ player[playerid].tradenumber ].amount));
			end
		end
	elseif player[playerid].tradenumber<givenumber then
		while player[playerid].tradenumber~=givenumber do
			ShowDraw(playerid,GDraw.id(trade_window.row[playerid][ player[playerid].tradenumber ].name));
			ShowDraw(playerid,GDraw.id(trade_window.row[playerid][ player[playerid].tradenumber ].amount));
			
			if Character_Trade_Active(playerid) then
				ShowDraw(targetid,GDraw.id(receive_window.row[targetid][ player[playerid].tradenumber ].name));
				ShowDraw(targetid,GDraw.id(receive_window.row[targetid][ player[playerid].tradenumber ].amount));
			end
			player[playerid].tradenumber=player[playerid].tradenumber+1;
		end
	end
	if givenumber~=0 then
		for i=0, givenumber-1 do
			local item=Character_Trade_GiveInventoryItem(playerid,i);
			GDraw.message_color(trade_window.row[playerid][i].name,item.name,255,255,255);
			GDraw.message_color(trade_window.row[playerid][i].amount,tostring(item.amount),255,255,255);
			
			if Character_Trade_Active(playerid) then
				GDraw.message(receive_window.row[targetid][i].name,item.name);
				GDraw.message(receive_window.row[targetid][i].amount,tostring(item.amount));
			end
		end
		if player[playerid].active_texture=="trade" then
			if player[playerid].row>=givenumber then
				player[playerid].row=givenumber-1;
			end
			GDraw.color(trade_window.row[playerid][player[playerid].row].name,255,255,0);
			GDraw.color(trade_window.row[playerid][player[playerid].row].amount,255,255,0);
		end
	end
	
	GDraw.message(trade_window.item[playerid],string.format("Item: %d/%d",givenumber,trade_rownumber));
	GDraw.message(trade_window.value[playerid],string.format("Value: %d",Character_Trade_GiveInventoryValue(playerid)));
	
	if Character_Trade_Active(playerid) then
		GDraw.message(receive_window.item[targetid],string.format("Item: %d/%d",givenumber,trade_rownumber));
		GDraw.message(receive_window.value[targetid],string.format("Value: %d",Character_Trade_GiveInventoryValue(playerid)));
	end
end

function Interface_TradeBox_GoldRefresh(playerid)
	GDraw.message(inventory_window.gold[playerid],string.format("Gold: %d",Character_Trade_InventoryGold(playerid)));
	GDraw.message(trade_window.gold[playerid],string.format("Gold: %d",Character_Trade_GiveInventoryGold(playerid)));
	GDraw.message(trade_window.value[playerid],string.format("Value: %d",Character_Trade_GiveInventoryValue(playerid)));
	
	if Character_Trade_Active(playerid) then
		GDraw.message(receive_window.gold[Character_Trade_Target(playerid)],string.format("Gold: %d",Character_Trade_GiveInventoryGold(playerid)));
		GDraw.message(receive_window.value[Character_Trade_Target(playerid)],string.format("Value: %d",Character_Trade_GiveInventoryValue(playerid)));
	end
end

function Interface_TradeBox_Move(playerid,move)
	if player[playerid].active_texture=="inventory" and Character_Trade_InventoryNumber(playerid)~=0 then
		local new=player[playerid].row+move;
		
		local itemNumber=player[playerid].pageitem;
		
		if new<0 then
			new=itemNumber-1;
		end
		
		if new>=itemNumber then
			new=0;
		end
		
		GDraw.color(inventory_window.row[playerid][new].name,255,255,0);
		GDraw.color(inventory_window.row[playerid][new].value,255,255,0);
		GDraw.color(inventory_window.row[playerid][new].amount,255,255,0);
				
		GDraw.color(inventory_window.row[playerid][ player[playerid].row ].name,255,255,255);
		GDraw.color(inventory_window.row[playerid][ player[playerid].row ].value,255,255,255);
		GDraw.color(inventory_window.row[playerid][ player[playerid].row ].amount,255,255,255);
				
		player[playerid].row=new;
	elseif player[playerid].active_texture=="trade" and Character_Trade_GiveInventoryNumber(playerid)~=0 then
		local new=player[playerid].row+move;
		
		local itemNumber=Character_Trade_GiveInventoryNumber(playerid);
		
		if new<0 then
			new=itemNumber-1;
		end
		
		if new>=itemNumber then
			new=0;
		end
		
		GDraw.color(trade_window.row[playerid][new].name,255,255,0);
		GDraw.color(trade_window.row[playerid][new].amount,255,255,0);
			
		GDraw.color(trade_window.row[playerid][ player[playerid].row ].name,255,255,255);
		GDraw.color(trade_window.row[playerid][ player[playerid].row ].amount,255,255,255);
			
		player[playerid].row=new;
	end
end

function Interface_TradeBox_Hide(playerid)
	HideTexture(playerid,inventory_window.active_texture);
	HideTexture(playerid,inventory_window.passive_texture);
	HideDraw(playerid,GDraw.id(inventory_window.name));
	for i=0,2 do
		HideDraw(playerid,GDraw.id(inventory_window.title[i]));
	end
	for i=0, player[playerid].pageitem-1 do
		HideDraw(playerid,GDraw.id(inventory_window.row[playerid][i].name));
		HideDraw(playerid,GDraw.id(inventory_window.row[playerid][i].value));
		HideDraw(playerid,GDraw.id(inventory_window.row[playerid][i].amount));
	end
	HideDraw(playerid,GDraw.id(inventory_window.page[playerid]));
	HideDraw(playerid,GDraw.id(inventory_window.gold[playerid]));
	
	HideTexture(playerid,trade_window.active_texture);
	HideTexture(playerid,trade_window.passive_texture);
	HideDraw(playerid,GDraw.id(trade_window.name));
	HideDraw(playerid,GDraw.id(trade_window.item[playerid]));
	HideDraw(playerid,GDraw.id(trade_window.gold[playerid]));
	HideDraw(playerid,GDraw.id(trade_window.value[playerid]));	
	for i=0,1 do
		HideDraw(playerid,GDraw.id(trade_window.title[i]));
	end
	for i=0,player[playerid].tradenumber-1 do
		HideDraw(playerid,GDraw.id(trade_window.row[playerid][i].name));
		HideDraw(playerid,GDraw.id(trade_window.row[playerid][i].amount));
	end
	
	if Character_Trade_Active(playerid) then
		HideTexture(playerid,receive_window.active_texture);
		HideTexture(playerid,receive_window.passive_texture);
		HideDraw(playerid,GDraw.id(receive_window.name));
		HideDraw(playerid,GDraw.id(receive_window.item[playerid]));
		HideDraw(playerid,GDraw.id(receive_window.gold[playerid]));
		HideDraw(playerid,GDraw.id(receive_window.value[playerid]));
		for i=0,1 do
			HideDraw(playerid,GDraw.id(receive_window.title[i]));
		end
		
		local targetid=Character_Trade_Target(playerid);
		for i=0,player[playerid].tradenumber-1 do
			HideDraw(targetid,GDraw.id(receive_window.row[targetid][i].name));
			HideDraw(targetid,GDraw.id(receive_window.row[targetid][i].amount));
		end
	end
	
	HideTexture(playerid,accept_window.active_texture);
	HideTexture(playerid,accept_window.passive_texture);
	HideDraw(playerid,GDraw.id(accept_window.text[playerid]));
	
	HideTexture(playerid,cancel_window.active_texture);
	HideTexture(playerid,cancel_window.passive_texture);
	HideDraw(playerid,GDraw.id(cancel_window.text[playerid]));	
end

function Interface_TradeBox_Active(playerid)
	if player[playerid].active_texture=="inventory" then
		Interface_TradeBox_InventoryPassive(playerid);
		Interface_TradeBox_TradeActive(playerid);
	elseif player[playerid].active_texture=="trade" then
		Interface_TradeBox_TradePassive(playerid);
		Interface_TradeBox_AcceptActive(playerid);
	elseif player[playerid].active_texture=="accept" then
		Interface_TradeBox_InventoryActive(playerid);
		Interface_TradeBox_AcceptPassive(playerid);
	end
end

function Interface_TradeBox_Event(playerid)
	if player[playerid].active_texture=="inventory" then
		Character_Trade_GiveRefresh(playerid,Interface_TradeBox_InventoryRowIndex(playerid),1);
	elseif player[playerid].active_texture=="trade" then
		Character_Trade_GiveRefresh(playerid,Interface_TradeBox_TradeRowIndex(playerid),-1);
	elseif player[playerid].active_texture=="accept" then
		if player[playerid].row==0 then
			Character_Trade_Check(playerid);
		else
			Character_Trade_Hide(playerid);
		end
	end
end

function Interface_TradeBox_Ready(playerid,ready)
	local targetid=Character_Trade_Target(playerid);
	if Character_Trade_Ready(playerid) then
		HideTexture(playerid,inventory_window.passive_texture);
		HideTexture(playerid,trade_window.passive_texture);
		HideTexture(targetid,receive_window.passive_texture);
		
		ShowTexture(playerid,inventory_window.active_texture);
		ShowTexture(playerid,trade_window.active_texture);
		ShowTexture(targetid,receive_window.active_texture);
		player[playerid].active_texture="ready";
	else
		HideTexture(playerid,inventory_window.active_texture);
		HideTexture(playerid,trade_window.active_texture);
		HideTexture(targetid,receive_window.active_texture);
		
		ShowTexture(playerid,inventory_window.passive_texture);
		ShowTexture(playerid,trade_window.passive_texture);
		ShowTexture(targetid,receive_window.passive_texture);
		player[playerid].active_texture="accept";
	end
end

function Interface_TradeBox_Key(playerid,keydown)
	if keydown == KEY_W or keydown == KEY_UP then
		Interface_TradeBox_Move(playerid,-1);
	elseif keydown == KEY_S or keydown == KEY_DOWN then
		Interface_TradeBox_Move(playerid,1);
	elseif keydown == KEY_A or keydown == KEY_LEFT then
		Interface_TradeBox_Page(playerid,-1);
	elseif keydown == KEY_D or keydown == KEY_RIGHT then
		Interface_TradeBox_Page(playerid,1);
	elseif keydown == KEY_LCONTROL or keydown == KEY_RCONTROL then
		Interface_TradeBox_Event(playerid);
	elseif keydown == KEY_TAB then
		Interface_TradeBox_Active(playerid);
	end
end

function  Interface_TradeBox_InventoryRowIndex(playerid)
	return (player[playerid].page-1)*inventory_window.rownumber+player[playerid].row;
end

function  Interface_TradeBox_TradeRowIndex(playerid)
	return player[playerid].row;
end

function  Interface_TradeBox_AcceptIndex(playerid)
	return player[playerid].row;
end

function  Interface_TradeBox_InventoryActive(playerid)
	player[playerid].row=0;	
	if Character_Trade_InventoryNumber(playerid)~=0 then
		GDraw.color(inventory_window.row[playerid][0].name,255,255,0);
		GDraw.color(inventory_window.row[playerid][0].value,255,255,0);
		GDraw.color(inventory_window.row[playerid][0].amount,255,255,0);
	end
	HideTexture(playerid,inventory_window.passive_texture);
	ShowTexture(playerid,inventory_window.active_texture);
	player[playerid].active_texture="inventory";
end

function  Interface_TradeBox_InventoryPassive(playerid)
	if Character_Trade_InventoryNumber(playerid)~=0 then
		GDraw.color(inventory_window.row[playerid][player[playerid].row].name,255,255,255);
		GDraw.color(inventory_window.row[playerid][player[playerid].row].value,255,255,255);
		GDraw.color(inventory_window.row[playerid][player[playerid].row].amount,255,255,255);
	end
	HideTexture(playerid,inventory_window.active_texture);
	ShowTexture(playerid,inventory_window.passive_texture);
end

function  Interface_TradeBox_TradeActive(playerid)
	player[playerid].row=0;		
	if Character_Trade_GiveInventoryNumber(playerid)~=0 then
		GDraw.color(trade_window.row[playerid][0].name,255,255,0);
		GDraw.color(trade_window.row[playerid][0].amount,255,255,0);
	end
		
	HideTexture(playerid,trade_window.passive_texture);
	ShowTexture(playerid,trade_window.active_texture);	
		
	player[playerid].active_texture="trade";
end

function  Interface_TradeBox_TradePassive(playerid)
	if Character_Trade_GiveInventoryNumber(playerid)~=0 then
		GDraw.color(trade_window.row[playerid][player[playerid].row].name,255,255,255);
		GDraw.color(trade_window.row[playerid][player[playerid].row].amount,255,255,255);
	end
	HideTexture(playerid,trade_window.active_texture);
	ShowTexture(playerid,trade_window.passive_texture);
end

function  Interface_TradeBox_AcceptActive(playerid)
	player[playerid].row=0;

	HideTexture(playerid,accept_window.passive_texture);
	ShowTexture(playerid,accept_window.active_texture);		
	GDraw.color(accept_window.text[playerid],255,255,0);
	
	HideTexture(playerid,cancel_window.passive_texture);
	ShowTexture(playerid,cancel_window.active_texture);		
	GDraw.color(cancel_window.text[playerid],255,255,255);
	
	player[playerid].active_texture="accept";
end

function  Interface_TradeBox_AcceptPassive(playerid)
	HideTexture(playerid,accept_window.active_texture);
	ShowTexture(playerid,accept_window.passive_texture);	
	GDraw.color(accept_window.text[playerid],255,255,255);
	
	HideTexture(playerid,cancel_window.active_texture);
	ShowTexture(playerid,cancel_window.passive_texture);	
	GDraw.color(cancel_window.text[playerid],255,255,255);
end