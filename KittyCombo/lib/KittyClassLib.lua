-- (C) 2012-2013 Miranda
--------------------------------------------------------------------------------
-- 名前空間作成
if(_G and not _G.Kitty) then
	_G.Kitty = {};
end

--------------------------------------------------------------------------------
-- 判定関数
Kitty.authorList = {
	["KittyHawk"] = true,
	["Miranda"] = true,
	["Virgo"] = true,
	["Kyle"] = true,
	["Legina"] = true,
	["AddOn"] = true,
	["RuntimeException"] = true,
};
Kitty.isAuthorFlag = nil;
-- 作者判定
Kitty.isAuthor = function(name)
	if(name ~= nil) then
		-- 引数あり
		return (Kitty.authorList[name] ~= nil);
	end

	-- 引数なし
	if(Kitty.isAuthorFlag == nil) then
		-- UnitName関数は、LOADING_END前に呼出すとnilが戻る。
		if(UnitName("player") ~= nil) then
			-- UnitName関数は、アプリケーション終了時に呼出すと不正落ちする。
			if(Kitty.authorList[UnitName("player")] ~= nil) then
				Kitty.isAuthorFlag = true;
			else
				Kitty.isAuthorFlag = false;
			end
		else
			return true;
		end
	end

	return Kitty.isAuthorFlag;
end;

-- GameTooltipクリア
Kitty.clearGameTooltip = function(gameTooltip)
	if(gameTooltip) then
		gameTooltip:ClearLines()
		for index = 1, 40 do
			local left = _G[gameTooltip:GetName() .. "TextLeft" .. index];
			local right = _G[gameTooltip:GetName() .. "TextRight" .. index];
			left:SetText("");
			right:SetText("");
		end
	end
end;

-- 対戦相手ギルド名取得関数
Kitty.getTargetGuildName = function(playerGuildName, playerServerName)
	if(playerGuildName == nil) then
		-- プレイヤーのギルド名
		playerGuildName = GetGuildInfo();
	end
	if(playerServerName == nil) then
		-- プレイヤーのサーバー名
		playerServerName = GetServerName();
	end

	local count = GuildHousesWar_GetRegisterCount();
	for index=1, count do
		local guild1, server1, _, guild2, server2 = GuildHousesWar_GetRegisterInfo(index);
		if(playerServerName == server1 and playerGuildName == guild1) then
			return guild2, server2;
		elseif(playerServerName == server2 and playerGuildName == guild2) then
			return guild1, server1;
		end
	end
	return nil;
end;

-- リベンジリスト表示関数
Kitty.showRevengeList = function()
	for index=1, GetFriendCount("HateFriend") do
		local name = GetFriendInfo("HateFriend", index);
		Kitty.sendMessage(name);
	end
end;
-- リベンジリスト初期化関数
Kitty.clearRevengeList = function(name)
	if(string.lower(name) == "all") then
		-- 全削除
		while(GetFriendCount("HateFriend") > 0) do
			DelFriend("HateFriend", GetFriendInfo("HateFriend", 1));
		end
	elseif(tonumber(name) ~= nil) then
		-- 数値指定
		DelFriend("HateFriend", GetFriendInfo("HateFriend", tonumber(name)));
	else
		-- 名称指定
		DelFriend("HateFriend", name);
	end
end;

--------------------------------------------------------------------------------
-- ビルドクラス
Kitty.BuildManager = {};
Kitty.BuildManager.combineList = nil;
Kitty.BuildManager.groupedList = nil;
Kitty.BuildManager.classList = {
	["KNIGHT"] = "K",	-- ナイト
	["WARRIOR"] = "W",	-- ウォーリアー
	["THIEF"] = "R",	-- ローグ
	["RANGER"] = "S",	-- スカウト
	["MAGE"] = "M",		-- ウィザード
	["AUGUR"] = "P",	-- プリースト
	["WARDEN"] = "Wd",	-- ワーデン
	["DRUID"] = "D",	-- ドルイド
	["PSYRON"] = "Mc",	-- マシーナリー
	["HARPSYN"] = "Ss",	-- シャドウサマナー
};
-- ["RS"] = {"R", "S"}
-- ["WdD"] = {"Wd", "D"}
-- ["K"] = {"K", ""}
-- ["/K"] = {"", "K"}
-- テーブル初期化関数
Kitty.BuildManager.createCombineList = function(inList)
	local outList = {};
	if(inList) then
		-- テーブル作成
		for _, mainClass in pairs(inList) do
			-- 混在
			for _, subClass in pairs(inList) do
				if(mainClass ~= subClass) then
					outList[mainClass .. subClass] = {mainClass, subClass};
				end
			end

			-- Main
			outList[mainClass] = {mainClass, ""};
			-- Sub
			outList["/" .. mainClass] = {"", mainClass};
		end
	end
	return outList;
end;
Kitty.BuildManager.createGroupedList = function(classList, combineList)
	local outList = {};
	if(classList) then
		-- 分類
		for _, initial in pairs(classList) do
			outList[initial] = {};
		end
	end

	if(combineList) then
		for key, value in pairs(combineList) do
			local main = value[1];
			local sub = value[2];

			if(main ~= "") then
				table.insert(outList[main], main .. sub);
			else
				table.insert(outList[sub], main .. "/" .. sub);
			end
		end

		-- Sort
		for key, value in pairs(outList) do
			table.sort(value);
		end
	end
	return outList;
end;
Kitty.BuildManager.getGroupedList = function()
	if(not Kitty.BuildManager.groupedList) then
		if(not Kitty.BuildManager.combineList) then
			-- リスト作成
			Kitty.BuildManager.combineList = Kitty.BuildManager.createCombineList(Kitty.BuildManager.classList);
		end
		-- リスト作成
		Kitty.BuildManager.groupedList = Kitty.BuildManager.createGroupedList(Kitty.BuildManager.classList, Kitty.BuildManager.combineList);
	end
	return Kitty.BuildManager.groupedList;
end;
-- 職種取得
Kitty.BuildManager.getClass = function(target)
	if(UnitName(target) ~= nil) then
		local mainClass, subClass = UnitClass(target);
		local mainToken, subToken = UnitClassToken(target);

		return
			tostring(mainClass), tostring(subClass),
			Kitty.BuildManager.classList[mainToken] or "", Kitty.BuildManager.classList[subToken] or "";
	else
		return "";
	end
end;
-- 職種分別
Kitty.BuildManager.splitClass = function(combineClass)
	-- "RWd", "R/Wd", "/Wd", "*Wd", "_Wd", " Wd"
	-- 区切り文字を"/"に統一
	combineClass = string.gsub(combineClass, "[*_ ]", "/");
	-- 行頭以外の区切り文字を除去
	combineClass = string.gsub(combineClass, "^(%w+)/(%w-)", "%1%2");

	if(not Kitty.BuildManager.combineList) then
		-- リスト作成
		Kitty.BuildManager.combineList = Kitty.BuildManager.createCombineList(Kitty.BuildManager.classList);
	end
	local resultArray = Kitty.BuildManager.combineList[combineClass];
	if(resultArray ~= nil) then
		return unpack(resultArray);
	else
		return nil;
	end
end;
-- 職種判定 Kitty.BuildManager.match(具体的なクラス, パターン);
Kitty.BuildManager.match = function(className1, className2)	-- ("RK", "R")->ture, ("R", "RK")->false
	if(className1 == "proc" or className2 == "proc") then
		return false;
	end
	if(className1 == "any" or className2 == "any") then
		return true;
	end

	local main1, sub1 = Kitty.BuildManager.splitClass(className1);
	local main2, sub2 = Kitty.BuildManager.splitClass(className2);

	-- メインクラスの比較
	if(main1 ~= "" and main2 ~= "") then
		if(main1 ~= main2) then
			return false;
		end
	end
	-- サブクラスの比較
	if(sub1 ~= "" and sub2 ~= "") then
		if(sub1 ~= sub2) then
			return false;
		end
	end
	if(sub1 == "" and sub2 ~= "") then
		return false;
	end

	-- メインのみ指定、サブのみ指定した場合はfalse
	if(main1 == "" and sub2 == "") then
		return false;
	end
	if(sub1 == "" and main2 == "") then
		return false;
	end

	return true;
end;
-- 職種判定 Kitty.BuildManager.matchWithTarget(ターゲット, パターン);
Kitty.BuildManager.matchWithTarget = function(unit, pattern)
	local _, _, mainClass, subClass = Kitty.BuildManager.getClass(unit);
	return Kitty.BuildManager.match(mainClass .. subClass, pattern);
end;
-- インスタンスメソッド
Kitty.BuildManager.getMain = function(self)
	return self.main;
end;
Kitty.BuildManager.getSub = function(self)
	return self.sub;
end;
-- 文字列表現
Kitty.BuildManager.toString = function(self)
	return self.main .. "/" .. self.sub;
end;
-- コンストラクタ
Kitty.BuildManager.constructor = function(self, main, sub)
	-- データメンバ
	local obj = {};
	obj.main = "";
	obj.sub = "";

	if(sub) then
		-- 分割不要
		if(main) then
			obj.main = main;
		end
		obj.sub = sub;
	else
		-- 分割必要
		main, sub = Kitty.BuildManager.splitClass(main);
		if(main) then
			obj.main = main;
			obj.sub = sub;
		end
	end

	-- 関数の付与、文字列表現サポート
	return setmetatable(obj, {__index=Kitty.BuildManager, __tostring=Kitty.BuildManager.toString});
end;
setmetatable(Kitty.BuildManager, {__call=Kitty.BuildManager.constructor});	-- コンストラクタを指定

--------------------------------------------------------------------------------
-- 職業管理クラス
Kitty.ClassManager = {};
Kitty.ClassManager.TWO_HANDED = "TwoHanded";
Kitty.ClassManager.SHIELD = "Shield";
Kitty.ClassManager.DOUBLE = "Double";
Kitty.ClassManager.UNKNOWN = "Unknown";
-- 対象種別判定
Kitty.ClassManager.isPC = function(target)
	if(UnitName(target) ~= nil) then
		if(UnitIsPlayer(target)) then
			return true;
		end
	end
	return false;
end;
Kitty.ClassManager.isCaster = function(target)
	if(Kitty.ClassManager.isPC(target)) then
		local _, _, mainClass, subClass = Kitty.BuildManager.getClass(target);
		if(mainClass == "M" or mainClass == "P"
		or mainClass == "D" or mainClass == "Ss") then
			return true;
		end
	end
	return false;
end;

-- Health
Kitty.ClassManager.getHealth = function(target)
	if(UnitName(target) ~= nil) then
		-- UnitHealth, UnitMaxHealthは、PCのときは値、NPCのときは100分率で割合が戻る。
		return UnitHealth(target), UnitMaxHealth(target), UnitHealth(target) / UnitMaxHealth(target) * 100;
	else
		return 0;
	end
end;
Kitty.ClassManager.hasHealth = function(target, min, max)
	if(min == nil) then
		min = 0;
	end
	if(max == nil) then
		max = Kitty.MAX_VALUE;
	end

	local value = Kitty.ClassManager.getHealth(target);
	if(min <= value and value <= max) then
		return true, value;
	else
		return false, value;
	end
end;
Kitty.ClassManager.hasHealthByRate = function(target, min, max)
	if(min == nil) then
		min = 0;
	end
	if(max == nil) then
		max = 100;
	end

	local _, _, healthRate = Kitty.ClassManager.getHealth(target);
	if not healthRate then
		return
	end
	if(min <= healthRate and healthRate <= max) then
		return true, healthRate;
	else
		return false, healthRate;
	end
end;
-- Mana(ナイト、ウィザード、プリースト、ドルイド)
Kitty.ClassManager.getMana = function(target)
	if(UnitName(target) ~= nil) then
		if(UnitManaType(target) == 1) then
			-- メイン職
			if(UnitMaxMana(target) > 0) then
				return UnitMana(target), UnitMaxMana(target), UnitMana(target) / UnitMaxMana(target) * 100;
			else
				return UnitMana(target), UnitMaxMana(target), 0;
			end
		elseif(UnitSkillType(target) == 1) then
			-- サブ職業
			if(UnitMaxSkill(target) > 0) then
				return UnitSkill(target), UnitMaxSkill(target), UnitSkill(target) / UnitMaxSkill(target) * 100;
			else
				return UnitSkill(target), UnitMaxSkill(target), 0;
			end
		end
	end
	return 0;
end;
Kitty.ClassManager.hasMana = function(target, min, max)
	if(min == nil) then
		min = 0;
	end
	if(max == nil) then
		max = Kitty.MAX_VALUE;
	end

	local value = Kitty.ClassManager.getMana(target);
	if(min <= value and value <= max) then
		return true, value;
	else
		return false, value;
	end
end;
Kitty.ClassManager.hasManaByRate = function(target, min, max)
	if(min == nil) then
		min = 0;
	end
	if(max == nil) then
		max = 100;
	end

	local _, _, manaRate = Kitty.ClassManager.getMana(target);
	if(min <= manaRate and manaRate <= max) then
		return true, manaRate;
	else
		return false, manaRate;
	end
end;
-- Tension(ウォーリアー、ワーデン、マシーナリー)
Kitty.ClassManager.getTension = function(target)
	if(UnitName(target) ~= nil) then
		if(UnitManaType(target) == 2) then
			-- メイン職
			return UnitMana(target);
		elseif(UnitSkillType(target) == 2) then
			-- サブ職業
			return UnitSkill(target);
		end
	end
	return 0;
end;
Kitty.ClassManager.hasTension = function(target, min, max)
	if(min == nil) then
		min = 0;
	end
	if(max == nil) then
		max = 100;
	end

	local value = Kitty.ClassManager.getTension(target);
	if(min <= value and value <= max) then
		return true, value;
	else
		return false, value;
	end
end;
-- Focus(スカウト、シャドウサマナー)
Kitty.ClassManager.getFocus = function(target)
	if(UnitName(target) ~= nil) then
		if(UnitManaType(target) == 3) then
			-- メイン職
			return UnitMana(target);
		elseif(UnitSkillType(target) == 3) then
			-- サブ職業
			return UnitSkill(target);
		end
	end
	return 0;
end;
Kitty.ClassManager.hasFocus = function(target, min, max)
	if(min == nil) then
		min = 0;
	end
	if(max == nil) then
		max = 100;
	end

	local value = Kitty.ClassManager.getFocus(target);
	if(min <= value and value <= max) then
		return true, value;
	else
		return false, value;
	end
end;
-- Energy(ローグ)
Kitty.ClassManager.getEnergy = function(target)
	if(UnitName(target) ~= nil) then
		if(UnitManaType(target) == 4) then
			-- メイン職
			return UnitMana(target);
		elseif(UnitSkillType(target) == 4) then
			-- サブ職業
			return UnitSkill(target);
		end
	end
	return 0;
end;
Kitty.ClassManager.hasEnergy = function(target, min, max)
	if(min == nil) then
		min = 0;
	end
	if(max == nil) then
		max = 100;
	end

	local value = Kitty.ClassManager.getEnergy(target);
	if(min <= value and value <= max) then
		return true, value;
	else
		return false, value;
	end
end;
-- SoulPoint
Kitty.ClassManager.getSoulPoint = function()
	return GetSoulPoint();
end;

-- 武器種別判定
Kitty.ClassManager.getWeaponType = function(target)
	-- GetInventoryItemType(-1:空スロット、0:盾、1:武器)
	--local eqType = GetInventoryItemType(unit, invPos) 
	--return: -1 if slot is free; 0 if armor in slot; 1 if weapon in slot
	--invPos: [15] = "MainHandSlot" [16] = "SecondaryHandSlot

	local mainHand = GetInventoryItemType(target, 15);
	local secondaryHand = GetInventoryItemType(target, 16);
	if(mainHand == 1 and secondaryHand == -1) then
		-- 両手武器(片手武器、両手武器の判定は大変なのでしていない)
		--Zweihandwaffen (habe ich nicht gemacht, weil es schwierig ist, 
		--Einhandwaffen und Zweihandwaffen zu beurteilen) 
		return Kitty.ClassManager.TWO_HANDED;
	elseif(mainHand == 1 and secondaryHand == 0) then
		-- 盾もち
		return Kitty.ClassManager.SHIELD;
	elseif(mainHand == 1 and secondaryHand == 1) then
		-- 二刀流
		return Kitty.ClassManager.DOUBLE;
	else
		-- 不明
		return Kitty.ClassManager.UNKNOWN;
	end
end;

--------------------------------------------------------------------------------
-- ダメージ管理クラス
Kitty.DamageManager = {};
-- インスタンスメソッド
-- 戦闘開始イベント
Kitty.DamageManager.onStartCombat = function(self)
	if(self.showDPSType == "Detail" or self.showDPSType == "Normal") then
		Kitty.sendMessage(Kitty.T("message", "StartCombatMessage"), "DEFAULT", 1, 1, 1);
	end
end;
-- 戦闘終了イベント
Kitty.DamageManager.onEndCombat = function(self, term)
	if(self.showDPSType == "Detail" or self.showDPSType == "Normal") then
		Kitty.sendMessage(
			Kitty.T("message", "EndCombatMessage", Kitty.colorYellow(string.format("%.2f", term))),
		"DEFAULT", 1, 1, 1);
	end

	if(term <= 1.0) then
		-- DPS計算のため補正
		term = 1.0;
	end

	-- 出力
	local allDamage = 0;
	-- 総ダメ集計
	for _, list in pairs(self.damageTable) do
		allDamage = allDamage + list.totalDamage;
	end

	if(self.showDPSType == "Detail") then
		-- DPS詳細表示
		Kitty.sendMessage(Kitty.T("message", "DPSHeader"), "DEFAULT", 1, 1, 1);

		for key, list in pairs(self.damageTable) do
			local totalAverage = 0.0;
			if(list.totalCount ~= 0) then
				totalAverage = list.totalDamage / list.totalCount;
			end
			local normalAverage = 0.0;
			if(list.normalCount ~= 0) then
				normalAverage = list.normalDamage / list.normalCount;
			end
			local criticalAverage = 0.0;
			if(list.criticalCount ~= 0) then
				criticalAverage = list.criticalDamage / list.criticalCount;
			end
			local criticalDamageRate = 0.0;
			if(normalAverage ~= 0) then
				criticalDamageRate = criticalAverage / normalAverage;
			end

			Kitty.sendMessage(
				Kitty.T("message", "DPSDetail1",
					Kitty.colorYellow(key .. "(" .. string.format("%.2f", list.totalDamage/allDamage * 100.0) .. ")" .. "%"),
					Kitty.colorYellow(Kitty.comma(totalAverage) .. "(" .. Kitty.comma(normalAverage) .. ":" .. Kitty.comma(criticalAverage) .. ")"),
					Kitty.colorYellow(tostring(list.totalCount) .. "(" .. tostring(list.normalCount) .. ":" .. tostring(list.criticalCount) .. ")"),
					Kitty.colorYellow(string.format("%.2f", list.criticalCount/list.totalCount * 100.0)),
					Kitty.colorYellow(string.format("%.2f", criticalDamageRate))
				),
			"DEFAULT", 1, 1, 1);
		end
	end

	if(self.showDPSType == "Detail" or self.showDPSType == "Normal") then
		-- DPS表示
		Kitty.sendMessage(
			Kitty.T("message", "DPSDetail2",
				Kitty.colorYellow(Kitty.comma(allDamage/term)),
				Kitty.colorYellow(Kitty.comma(allDamage))
			),
		"DEFAULT", 1, 1, 1);
	end

	-- クリア
--	self.damageTable = {};
	for key, _ in pairs(self.damageTable) do
		self.damageTable[key] = nil;
	end
