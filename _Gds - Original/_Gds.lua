-- _Gds (Gör gör det själv) Combat engine
--
-- written originally by Moo - rewritten by Vernberg
--
--_Gds = _Gds or {}
--_Gds['lastaction'] = nil;
--_G._Gds = _Gds;
--_Gds['timers'] = {};

lastUrgentHeal = 0;
HealCaptureDynFrame = CreateUIComponent("Frame", "HealCaptureDyn_Frame", "UIParent");

HealCaptureDynFrame:SetSize(0,0);
HealCaptureDynFrame:ClearAllAnchors();
HealCaptureDynFrame:SetAnchor("TOP", "TOP", "UIParent", 0, 0);
HealCaptureDynFrame:SetScripts("OnLoad",  [=[ HealCaptureDyn_Frame:RegisterEvent("COMBATMETER_HEAL") ]=] );
HealCaptureDynFrame:SetScripts("OnEvent", [=[ if (event=="COMBATMETER_HEAL") and (_skill=="Urgent Heal") then lastUrgentHeal=_heal; end; ]=] );

-- Locals
local ROOT = "Interface/Addons/_Gds"


------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Skills
------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------

 -- checks if skill is usable
function IsSkillUsable(SkillName, ShouldUse)
 -- checks if skill is usable (uses skill panel to determine usability. useage is flawed with ranged skills)
 for x=1,4,1 do totalCount = GetNumSkill(x)
  if (totalCount) then
   for y=1,totalCount,1 do
    local name, _, _, _, _, _, _, _, usable = GetSkillDetail(x,y)
    if string.lower(name) == string.lower(SkillName) and usable == true then totalCD, remainingCD = GetSkillCooldown(x, y);
     if (remainingCD <1) then
      if ShouldUse then UseSkill(x,y);
	  end;
      return true
     end
    end
   end
  end
 end
 return false
end



-- Skill cooldown
function SkillCooldown(unit, skillname) -- SkillCooldown("player", "SKILLNAME")
 if (skillname) ~= nil then
  local cd = GetSkillCooldown(skillname)
   return cd <= 0.2
	elseif skillname == nil then
     return false
   else
  return
 end
end

-- Cast skill by name
function CSBN(skillName) --CSBN("Skillname")
 if (IsPlayerCasting() == true) then
  return;
   end
  CastSpellByName(skillName)
-- _Gds['lastaction'] = skillName
end

------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Setskill
------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------

-- checks if setskill is usable
function IsAvailableSuitSkill(SkillName)  --IsAvailableSuitSkill("SKILLNAME")
 for index = 0, (SkillPlateUpdate(-1) - 1) do
  if(SkillPlateUpdate(index) == SkillName) then
   return true;
   end
  end
 return false;
end;

-- Cast setskill
function CastSuitSkill(SkillName) --CastSuitSkill("SKILLNAME")
 local spell = SkillName
  for k, v in pairs(SkillName) do
   if k == SkillName then
    for i = 0, SkillPlateUpdate(-1) - 1, 1 do
     local _, texture = SkillPlateUpdate(i);
      if v == texture then
       CastSpellByName(k)
        return
         end
          end
           for i = 1, 11 do
           for s = 1, 11 do
          local name, texture, index = GetSuitSkill_List(i, s - 1)
         if texture == v then
        SkillPlateReceiveDrag(1, index)
       CastSpellByName(k)
      return
     end
    end
   end
  end
 end
end



------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Food and or Items
------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------

-- IsBagItemUsable
function IsBagItemUsable(itemname)
 if (GetCountInBagByName(itemname) == 0) then
  return false
   end
    i=1
     while (i < 180)
      do
       local inventoryIndex, icon, name, itemCount, locked, invalid = GetBagItemInfo ( i )
        if (name == itemname) then
         local maxCD, CurrentCD = GetBagItemCooldown ( inventoryIndex )
          if (locked == true) then
         return false
        elseif (CurrentCD == 0) then
       return true
      else
     return false
    end
   end
  i = i + 1
 end
end

-- UseItemByName
function UseItem(name) --UseItem("ITEMNAME")
 UseItemByName(name)
end

------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Functions repair
------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------

--Repair
function repairItems()
 for i=0,22,1 do dV,dM,iN,dVf,dMf = GetInventoryItemDurable("player",i);
  if (iN) then
   if ((dMf>10100 and 10100>dVf) or (7000>dVf)) then UseItemByName(TEXT("Sys201967_name")); PickupEquipmentItem(i); Sol.io.Print(iN..": Repaired"); return
   else
   end;
  end;
 end;
end;

------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
-- PSI
------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------

-- playerSoulPoint
function playerSoulPoint(unit, min, max) --playerSoulPoint("Player", min, max)
 if(min == nil) then
  min = 0;
   end
    if(max == nil) then
     max = 6;
      end
      local point, _ = getSoulPoint();
     if(min <= point and point <= max) then
    return true, point;
   else
  return false, point;
 end
end;


function getSoulPoint()
 return GetSoulPoint();
end;

------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Autoshot
------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Function to keep autoshot activated
function Autoshot()
 local mainClass, subClass = UnitClassToken("player");
  if mainClass == "RANGER" then
   for i = 1, 80 do
    local a1,a2,a3,a4,a5,ASon = GetActionInfo(i)
     if tostring(a1):find("skill_ran_new35%-7") then
      if ASon ~= nil then
       if ASon == false then
        UseAction(i)
         end
          return
           end
		    end
		     end
		    for i = 80, 1, -1 do 
           if GetActionInfo(i) == nil then
          SetAction(i, 492589)
         local a1,a2,a3,a4,a5,ASon = GetActionInfo(i)
        if ASon == false then
       UseAction(i)
      end
     SetAction(i, 0)
    break;
   end
  end
 end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Buffs/Debuffs
------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------

-- checks if player has a specified buffTime
function BuffTime(unit, buffname)
 if not unit then
  unit = "player";
   end
    for i = 1, 50 do
     local currentbuffname, _, _ = UnitBuff(unit, i);
      if currentbuffname then
       if string.lower(currentbuffname) == string.lower(buffname) then
      return UnitBuffLeftTime(unit, i)
     end
    else
   return false
  end
 end
end

-- checks if player has a specified buffTimeleft
function BuffTimeLeft(unit, buffname)
 local cnt = 1
  local currentbuffname = UnitBuff(unit,cnt)
   while currentbuffname ~= nil do
    if string.find(currentbuffname,buffname) then
     return UnitBuffLeftTime(unit,cnt)
     end
    cnt = cnt + 1
   currentbuffname = UnitBuff(unit,cnt)
  end
 return 0
end

-- Buffcheck
function BuffCheck(buffname, unit)
 if not (unit) then unit ="player"; end;
  for i=1,50 do
   local currentbuffname, _, currentbuffcount, currentbuffid = UnitBuff(unit, i);
    if currentbuffname then
	if string.lower(currentbuffname) == string.lower(buffname) then
   return true, currentbuffcount, UnitBuffLeftTime(unit,i); end;
  else return false, 0, 0; end
 end
end

-- Debuffcheck
function DebuffCheck(debuffname, unit)
if not (unit) then unit ="target"; end;
for i=1,50 do
 local currentdebuffname, _, currentdebuffcount, currentdebuffid = UnitDebuff(unit, i);
  if currentdebuffname then
	if string.lower(currentdebuffname) == string.lower(debuffname) then
		return true, currentdebuffcount, UnitDebuffLeftTime(unit,i); end;
  else return false end
 end
end

function CheckDebuffStacks(debuffname,target)
    local target = target or "target"
    local result=0;
    local i=0;
    repeat
        i=i+1;
        local debuff,icon,stack=UnitDebuff(target,i);
        if (debuff==debuffname) then 
            result=stack
            break;
        end
    until (debuff==nil);
    return result;
end

------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Is player and target casting
------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------

-- checks if player is casting
function IsPlayerCasting()
	local _, maxValue, currValue = UnitCastingTime("player")
	if (maxValue == currValue) then
		return false;
	end
	return true;
end

-- checks if target is casting
function IsTargetCasting()
	local _, maxValue, currValue = UnitCastingTime("target")
	if (maxValue == currValue) then
		return false;
	end
	return true;
