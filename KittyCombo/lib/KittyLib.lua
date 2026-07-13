-- (C) 2012-2013 Miranda
--------------------------------------------------------------------------------
-- 名前空間作成
if(_G and not _G.Kitty) then
	_G.Kitty = {};
end
--------------------------------------------------------------------------------
-- 定数
Kitty.MAX_VALUE = 100000000.0;

--------------------------------------------------------------------------------
-- 汎用関数

-- デバッグ用関数
Kitty.isDebugFlag = false;
-- Debugモード判定
Kitty.isDebug = function(isDebugFlag)
	if(isDebugFlag ~= nil) then
		Kitty.isDebugFlag = isDebugFlag;
	end
	return Kitty.isDebugFlag;
end;
-- 表示関数(Debug用)
Kitty.debugPrint = function(...)
	if(Kitty.isDebug()) then
		Kitty.print(...);
	end
end;

-- 保護モード
Kitty.protectFunction = function(func)
	return function(...)
		return Kitty.pcall(func, ...);
	end
end;
Kitty.pcall = function(func, ...)
	-- 保護モードで実行
	local resultList = {pcall(func, ...)};
	if(resultList[1]) then
		return unpack(resultList, 2);
	else
		-- Error
		Kitty.sendMessage(resultList[2], "DEFAULT", 1, 0, 0);
		return nil;
	end
end;
-- インスタンスをクロージャに隠蔽
Kitty.bind = function(instance, func)
	return function(...)
		return func(instance, ...);
	end
end;
-- 表示関数
Kitty.print = function(...)
	if(select("#", ...) == 0) then
		Kitty.sendMessage("<none>");
	else
		local str = "";
		for index = 1, select("#", ...) do
			if(str ~= "") then
				str = str .. " / ";
			end

			local arg = select(index, ...);
			str = str .. Kitty.dump(arg);
		end
		Kitty.sendMessage(str);
	end
end;
Kitty.print = Kitty.protectFunction(Kitty.print);	-- 保護モードで実行
-- 出力関数
Kitty.sendMessage = function(message, messageType, r, g, b, indent)
	if(indent == nil) then
		indent = 0;
	end

	if(type(message) == "table") then
		for _, str in ipairs(message) do
			Kitty.sendMessage(str, messageType, r, g, b, indent+1);	-- 再帰呼出し
		end
	else
		-- インデント付与
		local blank = "";
		for index=1, indent-1 do
			blank = blank .. "    ";
		end
		message = blank .. message;

		if(messageType == nil or string.upper(messageType) == "DEFAULT") then
			if(DEFAULT_CHAT_FRAME ~= nil and DEFAULT_CHAT_FRAME.AddMessage ~= nil) then
				if(r == nil or g == nil or b == nil) then
					DEFAULT_CHAT_FRAME:AddMessage(message);
				else
					DEFAULT_CHAT_FRAME:AddMessage(message, r, g, b);
				end
			else
				print(message);
			end
		else
			if(Kitty.eventQueue ~= nill) then
				local executeTime = Kitty.eventQueue:getEndExecuteTime();
				local estimatedTime = 0;
				if(executeTime == nil) then
					estimatedTime = 0;
				else
					estimatedTime = (executeTime - Kitty.getTime())*1000 + 500;	-- 500[mSec]間隔
				end

				if(SendChatMessage ~= nil) then
					Kitty.eventQueue:addFunction(estimatedTime, SendChatMessage, message, messageType);
				else
					Kitty.eventQueue:addFunction(estimatedTime, print, message);
				end
			else
				if(SendChatMessage ~= nil) then
					SendChatMessage(message, messageType);
				else
					print(message);
				end
			end
		end
	end
end;
-- ダンプ
Kitty.dump = function(data, nest)
	-- 再帰呼出しのネストを制御
	if(nest == nil) then
		nest = 0;
	else
		nest = nest + 1;
	end
	-- ネストの深さをチェック
	if(nest ~= nil and nest > 1000) then
		error("Error: Stack overflow. Data:[" .. tostring(data) .. "], Index:[" .. tostring(nest) .. "]");
	end

	local line = "";
	if(type(data) == "string") then
		if(data == "") then
			line = "<blank>";
		else
			line = tostring(data);
		end
	elseif(type(data) == "table") then
		-- 配列
		local meta = getmetatable(data);
		if(meta ~= nil and meta.__tostring ~= nil) then
			line = tostring(data);
		elseif(next(data) == nil) then
			line = "<empty>";
		else
			for key, value in pairs(data) do
				if(line ~= "") then
					line = line .. ", ";
				end

				if(type(key) == "string" and key:sub(1, 2) == "__") then
					-- メタテーブルへ設定する情報と思われるものは、循環参照するので、詳細は表示しない。
					line = line .. "[" .. key .. "]:[" .. type(value) .. "]"
				else
					line = line .. "[" .. Kitty.dump(key, nest) .. "]:[" .. Kitty.dump(value, nest) .. "]";	-- 再帰呼出し
				end
			end
		end
	else
		-- nil、数値、ブーリアン型、function
		line = tostring(data);
	end

	return line;
end;

--------------------------------------------------------------------------------
-- デバッグ用関数
-- エラー発生関数
Kitty.error = function(errorMessage)
	Kitty.printStackTrace(Kitty.getStackTrace(3));
	error(errorMessage, 2);
end;
-- スタックトレース情報の取得
Kitty.getStackTrace = function(level)
	if(debug == nil) then
		error("Error: getStackTrace function does not support for debug mode.");
	end

	local debugInfoList = {};

	if(level == nil) then
		level = 2;	-- 0:debug.getinfo()、1:Kitty.getStackTrace()
	end
	while(true) do
		local debugInfo = debug.getinfo(level);
		if(debugInfo ~= nil) then
			table.insert(debugInfoList, debugInfo);
			level = level + 1;
		else
			return debugInfoList;
		end
	end
