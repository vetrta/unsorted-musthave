-- _Gds (Gör gör det själv) Combat engine
--
-- written originally by Moo - rewritten by Vernberg

-- Locals

local ROOT = "Interface/Addons/_Gds"
local me = {
    tag = "_Gds",
    config = {
        cd = 1,
        ISS = { --70,69,66, 65
           ["Runic Charge"] = 69,
           ["Ferocious Disassembly"] = 68,
           ["Punisher's Disassembly"] = 65,
           ["Attack Stance"] = 69,
           ["Guardian of the Pass"] = 68,		   
        }
    }
}
-- Actionslots https://static.wikia.nocookie.net/runesofmagic_gamepedia/images/7/7d/UseAction.png/revision/latest?cb=20131205060811 

--Actionbarslots in order
-- ----------------------------------------------------------------------------------------------------------------
-- Bottom panel [1] [2] [3] [4] [5] [6] [7] [8] [9] [10] [11] [12] [13] [14] [15] [16] [17] [18] [19] [20]
-- ----------------------------------------------------------------------------------------------------------------
-- Top panel    [21] [22] [23] [24] [25] [26] [27] [28] [29] [30] [31] [32] [33] [34] [35] [36] [37] [38] [39] [40]
-- -----------------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Skills
------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------

-- checks if skill is usable
function me.IsSkillUsable(SkillName, ShouldUse)
    for i = 1, 4 do
        local numSkills = GetNumSkill(i)
        if numSkills then
            for j = 1, numSkills do
                local name, _, _, _, _, _, _, _, usable = GetSkillDetail(i,j)
                if string.lower(name) == string.lower(SkillName) then
                    if not usable then return end
                    local totalCD, remainingCD = GetSkillCooldown(i, j)
                    if remainingCD > me.config.cd then return end
                    if ShouldUse then
                        UseSkill(i, j)
                    end
                    return true
                end
            end
        end
    end
    return false
end

-- Cast skill by name
function me.CSBN(skillName) --me.CSBN("Skillname")
    if UnitCastingTime("player") then return end
    CastSpellByName(skillName)
end

------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Setskill
------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Checks Cooldown on ISS
function me.getSuitSkillcd(SkillName)
    local slot = me.config.ISS[SkillName]
    if not slot then return 0 end
    local total, remaining = GetActionCooldown(slot)
    return remaining < me.config.cd
end

-- Check if ISS is ready
function me.IsAvailableSuitSkill(SkillName)
    for index = 0, (SkillPlateUpdate(-1) - 1) do
        if SkillPlateUpdate(index) == SkillName then
            return me.getSuitSkillcd(SkillName)
        end
    end
    return false
end

------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Food and or Items
------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------

-- IsBagItemUsable
function me.IsBagItemUsable(itemname) --me.IsBagItemUsable("ITEMNAME")
    if GetCountInBagByName(itemname) == 0 then return end
    for i = 1, 180 do
        local inventoryIndex, icon, name, itemCount, locked, invalid = GetBagItemInfo ( i )
        if (name == itemname) then
            if (locked == true) then return end
            local maxCD, CurrentCD = GetBagItemCooldown ( inventoryIndex )
            return CurrentCD <= me.config.cd
        end
    end
end

function me.UseItem(name) --UseItem("ITEMNAME")
 UseItemByName(name)
end

------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Functions repair
------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
function me.repair()
    for i=0,22,1 do 
        local dV,dM,iN,dVf,dMf = GetInventoryItemDurable("player",i);
        if (iN) then
            if ((dMf>10100 and 10100>dVf) or (7000>dVf)) then 
                UseItemByName(TEXT("Sys201967_name"))
                PickupEquipmentItem(i)
                print(iN..": Repaired") 
                return
            end
        end
    end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
-- PSI
------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------

function me.playerSoulPoint(min, max) --me.playerSoulPoint(min, max)
    min = min or 0
     max = max or 6
     local point, _ = GetSoulPoint()
    return min <= point and point <= max
end

------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Autoshot
------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------

function me.Autoshot()
    local mainClass, subClass = UnitClassToken("player")
    if mainClass ~= "RANGER" then return end
    for i = 1, 80 do
        local a1,a2,a3,a4,a5,ASon = GetActionInfo(i)
        if tostring(a1):find("skill_ran_new35%-7") then
            if not ASon then
                UseAction(i)
            end
            return
        end
    end
    for i = 80, 1, -1 do
        if not GetActionInfo(i) then
            SetAction(i, 492589)
        end
        local a1,a2,a3,a4,a5,ASon = GetActionInfo(i)
        if not ASon then
            UseAction(i)
        end
        SetAction(i, 0)
    end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Buffs/Debuffs
