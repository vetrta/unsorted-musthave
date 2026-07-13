-- (C) 2012-2013 Miranda
--------------------------------------------------------------------------------
-- 名前空間作成
if(_G and not _G.Kitty) then
	_G.Kitty = {};
end

--------------------------------------------------------------------------------
-- ウィンドウ位置
Kitty.loadPosition = function(this)
	-- 表示位置の設定
	local scale = GetUIScale();
	local x = Kitty.SettingManager.setting.window.framePositionX * scale;
	local y = Kitty.SettingManager.setting.window.framePositionY * scale;
	this:ClearAllAnchors();
	this:SetAnchor("TOPLEFT", "TOPLEFT", "UIParent", x, y);
end;
Kitty.savePosition = function(this)
	local scale = GetUIScale();
	local x, y = this:GetPos();
	Kitty.SettingManager.setting.window.framePositionX = x / scale;
	Kitty.SettingManager.setting.window.framePositionY = y / scale;
end;

--------------------------------------------------------------------------------
-- ツールチップ
Kitty.showGameTooltip = function(this, messageList)
	if(type(messageList) ~= "table") then
		messageList = {messageList};
	end

	GameTooltip:SetOwner(this, "ANCHOR_RIGHT", 4, 0);
	for index, message in ipairs(messageList) do
		if(index == 1) then
			-- １行目
			GameTooltip:SetText(tostring(message));
		else
			GameTooltip:AddLine(tostring(message));
		end
	end
	GameTooltip:Show();
end;
Kitty.hideGameTooltip = function(this)
	GameTooltip:Hide();
end;

--------------------------------------------------------------------------------
-- 判定関数
-- コンポーネントタイプ
Kitty.EDITBOX = "EditBox";
Kitty.CHECKBUTTON = "CheckButton";
Kitty.DROPDOWNMENU = "DropDownMenu";
Kitty.LABEL = "Label";
Kitty.BUTTON = "Button";
-- コンポーネント型判定
Kitty.getComponentType = function(componentName)
	local componentType = nil;
	if(string.endsWith(componentName, Kitty.EDITBOX)) then
		componentType = Kitty.EDITBOX;
	elseif(string.endsWith(componentName, Kitty.CHECKBUTTON)) then
		componentType = Kitty.CHECKBUTTON;
	elseif(string.endsWith(componentName, Kitty.DROPDOWNMENU)) then
		componentType = Kitty.DROPDOWNMENU;
	elseif(string.endsWith(componentName, Kitty.LABEL)) then
		componentType = Kitty.LABEL;
	elseif(string.endsWith(componentName, Kitty.BUTTON)) then
		componentType = Kitty.BUTTON;
	else
		error("Error: Invalid component. ComponentName:[" .. componentName .. "]");
	end

	return componentType;
end;

--------------------------------------------------------------------------------
-- DDX
-- 設定情報を画面へ表示する
Kitty.settingToComponent = function(settingData, relativeList)
	-- 設定情報とGUI部品との関係データでループ
	for componentName, data in pairs(relativeList) do
		local component = _G[componentName];
		assert(component, "Error: Component is nil. ComponentName:[" .. componentName .. "]");

		-- 設定情報にない場合は、dataをそのまま表示
		local value = data;
		if(settingData ~= nil and settingData[data] ~= nil) then
			value = settingData[data];
		end

		local componentType = Kitty.getComponentType(componentName);
		if(componentType == Kitty.EDITBOX) then
			-- エディットボックス
			component:SetText(value);
		elseif(componentType == Kitty.CHECKBUTTON) then
			-- チェックボタン
			component:SetChecked(value);
		elseif(componentType == Kitty.DROPDOWNMENU) then
			-- ドロップダウンメニュー
			UIDropDownMenu_SetText(component, value);
		elseif(componentType == Kitty.LABEL) then
			-- ラベル
			component:SetText(value);
		elseif(componentType == Kitty.BUTTON) then
			-- ボタン
			component:SetText(value);
		else
			error("Error: Invalid componentType. ComponentType:[" .. componentType .. "]");
		end
	end