end

function TargetCasting()
-- checks if target is casting something (checks API UnitCastingTime. flawed)
 if UnitExists("target") then
  SpellName, maxCastTime, currentCastTime = UnitCastingTime("target")
  if maxCastTime>currentCastTime then return SpellName
  else return false end
 end
end


------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Combat
------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------

function isCombat(unit, value)
	if value == nil then
		value = true;
	end
	if value then
		return GetPlayerCombatState(unit);
	else
		return not GetPlayerCombatState(unit);
	end
end;


------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Interupt
------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
function ShouldInterrupt()
local SkillCheck = IsTargetCasting();
if SkillCheck then
end;

interruptList = {

--Bosses
      	[500527] = true,
		
		
['Recover']	= true,
['Restore Life'] = true,
['Heal'] = true,
['Curing Shot']	= true,
['Urgent Heal']	= true,
['Annihilation'] = true,		
['King Bug Shock'] = true,
['Mana Rift'] = true,
['Dream of Gold'] = true,
['Leaves of Fire'] = true,
['Heavy Shelling'] = true,
['Dark Healing'] = true,
--Skills
['Snipe'] = true,
['Severed Consciousness'] = true,
['Psychic Arrows'] = true, 
['Warp Charge']	= true,
['Weakening Weave Curse'] = true,
['Beasts Roar']	= true,
['Flame'] = true,
['Flame Spell']	= true,
['Wave Bomb'] = true,
--Herald
['Summoning: Tornado'] = true,
['Thunder Force'] = true,
['Raise Morale'] = true,
['Fearless'] = true,
['Ironblood Army Spirit'] = true,
['Honor Guard'] = true,
}
end

--    local tspell,ttime,telapsed = UnitCastingTime("target")

--		local nSpell,tTotal,tRemaining = UnitCastingTime("target")
--		local interruptSkill = GABN("Lightning") or GABN("Silence");

--		elseif UnitExists("target") and UnitHealth("target")>0 and UnitCanAttack("player", "target") then
--		if IsTargetCasting() and interruptSkill and interruptList[nSpell] and ((tTotal - tRemaining) > 0.1) then UABS(interruptSkill); end;
--		UseSkill(1,1)


-- Interupt

-- Target			
--		elseif UnitExists("target") and UnitHealth("target")>0 and UnitCanAttack("player", "target") then																				
--		UseSkill(1,1);
-- Rotation			
--		if UnitCanAttack("player","target") then


------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
-- class values
------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Classtokens:
--WARRIOR->Warrior == class id = 1
--RANGER->Scout    == class id = 2
--THIEF->Rogue     == class id = 3
--MAGE->Mage       == class id = 4
--AUGUR->Priest    == class id = 5
--KNIGHT->Knight   == class id = 6
--WARDEN->Warden   == class id = 7
--DRUID->Druid     == class id = 8
--HARPSYN->Warlock == class id = 9
--PSYRON->Champion == class id = 10

-- UnitMana("player")>0 Current amount of Mana / Rage / Energy /Focus of the primary class
-- UnitSkill("player")>0 Current amount of Mana / Rage / Energy /Focus of the secondary class
-- playerSoulPoint("player", 6, 6) 

--UnitHealth("target")<45           = health below certain amount

--0.95>UnitHealth("player")/UnitMaxHealth("player") // 

------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Functions for class specific rotations
------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
--Champion
------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------

function ChampionTank()

local mainClass, subClass = UnitClassToken("player")
if mainClass=="PSYRON" then
	if subClass=="THIEF" then
		
-- Buff/Debuff player
		local sfbn, _, sfbr = BuffCheck("Shield Form","player");
		local sebn, _, sebr = BuffCheck("Shadow Explosion","player");
		local btbn, _, btbr = BuffCheck("Attack Is the Best Defense","player");
		local febn, _, febr = BuffCheck("Forge","player");	
		local rgbn, _, rgbr = BuffCheck("Rune Growth","player");
        local hbdn, hbdc, hbdr = BuffCheck("Heavy Bash","target");				
-- Negative HP buffs		
		local babn, _, babr = BuffCheck("Backlash Armor","player");	
		local webn, _, webr = BuffCheck("Waiting Game","player");	
		local fdbn, _, fdbr = BuffCheck("Feedback Defense","player");
		local oebn, _, oebr = BuffCheck("Overrule","player");
		local rybn, _, rybr = BuffCheck("Remodeled Body","player");	
-- Chaindrive			
		local cdbn, _, cdbr = BuffCheck("Chain Drive","player");		
--	Buffs	
	    if not sfbn and IsSkillUsable("Shield Form") then CSBN("Shield Form") 
 --       elseif not sebn and IsSkillUsable("Shadow Explosion") then CSBN("Shadow Explosion")
	    elseif not btbn and IsAvailableSuitSkill("Attack Is the Best Defense") and UnitMana("player")>30 then CSBN("Attack Is the Best Defense")	
        elseif not febn and IsSkillUsable("Forge") then CSBN("Forge") 
        elseif not rgbn and IsSkillUsable("Rune Growth") then CSBN("Rune Growth") 
        elseif IsSkillUsable("Rune Energy Influx") and UnitMana("player")>10 then CSBN("Rune Energy Influx") 		
-- Low HP skills	
		elseif 0.9>UnitHealth("player")/UnitMaxHealth("player") and IsSkillUsable("Waiting Game") then CSBN("Waiting Game")		
		elseif 0.5>UnitHealth("player")/UnitMaxHealth("player") and not fdbn and IsSkillUsable("Feedback Defense") then CSBN("Feedback Defense")	
		elseif 0.1>UnitHealth("player")/UnitMaxHealth("player") and not rybn and IsSkillUsable("Remodeled Body") then CSBN("Remodeled Body")				
-- Low Rage
 	    elseif UnitMana("player")<20 and IsAvailableSuitSkill("Runic Charge") then CSBN("Runic Charge")
-- Interuption and target					
		elseif UnitExists("target") and UnitHealth("target")>0 and UnitCanAttack("player", "target") then																				
		UseSkill(1,1);
-- Rotation			
		if UnitCanAttack("player","target") then		
        if cdbn and IsSkillUsable("Rune Pulse") then CSBN("Rune Pulse")			
 --       elseif IsSkillUsable("Shock Strike") and UnitMana("player")>25 then CSBN("Shock Strike")	
		elseif IsSkillUsable("Throw") then CSBN("Throw")	
		elseif IsSkillUsable("Shadowstab") and UnitSkill("player")>20 then CSBN("Shadowstab")					
        end				
		end
		end
end
end
end

function ChampionTankW()
local mainClass, subClass = UnitClassToken("player")
if mainClass=="PSYRON" then
	if subClass=="WARRIOR" then
-- Buff/Debuff player
		local sfbn, _, sfbr = BuffCheck("Shield Form","player");
		local dpbn, _, dpbr = BuffCheck("Deadland Protection","player");
		local btbn, _, btbr = BuffCheck("Attack Is the Best Defense","player");
		local febn, _, febr = BuffCheck("Forge","player");	
		local rgbn, _, rgbr = BuffCheck("Rune Growth","player");
		local rebn, _, rebr = BuffCheck("Rune Energy Influx","player");		
-- Negative HP buffs
		local drbn, _, drbr = BuffCheck("Determination Rune","player");
		local eebn, _, eebr = BuffCheck("Eye for an Eye","player");		
		local fdbn, _, fdbr = BuffCheck("Feedback Defense","player");
		local rybn, _, rybr = BuffCheck("Remodeled Body","player");		
-- Chaindrive		
		local cdbn, _, cdbr = BuffCheck("Chain Drive","player");	
-- Buff/Debuff target
        local hbdn, hbdc, hbdr = BuffCheck("Heavy Bash","target");				
-- Buffs	
	    if not sfbn and IsSkillUsable("Shield Form") then CSBN("Shield Form") 
 --       elseif not dpbn and IsSkillUsable("Deadland Protection") and UnitMana("player")>10 then CSBN("Deadland Protection")
	    elseif not btbn and IsAvailableSuitSkill("Attack Is the Best Defense") and UnitMana("player")>30 then CSBN("Attack Is the Best Defense")	
        elseif not febn and IsSkillUsable("Forge") then CSBN("Forge") 
        elseif not rgbn and IsSkillUsable("Rune Growth") then CSBN("Rune Growth") 			