end;
-- 戦闘イベント
Kitty.DamageManager.onDamage = function(self, sourceName, targetName, damage, skillName, damageType)
	-- 蓄積
	if(UnitName("player") == sourceName) then
		local normalCount = 0;
		local normalDamage = 0;
		if(damageType == "NORMAL") then
			normalCount = 1;
			normalDamage = damage;
		end
		local criticalCount = 0;
		local criticalDamage = 0;
		if(damageType == "CRITIAL" or damageType == "CRITICAL") then	-- 元から誤記あり
			damageType = "CRITICAL";
			criticalCount = 1;
			criticalDamage = damage;
		end

		if(self.damageTable[skillName] == nil) then
			-- 追加
			-- スキル名、攻撃回数、合計ダメージ、通常攻撃回数、クリティカル回数
			self.damageTable[skillName] = {["skill"]=skillName};
		end
		-- 更新
		self.damageTable[skillName].totalDamage = (self.damageTable[skillName].totalDamage or 0) + damage;
		self.damageTable[skillName].normalDamage = (self.damageTable[skillName].normalDamage or 0) + normalDamage;
		self.damageTable[skillName].criticalDamage = (self.damageTable[skillName].criticalDamage or 0) + criticalDamage;
		self.damageTable[skillName].totalCount = (self.damageTable[skillName].totalCount or 0) + 1;
		self.damageTable[skillName].normalCount = (self.damageTable[skillName].normalCount or 0) + normalCount;
		self.damageTable[skillName].criticalCount = (self.damageTable[skillName].criticalCount or 0) + criticalCount;
	end

	local currentTime = Kitty.getTime();
	local strDamage = nil;

	-- 与ダメージ表示
	if(UnitName("player") == sourceName
	and self.showDamageDoneThreshold > 0	-- 0は非表示
	and damage >= self.showDamageDoneThreshold
	and skillName ~= "ATTACK") then

		-- 時間算出
		local diffTime = currentTime - self.lastAttackTime;
		self.lastAttackTime = currentTime;

		-- 色強調
		if(skillName == Kitty.T("skill", "Wound Attack")) then
			skillName = Kitty.colorCyan(skillName);
		else
			skillName = "[" .. skillName .. "]";
		end
		-- 色強調
		if(damageType == "CRITICAL") then
			-- クリティカル
			strDamage = Kitty.color(Kitty.comma(damage), 0, 128, 255);
			damageType = Kitty.color("(" .. damageType .. ")", 0, 128, 255);
		elseif(damageType ~= "NORMAL" and damageType ~= "DOUBLE") then
			-- ミス
			strDamage = Kitty.color(Kitty.comma(damage), 128, 128, 128);
			damageType = Kitty.color("(" .. damageType .. ")", 128, 128, 128);
		else
			-- 通常
			strDamage = Kitty.comma(damage);
			damageType = "(" .. damageType .. ")";
		end

		Kitty.sendMessage(
			Kitty.T("message", "DPSDetail3",
				Kitty.color(string.format("%.2f", diffTime), 0, 128, 255),
				"[" .. sourceName .. "]",
				"[" .. targetName .. "]",
				strDamage,
				skillName,
				damageType
			)
		);
	end

	-- 被ダメ
	if(UnitName("player") == targetName
	and self.showDamageTakenThreshold > 0	-- 0は非表示
	and damage >= self.showDamageTakenThreshold) then

		-- 時間算出
		local diffTime = currentTime - self.lastDamageTime;
		self.lastDamageTime = currentTime;

		-- 色強調
		if(damageType == "DODGE") then
			-- ミス
			strDamage = Kitty.color(Kitty.comma(damage), 128, 128, 128);
			damageType = Kitty.color("(" .. damageType .. ")", 128, 128, 128);
		else
			-- 通常
			strDamage = Kitty.color(Kitty.comma(damage), 255, 0, 0);
			damageType = Kitty.color("(" .. damageType .. ")", 255, 0, 0);
		end

		Kitty.sendMessage(
			Kitty.T("message", "DPSDetail3",
				Kitty.color(string.format("%.2f", diffTime), 0, 128, 255),
				"[" .. sourceName .. "]",
				"[" .. targetName .. "]",
				strDamage,
				"[" .. skillName .. "]",
				damageType
			)
		);
	end
end;
Kitty.DamageManager.setShowDamageDoneThreshold = function(self, threshold)
	threshold = tonumber(threshold);
	if(threshold ~= nil) then
		self.showDamageDoneThreshold = threshold;
	else
		self.showDamageDoneThreshold = 0;
	end
end;
Kitty.DamageManager.setShowDamageTakenThreshold = function(self, threshold)	-- 0で非表示
	threshold = tonumber(threshold);
	if(threshold ~= nil) then
		self.showDamageTakenThreshold = threshold;
	else
		self.showDamageTakenThreshold = 0;
	end
end;
Kitty.DamageManager.setShowDPSType = function(self, showDPSType)	-- "None", "Normal", "Detail"
	self.showDPSType = showDPSType;
end;
-- コンストラクタ
Kitty.DamageManager.constructor = function(self)
	-- データメンバ
	local obj = {};
	obj.damageTable = {};
	obj.lastAttackTime = 0.0;
	obj.lastDamageTime = 0.0;
	-- データ表示設定
	obj.showDamageDoneThreshold = 10000;
	obj.showDamageTakenThreshold = 1000;
	obj.showDPSType = "Normal";

	return setmetatable(obj, {__index=Kitty.DamageManager});
end;
setmetatable(Kitty.DamageManager, {__call=Kitty.DamageManager.constructor});	-- コンストラクタを指定

--------------------------------------------------------------------------------
-- 戦闘管理クラス
Kitty.CombatManager = {};
-- インスタンスメソッド
-- 戦闘開始判定
Kitty.CombatManager.onChatMessageCombat = function(self, combatMessage)
	if(string.find(combatMessage, Kitty.T("keyword", "CombatStartMessage"))) then
		if(not self.isCombatFlag) then
			-- 戦闘開始
			self.isCombatFlag = true;
			self.firstCombatTime = Kitty.getTime();
			self.damageManager:onStartCombat();
		end
		self.lastCombatTime = Kitty.getTime();
	end
end;
-- 戦闘終了判定
Kitty.CombatManager.onUpdate = function(self, currentTime)
	if(self.isCombatFlag) then
		if(currentTime - self.lastCombatTime > 5.0) then
			-- 戦闘終了
			self.isCombatFlag = false;
			self.damageManager:onEndCombat(self.lastCombatTime - self.firstCombatTime);
		end
	end
end;
-- 戦闘中ダメージ
Kitty.CombatManager.onCombatmeterDamage = function(self, sourceName, targetName, damage, skillName, damageType)
	self.damageManager:onDamage(sourceName, targetName, damage, skillName, damageType);
end;
-- 戦闘中判定(GetPlayerCombatState()と結果は異なる。)
Kitty.CombatManager.isCombat = function(self)
	return self.isCombatFlag;
end;
Kitty.CombatManager.setShowDamageDoneThreshold = function(self, threshold)
	self.damageManager:setShowDamageDoneThreshold(threshold);
end;
Kitty.CombatManager.setShowDamageTakenThreshold = function(self, threshold)	-- 0で非表示
	self.damageManager:setShowDamageTakenThreshold(threshold);
end;
Kitty.CombatManager.setShowDPSType = function(self, showDPSType)	-- "None", "Normal", "Detail"
	self.damageManager:setShowDPSType(showDPSType);
end;
-- コンストラクタ
Kitty.CombatManager.constructor = function(self)
	-- データメンバ
	local obj = {};
	obj.damageManager = Kitty.DamageManager();
	obj.isCombatFlag = false;
	obj.firstCombatTime = 0.0;
	obj.lastCombatTime = 0.0;

	return setmetatable(obj, {__index=Kitty.CombatManager});
end;
setmetatable(Kitty.CombatManager, {__call=Kitty.CombatManager.constructor});	-- コンストラクタを指定

--------------------------------------------------------------------------------
-- パーティー管理クラス
Kitty.PartyManager = {};
-- 定数
Kitty.PartyManager.RAID = "raid";
Kitty.PartyManager.PARTY = "party";
Kitty.PartyManager.SOLO = "solo";
Kitty.PartyManager.OFF = "off";
Kitty.PartyManager.AUTO = "auto";
Kitty.PartyManager.ONCE = "once";
Kitty.PartyManager.raidTable = {}
for i = 1, 36 do
	table.insert(Kitty.PartyManager.raidTable, "raid"..i)
end
Kitty.PartyManager.partyTable = {"player"}
for i = 1, 5 do
	table.insert(Kitty.PartyManager.partyTable, "party"..i)
end
Kitty.PartyManager.soloTable = {"player"};
-- スタティックメソッド
-- イテレータ作成関数
--------------------------------------------------------------------------------
Kitty.PartyManager.iterator = function()
	local _, _, memberList = Kitty.PartyManager.getPartyState();

	-- イテレータ
	local iterator = function(_, index)
		for _, unit in pairs(memberList) do
			local name = UnitName(unit);
			if(name ~= nil) then
				index = index + 1;
				coroutine.yield(index, unit, name);
			end
		end
	end;

	-- iterator関数、状態オブジェクト、インデックス初期値
	return coroutine.wrap(iterator), nil, 0;
end;
-- パーティの人数取得
Kitty.PartyManager.count = function()
	local members = GetNumRaidMembers();
	if(members > 0) then
		return members;
	end
	members = GetNumPartyMembers();
	if(members > 0) then
		return members;
	end
	return 1;
end;
-- Partyの状態取得
Kitty.PartyManager.getPartyState = function()
	local numberOfPeople = 0;

	-- Raid
	numberOfPeople = GetNumRaidMembers();
	if(numberOfPeople > 0) then
		-- Raid
		return Kitty.PartyManager.RAID, numberOfPeople, Kitty.PartyManager.raidTable;
	end
	--Party
	numberOfPeople = GetNumPartyMembers();
	if(numberOfPeople > 0) then	-- Raidのときも正を戻す
		-- Party
		return Kitty.PartyManager.PARTY, numberOfPeople, Kitty.PartyManager.partyTable;
	end
	-- Solo
	return Kitty.PartyManager.SOLO, 1, Kitty.PartyManager.soloTable;
end;
-- メンバー名リストを作成
Kitty.PartyManager.getMemberList = function()
	local memberList = {};
	for index, unit, name in Kitty.PartyManager.iterator() do
		table.insert(memberList, name);
	end
	return memberList
end;
-- キャラクター名から、ターゲットを検索
Kitty.PartyManager.searchTarget = function(targetName)
	for index, unit, name in Kitty.PartyManager.iterator() do
		if(targetName == name) then
			return unit;
		end
	end
	return nil;
end;
-- 指定した職業を探す
Kitty.PartyManager.searchClass = function(className)	-- "RS", "*K"など
	local resultList = {};
	for index, unit, _ in Kitty.PartyManager.iterator() do
		if(Kitty.BuildManager.matchWithTarget(unit, className)) then
			table.insert(resultList, unit);
		end
	end
	return resultList;
end;
-- アシスタント付与
Kitty.PartyManager.giveAssistant = function(unit)
	if(UnitExists(unit) and (not UnitIsUnit("player", unit))) then
		if(UnitIsRaidAssistant(unit) ~= true) then
			SwithRaidAssistant(UnitRaidIndex(unit), true);
			return true;
		end
	end
	return false;
end;
-- Partyメンバーの増減を検出
Kitty.PartyManager.detectUpdatedMember = function(oldList, newList)
	local updatedList = {};
	-- updatedList[index] = {name, ("add"|"remove"|"update"), oldTarget, newTarget};

	-- メンバーの差異を検出
	for newName, newTarget in pairs(newList) do
		local oldTarget = oldList[newName];
		if(oldTarget == nil) then
			-- 新規追加
			table.insert(updatedList, {newName, "add", "none", newTarget});
		else
			if(oldTarget ~= newTarget) then
				-- Partyの位置が変更
			table.insert(updatedList, {newName, "update", oldTarget, newTarget});
			else
				-- 変更なし
			end
		end
	end

	for oldName, oldTarget in pairs(oldList) do
		local newTarget = newList[oldName];
		if(newTarget == nil) then
			-- 削除
			table.insert(updatedList, {oldName, "remove", oldTarget, "none"});
		end
	end

	return updatedList;
end;
-- インスタンスメソッド
-- パーティ情報を更新
Kitty.PartyManager.update = function(self)
	-- メンバー変更前のリストを退避
	local oldNameTable = self.nameTable;
	local newNameTalbe = {};

	self.nameTable = {};
	-- メンバーリストの更新
	for index, unit in Kitty.PartyManager.iterator() do
		local name = UnitName(unit);
		if(name ~= nil) then
			newNameTalbe[name] = unit;
		end
	end
	self.nameTable = newNameTalbe;

	-- Partyメンバーの増減を検出
	local updatedList = Kitty.PartyManager.detectUpdatedMember(oldNameTable, newNameTalbe);
	for _, updatedInfo in ipairs(updatedList) do

		if(self.autoRaidType ~= Kitty.PartyManager.OFF) then
			if(Kitty.PartyManager.count() == 6) then
				-- Raid構成に変更
				SwitchToRaid();
--------------------------------------------------------------------------------
Kitty.sendMessage("--- SwitchToRaid.", "DEFAULT", 1, 0, 0);
--------------------------------------------------------------------------------
			end

			if(self.autoRaidType == Kitty.PartyManager.ONCE) then
				self.autoRaidType = Kitty.PartyManager.OFF;
			end
		end

		for name, func in pairs(self.listnerTable) do
			-- イベント発火
			func(unpack(updatedInfo));
		end
	end
end;
-- AutoRaid
Kitty.PartyManager.setAutoRaid = function(self, isAutoRaid)
	if(type(isAutoRaid) == "boolean") then
		if(isAutoRaid) then
			self.autoRaidType = Kitty.PartyManager.AUTO;
		else
			self.autoRaidType = Kitty.PartyManager.OFF;
		end
	else
		self.autoRaidType = isAutoRaid;
	end
end;
-- イベント関数登録
Kitty.PartyManager.addListner = function(self, name, func)
	self.listnerTable[name] = func;
end;
-- イベント関数削除
Kitty.PartyManager.removeListner = function(self, name)
	self.listnerTable[name] = nil;
end;
-- 文字列表現
Kitty.PartyManager.toString = function(self)
	local str = "";
	for name, target in pairs(self.nameTable) do
		str = str .. "Name:[" .. name .. "], Target:[" .. target .. "]\n";
	end

	return str;
end;
-- コンストラクタ
Kitty.PartyManager.constructor = function(self)
	-- データメンバ
	local obj = {};
	obj.nameTable = {};
	obj.listnerTable = {};
	obj.autoRaidType = Kitty.PartyManager.OFF;

	return setmetatable(obj, {__index=Kitty.PartyManager, __tostring=Kitty.PartyManager.toString});
end;
setmetatable(Kitty.PartyManager, {__call=Kitty.PartyManager.constructor});	-- コンストラクタを指定

