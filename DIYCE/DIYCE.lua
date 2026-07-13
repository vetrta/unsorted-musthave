-- Based on DIY Combat Engine:0.3
-- Made by:Vernberg
------------------------
------------------------
function OnLoad(this)
this:RegisterEvent("EXCHANGECLASS_SUCCESS");
end;
------------------------
------------------------
function OnEvent(this, event)
if (event =="EXCHANGECLASS_SUCCESS") then
ReadSkills();
end; 
end;
------------------------
------------------------
g_skill = {}
local g_skill = {}
local g_lastaction = ""
local Timers = {}
------------------------
-- Tick down any active timers
------------------------
function TimerUpdate(elapsed)
    for k,v in pairs(Timers) do
        v.timeLeft = v.timeLeft - elapsed
        if v.timeLeft < 0 then
            v.timeLeft = 0
        end
    end
end
------------------------
-- if the named timer already exists, this does nothing
------------------------
function CreateTimer(timerName, waitTime)
    if not Timers[timerName] then
        Timers[timerName] = { timeLeft = 0, waitTime = waitTime }
    end
end
------------------------
-- Set/reset waitTimer of an existing timer
------------------------
function SetTimerDelay(timerName, waitTime)
    if Timers[timerName] then
        Timers[timerName].waitTime = waitTime
    end
end
------------------------
-- Delete named timer
------------------------
function DeleteTimer(timerName)
    if Timers[timerName] then
        Timers[timerName] = nil
    end
end
------------------------
-- Get a timer's current time
------------------------
function GetTimerValue(timerName)
    if timerName then
        return Timers[timerName] and Timers[timerName].timeLeft or 0
    end
    return 0
end
------------------------ 
-- Starts a timer ticking down
------------------------
function StartTimer(timerName)
    if timerName and Timers[timerName] then
        Timers[timerName].timeLeft = Timers[timerName].waitTime
    end
end
------------------------
-- CostumAction
------------------------
function CustomAction(action)
    if CD(action) then
        if IsShiftKeyDown() then Msg("- "..action) end
        g_lastaction = action
        CastSpellByName(action)
        return true
    else
        return false
    end
end
------------------------
-- Display msg
------------------------
function Msg(outstr,a1,a2,a3)
    DEFAULT_CHAT_FRAME:AddMessage(tostring(outstr),a1,a2,a3)
end
------------------------
-- Read skills into g_skill table at login --
------------------------
function ReadSkills()
	g_skill = {}
	local skillname,slot

	Msg("- Reading Class Skills")
	for page = 1,4 do
		slot = 1
		skillname = GetSkillDetail(page,slot)
		repeat
			local a1,a2,a3,a4,a5,a6,a7,a8,skillusable = GetSkillDetail(page,slot)
			if skillusable then
				g_skill[skillname] = { ["page"] = page, ["slot"] = slot }
			end
			slot = slot + 1
			skillname = GetSkillDetail(page,slot)
		until skillname == nil
	end
end
ReadSkills()
------------------------
-- Unit, Mana-Health-Skill
------------------------
function PctH(tgt)
	return (UnitHealth(tgt)/UnitMaxHealth(tgt))
end

function PctM(tgt)
	return (UnitMana(tgt)/UnitMaxMana(tgt))
end

function PctS(tgt)
	return (UnitSkill(tgt)/UnitMaxSkill(tgt))
end
------------------------
------------------------
function CancelBuff(buffname)
	local i = 1
	local buff = UnitBuff("player",i)

	while buff ~= nil do
		if buff == buffname then
			CancelPlayerBuff(i)
			return true
		end

		i = i + 1
		buff = UnitBuff("player",i)
	end
	return false
end
------------------------
------------------------
function BuffTimeLeft(tgt, buffname)
    local cnt = 1
    local buffcmd, bufftimecmd, buff

    if UnitCanAttack("player", tgt) then
        buffcmd = UnitDebuff
        bufftimecmd = UnitDebuffLeftTime
    else
        buffcmd = UnitBuff
        bufftimecmd = UnitBuffLeftTime
    end

    buff = buffcmd(tgt, cnt)

    while buff ~= nil do
        if string.find(buff, buffname) then
            return bufftimecmd(tgt, cnt)
        end
        cnt = cnt + 1
        buff = buffcmd(tgt, cnt)
    end

    return 0