-- Low HP skills
		elseif 0.95>UnitHealth("player")/UnitMaxHealth("player") and not drbn and IsSkillUsable("Determination Rune") then CSBN("Determination Rune")	
		elseif 0.6>UnitHealth("player")/UnitMaxHealth("player") and not eebn and IsSkillUsable("Eye for an Eye") then CSBN("Eye for an Eye")	
		elseif 0.4>UnitHealth("player")/UnitMaxHealth("player") and not fdbn and IsSkillUsable("Feedback Defense") and UnitMana("player")>10 then CSBN("Feedback Defense")	
		elseif 0.1>UnitHealth("player")/UnitMaxHealth("player") and not rybn and IsSkillUsable("Remodeled Body") then CSBN("Remodeled Body")					
-- Low Rage
 	    elseif UnitMana("player")<10 and IsAvailableSuitSkill("Runic Charge") then CSBN("Runic Charge")
-- Aggro
        elseif not rebn and IsSkillUsable("Rune Energy Influx") and UnitMana("player")>10 then CSBN("Rune Energy Influx") 		
-- Target			
		elseif UnitExists("target") and UnitHealth("target")>0 and UnitCanAttack("player", "target") then																				
		UseSkill(1,1);
-- Rotation			
		if UnitCanAttack("player","target") then
        if cdbn and IsSkillUsable("Rune Pulse") then CSBN("Rune Pulse")	
        elseif IsSkillUsable("Shock Strike") and UnitMana("player")>25 then CSBN("Shock Strike")			
		elseif hbdc==2 and 3>hbdr and IsSkillUsable("Heavy Bash") and UnitMana("player")>20 then CSBN("Heavy Bash")
		elseif hbdc==1 and IsSkillUsable("Heavy Bash") and UnitMana("player")>20 then CSBN("Heavy Bash")
		elseif not hbdn and IsSkillUsable("Heavy Bash") and UnitMana("player")>20 then CSBN("Heavy Bash")		
		elseif cdbn and IsSkillUsable("Rune Pulse") then CSBN("Rune Pulse")	
		elseif not cdbn and IsSkillUsable("Attack") then CSBN("Attack")		
end
end
end
end
end
end

function ChampionTankM()
local mainClass, subClass = UnitClassToken("player")
if mainClass=="PSYRON" then
	if subClass=="MAGE" then
-- Buff/Debuff player
		local sfbn, _, sfbr = BuffCheck("Shield Form","player");
		local edbn, _, edbr = BuffCheck("Elemental Defense","player");
		local btbn, _, btbr = BuffCheck("Attack Is the Best Defense","player");
		local febn, _, febr = BuffCheck("Forge","player");	
		local rgbn, _, rgbr = BuffCheck("Rune Growth","player");
		local hbbn, _, hbbr = BuffCheck("High-Energy Barrier","player");
		local rebn, _, rebr = BuffCheck("Rune Energy Influx","player");				
-- Negative HP buffs		
		local babn, _, babr = BuffCheck("Backlash Armor","player");	
		local kebn, _, kebr = BuffCheck("Key Rescue","player");	
		local fdbn, _, fdbr = BuffCheck("Feedback Defense","player");
		local oebn, _, oebr = BuffCheck("Overrule","player");
		local rybn, _, rybr = BuffCheck("Remodeled Body","player");		
-- Chaindrive		
		local cdbn, _, cdbr = BuffCheck("Chain Drive","player");	
-- Buff/Debuff target		
		local vwbn, _, vwbr = BuffCheck("Vacuum Wave","target");
		local ssbn, _, ssbr = BuffCheck("Shock Strike","target");
		local enbn, _, enbr = BuffCheck("Electrocution","target");
		local sebn, _, sebr = BuffCheck("Silence","target");
        local hbdn, _, hbdr = BuffCheck("Heavy Bash","target");				
-- Buffs	
	    if not sfbn and IsSkillUsable("Shield Form") then CSBN("Shield Form") 
        elseif not edbn and IsSkillUsable("Elemental Defense") and UnitSkill("player")>200 then CSBN("Elemental Defense")
	    elseif not btbn and IsAvailableSuitSkill("Attack Is the Best Defense") and UnitMana("player")>30 then CSBN("Attack Is the Best Defense")
        elseif not febn and IsSkillUsable("Forge") then CSBN("Forge") 
        elseif not rgbn and IsSkillUsable("Rune Growth") then CSBN("Rune Growth") 
        elseif not hbbn and IsSkillUsable("High-Energy Barrier") and UnitSkill("player")>180 then CSBN("High-Energy Barrier")
-- Low HP skills
		elseif 0.95>UnitHealth("player")/UnitMaxHealth("player") and not babn and IsSkillUsable("Backlash Armor") and UnitSkill("player")>450 then CSBN("Backlash Armor")	
		elseif 0.9>UnitHealth("player")/UnitMaxHealth("player") and not kebn and IsSkillUsable("Key Rescue") and UnitSkill("player")>102 then CSBN("Key Rescue")
		elseif 0.8>UnitHealth("player")/UnitMaxHealth("player") and not oebn and IsSkillUsable("Overrule") and UnitMana("player")>20 then CSBN("Overrule")		
		elseif 0.5>UnitHealth("player")/UnitMaxHealth("player") and not fdbn and IsSkillUsable("Feedback Defense") and UnitMana("player")>10 then CSBN("Feedback Defense")	
		elseif 0.2>UnitHealth("player")/UnitMaxHealth("player") and not rybn and IsSkillUsable("Remodeled Body") then CSBN("Remodeled Body")	
-- Low Rage
 --	    elseif UnitMana("player")<10 and IsAvailableSuitSkill("Runic Charge") then CSBN("Runic Charge")
-- Aggro
 --       elseif not rebn and IsSkillUsable("Rune Energy Influx") and UnitMana("player")>10 then CSBN("Rune Energy Influx") 	
-- Interuption and target			
		elseif UnitExists("target") and UnitHealth("target")>0 and UnitCanAttack("player", "target") then																			
		UseSkill(1,1);
-- Rotation			
		if UnitCanAttack("player","target") then
        if cdbn and IsSkillUsable("Rune Pulse") then CSBN("Rune Pulse")	
        elseif IsSkillUsable("Shock Strike") and UnitMana("player")>25 then CSBN("Shock Strike")				
		elseif cdbn and IsSkillUsable("Rune Pulse") then CSBN("Rune Pulse")	
		elseif not cdbn and IsSkillUsable("Attack") then CSBN("Attack")		
	
        end						
		end
		end
end
end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
--ChampionDPS
------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------

function ChampionDps()
local mainClass, subClass = UnitClassToken("player")
if mainClass=="PSYRON" then
	if subClass=="THIEF" then	
-- Buff/Debuff player
		local sebn, _, sebr = BuffCheck("Shadow Explosion","player");
		local febn, _, febr = BuffCheck("Forge","player");
		local rgbn, _, rgbr = BuffCheck("Rune Growth","player");		
-- Chaindrive		
		local cdbn, _, cdbr = BuffCheck("Chain Drive","player");
-- Buffs			
        if not sebn and IsSkillUsable("Shadow Explosion") then CSBN("Shadow Explosion")
        elseif not febn and IsSkillUsable("Forge") then CSBN("Forge")
--        elseif not rgbn and IsSkillUsable("Rune Growth") then CSBN("Rune Growth")		
-- Low HP skills		
		elseif 0.9>UnitHealth("player")/UnitMaxHealth("player") and IsSkillUsable("Waiting Game") then CSBN("Waiting Game")	
-- Low Rage
 	    elseif UnitMana("player")<10 and IsAvailableSuitSkill("Runic Charge") then CSBN("Runic Charge")
-- Low Energy
 --	    elseif IsBagItemUsable("Potion of Exquisite Skill") and UnitSkill("player")<10 then UseItem("Potion of Exquisite Skill")	
