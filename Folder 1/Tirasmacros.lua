DEFAULT_CHAT_FRAME:AddMessage("|cf#FFD700Created by Tíramisu, Gurkenhelden, Ainz und Phéles")
DEFAULT_CHAT_FRAME:AddMessage("|cf#FFD700Tirasmacros AddOn und folgende Klassen geladen")

-- On Load
function Tirasmacros_OnLoad(this)
    DEFAULT_CHAT_FRAME:AddMessage("TirasRotas geladen")
    this:RegisterEvent("SAVE_VARIABLES")
    this:RegisterEvent("VARIABLES_LOADED")
    this:RegisterEvent("ZONE_CHANGED")
end

-- On Event
function Tirasmacros_Event(this, event, arg1, arg2)
    tirasmacros.events[event](arg1, arg2)
end

-- Klassen Rota
function rota()
    
	if Isautotarget() then
        if UnitName("target") == nil or UnitIsDeadOrGhost("target") or UnitIsPlayer("target") then
            TargetNearestEnemy()
		end
		end
    if tirasmacros.var.zoneId == 0 then
        tirasmacros.var.zoneId = GetZoneID() % 1000
		end
		
    local main, sec = UnitClassToken("player")
    if (tirasmacros.rotas[main .. sec] ~= nil) then
        tirasmacros.rotas[main .. sec]()
    else
        DEFAULT_CHAT_FRAME:AddMessage("No Rota for " .. main .. sec)
		end
end

-- Buffcheck
function Buffs()
    local main, sec = UnitClassToken("player")
    if (tirasmacros.buffs[main .. sec] ~= nil) then
        tirasmacros.buffs[main .. sec]()
    else
        DEFAULT_CHAT_FRAME:AddMessage("No Bufflist found for " .. main .. sec)
    end
end

-- XML functions
function tirasmacros_Minimap_OnEnter(this)
    GameTooltip:SetOwner(this, "ANCHOR_BOTTOMRIGHT", 0, 0);
    GameTooltip:SetText("Tirasmacros")
    GameTooltip:AddSeparator();
    GameTooltip:AddLine(UI_MINIMAPBUTTON_MOVE, 0, 0.75, 0.95) -- Set move notification --	
    GameTooltip:Show();
end

function tirasmacros_intitialize()
    UIDropDownMenu_Initialize(Tirasmacros_Dropdown1, tirasmacros_DropdownMenue1);
end

-- Filtertype: 1 - Always visible, 2 - MainClass fits, 3 - Main+Sec fits
tirasmacros.buttonVisibility = {
    [1] = {
        filterType = 1,
        notCheckable = 1,
        func = function()
            Toggleautotarget()
        end,
        togglefunc = Isautotarget,
        text = "Autotarget"
    },
    [2] = {
        filterType = 3,
        filter = {
            ["WARDENRANGER"] = true,
            ["WARDENMAGE"] = true,
            ["PSYRONTHIEF"] = true,
            ["PSYRONMAGE"] = true,
            ["THIEFMAGE"] = true,
            ["KNIGHTWARRIOR"] = true,
			["KNIGHTMAGE"] = true,
			["KNIGHTAUGUR"] = true,
            ["WARRIORTHIEF"] = true,
            ["WARRIORMAGE"] = true,
            ["WARRIORRANGER"] = true,
            ["WARRIORWARDEN"] = true,
            ["HARPSYNPSYRON"] = true,
            ["HARPSYNMAGE"] = true,
			["MAGEHARPSYN"] = true,
			["MAGETHIEF"] = true,
			["MAGERANGER"] = true,
			["MAGEWARDEN"] = true
        },
        notCheckable = 1,
        func = function()
            ToggleInterrupt()
        end,
        togglefunc = IsInterrupt,
        text = "Abbruch Modus"
    },
    [3] = {
        filterType = 3,
        filter = {
            ["WARDENRANGER"] = true,
            ["WARDENWARRIOR"] = true,
            ["WARDENTHIEF"] = true,
            ["WARDENMAGE"] = true,
            ["WARRIORWARDEN"] = true,
            ["WARRIORRANGER"] = true,
            ["THIEFWARDEN"] = true,
            ["RANGERWARDEN"] = true,
			["KNIGHTWARRIOR"] = true,
			["KNIGHTMAGE"] = true,
			["KNIGHTAUGUR"] = true
        },
        notCheckable = 1,
        func = function()
            ToggleAoe()
        end,
        togglefunc = IsAoe,
        text = "AoE Rota"
    },
    [4] = {
        filterType = 3,
        filter = {
            ["PSYRONTHIEF"] = true,
			["WARDENWARRIOR"] = true
        },
        notCheckable = 1,
        func = function()
            ToggleTank()
        end,
        togglefunc = IsTank,
        text = "Tank Rota"
    },
	[5] = {
        filterType = 3,
        filter = {
			["MAGETHIEF"] = true,
			["MAGERANGER"] = true,
			["MAGEWARDEN"] = true,
			["WARRIORMAGE"] = true
        },
        notCheckable = 1,
        func = function()
            ToggleAltRota()
        end,
        togglefunc = IsAltRota,
        text = "Alternative Rota"
    },
    [6] = {
        filterType = 1,
        notCheckable = 1,
        func = function()
            CreateMacro()
        end,
        text = "Makro erstellen"
    }
}