end;
Kitty.formatStackTrace = function(debugInfo)
	-- 関数名
	local message = debugInfo.name;
	if(message ~= nil) then
		message = message .. "[" .. debugInfo.what .. "]";
	else
		message = debugInfo.what;
	end

	-- ファイル名
	local fileName = nil;
	if(debugInfo.currentline >= 0) then
		message = message .. "(" .. debugInfo.short_src .. ":" .. debugInfo.currentline .. ")";
	end

	return message;
end;
Kitty.printStackTrace = function(debugInfoList)
	for index, debugInfo in ipairs(debugInfoList) do
		Kitty.sendMessage([[	at ]] .. Kitty.formatStackTrace(debugInfo));
	end
end;

-- トレース関数
Kitty.isExcepted = function(debugInfo, exceptedFunctionList)
	for index, functionName in pairs(exceptedFunctionList) do
		if(functionName == debugInfo.what or functionName == debugInfo.name) then
			return true;
		end
	end
	return false;
end;
Kitty.trace = function(mask, exceptedFunctionList)
	if(debug == nil) then
		error("Error: trace function does not support for debug mode.");
	end

	-- 初期値の設定
	-- マスク
	if(mask == nil) then
		mask = "";
	end
	local orginalMask = mask;
	if(string.find(mask, "c") == nil) then
		mask = mask .. "c";
	end
	if(string.find(mask, "r") == nil) then
		mask = mask .. "r";
	end
	-- 対象外関数
	if(exceptedFunctionList == nil) then
		exceptedFunctionList = {"C"};
	end

	local level = 0;
	-- 初期値となる深さを算出
	local count = 0;
	local level = 0;	-- 0:debug.getinfo()、1:Kitty.trace()
	while(true) do
		local debugInfo = debug.getinfo(count);
		if(debugInfo ~= nil) then
			count = count + 1;
			-- 対象外関数判定
			if(not Kitty.isExcepted(debugInfo, exceptedFunctionList)) then
				level = level + 1;
			end
		else
			break;
		end
	end
	level = level - 1;	-- Topからの深さに変換

	-- event call, return, tail return, line, count
	local hook = function(event, line)	-- c:"call", r:"return", l:"line"

		local message = nil;
		-- 現在実行中の関数を呼び出している関数の情報
		local parentInfo = debug.getinfo(3);
		-- 現在実行中の関数情報
		local currentInfo = debug.getinfo(2);

		-- 対象外関数判定
		if(Kitty.isExcepted(currentInfo, exceptedFunctionList)) then
			return;
		end

		-- 深さを更新
		if(event == "call") then
			level = level + 1;
		end

		local message = "";
		-- イベント種別判定
		if(event == "call") then
			-- 関数呼出し
			if(string.find(orginalMask, "c") ~= nil) then
				message = string.format("%02d", level) .. " " .. string.rep("  ", level) .. ">>> ";

				-- 関数名
				if(currentInfo.name ~= nil) then
					message = message .. currentInfo.name .. "[" .. currentInfo.what .. "]";
				else
					message = message .. currentInfo.what;
				end

				-- ファイル名
				if(parentInfo ~= nil and parentInfo.currentline >= 0) then
					message = message .. "(" .. parentInfo.short_src .. ":" .. parentInfo.currentline .. ")";
				end

				-- 引数
				if(currentInfo.nparams ~= nil) then
					local str = "";
					for index = 1, currentInfo.nparams do
						if(str ~= "") then
							str = str .. ", ";
						end

						local argName, argValue = debug.getlocal(2, index);
						str = str .. string.format("[%s]=[%s]", tostring(argName), tostring(argValue));
					end
					if(str ~= "") then
						message = message .. " Arg: " .. str;
					end
				else
					-- 処理系により、currentInfo.nparamsが未定義の場合あり
					local str = "";
					local index = 1;
					while(true) do
						local argName, argValue = debug.getlocal(2, index);
						if(argName == nil or argName == "(*temporary)") then
							break;
						end

						if(str ~= "") then
							str = str .. ", ";
						end

						str = str .. string.format("[%s]=[%s]", tostring(argName), tostring(argValue));
						index = index + 1;
					end
					if(str ~= "") then
						message = message .. " Arg: " .. str;
					end
				end
			end
		elseif(event == "return") then
			-- 関数戻り
			if(string.find(orginalMask, "r") ~= nil) then
				message = string.format("%02d", level) .. " " .. string.rep("  ", level) .. "<<< ";

				-- 関数名
				if(currentInfo.name ~= nil) then
					message = message .. currentInfo.name .. "[" .. currentInfo.what .. "]";
				else
					message = message .. currentInfo.what;
				end

				-- ファイル名
				if(parentInfo ~= nil and parentInfo.currentline >= 0) then
					message = message .. "(" .. parentInfo.short_src .. ":" .. parentInfo.currentline .. ")";
				end
			end
		elseif(event == "line") then
			-- 行呼出し
			if(string.find(orginalMask, "l") ~= nil) then
				message = string.format("%02d", level+1) .. " " .. string.rep("  ", level+1) .. "--- ";

				-- 関数名
				if(currentInfo.name ~= nil) then
					message = message .. currentInfo.name .. "[" .. currentInfo.what .. "]";
				else
					message = message .. currentInfo.what;
				end

				-- ファイル名
				if(currentInfo.currentline >= 0) then
					message = message .. "(" .. currentInfo.short_src .. ":" .. line .. ")";
				end
			end
		elseif(event == "tail call") then
			message = string.format("%02d", level+1) .. " " .. string.rep("  ", level+1) .. "### ";

			-- 関数名
			if(currentInfo.name ~= nil) then
				message = message .. currentInfo.name .. "[" .. currentInfo.what .. "]";
			else
				message = message .. currentInfo.what;
			end

			-- ファイル名
			if(parentInfo ~= nil and parentInfo.currentline >= 0) then
				message = message .. "(" .. parentInfo.short_src .. ":" .. parentInfo.currentline .. ")";
			end
		elseif(event == "tail return") then
			message = string.format("%02d", level+1) .. " " .. string.rep("  ", level+1) .. "%%% ";

			-- 関数名
			if(currentInfo.name ~= nil) then
				message = message .. currentInfo.name .. "[" .. currentInfo.what .. "]";
			else
				message = message .. currentInfo.what;
			end

			-- ファイル名
			if(parentInfo ~= nil and parentInfo.currentline >= 0) then
				message = message .. "(" .. parentInfo.short_src .. ":" .. parentInfo.currentline .. ")";
			end
		else
			-- Error
			message = "Error:[" .. event .. "]";
		end

		-- 深さを更新
		if(event == "return") then
			if(level > 0) then
				level = level - 1;
			end
		end

		-- デバッグ情報を出力
		if(message ~= "") then
			Kitty.sendMessage(message);
		end
	end;

	-- フック
	debug.sethook(hook, mask);
