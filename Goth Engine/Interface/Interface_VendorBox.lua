
local vendor_window={};
vendor_window.x=4000;
vendor_window.y=2400;
vendor_window.active_texture=nil;
vendor_window.passive_texture=nil;
vendor_window.title={};
vendor_window.rownumber=11;
vendor_window.row={};

local receive_rownumber=8;
local receive_window={};
receive_window.x=vendor_window.x;
receive_window.y=vendor_window.y+2900;
receive_window.active_texture=nil;
receive_window.passive_texture=nil;
receive_window.name=nil;
receive_window.title={};
receive_window.row={};
receive_window.item={};
receive_window.gold={};
receive_window.value={};

local player={};

function Interface_VendorBox_Init()
	vendor_window.active_texture=CreateTexture(vendor_window.x,vendor_window.y,vendor_window.x+3500,vendor_window.y+2500,"Frame_GMPA.TGA");
	vendor_window.passive_texture=CreateTexture(vendor_window.x,vendor_window.y,vendor_window.x+3500,vendor_window.y+2500,"DLG_CONVERSATION.TGA");
	vendor_window.title[0]=GDraw.new(vendor_window.x+100,vendor_window.y+200,"Name","Font_Old_10_White_Hi.TGA",255,255,255);
	vendor_window.title[1]=GDraw.new(vendor_window.x+2900,vendor_window.y+200,"Value","Font_Old_10_White_Hi.TGA",255,255,255);
	
	receive_window.active_texture=CreateTexture(receive_window.x,receive_window.y,receive_window.x+3000,receive_window.y+2000,"Frame_GMPA.TGA");
	receive_window.passive_texture=CreateTexture(receive_window.x,receive_window.y,receive_window.x+3000,receive_window.y+2000,"DLG_CONVERSATION.TGA");
	receive_window.name=GDraw.new(receive_window.x+100,receive_window.y-225,"Receive","Font_Old_20_White_Hi.TGA",255,255,255);
	receive_window.title[0]=GDraw.new(receive_window.x+100,receive_window.y+200,"Name","Font_Old_10_White_Hi.TGA",255,255,255);
	receive_window.title[1]=GDraw.new(receive_window.x+2400,receive_window.y+200,"Amount","Font_Old_10_White_Hi.TGA",255,255,255);
	
	for i = 0, GetMaxPlayers() - 1 do
		vendor_window.row[i]={};
		for j=0, vendor_window.rownumber-1 do
			vendor_window.row[i][j]={};
			vendor_window.row[i][j].name=GDraw.new(vendor_window.x+100,vendor_window.y+200+(j+1)*150,"","Font_Old_10_White_Hi.TGA",255,255,255);
			vendor_window.row[i][j].value=GDraw.new(vendor_window.x+2900,vendor_window.y+200+(j+1)*150,"","Font_Old_10_White_Hi.TGA",255,255,255);
		end
		
		receive_window.item[i]=GDraw.new(receive_window.x+100,receive_window.y+200+(receive_rownumber+2)*150,"Item: 0/8","Font_Old_10_White_Hi.TGA",255,255,255);
		receive_window.gold[i]=GDraw.new(receive_window.x+1000,receive_window.y+200+(receive_rownumber+2)*150,"Gold: 0","Font_Old_10_White_Hi.TGA",255,255,255);
		receive_window.value[i]=GDraw.new(receive_window.x+2000,receive_window.y+200+(receive_rownumber+2)*150,"Value: 0","Font_Old_10_White_Hi.TGA",255,255,255);
		
		receive_window.row[i]={};
		for j=0, receive_rownumber-1 do			
			receive_window.row[i][j]={};
			receive_window.row[i][j].name=GDraw.new(receive_window.x+100,receive_window.y+200+(j+1)*150,"","Font_Old_10_White_Hi.TGA",255,255,255);
			receive_window.row[i][j].amount=GDraw.new(receive_window.x+2400,receive_window.y+200+(j+1)*150,"","Font_Old_10_White_Hi.TGA",255,255,255);
		end
		
		player[i]={};
		player[i].active_texture=""; --value: inventory,vendor,give,take,accept
		player[i].row=0;
		player[i].takenumber=0;
	end
	Interface_TradeBox_Init();
	Human_Vendor_Init_Box(Interface_VendorBox_Show,Interface_VendorBox_Refresh,Interface_VendorBox_TakeRefresh,Interface_VendorBox_ValueRefresh,Interface_VendorBox_Hide,Interface_VendorBox_Key);
	Human_Vendor_MaxItem(vendor_window.rownumber,receive_rownumber);
	Help_AddHelp("vendor","You can move w,a,s,d (or arrow).");
	Help_AddHelp("vendor","Selected is CTRL and window change is TAB.");