------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------

-- checks if player has a specified buffTimeleft
function me.BuffTimeLeft(buffname, unit)
    unit = unit or "player"
    for i = 1, 50 do
        local name = UnitBuff(unit, i)
        if not name then return 0 end
        if string.lower(name) == string.lower(buffname) then
            return UnitBuffLeftTime(unit, i)
        end
    end
    return 0
end

-- Buffcheck
function me.BuffCheck(buffname, unit)
    unit = unit or "player"
    for i=1,50 do
        local currentbuffname, _, currentbuffcount, currentbuffid = UnitBuff(unit, i)
        if not currentbuffname then return end
        if string.lower(currentbuffname) == string.lower(buffname) then
            return true, currentbuffcount, UnitBuffLeftTime(unit,i)
        end
    end
end

-- Debuffcheck
function me.DebuffCheck(buffname, unit)
    unit = unit or "player"
    for i=1,50 do
        local currentbuffname, _, currentbuffcount, currentbuffid = UnitDebuff(unit, i)
        if not currentbuffname then return end
        if string.lower(currentbuffname) == string.lower(buffname) then
            return true, currentbuffcount, UnitDebuffLeftTime(unit,i)
        end
    end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Health
------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------

function me.GetUnitHealthPerc(unit)
    unit = unit or "player"

    return UnitHealth(unit) / UnitMaxHealth(unit)
end

------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Rotation 
------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------

function me.Rota(key)
    local mc, sc = UnitClassToken("player")
    local func = string.format("%s_%s", mc, sc)
    if key then
    func = func .. "_" .. key
    end
    if me[func] then
        me[func]()
    end
end
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


-- Memory Table for futher class making
---------------------------------------------------------------------------------------------------------------------------------------------------------

-- me.CSBN("Skillname")

-- UnitMana("player")>0 Current amount of Mana / Rage / Energy /Focus of the primary class
-- UnitSkill("player")>0 Current amount of Mana / Rage / Energy /Focus of the secondary class
-- me.playerSoulPoint(min, max) 
-- me.IsSkillUsable("SKILLNAME")
-- me.BuffCheck("buffname", "unit")
-- me.DeuffCheck("buffname", "unit")
-- me.BuffTimeLeft("buffname", "unit")
-- me.IsBagItemUsable("ITEMNAME")
-- me.GetUnitHealthPerc("player"/"Target") < 0.1 lower
-- me.GetUnitHealthPerc() > 0.1 Above
-- GetPlayerCombatState()  (noarguments)
-- UseItemByName("Potion of Focused Will")


--        print("Fearless blow done")
 --       print("check buff: ", not bool or stacks < 3 or timeleft < 3) 
--        print("usable: ", me.IsSkillUsable("Heavy Bash")) 
--        print("mana:", UnitMana("player"))

 --       print("exists")
--        print("shadowstab done")
------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Functions for class specific rotations
------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
--Champion
------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------

function me.PSYRON_THIEF_Tank() --Champion/Rogue Tank
 -- Buffs
    if not me.BuffCheck("Shield Form", "player") and me.IsSkillUsable("Shield Form") then me.CSBN("Shield Form") return end
    if not me.BuffCheck("Attack Is the Best Defense", "player") and me.IsAvailableSuitSkill("Attack Is the Best Defense") and UnitMana("player") >= 30 then me.CSBN("Attack Is the Best Defense") return end
    if not me.BuffCheck("Forge", "player") and me.IsSkillUsable("Forge") then me.CSBN("Forge") return end
    if not me.BuffCheck("Rune Growth", "player") and me.IsSkillUsable("Rune Growth") then me.CSBN("Rune Growth") return end
 -- Aggro
    if me.IsSkillUsable("Rune Energy Influx") and UnitMana("player") >= 10 then me.CSBN("Rune Energy Influx") return end
 -- Low HP skills      
    if me.GetUnitHealthPerc() < 0.9 and me.IsSkillUsable("Waiting Game") then me.CSBN("Waiting Game") return end
    if me.GetUnitHealthPerc() < 0.5 and not me.BuffCheck("Feedback Defense") and me.IsSkillUsable("Feedback Defense") then me.CSBN("Feedback Defense") return end
    if me.GetUnitHealthPerc() < 0.1 and not me.BuffCheck("Remodeled Body") and me.IsSkillUsable("Remodeled Body") then me.CSBN("Remodeled Body") return end
 -- Low Rage    
    if UnitMana("player") < 20 and me.IsAvailableSuitSkill("Runic Charge") then me.CSBN("Runic Charge") return end
 -- Target    
    if UnitExists("target") and UnitHealth("target") > 0 and UnitCanAttack("player","target") then
        UseSkill(1, 1)
 -- Rotation        
        if me.BuffCheck("Chain Drive") and me.IsSkillUsable("Rune Pulse") then me.CSBN("Rune Pulse") return end
        if me.IsSkillUsable("Throw") then me.CSBN("Throw") return end
        if me.IsSkillUsable("Shadowstab") and UnitSkill("player") > 20 then me.CSBN("Shadowstab") return end
    end
