CUSTOMLUA = CUSTOMLUA or {}
CUSTOMLUA['skills'] = nil;
CUSTOMLUA['class'] = nil;
CUSTOMLUA['lastaction'] = nil;
CUSTOMLUA['timers'] = {};
_G.CUSTOMLUA = CUSTOMLUA;

-- Checks all skills from all pages and saves their page and slot number.
function CheckClassAndSkills()
	local mainClass,subClass = UnitClass("player");
	local class = mainClass..subClass;
	if not CUSTOMLUA['skills'] or not CUSTOMLUA['class'] or CUSTOMLUA['class'] ~= class then
		CUSTOMLUA['class'] = class;
		CUSTOMLUA['skills'] = {};
		local skillname,slot;

		for page = 1,5 do
			slot = 1
			skillname = GetSkillDetail(page,slot)
			repeat
				local a1,a2,a3,a4,a5,a6,a7,a8,skillusable = GetSkillDetail(page,slot)
				if skillusable then
					CUSTOMLUA['skills'][skillname] = { ["page"] = page, ["slot"] = slot }
				end
				slot = slot + 1
				skillname = GetSkillDetail(page,slot)
			until skillname == nil
		end
	end
end

function isAvailableSuitSkill(skillName)
	for index = 0, (SkillPlateUpdate(-1) - 1) do
		if(SkillPlateUpdate(index) == skillName) then
			return true;
		end
	end
	return false;
end;

-- Do this at the start of every burst function.
function CustomLuaPreAttack()
	--Select Next Enemy
	if (UnitIsDeadOrGhost("target")) then
		TargetNearestEnemy()
		return
	end

	CheckClassAndSkills();
end

-- Returns the chosen target's (de)buffs and their stack and time remaining.
function CheckBuffsAndDebuffs(target)
	local effects = {};

    for i = 1,200 do
        local buff, _, buffStackSize, buffID = UnitBuff(target, i)
        local debuff, _, debuffStackSize, debuffID = UnitDebuff(target, i)

        -- No buff or debuff left, we can't add more.
        if (not buff and not debuff) then
        	break
    	end

    	-- Add buff
        if (buff) then
        local buffTimeRemaining = UnitBuffLeftTime(target, i)
	        effects[buff:gsub("(%()(.)(%))", "%2")] = { stack = buffStackSize, time = buffTimeRemaining or 0, id = buffID }
	        effects[buffID] = {stack = buffStackSize, time = buffTimeRemaining, name = buff:gsub("(%()(.)(%))", "%2") }
    	end

    	-- Add debuff
    	if (debuff) then
        local debuffTimeRemaining = UnitDebuffLeftTime(target, i)
	        effects[debuff:gsub("(%()(.)(%))", "%2")] = { stack = debuffStackSize, time = debuffTimeRemaining or 0, id = debuffID }
	        effects[debuffID] = {stack = debuffStackSize, time = debuffTimeRemaining, name = debuff:gsub("(%()(.)(%))", "%2") }
	    end
    end

    return effects;
end

-- Gets the cooldown by name from the saved skills (page/slot).
function GetCooldownByName(skillname)
	if not CUSTOMLUA['skills'][skillname] then
		CustomLuaNotice("The skill " .. skillname .. " does not exist in your skill list, can't get cooldown for it.");
		local tablenil = {};
		tablenil[0] = 0;
		tablenil[1] = 0;
		return tablenil;
	end
	return GetSkillCooldown(CUSTOMLUA['skills'][skillname]["page"], CUSTOMLUA['skills'][skillname]["slot"])
end

-- Use in your condition
function CL_IsTimedSkillReady(name, duration)
  -- No registered time, skill should be ready.
  if (not CUSTOMLUA['timers'][name]) then
    return true;
  end

  -- If the registered time + duration is less than or equal to the current time, skill should be ready.
  if ((CUSTOMLUA['timers'][name] + duration) <= GetTime()) then
    CUSTOMLUA['timers'][name] = nil;
    return true;
  end

  -- Skill is not ready.
  return false;
end

-- Use when casting the skill
function CL_SetTimer(name)
  if (CUSTOMLUA['timers'][name]) then
    return;
  end

  CUSTOMLUA['timers'][name] = GetTime();
end

IsPlayerCasting = function()
	local name, maxValue, currValue = UnitCastingTime("player")

	if (maxValue == currValue) then
		return false;
	end

	return true;
end


-- Won't use when user is casting, saves last used skill.
function CustomCastSpellByName(skillname, timername)
	if (IsPlayerCasting() == true) then
	    return;
	end

	--CustomLuaDebug("Attempting to cast " .. skillname)
	CastSpellByName(skillname)
	CUSTOMLUA['lastaction'] = skillname

      if (timername) then
          CL_SetTimer(timername);
      end
end

-- First energy bar percentage 0-100.
function PctEB1(target)
	target = target or "player"
	return ((UnitMana(target)/UnitMaxMana(target)) * 100)
end

-- Second energy bar percentage 0-100.
function PctEB2(target)
	target = target or "player"
	return ((UnitSkill(target)/UnitMaxSkill(target)) * 100)
end

-- Send debug message.
function CustomLuaDebug(text)
	if CUSTOMLUA['debug'] == true then
		SendSystemChat('|cffFF0000CUSTOMLUA DEBUG:|r ' .. text)
	end
end

-- Sends a notice message to chat, in customlua style so it stands out.
function CustomLuaNotice(text)
	SendSystemChat("|cffFF0000CUSTOMLUA NOTICE:|r " .. text)
end

-- Custom function that checks if Throw is usable, and then uses it.
function CustomLua_Throw()
	local _,TCD = GetCooldownByName("Throw")
	local ammo = (GetEquipSlotInfo(10) ~= nil)

	if (TCD > 0) then
		return;
	end

	if (not ammo) then
		CustomLuaNotice("No more ammo!")
		return;
	end

	CustomCastSpellByName("Throw");
end
