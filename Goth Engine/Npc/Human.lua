
local human={};
local human_number=0;

local human_key_distance=350;

function Human_Init()
	local handler=MySQL_Get();
	if handler~=nil then
		Human_Quest_Init();
		
		local servername=Setting_GetServerName();
		local humans=mysql_query(handler,string.format("SELECT `humanname`,`immortal`,`bodyform`,`bodyid`,`headform`,`headid`,`fatness`,`red`,`green`,`blue`,`lvl`,`hp`,`mana`,`str`,`dex`,`oneh`,`twoh`,`bow`,`cbow`,`armor`,`meele`,`ranged`,`event`,`x`,`y`,`z`,`angle` FROM `human` WHERE `servername`=%q",servername));
		if humans then
			local i=0;
			for humans,man in mysql_rows_assoc(humans) do
				local id=CreateNPC(man['humanname']);
				human[id]={};
				SetPlayerAdditionalVisual(id,man['bodyform'],tonumber(man['bodyid']),man['headform'],tonumber(man['headid']));
				SetPlayerFatness(id,tonumber(man['fatness']));
				SetPlayerColor(id,tonumber(man['red']),tonumber(man['green']),tonumber(man['blue']));
				
				if tonumber(man['immortal'])==1 then
					human[id].immortal=true;
					SetPlayerHealth(id,9999);
					SetPlayerMaxHealth(id,9999);
				else
					human[id].immortal=false;
					SetPlayerMaxHealth(id,tonumber(man['hp']));
					SetPlayerHealth(id,tonumber(man['hp']));
				end
				
				SetPlayerLevel(id,tonumber(man['lvl']));
				SetPlayerMaxMana(id,tonumber(man['mana']));
				SetPlayerMana(id,tonumber(man['mana']));
				SetPlayerStrength(id,tonumber(man['str']));
				SetPlayerDexterity(id,tonumber(man['dex']));
				
				SetPlayerSkillWeapon(id,SKILL_1H,tonumber(man['oneh']));
				SetPlayerSkillWeapon(id,SKILL_2H,tonumber(man['twoh']));
				SetPlayerSkillWeapon(id,SKILL_BOW,tonumber(man['bow']));
				SetPlayerSkillWeapon(id,SKILL_CBOW,tonumber(man['cbow']));
				
				human[id].maxhp=tonumber(man['hp']);
				human[id].x=tonumber(man['x']);
				human[id].y=tonumber(man['y']);
				human[id].z=tonumber(man['z']);
				human[id].angle=tonumber(man['angle']);
				
				EquipArmor(id,tostring(man['armor']));
				EquipMeleeWeapon(id,tostring(man['meele']));
				EquipRangedWeapon(id,tostring(man['ranged']));

				SpawnPlayer(id);
				SetPlayerPos(id,human[id].x,human[id].y,human[id].z);
				SetPlayerAngle(id,human[id].angle);
				
				if _G[man['event']]~=nil then
					human[id].event=_G[man['event']](id);
				end
				
				Log_System(string.format("Human: %s (id: %d)",man['humanname'],id));
				i=i+1;
			end
			human_number=i;
			Log_System(string.format("Human: %d",human_number));
			
			Respawn_AddText(string.format("%s people live on the island.",human_number),2100,"Font_Old_20_White_Hi.TGA");
			
			mysql_free_result(humans);
		else
			Log_System("Human: Database lost.");
		end
	else
		Log_System("Human: Database lost.");
	end
end

function Human_Is(id)
	if id==nil then
		return false;
	end
	
	return human[id]~=nil;
end

function Human_Spawn(playerid)
	if Human_Is(playerid) then
		SetPlayerPos(playerid,human[playerid].x,human[playerid].y,human[playerid].z);
		SetPlayerAngle(playerid,human[playerid].angle);
	end
end

function Human_Hit(playerid)
	if Human_Is(playerid) and human[playerid].immortal==true then
		SetPlayerHealth(playerid,GetPlayerMaxHealth(playerid));
	end
end

function Human_Focus(playerid, focusid)
	local account=Player_GetAccount(playerid);
	
	if GPlayer.IsLoginCharacter(account) then
		if focusid~=nil and human[focusid]~=nil and human[focusid].event~=nil then
			SetPlayerEnable_OnPlayerKey(playerid,1);	
		else
			SetPlayerEnable_OnPlayerKey(playerid,0);
		end
	end
end

function Human_Key(playerid, keydown)
	local npcid=GetFocus(playerid);
	if Human_Is(npcid) then		
		if Human_Trainer_Active(playerid) then
			Human_Trainer_Key(playerid,keydown);
		elseif Human_Vendor_Active(playerid) then
			Human_Vendor_Key(playerid,keydown);
		elseif keydown == KEY_LCONTROL and GetDistancePlayers(playerid,npcid)<human_key_distance and (not Character_Party_IsInvitee(playerid)) then
			PlayAnimation(playerid,"S_FISTRUN");
			human[npcid].event(playerid,npcid);
		end
	end
end

function Human_Logout(playerid)
	Human_Trainer_Logout(playerid);
	Human_Quest_Logout(playerid);
	Human_Speech_Logout(playerid);
	Human_Vendor_Logout(playerid);
end