end
------------------------
------------------------
function BuffTimeLeft(tgt, buffname)
    local cnt = 1
    local buff = UnitBuff(tgt,cnt)
 
    while buff ~= nil do
        if string.find(buff,buffname) then
            return UnitBuffLeftTime(tgt,cnt)
        end
        cnt = cnt + 1
        buff = UnitBuff(tgt,cnt)
    end
 
    return 0
end
------------------------
------------------------
function BuffTimeLeft(tgt, buffname)
    local cnt = 1
    local buffcmd, bufftimecmd, buff

    if UnitCanAttack("player", tgt) then
        buffcmd = UnitDebuff
        bufftimecmd = UnitDebuffLeftTime
    else
        buffcmd = UnitBuff
        bufftimecmd = UnitBuffLeftTime
    end

    buff = buffcmd(tgt, cnt)

    while buff ~= nil do
        if string.find(buff, buffname) then
            return bufftimecmd(tgt, cnt)
        end
        cnt = cnt + 1
        buff = buffcmd(tgt, cnt)
    end

    return 0
end
------------------------
------------------------
function ChkBuff(tgt,buffname)
	local cnt = 1
	local buffcmd = UnitBuff

	if UnitCanAttack("player",tgt) then
		buffcmd = UnitDebuff
	end
	local buff = buffcmd(tgt,cnt)

	while buff ~= nil do
		if string.gsub(buff, "(%()(.)(%))", "%2") == buffname then
			return true
		end
		cnt = cnt + 1
		buff = buffcmd(tgt,cnt)
	end
	return false
end
------------------------
------------------------
function BuffList(tgt)
    local cnt = 1
    local buffcmd = UnitBuff
    local buffstr = "/"
    if UnitCanAttack("player",tgt) then
        buffcmd = UnitDebuff
    end
    local buff = buffcmd(tgt,cnt)
    while buff ~= nil do
        buffstr = buffstr..buff.."/"
        cnt = cnt + 1
        buff = buffcmd(tgt,cnt)
    end
    return string.gsub(buffstr, "(%()(.)(%))", "%2")
end
------------------------
------------------------
function DebuffList(tgt)
local cnt = 1
local buffcmd = UnitDebuff
local buffstr = "/"

if UnitCanAttack("player",tgt) then
buffcmd = UnitBuff
end
local buff = buffcmd(tgt,cnt)

while buff ~= nil do
buffstr = buffstr..buff.."/"
cnt = cnt + 1
buff = buffcmd(tgt,cnt)
end

return string.gsub(buffstr, "(%()(.*)(%))", "%2")
end
------------------------
------------------------
function BuffList(tgt)
    local cnt = 1
    local buffcmd = UnitBuff
    local buffstr = "/"

    if UnitCanAttack("player",tgt) then
        buffcmd = UnitDebuff
    end
    local buff = buffcmd(tgt,cnt)

    while buff ~= nil do
        buffstr = buffstr..buff.."/"
        cnt = cnt + 1
        buff = buffcmd(tgt,cnt)
    end

    return string.gsub(buffstr, "(%()(.)(%))", "%2")
end
------------------------
------------------------
function CD(skillname)
	local firstskill = GetSkillDetail(2,1)
	if (g_skill[firstskill] == nil) or (g_skill[firstskill].page ~= 2) then
		ReadSkills()
	end

	if g_skill[skillname] ~= nil then
		local tt,cd = GetSkillCooldown(g_skill[skillname].page,g_skill[skillname].slot)
		return cd<=0.5
	elseif skillname == nil then
		return false
	else
		Msg("Skill not available: "..skillname)
		return false
	end
end
------------------------
------------------------
function MyCombat(Skill, arg1)
	local spell_name = UnitCastingTime("player")
	local talktome = ((arg1 == "v1") or (arg1 == "v2"))
	local action,actioncd,actiondef,actioncnt
	
	if spell_name ~= nil then
		if (arg1 == "v2") then Msg("- ["..spell_name.."]", 0, 1, 1) end
		return true
	end

	for x,tbl in ipairs(Skill) do
		if Skill[x].use then
			if string.find(Skill[x].name, "Action:") then
				action = tonumber((string.gsub(Skill[x].name, "(Action:)( *)(%d+)(.*)", "%3")))
				_1,actioncd = GetActionCooldown(action)
				actiondef,_1,actioncnt = GetActionInfo(action)
				if GetActionUsable(action) and (actioncd <= 0.5) and (actiondef ~= nil) and (actioncnt > 0) then
					if talktome then Msg("- "..Skill[x].name) end
					UseAction(action)
					return true
				end
			elseif string.find(Skill[x].name, "Custom:") then
				action = string.gsub(Skill[x].name, "(Custom:)( *)(.*)", "%3")
				if CustomAction(action) then
					return true
				end
			elseif string.find(Skill[x].name, "Item:") then
				action = string.gsub(Skill[x].name, "(Item:)( *)(.*)", "%3")
				if talktome then Msg("- "..Skill[x].name) end
				UseItemByName(action)
				return true
			elseif CD(Skill[x].name) then
				if talktome then Msg("- "..Skill[x].name) end
				CastSpellByName(Skill[x].name)
				return true
			end
		end
	end
	if (arg1 == "v2") then Msg("- [IDLE]", 0, 1, 1) end

	return false
