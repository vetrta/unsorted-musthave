-- (C) 2012-2013 Miranda
--------------------------------------------------------------------------------
-- 名前空間作成
if(_G and not _G.Kitty) then
	_G.Kitty = {};
end

--------------------------------------------------------------------------------
-- 設定情報
Kitty.SettingManager = {};
Kitty.SettingManager.VARIABLE_NAME = "KittyCombo_Setting";	-- おそらく"_G"直下しか指定できない
Kitty.SettingManager.setting = {};	-- 設定値
Kitty.SettingManager.setting.window = {};
Kitty.SettingManager.setting.basic = {};
Kitty.SettingManager.setting.gradation = {};
Kitty.SettingManager.setting.command = {};

Kitty.SettingManager.onVariablesLoaded = function(version)
	local settingFromFile = _G[Kitty.SettingManager.VARIABLE_NAME];

	local settingToFile = {};
	if(settingFromFile == nil) then
		-- 保存していたデータはなし
		settingToFile = Kitty.SettingManager.defaultSetting;
	elseif(type(settingFromFile) == "table") then
		-- 保存していたデータあり
		-- ゴミが発生した場合に除去するため、基本単位ごとにコピーする

		-- ウィンドウの表示位置
		if(settingFromFile.window == nil) then
			-- 基本設定初期値
			settingToFile.window = Kitty.SettingManager.defaultSetting.window;
		else
			settingToFile.window = settingFromFile.window;
		end

		-- 基本設定情報
		if(settingFromFile.basic == nil) then
			-- 基本設定初期値
			settingToFile.basic = Kitty.SettingManager.defaultSetting.basic;
		else
			settingToFile.basic = settingFromFile.basic;

			if(settingToFile.basic.showDamageDoneThreshold == nil) then
				settingToFile.basic.showDamageDone = nil;	-- ごみ掃除
				settingToFile.basic.showDamageDoneThreshold = Kitty.SettingManager.defaultSetting.basic.showDamageDoneThreshold;
			end
		end

		-- チャットカラー情報
		if(settingFromFile.gradation == nil) then
			-- 基本設定初期値
			settingToFile.gradation = Kitty.SettingManager.defaultSetting.gradation;
		else
			settingToFile.gradation = settingFromFile.gradation;
		end

		-- コマンドリスト
		if(settingFromFile.command == nil) then
			-- 基本設定初期値
			settingToFile.command = Kitty.copyTable(Kitty.SettingManager.defaultSetting.command);
		else
			settingToFile.command = settingFromFile.command;
		end
	else
		error("Error: Stored data is not table format. Data:[" .. tostring(settingFromFile) .. "]");
	end
	-- 現在のバージョンを記録
	settingToFile.version = version;

	_G[Kitty.SettingManager.VARIABLE_NAME] = settingToFile;
	Kitty.SettingManager.setting = _G[Kitty.SettingManager.VARIABLE_NAME];
end;

-- 初期設定値
Kitty.SettingManager.defaultSetting = {};
Kitty.SettingManager.defaultSetting.window = {
	-- Frameの座標
	["framePositionX"] = 100,
	["framePositionY"] = 100,
	-- Minimapボタンの表示有無
	["showMinimap"] = true,
};
Kitty.SettingManager.defaultSetting.basic = {
	["skipTarget"] = true,
	["useAutoshot"] = true,
	-- 被ダメ表示有無(閾値)
	["showDamageTakenThreshold"] = 0,	-- 0で非表示
	-- 与ダメ表示有無
	["showDamageDoneThreshold"] = 0,	-- 0で非表示
	-- DPS表示有無("None", "Normal", "Detail")
	["showDPSType"] = "None",
	-- Petのターゲットスキップ(CGのみ)
	["skipPetTarget"] = true,
	-- PT自動招待
	["autoInviteParty"] = false,
	["keyword1"] = Kitty.T("keyword", "InviteParty1"),
	["keyword2"] = Kitty.T("keyword", "InviteParty2"),
	["keyword3"] = Kitty.T("keyword", "InviteParty3"),
	-- PT受領
	["autoAcceptParty"] = false,
	-- PTリーダー譲与
	["givePartyLeader"] = true,
	-- 自動アシスト付与
	["autoAssistant"] = true,
	-- ID難易度設定("None", "Easy", "Normal", "Hard")
	["instanceLevel"] = Kitty.T("message", "None"),
	-- 白サイコロ設定有無
	["lootThreshold"] = false,
	-- ID難易度表示
	["showInstanceLevel"] = false,
};
Kitty.SettingManager.defaultSetting.gradation = {
	["startR"] = 0,
	["startG"] = 255,
	["startB"] = 255,
	["endR"] = 255,
	["endG"] = 255,
	["endB"] = 255,
	["messageType"] = "DEFAULT",
};
Kitty.SettingManager.defaultSetting.command = Kitty.ComboManager.commandList;