end

function Interface_VendorBox_Show(playerid)
	player[playerid].active_texture="inventory";
	Interface_TradeBox_Show(playerid);
	Interface_Npcname_Show(playerid,vendor_window.x+100,vendor_window.y-225)
	
	ShowTexture(playerid,vendor_window.passive_texture);
	for i=0,1 do
		ShowDraw(playerid,GDraw.id(vendor_window.title[i]));
	end
	
	ShowTexture(playerid,receive_window.passive_texture);
	ShowDraw(playerid,GDraw.id(receive_window.name));
	ShowDraw(playerid,GDraw.id(receive_window.item[playerid]));
	ShowDraw(playerid,GDraw.id(receive_window.gold[playerid]));
	ShowDraw(playerid,GDraw.id(receive_window.value[playerid]));
	for i=0,1 do
		ShowDraw(playerid,GDraw.id(receive_window.title[i]));
	end
end

function Interface_VendorBox_Refresh(playerid)
	player[playerid].takenumber=0;
	for i=0,Human_Vendor_ItemNumber(playerid)-1 do
		local item=Human_Vendor_Item(playerid,i);
		GDraw.message_color(vendor_window.row[playerid][i].name,item.name,255,255,255);
		GDraw.message_color(vendor_window.row[playerid][i].value,tostring(item.value),255,255,255);
		ShowDraw(playerid,GDraw.id(vendor_window.row[playerid][i].name));
		ShowDraw(playerid,GDraw.id(vendor_window.row[playerid][i].value));
	end
	GDraw.message(receive_window.item[playerid],string.format("Item: 0/%d",receive_rownumber));
	GDraw.message(receive_window.gold[playerid],"Gold: 0");
	GDraw.message(receive_window.value[playerid],"Value: 0");
	Interface_VendorBox_TakeRefresh(playerid);
end

function Interface_VendorBox_TakeRefresh(playerid)
	local takenumber=Human_Vendor_TakeInventoryNumber(playerid);
	if player[playerid].takenumber>takenumber then
		while player[playerid].takenumber~=takenumber do
			player[playerid].takenumber=player[playerid].takenumber-1;
			HideDraw(playerid,GDraw.id(receive_window.row[playerid][ player[playerid].takenumber ].name));
			HideDraw(playerid,GDraw.id(receive_window.row[playerid][ player[playerid].takenumber ].amount));
		end
	elseif player[playerid].takenumber<takenumber then
		while player[playerid].takenumber~=takenumber do
			ShowDraw(playerid,GDraw.id(receive_window.row[playerid][ player[playerid].takenumber ].name));
			ShowDraw(playerid,GDraw.id(receive_window.row[playerid][ player[playerid].takenumber ].amount));
			player[playerid].takenumber=player[playerid].takenumber+1;
		end
	end
	if takenumber~=0 then
		for i=0, takenumber-1 do
			local item=Human_Vendor_TakeInventoryItem(playerid,i);
			GDraw.message_color(receive_window.row[playerid][i].name,item.name,255,255,255);
			GDraw.message_color(receive_window.row[playerid][i].amount,tostring(item.amount),255,255,255);	
		end
		if player[playerid].active_texture=="take" then
			if player[playerid].row>=takenumber then
				player[playerid].row=takenumber-1;
			end
			GDraw.color(receive_window.row[playerid][player[playerid].row].name,255,255,0);
			GDraw.color(receive_window.row[playerid][player[playerid].row].amount,255,255,0);	
		end
	end
	GDraw.message(receive_window.item[playerid],string.format("Item: %d/%d",takenumber,receive_rownumber));
