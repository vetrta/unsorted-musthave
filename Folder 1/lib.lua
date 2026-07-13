DEFAULT_CHAT_FRAME:AddMessage("|cf#FFD700TirasMacros lib.lua geladen")

tirasmacros = {
    events = {},
    rotas = {},
    buffs = {}
}

tirasmacros.settings = {
    interrupt = false,
    autotarget = false,
    aoe = false,
    defaultButtonVisibility = true
}

tirasmacros.var = {
    zoneId = 0,
    TimeHie = 0,
	TimeKra = 0
}

-- Event - ZoneID
function tirasmacros.events.ZONE_CHANGED(arg1)
    tirasmacros.var.zoneId = GetZoneID() % 1000
end

function tirasmacros.events.VARIABLES_LOADED(arg1)
    if type(tirasmacros_settings) == "table" then
        tirasmacros.settings = tirasmacros_settings
    end
    SaveVariablesPerCharacter("tirasmacros_settings")
    tirasmacros_intitialize()
end

function tirasmacros.events.SAVE_VARIABLES(arg1)
    tirasmacros_settings = tirasmacros.settings
end

-- Addon neuladen
function lib_reloadFiles()
    dofile('interface/addons/Tirasmacros/lib.lua')
	dofile('interface/addons/Tirasmacros/Tirasmacros.lua')
    dofile('interface/addons/Tirasmacros/classes/WARDEN.lua')
    dofile('interface/addons/Tirasmacros/classes/WARRIOR.lua')
    dofile('interface/addons/Tirasmacros/classes/PSYRON.lua')
    dofile('interface/addons/Tirasmacros/classes/KNIGHT.lua')
    dofile('interface/addons/Tirasmacros/classes/RANGER.lua')
    dofile('interface/addons/Tirasmacros/classes/THIEF.lua')
    dofile('interface/addons/Tirasmacros/classes/HARPSYN.lua')
	dofile('interface/addons/Tirasmacros/classes/MAGE.lua')

end

-- Rota Makro erstellen
function CreateMacro()
    local macro = {
        name = "rota_tirasaddon",
        body = "/run rota();",
        index = 0
    }
    local nothingHappened = true

    for i = 1, 56 do
        _, macro_name, _ = GetMacroInfo(i)
        if (macro_name ~= nil and macro_name == macro.name) then
            macro.index = -1
            break
        elseif (macro_name == nil and macro.index == 0) then
            macro.index = i
        end
    end

    if (macro.index > 0) then
        EditMacro(macro.index, macro.name, 50, macro.body)
        DEFAULT_CHAT_FRAME:AddMessage("Macro " .. macro.name .. " created!")
        nothingHappened = false
    end

    if (nothingHappened) then
        DEFAULT_CHAT_FRAME:AddMessage("Makro bereits erstellt!")
    end

end

-- Skill und Action Cooldowns
function GetCooldown(slot1, slot2)
    local cd, cdskill = 0, 0
    if slot2 then
        cd, cdskill = GetSkillCooldown(slot1, slot2)
    else
        cd, cdskill = GetActionCooldown(slot1)
    end
    return cdskill
end

-- Spieler Buffabfrage
function CheckBuff(...)
    local buffs = {}
    for k,v in pairs({...}) do
        buffs[v] = true
    end
    for i = 1, 50, 1 do
        local Buff, _, _, ID = UnitBuff("player", i)
        if not ID then return false end
        if buffs[ID] then
            return true
        end
    end
    return false
end

-- Spieler Buffzeit Abfrage
function CheckBufftime(BuffID)
    local lefttime = 0
    for i = 1, 50, 1 do
        local Buff, _, _, ID = UnitBuff("player", i)
        if BuffID == ID then
            lefttime = UnitBuffLeftTime("player", i)
            break
        end
    end
    return lefttime
end

-- Spieler Buffanzahlabfrage
function GetBuffNum(unit) 
    local unit = unit or "player"
    for i = 1,50 do 
        local _,icon,_,ID = UnitBuffInfo(unit,i) 
        if not ID then 
            return i - 1 
        end
    end 
	return 50