-- Target			
		elseif UnitExists("target") and UnitHealth("target")>0 and UnitCanAttack("player", "target") then																				
		UseSkill(1,1);
-- Rotation			
		if UnitCanAttack("player","target") then		
        if cdbn and IsSkillUsable("Rune Pulse") then CSBN("Rune Pulse")
		elseif IsSkillUsable("Throw") then CSBN("Throw")
		elseif IsSkillUsable("Shadow Pulse") and UnitSkill("player")>20 then CSBN("Shadow Pulse")		
		elseif IsSkillUsable("Shadowstab") and UnitSkill("player")>20 then CSBN("Shadowstab")	
		elseif IsSkillUsable("Fearless Blows") and UnitHealth("target")<40 and UnitMana("player")>15 then CSBN("Fearless Blows")
		elseif cdbn and IsSkillUsable("Rune Pulse") then CSBN("Rune Pulse")	
		elseif not cdbn and IsSkillUsable("Attack") then CSBN("Attack")	
        end				
		end
		end
		end
		end
		end	
		
function ChampionDpsTWO()
local mainClass, subClass = UnitClassToken("player")
if mainClass=="PSYRON" then
	if subClass=="THIEF" then	
-- Buff/Debuff player
		local sebn, _, sebr = BuffCheck("Shadow Explosion","player");
		local febn, _, febr = BuffCheck("Forge","player");
		local rgbn, _, rgbr = BuffCheck("Rune Growth","player");

-- Foodbuffs
		local hpbn, _, hpbr = BuffCheck("Hero Potion","player");
		local hrbn, _, hrbr = BuffCheck("Honey Ribs","player");
		local gmbn, _, gmbr = BuffCheck("Grassland Mix","player");
		local csbn, _, csbr = BuffCheck("Caviar Sandwich","player");		
-- Chaindrive		
		local cdbn, _, cdbr = BuffCheck("Chain Drive","player");
-- Buffs			
        if not sebn and IsSkillUsable("Shadow Explosion") then CSBN("Shadow Explosion")
        elseif not febn and IsSkillUsable("Forge") then CSBN("Forge")
	
--        elseif not rgbn and IsSkillUsable("Rune Growth") then CSBN("Rune Growth")
-- Foods
		elseif IsBagItemUsable("Hero Potion") and not hpbn then UseItem("Hero Potion")
		elseif IsBagItemUsable("Honey Ribs") and not hrbn then UseItem("Honey Ribs")
		elseif IsBagItemUsable("Grassland Mix") and not gmbn then UseItem("Grassland Mix")	
		elseif combat and not csbn and IsBagItemUsable("Caviar Sandwich") then UseItem("Caviar Sandwich")		
-- Low HP skills		
		elseif 0.9>UnitHealth("player")/UnitMaxHealth("player") and IsSkillUsable("Waiting Game") then CSBN("Waiting Game")	
-- Low Rage
 	    elseif UnitMana("player")<10 and IsAvailableSuitSkill("Runic Charge") then CSBN("Runic Charge")
-- Low Energy
 --	    elseif IsBagItemUsable("Potion of Exquisite Skill") and UnitSkill("player")<10 then UseItem("Potion of Exquisite Skill")	
-- Target			
		elseif UnitExists("target") and UnitHealth("target")>0 and UnitCanAttack("player", "target") then																				
		UseSkill(1,1);
-- Rotation			
		if UnitCanAttack("player","target") then		
        if cdbn and IsSkillUsable("Rune Pulse") then CSBN("Rune Pulse")
		elseif IsSkillUsable("Throw") then CSBN("Throw")		
		elseif IsSkillUsable("Shadowstab") and UnitSkill("player")>20 then CSBN("Shadowstab")	
		elseif IsSkillUsable("Fearless Blows") and UnitHealth("target")<40 and UnitMana("player")>15 then CSBN("Fearless Blows")
		elseif cdbn and IsSkillUsable("Rune Pulse") then CSBN("Rune Pulse")	
		elseif not cdbn and IsSkillUsable("Attack") then CSBN("Attack")	
        end				
		end
		end
		end
		end
		end	
		
		
------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
--Warlock
------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------

function WarlockMage()
local mainClass, subClass = UnitClassToken("player")
if mainClass=="HARPSYN" then
	if subClass=="MAGE" then
		local combat = GetPlayerCombatState();	
-- Buff/Debuff player
	    local scbn, _, _ = BuffCheck("Sublimation Weave Curse","player")		
        local fbbn, _, fbbr = BuffCheck("Focus Building","player")
        local wbbn, _, _ = BuffCheck("Willpower Blade","player")		
        local smbn, _, _ = BuffCheck("Shield of Solid Mind","player")		
        local dnbn, _, _ = BuffCheck("Defense Net","player")	
	    local atdn, _, _ = DebuffCheck("Authoritative Deterrence","target")	
        local sbdn, sbdc, sbdr = DebuffCheck("Soul Brand","target")	
        local wcbnp, _, _ = DebuffCheck("Warp Charge","player")
        local wcbnt, _, _ = DebuffCheck("Warp Charge","target")	
	    local pedn, _, _ = DebuffCheck("Perception Extraction","target")
	    local wddn, _, _ = DebuffCheck("Weakened","target")		
-- Buffs
        if IsSkillUsable("Sublimation Weave Curse") and not scbn then CSBN("Sublimation Weave Curse");
--        elseif IsSkillUsable("Focus Building") and not fbbn then CSBN("Focus Building");
-- No focus
       elseif IsBagItemUsable("Potion of Focused Will") and UnitMana("player")<30 then UseItem("Potion of Focused Will")	
-- Low PH		
		elseif 0.95>UnitHealth("player")/UnitMaxHealth("player") and not smbn and IsSkillUsable("Shield of Solid Mind") and UnitMana("player")>35 then CSBN("Shield of Solid Mind")	
-- Target
		elseif UnitExists("target") and UnitHealth("target")>0 and UnitCanAttack("player", "target") then		
		if UnitCanAttack("player","target") then
-- Rotation
		if atdn and IsSkillUsable("Silence") and UnitSkill("player")>300 then CSBN("Silence")	
		elseif IsSkillUsable("Warp Charge") and UnitMana("player")>30 then CSBN("Warp Charge")
		elseif sbdc==4 and 4>sbdr and IsSkillUsable("Perception Extraction") and UnitMana("player")>15 then CSBN("Perception Extraction")	
		elseif sbdc==3 and IsSkillUsable("Perception Extraction") and UnitMana("player")>15 then CSBN("Perception Extraction")
		elseif sbdc==2 and IsSkillUsable("Perception Extraction") and UnitMana("player")>15 then CSBN("Perception Extraction")
		elseif sbdc==1 and IsSkillUsable("Perception Extraction") and UnitMana("player")>15 then CSBN("Perception Extraction")	
		elseif not sdbn and IsSkillUsable("Perception Extraction") and UnitMana("player")>15 then CSBN("Perception Extraction")
		elseif IsSkillUsable("Heart Collection Strike") then CSBN("Heart Collection Strike")						
        end				
		end
		end
		end
		end
		end
		
function WLM()
local mainClass, subClass = UnitClassToken("player")
if mainClass=="HARPSYN" then
	if subClass=="MAGE" then
		FocusUnit(1,"raid5")
	TargetUnit("focus1target");
		local combat = GetPlayerCombatState();	
-- Buff/Debuff player
	    local scbn, _, _ = BuffCheck("Sublimation Weave Curse","player")		
        local fbbn, _, fbbr = BuffCheck("Focus Building","player")
        local wbbn, _, _ = BuffCheck("Willpower Blade","player")		
        local smbn, _, _ = BuffCheck("Shield of Solid Mind","player")		
        local dnbn, _, _ = BuffCheck("Defense Net","player")	
	    local atdn, _, _ = DebuffCheck("Authoritative Deterrence","target")	
        local sbdn, sbdc, sbdr = DebuffCheck("Soul Brand","target")	
        local wcbnp, _, _ = DebuffCheck("Warp Charge","player")
        local wcbnt, _, _ = DebuffCheck("Warp Charge","target")	
	    local pedn, _, _ = DebuffCheck("Perception Extraction","target")
	    local wddn, _, _ = DebuffCheck("Weakened","target")		