end

------------------------
------------------------
------ Help table ------
------------------------
------------------------
-- Mana
-- Focus is also PSI
-- Energy
-- Rage
--   local XXXX = UnitMana("player") -- What does main class use
--   local XXXX = UnitSkill("player") -- What does secondary class use

  function actionbar(arg1,arg2) 

   local Skill = {} 
   local i = 0 
   local energy = UnitMana("player") 
   local mana  = UnitSkill("player")
   local friendly = (not UnitCanAttack("player", "target")) 
   local combat = GetPlayerCombatState() 
   local pbuffs = BuffList("player") 
   local tbuffs = BuffList("target")    
   
   i=i+1; Skill[i] = { ['name'] = "Action: 3",   use = ((not friendly) and (energy >=35)) }

   MyCombat(Skill,arg1) 

end 
------------------------
------------------------
-- Warrior/Scout --
------------------------
------------------------
  function Ws(arg1)
    local Skill = {}
    local i = 0
    local rage = UnitMana("player")
    local focus  = UnitSkill("player")
    local enemy = UnitCanAttack("player","target")
    local tspell,ttime,telapsed = UnitCastingTime("target")
    local combat = GetPlayerCombatState()
--	
    local pbuffs = BuffList("player") 
    local tbuffs = BuffList("target")
    local dbuffs = DebuffList("player")	
    local health,buffs	
--	
    local tclass = UnitClass("target");
    local health = PctH(tgt) 	
	local cd,tt

	i=i+1; Skill[i] = { name = "Slash",                    use = ((not friendly) and (not string.find(tbuffs, "Bleed") and (rage >= 25))) }
	i=i+1; Skill[i] = { name = "Tactical Attack",          use = ((not friendly) and (string.find(tbuffs, "Bleed") and (rage >= 15))) }
	i=i+1; Skill[i] = { name = "Probing Attack",           use = ((not friendly) and (not string.find(tbuffs, "Vulnerable") and (string.find(tbuffs, "Bleed") and (rage >= 20)))) }	
	i=i+1; Skill[i] = { name = "Open Flank",               use = ((not friendly) and (string.find(tbuffs, "Vulnerable") and (string.find(tbuffs, "Bleed") and (rage >= 10)))) }	
	i=i+1; Skill[i] = { name = "Skull Breaker",            use = ((not friendly) and (focus >= 30)) }
	
    MyCombat(Skill,arg1)
end

------------------------
------------------------
-- Champion/Rouge --
------------------------
------------------------

 function Chr(arg1)
    local Skill = {}
    local i = 0
    local rage = UnitMana("player")
    local energy = UnitSkill("player")
    local enemy = UnitCanAttack("player","target")
    local tspell,ttime,telapsed = UnitCastingTime("target")
    local combat = GetPlayerCombatState()
--	
    local pbuffs = BuffList("player") 
    local tbuffs = BuffList("target")
    local dbuffs = DebuffList("player")	
    local health,buffs	
--	
    local tclass = UnitClass("target");
    local health = PctH(tgt) 	
	local cd,tt


	i=i+1; Skill[i] = { name = "Shadow Explosion",       use = (not ChkBuff("player","Shadow Explosion")) }	
	i=i+1; Skill[i] = { name = "Forge",                  use = (not ChkBuff("player","Forge")) }	
	i=i+1; Skill[i] = { name = "Rune Growth",            use = (not ChkBuff("player","Rune Growth")) }	
--	
	i=i+1; Skill[i] = { name = "Feedback Defense",       use = (PctH("player") <= 0.95) and (not ChkBuff("player","Feedback Defense") and (combat)) }	
	i=i+1; Skill[i] = { name = "Waiting Game",           use = (PctH("player") <= 0.80) and (not ChkBuff("player","Waiting Game") and (combat)) }
	i=i+1; Skill[i] = { name = "Overrule",               use = (PctH("player") <= 0.70) and (not ChkBuff("player","Overrule") and (combat)) }	
	i=i+1; Skill[i] = { name = "Remodeled Body",         use = (PctH("player") <= 0.20) and (not ChkBuff("player","Remodeled Body") and (combat)) }	