end

-- Spieler Buffsrausdrücken
function GetCancelID(id) 
    local pos = 0
    for i=1,50 do 
        local _,icon,_,ID = UnitBuffInfo("player",i) 
        if not ID then return 0 end
        if icon then 
			pos = pos + 1 
		end
        if ID == id then 
			return pos
        end
    end 
end

-- Spieler Debuffzeit Abfrage
function CheckPlayerDebuffTimeMax(...)
    local buffs = {}
    for k,v in pairs({...}) do
        buffs[v] = true
    end
    local max = 0

    for i=1, 50 do 
        local _,_,_,ID = UnitDebuff("player", i)
        if buffs[ID] then
            max = math.max(max, UnitDebuffLeftTime("player", i))
        end
    end
    return max
end

-- Target Enemy
function isEnemy(unit)
	unit = unit or 'target'
    if not UnitIsDeadOrGhost(unit) and UnitCanAttack('player', unit) and not UnitIsUnit(unit, 'player') then
		return true
	end
	return false
end

-- Target Buffabfrage
function CheckBuffTarget(...)
    local buffs = {}
    for k,v in pairs({...}) do
        buffs[v] = true
    end
	for i = 1, 50, 1 do
        local Buff, _, name, ID = UnitBuff("target", i)
        if not ID then return false end
        if buffs[ID] then
            return true
        end
    end
    return false
end

-- Target Debuffabfrage
function CheckDeBuffs(...)
    local buffs = {}
    for k,v in pairs({...}) do
        buffs[v] = true
    end
    for i = 1, 50, 1 do
        local Buff, _, _, ID = UnitDebuff("target", i)
        if not ID then return false end
		if buffs[ID] then
            return true
        end
    end
    return false
end

-- Matching Debuffabfrage
function CheckAllDeBuffs(...)
    local requiredBuffs = {}
    for _, v in ipairs({...}) do
        requiredBuffs[v] = true
    end

    local foundBuffs = {}

    for i = 1, 50 do
        local Buff, _, _, ID = UnitDebuff("target", i)
        if not ID then break end
        if requiredBuffs[ID] then
            foundBuffs[ID] = true
        end
    end

    for id in pairs(requiredBuffs) do
        if not foundBuffs[id] then
            return false
        end
    end

    return true
end


-- Target Debuffzeit Abfrage
function CheckDebufftime(...)
        local buffs = {}
    for k,v in pairs({...}) do
        buffs[v] = true
    end
	local lefttime = 0
    for i = 1, 50, 1 do
        local _, _, _, ID = UnitDebuff("target", i)
        if buffs[ID] then
            lefttime = UnitDebuffLeftTime("target", i)
            break
        end
    end
    return lefttime
end

-- Target Anzahl Debuffabfrage bswp. Hieb
function NumberDeBuffs(DeBuffID)
    local i = 1
    local Buff, _, _, ID = UnitDebuff("target", i)
    local NumberDeBuffs = 0
    while Buff ~= nil do
        if DeBuffID == ID then
            NumberDeBuffs = NumberDeBuffs + 1
        end
        i = i + 1
        Buff, _, _, ID = UnitDebuff("target", i)
    end
    return NumberDeBuffs
end

-- Target Debuff StackCounter Abfrage bspw. Seelenbrand
function CheckDeBuffsCount(DeBuffID, Stack)
    for i = 1, 50, 1 do
        local Buff, _, Count, ID = UnitDebuff("target", i)
        if DeBuffID == ID then
            if Stack then
                if Count == Stack then
                    return true
                else
                    return false
                end
            else
                return true
            end
        end
    end
    return false
end

-- TargetTarget Buffabfrage
function BTT(...)
    local buffs = {}
    for k,v in pairs({...}) do
        buffs[v] = true
    end
    for i = 1, 50, 1 do
        local Buff, _, name, ID = UnitBuff("targettarget", i)
        if not ID then return false end
        if buffs[ID] then
            return true
        end
    end
    return false
end

-- PlayerCharacter HP in %
function unitHP(unit)
    unit = unit or 'player'
    local perc = (UnitHealth(unit) / UnitMaxHealth(unit)) * 100
    return perc
