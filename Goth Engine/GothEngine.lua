require ("Goth Engine/System/Admin")
require ("Goth Engine/System/Animation")
require ("Goth Engine/System/Anticheat")
require ("Goth Engine/System/Camera")
require ("Goth Engine/System/Character_Body")
require ("Goth Engine/System/GCharacter")
require ("Goth Engine/System/GDraw")
require ("Goth Engine/System/GPlayer")
require ("Goth Engine/System/Help")
require ("Goth Engine/System/Item")
require ("Goth Engine/System/Log")
require ("Goth Engine/System/Loot")
require ("Goth Engine/System/MySQL")
require ("Goth Engine/System/Player")
require ("Goth Engine/System/Respawn")
require ("Goth Engine/System/RPChat")
require ("Goth Engine/System/Setting")
require ("Goth Engine/System/Time")

require ("Goth Engine/Interface/Interface_AccountMenu")
require ("Goth Engine/Interface/Interface_CharacterMenu")
require ("Goth Engine/Interface/Interface_CharacterMenu_Option")
require ("Goth Engine/Interface/Interface_CharacterMenu_DeleteDialog")
require ("Goth Engine/Interface/Interface_CharacterMenu_Create")
require ("Goth Engine/Interface/Interface_Npcname")
require ("Goth Engine/Interface/Interface_TrainerBox")
require ("Goth Engine/Interface/Interface_TalkBox")
require ("Goth Engine/Interface/Interface_QuestBox")
require ("Goth Engine/Interface/Interface_Time")
require ("Goth Engine/Interface/Interface_TradeBox")
require ("Goth Engine/Interface/Interface_VendorBox")
require ("Goth Engine/Interface/Interface_PartyBox")
require ("Goth Engine/Interface/Interface_PartyBox_Offer")

require ("Goth Engine/Npc/Human")
require ("Goth Engine/Npc/Human_Guard")
require ("Goth Engine/Npc/Human_Quest")
require ("Goth Engine/Npc/Human_Speech")
require ("Goth Engine/Npc/Human_Trainer")
require ("Goth Engine/Npc/Human_Vendor")
require ("Goth Engine/Npc/Monster")
require ("Goth Engine/Npc/Npc")

require ("Goth Engine/Player/Account")
require ("Goth Engine/Player/Character")
require ("Goth Engine/Player/Character_Item")
require ("Goth Engine/Player/Character_Party")
require ("Goth Engine/Player/Character_Quest")
require ("Goth Engine/Player/Character_Spawn")
require ("Goth Engine/Player/Character_Stat")
require ("Goth Engine/Player/Character_Trade")

require ("Goth Engine/World/World_Item")

function Object_Init(servername)
	if MySQL_Online() then
		Interface_Init();
		Setting_SetServerName(servername);
		
		Item_Init();
		Character_Init();
		Human_Init();
		Monster_Init();
		World_Item_Init();
		Loot_Init();
		
		Respawn_AddText("The respawn time of the NPCs and players is same.",800,"Font_Old_20_White_Hi.TGA");
	end
end

function Interface_Init()
	Interface_AccountMenu_Init();
	Interface_CharacterMenu_Init();
	Interface_TrainerBox_Init();
	Interface_TalkBox_Init();
	Interface_QuestBox_Init();
	Interface_TradeBox_Init();
	Interface_VendorBox_Init();
	Interface_PartyBox_Init();
	Interface_Time_Init();
end

function OnPlayerConnect(playerid)
	Player_Init(playerid);
	Help_Connect(playerid);
end

function OnPlayerDisconnect(playerid, reason)
	Account_Disconnect(playerid,reason);
	RPChat_Disconnect(playerid);
end

function OnPlayerDeath(playerid, p_classid, killerid, k_classid)
	Character_Death(playerid);
	Monster_Death(playerid, killerid);
	Character_Quest_Kill(playerid, killerid);
end

function OnPlayerSpawn(playerid, classid)
	Player_Spawn(playerid);
	Account_Spawn(playerid);
	Monster_Spawn(playerid);
	Human_Spawn(playerid);
end

function OnPlayerCommandText(playerid, cmdtext)	
	Account_CommandText(playerid, cmdtext);
	Interface_CharacterMenu_CommandText(playerid, cmdtext)
	Character_CommandText(playerid, cmdtext);
	Character_Quest_CommandText(playerid, cmdtext);
	Character_Trade_CommandText(playerid, cmdtext);
	Character_Party_CommandText(playerid, cmdtext);
	Time_CommandText(playerid, cmdtext);
	RPChat_CommandText(playerid, cmdtext);
	Admin_CommandText(playerid, cmdtext);
	Animation_CommandText(playerid, cmdtext);
	Human_Trainer_CommandText(playerid, cmdtext);
	Human_Vendor_CommandText(playerid, cmdtext);
end

function OnPlayerText(playerid, text)
	RPChat_Send(playerid, text);
end

