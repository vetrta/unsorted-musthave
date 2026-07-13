-- (C) 2012-2013 Miranda
--------------------------------------------------------------------------------
-- 名前空間作成
if(_G and not _G.Kitty) then
	_G.Kitty = {};
end
--------------------------------------------------------------------------------
-- 定数
Kitty.VERSION = "0.973";

--------------------------------------------------------------------------------
-- ターゲットのバフ、デバフを表示
Kitty.showBuff = function(target)
	if(UnitName(target) == nil) then
		target = "player";
	end

	-- バフ情報取得
	local buffManager = Kitty.BuffManager();
	buffManager:update(target);
	Kitty.sendMessage(tostring(buffManager), "DEFAULT", 1, 1, 1);
	buffManager = nil;
end;
Kitty.showBuff = Kitty.protectFunction(Kitty.showBuff);	-- 保護モードで実行
Kitty.ShowBuff = Kitty.showBuff;	-- エイリアス
Kitty.showbuff = Kitty.showBuff;	-- エイリアス

--------------------------------------------------------------------------------
-- ターゲットのバフをチェック
Kitty.checkBuff = function()
	local outList = {};

	table.insert(outList, Kitty.T("message", "StartBuffCheckMessage"));
	for index, unit in Kitty.PartyManager.iterator() do
		outList = Kitty.concatTable(outList, Kitty.checkTarget(unit));
	end
	table.insert(outList, Kitty.T("message", "EndBuffCheckMessage"));

	-- 出力
	local messageType = "DEFAULT";
	if(Kitty.PartyManager.count() > 1 and IsShiftKeyDown()) then
		messageType = "PARTY";
	end

	Kitty.sendMessage(outList, messageType);
end;
Kitty.checkBuff = Kitty.protectFunction(Kitty.checkBuff);	-- 保護モードで実行
Kitty.CheckBuff = Kitty.checkBuff;	-- エイリアス
Kitty.checkbuff = Kitty.checkBuff;	-- エイリアス
Kitty.formatBuffMessgage = function(buffManager, buffName, threshold)	-- true:バフありメッセージ、false:バフなしメッセージ、nil:効果時間メッセージ
	if(threshold <= 0.0) then
		-- ゼロや負は、効果時間を表示する
		threshold = Kitty.MAX_VALUE;
	end

	local message = nil;
	local isBuff, duration = buffManager:hasEffect(buffName);
	if(isBuff) then
		if(duration < threshold) then
			isBuff = nil;
			message = Kitty.T("message", "BuffDurationStateMessage",
						Kitty.colorCyan(buffManager:getName()),
						Kitty.colorYellow(buffName),
						Kitty.colorYellow(Kitty.comma(duration)));
		else
			message = Kitty.T("message", "BuffExistStateMessage",
						Kitty.colorCyan(buffManager:getName()),
						Kitty.colorYellow(buffName));
		end
	else
		message = Kitty.T("message", "BuffNonExistStateMessage",
					Kitty.colorCyan(buffManager:getName()),
					Kitty.colorRed(buffName));
	end
	return isBuff, message;
end;
Kitty.checkBuffList = {
	[Kitty.T("skill", "Soul Bond")] = 0.0,					-- P:スピリットオース
--	[Kitty.T("skill", "Amplified Attack")] = 180.0,			-- P:アタックブースト
--	[Kitty.T("skill", "Enhanced Grace of Life")] = 180.0,	-- P:ベネフィットライフ
--	[Kitty.T("skill", "Enhanced Grace of Life")] = 180.0,	-- PK:ベネフィットライフ・ブースト
	[Kitty.T("skill", "Awakening of the Wild D")] = 0.0,	-- DW:ワイルドアウェイク
	[Kitty.T("item", "ProtectMeleeItem")] = 0.0,			-- レインボードロップ
	[Kitty.T("item", "ProtectMagicItem2")] = 0.0,			-- ザレス・ディザーン
	[Kitty.T("item", "ProtectMagicItem1")] = 0.0,			-- 森のケーキ
	[Kitty.T("skill", "Holy Shield")] = 0.0,				-- ホーリーシールド
	[Kitty.T("skill", "Holy Light Strike")] = 0.0,			-- ホーリーライト
--	[Kitty.T("effect", "SignRecovery")] = 0.0,				-- 回復の印
	[Kitty.T("effect", "SignAttack")] = 0.0,				-- 攻撃の印
--	[Kitty.T("effect", "SignDefence")] = 0.0,				-- 防御の印
--	[Kitty.T("effect", "SignExperience")] = 0.0,			-- 経験の印
	[Kitty.T("effect", "SignMagicAttack")] = 0.0,			-- 魔法攻撃の印
--	[Kitty.T("effect", "SignMagicDefence")] = 0.0,			-- 魔法防御の印
--	[Kitty.T("effect", "SignSkill")] = 0.0,					-- 技の印
};
Kitty.checkTarget = function(target)
	if(UnitName(target) == nil) then
		return;
	end

	local outList = {};

	-- バフ情報取得
	local buffManager = Kitty.BuffManager();
	buffManager:update(target);

	-- HP
	if(UnitHealth(target) < 40000) then
		table.insert(outList, Kitty.T("message", "HPState",
								Kitty.colorCyan(tostring(UnitName(target))),
								Kitty.colorRed(Kitty.comma(UnitHealth(target))))
		);
	end

	-- Pバフ
	if(not Kitty.ClassManager.isCaster(target)) then
		-- アタックブースト
		local isAttackBoost, attackBoostMessage = buffManager:formatBuffMessgage(Kitty.T("skill", "Amplified Attack"), 180.0);
		if(isAttackBoost == nil or isAttackBoost == false) then
			-- バフの効果時間、もしくは存在しないことを表示
			table.insert(outList, tostring(attackBoostMessage));
		end
	end
	-- ベネフィットライフ
	local isBenefitLife, benefitLifeMessage = buffManager:formatBuffMessgage(Kitty.T("skill", "Grace of Life"), 180.0);
	if(isBenefitLife == nil) then
		-- バフの効果時間を表示
		table.insert(outList, tostring(benefitLifeMessage));
	end
	-- ベネフィットライフ・ブースト
	local isBenefitLifeBoost, benefitLifeBoostMessage = buffManager:formatBuffMessgage(Kitty.T("skill", "Enhanced Grace of Life"), 180.0);
	if(isBenefitLifeBoost == nil) then
		-- バフの効果時間を表示
		table.insert(outList, tostring(benefitLifeBoostMessage));
	end
	if(isBenefitLife == false and isBenefitLifeBoost == false) then
		-- バフが存在しないことを表示
		table.insert(outList, tostring(benefitLifeMessage));
	end

	-- KPバフ
	local resultList = Kitty.PartyManager.searchClass("K/P");
	if(next(resultList) ~= nil) then
		-- ホーリーライトプロテクト
		local isHolyLightProtect, holyLightProtectMessage = buffManager:formatBuffMessgage(Kitty.T("skill", "Holy Protection"), 180.0);
		if(isHolyLightProtect == nil or isHolyLightProtect == false) then
			-- バフの効果時間、もしくは存在しないことを表示
			table.insert(outList, tostring(holyLightProtectMessage));
		end
	end

	-- Ssバフ
	local resultList = Kitty.PartyManager.searchClass("Ss/");
	if(next(resultList) ~= nil) then
		-- クラスアップスペル
		local isClassUpSpell, ClassUpSpellMessage = buffManager:formatBuffMessgage(Kitty.T("skill", "Sublimation Weave Curse"), 180.0);
		if(isClassUpSpell == nil or isClassUpSpell == false) then
			-- バフの効果時間、もしくは存在しないことを表示
			table.insert(outList, tostring(ClassUpSpellMessage));
		end
	end

	-- 対象のバフ情報を表示
	for buffName, threshold in pairs(Kitty.checkBuffList) do
		local isBuff, message = buffManager:formatBuffMessgage(buffName, threshold);

		if(threshold > 0.0) then
			if(isBuff == nil or isBuff == false) then
				-- バフの効果時間、もしくは存在しないことを表示
				table.insert(outList, tostring(message));
			end
		else
			if(isBuff == nil) then
				-- バフの効果時間を表示
				table.insert(outList, tostring(message));
			end
		end
	end

	buffManager = nil;
	return outList;