end

-- Hieb Timer
function CheckTimeHieb()
    return (TimeHie == 0) or (GetTickCount() >= (TimeHie + 7000)) or (GetTickCount() <= (TimeHie + 350))
end
TimeHie = GetTickCount();

-- THIEF/WARDEN Kraft des Baumgeistes Timer
function CheckTimeKraft()
    return (TimeKra == 0) or (GetTickCount() >= (TimeKra + 20000)) or (GetTickCount() <= (TimeKra + 350))
end
TimeKra = GetTickCount();

-- Einhand / Zweihand Waffen Abfrage
function Waffentyp(target)
    local mainHand = GetInventoryItemType(target, 15);
    local secondaryHand = GetInventoryItemType(target, 16)
    if (mainHand == 1 and secondaryHand == -1) then
        return "2h"
    elseif (mainHand == 1 and secondaryHand == 0) then
        return "schild"
    elseif (mainHand == 1 and secondaryHand == 1) then
        return "doppelt"
    else
        return false
    end
end

-- PDD WARRIOR Abfrage
function WarriorIsInRaid()
    local classname = "WARRIOR";
    local secToIgnore = "MAGE";
    for i = 1, 12 do
        local tmpUnit = "raid" .. i;
        if UnitExists(tmpUnit) then
            local main, second = UnitClassToken(tmpUnit);
            if main == classname and second ~= secToIgnore then
                return true;
            end
        end
    end
    return false;
end

-- HARPSYN/MAGE Abfrage
function WarlockIsInRaid()
    local classname = "HARPSYN";
    local secToIgnore = "MAGE";
    for i = 1, 12 do
        local tmpUnit = "raid" .. i;
        if UnitExists(tmpUnit) then
            local main, second = UnitClassToken(tmpUnit);
            if main == classname and second ~= secToIgnore then
                return true;
            end
        end
    end
    return false;
end

-- KNIGHT/WARRIOR Abfrage
function KnightWarriorIsInRaid()
    local classname = "KNIGHT";
    local secclassname = "WARRIOR";
    for i = 1, 12 do
        local tmpUnit = "raid" .. i;
        if UnitExists(tmpUnit) then
            local main, second = UnitClassToken(tmpUnit);
            if main == classname and second == secclassname then
                return true;
            end
        end
    end
    return false;
end

-- KNIGHT/AUGUR Abfrage
function KnightPriestIsInRaid()
    local classname = "KNIGHT";
    local secclassname = "AUGUR";
    for i = 1, 12 do
        local tmpUnit = "raid" .. i;
        if UnitExists(tmpUnit) then
            local main, second = UnitClassToken(tmpUnit);
            if main == classname and second == secclassname then
                return true;
            end
        end
    end
    return false;
end

-- Autotarget (de)aktivieren
function Toggleautotarget()
    tirasmacros.settings.autotarget = not tirasmacros.settings.autotarget
    if tirasmacros.settings.autotarget then
        SendWarningMsg("|cff00ff00Autotarget: Aktiviert")
    else
        SendWarningMsg("|cffff0000Autotarget: Deaktiviert")
    end
    return tirasmacros.settings.autotarget
end
function Isautotarget()
    return tirasmacros.settings.autotarget
end

-- Flächenschaden Rota (de)aktivieren
function ToggleAoe()
    tirasmacros.settings.aoe = not tirasmacros.settings.aoe
    if tirasmacros.settings.aoe then
        SendWarningMsg("|cff00ff00AoE: Aktiviert")
    else
        SendWarningMsg("|cffff0000AoE: Deaktiviert")
    end
    return tirasmacros.settings.aoe
end
function IsAoe()
    return tirasmacros.settings.aoe
end

-- Unterbrecher Rota (de)aktivieren
function ToggleInterrupt()
    tirasmacros.settings.interrupt = not tirasmacros.settings.interrupt
    if tirasmacros.settings.interrupt then
        SendWarningMsg("|cff00ff00Abbruch Modus: Aktiviert")
    else
        SendWarningMsg("|cffff0000Abbruch Modus: Deaktiviert")
    end
    return tirasmacros.settings.interrupt
