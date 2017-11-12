local kickMessage="Kick: %s cheat";
local kickLog="Kick: %s use %s cheat. Currently: %d, New: %d"

function Anticheat_Strength(playerid, newStrength)
	return Anticheat_Check(playerid, newStrength, GCharacter.GetStrength, "Strength");
end

function Anticheat_Dexterity(playerid, newDexterity)
	return Anticheat_Check(playerid, newDexterity, GCharacter.GetDexterity, "Dexterity");
end

function Anticheat_Health(playerid, newHealth)
	if Player_Is(playerid) then
		local account=Player_GetAccount(playerid);
		local character=GPlayer.GetCharacter(account);
		
		if character~=nil and (not GPlayer.IsBusy(account)) then
			local MaxHealth=GCharacter.GetMaxHealth(character);
			
			if MaxHealth<newHealth then
				Anticheat_Kick(character,"Health");
				return true;
			end
		end
	end
	
	return false;
end

function Anticheat_MaxHealth(playerid, newMaxHealth)
	return Anticheat_Check(playerid, newMaxHealth, GCharacter.GetMaxHealth, "MaxHealth");
end

function Anticheat_Mana(playerid, newMana)
	if Player_Is(playerid) then
		local account=Player_GetAccount(playerid);
		local character=GPlayer.GetCharacter(account);
		
		if character~=nil then
			local MaxMana=GCharacter.GetMaxMana(character);
			
			if MaxMana<newMana then
				Anticheat_Kick(character,"Mana");
				return true;
			end
		end
	end
	
	return false;
end

function Anticheat_MaxMana(playerid, newMaxMana)
	return Anticheat_Check(playerid, newMaxMana, GCharacter.GetMaxMana, "MaxMana");
end

function Anticheat_SkillWeapon(playerid, skillId, newSkillWeapon)	
	if skillId==SKILL_1H then
		return Anticheat_Check(playerid, newSkillWeapon, GCharacter.GetOneHand, "OneHand");
	elseif skillId==SKILL_2H then
		return Anticheat_Check(playerid, newSkillWeapon, GCharacter.GetTwoHand, "TwoHand");
	elseif skillId==SKILL_BOW then
		return Anticheat_Check(playerid, newSkillWeapon, GCharacter.GetBow, "Bow");
	elseif skillId==SKILL_CBOW then
		return Anticheat_Check(playerid, newSkillWeapon, GCharacter.GetCrossBow, "CrossBow");
	end
	
	return false;
end

function Anticheat_Acrobatic(playerid, newAcrobatic)
	return Anticheat_Check(playerid, newAcrobatic, GCharacter.GetAcrobatic, "Acrobatic");
end

function Anticheat_Gold(playerid, newGold)
	if Player_Is(playerid) then
		local account=Player_GetAccount(playerid);
		local character=GPlayer.GetCharacter(account);
		
		if character~=nil and (not GPlayer.IsDead(account)) then
			local currGold=GCharacter.GetGold(character);
			if currGold~=newGold then
				GCharacter.SetGold(character,currGold);
				Anticheat_Kick(character,"Gold",currGold,newGold);
				return true;
			end
		end
	end
	
	return false;
end

function Anticheat_Check(playerid, newValue, checkFunction, statName)
	if Player_Is(playerid) then
		local account=Player_GetAccount(playerid);
		local character=GPlayer.GetCharacter(account);
		
		if character~=nil and (not GPlayer.IsDead(account)) then
			local currValue=checkFunction(character);
			if currValue~=newValue then
				Anticheat_Kick(character,statName,currValue,newValue);
				return true;
			end
		end
	end
	
	return false;
end

function Anticheat_Kick(character,statName,current,new)
	local playerid=GCharacter.GetId(character);
	local message=string.format(kickLog, GCharacter.GetName(character), statName,current,new);

	SendPlayerMessage(playerid, 255, 128, 0, string.format(kickMessage, statName));
	Log_Player(playerid, message);
	Admin_AllAdminMessage(message);
	Kick(playerid);
end