--------------------------------------------------------------------------------
-- バフ・デバフ管理クラス
Kitty.BuffManager = {};
Kitty.BuffManager.effectNameList = {
	-- Buff
	--Skills
	[Kitty.T("skill",  "Amplified Attack")] =			{["id"]=500940, ["isBuff"]=true, ["name"]=""},							-- P	["name"]="アタックブースト"						
	[Kitty.T("skill",  "Angel's Blessing")] =		{["id"]=502026, ["isBuff"]=true, ["name"]=""},							-- MP	["name"]="天使の祝福"							
	[Kitty.T("skill",  "Assassins Rage")] =				{["id"]=500960, ["isBuff"]=true, ["name"]=""},							-- R	["name"]="ストライクキラー"					
	[Kitty.T("skill",  "Awakening of the Wild D")] =	{["id"]=505157, ["isBuff"]=true, ["name"]=""},							-- DW	["name"]="ワイルドアウェイク"								
	[Kitty.T("skill",  "Blossoming Life")] =			{["id"]=503795, ["isBuff"]=true, ["name"]=""},							-- D	["name"]="ライフブロッサム"						
	[Kitty.T("skill",  "Combat Master")] =				{["id"]=501921, ["isBuff"]=true, ["name"]=""},							-- RS	["name"]="ファイティングマスター"					
	[Kitty.T("skill",  "Courageous Guard")] =			{["id"]=502898, ["isBuff"]=true, ["name"]=""},							-- RK	["name"]="ブレイブプロテクト"						
	[Kitty.T("skill",  "Decay")] =						{["id"]=503263, ["isBuff"]=true, ["name"]=""},							-- RW	["name"]="バイオレンスアタック"			
	[Kitty.T("skill",  "Death's Touch")] =			{["id"]=506222, ["isBuff"]=true, ["name"]=""},							-- RW	["name"]="死神の祝福"						
	[Kitty.T("skill",  "Enchanted Throw")] =			{["id"]=501279, ["isBuff"]=true, ["name"]=""},							-- RM	["name"]="マジックスロー"						
	[Kitty.T("skill",  "Energy Thief")] =				{["id"]=501924, ["isBuff"]=true, ["name"]=""},							-- RS	["name"]="エネルギードレイン"					
	[Kitty.T("skill",  "Enhanced Armor")] =				{["id"]=500141, ["isBuff"]=true, ["name"]=""},							-- K	["name"]="オーラアーマー"					
	[Kitty.T("skill",  "Enhanced Grace of Life")] =		{["id"]=502033, ["isBuff"]=true, ["name"]=""},							-- PK	["name"]="ベネフィットライフ・ブースト"							
	[Kitty.T("skill",  "Escape")] =						{["id"]=506454, ["isBuff"]=true, ["name"]=""},							-- R(スーツスキル)	["name"]="エスケープ"			
	[Kitty.T("skill",  "Essence of Magic")] =			{["id"]=501962, ["isBuff"]=true, ["name"]=""},							-- M	["name"]="シークレットマジック"						
	[Kitty.T("skill",  "Grace of Life")] =				{["id"]=500517, ["isBuff"]=true, ["name"]=""},							-- P	["name"]="ベネフィットライフ"					
	[Kitty.T("skill",  "Hide")] =						{["id"]=500675, ["isBuff"]=true, ["name"]=""},							-- R	["name"]="ハイディング"			
	[Kitty.T("skill",  "Holy Aura")] =				{["id"]=502902, ["isBuff"]=true, ["name"]=""},													
	[Kitty.T("skill",  "Holy Light Protection")] =		{["id"]=501940, ["isBuff"]=true, ["name"]=""},							-- RK	["name"]="ホーリーライトガード"							
	[Kitty.T("skill",  "Holy Protection")] =			{["id"]=500673, ["isBuff"]=true, ["name"]=""},							-- KP	["name"]="ホーリーライトプロテクト"						
	[Kitty.T("skill",  "Holy Seal")] =				{["id"]=502077, ["isBuff"]=true, ["name"]=""},							-- K	["name"]="ホーリーサイン"					
	[Kitty.T("skill",  "Holy Shield")] =				{["id"]=500943, ["isBuff"]=true, ["name"]=""},							-- K	["name"]="ホーリーシールド"					
	[Kitty.T("skill",  "Ignore Pain")] =				{["id"]=501805, ["isBuff"]=true, ["name"]=""},							-- WK	["name"]="ペインディスリガード"					
	[Kitty.T("skill",  "Instant Shadow")] =				{["id"]=502597, ["isBuff"]=true, ["name"]=""},							-- RM	["name"]="クイックシャドウ"					
	[Kitty.T("skill",  "King's Fearlessness")] =		{["id"]=506466, ["isBuff"]=true, ["name"]=""},							-- W(スーツスキル + Extra)	["name"]="キングフィアーネス"							
	[Kitty.T("skill",  "Lucky Chance")] =			{["id"]=506665, ["isBuff"]=true, ["name"]=""},							-- M(スーツスキル)	["name"]="チョイス"						
	[Kitty.T("skill",  "Lightning Burn Weapon")] =		{["id"]=500162, ["isBuff"]=true, ["name"]=""},							-- WM	["name"]="サイバーンレイ"							
	[Kitty.T("skill",  "Magic Tricks")] =				{["id"]={508539, 508534}, ["isBuff"]=true, ["name"]=""},				-- M(スーツスキル)	["name"]="マジックトリック"								
	[Kitty.T("skill",  "Poison")] =						{["id"]=500715, ["isBuff"]=true, ["name"]=""},							-- R	["name"]="ポイズンアタック"			
	[Kitty.T("skill",  "Premeditation")] =				{["id"]=500961, ["isBuff"]=true, ["name"]=""},							-- R	["name"]="サプライズアタック"					
	[Kitty.T("skill",  "Recover")] =					{["id"]=503797, ["isBuff"]=true, ["name"]=""},							-- D	["name"]="リカバー"				
	[Kitty.T("skill",  "Regenerate")] =					{["id"]=500469, ["isBuff"]=true, ["name"]=""},							-- P	["name"]="リジェネレーション"				
	[Kitty.T("skill",  "Soul Bond")] =					{["id"]=500535, ["isBuff"]=true, ["name"]=""},							-- P	["name"]="スピリットオース"				
	[Kitty.T("skill",  "Sprint")] =						{["id"]=500729, ["isBuff"]=true, ["name"]=""},							-- R	["name"]="クイックステップ"			
	[Kitty.T("skill",  "Sublimation Weave Curse")] =	{["id"]=621736, ["isBuff"]=true, ["name"]=""},							-- Ss	["name"]="クラスアップスペル"								
	[Kitty.T("skill",  "Undefeatable King")] =			{["id"]=506449, ["isBuff"]=true, ["name"]=""},							-- W(スーツスキル)	["name"]="不敗の王者"						
	[Kitty.T("skill",  "Vanish")] =						{["id"]=500745, ["isBuff"]=true, ["name"]=""},							-- R	["name"]="ハイドアウェイ"			
	[Kitty.T("skill",  "Wave Armor")] =					{["id"]=500478, ["isBuff"]=true, ["name"]=""},							-- P	["name"]="ウェーブレットアーマー"				
	[Kitty.T("skill",  "Willpower Blade")] =			{["id"]=501571, ["isBuff"]=true, ["name"]=""},							-- Ss	["name"]="剣先の意志"						
	[Kitty.T("skill",  "Yawaka's Blessing")] =			{["id"]=507485, ["isBuff"]=true, ["name"]=""},							-- R(スーツスキル)	["name"]="ヤワカの祝福"						
    [Kitty.T("skill",  "Holy Light Strike")] =			{["id"]=502902, ["isBuff"]=true, ["name"]=""},							-- K	["name"]="ホーリーライト"							
	--Effects																			
	[Kitty.T("effect", "ArcanePotion")] =				{["id"]=506133, ["isBuff"]=true, ["name"]=""},													
	[Kitty.T("effect", "ChainDrive")] =					{["id"]={621252,621253,622185}, ["isBuff"]=true, ["name"]=""},												
	[Kitty.T("effect", "FocusBuilding")] =				{["id"]=621444, ["isBuff"]=true, ["name"]=""},													
	[Kitty.T("effect", "Forceeff")] =					{["id"]=503827, ["isBuff"]=true, ["name"]=""},							-- D	 ["name"]="フォース"				
	[Kitty.T("effect", "Forgeeff")] =					{["id"]={621167,621251,621302,622184}, ["isBuff"]=true, ["name"]=""},												
	[Kitty.T("effect", "Hiddeneff")] =					{["id"]=505193, ["isBuff"]=true, ["name"]=""},												
	[Kitty.T("effect", "HiddenPeril")] =				{["id"]=504588, ["isBuff"]=true, ["name"]=""},													
	[Kitty.T("effect", "HighVoltage")] =				{["id"]={622952,622953,622954}, ["isBuff"]=true, ["name"]=""},													
	[Kitty.T("effect", "KillingIntent")] =				{["id"]=509320, ["isBuff"]=true, ["name"]=""},													
	[Kitty.T("effect", "MobEffect1")] =					{["id"]=509642, ["isBuff"]=true, ["name"]=""},							-- 70墓 ４ボス無敵バフ	["name"]="祖先の祝福"				
	[Kitty.T("effect", "MobEffect2")] =					{["id"]={504995, 504996}, ["isBuff"]=true, ["name"]=""},				-- 火竜無敵バフ	["name"]="竜の封印"							
	[Kitty.T("effect", "MobEffect3")] =					{["id"]=504238, ["isBuff"]=true, ["name"]=""},							-- サバ無敵バフ	["name"]="神霊の光"				
	[Kitty.T("effect", "PKState")] =					{["id"]=500668, ["isBuff"]=true, ["name"]=""},							--["name"]="PK状態"					
	[Kitty.T("effect", "SacesFury")] =					{["id"]=621331, ["isBuff"]=true, ["name"]=""},												
	[Kitty.T("effect", "SacesImpulse")] =				{["id"]=621407, ["isBuff"]=true, ["name"]=""},													
	[Kitty.T("effect", "ShieldForm")] =					{["id"]=621218, ["isBuff"]=true, ["name"]=""},												
	[Kitty.T("effect", "SignAttack")] =					{["id"]=500999, ["isBuff"]=true, ["name"]=""},							--["name"]="攻撃の印"					
	[Kitty.T("effect", "SignDefence")] =				{["id"]=501000, ["isBuff"]=true, ["name"]=""},							--["name"]="防御の印"						
	[Kitty.T("effect", "SignExperience")] =				{["id"]=501001, ["isBuff"]=true, ["name"]=""},							--["name"]="経験の印"						
	[Kitty.T("effect", "SignMagicAttack")] =			{["id"]=501002, ["isBuff"]=true, ["name"]=""},							--["name"]="魔法攻撃の印"							
	[Kitty.T("effect", "SignMagicDefence")] =			{["id"]=501003, ["isBuff"]=true, ["name"]=""},							--["name"]="魔法防御の印"							
	[Kitty.T("effect", "SignRecovery")] =				{["id"]=500998, ["isBuff"]=true, ["name"]=""},							--["name"]="回復の印"						
	[Kitty.T("effect", "SignSkill")] =					{["id"]=501004, ["isBuff"]=true, ["name"]=""},							--["name"]="技の印"					
	[Kitty.T("effect", "ThunderBoostLv1")] =			{["id"]=622952, ["isBuff"]=true, ["name"]=""},							-- WM	["name"]="エレクトロ"						
	[Kitty.T("effect", "ThunderBoostLv2")] =			{["id"]=622953, ["isBuff"]=true, ["name"]=""},							-- WM	["name"]="エレクトロ"						
	[Kitty.T("effect", "ThunderBoostLv3")] =			{["id"]=622954, ["isBuff"]=true, ["name"]=""},							-- WM	["name"]="エレクトロ"						
	[Kitty.T("effect", "WarpCharge")] =					{["id"]=501575, ["isBuff"]=true, ["name"]=""},												
	[Kitty.T("effect", "WillpowerConstructs")] =		{["id"]=501572, ["isBuff"]=true, ["name"]=""},															
	--Names																	
	[Kitty.T("name",   "MatchlessMob")] =				{["id"]={509642, 504995, 504996, 504238}, ["isBuff"]=true, ["name"]=""},-- 攻撃無効	["name"]="Mob無敵"												
	[Kitty.T("name",   "MatchlessPC")] =				{["id"]={505932, 505925}, ["isBuff"]=true, ["name"]=""},				--["name"]="フィアーレス"									
	--Items
	[Kitty.T("item",   "ProtectMagicItem1")] =			{["id"]=501182, ["isBuff"]=true, ["name"]=""},							--["name"]="森のケーキ"							
	[Kitty.T("item",   "ProtectMagicItem2")] =			{["id"]=501190, ["isBuff"]=true, ["name"]=""},							--["name"]="シャレスドトーン"							
	[Kitty.T("item",   "ProtectMeleeItem")] =			{["id"]=501178, ["isBuff"]=true, ["name"]=""},							--["name"]="レインボードロップ"							
	[Kitty.T("item",   "ProtectMeleeItem2")] =			{["id"]=501189, ["isBuff"]=true, ["name"]=""},							--["name"]="レインボードロップ"							

	--["マジックトリックW"] =									{["id"]=508539, ["isBuff"]=true, ["name"]="マジックトリック"},				-- M(スーツスキル)
	--["マジックトリックF"] =									{["id"]=508534, ["isBuff"]=true, ["name"]="マジックトリック"},				-- M(スーツスキル)
	--["フェイトW"] =										{["id"]=506582, ["isBuff"]=true, ["name"]=""},							-- M(スーツスキル)	["name"]="チョイス"
	--["フェイトF"] =										{["id"]=506670, ["isBuff"]=true, ["name"]="チョイス"},						-- M(スーツスキル)
	--["フィアーレスA"] =									{["id"]=505932, ["isBuff"]=true, ["name"]="フィアーレス"},
	--["フィアーレスB"] =									{["id"]=505925, ["isBuff"]=true, ["name"]="フィアーレス"},

	-- Debuff																
	--Skills																	
	[Kitty.T("skill", "Blind Spot")] =					{["id"]=620297, ["isBuff"]=false, ["name"]=""},							-- R		["name"]="ブラインドブラッド"			
	[Kitty.T("skill", "Blind Stab")] =					{["id"]=500691, ["isBuff"]=false, ["name"]=""},							-- R		["name"]="ブラインド"			
	[Kitty.T("skill", "Bone Chill")] =					{["id"]=501548, ["isBuff"]=false, ["name"]=""},							-- P		["name"]="フローズンコールド"			
	[Kitty.T("skill", "Briar Entwinement")] =			{["id"]=503808, ["isBuff"]=false, ["name"]=""},							-- D		["name"]="ソーニーバインド"					
	[Kitty.T("skill", "Deadly Nightmare")] =			{["id"]=504057, ["isBuff"]=false, ["name"]=""},							--["name"]="ディープパニック"							
	[Kitty.T("skill", "Death's Touch")] =				{["id"]=501815, ["isBuff"]=false, ["name"]=""},							-- RW		["name"]="タッチオブデス"				
	[Kitty.T("skill", "Electric Bolt")] =				{["id"]=501550, ["isBuff"]=false, ["name"]=""},							-- M		["name"]="サンダーボルト"				
	[Kitty.T("skill", "Enter Nightmare")] =				{["id"]=508900, ["isBuff"]=false, ["name"]=""},							--["name"]="悪夢に堕ちる"						
	[Kitty.T("skill", "Freeze")] =						{["id"]=501961, ["isBuff"]=false, ["name"]=""},							-- P		["name"]="フリーザー"		
    [Kitty.T("skill", "Holy Light's Fury")] =			{["id"]=502074, ["isBuff"]=false, ["name"]=""},							-- KP		["name"]="ホーリーライトアグリー"						
	[Kitty.T("skill", "Lightning")] =					{["id"]={501535, 503837}, ["isBuff"]=false, ["name"]=""},				-- M		["name"]="感電"						
	[Kitty.T("skill", "Low Blow")] =					{["id"]={500704, 620314}, ["isBuff"]=false,["name"]="" },				-- R	["name"]="流血"							
	[Kitty.T("skill", "Low Roar")] =					{["id"]=508775, ["isBuff"]=false, ["name"]=""},							--["name"]="ロウロアー"					
	[Kitty.T("skill", "Movement Restriction")] =		{["id"]=504241, ["isBuff"]=false, ["name"]=""},							-- Wd(10秒麻痺+ダメ)		["name"]="ムーブリストリクション"						
	[Kitty.T("skill", "Open Flank")] =					{["id"]=501503, ["isBuff"]=false, ["name"]=""},							-- W	["name"]="アタックチャンス"				
	[Kitty.T("skill", "Poisonous Infection")] =			{["id"]=502894, ["isBuff"]=false, ["name"]=""},							-- RW		["name"]="ポイズンインフェクション"					
	[Kitty.T("skill", "Probing Attack")] =				{["id"]=501502, ["isBuff"]=false, ["name"]=""},							-- W	["name"]="弱体化"					
	[Kitty.T("skill", "Shadow Prison")] =				{["id"]={500735, 503861}, ["isBuff"]=false, ["name"]=""},				-- R		["name"]="シャドウプリズン"							
	[Kitty.T("skill", "Shadowstab")] =					{["id"]={500654, 620313, 621172}, ["isBuff"]=false, ["name"]=""},		-- R	["name"]="出血"									
	[Kitty.T("skill", "Slash")] =						{["id"]=500081, ["isBuff"]=false, ["name"]=""},							-- W	["name"]="出血"			
	[Kitty.T("skill", "Sneak Attack")] =				{["id"]=500726, ["isBuff"]=false, ["name"]=""},							-- R		["name"]="スラップアタック"				
	--Effects																
	[Kitty.T("effect", "AuthoritativeDeterrence")] =	{["id"]=502112, ["isBuff"]=false, ["name"]=""},															
	[Kitty.T("effect", "BeastSigil")] =					{["id"]=620690, ["isBuff"]=false, ["name"]=""},											
	[Kitty.T("effect", "BleedRogue")] =					{["id"]={500654, 620313, 621172, 620297, 500726}, ["isBuff"]=false, ["name"]=""},											
	[Kitty.T("effect", "BleedWarrior")] =				{["id"]=500081, ["isBuff"]=false, ["name"]=""},												
	[Kitty.T("effect", "Disarmament")] =				{["id"]={500157,500158,500159,500165}, ["isBuff"]=false, ["name"]=""},												
	[Kitty.T("effect", "DisarmamentLv1")] =				{["id"]=500157, ["isBuff"]=false, ["name"]=""},							-- K		["name"]="Lv1ディフェンスダウン"				
	[Kitty.T("effect", "DisarmamentLv2")] =				{["id"]=500158, ["isBuff"]=false, ["name"]=""},							-- K		["name"]="Lv2ディフェンスダウン"				
	[Kitty.T("effect", "DisarmamentLv3")] =				{["id"]=500159, ["isBuff"]=false, ["name"]=""},							-- K		["name"]="Lv3ディフェンスダウン"				
	[Kitty.T("effect", "DisarmamentLv4")] =				{["id"]=500165, ["isBuff"]=false, ["name"]=""},							-- K		["name"]="Lv4ディフェンスダウン"				
	[Kitty.T("effect", "DivinePunishment")] =			{["id"]=502052, ["isBuff"]=false, ["name"]=""},													
	[Kitty.T("effect", "Electrocutioneff")] =			{["id"]=621396, ["isBuff"]=false, ["name"]=""},													
	[Kitty.T("effect", "ElementalExtraction")] =		{["id"]=623436, ["isBuff"]=false, ["name"]=""},														
	[Kitty.T("effect", "GrievousWoundLowBlow")] =		{["id"]={500704, 620314}, ["isBuff"]=false, ["name"]=""},														
	[Kitty.T("effect", "HolySeal")] =					{["id"]={500140,500146,500168,500169}, ["isBuff"]=false, ["name"]=""},											
	[Kitty.T("effect", "HolySealLv1")] =				{["id"]=500140, ["isBuff"]=false, ["name"]=""},							-- K		["name"]="ホーリーサイン1"				
	[Kitty.T("effect", "HolySealLv2")] =				{["id"]=500146, ["isBuff"]=false, ["name"]=""},							-- K		["name"]="ホーリーサイン2"				
	[Kitty.T("effect", "HolySealLv3")] =				{["id"]=500168, ["isBuff"]=false, ["name"]=""},							-- K		["name"]="ホーリーサイン3"				
	[Kitty.T("effect", "HolySealLv4")] =				{["id"]=500169, ["isBuff"]=false, ["name"]=""},							--["name"]="ホーリーサイン4"						
	[Kitty.T("effect", "HolyStrikeLv1")] =			{["id"]=500137, ["isBuff"]=false, ["name"]=""},							-- K		["name"]="Lv1光の刻印"
	[Kitty.T("effect", "HolyStrikeLv2")] =			{["id"]=500138, ["isBuff"]=false, ["name"]=""},							-- K		["name"]="Lv2光の刻印"
	[Kitty.T("effect", "HolyStrikeLv3")] =			{["id"]=500139, ["isBuff"]=false, ["name"]=""},							-- K		["name"]="Lv3光の刻印"
	[Kitty.T("effect", "IceFogRank1")] =				{["id"]=500485, ["isBuff"]=false, ["name"]=""},							-- P		["name"]="Lv1アイスフォガー"				
	[Kitty.T("effect", "IceFogRank2")] =				{["id"]=500486, ["isBuff"]=false, ["name"]=""},							-- P		["name"]="Lv2アイスフォガー"				
	[Kitty.T("effect", "IceFogRank3")] =				{["id"]=500487, ["isBuff"]=false, ["name"]=""},							-- P		["name"]="Lv3アイスフォガー"				
	[Kitty.T("effect", "SappingArrow")] =				{["id"]={501897,504285}, ["isBuff"]=false, ["name"]=""},												
	[Kitty.T("effect", "SilenceM")] =					{["id"]=500529, ["isBuff"]=false, ["name"]=""},											
	[Kitty.T("effect", "SilentSeal")] =					{["id"]=621445, ["isBuff"]=false, ["name"]=""},											
	[Kitty.T("effect", "SoulBrand")] =					{["id"]=621446, ["isBuff"]=false, ["name"]=""},											
	[Kitty.T("effect", "VampireArrows")] =				{["id"]=501690, ["isBuff"]=false, ["name"]=""},												
	[Kitty.T("effect", "Vulnerableeff")] =				{["id"]=501502, ["isBuff"]=false, ["name"]=""},												
    [Kitty.T("effect", "WaveArmorDebuff")] =			{["id"]=500479, ["isBuff"]=false, ["name"]=""},							-- P		["name"]="ウェーブレットアーマー無効"					
	[Kitty.T("effect", "WeakenedWarlock")] =			{["id"]=501577, ["isBuff"]=false, ["name"]=""},													
	[Kitty.T("effect", "WeakenedWarrior")] =			{["id"]=501503, ["isBuff"]=false, ["name"]=""},													
	--Names																
	[Kitty.T("name", "Stun")] =							{["id"]={500735, 503861, 501535, 503837, 504241}, ["isBuff"]=false, ["name"]=""},	-- エスケープ可能なデバフ		["name"]="硬直"						

	--["ダークネスW"] =								{["id"]=621172, ["isBuff"]=false, ["name"]=""},								-- RW	["name"]="出血"
	--["ダークネスR"] =								{["id"]=500654, ["isBuff"]=false, ["name"]=""},								-- R	["name"]="出血"
	--["ダークネスK"] =								{["id"]=620313, ["isBuff"]=false, ["name"]=""},								-- RK	["name"]="出血"
	--["ダーティトリックS"] =								{["id"]=500704, ["isBuff"]=false, ["name"]="流血"},								-- R
	--["ダーティトリックSWK"] =							{["id"]=620314, ["isBuff"]=false, ["name"]="流血"},								-- RS、RW、RK
	--["シャドウプリズンNPC"] =							{["id"]=500735, ["isBuff"]=false, ["name"]="シャドウプリズン"},					-- R from NPC
	--["シャドウプリズンPC"] =							{["id"]=503861, ["isBuff"]=false, ["name"]="シャドウプリズン"},					-- R from PC
	--["ロウロアー"] =									{["id"]=508775, ["isBuff"]=false, ["name"]="ロウロアー"},
	--["ディープパニック"] =								{["id"]=504057, ["isBuff"]=false, ["name"]="ディープパニック"},					-- アンドリア・ナイトメア(混乱)
	--["悪夢に堕ちる"] =								{["id"]=508900, ["isBuff"]=false, ["name"]="悪夢に堕ちる"},						-- アンドリア・ナイトメア(混乱前兆)		

};

