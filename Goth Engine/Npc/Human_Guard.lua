function Human_Guard(id)
	local rand=random(10);
	if rand<5 then
		PlayAnimation(id,"S_LGUARD");  
	else
		PlayAnimation(id,"S_HGUARD");
	end
end