end

function me.PSYRON_WARRIOR_Tank() --Champion/Warrior Tank
    local bool, stacks, timeleft = me.DeuffCheck("Heavy Bash","target")    
 -- Buffs
    if not me.BuffCheck("Shield Form", "player") and me.IsSkillUsable("Shield Form") then me.CSBN("Shield Form") return end
    if not me.BuffCheck("Attack Is the Best Defense", "player") and me.IsAvailableSuitSkill("Attack Is the Best Defense") and UnitMana("player") >= 30 then me.CSBN("Attack Is the Best Defense") return end
    if not me.BuffCheck("Forge", "player") and me.IsSkillUsable("Forge") then me.CSBN("Forge") return end
    if not me.BuffCheck("Rune Growth", "player") and me.IsSkillUsable("Rune Growth") then me.CSBN("Rune Growth") return end
 -- Aggro
    if me.IsSkillUsable("Rune Energy Influx") and UnitMana("player") >= 10 then me.CSBN("Rune Energy Influx") return end
 -- Low HP skills   
    if me.GetUnitHealthPerc() < 0.95 and me.IsSkillUsable("Determination Rune", "player") then me.CSBN("Determination Rune") return end
    if me.GetUnitHealthPerc() < 0.6 and not me.BuffCheck("Eye for an Eye", "player") and me.IsSkillUsable("Eye for an Eye") then me.CSBN("Eye for an Eye") return end
    if me.GetUnitHealthPerc() < 0.4 and not me.BuffCheck("Feedback Defense", "player") and me.IsSkillUsable("Feedback Defense") then me.CSBN("Feedback Defense") return end
    if me.GetUnitHealthPerc() < 0.1 and not me.BuffCheck("Remodeled Body", "player") and me.IsSkillUsable("Remodeled Body") then me.CSBN("Remodeled Body") return end   
-- Low Rage
    if UnitMana("player") < 20 and me.IsAvailableSuitSkill("Runic Charge") then me.CSBN("Runic Charge") return end
-- Target
    if UnitExists("target") and UnitHealth("target") > 0 and UnitCanAttack("player","target") then
        UseSkill(1, 1)
 -- Rotation       
        if me.BuffCheck("Chain Drive", "player") and me.IsSkillUsable("Rune Pulse") then me.CSBN("Rune Pulse") return end
        if me.IsSkillUsable("Shock Strike") and UnitMana("player") > 25 then me.CSBN("Shock Strike") return end        
        if (stacks < 3 or timeleft < 3) and me.IsSkillUsable("Heavy Bash") then me.CSBN("Heavy Bash") return end
    end
end