end;
Kitty.traceGlobals = function()
	local global = {};
	local set = function(t, name, value)
		local debugInfo = debug.getinfo(2, "Sl");

		-- "(xxxx.lua:999) [arg]:[old]->[new]"
		local message = debugInfo.short_src;
		if(debugInfo.currentline >= 0) then
			message = message .. ":" .. debugInfo.currentline;
		end
		message = "(" .. message .. ") ";
		message = message .. "[" .. name .. "]:[" .. Kitty.dump(global[name]) .. "]->[" .. Kitty.dump(value) .. "]";
		Kitty.sendMessage(message);

		global[name] = value;
	end;

	setmetatable(_G, {__index=global, __newindex=set});
end;

--------------------------------------------------------------------------------
-- テーブル操作関数
-- テーブルコピー(DeepCopy)
Kitty.copyTable = function(list)
	local result = nil;

	local dataType = type(list);
	if(dataType == "nil"
	or dataType == "number"
	or dataType == "string"
	or dataType == "boolean"
	or dataType == "function") then
		result = list;
	elseif(dataType == "table") then
		result = {};
		for key, value in pairs(list) do
			result[Kitty.copyTable(key)] = Kitty.copyTable(value);	-- 再帰呼出し
		end
	else
		-- thread, userdata
		error("Could not copy. DataType:[" .. dataType .. "]");
	end

	return result;
end;
-- テーブルの要素結合
Kitty.concatTable = function(list1, list2)
	local resultList = {};
	for key, value in pairs(list1) do
		if(type(key)=="number") then
			table.insert(resultList, value);
		else
			resultList[key] = value;
		end
	end
	for key, value in pairs(list2) do
		if(type(key)=="number") then
			table.insert(resultList, value);
		else
			resultList[key] = value;
		end
	end
	return resultList;
end;
-- 指定したキーで、連想配列からデータを取得する関数
Kitty.getData = function(mapData, ...)	-- Kitty.getData(Kitty.locale, "category1", "category2", ...);
	local resultData = nil;
	if(select("#", ...) > 0) then
		resultData = mapData;
		for index=1, select("#", ...) do
			local temp = resultData[select(index, ...)];
			if(temp) then
				resultData = temp;
				if(type(temp) ~= "table") then
					break;
				end
			else
				resultData = nil;
				break;
			end
		end
	end
	return resultData;
end;

-- 時刻取得
Kitty.getTime = function()
	if(GetTime ~= nil) then
		return GetTime();
	elseif(os ~= nil and os.time ~= nil) then
		return os.time();
	else
		error("Error: Does not exist clock.");
	end
end;

-- Luaコードのロード/文字列化
Kitty.stringToData = function(str)
	local func = loadstring("return " .. tostring(str) .. ";");
	if(func ~= nil) then
		return func();
	else
		return nil;
	end
end;

Kitty.dataToString = function(data, indent)
	if(not indent) then
		indent = 0;
	else
		-- ネストの深さをチェック
		if(indent > 1000) then
			error("Error: Stack overflow. Data:[" .. tostring(data) .. "], Indent:[" .. tostring(indent) .. "]");
		end
	end

	local out = "";
	if(type(data) == "thread") then
		out = "thread";
	elseif(type(data) == "userdata") then
		out = "userdata";
	elseif(type(data) == "table") then
		-- 配列
		local line = "";
		for key, value in pairs(data) do
			if(line ~= "") then
				line = line .. ",\n";
			end

			indent = indent + 1;
			line = line .. Kitty.blank(indent);
			if(string.startsWith(tostring(key), "__")) then
				-- Meta情報
				line = line .. "[" .. Kitty.formatData(key) .. "]=" .. Kitty.formatData(value);
			else
				-- 通常データ
				line = line .. "[" .. Kitty.formatData(key) .. "]=" .. Kitty.dataToString(value, indent);	-- 再起呼び出し
			end
			indent = indent - 1;
		end

		if(line ~= "") then
			out = out .. "{" .. "\n";
			out = out .. line .. "\n";
			out = out .. Kitty.blank(indent) .. "}";
		else
			out = out .. "{}";
		end
	else
		-- 文字列、数値、ブーリアン型
		out = Kitty.formatData(data);
	end

	return out;
end;
Kitty.blank = function(indent, blank)
	if(not blank) then
		blank = "    ";
	end

	local result = "";
	for index=1, indent do
		result = result .. blank;
	end
	return result;