-- スタティックメソッド
-- 引数変換(スキル名/IDと閾値のペアに変換)
-- "ダーティトリック" → {["ダーティトリック"] = threshold}
-- 501961 → {[501961] = threshold}
-- {"ブロウ", 501961, [500704]=0.6, ["ダーティトリック"]=0.6}などの形式を
-- ↓↓↓
-- {["ブロウ"]=threshold, [501961]=threshold, [500704]=0.6, ["ダーティトリック"]=0.6}形式に変換する

Kitty.BuffManager.format = function(inData, default)
	local out = {};

	if(inData == nil) then
		return out;
	end

	-- デフォルト値(閾値)
	if(default == nil) then
		default = 0.0;
	end

	if(type(inData) == "number") then	-- 500704
		-- id
		out[inData] = default;
	elseif(type(inData) == "string") then	-- "ダーティトリック"
		-- Effect
		out[inData] = default;
	elseif(type(inData) == "table") then	-- {[1]="スタッブ", ["ダーティトリック"]=0.6, [2]=500704, [500704]=0.0}
		for key, value in pairs(inData) do
			if(type(key) == "number") then
				if(key < 100000) then		-- [1] = "スタッブ"
					out[value] = default;
				else	-- [500704] = 0.0
					out[key] = value;
				end
			elseif(type(key) == "string") then	-- ["ダーティトリック"]=0.6
				out[key] = value;
			end
		end
	end

	return out;
end;
-- 引数変換(スキル名をIDに変換)
-- {"ブロウ"=0.0, [501961]=0.0, [500704]=0.6, ["ダーティトリック"]=0.6}などの形式を
-- {[500081]=0.0, [501961]=0.0, [500704]=0.6, ["500704"]=0.6, ["620314"]=0.6}形式に変換する
Kitty.BuffManager.translate = function(inData)
	local out = {};

	if(inData == nil) then
		return out;
	end

	-- テーブル構造変換
	for key, value in pairs(inData) do
		if(type(key) == "number") then
			-- id
			out[key] = value;
		elseif(type(key) == "string") then	-- ["ダーティトリック"]=0.6
			if(Kitty.BuffManager.effectNameList[key] ~= nil) then
				if(type(Kitty.BuffManager.effectNameList[key].id) == "number") then	-- ["ダーティトリック"] = {["id"]=500704}
					out[Kitty.BuffManager.effectNameList[key].id] = value;
				elseif(type(Kitty.BuffManager.effectNameList[key].id) == "table") then	-- ["ダーティトリック"] = {["id"]={500704, 620314}}
					for _, id in pairs(Kitty.BuffManager.effectNameList[key].id) do
						out[id] = value;
					end
				end
			else
				-- Error
				error("Error: [" .. tostring(key) .. "] is nothing.");
			end
		else
			-- Error
			error("Error: [" .. tostring(key) .. "] is nothing.");
		end
	end

	return out;
end;
-- インスタンスメソッド
-- 更新
Kitty.BuffManager.update = function(self, target)
	if(UnitName(target) == nil) then
		return;
	end
	self.name = tostring(UnitName(target));
	self.unit = target;

	local index = 1;
	self.effectTable = {};
	self.effectNameTable = {};

	-- バフ
	index = 1;
	while(true) do
		local name, texture, count, id, params = UnitBuff(target, index);
		if(name ~= nil) then
			-- バフ・デバフ区分、バフ名、テクスチャ、回数、ID、パラメータ、タイムスタンプ、有効時間
			local table = {};
			table.isBuff = true;
			table.name = name;
			table.texture = texture;
			table.count = count;
			table.id = id;
			table.params = params;
			table.timestamp = Kitty.getTime();
			local duration = UnitBuffLeftTime(target, index);
			if(duration ~= nil) then
				table.duration = duration;
			end

			-- ID-Buff情報
			self.effectTable[id] = table;
			-- BuffName-Buff情報
			if(self.effectNameTable[name] == nil) then
				self.effectNameTable[name] = table;
			else
				-- 有効時間が長いものを選択
				if(self.effectNameTable[name].duration and table.duration) then
					if(self.effectNameTable[name].duration < table.duration) then
						self.effectNameTable[name] = table;
					end
				elseif(table.duration) then
					self.effectNameTable[name] = table;
				end
			end

			index = index + 1;
		else
			break;
		end
	end

	-- デバフ
	index = 1;
	while(true) do
		local name, texture, count, id, params = UnitDebuff(target, index);
		if(name ~= nil) then
			-- バフ・デバフ区分、デバフ名、テクスチャ、回数、ID、パラメータ、タイムスタンプ、有効時間
			local table = {};
			table.isBuff = false;
			table.name = name;
			table.texture = texture;
			table.count = count;
			table.id = id;
			table.params = params;
			table.timestamp = Kitty.getTime();
			local duration = UnitDebuffLeftTime(target, index);
			if(duration ~= nil) then
				table.duration = duration;
			end

			-- ID-Buff情報
			self.effectTable[id] = table;
			-- BuffName-Buff情報
			if(self.effectNameTable[name] == nil) then
				self.effectNameTable[name] = table;
			else
				-- 有効時間が長いものを選択
				if(self.effectNameTable[name].duration and table.duration) then
					if(self.effectNameTable[name].duration < table.duration) then
						self.effectNameTable[name] = table;
					end
				elseif(table.duration) then
					self.effectNameTable[name] = table;
				end
			end

			index = index + 1;
		else
			break;
		end
	end
end;

-- バフ・デバフ判定(名称で判定)
Kitty.BuffManager.hasEffectByName = function(self, effectName, threshold)
	local result = false;
	local duration = 0.0;

	local detail = self.effectNameTable[effectName];
	if(detail ~= nil) then
		if(detail.duration ~= nil) then
			if(detail.duration > threshold) then
				result = true;
				duration = detail.duration;
			else
				result = false;
			end
		else
			result = true;
		end
	else
		result = false;
	end

	return result, duration;
end;
-- バフ・デバフ判定(IDで判定)
Kitty.BuffManager.hasEffectById = function(self, id, threshold)
	local result = false;
	local duration = 0.0;

	local detail = self.effectTable[tonumber(id)];
	if(detail ~= nil) then
		if(detail.duration ~= nil) then
			if(detail.duration > threshold) then
				result = true;
				duration = detail.duration;
			else
				result = false;
			end
		else
			result = true;
		end
	else
		result = false;
	end

	return result, duration;
end;
-- バフ・デバフ判定(既定値より判定)
Kitty.BuffManager.hasEffect = function(self, effectName, threshold)
	-- 引数の型を統一
	-- スキル名/IDと閾値のペアに変換
	local tempData = Kitty.BuffManager.format(effectName, threshold);
	-- スキル名をIDに変換
	local outData = Kitty.BuffManager.translate(tempData);

	local result = false;
	local duration = 0.0;
	for id, limit in pairs(outData) do
		local detail = self.effectTable[id];
		if(detail ~= nil) then
			if(detail.duration ~= nil) then
				if(detail.duration > limit) then
					result = result or true;
					duration = detail.duration;
				else
					result = result or false;
				end
			else
				result = result or true;
			end
		else
			result = result or false;
		end
	end

	return result, duration;
end;

Kitty.lastDuration = 0.0;
Kitty.lastBuffName = "";
-- 無敵判定
Kitty.BuffManager.fearlessCasterList = {
	Kitty.T("item", "ProtectMagicItem2"),	-- ザレス・ディザーン
	Kitty.T("item", "ProtectMagicItem1"),	-- 森のケーキ
	Kitty.T("skill", "Holy Shield"),		-- ホーリーシールド
	Kitty.T("skill", "Holy Light Strike"),	-- ホーリーライト
	Kitty.T("name", "MatchlessPC"),			-- フィアーレス
	Kitty.T("name", "MatchlessMob"),		-- Mob無敵
};
Kitty.BuffManager.fearlessMeleeList = {
	Kitty.T("item", "ProtectMeleeItem"),	-- レインボードロップ
	Kitty.T("skill", "Holy Shield"),		-- ホーリーシールド
	Kitty.T("skill", "Holy Light Strike"),	-- ホーリーライト
	Kitty.T("name", "MatchlessPC"),			-- フィアーレス
	Kitty.T("name", "MatchlessMob"),		-- Mob無敵
};
Kitty.BuffManager.isFearless = function(self, opponentIsPlayerCaster)
	local list = nil;
	if(opponentIsPlayerCaster) then
		-- Playerがキャスター
		list = Kitty.BuffManager.fearlessCasterList;
	else
		-- Playerが前衛職
		list = Kitty.BuffManager.fearlessMeleeList;
	end

	for _, buffName in ipairs(list) do
		local isFearless, duration = self:hasEffect(buffName, 0.3);
		if(isFearless) then
			Kitty.lastDuration = duration;
			Kitty.lastBuffName = buffName;
			return isFearless, duration, buffName;
		end
	end

	return false, 0.0, "";
end;

-- 対象キャラ名
Kitty.BuffManager.getName = function(self)
	return tostring(self.name);
end;

-- バフ確認メッセージ取得(true:バフありメッセージ、false:バフなしメッセージ、nil:効果時間メッセージ)
Kitty.BuffManager.formatBuffMessgage = function(self, buffName, threshold)
	if(threshold <= 0.0) then
		-- ゼロや負は、効果時間を表示する
		threshold = Kitty.MAX_VALUE;
	end

	local message = nil;
	local isBuff, duration = self:hasEffect(buffName);
	if(isBuff) then
		if(duration < threshold) then
			isBuff = nil;
			message = Kitty.T("message", "BuffDurationStateMessage",
				Kitty.colorCyan(self:getName()),
				Kitty.colorYellow(buffName),
				Kitty.colorYellow(Kitty.comma(duration)));
		else
			message = Kitty.T("message", "BuffExistStateMessage",
				Kitty.colorCyan(self:getName()),
				Kitty.colorYellow(buffName));
		end
	else
		message = Kitty.T("message", "BuffNonExistStateMessage",
			Kitty.colorCyan(self:getName()),
			Kitty.colorRed(buffName));
	end
	return isBuff, message;
end;

-- 文字列表現
Kitty.BuffManager.toString = function(self)
	local str = "";
	-- バフ
	str = str .. "[" .. self:getName() .. "]:Buff\n";
	for id, detail in pairs(self.effectTable) do
		if(detail.isBuff) then
			if(detail.duration ~= nil) then
				local remain = tonumber(detail.duration) - (Kitty.getTime() - tonumber(detail.timestamp));
				str = str .. string.format("%s(%s) %.2f[Sec]\n", tostring(detail.name), tostring(detail.id), remain);
			else
				str = str .. string.format("%s(%s)\n", tostring(detail.name), tostring(detail.id));
			end
		end
	end
	-- デバフ
	str = str .. "[" .. self:getName() .. "]:Debuff\n";
	for id, detail in pairs(self.effectTable) do
		if(not detail.isBuff) then
			if(detail.duration ~= nil) then
				local remain = tonumber(detail.duration) - (Kitty.getTime() - tonumber(detail.timestamp));
				str = str .. string.format("%s(%s) %.2f[Sec]\n", tostring(detail.name), tostring(detail.id), remain);
			else
				str = str .. string.format("%s(%s)\n", tostring(detail.name), tostring(detail.id));
			end
		end
	end

	return str;
end;
-- コンストラクタ
Kitty.BuffManager.constructor = function(self)
	-- データメンバ
	local obj = {};
	obj.name = "";
	-- バフ・デバフ
	obj.effectNameTable = {};	-- key:バフ・デバフ名, value:バフ・デバフ情報
	obj.effectTable = {};		-- key:id, value:バフ・デバフ情報

	return setmetatable(obj, {__index=Kitty.BuffManager, __tostring=Kitty.BuffManager.toString});
end;
setmetatable(Kitty.BuffManager, {__call=Kitty.BuffManager.constructor});	-- コンストラクタを指定

--------------------------------------------------------------------------------
-- ショートカット管理クラス
Kitty.SlotManager = {};
-- スタティックメソッド
Kitty.SlotManager.getPureName = function(skillName)
	skillName = skillName:gsub( " %+%d+", "" ) -- PLUSSED SKILL FIX UP
	-- +10などの修飾を除去
	local str = skillName;
	if(str ~= nil) then
		local position = str:reverseFind("+");
		if(position) then
			str = string.sub(str, 0, position-1);
		end
	end
	return str;
end;
-- ActionBarより名称取得
Kitty.SlotManager.getActionName = function(gameTooltip, index)
	if(gameTooltip) then
		Kitty.clearGameTooltip(gameTooltip);
		gameTooltip:SetActionItem(index);
		gameTooltip:Hide();
		local name = _G[gameTooltip:GetName() .. "TextLeft1"]:GetText();
		if(name) then
			name = Kitty.SlotManager.getPureName(name);
		end
		return tostring(name);
	else
		return "";
	end
end;
Kitty.SlotManager.getList = function(startIndex, endIndex)
	if(startIndex == nil) then
		startIndex = 1;
	end
	if(endIndex == nil) then
		endIndex = 80;
	end

	local list = {};
	for index = startIndex, endIndex do
		local path, _, _, _, _, _ = GetActionInfo(index);
		if(path ~= nil) then
			local name = Kitty.SlotManager.getActionName(KittyComboGameTooltip, index);
			if(name) then
				table.insert(list, name);
			end
		end
	end

	return list;
end;
-- インスタンスメソッド
-- インデックス取得
Kitty.SlotManager.getIndex = function(self, name)
	return self.slotTable[name];
end;
-- 利用不可判定(クールダウンのみ判定)
Kitty.SlotManager.canUse = function(self, name, threshold)
	if(threshold == nil) then
		threshold = 0.0;
	end

	local index = self.slotTable[name];
	if(index ~= nil) then
		local _, remaining = GetActionCooldown(index);
		if(remaining <= threshold) then
			-- Debug
			Kitty.debugPrint(tostring(name));

			return true, remaining;
		else
			return false, remaining;
		end
	end

	return false, 0;
end;
Kitty.SlotManager.use = function(self, name)
	local index = self.slotTable[name];
	if(index ~= nil) then
		UseAction(index);
	end
end;

-- 利用不可判定(射程を判定)
Kitty.SlotManager.inRange = function(self, name)
	local index = self.slotTable[name];
	if(index ~= nil) then
		return GetActionUsable(index);
	else
		-- ショートカットなし
		return nil;
	end
end;
-- スロット情報更新
Kitty.SlotManager.onUpdate = function(self, index)
	-- 消去
	for name, slotIndex in pairs(self.slotTable) do
		if(slotIndex == index) then
			self.slotTable[name] = nil;
			-- Debug
--			Kitty.debugPrint("Delete Index:[" .. tostring(index) .. "], Name:[" .. tostring(name) .. "]");
		end
	end
	-- 更新
	local path, _, _, _, _, _ = GetActionInfo(index);
	if(path ~= nil) then
		local name = Kitty.SlotManager.getActionName(KittyComboGameTooltip, index);
		if(name) then
			self.slotTable[name] = index;
			-- Debug
--			Kitty.debugPrint("Add Index:[" .. tostring(index) .. "], Name:[" .. tostring(name) .. "]");
		end
	end
end;
-- 文字列表現
Kitty.SlotManager.toString = function(self, tabIndex)
	local str = "";
	if(tabIndex == nil or tabIndex == 0) then
		for name, index in pairs(self.slotTable) do
			if(str ~= "") then
				str = str .. ", ";
			end
			str = str .. string.format("[%s](%s)", name, index);
		end
	else
		local outCount = 0;
		local outIndex = 1;
		for name, index in pairs(self.slotTable) do
			if(outCount < 20) then
				if((tabIndex-1) * 20 <= outIndex and outIndex <= (tabIndex-1) * 20 + 20) then
					if(str ~= "") then
						str = str .. ", ";
					end
					str = str .. string.format("[%s](%s)", name, index);
					outCount = outCount + 1;
				end
				outIndex = outIndex + 1;
			else
				break;
			end
		end
	end

	return str;
end;
-- コンストラクタ
Kitty.SlotManager.constructor = function(self)
	-- データメンバ
	local obj = {};
	obj.slotTable = {};

	-- コンストラクタ
	-- ショートカット情報取得(ショートカットは、LOADING_END後に有効になる)
	for index = 1, 80 do
		local path, _, _, _, _, _ = GetActionInfo(index);
		if(path ~= nil) then
			local name = Kitty.SlotManager.getActionName(KittyComboGameTooltip, index);
			if(name) then
				obj.slotTable[name] = index;
				-- Debug
				Kitty.debugPrint("Index:[" .. tostring(index) .. "], Name:[" .. tostring(name) .. "]");
			end
		end
	end

	return setmetatable(obj, {__index=Kitty.SlotManager, __tostring=Kitty.SlotManager.toString});
end;
setmetatable(Kitty.SlotManager, {__call=Kitty.SlotManager.constructor});	-- コンストラクタを指定