end
function IsInterrupt()
    return tirasmacros.settings.interrupt
end

-- Tank Rota (de)aktivieren
function ToggleTank()
    tirasmacros.settings.tank = not tirasmacros.settings.tank
    if tirasmacros.settings.tank then
        SendWarningMsg("|cff00ff00TankRota: Aktiviert")
    else
        SendWarningMsg("|cffff0000TankRota: Deaktiviert")
    end
    return tirasmacros.settings.tank
end
function IsTank()
    return tirasmacros.settings.tank
end

-- NoneMeta Rotation (de)aktivieren zb Magier/Kundschafter
function ToggleAltRota()
    tirasmacros.settings.nonemeta = not tirasmacros.settings.nonemeta
    if tirasmacros.settings.nonemeta then
        SendWarningMsg("|cff00ff00NoneMeta Aktiviert")
    else
        SendWarningMsg("|cffff0000NoneMeta Deaktiviert")
    end
    return tirasmacros.settings.nonemeta
end
function IsAltRota()
    return tirasmacros.settings.nonemeta
end

-- Abzubrechende Casts und Unterbrecher Rota (de)aktivieren
local SilenceList = {
    ['Sturmimpuls'] = true,
	["Storm's Pulse"] = true,
	["Pulso de la tormenta"] = true,
	["Pulsation de la tempête"] = true,
	["Puls Sztormu"] = true,
    ['Flammensto\195\159'] = true,
	["Flame"] = true,
	["Llama"] = true,
	["Enflammement"] = true,
	["Płomień"] = true,
    ['Farbenspiel'] = true,
	["What about that color"] = true,
	["¿Qué pasa con ese color?"] = true,
	["Et cette couleur ?"] = true,
	["Co to za kolor"] = true,
    ['Schwerer Beschuss'] = true,
	["Heavy Shelling"] = true,
	["Bombardeo violento"] = true,
	["Pilonnage intensif"] = true,
	["Gwałtowny Ostrzał"] = true,
    ['Schwarze Heilung'] = true,
    ['Dunkle Heilung'] = true,
	["Dark Healing"] = true,
	["Curación oscura"] = true,
	["Soin obscur"] = true,
	["Mroczne Leczenie"] = true,
    ['Verst\195\164rkte Bestrafung'] = true,
	["Amplified Punishment"] = true,
	["Castigo amplificado"] = true,
	["Châtiment amplifié"] = true,
	["Wzmocniona Kara"] = true,
    ['Myrmex \195\156berleben'] = true,
	["Myrmex Survival"] = true,
	["Supervivencia de Hormiga león"] = true,
	["Survie Myrmex"] = true,
	["Przetrwanie Myrmexów"] = true,
    ['Enthaupten'] = true,
	["Behead"] = true,
	["Decapitación"] = true,
	["Décapitation"] = true,
	["Dekapitacja"] = true,
    ['Jolyttas Kuss'] = true,
	["Jolytta's Kiss"] = true,
	["Beso de Jolytta"] = true,
	["Baiser de Jolytta"] = true,
	["Pocałunek Jolytty"] = true,
    ['Beschw\195\182rung: Unterweltschatten'] = true,
	["Summon Underworld Shadow"] = true,
	["Invocar sombra del Averno"] = true,
	["Invoquer l'ombre de l'au-delà"] = true,
	["Przyzwij Cień z Zaświatów"] = true,
    ['Sandsturm'] = true,
	["Sand Storm"] = true,
	["Tormenta de arena"] = true,
	["Tempête de sable"] = true,
	["Burza Piaskowa"] = true,
    ['Totenbeschw\195\182rer'] = true,
	["Necromancer"] = true,
	["Nigromante"] = true,
	["Nécromancien"] = true,
	["Nekromanta"] = true,
    ['Erdpflug'] = true,
	["Earth Plow"] = true,
	["Arado de la tierra"] = true,
	["Charrue de terre"] = true,
	["Ziemny Pług"] = true,
    ['Licht der Vernichtung'] = true,
	["Light of Annihilation"] = true,
	["Luz aniquiladora"] = true,
	["Lumière d'annihilation"] = true,
	["Światło Anihilacji"] = true,
    ['Beschw\195\182rung der Toten'] = true,
	["Summon the Dead"] = true,
	["Invocación de los muertos"] = true,
	["Invocation des morts"] = true,
	["Przywołanie Umarłych"] = true,
    ['Seelenvernichtung'] = true,
	["Soul Crush"] = true,
	["Destrucción del alma"] = true,
	["Écrasement d'âmes"] = true,
	["Zmiażdżenie Duszy"] = true,
    ['Seelenverwehung'] = true,
	["Soul Drift"] = true,
	["Torbellino de almas"] = true,
	["Amas d'âmes"] = true,
	["Dryf Duszy"] = true,
    ['Götzenbeben'] = true,
	["Idolquake"] = true,
	["Ídolo temblante"] = true,
	["Secousse d'idole"] = true,
	["Boski Wstrząs"] = true,
    ['Flamme'] = true,
    ['Wirbelnder Angriff'] = true,
	["Spin Attack"] = true,
	["Ataque giratorio"] = true,
	["Attaque tournoyante"] = true,
	["Atak Obrotowy"] = true,
    ['Magischer Ritterschild'] = true,
	["Magic Knight Shield"] = true,
	["Escudo mágico de caballero"] = true,
	["Bouclier de chevalier magique"] = true,
	["Magiczna Tarcza Rycerza"] = true,
    ['Zerstörungsschlag'] = true,
	["Devastation Strike"] = true,
	["Golpe de destrucción"] = true,
	["Coup destructeur"] = true,
	["Niszczący Cios"] = true,
    ['Beben'] = true,
	["Quake"] = true,
	["Tremblement"] = true,
	["Terremoto"] = true,
	["Trzęsienie"] = true,
    ['Todessichel'] = true,
	["Death Sickle"] = true,
	["Guadaña mortal"] = true,
	["Faucille mortelle"] = true,
	["Sierp Śmierci"] = true,
    ['Formationsbrecher'] = true,
	["Formation Breaker"] = true,
	["Rompedefensa"] = true,
	["Brise-formation"] = true,
	["Łamacz Formacji"] = true,
    ['Ansturm'] = true,
	["Charge"] = true,
	["Embestida"] = true,
	["Natarcie"] = true,
    ['Durchbohrender Angriff'] = true,
	["Piercing Attack"] = true,
	["Ataque desgarrador"] = true,
	["Attaque perforante"] = true,
	["Przeszywający Atak"] = true,
	['Schwerttanz'] = true,
	["Sword Dance"] = true,
	["Danza de filos"] = true,
	["Danse-lames"] = true,
	["Taniec z Mieczami"] = true,
	['Elektrische Energie'] = true,
	["Electrical Energy"] = true,
	["Energía eléctrica"] = true,
	["Énergie électrique"] = true,
	["Elektryczna Energia"] = true,
	["Mittlere Durchbohrung"] = true,
	["Middle Drill"] = true,
	["Perforación intermedia"] = true,
	["Perforation centrale"] = true,
	["Średnie Przewiercenie"] = true,
	["Doppelklingen-Spalter"] = true,
	["Double Bladed Cleave"] = true,
	["Faucheuse à deux lames"] = true,
	["Obosieczne Rozrąbanie"] = true,
}
function isNeedInterrupt(unit)
    if (not tirasmacros.settings.interrupt) then
        return false
    end
    local tSpell, tTime, tElapsed = UnitCastingTime(unit or "target")
    return (tSpell and SilenceList[tSpell] and tElapsed > 0.1)