-- Buffs
        if IsSkillUsable("Sublimation Weave Curse") and not scbn then CSBN("Sublimation Weave Curse");
--        elseif IsSkillUsable("Focus Building") and not fbbn then CSBN("Focus Building");
-- No focus
       elseif IsBagItemUsable("Potion of Focused Will") and UnitMana("player")<30 then UseItem("Potion of Focused Will")	
-- Low PH		
		elseif 0.95>UnitHealth("player")/UnitMaxHealth("player") and not smbn and IsSkillUsable("Shield of Solid Mind") and UnitMana("player")>35 then CSBN("Shield of Solid Mind")	
-- Target
		elseif UnitExists("target") and UnitHealth("target")>0 and UnitCanAttack("player", "target") then		
		if UnitCanAttack("player","target") then
-- Rotation
		if atdn and IsSkillUsable("Silence") and UnitSkill("player")>300 then CSBN("Silence")	
		elseif IsSkillUsable("Warp Charge") and UnitMana("player")>30 then CSBN("Warp Charge")
		elseif sbdc==4 and 4>sbdr and IsSkillUsable("Perception Extraction") and UnitMana("player")>15 then CSBN("Perception Extraction")	
		elseif sbdc==3 and IsSkillUsable("Perception Extraction") and UnitMana("player")>15 then CSBN("Perception Extraction")
		elseif sbdc==2 and IsSkillUsable("Perception Extraction") and UnitMana("player")>15 then CSBN("Perception Extraction")
		elseif sbdc==1 and IsSkillUsable("Perception Extraction") and UnitMana("player")>15 then CSBN("Perception Extraction")	
		elseif not sdbn and IsSkillUsable("Perception Extraction") and UnitMana("player")>15 then CSBN("Perception Extraction")
		elseif IsSkillUsable("Heart Collection Strike") then CSBN("Heart Collection Strike")						
        end				
		end
		end
		end
		end
		end		
	
function WarlockMagetwo()
local mainClass, subClass = UnitClassToken("player")
if mainClass=="HARPSYN" then
	if subClass=="MAGE" then
		local combat = GetPlayerCombatState();	
-- Buff/Debuff player
	    local scbn, _, _ = BuffCheck("Sublimation Weave Curse","player")		
        local fbbn, _, fbbr = BuffCheck("Focus Building","player")
        local wbbn, _, _ = BuffCheck("Willpower Blade","player")		
        local smbn, _, _ = BuffCheck("Shield of Solid Mind","player")		
        local dnbn, _, _ = BuffCheck("Defense Net","player")	
	    local atdn, _, _ = DebuffCheck("Authoritative Deterrence","target")	
        local sbdn, sbdc, sbdr = DebuffCheck("Soul Brand","target")	
        local wcbnp, _, _ = DebuffCheck("Warp Charge","player")
        local wcbnt, _, _ = DebuffCheck("Warp Charge","target")	
	    local pedn, _, _ = DebuffCheck("Perception Extraction","target")
	    local wddn, _, _ = DebuffCheck("Weakened","target")	
        local scbn, _, scbr = BuffCheck("Sublimation Weave Curse","player")	
        local mrbn, _, mrbr = BuffCheck("Mind Rune","player") 
        local sfbn, _, sfbr = BuffCheck("Saces' Fury","player")
        local sibn, _, sibr = BuffCheck("Saces' Impulse","player")		
        local wbbn, _, wbbr = BuffCheck("Willpower Blade","player")
        local dhbn, _, dhbr = BuffCheck("Dark Halo","player")	
        local wcbn, _, wcbr = BuffCheck("Warp Charge","player")
        local smbn, _, _ = BuffCheck("Shield of Solid Mind","player")

		
		local enbn, _, enbr = DebuffCheck("Electrocution","target")
	    local wddn, _, wdbr = DebuffCheck("Weakened","target")		
	    local spdn, _, spbr = DebuffCheck("Soul Pain","target")	
	    local pedn, _, pebr = DebuffCheck("Perception Extraction","target")			
-- Buffs
        if IsSkillUsable("Sublimation Weave Curse") and not scbn then CSBN("Sublimation Weave Curse");
--        elseif IsSkillUsable("Focus Building") and not fbbn then CSBN("Focus Building");
-- No focus
       elseif IsBagItemUsable("Potion of Focused Will") and UnitMana("player")<30 then UseItem("Potion of Focused Will")	
-- Low PH		
		elseif 0.95>UnitHealth("player")/UnitMaxHealth("player") and not smbn and IsSkillUsable("Shield of Solid Mind") and UnitMana("player")>35 then CSBN("Shield of Solid Mind")	
-- Target
		elseif UnitExists("target") and UnitHealth("target")>0 and UnitCanAttack("player", "target") then		
		if UnitCanAttack("player","target") then
-- Rotation	
		if IsSkillUsable("Warp Charge") and UnitMana("player")>30 then CSBN("Warp Charge")

		elseif not spdn and IsSkillUsable("Soul Pain")	and UnitMana("player")>15 then CSBN("Soul Pain")
		elseif IsSkillUsable("Heart Collection Strike") and UnitMana("player")<35 then CSBN("Heart Collection Strike")					
		elseif IsSkillUsable("Soul Trauma") and UnitMana("player")>25 then CSBN("Soul Trauma")		
		elseif IsSkillUsable("Surge of Malice") and UnitMana("player")>20 then CSBN("Surge of Malice")	
		elseif IsSkillUsable("Heart Collection Strike") then CSBN("Heart Collection Strike")	
		elseif wddn and IsSkillUsable("Puzzlement") and UnitMana("player")>25 then CSBN("Puzzlement")						
        end				
		end
		end
		end
		end
		end	
		

function WarlockRogue()
local mainClass, subClass = UnitClassToken("player")
if mainClass=="HARPSYN" then
	if subClass=="THIEF" then
		local combat = GetPlayerCombatState();
-- Buff/Debuff player		
        local scbn, _, scbr = BuffCheck("Sublimation Weave Curse","player");		
        local wbbn, _, wbbr = BuffCheck("Willpower Blade","player"); 
        local wcbn, _, _ = BuffCheck("Warp Charge","player");				
        local sbdn, sbdc, sbdr = DebuffCheck("Soul Poisoned Fang","target");	
	    local wddn, _, _ = DebuffCheck("Weakened","target");		
-- Buffs
        if IsSkillUsable("Sublimation Weave Curse") and not scbn then CSBN("Sublimation Weave Curse");
-- Low PH		
		elseif 0.95>UnitHealth("player")/UnitMaxHealth("player") and not smbn and IsSkillUsable("Shield of Solid Mind") and UnitMana("player")>35 then CSBN("Shield of Solid Mind")
--Willpower Blade				
        elseif combat and not wbbn and IsSkillUsable("Willpower Blade") and playerSoulPoint(self, 6, 6) then CSBN("Willpower Blade");		
-- Target
		elseif UnitExists("target") and UnitHealth("target")>0 and UnitCanAttack("player", "target") then		
		if UnitCanAttack("player","target") then
-- Rotation
		if wbbn and IsSkillUsable("Severed Consciousness") and playerSoulPoint(self, 2, 6) then CSBN("Severed Consciousness");
		elseif IsSkillUsable("Heart Collection Strike") then CSBN("Heart Collection Strike");
		elseif IsSkillUsable("Warp Charge") and UnitMana("player")>30 then CSBN("Warp Charge");
        elseif IsSkillUsable("Soul Trauma") and UnitMana("player")>25 then CSBN("Soul Trauma");
		elseif wddn and IsSkillUsable("Puzzlement") and UnitMana("player")>20 then CSBN("Puzzlement");	
		elseif not wddn and IsSkillUsable("Weakening Weave Curse") and UnitMana("player")>20 then CSBN("Weakening Weave Curse");	
		elseif IsSkillUsable("Throw") then CSBN("Throw")
		elseif IsSkillUsable("Shadowstab") and UnitSkill("player")>30 then CSBN("Shadowstab")			
		elseif IsSkillUsable("Soul Poisoned Fang") and sbdc==4 and 4>sbdr and UnitSkill("player")>25 then CSBN("Soul Poisoned Fang");	
		elseif IsSkillUsable("Soul Poisoned Fang") and sbdc==3 and UnitSkill("player")>25 then CSBN("Soul Poisoned Fang");	
		elseif IsSkillUsable("Soul Poisoned Fang") and sbdc==2 and UnitSkill("player")>25 then CSBN("Soul Poisoned Fang");
		elseif IsSkillUsable("Soul Poisoned Fang") and sbdc==1 and UnitSkill("player")>25 then CSBN("Soul Poisoned Fang");	
		elseif IsSkillUsable("Soul Poisoned Fang") and UnitSkill("player")>25 then CSBN("Soul Poisoned Fang");
		elseif IsSkillUsable("Psychic Arrows") and UnitMana("player")>20 then CSBN("Psychic Arrows") end;	
        end								
		end
		end	