end

function Interface_VendorBox_ValueRefresh(playerid)
	GDraw.message(receive_window.gold[playerid],string.format("Gold: %d",Human_Vendor_TakeInventoryGold(playerid)));
	GDraw.message(receive_window.value[playerid],string.format("Value: %d",Human_Vendor_TakeInventoryValue(playerid)));
end

function Interface_VendorBox_Move(playerid,move)
	if player[playerid].active_texture=="inventory" or player[playerid].active_texture=="give" then
		Interface_TradeBox_Move(playerid,move);
	elseif player[playerid].active_texture=="vendor" then
		local new=player[playerid].row+move;
		
		local itemNumber=Human_Vendor_ItemNumber(playerid);
		
		if new<0 then
			new=itemNumber-1;
		end
		
		if new>=itemNumber then
			new=0;
		end

		GDraw.color(vendor_window.row[playerid][new].name,255,255,0);
		GDraw.color(vendor_window.row[playerid][new].value,255,255,0);
				
		GDraw.color(vendor_window.row[playerid][ player[playerid].row ].name,255,255,255);
		GDraw.color(vendor_window.row[playerid][ player[playerid].row ].value,255,255,255);
				
		player[playerid].row=new;
		
	elseif player[playerid].active_texture=="take" then
		local new=player[playerid].row+move;
		
		local itemNumber=player[playerid].takenumber;
		
		if new<0 then
			new=itemNumber-1;
		end
		
		if new>=itemNumber then
			new=0;
		end
		
		GDraw.color(receive_window.row[playerid][new].name,255,255,0);
		GDraw.color(receive_window.row[playerid][new].amount,255,255,0);
				
		GDraw.color(receive_window.row[playerid][ player[playerid].row ].name,255,255,255);
		GDraw.color(receive_window.row[playerid][ player[playerid].row ].amount,255,255,255);
				
		player[playerid].row=new;
	end
end

function Interface_VendorBox_Hide(playerid)
	Interface_TradeBox_Hide(playerid);	
	Interface_Npcname_Hide(playerid);
	HideTexture(playerid,vendor_window.active_texture);
	HideTexture(playerid,vendor_window.passive_texture);
	for i=0,Human_Vendor_ItemNumber(playerid)-1 do
		HideDraw(playerid,GDraw.id(vendor_window.row[playerid][i].name));
		HideDraw(playerid,GDraw.id(vendor_window.row[playerid][i].value));
	end
	for i=0,1 do
		HideDraw(playerid,GDraw.id(vendor_window.title[i]));
	end
	
	HideTexture(playerid,receive_window.active_texture);
	HideTexture(playerid,receive_window.passive_texture);
	HideDraw(playerid,GDraw.id(receive_window.name));
	HideDraw(playerid,GDraw.id(receive_window.item[playerid]));
	HideDraw(playerid,GDraw.id(receive_window.gold[playerid]));
	HideDraw(playerid,GDraw.id(receive_window.value[playerid]));
	for i=0,1 do
		HideDraw(playerid,GDraw.id(receive_window.title[i]));
	end
		
	for i=0,player[playerid].takenumber-1 do
		HideDraw(playerid,GDraw.id(receive_window.row[playerid][i].name));
		HideDraw(playerid,GDraw.id(receive_window.row[playerid][i].amount));
	end
end
function Interface_VendorBox_Active(playerid)
	if player[playerid].active_texture=="inventory" then
		Interface_TradeBox_InventoryPassive(playerid);
		Interface_VendorBox_VendorActive(playerid);
		player[playerid].active_texture="vendor";
		
	elseif player[playerid].active_texture=="vendor" then
		Interface_TradeBox_TradeActive(playerid);
		Interface_VendorBox_VendorPassive(playerid);
		player[playerid].active_texture="give";
		
	elseif player[playerid].active_texture=="give" then
		Interface_TradeBox_TradePassive(playerid);
		Interface_VendorBox_TakeActive(playerid);
		player[playerid].active_texture="take";
	
	elseif player[playerid].active_texture=="take" then
		Interface_VendorBox_TakePassive(playerid);
		Interface_TradeBox_AcceptActive(playerid);
		player[playerid].active_texture="accept";
	elseif player[playerid].active_texture=="accept" then
		Interface_TradeBox_InventoryActive(playerid);
		Interface_TradeBox_AcceptPassive(playerid);
		player[playerid].active_texture="inventory"
	end