end

function tirasmacros_generalBuffs()
    -- Überprüft die allgemeinen Buffs und gibt die entsprechenden Nachrichten aus
    if not CheckBuff(623776, 623778) then
        DEFAULT_CHAT_FRAME:AddMessage("|cffff0000Attri Hochzeitfoods fehlt")
    else
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00Attri Hochzeitfood vorhanden")
    end
    if not CheckBuff(502341) then
        DEFAULT_CHAT_FRAME:AddMessage("|cffff0000Unbesiegbarer Angriff fehlt")
    else
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00Unbesiegbarer Angriff vorhanden")
    end
    if not CheckBuff(620454) then
        DEFAULT_CHAT_FRAME:AddMessage("|cffff0000Wilde Segnung fehlt")
    else
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00Wilde Segnung vorhanden")
    end
    if not CheckBuff(501337) then
        DEFAULT_CHAT_FRAME:AddMessage("|cffff0000Helden-Trank fehlt")
    else
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00Helden-Trank vorhanden")
    end
    if not CheckBuff(621736) then
        DEFAULT_CHAT_FRAME:AddMessage("|cffff0000Webefluch fehlt")
    else
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00Webefluch vorhanden")
    end
    if not CheckBuff(622528, 622534) then
        DEFAULT_CHAT_FRAME:AddMessage("|cffff0000Kleiner Sternenbegleiter fehlt")
    else
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00Kleiner Sternenbegleiter vorhanden")
    end
    if not CheckBuff(622534, 622790) then
        DEFAULT_CHAT_FRAME:AddMessage("|cffff0000Großer Sternenbegleiter fehlt")
    else
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00Großer Sternenbegleiter vorhanden")
    end
    if IsPetSummoned(1) == false and IsPetSummoned(2) == false and IsPetSummoned(3) == false and IsPetSummoned(4) == false and IsPetSummoned(5) == false and IsPetSummoned(6) == false then
        DEFAULT_CHAT_FRAME:AddMessage("|cffff0000Pet nicht beschworen")
    else
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00Pet beschworen")
    end
    local rare, ep, rep, epmax = GetAncillaryTitleInfo()
    if rep == 0 then
        DEFAULT_CHAT_FRAME:AddMessage("|cffff0000Titelsystem nicht aktiv")
    else
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00Titelsystem aktiv")
    end

    -- Phantom-Items überprüfen
    local ID_Slot1, ID_Slot2 = GetEquipPhantom()

    -- Phantom-Items mit ihren Namen
    local phantomNames = {
        [250000] = "Liphisto", [250001] = "Bendor", [250002] = "Mersi",
        [250003] = "Mayi", [250004] = "Salo", [250005] = "Wolin",
        [250006] = "Alis", [250007] = "Forensa", [250008] = "Shados",
        [250009] = "Schreck", [250010] = "Moony", [250011] = "Vestin",
        [250012] = "Tatuin", [250013] = "Ardes", [250014] = "Garsist",
        [250015] = "Farell", [250016] = "Lunder", [250017] = "Froststreitross"
    }

    -- Wenn Slot 1 Cenedril
    if ID_Slot1 and phantomNames[ID_Slot1] then
        DEFAULT_CHAT_FRAME:AddMessage("|cFFff1493" .. phantomNames[ID_Slot1] .. "|r")
    else
        DEFAULT_CHAT_FRAME:AddMessage("Slot 1 Cenedril fehlt.")
    end

    -- Wenn Slot 2 Cenedril
    if ID_Slot2 and phantomNames[ID_Slot2] then
        DEFAULT_CHAT_FRAME:AddMessage("|cFFff1493" .. phantomNames[ID_Slot2] .. "|r")
    else
        DEFAULT_CHAT_FRAME:AddMessage("Slot 2 Cenedril fehlt.")
    end