function OnPlayerKey(playerid, keydown, keyup)
	Interface_CharacterMenu_Key(playerid,keydown);
	Character_Quest_Key(playerid,keydown);
	Human_Key(playerid, keydown);
	Character_Trade_Key(playerid,keydown);
	Interface_PartyBox_Offer_Key(playerid,keydown);
end

function OnPlayerFocus(playerid, focusid)
	Human_Focus(playerid, focusid);
end

function OnPlayerHit(playerid, killerid)
	Player_Hit(playerid, killerid);
	Monster_Take_Damage(playerid, killerid);
	Human_Hit(playerid);
end

function OnPlayerTakeItem(playerid, itemID, item_instance, amount, x, y, z, worldName)
	World_Item_Take(itemID,item_instance, x, y, z)
	Character_Item_Take(playerid, item_instance, amount, itemID);
end

function OnPlayerDropItem(playerid, itemid, item_instance, amount, x, y, z, worldName)
	Character_Item_Drop(playerid, item_instance, amount);
end

function OnPlayerUseItem(playerid, item_instance, amount, hand)
	Character_Item_Use(playerid, item_instance, amount);
end

function OnPlayerChangeArmor(playerid, currArmor, oldArmor)
	Character_Item_EquippedItem(playerid, currArmor, oldArmor);
end

function OnPlayerChangeMeleeWeapon(playerid, currMelee, oldMelee)
	Character_Item_EquippedItem(playerid, currMelee, oldMelee);
end

function OnPlayerChangeRangedWeapon(playerid, currRanged, oldRanged)
	Character_Item_EquippedItem(playerid, currRanged, oldRanged);
end

function OnPlayerSpellSetup(playerid, spellInstance)
	Character_Item_SpellSetup(playerid, spellInstance);
end

function OnPlayerSpellCast(playerid, spellInstance)
	Character_Item_Cast(playerid, spellInstance);
end

function OnPlayerHasItem(playerid, item_instance, amount, equipped, checkid)
	Character_Item_CheckArrow(playerid,amount,checkid);
end

function OnPlayerChangeStrength(playerid, currStrength, oldStrength)
	Character_Stat_ChangeStrength(playerid, currStrength);
end

function OnPlayerChangeDexterity(playerid, currDexterity, oldDexterity)
	Character_Stat_ChangeDexterity(playerid, currDexterity);
end

function OnPlayerChangeHealth(playerid, currHealth, oldHealth)
	Character_Stat_ChangeHealth(playerid, currHealth);
end

function OnPlayerChangeMaxHealth(playerid, currMaxHealth, oldMaxHealth)
	Character_Stat_ChangeMaxHealth(playerid, currMaxHealth);
end

function OnPlayerChangeMana(playerid, currMana, oldMana)
	Character_Stat_ChangeMana(playerid, currMana);
end

function OnPlayerChangeMaxMana(playerid, currMaxMana, oldMaxMana)
	Character_Stat_ChangeMaxMana(playerid, currMaxMana);
end

function OnPlayerChangeSkillWeapon(playerid, skillID, currSkillAmount, oldSkillAmount)
	Character_Stat_ChangeSkillWeapon(playerid, skillId, currSkillAmount);
end

function OnPlayerChangeAcrobatic(playerid, currAcrobatic, oldAcrobatic)
	Character_Stat_ChangeAcrobatic(playerid, currAcrobatic);
end

function OnPlayerChangeGold(playerid, currGold, oldGold)
	Character_Item_ChangeGold(playerid, currGold);
end

--[[function OnGamemodeInit()
end]]

function OnFilterscriptExit()
end

function OnFilterscriptInit()
end

function OnGamemodeExit()
end

function OnPlayerChangeAdditionalVisual(playerid, currBodyModel, currBodyTexture, currHeadModel, currHeadTexture, oldBodyModel, oldBodyTexture, oldHeadModel, oldHeadTexture)
end

function OnPlayerChangeClass(playerid, classid)
end

function OnPlayerCloseInventory(playerid)
end

function OnPlayerChangeFatness(playerid, currFatness, oldFatness)
end

function OnPlayerChangeInstance(playerid, currInstance, oldInstance)
end

function OnPlayerChangeScience(playerid, scienceID, currScienceValue, oldScienceValue)
end

function OnPlayerChangeStrength(playerid, currStrength, oldStrength)
end

function OnPlayerChangeWalk(playerid, currWalk, oldWalk)
end

function OnPlayerChangeWorld(playerid, world)
end

function OnPlayerEnterWorld(playerid, world)
end

function OnPlayerMD5File(playerid, pathFile, hash)
end

function OnPlayerOpenInventory(playerid)
end

function OnPlayerResponseItem(playerid, slot, item_instance, amount, equipped)
end

function OnPlayerSelectClass(playerid, classid)
end

function OnPlayerStandUp(playerid, killerid)
end

function OnPlayerUnconscious(playerid, p_classid, killerid, k_classid)
end

function OnPlayerUpdate(playerid)
end

function OnPlayerWeaponMode(playerid, weaponmode)
end