function me.PSYRON_THIEF_Dps() --Champion/Rogue DPS
    -- Buffs
    if not me.BuffCheck("Shadow Explosion", "player") and me.IsSkillUsable("Shadow Explosion") then  me.CSBN("Shadow Explosion") return end
    if not me.BuffCheck("Forge", "player") and me.IsSkillUsable("Forge") then me.CSBN("Forge") return end
	if GetPlayerCombatState() and not me.BuffCheck("Attack Rune Growth", "player") and me.IsSkillUsable("Rune Growth") then me.CSBN("Rune Growth") return end	
  -- Low PH  
    if me.GetUnitHealthPerc() < 0.9 and me.IsSkillUsable("Waiting Game") then me.CSBN("Waiting Game") return end
 -- Low Rage   
    if UnitMana("player") < 20 and me.IsAvailableSuitSkill("Runic Charge") then me.CSBN("Runic Charge") return end
 -- Interuption and target   
    if UnitExists("target") and UnitHealth("target") > 0 and UnitCanAttack("player","target") then
 -- Rotation       
        UseSkill(1, 1)
        if me.BuffCheck("Chain Drive", "player") and me.IsSkillUsable("Rune Pulse") then me.CSBN("Rune Pulse") return end
        if me.IsSkillUsable("Throw") then me.CSBN("Throw") return end
        if me.IsSkillUsable("Shadowstab") and UnitSkill("player") > 20 then me.CSBN("Shadowstab") return end
    end
end


function me.PSYRON_THIEF_Dpstwo() --Champion/Rogue DPS
    local bool, stacks, timeleft = me.DebuffCheck("Heavy Bash","target") 
    -- Buffs
    if not me.BuffCheck("Shadow Explosion", "player") and me.IsSkillUsable("Shadow Explosion") then  me.CSBN("Shadow Explosion") return end
    if not me.BuffCheck("Forge", "player") and me.IsSkillUsable("Forge") then me.CSBN("Forge") return end
	if GetPlayerCombatState() and not me.BuffCheck("Attack Rune Growth", "player") and me.IsSkillUsable("Rune Growth") then me.CSBN("Rune Growth") return end	
  -- Low PH  
    if me.GetUnitHealthPerc() < 0.9 and me.IsSkillUsable("Waiting Game") then me.CSBN("Waiting Game") return end
 -- Low Rage   
    if UnitMana("player") < 20 and me.IsAvailableSuitSkill("Runic Charge") then me.CSBN("Runic Charge") return end


--	if UnitMana("player") < 20 then
--	if me.IsAvailableSuitSkill("Runic Charge") then me.CSBN("Runic Charge") return end	
--	if me.IsBagItemUsable("Strength of Battle") then UseItemByName("Strength of Battle")
--end
	
 -- Interuption and target   
    if UnitExists("target") and UnitHealth("target") > 0 and UnitCanAttack("player","target") then

 -- Rotation       
        UseSkill(1, 1)
	
        if me.BuffCheck("Chain Drive", "player") and me.IsSkillUsable("Rune Pulse") then me.CSBN("Rune Pulse") return end	
	
        if me.IsSkillUsable("Throw") then me.CSBN("Throw") return end
	
        if me.IsSkillUsable("Shadowstab") and UnitSkill("player") > 20 then me.CSBN("Shadowstab") return end
		
 --       if me.IsSkillUsable("Fearless Blows") and UnitHealth("Target") < 45 and UnitMana("player") > 15 then me.CSBN("Fearless Blows") return end	

		if (not bool or stacks < 3 or timeleft < 3) and me.IsSkillUsable("Heavy Bash") and UnitMana("player") > 15 then me.CSBN("Heavy Bash") return end
		
    end
end

function me.PSYRON_THIEF_Dpst() --Champion/Rogue DPS
    local bool, stacks, timeleft = me.DebuffCheck("Heavy Bash", "target") 
	
    -- Buffs
    if not me.BuffCheck("Shadow Explosion", "player") and me.IsSkillUsable("Shadow Explosion") then  me.CSBN("Shadow Explosion") return end
	
    if not me.BuffCheck("Forge", "player") and me.IsSkillUsable("Forge") then me.CSBN("Forge") return end
	
	if GetPlayerCombatState() and not me.BuffCheck("Attack Rune Growth", "player") and me.IsSkillUsable("Rune Growth") then me.CSBN("Rune Growth") return end	
	
  -- Low PH  
    if me.GetUnitHealthPerc() < 0.9 and me.IsSkillUsable("Waiting Game") then me.CSBN("Waiting Game") return end
	
 -- Low Rage   
    if UnitMana("player") < 20 and me.IsAvailableSuitSkill("Runic Charge") then me.CSBN("Runic Charge") return end