end


-- Magischer DD Buffcheck
function MDDBuffs()
    if not CheckBuff(507062, 507071) then
        DEFAULT_CHAT_FRAME:AddMessage("|cffff0000Matk / DMG Food fehlt")
    else
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00Matk / DMG Food vorhanden")
    end
    if not CheckBuff(505165) then
        DEFAULT_CHAT_FRAME:AddMessage("|cffff0000Mag. Anmut fehlt")
    else
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00Mag. Anmut vorhanden")
    end
    if not CheckBuff(501962) then
        DEFAULT_CHAT_FRAME:AddMessage("|cffff0000Mag. Essenz fehlt")
    else
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00Mag. Essenz vorhanden")
    end
    if not CheckBuff(501778) then
        DEFAULT_CHAT_FRAME:AddMessage("|cffff0000Wassergeist fehlt")
    else
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00Wassergeist vorhanden")
    end
    if not CheckBuff(506634) then
        DEFAULT_CHAT_FRAME:AddMessage("|cffff00006% Hausmädchenbuff fehlt")
    else
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ff006% Hausmädchenbuff vorhanden")
    end
    if not CheckBuff(623775, 623773) then
        DEFAULT_CHAT_FRAME:AddMessage("|cffff0000Matk Hochzeitsfood fehlt")
    else
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00Matk Hochzeitsfood vorhanden")
    end
    tirasmacros_generalBuffs()