end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------  
--Mage
------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------

function MageWarlock()
local mainClass, subClass = UnitClassToken("player")
if mainClass=="MAGE" then
	if subClass=="HARPSYN" then

		local combat = GetPlayerCombatState();	
-- Buff/Debuff player
	    local eibn, _, _ = BuffCheck("Energy Influx","player")
	    local ewdn, _, _ = DebuffCheck("Elemental Weakness","target")			
	    local eedn, _, _ = DebuffCheck("Elemental Extraction","target")	
	    local wddn, _, _ = DebuffCheck("Weakened","target");
        local wcbnp, _, _ = DebuffCheck("Warp Charge","player")		
-- Buffs
        if not eibn and IsSkillUsable("Energy Influx") then CSBN("Energy Influx")
		elseif UnitExists("target") and UnitHealth("target")>0 and UnitCanAttack("player", "target") then		
		if UnitCanAttack("player","target") then
-- Rotation
		if not ewdn and IsSkillUsable("Elemental Weakness") and UnitMana("player")>500 then CSBN("Elemental Weakness")	
		elseif IsSkillUsable("Warp Charge") and UnitSkill("player")>30 then CSBN("Warp Charge")			
		elseif ewdn and IsSkillUsable("Electric Explosion") and UnitMana("player")>80 then CSBN("Electric Explosion")		
		elseif IsSkillUsable("Weakening Weave Curse") and UnitSkill("player")>20 then CSBN("Weakening Weave Curse");		
		elseif IsSkillUsable("Fireball") and UnitMana("player")>180 then CSBN("Fireball")		
        end				
		end
		end
		end		
		end
		end
		
function MageWarlockF()
local mainClass, subClass = UnitClassToken("player")
if mainClass=="MAGE" then
	if subClass=="HARPSYN" then

		local combat = GetPlayerCombatState();	
-- Buff/Debuff player
	    local eibn, _, _ = BuffCheck("Energy Influx","player")
	    local ewdn, _, _ = DebuffCheck("Elemental Weakness","target")			
	    local eedn, _, _ = DebuffCheck("Elemental Extraction","target")	
	    local wddn, _, _ = DebuffCheck("Weakened","target");	
-- Buffs
        if not eibn and IsSkillUsable("Energy Influx") then CSBN("Energy Influx")
		elseif UnitExists("target") and UnitHealth("target")>0 and UnitCanAttack("player", "target") then		
		if UnitCanAttack("player","target") then
-- Rotation
		if not ewdn and IsSkillUsable("Elemental Weakness") and UnitMana("player")>500 then CSBN("Elemental Weakness")	
		elseif IsSkillUsable("Fireball") and UnitMana("player")>180 then CSBN("Fireball")
		elseif IsSkillUsable("Warp Charge") and UnitSkill("player")>30 then CSBN("Warp Charge")			
		elseif ewdn and IsSkillUsable("Flame") and UnitMana("player")>300 then CSBN("Flame")			
        end				
		end
		end
		end		
		end
		end		
		
function MWL()
local mainClass, subClass = UnitClassToken("player")
if mainClass=="MAGE" then
	if subClass=="HARPSYN" then
		FocusUnit(1,"raid5")
		TargetUnit("focus1target");
		local combat = GetPlayerCombatState();	
		local boss = UnitSex("target") > 2		
-- Buff/Debuff player
	    local eibn, _, _ = BuffCheck("Energy Influx","player")
        local ecbn, _, _ = BuffCheck("Electrostatic Charge","player")		
	    local ewdn, _, _ = DebuffCheck("Elemental Weakness","target")			
	    local eedn, _, _ = DebuffCheck("Elemental Extraction","target")	
	    local wddn, _, _ = DebuffCheck("Weakened","target");	
-- Buffs
        if not eibn and IsSkillUsable("Energy Influx") then CSBN("Energy Influx")
-- Low PH		
		elseif 0.95>UnitHealth("player")/UnitMaxHealth("player") and not ecbn and IsSkillUsable("Electrostatic Charge") and UnitMana("player")>450 then CSBN("Electrostatic Charge")	
-- Target		
		elseif UnitExists("target") and UnitHealth("target")>0 and UnitCanAttack("player", "target") then		
		if UnitCanAttack("player","target") then
-- Rotation
		if not ewdn and IsSkillUsable("Elemental Weakness") and UnitMana("player")>500 then CSBN("Elemental Weakness")		
		elseif ewdn and IsSkillUsable("Electric Explosion") and UnitMana("player")>80 then CSBN("Electric Explosion")		
		elseif IsSkillUsable("Weakening Weave Curse") and UnitSkill("player")>20 then CSBN("Weakening Weave Curse");				
        end				
		end
		end
		end		
		end
		end	

		
				
------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------  
--Warrior
------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
	
function WarriorMage()
local mainClass, subClass = UnitClassToken("player")
if mainClass=="WARRIOR" then
	if subClass=="MAGE" then
-- Buff/Debuff player	
		local hvbn, hvrc, hvrr = BuffCheck("High Voltage")	
		local lbbn, _, lbbr = BuffCheck("Lightning Burn Weapon","player")
		local sdbn, _, sdbr = BuffCheck("Sense of Danger","player")
		local sibn, _, sibr = BuffCheck("Survival Instinct","player")		
-- Buffs
		if not lbbn and IsSkillUsable("Lightning Burn Weapon") then CSBN("Lightning Burn Weapon")
-- Low HP skills
		elseif 0.5>UnitHealth("player")/UnitMaxHealth("player") and not sibn and IsSkillUsable("Survival Instinct") then CSBN("Survival Instinct")
		elseif 0.3>UnitHealth("player")/UnitMaxHealth("player") and not sdbn and IsSkillUsable("Sense of Danger") then CSBN("Sense of Danger")	
-- Target			
		elseif UnitExists("target") and UnitHealth("target")>0 and UnitCanAttack("player", "target") then																				
 		UseSkill(1,1)
-- Rotation			
	if UnitCanAttack("player","target") then
    if hvrc==3 and 4>hvrr and IsSkillUsable("Electrical Rage") and UnitMana("player")>20 and UnitSkill("player")>400 then CSBN("Electrical Rage")	
    elseif hvrc==2 and IsSkillUsable("Electrical Rage") and UnitMana("player")>20 and UnitSkill("player")>400 then CSBN("Electrical Rage")	
    elseif hvrc==1 and IsSkillUsable("Electrical Rage") and UnitMana("player")>20 and UnitSkill("player")>400 then CSBN("Electrical Rage")		
    elseif not hvbn and IsSkillUsable("Electrical Rage") and UnitMana("player")>20 and UnitSkill("player")>400 then CSBN("Electrical Rage")	
end
end
end
end
end
end

function WarriorRogue()
local mainClass, subClass = UnitClassToken("player")
if mainClass=="WARRIOR" then
	if subClass=="THIEF" then
		local gpbn, _, gpbr = BuffCheck("Guardian of the Pass","player");	
 		local bdbn, _, bdbr = DebuffCheck("Bleed","target");
 		local vebn, _, vebr = DebuffCheck("Vulnerable","target");
		local wdbn, _, wdbr = DebuffCheck("Weakened","target");	
				
        if not gpbn and IsAvailableSuitSkill("Guardian of the Pass") then CSBN("Guardian of the Pass")