end;
Kitty.formatData = function(data)
	local result = nil;

	if(type(data) == "nil") then
		result = tostring(data);
	elseif(type(data) == "number") then
		result = tostring(data);
	elseif(type(data) == "string") then
		result = [["]] .. data .. [["]];
	elseif(type(data) == "boolean") then
		result = tostring(data);
	elseif(type(data) == "table") then
		result = "{talbe}";
	elseif(type(data) == "function") then
		result = "function()";
	else
		result = tostring(data);
	end

	return result;
end;

-- 書式変換関数
Kitty.comma = function(data)
	if(type(data) == "string" or type(data) == "number") then
		if(tonumber(data) ~= nil) then
			data = string.format("%d", tonumber(data));	-- 整数に変換
			local out = "";
			for index = -1, -#data, -3 do
				if(out ~= "") then
					-- コンマ付加
					out = "," .. out;
				end
				out = string.sub(data, index - 2, index) .. out;
			end

			return out;
		end
	end
	return data;
end;

-- 言語データ書式化関数
Kitty.format = function(text, ...)
	if(text ~= nil and text ~= "") then
		for index=1, select("#", ...) do
			text = text:gsub("<<" .. index .. ">>", (select(index, ...)));	-- selectの戻り値の個数をひとつにする
		end
	end
	return tostring(text);
end

--------------------------------------------------------------------------------
-- 文字列クラス拡張関数
Kitty.getUtf8Length = function(initialByte)
	-- 先頭の1Byteを判定
	if(0x00 <= initialByte and initialByte <= 0x7F) then
		return 1;
	elseif(0xC0 <= initialByte and initialByte <= 0xDF) then
		return 2;
	elseif(0xE0 <= initialByte and initialByte <= 0xEF) then
		return 3;
	elseif(0xF0 <= initialByte and initialByte <= 0xF7) then
		return 4;
	elseif(0xF8 <= initialByte and initialByte <= 0xFB) then
		return 5;
	elseif(0xFC <= initialByte and initialByte <= 0xFD) then
		return 6;
	else
		-- 先頭以外の文字
		error("Invalid byte. str:[" .. tostring(str) .. "]");
	end
end;
-- 文字列を１文字ずつに分割
string.toArray = function(self)
	local resultArray = {};

	local index = 1;
	while(index <= string.len(self or "")) do
		local length = Kitty.getUtf8Length(string.byte(self, index));
		table.insert(resultArray, string.sub(self, index, index + length - 1));

		index = index + length;
	end
	return resultArray;
end;
-- 文字列検索関数(右側から検索)
string.reverseFind = function(self, pattern, final, plain)
	if(final ~= nil) then
		-- 末尾を削除し検索対象範囲を変更
		self = string.sub(self, 1, final);
	end

	local result = {};
	local lastResult = nil;
	repeat
		lastResult = result;
		-- 検索開始位置は、最初が1、事項は前回検索した範囲+1
		result = {string.find(self, pattern, (lastResult[2] or 0) + 1, plain)};
	until(result[1] == nil);

	return unpack(lastResult);
end;

-- 文字列分割関数
string.split = function(self, delimiter)
	assert(self, "Error: self is nil.");

	local result = {};
	local lastPosition = 1;
	for part, position in string.gmatch(self, "(.-)" .. delimiter .. "()") do
		-- 単語+区切り文字の部位を、検出し登録
		table.insert(result, part);
		lastPosition = position;
	end

	-- 末尾の単語を登録
	table.insert(result, string.sub(self, lastPosition));
	return result
end;

string.startsWith = function(self, pattern, init, plain)
	if(init == nil) then
		init = 1;
	end

	if(plain == true) then
		-- 正規表現なし
		if(pattern == string.sub(self, init, init + string.len(pattern) - 1)) then
			return true, pattern;
		else
			return false;
		end
	else
		-- 正規表現あり
		local s, e = string.find(self, pattern, init, plain);
		if(s == init) then
			-- 先頭
			return true, string.sub(self, s, e);
		else
			return false;
		end
	end
end;
string.endsWith = function(self, pattern, final, plain)
	if(final == nil) then
		final = string.len(self);
	elseif(final < 0) then
		-- 負のインデックスは使用しない
		final = final + string.len(self) + 1;
	end

	if(plain == true) then
		-- 正規表現なし
		if(pattern == string.sub(self, final - string.len(pattern) + 1, final)) then
			return true, pattern;
		else
			return false;
		end
	else
		-- 正規表現あり
		local s, e = string.reverseFind(self, pattern, final, plain);
		if(e == final) then
			-- 末尾
			return true, string.sub(self, s, e);
		else
			return false;
		end
	end
end;

string.trim = function(self, pattern)	-- patternは、除去する文字(character)を連結したもの。
	return string.trimRight(string.trimLeft(self, pattern), pattern);
end;
string.trimLeft = function(self, pattern)
	assert(self, "Error: self is nil.");

	if(pattern == nil) then
		set = [[ 　	]];
	elseif(type(pattern) == "string") then
		set = pattern;
	elseif(type(pattern) == "table") then
		set = table.concat(pattern);
	else
		-- Error
		error("Error: This type is not supported. pattern:[" .. tostring(pattern) .. "](" .. type(pattern) .. ")");
	end
	-- 行頭のブランクを除去
	return string.gsub(self, "^[" .. set .. "]+", "");
