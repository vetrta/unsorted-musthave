local me = {
    active = true,
	debug = false,
    tag = "abr",
    Classes = {

		
	}	
}

local mc, sc
local init = false
local eventRegistered = false
local periodicTimerActive = false
local pendingCheck = false

local EVENT_TAG = me.tag
local EVENT_TIMER_TAG = me.tag .. "_event"
local PERIODIC_TIMER_TAG = me.tag
local CHECK_DELAY = 0.10
local PERIODIC_CHECK_DELAY = 10
local MAX_BUFFS = 50

local UnitBuff = UnitBuff
local UnitClassToken = UnitClassToken
local CancelPlayerBuff = CancelPlayerBuff
local GetTime = GetTime
local print = print
local string_format = string.format

local function DebugPrint(...)
    if me.debug then
        print(...)
    end
end

local function HasPyLib()
    return pylib and pylib.RegisterEventHandler and pylib.UnRegisterEventHandler and pylib.lib and pylib.lib.timer
end

local function UpdateClassTokens()
    mc, sc = UnitClassToken("player")
end

local function RegisterBuffEvent()
    if eventRegistered then return end
    if not HasPyLib() then return end

    pylib.RegisterEventHandler("UNIT_BUFF_CHANGED", EVENT_TAG, me.BuffChange)
    eventRegistered = true
end

local function UnregisterBuffEvent()
    if not eventRegistered then return end
    if not HasPyLib() then return end

    pylib.UnRegisterEventHandler("UNIT_BUFF_CHANGED", EVENT_TAG)
    eventRegistered = false
end

local function StartPeriodicCheck()
    if periodicTimerActive then return end
    if not HasPyLib() then return end

    pylib.lib.timer.Add(PERIODIC_CHECK_DELAY, me.CheckBuffs, PERIODIC_TIMER_TAG)
    periodicTimerActive = true
end

local function StopPeriodicCheck()
    if not periodicTimerActive then return end
    if not HasPyLib() then return end

    pylib.lib.timer.Remove(PERIODIC_TIMER_TAG)
    periodicTimerActive = false
end

local function QueueBuffCheck()
    if pendingCheck then return end
    if not HasPyLib() then return end

    pendingCheck = true
    pylib.lib.timer.Add(CHECK_DELAY, function()
        pendingCheck = false
        me.CheckBuffs()
    end, EVENT_TIMER_TAG, 1)
end

local function ShouldCancelBuff(buffID)
    if not buffID or not mc then return false end

    local classList = me.Classes[mc]
    if not classList then return false end

    -- Optional subclass-specific override, if you later add e.g. me.Classes.PSYRON.THIEF = { [id] = true }
    if sc and type(classList[sc]) == "table" and classList[sc][buffID] then
        return true
    end

    return classList[buffID] == true
end

function me.Init()
    if init then return end
    if not HasPyLib() then
        print(me.tag .. ": pylib saknas - addon kunde inte initieras")
        return
    end

    UpdateClassTokens()

    if me.active then
        RegisterBuffEvent()
        StartPeriodicCheck()
        me.CheckBuffs()
    end

    init = true
end

function me.ClassChange(event, arg1)
    if event ~= "UNIT_CLASS_CHANGED" then return end
    if arg1 ~= "player" then return end

    UpdateClassTokens()
    DebugPrint("abr: Event triggered:", GetTime(), event, arg1, mc, sc)

    if me.active then
        QueueBuffCheck()
    end
end

function me.BuffChange(event, arg1)
    if event ~= "UNIT_BUFF_CHANGED" then return end
    if arg1 ~= "player" then return end

    QueueBuffCheck()
end

function me.CheckBuffs()
    if not me.active then return end
    if not mc then UpdateClassTokens() end

    DebugPrint("abr: Check All Buffs triggered:", GetTime(), mc, sc)

    -- Scan backwards because CancelPlayerBuff(pos) shifts buff indexes.
    for i = MAX_BUFFS, 1, -1 do
        local _, _, _, buffID = UnitBuff("player", i)
        if buffID and ShouldCancelBuff(buffID) then
            CancelPlayerBuff(i)
            DebugPrint("abr: CancelBuff triggered:", GetTime(), buffID, i)
        end
    end
end

function me.CancelBuff(buffID, pos)
    if not me.active then return false end
    if not pos then return false end

    if ShouldCancelBuff(buffID) then
        CancelPlayerBuff(pos)
        DebugPrint("abr: CancelBuff triggered:", GetTime(), buffID, pos)
        return true
    end

    return false
end

function me.Toggle()
    me.active = not me.active

    if me.active then
        UpdateClassTokens()
        RegisterBuffEvent()
        StartPeriodicCheck()
        me.CheckBuffs()
    else
        UnregisterBuffEvent()
        StopPeriodicCheck()
        if HasPyLib() then
            pylib.lib.timer.Remove(EVENT_TIMER_TAG)
        end
        pendingCheck = false
    end

    print(string_format("%s: %sactivated", me.tag, me.active and "|cff00ff00" or "|cffff0000de"))
end

if HasPyLib() then
    pylib.RegisterEventHandler("LOADING_END", EVENT_TAG, me.Init)
    pylib.RegisterEventHandler("UNIT_CLASS_CHANGED", EVENT_TAG, me.ClassChange)
else
    print(me.tag .. ": pylib saknas - events registrerades inte")
end

_G[me.tag] = me