-- Target			
		elseif UnitExists("target") and UnitHealth("target")>0 and UnitCanAttack("player", "target") then																				
		UseSkill(1,1);
-- Rotation	
    if not vebn and IsSkillUsable("Probing Attack") and UnitMana("player")>20 then CSBN("Probing Attack")
    elseif vebn and IsSkillUsable("Open Flank") and UnitMana("player")>10 then CSBN("Open Flank")
    elseif vebn and IsSkillUsable("Keen Attack") and UnitSkill("player")>20 then CSBN("Keen Attack")	
    elseif wdbn and IsSkillUsable("Thunder") and UnitMana("player")>15 then CSBN("Thunder")
    elseif wdbn and IsSkillUsable("Splitting Chop") and UnitMana("player")>15 then CSBN("Splitting Chop")			 
	elseif IsSkillUsable("Throw") then CSBN("Throw")		
	elseif IsSkillUsable("Shadowstab") and UnitSkill("player")>20 then CSBN("Shadowstab")		
 		
end
end		
end
end	
end

function WarriorChamp()
local mainClass, subClass = UnitClassToken("player")
if mainClass=="WARRIOR" then
	if subClass=="PSYRON" then
        local hbdn, hbdc, hbdr = DebuffCheck("Heavy Bash","target");			
	    local sadn, _, sabr = DebuffCheck("Stifling Attack","target")		
	    local asdn, _, asbr = DebuffCheck("Attack Stance","target")
	    local tsdn, _, _ = DebuffCheck("Tactical Smash","target")		
 		local bdbn, _, bdbr = DebuffCheck("Bleed","target");
 		local vebn, _, vebr = DebuffCheck("Vulnerable","target");
		local wdbn, _, wdbr = DebuffCheck("Weakened","target");	

	
		local gpbn, _, gpbr = BuffCheck("Guardian of the Pass","player");	
		local wsbn, _, wsbr = BuffCheck("Wild Slash","player");
		local bwbn, _, bwbr = BuffCheck("Blood Rune Weapon","player");		
		
				
        if not gpbn and IsAvailableSuitSkill("Guardian of the Pass") then CSBN("Guardian of the Pass")
		elseif not wsbn and IsSkillUsable("Slash") and UnitHealth("player")>15 then CSBN("Slash")
		elseif not bwbn and IsSkillUsable("Blood Rune Weapon") and UnitHealth("player")>15 then CSBN("Blood Rune Weapon")		
-- Target			
		elseif UnitExists("target") and UnitHealth("target")>0 and UnitCanAttack("player", "target") then																				
		UseSkill(1,1);
-- Rotation	
		if UnitCanAttack("player","target") then
		if hbdc==2 and 3>hbdr and IsSkillUsable("Heavy Bash") and UnitMana("player")>20 then CSBN("Heavy Bash")
		elseif hbdc==1 and IsSkillUsable("Heavy Bash") and UnitMana("player")>20 then CSBN("Heavy Bash")
		elseif not hbdn and IsSkillUsable("Heavy Bash") and UnitMana("player")>20 then CSBN("Heavy Bash")
		elseif not sadn and IsSkillUsable("Stifling Attack") and UnitHealth("player")>15 then CSBN("Stifling Attack")
		elseif vebn and IsAvailableSuitSkill("Attack Stance") and not asdn and UnitMana("player")>25 then CSBN("Attack Stance")	

		
		elseif not vebn and IsSkillUsable("Probing Attack") and UnitMana("player")>20 then CSBN("Probing Attack")		
end
end		
end
end	
end
end
 

------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------  
--Scout
------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------

function ScoutRboss()
local mainClass, subClass = UnitClassToken("player")
 if mainClass=="RANGER" then
	if subClass=="THIEF" then	
        local vmpa, _, _ = DebuffCheck("Vampire Arrows","target")
        local wapa, _, _ = DebuffCheck("Weak Spot Awareness","target")	
        local adpa, _, _ = DebuffCheck("Authoritative Deterrence","target")	
        local espa, _, _ = DebuffCheck("Exploiting Shot","target")	
        local sepa, _, _ = DebuffCheck("Silence","target")		
        local tabn, _, tabr = BuffCheck("Target Area","player")			
		local a1,a2,a3,a4,a5,ASon = Autoshot()	
 --       if not tabn and IsSkillUsable("Target Area") then CSBN("Target Area")			
-- Target			
		if UnitExists("target") and UnitHealth("target")>0 and UnitCanAttack("player", "target") then																				
-- Rotation			
		if UnitCanAttack("player","target") then
		if IsSkillUsable("Vampire Arrows") and UnitMana("player")>20 then CSBN("Vampire Arrows")				
		elseif not espa and IsSkillUsable("Shot") then CSBN("Shot")		
		elseif sepa and espa and IsSkillUsable("Snipe") then CSBN("Snipe")
		elseif IsSkillUsable("Deadly Poison Bite") and UnitMana("player")>20 then CSBN("Deadly Poison Bite")		
		elseif IsSkillUsable("Reflected Shot") then CSBN("Reflected Shot")
		elseif IsSkillUsable("Weak Spot") and UnitMana("player")>20 then CSBN("Weak Spot")	
		elseif IsSkillUsable("Mana Drain Shot") then CSBN("Mana Drain Shot")		
		elseif IsSkillUsable("Piercing Arrow") then CSBN("Piercing Arrow")
		elseif IsSkillUsable("Combo Shot") then CSBN("Combo Shot")		
		elseif IsSkillUsable("Shot") then CSBN("Shot")
		
	 end
  end
  end
  end
  end
end

function ScoutM()
local mainClass, subClass = UnitClassToken("player")
 if mainClass=="RANGER" then
	if subClass=="MAGE" then	
        local vmpa, _, _ = DebuffCheck("Vampire Arrows","target")
        local wapa, _, _ = DebuffCheck("Weak Spot Awareness","target")	
        local adpa, _, _ = DebuffCheck("Authoritative Deterrence","target")	
        local sepa, _, _ = DebuffCheck("Silence","target")	
		
        local tabn, _, tabr = BuffCheck("Target Area","player")	
        local bebn, _, bebr = BuffCheck("Blazing Energy","player")			
		local a1,a2,a3,a4,a5,ASon = Autoshot()
-- Buffs		
       if not tabn and IsSkillUsable("Target Area") then CSBN("Target Area")	
		elseif not bebn and IsSkillUsable("Blazing Energy") then CSBN("Blazing Energy") 
-- Target			
		elseif UnitExists("target") and UnitHealth("target")>0 and UnitCanAttack("player", "target") then																				
-- Rotation			
		if UnitCanAttack("player","target") then
		if IsSkillUsable("Vampire Arrows") and UnitMana("player")>20 then CSBN("Vampire Arrows")				
		elseif IsSkillUsable("Shot") then CSBN("Shot")		
		elseif sepa and IsSkillUsable("Snipe") then CSBN("Snipe")	
		elseif IsSkillUsable("Reflected Shot") then CSBN("Reflected Shot")
		elseif IsSkillUsable("Mana Drain Shot") then CSBN("Mana Drain Shot")		
		elseif IsSkillUsable("Piercing Arrow") then CSBN("Piercing Arrow")
		elseif IsSkillUsable("Combo Shot") then CSBN("Combo Shot")		
		elseif IsSkillUsable("Shot") then CSBN("Shot")
		
	 end
  end
  end
  end
  end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------  
 --Rogue
------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------

function Rouge()
local mainClass, subClass = UnitClassToken("player")

if mainClass=="THIEF" then
	if subClass=="MAGE" then
-- Buff/Debuff player
		local etbn, _, etbr = BuffCheck("Enchanted Throw","player");
		local ybbn, _, ybbr = BuffCheck("Yawaka's Blessing","player");
		local bleed, _, bleed = DebuffCheck("Bleed","target");	
		local gswd, _, bleed = DebuffCheck("Grievous Wound","target");
-- Buffs	
		if not etbn and IsSkillUsable("Enchanted Throw") then CSBN("Enchanted Throw")	
		elseif not ybbn and IsSkillUsable("Yawaka's Blessing") then CSBN("Yawaka's Blessing")		
