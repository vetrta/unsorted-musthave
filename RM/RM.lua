function FFA_SkillReady(skillName)
	for tab = 2, 4 do
		local totalCount = GetNumSkill(tab);
		if totalCount then
			for number = 1, totalCount do
				local name, rank, iconPath, mode, skillLV, point, totalPoint, energyType, learned = GetSkillDetail(tab,number);
				if name == skillName then
					local duration, remaining = GetSkillCooldown(tab,number);
					if remaining <1 then
						return true
					else
						return false
					end
				end
			end
		end
	end
end

function FFA_SearchDebuff(target,debuffName)
	local i = 1;
	local r = false;
	while(UnitDebuff(target,i) ~= nil)do
		if(UnitDebuff(target,i) == debuffName) then
			r = true
		end
		i = i + 1
	end
	return r
end

function SkillReady(skillName)
    x = 1;
    while(x <= 5)do
        totalCount = GetNumSkill(x);
        if(totalCount)then
            y = 1;
            while(y <= totalCount) do
                if GetSkillDetail(x, y) == skillName then
                    totalSR, remainingSR = GetSkillCooldown(x, y);
					return remainingSR
                end
                y = y + 1;
            end
        end
        x = x + 1;
    end
	return 999
end

function SearchBuff(player,buffName)
    local i = 1;
    local r = false;
    while(UnitBuff(player,i) ~= nil)do
        if(UnitBuff(player,i) == buffName)then
            r = true;
        end;
        i = i + 1;
    end;
    return r;
end;

function FFA_SearchBuffTime(target,buffName)
	local i = 1;
	local Buf_time = 0;
	while UnitBuff(target,i)~=nil do
		if UnitBuff(target,i)== buffName then
			Buf_time = UnitBuffLeftTime(target,i)
		end
		i = i + 1
	end
	return Buf_time
end


function SearchDebuff(target,debuffName)
    local i = 1;
    local r = false;
    while(UnitDebuff(target,i) ~= nil)do
        if(UnitDebuff(target,i) == debuffName)then
            r = true;
        end;
        i = i + 1;
    end;
    return r;
end;


function PerHealth(unit)
	return UnitHealth(unit) / UnitMaxHealth(unit) * 100
end;

function BagItemReady(item)
	local occupied, bagCount = GetBagCount()
	for slot = 1, bagCount do
		local index, icon, name, count = GetBagItemInfo(slot)
		if name == item then
			local duration, remaining = GetBagItemCooldown(index)
			if remaining == 0 then
				return true
			end
		end
	end
end;

function RM()
		
	if (FFA_SearchDebuff("target","Bleed")==true) and (FFA_SearchDebuff("target","Grievous Wound")==true) and (UnitMana("player")>34) and (SkillReady("Wound Attack")<=0.3) then 
		CastSpellByName("Wound Attack")
				else
		if (FFA_SearchDebuff("target","Blind Spot Bleed")==true) and (FFA_SearchDebuff("target","Grievous Wound")==true) and (UnitMana("player")>34) and (SkillReady("Wound Attack")<=0.3) then 
		CastSpellByName("Wound Attack")
					else
		if (FFA_SearchDebuff("target","Sneak Attack Bleed")==true) and (FFA_SearchDebuff("target","Grievous Wound")==true) and (UnitMana("player")>34) and (SkillReady("Wound Attack")<=0.3) then 
		CastSpellByName("Wound Attack")
					else
		if (FFA_SearchDebuff("target","Bleed")==true) and (UnitMana("player")>29) and (FFA_SearchDebuff("target","Grievous Wound") == false) and (SkillReady("Low Blow")<=0.3) then 
			CastSpellByName("Low Blow")
				else 
				if (FFA_SearchDebuff("target","Blind Spot Bleed")==true) and (UnitMana("player")>29) and (FFA_SearchDebuff("target","Grievous Wound") == false) and (SkillReady("Low Blow")<=0.3) then 
					CastSpellByName("Low Blow")
					else
						if (FFA_SearchDebuff("target","Sneak Attack Bleed")==true) and (UnitMana("player")>29) and (FFA_SearchDebuff("target","Grievous Wound") == false) and (SkillReady("Low Blow")<=0.3) then 
							CastSpellByName("Low Blow")
							else
					if (FFA_SearchDebuff("target","Bleed") == false) then 
							if (FFA_SearchDebuff("target","Blind Spot Bleed") == false) then
								if (FFA_SearchDebuff("target","Blind Spot Bleed") == false) then 
									if  (SkillReady("Shadowstab")<=0.3) and (UnitMana("player")>19) then
										CastSpellByName("Shadowstab")								
	end end end	end end end end end end
	end  
			
		if  (UnitMana("player")>59) and (SkillReady("Low Blow")<=0.3) then 
							CastSpellByName("Low Blow")
			end
		if (not UnitExists("target")) or (UnitName("target") == "") or (UnitIsUnit("player","target")) or (UnitHealth("target")<=0) or (UnitIsDeadOrGhost("target")) or (not UnitCanAttack("player","target")) or (AssistUnit("unit")) then 
		TargetNearestEnemy()
	end
end

function RogueShadowPrison()
	if (FFA_SearchDebuff("target","Shadow Prison")<=0.9) then
		CastSpellByName("Shadow Prison")
	end
		if (FFA_SearchDebuff("target","Shadow Prison")==false) then
		CastSpellByName("Shadow Prison")
	end

end