--	
    i=i+1; Skill[i] = { name = "Rune Pulse",             use = ((not friendly) and (ChkBuff("player","Chain Drive"))) }
    i=i+1; Skill[i] = { name = "Shadowstab",             use = ((not friendly) and (energy >=20)) } 	
    i=i+1; Skill[i] = { name = "Rune Pulse",             use = ((not friendly) and (ChkBuff("player","Chain Drive"))) }
    i=i+1; Skill[i] = { name = "Attack",		         use = ((not friendly) and (not ChkBuff("player","Chain Drive"))) }	

	
    MyCombat(Skill,arg1)
end


 function Chrwdasfas(arg1)
    local Skill = {}
    local i = 0
    local rage = UnitMana("player")
    local energy = UnitSkill("player")
    local enemy = UnitCanAttack("player","target")
    local tspell,ttime,telapsed = UnitCastingTime("target")
    local combat = GetPlayerCombatState()
--	
    local pbuffs = BuffList("player") 
    local tbuffs = BuffList("target")
    local dbuffs = DebuffList("player")	
    local health,buffs	
--	
    local tclass = UnitClass("target");
    local health = PctH(tgt) 	
	local cd,tt


	i=i+1; Skill[i] = { name = "Shadow Explosion",       use = ((not string.find(pbuffs, 623402))) }
	i=i+1; Skill[i] = { name = "Forge",                  use = ((not string.find(pbuffs, 622184))) }	
	i=i+1; Skill[i] = { name = "Rune Growth",            use = ((not string.find(pbuffs, 621208))) }
--	
	i=i+1; Skill[i] = { name = "Feedback Defense",       use = (PctH("player") <= 0.95) and (not string.find(pbuffs, "Feedback Defense") and (combat)) }
	i=i+1; Skill[i] = { name = "Waiting Game",           use = (PctH("player") <= 0.80) and (not string.find(pbuffs, "Waiting Game") and (combat)) }
	i=i+1; Skill[i] = { name = "Overrule",               use = (PctH("player") <= 0.70) and (not string.find(pbuffs, "Overrule") and (combat)) }	
	i=i+1; Skill[i] = { name = "Remodeled Body",         use = (PctH("player") <= 0.20) and (not string.find(pbuffs, "Remodeled Body") and (combat)) }	
--	
    i=i+1; Skill[i] = { name = "Rune Pulse",             use = ((not friendly) and (string.find(pbuffs, 622185))) }
    i=i+1; Skill[i] = { name = "Shadowstab",             use = ((not friendly) and (energy >=20)) } 	
    i=i+1; Skill[i] = { name = "Rune Pulse",             use = ((not friendly) and (string.find(pbuffs, 622185))) }
    i=i+1; Skill[i] = { name = "Attack",		         use = ((not friendly) and (not string.find(pbuffs, 622185))) }	

	
    MyCombat(Skill,arg1)
end
------------------------
------------------------
-- Champion/Mage --
------------------------
------------------------
 function Chm(arg1)
    local Skill = {}
    local i = 0
    local rage = UnitMana("player")
    local mana = UnitSkill("player")
    local enemy = UnitCanAttack("player","target")
    local tspell,ttime,telapsed = UnitCastingTime("target")
    local combat = GetPlayerCombatState()
--	
    local pbuffs = BuffList("player") 
    local tbuffs = BuffList("target")
    local dbuffs = DebuffList("player")	
    local health,buffs	
--	
    local tclass = UnitClass("target");
    local health = PctH(tgt) 
    local mana = PctM(tgt)	
	local cd,tt
	
	i=i+1; Skill[i] = { name = "Shield Form",             use = ((not string.find(pbuffs, "Shield Form"))) }	
	i=i+1; Skill[i] = { name = "Elemental Defense",      use = ((not string.find(pbuffs, "Elemental Defense"))) }
	i=i+1; Skill[i] = { name = "Forge",                  use = ((not string.find(pbuffs, "Forge"))) }	
	i=i+1; Skill[i] = { name = "Rune Growth",            use = ((not string.find(pbuffs, "Attack Rune Growth"))) }
    i=i+1; Skill[i] = { name = "Rune Growth",            use = ((BuffTimeLeft("player", "Rune Growth") < 1)) }	
	i=i+1; Skill[i] = { name = "Action: 60",             use = ((not string.find(pbuffs, "Battle Defense Transfer"))) }	-- Place Skill on slot 60	
	i=i+1; Skill[i] = { name = "High-Energy Barrier",    use = ((not string.find(pbuffs, "High-Energy Barrier"))) }
    i=i+1; Skill[i] = { name = "High-Energy Barrier",    use = ((BuffTimeLeft("player", "High-Energy Barrier") < 1)) }	