end;
string.trimRight = function(self, pattern)
	assert(self, "Error: self is nil.");

	if(pattern == nil) then
		set = [[ 　	]];
	elseif(type(pattern) == "string") then
		set = pattern;
	elseif(type(pattern) == "table") then
		set = table.concat(pattern);
	else
		-- Error
		error("Error: This type is not supported. pattern:[" .. tostring(pattern) .. "](" .. type(pattern) .. ")");
	end
	-- 末尾のブランクを除去
	return string.gsub(self, "[" .. set .. "]+$", "");
end;

--------------------------------------------------------------------------------
-- Hook管理クラス
-- 注意：Lua関数をフックする場合はガーベージコレクトされるが、C関数はされない。
-- C関数をフックする場合は、フックの解除処理が必要。
Kitty.HookManager = {};
-- スタティックメソッド
-- オーバーライド
Kitty.HookManager.override = function(orgFunc, overrideFunc, instance)
	local hookManager = Kitty.HookManager(orgFunc, nil, nil, instance);
	hookManager.overrideFunc = overrideFunc;
	return hookManager;
end;
-- インスタンスメソッド
Kitty.HookManager.call = function(self, ...)
	if(self.overrideFunc ~= nil) then
		-- オーバーライド
		local result = nil;
		if(self.instance ~= nil) then
			result = {pcall(self.overrideFunc, self.instance, self.orgFunc, ...)};
		else
			result = {pcall(self.overrideFunc, self.orgFunc, ...)};
		end

		if(result[1]) then
			return unpack(result, 2);
		else
			-- Error
			Kitty.sendMessage(result[2]);
			return;
		end
	end

	-- 前呼出し
	if(self.preFunc ~= nil) then
		local result = nil;
		if(self.instance ~= nil) then
			result = {pcall(self.preFunc, self.instance, ...)};
		else
			result = {pcall(self.preFunc, ...)};
		end
		if(not result[1]) then
			-- Error
			Kitty.sendMessage(result[2]);
		end
	end

	-- 元々の関数
	local resultList = {pcall(self.orgFunc, ...)};
	if(not resultList[1]) then
		-- Error
		Kitty.sendMessage(resultList[2]);
	end

	-- 後呼出し
	if(self.postFunc ~= nil) then
		local result = nil;
		if(self.instance ~= nil) then
			result = {pcall(self.postFunc, self.instance, ...)};
		else
			result = {pcall(self.postFunc, ...)};
		end
		if(not result[1]) then
			-- Error
			Kitty.sendMessage(result[2]);
		end
	end

	return unpack(resultList, 2);
end;
Kitty.HookManager.getOriginalFunction = function(self)
	return self.orgFunc;
end;
Kitty.HookManager.isHooked = function(self)
	return true;
end;
-- 文字列表現
Kitty.HookManager.toString = function(self)
	return "orgFunc:[" .. tostring(self.orgFunc) .. "], preFunc:[" .. tostring(self.preFunc) .. "], postFunc:[" .. tostring(self.postFunc) .. "], overrideFunc:[" .. tostring(self.overrideFunc) .. "]";
end;
-- コンストラクタ
Kitty.HookManager.constructor = function(self, orgFunc, preFunc, postFunc, instance)
	-- データメンバ
	local obj = {};
	-- Hookする関数
	obj.orgFunc = orgFunc;
	-- Hookしたときコールされる関数
	obj.preFunc = preFunc;
	obj.postFunc = postFunc;
	obj.instance = instance;
	obj.overrideFunc = nil;

	-- 関数の付与、文字列表現サポート
	return setmetatable(obj, {__index=Kitty.HookManager, __tostring=Kitty.HookManager.toString, __call=Kitty.HookManager.call});
end;
setmetatable(Kitty.HookManager, {__call=Kitty.HookManager.constructor});	-- コンストラクタを指定

--------------------------------------------------------------------------------
-- Tokenizerクラス
Kitty.Tokenizer = {};
-- スタティックメソッド
Kitty.Tokenizer.startsWith = function(source, delimiterArray)
	for _, value in pairs(delimiterArray) do
		local result, word = source:startsWith(value);	-- 正規表現
		if(result) then
			return word;
		end
	end
	return nil;
end;
-- インスタンスメソッド
-- トークンの取得(トークンもしくは区切り文字を返す)
Kitty.Tokenizer.nextToken = function(self)
	-- トークン
	local position = 0;
	local result = nil;
	local word = nil;
	while(true) do
		local str = self.source:sub(self.offset + position);
		if(str == nil or str == "") then
			if(position > 0) then
				-- トークン
				local token = self.source:sub(self.offset, self.offset + position -1);
				self.offset = self.offset + position;
				result = true;
				word = token;
				break;
			else
				-- 解析終了
				result = nil;
				word = nil;
				break;
			end
		end

		-- 対象外文字判定
		if(self.exceptedWordArray ~= nil) then
			local exceptedWord = Kitty.Tokenizer.startsWith(str, self.exceptedWordArray);
			if(exceptedWord ~= nil) then
				position = position + exceptedWord:len();
			end
		end

		local delimiter = Kitty.Tokenizer.startsWith(str, self.delimiterArray);
		if(delimiter ~= nil) then
			if(position > 0) then
				-- トークン
				local token = self.source:sub(self.offset, self.offset + position -1);
				self.offset = self.offset + position;
				result = true;
				word = token;
				break;
			else
				-- 区切り文字
				self.offset = self.offset + delimiter:len();
				result = false;
				word = delimiter;
				break;
			end
		end

		position = position + 1;
	end

	return result, word;
end;
-- 区切り文字の設定
Kitty.Tokenizer.setDelimiter = function(self, delimiterArray)
	self.delimiterArray = delimiterArray;
end;
Kitty.Tokenizer.setExceptedWord = function(self, exceptedWordArray)
	self.exceptedWordArray = exceptedWordArray;
end;
-- 文字列表現
Kitty.Tokenizer.toString = function(self)
	return self.source;
