GCharacter = {};
GCharacter.__index = GCharacter;

function GCharacter.new(playerid,charactername)
	local self = setmetatable({}, GCharacter);
	
	self.id=playerid;
	self.name=charactername;
	
	self.lvl=0;
	self.xp=0;
	self.nextXp=500;
	self.lp=0;
	self.mc=0;
	
	self.str=10;
	self.dex=10;
	self.hp=40;
	self.maxHp=40;
	self.mana=10;
	self.maxMana=10;
	
	self.ohand=10;
	self.thand=10;
	self.bow=10;
	self.cbow=10;
	
	self.acrobatic=0;
	
	self.gold=0;

	SetPlayerName(playerid,charactername);
	
	return self;
end

function GCharacter.GetId(self)
	return self.id;
end

function GCharacter.GetName(self)
	return self.name;
end

function GCharacter.GetLevel(self)
	return self.lvl;
end

function GCharacter.SetLevel(self,lvl)
	self.lvl=lvl;
	SetPlayerLevel(self.id,lvl);
end

function GCharacter.GetMagicCircle(self)
	return self.mc;
end

function GCharacter.SetMagicCircle(self,mc)
	self.mc=mc;
	SetPlayerMagicLevel(self.id,mc);
end

function GCharacter.GetXp(self)
	return self.xp;
end

function GCharacter.SetXp(self,xp)
	self.xp=xp;
	SetPlayerExperience(self.id,xp);
end

function GCharacter.GetXpNextLvl(self)
	return self.nextXp;
end

function GCharacter.SetXpNextLvl(self,nextXp)
	self.nextXp=nextXp;
	SetPlayerExperienceNextLevel(self.id,nextXp);
end

function GCharacter.GetLearnPoint(self)
	return self.lp;
end

function GCharacter.SetLearnPoint(self,lp)
	self.lp=lp;
	SetPlayerLearnPoints(self.id,lp);
end

function GCharacter.GetStrength(self)
	return self.str;
end

function GCharacter.SetStrength(self,str)
	self.str=str;
	SetPlayerStrength(self.id,str);
end

function GCharacter.GetDexterity(self)
	return self.dex;
end

function GCharacter.SetDexterity(self,dex)
	self.dex=dex;
	SetPlayerDexterity(self.id,dex);
end

function GCharacter.GetHealth(self)
	return self.hp;
end

function GCharacter.SetHealth(self,hp)
	self.hp=hp;
	SetPlayerHealth(self.id,hp);
end

function GCharacter.ChangeHealth(self,hp)
	self.hp=hp;
end

function GCharacter.GetMaxHealth(self)
	return self.maxHp;
end

function GCharacter.SetMaxHealth(self,maxHp)
	self.maxHp=maxHp;
	SetPlayerMaxHealth(self.id,maxHp);
end

function GCharacter.GetMana(self)
	return self.mana;
end

function GCharacter.SetMana(self,mana)
	self.mana=mana;
	SetPlayerMana(self.id,mana);
end

function GCharacter.ChangeMana(self,mana)
	self.mana=mana;
end

function GCharacter.GetMaxMana(self)
	return self.maxMana;
end

function GCharacter.SetMaxMana(self,maxMana)
	self.maxMana=maxMana;
	SetPlayerMaxMana(self.id,maxMana);
end

function GCharacter.GetOneHand(self)
	return self.ohand;
end

function GCharacter.SetOneHand(self,ohand)
	self.ohand=ohand;
	SetPlayerSkillWeapon(self.id,SKILL_1H,ohand);
end

function GCharacter.GetTwoHand(self)
	return self.thand;
end

function GCharacter.SetTwoHand(self,thand)
	self.thand=thand;
	SetPlayerSkillWeapon(self.id,SKILL_2H,thand);
end

function GCharacter.GetBow(self)
	return self.bow;
end

function GCharacter.SetBow(self,bow)
	self.bow=bow;
	SetPlayerSkillWeapon(self.id,SKILL_BOW,bow);
end

function GCharacter.GetCrossBow(self)
	return self.cbow;
end

function GCharacter.SetCrossBow(self,cbow)
	self.cbow=cbow;
	SetPlayerSkillWeapon(self.id,SKILL_CBOW,cbow);
end

function GCharacter.GetAcrobatic(self)
	return self.acrobatic;
end

function GCharacter.SetAcrobatic(self,acrobatic)
	self.acrobatic=acrobatic;
	SetPlayerAcrobatic(self.id,acrobatic);
end

function GCharacter.GetGold(self)
	return self.gold;
end

function GCharacter.SetGold(self,gold)
	self.gold=gold;
end