end;

--------------------------------------------------------------------------------
-- 修理
Kitty.repair = function()
	if(not Kitty.findItem(Kitty.T("item", "RepairHammer"))) then
		Kitty.sendMessage(Kitty.T("message", "RepairMessage1"));
		return false;
	end

	for _, index in ipairs({0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 11, 12, 13, 14, 16, 17, 21, 15, 10}) do
		local durable, max, name = GetInventoryItemDurable("player", index);
		if(name ~= nil) then
			if(index == 15 or index == 10) then
				-- 武器
				if((max>100 and durable<max and durable<103) or (durable <= 40 and durable<max)) then
					UseItemByName(Kitty.T("item", "RepairHammer"));	-- リペアハンマー
					PickupEquipmentItem(index);
					Kitty.sendMessage(name .. "[" .. durable .. "]->[" .. max .. "]");
					return true;
				end
			else
				-- 防具
				if((max>100 and durable<=100) or (durable <= 40 and durable<max)) then
					UseItemByName(Kitty.T("item", "RepairHammer"));	-- リペアハンマー
					PickupEquipmentItem(index);
					Kitty.sendMessage(name .. "[" .. durable .. "]->[" .. max .. "]");
					return true;
				end
			end
		end
	end

	Kitty.sendMessage(Kitty.T("message", "RepairMessage2"));
	return true;
end;
Kitty.repair = Kitty.protectFunction(Kitty.repair);	-- 保護モードで実行
Kitty.Repair = Kitty.repair;	-- エイリアス