end;
-- コンストラクタ
Kitty.Tokenizer.constructor = function(self, source, delimiterArray)
	-- データメンバ
	local obj = {};
	-- トークンに分割する文字列
	obj.source = source;
	-- 区切り文字(文字列)
	obj.delimiterArray = delimiterArray;
	-- 解析対象外文字(文字列)
	obj.exceptedWordArray = nil;
	-- オフセット
	obj.offset = 1;

	return setmetatable(obj, {__index=Kitty.Tokenizer, __tostring=Kitty.Tokenizer.toString});
end;
setmetatable(Kitty.Tokenizer, {__call=Kitty.Tokenizer.constructor});	-- コンストラクタを指定

--------------------------------------------------------------------------------
-- LinkedListクラス
Kitty.LinkedList = {};
-- インスタンスメソッド
-- 格納されている要素の数
Kitty.LinkedList.count = function(self)
	return self.numberOfCell;
end;
-- リストの末尾に要素を追加
Kitty.LinkedList.pushBack = function(self, data)
	local cell = nil;
	if(self.numberOfCell == 0) then
		cell = Kitty.LinkedList.Cell(data, nil, nil);
		self.frontCell = cell;
		self.backCell = cell;
	else
		cell = Kitty.LinkedList.Cell(data, self.backCell, nil);
		self.backCell.nextCell = cell;
		self.backCell = cell;
	end
	self.numberOfCell = self.numberOfCell + 1;
end;
-- リストの先頭に要素を追加
Kitty.LinkedList.pushFront = function(self, data)
	local cell = nil;
	if(self.numberOfCell == 0) then
		cell = Kitty.LinkedList.Cell(data, nil, nil);
		self.frontCell = cell;
		self.backCell = cell;
	else
		cell = Kitty.LinkedList.Cell(data, nil, self.frontCell);
		self.frontCell.prevCell = cell;
		self.frontCell = cell;
	end
	self.numberOfCell = self.numberOfCell + 1;
end;
-- 末尾の要素を取り出し(リストから削除する)
Kitty.LinkedList.popBack = function(self)
	local returnValue = nil;
	if(self.numberOfCell > 0) then
		local cell = self.backCell;
		if(self.numberOfCell == 1) then
			self.frontCell = nil;
			self.backCell = nil;
		else
			self.backCell.prevCell.nextCell = nil;
			self.backCell = self.backCell.prevCell;
		end
		self.numberOfCell = self.numberOfCell - 1;
		returnValue = cell.data;
	end

	return returnValue;
end;
-- 先頭の要素を取り出し(リストから削除する)
Kitty.LinkedList.popFront = function(self)
	local returnValue = nil;
	if(self.numberOfCell > 0) then
		local cell = self.frontCell;
		if(self.numberOfCell == 1) then
			self.frontCell = nil;
			self.backCell = nil;
		else
			self.frontCell.nextCell.prevCell = nil;
			self.frontCell = self.frontCell.nextCell;
		end
		self.numberOfCell = self.numberOfCell - 1;
		returnValue = cell.data;
	end

	return returnValue;
end;
-- 末尾の要素を取得(リストから削除しない)
Kitty.LinkedList.back = function(self)
	local returnValue = nil;
	if(self.numberOfCell > 0) then
		returnValue = self.backCell.data;
	end
	return returnValue;
end;
-- 先頭の要素を取得(リストから削除しない)
Kitty.LinkedList.front = function(self)
	local returnValue = nil;
	if(self.numberOfCell > 0) then
		returnValue = self.frontCell.data;
	end
	return returnValue;
end;
-- index番目の要素を取得(リストから削除しない。indexはゼロから始まる。)
Kitty.LinkedList.getCell = function(self, index)
	local currentIndex = 0;
	local cell = self.frontCell;
	while(cell ~= nil) do
		if(currentIndex == index) then
			return cell.data;
		end
		cell = cell.nextCell;
		currentIndex = currentIndex + 1;
	end
	return nil;
end;
-- index番目に要素を追加(indexはゼロから始まる。)
Kitty.LinkedList.insertCell = function(self, index, data)
	if(self.numberOfCell == index) then
		-- 末尾に追加
		self:pushBack(data);
		return true;
	end

	local currentIndex = 0;
	local cell = self.frontCell;
	while(cell ~= nil) do
		if(currentIndex == index) then
			-- 追加
			local newCell = Kitty.LinkedList.Cell(data, cell.prevCell, cell);
			if(cell.prevCell == nil) then
				self.frontCell = newCell;
			else
				cell.prevCell.nextCell = newCell;
			end
			cell.prevCell = newCell;
			self.numberOfCell = self.numberOfCell + 1;
			return true;
		end
		cell = cell.nextCell;
		currentIndex = currentIndex + 1;
	end
	return false;
end;
-- すべての要素を削除
Kitty.LinkedList.clear = function(self)
	self.frontCell = nil;
	self.backCell = nil;
	self.numberOfCell = 0;
end;
-- 指定した要素の次に追加(イテレータ用)
Kitty.LinkedList.insertNext = function(self, cell, data)
	local newCell = Kitty.LinkedList.Cell(data, cell, cell.nextCell);
	if(cell.nextCell == nil) then
		self.backCell = newCell;
	else
		cell.nextCell.prevCell = newCell;
	end
	cell.nextCell = newCell;
	self.numberOfCell = self.numberOfCell + 1;
end;
-- 指定した要素の前に追加(イテレータ用)
Kitty.LinkedList.insertPrev = function(self, cell, data)
	local newCell = Kitty.LinkedList.Cell(data, cell.prevCell, cell);
	if(cell.prevCell == nil) then
		self.frontCell = newCell;
	else
		cell.prevCell.nextCell = newCell;
	end
	cell.prevCell = newCell;
	self.numberOfCell = self.numberOfCell + 1;