--	if UnitMana("player") < 20 then
--	if me.IsAvailableSuitSkill("Runic Charge") then me.CSBN("Runic Charge") return end	
--	if me.IsBagItemUsable("Strength of Battle") then UseItemByName("Strength of Battle")
--end
	
 -- Interuption and target   
    if UnitExists("target") and UnitHealth("target") > 0 and UnitCanAttack("player","target") then

 -- Rotation       
        UseSkill(1, 1)
			
        if me.BuffCheck("Chain Drive", "player") and me.IsSkillUsable("Rune Pulse") then me.CSBN("Rune Pulse") return end	
	
        if me.IsSkillUsable("Throw") then me.CSBN("Throw") return end
	
        if me.IsSkillUsable("Shadowstab") and UnitSkill("player")>20 then me.CSBN("Shadowstab") return end
		
--        if me.IsSkillUsable("Fearless Blows") and UnitHealth("Target") < 45 then me.CSBN("Fearless Blows") return end	
 
 		if (not bool or stacks < 3 or timeleft < 3) and me.IsSkillUsable("Heavy Bash") then me.CSBN("Heavy Bash") return end	
		
    end
end

function me.PSYRON_THIEF_Dpstt() --Champion/Rogue DPS
local mainClass, subClass = UnitClassToken("player")
if mainClass=="PSYRON" then
	if subClass=="THIEF" then
    local bool, stacks, timeleft = me.DebuffCheck("Heavy Bash", "target"); 
	
    -- Buffs
    if not me.BuffCheck("Shadow Explosion", "player") and me.IsSkillUsable("Shadow Explosion") then  me.CSBN("Shadow Explosion")
	
    elseif not me.BuffCheck("Forge", "player") and me.IsSkillUsable("Forge") then me.CSBN("Forge")
	
	elseif GetPlayerCombatState() and not me.BuffCheck("Attack Rune Growth", "player") and me.IsSkillUsable("Rune Growth") then me.CSBN("Rune Growth")
	
  -- Low PH  
    elseif me.GetUnitHealthPerc()<0.9 and me.IsSkillUsable("Waiting Game") then me.CSBN("Waiting Game")
	
 -- Low Rage   
    elseif UnitMana("player")<20 and me.IsAvailableSuitSkill("Runic Charge") then me.CSBN("Runic Charge")


--	if UnitMana("player") < 20 then
--	if me.IsAvailableSuitSkill("Runic Charge") then me.CSBN("Runic Charge") return end	
--	if me.IsBagItemUsable("Strength of Battle") then UseItemByName("Strength of Battle")
--end
	
 -- Interuption and target   
    elseif UnitExists("target") and UnitHealth("target")>0 and UnitCanAttack("player","target") then

 -- Rotation       
        UseSkill(1,1);
		if UnitCanAttack("player","target") then
		
        if me.BuffCheck("Chain Drive", "player") and me.IsSkillUsable("Rune Pulse") then me.CSBN("Rune Pulse")	
	
        elseif me.IsSkillUsable("Throw") then me.CSBN("Throw") return end
	
        elseif me.IsSkillUsable("Shadowstab") and UnitSkill("player")>20 then me.CSBN("Shadowstab")
		
        elseif me.IsSkillUsable("Fearless Blows") and UnitHealth("Target")<45 and UnitMana("player")>15 then me.CSBN("Fearless Blows")	
 
 		elseif (not bool or stacks < 3 or timeleft < 3) and me.IsSkillUsable("Heavy Bash") and UnitMana("player")>15 then me.CSBN("Heavy Bash")	
		
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

function me.HARPSYN_MAGE_Wl() --Warlock/mage
    local bool, stacks, timeleft = me.DebuffCheck("Soul Brand","target")    	
-- Buffs
    if not me.BuffCheck("Sublimation Weave Curse", "player") and me.IsSkillUsable("Sublimation Weave Curse") then me.CSBN("Sublimation Weave Curse") return end
-- No focus
    if UnitMana("player") < 30 and me.IsBagItemUsable("Potion of Focused Will") then UseItemByName("Potion of Focused Will") return end
-- Low PH	
    if me.GetUnitHealthPerc() < 0.95 and not me.BuffCheck("Shield of Solid Mind", "player") and me.IsSkillUsable("Shield of Solid Mind") and UnitMana("player") > 35 then me.CSBN("Shield of Solid Mind") return end
-- Target
    if UnitExists("target") and UnitHealth("target") > 0 and UnitCanAttack("player","target") then		