--------------------------------------------------------------------------------
-- スキル管理クラス
Kitty.SkillManager = {};
Kitty.SkillManager.manaList = {
	[Kitty.T("skill", "Holy Strike")] =					200,	-- K
	[Kitty.T("skill", "Disarmament")] =					200,	-- K
};
Kitty.SkillManager.tensionList = {
	[Kitty.T("skill", "Slash")] =						25,	-- W
	[Kitty.T("skill", "Whirlwind")] =					50,	-- W
	[Kitty.T("skill", "Berserk")] =						25,	-- W
	[Kitty.T("skill", "Defensive Formation")] =			25,	-- W
	[Kitty.T("skill", "Probing Attack")] =				10,	-- W
	[Kitty.T("skill", "Open Flank")] =					20,	-- W
	[Kitty.T("skill", "Tactical Attack")] =				15,	-- W
	[Kitty.T("skill", "Thunder")] =						15,	-- W
	[Kitty.T("skill", "Full Moon Cleave")] =			50,	-- W
	[Kitty.T("skill", "Shout")] =						30,	-- W
	[Kitty.T("skill", "Terror")] =						30,	-- W
	[Kitty.T("skill", "Blasting Cyclone")] =			35,	-- W
	[Kitty.T("skill", "Punishment W")] =				25,	-- W(スーツスキル)
	[Kitty.T("skill", "Sword of Imprisonment")] =		20,	-- W(スーツスキル)
	[Kitty.T("skill", "Brash Ferocity Strike")] =		25,	-- W(スーツスキル)
	[Kitty.T("skill", "Electrical Rage")] =				15,	-- WM
	[Kitty.T("skill", "Interrupting Strike")] =			30,	-- WP
	[Kitty.T("skill", "Opportunity")] =					15,	-- WP
	[Kitty.T("skill", "The Final Battle")] =			25,	-- WS
	[Kitty.T("skill", "Splitting Chop")] =				15,	-- WR
	[Kitty.T("skill", "Quick Reflexes")] =				20,	-- KW
	[Kitty.T("skill", "Fearless")] =					10,	-- KW
	[Kitty.T("skill", "Master of Parry")] =				30,	-- KW
	[Kitty.T("skill", "Authoritative Deterrence")] =	10,	-- KW
	[Kitty.T("skill", "Magical Talent")] =				20,	-- MW
	[Kitty.T("skill", "Magical Enlightenment")] =		35,	-- MW
	[Kitty.T("skill", "Elemental Explosion")] =			35,	-- MW
	[Kitty.T("skill", "Rage Mana")] =					35,	-- MW
	[Kitty.T("skill", "Ascending Dragon Strike")] =		30,	-- PW
	[Kitty.T("skill", "Vindictive Strike")] =			10,	-- PW
	[Kitty.T("skill", "Condensed Rage")] =				25,	-- PW
	[Kitty.T("skill", "Battle Instinct")] =				30,	-- SW
	[Kitty.T("skill", "Mental Focus")] =				30,	-- SW
	[Kitty.T("skill", "Death's Touch")] =				15,	-- RW
	[Kitty.T("skill", "Poisonous Infection")] =			20,	-- RW
	[Kitty.T("skill", "Double Chop")] =					25,	-- WdW
	[Kitty.T("skill", "Beast Chop")] =					20,	-- WdW
	[Kitty.T("skill", "Natural Attack")] =				15,	-- DW
	[Kitty.T("skill", "Cross of Thorns Attack")] =		30,	-- DW
	[Kitty.T("skill", "Healing Wind")] =				15,	-- DW
	[Kitty.T("skill", "Electrocution")] =				20,	-- Mc
	[Kitty.T("skill", "Heavy Bash")] =					20,	-- Mc
	[Kitty.T("skill", "Energy Influx Strike")] =		25,	-- Mc
	[Kitty.T("skill", "Shock Strike")] =				25,	-- Mc
	[Kitty.T("skill", "Fearless Blow")] =				15,	-- Mc
	[Kitty.T("skill", "Rune Energy Influx")] =			10,	-- Mc
	[Kitty.T("skill", "Vacuum Wave")] =					40,	-- Mc
	[Kitty.T("skill", "Imprisonment Pulse")] =			30,	-- Mc
	[Kitty.T("skill", "Arc Strike")] =					5,	-- McW
	[Kitty.T("skill", "Superior Suppression")] =		20,	-- McW
	[Kitty.T("skill", "Deadland Protection")] =			10,	-- McW
	[Kitty.T("skill", "Divine Vengeance")] =			15,	-- McP
	[Kitty.T("skill", "Rune Energy Consecration")] =	10,	-- McP
	[Kitty.T("skill", "Suppression Offensive")] =		10,	-- McM
	[Kitty.T("skill", "Dark Energy Strike")] =			20,	-- McSs
	[Kitty.T("skill", "Indomitable Spirit")] =			20,	-- McSs
	[Kitty.T("skill", "Rune Siphon")] =					10,	-- McSs
	[Kitty.T("skill", "Confusion Mechanism")] =			20,	-- RMc
	[Kitty.T("skill", "Foot Mechanism")] =				20,	-- RMc
	[Kitty.T("skill", "Silent Rune Bomb")] =			20,	-- RMc
	[Kitty.T("skill", "Pulse Rune Bomb")] =				25,	-- RMc
	[Kitty.T("skill", "Electrocution Mechanism")] =		35,	-- RMc
	[Kitty.T("skill", "Heart Rune Energy")] =			20,	-- PMc
	[Kitty.T("skill", "Diamond Light Activation")] =	30,	-- PMc
	[Kitty.T("skill", "Rune Footstep")] =				20,	-- PMc
	[Kitty.T("skill", "Brain Shock")] =					30,	-- MMc
	[Kitty.T("skill", "Electrolysis Power")] =			20,	-- MMc
	[Kitty.T("skill", "Ion Storm")] =					30,	-- MMc
	[Kitty.T("skill", "Saces's Fury")] =				10,	-- SsMc
};
Kitty.SkillManager.energyList = {
	[Kitty.T("skill", "Shadowstab")] =					20,	-- R
	[Kitty.T("skill", "Blind Stab")] =					20,	-- R
	[Kitty.T("skill", "Shadow Step")] =					20,	-- R
	[Kitty.T("skill", "Low Blow")] =					30,	-- R
	[Kitty.T("skill", "Wound Attack")] =				35,	-- R
	[Kitty.T("skill", "Blind Spot")] =					25,	-- R
	[Kitty.T("skill", "Premeditation")] =				20,	-- R
	[Kitty.T("skill", "Sneak Attack")] =				30,	-- R
	[Kitty.T("skill", "Shadow Prison")] =				50,	-- R
	[Kitty.T("skill", "Phantom Stab")] =				35,	-- R(スーツスキル)
	[Kitty.T("skill", "Escape")] =						30,	-- R(スーツスキル)
	[Kitty.T("skill", "Night Attack")] =				25,	-- R(スーツスキル)
	[Kitty.T("skill", "Unknown Choice")] =				25,	-- R(スーツスキル)
	[Kitty.T("skill", "Yawaka's Blessing")] =			30,	-- R(スーツスキル)
	[Kitty.T("skill", "Lion Claw Mark")] =				20,	-- R(スーツスキル)
	[Kitty.T("skill", "Sneak Shot")] =					25,	-- R(スーツスキル)
	[Kitty.T("skill", "Kanches' Rend")] =				35,	-- R(スーツスキル)
	[Kitty.T("skill", "Decay")] =						30,	-- RW
	[Kitty.T("skill", "Vengeance Sting")] =				25,	-- RM
	[Kitty.T("skill", "Create Opportunity")] =			45,	-- RM
	[Kitty.T("skill", "Disabling Blade")] =				50,	-- RM
	[Kitty.T("skill", "Quickness Aura")] =				60,	-- RP
	[Kitty.T("skill", "Kick")] =						30,	-- RP
	[Kitty.T("skill", "Energy Absorb")] =				20,	-- RS
	[Kitty.T("skill", "Killin' Time")] =				45,	-- RD
	[Kitty.T("skill", "Frenzied Attack")] =				50,	-- WR
	[Kitty.T("skill", "Keen Attack")] =					20,	-- WR
	[Kitty.T("skill", "Crazy Blades")] =				20,	-- KR
	[Kitty.T("skill", "Cursed Fangs")] =				30,	-- MR
	[Kitty.T("skill", "Demoralize")] =					30,	-- MR
	[Kitty.T("skill", "Snake Curse")] =					30,	-- PR
	[Kitty.T("skill", "Infectious Wound")] =			30,	-- PR
	[Kitty.T("skill", "Lure of the Snake Woman")] =		40,	-- PR
	[Kitty.T("skill", "Blinding Powder")] =				30,	-- SR
	[Kitty.T("skill", "Sapping Arrows")] =				30,	-- SR
	[Kitty.T("skill", "Achilles' Heel Strike")] =		30,	-- WdR
	[Kitty.T("skill", "Gravel Attack")] =				30,	-- WdR
	[Kitty.T("skill", "Poisonous Widow Embrace")] =		30,	-- DR
	[Kitty.T("skill", "Speed Catalysis")] =				15,	-- DR
	[Kitty.T("skill", "Corrosive Poison")] =			30,	-- DR
	[Kitty.T("skill", "Necrotic Wound")] =				30,	-- DR
	[Kitty.T("skill", "Shadow Pulse")] =				20,	-- McR
	[Kitty.T("skill", "Waiting Game")] =				20,	-- McR
	[Kitty.T("skill", "Shadow Explosion")] =			10,	-- McR
	[Kitty.T("skill", "Soul Poisoned Fang")] =			25,	-- SsR
};
Kitty.SkillManager.focusList = {
	[Kitty.T("skill", "Vampire Arrows")] =				20,	-- S
	[Kitty.T("skill", "Joint Blow")] =					15,	-- S
	[Kitty.T("skill", "Throat Attack")] =				15,	-- S
	[Kitty.T("skill", "Wrist Attack")] =				35,	-- S
	[Kitty.T("skill", "Wind Arrows")] =					15,	-- S
	[Kitty.T("skill", "Frost Arrow")] =					20,	-- S
	[Kitty.T("skill", "Mana Drain Shot")] =				35,	-- S
	[Kitty.T("skill", "Lasso")] =						35,	-- S
	[Kitty.T("skill", "Neck Strike")] =					30,	-- S
	[Kitty.T("skill", "Shatterstar Storm")] =			20,	-- S(スーツスキル)
	[Kitty.T("skill", "Target Lock")] =					30,	-- SW
	[Kitty.T("skill", "Aggro Transfer")] =				35,	-- SM
	[Kitty.T("skill", "Aggro Lead")] =					35,	-- SP
	[Kitty.T("skill", "Weak Spot")] =					30,	-- SR
	[Kitty.T("skill", "Poisonous Bite")] =				20,	-- SR
	[Kitty.T("skill", "Skull Breaker")] =				30,	-- WS
	[Kitty.T("skill", "Stun Shot")] =					30,	-- WS
	[Kitty.T("skill", "Aim for the Wound")] =			30,	-- WS
	[Kitty.T("skill", "Sword Breath")] =				25,	-- WS
	[Kitty.T("skill", "Arrow of Vengeance")] =			20,	-- KS
	[Kitty.T("skill", "Sacred Protection")] =			60,	-- KS
	[Kitty.T("skill", "Disregard Danger")] =			20,	-- KS
	[Kitty.T("skill", "Thunderclap")] =					20,	-- MS
	[Kitty.T("skill", "Magic Crossflow")] =				30,	-- MS
	[Kitty.T("skill", "Combat Master")] =				30,	-- RS
	[Kitty.T("skill", "Substitute")] =					30,	-- RS
	[Kitty.T("skill", "Anti-Magic Arrow")] =			30,	-- WdS
	[Kitty.T("skill", "Morale Boost Wd")] =				35,	-- WdS
	[Kitty.T("skill", "Healing Arrows")] =				20,	-- DS
	[Kitty.T("skill", "Psychic Arrows")] =				20,	-- Ss
	[Kitty.T("skill", "Weakening Weave Curse")] =		20,	-- Ss
	[Kitty.T("skill", "Warp Charge")] =					30,	-- Ss
	[Kitty.T("skill", "Soul Pain")] =					15,	-- Ss
	[Kitty.T("skill", "Surge of Malice")] =				20,	-- Ss
	[Kitty.T("skill", "Saces's Scorn")] =				30,	-- Ss
	[Kitty.T("skill", "Perplexed")] =					25,	-- Ss
	[Kitty.T("skill", "Perception Extraction")] =		15,	-- Ss
	[Kitty.T("skill", "Shield of Solid Mind")] =		35,	-- Ss
	[Kitty.T("skill", "Sublimation Weave Curse")] =		50,	-- Ss
	[Kitty.T("skill", "Beast's Roar")] =				30,	-- Ss
	[Kitty.T("skill", "Defense Net")] =					35,	-- Ss
	[Kitty.T("skill", "Soul Trauma")] =					25,	-- Ss
	[Kitty.T("skill", "Puzzlement")] =					20,	-- Ss
	[Kitty.T("skill", "Calm Paradox")] =				25,	-- Ss
	[Kitty.T("skill", "Surge of Awareness")] =			25,	-- Ss
	[Kitty.T("skill", "Spreading Pain")] =				15,	-- SsP
	[Kitty.T("skill", "Mind Rune")] =					15,	-- SsMc
	[Kitty.T("skill", "Rage Blow")] =					20,	-- WSs
	[Kitty.T("skill", "Divine Battle Spirit")] =		20,	-- WSs
	[Kitty.T("skill", "Psychic Battle Cry")] =			20,	-- WSs
	[Kitty.T("skill", "Spirit-Cracking Blow")] =		30,	-- WSs
	[Kitty.T("skill", "Soul Stab")] =					30,	-- RSs
	[Kitty.T("skill", "Ghostly Strike")] =				30,	-- RSs
	[Kitty.T("skill", "Touch of Revival")] =			30,	-- PSs
	[Kitty.T("skill", "Prayer of Tribulation")] =		30,	-- PSs
	[Kitty.T("skill", "Spirit Jump")] =					20,	-- PSs
	[Kitty.T("skill", "Spatial Jump")] =				20,	-- PSs
	[Kitty.T("skill", "Breath Erase")] =				10,	-- PSs
	[Kitty.T("skill", "Soul Stepping")] =				30,	-- PSs
	[Kitty.T("skill", "Fire Lightning Burst")] =		25,	-- PSs
	[Kitty.T("skill", "Endless Pulse")] =				20,	-- McSs
	[Kitty.T("skill", "Rune Siphon")] =					20,	-- McSs
	[Kitty.T("skill", "Heart Collection Rune")] =		35,	-- McSs
};
Kitty.SkillManager.soulPointList = {
	[Kitty.T("skill", "Willpower Blade")] =				6,	-- Ss 剣先の意志
	[Kitty.T("skill", "Willpower Construct")] =			6,	-- Ss 構築の意志
	[Kitty.T("skill", "Locked Heart")] =				3,	-- Ss 心の砦
	[Kitty.T("skill", "Severed Consciousness")] =		2,	-- Ss 意識カッター
	[Kitty.T("skill", "Mind Barrier")] =				5,	-- Ss マインドバリア
	[Kitty.T("skill", "Ruthless Judgment")] =			2,	-- Ss ルースレスジャッジメント
	[Kitty.T("skill", "Knowledge Acquisition")] =		4,	-- Ss 原理を極める
	[Kitty.T("skill", "Otherworldly Whisper")] =		3,	-- Ss アナザーワールド
	[Kitty.T("skill", "Life Weave")] =					6,	-- Ss 命の再生
	[Kitty.T("skill", "Heart Fence")] =					2,	-- SsW
	[Kitty.T("skill", "Consistent Heart Strike")] =		2,	-- SsW
	[Kitty.T("skill", "Liquidation Suffering")] =		2,	-- SsR
	[Kitty.T("skill", "End of Thought")] =				3,	-- SsR
	[Kitty.T("skill", "Crime and Punishment")] =		2,	-- SsR
	[Kitty.T("skill", "Soul Enlightenment")] =			2,	-- SsP
	[Kitty.T("skill", "Touch of Faith")] =				2,	-- SsP
	[Kitty.T("skill", "Saces's Cracking Spell")] =		2,	-- SsM
	[Kitty.T("skill", "Soul Brand Sting")] =			1,	-- SsM
	[Kitty.T("skill", "Imagination Release")] =			1,	-- SsMc
	[Kitty.T("skill", "Saces's Impulse")] =				2,	-- SsMc
};
-- スタティックメソッド
-- 利用可能なスーツスキル判定
Kitty.SkillManager.isAvailableSuitSkill = function(skillName)
	for index = 0, (SkillPlateUpdate(-1) - 1) do
		if(SkillPlateUpdate(index) == skillName) then
			return true;
		end
	end
	return false;
end;
Kitty.SkillManager.castTarget = function(skillName, unitId)
	if(skillName ~= nil) then
		if(UnitName("target") ~= nil) then
			FocusUnit(1, "target");	-- 保存
			TargetUnit(unitId);
			CastSpellByName(skillName);
			TargetUnit("focus1");	-- 復元
			FocusUnit(1, "");
		else
			TargetUnit(unitId);
			CastSpellByName(skillName);
			TargetUnit();	-- Clear Target
		end
	end
end;
-- インスタンスメソッド
-- スキル情報取得
Kitty.SkillManager.update = function(self)
	-- メインスキル、サブスキル
	for tabIndex = 1, 4 do
		local skillCount = GetNumSkill(tabIndex);
		if skillCount then
			for skillIndex = 1, skillCount do
				local skill, _, texture, _, rank, _, nextRank, isSkillable, isAvailable = GetSkillDetail(tabIndex, skillIndex);
				local cooldown, remaining = GetSkillCooldown(tabIndex, skillIndex);
				if(self.skillTable[skill] == nil) then
					-- 追加
					-- スキル名、テクスチャ、レベル、必要TP、isSkillable、isAvailable、cooldown、remaining、tabIndex、skillIndex、isSuitSkill
					self.skillTable[skill] = {};
				end
				-- 更新
				self.skillTable[skill].skill = skill;
				self.skillTable[skill].texture = texture;
				self.skillTable[skill].rank = rank;
				self.skillTable[skill].nextRank = nextRank;
				self.skillTable[skill].isSkillable = isSkillable;
				self.skillTable[skill].isAvailable = isAvailable;
				self.skillTable[skill].cooldown = cooldown;
				self.skillTable[skill].remaining = remaining;
				self.skillTable[skill].tabIndex = tabIndex;
				self.skillTable[skill].skillIndex = skillIndex;
				self.skillTable[skill].isSuitSkill = false;
			end
		end
	end

	-- スーツスキル
	for classIndex, count in ipairs({SetSuitSkill_List()}) do
		for skillIndex = 0, count-1 do
			--GetSuitSkill_List( int Jobindex, int Skillindex ) => string Name, string Texture, int index
			local skill, texture, index = GetSuitSkill_List(classIndex, skillIndex);	-- 8 / 8 / 8 / 0 / 0 / 8 / 0 / 0 / 11
			--SkillPlateUpdate(int index) return: ( string Name, string Texture, float total cooldown, float current cooldown );
			local _, _, cooldown, remaining = SkillPlateUpdate(skillIndex)
			if(self.skillTable[skill] == nil) then
				-- 追加
				self.skillTable[skill] = {};
			end
			-- 更新
			self.skillTable[skill].skill = skill;
			self.skillTable[skill].texture = texture;
			self.skillTable[skill].tabIndex = classIndex;
			self.skillTable[skill].skillIndex = skillIndex;
			self.skillTable[skill].cooldown = cooldown;
			self.skillTable[skill].remaining = remaining;
			self.skillTable[skill].index = index;
			self.skillTable[skill].isAvailable = false;
			self.skillTable[skill].isSuitSkill = true;
		end
	end
	
	-- isAvailableの更新
	for index = 0, (SkillPlateUpdate(-1) - 1) do
		local skillDetail = self.skillTable[SkillPlateUpdate(index)];
		if(skillDetail ~= nil) then
			skillDetail.isAvailable = true;
		end
	end
end;
-- クールタイム取得
Kitty.SkillManager.canCast = function(self, skillName, threshold)
	if(threshold == nill) then
		threshold = 0.6;
	end

	if(not self:isAvailable(skillName)) then
		return false, 0.0;
	end

	-- Manaチェック
	if(Kitty.SkillManager.manaList[skillName] ~= nil) then
		if(Kitty.ClassManager.getMana("player") < Kitty.SkillManager.manaList[skillName]) then
			return false, 0.0;
		end
	end
	-- Tensionチェック
	if(Kitty.SkillManager.tensionList[skillName] ~= nil) then
		if(Kitty.ClassManager.getTension("player") < Kitty.SkillManager.tensionList[skillName]) then
			return false, 0.0;
		end
	end
	-- ローグSPチェック
	if(Kitty.SkillManager.energyList[skillName] ~= nil) then
		if(Kitty.ClassManager.getEnergy("player") < Kitty.SkillManager.energyList[skillName]) then
			return false, 0.0;
		end
	end
	-- スカウトSPチェック
	if(Kitty.SkillManager.focusList[skillName] ~= nil) then
		if(Kitty.ClassManager.getFocus("player") < Kitty.SkillManager.focusList[skillName]) then
			return false, 0.0;
		end
	end
	-- シャドーサモナー SoulPointチェック
	if(Kitty.SkillManager.soulPointList[skillName] ~= nil) then
		local point, _ = Kitty.ClassManager.getSoulPoint();
		if(point < Kitty.SkillManager.soulPointList[skillName]) then
			return false, 0.0;
		end
	end

	local result = false;
	local remaining = 0.0;
	local skillType = Kitty.CooldownManager.getSkillType(skillName);
	if(skillType ~= nil or self:isSuitSkill(skillName)) then
		-- クールダウンを独自に判定する必要があるスキル
		assert(self.cooldownManager, "CooldownManager is nil.");

		if(skillType == "TrialSkill") then
			-- 特殊スキル
			-- CooldownManagerとSkillManagerの両方のクールタイムを見る
			local ret1, remain1 = self.cooldownManager:canCast(skillName, threshold);
			if(not ret1) then
				result = ret1;
				remaining = remain1;
			else
				local ret2, remain2 = self:canCastNormalSkill(skillName, threshold);
				if(not ret2) then
					result = ret2;
					remaining = remain2;
				else
					result = true;
					remaining = 0.0;
				end
			end
		else
			-- SuitSkill, CastingSpell
			-- CooldownManagerのクールタイムを見る
			result, remaining = self.cooldownManager:canCast(skillName, threshold);
		end
	else
		-- 通常スキル
		result, remaining = self:canCastNormalSkill(skillName, threshold);
	end

	return result, remaining;
