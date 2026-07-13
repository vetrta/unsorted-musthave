-- (C) 2012-2013 Miranda
--------------------------------------------------------------------------------
-- 名前空間作成
if(_G and not _G.Kitty) then
	_G.Kitty = {};
end

--------------------------------------------------------------------------------
-- 言語データロード関数
Kitty.loadLanguageFile = function(locale)
	function toName(num) -- shortening TEXT() (only accepts ID between 100000-999999)
		if tonumber(num) == nil then
			return
		end
		result = TEXT("Sys"..num.."_name")
		return result
	end
	return pcall(dofile, "Interface/Addons/KittyCombo/locales/lang_" .. tostring(locale) .. ".lua");
end;
-- 言語データ取得関数
Kitty.T = function(category, key, ...)
	local message = "";
	if(Kitty.locale) then
		-- 文言取得
		message = Kitty.getData(Kitty.locale, category, key);
		message = Kitty.format(message, ...);
	else
		message = key;
	end

	return message;
end;
Kitty.text = function(categoryList, replaceList)	-- Kitty.text({"category1", "category2", ...}, {replace_data1, replace_data2, ...});
	if(categoryList) then
		if(Kitty.locale) then
			-- 言語データあり
			local message = "";
			if(type(categoryList) == "table") then
				message = Kitty.getData(Kitty.locale, unpack(categoryList));
			else
				message = Kitty.getData(Kitty.locale, categoryList);
			end

			if(type(message) == "string") then
				-- Replace
				if(replaceList) then
					if(type(replaceList) == "table") then
						message = Kitty.format(message, unpack(replaceList));
					else
						message = Kitty.format(message, replaceList);
					end
				end
			else
				message = "NONE";
			end
			return message;
		else
			-- 言語データなし
			local resultText = "";
			if(type(categoryList) == "table") then
				for index, value in ipairs(categoryList) do
					if(index ~= 1) then
						resultText = resultText .. ".";
					end
					resultText = resultText .. value;
				end
			else
				resultText = categoryList;
			end
			return resultText;
		end
	else
		return "NONE";
	end
end;

--------------------------------------------------------------------------------
-- ロードするモジュール
Kitty.loadFileList = {
	[[Interface/Addons/KittyCombo/lib/KittyLib.lua]],
	[[Interface/Addons/KittyCombo/lib/KittyClassLib.lua]],
	[[Interface/Addons/KittyCombo/lib/KittyUILib.lua]],
	[[Interface/Addons/KittyCombo/KittyCombo.lua]],						-- 順番は一時的に逆
	[[Interface/Addons/KittyCombo/KittySetting.lua]],					-- 順番は一時的に逆
	[[Interface/Addons/KittyCombo/Kitty.lua]],
	[[Interface/Addons/KittyCombo/gui/KittyControl.lua]],				-- temp
	[[Interface/Addons/KittyCombo/gui/KittyBasicConfigFrame.lua]],		-- temp
	[[Interface/Addons/KittyCombo/gui/KittyCommandListFrame.lua]],		-- temp
	[[Interface/Addons/KittyCombo/gui/KittyCommandConfigFrame.lua]],	-- temp
	[[Interface/Addons/KittyCombo/gui/KittyCommandConditionFrame.lua]],	-- temp
	[[Interface/Addons/KittyCombo/gui/KittyEventCodeButton.lua]],		-- temp
};
Kitty.dofile = function(index)
	if(index == nil) then
		for _, file in ipairs(Kitty.loadFileList) do
			local result, errorMessage = pcall(dofile, file);
			if(result == false) then
				DEFAULT_CHAT_FRAME:AddMessage("Error:" .. errorMessage, 1, 0, 0);
				break;
			end
		end
	else
		if(type(index) == "number") then
			local result, errorMessage = pcall(dofile, Kitty.loadFileList[index]);
			if(result == false) then
				DEFAULT_CHAT_FRAME:AddMessage("Error:" .. errorMessage, 1, 0, 0);
			end
		elseif(type(index) == "string") then
			local result, errorMessage = pcall(dofile, index);
			if(result == false) then
				DEFAULT_CHAT_FRAME:AddMessage("Error:" .. errorMessage, 1, 0, 0);
			end
		end
	end
end;

--------------------------------------------------------------------------------
-- 実行エリア
(function()
	-- 言語データのロード
	local result, locale = Kitty.loadLanguageFile(GetLanguage():upper());
	if(result) then
		Kitty.locale = locale;
	else
		result, locale = Kitty.loadLanguageFile("ENEU");	-- Default
		if(result) then
			Kitty.locale = locale;
		else
			DEFAULT_CHAT_FRAME:AddMessage("Error:" .. locale, 1, 0, 0);
		end
	end

	-- モジュールのロード
	Kitty.dofile();
end)();