end

-- Physischer DD Buffcheck
function PDDBuffs()
    if not CheckBuff(507044, 507053) then
        DEFAULT_CHAT_FRAME:AddMessage("|cffff0000Patk / DMG Food fehlt")
    else
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00Patk / DMG Food vorhanden")
    end
    if not CheckBuff(506638, 506642) then
        DEFAULT_CHAT_FRAME:AddMessage("|cffff00006% Hausmädchenbuff fehlt")
    else
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ff006% Hausmädchenbuff vorhanden")
    end
    if not CheckBuff(500940, 505157, 623402) then
        DEFAULT_CHAT_FRAME:AddMessage("|cffff0000Druide / Priester Buff fehlt")
    else
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00Druide / Priester Buff vorhanden")
    end
    if not CheckBuff(623770, 623772) then
        DEFAULT_CHAT_FRAME:AddMessage("|cffff0000Patk Hochzeitsfood fehlt")
    else
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00Patk Hochzeitsfood vorhanden")
    end
    tirasmacros_generalBuffs()
end

-- Ini Stuns
	local inistuns = {
	503836, -- Vom Donner betäubt
	501511, -- Vom Donner betäubt
	500236, -- Zyklon - Niederwurf
	506747, -- Zyklon - Niederwurf
	622477, -- Zyklon - Niederwurf
	502717, -- Entladung
	503850, -- Entladung
	622478, -- Entladung
	622482, -- Entladung
	623936, -- Entladung
	500243, -- Ansturm
	504257, -- Ansturm
}

-- KNIGHT Siegel
	local rsiegel = {
	500140, -- Heiliges Siegel 1
	500146, -- Heiliges Siegel 2
	500168, -- Heiliges Siegel 3
	500169, -- Heiliges Siegel 4
}

-- Allgemeine Stuns
local stuns = {
	500243, -- Ansturm
	504257, -- Ansturm
	500247, -- Schock
	500248, -- Schock
	500249, -- Schock
	500253, -- Schock
	500259, -- Schock
	500223, -- Bestrafung
	501511, -- Donner
	503836, -- Donner
	502717, -- Entladung
	503850, -- Entladung
	622478, -- Entladung
	622482, -- Entladung
	623936, -- Entladung
	503837, -- Blitzschlag
	503635, -- Verbannt
}

-- Allgemeine Fears
local fears = {
	500399,
	500506,
	500903,
	500974,
	500980,
	501306,
	501442,
	501463,
	501642,
	501692,
	502001,
	502011,
	502150,
	502241,
	502373,
	502436,
	502441,
	502500,
	502517,
	502943,
	502949,
	502954,
	502992,
	503047,
	503370,
	503400,
	503413,
	503447,
	503561,
	503660,
	504057,
	504100,
	504107,
	504214,
	504224,
	504363,
	504689,
	504806,
	504807,
	504973,
	504990,
	504999,
	505039,
	505346,
	505579,
	505796,
	505817,
	505961,
	506110,
	506261,
	506426,
	506551,
	506895,
	506933,
	506939,
	507264,
	507283,
	507288,
	507350,
	507588,
	507614,
	507762,
	507766,
	507855,
	507856,
	507909,
	507967,
	508014,
	508022,
	508031,
	508229,
	508307,
	508312,
	508486,
	508603,
	508608,
	508653,
	508775,
	508833,
	508850,
	508866,
	509007,
	509014,
	509421,
	509441,
	509580,
	509728,
	509870,
	509888,
	620039,
	620060,
	620140,
	620160,
	620968,
	621194,
	621220,
	621292,
	621576,
	621692,
	621725,
	621774,
	621868,
	621965,
	622055,
	622126,
	622379,
	622498,
	623192,
	623238,
	623482,
	623493,
	623623,
	623676,
	623724,
	623750,
	623972,
	624129,
	624256,
	624337,
	624385,
	624445,
	624747,
	624829,
	624903,
	625086,
	625163,
	625349,
	625409,
	625461,
	625471,
	625587,
	625588,
	625589,
	625590,
	625591,
	625731,
	625790,
	625794,
	625795,
	625796,
	626106,
	626172,
	626240,
	626844,
	626986,
}