end;
-- キャスト(スキル or スーツスキル)
Kitty.Autoshot = function()
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
Kitty.SkillManager.cast = function(self, skillName)
	if(skillName ~= nil) then
		CastSpellByName(skillName);
	end
	Kitty.debugPrint(string.format("%.2f[Sec] %s", Kitty.getTime(), "SkillName:[" .. tostring(skillName) .. "]"));
end;
-- 通常スキルがキャスト可能か判定
Kitty.SkillManager.canCastNormalSkill = function(self, skillName, threshold)
	if(threshold == nil) then
		threshold = 0.6;
	end

	local skillDetail = self.skillTable[skillName];
	if(skillDetail ~= nil) then
		if(skillDetail.isAvailable and skillDetail.remaining <= threshold) then
			return true, skillDetail.remaining;
		end
	end

	return false, 0.0;
end;
-- スーツスキル判定
Kitty.SkillManager.isSuitSkill = function(self, skillName)
	if(self.skillTable[skillName] ~= nil) then
		return self.skillTable[skillName].isSuitSkill;
	else
		return false;
	end
end;
-- 利用可能スキル判定
Kitty.SkillManager.isAvailable = function(self, skillName)
	if(self.skillTable[skillName] ~= nil) then
		return self.skillTable[skillName].isAvailable;
	else
		return false;
	end
end;
-- ハイパーリンク取得
Kitty.SkillManager.getHyperLink = function(self, skillName)
	local skillInfo = self.skillTable[skillName];
	if(skillInfo ~= nil) then
		return GetSkillHyperLink(skillInfo.tabIndex, skillInfo.skillIndex);
	end

	return nil;
end;
-- スキルインデックス取得
Kitty.SkillManager.getIndex = function(self, skillName)
	local skillInfo = self.skillTable[skillName];
	if(skillInfo ~= nil) then
		return skillInfo.tabIndex, skillInfo.skillIndex, skillInfo.index;
	end

	return nil;
end;
-- スーツスキル名取得
Kitty.SkillManager.getSuitSkill = function(self, index)
	for skillName, skillInfo in pairs(self.skillTable) do
		if(skillInfo ~= nil) then
			if(skillInfo.index == index) then
				return skillInfo.skill, skillInfo.texture;
			end
		end
	end
	return nil;
end;
-- 文字列表現
Kitty.SkillManager.toString = function(self, tabIndex)
	local str = "";

	if(type(tabIndex) == "string") then
		-- 詳細
		if(self.skillTable[tabIndex] ~= nil) then
			for key, value in pairs(self.skillTable[tabIndex]) do
				if(str ~= "") then
					str = str .. ", ";
				end
				str = str .. tostring(key) .. ":[" .. tostring(value) .. "]";
			end
		else
			str = "None";
		end
	else
		-- なし:全件、ゼロ:スーツスキル、数値:タブ
		for skillName, skillDetail in pairs(self.skillTable) do
			if(tabIndex == nil) then
				-- 全件
				if(str ~= "") then
					str = str .. ", ";
				end
				str = str .. "[" .. tostring(skillDetail.skill) .. "]";
			elseif(tabIndex == 0) then
				-- スーツスキルのみ
				if(skillDetail.isSuitSkill) then
					if(str ~= "") then
						str = str .. ", ";
					end
					str = str .. "[" .. tostring(skillDetail.skill) .. "]";
				end
			else
				-- 指定されたタブのみ
				if(skillDetail.tabIndex == tabIndex) then
					if(str ~= "") then
						str = str .. ", ";
					end
					str = str .. "[" .. tostring(skillDetail.skill) .. "]";
				end
			end
		end
	end

	return str;
end;
-- コンストラクタ
Kitty.SkillManager.constructor = function(self, cooldownManager)
	-- データメンバ
	local obj = {};
	obj.skillTable = {};
	obj.cooldownManager = cooldownManager;

	return setmetatable(obj, {__index=Kitty.SkillManager, __tostring=Kitty.SkillManager.toString});
end;
setmetatable(Kitty.SkillManager, {__call=Kitty.SkillManager.constructor});	-- コンストラクタを指定

--------------------------------------------------------------------------------
-- クールダウン管理クラス
Kitty.CooldownManager = {};
Kitty.CooldownManager.cooldownTable = {
	[Kitty.T("skill", "Blind Spot")] =									{["skilltype"]="TrialSkill",   ["cooldown"]=5.0},
	[Kitty.T("skill", "Blind Stab")] =									{["skilltype"]="TrialSkill",   ["cooldown"]=5.0},
	[Kitty.T("skill", "Electric Bolt")] =								{["skilltype"]="CastingSpell", ["cooldown"]=2.0},	-- ２連続キャスト防止
-- 共通 General Item Set Skills
	--Restore Rage Focus Energy
	[Kitty.T("skill", "Energy Restore")] =								{["skilltype"]="SuitSkill",    ["cooldown"]=45.0},	--Lvl  51 Sleepwalker Accessory
	--Restore Life
	[Kitty.T("skill", "Spirit Herb Essence")] =							{["skilltype"]="SuitSkill",    ["cooldown"]=8.0},	--Lvl  51 Sleepwalker Accessory
	[Kitty.T("skill", "Essence of Herbs of Omnipotence")] =				{["skilltype"]="SuitSkill",    ["cooldown"]=8.0},	--Lvl  62 Fire Protection, Angerfang's Spirit, Guardian's Spirit, Yinha's Spirit, Fury of Death, Blessing of Death  
	[Kitty.T("skill", "Mysterious Herb Essence")] =						{["skilltype"]="SuitSkill",    ["cooldown"]=8.0},	--Lvl  72 Augmented Release, Imprisoning Barrier, Spirit Suppression, Runic Energy, Immolating Burn, Glacial Freeze   
	[Kitty.T("skill", "Mysterious Fruit Essence")] =					{["skilltype"]="SuitSkill",    ["cooldown"]=8.0},	--Lvl  77 Disaster of Chaos, Master of Will, Headfirst Engagement, Final Strike, Sealed Fate, Otherworld Craftsman 
	[Kitty.T("skill", "Rare Elf Stone Essence")] =						{["skilltype"]="SuitSkill",    ["cooldown"]=8.0},	--Lvl  82 Lyfonava's Set, Sagwyth's Set, Sayafiz's Set, Jolytta's Set, Farutor's Set, Maderoth's Set  
	[Kitty.T("skill", "Elven Herb Extraction")] =						{["skilltype"]="SuitSkill",    ["cooldown"]=8.0},	--Lvl  87 Kerkolon's Set, Horban's Set, Jalorian Bioweapons Set, Yarlis' Set, Gorligen's Set, Sarsidan's Set 
	[Kitty.T("skill", "Miracle Flower Extraction")] =					{["skilltype"]="SuitSkill",    ["cooldown"]=8.0},	--Lvl  92 Lismomo's Set, Yarnatha's Set, Tatarwiak's Set, Kinya's Set, Manakaza's Set, Voidal Banka Set    
	[Kitty.T("skill", "Sage Herb Extraction")] =						{["skilltype"]="SuitSkill",    ["cooldown"]=8.0},	--Lvl  97 Charkor's Set, Mogmogur's Set, Genozan's Set, Kellas' Set, Meshyah's Set, Asoken's Set     
	[Kitty.T("skill", "Hundred Grass Essence Extraction")] =			{["skilltype"]="SuitSkill",    ["cooldown"]=8.0},	--Lvl 100 Golem Guardian's Set, Kadnis' Set, Darkfang Set, Nex of Enoch Set, Sunlight Set 
	--Restore Mana
	[Kitty.T("skill", "Elemental Spirit Stone")] =						{["skilltype"]="SuitSkill",    ["cooldown"]=8.0},	--Lvl  51 Sleepwalker Accessory
	[Kitty.T("skill", "Essence of Elemental Stone of Omnipotence")] =	{["skilltype"]="SuitSkill",    ["cooldown"]=8.0},	--Lvl  62 Fire Protection, Angerfang's Spirit, Guardian's Spirit, Yinha's Spirit, Fury of Death, Blessing of Death  
	[Kitty.T("skill", "Mysterious Magic Stone Essence")] =				{["skilltype"]="SuitSkill",    ["cooldown"]=8.0},	--Lvl  72 Augmented Release, Imprisoning Barrier, Spirit Suppression, Runic Energy, Immolating Burn, Glacial Freeze   
	[Kitty.T("skill", "Blessed Magic Stone Essence")] =					{["skilltype"]="SuitSkill",    ["cooldown"]=8.0},	--Lvl  77 Disaster of Chaos, Master of Will, Headfirst Engagement, Final Strike, Sealed Fate, Otherworld Craftsman 
	[Kitty.T("skill", "Blessed Herb Extraction")] =						{["skilltype"]="SuitSkill",    ["cooldown"]=8.0},	--Lvl  82 Lyfonava's Set, Sagwyth's Set, Sayafiz's Set, Jolytta's Set, Farutor's Set, Maderoth's Set
	[Kitty.T("skill", "Mysterious Elf Stone Essence")] =				{["skilltype"]="SuitSkill",    ["cooldown"]=8.0},	--Lvl  87 Kerkolon's Set, Horban's Set, Jalorian Bioweapons Set, Yarlis' Set, Gorligen's Set, Sarsidan's Set
	[Kitty.T("skill", "Rare Sage Stone Essence")] =						{["skilltype"]="SuitSkill",    ["cooldown"]=8.0},	--Lvl  92 Lismomo's Set, Yarnatha's Set, Tatarwiak's Set, Kinya's Set, Manakaza's Set, Voidal Banka Set
	[Kitty.T("skill", "Mysterious Sage Stone Essence")] =				{["skilltype"]="SuitSkill",    ["cooldown"]=8.0},	--Lvl  97 Charkor's Set, Mogmogur's Set, Genozan's Set, Kellas' Set, Meshyah's Set, Asoken's Set 
	[Kitty.T("skill", "Divine Magic Stone Essence")] =					{["skilltype"]="SuitSkill",    ["cooldown"]=8.0},	--Lvl 100 Golem Guardian's Set, Kadnis' Set, Darkfang Set, Nex of Enoch Set, Sunlight Set 

-- W Warrior Item Set
	[Kitty.T("skill", "Undefeatable King")] =							{["skilltype"]="SuitSkill",    ["cooldown"]=180.0},	--Lvl  55 Fury Battle Wear
	--P[Kitty.T("skill", "Weapon Guard")] =								{["skilltype"]="SuitSkill",    ["cooldown"]=0.0},	--Lvl  55 Devil Slaughter Suit
	[Kitty.T("skill", "Tourniquet 55")] =								{["skilltype"]="SuitSkill",    ["cooldown"]=90.0},	--Lvl  55 Fearless Chainmail Set ?
	[Kitty.T("skill", "Punishment W")] =								{["skilltype"]="SuitSkill",    ["cooldown"]=0.0},	--Lvl  58 Dragon On The Loose ?
	[Kitty.T("skill", "Sword of Imprisonment")] =						{["skilltype"]="SuitSkill",    ["cooldown"]=0.0},	--Lvl  60 Guardian Punishment
	[Kitty.T("skill", "Composure")] =									{["skilltype"]="SuitSkill",    ["cooldown"]=0.0},	--Lvl  65 Heart of Distortion
	[Kitty.T("skill", "Tourniquet 67")] =								{["skilltype"]="SuitSkill",    ["cooldown"]=90.0},	--Lvl  67 Deadly Danger ?
	[Kitty.T("skill", "Brash Ferocity Strike")] =						{["skilltype"]="SuitSkill",    ["cooldown"]=0.0},	--Lvl  70 Assault of the Quaking King
	[Kitty.T("skill", "Powerhouse Sword")] =							{["skilltype"]="SuitSkill",    ["cooldown"]=0.0},	--Lvl  75 S2 Punishment Rune Series
	--P[Kitty.T("skill", "Iron Light Magic Ring Protection")] =			{["skilltype"]="SuitSkill",    ["cooldown"]=0.0},	--Lvl  80 Lyong's Set	
	[Kitty.T("skill", "Guardian of the Pass")] =						{["skilltype"]="SuitSkill",    ["cooldown"]=0.0},	--Lvl  85 Tekoli-Wussa's Set
	[Kitty.T("skill", "Recovery Area")] =								{["skilltype"]="SuitSkill",    ["cooldown"]=90.0},	--Lvl  90 Khalakli Set
	[Kitty.T("skill", "Attack Stance")] =								{["skilltype"]="SuitSkill",    ["cooldown"]=0.0},	--Lvl  95 Slogar's Set
	[Kitty.T("skill", "Crescent Moon Cleave")] =						{["skilltype"]="SuitSkill",    ["cooldown"]=10.0},	--Lvl  98 Terror Spread Set
	--P[Kitty.T("skill", "War Blade")] =								{["skilltype"]="SuitSkill",    ["cooldown"]=0.0},	--Lvl  99 Fursthor Set
	[Kitty.T("skill", "Soul Warrior")] =								{["skilltype"]="SuitSkill",    ["cooldown"]=10.0},	--Lvl 100 Fursthor Set
	--P[Kitty.T("skill", "Desire to Destroy")] =						{["skilltype"]="SuitSkill",    ["cooldown"]=0.0},	--Lvl 104 Final Form of Extermination
	
-- K Knight Item Set
	[Kitty.T("skill", "Lion King Battle Roar")] =						{["skilltype"]="SuitSkill",    ["cooldown"]=120.0},	--Lvl  55 Destruction Armor
	[Kitty.T("skill", "Full Moon Cleave")] =							{["skilltype"]="SuitSkill",    ["cooldown"]=20.0},	--Lvl  55 Knight's Falcon Suit
	[Kitty.T("skill", "Flawless Scarlet Sword")] =						{["skilltype"]="SuitSkill",    ["cooldown"]=4.0},	--Lvl  55 Fearless Plate Set 
	--P[Kitty.T("skill", "Honorable Fighter")] =						{["skilltype"]="SuitSkill",    ["cooldown"]=0.0},	--Lvl  58 Furious Fighter 
	--P[Kitty.T("skill", "Tyrant")] =									{["skilltype"]="SuitSkill",    ["cooldown"]=0.0},	--Lvl  60 Sacred Beast Will
	[Kitty.T("skill", "Arching Chop")] =								{["skilltype"]="SuitSkill",    ["cooldown"]=20.0},	--Lvl  65 Heart of Taming
	[Kitty.T("skill", "Lanaik's Roar")] =								{["skilltype"]="SuitSkill",    ["cooldown"]=120.0},	--Lvl  67 Skeleton Protection
	--P[Kitty.T("skill", "Wicked Backfire")] =							{["skilltype"]="SuitSkill",    ["cooldown"]=0.0},	--Lvl  70 Protection of the Unrivaled Shield
	[Kitty.T("skill", "Myrmex Military Sickle")] =						{["skilltype"]="SuitSkill",    ["cooldown"]=4.0},	--Lvl  75 Carnage
	--P[Kitty.T("skill", "Protection of Twilight")] =					{["skilltype"]="SuitSkill",    ["cooldown"]=0.0},	--Lvl  80 Tatha's Set
	[Kitty.T("skill", "Tsunami")] =										{["skilltype"]="SuitSkill",    ["cooldown"]=20.0},	--Lvl  85 Pikusate's Set (A4/R20)
	[Kitty.T("skill", "Howl from the Deep")] =							{["skilltype"]="SuitSkill",    ["cooldown"]=120.0},	--Lvl  90 Adur Set (A30/R120)
	--P[Kitty.T("skill", "World Domination")] =							{["skilltype"]="SuitSkill",    ["cooldown"]=0.0},	--Lvl  95 Omnisoul Sarcophagus Set	
	[Kitty.T("skill", "Holy Thunder Blade")] =							{["skilltype"]="SuitSkill",    ["cooldown"]=4.0},	--Lvl  98 Kreyen's Set (A2/R4)
	[Kitty.T("skill", "Traces of the Cross Sword")] =					{["skilltype"]="SuitSkill",    ["cooldown"]=15.0},	--Lvl  99 Nasqtas Set (A15/R10)
	--P[Kitty.T("skill", "Heroic Spirit Guard")] =						{["skilltype"]="SuitSkill",    ["cooldown"]=0.0},	--Lvl 100 Steel of Tomb	
	--P[Kitty.T("skill", "Honorable Guard")] =							{["skilltype"]="SuitSkill",    ["cooldown"]=0.0},	--Lvl 104 Final Form of Vitality	
	
-- M Mage Item Set
	[Kitty.T("skill", "Lucky Chance")] =								{["skilltype"]="SuitSkill",    ["cooldown"]=12.0},	--Lvl  55 Bloody Attire
	[Kitty.T("skill", "Lucky Chance Wind")] =							{["skilltype"]="SuitSkill",    ["cooldown"]=12.0,},		   --["skillName"]="フェイト"},
	[Kitty.T("skill", "Lucky Chance Flame")] =							{["skilltype"]="SuitSkill",    ["cooldown"]=12.0,},		   --["skillName"]="フェイト"},
	[Kitty.T("skill", "Recover Magic")] =								{["skilltype"]="SuitSkill",    ["cooldown"]=180.0},	--Lvl  55 Elemental Flame Set
	[Kitty.T("skill", "Stone Scale Blade")] =							{["skilltype"]="SuitSkill",    ["cooldown"]=0.0},	--Lvl  55 Fearless Cloth Set
	[Kitty.T("skill", "Unharmed")] =									{["skilltype"]="SuitSkill",    ["cooldown"]=180.0},	--Lvl  58 Thoughts on Ruling
	[Kitty.T("skill", "Earth Collapse")] =								{["skilltype"]="SuitSkill",    ["cooldown"]=60.0},	--Lvl  60 Unbalanced Energy
	[Kitty.T("skill", "Magic Tricks")] =								{["skilltype"]="SuitSkill",    ["cooldown"]=0.0},	--Lvl  65 Heart of Illusion (A0/R0)
	[Kitty.T("skill", "Magic Tricks Wind")] =							{["skilltype"]="SuitSkill",    ["cooldown"]=0.0,}, 	   --["skillName"]="マジックトリック"},
	[Kitty.T("skill", "Magic Tricks Flame")] =							{["skilltype"]="SuitSkill",    ["cooldown"]=0.0,}, 	   --["skillName"]="マジックトリック"},
	--P[Kitty.T("skill", "Sage")] =										{["skilltype"]="SuitSkill",    ["cooldown"]=0.0},	--Lvl  67 Energy Expansion
	[Kitty.T("skill", "Sword of Divinity")] =							{["skilltype"]="SuitSkill",    ["cooldown"]=30.0},	--Lvl  70 Dexterity of a Thousand Feathers
	--P[Kitty.T("skill", "Shetamb's Think Tank")] =						{["skilltype"]="SuitSkill",    ["cooldown"]=0.0},	--Lvl  75 Signal Suspicion
	[Kitty.T("skill", "Earth Splitting Giant Phantom")] =				{["skilltype"]="SuitSkill",    ["cooldown"]=0.0},	--Lvl  80 Hoson's Set (A30/R0)
	[Kitty.T("skill", "Voice of the Sea")] =							{["skilltype"]="SuitSkill",    ["cooldown"]=180.0},	--Lvl  85 Aggregate of Desperation Set (A0/R180)
	[Kitty.T("skill", "Dulcet Tones")] =								{["skilltype"]="SuitSkill",    ["cooldown"]=180.0},	--Lvl  90 Thallsus Set
	[Kitty.T("skill", "Runic Formation")] =								{["skilltype"]="SuitSkill",    ["cooldown"]=60.0},	--Lvl  95 Sanbresha's Set (A180/R60)
	[Kitty.T("skill", "The Sage")] =									{["skilltype"]="SuitSkill",    ["cooldown"]=0.0},	--Lvl  98 Marissha's Set (A300 activeSkill?/R0 passiveSkill?)
	--P[Kitty.T("skill", "Divine Elementalist")] =						{["skilltype"]="SuitSkill",    ["cooldown"]=0.0},	--Lvl  99 Nex of Korris Set	Archadia
	[Kitty.T("skill", "Shining Blade")] =								{["skilltype"]="SuitSkill",    ["cooldown"]=30.0},	--Lvl  99 Nex of Korris Set	Runes
	--P[Kitty.T("skill", "Rune Master")] =								{["skilltype"]="SuitSkill",    ["cooldown"]=0.0},	--Lvl 100 Soul of Tomb	
	--P[Kitty.T("skill", "Badge of Destruction")] =						{["skilltype"]="SuitSkill",    ["cooldown"]=0.0},	--Lvl 104 Final Form of Magic	