end;
-- 画面の情報を設定値へ保存する
Kitty.componentToSetting = function(settingData, relativeList)
	-- 設定情報とGUI部品との関係データでループ
	for componentName, data in pairs(relativeList) do
		local component = _G[componentName];
		assert(component, "Error: Component is nil. ComponentName:[" .. componentName .. "]");

		local componentType = Kitty.getComponentType(componentName);
		if(componentType == Kitty.EDITBOX) then
			-- エディットボックス
			settingData[data] = component:GetText();
		elseif(componentType == Kitty.CHECKBUTTON) then
			-- チェックボタン
			settingData[data] = component:IsChecked();
		elseif(componentType == Kitty.DROPDOWNMENU) then
			-- ドロップダウンメニュー
			settingData[data] = UIDropDownMenu_GetText(component);
		elseif(componentType == Kitty.LABEL) then
			-- ラベル
		elseif(componentType == Kitty.BUTTON) then
			-- ボタン
		else
			error("Error: Invalid componentType. ComponentType:[" .. componentType .. "]");
		end
	end
end;

--------------------------------------------------------------------------------
-- リスト管理クラス
Kitty.ListManager = {};
-- インスタンスメソッド
-- 更新
Kitty.ListManager.update = function(self, index, element)
	Kitty.debugPrint("Update:[" .. tostring(index) .. "]");
	self[index] = element;
end;
-- 挿入
Kitty.ListManager.insert = function(self, index, element)
	Kitty.debugPrint("Insert:[" .. tostring(index) .. "]");
	table.insert(self, index+1, element);
end;
-- コピー
Kitty.ListManager.copy = function(self, index)
	Kitty.debugPrint("Copy:[" .. tostring(index) .. "]");
	-- DeepCopy
	local element = Kitty.copyTable(self[index]);
	table.insert(self, index+1, element);
end;
-- 削除
Kitty.ListManager.remove = function(self, index)
	Kitty.debugPrint("Remove:[" .. tostring(index) .. "]");
	table.remove(self, index);
end;
-- 要素位置の交換
Kitty.ListManager.swap = function(self, fromIndex, toIndex)
	Kitty.debugPrint("Swap:[" .. tostring(fromIndex) .. ", " .. tostring(toIndex) .. "]");
	if(self[fromIndex] ~= nil and self[toIndex] ~= nil) then
		self[fromIndex], self[toIndex] = self[toIndex], self[fromIndex];
		return true;
	else
		return false;
	end
end;
-- 文字列表現
Kitty.ListManager.toString = function(self)
	local str = "";
	for key, value in pairs(self) do
		if(str ~= "") then
			str = str .. ",\n";
		end
		str = str .. "[" .. tostring(key) .. "]:[" .. Kitty.dump(value) .. "]"
	end

	return str;
end;
-- コンストラクタ
Kitty.ListManager.constructor = function(self, list)
	-- 関数の付与、文字列表現サポート
	return setmetatable(list, {__index=Kitty.ListManager, __tostring=Kitty.ListManager.toString});
end;
setmetatable(Kitty.ListManager, {__call=Kitty.ListManager.constructor});	-- コンストラクタを指定

--------------------------------------------------------------------------------
-- Drag&Drop管理クラス
Kitty.DragAndDropManager = {};
-- スタティックメソッド
Kitty.DragAndDropManager.getClassName = function()
	return "DragAndDropManager";