-- Target			
		elseif UnitExists("target") and UnitHealth("target")>0 and UnitCanAttack("player", "target") then																				
		UseSkill(1,1);
-- Rotation	
		if UnitCanAttack("player","target") then
		if bleed and gswd and IsSkillUsable("Wound Attack") and UnitMana("player")>20 then CSBN("Wound Attack")		
		elseif bleed and IsSkillUsable("Low Blow") and UnitMana("player")>30 then CSBN("Low Blow")
		elseif IsSkillUsable("Throw") then CSBN("Throw")	
		elseif not bleed and IsSkillUsable("Shadowstab") and UnitMana("player")>20 then CSBN("Shadowstab")	
		elseif IsSkillUsable("Attack") then CSBN("Attack")		
end
end
end
end
end
end	


----------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
--HEAL
------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------

--macro for buffing
function moobuff(skillname)
	if skillname==nil or skillname=="" then Sol.io.Print("Provide a skill name when running moobuff('skillname')"); return end;
	local buffname; local buffname2;
	if (skillname==TEXT("Sys490269_name")) then buffname = TEXT("Sys500469_name") -- regnerate
	elseif (skillname==TEXT("Sys491651_name")) then buffname = TEXT("Sys500517_name"); buffname2 = TEXT("Sys502033_name") -- grace of life
	elseif (skillname==TEXT("Sys490491_name")) then buffname = TEXT("Sys500940_name"); buffname2 = TEXT("Sys505157_name") -- amplified attack
	elseif (skillname==TEXT("Sys491640_name")) then buffname = TEXT("Sys500673_name") ; buffname2 = TEXT("Sys505157_name")
	
	
	
	end
	if buffname==nil then buffname=skillname; end
	if buffname2==nil then buffname2=buffname; end

	if (GetNumRaidMembers()>0) then
		local numUnits = GetNumRaidMembers()
		for i=1,numUnits,1 do
			target="raid"..i;
			if not (BuffCheck(buffname,target) or BuffCheck(buffname2,target)) and IsSkillUsable(skillname) then TargetUnit(target); CSBN(skillname) return end
		end
	elseif (GetNumPartyMembers()>0) then
		local numUnits = GetNumPartyMembers()
		for i=1,numUnits,1 do
			target="party"..i;
			if not (BuffCheck(buffname,target) or BuffCheck(buffname2,target)) and IsSkillUsable(skillname) then TargetUnit(target); CSBN(skillname) return end
		end
	elseif (GetNumRaidMembers()==0 and GetNumPartyMembers()==0) then
		if IsSkillUsable(skillname) then CSBN(skillname) end
	end
end



function urgent()
	if (GetNumRaidMembers()>0) then
			playertable={};	local numUnits = GetNumRaidMembers(); local totalplayers = 1;
		for i=1,numUnits,1 do
		memberName, online = GetRaidMember(i or -1);
			for ii=1,100,1 do ObjName = GetMinimapIconText( ii );
				if ObjName and ObjName==memberName and online==true and UnitHealth("raid"..i)>0 then
					mainClass, subClass = UnitClassToken("raid"..i)
					if _target==UnitName("raid"..i) and _heal>0 and _source==UnitName("player") then
					local healthcalc=(UnitHealth("raid"..i)+_heal)/UnitMaxHealth("raid"..i)
					if healthcalc>1 then healthcalc=1; end;
					playertable[totalplayers]={target="raid"..i; name=UnitName("raid"..i),health=healthcalc,main=mainClass,sub=subClass}
					totalplayers = totalplayers + 1;
					else
					local healthcalc=(UnitHealth("raid"..i))/UnitMaxHealth("raid"..i)
					playertable[totalplayers]={target="raid"..i; name=UnitName("raid"..i),health=healthcalc,main=mainClass,sub=subClass}
					totalplayers = totalplayers + 1;
					end
				end
			end
		end
		mainClass, subClass = UnitClassToken("player")
		playertable[totalplayers]={target="player", name=UnitName("player"),health=UnitHealth("player")/UnitMaxHealth("player"),main = mainClass,sub = subClass,}
		for i=1,totalplayers,1 do
			if (playertable[i].health==0) then playertable[i].priority = 0;
			elseif (playertable[i].main=="AUGUR") and (playertable[i].name == UnitName("player")) then playertable[i].priority = 0;
			elseif (playertable[i].main=="KNIGHT") or (playertable[i].main=="PSYRON") or (playertable[i].main=="WARDEN" or (playertable[i].main=="WARRIOR" and playertable[i].sub=="WARRIOR") or playertable[i].sub=="MAGE") then playertable[i].priority = 7*(1-playertable[i].health)
			elseif (playertable[i].sub=="KNIGHT") or (playertable[i].main=="PSYRON")  or (playertable[i].sub=="WARDEN") then playertable[i].priority = 4*(1-playertable[i].health)
			else playertable[i].priority = 5*(1-playertable[i].health) end;
		end
		sortTable = {}
		for i=1,#playertable,1 do table.insert(sortTable,playertable[i].priority) end
		table.sort(sortTable,function(a,b) return a>b end);
		if sortTable[1]>0 then
			for i=1,#playertable,1 do
				if playertable[i].priority == sortTable[1] then TargetUnit(playertable[i].target); if IsSkillUsable("Urgent Heal") then CSBN("Urgent Heal"); end; end
			end;
		else CSBN("Urgent Heal"); end;
	elseif (GetNumPartyMembers()>0) then
		playertable={};	local numUnits = GetNumPartyMembers(); local totalplayers = 1;
		for i=1,numUnits,1 do
		memberName, online = GetPartyMember(i or -1);
			for ii=1,100,1 do ObjName = GetMinimapIconText( ii );
				if ObjName and ObjName==memberName and online==true and UnitHealth("party"..i)>0 then
					mainClass, subClass = UnitClassToken("party"..i)
					if _target==UnitName("party"..i) and _heal>0 and _source==UnitName("player") then
					local healthcalc=(UnitHealth("party"..i)+_heal)/UnitMaxHealth("party"..i)
					if healthcalc>1 then healthcalc=1; end;
					playertable[totalplayers]={target="party"..i; name=UnitName("party"..i),health=healthcalc,main=mainClass,sub=subClass}
					totalplayers = totalplayers + 1;
					else
					local healthcalc=(UnitHealth("party"..i))/UnitMaxHealth("party"..i)
					playertable[totalplayers]={target="party"..i; name=UnitName("party"..i),health=healthcalc,main=mainClass,sub=subClass}
					totalplayers = totalplayers + 1;
					end
				end
			end
		end
		mainClass, subClass = UnitClassToken("player")
			playertable[totalplayers]={target="player", name=UnitName("player"),health=UnitHealth("player")/UnitMaxHealth("player"),main = mainClass,sub = subClass,}
		for i=1,totalplayers,1 do
			if (playertable[i].health==0) then playertable[i].priority = 0;
	elseif (playertable[i].main=="AUGUR") and (playertable[i].name == UnitName("player")) then playertable[i].priority = 0;
			elseif (playertable[i].main=="KNIGHT") or (playertable[i].main=="PSYRON") or (playertable[i].main=="WARDEN" or (playertable[i].main=="WARRIOR" and playertable[i].sub=="WARRIOR") or playertable[i].sub=="MAGE") then playertable[i].priority = 7*(1-playertable[i].health)
			elseif (playertable[i].sub=="KNIGHT") or (playertable[i].main=="PSYRON")  or (playertable[i].sub=="WARDEN") then playertable[i].priority = 4*(1-playertable[i].health)
			else playertable[i].priority = 5*(1-playertable[i].health) end;
		end
		sortTable = {}
		for i=1,#playertable,1 do table.insert(sortTable,playertable[i].priority) end
		table.sort(sortTable,function(a,b) return a>b end);
		if sortTable[1]>0 then
			for i=1,#playertable,1 do
				if playertable[i].priority == sortTable[1] then TargetUnit(playertable[i].target); if IsSkillUsable("Urgent Heal") then CSBN("Urgent Heal"); end; end			end;
		else CSBN("Urgent Heal"); end;
	elseif (GetNumRaidMembers()==0 and GetNumPartyMembers()==0) then CSBN("Urgent Heal") end
end