-- Rotation
    if not me.DebuffCheck("Authoritative Deterrence", "target") and me.IsSkillUsable("Silence") and UnitSkill("player") > 300 then me.CSBN("Silence") return end
    if me.IsSkillUsable("Warp Charge") and UnitMana("player") > 30 then me.CSBN("Warp Charge") return end
	if (not bool or stacks < 4 or timeleft < 4) and me.IsSkillUsable("Perception Extraction") then me.CSBN("Perception Extraction") return end  
    if me.IsSkillUsable("Heart Collection Strike") then me.CSBN("Heart Collection Strike") return end  	

    
    end
end

function me.HARPSYN_MAGE_W() --Warlock/mage
	FocusUnit(1,"raid5")
	TargetUnit("focus1target");
    local bool, stacks, timeleft = me.DebuffCheck("Soul Brand","target")    	
-- Buffs
    if not me.BuffCheck("Sublimation Weave Curse", "player") and me.IsSkillUsable("Sublimation Weave Curse") then me.CSBN("Sublimation Weave Curse") return end
-- No focus
    if me.IsBagItemUsable("Potion of Focused Will") and UnitMana("player") < 30 then UseItemByName("Potion of Focused Will") return end
-- Low PH	
    if me.GetUnitHealthPerc() < 0.95 and not me.BuffCheck("Shield of Solid Mind", "player") and me.IsSkillUsable("Shield of Solid Mind") and UnitMana("player") > 35 then me.CSBN("Shield of Solid Mind") return end
-- Target
    if UnitExists("target") and UnitHealth("target") > 0 and UnitCanAttack("player","target") then		
-- Rotation
    if not me.DebuffCheck("Authoritative Deterrence", "target") and me.IsSkillUsable("Silence") and UnitSkill("player") > 300 then me.CSBN("Silence") return end
    if me.IsSkillUsable("Warp Charge") and UnitMana("player") > 30 then me.CSBN("Warp Charge") return end
	if (not bool or stacks < 4 or timeleft < 4) and me.IsSkillUsable("Perception Extraction") then me.CSBN("Perception Extraction") return end  
    if me.IsSkillUsable("Heart Collection Strike") then me.CSBN("Heart Collection Strike") return end  	

    
    end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------  
--Mage
------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------

function me.MAGE_HARPSYN_Mwlf()	--Mage/warlock
-- Buffs
    if not me.BuffCheck("Energy Influx", "player") and me.IsSkillUsable("Energy Influx") then me.CSBN("Energy Influx") return end
    if UnitExists("target") and UnitHealth("target") > 0 and UnitCanAttack("player","target") then
-- Rotation
    if not me.DebuffCheck("Elemental Weakness", "target") and me.IsSkillUsable("Elemental Weakness") and UnitMana("player") > 500 then me.CSBN("Elemental Weakness") return end
    if me.IsSkillUsable("Fireball") and UnitMana("player") > 180 then me.CSBN("Fireball") return end   
    if me.DebuffCheck("Elemental Weakness", "target") and me.IsSkillUsable("Flame") and UnitMana("player") > 300 then me.CSBN("Flame") return end		
     end				
end

function me.MAGE_HARPSYN_Mwl()	--Mage/warlock
-- Buffs
    if not me.BuffCheck("Energy Influx", "player") and me.IsSkillUsable("Energy Influx") then me.CSBN("Energy Influx") return end
	if GetPlayerCombatState() and not me.BuffCheck("Soul Stepping", "player") and me.IsSkillUsable("Soul Stepping") then me.CSBN("Soul Stepping") return end
    if UnitExists("target") and UnitHealth("target") > 0 and UnitCanAttack("player","target") then
-- Rotation
    if not me.DebuffCheck("Elemental Weakness", "target") and me.IsSkillUsable("Elemental Weakness") and UnitMana("player") > 500 then me.CSBN("Elemental Weakness") return end 
    if me.DebuffCheck("Elemental Weakness", "target") and me.IsSkillUsable("Electric Explosion") and UnitMana("player") > 80 then me.CSBN("Electric Explosion") return end		
     end				
end




function me.MAGE_HARPSYN_M()	--Mage/warlock
		FocusUnit(1,"raid5")
		TargetUnit("focus1target");
-- Buffs
    if not me.BuffCheck("Energy Influx", "player") and me.IsSkillUsable("Energy Influx") then me.CSBN("Energy Influx") return end
	if GetPlayerCombatState() and not me.BuffCheck("Soul Stepping", "player") and me.IsSkillUsable("Soul Stepping") then me.CSBN("Soul Stepping") return end
    if UnitExists("target") and UnitHealth("target") > 0 and UnitCanAttack("player","target") then