--------------------------------------------------------------------------------
-- PT再作成
Kitty.previousMemberList = {};
Kitty.remakeParty = function()
	if(Kitty.PartyManager.getPartyState() ~= Kitty.PartyManager.SOLO) then
		-- Party/Raid中
		if(IsShiftKeyDown()) then
			-- 解散
			Kitty.previousMemberList = Kitty.disperseParty();
		else
			assert(Kitty.eventQueue, "Kitty.eventQueue is nil.");
			-- 再編成(解散、招待)
			-- 解散
			Kitty.previousMemberList = Kitty.disperseParty();

			if(#Kitty.previousMemberList > 6) then
				-- ６人より多い人数をPartyに招待するので、Raid構成にする
				assert(Kitty.partyManager, "Kitty.partyManager is nil.");
				Kitty.partyManager:setAutoRaid(Kitty.PartyManager.ONCE);
			end

			-- 招待
			Kitty.eventQueue:addFunction(1000, Kitty.createParty, Kitty.previousMemberList);
		end
	else
		-- Solo
		if(#Kitty.previousMemberList > 6) then
			-- ６人より多い人数をPartyに招待するので、Raid構成にする
			assert(Kitty.partyManager, "Kitty.partyManager is nil.");
			Kitty.partyManager:setAutoRaid(Kitty.PartyManager.ONCE);
		end

		-- 招待
		Kitty.createParty(Kitty.previousMemberList);
	end
end;
Kitty.remakeParty = Kitty.protectFunction(Kitty.remakeParty);	-- 保護モードで実行
Kitty.RemakeParty = Kitty.remakeParty;	-- エイリアス
Kitty.remakeparty = Kitty.remakeParty;	-- エイリアス
-- Party招待
Kitty.createParty = function(memberList)
	for _, name in pairs(memberList) do
		if(name ~= UnitName("player")) then
			InviteByName(name);
		end
	end
end;
-- Party解散
Kitty.disperseParty = function()
	local memberList = Kitty.PartyManager.getMemberList();
	for _, name in pairs(memberList) do
		if(name ~= UnitName("player")) then
			UninviteByName(name);
		end
	end
	return memberList;
end;

--------------------------------------------------------------------------------
-- アイテム検索
Kitty.findItem = function(name) -- アイテム名
	local returnIndex = nil;
	-- アイテム検索
	for index = 1, 180 do
		local inventoryIndex, icon, itemName, itemCount, locked, quality = GetBagItemInfo(index);
		if(itemName == name) then
			returnIndex = inventoryIndex;
			break;
		end;
	end
	return returnIndex;
end;

--------------------------------------------------------------------------------
-- 対象のタゲをとらずにキャスト
Kitty.cast = function(skillName, unitName)	-- スキル名、キャラクタ名
	local unitId = Kitty.PartyManager.searchTarget(unitName);
	if(unitId == nil) then
		unitId = unitName;
	end

	Kitty.SkillManager.castTarget(skillName, unitId);	-- スキル名、ユニットID
end;
Kitty.Cast = Kitty.cast;	-- エイリアス

--------------------------------------------------------------------------------
-- コンボ攻撃
Kitty.isRequest = false;
Kitty.attack = function(...)
	if Kitty.SettingManager.setting.basic.skipTarget then
		local targetHP = UnitHealth("target")
		local condition = targetHP > 0 and UnitCanAttack("player", "target")
		if not condition then
			TargetNearestEnemy()
		end
	end
	if Kitty.SettingManager.setting.basic.useAutoshot then
		Kitty.Autoshot() -- triggers autoshot if main class is ranger
	end	
	local mainClassName, subClassName, mainClass, subClass = Kitty.BuildManager.getClass("player");

	-- 設定変更
	if(IsShiftKeyDown()) then
		Kitty.isRequest = not Kitty.isRequest;
		if(Kitty.isRequest) then
			Kitty.sendMessage(Kitty.T("message", "IsRequestChangeIntoOn"), "DEFAULT", 1, 0, 0);
		else
			Kitty.sendMessage(Kitty.T("message", "IsRequestChangeIntoOff"), "DEFAULT", 1, 0, 0);
		end
		return;
	end

	local args = {...};
	if(#args > 0) then
		-- コマンドリストが指定されている場合
		local commandLists = Kitty.ComboManager.selectCommandListByName(args);
		if(#commandLists == 0) then
			local str = "";
			for index, value in ipairs(args) do
				if(str ~= "") then
					str = str .. ", ";
				end
				str = str .. "[" .. value .. "]";
			end
			Kitty.sendMessage("This command list does not exist." .. str);
			return;
		end

		-- ComboManager
		local comboManager = Kitty.ComboManager(Kitty.slotManager, Kitty.cooldownManager, Kitty.macroManager);
		for index, commandList in ipairs(commandLists) do
			local commandType, commandName = comboManager:check(commandList);
			if(commandType ~= nil) then
				comboManager:cast(commandType, commandName);
				break;
			end
		end
		-- リリース
		comboManager = nil;
	else
		-- コマンドリストが指定されていない場合
		-- スキルテーブル選定
		local commandList, targetState = Kitty.ComboManager.selectCommandList(mainClass, subClass);
		if(commandList == nil) then
			if(Kitty.ComboManager.getTargetState() ~= "none") then
				Kitty.sendMessage(Kitty.format("This command list does not exist. MainClass:[<<1>>], SubClass[<<2>>]", tostring(mainClassName), tostring(subClassName)));
				return;
			else
				-- Negrect
			end
		else
			-- ComboManager
			local comboManager = Kitty.ComboManager(Kitty.slotManager, Kitty.cooldownManager, Kitty.macroManager);
			local commandType, commandName = comboManager:check(commandList);
			comboManager:cast(commandType, commandName);
			-- リリース
			comboManager = nil;
		end
	end
end;
Kitty.attack = Kitty.protectFunction(Kitty.attack);	-- 保護モードで実行
Kitty.Attack = Kitty.attack;	-- エイリアス

--------------------------------------------------------------------------------
-- 遠距離攻撃
Kitty.rangeAttack = function()
	-- スキル情報取得
	local skillManager = Kitty.SkillManager(Kitty.cooldownManager);
	skillManager:update();

	-- 遠距離攻撃
	local skillName = nil;
	local _, _, mainClass, subClass = Kitty.BuildManager.getClass("player");
	-- スカウト用スキル構成
	if(tostring(subClass) == "S") then
		if(skillManager:canCast(Kitty.T("skill", "Vampire Arrows"))) then
			skillName = Kitty.T("skill", "Vampire Arrows");	-- ブラッディアロー
		elseif(skillManager:canCast(Kitty.T("skill", "Shooting"))) then
			skillName = Kitty.T("skill", "Shooting");	-- シューティング
		elseif(skillManager:canCast(Kitty.T("skill", "Shot"))) then
			skillName = Kitty.T("skill", "Shot");	-- ショット
		end
	-- ローグ用スキル構成
	elseif(tostring(mainClass) == "R") then
		if(not Kitty.isAuthor()) then
			if(skillManager:canCast(Kitty.T("skill", "Combo Throw"))) then
				skillName = Kitty.T("skill", "Combo Throw");	-- シークエンススロー
			elseif(skillManager:canCast(Kitty.T("skill", "Throw"))) then
				skillName = Kitty.T("skill", "Throw");	-- スローイング
			end
		else
			if(skillManager:canCast(Kitty.T("skill", "Kanches' Rend"))) then
				skillName = Kitty.T("skill", "Kanches' Rend");	-- カンチェスティア
			elseif(skillManager:canCast(Kitty.T("skill", "Phantom Stab"))) then
				skillName = Kitty.T("skill", "Phantom Stab");	-- シャドーアサルト
			elseif(skillManager:canCast(Kitty.T("skill", "Shadow Step"))) then
				skillName = Kitty.T("skill", "Shadow Step");	-- バッククリープ
			elseif(skillManager:canCast(Kitty.T("skill", "Combo Throw"))) then
				skillName = Kitty.T("skill", "Combo Throw");	-- シークエンススロー
			elseif(skillManager:canCast(Kitty.T("skill", "Throw"))) then
				skillName = Kitty.T("skill", "Throw");	-- スローイング
			end
		end
	else
		Kitty.sendMessage("Unsupported class. (use is possible, only when a subclass is Scout and main class is Rogue)");
	end

	skillManager:cast(skillName);
	skillManager = nil;
end;
Kitty.rangeAttack = Kitty.protectFunction(Kitty.rangeAttack);	-- 保護モードで実行
Kitty.RangeAttack = Kitty.rangeAttack;	-- エイリアス
Kitty.rangeattack = Kitty.rangeAttack;	-- エイリアス

--------------------------------------------------------------------------------
-- まとめ買い開始
Kitty.startBigShop = function()
	-- まとめ買い(ALTdeBBのShiftKey版)
	local overrideFunc = function(orgFunc, ...)
		if(STOREFRAME_CURRENT_TAB == "SELL") then
			local this, key = ...;
			if(key == "RBUTTON" and IsShiftKeyDown()) then
				-- アイテム情報取得
				local index = this:GetParent().index;
				local icon, name, price, moneyType, count, stock, maxHeap, secondPrice, secondMoneyType = GetStoreSellItemInfo(index);

				if(price > 0 and moneyType == 0 and secondMoneyType == 0) then
					local heap = math.floor(GetPlayerMoney("copper") / price);
					if(heap > maxHeap) then
						heap = maxHeap;
					end

					if(heap > 0) then
						StoreBuyItem(index, heap);
						Kitty.sendMessage(Kitty.T("message", "BulkPurchase", Kitty.colorCyan(name)));
						return;
					end
				end
			end
		end

		return orgFunc(...);
	end;
	-- Hook
	StoreItemButton_OnClick = Kitty.HookManager.override(StoreItemButton_OnClick, overrideFunc);
end;
-- まとめ買い終了
Kitty.endBigShop = function()
	-- Hook解除
	if(StoreItemButton_OnClick ~= nil and type(StoreItemButton_OnClick) == "table" and StoreItemButton_OnClick.getOriginalFunction ~= nil) then
		StoreItemButton_OnClick = StoreItemButton_OnClick:getOriginalFunction();
	end
end;
Kitty.startBigShop();

--------------------------------------------------------------------------------
-- 関数
Kitty.onVariablesChanged = function(setting)
	if(Kitty.combatManager ~= nil) then
		-- 表示設定
		Kitty.combatManager:setShowDamageDoneThreshold(setting.basic.showDamageDoneThreshold);
		Kitty.combatManager:setShowDamageTakenThreshold(setting.basic.showDamageTakenThreshold);
		Kitty.combatManager:setShowDPSType(setting.basic.showDPSType);

		-- Party状態更新
		Kitty.setPartyState();
	end
end;

--------------------------------------------------------------------------------
Kitty.preCastList = {
	[Kitty.T("skill", "Combat Master")] =			{["threshold"]= 0.0},	-- RS:ファイティングマスター
	[Kitty.T("skill", "Yawaka's Blessing")] =		{["threshold"]=20.0},	-- R:ヤワカの祝福(スーツスキル)
--	[Kitty.T("skill", "Premeditation")] =			{["threshold"]= 0.0},	-- R:背後からの一撃
	[Kitty.T("skill", "Essence of Magic")] =		{["threshold"]=20.0},	-- M:シークレットマジック
	[Kitty.T("skill", "Enhanced Armor")] =			{["threshold"]=20.0},	-- K:オーラアーマー
	[Kitty.T("skill", "Holy Seal")] =				{["threshold"]=20.0},	-- K:ホーリーサイン
--	[Kitty.T("skill", "Amplified Attack")] =		{["threshold"]=20.0},	-- P:アタックブースト
	[Kitty.T("skill", "Grace of Life")] =			{["threshold"]=20.0, ["isFunc"]=function(playerBuffManager, skillManager)
																			return not playerBuffManager:hasEffect(Kitty.T("skill", "Grace of Life"));
																		end},	-- P:ベネフィットライフ
	[Kitty.T("skill", "Angel's Blessing")] =		{["threshold"]=20.0},	-- PM:天使の祝福
	[Kitty.T("skill", "Enhanced Grace of Life")] =	{["threshold"]=20.0},	-- PK:ベネフィットライフ・ブースト
--	[Kitty.T("skill", "Awakening of the Wild D")] =	{["threshold"]=20.0},	-- DW:ワイルドアウェイク
};
-- 事前バフ(自分のみ)
Kitty.preCast = function(playerBuffManager, skillManager)
	for skillName, element in pairs(Kitty.preCastList) do
		if(skillManager:isAvailable(skillName)) then
			if(not playerBuffManager:hasEffect(skillName, element.threshold)) then
				if(element.isFunc ~= nil) then
					if(not element.isFunc(playerBuffManager, skillManager)) then
						break;
					end
				end

				-- Buffなし
				if(skillManager:canCast(skillName)) then
					if(UnitIsUnit("target", "player")) then
						skillManager:cast(skillName);
					else
						Kitty.SkillManager.castTarget(skillName, "player");
					end
					return true, skillName;
				end
			end
		end
	end
	return false, "";
end;

--------------------------------------------------------------------------------
-- ヘルプ(メニュー)
Kitty.helpHelp = function()
	-- 対応ビルド
	local str = "";
	local list = Kitty.ComboManager.getSupportedClass(Kitty.SettingManager.setting.command);
	for index = 1, #list do
		if(str ~= "") then
			str = str .. ", ";
		end
		str = str .. "[" .. list[index] .. "]";
	end

	-- 【ヘルプ一覧】
	local messageType = "DEFAULT";
	Kitty.sendMessage(Kitty.T("message", "HelpTitle"), messageType);
	Kitty.sendMessage(Kitty.T("message", "Help01") .. " " .. Kitty.color("/kc help", 255, 255, 255), messageType);
	Kitty.sendMessage(Kitty.T("message", "Help02") .. " " .. Kitty.color("/kc function", 255, 255, 255), messageType);
	Kitty.sendMessage(Kitty.T("message", "Help03") .. " " .. Kitty.color("/kc macro", 255, 255, 255), messageType);
	Kitty.sendMessage(Kitty.T("message", "Help04", "/kc") .. " " .. Kitty.color("/kc RS", 255, 255, 255), messageType);
	Kitty.sendMessage(Kitty.T("message", "Help05") .. " " .. Kitty.color("/kc show", 255, 255, 255), messageType);
	Kitty.sendMessage(Kitty.T("message", "Help06") .. " " .. Kitty.color("/kc grad", 255, 255, 255), messageType);
	Kitty.sendMessage(Kitty.T("message", "Help07") .. " " .. Kitty.color("/kcg [Message]", 255, 255, 255), messageType);
	Kitty.sendMessage(Kitty.T("message", "Help08") .. " " .. Kitty.color("/kc history", 255, 255, 255), messageType);
	Kitty.sendMessage(Kitty.T("message", "Help09"), messageType, 1, 1, 1);
	Kitty.sendMessage(str, messageType, 1, 1, 1);
end;

--------------------------------------------------------------------------------
-- ヘルプ(機能一覧)
Kitty.functionHelp = function()
	-- 【主な機能一覧】
	local messageType = "DEFAULT";
	Kitty.sendMessage(Kitty.T("message", "FunctionTitle"), messageType);
	Kitty.sendMessage(Kitty.T("message", "Function01") .. " " .. Kitty.color("Kitty.attack(), Kitty.rangeAttack()", 255, 255, 255), messageType);
	Kitty.sendMessage(Kitty.T("message", "Function02") .. " " .. Kitty.color("Kitty.repair()", 255, 255, 255), messageType);
	Kitty.sendMessage(Kitty.T("message", "Function03") .. " " .. Kitty.color("Kitty.checkBuff()", 255, 255, 255), messageType);
	Kitty.sendMessage(Kitty.T("message", "Function04") .. " " .. Kitty.color("Kitty.remakeParty()", 255, 255, 255), messageType);
	Kitty.sendMessage(Kitty.T("message", "Function05"), messageType);
	Kitty.sendMessage(Kitty.T("message", "Function06"), messageType);
	Kitty.sendMessage(Kitty.T("message", "Function07"), messageType);
	Kitty.sendMessage(Kitty.T("message", "Function08"), messageType);
	Kitty.sendMessage(Kitty.T("message", "Function09"), messageType);
	Kitty.sendMessage(Kitty.T("message", "Function10"), messageType);
	Kitty.sendMessage(Kitty.T("message", "Function11"), messageType);
	Kitty.sendMessage(Kitty.T("message", "Function12"), messageType);
end;

--------------------------------------------------------------------------------
-- ヘルプ(マクロ一覧)
Kitty.macroHelp = function()
	-- 【マクロ一覧】
	local messageType = "DEFAULT";
	Kitty.sendMessage(Kitty.T("message", "MacroTitle"), messageType);
	Kitty.sendMessage(Kitty.T("message", "Macro01"), messageType);
	Kitty.sendMessage("/run Kitty.attack();", messageType, 1, 1, 1);
--	Kitty.sendMessage(Kitty.T("message", "Macro02"), messageType);
--	Kitty.sendMessage("/run Kitty.rangeAttack();" .. " " .. Kitty.colorRed(Kitty.T("message", "Macro03")), messageType, 1, 1, 1);
--	Kitty.sendMessage(Kitty.T("message", "Macro04", [[/run Kitty.attack("RangeAttack")]]), messageType, 1, 1, 1);
	Kitty.sendMessage(Kitty.T("message", "Macro05"), messageType);
	Kitty.sendMessage("/run Kitty.repair();", messageType, 1, 1, 1);
	Kitty.sendMessage(Kitty.T("message", "Macro06"), messageType);
	Kitty.sendMessage("/run Kitty.checkBuff();", messageType, 1, 1, 1);
	Kitty.sendMessage(Kitty.T("message", "Function04"), messageType);
	Kitty.sendMessage("/run Kitty.remakeParty();", messageType, 1, 1, 1);
	Kitty.sendMessage(Kitty.T("message", "Macro07"), messageType);
end;

--------------------------------------------------------------------------------
-- ヘルプ(グラデーション設定)
Kitty.colorList = {
	["R"] = {["r"]=255, ["g"]=  0, ["b"]=  0},
	["G"] = {["r"]=  0, ["g"]=255, ["b"]=  0},
	["B"] = {["r"]=  0, ["g"]=  0, ["b"]=255},
	["C"] = {["r"]=  0, ["g"]=255, ["b"]=255},
	["M"] = {["r"]=255, ["g"]=  0, ["b"]=255},
	["Y"] = {["r"]=255, ["g"]=255, ["b"]=  0},
	["W"] = {["r"]=255, ["g"]=255, ["b"]=255},
	["A"] = {["r"]=128, ["g"]=128, ["b"]=128},
	["K"] = {["r"]=  0, ["g"]=  0, ["b"]=  0},
};
Kitty.messgeTypeList = {
	["SAY"] = true,
	["ZONE"] = true,
	["YELL"] = true,
	["GUILD"] = true,
	["PARTY"] = true,
	["DEFAULT"] = true,
};
Kitty.gradationHelp = function(message)
	-- 設定情報取得
	local color = nil;
	local messageType = nil;
	if(message ~= nil and message ~= "") then
		message = string.gsub(message, " +", " ");
		message = string.trim(message);

		local list = string.split(message, " ");
		for index = 1, #list do
			if(string.lower(list[index]) == "grad") then
				-- 色情報
				if(list[index+1] ~= nil and list[index+1] ~= "") then
					color = list[index+1];
				end
				-- 送信先メッセージタイプ
				if(list[index+2] ~= nil and list[index+2] ~= "") then
					messageType = list[index+2];
				end

				break;
			end
		end
	end

	if(color == nil) then
		-- ヘルプを表示(設定情報なし)
		local messageType = "DEFAULT";
		-- 【グラデーション設定】
		Kitty.sendMessage(Kitty.T("message", "GradationTitle"), messageType);
		Kitty.sendMessage(Kitty.T("message", "Gradation01"), messageType);
		Kitty.sendMessage("/kc grad [S][E] [messageType]", messageType, 1, 1, 1);
		Kitty.sendMessage("  " .. "Ex) /kc grad BW SAY", messageType, 1, 1, 1);
		Kitty.sendMessage("  " .. Kitty.T("message", "Gradation02"), messageType, 1, 1, 1);
		Kitty.sendMessage("  " .. Kitty.T("message", "Gradation03"), messageType, 1, 1, 1);
		Kitty.sendMessage("  " ..
						"R:" .. Kitty.colorRed(Kitty.T("message", "ColorRed")) .. ", " ..
						"G:" .. Kitty.colorGreen(Kitty.T("message", "ColorGreen")) .. ", " ..
						"B:" .. Kitty.colorBlue(Kitty.T("message", "ColorBlue")) .. ", " ..
						"C:" .. Kitty.colorCyan(Kitty.T("message", "ColorCyan")) .. ", " ..
						"M:" .. Kitty.colorMagenta(Kitty.T("message", "ColorMagenta")) .. ", " ..
						"Y:" .. Kitty.colorYellow(Kitty.T("message", "ColorYellow")) .. ", " ..
						"W:" .. Kitty.colorWhite(Kitty.T("message", "ColorWhite")) .. ", " ..
						"A:" .. Kitty.colorGray(Kitty.T("message", "ColorGray")) .. ", " ..
						"K:" .. Kitty.colorBlack(Kitty.T("message", "ColorBlack")), messageType, 1, 1, 1);
		Kitty.sendMessage("  " .. Kitty.T("message", "Gradation04"), messageType, 1, 1, 1);
		Kitty.sendMessage("  " .. Kitty.T("message", "Gradation05"), messageType, 1, 1, 1);
		Kitty.sendMessage("  " .. "SAY、ZONE、YELL、GUILD、PARTY、DEFAULT", messageType, 1, 1, 1);
		Kitty.sendMessage("  " .. Kitty.T("message", "Gradation06"), messageType, 1, 1, 1);
		Kitty.sendMessage(Kitty.T("message", "Gradation07"), messageType);
		Kitty.sendMessage("/kcg " .. Kitty.T("message", "Gradation08"), messageType, 1, 1, 1);
		Kitty.sendMessage(Kitty.T("message", "Gradation09"), messageType);
		Kitty.sendMessage("/kcg", messageType, 1, 1, 1);
	else
		-- 設定情報を保存(設定情報あり)
		-- 色情報
		local strStart = string.upper(string.sub(color, 1, 1));
		local strEnd = string.upper(string.sub(color, 2, 2));

		local startColor = Kitty.colorList[strStart];
		local endColor = Kitty.colorList[strEnd];
		if(startColor ~= nil and endColor ~= nil) then
			Kitty.SettingManager.setting.gradation.startR = startColor.r
			Kitty.SettingManager.setting.gradation.startG = startColor.g
			Kitty.SettingManager.setting.gradation.startB = startColor.b
			Kitty.SettingManager.setting.gradation.endR = endColor.r
			Kitty.SettingManager.setting.gradation.endG = endColor.g
			Kitty.SettingManager.setting.gradation.endB = endColor.b

			-- 送信先メッセージタイプ
			if(messageType ~= nil and messageType ~= "") then
				if(Kitty.messgeTypeList[string.upper(messageType)] ~= nil) then
					Kitty.SettingManager.setting.gradation.messageType = string.upper(messageType);
				else
					-- 送信先メッセージタイプエラー
					Kitty.sendMessage(Kitty.T("message", "NotExistChannelMessage", tostring(messageType)));
					return;
				end
			end
		else
			-- 色指定エラー
			Kitty.sendMessage(Kitty.T("message", "NotExistColorMessage", tostring(color)), "DEFAULT", 1, 0, 0);
			return;
		end

		-- 設定結果表示
		if(messageType ~= nil and messageType ~= "") then
			Kitty.sendMessage(Kitty.T("message", "SettingCompleteMessage", tostring(strStart) .. tostring(strEnd), tostring(string.upper(messageType))));
		else
			Kitty.sendMessage(Kitty.T("message", "SettingCompleteMessage", tostring(strStart) .. tostring(strEnd), tostring(Kitty.SettingManager.setting.gradation.messageType)));
		end
	end
end;

--------------------------------------------------------------------------------
-- ヘルプ(変更履歴一覧)
Kitty.historyHelp = function()
	-- 【最近の主な修正】
	local messageType = "DEFAULT";
	Kitty.sendMessage("[Latest main modification.]", messageType);
	Kitty.sendMessage(Kitty.color("At version:" .. tostring(Kitty.VERSION), 255, 255, 255), messageType);
	Kitty.sendMessage("- Dalaqua, 10.09.2021", messageType);	
	Kitty.sendMessage("- #Setskills over lvl 70 old classes, Warlock and Champion added with duration time", messageType);
	Kitty.sendMessage("- #Setskills some work without a shortcut and cooldown is working without condition", messageType);	
	Kitty.sendMessage("- #but, if setskill is not working use shortcut and condition use.", messageType);
	Kitty.sendMessage("- #Autoshoot function for Scout added, check or uncheck on main page if needed ", messageType);	
	Kitty.sendMessage("- #For Warden, Condition Playerpet is summond or not added to be able to use skill that work only if pet is summond  ", messageType);
	Kitty.sendMessage("- #Reworked the Info / Help messages some Infos seemed to be not so good translated, from original Japan ", messageType);
	Kitty.sendMessage("- #glued the language translations (locals) together, not finished, some help needed ", messageType);
	Kitty.sendMessage("- #Reworked the Original Skill Conditions, erased the Japan, not working and renewed the IDs, not finished ", messageType);
	Kitty.sendMessage(Kitty.color("At version:0.972", 255, 255, 255), messageType);
	Kitty.sendMessage("...", messageType);		
	Kitty.sendMessage(Kitty.color("At version:0.971", 255, 255, 255), messageType);
	Kitty.sendMessage("- targethealth and targetdebuffcounter function added", messageType);	
	Kitty.sendMessage(Kitty.color("At version:0.9xx", 255, 255, 255), messageType);
	Kitty.sendMessage("- Fixed: Bug of initialize button.", messageType);
	Kitty.sendMessage(Kitty.color("At version:0.946", 255, 255, 255), messageType);
	Kitty.sendMessage("- Show messsage when Lv75ID 5th Boss calls party menber name.", messageType);
	Kitty.sendMessage("- Changed: auto-target function is available, when pet skip function is enabled.", messageType);
	Kitty.sendMessage("- Changed: 40 durability or less equipment might be repaired. Changed high durable weapon might be repaired always.", messageType);
	Kitty.sendMessage([[- The log of area event information was displayed by "/kc event."]], messageType);
	Kitty.sendMessage("- Chagend: Pet of centaur is not targetted by pet skip function.", messageType);
	Kitty.sendMessage([[- Fixed: the issue which ToolTip does not shown when using "Kitty.attack" macro.]], messageType);
	Kitty.sendMessage([[- Added: "canUse" which is triggering conditions whether player can use shortcut item.]], messageType);
	Kitty.sendMessage("- ###Need Help### with Knight/Warrior, Knight Skill -Bestrafung- Warrior Setskill -Bestrafung- they have the same name in german  ", messageType);
	Kitty.sendMessage("- ###Need Help### Kitty always tries to take the Warrior Setskill if you play Knight  ", messageType);

	Kitty.sendMessage(Kitty.color("At version:0.929", 255, 255, 255), messageType);
	Kitty.sendMessage("- Multi-language is supported.", messageType);
	Kitty.sendMessage("- The initial value of isRequest is changed into off.", messageType);
	Kitty.sendMessage("- Ss(Warlock): The defect which could not detect [Sublimation Weave Curse] buff is revised.", messageType);
	Kitty.sendMessage("- W(Warrior): The defect which could not execute [Undefeatable King] is revised.", messageType);
	Kitty.sendMessage("- Remove guild CG limitation. Player can attack all guild in CG.", messageType);
	Kitty.sendMessage("- Add: Command List of McR, WS", messageType);

--[[
	Kitty.sendMessage(Kitty.color("◇0.922にて", 255, 255, 255), messageType);
	Kitty.sendMessage("- PM 共通コマンドは、プレイヤーが硬直していないときのみ利用するよう変更。", messageType);
	Kitty.sendMessage("- PM ホーリーチェインを初期値に追加。", messageType);
	Kitty.sendMessage("- PKのスキル回しを追加。", messageType);
	Kitty.sendMessage("- Dのスキル回しを追加。", messageType);

	Kitty.sendMessage(Kitty.color("◇0.920にて", 255, 255, 255), messageType);
	Kitty.sendMessage("- 発動条件で複数バフを指定した場合、and条件となるよう変更。or条件はコマンドを複数指定することで設定可能。", messageType);
	Kitty.sendMessage("- K、Sは自動ルートしないよう初期値を変更。", messageType);
	Kitty.sendMessage("- WKペインディスリガードを発動するよう初期値を変更。", messageType);
	Kitty.sendMessage("- R用RangeAttackを初期値に追加。", messageType);
	Kitty.sendMessage("- 自動ポーション設定を初期値に追加(無効状態)。", messageType);
	Kitty.sendMessage("- 自動ドロップ設定を初期値に追加(無効状態)。", messageType);
	Kitty.sendMessage("- Exスキルが発動しにくい不具合を修正。", messageType);

	Kitty.sendMessage(Kitty.color("◇0.918にて", 255, 255, 255), messageType);
	Kitty.sendMessage("- スキル回しを設定する機能を追加。", messageType);
	Kitty.sendMessage("- グラデーション表示機能を追加。", messageType);
	Kitty.sendMessage("- AddonManager対応。", messageType);
	Kitty.sendMessage("- 設定画面を表示するためのミニマップボタンを追加。", messageType);
	Kitty.sendMessage("- マジックトリックなど、ExtraActionを利用できるよう変更。", messageType);
	Kitty.sendMessage("- IDの難易度を設定する機能に、None(変更しない)を追加。", messageType);
	Kitty.sendMessage("- R スキル回しに、ハーツアヴォイドを追加。", messageType);

	Kitty.sendMessage(Kitty.color("◇0.851にて", 255, 255, 255), messageType);
	Kitty.sendMessage("- 基本設定を変更できるよう設定画面を追加。 /kc show", messageType);
	Kitty.sendMessage("- Wd、WdS、WdWのスキル実行順を変更", messageType);
	Kitty.sendMessage("- IDの難易度、サイコロの設定機能を追加", messageType);
	Kitty.sendMessage("- Party招待、再編成機能を追加", messageType);
	Kitty.sendMessage("- checkBuff() Ssがいるときは、クラスアップスペルの有無を表示するよう変更", messageType);
	Kitty.sendMessage("- rangeAttack() Rの遠距離攻撃を追加", messageType);
	Kitty.sendMessage("- ShiftKeyを押しながら購入することで、まとめ買いする機能を追加", messageType);
	Kitty.sendMessage("- イベントコードを自動変換する機能を追加。" .. Kitty.colorCyan("YossyE") .. "さん、ありがとう～", messageType);

	Kitty.sendMessage(Kitty.color("◇0.777にて", 255, 255, 255), messageType);
	Kitty.sendMessage("- [パルプ○テ]と発言したPartyMemberへリーダーを譲与する機能を追加。", messageType);
	Kitty.sendMessage("- 全員へアシストを配布する機能を追加。", messageType);
	Kitty.sendMessage("- S、SKのスキルを追加", messageType);
	Kitty.sendMessage("- M 自分が無敵のときはサイレンスをうたないよう変更", messageType);
	Kitty.sendMessage("- WR スキルの優先順を変更。ダブルアタックを削除", messageType);
	Kitty.sendMessage("- MK、MP 対人のときはサンダーボールを使うよう変更", messageType);
	Kitty.sendMessage("- MK、PM 相手との距離により、サンダー召喚を撃つように変更", messageType);
	Kitty.sendMessage("- KS ホーリーヘイト > ヘイトアタック > シルブラ > ホリソの順に変更", messageType);
	Kitty.sendMessage("- 自動追尾時に「～さん呼ばれましたよ」と表示される不具合を修正", messageType);

	Kitty.sendMessage(Kitty.color("◇0.766にて", 255, 255, 255), messageType);
	Kitty.sendMessage("- 改定履歴を参照できるよう、ヘルプに機能を追加", messageType);
	Kitty.sendMessage("- WK 片手装備のときディフェンスダウンを連打するよう修正", messageType);
	Kitty.sendMessage("- W、WK サバイバルオーラを追加", messageType);
	Kitty.sendMessage("- W ブロウを連打するよう修正", messageType);
	Kitty.sendMessage("- KS ヘイトアタックを追加、円弧斬、ムーンスラッシュを除外", messageType);
	Kitty.sendMessage("- MP、MK、PM 相手がホーリーライトガードのときはサンダー召喚を撃たないよう変更", messageType);
	Kitty.sendMessage("- 自動ルート機能を一時的に廃止", messageType);

	Kitty.sendMessage(Kitty.color("◇0.764にて", 255, 255, 255), messageType);
	Kitty.sendMessage("- ヘルプ機能を追加", messageType);
	Kitty.sendMessage("- マウスオーバーでターゲティング(CG中のみ)", messageType);
	Kitty.sendMessage("- 不評のため、事前バフを廃止", messageType);
	Kitty.sendMessage("- CG中の門など、監視対象がきえる不具合を修正(事前バフ廃止により対応)", messageType);
	Kitty.sendMessage("- ベネフィットライフ・ブーストがあるとベネを詠唱し続ける不具合を修正(事前バフ廃止により対応)", messageType);
	Kitty.sendMessage("- 特定のフィアレスを検知できない不具合を修正", messageType);
--]]
end;

--------------------------------------------------------------------------------
-- ヘルプ(エリアイベント一覧)
Kitty.showAreaEventLog = function(list)
	if(list and #list > 0) then
		Kitty.sendMessage(Kitty.T("message", "AreaEvent01"));
		for index, value in ipairs(list) do
			Kitty.sendMessage(value);
		end
	else
		Kitty.sendMessage(Kitty.T("message", "AreaEventMessage"));
	end
end;

--------------------------------------------------------------------------------
-- ヘルプ(対応ビルドのコマンドリスト一覧)
Kitty.commandHelp = function(className)
	-- 【スキル一覧】
	local messageType = "DEFAULT";
	Kitty.sendMessage(Kitty.T("message", "SkillTitle"), messageType);
	Kitty.sendMessage(Kitty.T("message", "Skill01", className), messageType);
	Kitty.sendMessage(Kitty.ComboManager.showHelp(Kitty.SettingManager.setting.command, className), messageType);
end;

--------------------------------------------------------------------------------
-- 実行エリア
(function()
	-- ヘルプコマンド用
	local showHelp = function(editBox, message)
		Kitty.debugPrint(editBox, message);

		local messageType = "DEFAULT";
		Kitty.sendMessage("--- KittyCombo Version:[" .. tostring(Kitty.VERSION) .. "] --------------------", messageType, 1, 1, 1);

		if(message == nil or message == "") then
			Kitty.helpHelp();
		else
			if(string.find(string.lower(message), "help")) then
				Kitty.helpHelp();
			elseif(string.find(string.lower(message), "function")) then
				Kitty.functionHelp();
			elseif(string.find(string.lower(message), "macro")) then
				Kitty.macroHelp();
			elseif(string.find(string.lower(message), "grad")) then
				Kitty.gradationHelp(message);
			elseif(string.find(string.lower(message), "history")) then
				Kitty.historyHelp();
			elseif(string.find(string.lower(message), "show")) then
				if(KittyBasicConfigFrame:IsVisible()) then
					KittyBasicConfigFrame:Hide();
				else
					KittyBasicConfigFrame:Show();
					if(Kitty.SettingManager.setting.window ~= nil and Kitty.SettingManager.setting.window.showMinimap ~= nil) then
						Kitty.SettingManager.setting.window.showMinimap = true;
						KittyMinimap:Show();
					end
				end
			elseif(string.find(string.lower(message), "event")) then
				Kitty.showAreaEventLog(Kitty.areaEventList);
			elseif(string.find(string.lower(message), "date")) then
				if(os and os.date) then
					Kitty.sendMessage(os.date("%Y/%m/%d %H:%M:%S"));
				end
			else
				-- 対応ビルド判定
				if(Kitty.ComboManager.isSupportedClass(Kitty.SettingManager.setting.command, message)) then
					Kitty.commandHelp(message);
				else
					Kitty.sendMessage(Kitty.T("message", "NotExistSettingMessage", message), messageType, 1, 0, 0);
				end
			end
		end
	end;
	-- スラッシュコマンド
	SLASH_KittyCombo1 = "/KittyCombo";
	SLASH_KittyCombo2 = "/kc";
	SlashCmdList["KittyCombo"] = Kitty.protectFunction(showHelp);

	-- カラー文字表示コマンド用
	local showGradation = function(editBox, message)
		Kitty.debugPrint(editBox, message);

		if(message == nil or message == "") then
			-- 設定値を表示
			local str = Kitty.colorGradation(Kitty.T("message", "GradationSettingMessage", Kitty.SettingManager.setting.gradation.messageType),
											Kitty.SettingManager.setting.gradation.startR,
											Kitty.SettingManager.setting.gradation.startG,
											Kitty.SettingManager.setting.gradation.startB,
											Kitty.SettingManager.setting.gradation.endR,
											Kitty.SettingManager.setting.gradation.endG,
											Kitty.SettingManager.setting.gradation.endB);
			Kitty.sendMessage(str);
		else
			local str = Kitty.colorGradation(Kitty.ComboManager.formatMessage(tostring(message)),
											Kitty.SettingManager.setting.gradation.startR,
											Kitty.SettingManager.setting.gradation.startG,
											Kitty.SettingManager.setting.gradation.startB,
											Kitty.SettingManager.setting.gradation.endR,
											Kitty.SettingManager.setting.gradation.endG,
											Kitty.SettingManager.setting.gradation.endB);
			Kitty.sendMessage(str, Kitty.SettingManager.setting.gradation.messageType);
		end
	end;
	-- スラッシュコマンド
	SLASH_KittyComboGradation1 = "/KittyComboGradation";
	SLASH_KittyComboGradation2 = "/kcg";
	SlashCmdList["KittyComboGradation"] = Kitty.protectFunction(showGradation);
end)();

--------------------------------------------------------------------------------
Kitty.foreach = function(list, func)
	for key, value in pairs(list) do
		if(func(key, value) == false) then	-- nilは処理継続
			break;
		end
	end
end;
Kitty.showKeyList = function(list)
	Kitty.foreach(list, function(key, value)
		Kitty.sendMessage("[" .. tostring(key) .. "]");
	end);
end;

--------------------------------------------------------------------------------
-- For Test
Kitty.test = function(target)
	Kitty.print("KittyCombo Version:[" .. tostring(Kitty.VERSION) .. "]");

	if(UnitName(target) == nil) then
		target = "player";
	end

	-- バフ・デバフ管理クラス
	Kitty.buff = Kitty.BuffManager();
	Kitty.buff:update(target);
	-- スキル情報取得
	Kitty.skill = Kitty.SkillManager(Kitty.cooldownManager);
	Kitty.skill:update();

	-- 戦闘管理クラス
	-- パーティー管理クラス
	-- ショートカット情報
	-- クールダウン管理クラス
	-- ExtraActionクラス
--	Kitty.extra = Kitty.ExtraAction();

	-- コマンド管理クラス
	Kitty.combo = Kitty.ComboManager(Kitty.slotManager, Kitty.cooldownManager, Kitty.macroManager);
end;
