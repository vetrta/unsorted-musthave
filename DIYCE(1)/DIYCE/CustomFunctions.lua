-- Title: DIY Combat Engine
-- Version: 2.4.2
-- Description: Combat Engine to help with skill rotations, and maintaining buffs/debuffs for maximizing DPS.
-- Author: Ghost Wolf

local WHITE = "|cffffffff"
local SILVER = "|cffc0c0c0"
local GREEN = "|cff00ff00"
local LTBLUE = "|cffa0a0ff"

function DIYCE_DebugSkills(skillList)
    DEFAULT_CHAT_FRAME:AddMessage(GREEN.."Skill List:")
    
    for i,v in ipairs(skillList) do
        DEFAULT_CHAT_FRAME:AddMessage(SILVER.."  ["..WHITE..i..SILVER.."]: "..LTBLUE.."\" "..WHITE..v.name..LTBLUE.."\"  use = "..WHITE..(v.use and "true" or "false"))
    end

    DEFAULT_CHAT_FRAME:AddMessage(GREEN.."----------")
end

function DIYCE_DebugBuffList(buffList)
    DEFAULT_CHAT_FRAME:AddMessage(GREEN.."Buff List:")
    
    for k,v in pairs(buffList) do
        -- We ignore numbered entries because both the ID and name 
        -- are stored in the list. This avoids doubling the output.
        if type(k) ~= "number" then
            DEFAULT_CHAT_FRAME:AddMessage(SILVER.."  ["..WHITE..k..SILVER.."]:  "..LTBLUE.."id: "..WHITE..v.id..LTBLUE.."  stack: "..WHITE..v.stack..LTBLUE.."  time: "..WHITE..(v.time or "none"))
        end
    end
    
    DEFAULT_CHAT_FRAME:AddMessage(GREEN.."----------")    
end

local silenceList = {
		["Annihilation"] = true,
		["King Bug Shock"] = true,
		["Mana Rift"] = true,
		["Dream of Gold"] = true,
		["Flame"] = true,
		["Flame Spell"] = true,
		["Wave Bomb"] = true,
		["Silence"] = true,
		["Recover"] = true,
		["Restore Life"] = true,
		["Heal"] = true,
		["Curing Shot"] = true,
		["Leaves of Fire"] = true,
		["Urgent Heal"] = true,
		["Heavy Shelling"] = true,
		["Dark Healing"] = true,
						}	

local subList = {
		["Sharp Slash"] = true, -- 1st Boss DOD
		["Conjure Energy"] = true, -- 4th boss GC HM AOE
		["Cat Claw Whirlwind"] = true,  --1st boss RT AOE
		["Void Fire"] = true, --2nd boss RT AOE
                        }
						
arrowTime = 0
SlotRWB = 16 --Action Bar Slot # for Rune War Bow
SlotMNB = 17 --Action Bar Slot # for your Main Bow
local g_lastaction = ""
local g_cnt = 0

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

--The Potion function is for using in a macro either by itself or combined with the KillSequence function. 
--I used it with my Priest in combo with the PartyHealer Addon to make sure to use potions when I needed them most.
function Potion(healthpot,manapot)
    local Skill = {}
    local i = 0
	local phealth = PctH("player")
    local pctmana = PctM("player")
	healthpot = healthpot or 0
	manapot = manapot or 0
	Skill = {
	{ name = "Action: "..healthpot,		use = (phealth <= .70) },
	{ name = "Action: "..manapot,		use = (pctmana <= .40) },
			}
	MyCombat(Skill,arg1)
end

--Summon and dismiss a pet.
function Pet(petnum)
	if IsPetSummoned(petnum)
		then ReturnPet(petnum) 
	else SummonPet(petnum)
	end
end

--Summon and use the Warden Pet.
function WardenPet(arg1)
	local Skill = {}
	local pctEB1 = PctM("player")
	local pbuffs = BuffList("player")

	local SpiritOfTheOakActive = UnitExists("pet") and (UnitName("pet") == "Spirit of the Oak")
	local NatureCrystalActive = UnitExists("pet") and (UnitName("pet") == "Nature Crystal")
	
	Skill = {
		--{ name = "Summon Spirit of the Oak",			use = (not pbuffs["Heart of the Oak"]) and (not SpiritOfTheOakActive) and (pctEB1 >= .15) },
		--{ name = "Heart of the Oak",					use = SpiritOfTheOakActive and (not pbuffs["Heart of the Oak"]) and (pctEB1 >= .05) },
		{ name = "Summon Nature Crystal",				use = (not NatureCrystalActive) and (pctEB1 >= .15) },
			}	
	
	MyCombat(Skill, arg1)
end

--Summon and use the Priest Fairy.,
function PriestFairySequence(arg1)
	local Skill = {}
	local Skill2 = {}
	local i = 0
	local FairyExists = UnitExists("playerpet")
	local FairyBuffs = BuffList("playerpet")
	local combat = GetPlayerCombatState()

    --Determine Class-Combo
    mainClass, subClass = UnitClassToken( "player" )

	--Summon Fairy
	if (not FairyExists) and (not combat) then
		if mainClass == "AUGUR" then
			if subClass == "THIEF" then
				Skill = {
					{ name = "Shadow Fairy",			use = true },
						}
			elseif subClass == "RANGER" then
				Skill = {
					{ name = "Water Fairy",				use = true },
						}
			elseif subClass == "MAGE" then
				Skill = {
					{ name = "Wind Fairy",				use = true },
						}			
			elseif subClass == "KNIGHT" then
				Skill = {
					{ name = "Light Fairy",				use = true },
						}			
			elseif subClass == "WARRIOR" then
				Skill = {
					{ name = "Fire Fairy",				use = true },
						}
			end
		end
	end	
	
	--Cast Halo
	if FairyExists then
		if mainClass == "AUGUR" then
			if subClass == "THIEF" then
				if (not FairyBuffs[503459]) then
					if (arg1 == "v1") then
						Msg("- Activating Halo", 0, 1, 1)
					end
					Skill = {
						{ name = "Pet Skill: 5 (Wraith Halo)",	use = true },
							}
				end
			elseif subClass == "RANGER" then
				if (not FairyBuffs[503457]) then
					if (arg1 == "v1") then
						Msg("- Activating Halo", 0, 1, 1)
					end
					Skill = {
						{ name = "Pet Skill: 5 (Frost Halo)",	use = true },
							}
				end
			elseif subClass == "MAGE" then
				if (not FairyBuffs[503461]) then
					if (arg1 == "v1") then
						Msg("- Activating Halo", 0, 1, 1)
					end
					Skill = {
						{ name = "Pet Skill: 5 (Windrider Halo)",	use = true },
							}
				end
			elseif subClass == "KNIGHT" then
				if (not FairyBuffs[503507]) then
					if (arg1 == "v1") then
						Msg("- Activating Halo", 0, 1, 1)
					end
					Skill = {
						{ name = "Pet Skill: 5 (Devotion Halo)",	use = true },
							}
				end
			elseif subClass == "WARRIOR" then
				if (not FairyBuffs[503455]) then
					if (arg1 == "v1") then
						Msg("- Activating Halo", 0, 1, 1)
					end
					Skill = {
						{ name = "Pet Skill: 5 (Accuracy Halo)",	use = true },
							}
				end
			end
		
			--Cast Conceal
		if (not MyCombat(Skill, arg1)) then
			if (not FairyBuffs[503753]) then
				if (arg1 == "v1") then
					Msg("- Activating Conceal", 0, 1, 1)
				end
				Skill2 = {
					{ name = "Pet Skill: 6 (Conceal)",	use = true },
						}
			end
		end
		end
	end
	
	if (not MyCombat(Skill, arg1)) then
		MyCombat(Skill2, arg1)
	end
end