-- P Priest Item Set
	[Kitty.T("skill", "Mana Rune Stone")] =								{["skilltype"]="SuitSkill",    ["cooldown"]=0.0},	--Lvl  55 Ornaments of the Void
	[Kitty.T("skill", "Holy Candle Shield")] =							{["skilltype"]="SuitSkill",    ["cooldown"]=240.0},	--Lvl  55 Holy Source Set
	[Kitty.T("skill", "Frost Scars")] =									{["skilltype"]="SuitSkill",    ["cooldown"]=4.0},	--Lvl  55 Noble Cloth Set
	[Kitty.T("skill", "Cleanse Suit")] =								{["skilltype"]="SuitSkill",    ["cooldown"]=60.0},  --Lvl  58 Guard of the Ruler
	[Kitty.T("skill", "Altar of Shadoj")] =								{["skilltype"]="SuitSkill",    ["cooldown"]=30.0},	--Lvl  60 Heart of Prayer
	[Kitty.T("skill", "Mage's Repayment")] =							{["skilltype"]="SuitSkill",    ["cooldown"]=0.0},	--Lvl  65 Puppet Heart
	[Kitty.T("skill", "Frost Death")] =									{["skilltype"]="SuitSkill",    ["cooldown"]=4.0},	--Lvl  67 Loyal Protection
	[Kitty.T("skill", "Heroic Guard")] =								{["skilltype"]="SuitSkill",    ["cooldown"]=60.0},	--Lvl  70 Power of the Cursed Face  
	[Kitty.T("skill", "Energy Reaction")] =								{["skilltype"]="SuitSkill",    ["cooldown"]=30.0},	--Lvl  75 War Experience
	[Kitty.T("skill", "Elemental Repercussions")] =						{["skilltype"]="SuitSkill",    ["cooldown"]=0.0},	--Lvl  80 Krynor's Set
	[Kitty.T("skill", "Shield of Disorder")] =							{["skilltype"]="SuitSkill",    ["cooldown"]=240.0},	--Lvl  80 Krynor's Set
	[Kitty.T("skill", "Water Element of Rebirth")] =					{["skilltype"]="SuitSkill",    ["cooldown"]=0.0},	--Lvl  85 Yifirus' Set	
	[Kitty.T("skill", "Death of Cold")] =								{["skilltype"]="SuitSkill",    ["cooldown"]=4.0},	--Lvl  90 Kelopas Set (A2/R4)
	[Kitty.T("skill", "Blessing of Rebirth")] =							{["skilltype"]="SuitSkill",    ["cooldown"]=60.0},	--Lvl  95 Istye's Set (A15/R60)
	[Kitty.T("skill", "Slipstream of Healing")] =						{["skilltype"]="SuitSkill",    ["cooldown"]=10.0},	--Lvl  98 Mazzren's Set (A30/R10)
	[Kitty.T("skill", "Supreme Priest")] =								{["skilltype"]="SuitSkill",    ["cooldown"]=240.0},	--Lvl  99 Zeyj Set (Archadia active / Runes passive)
	[Kitty.T("skill", "Divine Shield")] =								{["skilltype"]="SuitSkill",    ["cooldown"]=240.0},	--Lvl 100 Wisdom of Tomb
	--P[Kitty.T("skill", "Divine Urge")] =								{["skilltype"]="SuitSkill",    ["cooldown"]=0.0},	--Lvl 104 Final Form of Aid	
	
-- R Rogue Item Set
	[Kitty.T("skill", "Phantom Stab")] =								{["skilltype"]="SuitSkill",    ["cooldown"]=60.0},	--Lvl  55 Giant Fist Battle Suit
	[Kitty.T("skill", "Escape")] =										{["skilltype"]="SuitSkill",    ["cooldown"]=120.0},	--Lvl  55 Atrocity Suit
	[Kitty.T("skill", "Night Attack")] =								{["skilltype"]="SuitSkill",    ["cooldown"]=0.0},	--Lvl  55 Fearless Leather Set
	[Kitty.T("skill", "Unknown Choice")] =								{["skilltype"]="SuitSkill",    ["cooldown"]=180.0},	--Lvl  58 The Controller's Thoughts
	[Kitty.T("skill", "Yawaka's Blessing")] =							{["skilltype"]="SuitSkill",    ["cooldown"]=0.0},	--Lvl  60 Illegal Invasion
	[Kitty.T("skill", "Lion Claw Mark")] =								{["skilltype"]="SuitSkill",    ["cooldown"]=0.0},	--Lvl  65 Heart of Clown
	[Kitty.T("skill", "Sneak Shot")] =									{["skilltype"]="SuitSkill",    ["cooldown"]=0.0},	--Lvl  67 Strength of a Coward
	[Kitty.T("skill", "Kanches' Rend")] =								{["skilltype"]="SuitSkill",    ["cooldown"]=60.0},	--Lvl  70 Seizure of the Night King
	[Kitty.T("skill", "Greedy Blood Maggot")] =							{["skilltype"]="SuitSkill",    ["cooldown"]=180.0},	--Lvl  75 Sorrowful Sonata
	[Kitty.T("skill", "Poison Pangs")] =								{["skilltype"]="SuitSkill",    ["cooldown"]=0.0},	--Lvl  80 Sandos' Set
	[Kitty.T("skill", "Demon Wolf Claw")] =								{["skilltype"]="SuitSkill",    ["cooldown"]=0.0},	--Lvl  85 Tabokake's Set
	[Kitty.T("skill", "Bloodless")] =									{["skilltype"]="SuitSkill",    ["cooldown"]=0.0},	--Lvl  90 Mosfetto Set
	[Kitty.T("skill", "Soul Storm")] =									{["skilltype"]="SuitSkill",    ["cooldown"]=60.0},	--Lvl  95 Old Dan's Set	(A20/R60)
	[Kitty.T("skill", "Claw Scar")] =									{["skilltype"]="SuitSkill",    ["cooldown"]=6.0},	--Lvl  98 Nex of Tasuq Set
	[Kitty.T("skill", "Target")] =										{["skilltype"]="SuitSkill",    ["cooldown"]=30.0},	--Lvl  99 Cibel Set (Archadia active / Runes passive)
	[Kitty.T("skill", "Golden Cicada Skin")] =							{["skilltype"]="SuitSkill",    ["cooldown"]=120.0},	--Lvl 100 Energy of Tomb (A60/R120)
	[Kitty.T("skill", "Lightning Attack")] =							{["skilltype"]="SuitSkill",    ["cooldown"]=180.0},	--Lvl 104 Final Form of Agility	
		
-- S Scout Item Set
	[Kitty.T("skill", "Archer's Glory")] =								{["skilltype"]="SuitSkill",    ["cooldown"]=180.0},	--Lvl  55 Hunting Dress of the Goddess
	[Kitty.T("skill", "Shatterstar Storm")] =							{["skilltype"]="SuitSkill",    ["cooldown"]=60.0},	--Lvl  55 Shatterstar Storm
	--P[Kitty.T("skill", "Keen Will")] =								{["skilltype"]="SuitSkill",    ["cooldown"]=0.0},	--Lvl  55  Hurricane Leather Set
	[Kitty.T("skill", "Arrow Shield")] =								{["skilltype"]="SuitSkill",    ["cooldown"]=120.0},	--Lvl  58 The Baron's Rage
	[Kitty.T("skill", "Create Tendrils")] =								{["skilltype"]="SuitSkill",    ["cooldown"]=0.0},	--Lvl  60 Brave and Fierce
	--P[Kitty.T("skill", "Hunter's Advantage")] =						{["skilltype"]="SuitSkill",    ["cooldown"]=0.0},	--Lvl  65 Heart of Teasing
	--P[Kitty.T("skill", "Focus Enhancement")] =						{["skilltype"]="SuitSkill",    ["cooldown"]=0.0},	--Lvl  67 Dark Energy
	[Kitty.T("skill", "Shadow of a Thousand Feathers")] =				{["skilltype"]="SuitSkill",    ["cooldown"]=0.0},	--Lvl  70 Massacre of the Insane Warrior
	[Kitty.T("skill", "Strange Arrow")] =								{["skilltype"]="SuitSkill",    ["cooldown"]=30.0},	--Lvl  75 Until Death
	--P[Kitty.T("skill", "Spirit Beast's Leather")] =					{["skilltype"]="SuitSkill",    ["cooldown"]=0.0},	--Lvl  80 Lasoyl's Set
	[Kitty.T("skill", "Hunter Stance")] =								{["skilltype"]="SuitSkill",    ["cooldown"]=180.0},	--Lvl  85 Yinajo's Set
	[Kitty.T("skill", "Hurricane Downpour")] =							{["skilltype"]="SuitSkill",    ["cooldown"]=60.0},	--Lvl  90 Katbalbus Set
	[Kitty.T("skill", "Arrow Defense")] =								{["skilltype"]="SuitSkill",    ["cooldown"]=120.0},	--Lvl  95 Shabdoo's Set
	--P[Kitty.T("skill", "Going It Alone")] =							{["skilltype"]="SuitSkill",    ["cooldown"]=0.0},	--Lvl  98 Swamp of Oblivion Set
	[Kitty.T("skill", "Shock Frost Arrow")] =							{["skilltype"]="SuitSkill",    ["cooldown"]=30.0},	--Lvl  99 Cibel Set
	--P[Kitty.T("skill", "Soul Raider")] =								{["skilltype"]="SuitSkill",    ["cooldown"]=0.0},	--Lvl 100 Energy of Tomb
	[Kitty.T("skill", "Devil's Contract")] =							{["skilltype"]="SuitSkill",    ["cooldown"]=30.0},	--Lvl 104 Final Form of Agility	
		
-- Wd Warden Item Set
	--P[Kitty.T("skill", "Pet Master")] =								{["skilltype"]="SuitSkill",    ["cooldown"]=0.0}, 	--Lvl  55 Fury Battle Wear
	[Kitty.T("skill", "Beast King Attack")] =							{["skilltype"]="SuitSkill",    ["cooldown"]=20.0},	--Lvl  55 Giant Tree Summoning Set
	[Kitty.T("skill", "Tranquil Wave")] =								{["skilltype"]="SuitSkill",    ["cooldown"]=0.0}, 	--Lvl  55 Earth-Splitter Chainmail Set
	[Kitty.T("skill", "Dance of Confusion")] =							{["skilltype"]="SuitSkill",    ["cooldown"]=120.0}, --Lvl  58 Dragon On The Loose
	[Kitty.T("skill", "Unbind")] =										{["skilltype"]="SuitSkill",    ["cooldown"]=60.0},	--Lvl  60 Guardian Punishment
	[Kitty.T("skill", "Animal Spirit Eclipse")] =						{["skilltype"]="SuitSkill",    ["cooldown"]=4.0},	--Lvl  65 Heart of Distortion
	[Kitty.T("skill", "Companion")] =									{["skilltype"]="SuitSkill",    ["cooldown"]=0.0},	--Lvl  67 Deadly Danger
	--P[Kitty.T("skill", "Binding Contract")] =							{["skilltype"]="SuitSkill",    ["cooldown"]=0.0},	--Lvl  70 Assault of the Quaking King
	[Kitty.T("skill", "Beast Punishment")] =							{["skilltype"]="SuitSkill",    ["cooldown"]=20.0},	--Lvl  75 S2 Punishment Rune Series (A8/R20)
	[Kitty.T("skill", "Shadow of the Mist")] =							{["skilltype"]="SuitSkill",    ["cooldown"]=0.0},	--Lvl  80 Lyong's Set
	[Kitty.T("skill", "Chaos of Greed")] =								{["skilltype"]="SuitSkill",    ["cooldown"]=120.0}, --Lvl  85 Tekoli-Wussa's Set
	[Kitty.T("skill", "Unbridled Will")] =								{["skilltype"]="SuitSkill",    ["cooldown"]=60.0},	--Lvl  90 Khalakli Set
	[Kitty.T("skill", "Assault of the Animal Spirit")] =				{["skilltype"]="SuitSkill",    ["cooldown"]=4.0},	--Lvl  95 Slogar's Set
	[Kitty.T("skill", "Echo Effect")] =									{["skilltype"]="SuitSkill",    ["cooldown"]=0.0},	--Lvl  98 Terror Spread Set
	[Kitty.T("skill", "Berserk of Nature")] =							{["skilltype"]="SuitSkill",    ["cooldown"]=120.0},	--Lvl  99 Fursthor Set Archadia
	[Kitty.T("skill", "Nervous Tribulations")] =						{["skilltype"]="SuitSkill",    ["cooldown"]=180.0},	--Lvl  99 Fursthor Set Runes
	--P[Kitty.T("skill", "Iron Focus")] =								{["skilltype"]="SuitSkill",    ["cooldown"]=0.0},	--Lvl 100 Spirit of Tomb
	[Kitty.T("skill", "Animal Spirit's Embrace")] =						{["skilltype"]="SuitSkill",    ["cooldown"]=8.0},	--Lvl 104 Final Form of Extermination	

-- D Druid Item Set
	[Kitty.T("skill", "Blinding Seeds55")] =							{["skilltype"]="SuitSkill",    ["cooldown"]=60.0},	--Lvl  55 Druid Item Set
	[Kitty.T("skill", "Countdown Seeds")] =								{["skilltype"]="SuitSkill",    ["cooldown"]=60.0},	--Lvl  55 Primal Spirit Set
	[Kitty.T("skill", "Forest Bath")] =									{["skilltype"]="SuitSkill",    ["cooldown"]=60.0},	--Lvl  55 Augury Cloth Set
	[Kitty.T("skill", "Lunar Halo")] =									{["skilltype"]="SuitSkill",    ["cooldown"]=60.0},	--Lvl  58 Guard of the Ruler
	[Kitty.T("skill", "Green Seed")] =									{["skilltype"]="SuitSkill",    ["cooldown"]=0.0},	--Lvl  60 Heart of Prayer
	[Kitty.T("skill", "Soul Soothe")] =									{["skilltype"]="SuitSkill",    ["cooldown"]=90.0},	--Lvl  65 Puppet Heart
	[Kitty.T("skill", "Forest Worship")] =								{["skilltype"]="SuitSkill",    ["cooldown"]=60.0},	--Lvl  67 Loyal Protection
	[Kitty.T("skill", "Nature's Force Field")] =						{["skilltype"]="SuitSkill",    ["cooldown"]=60.0},	--Lvl  70 Power of the Cursed Face
	[Kitty.T("skill", "Half-assimilate")] =								{["skilltype"]="SuitSkill",    ["cooldown"]=120.0},	--Lvl  75 War Experience
	[Kitty.T("skill", "Blinding Seeds80")] =							{["skilltype"]="SuitSkill",    ["cooldown"]=60.0},	--Lvl  80 Krynor's Set	
	[Kitty.T("skill", "Seed of Destruction")] =							{["skilltype"]="SuitSkill",    ["cooldown"]=60.0},	--Lvl  85 Yifirus' Set		
	[Kitty.T("skill", "Return of Light")] =								{["skilltype"]="SuitSkill",    ["cooldown"]=60.0},	--Lvl  90 Kelopas Set	
	[Kitty.T("skill", "Life Seed")] =									{["skilltype"]="SuitSkill",    ["cooldown"]=0.0},	--Lvl  95 Istye's Set		
	[Kitty.T("skill", "Seed of Resonance")] =							{["skilltype"]="SuitSkill",    ["cooldown"]=60.0},	--Lvl  98 Mazzren's Set	
	[Kitty.T("skill", "Heaven and Earth")] =							{["skilltype"]="SuitSkill",    ["cooldown"]=240.0},	--Lvl  99 Zeyj Set A240/R120
	[Kitty.T("skill", "Lava Effect")] =									{["skilltype"]="SuitSkill",    ["cooldown"]=45.0},	--Lvl 100 Wisdom of Tomb
	[Kitty.T("skill", "Nature's Cleanse")] =							{["skilltype"]="SuitSkill",    ["cooldown"]=300.0},	--Lvl 104 Final Form of Aid	