end;
-- イテレータ作成関数
Kitty.LinkedList.iterator = function(self)
	local currentCell = nil;

	-- イテレータ
	local iterator = function(linkedList, index)
		if(index == 0) then
			-- 初回
			currentCell = self.frontCell;
		else
			if(currentCell ~= nil) then
				-- 次の要素
				currentCell = currentCell.nextCell;
			else
				-- Error
				error("Error: Program error. Called again after iterator returned nil value.");
			end
		end

		index = index + 1;

		if(currentCell == nil) then
			-- 最後
			return nil, nil, nil;
		else
			return index, currentCell.data, currentCell;
		end
	end;

	-- iterator関数、状態オブジェクト、インデックス初期値
	return iterator, self, 0;
end;
Kitty.LinkedList.reverseIterator = function(self)
	local currentCell = nil;

	-- イテレータ
	local iterator = function(linkedList, index)
		if(index == 0) then
			-- 初回
			currentCell = self.backCell;
		else
			if(currentCell ~= nil) then
				-- 次の要素
				currentCell = currentCell.prevCell;
			else
				-- Error
				error("Error: Program error. Called again after iterator returned nil value.");
			end
		end

		index = index + 1;

		if(currentCell == nil) then
			-- 最後
			return nil, nil, nil;
		else
			return index, currentCell.data, currentCell;
		end
	end;

	-- iterator関数、状態オブジェクト、インデックス初期値
	return iterator, self, 0;
end;
-- 文字列表現
Kitty.LinkedList.toString = function(self)
	local str = "Count:[" .. self.numberOfCell .. "]";
	local cell = self.frontCell;
	while(cell ~= nil) do
		if(str ~= "") then
			str = str .. ", ";
		end

		str = str .. "[" .. tostring(cell) .. "]";
		cell = cell.nextCell;
	end
	return str;
end;
-- コンストラクタ
Kitty.LinkedList.constructor = function(self)
	local obj = {};

	-- 要素の順番関係
	-- front << prev << cell << next << back
	obj.frontCell = nil;
	obj.backCell = nil;
	obj.numberOfCell = 0;

	return setmetatable(obj, {__index=Kitty.LinkedList, __tostring=Kitty.LinkedList.toString});
end;
setmetatable(Kitty.LinkedList, {__call=Kitty.LinkedList.constructor});	-- コンストラクタを指定

--------------------------------------------------------------------------------
-- LinkedListの要素クラス
Kitty.LinkedList.Cell = {};
-- 文字列表現
Kitty.LinkedList.Cell.toString = function(self)
	local strPrev = "None";
	if(self.prevCell ~= nil) then
		strPrev = tostring(self.prevCell.data);
	end
	local strNext = "None";
	if(self.nextCell ~= nil) then
		strNext = tostring(self.nextCell.data);
	end
	return string.format("Data:[%s], prevData:[%s], nextData:[%s]", Kitty.dump(self.data), strPrev, strNext);
end;
-- コンストラクタ
Kitty.LinkedList.Cell.constructor = function(self, data, prevCell, nextCell)
	-- データメンバ
	local obj = {};
	obj.prevCell = prevCell;
	obj.nextCell = nextCell;
	obj.data = data;

	return setmetatable(obj, {__index=Kitty.LinkedList.Cell, __tostring=Kitty.LinkedList.Cell.toString});
end;
setmetatable(Kitty.LinkedList.Cell, {__call=Kitty.LinkedList.Cell.constructor});	-- コンストラクタを指定

--------------------------------------------------------------------------------
-- 指定した時間に処理を実行するクラス
Kitty.EventQueue = {};
-- インスタンスメソッド
Kitty.EventQueue.count = function(self)
	return self.queue:count();
end;
-- 指定時間後に実行させる関数を登録(実行予定時間[mSec]、関数、引数)
Kitty.EventQueue.addFunction = function(self, delayTime, func, ...)
	local newEventQueueElement = Kitty.EventQueue.Element((delayTime / 1000) + Kitty.getTime(), func, ...);

	-- 実行予定時間順になる位置に挿入
	for index, eventQueueElement, cell in self.queue:reverseIterator() do
		if(newEventQueueElement:getExpectedExecutetime() >= eventQueueElement:getExpectedExecutetime()) then
			-- 挿入
			self.queue:insertNext(cell, newEventQueueElement);
			return;
		end
	end

	-- 挿入(ゼロ件 or 最も早い)
	self.queue:pushFront(newEventQueueElement);
end;
-- 指定された時間の関数をひとつ実行(現在の時間[Sec])
Kitty.EventQueue.execute = function(self, currentTime)
	local eventQueueElement = self.queue:front();
	if(eventQueueElement ~= nil) then
		if(eventQueueElement:executable(currentTime)) then
			self.queue:popFront();
			-- 実行
			return eventQueueElement:execute();
		end
	end

	return nil;
end;
-- 最も早いの実行予定時刻の取得
Kitty.EventQueue.getStartExecuteTime = function(self)
	local element = self.queue:front();
	if(element ~= nil) then
		return element:getExpectedExecutetime();
	else
		return nil;
	end
end;
-- 最も遅いの実行予定時刻の取得
Kitty.EventQueue.getEndExecuteTime = function(self)
	local element = self.queue:back();
	if(element ~= nil) then
		return element:getExpectedExecutetime();
	else
		return nil;
	end
end;
-- 文字列表現
Kitty.EventQueue.toString = function(self)
	local str = "";

	for index, eventQueueElement, _ in self.queue:iterator() do
		if(str ~= "") then
			str = str .. ", "
		end

		str = str .. "[" .. tostring(eventQueueElement) .. "]";
	end

	if(str == "") then
		str = "None";
	end
	return str;