-- Gesamt Immuns
	local gimmuns = {
	501546, -- Gesegnete Aura
    502902, -- Gesegnete Aura
    621425, -- Gesegnete Aura
    621559, -- Gesegnete Aura
    623184, -- Gesegnete Aura
    505925, -- Herold Immun
    505932, -- Herold Immun
	503635, -- Verbannt
	504240, -- Verbannt
}

-- Magisch Immuns
	local mimmuns = {
    621270, -- Verteidigungsnetz
    621286, -- Verteidigungsnetz
    501190, -- Serenstum
    501182, -- Kuchen der singenden Wälder
}

-- Physisch Immuns
	local pimmuns = {
    501189, -- Laorobstkuchen
    501178, -- Regenbogenkristallzucker
	500943, -- Heiliger Schild
}

-- % DMG Reduce
	local dmgreduce = {
	500572, -- Schutzschirm der Anderswelt
    500570, -- Schutzschirm der Anderswelt
    624355, -- Schutz der Leere
    624357, -- Schutz der Leere
    504583, -- Felspanzer
    503813, -- Felspanzer
    505183, -- Felspanzer
}

-- Physische Stuns
	local pstuns = {
	503836, -- Vom Donner betäubt
	501511, -- Vom Donner betäubt
	500236, -- Zyklon - Niederwurf
	506747, -- Zyklon - Niederwurf
	622477, -- Zyklon - Niederwurf
	622974, -- Barbarische Exekution
	500243, -- Ansturm
	504257, -- Ansturm
	622972, -- Ins Schwarze
	503635, -- Verbannt
	504240, -- Verbannt
}

-- Schilde BK
	local bsschilde = { 
	623173, -- Manaschild
	621189, -- Fester Gedankenschild
	621416, -- Energiereiche Barriere
}

-- Anti Stuns
	local antistuns = {
	620139, -- Seelenkämpfer
	501805, -- Schmerz ignorieren
	504357, -- Furchtlos
}

-- Klassen Abfrage
local mainClass, subClass = UnitClassToken("target")

-- UnitBuff returns: name, icon, count, ID
function PrintAllActiveBuffs()
    local i = 1
    local hasBuffs = false

    while true do
        local name, icon, count, id = UnitBuffInfo("target", i)
        if not name then break end

        hasBuffs = true
        local stackText = count and count > 1 and (" (x" .. count .. ")") or ""

        DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00Buff " .. i .. ": " .. name .. " (ID: " .. id .. ")" .. stackText)
        i = i + 1
    end

    if not hasBuffs then
        DEFAULT_CHAT_FRAME:AddMessage("|cffff0000Keine aktiven Buffs gefunden.")
    end
end

-- Pet Skills aktivieren z.B. Bewahrer oder Magier Kundschafter
function EnablePetSkillAutoCast(...)
    if not PetActionBarFrame:IsVisible() then
        return false
    end

    local success = false
    local args = {...}

    for _, skill in ipairs(args) do
        if type(skill) == "number" then
            if skill >= 1 and skill <= 10 then
                local icon_path, isActive, autoCastAllowed = GetPetActionInfo(skill)
                if icon_path and autoCastAllowed and not isActive then
                    UsePetAction(skill, true)
                    success = true
                end
            end
        end
    end
    return success
end