-- Warlock Item Set
	[Kitty.T("skill", "Dark Soul Essence")] =							{["skilltype"]="SuitSkill",    ["cooldown"]=90.0},	--Lvl  55 Bloody Attire
	[Kitty.T("skill", "Void Shift")] =									{["skilltype"]="SuitSkill",    ["cooldown"]=60.0},	--Lvl  55 Elemental Flame Set
	[Kitty.T("skill", "Dark Halo")] =									{["skilltype"]="SuitSkill",    ["cooldown"]=50.0},	--Lvl  55 Fearless Cloth Set
	[Kitty.T("skill", "Abyss Footsteps")] =								{["skilltype"]="SuitSkill",    ["cooldown"]=60.0},	--Lvl  58 Thoughts on Ruling
	[Kitty.T("skill", "Soul Absorb Barrier")] =							{["skilltype"]="SuitSkill",    ["cooldown"]=60.0},	--Lvl  60 Unbalanced Energy
	[Kitty.T("skill", "Terror of Broken Souls")] =						{["skilltype"]="SuitSkill",    ["cooldown"]=90.0},	--Lvl  65 Heart of Illusion
	[Kitty.T("skill", "Self-Distortion")] =								{["skilltype"]="SuitSkill",    ["cooldown"]=0.0},	--Lvl  67 Energy Expansion
	[Kitty.T("skill", "Siphonic Etching")] =							{["skilltype"]="SuitSkill",    ["cooldown"]=60.0},	--Lvl  70 Dexterity of a Thousand Feathers
	[Kitty.T("skill", "Psychic Power of the Ant Queen")] =				{["skilltype"]="SuitSkill",    ["cooldown"]=50.0},	--Lvl  75 Signal Suspicion
	[Kitty.T("skill", "Chaos Guide")] =									{["skilltype"]="SuitSkill",    ["cooldown"]=90.0},	--Lvl  80 Hoson's Set	
	[Kitty.T("skill", "Shield of the Otherworld")] =					{["skilltype"]="SuitSkill",    ["cooldown"]=60.0},	--Lvl  85 Aggregate of Desperation Set	Archadia 90  offi 60	
	[Kitty.T("skill", "Path of Anguish")] =								{["skilltype"]="SuitSkill",    ["cooldown"]=60.0},	--Lvl  90 Thallsus Set	Archadia 70  offi 60	
	[Kitty.T("skill", "Dead Spirit Protection")] =						{["skilltype"]="SuitSkill",    ["cooldown"]=60.0},	--Lvl  95 Sanbresha's Set		
	[Kitty.T("skill", "Spatial Rift")] =								{["skilltype"]="SuitSkill",    ["cooldown"]=90.0},	--Lvl  98 Marissha's Set	30->90
	[Kitty.T("skill", "Traces of the Void")] =							{["skilltype"]="SuitSkill",    ["cooldown"]=0.0},	--Lvl  99 Nex of Korris Set Archadia 90  offi 0 oder Sperrzeit 10sec
	[Kitty.T("skill", "Soul Crusher")] =								{["skilltype"]="SuitSkill",    ["cooldown"]=0.0},	--Lvl 100 Soul of Tomb (A30/R0) Runes 6sec for dottime ?
	[Kitty.T("skill", "Astaroth's Dark Magic")] =						{["skilltype"]="SuitSkill",    ["cooldown"]=0.0},	--Lvl 104 Final Form of Magic	40 -> 0

-- Champion Item Set
	[Kitty.T("skill", "Ultimate Destruction")] =						{["skilltype"]="SuitSkill",    ["cooldown"]=8.0},	--Lvl  55 Fury Battle Wear
	[Kitty.T("skill", "Disassembly Step")] =							{["skilltype"]="SuitSkill",    ["cooldown"]=5.0},	--Lvl  55 Devil Slaughter Suit
	--P[Kitty.T("skill", "Runic Enhancement")] =						{["skilltype"]="SuitSkill",    ["cooldown"]=0.0},	--Lvl  55 Fearless Chainmail Set
	[Kitty.T("skill", "Clone Conversion")] =							{["skilltype"]="SuitSkill",    ["cooldown"]=60.0},	--Lvl  58 Dragon On The Loose
	[Kitty.T("skill", "Battle Defense Transfer")] =						{["skilltype"]="SuitSkill",    ["cooldown"]=0.0},	--Lvl  60 Guardian Punishment
	[Kitty.T("skill", "Rune Guardian")] =								{["skilltype"]="SuitSkill",    ["cooldown"]=300.0},	--Lvl  65 Heart of Distortion
	[Kitty.T("skill", "Energy Supply")] =								{["skilltype"]="SuitSkill",    ["cooldown"]=60.0},	--Lvl  67 Deadly Danger
	--P[Kitty.T("skill", "Power Upgrade")] =							{["skilltype"]="SuitSkill",    ["cooldown"]=0.0},	--Lvl  70 Assault of the Quaking King
	[Kitty.T("skill", "Punisher's Disassembly")] =						{["skilltype"]="SuitSkill",    ["cooldown"]=8.0},	--Lvl  75 S2 Punishment Rune Series
	[Kitty.T("skill", "Ferocious Disassembly")] =						{["skilltype"]="SuitSkill",    ["cooldown"]=5.0},	--Lvl  80 Lyong's Set	
	[Kitty.T("skill", "Organic Deconstruction")] =						{["skilltype"]="SuitSkill",    ["cooldown"]=60.0},	--Lvl  85 Tekoli-Wussa's Set		
	[Kitty.T("skill", "Attack Is the Best Defense")] =					{["skilltype"]="SuitSkill",    ["cooldown"]=0.0},	--Lvl  90 Khalakli Set
	[Kitty.T("skill", "Sacrificial Protection")] =						{["skilltype"]="SuitSkill",    ["cooldown"]=480.0},	--Lvl  95 Slogar's Set	A300/R480
	--P[Kitty.T("skill", "Unbreakable")] =								{["skilltype"]="SuitSkill",    ["cooldown"]=0.0},	--Lvl  98 Terror Spread Set	
	--P[Kitty.T("skill", "Increased Drive")] =							{["skilltype"]="SuitSkill",    ["cooldown"]=0.0},	--Lvl  99 Fursthor Set
	[Kitty.T("skill", "Runic Charge")] =								{["skilltype"]="SuitSkill",    ["cooldown"]=40.0},	--Lvl 100 Spirit of Tomb
	[Kitty.T("skill", "Secret Technique of the Ruins")] =				{["skilltype"]="SuitSkill",    ["cooldown"]=240.0},	--Lvl 104 Final Form of Extermination	
		
};

-- スタティックメソッド
-- 対象スキル判定
Kitty.CooldownManager.getSkillType = function(skillName)
	local detail = Kitty.CooldownManager.cooldownTable[skillName];
	if(detail ~= nil) then
		return detail.skilltype;
	else
		return nil;
	end
end;
-- インスタンスメソッド
-- スキル発動成功
Kitty.CooldownManager.onSucceed = function(self, skillName)
	local detail = Kitty.CooldownManager.cooldownTable[skillName];
	if(detail ~= nil) then
		if(self.skillTable[skillName] == nil or (self.skillTable[skillName].skilltype ~= "CastingSpell")) then
			self.skillTable[skillName] = {};
			self.skillTable[skillName].skilltype = detail.skilltype;
			self.skillTable[skillName].cooldown = detail.cooldown;
			self.skillTable[skillName].timestamp = Kitty.getTime();
			self.skillTable[skillName].state = "Succeed";
		end

		local original = Kitty.CooldownManager.cooldownTable[detail.skillName];
		if(original ~= nil) then
			-- スキルにクールダウンを付与
			self.skillTable[detail.skillName] = {};
			self.skillTable[detail.skillName].skilltype = original.skilltype;
			self.skillTable[detail.skillName].cooldown = original.cooldown;
			self.skillTable[detail.skillName].timestamp = Kitty.getTime();
			self.skillTable[detail.skillName].state = "Cast";
		end
	end
end;
-- スキル発動失敗
Kitty.CooldownManager.onFail = function(self, skillName)
	local detail = Kitty.CooldownManager.cooldownTable[skillName];
	if(detail ~= nil) then
		self.skillTable[skillName] = {};
		self.skillTable[skillName].skilltype = detail.skilltype;
		self.skillTable[skillName].cooldown = detail.cooldown;
		self.skillTable[skillName].timestamp = Kitty.getTime();
		self.skillTable[skillName].state = "Fail";
	end
end;
-- スペル詠唱開始
Kitty.CooldownManager.onCast = function(self, skillName, cooldown)
	local detail = Kitty.CooldownManager.cooldownTable[skillName];
	if(detail ~= nil) then
		self.skillTable[skillName] = {};
		self.skillTable[skillName].skilltype = detail.skilltype;
		self.skillTable[skillName].cooldown = detail.cooldown;
		self.skillTable[skillName].timestamp = Kitty.getTime();
		self.skillTable[skillName].state = "Cast";
	else
		-- 任意のアクションのクールダウン
		self.skillTable[skillName] = {};
		self.skillTable[skillName].skilltype = "Custom";
		self.skillTable[skillName].cooldown = cooldown or 3.0;
		self.skillTable[skillName].timestamp = Kitty.getTime();
		self.skillTable[skillName].state = "Act";
	end
end;
-- スキル使用可能判定
Kitty.CooldownManager.canCast = function(self, skillName, threshold)
	if(threshold == nil) then
		threshold = 0.3;
	end
	threshold = math.abs(threshold);
	local result = false;
	local remaining = 0.0;
	local skillDetail = self.skillTable[skillName];
	if(skillDetail ~= nil) then
		local remain = skillDetail.timestamp + skillDetail.cooldown - Kitty.getTime();
		if(remain > threshold) then
			result = false;
			remaining = remain;
		else
			-- キャスト履歴を削除
			self.skillTable[skillName] = nil;
			result = true;
			remaining = remain;
		end
	else
		result = true;
		remaining = 0.0;
	end

	return result, remaining;
end;
-- 文字列表現
Kitty.CooldownManager.toString = function(self)
	local str = "";
	for key, value in pairs(self.skillTable) do
		if(str ~= "") then
			str = str .. ", ";
		end

		str = str .. tostring(key) .. ":";
		for k, v in pairs(value) do
			if(type(v) == "number") then
				str = str .. string.format("[%s=%.2f]", tostring(k), v);
			else
				str = str .. string.format("[%s=%s]", tostring(k), tostring(v));
			end
		end
	end

	if(str == "") then
		str = "None";
	end
	return str;
end;
-- コンストラクタ
Kitty.CooldownManager.constructor = function(self)
	-- データメンバ
	local obj = {};
	obj.skillTable = {};

	return setmetatable(obj, {__index=Kitty.CooldownManager, __tostring=Kitty.CooldownManager.toString});
end;
setmetatable(Kitty.CooldownManager, {__call=Kitty.CooldownManager.constructor});	-- コンストラクタを指定

--------------------------------------------------------------------------------
-- ExtraAction管理クラス
Kitty.ExtraActionManager = {};
-- スタティックメソッド
Kitty.ExtraActionManager.canUseByIndex = function(index, threshold)
	if(threshold == nil) then
		threshold = 0.0;
	end

	local extraActionName = Kitty.ExtraActionManager.getExtraActionName(KittyComboGameTooltip, index);
	if(extraActionName ~= nil and extraActionName ~= "") then
		local _, remaining = GetExtraActionCooldown(index);

		if(remaining <= threshold) then
			return true, remaining;
		else
			return false, remaining;
		end
	end

	return false, 0;
end;
Kitty.ExtraActionManager.useByIndex = function(index)
	UseExtraAction(index);
end;
-- ExtraActionBarより名称取得
Kitty.ExtraActionManager.getExtraActionName = function(gameTooltip, index)
	if(gameTooltip) then
		Kitty.clearGameTooltip(gameTooltip);
		gameTooltip:SetExtraActionItem(index);
		gameTooltip:Hide();
		local name = _G[gameTooltip:GetName() .. "TextLeft1"]:GetText();
		return tostring(name);
	else
		return "";
	end
end;
-- インスタンスメソッド
Kitty.ExtraActionManager.getExtraActionList = function(self)
	local list = {};
	for extraActionName, value in pairs(self.extraActionTable) do
		table.insert(list, extraActionName);
	end
	return list;
end;
Kitty.ExtraActionManager.canUse = function(self, extraActionName, threshold)
	if(threshold == nil) then
		threshold = 0.0;
	end

	if(self.extraActionTable[extraActionName] ~= nil) then
		local remaining = self.extraActionTable[extraActionName].remaining;
		if(remaining <= threshold) then
			return true, remaining;
		else
			return false, remaining;
		end
	end

	return false, 0;
end;
Kitty.ExtraActionManager.use = function(self, extraActionName)
	if(self.extraActionTable[extraActionName] ~= nil) then
		local index = self.extraActionTable[extraActionName].index;
		UseExtraAction(index);
	end
end;
-- 文字列表現
Kitty.ExtraActionManager.toString = function(self)
	local str = "";
	for name, value in pairs(self.extraActionTable) do
		if(str == nil) then
			str = str .. ", ";
		end
		str = str .. name .. ":[Index=" .. tostring(value.index) .. "][Duration=" .. tostring(value.duration) .. "][Remaining=" .. tostring(value.remaining) .. "]";
	end
	return str;
end;
-- コンストラクタ
Kitty.ExtraActionManager.constructor = function(self)
	-- データメンバ
	local obj = {};
	obj.extraActionTable = {};

	local index = 1;
	while(true) do
		local extraActionName = Kitty.ExtraActionManager.getExtraActionName(KittyComboGameTooltip, index);
		if(extraActionName ~= nil and extraActionName ~= "") then
			obj.extraActionTable[extraActionName] = {};
			obj.extraActionTable[extraActionName].index = index;
			obj.extraActionTable[extraActionName].duration, obj.extraActionTable[extraActionName].remaining = GetExtraActionCooldown(index);
		else
			break;
		end

		index = index + 1;
	end

	-- 関数の付与、文字列表現サポート
	return setmetatable(obj, {__index=Kitty.ExtraActionManager, __tostring=Kitty.ExtraActionManager.toString});
end;
setmetatable(Kitty.ExtraActionManager, {__call=Kitty.ExtraActionManager.constructor});	-- コンストラクタを指定

--------------------------------------------------------------------------------
-- Macro管理クラス
Kitty.MacroManager = {};
-- インスタンスメソッド
Kitty.MacroManager.getIndex = function(self, name)
	if(self.macroTable[name] ~= nil) then
		return self.macroTable[name].index;
	end
	return nil;
end;
Kitty.MacroManager.getIcon = function(self, name)
	if(self.macroTable[name] ~= nil) then
		local iconIndex = self.macroTable[name].iconIndex;
		if(iconIndex ~= nil) then
			return GetMacroIconInfo(iconIndex);
		end
	end
	return nil;
end;
Kitty.MacroManager.canExecute = function(self, name)
	if(self.macroTable[name] ~= nil) then
		return true;
	else
		return false;
	end
end;
-- マクロ実行関数(スキル、アイテムを使用するマクロの実行は不可)
Kitty.MacroManager.execute = function(self, name)
	-- マクロの解析
	local macroList, totalEstimatedPeriod = self:parseMacro(name);
	if(macroList == nil) then
		return nil;
	end

	-- マクロ実行関数
	local eventQueue = self.eventQueue;
	local executeMacro = function(self, macroList)
		if(type(macroList) == "table") then

			while(true) do
				local macro = table.remove(macroList, 1);
				if(macro ~= nil) then
					if(type(macro) == "string") then
						-- 通常のマクロ
						ExecuteMacroLine(macro);
						Kitty.debugPrint("Execute:" .. tostring(macro));
					elseif(type(macro) == "number") then
						-- Wait
						eventQueue:addFunction(macro*1000, self, self, macroList);
						Kitty.debugPrint("Wait:" .. tostring(macro));
						break;
					else
						error("Error: Invalid type. Macro:[" .. tostring(macro) .. "]");
					end
				else
					break;
				end
			end

		else
			error("Error: macroList is not table. MacroList:[" .. tostring(macroList) .. "]");
		end
	end;

	-- マクロの実行(非同期)
	eventQueue:addFunction(0, executeMacro, executeMacro, macroList);

	return totalEstimatedPeriod;
end;
-- マクロ解析関数(行コマンドごとに分割)
Kitty.MacroManager.parseMacro = function(self, name)
	local macroList = {};	-- 数値は待ち時間、Stringはマクロの行コマンド
	local totalEstimatedPeriod = 0.0;

	-- マクロ解析(行コマンドごとに分割)
	if(self.macroTable[name] ~= nil and self.macroTable[name].index ~= nil) then
		local _, _, body = GetMacroInfo(self.macroTable[name].index);
		if(type(body) == "string") then
			-- 改行ごとに分離
			local list = string.split(body, "\n");
			for index, str in ipairs(list) do
				if(str ~= nil and str ~= "") then
					str = string.trim(str);
					if(string.startsWith(str, "/[Ww][Aa][Ii][Tt]") == true) then
						-- /waitマクロ(/waitは機能しないため、独自に処理する)
						local period = self:getWaitTime(str);
						if(period ~= nil) then
							totalEstimatedPeriod = totalEstimatedPeriod + period;
							table.insert(macroList, period);
						end
					else
						-- 通常のマクロ
						table.insert(macroList, str);
					end
				end
			end

			-- 末尾のwaitを除去
			for index = #macroList, 1, -1 do
				if(type(macroList[index]) ~= "string") then
					-- 除去
					table.remove(macroList);
				else
					break;
				end
			end

			return macroList, totalEstimatedPeriod;
		end
	end
	return nil;
end;
-- 文字列から、/waitマクロの待ち時間[Sec]を取得する関数
Kitty.MacroManager.getWaitTime = function(self, macro)	-- [/wait 1.0]など
	local list = string.split(macro, " ");
	local period = nil;
	for index, str in ipairs(list) do
		-- 最初の数値を待ち時間とする
		period = tonumber(str);
		if(period ~= nil) then
			return period;
		end
	end
	return nil;
end;
-- 文字列表現
Kitty.MacroManager.toString = function(self)
	local str = "";
	for name, value in pairs(self.macroTable) do
		if(str == nil) then
			str = str .. ", ";
		end
		str = str .. name .. ":[Index=" .. tostring(value.index) .. "][IconIndex=" .. tostring(value.iconIndex) .. "]";
	end
	return str;
end;
-- コンストラクタ
Kitty.MacroManager.constructor = function(self, eventQueue)
	-- データメンバ
	local obj = {};
	obj.eventQueue = eventQueue;
	obj.macroTable = {};

	for index = 1, MAX_NUM_MACROS do
		local iconIndex, name, body=GetMacroInfo(index);
		if(iconIndex ~= nil) then
			-- 同名のマクロが存在する場合は、最初のものを利用
			if(obj.macroTable[name] == nil) then
				obj.macroTable[name] = {};
				obj.macroTable[name].index = index;
				obj.macroTable[name].iconIndex = iconIndex;
			end
		end
	end

	-- 関数の付与、文字列表現サポート
	return setmetatable(obj, {__index=Kitty.MacroManager, __tostring=Kitty.MacroManager.toString});
end;
setmetatable(Kitty.MacroManager, {__call=Kitty.MacroManager.constructor});	-- コンストラクタを指定

--------------------------------------------------------------------------------
-- Emotion管理クラス
Kitty.EmotionManager = {};
-- インスタンスメソッド
Kitty.EmotionManager.canEmote = function(self, emotionName)
	if(g_EmoteCmdTable[emotionName] ~= nil) then
		return true;
	else
		return false;
	end
end;
Kitty.EmotionManager.doEmote = function(self, emotionName)
	local index = g_EmoteCmdTable[emotionName];
	if(index ~= nil) then
		DoEmote(index);
	end
end;
Kitty.EmotionManager.getIndex = function(self, emotionName)
	return g_EmoteCmdTable[emotionName];
end;
-- 文字列表現
Kitty.EmotionManager.toString = function(self)
	local list = {};
	for name, index in pairs(g_EmoteCmdTable) do
		if(list[index] == nil) then
			-- 新規
			list[index] = {name};
		else
			-- 追加
			table.insert(list[index], name)
		end
	end

	for index=1, #list do
		table.sort(list[index]);
	end

	local str = "";
	for index, nameList in ipairs(list) do
		if(tonumber(index) ~= nil) then
			local line = "";
			for nameIndex, name in ipairs(nameList) do
				if(line ~= nil) then
					line = line .. ", ";
				end

				line = line .. "[" .. string.format("%02d", tonumber(index)) .. "]:[" .. name .. "]";
			end
			str = str .. line .. "\n";
		end
	end

	return str;
end;
-- コンストラクタ
Kitty.EmotionManager.constructor = function(self)
	-- データメンバ
	local obj = {};

	-- 関数の付与、文字列表現サポート
	return setmetatable(obj, {__index=Kitty.EmotionManager, __tostring=Kitty.EmotionManager.toString});
end;
setmetatable(Kitty.EmotionManager, {__call=Kitty.EmotionManager.constructor});	-- コンストラクタを指定