end;
-- コンストラクタ
Kitty.EventQueue.constructor = function(self)
	-- データメンバ
	local obj = {};
	obj.queue = Kitty.LinkedList();

	return setmetatable(obj, {__index=Kitty.EventQueue, __tostring=Kitty.EventQueue.toString});
end;
setmetatable(Kitty.EventQueue, {__call=Kitty.EventQueue.constructor});	-- コンストラクタを指定

--------------------------------------------------------------------------------
-- EventQueueの要素クラス
Kitty.EventQueue.Element = {};
-- インスタンスメソッド
-- 時間チェック
Kitty.EventQueue.Element.executable = function(self, currentTime)
	if(self.expectedExecutetime <= currentTime) then
		return true;
	else
		return false;
	end
end;
-- 実行
Kitty.EventQueue.Element.execute = function(self)
	return self.func(unpack(self.argList));
end;
-- 実行予定時刻の取得
Kitty.EventQueue.Element.getExpectedExecutetime = function(self)
	return self.expectedExecutetime;
end;
-- 文字列表現
Kitty.EventQueue.Element.toString = function(self)
	return tostring(self.expectedExecutetime);
end;
-- コンストラクタ
Kitty.EventQueue.Element.constructor = function(self, expectedExecutetime, func, ...)
	-- データメンバ
	local obj = {};
	obj.expectedExecutetime = expectedExecutetime;
	obj.func = func;
	obj.argList = {...};

	return setmetatable(obj, {__index=Kitty.EventQueue.Element, __tostring=Kitty.EventQueue.Element.toString});
end;
setmetatable(Kitty.EventQueue.Element, {__call=Kitty.EventQueue.Element.constructor});	-- コンストラクタを指定

--------------------------------------------------------------------------------
-- 文字色変更関数
Kitty.color = function(str, r, g, b)
	local header = "|H|h|cff" .. string.format("%02x", r) .. string.format("%02x", g) .. string.format("%02x", b);
	local footer = "|r|h";

	local START_TAG = "|H|h|c[0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F]";
	local END_TAG = "|r|h";
	local tokenizer = Kitty.Tokenizer(str, {START_TAG, END_TAG});
--	Kitty.debugPrint("[" .. tokenizer:toString() .. "]");

	local message = "";
	local index = 0;
	repeat
		local result, token = tokenizer:nextToken();
		if(result == true) then
			-- トークン
--			Kitty.debugPrint("[" .. token .. "]");
			if(index == 0) then
				-- 色指定されていないメッセージのみ着色する
				message = message .. header .. token .. footer;
			else
				message = message .. token;
			end
		elseif(result == false) then
			-- 区切り文字
			if(token:match(START_TAG) ~= nil) then
				-- START_TAG
				index = index + 1;
--				Kitty.debugPrint((" "):rep(index) .. "Start:[" .. token .. "]");
				message = message .. token;
			else
				-- END_TAG
--				Kitty.debugPrint((" "):rep(index) .. "End:[" .. token .. "]");
				message = message .. token;
				index = index - 1;
			end
		end
	until(result == nil);

--	Kitty.debugPrint("[" .. message .. "]");
	return message;
end;
-- 固定色 + 括弧
Kitty.colorRed = function(str)
	return Kitty.color("[" .. tostring(str) .. "]", 255, 0, 0);
end;
Kitty.colorGreen = function(str)
	return Kitty.color("[" .. tostring(str) .. "]", 0, 255, 0);
end;
Kitty.colorBlue = function(str)
	return Kitty.color("[" .. tostring(str) .. "]", 0, 0, 255);
end;
Kitty.colorCyan = function(str)
	return Kitty.color("[" .. tostring(str) .. "]", 0, 255, 255);
end;
Kitty.colorMagenta = function(str)
	return Kitty.color("[" .. tostring(str) .. "]", 255, 0, 255);
end;
Kitty.colorYellow = function(str)
	return Kitty.color("[" .. tostring(str) .. "]", 255, 255, 0);
end;
Kitty.colorWhite = function(str)
	return Kitty.color("[" .. tostring(str) .. "]", 255, 255, 255);
end;
Kitty.colorGray = function(str)
	return Kitty.color("[" .. tostring(str) .. "]", 128, 128, 128);
end;
Kitty.colorBlack = function(str)
	return Kitty.color("[" .. tostring(str) .. "]", 0, 0, 0);
end;
Kitty.colorGradation = function(str, startR, startG, startB, endR, endG, endB)
	if(startR == nil) then
		startR = 0;
	end
	if(startG == nil) then
		startG = 255;
	end
	if(startB == nil) then
		startB = 255;
	end
	if(endR == nil) then
		endR = 255;
	end
	if(endG == nil) then
		endG = 255;
	end
	if(endB == nil) then
		endB = 255;
	end

	local result = "";
	local array = str:toArray();
	while(#array > 24) do	-- チャンネルの最大文字数制限は、ほぼ24文字
		table.remove(array);
	end

	if(#array > 1) then
		-- 線形補間
		for index, charcter in ipairs(array) do
			local r = startR + (endR - startR) / (#array-1) * (index-1);
			local g = startG + (endG - startG) / (#array-1) * (index-1);
			local b = startB + (endB - startB) / (#array-1) * (index-1);
			result = result .. Kitty.color(charcter, r, g, b);
		end
	else
		-- １文字の場合は、平均値
		local r = (startR + endR) / 2;
		local g = (startG + endG) / 2;
		local b = (startB + endB) / 2;
		result = Kitty.color(str, r, g, b);
	end

	return result;
end;