-- Gearcheck
function tirasmacros.PrintItemNamesForAllSlots()
    local slotNames = {
        {0, "Head"}, 
        {7, "Shoulders"},
        {3, "Upper Body"},
        {2, "Feet"},
        {5, "Cape"}, 
        {1, "Hands"},
        {6, "Belt"},
        {4, "Lower Body"},
        {11, "Ring 1"},
        {12, "Ring 2"},
        {13, "Earring 1"},
        {14, "Earring 2"},
        {8, "Necklace"},
        {21, "Wings"},
        {15, "Main hand"},
        {16, "Off-hand"},
        {10, "Ranged", "ranged"},
        {9, "Ammunition", "ammo"}, 
    }

    local mainClass, subClass = UnitClassToken('player')
    local isRanger = (mainClass == "RANGER" or subClass == "RANGER")
    local isThiefOrRanger = (mainClass == "THIEF" or subClass == "THIEF" or isRanger)

    local collected = {}

    for i = 1, #slotNames do
        local data = slotNames[i]
        local slotId = data[1]
        local slotLabel = data[2]
        local specialCondition = data[3]

        local _, _, itemName = GetInventoryItemDurable("player", slotId)

        if slotId == 16 then
            -- Off-hand speziell behandeln: nur einfügen, wenn Item vorhanden
            if itemName then
                table.insert(collected, itemName)
            end
        else
            itemName = itemName or "|cffff0000" .. slotId .. ": Kein Item im Slot." .. "|r"
            if specialCondition then
                if (specialCondition == "ranged" and isRanger) or (specialCondition == "ammo" and isThiefOrRanger) then
                    table.insert(collected, itemName)
                end
            else
                table.insert(collected, itemName)
            end
        end
    end

    -- Titel noch anhängen
    local id, tname = GetCurrentTitle()
    table.insert(collected, tname)

    return collected
end


-- Button Menu
function tirasmacros_DropdownMenue1()
    local main, sec = UnitClassToken("player")
    main = main or ""
    sec = sec or ""

    if UIDROPDOWNMENU_MENU_LEVEL == 1 then
        local menuitem = {}
        menuitem.notCheckable = 1
        menuitem.text = "Tirasmacros"
        menuitem.isTitle = 1
        UIDropDownMenu_AddButton(menuitem, UIDROPDOWNMENU_MENU_LEVEL)

        for i, v in ipairs(tirasmacros.buttonVisibility) do
            if CheckMenuItemFilter(main, sec, v) then
                local menuitem = {}
                menuitem.notCheckable = v.notCheckable
                menuitem.func = v.func
                if v.togglefunc and v.togglefunc() then
                    menuitem.text = "|cff00ff00" .. v.text
                else
                    menuitem.text = v.text
                end
                UIDropDownMenu_AddButton(menuitem, UIDROPDOWNMENU_MENU_LEVEL)
            end
        end

        -- Submenu for Buffcheck with an additional submenu
        local menuitem = {}
        menuitem.notCheckable = 1
        menuitem.hasArrow = true  -- Indicates this item has a submenu
        menuitem.value = "BUFFS"
        menuitem.text = "|cFFfff68fBuffcheck"
        UIDropDownMenu_AddButton(menuitem, UIDROPDOWNMENU_MENU_LEVEL)

        -- Submenu for Equipment (Items)
        local menuitem = {}
        menuitem.notCheckable = 1
        menuitem.hasArrow = true
        menuitem.value = "EQUIPMENT"
        menuitem.text = "|cFFfff68fGear"
        UIDropDownMenu_AddButton(menuitem, UIDROPDOWNMENU_MENU_LEVEL)

        -- Reload Button
        local menuitem = {}
        menuitem.notCheckable = 1
        menuitem.func = function()
            lib_reloadFiles()
        end
        menuitem.text = "Reload"
        UIDropDownMenu_AddButton(menuitem, UIDROPDOWNMENU_MENU_LEVEL)

    elseif UIDROPDOWNMENU_MENU_LEVEL == 2 then
        if UIDROPDOWNMENU_MENU_VALUE == "BUFFS" then
            local buffList = tirasmacros.GetBuffCheckList()
            for _, msg in ipairs(buffList) do
                UIDropDownMenu_AddButton({
                    text = msg,
                    notCheckable = 1,
                    isTitle = false, 
                }, UIDROPDOWNMENU_MENU_LEVEL)
            end
        elseif UIDROPDOWNMENU_MENU_VALUE == "EQUIPMENT" then
            -- Hier rufen wir die PrintItemNamesForAllSlots-Funktion auf und fügen sie dem Dropdown-Menü hinzu
            local itemNames = tirasmacros.PrintItemNamesForAllSlots()
            for _, item in ipairs(itemNames) do
                UIDropDownMenu_AddButton({
                    text = item,
                    notCheckable = 1,
                    isTitle = false, 
                }, UIDROPDOWNMENU_MENU_LEVEL)
            end
        end
    end
