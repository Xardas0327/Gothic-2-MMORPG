GPlayer = {};
GPlayer.__index = GPlayer;

local busyHealth=9999;

function GPlayer_GetBusyHealth()
	return busyHealth;
end

function GPlayer.new(id,name)
	local self = setmetatable({}, GPlayer);
	
	self.id=id;
	self.accname=name;
	self.character=nil;
	self.busy=false;
	self.dead=false;
	self.admin=false;
	
	SetPlayerName(id,name);
	
	return self;
end

function GPlayer.GetId(self)
	return self.id;
end

function GPlayer.GetAccountName(self)
	return self.accname;
end

function GPlayer.GetCharacter(self)
	return self.character;
end

function GPlayer.LoginCharacter(self,name)
	self.character=GCharacter.new(self.id,name);
end

function GPlayer.LogoutCharacter(self)
	self.character=nil;
	self.dead=false;
	SetPlayerName(self.id,self.accname);
end

function GPlayer.IsLoginCharacter(self)
	return self.character~=nil;
end

function GPlayer.SetBusy(self,busy)
	self.busy=busy;
	
	if busy then
		FreezePlayer(self.id, 1);
		SetPlayerHealth(self.id,busyHealth);
	else
		if self.character~=nil then
			local hp=GCharacter.GetHealth(self.character);
			SetPlayerHealth(self.id,hp)
		end
		FreezePlayer(self.id, 0);
	end
end

function GPlayer.IsBusy(self)
	return self.busy;
end

function GPlayer.PlayerHit(self)
	if self.busy then
		SetPlayerHealth(self.id,busyHealth);
	end
end

function GPlayer.SetDead(self,dead)
	self.dead=dead;
end

function GPlayer.IsDead(self)
	return self.dead;
end

function GPlayer.SetAdmin(self,value)
	self.admin=value;
end

function GPlayer.IsAdmin(self)
	return self.admin;
end