end

function Interface_VendorBox_Event(playerid)
	if player[playerid].active_texture=="inventory" or player[playerid].active_texture=="give" then
		if player[playerid].active_texture=="inventory" then
			Human_Vendor_GiveRefresh(playerid,Interface_TradeBox_InventoryRowIndex(playerid),1);
		else
			Human_Vendor_GiveRefresh(playerid,Interface_TradeBox_TradeRowIndex(playerid),-1);
		end
	elseif player[playerid].active_texture=="vendor" or player[playerid].active_texture=="take" then
		if player[playerid].active_texture=="vendor" then
			Human_Vendor_TakeRefresh(playerid,player[playerid].row,1);
		else
			Human_Vendor_TakeRefresh(playerid,player[playerid].row,-1);
		end
	elseif player[playerid].active_texture=="accept" then
		if Interface_TradeBox_AcceptIndex(playerid)==0 then
			Human_Vendor_Accept(playerid);
		else
			Human_Vendor_Hide(playerid);
		end
	end
end

function Interface_VendorBox_Key(playerid,keydown)
	if keydown == KEY_W or keydown == KEY_UP then
		Interface_VendorBox_Move(playerid,-1);
	elseif keydown == KEY_S or keydown == KEY_DOWN then
		Interface_VendorBox_Move(playerid,1);
	elseif (keydown == KEY_A or keydown == KEY_LEFT) and (player[playerid].active_texture=="inventory" or player[playerid].active_texture=="accept") then
		Interface_TradeBox_Page(playerid,-1);
	elseif (keydown == KEY_D or keydown == KEY_RIGHT) and (player[playerid].active_texture=="inventory" or player[playerid].active_texture=="accept") then
		Interface_TradeBox_Page(playerid,1);
	elseif keydown == KEY_LCONTROL or keydown == KEY_RCONTROL then
		Interface_VendorBox_Event(playerid);
	elseif keydown == KEY_TAB then
		Interface_VendorBox_Active(playerid);
	end
end

function  Interface_VendorBox_VendorActive(playerid)
	player[playerid].row=0;	
	if Human_Vendor_ItemNumber(playerid)~=0 then
		GDraw.color(vendor_window.row[playerid][0].name,255,255,0);
		GDraw.color(vendor_window.row[playerid][0].value,255,255,0);
	end
	HideTexture(playerid,vendor_window.passive_texture);
	ShowTexture(playerid,vendor_window.active_texture);
end

function  Interface_VendorBox_VendorPassive(playerid)
	if Human_Vendor_ItemNumber(playerid)~=0 then
		GDraw.color(vendor_window.row[playerid][ player[playerid].row ].name,255,255,255);
		GDraw.color(vendor_window.row[playerid][ player[playerid].row ].value,255,255,255);
	end
	HideTexture(playerid,vendor_window.active_texture);
	ShowTexture(playerid,vendor_window.passive_texture);
end

function  Interface_VendorBox_TakeActive(playerid)
	player[playerid].row=0;	
	if Human_Vendor_TakeInventoryNumber(playerid)~=0 then
		GDraw.color(receive_window.row[playerid][0].name,255,255,0);
		GDraw.color(receive_window.row[playerid][0].amount,255,255,0);
	end
	HideTexture(playerid,receive_window.passive_texture);
	ShowTexture(playerid,receive_window.active_texture);
end

function  Interface_VendorBox_TakePassive(playerid)
	if Human_Vendor_TakeInventoryNumber(playerid)~=0 then
		GDraw.color(receive_window.row[playerid][player[playerid].row].name,255,255,255);
		GDraw.color(receive_window.row[playerid][player[playerid].row].amount,255,255,255);
	end
	HideTexture(playerid,receive_window.active_texture);
	ShowTexture(playerid,receive_window.passive_texture);
end