--
	i=i+1; Skill[i] = { name = "Key Rescue",             use = (PctH("player") <= 0.90) and (not string.find(pbuffs, "Feedback Defense") and (combat)) }
	i=i+1; Skill[i] = { name = "Overrule",               use = (PctH("player") <= 0.70) and (not string.find(pbuffs, "Feedback Defense") and (combat)) }
	i=i+1; Skill[i] = { name = "Backlash Armor",         use = (PctH("player") <= 0.50) and (not string.find(pbuffs, "Feedback Defense") and (combat)) }
	i=i+1; Skill[i] = { name = "Feedback Defense",       use = (PctH("player") <= 0.30) and (not string.find(pbuffs, "Feedback Defense") and (combat)) }	
	i=i+1; Skill[i] = { name = "Remodeled Body",         use = (PctH("player") <= 0.10) and (not string.find(pbuffs, "Feedback Defense") and (combat)) }
--	

	i=i+1; Skill[i] = { name = "Rune Pulse",             use = ((not friendly) and (string.find(pbuffs,"Chain Drive"))) }
	i=i+1; Skill[i] = { name = "Rapid Spread",           use = ((not friendly) and (mana >= 600) and (not string.find(pbuffs, "Rapid Spread"))) }
	i=i+1; Skill[i] = { name = "Suppression Offensive",  use = ((not friendly) and (mana >= 600) and (rage >= 10) and (not string.find(tbuffs, "Suppression Offensive"))) }	
	i=i+1; Skill[i] = { name = "Vacuum Wave",            use = ((not friendly) and (rage >= 39) and (not string.find(tbuffs, "Vacuum Wave"))) }	
	i=i+1; Skill[i] = { name = "Silence",                use = ((not friendly) and (mana >= 300) and (not string.find(tbuffs, "Silence"))) }	
	i=i+1; Skill[i] = { name = "Shock Strike",           use = ((not friendly) and (rage >= 24) and (not string.find(tbuffs, "Shock Strike") )) }
	i=i+1; Skill[i] = { name = "Electrocution",          use = ((not friendly) and (rage >= 20) and (not string.find(tbuffs, "Electrocution") )) }
	i=i+1; Skill[i] = { name = "Heavy Bash",             use = ((not friendly) and (rage >= 20) and (not string.find(tbuffs, "Heavy Bash") )) }	
	i=i+1; Skill[i] = { name = "Attack",		         use = ((not friendly)) }		
	
	
    MyCombat(Skill,arg1)
end
------------------------
------------------------
-- Warlock/Mage --
------------------------
------------------------
function Wlm(arg1)
    local Skill = {}
    local i = 0
    local focus = UnitMana("player")
    local mana  = UnitSkill("player")
	local PsiPoints, PsiStatus = GetSoulPoint()		
    local enemy = UnitCanAttack("player","target")
    local tspell,ttime,telapsed = UnitCastingTime("target")
    local combat = GetPlayerCombatState()
--	
    local pbuffs = BuffList("player") 
    local tbuffs = BuffList("target")
    local dbuffs = DebuffList("player")	
    local health,buffs	
--	
    local tclass = UnitClass("target");
    local health = PctH(tgt) 	
	local cd,tt

	i=i+1; Skill[i] = { name = "Silence",                   use = ((not friendly) and (string.find(tbuffs,"Authoritative Deterrence") and (mana >=300))) }
	i=i+1; Skill[i] = { name = "Warp Charge",               use = ((not friendly) and (not string.find(pbuffs, "Warp Charge") and (focus >=30))) }	
	i=i+1; Skill[i] = { name = "Heart Collection Strike",   use = ((not friendly) and (not string.find(tbuffs, "Soul Brand"))) }		
    i=i+1; Skill[i] = { name = "Perception Extraction",     use = ((not friendly) and (not string.find(pbuffs, "Perception Extraction") and (focus >=15))) }
	i=i+1; Skill[i] = { name = "Perception Extraction",     use = ((focus >=15) and (BuffTimeLeft("target", "Perception Extraction") < 1)) }
	
	MyCombat(Skill,arg1)
end