-- Rotation
    if not me.DebuffCheck("Elemental Weakness", "target") and me.IsSkillUsable("Elemental Weakness") and UnitMana("player") > 500 then me.CSBN("Elemental Weakness") return end 
    if me.DebuffCheck("Elemental Weakness", "target") and me.IsSkillUsable("Electric Explosion") and UnitMana("player") > 80 then me.CSBN("Electric Explosion") return end		
     end				
end
------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------  
--Warrior
------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------



function me.WARRIOR_THIEF_Dps() --Warrior/Rogue DPS
    -- Buffs
    if not me.BuffCheck("Guardian of the Pass", "player") and me.IsAvailableSuitSkill("Guardian of the Pass") then  me.CSBN("Guardian of the Pass") return end	
  -- Low PH  
--    if me.GetUnitHealthPerc() < 0.9 and me.IsSkillUsable("Waiting Game") then me.CSBN("Waiting Game") return end
 -- Low Rage   
--    if UnitMana("player") < 20 and me.IsAvailableSuitSkill("Runic Charge") then me.CSBN("Runic Charge") return end
 -- Interuption and target   
    if UnitExists("target") and UnitHealth("target") > 0 and UnitCanAttack("player","target") then
 -- Rotation       
        UseSkill(1, 1)		
        if not me.DebuffCheck("Vulnerable","target") and me.IsSkillUsable("Probing Attack") and UnitMana("player") > 20 then me.CSBN("Probing Attack") return end	
        if me.DebuffCheck("Vulnerable","target") and me.IsSkillUsable("Open Flank") and UnitMana("player") > 10 then me.CSBN("Open Flank") return end	
 --       if me.DebuffCheck("Vulnerable","target") and me.IsSkillUsable("Keen Attack") and UnitSkill("player") > 20 then me.CSBN("Keen Attack") return end			
        if me.DebuffCheck("Weakened","target") and me.IsSkillUsable("Thunder") and UnitMana("player") > 15 then me.CSBN("Thunder") return end
--        if me.DebuffCheck("Weakened","target") and me.IsSkillUsable("Splitting Chop") and UnitMana("player") > 15 then me.CSBN("Splitting Chop") return end		
        if me.IsSkillUsable("Throw") then me.CSBN("Throw") return end	
        if me.IsSkillUsable("Shadowstab") and UnitSkill("player") > 20 then me.CSBN("Shadowstab") return end
    end
end



function me.WARRIOR_PSYRON_Dps() --Warrior/Champion DPS
    local bool, stacks, timeleft = me.DebuffCheck("Heavy Bash","target") 
    -- Buffs
    if not me.BuffCheck("Guardian of the Pass", "player") and me.IsAvailableSuitSkill("Guardian of the Pass") then  me.CSBN("Guardian of the Pass") return end	

 -- Interuption and target   
    if UnitExists("target") and UnitHealth("target") > 0 and UnitCanAttack("player","target") then
 -- Rotation       
        UseSkill(1, 1)
		if not me.BuffCheck("Wild Slash", "player") and me.IsSkillUsable("Slash") then  me.CSBN("Slash") return end		
        if (not bool or stacks < 3 or timeleft < 3)  and me.IsSkillUsable("Heavy Bash") and UnitMana("player") > 20 then me.CSBN("Heavy Bash") return end			
        if not me.DebuffCheck("Stifling Attack","target") and me.IsSkillUsable("Stifling Attack") and UnitHealth("player") > 15 then me.CSBN("Stifling Attack") return end
        if not me.DebuffCheck("Vulnerable","target") and me.IsSkillUsable("Probing Attack") and UnitMana("player") > 20 then me.CSBN("Probing Attack") return end			
        if me.DebuffCheck("Vulnerable","target") and me.IsAvailableSuitSkill("Attack Stance") and UnitMana("player") > 20 then me.CSBN("Attack Stance") return end	
        if me.DebuffCheck("Vulnerable","target") and me.IsSkillUsable("Open Flank") and UnitMana("player") > 10 then me.CSBN("Open Flank") return end	
        if me.DebuffCheck("Weakened","target") and me.IsSkillUsable("Thunder") and UnitMana("player") > 15 then me.CSBN("Thunder") return end
    end
end
		
		
_G[me.tag] = me	