end;
Kitty.DragAndDropManager.SKILL = "skill";
Kitty.DragAndDropManager.ACTION = "action";
Kitty.DragAndDropManager.BAG = "bag";
Kitty.DragAndDropManager.EQUIP = "equip";
Kitty.DragAndDropManager.BANK = "bank";
Kitty.DragAndDropManager.EMOTE = "emote";
Kitty.DragAndDropManager.MACRO = "macro";
Kitty.DragAndDropManager.SUIT_SKILL = "SuitSkill";
Kitty.DragAndDropManager.SUIT_SKILL_PLATE = "SkillPlate";
Kitty.DragAndDropManager.hookedFunctionList = {
	["DragSkillButton"] = Kitty.DragAndDropManager.SKILL,
	["PickupAction"] = Kitty.DragAndDropManager.ACTION,
	["PickupBagItem"] = Kitty.DragAndDropManager.BAG,
	["PickupEquipmentItem"] = Kitty.DragAndDropManager.EQUIP,
	["PickupBankItem"] = Kitty.DragAndDropManager.BANK,
	["DragEmoteItem"] = Kitty.DragAndDropManager.EMOTE,
	["PickupMacroItem"] = Kitty.DragAndDropManager.MACRO,
	["DragSuitSkill_job"] = Kitty.DragAndDropManager.SUIT_SKILL,
	["SkillPlateDragStart"] = Kitty.DragAndDropManager.SUIT_SKILL_PLATE,
};
-- インスタンスメソッド
Kitty.DragAndDropManager.createHookFunction = function(self, funcName)
	local func = function(index1, index2)
		local cursorType = Kitty.DragAndDropManager.hookedFunctionList[funcName];
		assert(cursorType, "Error: CursorType is nil. FuncName:[" .. funcName .. "]");
		Kitty.debugPrint(cursorType, index1, index2);

		self.cursorType = cursorType;
		self.index1 = index1;
		self.index2 = index2;
	end;
	return func;
end;
Kitty.DragAndDropManager.startHook = function(self)
	-- 関数のフック
	for functionName, _ in pairs(Kitty.DragAndDropManager.hookedFunctionList) do
		if(_G[functionName] ~= nil) then
			_G[functionName] = Kitty.HookManager(_G[functionName], self:createHookFunction(functionName));
		end
	end
end;
Kitty.DragAndDropManager.endHook = function(self)
	-- 関数のアンフック
	for functionName, _ in pairs(Kitty.DragAndDropManager.hookedFunctionList) do
		if(_G[functionName] ~= nil and type(_G[functionName]) == "table" and _G[functionName].getOriginalFunction ~= nil) then
			_G[functionName] = (_G[functionName]):getOriginalFunction();
		end
	end
end;
Kitty.DragAndDropManager.getInfo = function(self)
	return self.cursorType, self.index1, self.index2;
end;
Kitty.DragAndDropManager.clear = function(self)
	self.cursorType = "";
	self.index1 = 0;
	self.index2 = 0;
end;
-- 文字列表現
Kitty.DragAndDropManager.toString = function(self)
	return "CursorType:[" .. tostring(self.cursorType) .. "], Index1:[" .. tostring(self.index1) .. "], Index2:[" .. tostring(self.index2) .. "]";
end;
-- コンストラクタ
Kitty.DragAndDropManager.constructor = function(self)
	-- データメンバ
	local obj = {};
	obj.cursorType = "";
	obj.index1 = 0;
	obj.index2 = 0;

	-- 関数の付与、文字列表現サポート
	return setmetatable(obj, {__index=Kitty.DragAndDropManager, __tostring=Kitty.DragAndDropManager.toString});
end;
setmetatable(Kitty.DragAndDropManager, {__call=Kitty.DragAndDropManager.constructor});	-- コンストラクタを指定

--------------------------------------------------------------------------------
-- DropDownクラス
Kitty.DropDown = {};
-- スタティックメソッド
Kitty.DropDown.SettingtoString = function(setting)
	local check = "[ ]";
	if(setting.checked) then
		check = "[O]";
	end
	local arrow = "[  ]";
	if(setting.hasArrow) then
		arrow = "[->]";
	end
	local title = "[     ]";
	if(setting.isTitle) then
		title = "[Title]";
	end
	local checkable = "[            ]";
	if(setting.notCheckable) then
		checkable = "[notCheckable]";
	end

	return check .. arrow .. title .. checkable .. " [" .. tostring(setting.value) .. "]/[" .. tostring(setting.text) .. "]";