--The main function of DIYCE.
function KillSequence(arg1, mode, healthpot, manapot, Healslot, foodslot, speedpot, ragepot, HoTslot)
--arg1 = "v1" or "v2" for debugging
--mode = used for various purposes, such as setting custom sections for specific situation. (IE: Seige War/PvP)
--healthpot = # of actionbar slot for health potions
--manapot = # of actionbar slot for mana potions
--foodslot = # of actionbar slot for food (add more args for more foodslots if needed)

	local Skill = {}
	local Skill2 = {}
	local i = 0
		
	-- Player and target status.
	local combat = GetPlayerCombatState()
	local enemy = UnitCanAttack("player","target")
	local EnergyBar1 = UnitMana("player")
	local EnergyBar2 = UnitSkill("player")
	local pctEB1 = PctM("player")
	local pctEB2 = PctS("player")
	local tbuffs = BuffList("target")
	local pbuffs = BuffList("player")
	local tDead = UnitIsDeadOrGhost("target")
	local behind = (not UnitIsUnit("player", "targettarget"))
	local melee = GetActionUsable(13) -- # is your melee range spell slot number
	local a1,a2,a3,a4,a5,ASon = GetActionInfo(14)  -- # is your Autoshot slot number
	local ammo = (GetEquipSlotInfo(10) ~= nil)
	local _,_,_,_,RWB,_ = GetActionInfo( SlotRWB )
	local _,_,_,_,MNB,_ = GetActionInfo( SlotMNB )
	local phealth = PctH("player")
	local thealth = PctH("target")
	local LockedOn = UnitExists("target")
	local boss = UnitSex("target") > 2
	local elite = UnitSex("target") == 2
	local party = GetNumPartyMembers() >= 2
	local PsiPoints, PsiStatus = GetSoulPoint()
	local zoneid = (GetZoneID() % 1000)
    local SeigeWar = (zoneid == 402) -- The "Seige War" Zone
	
	--Determine Class-Combo
	mainClass, subClass = UnitClassToken( "player" )
	--main, second = UnitClass("player")

	--Silence Logic
	local tSpell,tTime,tElapsed = UnitCastingTime("target")
	local silenceThis = tSpell and silenceList[tSpell] and ((tTime - tElapsed) > 0.1)
	
	--Substitute Logic (for R/S combo)
	local subThis = tSpell and subList[tSpell] and ((tTime - tElapsed) > 0.1)
	
	--Potion & Food Checks
	healthpot = healthpot or 0
	manapot = manapot or 0
	speedpot = speedpot or 0
	foodslot = foodslot or 0

	--Equipment and Pet Protection
	if phealth <= .04 then
			--SwapEquipmentItem()		--Note: Remove the first double dash to re-enable equipment protection.
		for i=1,6 do
			if (IsPetSummoned(i) == true) then
				ReturnPet(i);
			end
		end        
	end

	--Check for level 1 mobs, if it is, drop target and acquire a new one.
	if (LockedOn and (UnitLevel("target") < 2)) then
		TargetNearestEnemy()
		return
	end
	
	--Begin Player Skill Sequences
	
		--Priest = AUGUR, Druid = DRUID, Mage = MAGE, Knight = KNIGHT, 
		--Scout = RANGER, Rogue = THIEF, Warden = WARDEN, Warrior = WARRIOR
		--Warlock = HARPSYN, Champion = PSYRON
		
		-- Class: Warrior/Mage
			if mainClass == "WARRIOR" and subClass == "MAGE" then
				local SurpriseAttack = GetActionUsable(14)

			--Potions and Buffs
			Skill = {
				{ name = "Action: "..healthpot,			use = (phealth <= .70) },
				{ name = "Survival Instinct",			use = (phealth <= .30) and combat },
				{ name = "Sense of Danger",				use = (phealth <= .30) and combat },
				{ name = "Action: "..manapot,			use = (pctEB2 <= .40) },
				--{ name = "Action: "..Healslot,  		use = (phealth < .70) and (not combat) and (not party) },
				--{ name = "Action: "..HoTslot,  			use = (phealth < .80) and (not party) },
				{ name = "Intensification",				use = (pctEB2 >= .05) and (not pbuffs["Intensification"]) and boss and enemy },
				{ name = "Aggressiveness",				use = boss and enemy },
				{ name = "Electric Attack",				use = (pctEB2 >= .05) and ((not pbuffs["Electric Attack"]) or (pbuffs["Electric Attack"].time <= 45)) },
					}
					
			--Combat
				if enemy then
				Skill2 = {
					{ name = "Silence",					use = (silenceThis) },
					{ name = "Fireball",				use = (pctEB2 >= .05) and (not Boss) and (not melee) },
					{ name = "Thunder Sword",			use = (pctEB2 >= .05) and (not melee) },
					{ name = "Surprise Attack",			use = SurpriseAttack },
					{ name = "Enraged",					use = (EnergyBar1 <= 30) and (boss or elite) },
					{ name = "Electrical Rage",			use = (EnergyBar1 >= 15) and (pctEB2 >=.05) and (not pbuffs["High Voltage III"]) },
					{ name = "Thunder Sword",			use = (pctEB2 >= .05) },
					{ name = "Lightning's Touch",		use = (pctEB2 >= .05) },
					{ name = "Attack",					use = (thealth == 1) },
						}
				end
				
			-- Class: Warrior/Rogue
			elseif mainClass == "WARRIOR" and subClass == "THIEF" then
				local SurpriseAttack = GetActionUsable(14)
				CreateDIYCETimer("SSBleed", 7) --Change the value between 6 -> 7.5 depending on your lag.
				CreateDIYCETimer("SlashBleed", 6) --Change the value between 5.8 -> 6.2 depending on your lag.

	        --Ammo Check and Equip
			--local ammo = (GetEquipSlotInfo(10) ~= nil)

			if (ammo == false) then
				local HaveAmmo = false
				local daggers = ""
				for i=1,60 do
					local x,y,name = GetBagItemInfo(i)
						if (string.find(name, " Axe")) then --[[This will equip the daggers bought in Dalanis.
													Change this name to whatever current throwing dagger you use.]]
							HaveAmmo = true
							daggers = name
						end
				end
				if (HaveAmmo == true) then
					i=i+1; Skill[i] = { name = "Item: "..daggers,    use = (not ammo) } --Equip daggers if have           
				elseif ((g_cnt%100) == 0) then
					DEFAULT_CHAT_FRAME:AddMessage"I need to get throwing daggers!"
				end
					g_cnt = g_cnt + 1
			end
	
			--[[if (goat = "BossBuffs") then
			Skill= {
				{ name = "Aggressiveness",				use = boss and enemy },
				{ name = "Berserk",						use = boss and enemy },
				{ name = "Frenzied Attack",				use = boss and enemy },
					}
			end		]]--
	
			--Potions and Buffs
			Skill = {
				{ name = "Action: "..healthpot,			use = (phealth <= .70) },
				{ name = "Survival Instinct",			use = (phealth <= .33) and combat },
				{ name = "Action: "..Healslot,  		use = (phealth < .70) and (not combat) and (not party) },
				{ name = "Action: "..HoTslot,  			use = (phealth < .80) and (not party) },
					}
					
			--Combat
				if enemy then
				Skill2 = {
					{ name = "Shout",					use = (silenceThis) },
					{ name = "Surprise Attack",			use = SurpriseAttack },
					{ name = "Feint",               	use = ((_target == UnitName("target")) and (_type == "DODGE")) },
					{ name = "Enraged",					use = (EnergyBar1 <= 30) and (boss or elite) },
					{ name = "Blood Dance",				use = (phealth >= .80) and boss },
					{ name = "Slash",					use = (EnergyBar1 >= 25), timer = "SlashBleed" },
					{ name = "Shadowstab",				use = (EnergyBar2 >= 20), timer = "SSBleed"},
					{ name = "Blasting Cyclone",		use = (EnergyBar1 >= 35) },
					{ name = "Probing Attack",			use = (EnergyBar1 >= 20) and (not pbuffs["Vulnerable"]) },
					{ name = "Open Flank",				use = (EnergyBar1 >= 10) and (pbuffs["Vulnerable"]) },
					{ name = "Splitting Chop",			use = (EnergyBar1 >= 15) and (pbuffs["Weakened"]) },
					{ name = "Keen Attack",				use = (EnergyBar2 >= 20) and (pbuffs["Vulnerable"]) },
					{ name = "Shadowstab",				use = (EnergyBar2 >= 20)},
					{ name = "Attack",					use = (thealth == 1) },
						}
				end
				
		--Class: Druid/Mage
			elseif mainClass == "DRUID" and subClass == "MAGE" then
			
			--Potions and buffs
			Skill = {
				{ name = "Action: "..healthpot,			use = (phealth <= .70) },
				{ name = "Action: "..manapot,			use = (pctEB1 <= .40) },
				{ name = "Savage Blessing",				use = (pctEB1 >= .05) and ((not pbuffs["Savage Blessing"]) or (pbuffs["Savage Blessing"].time <= 45)) },
				{ name = "Concentration Prayer",		use = (pctEB1 >= .05) and ((not pbuffs["Concentration Prayer"]) or (pbuffs ["Concentration Prayer"].time <= 45)) },
				{ name = "Intensification",				use = (pctEB1 >= .05) and (not pbuffs["Intensification"]) and boss and enemy },
					}
			--Combat
				if enemy then
				Skill2 = {
					{ name = "Binding Silence",			use = (silenceThis) },
					{ name = "Silence",					use = (silenceThis) },
					{ name = "Weakening Seed",			use = (pctEB1 >= .05) and boss and ((not tbuffs["Weakening Seed"]) or (tbuffs["Weakening Seed"].time < 4)) },
					{ name = "Mother Nature's Wrath",	use = (pctEB1 >= .05) },
					{ name = "Briar Entwinement",		use = (pctEB1 >= .05) and ((not tbuffs["Briar Entwinement"]) or (tbuffs["Briar Entwinement"].time < 4)) },
					{ name = "Lightning",				use = (pctEB1 >= .05) },
					{ name = "Fireball",				use = (pctEB1 >= .05) },
					{ name = "Earth Arrow",				use = (pctEB1 >= .05) },
							}
				end
				
		--Class: Mage/Warrior
			elseif mainClass == "MAGE" and subClass == "WARRIOR" then
			
			--Potions and buffs
			Skill = {
				{ name = "Action: "..healthpot,			use = (phealth <= .70) },
				{ name = "Action: "..manapot,			use = (pctEB1 <= .40) },
				{ name = "Intensification",				use = (pctEB1 >= .05) and (not pbuffs["Intensification"]) and boss and enemy },
				{ name = "Magical Talent",				use = (EnergyBar2 >= 20) and (not pbuffs["Magical Talent"]) },
				{ name = "Magical Enlightenment",		use = (EnergyBar2 >= 35) and (not pbuffs["Magical Enlightenment"]) },
				{ name = "Elemental Explosion",			use = (EnergyBar2 >= 35) and (not pbuffs["Elemental Explosion"]) },
				{ name = "Activate Mana",				use = (EnergyBar2 <= 90) and ((not pbuffs["Magical Talent"]) or (not pbuffs["Magical Enlightenment"]) or (not pbuffs["Elemental Explosion"])) },
				{ name = "Enraged",						use = ((EnergyBar2 >= 15) and (EnergyBar2 <= 35)) and ((not pbuffs["Magical Talent"]) or (not pbuffs["Magical Enlightenment"]) or (not pbuffs["Elemental Explosion"])) },
			
					}
			--Combat
				if enemy then
				Skill2 = {
					{ name = "Silence",					use = (silenceThis) },
					{ name = "Fireball",				use = (pctEB1 >= .05) },
					{ name = "Lightning",				use = (pctEB1 >= .05) },
						}
				end
				
		--Class: Knight/Mage
			elseif mainClass == "KNIGHT" and subClass == "MAGE" then
			    local LKBR = GetActionUsable(20) -- # is Lion King Battle Roar spell slot number

			--Potions and buffs
			Skill = {
				{ name = "Action: "..healthpot,			use = (phealth <= .70) },
				{ name = "Action: "..manapot,			use = (pctEB1 <= .40) },
				{ name = "Enhanced Armor",				use = (pctEB1 >= .05) and ((not pbuffs["Enhanced Armor"]) or (pbuffs["Enhanced Armor"].time <= 45)) },
				{ name = "Holy Seal",					use = (pctEB1 >= .05) and ((not pbuffs["Holy Seal"]) or (pbuffs["Holy Seal"].time <= 45)) },
				{ name = "Lightning Armor",				use = (pctEB1 >= .05) and ((not pbuffs["Lightning Armor"]) or (pbuffs["Lightning Armor"].time <= 45)) },
					}
				--{ name = "Function: CancelBuff",			use = (pbuffs["Willpower Blade"]) and (PsiPoints <= 0), params = {"Willpower Blade"} },
							
			--Combat
				if enemy then
				Skill2 = {
					{ name = "Silence",					use = (silenceThis) },
					{ name = "Resolution",				use = party and boss },
					{ name = "Shield of Discipline",	use = party and boss },
					{ name = "Intensification",			use = party and boss },
					{ name = "Shield of Valor",			use = party and boss },
					{ name = "Hatred Strike",			use = (pctEB1 >= .05) and party and boss },
					{ name = "Threaten",				use = (pctEB1 >= .05) and party and boss and (tbuffs["Holy Seals 3"]) },
					{ name = "Action: 20",				use = (pctEB1 >= .07) and LKBR and party and boss },
					{ name = "Function: CancelBuff",	use = (pbuffs[501797]), params = {"Mana Shield"} },
					{ name = "Mana Shield",				use = (pctEB1 <= .25) },
					{ name = "Custom: Holy Light Domain",	use = (pctEB1 >= .05) and (not tbuffs["Holy Illumination"]) and ((tbuffs["Light Seal I"]) or (tbuffs["Light Seal II"]) or (tbuffs["Light Seal III"])) and (g_lastaction ~= "Holy Light Domain") },
					{ name = "Mana Return",				use = (pctEB1 <= .80) and (tbuffs["Holy Seals 3"]) },
					{ name = "Whirlwind Shield",		use = (pctEB1 >= .05) and (tbuffs["Holy Illumination"]) },
					{ name = "Custom: Holy Strike",		use = (pctEB1 >= .05) and (not tbuffs["Light Seal III"]) },
					{ name = "Disarmament",				use = (pctEB1 >= .05) and (not tbuffs["Disarmament IV"]) and (tbuffs["Holy Illumination"]) and party and boss },
					{ name = "Custom: Holy Strike",		use = (pctEB1 >= .05) },
					{ name = "Attack",					use = (thealth == 1) },
						}
				end
				
		--Class: Mage/Druid
			elseif mainClass == "MAGE" and subClass == "DRUID" then

			--Potions and buffs
			Skill = {
				{ name = "Action: "..healthpot,			use = (phealth <= .70) },
				{ name = "Action: "..manapot,			use = (pctEB1 <= .40) },
				{ name = "Intensification",				use = (pctEB1 >= .05) and (not pbuffs["Intensification"]) and boss and enemy },
			    { name = "Savage Blessing",				use = (pctEB1 >= .05) and ((not pbuffs["Savage Blessing"]) or (pbuffs["Savage Blessing"].time <= 45)) },
			    { name = "Perception",					use = (pctEB1 >= .05) and ((not pbuffs["Perception"]) or (pbuffs["Perception"].time <= 45)) },
			    { name = "Magic Target",				use = (pctEB1 >= .05) and ((not pbuffs["Magic Target"]) or (pbuffs["Magic Target"].time <= 45)) },
					}
			--Combat
				if enemy then
				Skill2 = {
					{ name = "Silence",					use = (silenceThis) },
					{ name = "Fireball",				use = (pctEB1 >= .05) },
					{ name = "Magma Blade",				use = (pctEB1 >= .05) },
					{ name = "Lightning",				use = (pctEB1 >= .05) },
						}
				end
				
		--Class: Mage/Rogue		
			elseif mainClass == "MAGE" and subClass == "THIEF" then
			
			--Potions and buffs
			Skill = {
				{ name = "Action: "..healthpot,			use = (phealth <= .70) },
				{ name = "Action: "..manapot,			use = (pctEB1 <= .40) },
				{ name = "Kiss of the Vampire",			use = (pctEB1 >= .05) and (phealth <= .90)	},
				{ name = "Intensification",				use = (pctEB1 >= .05) and (not pbuffs["Intensification"]) and boss and enemy },
				{ name = "Fang Ritual",					use = (pctEB1 >= .05) and ((not pbuffs["Fang Ritual"]) or (pbuffs["Fang Ritual"].time <= 45)) },
				{ name = "Shadow Protection",			use = (pctEB1 >= .05) and ((not pbuffs["Shadow Protection"]) or (pbuffs["Shadow Protection"].time <= 45)) },
					}
			--Combat
				if enemy then
					if (not melee) then
					Skill2 = {
						{ name = "Silence",				use = (silenceThis) },
						{ name = "Cursed Fangs",		use = (pctEB1 >= .05) and ((not tbuffs["Cursed Fangs"]) or (tbuffs["Cursed Fangs"].time <= 2)) and (thealth >= .10)	},
						{ name = "Fireball",			use = (pctEB1 >= .05) },
						{ name = "Demoralize",			use = (EnergyBar2 >= 30) and (boss or elite) },
							}
					elseif melee then
					Skill3 = {
						{ name = "Silence",				use = (silenceThis) },
						--{ name = "Cursed Fangs",		use = (pctEB1 >= .05) and ((not tbuffs["Cursed Fangs"]) or (tbuffs["Cursed Fangs"].time <= 2)) and (thealth >= .10)	},
						{ name = "Demoralize",			use = (EnergyBar2 >= 30) and (boss or elite) },
						{ name = "Fireball",			use = (pctEB1 >= .05) },
						{ name = "Blind Stab",			use = (EnergyBar2 >= 20) },
						{ name = "Shadowstab",			use = (EnergyBar2 >= 20) },
							}
					end
				end
				
			--Class: Rogue/Scout
			elseif mainClass == "THIEF" and subClass == "RANGER" then
				--Timers for this class
					CreateDIYCETimer("SSBleed", 8.8) --Change the value between 6 -> 7.5 depending on your lag.
					CreateDIYCETimer("LBBleed", 8.8) --Change the value between 7 ->  8.5 depending on your lag.
			
				--Ammo Check and Equip
				if GetCountInBagByName("Runic Thorn") > 0 then
					UseItemByName("Runic Thorn")
					return true
				end
				if GetInventoryItemDurable("player", 9) == 0 
					and GetTime() - arrowTime > 2 then
						if (not RWB) then
							UseAction(SlotRWB)
							return
						end
					UseEquipmentItem(10)
					arrowTime = GetTime()
					return true
				end
				
				if (not MNB) then
					UseAction(SlotMNB)
					return
				end				
			
			--Potions and Buffs
			Skill = {
				{ name = "Action: "..healthpot,			use = (phealth <= .70) },
				{ name = "Combat Master",				use = ((not pbuffs["Combat Master"]) or (pbuffs["Combat Master"].time <= 45)) and (EnergyBar2 >= 30) },
				{ name = "Poison",						use = (not combat) and ((not pbuffs["Poisonous"]) or (pbuffs["Poisonous"].time <= 45)) },				
				{ name = "Action: "..speedpot,			use = (not pbuffs["Unbridled Enthusiasm"]) },
				{ name = "Action: "..foodslot,			use = (not pbuffs["Spicy Meatsauce Burrito"]) },
				}
					
			--Combat
				if enemy then
				Skill2 = {
					{ name = "Throat Attack",				use = melee and (silenceThis) },
					{ name = "Substitute",					use = subThis and (EnergyBar2 >= 30) },
					{ name = "Energy Thief",				use = ((EnergyBar1 < 25) and (boss) and (not tDead)) },
					{ name = "Fervent Attack",				use = (pbuffs["Energy Thief"]) },
					{ name = "Premeditation",				use = (not combat) and boss and (EnergyBar1 >= 50) and (not pbuffs["Premeditation"]) },
					{ name = "Informer",					use = boss },
					{ name = "Assassins Rage",				use = boss },
					{ name = "Evasion",						use = boss },
					{ name = "Wrist Attack",				use = (EnergyBar2 >= 35) and boss },
					{ name = "Sneak Attack",				use = (EnergyBar1 >= 20) and boss and behind and party and (not combat) },
					{ name = "Blind Spot",					use = (EnergyBar1 >= 20) and boss and behind and party },
					{ name = "Vampire Arrows",				use = (not melee) and (EnergyBar2 >= 20) },
					{ name = "Shot",						use = (not melee) },
					{ name = "Wound Attack",				use = (EnergyBar1 >= 35) and (tbuffs[620313]) and (tbuffs[500704]) },
					{ name = "Low Blow",					use = (EnergyBar1 >= 25) and (tbuffs[620313]) and (not tbuffs[500704]),	timer = "LBBleed" },
					{ name = "Shadowstab",					use = (EnergyBar1 >= 20) and (not tbuffs[620313]),	timer = "SSBleed" },
					{ name = "Vampire Arrows",				use = (EnergyBar2 >= 20) },
					{ name = "Shot",						use = true },
					{ name = "Shadowstab",					use = (EnergyBar1 >= 20) },					
					{ name = "Attack",						use = (thealth == 1) },					
							}
				end
				
			--Class: Rogue/Priest
			elseif mainClass == "THIEF" and subClass == "AUGUR" then
				--Timers for this class
					CreateDIYCETimer("SSBleed", 8.8) --Change the value between 6 -> 7.5 depending on your lag.
					CreateDIYCETimer("LBBleed", 8.8) --Change the value between 7 ->  8.5 depending on your lag.
					
			--Potions and Buffs
			Skill = {
				{ name = "Holy Aura",					use = (phealth <= .20) },
				{ name = "Regenerate",					use = (phealth <= .90) and (pctEB2 >= .05) and (not pbuffs["Regenerate"]) },
				{ name = "Urgent Heal",					use = (phealth <= .70) and (pctEB2 >= .05) and (not combat) },
				{ name = "Action: "..healthpot,			use = (phealth <= .70) },
				{ name = "Action: "..manapot,			use = (pctEB2 <= .40) },
				{ name = "Magic Barrier",				use = (pctEB2 >= .05) and ((not pbuffs["Magic Barrier"]) or (pbuffs["Magic Barrier"].time <= 45)) },
				{ name = "Quickness Aura",				use = (pctEB2 >= .05) and ((not pbuffs["Quickness Aura"]) or (pbuffs["Quickness Aura"].time <= 45)) },
				{ name = "Poison",						use = (not combat) and ((not pbuffs["Poisonous"]) or (pbuffs["Poisonous"].time <= 45))},
				{ name = "Action: "..speedpot,			use = (not pbuffs["Unbridled Enthusiasm"]) },
				{ name = "Action: "..foodslot,			use = (not pbuffs["Spicy Meatsauce Burrito"]) },
					}
					
			--Combat
				if enemy then
				Skill2 = {
					--{ name = "Throw",						use = (not melee) and (not boss) },
					{ name = "Premeditation",				use = (not combat) and boss and (EnergyBar1 >= 50) and (not pbuffs["Premeditiation"]) },
					{ name = "Slowing Poison",				use = boss },
					{ name = "Informer",					use = boss },
					{ name = "Fervent Attack",				use = boss },
					{ name = "Assassins Rage",				use = boss },
					{ name = "Kick",						use = (pctEB2 >= .05) },
					{ name = "Sneak Attack",				use = (EnergyBar1 >= 20) and boss and behind and party },
					{ name = "Blind Spot Attack",			use = (EnergyBar1 >= 20) and boss and behind and party },
					{ name = "Wound Attack",				use = (EnergyBar1 >= 35) and (tbuffs[620313]) and (tbuffs[500704]) },
					{ name = "Low Blow",					use = (EnergyBar1 >= 25) and (tbuffs[620313]) and (not tbuffs[500704]),	timer = "LBBleed" },
					{ name = "Shadowstab",					use = (EnergyBar1 >= 20) and (not tbuffs[620313]),	timer = "SSBleed" },
					{ name = "Shadowstab",					use = (EnergyBar1 >= 20) },
					{ name = "Attack",						use = (thealth == 1) },					
							}
				end
				
			--Class: Priest/Scout	
			elseif mainClass == "AUGUR" and subClass == "RANGER" then
				
			--Ammo Check and Equip
				if GetCountInBagByName("Runic Thorn") > 0 then
					UseItemByName("Runic Thorn")
					return true
				end
				if GetInventoryItemDurable("player", 9) == 0 
					and GetTime() - arrowTime > 2 then
						if (not RWB) then
							UseAction(SlotRWB)
							return
						end
					UseEquipmentItem(10)
					arrowTime = GetTime()
					return true
				end
				
				if (not MNB) then
					UseAction(SlotMNB)
					return
				end
				
			--Potions and Buffs
			Skill = {
				{ name = "Holy Aura",					use = (phealth <= .20) },
				{ name = "Soul Source",					use = (phealth <= .20) },
				{ name = "Regenerate",					use = (phealth <= .90) and (pctEB2 >= .05) and (not pbuffs["Regenerate"]) },
				{ name = "Urgent Heal",					use = (phealth <= .70) and (pctEB2 >= .05) and (not combat) },
				{ name = "Grace of Life",				use = (pctEB2 >= .05) and ((not pbuffs["Grace of Life"]) or (pbuffs["Grace of Life"].time <= 45)) },
				{ name = "Magic Barrier",				use = (pctEB2 >= .05) and ((not pbuffs["Magic Barrier"]) or (pbuffs["Magic Barrier"].time <= 45)) },
				{ name = "Embrace of the Water Spirit",	use = (pctEB2 >= .05) and ((not pbuffs["Embrace of the Water Spirit"]) or (pbuffs["Embrace of the Water Spirit"].time <= 45)) },
				{ name = "Magic Barrier",				use = (pctEB2 >= .05) and ((not pbuffs["Magic Barrier"]) or (pbuffs["Magic Barrier"].time <= 45)) },
				{ name = "Action: "..manapot,			use = (pctEB1 <= .40) },
				{ name = "Action: "..foodslot,			use = (not pbuffs["Deluxe Seafood"]) },
				{ name = "Action: "..speedpot,			use = (not pbuffs["Unbridled Enthusiasm"]) },
					}
			
			--Combat
				if enemy then
				Skill2 = {
					{ name = "Throat Attack",				use = (silenceThis) },
					{ name = "Ice Blade",					use = (pctEB1 >= .05) },
					{ name = "Vampire Arrows",				use = (EnergyBar2 >= 20) },
					{ name = "Shot",						use = true },
							}
				end
				
			elseif mainClass == "AUGUR" and subClass == "WARRIOR" then
				
			--Potions and Buffs
			Skill = {
				{ name = "Holy Aura",					use = (phealth <= .20) },
				{ name = "Soul Source",					use = (phealth <= .20) },
				{ name = "Healing Salve",				use = (phealth <= .90) and (pctEB1 >= .05) and (not pbuffs["Healing Salve"]) },
				{ name = "Regenerate",					use = (phealth <= .90) and (pctEB1 >= .05) and (not pbuffs["Regenerate"]) },
				{ name = "Urgent Heal",					use = (phealth <= .60) and (pctEB1 >= .05) },
				{ name = "Grace of Life",				use = (pctEB1 >= .05) and ((not pbuffs["Grace of Life"]) or (pbuffs["Grace of Life"].time <= 45)) },
				{ name = "Amplified Attack",			use = (pctEB1 >= .05) and ((not pbuffs["Amplified Attack"]) or (pbuffs["Grace of Life"].time <= 45)) },
				{ name = "Magic Barrier",				use = (pctEB1 >= .05) and ((not pbuffs["Magic Barrier"]) or (pbuffs["Magic Barrier"].time <= 45)) },
				{ name = "Blessed Spring Water",		use = (pctEB1 >= .05) and ((not pbuffs["Blessed Spring Water"]) or (pbuffs["Blessed Spring Water"].time <= 45)) },
				{ name = "Battle Monk Stance",			use = (pctEB1 >= .05) and ((not pbuffs["Battle Monk Stance"]) or (pbuffs["Battle Monk Stance"].time <= 45)) },
				{ name = "Power Build-Up",				use = (pctEB1 >= .05) and ((not pbuffs["Power Build-Up"]) or (pbuffs["Power Build-Up"].time <= 45)) },
				{ name = "Condensed Rage",				use = (EnergyBar2 >= 25) and ((not pbuffs["Condensed Rage"]) or (pbuffs["Condensed Rage"].time <= 45)) },
				{ name = "Action: "..manapot,			use = (pctEB1 <= .60) },
				{ name = "Action: "..foodslot,			use = (not pbuffs["Unimaginable Salad"]) },
				{ name = "Action: "..speedpot,			use = (not pbuffs["Unbridled Enthusiasm"]) },
					}
			
			--Combat
				if enemy then
				Skill2 = {
					{ name = "Vindictive Strike",			use = (silenceThis) and (EnergyBar2 >= 10) },
					{ name = "Regenerate",					use = (pctEB1 >= .05) and (not pbuffs["Regenerate"]) and boss },
					{ name = "Vindictive Strike",			use = (EnergyBar2 >= 10) },
					{ name = "Ascending Dragin Strike",		use = (EnergyBar2 >= 30) },
					{ name = "Fighting Spirit Combination",	use = (pctEB1 >= .05) },
					{ name = "Explosion of Fighting Spirit",use = (pctEB1 >= .05) },
					{ name = "Shot",						use = true },
							}
				end	
				
			elseif mainClass == "AUGUR" and subClass == "THIEF" then
				
			--Potions and Buffs
			Skill = {
				{ name = "Holy Aura",					use = (phealth <= .20) },
					}
			
			--Combat
				if enemy then
				Skill2 = {
					--{ name = "Wave Armor",					use = (pctEB1 >= .05) and ((not pbuffs["Wave Armor"]) or (pbuffs["Wave Armor"].time <= 2)) },
					{ name = "Snake Curse",					use = (EnergyBar2 >= 30) and ((not tbuffs["Snake Curse"]) or (tbuffs["Snake Curse"].time <= 2)) },
					{ name = "Ice Fog",						use = (pctEB1 >= .05) and ((not tbuffs["Ice Fog I"]) or (not tbuffs["Ice Fog II"]) or (not tbuffs["Ice Fog III"])) },
					{ name = "Infectious Wound",			use = (EnergyBar2 >= 30) },
					{ name = "Lure of the Snake Woman",		use = (EnergyBar2 >= 40) and (boss) },
					{ name = "Bone Chill",					use = (pctEB1 >= .05) and ((not tbuffs["Bone Chill"]) or (tbuffs["Bone Chill"].time <= 2)) },
					{ name = "Rising Tide",					use = (pctEB1 >= .05) },
					{ name = "Action: "..speedpot,			use = (not pbuffs["Unbridled Enthusiasm"]) },
							}
				end
					
			elseif mainClass == "RANGER" and subClass == "AUGUR" then
			
			--Ammo Check and Equip
				if GetCountInBagByName("Runic Thorn") > 0 then
					UseItemByName("Runic Thorn")
					return true
				end
				if GetInventoryItemDurable("player", 9) == 0 
					and GetTime() - arrowTime > 2 then
						if (not RWB) then
							UseAction(SlotRWB)
							return
						end
					UseEquipmentItem(10)
					arrowTime = GetTime()
					return true
				end
			--[[	if (not MNB) then
					UseAction(SlotMNB)
					return
				end			]]--
				
			--Potions and Buffs
			Skill = {
				{ name = "Regenerate",					use = (phealth <= .90) and (pctEB2 >= .05) and (not pbuffs["Regenerate"]) },
				{ name = "Urgent Heal",					use = (phealth <= .70) and (pctEB2 >= .05) and (not combat) },
				{ name = "Action: "..healthpot,			use = (phealth <= .70) },
				{ name = "Action: "..manapot,			use = (pctEB2 <= .40) },
				{ name = "Magic Barrier",				use = (pctEB2 >= .05) and ((not pbuffs["Magic Barrier"]) or (pbuffs["Magic Barrier"].time <= 45)) },				
				--{ name = "Frost Arrow",					use = (not combat) and (EnergyBar1 >= 20) and ((not pbuffs["Frost Arrow"]) or (pbuffs["Frost Arrow"].time <= 45)) },
				{ name = "Blood Arrow",					use = ((not combat or (phealth <= .45)) and (pbuffs["Blood Arrow"])) },
				{ name = "Target Area",					use = (tdead and (pbuffs["Target Area"])) },
				{ name = "Action: "..speedpot,			use = (not pbuffs["Unbridled Enthusiasm"]) },
					}
			
			--Combat
				if enemy then
				Skill2 = {
						{ name = "Throat Attack",			use = melee and (silenceThis) },
						{ name = "Neck Strike",				use = (silenceThis) },
						{ name = "Blood Arrow",				use = (phealth >= .95) and (not pbuffs["Blood Arrow"]) and boss },
						{ name = "Target Area",				use = (EnergyBar1 >= 40) and (not pbuffs["Target Area"]) and boss },
						{ name = "Concentration",			use = (not pbuffs["Concentration"]) and boss },
						{ name = "Arrow of Essence",		use = (not pbuffs["Arrow of Essence"]) and boss },
						{ name = "Autoshot",				use = (not ASon) },
						{ name = "Vampire Arrows",			use = (EnergyBar1 >= 20) },
						{ name = "Shot",					use = true },
							}
				end
				
			
				
			--Class: Scout/Rogue
			elseif mainClass == "RANGER" and subClass == "THIEF" then
				--Timers for this class
				
				--[[	--Ammo Check and Equip
				if GetCountInBagByName("Runic Thorn") > 0 then
					UseItemByName("Runic Thorn")
					return true
				end
				if GetInventoryItemDurable("player", 9) == 0 
					and GetTime() - arrowTime > 2 then
						if (not RWB) then
							UseAction(SlotRWB)
							return
						end
					UseEquipmentItem(10)
					arrowTime = GetTime()
					return true
				end
				if (not MNB) then
					UseAction(SlotMNB)
					return
				end		]]--
			
			--Potions and Buffs
			Skill = {
				{ name = "Action: "..healthpot,			use = (phealth <= .70) },
				}
					
			--Combat
				if enemy then
				Skill2 = {
					{ name = "Neck Strike",					use = melee and (silenceThis) },
					{ name = "Sapping Arrow",				use = (EnergyBar2 >= 30) },
					{ name = "Weak Spot",					use = (EnergyBar1 >= 30) },
					{ name = "Piercing Arrow",				use = true },
					{ name = "Custom: Shot",				use = (g_lastaction ~= "Shot") },
					{ name = "Vampire Arrows",				use = (EnergyBar1 >= 20) and CD("Deadly Poison Bite")},
					{ name = "Deadly Poison Bite",			use = (EnergyBar2 >= 30) },
					{ name = "Custom: Reflected Shot",		use = true },
					{ name = "Shot",						use = true },
							}
				end
				
			--Class: Rogue/Warden
			elseif mainClass == "THIEF" and subClass == "WARDEN" then
				--Timers for this class
					CreateDIYCETimer("SSBleed", 8.8) --Change the value between 6 -> 7.5 depending on your lag.
					CreateDIYCETimer("LBBleed", 8.8) --Change the value between 7 ->  8.5 depending on your lag.
					CreateDIYCETimer("BBCritBonus", 20) --Timer for Bloodthirsty Blade Crit Bonus Effect
					CreateDIYCETimer("PotWSBonus", 20) --Timer for Power of the Wood Spirit Damage Bonus Effect

			--Potions and Buffs
			Skill = {
				{ name = "Action: "..Healslot,  		use = (phealth <= .70) and (not combat) and (not party) },
				{ name = "Action: "..healthpot,			use = (phealth <= .70) },
				{ name = "Action: "..manapot,			use = (pctEB2 <= .40) },
				{ name = "Briar Shield",				use = ((not pbuffs["Briar Shield"]) or (pbuffs["Briar Shield"].time <= 45))},
				{ name = "Poison",						use = (not combat) and ((not pbuffs["Poisonous"]) or (pbuffs["Poisonous"].time <= 45))},
				{ name = "Wound Patch",					use = ((not pbuffs["Wound Patch"]) or (pbuffs["Wound Patch"].time <= 45)) and (EnergyBar1 >= 50) },
				{ name = "Action: "..speedpot,			use = (not pbuffs["Unbridled Enthusiasm"]) },
				{ name = "Action: "..foodslot,			use = (not pbuffs["Spicy Meatsauce Burrito"]) },
					}
					
			--Combat
				if enemy then
				Skill2 = {
					{ name = "Premeditation",				use = (not combat) and boss and (EnergyBar1 >= 50) and (not pbuffs["Premeditation"]) },
					{ name = "Informer",					use = boss },
					{ name = "Fervent Attack",				use = boss },
					{ name = "Savage Power",				use = boss },
					{ name = "Assassins Rage",				use = boss },
				--	{ name = "Phantom Blade",				use = (pctEB2 >= .1) and (phealth >= .60) },
					--{ name = "Throw",			use = (pctEB2 >= .1) },
					{ name = "Weak Point Strike",			use = (pctEB2 >= .1) },
					{ name = "Bloodthirsty Blade",			use = (pctEB2 >= .1),	timer = "BBCritBonus"  },
					--{ name = "Power of the Wood Spirit",	use = (pctEB2 >= .1),	timer = "PotWSBonus"  },
					--{ name = "Sneak Attack",				use = (EnergyBar1 >= 20) and boss and behind and party },
					--{ name = "Blind Spot Attack",			use = (EnergyBar1 >= 20) and boss and behind and party },
					----{ name = "Wound Attack",				use = (EnergyBar1 >= 35) and ((tbuffs[620313]) and (tbuffs["Grievous Wound"])) },
					----{ name = "Low Blow",					use = (EnergyBar1 >= 30) and (tbuffs[620313]) and (not tbuffs["Grievous Wound"]),	timer = "LBBleed" },
					----{ name = "Shadowstab",					use = (EnergyBar1 >= 20) and (not tbuffs[620313]),	timer = "SSBleed" },
					{ name = "Shadowstab",					use = (EnergyBar1 >= 20) },
					{ name = "Charged Chop",				use = (pctEB2 >= .1) },
					{ name = "Attack",						use = (thealth == 1) },					
							}
				end
				
			--Class: Warden/Rogue
			elseif mainClass == "WARDEN" and subClass == "THIEF" then
				CreateDIYCETimer("SSBleed", 3.0) --Set to 3 so it will go off, then PotWS, then back to SS, etc.
		  
			--Potions and Buffs
			Skill = {
				{ name = "Walker Spirit",						use = (phealth <= .40) },
				{ name = "Action: "..Healslot,  				use = (phealth <= .70) and (not combat) and (not party) },
				{ name = "Action: "..healthpot,					use = (phealth <= .70) },
				{ name = "Action: "..manapot,					use = (pctEB1 <= .40) },
				{ name = "Briar Shield",						use = (pctEB1 >= .05) and ((not pbuffs["Briar Shield"]) or (pbuffs["Briar Shield"].time <= 45))},
				{ name = "Protection of Nature",				use = (pctEB1 >= .05) and ((not pbuffs["Protection of Nature"]) or (pbuffs["Protection of Nature"].time <= 45))},
				{ name = "Action: "..speedpot,					use = (not pbuffs["Unbridled Enthusiasm"]) },
				{ name = "Action: "..foodslot,					use = (not pbuffs["Spicy Meatsauce Burrito"]) },
					}
					
			--Combat
				if enemy then
				Skill2 = {
					{ name = "Savage Power",					use = boss },
					{ name = "Together",						use = (EnergyBar2 >= 50) },
					{ name = "Achilles' Heel Strike",			use = (EnergyBar2 >= 30) },
					{ name = "Thorny Vines",					use = (pctEB1 >= .05) and (not pbuffs["Thorny Vine"]) },
					{ name = "Gravel Attack",					use = (EnergyBar2 >= 30) },
					{ name = "Shadowstab",						use = (EnergyBar2 >= 20), timer = "SSBleed" },
					{ name = "Charged Chop",					use = (pctEB1 >= .05) },
					{ name = "Attack",							use = (thealth == 1) },				
							}
				end
			
			-- Class: Warrior/Warden
			elseif mainClass == "WARRIOR" and subClass == "WARDEN" then
				local SurpriseAttack = GetActionUsable(17)
				CreateDIYCETimer("SlashBleed", 6) --Change the value between 5.8 -> 6.2 depending on your lag.

			--Combat
				if enemy then
				Skill = {
					{ name = "Shout",					use = (silenceThis) },
					{ name = "Surprise Attack",			use = SurpriseAttack },
					{ name = "Savage Whirlwind",		use = (pctEB2 >= .05) },
					{ name = "Probing Attack",			use = (EnergyBar1 >= 20) },
					{ name = "Open Flank",				use = (EnergyBar1 >= 10) and (tbuffs["Vulnerable"]) },
					{ name = "Slash",					use = (EnergyBar1 >= 25), timer = "SlashBleed" },
					{ name = "Tactical Attack",			use = (EnergyBar1 >= 15) and (tbuffs[500081])},
					{ name = "Power of the Wood Spirit",use = (pctEB2 >= .05) },
					{ name = "Attack",					use = (thealth == 1) },
						}
				end
				
			--Class Warlock/Warrior
			elseif mainClass == "HARPSYN" and subClass == "WARRIOR" then
			
			--Potions and Buffs
				Skill = {
					{ name = "Action: "..healthpot,			use = (phealth <= .70) },
					{ name = "Sublimation Weave Curse",		use = (not combat) and (EnergyBar1 >= 50) and ((not pbuffs["Sublimation Weave Curse"]) or (pbuffs["Sublimation Weave Curse"].time <= 45))  },
						}
						
			--Combat
				if enemy then
				Skill2 = {
					{ name = "Perception Extraction",			use = (EnergyBar1 >= 15) and (not tbuffs["Perception Extraction"]) and (EnergyBar1 <= 40) },
					{ name = "Heart Collection Strike",			use = (EnergyBar1 <= 20) },
					{ name = "Weakening Weave Curse",			use = (EnergyBar1 >= 20) and (not tbuffs["Weakened"]) },
                    { name = "Surge of Malice",					use = (EnergyBar1 >= 20) and (tbuffs["Weakened"]) },
					{ name = "Warp Charge",						use = (EnergyBar1 >= 30) and (not pbuffs["Warp Charge"]) },
					{ name = "Enraged",							use = true },
					{ name = "Slash",							use = (EnergyBar2 >= 25) },
					{ name = "Weakening Weave Curse",			use = (EnergyBar1 >= 20) },
                    { name = "Surge of Malice",					use = (EnergyBar1 >= 20) },
					{ name = "Warp Charge",						use = (EnergyBar1 >= 30) },
					{ name = "Puzzlement",						use = (EnergyBar1 >= 20) },
					{ name = "Psychic Arrows",					use = (EnergyBar1 >= 20) },
							}
				end
				
			--Class Warlock/Mage
			elseif mainClass == "HARPSYN" and subClass == "MAGE" then
			
			--Potions and Buffs
				Skill = {
					{ name = "Action: "..healthpot,			use = (phealth <= .70) },
					{ name = "Action: "..manapot,			use = (pctEB2 <= .40) },
					{ name = "Thinking Overload",			use = boss  },
					{ name = "Sublimation Weave Curse",		use = (EnergyBar1 >= 50) and ((not pbuffs["Sublimation Weave Curse"]) or (pbuffs["Sublimation Weave Curse"].time <= 45))  },
					{ name = "Fire Ward",					use = (pctEB2 >= .05) and ((not pbuffs["Fire Ward"]) or (pbuffs["Fire Ward"].time <= 45))  },															
					{ name = "Focus Building",				use = (not pbuffs["Focus Building"])  },
					{ name = "Intensification",				use = boss and (pctEB2 >= .05) },
						}
			
			--Combat
				if enemy then
					if (mode == "dps") then
						Skill2 = {
							{ name = "Silence",							use = (silenceThis) },
							{ name = "Custom: Willpower Blade",			use = (EnergyBar1 >= 30) and (not pbuffs["Willpower Blade"]) and (PsiPoints == 6) },
							{ name = "Custom: Flaming Heart Strike",	use = (pbuffs["Willpower Blade"]) and (PsiPoints >= 1) and (pctEB2 >= .05) },
							{ name = "Custom: Soul Brand Sting",		use = (pbuffs["Willpower Blade"]) and (PsiPoints >= 1) and (g_lastaction ~= "Soul Brand Sting") },
							{ name = "Perception Extraction",			use = (EnergyBar1 <= 30) and (EnergyBar1 >= 15) and (not tbuffs[621701]) },
							{ name = "Weakening Weave Curse",			use = (EnergyBar1 >= 20) and (not tbuffs["Weakened"]) },
							{ name = "Warp Charge",						use = (EnergyBar1 >= 30) and (not pbuffs["Willpower Blade"]) },
							{ name = "Flaming Heart Strike",			use = (pctEB2 >= .05) and (not pbuffs["Willpower Blade"]) },
							{ name = "Puzzlement",						use = (EnergyBar1 >= 20) and (not pbuffs["Willpower Blade"]) },
							{ name = "Custom: Psychic Arrows",			use = (EnergyBar1 >= 20) and (not pbuffs["Willpower Blade"]) and (g_lastaction ~= "Psychic Arrows") },
							{ name = "Heart Collection Strike",			use = (EnergyBar1 <= 20) and (tbuffs["Weakened"]) },
							{ name = "Surge of Malice",					use = (EnergyBar1 >= 20) and (tbuffs["Weakened"]) },
							{ name = "Fireball",						use = (pctEB2 >= .05) },
							{ name = "Warp Charge",						use = (EnergyBar1 >= 30) },
							{ name = "Psychic Arrows",					use = (EnergyBar1 >= 20) },
									}

					elseif (mode == "SB") then
						Skill2 = {
							{ name = "Silence",							use = (silenceThis) },
							{ name = "Perception Extraction",			use = (EnergyBar1 >= 15) and (not tbuffs[621446] or tbuffs[621446].stack < 4) },
									}
								
					elseif (mode == "AoE") then
						Skill2 = {
							{ name = "Silence",							use = (silenceThis) },
							{ name = "Weakening Weave Curse",			use = (EnergyBar1 >= 20) },
							{ name = "Surge of Malice",					use = (EnergyBar1 >= 20) },
							{ name = "Warp Charge",						use = (EnergyBar1 >= 30) },
							{ name = "Fireball",						use = (pctEB2 >= .05) },
									}
									
					else
						Skill2 = {
							{ name = "Silence",							use = (silenceThis) },
							{ name = "Perception Extraction",			use = (EnergyBar1 <= 30) and (not tbuffs["Perception Extraction"]) },
							{ name = "Heart Collection Strike",			use = (EnergyBar1 <= 20) },
							{ name = "Fireball",						use = (pctEB2 >= .05) },
							{ name = "Warp Charge",						use = (EnergyBar1 >= 30) and (not pbuffs["Warp Charge"]) },
							{ name = "Warp Charge",						use = (EnergyBar1 >= 30) },
							{ name = "Flaming Heart Strike",			use = (pctEB2 >= .05) },
							{ name = "Weakening Weave Curse",			use = (EnergyBar1 >= 20) and (not tbuffs["Weakened"]) },
							{ name = "Surge of Malice",					use = (EnergyBar1 >= 20) and (tbuffs["Weakened"]) },
							{ name = "Puzzlement",						use = (EnergyBar1 >= 20) },
							{ name = "Psychic Arrows",					use = (EnergyBar1 >= 20) },
									}
					end
				end
			
			--Class Warlock/Rogue
			elseif mainClass == "HARPSYN" and subClass == "THIEF" then
				
			--Potions and Buffs
				Skill = {
					{ name = "Action: "..healthpot,			use = (phealth <= .70) },
					{ name = "Sublimation Weave Curse",		use = (EnergyBar1 >= 50) and ((not pbuffs["Sublimation Weave Curse"]) or (pbuffs["Sublimation Weave Curse"].time <= 45))  },
						}

			--Combat
				if enemy then
					if (mode == "dps") then
						Skill2 = {
							{ name = "Soul Pain",						use = (EnergyBar1 >= 15) and (not tbuffs[621188]) and (PsiPoints == 6) },
							{ name = "Perception Extraction",			use = (EnergyBar1 >= 15) and (not tbuffs[621701]) },
							{ name = "Soul Poisoned Fang",				use = (EnergyBar2 >= 25) and (not tbuffs[621399]) },
							{ name = "Custom: Willpower Blade",			use = (EnergyBar1 >= 30) and (not pbuffs["Willpower Blade"]) and (PsiPoints == 6) },
							{ name = "End of Thought",					use = (pbuffs["Willpower Blade"]) and (PsiPoints >= 3) and (thealth <= .35) },
							{ name = "Crime and Punishment",			use = (pbuffs["Willpower Blade"]) and (PsiPoints >= 2) },
							{ name = "Perception Extraction",			use = (EnergyBar1 <= 30) and (EnergyBar1 >= 15) and (not tbuffs[621701]) },
							{ name = "Warp Charge",						use = (EnergyBar1 >= 30) and (not pbuffs["Willpower Blade"]) },
							{ name = "Puzzlement",						use = (EnergyBar1 >= 20) and (not pbuffs["Willpower Blade"]) },
							{ name = "Psychic Arrows",					use = (EnergyBar1 >= 20) and (not pbuffs["Willpower Blade"]) },
							{ name = "Warp Charge",						use = (EnergyBar1 >= 30) and (not pbuffs["Warp Charge"]) },
							{ name = "Weakening Weave Curse",			use = (EnergyBar1 >= 20) and (not tbuffs["Weakened"]) },
							{ name = "Heart Collection Strike",			use = (EnergyBar1 <= 20) and (tbuffs["Weakened"]) },
							{ name = "Perception Extraction",			use = (EnergyBar1 <= 30) and (EnergyBar1 >= 15) and (not tbuffs[621701]) },
							{ name = "Surge of Malice",					use = (EnergyBar1 >= 20) and (tbuffs["Weakened"]) },
							{ name = "Puzzlement",						use = (EnergyBar1 >= 20) and (tbuffs["Weakened"]) },
							{ name = "Soul Poisoned Fang",				use = (EnergyBar2 >= 25) and (not tbuffs[621399]) },
							{ name = "Shadowstab",						use = (EnergyBar2 >= 20) },
							{ name = "Warp Charge",						use = (EnergyBar1 >= 30) },
							{ name = "Psychic Arrows",					use = (EnergyBar1 >= 20) },
									}
					
					elseif (mode == "AoE") then
						Skill2 = {
							{ name = "Weakening Weave Curse",			use = (EnergyBar1 >= 20) },
							{ name = "Surge of Malice",					use = (EnergyBar1 >= 20) },
							{ name = "Warp Charge",						use = (EnergyBar1 >= 30) },
							{ name = "Shadowstab",						use = (EnergyBar2 >= 20) },
									}
					
					elseif (mode == "QuickKill") then
						Skill2 = {
							{ name = "Shadowstab",						use = (EnergyBar2 >= 20) },
							{ name = "Warp Charge",						use = (EnergyBar1 >= 30) and (not pbuffs["Warp Charge"]) },
							{ name = "Weakening Weave Curse",			use = (EnergyBar1 >= 20) and (not tbuffs["Weakened"]) },
							{ name = "Heart Collection Strike",			use = (EnergyBar1 <= 20) and (tbuffs["Weakened"]) },
							{ name = "Perception Extraction",			use = (EnergyBar1 <= 30) and (EnergyBar1 >= 15) and (not tbuffs[621701]) },
							{ name = "Surge of Malice",					use = (EnergyBar1 >= 20) and (tbuffs["Weakened"]) },
							{ name = "Puzzlement",						use = (EnergyBar1 >= 20) and (tbuffs["Weakened"]) },
							{ name = "Soul Poisoned Fang",				use = (EnergyBar2 >= 25) and (not tbuffs[621399]) },
							{ name = "Warp Charge",						use = (EnergyBar1 >= 30) },
							{ name = "Psychic Arrows",					use = (EnergyBar1 >= 20) },
									}
					
					else
						Skill2 = {
							{ name = "Warp Charge",						use = (EnergyBar1 >= 30) and (not pbuffs["Warp Charge"]) },
							{ name = "Weakening Weave Curse",			use = (EnergyBar1 >= 20) and (not tbuffs["Weakened"]) },
							{ name = "Heart Collection Strike",			use = (EnergyBar1 <= 20) and (tbuffs["Weakened"]) },
							{ name = "Perception Extraction",			use = (EnergyBar1 <= 30) and (EnergyBar1 >= 15) and (not tbuffs[621701]) },
							{ name = "Surge of Malice",					use = (EnergyBar1 >= 20) and (tbuffs["Weakened"]) },
							{ name = "Puzzlement",						use = (EnergyBar1 >= 20) and (tbuffs["Weakened"]) },
							{ name = "Soul Poisoned Fang",				use = (EnergyBar2 >= 25) and (not tbuffs[621399]) },
							{ name = "Shadowstab",						use = (EnergyBar2 >= 20) },
							{ name = "Warp Charge",						use = (EnergyBar1 >= 30) },
							{ name = "Psychic Arrows",					use = (EnergyBar1 >= 20) },
									}
					end
				end
				
			--Class Rogue/Warlock
			elseif mainClass == "THIEF" and subClass == "HARPSYN" then
			
			--Timers for this class
					CreateDIYCETimer("SSBleed", 8.8) --Change the value between 6 -> 7.5 depending on your lag.
					CreateDIYCETimer("LBBleed", 8.8) --Change the value between 7 ->  8.5 depending on your lag.

			--Potions and Buffs
			Skill = {
				{ name = "Energy Conservation",			use = (phealth <= .50) },
				--{ name = "Action: "..Healslot,  		use = (phealth <= .70) and (not combat) and (not party) },
				{ name = "Action: "..healthpot,			use = (phealth <= .70) },
				{ name = "Poison",						use = (not combat) and ((not pbuffs["Poisonous"]) or (pbuffs["Poisonous"].time <= 45))},
				--{ name = "Action: "..speedpot,			use = (not pbuffs["Unbridled Enthusiasm"]) },
				--{ name = "Action: "..foodslot,			use = (not pbuffs["Spicy Meatsauce Burrito"]) },
					}
					
			--Combat
				if enemy then
				Skill2 = {
					{ name = "Premeditation",				use = (not combat) and boss and (EnergyBar1 >= 50) and (not pbuffs["Premeditation"]) },
					--{ name = "Informer",					use = boss },
					--{ name = "Fervent Attack",				use = boss },
					{ name = "Assassins Rage",				use = boss },
					--{ name = "Sneak Attack",				use = (EnergyBar1 >= 20) and boss and behind and party },
					--{ name = "Blind Spot Attack",			use = (EnergyBar1 >= 20) and boss and behind and party },
					{ name = "Warp Charge",					use = (EnergyBar2 >= 30) and (tbuffs["Weakened"]) },
					{ name = "Soul Stab",					use = (EnergyBar2 >= 30) and (tbuffs["Weakened"]) },
					{ name = "Surge of Malice",				use = (EnergyBar2 >= 20) and (tbuffs["Weakened"]) },
					{ name = "Weakening Weave Curse",		use = (EnergyBar2 >= 20) and (not tbuffs["Weakened"]) },
					{ name = "Wound Attack",				use = (EnergyBar1 >= 35) and (tbuffs[620313]) and (tbuffs["Grievous Wound"]) },
					{ name = "Low Blow",					use = (EnergyBar1 >= 30) and (tbuffs[620313]) and (not tbuffs["Grievous Wound"]),	timer = "LBBleed" },
					{ name = "Shadowstab",					use = (EnergyBar1 >= 20) and (not tbuffs[620313]),	timer = "SSBleed" },
					{ name = "Shadowstab",					use = (EnergyBar1 >= 20) },
					{ name = "Attack",						use = (thealth == 1) },					
							}
				end
			
			--Class Mage/Warlock
			elseif mainClass == "MAGE" and subClass == "HARPSYN" then
			
			--Potions and Buffs
				Skill = {
					{ name = "Fire Ward",				use = (pctEB1 >= .05) and ((not pbuffs["Fire Ward"]) or (pbuffs["Fire Ward"].time <= 45))  },										
					{ name = "Intensification",			use = boss and (pctEB1 >= .05) and (not pbuffs["Intensification"])  },										
					{ name = "Elemental Catalysis",		use = boss },										
							}
			
			--Combat
				if enemy then
				Skill2 = {
					{ name = "Silence",							use = (silenceThis) },
					{ name = "Fireball",						use = (pctEB1 >= .05) },
					{ name = "Warp Charge",						use = (EnergyBar2 >= 30) and (not pbuffs["Warp Charge"]) },
					{ name = "Psychic Arrows",					use = (EnergyBar2 >= 20) },
							}
				end
			
			--Class Champion/Rogue
			elseif mainClass == "PSYRON" and subClass == "THIEF" then
			
			--Potions and Buffs
				Skill = {
					{ name = "Remodeled Body",			use = (pbuffs["Shield Form"]) and (phealth <= .15) },
					{ name = "Action: "..healthpot,		use = (phealth <= .70) },
					{ name = "Forge",					use = ((not pbuffs["Forge"]) or (pbuffs["Forge"].time <= 45)) },
					{ name = "Shield Form",				use = (not pbuffs["Shield Form"]) },
							}

			--Ammo Check and Equip
				if (ammo == false) then
					local HaveAmmo = false
					local daggers = ""
						for i=1,60 do
						local x,y,name = GetBagItemInfo(i)
							if (string.find(name, " Dart")) then --Change the name to identify the ones you use.
								HaveAmmo = true
								daggers = name
							end
						end
						if (HaveAmmo == true) then
							i=i+1; Skill[i] = { name = "Item: "..daggers,    use = (not ammo) } --Equip daggers if have           
						elseif ((g_cnt%100) == 0) then
							DEFAULT_CHAT_FRAME:AddMessage"I need to get throwing daggers!"
							return
						end
				end

			--Combat
				if enemy then
					Skill2 = {
						{ name = "Rune Draw",						use = (silenceThis) },
						{ name = "Vacuum Wave",						use = (silenceThis) },
						{ name = "Rune Growth",						use = melee and (not pbuffs[621209])  },																				
						{ name = "Throw",							use = (not melee) },
						{ name = "Shadow Pulse",					use = (EnergyBar2 >= 20) },
						{ name = "Rune Pulse",						use = (pbuffs[621252]) },
						{ name = "Fearless Blows",					use = (EnergyBar1 >= 15) and (thealth <= .44) },
						{ name = "Shadowstab",						use = (EnergyBar2 >= 20) },
						{ name = "Attack",							use = (thealth == 1) },					
							}
				end
				
			--Class Champion/Warlock
			elseif mainClass == "PSYRON" and subClass == "HARPSYN" then
				
			--Potions and Buffs
				Skill = {
					{ name = "Remodeled Body",			use = (pbuffs["Shield Form"]) and (phealth <= .15) },
					{ name = "Action: "..healthpot,		use = (phealth <= .70) },
					{ name = "Forge",					use = ((not pbuffs["Forge"]) or (pbuffs["Forge"].time <= 45)) },
					{ name = "Shield Form",				use = (not pbuffs["Shield Form"]) },
							}
							
			--Combat
				if enemy then
					Skill2 = {
						{ name = "Rune Draw",						use = (silenceThis) },
						{ name = "Vacuum Wave",						use = (silenceThis) },
						{ name = "Rune Growth",						use = melee and (not pbuffs[621209])  },
						{ name = "Custom: Psychic Arrows",			use = (pbuffs[621252]) and (EnergyBar2 >= 20) and (g_lastaction ~= "Psychic Arrows") },
						{ name = "Custom: Rune Pulse",				use = (pbuffs[621252]) and (g_lastaction ~= "Rune Pulse") },
						{ name = "Fearless Blows",					use = (EnergyBar1 >= 15) and (thealth <= .44) },
						{ name = "Attack",					use = (thealth == 1) },					
							}
				end
			
			--ADD MORE CLASS COMBOS ABOVE THIS LINE. 
			--USE AN "ELSEIF" TO CONTINUE WITH MORE CLASS COMBOS.
			--THE NEXT "END" STATEMENT IS THE END OF THE CLASS COMBOS STATEMENTS.
			--DO NOT ADD ANYTHING BELOW THE FOLLOWING "END" STATEMENT!
		end
	--End Player Skill Sequences
	
	if (arg1=="debugskills") then		--Used for printing the skill table, and true/false usability
		DIYCE_DebugSkills(Skill)
		DIYCE_DebugSkills(Skill2)
	elseif (arg1=="debugpbuffs") then	--Used for printing your buff names, and buffID
		DIYCE_DebugBuffList(pbuffs)
	elseif (arg1=="debugtbuffs") then	--Used for printing target buff names, and buffID
		DIYCE_DebugBuffList(tbuffs)
	elseif (arg1=="debugall") then		--Used for printing all of the above at the same time
		DIYCE_DebugSkills(Skill)
		DIYCE_DebugSkills(Skill2)
		DIYCE_DebugBuffList(pbuffs)
		DIYCE_DebugBuffList(tbuffs)
	end
	
	if (not MyCombat(Skill, arg1)) then
		MyCombat(Skill2, arg1)
	end
		
    --Select Next Enemy
	if (tDead) then
		TargetUnit("")
		g_lastaction = ""
		return
	end
	
	if SeigeWar then
		if (not LockedOn) or (not enemy) then
			for i=1,10 do
				if UnitIsPlayer("target") then
					break
				end
				TargetNearestEnemy()
				    StopDIYCETimer("LBBleed")
					StopDIYCETimer("SSBleed")
				return
			end
		end
	
	elseif (not SeigeWar) then
		if mainClass == "RANGER" and (not party) then		--To keep scouts from pulling mobs without meaning to.
			if (not LockedOn) or (not enemy) then
				TargetNearestEnemy()
						g_lastaction = ""
					StopDIYCETimer("LBBleed")
					StopDIYCETimer("SSBleed")
				return
			end
		elseif mainClass ~= "RANGER" then					--Let all other classes auto target.
			if (not LockedOn) or (not enemy) then
				TargetNearestEnemy()
						g_lastaction = ""
				    StopDIYCETimer("LBBleed")
					StopDIYCETimer("SSBleed")
				return
			end
		end
	end
end