end

-- Buffcheck abfangen
function tirasmacros.GetBuffCheckList()
    local main, sec = UnitClassToken("player")
    local combo = main .. sec
    local collected = {}
    local redMessages = {}
    local notMessages = {}

    -- Backup der originalen AddMessage-Funktion
    local originalAddMessage = DEFAULT_CHAT_FRAME.AddMessage

    -- Abfangen der Chatnachrichten, einschließlich Farbcodes
    DEFAULT_CHAT_FRAME.AddMessage = function(_, msg)
        
        if string.find(msg, "Buffcheck") then
            return
        end
        
        if string.find(msg, "fehlt") then
            
            table.insert(redMessages, msg)
        
        elseif string.find(msg, "nicht") then
            
            table.insert(notMessages, msg)
        else

            table.insert(collected, msg)
        end
    end

    -- Bufffunktion aufrufen (ohne Ausgabe im Chat)
    if tirasmacros.buffs[combo] then
        tirasmacros.buffs[combo]()  -- Führt die Buffprüfungen aus und gibt die Nachrichten mit Farbcodes aus
    else
        -- Wenn keine Bufffunktion vorhanden ist, Standardnachricht
        table.insert(collected, "|cffff0000Kein Buffcheck für " .. combo .. "|r")
    end

    -- Wiederherstellen der Originalfunktion
    DEFAULT_CHAT_FRAME.AddMessage = originalAddMessage

    for _, redMsg in ipairs(redMessages) do
        table.insert(collected, redMsg)
    end

    for _, notMsg in ipairs(notMessages) do
        table.insert(collected, notMsg)
    end

    return collected
end

-- Cenedril
function tirasmacros.CheckForPhantomItems()
    -- Abrufen der Phantom-Items für Slot 1 und Slot 2
    local ID_Slot1, ID_Slot2 = GetEquipPhantom()

    -- Überprüfen, ob für Slot 1 ein Phantom-Item vorhanden ist
    if ID_Slot1 then
        DEFAULT_CHAT_FRAME:AddMessage("Slot 1 enthält ein Phantom-Item mit der ID: " .. ID_Slot1)
    else
        DEFAULT_CHAT_FRAME:AddMessage("Slot 1 enthält kein Phantom-Item.")
    end

    -- Überprüfen, ob für Slot 2 ein Phantom-Item vorhanden ist
    if ID_Slot2 then
        DEFAULT_CHAT_FRAME:AddMessage("Slot 2 enthält ein Phantom-Item mit der ID: " .. ID_Slot2)
    else
        DEFAULT_CHAT_FRAME:AddMessage("Slot 2 enthält kein Phantom-Item.")
    end
end

-- Menu Class Filter
function CheckMenuItemFilter(main, sec, item)

    if item and item.filterType then

        if item.filterType == 1 then
            return true
        end
        if item.filterType == 2 and item.filter then
            return item.filter[main] == true
        end
        if item.filterType == 3 and item.filter then
            return item.filter[main .. sec] == true
        end
    end

    return false
end