end;
Kitty.DropDown.findIndex = function(list, target)
	for index, item in ipairs(list or {}) do
		if(type(item) == "string") then		-- 要素は文字
			if(item == target) then
				return index;
			end
		elseif(type(item) == "table") then	--要素はsettings
			if(item.value == target) then
				return index;
			end
		else
			error("item was unexpected type. Type:[" .. type(item) .. "]");
		end

		if(item == target) then
			return index;
		end
	end
	return nil;
end;
-- インスタンスメソッド
Kitty.DropDown.getSelectedValue = function(self)
	return self.value;
end;
Kitty.DropDown.getSelectedText = function(self)
	return UIDropDownMenu_GetText(self.dropDownObj);
end;
-- 利用例１(要素は値)
--	local level1 = {"A", "B"};
--	local level2 = {{"A1", "A2"}, {"B1", "B2"}};
-- 利用例２(要素はsetting)
--	local level1 = {
--		{value="A", text="aa"},
--		{value="B", text="bb"}
--	};
--	local level2 = {
--		{{value="A1", text="aa11"}, {value="A2", text="aa22"}, {value="A3", text="aa33"}},
--		{{value="B1", text="bb11"}, {value="B2", text="bb22"}, {value="B3", text="bb33"}}
--	};
Kitty.DropDown.setListData = function(self, onClickFunction, level1, level2)	-- {"A", "B"}, {{"A1", "A2"}, {"B1", "B2"}}
	-- 選択時に呼出される関数
	local func = function(button)
		Kitty.debugPrint("DropDownButton Name:[" .. tostring(button:GetName()) .. "], "
			.. "ID:[" .. tostring(button:GetID()) .. "], Value:[" .. tostring(button.value) .. "], Text:[" .. tostring(button:GetText()) .. "]");

		local previousValue = self.selectedValue;
		local previosuText = UIDropDownMenu_GetText(self.dropDownObj);
		-- 選択値を表示
		self.selectedValue = button.value;
		UIDropDownMenu_SetText(self.dropDownObj, button:GetText());

		if(onClickFunction) then
			onClickFunction(self.dropDownObj, button,
							button.value, button:GetText(),	-- 選択後
							previousValue, previosuText);	-- 選択前
		end

		if(UIDROPDOWNMENU_MENU_LEVEL == 2) then
			-- 第１階層のリストを非表示
			CloseDropDownMenus(1);
		end
	end;

	-- 初期化時に呼出される関数
	local initializeFunction = function()
		Kitty.debugPrint("DropDown Level:[" .. tostring(UIDROPDOWNMENU_MENU_LEVEL) .. "], Value:[" .. tostring(UIDROPDOWNMENU_MENU_VALUE) .. "]");

		local level1Data = nil;
		if(type(level1)=="function") then
			level1Data = level1();	-- 関数実行
		else
			level1Data = level1;
		end

		if(UIDROPDOWNMENU_MENU_LEVEL == 1) then
			-- 第１階層のメニュー
			for index, item in ipairs(level1Data or {}) do
				-- 要素の型判定
				local setting = nil;
				if(type(item) == "string") then	-- 要素は文字
					setting = {};
					setting.text = item;	-- 表示用
					setting.value = item;	-- 内部処理用
				elseif(type(item) == "table") then	--要素はsettings
					setting = Kitty.copyTable(item);
				else
					-- Error.
					error("item was unexpected type. Type:[" .. type(item) .. "]");
				end

				if(not self.isDescriptionMode) then
					local level2Data = nil;
					if(type(level2)=="function") then
						level2Data = level2(index, item);	-- 関数実行
					elseif(type(level2)=="table") then
						level2Data = level2[index];
					else
						level2Data = level2;
					end

					if(not level2Data) then
						-- 第１階層のみ
						if(setting.checked == nil) then
							-- 選択状態の設定
							local isCheck = false;
							if(setting.text == UIDropDownMenu_GetText(self.dropDownObj)) then
								isCheck = true;
							end
							setting.checked = isCheck;
						end
						setting.hasArrow = false;
						setting.func = func;
					else
						-- 第１階層 + 第２階層
						setting.checked = false;
						setting.hasArrow = true;
						setting.isTitle = true;
						setting.notCheckable = true;
						setting.func = nil;
					end
				else
					-- 説明文付与モード
					-- 第１階層 + 第２階層
					if(setting.checked == nil) then
						-- 選択状態の設定
						local isCheck = false;
						if(setting.text == UIDropDownMenu_GetText(self.dropDownObj)) then
							isCheck = true;
						end
						setting.checked = isCheck;
					end
					setting.hasArrow = true;
					setting.func = func;
				end

				-- 選択肢の追加
				UIDropDownMenu_AddButton(setting, UIDROPDOWNMENU_MENU_LEVEL);
			end
		elseif(UIDROPDOWNMENU_MENU_LEVEL == 2) then
			-- 第２階層のメニュー
			local itemIndex = Kitty.DropDown.findIndex(level1Data, UIDROPDOWNMENU_MENU_VALUE);
			local level2Data = nil;
			if(type(level2)=="function") then
				level2Data = level2(itemIndex, UIDROPDOWNMENU_MENU_VALUE);	-- 関数実行
			elseif(type(level2)=="table") then
				level2Data = level2[itemIndex];
			else
				level2Data = level2;
			end

			for index, item in ipairs(level2Data or {}) do
				-- 要素の型判定
				local setting = nil;
				if(type(item) == "string") then		-- 要素は文字
					setting = {};
					setting.text = item;	-- 表示用
					setting.value = item;	-- 内部処理用
				elseif(type(item) == "table") then	--要素はsettings
					setting = Kitty.copyTable(item);
				else
					-- Error.
					error("item was unexpected type. Type:[" .. type(item) .. "]");
				end

				if(not self.isDescriptionMode) then
					if(setting.checked == nil) then
						-- 選択状態の設定
						local isCheck = false;
						if(setting.text == UIDropDownMenu_GetText(self.dropDownObj)) then
							isCheck = true;
						end
						setting.checked = isCheck;
					end
					setting.hasArrow = false;
					setting.func = func;
				else
					-- 説明文付与モード
					setting.checked = false;
					setting.hasArrow = false;
					setting.isTitle = true;
					setting.notCheckable = true;
					setting.func = nil;
				end

				-- 選択肢の追加
				UIDropDownMenu_AddButton(setting, UIDROPDOWNMENU_MENU_LEVEL);
			end
		end
	end;

	if(self.width) then
		UIDropDownMenu_SetWidth(self.dropDownObj, self.width);
	end
	UIDropDownMenu_Initialize(self.dropDownObj, initializeFunction);
end;
-- 文字列表現
Kitty.DropDown.toString = function(self)
	return "Kitty.DropDown";
end;
-- コンストラクタ
Kitty.DropDown.constructor = function(self, dropDownObj, width, isDescriptionMode)
	-- データメンバ
	local obj = {};
	obj.dropDownObj = dropDownObj;
	obj.width = width;
	obj.isDescriptionMode = isDescriptionMode or false;
	obj.selectedValue = "";

	-- 関数の付与、文字列表現サポート
	return setmetatable(obj, {__index=Kitty.DropDown, __tostring=Kitty.DropDown.toString});
end;
setmetatable(Kitty.DropDown, {__call=Kitty.DropDown.constructor});	-- コンストラクタを指定
