function Npc_Is(id)
	if id==nil then
		return false;
	end
	
	return Human_Is(id) or Monster_Is(id);
end