-- (C) 2012-2013 Miranda
--------------------------------------------------------------------------------
-- 名前空間作成
if(_G and not _G.Kitty) then
	_G.Kitty = {};
end

--------------------------------------------------------------------------------
-- 戦闘管理クラス
Kitty.ComboManager = {};
Kitty.ComboManager.TYPE_EFFECT = "EFFECT";
Kitty.ComboManager.TYPE_ACTION = "ACTION";
Kitty.ComboManager.TYPE_BUILD = "BUILD";
Kitty.ComboManager.TYPE_STRING_NUMBER_LIST = "STRING_NUMBER_LIST";
Kitty.ComboManager.TYPE_STRING = "STRING";
Kitty.ComboManager.TYPE_NUMBER = "NUMBER";
Kitty.ComboManager.TYPE_BOOLEAN = "BOOLEAN";
Kitty.ComboManager.TYPE_OTHER = "OTHER";

-- コマンドリスト
Kitty.ComboManager.commandList = {
{
	["info"]={["name"]="Default_R", ["class"]="R", ["target"]="all"},
	{
		-- 共通コマンド
		["commandType"]="proc", ["commandName"]=Kitty.T("name", "CommonCommand"), ["icon"]="", ["enable"]=true,
		{["conditionType"]="playerNonEffect", {["effectType"]="original", ["name"]=Kitty.T("name", "Stun"), ["threshold"]=0.6}},
	},
	{
		-- ハイディング
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Hide"), ["icon"]="interface/icons/skill_thi3-2", ["enable"]=true,
		{["conditionType"]="playerEffect", {["effectType"]="original", ["name"]=Kitty.T("skill", "Vanish"), ["threshold"]=0.6}},
	},
	{
		-- ハーツアヴォイド
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Evasion"), ["icon"]="interface/icons/skill_thi72-1", ["enable"]=true,
		{["conditionType"]="targetIsBoss", ["value"]=true},
		{["conditionType"]="isTargeted", ["value"]=true},
		{["conditionType"]="playerIsFearless", ["value"]=false},
	},
	{
		-- エスケープ
		["commandType"]="suitskill", ["commandName"]=Kitty.T("skill", "Escape"), ["icon"]="interface/Icons/skill_panel_icons/sp_thi_002.dds", ["enable"]=true,
		{["conditionType"]="playerEffect", {["effectType"]="original", ["name"]=Kitty.T("name", "Stun"), ["threshold"]=0.6}},
	},
	{
		-- バッククリープ
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Shadow Step"), ["icon"]="interface/icons/skill_thi27-2", ["enable"]=true,
		{["conditionType"]="targetIsCaster", ["value"]=true},
		{["conditionType"]="playerEffect", {["effectType"]="original", ["name"]=Kitty.T("skill", "Lightning"), ["threshold"]=0.6}},
	},
	{
		-- デッドアングルアタック
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Blind Spot"), ["icon"]="interface/icons/skill_thi3-1", ["enable"]=true,
		{["conditionType"]="isTargeted", ["value"]=false},
		{["conditionType"]="isRequest", ["value"]=true},
	},
	{
		-- ダーティトリック
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Low Blow"), ["icon"]="interface/icons/skill_thi12-1", ["enable"]=true,
		{["conditionType"]="targetIsPC", ["value"]=true},
		{["conditionType"]="playerEnergy", ["min"]=60, ["max"]=nil},
	},
	{
		-- ダークネス
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Shadowstab"), ["icon"]="interface/icons/skill_thi1-1", ["enable"]=true,
		{["conditionType"]="targetNonEffect", {["effectType"]="original", ["name"]=Kitty.T("skill", "Shadowstab"), ["threshold"]=0.6}},
	},
	{
		-- ダーティトリック
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Low Blow"), ["icon"]="interface/icons/skill_thi12-1", ["enable"]=true,
		{["conditionType"]="targetNonEffect", {["effectType"]="original", ["name"]=Kitty.T("skill", "Low Blow"), ["threshold"]=0.6}},
	},
	{
		-- ウーンドアタック
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Wound Attack"), ["icon"]="interface/icons/skill_thi6-1", ["enable"]=true,
	},
	{
		-- ダーティトリック
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Low Blow"), ["icon"]="interface/icons/skill_thi12-1", ["enable"]=true,
		{["conditionType"]="playerEnergy", ["min"]=60, ["max"]=nil},
	},
},

{
	["info"]={["name"]="Default_RS", ["class"]="RS", ["target"]="all"},
	{
		-- 共通コマンド
		["commandType"]="proc", ["commandName"]=Kitty.T("name", "CommonCommand"), ["icon"]="", ["enable"]=true,
		{["conditionType"]="playerNonEffect", {["effectType"]="original", ["name"]=Kitty.T("name", "Stun"), ["threshold"]=0.6}},
	},
	{
		-- ハイディング
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Hide"), ["icon"]="interface/icons/skill_thi3-2", ["enable"]=true,
		{["conditionType"]="playerEffect", {["effectType"]="original", ["name"]=Kitty.T("skill", "Vanish"), ["threshold"]=0.6}},
	},
	{
		-- ハーツアヴォイド
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Evasion"), ["icon"]="interface/icons/skill_thi72-1", ["enable"]=true,
		{["conditionType"]="targetIsBoss", ["value"]=true},
		{["conditionType"]="isTargeted", ["value"]=true},
		{["conditionType"]="playerIsFearless", ["value"]=false},
	},
	{
		-- エスケープ
		["commandType"]="suitskill", ["commandName"]=Kitty.T("skill", "Escape"), ["icon"]="interface/Icons/skill_panel_icons/sp_thi_002.dds", ["enable"]=true,
		{["conditionType"]="playerEffect", {["effectType"]="original", ["name"]=Kitty.T("name", "Stun"), ["threshold"]=0.6}},
	},
	{
		-- バッククリープ
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Shadow Step"), ["icon"]="interface/icons/skill_thi27-2", ["enable"]=true,
		{["conditionType"]="targetIsCaster", ["value"]=true},
		{["conditionType"]="playerEffect", {["effectType"]="original", ["name"]=Kitty.T("skill", "Lightning"), ["threshold"]=0.6}},
	},
	{
		-- デッドアングルアタック
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Blind Spot"), ["icon"]="interface/icons/skill_thi3-1", ["enable"]=true,
		{["conditionType"]="isTargeted", ["value"]=false},
		{["conditionType"]="isRequest", ["value"]=true},
	},
	{
		-- ダーティトリック
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Low Blow"), ["icon"]="interface/icons/skill_thi12-1", ["enable"]=true,
		{["conditionType"]="targetIsPC", ["value"]=true},
		{["conditionType"]="playerEnergy", ["min"]=60, ["max"]=nil},
	},
	{
		-- ダークネス
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Shadowstab"), ["icon"]="interface/icons/skill_thi1-1", ["enable"]=true,
		{["conditionType"]="targetNonEffect", {["effectType"]="original", ["name"]=Kitty.T("skill", "Shadowstab"), ["threshold"]=0.6}},
	},
	{
		-- ダーティトリック
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Low Blow"), ["icon"]="interface/icons/skill_thi12-1", ["enable"]=true,
		{["conditionType"]="targetNonEffect", {["effectType"]="original", ["name"]=Kitty.T("skill", "Low Blow"), ["threshold"]=0.6}},
	},
	{
		-- ウーンドアタック
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Wound Attack"), ["icon"]="interface/icons/skill_thi6-1", ["enable"]=true,
	},
	{
		-- ダーティトリック
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Low Blow"), ["icon"]="interface/icons/skill_thi12-1", ["enable"]=true,
		{["conditionType"]="playerEnergy", ["min"]=60, ["max"]=nil},
	},
	{
		-- ブラッディアロー
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Vampire Arrows"), ["icon"]="interface/icons/skill_ran6-3.dds", ["enable"]=true,
	},
	{
		-- ハンドブレイク
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Wrist Attack"), ["icon"]="interface/icons/skill_ran18-2", ["enable"]=true,
	},
	{
		-- シューティング
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Shooting"), ["icon"]="interface/icons/skill_ran1-2", ["enable"]=true,
	},
},

{
	["info"]={["name"]="Default_RW", ["class"]="RW", ["target"]="all"},
	{
		-- 共通コマンド
		["commandType"]="proc", ["commandName"]=Kitty.T("name", "CommonCommand"), ["icon"]="", ["enable"]=true,
		{["conditionType"]="playerNonEffect", {["effectType"]="original", ["name"]=Kitty.T("name", "Stun"), ["threshold"]=0.6}},
	},
	{
		-- ハイディング
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Hide"), ["icon"]="interface/icons/skill_thi3-2", ["enable"]=true,
		{["conditionType"]="playerEffect", {["effectType"]="original", ["name"]=Kitty.T("skill", "Vanish"), ["threshold"]=0.6}},
	},
	{
		-- ハーツアヴォイド
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Evasion"), ["icon"]="interface/icons/skill_thi72-1", ["enable"]=true,
		{["conditionType"]="targetIsBoss", ["value"]=true},
		{["conditionType"]="isTargeted", ["value"]=true},
		{["conditionType"]="playerIsFearless", ["value"]=false},
	},
	{
		-- エスケープ
		["commandType"]="suitskill", ["commandName"]=Kitty.T("skill", "Escape"), ["icon"]="interface/Icons/skill_panel_icons/sp_thi_002.dds", ["enable"]=true,
		{["conditionType"]="playerEffect", {["effectType"]="original", ["name"]=Kitty.T("name", "Stun"), ["threshold"]=0.6}},
	},
	{
		-- バッククリープ
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Shadow Step"), ["icon"]="interface/icons/skill_thi27-2", ["enable"]=true,
		{["conditionType"]="targetIsCaster", ["value"]=true},
		{["conditionType"]="playerEffect", {["effectType"]="original", ["name"]=Kitty.T("skill", "Lightning"), ["threshold"]=0.6}},
	},
	{
		-- デッドアングルアタック
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Blind Spot"), ["icon"]="interface/icons/skill_thi3-1", ["enable"]=true,
		{["conditionType"]="isTargeted", ["value"]=false},
		{["conditionType"]="isRequest", ["value"]=true},
	},
	{
		-- イロード
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Decay"), ["icon"]="interface/icons/skill_thi_new45-6.dds", ["enable"]=true,
		{["conditionType"]="playerEffect", {["effectType"]="original", ["name"]=Kitty.T("skill", "Poison"), ["threshold"]=0.6}},
		{["conditionType"]="playerNonEffect", {["effectType"]="original", ["name"]=Kitty.T("skill", "Decay"), ["threshold"]=0.6}},
		{["conditionType"]="playerEnergy", ["min"]=60, ["max"]=nil},
	},
	{
		-- ポイズンインフェクション
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Poisonous Infection"), ["icon"]="interface/icons/skill_thi_new35-4", ["enable"]=true,
	},
	{
		-- タッチオブデス
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Death's Touch"), ["icon"]="interface/icons/skill_thi_new45-3", ["enable"]=true,
	},
	{
		-- ブロウ
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Slash"), ["icon"]="interface/icons/skill_war1-1", ["enable"]=true,
		{["conditionType"]="playerTension", ["min"]=70, ["max"]=nil},
	},
	{
		-- ダークネス
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Shadowstab"), ["icon"]="interface/icons/skill_thi1-1", ["enable"]=true,
		{["conditionType"]="targetNonEffect", {["effectType"]="original", ["name"]=Kitty.T("skill", "Shadowstab"), ["threshold"]=0.6}},
		{["conditionType"]="playerEnergy", ["min"]=40, ["max"]=nil},
	},
	{
		-- ダーティトリック
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Low Blow"), ["icon"]="interface/icons/skill_thi12-1", ["enable"]=true,
		{["conditionType"]="targetNonEffect", {["effectType"]="original", ["name"]=Kitty.T("skill", "Low Blow"), ["threshold"]=0.6}},
	},
	{
		-- ウーンドアタック
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Wound Attack"), ["icon"]="interface/icons/skill_thi6-1", ["enable"]=true,
	},
	{
		-- ダーティトリック
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Low Blow"), ["icon"]="interface/icons/skill_thi12-1", ["enable"]=true,
		{["conditionType"]="playerEnergy", ["min"]=60, ["max"]=nil},
	},
	{
		-- ブロウ
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Slash"), ["icon"]="interface/icons/skill_war1-1", ["enable"]=true,
	},
},

{
	["info"]={["name"]="Default_RK", ["class"]="RK", ["target"]="all"},
	{
		-- 共通コマンド
		["commandType"]="proc", ["commandName"]=Kitty.T("name", "CommonCommand"), ["icon"]="", ["enable"]=true,
		{["conditionType"]="playerNonEffect", {["effectType"]="original", ["name"]=Kitty.T("name", "Stun"), ["threshold"]=0.6}},
	},
	{
		-- ハイディング
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Hide"), ["icon"]="interface/icons/skill_thi3-2", ["enable"]=true,
		{["conditionType"]="playerEffect", {["effectType"]="original", ["name"]=Kitty.T("skill", "Vanish"), ["threshold"]=0.6}},
	},
	{
		-- サンクションアタック
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Sanction Attack"), ["icon"]="interface/icons/skill_kni6-1", ["enable"]=true,
		{["conditionType"]="targetIsPC", ["value"]=true},
	},
	{
		-- ハーツアヴォイド
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Evasion"), ["icon"]="interface/icons/skill_thi72-1", ["enable"]=true,
		{["conditionType"]="targetIsBoss", ["value"]=true},
		{["conditionType"]="isTargeted", ["value"]=true},
		{["conditionType"]="playerIsFearless", ["value"]=false},
	},
	{
		-- エスケープ
		["commandType"]="suitskill", ["commandName"]=Kitty.T("skill", "Escape"), ["icon"]="interface/Icons/skill_panel_icons/sp_thi_002.dds", ["enable"]=true,
		{["conditionType"]="playerEffect", {["effectType"]="original", ["name"]=Kitty.T("name", "Stun"), ["threshold"]=0.6}},
	},
	{
		-- バッククリープ
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Shadow Step"), ["icon"]="interface/icons/skill_thi27-2", ["enable"]=true,
		{["conditionType"]="targetIsCaster", ["value"]=true},
		{["conditionType"]="playerEffect", {["effectType"]="original", ["name"]=Kitty.T("skill", "Lightning"), ["threshold"]=0.6}},
	},
	{
		-- パニッシュ
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Punishment"), ["icon"]="interface/icons/skill_kni1-2", ["enable"]=false,
		{["conditionType"]="targetEffect", {["effectType"]="original", ["name"]=Kitty.T("effect", "HolyStrikeLv3"), ["threshold"]=0}},
	},
	{
		-- デッドアングルアタック
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Blind Spot"), ["icon"]="interface/icons/skill_thi3-1", ["enable"]=true,
		{["conditionType"]="isTargeted", ["value"]=false},
		{["conditionType"]="isRequest", ["value"]=true},
	},
	{
		-- ダーティトリック
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Low Blow"), ["icon"]="interface/icons/skill_thi12-1", ["enable"]=true,
		{["conditionType"]="targetIsPC", ["value"]=true},
		{["conditionType"]="playerEnergy", ["min"]=40, ["max"]=nil},
	},
	{
		-- ダークネス
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Shadowstab"), ["icon"]="interface/icons/skill_thi1-1", ["enable"]=true,
		{["conditionType"]="targetNonEffect", {["effectType"]="original", ["name"]=Kitty.T("skill", "Shadowstab"), ["threshold"]=0.6}},
		{["conditionType"]="playerEnergy", ["min"]=40, ["max"]=nil},
	},
	{
		-- ダーティトリック
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Low Blow"), ["icon"]="interface/icons/skill_thi12-1", ["enable"]=true,
		{["conditionType"]="targetNonEffect", {["effectType"]="original", ["name"]=Kitty.T("skill", "Low Blow"), ["threshold"]=0.6}},
	},
	{
		-- ウーンドアタック
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Wound Attack"), ["icon"]="interface/icons/skill_thi6-1", ["enable"]=true,
	},
	{
		-- ダーティトリック
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Low Blow"), ["icon"]="interface/icons/skill_thi12-1", ["enable"]=true,
		{["conditionType"]="playerEnergy", ["min"]=40, ["max"]=nil},
	},
	{
		-- ディフェンスダウン
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Disarmament"), ["icon"]="interface/icons/skill_kni12-1", ["enable"]=true,
		{["conditionType"]="targetNonEffect", {["effectType"]="original", ["name"]=Kitty.T("effect", "DisarmamentLv4"), ["threshold"]=4.0}},
	},
	{
		-- ホーリーソード
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Holy Strike"), ["icon"]="interface/icons/skill_kni5-1.dds", ["enable"]=true,
	},
},

{
	["info"]={["name"]="Default_RM", ["class"]="RM", ["target"]="all"},
	{
		-- 共通コマンド
		["commandType"]="proc", ["commandName"]=Kitty.T("name", "CommonCommand"), ["icon"]="", ["enable"]=true,
		{["conditionType"]="playerNonEffect", {["effectType"]="original", ["name"]=Kitty.T("name", "Stun"), ["threshold"]=0.6}},
	},
	{
		-- クイックシャドウ
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Instant Shadow"), ["icon"]="interface/Icons/elf_skill/skill_thi_mag40.dds", ["enable"]=true,
		{["conditionType"]="inRange", ["value"]=Kitty.T("skill", "Instant Shadow")},
	},
	{
		-- ハイディング
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Hide"), ["icon"]="interface/icons/skill_thi3-2", ["enable"]=true,
		{["conditionType"]="playerEffect", {["effectType"]="original", ["name"]=Kitty.T("skill", "Vanish"), ["threshold"]=0.6}},
	},
	{
		-- ハーツアヴォイド
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Evasion"), ["icon"]="interface/icons/skill_thi72-1", ["enable"]=true,
		{["conditionType"]="targetIsBoss", ["value"]=true},
		{["conditionType"]="isTargeted", ["value"]=true},
		{["conditionType"]="playerIsFearless", ["value"]=false},
	},
	{
		-- エスケープ
		["commandType"]="suitskill", ["commandName"]=Kitty.T("skill", "Escape"), ["icon"]="interface/Icons/skill_panel_icons/sp_thi_002.dds", ["enable"]=true,
		{["conditionType"]="playerEffect", {["effectType"]="original", ["name"]=Kitty.T("name", "Stun"), ["threshold"]=0.6}},
	},
	{
		-- サイレンス
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Silence"), ["icon"]="interface/icons/skill_aug39-2", ["enable"]=true,
		{["conditionType"]="targetIsCaster", ["value"]=true},
		{["conditionType"]="playerIsFearless", ["value"]=false},
	},
	{
		-- ダブルスロー
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Double Throw"), ["icon"]="interface/icons/skill_thi21-2", ["enable"]=true,
	},
	{
		-- スローイング
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Throw"), ["icon"]="interface/icons/skill_thi1-2", ["enable"]=true,
	},
	{
		-- バッククリープ
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Shadow Step"), ["icon"]="interface/icons/skill_thi27-2", ["enable"]=true,
		{["conditionType"]="targetIsCaster", ["value"]=true},
		{["conditionType"]="playerEffect", {["effectType"]="original", ["name"]=Kitty.T("skill", "Lightning"), ["threshold"]=0.6}},
	},
	{
		-- フラワーレイン
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Day of Rain"), ["icon"]="interface/Icons/elf_skill/skill_thi_mag30.dds", ["enable"]=true,
	},
	{
		-- デッドアングルアタック
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Blind Spot"), ["icon"]="interface/icons/skill_thi3-1", ["enable"]=true,
		{["conditionType"]="isTargeted", ["value"]=false},
		{["conditionType"]="isRequest", ["value"]=true},
	},
	{
		-- ダーティトリック
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Low Blow"), ["icon"]="interface/icons/skill_thi12-1", ["enable"]=true,
		{["conditionType"]="targetIsPC", ["value"]=true},
		{["conditionType"]="playerEnergy", ["min"]=60, ["max"]=nil},
	},
	{
		-- ダークネス
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Shadowstab"), ["icon"]="interface/icons/skill_thi1-1", ["enable"]=true,
		{["conditionType"]="targetNonEffect", {["effectType"]="original", ["name"]=Kitty.T("skill", "Shadowstab"), ["threshold"]=0.6}},
	},
	{
		-- ダーティトリック
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Low Blow"), ["icon"]="interface/icons/skill_thi12-1", ["enable"]=true,
		{["conditionType"]="targetNonEffect", {["effectType"]="original", ["name"]=Kitty.T("skill", "Low Blow"), ["threshold"]=0.6}},
	},
	{
		-- ウーンドアタック
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Wound Attack"), ["icon"]="interface/icons/skill_thi6-1", ["enable"]=true,
	},
	{
		-- ダーティトリック
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Low Blow"), ["icon"]="interface/icons/skill_thi12-1", ["enable"]=true,
		{["conditionType"]="playerEnergy", ["min"]=60, ["max"]=nil},
	},
},

{
	["info"]={["name"]="Default_S", ["class"]="S", ["target"]="all"},
	{
		-- 共通コマンド
		["commandType"]="proc", ["commandName"]=Kitty.T("name", "CommonCommand"), ["icon"]="", ["enable"]=true,
		{["conditionType"]="playerNonEffect", {["effectType"]="original", ["name"]=Kitty.T("name", "Stun"), ["threshold"]=0.6}},
	},
	{
		-- シークエンスショット
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Combo Shot"), ["icon"]="interface/icons/skill_ran3-1", ["enable"]=true,
	},
	{
		-- ピアッシングアロー
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Piercing Arrow"), ["icon"]="interface/icons/skill_ran21-1", ["enable"]=true,
	},
	{
		-- ブラッディアロー
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Vampire Arrows"), ["icon"]="interface/icons/skill_ran6-3.dds", ["enable"]=true,
	},
	{
		-- リフレクトショット
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Reflected Shot"), ["icon"]="interface/icons/skill_ran27-1", ["enable"]=true,
	},
},

{
	["info"]={["name"]="Default_SK", ["class"]="SK", ["target"]="all"},
	{
		-- 共通コマンド
		["commandType"]="proc", ["commandName"]=Kitty.T("name", "CommonCommand"), ["icon"]="", ["enable"]=true,
		{["conditionType"]="playerNonEffect", {["effectType"]="original", ["name"]=Kitty.T("name", "Stun"), ["threshold"]=0.6}},
	},
	{
		-- シークエンスショット
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Combo Shot"), ["icon"]="interface/icons/skill_ran3-1", ["enable"]=true,
	},
	{
		-- ピアッシングアロー
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Piercing Arrow"), ["icon"]="interface/icons/skill_ran21-1", ["enable"]=true,
	},
	{
		-- ブラッディアロー
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Vampire Arrows"), ["icon"]="interface/icons/skill_ran6-3.dds", ["enable"]=true,
	},
	{
		-- リフレクトショット
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Reflected Shot"), ["icon"]="interface/icons/skill_ran27-1", ["enable"]=true,
	},
	{
		-- ディフェンスダウン
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Disarmament"), ["icon"]="interface/icons/skill_kni12-1", ["enable"]=true,
	},
},

{
	["info"]={["name"]="Default_W", ["class"]="W", ["target"]="all"},
	{
		-- 共通コマンド
		["commandType"]="proc", ["commandName"]=Kitty.T("name", "CommonCommand"), ["icon"]="", ["enable"]=true,
		{["conditionType"]="playerNonEffect", {["effectType"]="original", ["name"]=Kitty.T("name", "Stun"), ["threshold"]=0.6}},
	},
	{
		-- 不敗の王者
		["commandType"]="proc", ["commandName"]=Kitty.T("name", "ExtraUndefeatableKing"), ["icon"]="interface/Icons/skill_panel_icons/sp_war_001.dds", ["enable"]=true,
	},
	{
		-- サバイバルオーラ
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Survival Instinct W"), ["icon"]="interface/icons/skill_war36-1", ["enable"]=true,
		{["conditionType"]="playerHealth", ["min"]=nil, ["max"]=49},
	},
	{
		-- W(片手)
		["commandType"]="proc", ["commandName"]=Kitty.T("name", "WSingleHand"), ["icon"]="", ["enable"]=true,
		{["conditionType"]="isTwoHanded", ["value"]=false},
	},
	{
		-- W(両手)
		["commandType"]="proc", ["commandName"]=Kitty.T("name", "WTwoHand"), ["icon"]="", ["enable"]=true,
		{["conditionType"]="isTwoHanded", ["value"]=true},
	},
},

{
	["info"]={["name"]="Default_WK", ["class"]="WK", ["target"]="all"},
	{
		-- 共通コマンド
		["commandType"]="proc", ["commandName"]=Kitty.T("name", "CommonCommand"), ["icon"]="", ["enable"]=true,
		{["conditionType"]="playerNonEffect", {["effectType"]="original", ["name"]=Kitty.T("name", "Stun"), ["threshold"]=0.6}},
	},
	{
		-- ペインディスリガード
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Ignore Pain"), ["icon"]="interface/icons/skill_war_new50-2", ["enable"]=true,
		{["conditionType"]="playerEffect", {["effectType"]="original", ["name"]=Kitty.T("name", "Stun"), ["threshold"]=0.6}},
	},
	{
		-- 不敗の王者
		["commandType"]="proc", ["commandName"]=Kitty.T("name", "ExtraUndefeatableKing"), ["icon"]="interface/Icons/skill_panel_icons/sp_war_001.dds", ["enable"]=true,
	},
	{
		-- サバイバルオーラ
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Survival Instinct W"), ["icon"]="interface/icons/skill_war36-1", ["enable"]=true,
		{["conditionType"]="playerHealth", ["min"]=nil, ["max"]=49},
	},
	{
		-- WK(片手)
		["commandType"]="proc", ["commandName"]=Kitty.T("name", "WKSingleHand"), ["icon"]="", ["enable"]=true,
		{["conditionType"]="isTwoHanded", ["value"]=false},
	},
	{
		-- WK(両手)
		["commandType"]="proc", ["commandName"]=Kitty.T("name", "WKTwoHand"), ["icon"]="", ["enable"]=true,
		{["conditionType"]="isTwoHanded", ["value"]=true},
	},
},

{
	["info"]={["name"]="Default_WR", ["class"]="WR", ["target"]="all"},
	{
		-- 共通コマンド
		["commandType"]="proc", ["commandName"]=Kitty.T("name", "CommonCommand"), ["icon"]="", ["enable"]=true,
		{["conditionType"]="playerNonEffect", {["effectType"]="original", ["name"]=Kitty.T("name", "Stun"), ["threshold"]=0.6}},
	},
	{
		-- 不敗の王者
		["commandType"]="proc", ["commandName"]=Kitty.T("name", "ExtraUndefeatableKing"), ["icon"]="interface/Icons/skill_panel_icons/sp_war_001.dds", ["enable"]=true,
	},
	{
		-- サバイバルオーラ
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Survival Instinct W"), ["icon"]="interface/icons/skill_war36-1", ["enable"]=true,
		{["conditionType"]="playerHealth", ["min"]=nil, ["max"]=49},
	},
	{
		-- ブラッディロンド
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Blood Dance"), ["icon"]="interface/icons/skill_war_new20-2", ["enable"]=true,
	},
	{
		-- 電光石火
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Thunder"), ["icon"]="interface/icons/skill_war15-1", ["enable"]=true,
		{["conditionType"]="targetEffect", {["effectType"]="original", ["name"]=Kitty.T("skill", "Probing Attack"), ["threshold"]=0.6}},
		{["conditionType"]="isTwoHanded", ["value"]=false},
	},
	{
		-- クラッシュソード
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Splitting Chop"), ["icon"]="interface/icons/skill_war_new40-2.dds", ["enable"]=true,
		{["conditionType"]="targetEffect", {["effectType"]="original", ["name"]=Kitty.T("skill", "Probing Attack"), ["threshold"]=0.6}},
	},
	{
		-- アタックチャンス
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Probing Attack"), ["icon"]="interface/icons/skill_war3-2", ["enable"]=true,
		{["conditionType"]="canCast", {["name"]=Kitty.T("skill", "Splitting Chop"), ["threshold"]=0.6}},
		{["conditionType"]="targetEffect", {["effectType"]="original", ["name"]=Kitty.T("skill", "Open Flank"), ["threshold"]=0.6}},
	},
	{
		-- ブラッシュストライク
		["commandType"]="suitskill", ["commandName"]=Kitty.T("skill", "Brash Ferocity Strike"), ["icon"]="interface/Icons/skill_panel_icons/sp_war_z21_001.dds", ["enable"]=true,
		{["conditionType"]="targetEffect", {["effectType"]="original", ["name"]=Kitty.T("skill", "Probing Attack"), ["threshold"]=0.6}},
	},
	{
		-- シャープアタック
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Keen Attack"), ["icon"]="interface/icons/skill_war_new35-2", ["enable"]=true,
		{["conditionType"]="targetEffect", {["effectType"]="original", ["name"]=Kitty.T("skill", "Open Flank"), ["threshold"]=0.6}},
	},
	{
		-- ガードブレイク
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Open Flank"), ["icon"]="interface/icons/skill_thi3-1.dds", ["enable"]=true,
	},
	{
		-- ブロウ
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Slash"), ["icon"]="interface/icons/skill_war1-1", ["enable"]=true,
		{["conditionType"]="playerTension", ["min"]=60, ["max"]=nil},
	},
	{
		-- ダークネス
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Shadowstab"), ["icon"]="interface/icons/skill_thi1-1", ["enable"]=true,
	},
},

{
	["info"]={["name"]="Default_WS", ["class"]="WS", ["target"]="all"},
	{
		-- 共通コマンド
		["commandType"]="proc", ["commandName"]=Kitty.T("name", "CommonCommand"), ["icon"]="", ["enable"]=true,
		{["conditionType"]="playerNonEffect", {["effectType"]="original", ["name"]=Kitty.T("name", "Stun"), ["threshold"]=0.6}},
	},
	{
		-- 不敗の王者
		["commandType"]="proc", ["commandName"]=Kitty.T("name", "ExtraUndefeatableKing"), ["icon"]="interface/Icons/skill_panel_icons/sp_war_001.dds", ["enable"]=true,
	},
	{
		-- サバイバルオーラ
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Survival Instinct W"), ["icon"]="interface/icons/skill_war36-1", ["enable"]=true,
		{["conditionType"]="playerHealth", ["min"]=nil, ["max"]=49},
	},
	{
		-- ブラッシュストライク
		["commandType"]="suitskill", ["commandName"]=Kitty.T("skill", "Brash Ferocity Strike"), ["icon"]="interface/Icons/skill_panel_icons/sp_war_z21_001.dds", ["enable"]=true,
		{["conditionType"]="targetEffect", {["effectType"]="original", ["name"]=Kitty.T("skill", "Probing Attack"), ["threshold"]=0.6}},
	},
	{
		-- ガードブレイク
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Open Flank"), ["icon"]="interface/icons/skill_thi3-1.dds", ["enable"]=true,
		{["conditionType"]="inRange", ["value"]=Kitty.T("skill", "Open Flank")},
	},
	{
		-- スナイプウーンド
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Aim for the Wound"), ["icon"]="interface/icons/skill_war_new15-1", ["enable"]=true,
	},
	{
		-- ブラッディアロー
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Vampire Arrows"), ["icon"]="interface/icons/skill_ran6-3.dds", ["enable"]=true,
		{["conditionType"]="playerFocus", ["min"]=50, ["max"]=nil},
	},
	{
		-- ソードオーラ
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Sword Breath"), ["icon"]="interface/icons/skill_war_new35-1", ["enable"]=true,
		{["conditionType"]="playerFocus", ["min"]=50, ["max"]=nil},
	},
	{
		-- ガードブレイク
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Open Flank"), ["icon"]="interface/icons/skill_thi3-1.dds", ["enable"]=true,
	},
	{
		-- ショット
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Shot"), ["icon"]="interface/icons/skill_ran1-2", ["enable"]=true,
	},
	{
		-- ブロウ
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Slash"), ["icon"]="interface/icons/skill_war1-1", ["enable"]=true,
	},
},

{
	["info"]={["name"]="Default_WM", ["class"]="WM", ["target"]="all"},
	{
		-- 共通コマンド
		["commandType"]="proc", ["commandName"]=Kitty.T("name", "CommonCommand"), ["icon"]="", ["enable"]=true,
		{["conditionType"]="playerNonEffect", {["effectType"]="original", ["name"]=Kitty.T("name", "Stun"), ["threshold"]=0.6}},
	},
	{
		-- 不敗の王者
		["commandType"]="proc", ["commandName"]=Kitty.T("name", "ExtraUndefeatableKing"), ["icon"]="interface/Icons/skill_panel_icons/sp_war_001.dds", ["enable"]=true,
	},
	{
		-- サイレンス
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Silence"), ["icon"]="interface/icons/skill_aug39-2", ["enable"]=true,
		{["conditionType"]="targetIsCaster", ["value"]=true},
		{["conditionType"]="playerIsFearless", ["value"]=false},
	},
	{
		-- ガードオーラ
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Defensive Formation"), ["icon"]="interface/icons/skill_war24-2", ["enable"]=false,
	},
	{
		-- サバイバルオーラ
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Survival Instinct W"), ["icon"]="interface/icons/skill_war36-1", ["enable"]=true,
		{["conditionType"]="playerHealth", ["min"]=nil, ["max"]=49},
	},
	{
		-- サイバーンレイ
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Lightning Burn Weapon"), ["icon"]="interface/Icons/elf_skill/skill_war_mag60.dds", ["enable"]=true,
		{["conditionType"]="playerNonEffect", {["effectType"]="original", ["name"]=Kitty.T("skill", "Lightning Burn Weapon"), ["threshold"]=0.6}},
	},
	{
		-- エレクトロ
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Electrical Rage"), ["icon"]="interface/icons/skill_war_new15-3", ["enable"]=true,
		{["conditionType"]="playerNonEffect", {["effectType"]="original", ["name"]=Kitty.T("effect", "ThunderBoostLv3"), ["threshold"]=1.6}},
	},
	{
		-- ライトニングショック
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Lightning's Touch"), ["icon"]="interface/icons/skill_war_new20-4", ["enable"]=true,
	},
},

{
	["info"]={["name"]="Default_KW", ["class"]="KW", ["target"]="all"},
	{
		-- 共通コマンド
		["commandType"]="proc", ["commandName"]=Kitty.T("name", "CommonCommand"), ["icon"]="", ["enable"]=true,
		{["conditionType"]="playerNonEffect", {["effectType"]="original", ["name"]=Kitty.T("name", "Stun"), ["threshold"]=0.6}},
	},
	{
		-- ホーリーヘイト
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Threaten"), ["icon"]="interface/icons/skill_kni16-1", ["enable"]=true,
		{["conditionType"]="targetEffect", {["effectType"]="original", ["name"]=Kitty.T("effect", "HolySealLv3"), ["threshold"]=0.6}},
	},
	{
		-- ブロウ
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Slash"), ["icon"]="interface/icons/skill_war1-1", ["enable"]=true,
		{["conditionType"]="playerTension", ["min"]=75, ["max"]=nil},
	},
	{
		-- ディフェンスダウン
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Disarmament"), ["icon"]="interface/icons/skill_kni12-1", ["enable"]=true,
		{["conditionType"]="targetNonEffect", {["effectType"]="original", ["name"]=Kitty.T("effect", "DisarmamentLv4"), ["threshold"]=4.0}},
	},
	{
		-- ブロウ
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Slash"), ["icon"]="interface/icons/skill_war1-1", ["enable"]=true,
	},
	{
		-- ホーリーソード
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Holy Strike"), ["icon"]="interface/icons/skill_kni5-1.dds", ["enable"]=true,
	},
},

{
	["info"]={["name"]="Default_KR", ["class"]="KR", ["target"]="all"},
	{
		-- 共通コマンド
		["commandType"]="proc", ["commandName"]=Kitty.T("name", "CommonCommand"), ["icon"]="", ["enable"]=true,
		{["conditionType"]="playerNonEffect", {["effectType"]="original", ["name"]=Kitty.T("name", "Stun"), ["threshold"]=0.6}},
	},
	{
		-- ホーリーヘイト
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Threaten"), ["icon"]="interface/icons/skill_kni16-1", ["enable"]=true,
		{["conditionType"]="targetEffect", {["effectType"]="original", ["name"]=Kitty.T("effect", "HolySealLv3"), ["threshold"]=0.6}},
	},
	{
		-- ダークネス
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Shadowstab"), ["icon"]="interface/icons/skill_thi1-1", ["enable"]=true,
		{["conditionType"]="playerEnergy", ["min"]=40, ["max"]=nil},
	},
	{
		-- ディフェンスダウン
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Disarmament"), ["icon"]="interface/icons/skill_kni12-1", ["enable"]=true,
		{["conditionType"]="targetNonEffect", {["effectType"]="original", ["name"]=Kitty.T("effect", "DisarmamentLv4"), ["threshold"]=4.0}},
	},
	{
		-- ダークネス
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Shadowstab"), ["icon"]="interface/icons/skill_thi1-1", ["enable"]=true,
	},
	{
		-- ホーリーソード
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Holy Strike"), ["icon"]="interface/icons/skill_kni5-1.dds", ["enable"]=true,
	},
},

{
	["info"]={["name"]="Default_KS", ["class"]="KS", ["target"]="all"},
	{
		-- 共通コマンド
		["commandType"]="proc", ["commandName"]=Kitty.T("name", "CommonCommand"), ["icon"]="", ["enable"]=true,
		{["conditionType"]="playerNonEffect", {["effectType"]="original", ["name"]=Kitty.T("name", "Stun"), ["threshold"]=0.6}},
	},
	{
		-- ホーリーヘイト
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Threaten"), ["icon"]="interface/icons/skill_kni16-1", ["enable"]=true,
		{["conditionType"]="targetEffect", {["effectType"]="original", ["name"]=Kitty.T("effect", "HolySealLv3"), ["threshold"]=0.6}},
	},
	{
		-- ヘイトアタック
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Hatred Strike"), ["icon"]="interface/icons/skill_kni12-2", ["enable"]=true,
	},
	{
		-- シールドブラスト
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Whirlwind Shield"), ["icon"]="interface/icons/skill_kni20-1.dds", ["enable"]=true,
	},
	{
		-- ホーリーソード
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Holy Strike"), ["icon"]="interface/icons/skill_kni5-1.dds", ["enable"]=true,
	},
},

{
	["info"]={["name"]="Default_KP", ["class"]="KP", ["target"]="all"},
	{
		-- 共通コマンド
		["commandType"]="proc", ["commandName"]=Kitty.T("name", "CommonCommand"), ["icon"]="", ["enable"]=true,
		{["conditionType"]="playerNonEffect", {["effectType"]="original", ["name"]=Kitty.T("name", "Stun"), ["threshold"]=0.6}},
	},
	{
		-- ホーリーヘイト
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Threaten"), ["icon"]="interface/icons/skill_kni16-1", ["enable"]=true,
		{["conditionType"]="targetEffect", {["effectType"]="original", ["name"]=Kitty.T("effect", "HolySealLv3"), ["threshold"]=0.6}},
		{["conditionType"]="isRequest", ["value"]=true},
	},
	{
		-- ホーリーソード
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Holy Strike"), ["icon"]="interface/icons/skill_kni5-1.dds", ["enable"]=true,
		{["conditionType"]="isRequest", ["value"]=true},
	},
	{
		-- ディフェンスダウン
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Disarmament"), ["icon"]="interface/icons/skill_kni12-1", ["enable"]=true,
		{["conditionType"]="isRequest", ["value"]=false},
	},
},

{
	["info"]={["name"]="Default_MP", ["class"]="MP", ["target"]="none"},
	{
		-- ライトニング
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Discharge"), ["icon"]="interface/icons/skill_mag24-1", ["enable"]=true,
	},
	{
		-- パーガトリファイア
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Purgatory Fire"), ["icon"]="interface/icons/skill_mag72-1.dds", ["enable"]=true,
	},
},

{
	["info"]={["name"]="Default_MP_All", ["class"]="MP", ["target"]="all"},
	{
		-- 共通コマンド
		["commandType"]="proc", ["commandName"]=Kitty.T("name", "CommonCommand"), ["icon"]="", ["enable"]=true,
		{["conditionType"]="playerNonEffect", {["effectType"]="original", ["name"]=Kitty.T("name", "Stun"), ["threshold"]=0.6}},
	},
	{
		-- サンダー召喚
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Lightning"), ["icon"]="interface/icons/skill_mag3-1", ["enable"]=true,
		{["conditionType"]="targetNonEffect",	{["effectType"]="original", ["name"]=Kitty.T("skill", "Holy Light Protection"), ["threshold"]=0.6},
												{["effectType"]="original", ["name"]=Kitty.T("skill", "Ignore Pain"), ["threshold"]=0.6}},
	},
	{
		-- ファイヤボール
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Fireball"), ["icon"]="interface/icons/skill_mag1-1", ["enable"]=true,
	},
	{
		-- アクアスイフト
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Rising Tide"), ["icon"]="interface/icons/skill_aug1-1", ["enable"]=true,
	},
	{
		-- マジックトリック
		["commandType"]="proc", ["commandName"]=Kitty.T("name", "ExtraMagicTricks"), ["icon"]="interface/icons/skill_panel_icons/sp_mag_006.dds", ["enable"]=true,
	},
	{
		-- サンダーボール
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Electric Bolt"), ["icon"]="interface/icons/skill_mag_new50-5", ["enable"]=true,
		{["conditionType"]="targetNonEffect", {["effectType"]="original", ["name"]=Kitty.T("skill", "Electric Bolt"), ["threshold"]=0.6}},
	},
	{
		-- ギャラクシー
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Meteor Shower"), ["icon"]="interface/icons/skill_mag54-1", ["enable"]=true,
	},
},

{
	["info"]={["name"]="Default_MP_PC", ["class"]="MP", ["target"]="pc"},
	{
		-- 共通コマンド
		["commandType"]="proc", ["commandName"]=Kitty.T("name", "CommonCommand"), ["icon"]="", ["enable"]=true,
		{["conditionType"]="playerNonEffect", {["effectType"]="original", ["name"]=Kitty.T("name", "Stun"), ["threshold"]=0.6}},
	},
	{
		-- サイレンス
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Silence"), ["icon"]="interface/icons/skill_aug39-2", ["enable"]=true,
		{["conditionType"]="targetIsCaster", ["value"]=true},
		{["conditionType"]="inRange", ["value"]=Kitty.T("skill", "Silence")},
		{["conditionType"]="playerIsFearless", ["value"]=false},
	},
	{
		-- サンダー召喚
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Lightning"), ["icon"]="interface/icons/skill_mag3-1", ["enable"]=true,
		{["conditionType"]="inRange", ["value"]=Kitty.T("skill", "Lightning")},
		{["conditionType"]="targetNonEffect",	{["effectType"]="original", ["name"]=Kitty.T("skill", "Holy Light Protection"), ["threshold"]=0.6},
												{["effectType"]="original", ["name"]=Kitty.T("skill", "Ignore Pain"), ["threshold"]=0.6}},
	},
	{
		-- ファイヤボール
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Fireball"), ["icon"]="interface/icons/skill_mag1-1", ["enable"]=true,
	},
	{
		-- アクアスイフト
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Rising Tide"), ["icon"]="interface/icons/skill_aug1-1", ["enable"]=true,
	},
	{
		-- フェニックス
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Phoenix"), ["icon"]="interface/icons/skill_mag21-2", ["enable"]=true,
	},
	{
		-- サイレンス
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Silence"), ["icon"]="interface/icons/skill_aug39-2", ["enable"]=true,
		{["conditionType"]="targetIsCaster", ["value"]=true},
		{["conditionType"]="playerIsFearless", ["value"]=false},
	},
	{
		-- サンダー召喚
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Lightning"), ["icon"]="interface/icons/skill_mag3-1", ["enable"]=true,
		{["conditionType"]="targetNonEffect",	{["effectType"]="original", ["name"]=Kitty.T("skill", "Holy Light Protection"), ["threshold"]=0.6},
												{["effectType"]="original", ["name"]=Kitty.T("skill", "Ignore Pain"), ["threshold"]=0.6}},
	},
	{
		["commandType"]="proc", ["commandName"]=Kitty.T("name", "ExtraMagicTricks"), ["icon"]="interface/icons/skill_panel_icons/sp_mag_006.dds", ["enable"]=true,
	},
	{
		-- サンダーボール
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Electric Bolt"), ["icon"]="interface/icons/skill_mag_new50-5", ["enable"]=true,
		{["conditionType"]="targetNonEffect", {["effectType"]="original", ["name"]=Kitty.T("skill", "Electric Bolt"), ["threshold"]=0.6}},
	},
	{
		-- ギャラクシー
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Meteor Shower"), ["icon"]="interface/icons/skill_mag54-1", ["enable"]=true,
	},
},

{
	["info"]={["name"]="Default_MK", ["class"]="MK", ["target"]="none"},
	{
		-- ライトニング
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Discharge"), ["icon"]="interface/icons/skill_mag24-1", ["enable"]=true,
	},
	{
		-- パーガトリファイア
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Purgatory Fire"), ["icon"]="interface/icons/skill_mag72-1.dds", ["enable"]=true,
	},
},

{
	["info"]={["name"]="Default_MK_All", ["class"]="MK", ["target"]="all"},
	{
		-- 共通コマンド
		["commandType"]="proc", ["commandName"]=Kitty.T("name", "CommonCommand"), ["icon"]="", ["enable"]=true,
		{["conditionType"]="playerNonEffect", {["effectType"]="original", ["name"]=Kitty.T("name", "Stun"), ["threshold"]=0.6}},
	},
	{
		-- サンダー召喚
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Lightning"), ["icon"]="interface/icons/skill_mag3-1", ["enable"]=true,
		{["conditionType"]="targetNonEffect",	{["effectType"]="original", ["name"]=Kitty.T("skill", "Holy Light Protection"), ["threshold"]=0.6},
												{["effectType"]="original", ["name"]=Kitty.T("skill", "Ignore Pain"), ["threshold"]=0.6}},
	},
	{
		-- ファイヤボール
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Fireball"), ["icon"]="interface/icons/skill_mag1-1", ["enable"]=true,
	},
	{
		-- ライトショック
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Light Charge"), ["icon"]="interface/icons/skill_mag_new35-4", ["enable"]=true,
	},
	{
		-- マジックトリック
		["commandType"]="proc", ["commandName"]=Kitty.T("name", "ExtraMagicTricks"), ["icon"]="interface/icons/skill_panel_icons/sp_mag_006.dds", ["enable"]=true,
	},
	{
		-- サンダーボール
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Electric Bolt"), ["icon"]="interface/icons/skill_mag_new50-5", ["enable"]=true,
		{["conditionType"]="targetNonEffect", {["effectType"]="original", ["name"]=Kitty.T("skill", "Electric Bolt"), ["threshold"]=0.6}},
	},
	{
		-- ギャラクシー
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Meteor Shower"), ["icon"]="interface/icons/skill_mag54-1", ["enable"]=true,
	},
},

{
	["info"]={["name"]="Default_MK_PC", ["class"]="MK", ["target"]="pc"},
	{
		-- 共通コマンド
		["commandType"]="proc", ["commandName"]=Kitty.T("name", "CommonCommand"), ["icon"]="", ["enable"]=true,
		{["conditionType"]="playerNonEffect", {["effectType"]="original", ["name"]=Kitty.T("name", "Stun"), ["threshold"]=0.6}},
	},
	{
		-- サイレンス
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Silence"), ["icon"]="interface/icons/skill_aug39-2", ["enable"]=true,
		{["conditionType"]="targetIsCaster", ["value"]=true},
		{["conditionType"]="playerIsFearless", ["value"]=false},
	},
	{
		-- サンダー召喚
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Lightning"), ["icon"]="interface/icons/skill_mag3-1", ["enable"]=true,
		{["conditionType"]="inRange", ["value"]=Kitty.T("skill", "Lightning")},
		{["conditionType"]="targetNonEffect",	{["effectType"]="original", ["name"]=Kitty.T("skill", "Holy Light Protection"), ["threshold"]=0.6},
												{["effectType"]="original", ["name"]=Kitty.T("skill", "Ignore Pain"), ["threshold"]=0.6}},
	},
	{
		-- ファイヤボール
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Fireball"), ["icon"]="interface/icons/skill_mag1-1", ["enable"]=true,
	},
	{
		-- ライトショック
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Light Charge"), ["icon"]="interface/icons/skill_mag_new35-4", ["enable"]=true,
	},
	{
		-- フェニックス
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Phoenix"), ["icon"]="interface/icons/skill_mag21-2", ["enable"]=true,
	},
	{
		-- サンダー召喚
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Lightning"), ["icon"]="interface/icons/skill_mag3-1", ["enable"]=true,
		{["conditionType"]="targetNonEffect",	{["effectType"]="original", ["name"]=Kitty.T("skill", "Holy Light Protection"), ["threshold"]=0.6},
												{["effectType"]="original", ["name"]=Kitty.T("skill", "Ignore Pain"), ["threshold"]=0.6}},
	},
	{
		-- マジックトリック
		["commandType"]="proc", ["commandName"]=Kitty.T("name", "ExtraMagicTricks"), ["icon"]="interface/icons/skill_panel_icons/sp_mag_006.dds", ["enable"]=true,
	},
	{
		-- サンダーボール
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Electric Bolt"), ["icon"]="interface/icons/skill_mag_new50-5", ["enable"]=true,
		{["conditionType"]="targetNonEffect", {["effectType"]="original", ["name"]=Kitty.T("skill", "Electric Bolt"), ["threshold"]=0.6}},
	},
	{
		-- ギャラクシー
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Meteor Shower"), ["icon"]="interface/icons/skill_mag54-1", ["enable"]=true,
	},
},

{
	["info"]={["name"]="Default_P", ["class"]="P", ["target"]="none"},
	{
		-- ウェーブレットアーマー
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Wave Armor"), ["icon"]="interface/icons/skill_aug3-2", ["enable"]=true,
		{["conditionType"]="playerNonEffect", {["effectType"]="original", ["name"]=Kitty.T("skill", "Wave Armor"), ["threshold"]=0.6}},
	},
	{
		-- リジェネレーション
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Regenerate"), ["icon"]="interface/icons/skill_aug3-1", ["enable"]=true,
		{["conditionType"]="playerNonEffect", {["effectType"]="original", ["name"]=Kitty.T("skill", "Regenerate"), ["threshold"]=1.0}},
	},
	{
		-- クイックヒール
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Urgent Heal"), ["icon"]="interface/icons/skill_aug42-3", ["enable"]=true,
	},
},

{
	["info"]={["name"]="Default_PM_All", ["class"]="PM", ["target"]="all"},
	{
		-- 共通コマンド
		["commandType"]="proc", ["commandName"]=Kitty.T("name", "CommonCommand"), ["icon"]="", ["enable"]=true,
		{["conditionType"]="playerNonEffect", {["effectType"]="original", ["name"]=Kitty.T("name", "Stun"), ["threshold"]=0.6}},
	},
	{
		-- アイシクルウィンドエッジ
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Icewind Blade"), ["icon"]="interface/icons/skill_aug_new45-7.dds", ["enable"]=true,
	},
	{
		-- ファイヤボール
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Fireball"), ["icon"]="interface/icons/skill_mag1-1", ["enable"]=true,
	},
	{
		-- サンダー召喚
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Lightning"), ["icon"]="interface/icons/skill_mag3-1", ["enable"]=true,
		{["conditionType"]="targetNonEffect",	{["effectType"]="original", ["name"]=Kitty.T("skill", "Holy Light Protection"), ["threshold"]=0.6},
												{["effectType"]="original", ["name"]=Kitty.T("skill", "Ignore Pain"), ["threshold"]=0.6}},
	},
	{
		-- フロストデス
		["commandType"]="suitskill", ["commandName"]=Kitty.T("skill", "Frost Death"), ["icon"]="interface/Icons/skill_panel_icons/sp_aug_z20_001", ["enable"]=true,
	},
	{
		-- フロストスカー
		["commandType"]="suitskill", ["commandName"]=Kitty.T("skill", "Frost Scars"), ["icon"]="interface/Icons/skill_panel_icons/sp_aug_003.dds", ["enable"]=true,
	},
	{
		-- フローズンコールド
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Bone Chill"), ["icon"]="interface/icons/skill_aug12-4", ["enable"]=true,
		{["conditionType"]="targetNonEffect",	{["effectType"]="original", ["name"]=Kitty.T("skill", "Bone Chill"), ["threshold"]=1.0}},
	},
	{
		-- ホーリーチェイン
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Chain of Light"), ["icon"]="interface/icons/skill_aug12-3.dds", ["enable"]=true,
	},
},

{
	["info"]={["name"]="Default_PM_PC", ["class"]="PM", ["target"]="pc"},
	{
		-- 共通コマンド
		["commandType"]="proc", ["commandName"]=Kitty.T("name", "CommonCommand"), ["icon"]="", ["enable"]=true,
		{["conditionType"]="playerNonEffect", {["effectType"]="original", ["name"]=Kitty.T("name", "Stun"), ["threshold"]=0.6}},
	},
	{
		-- サイレンス
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Silence"), ["icon"]="interface/icons/skill_aug39-2", ["enable"]=true,
		{["conditionType"]="targetIsCaster", ["value"]=true},
		{["conditionType"]="playerIsFearless", ["value"]=false},
	},
	{
		-- サンダー召喚
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Lightning"), ["icon"]="interface/icons/skill_mag3-1", ["enable"]=true,
		{["conditionType"]="inRange", ["value"]=Kitty.T("skill", "Lightning")},
		{["conditionType"]="targetNonEffect",	{["effectType"]="original", ["name"]=Kitty.T("skill", "Holy Light Protection"), ["threshold"]=0.6},
												{["effectType"]="original", ["name"]=Kitty.T("skill", "Ignore Pain"), ["threshold"]=0.6}},
	},
	{
		-- アイシクルウィンドエッジ
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Icewind Blade"), ["icon"]="interface/icons/skill_aug_new45-7.dds", ["enable"]=true,
	},
	{
		-- ファイヤボール
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Fireball"), ["icon"]="interface/icons/skill_mag1-1", ["enable"]=true,
	},
	{
		-- フロストデス
		["commandType"]="suitskill", ["commandName"]=Kitty.T("skill", "Frost Death"), ["icon"]="interface/Icons/skill_panel_icons/sp_aug_z20_001", ["enable"]=true,
	},
	{
		-- フロストスカー
		["commandType"]="suitskill", ["commandName"]=Kitty.T("skill", "Frost Scars"), ["icon"]="interface/Icons/skill_panel_icons/sp_aug_003.dds", ["enable"]=true,
	},
	{
		-- サンダー召喚
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Lightning"), ["icon"]="interface/icons/skill_mag3-1", ["enable"]=true,
		{["conditionType"]="targetNonEffect",	{["effectType"]="original", ["name"]=Kitty.T("skill", "Holy Light Protection"), ["threshold"]=0.6},
												{["effectType"]="original", ["name"]=Kitty.T("skill", "Ignore Pain"), ["threshold"]=0.6}},
	},
	{
		-- フローズンコールド
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Bone Chill"), ["icon"]="interface/icons/skill_aug12-4", ["enable"]=true,
		{["conditionType"]="targetNonEffect",	{["effectType"]="original", ["name"]=Kitty.T("skill", "Bone Chill"), ["threshold"]=1.0}},
	},
},

{
	["info"]={["name"]="Default_PK_All", ["class"]="PK", ["target"]="all"},
	{
		-- 共通コマンド
		["commandType"]="proc", ["commandName"]=Kitty.T("name", "CommonCommand"), ["icon"]="", ["enable"]=true,
		{["conditionType"]="playerNonEffect", {["effectType"]="original", ["name"]=Kitty.T("name", "Stun"), ["threshold"]=0.6}},
	},
	{
		-- アクアスイフト
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Rising Tide"), ["icon"]="interface/icons/skill_aug1-1", ["enable"]=true,
		{["conditionType"]="isTargeted", ["value"]=false},
	},
	{
		-- ホーリーチェイン
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Chain of Light"), ["icon"]="interface/icons/skill_aug12-3.dds", ["enable"]=true,
	},
	{
		-- フロストデス
		["commandType"]="suitskill", ["commandName"]=Kitty.T("skill", "Frost Death"), ["icon"]="interface/Icons/skill_panel_icons/sp_aug_z20_001", ["enable"]=true,
	},
	{
		-- フロストスカー
		["commandType"]="suitskill", ["commandName"]=Kitty.T("skill", "Frost Scars"), ["icon"]="interface/Icons/skill_panel_icons/sp_aug_003.dds", ["enable"]=true,
	},
	{
		-- フローズンコールド
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Bone Chill"), ["icon"]="interface/icons/skill_aug12-4", ["enable"]=true,
		{["conditionType"]="targetNonEffect",	{["effectType"]="original", ["name"]=Kitty.T("skill", "Bone Chill"), ["threshold"]=1.0}},
	},
	{
		-- アクアスイフト
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Rising Tide"), ["icon"]="interface/icons/skill_aug1-1", ["enable"]=true,
	},
},

{
	["info"]={["name"]="Default_PK_PC", ["class"]="PK", ["target"]="pc"},
	{
		-- 共通コマンド
		["commandType"]="proc", ["commandName"]=Kitty.T("name", "CommonCommand"), ["icon"]="", ["enable"]=true,
		{["conditionType"]="playerNonEffect", {["effectType"]="original", ["name"]=Kitty.T("name", "Stun"), ["threshold"]=0.6}},
	},
	{
		-- ディスプレンシールド
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Shield of Atonement"), ["icon"]="interface/icons/skill_kni6-1", ["enable"]=true,
		{["conditionType"]="targetIsCaster", ["value"]=false},
	},
	{
		-- フローズンコールド
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Bone Chill"), ["icon"]="interface/icons/skill_aug12-4", ["enable"]=true,
		{["conditionType"]="targetNonEffect", {["effectType"]="original", ["name"]=Kitty.T("skill", "Bone Chill"), ["threshold"]=2.0}},
	},
	{
		-- アイスフォガー
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Ice Fog Rank 1"), ["icon"]="interface/icons/skill_aug6-1", ["enable"]=true,
	},
	{
		-- フロストデス
		["commandType"]="suitskill", ["commandName"]=Kitty.T("skill", "Frost Death"), ["icon"]="interface/Icons/skill_panel_icons/sp_aug_z20_001", ["enable"]=true,
	},
	{
		-- フロストスカー
		["commandType"]="suitskill", ["commandName"]=Kitty.T("skill", "Frost Scars"), ["icon"]="interface/Icons/skill_panel_icons/sp_aug_003.dds", ["enable"]=true,
	},
	{
		-- ホーリーチェイン
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Chain of Light"), ["icon"]="interface/icons/skill_aug12-3.dds", ["enable"]=true,
	},
},

{
	["info"]={["name"]="Default_Wd", ["class"]="Wd", ["target"]="all"},
	{
		-- 共通コマンド
		["commandType"]="proc", ["commandName"]=Kitty.T("name", "CommonCommand"), ["icon"]="", ["enable"]=true,
		{["conditionType"]="playerNonEffect", {["effectType"]="original", ["name"]=Kitty.T("name", "Stun"), ["threshold"]=0.6}},
	},
	{
		-- アンタンブル
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Untamable"), ["icon"]="", ["enable"]=true,
	},
	{
		-- 十字斬り
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Cross Chop"), ["icon"]="", ["enable"]=true,
	},
	{
		-- 溜め斬り
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Charged Chop"), ["icon"]="interface/icons/elf_skill/skill_ward1-1.dds", ["enable"]=true,
		{["conditionType"]="isRequest", ["value"]=true},
	},
	{
		-- 木霊の力
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Power of the Wood Spirit"), ["icon"]="interface/icons/elf_skill/skill_ward8-1.dds", ["enable"]=true,
	},
},

{
	["info"]={["name"]="Default_WdS", ["class"]="WdS", ["target"]="all"},
	{
		-- 共通コマンド
		["commandType"]="proc", ["commandName"]=Kitty.T("name", "CommonCommand"), ["icon"]="", ["enable"]=true,
		{["conditionType"]="playerNonEffect", {["effectType"]="original", ["name"]=Kitty.T("name", "Stun"), ["threshold"]=0.6}},
	},
	{
		-- アンタンブル
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Untamable"), ["icon"]="", ["enable"]=true,
	},
	{
		-- ブラッディアロー
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Vampire Arrows"), ["icon"]="interface/icons/skill_ran6-3.dds", ["enable"]=true,
	},
	{
		-- 十字斬り
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Cross Chop"), ["icon"]="", ["enable"]=true,
	},
	{
		-- 溜め斬り
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Charged Chop"), ["icon"]="interface/icons/elf_skill/skill_ward1-1.dds", ["enable"]=true,
		{["conditionType"]="isRequest", ["value"]=true},
	},
},

{
	["info"]={["name"]="Default_WdW", ["class"]="WdW", ["target"]="all"},
	{
		-- 共通コマンド
		["commandType"]="proc", ["commandName"]=Kitty.T("name", "CommonCommand"), ["icon"]="", ["enable"]=true,
		{["conditionType"]="playerNonEffect", {["effectType"]="original", ["name"]=Kitty.T("name", "Stun"), ["threshold"]=0.6}},
	},
	{
		-- 十字斬り
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Cross Chop"), ["icon"]="", ["enable"]=true,
	},
	{
		-- フランティックソーニー
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Frantic Briar"), ["icon"]="interface/icons/elf_skill/skill_ward26-1.dds", ["enable"]=true,
	},
	{
		-- 木霊の力
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Power of the Wood Spirit"), ["icon"]="interface/icons/elf_skill/skill_ward8-1.dds", ["enable"]=true,
	},
},

{
	["info"]={["name"]="Default_D", ["class"]="D", ["target"]="all"},
	{
		-- 共通コマンド
		["commandType"]="proc", ["commandName"]=Kitty.T("name", "CommonCommand"), ["icon"]="", ["enable"]=true,
		{["conditionType"]="playerNonEffect", {["effectType"]="original", ["name"]=Kitty.T("name", "Stun"), ["threshold"]=0.6}},
	},
	{
		-- ソーニーバインド
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Briar Entwinement"), ["icon"]="interface/icons/elf_skill/skill_dru2-1.dds", ["enable"]=true,
		{["conditionType"]="isTargeted", ["value"]=true},
		{["conditionType"]="targetNonEffect", {["effectType"]="original", ["name"]=Kitty.T("skill", "Briar Entwinement"), ["threshold"]=1}},
	},
	{
		-- アースアロー
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Earth Arrow"), ["icon"]="interface/icons/elf_skill/skill_dru1-2.dds", ["enable"]=true,
	},
	{
		-- ライフブロッサム
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Blossoming Life"), ["icon"]="interface/icons/elf_skill/skill_dru10-1.dds", ["enable"]=true,
		{["conditionType"]="playerHealth", ["max"]=70},
		{["conditionType"]="playerNonEffect",	{["effectType"]="original", ["name"]=Kitty.T("skill", "Blossoming Life"), ["threshold"]=1.0}},
	},
	{
		-- リカバー
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Recover"), ["icon"]="interface/icons/elf_skill/skill_dru1-1.dds", ["enable"]=true,
		{["conditionType"]="playerHealth", ["max"]=50},
	},
},

{
	["info"]={["name"]="Default_McR", ["class"]="McR", ["target"]="all"},
	{
		-- 共通コマンド
		["commandType"]="proc", ["commandName"]=Kitty.T("name", "CommonCommand"), ["icon"]="", ["enable"]=true,
		{["conditionType"]="playerNonEffect", {["effectType"]="original", ["name"]=Kitty.T("name", "Stun"), ["threshold"]=0.6}},
	},
	{
		-- ルーンチャージ
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Rune Energy Influx"), ["icon"]="interface/Icons/dwarf_skill/skill_psy18-2", ["enable"]=true,
		{["conditionType"]="playerEffect", {["effectType"]="name", ["name"]=Kitty.T("skill", "Shield Form"), ["threshold"]=0.0}},
		{["conditionType"]="targetIsBoss", ["value"]=true},
	},
	{
		-- ルーングロウ
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Rune Growth"), ["icon"]="interface/Icons/dwarf_skill/skill_psy24-1", ["enable"]=true,
	},
	{
		-- ルーンパワーパルス
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Rune Pulse"), ["icon"]="interface/Icons/dwarf_skill/skill_psy10-1", ["enable"]=true,
		{["conditionType"]="playerEffect", {["effectType"]="name", ["name"]=Kitty.T("skill", "Chain Drive"), ["threshold"]=0.6}},
	},
	{
		-- ダークパルス
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Shadow Pulse"), ["icon"]="interface/Icons/dwarf_skill/skill_psy_thi20-1.dds", ["enable"]=true,
	},
	{
		-- ノンフィアーストライク
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Fearless Blow"), ["icon"]="interface/Icons/dwarf_skill/skill_psy14-1", ["enable"]=true,
	},
	{
		-- エレクトロカッション
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Electrocution"), ["icon"]="interface/Icons/dwarf_skill/skill_psy1-2", ["enable"]=true,
	},
	{
		-- ショックストライク
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Shock Strike"), ["icon"]="interface/Icons/dwarf_skill/skill_psy20-1", ["enable"]=true,
	},
	{
		-- 陰険
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Vicious Attack"), ["icon"]="interface/icons/skill_thi1-1", ["enable"]=true,
		{["conditionType"]="playerEnergy", ["min"]=40, ["max"]=nil},
	},
	{
		-- ヘビーバッシュ
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Heavy Bash"), ["icon"]="interface/Icons/dwarf_skill/skill_psy1-1", ["enable"]=true,
	},
	{
		-- スローイング
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Throw"), ["icon"]="interface/icons/skill_thi1-2", ["enable"]=true,
	},
},

-- RangeAttack
{
	["info"]={["name"]="RangeAttack", ["class"]="proc", ["target"]="all"},
	{
		["commandType"]="proc", ["commandName"]="RangeAttack_S", ["icon"]="", ["enable"]=true,
		{["conditionType"]="playerClass", ["value"]="/S"},
	},
	{
		["commandType"]="break", ["commandName"]="", ["icon"]="", ["enable"]=true,
		{["conditionType"]="playerClass", ["value"]="/S"},
	},
	{
		["commandType"]="proc", ["commandName"]="RangeAttack_RM", ["icon"]="", ["enable"]=true,
		{["conditionType"]="playerClass", ["value"]="RM"},
	},
	{
		["commandType"]="break", ["commandName"]="", ["icon"]="", ["enable"]=true,
		{["conditionType"]="playerClass", ["value"]="RM"},
	},
	{
		["commandType"]="proc", ["commandName"]="RangeAttack_R", ["icon"]="", ["enable"]=true,
		{["conditionType"]="playerClass", ["value"]="R/"},
	},
},

{
	["info"]={["name"]="RangeAttack_S", ["class"]="proc", ["target"]="all"},
	{
		-- ブラッディアロー
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Vampire Arrows"), ["icon"]="interface/icons/skill_ran6-3.dds", ["enable"]=true,
	},
	{
		-- シューティング
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Shooting"), ["icon"]="interface/icons/skill_ran1-2", ["enable"]=true,
	},
},

{
	["info"]={["name"]="RangeAttack_R", ["class"]="proc", ["target"]="all"},
	{
		-- カンチェスティア
		["commandType"]="suitskill", ["commandName"]=Kitty.T("skill", "Kanches' Rend"), ["icon"]="interface/Icons/skill_panel_icons/sp_thi_z21_001.dds", ["enable"]=true,
	},
	{
		-- シャドーアサルト
		["commandType"]="suitskill", ["commandName"]=Kitty.T("skill", "Phantom Stab"), ["icon"]="interface/Icons/skill_panel_icons/sp_thi_001.dds", ["enable"]=true,
	},
	{
		-- バッククリープ
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Shadow Step"), ["icon"]="interface/icons/skill_thi27-2", ["enable"]=true,
	},
	{
		-- シークエンススロー
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Combo Throw"), ["icon"]="interface/icons/skill_thi21-2", ["enable"]=true,
	},
	{
		-- スローイング
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Throw"), ["icon"]="interface/icons/skill_thi1-2", ["enable"]=true,
	},
},

{
	["info"]={["name"]="RangeAttack_RM", ["class"]="proc", ["target"]="all"},
	{
		-- サイレンス
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Silence"), ["icon"]="interface/icons/skill_aug39-2", ["enable"]=true,
		{["conditionType"]="targetIsCaster", ["value"]=true},
		{["conditionType"]="playerIsFearless", ["value"]=false},
	},
	{
		-- スローイング
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Throw"), ["icon"]="interface/icons/skill_thi1-2", ["enable"]=true,
	},
	{
		-- ダブルスロー
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Double Throw"), ["icon"]="interface/icons/skill_thi21-2", ["enable"]=true,
	},
	{
		-- サンダー召喚
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Lightning"), ["icon"]="interface/icons/skill_mag3-1", ["enable"]=true,
		{["conditionType"]="targetNonEffect",	{["effectType"]="original", ["name"]=Kitty.T("skill", "Holy Light Protection"), ["threshold"]=0.6},
												{["effectType"]="original", ["name"]=Kitty.T("skill", "Ignore Pain"), ["threshold"]=0.6}},
	},
	{
		-- ファイヤボール
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Fireball"), ["icon"]="interface/icons/skill_mag1-1", ["enable"]=true,
	},
},

-- 共通コマンド
{
	["info"]={["name"]=Kitty.T("name", "CommonCommand"), ["class"]="proc", ["target"]="all"},
	{
		-- ルートコマンド
		["commandType"]="proc", ["commandName"]=Kitty.T("name", "LootCommand"), ["icon"]="", ["enable"]=true,
	},
	{
		-- 回復コマンド
		["commandType"]="proc", ["commandName"]=Kitty.T("name", "RecoveryCommand"), ["icon"]="", ["enable"]=false,
		{["conditionType"]="isCG", ["value"]=false},
	},
	{
		-- 無敵コマンド
		["commandType"]="proc", ["commandName"]=Kitty.T("name", "MatchlessCommand"), ["icon"]="", ["enable"]=false,
		{["conditionType"]="isCG", ["value"]=true},
	},
	{
		-- 無敵判定
		["commandType"]="proc", ["commandName"]=Kitty.T("name", "TargetMatchless"), ["icon"]="", ["enable"]=true,
	},
},

-- ルート判定
{
	["info"]={["name"]=Kitty.T("name", "LootCommand"), ["class"]="proc", ["target"]="all"},
	{
		["commandType"]="break", ["commandName"]="", ["icon"]="", ["enable"]=true,
		{["conditionType"]="targetIsDead", ["value"]=true},
		{["conditionType"]="playerClass", ["value"]="K/"},
	},
	{
		["commandType"]="break", ["commandName"]="", ["icon"]="", ["enable"]=true,
		{["conditionType"]="targetIsDead", ["value"]=true},
		{["conditionType"]="playerClass", ["value"]="S/"},
	},
	{
		-- 攻撃
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Attack"), ["icon"]="interface/Icons/weapon/wp_act_blade", ["enable"]=true,
		{["conditionType"]="targetIsDead", ["value"]=true},
	},
},

-- ポーション
{
	["info"]={["name"]=Kitty.T("name", "RecoveryCommand"), ["class"]="proc", ["target"]="all"},
	{
		-- Lv5フィリウスポーション
		["commandType"]="action", ["commandName"]=Kitty.T("item", "HPPotionLv5"), ["icon"]="interface/icons/fete_water_05", ["enable"]=true,
		{["conditionType"]="playerHealth", ["max"]=20},
	},
	{
		-- Lv4フィリウスポーション
		["commandType"]="action", ["commandName"]=Kitty.T("item", "HPPotionLv4"), ["icon"]="interface/icons/item_potion_040_008", ["enable"]=true,
		{["conditionType"]="playerHealth", ["max"]=30},
	},
	{
		-- Lv3フィリウスポーション
		["commandType"]="action", ["commandName"]=Kitty.T("item", "HPPotionLv3"), ["icon"]="interface/icons/item_potion_070_006", ["enable"]=true,
		{["conditionType"]="playerHealth", ["max"]=40},
	},
	{
		-- Lv2フィリウスポーション
		["commandType"]="action", ["commandName"]=Kitty.T("item", "HPPotionLv2"), ["icon"]="interface/icons/item_potion_040_001", ["enable"]=true,
		{["conditionType"]="playerHealth", ["max"]=50},
	},
	{
		-- Lv1フィリウスポーション
		["commandType"]="action", ["commandName"]=Kitty.T("item", "HPPotionLv1"), ["icon"]="interface/icons/item_potion_030_001", ["enable"]=true,
		{["conditionType"]="playerHealth", ["max"]=60},
	},
	{
		-- Lv5フィリウスの不思議な水
		["commandType"]="action", ["commandName"]=Kitty.T("item", "HPMPpotionLv5"), ["icon"]="interface/icons/fete_water_10", ["enable"]=true,
		{["conditionType"]="playerHealth", ["max"]=20},
	},
	{
		-- Lv4フィリウスの不思議な水
		["commandType"]="action", ["commandName"]=Kitty.T("item", "HPMPpotionLv4"), ["icon"]="interface/icons/item_potion_040_009", ["enable"]=true,
		{["conditionType"]="playerHealth", ["max"]=30},
	},
	{
		-- Lv3フィリウスの不思議な水
		["commandType"]="action", ["commandName"]=Kitty.T("item", "HPMPpotionLv3"), ["icon"]="interface/icons/item_potion_070_003", ["enable"]=true,
		{["conditionType"]="playerHealth", ["max"]=40},
	},
	{
		-- Lv2フィリウスの不思議な水
		["commandType"]="action", ["commandName"]=Kitty.T("item", "HPMPpotionLv2"), ["icon"]="interface/icons/item_potion_040_003", ["enable"]=true,
		{["conditionType"]="playerHealth", ["max"]=50},
	},
	{
		-- Lv1フィリウスの不思議な水
		["commandType"]="action", ["commandName"]=Kitty.T("item", "HPMPpotionLv1"), ["icon"]="interface/icons/item_potion_030_002", ["enable"]=true,
		{["conditionType"]="playerHealth", ["max"]=60},
	},
	{
		-- レインボードロップ
		["commandType"]="action", ["commandName"]=Kitty.T("item", "ProtectMeleeItem"), ["icon"]="interface/icons/item_sweets_060_004", ["enable"]=true,
		{["conditionType"]="isTargeted", ["value"]=true},
		{["conditionType"]="targetIsBoss", ["value"]=true},
		{["conditionType"]="playerHealth", ["max"]=40},
		{["conditionType"]="playerIsFearless", ["value"]=false},
	},
},

-- ドロップ
{
	["info"]={["name"]=Kitty.T("name", "MatchlessCommand"), ["class"]="proc", ["target"]="all"},
	{
		-- レインボードロップ
		["commandType"]="action", ["commandName"]=Kitty.T("item", "ProtectMeleeItem"), ["icon"]="interface/icons/item_sweets_060_004", ["enable"]=true,
		{["conditionType"]="isTargeted", ["value"]=true},
		{["conditionType"]="targetIsCaster", ["value"]=false},
		{["conditionType"]="playerHealth", ["max"]=60},
		{["conditionType"]="playerIsFearless", ["value"]=false},
	},
	{
		-- ザレス・ディザーン
		["commandType"]="action", ["commandName"]=Kitty.T("item", "ProtectMagicItem2"), ["icon"]="interface/icons/item_sweets_070_004", ["enable"]=true,
		{["conditionType"]="isTargeted", ["value"]=true},
		{["conditionType"]="targetIsCaster", ["value"]=true},
		{["conditionType"]="playerHealth", ["max"]=60},
		{["conditionType"]="playerIsFearless", ["value"]=false},
	},
	{
		-- 森のケーキ
		["commandType"]="action", ["commandName"]=Kitty.T("item", "ProtectMagicItem1"), ["icon"]="interface/icons/item_sweets_040_003", ["enable"]=true,
		{["conditionType"]="isTargeted", ["value"]=true},
		{["conditionType"]="targetIsCaster", ["value"]=true},
		{["conditionType"]="playerHealth", ["max"]=60},
		{["conditionType"]="playerIsFearless", ["value"]=false},
	},
},

-- Target無敵判定
{
	["info"]={["name"]=Kitty.T("name", "TargetMatchless"), ["class"]="proc", ["target"]="all"},
	{
		["commandType"]="break", ["commandName"]=Kitty.T("message", "MatchlessStateMessage"), ["icon"]="", ["enable"]=true,
		{["conditionType"]="targetIsFearless", ["value"]=true},
	},
},

-- W ExSkill
{
	["info"]={["name"]=Kitty.T("name", "ExtraUndefeatableKing"), ["class"]="proc", ["target"]="all"},
	{
		-- 不敗の王者
		["commandType"]="suitskill", ["commandName"]=Kitty.T("skill", "Undefeatable King"), ["icon"]="interface/Icons/skill_panel_icons/sp_war_001.dds", ["enable"]=true,
		{["conditionType"]="playerEffect", {["effectType"]="original", ["name"]=Kitty.T("name", "Stun"), ["threshold"]=0.6}},
		{["conditionType"]="playerNonEffect", {["effectType"]="original", ["name"]=Kitty.T("skill", "Undefeatable King"), ["threshold"]=0.6}},
	},
	{
		-- キングフィアーネス
		["commandType"]="extra", ["commandName"]=Kitty.T("skill", "King Fairness"), ["icon"]="", ["enable"]=true,
		{["conditionType"]="playerEffect",	{["effectType"]="original", ["name"]=Kitty.T("name", "Stun"), ["threshold"]=0.6},
											{["effectType"]="original", ["name"]=Kitty.T("skill", "Undefeatable King"), ["threshold"]=0.6}},
	},
},

-- M ExSkill
{
	["info"]={["name"]=Kitty.T("name", "ExtraMagicTricks"), ["class"]="proc", ["target"]="all"},
	{
		-- マジックトリック
		["commandType"]="suitskill", ["commandName"]=Kitty.T("skill", "Magic Tricks"), ["icon"]="interface/icons/skill_panel_icons/sp_mag_006.dds", ["enable"]=true,
		{["conditionType"]="playerNonEffect", {["effectType"]="original", ["name"]=Kitty.T("skill", "Magic Tricks"), ["threshold"]=0}},
	},
	{
		-- カマイタチ
		["commandType"]="extra", ["commandName"]=Kitty.T("skill", "Magic Tricks Wind"), ["icon"]="", ["enable"]=true,
		{["conditionType"]="playerEffect", {["effectType"]="original", ["name"]=Kitty.T("skill", "Magic Tricks"), ["threshold"]=0.6}},
	},
	{
		-- フレイムダンス
		["commandType"]="extra", ["commandName"]=Kitty.T("skill", "Magic Tricks Flame"), ["icon"]="", ["enable"]=true,
		{["conditionType"]="playerEffect", {["effectType"]="original", ["name"]=Kitty.T("skill", "Magic Tricks"), ["threshold"]=0.6}},
	},
	{
		-- フェイト
		["commandType"]="suitskill", ["commandName"]=Kitty.T("skill", "Lucky Chance"), ["icon"]="interface/icons/skill_panel_icons/sp_mag_002.dds", ["enable"]=false,
		{["conditionType"]="playerNonEffect",	{["name"]=Kitty.T("skill", "Lucky Chance"), ["effectType"]="original", ["threshold"]=0},
												{["name"]=Kitty.T("skill", "Magic Tricks"), ["effectType"]="original", ["threshold"]=0}},
	},
	{
		-- フェイトフレイム
		["commandType"]="extra", ["commandName"]=Kitty.T("skill", "Lucky Chance Flame"), ["icon"]="", ["enable"]=false,
		{["conditionType"]="playerEffect", {["effectType"]="original", ["name"]=Kitty.T("skill", "Lucky Chance"), ["threshold"]=0.6}},
	},
	{
		-- フェイトウインド
		["commandType"]="extra", ["commandName"]=Kitty.T("skill", "Lucky Chance Wind"), ["icon"]="", ["enable"]=false,
		{["conditionType"]="playerEffect", {["effectType"]="original", ["name"]=Kitty.T("skill", "Lucky Chance"), ["threshold"]=0.6}},
	},
},

-- W(片手)
{
	["info"]={["name"]=Kitty.T("name", "WSingleHand"), ["class"]="proc", ["target"]="all"},
	{
		-- 電光石火
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Thunder"), ["icon"]="interface/icons/skill_war15-1", ["enable"]=true,
		{["conditionType"]="targetEffect", {["effectType"]="original", ["name"]=Kitty.T("skill", "Probing Attack"), ["threshold"]=0.6}},
	},
	{
		-- アタックチャンス
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Probing Attack"), ["icon"]="interface/icons/skill_war3-2", ["enable"]=true,
		{["conditionType"]="canCast", {["name"]=Kitty.T("skill", "Thunder"), ["threshold"]=0.6}},
		{["conditionType"]="targetEffect", {["effectType"]="original", ["name"]=Kitty.T("skill", "Open Flank"), ["threshold"]=0.6}},
	},
	{
		-- ブラッシュストライク
		["commandType"]="suitskill", ["commandName"]=Kitty.T("skill", "Brash Ferocity Strike"), ["icon"]="interface/Icons/skill_panel_icons/sp_war_z21_001.dds", ["enable"]=true,
		{["conditionType"]="targetEffect", {["effectType"]="original", ["name"]=Kitty.T("skill", "Probing Attack"), ["threshold"]=0.6}},
	},
	{
		-- ガードブレイク
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Open Flank"), ["icon"]="interface/icons/skill_thi3-1.dds", ["enable"]=true,
		{["conditionType"]="playerTension", ["min"]=40, ["max"]=nil},
	},
	{
		-- ブロウ
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Slash"), ["icon"]="interface/icons/skill_war1-1", ["enable"]=true,
	},
},

-- W(両手)
{
	["info"]={["name"]=Kitty.T("name", "WTwoHand"), ["class"]="proc", ["target"]="all"},
	{
		-- ブラッシュストライク
		["commandType"]="suitskill", ["commandName"]=Kitty.T("skill", "Brash Ferocity Strike"), ["icon"]="interface/Icons/skill_panel_icons/sp_war_z21_001.dds", ["enable"]=true,
		{["conditionType"]="targetEffect", {["effectType"]="original", ["name"]=Kitty.T("skill", "Probing Attack"), ["threshold"]=0.6}},
	},
	{
		-- ガードブレイク
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Open Flank"), ["icon"]="interface/icons/skill_thi3-1.dds", ["enable"]=true,
		{["conditionType"]="playerTension", ["min"]=40, ["max"]=nil},
		{["conditionType"]="canCast", {["name"]=Kitty.T("skill", "Brash Ferocity Strike"), ["threshold"]=0.6}},
	},
	{
		-- ダブルアタック
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Tactical Attack"), ["icon"]="interface/icons/skill_war9-1", ["enable"]=true,
		{["conditionType"]="targetEffect", {["effectType"]="original", ["name"]=Kitty.T("skill", "Slash"), ["threshold"]=0.6}},
	},
	{
		-- ブロウ
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Slash"), ["icon"]="interface/icons/skill_war1-1", ["enable"]=true,
	},
},

-- WK(片手)
{
	["info"]={["name"]=Kitty.T("name", "WKSingleHand"), ["class"]="proc", ["target"]="all"},
	{
		-- 電光石火
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Thunder"), ["icon"]="interface/icons/skill_war15-1", ["enable"]=true,
		{["conditionType"]="targetEffect", {["effectType"]="original", ["name"]=Kitty.T("skill", "Probing Attack"), ["threshold"]=0.6}},
	},
	{
		-- アタックチャンス
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Probing Attack"), ["icon"]="interface/icons/skill_war3-2", ["enable"]=true,
		{["conditionType"]="canCast", {["name"]=Kitty.T("skill", "Thunder"), ["threshold"]=0.6}},
		{["conditionType"]="targetEffect", {["effectType"]="original", ["name"]=Kitty.T("skill", "Open Flank"), ["threshold"]=0.6}},
	},
	{
		-- ブラッシュストライク
		["commandType"]="suitskill", ["commandName"]=Kitty.T("skill", "Brash Ferocity Strike"), ["icon"]="interface/Icons/skill_panel_icons/sp_war_z21_001.dds", ["enable"]=true,
		{["conditionType"]="targetEffect", {["effectType"]="original", ["name"]=Kitty.T("skill", "Probing Attack"), ["threshold"]=0.6}},
	},
	{
		-- ガードブレイク
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Open Flank"), ["icon"]="interface/icons/skill_thi3-1.dds", ["enable"]=true,
		{["conditionType"]="playerTension", ["min"]=40, ["max"]=nil},
	},
	{
		-- ブロウ
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Slash"), ["icon"]="interface/icons/skill_war1-1", ["enable"]=true,
		{["conditionType"]="playerTension", ["min"]=70, ["max"]=nil},
	},
	{
		-- ディフェンスダウン
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Disarmament"), ["icon"]="interface/icons/skill_kni12-1", ["enable"]=true,
	},
},

-- WK(両手)
{
	["info"]={["name"]=Kitty.T("name", "WKTwoHand"), ["class"]="proc", ["target"]="all"},
	{
		-- ブラッシュストライク
		["commandType"]="suitskill", ["commandName"]=Kitty.T("skill", "Brash Ferocity Strike"), ["icon"]="interface/Icons/skill_panel_icons/sp_war_z21_001.dds", ["enable"]=true,
		{["conditionType"]="targetEffect", {["effectType"]="original", ["name"]=Kitty.T("skill", "Probing Attack"), ["threshold"]=0.6}},
	},
	{
		-- ガードブレイク
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Open Flank"), ["icon"]="interface/icons/skill_thi3-1.dds", ["enable"]=true,
		{["conditionType"]="playerTension", ["min"]=40, ["max"]=nil},
		{["conditionType"]="canCast", {["name"]=Kitty.T("skill", "Brash Ferocity Strike"), ["threshold"]=0.6}},
	},
	{
		-- ダブルアタック
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Tactical Attack"), ["icon"]="interface/icons/skill_war9-1", ["enable"]=true,
		{["conditionType"]="targetEffect", {["effectType"]="original", ["name"]=Kitty.T("skill", "Slash"), ["threshold"]=0.6}},
	},
	{
		-- ブロウ
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Slash"), ["icon"]="interface/icons/skill_war1-1", ["enable"]=true,
		{["conditionType"]="playerTension", ["min"]=70, ["max"]=nil},
	},
	{
		-- ディフェンスダウン
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Disarmament"), ["icon"]="interface/icons/skill_kni12-1", ["enable"]=true,
		{["conditionType"]="targetNonEffect", {["effectType"]="original", ["name"]=Kitty.T("effect", "DisarmamentLv4"), ["threshold"]=4.0}},
	},
	{
		-- ブロウ
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Slash"), ["icon"]="interface/icons/skill_war1-1", ["enable"]=true,
	},
	{
		-- ディフェンスダウン
		["commandType"]="skill", ["commandName"]=Kitty.T("skill", "Disarmament"), ["icon"]="interface/icons/skill_kni12-1", ["enable"]=true,
	},
},
};

--------------------------------------------------------------------------------
-- スタティックメソッド
-- メッセージ内の特殊文字(%s、%t、%b、%d)を変換
Kitty.ComboManager.formatMessage = function(message)
	local replaceList = {
		["s"] = tostring(UnitName("player")),					-- プレイヤー名
		["t"] = tostring(UnitName("target")),					-- ターゲット名
		["b"] = tostring(Kitty.lastBuffName),					-- バフ名称
		["d"] = string.format("%.2f", Kitty.lastDuration),		-- バフ残り効果時間

		["S"] = Kitty.colorCyan(tostring(UnitName("player"))),				-- プレイヤー名
		["T"] = Kitty.colorCyan(tostring(UnitName("target"))),				-- ターゲット名
		["B"] = Kitty.colorCyan(tostring(Kitty.lastBuffName)),				-- バフ名称
		["D"] = Kitty.colorCyan(string.format("%.2f", Kitty.lastDuration)),	-- バフ残り効果時間
	};

	return string.gsub(message, "%%(%w)", replaceList);
end;
-- クラスから、関数名を取得Helpのあるものを抽出
Kitty.ComboManager.createFunctionList = function()
	local resultList = {};
	local suffix = "Describe";

	for funcName, func in pairs(Kitty.ComboManager) do
		if(type(funcName) == "string" and type(func) == "function") then
			if(string.endsWith(funcName, suffix)) then
				local originalFuncName = string.sub(funcName, 1, -string.len(suffix)-1);
				-- もともとの関数
				if(originalFuncName ~= "func" and originalFuncName ~= "show" and originalFuncName ~= "commandList" and originalFuncName ~= "command") then
					local helpFuncName = funcName .. "Help";
					local describeFuncName = originalFuncName .. "Describe";
					local typeFuncName = originalFuncName .. "Type";

					resultList[originalFuncName] = {};
					resultList[originalFuncName][originalFuncName] = Kitty.ComboManager[originalFuncName];
					resultList[originalFuncName][helpFuncName] = Kitty.ComboManager[helpFuncName];
					resultList[originalFuncName][describeFuncName] = Kitty.ComboManager[describeFuncName];
					resultList[originalFuncName][typeFuncName] = Kitty.ComboManager[typeFuncName];
				end
			end
		end
	end

	return resultList;
end;

Kitty.ComboManager.getFormatType = function(conditionType)
	assert(conditionType, "ConditionType is nil.");
	return Kitty.ComboManager[conditionType .. "Type"](nil, nil);
end;

-- 引数を抽出
Kitty.ComboManager.getArgument = function(condition)
	local formatType = Kitty.ComboManager.getFormatType(condition.conditionType);
	if(formatType == Kitty.ComboManager.TYPE_EFFECT) then
		return condition;
	elseif(formatType == Kitty.ComboManager.TYPE_ACTION) then
		return condition.value;
	elseif(formatType == Kitty.ComboManager.TYPE_BUILD) then
		return condition.value;
	elseif(formatType == Kitty.ComboManager.TYPE_STRING_NUMBER_LIST) then
		return condition;
	elseif(formatType == Kitty.ComboManager.TYPE_STRING) then
		return condition.value;
	elseif(formatType == Kitty.ComboManager.TYPE_NUMBER) then
		return condition.min, condition.max;
	elseif(formatType == Kitty.ComboManager.TYPE_BOOLEAN) then
		return condition.value;
	else
		return condition;
	end
end;

-- 状態判定関数
Kitty.ComboManager.getTargetState = function()
	if(UnitName("target") == nil or UnitIsUnit("target", "player")) then
		return "none";
	else
		if(UnitIsPlayer("target")) then
			if(Kitty.ClassManager.isCaster("target")) then
				return "caster", "pc", "all";
			else
				return "pc", "all";
			end
		else
			if(UnitSex("target") >= 3) then
				return "boss", "all";
			else
				return "all";
			end
		end
	end
end;
-- 指定ビルドのコマンドリストを抽出
Kitty.ComboManager.pickupCommandList = function(allCommandList, mainClass, subClass)
	local result = {};
	local className = nil;
	if(mainClass == "" and subClass == "") then
		className = "any";
	elseif(mainClass == "") then
		className = "/" .. subClass;
	else
		className = mainClass .. subClass;
	end

	for index, commandList in ipairs(allCommandList) do
		if(commandList ~= nil and commandList.info ~= nil) then
			if(commandList.info.class == className) then	-- 完全一致
				if(result[commandList.info.target] == nil) then
					-- 最初のものを優先
					result[commandList.info.target] = commandList;
				else
					-- 重複
--					Kitty.sendMessage(Kitty.format("Command list is duplicated. Class:[<<1>>], Target:[<<2>>]", tostring(mainClass) .. tostring(subClass), tostring(commandList.info.target)), "DEFAULT", 1, 0, 0);
				end
			end
		end
	end

	return result;
end;

Kitty.ComboManager.selectCommandList = function(mainClass, subClass)
	local targetStateList = {Kitty.ComboManager.getTargetState()};

	-- メイン、サブ指定のコマンドリスト
	local targetCommandListMap = Kitty.ComboManager.pickupCommandList(Kitty.SettingManager.setting.command, mainClass, subClass);
	for _, targetState in ipairs(targetStateList) do
		if(targetCommandListMap[targetState] ~= nil) then
			return targetCommandListMap[targetState], targetState;
		end
	end

	-- メインのみ指定のコマンドリス
	local targetCommandListMap = Kitty.ComboManager.pickupCommandList(Kitty.SettingManager.setting.command, mainClass, "");
	for _, targetState in ipairs(targetStateList) do
		if(targetCommandListMap[targetState] ~= nil) then
			return targetCommandListMap[targetState], targetState;
		end
	end

	-- サブのみ指定のコマンドリス
	local targetCommandListMap = Kitty.ComboManager.pickupCommandList(Kitty.SettingManager.setting.command, "", subClass);
	for _, targetState in ipairs(targetStateList) do
		if(targetCommandListMap[targetState] ~= nil) then
			return targetCommandListMap[targetState], targetState;
		end
	end

	-- クラス指定なしのコマンドリス
	local targetCommandListMap = Kitty.ComboManager.pickupCommandList(Kitty.SettingManager.setting.command, "", "");
	for _, targetState in ipairs(targetStateList) do
		if(targetCommandListMap[targetState] ~= nil) then
			return targetCommandListMap[targetState], targetState;
		end
	end

	-- 未サポート
	return nil;
end;
Kitty.ComboManager.selectCommandListByName = function(commandListNames)
	local list = {};
	for _, name in ipairs(commandListNames) do
		list[name] = true;
	end

	local resultList = {};
	for _, commandList in pairs(Kitty.SettingManager.setting.command) do
		if(commandList.info ~= nil) then
			if(list[commandList.info.name] ~= nil) then
				table.insert(resultList, commandList);
			end
		end
	end
	return resultList;
end;

Kitty.ComboManager.getSupportedClass = function(allCommandList)
	local map = {};
	-- ダブり落とし
	for index, commandList in ipairs(allCommandList) do
		if(commandList.info ~= nil and commandList.info.class ~= nil) then
			if(commandList.info.class ~= "proc") then
				map[commandList.info.class] = true;
			end
		end
	end

	-- 配列に変換
	local array = {};
	for key, _ in pairs(map) do
		table.insert(array, key);
	end

	table.sort(array);
	return array;
end;
Kitty.ComboManager.isSupportedClass = function(allCommandList, className)
	for index, commandList in ipairs(allCommandList) do
		if(commandList.info ~= nil and commandList.info.class ~= nil) then
			if(Kitty.BuildManager.match(className, commandList.info.class)) then
				return true;
			end
		end
	end
	return false;
end;

--------------------------------------------------------------------------------
-- ヘルプ
Kitty.ComboManager.showHelp = function(allCommandList, className)
	local resultList = {};

	for index, commandList in ipairs(allCommandList) do
		if(commandList ~= nil and commandList.info ~= nil) then
			if(commandList.info.class == className) then	-- 完全一致

				if(commandList.info.target == "all") then
					table.insert(resultList, Kitty.T("message", "Skill02"));
				elseif(commandList.info.target == "pc") then
					table.insert(resultList, Kitty.T("message", "Skill03"));
				elseif(commandList.info.target == "caster") then
					table.insert(resultList, Kitty.T("message", "Skill04"));
				elseif(commandList.info.target == "boss") then
					table.insert(resultList, Kitty.T("message", "Skill06"));
				elseif(commandList.info.target == "none") then
					table.insert(resultList, Kitty.T("message", "Skill05"));
				else
					table.insert(resultList, Kitty.T("message", "UnsupportedTarget", tostring(commandList.info.target)));
					break;
				end

				resultList = Kitty.concatTable(resultList, Kitty.ComboManager.commandListHelp(commandList));
			end
		end
	end

	if(#resultList == 0) then
		table.insert(resultList, Kitty.T("message", "UnsupportedClass", className));
	end

	return resultList;
end;
Kitty.ComboManager.commandListHelp = function(targetList)
	local resultList = {};
	-- コマンドごとにループ
	for index, command in ipairs(targetList) do
		local commandName = nil;
		if(command.commandName ~= nil and command.commandName ~= "") then
			commandName = command.commandName
		else
			commandName = "<none>";
		end

		-- 有効なコマンド
		if(command.enable ~= false) then	-- nilは実行する
			if(command.commandType ~= nil and command.commandType ~= "") then
				-- No, Skill名
				local message = Kitty.color(tostring(index), 255, 255, 255) .. "."
							.. Kitty.ComboManager.formatCommandType(command.commandType)
							.. Kitty.color(tostring(commandName), 255, 255, 0);
				table.insert(resultList, message);
				-- 発動条件
				local strList = Kitty.ComboManager.commandHelp(command);
				table.insert(resultList, strList);	-- 配列の要素に配列を代入
			else
				table.insert(resultList, Kitty.color(tostring(index) .. ".", 255, 255, 255)
										.. Kitty.color(Kitty.ComboManager.formatCommandType(command.commandType)
										.. Kitty.T("message", "Invalid"), 255, 0, 0));
			end
		else
			local message = Kitty.color(tostring(index) .. ".", 255, 255, 255)
										.. Kitty.ComboManager.formatCommandType(command.commandType)
										.. tostring(commandName)
										.. Kitty.color(Kitty.T("message", "Disable"), 255, 0, 255);
			table.insert(resultList, message);
		end
	end

	return resultList;
end;
Kitty.ComboManager.commandHelp = function(command)
	local resultList = {};
	if(command ~= nil) then
		-- 発動条件
		for index, condition in ipairs(command) do
			local func = Kitty.ComboManager[condition.conditionType .. "Help"];
			assert(func, "Error: Function:[" .. tostring(condition.conditionType .. "Help") .. "] is nothing.");
			local conditionMessage = func(nil, Kitty.ComboManager.getArgument(condition));	-- インスタンスメソッドだが、インスタンスは未使用
			if(type(conditionMessage) == "string") then
				conditionMessage = {conditionMessage};
			end

			for _, value in ipairs(conditionMessage) do
				table.insert(resultList, Kitty.color(value, 255, 255, 255));
			end
		end
	end
	return resultList;
end;
Kitty.ComboManager.formatCommandType = function(commandType)
	if(commandType == "skill") then
		return Kitty.colorGreen("K");
	elseif(commandType == "suitskill") then
		return Kitty.colorGreen("S");
	elseif(commandType == "action") then
		return Kitty.colorGreen("A");
	elseif(commandType == "extra") then
		return Kitty.colorGreen("X");
	elseif(commandType == "emote") then
		return Kitty.colorGreen("E");
	elseif(commandType == "macro") then
		return Kitty.colorGreen("M");
	elseif(commandType == "proc") then
		return Kitty.colorGreen("P");
	elseif(commandType == "break") then
		return Kitty.colorGreen("B");
	elseif(commandType == "debug") then
		return Kitty.colorGreen("D");
	else
		return Kitty.colorMagenta("?");
	end
end;

--------------------------------------------------------------------------------
-- インスタンスメソッド

--------------------------------------------------------------------------------
-- PlayerのBuff/Debuff(どちらもあるなら)
--------#Player Effect#--------
Kitty.ComboManager.playerEffect = function(self, condition)
	local result = true;
	for index, value in ipairs(condition) do
		if(value.effectType == "name") then
			-- Name
			result = result and self.playerBuffManager:hasEffectByName(value.name, value.threshold);
		elseif(value.effectType == "id") then
			-- ID
			result = result and self.playerBuffManager:hasEffectById(value.name, value.threshold);
		elseif(value.effectType == "original") then
			-- Original
			result = result and self.playerBuffManager:hasEffect(value.name, value.threshold);
		else
			error("Invalid EffectType. EffectType:[" .. tostring(value.effectType) .. "]");
		end
	end
	return result;
end;
Kitty.ComboManager.playerEffectHelp = function(self, condition)
	local resultList = {};
	for index, value in ipairs(condition) do
		local str = "";
		if(index ~= 1) then
			str = str .. "and" .. " ";
		end

		if(value.threshold and value.threshold > 0.0) then
			str = str .. Kitty.colorCyan(value.name .. Kitty.T("message", "OverDuration", value.threshold));
		elseif value.threshold == nil or value.threshold == 0 then
			str = str .. Kitty.colorCyan(value.name);
		elseif value.threshold and value.threshold < 0.0 then
			str = str .. Kitty.colorCyan(value.name .. Kitty.T("message", "OverDuration1", math.abs(value.threshold)));
		end
		table.insert(resultList, str);
	end

	if(#resultList > 1) then
		table.insert(resultList, 1, Kitty.T("message", "PlayerEffect1"));
	elseif(#resultList == 1) then
		resultList[1] = Kitty.T("message", "PlayerEffect2", resultList[1]);
	end

	return resultList;
end;
Kitty.ComboManager.playerEffectDescribe = function(self, condition)
	return {
		Kitty.T("message", "playerEffectDescription1"),
		Kitty.T("message", "playerEffectDescription2"),
		Kitty.T("message", "playerEffectDescription3"),
	};
end;
Kitty.ComboManager.playerEffectType = function(self, condition)
	return Kitty.ComboManager.TYPE_EFFECT;
end;
--------------------------------------------------------------------------------
-- PlayerのBuff/Debuff(どれもなければ)
--------#Player Non Effect#--------
Kitty.ComboManager.playerNonEffect = function(self, condition)
	local result = true;
	for index, value in ipairs(condition) do
		if(value.effectType == "name") then
			-- Name
			result = result and (not self.playerBuffManager:hasEffectByName(value.name, value.threshold));
		elseif(value.effectType == "id") then
			-- ID
			result = result and (not self.playerBuffManager:hasEffectById(value.name, value.threshold));
		elseif(value.effectType == "original") then
			-- Original
			result = result and (not self.playerBuffManager:hasEffect(value.name, value.threshold));
		else
			error("Invalid EffectType. EffectType:[" .. tostring(value.effectType) .. "]");
		end
	end
	return result;
end;
Kitty.ComboManager.playerNonEffectHelp = function(self, condition)
	local resultList = {};
	for index, value in ipairs(condition) do
		local str = "";
		if(index ~= 1) then
			str = str .. "and ";
		end

		if(value.threshold and value.threshold > 0.0) then
			str = str .. Kitty.colorCyan(value.name .. Kitty.T("message", "OverDuration", value.threshold));
		else
			str = str .. Kitty.colorCyan(value.name);
		end
		table.insert(resultList, str);
	end

	if(#resultList > 1) then
		table.insert(resultList, 1, Kitty.T("message", "PlayerEffect3"));
	elseif(#resultList == 1) then
		resultList[1] = Kitty.T("message", "PlayerEffect4", resultList[1]);
	end

	return resultList;
end;
Kitty.ComboManager.playerNonEffectDescribe = function(self, condition)
	return {
		Kitty.T("message", "playerNonEffectDescription1"),
		Kitty.T("message", "playerNonEffectDescription2"),
		Kitty.T("message", "playerNonEffectDescription3"),
	};
end;
Kitty.ComboManager.playerNonEffectType = function(self, condition)
	return Kitty.ComboManager.TYPE_EFFECT;
end;
--------------------------------------------------------------------------------
-- TargetのBuff/Debuff(どれもなければ)
--------#Target Effect Counter #--------
Kitty.ComboManager.targetEffectCounter = function(self, condition) 
	local result = false;
	local counter = 0;
	for index, value in ipairs(condition) do
		for i=1,100,1 do
			if(value.effectType == "name") then
				local a,b,c,d,e = UnitDebuff("target",i);
				if(a == value.name)
				then
					local duration = UnitDebuffLeftTime("target", i);
					if(duration >= 0.6)
					then
						counter = counter + 1;
					end
				end
			elseif(value.effectType == "id") then
				local a,b,c,d,e = UnitDebuff("target",i);
				if(tonumber(d) == tonumber(value.name))
				then
					local duration = UnitDebuffLeftTime("target", i);
					if(duration >= 0.6)
					then
						counter = counter + 1;
					end
				end
			end
			
		end
		if(counter >= value.threshold)
		then
			result = true;
		end
	end
	return result;
end;
Kitty.ComboManager.targetEffectCounterHelp = function(self, condition)
	local resultList = {};
	for index, value in ipairs(condition) do
		local str = "";
		if(index ~= 1) then
			str = str .. "and ";
		end

		if(value.threshold and value.threshold > 0.0) then
			str = str .. Kitty.colorCyan(value.name .. Kitty.T("message", "StackDuration1", value.threshold));
		else
			str = str .. Kitty.colorCyan(value.name .. Kitty.T("message", "StackDuration2"));
			---str = str .. Kitty.colorCyan(value.name);
		end
		table.insert(resultList, str);
	end

	if(#resultList > 1) then
		table.insert(resultList, 1, Kitty.T("message", "TargetEffect1"));
	elseif(#resultList == 1) then
		resultList[1] = Kitty.T("message", "TargetEffect2", resultList[1]);
	end

	return resultList;
end;
Kitty.ComboManager.targetEffectCounterDescribe = function(self, condition)
	return {
		Kitty.T("message", "targetEffectCounterDescription1"),
		Kitty.T("message", "targetEffectCounterDescription2"),
		Kitty.T("message", "targetEffectCounterDescription3"),
	};
end;
Kitty.ComboManager.targetEffectCounterType = function(self, condition)
	return Kitty.ComboManager.TYPE_EFFECT;
end;
--------------------------------------------------------------------------------

-- TargetのBuff/Debuff(どれもなければ)
--------#Target Effect#--------
Kitty.ComboManager.targetEffect = function(self, condition)
	local result = true;
	for index, value in ipairs(condition) do
		if(value.effectType == "name") then
			-- Name
			result = result and self.targetBuffManager:hasEffectByName(value.name, value.threshold);
		elseif(value.effectType == "id") then
			-- ID
			result = result and self.targetBuffManager:hasEffectById(value.name, value.threshold);
		elseif(value.effectType == "original") then
			-- Original
			result = result and self.targetBuffManager:hasEffect(value.name, value.threshold);
		else
			error("Invalid EffectType. EffectType:[" .. tostring(value.effectType) .. "]");
		end
	end
	return result;
end;
Kitty.ComboManager.targetEffectHelp = function(self, condition)
	local resultList = {};
	for index, value in ipairs(condition) do
		local str = "";
		if(index ~= 1) then
			str = str .. "and ";
		end

		if(value.threshold and value.threshold > 0.0) then
			str = str .. Kitty.colorCyan(value.name .. Kitty.T("message", "OverDuration", value.threshold));
		elseif value.threshold == nil or value.threshold == 0 then
			str = str .. Kitty.colorCyan(value.name);
		elseif value.threshold and value.threshold < 0.0 then
			str = str .. Kitty.colorCyan(value.name .. Kitty.T("message", "OverDuration1", math.abs(value.threshold)));
		end
		table.insert(resultList, str);
	end

	if(#resultList > 1) then
		table.insert(resultList, 1, Kitty.T("message", "TargetEffect1"));
	elseif(#resultList == 1) then
		resultList[1] = Kitty.T("message", "TargetEffect2", resultList[1]);
	end

	return resultList;
end;
Kitty.ComboManager.targetEffectDescribe = function(self, condition)
	return {
		Kitty.T("message", "targetEffectDescription1"),
		Kitty.T("message", "targetEffectDescription2"),
		Kitty.T("message", "targetEffectDescription3"),
	};
end;
Kitty.ComboManager.targetEffectType = function(self, condition)
	return Kitty.ComboManager.TYPE_EFFECT;
end;

--------------------------------------------------------------------------------
-- TargetのBuff/Debuff(どれもなければ)
--------#Target Non Effect#--------
Kitty.ComboManager.targetNonEffect = function(self, condition)
	local result = true;
	for index, value in ipairs(condition) do
		if(value.effectType == "name") then
			-- Name
			result = result and (not self.targetBuffManager:hasEffectByName(value.name, value.threshold));
		elseif(value.effectType == "id") then
			-- ID
			result = result and (not self.targetBuffManager:hasEffectById(value.name, value.threshold));
		elseif(value.effectType == "original") then
			-- Original
			result = result and (not self.targetBuffManager:hasEffect(value.name, value.threshold));
		else
			error("Invalid EffectType. EffectType:[" .. tostring(value.effectType) .. "]");
		end
	end
	return result;
end;
Kitty.ComboManager.targetNonEffectHelp = function(self, condition)
	local resultList = {};
	for index, value in ipairs(condition) do
		local str = "";
		if(index ~= 1) then
			str = str .. "and ";
		end

		if(value.threshold and value.threshold > 0.0) then
			str = str .. Kitty.colorCyan(value.name .. Kitty.T("message", "OverDuration", value.threshold));
		else
			str = str .. Kitty.colorCyan(value.name);
		end
		table.insert(resultList, str);
	end

	if(#resultList > 1) then
		table.insert(resultList, 1, Kitty.T("message", "TargetEffect3"));
	elseif(#resultList == 1) then
		resultList[1] = Kitty.T("message", "TargetEffect4", resultList[1]);
	end

	return resultList;
end;
Kitty.ComboManager.targetNonEffectDescribe = function(self, condition)
	return {
		Kitty.T("message", "targetNonEffectDescription1"),
		Kitty.T("message", "targetNonEffectDescription2"),
		Kitty.T("message", "targetNonEffectDescription3"),
	};
end;
Kitty.ComboManager.targetNonEffectType = function(self, condition)
	return Kitty.ComboManager.TYPE_EFFECT;
end;

-- PlayerのBuff/Debuff(どれもなければ)
--------#Player Health#--------
Kitty.ComboManager.playerHealth = function(self, min, max)
	return Kitty.ClassManager.hasHealthByRate("player", min, max);
end;
Kitty.ComboManager.playerHealthHelp = function(self, min, max)
	if(min == nil) then
		return Kitty.T("message", "HP1", Kitty.colorCyan(max));
	end
	if(max == nil) then
		return Kitty.T("message", "HP2", Kitty.colorCyan(min));
	end
	return Kitty.T("message", "HP3", Kitty.colorCyan(min), Kitty.colorCyan(max));
end;
Kitty.ComboManager.playerHealthDescribe = function(self, min, max)
	return {
		Kitty.T("message", "playerHealthDescription1"),
		Kitty.T("message", "playerHealthDescription2"),
		Kitty.T("message", "playerHealthDescription3"),
	};
end;
Kitty.ComboManager.playerHealthType = function(self, min, max)
	return Kitty.ComboManager.TYPE_NUMBER;
end;
Kitty.ComboManager.playerHealthMinMax = function( self )
	return 0, 100
end
-- TargetのBuff/Debuff(どれもなければ)
--------#Target Health#--------
Kitty.ComboManager.targetHealth = function(self, min, max)
	return Kitty.ClassManager.hasHealthByRate("target", min, max);
end;
Kitty.ComboManager.targetHealthHelp = function(self, min, max)
	if(min == nil) then
		return Kitty.T("message", "HP1", Kitty.colorCyan(max));
	end
	if(max == nil) then
		return Kitty.T("message", "HP2", Kitty.colorCyan(min));
	end
	return Kitty.T("message", "HP3", Kitty.colorCyan(min), Kitty.colorCyan(max));
end;
Kitty.ComboManager.targetHealthDescribe = function(self, min, max)
	return {
		Kitty.T("message", "targetHealthDescription1"),
		Kitty.T("message", "targetHealthDescription2"),
		Kitty.T("message", "targetHealthDescription3"),
	};
end;
Kitty.ComboManager.targetHealthType = function(self, min, max)
	return Kitty.ComboManager.TYPE_NUMBER;
end;
Kitty.ComboManager.targetHealthMinMax = function( self )
	return 0, 100
end
-- PlayerのBuff/Debuff(どれもなければ)
--------#Player Mana#--------
Kitty.ComboManager.playerMana = function(self, min, max)
	return Kitty.ClassManager.hasManaByRate("player", min, max);
end;
Kitty.ComboManager.playerManaHelp = function(self, min, max)
	if(min == nil) then
		return Kitty.T("message", "MP1", Kitty.colorCyan(max));
	end
	if(max == nil) then
		return Kitty.T("message", "MP2", Kitty.colorCyan(min));
	end
	return Kitty.T("message", "MP3", Kitty.colorCyan(min), Kitty.colorCyan(max));
end;
Kitty.ComboManager.playerManaDescribe = function(self, min, max)
	return {
		Kitty.T("message", "playerManaDescription1"),
		Kitty.T("message", "playerManaDescription2"),
		Kitty.T("message", "playerManaDescription3"),
	};
end;
Kitty.ComboManager.playerManaType = function(self, min, max)
	return Kitty.ComboManager.TYPE_NUMBER;
end;
Kitty.ComboManager.playerManaMinMax = function( self )
	return 0, 100
end
-- PlayerのBuff/Debuff(どれもなければ)
--------#Player Tension#--------
Kitty.ComboManager.playerTension = function(self, min, max)
	return Kitty.ClassManager.hasTension("player", min, max);
end;
Kitty.ComboManager.playerTensionHelp = function(self, min, max)
	if(min == nil) then
		return Kitty.T("message", "Tension1", Kitty.colorCyan(max));
	end
	if(max == nil) then
		return Kitty.T("message", "Tension2", Kitty.colorCyan(min));
	end
	return Kitty.T("message", "Tension3", Kitty.colorCyan(min), Kitty.colorCyan(max));
end;
Kitty.ComboManager.playerTensionDescribe = function(self, min, max)
	return {
		Kitty.T("message", "playerTensionDescription1"),
		Kitty.T("message", "playerTensionDescription2"),
		Kitty.T("message", "playerTensionDescription3"),
	};
end;
Kitty.ComboManager.playerTensionType = function(self, min, max)
	return Kitty.ComboManager.TYPE_NUMBER;
end;
Kitty.ComboManager.playerTensionMinMax = function( self )
	return 0, 100
end
-- PlayerのBuff/Debuff(どれもなければ)
--------#Player Focus#--------
Kitty.ComboManager.playerFocus = function(self, min, max)
	return Kitty.ClassManager.hasFocus("player", min, max);
end;
Kitty.ComboManager.playerFocusHelp = function(self, min, max)
	if(min == nil) then
		return Kitty.T("message", "Focus1", Kitty.colorCyan(max));
	end
	if(max == nil) then
		return Kitty.T("message", "Focus2", Kitty.colorCyan(min));
	end
	return Kitty.T("message", "Focus3", Kitty.colorCyan(min), Kitty.colorCyan(max));
end;
Kitty.ComboManager.playerFocusDescribe = function(self, min, max)
	return {
		Kitty.T("message", "playerFocusDescription1"),
		Kitty.T("message", "playerFocusDescription2"),
		Kitty.T("message", "playerFocusDescription3"),
	};
end;
Kitty.ComboManager.playerFocusType = function(self, min, max)
	return Kitty.ComboManager.TYPE_NUMBER;
end;
Kitty.ComboManager.playerFocusMinMax = function( self )
	return 0, 200
end
-- PlayerのBuff/Debuff(どれもなければ)
--------#Player Engergy#--------
Kitty.ComboManager.playerEnergy = function(self, min, max)
	return Kitty.ClassManager.hasEnergy("player", min, max);
end;
Kitty.ComboManager.playerEnergyHelp = function(self, min, max)
	if(min == nil) then
		return Kitty.T("message", "Energy1", Kitty.colorCyan(max));
	end
	if(max == nil) then
		return Kitty.T("message", "Energy2", Kitty.colorCyan(min));
	end
	return Kitty.T("message", "Energy3", Kitty.colorCyan(min), Kitty.colorCyan(max));
end;
Kitty.ComboManager.playerEnergyDescribe = function(self, min, max)
	return {
		Kitty.T("message", "playerEnergyDescription1"),
		Kitty.T("message", "playerEnergyDescription2"),
		Kitty.T("message", "playerEnergyDescription3"),
	};
end;
Kitty.ComboManager.playerEnergyType = function(self, min, max)
	return Kitty.ComboManager.TYPE_NUMBER;
end;
Kitty.ComboManager.playerEnergyMinMax = function( self )
	return 0, 100
end
-- PlayerのBuff/Debuff(どれもなければ)
--------#Player PSI#--------
Kitty.ComboManager.playerSoulPoint = function(self, min, max)
	if(min == nil) then
		min = 0;
	end
	if(max == nil) then
		max = 6;
	end

	local point, _ = Kitty.ClassManager.getSoulPoint();
	if(min <= point and point <= max) then
		return true, point;
	else
		return false, point;
	end
end;
Kitty.ComboManager.playerSoulPointHelp = function(self, min, max)
	if(min == nil) then
		return Kitty.T("message", "SoulPoint1", Kitty.colorCyan(max));
	end
	if(max == nil) then
		return Kitty.T("message", "SoulPoint2", Kitty.colorCyan(min));
	end
	return Kitty.T("message", "SoulPoint3", Kitty.colorCyan(min), Kitty.colorCyan(max));
end;
Kitty.ComboManager.playerSoulPointDescribe = function(self, min, max)
	return {
		Kitty.T("message", "playerSoulPointDescription1"),
		Kitty.T("message", "playerSoulPointDescription2"),
		Kitty.T("message", "playerSoulPointDescription3"),
	};
end;
Kitty.ComboManager.playerSoulPointType = function(self, min, max)
	return Kitty.ComboManager.TYPE_NUMBER;
end;
Kitty.ComboManager.playerSoulPointMinMax = function( self )
	return 0, 6
end
-- PlayerのBuff/Debuff(どれもなければ)
--------#Player Name#--------
Kitty.ComboManager.playerName = function(self, value)
	local playerName = UnitName("player");
	if(playerName == nil) then
		return false;
	end

	-- 引数の型を統一
	local outData = Kitty.BuffManager.format(value, true);
	for name, bool in pairs(outData) do
		if(playerName == name) then
			if(bool) then
				return true;
			else
				return false;
			end
		end
	end
	return false;
end;
Kitty.ComboManager.playerNameHelp = function(self, value)
	-- 引数の型を統一
	local outData = Kitty.BuffManager.format(value, true);

	local str = "";
	for name, bool in pairs(outData) do
		if(str ~= "") then
			str = str .. ", ";
		end

		if(bool) then
			str = str .. Kitty.colorCyan(name);
		else
			str = str .. Kitty.colorCyan(name) .. Kitty.T("message", "Exception");
		end
	end
	return Kitty.T("message", "PlayerName", str);
end;
Kitty.ComboManager.playerNameDescribe = function(self, value)
	return {
		Kitty.T("message", "playerNameDescription1"),
		Kitty.T("message", "playerNameDescription2"),
		Kitty.T("message", "playerNameDescription3"),
	};
end;
Kitty.ComboManager.playerNameType = function(self, value)
	return Kitty.ComboManager.TYPE_STRING;
end;

-- TargetのBuff/Debuff(どれもなければ)
--------#Target Name#--------
Kitty.ComboManager.targetName = function(self, value)
	local targetName = UnitName("target");
	if(targetName == nil) then
		return false;
	end

	-- 引数の型を統一
	local outData = Kitty.BuffManager.format(value, true);
	for name, bool in pairs(outData) do
		if(targetName == name) then
			if(bool) then
				return true;
			else
				return false;
			end
		end
	end
	return false;
end;
Kitty.ComboManager.targetNameHelp = function(self, value)
	-- 引数の型を統一
	local outData = Kitty.BuffManager.format(value, true);

	local str = "";
	for name, bool in pairs(outData) do
		if(str ~= "") then
			str = str .. ", ";
		end

		if(bool) then
			str = str .. Kitty.colorCyan(name);
		else
			str = str .. Kitty.colorCyan(name) .. Kitty.T("message", "Exception");
		end
	end
	return Kitty.T("message", "TargetName", str);
end;
Kitty.ComboManager.targetNameDescribe = function(self, value)
	return {
		Kitty.T("message", "targetNameDescription1"),
		Kitty.T("message", "targetNameDescription2"),
		Kitty.T("message", "targetNameDescription3"),
	};
end;
Kitty.ComboManager.targetNameType = function(self, value)
	return Kitty.ComboManager.TYPE_STRING;
end;

-- PlayerのBuff/Debuff(どれもなければ)
--------#Player Is Fearless#--------
Kitty.ComboManager.playerIsFearless = function(self, value)
	if(self.playerBuffManager:isFearless(Kitty.ClassManager.isCaster("target"))) then
		return value;
	else
		return not value;
	end
end;
Kitty.ComboManager.playerIsFearlessHelp = function(self, value)
	if(value) then
		return Kitty.T("message", "PlayerState1", Kitty.T("message", "MatchlessState"));
	else
		return Kitty.T("message", "PlayerState2", Kitty.T("message", "MatchlessState"));
	end
end;
Kitty.ComboManager.playerIsFearlessDescribe = function(self, value)
	return {
		Kitty.T("message", "playerIsFearlessDescription1"),
		Kitty.T("message", "playerIsFearlessDescription2"),
		Kitty.T("message", "playerIsFearlessDescription3"),
	};
end;
Kitty.ComboManager.playerIsFearlessType = function(self, value)
	return Kitty.ComboManager.TYPE_BOOLEAN;
end;

-- TargetのBuff/Debuff(どれもなければ)
--------#Target Is Fearless#--------
Kitty.ComboManager.targetIsFearless = function(self, value)
	if(self.targetBuffManager:isFearless(Kitty.ClassManager.isCaster("player"))) then
		return value;
	else
		return not value;
	end
end;
Kitty.ComboManager.targetIsFearlessHelp = function(self, value)
	if(value) then
		return Kitty.T("message", "TargetState1", Kitty.T("message", "MatchlessState"));
	else
		return Kitty.T("message", "TargetState2", Kitty.T("message", "MatchlessState"));
	end
end;
Kitty.ComboManager.targetIsFearlessDescribe = function(self, value)
	return {
		Kitty.T("message", "targetIsFearlessDescription1"),
		Kitty.T("message", "targetIsFearlessDescription2"),
		Kitty.T("message", "targetIsFearlessDescription3"),
	};
end;
Kitty.ComboManager.targetIsFearlessType = function(self, value)
	return Kitty.ComboManager.TYPE_BOOLEAN;
end;

-- PlayerのBuff/Debuff(どれもなければ)
--------#Player Class#--------
Kitty.ComboManager.playerClass = function(self, value)
	if(value == nil) then
		return false;
	end

	-- 引数の型を統一
	local outData = Kitty.BuffManager.format(value, true);

	local isExist = false;
	local orResult = false;
	local andResult = true;
	for combineClass, isTarget in pairs(outData) do
		if(isTarget) then
			-- どれか
			orResult = orResult or Kitty.BuildManager.matchWithTarget("player", combineClass);
			isExist = true;
		else
			-- どれも
			andResult = andResult and (not Kitty.BuildManager.matchWithTarget("player", combineClass));
		end
	end

	return ((orResult or (not isExist)) and andResult);
end;
Kitty.ComboManager.playerClassHelp = function(self, value)
	-- 引数の型を統一
	local outData = Kitty.BuffManager.format(value, true);

	local strTrue = "";
	local strFalse = "";
	for combineClass, isTarget in pairs(outData) do
		if(isTarget) then
			if(strTrue ~= "") then
				strTrue = strTrue .. ", ";
			end
			strTrue = strTrue .. Kitty.colorCyan(combineClass);
		else
			if(strFalse ~= "") then
				strFalse = strFalse .. ", ";
			end
			strFalse = strFalse .. Kitty.colorCyan(combineClass);
		end
	end

	-- メッセージ編集
	if(strTrue ~= "") then
		strTrue = Kitty.T("message", "PlayerState1", strTrue);
	end
	if(strFalse ~= "") then
		strFalse = Kitty.T("message", "PlayerState2", strFalse);
	end
	-- メッセージ複合
	if(strTrue ~= "" and strFalse ~= "") then
		return strTrue .. " " .. strFalse;
	else
		return strTrue .. strFalse;
	end
end;
Kitty.ComboManager.playerClassDescribe = function(self, value)
	return {
		Kitty.T("message", "playerClassDescription1"),
		Kitty.T("message", "playerClassDescription2"),
		Kitty.T("message", "playerClassDescription3"),
	};
end;
Kitty.ComboManager.playerClassType = function(self, value)
	return Kitty.ComboManager.TYPE_BUILD;
end;

-- TargetのBuff/Debuff(どれもなければ)
--------#Target Class#--------
Kitty.ComboManager.targetClass = function(self, value)
	if(value == nil) then
		return false;
	end
	if(not Kitty.ClassManager.isPC("target")) then
		return false;
	end

	-- 引数の型を統一
	local outData = Kitty.BuffManager.format(value, true);

	local isExist = false;
	local orResult = false;
	local andResult = true;
	for combineClass, isTarget in pairs(outData) do
		if(isTarget) then
			-- どれか
			orResult = orResult or Kitty.BuildManager.matchWithTarget("target", combineClass);
			isExist = true;
		else
			-- どれも
			andResult = andResult and (not Kitty.BuildManager.matchWithTarget("target", combineClass));
		end
	end

	return ((orResult or (not isExist)) and andResult);
end;
Kitty.ComboManager.targetClassHelp = function(self, value)
	-- 引数の型を統一
	local outData = Kitty.BuffManager.format(value, true);

	local strTrue = "";
	local strFalse = "";
	for combineClass, isTarget in pairs(outData) do
		if(isTarget) then
			if(strTrue ~= "") then
				strTrue = strTrue .. ", ";
			end
			strTrue = strTrue .. Kitty.colorCyan(combineClass);
		else
			if(strFalse ~= "") then
				strFalse = strFalse .. ", ";
			end
			strFalse = strFalse .. Kitty.colorCyan(combineClass);
		end
	end

	-- メッセージ編集
	if(strTrue ~= "") then
		strTrue = Kitty.T("message", "TargetState1", strTrue);
	end
	if(strFalse ~= "") then
		strFalse = Kitty.T("message", "TargetState2", strFalse);
	end
	-- メッセージ複合
	if(strTrue ~= "" and strFalse ~= "") then
		return strTrue .. " " .. strFalse;
	else
		return strTrue .. strFalse;
	end
end;
Kitty.ComboManager.targetClassDescribe = function(self, value)
	return {
		Kitty.T("message", "targetClassDescription1"),
		Kitty.T("message", "targetClassDescription2"),
		Kitty.T("message", "targetClassDescription3"),
	};
end;
Kitty.ComboManager.targetClassType = function(self, value)
	return Kitty.ComboManager.TYPE_BUILD;
end;

-- TargetのBuff/Debuff(どれもなければ)
--------#Target Is PC#--------
Kitty.ComboManager.targetIsPC = function(self, value)
	if(value== nil) then
		value = true;
	end
	if(value) then
		return Kitty.ClassManager.isPC("target");
	else
		return (not Kitty.ClassManager.isPC("target"));
	end
end;
Kitty.ComboManager.targetIsPCHelp = function(self, value)
	if(value) then
		return Kitty.T("message", "TargetState1", Kitty.colorCyan("PC"));
	else
		return Kitty.T("message", "TargetState2", Kitty.colorCyan("PC"));
	end
end;
Kitty.ComboManager.targetIsPCDescribe = function(self, value)
	return {
		Kitty.T("message", "targetIsPCDescription1"),
		Kitty.T("message", "targetIsPCDescription2"),
		Kitty.T("message", "targetIsPCDescription3"),
	};
end;
Kitty.ComboManager.targetIsPCType = function(self, value)
	return Kitty.ComboManager.TYPE_BOOLEAN;
end;

-- TargetのBuff/Debuff(どれもなければ)
--------#Target Is Caster#--------
Kitty.ComboManager.targetIsCaster = function(self, value)
	if(value== nil) then
		value = true;
	end
	if(value) then
		return Kitty.ClassManager.isCaster("target");
	else
		return (not Kitty.ClassManager.isCaster("target"));
	end
end;
Kitty.ComboManager.targetIsCasterHelp = function(self, value)
	if(value) then
		return Kitty.T("message", "TargetState1", Kitty.colorCyan(Kitty.T("message", "SpellCaster")));
	else
		return Kitty.T("message", "TargetState2", Kitty.colorCyan(Kitty.T("message", "SpellCaster")));
	end
end;
Kitty.ComboManager.targetIsCasterDescribe = function(self, value)
	return {
		Kitty.T("message", "targetIsCasterDescription1"),
		Kitty.T("message", "targetIsCasterDescription2"),
		Kitty.T("message", "targetIsCasterDescription3"),
	};
end;
Kitty.ComboManager.targetIsCasterType = function(self, value)
	return Kitty.ComboManager.TYPE_BOOLEAN;
end;

-- TargetのBuff/Debuff(どれもなければ)
--------#Target Is Boss#--------
Kitty.ComboManager.targetIsBoss = function(self, value)
	if(value== nil) then
		value = true;
	end

	if(UnitSex("target") >= 3) then
		return value;
	else
		return (not value);
	end
end;
Kitty.ComboManager.targetIsBossHelp = function(self, value)
	if(value) then
		return Kitty.T("message", "TargetState1", Kitty.colorCyan(Kitty.T("message", "KingBoss")));
	else
		return Kitty.T("message", "TargetState2", Kitty.colorCyan(Kitty.T("message", "KingBoss")));
	end
end;
Kitty.ComboManager.targetIsBossDescribe = function(self, value)
	return {
		Kitty.T("message", "targetIsBossDescription1"),
		Kitty.T("message", "targetIsBossDescription2"),
		Kitty.T("message", "targetIsBossDescription3"),
	};
end;
Kitty.ComboManager.targetIsBossType = function(self, value)
	return Kitty.ComboManager.TYPE_BOOLEAN;
end;

-- PlayerのBuff/Debuff(どれもなければ)
--------#Warden Player Pet#--------
Kitty.ComboManager.wardenPetExists = function(self, value)
	if(value== nil) then
		value = true;
	end

	local PetExists = UnitExists("playerpet")
	if PetExists then
		return value;
	else
		return (not value);
	end
end;
Kitty.ComboManager.wardenPetExistsHelp = function(self, value)
	if(value) then
		return Kitty.T("message", "wardenPetExistsState1", Kitty.colorCyan(Kitty.T("message", "WardenPet")));
	else
		return Kitty.T("message", "wardenPetExistsState2", Kitty.colorCyan(Kitty.T("message", "WardenPet")));
	end
end;
Kitty.ComboManager.wardenPetExistsDescribe = function(self, value)
	return {
		Kitty.T("message", "wardenPetExistsDescription1"),
		Kitty.T("message", "wardenPetExistsDescription2"),
		Kitty.T("message", "wardenPetExistsDescription3"),
	};
end;
Kitty.ComboManager.wardenPetExistsType = function(self, value)
	return Kitty.ComboManager.TYPE_BOOLEAN;
end;


-- TargetのBuff/Debuff(どれもなければ)
--------#Target Is Dead#--------
Kitty.ComboManager.targetIsDead = function(self, value)
	if(value== nil) then
		value = true;
	end

	if(UnitIsDeadOrGhost("target") == true) then
		return value;
	else
		return (not value);
	end
end;
Kitty.ComboManager.targetIsDeadHelp = function(self, value)
	if(value) then
		return Kitty.T("message", "TargetState1", Kitty.colorCyan(Kitty.T("message", "DeadState")));
	else
		return Kitty.T("message", "TargetState2", Kitty.colorCyan(Kitty.T("message", "DeadState")));
	end
end;
Kitty.ComboManager.targetIsDeadDescribe = function(self, value)
	return {
		Kitty.T("message", "targetIsDeadDescription1"),
		Kitty.T("message", "targetIsDeadDescription2"),
		Kitty.T("message", "targetIsDeadDescription3"),
	};
end;
Kitty.ComboManager.targetIsDeadType = function(self, value)
	return Kitty.ComboManager.TYPE_BOOLEAN;
end;

-- Condition
--------#Is Combat#----------
Kitty.ComboManager.isCombat = function(self, value)
	if(value == nil) then
		value = true;
	end
	if(value) then
		return GetPlayerCombatState();
	else
		return (not GetPlayerCombatState());
	end
end;
Kitty.ComboManager.isCombatHelp = function(self, value)
	if(value) then
		return Kitty.T("message", "OnCombat");
	else
		return Kitty.T("message", "OffCombat");
	end
end;
Kitty.ComboManager.isCombatDescribe = function(self, value)
	return {
		Kitty.T("message", "isCombatDescription1"),
		Kitty.T("message", "isCombatDescription2"),
		Kitty.T("message", "isCombatDescription3"),
	};
end;
Kitty.ComboManager.isCombatType = function(self, value)
	return Kitty.ComboManager.TYPE_BOOLEAN;
end;

-- Condition
--------#Is CG#----------
Kitty.ComboManager.isCG = function(self, value)
	if(value == nil) then
		value = true;
	end
	if(value) then
		return IsBattleGroundZone();
	else
		return (not IsBattleGroundZone());
	end
end;
Kitty.ComboManager.isCGHelp = function(self, value)
	if(value) then
		return Kitty.T("message", "OnCG");
	else
		return Kitty.T("message", "OffCG");
	end
end;
Kitty.ComboManager.isCGDescribe = function(self, value)
	return {
		Kitty.T("message", "isCGDescription1"),
		Kitty.T("message", "isCGDescription2"),
		Kitty.T("message", "isCGDescription3"),
	};
end;
Kitty.ComboManager.isCGType = function(self, value)
	return Kitty.ComboManager.TYPE_BOOLEAN;
end;

-- Condition
--------#Is Targeted#----------
Kitty.ComboManager.isTargeted = function(self, value)
	if(value== nil) then
		value = true;
	end
	if(value) then
		return UnitIsUnit("player", "targettarget");
	else
		return (not UnitIsUnit("player", "targettarget"));
	end
end;
Kitty.ComboManager.isTargetedHelp = function(self, value)
	if(value) then
		return Kitty.T("message", "Targeted");
	else
		return Kitty.T("message", "Untargeted");
	end
end;
Kitty.ComboManager.isTargetedDescribe = function(self, value)
	return {
		Kitty.T("message", "isTargetedDescription1"),
		Kitty.T("message", "isTargetedDescription2"),
		Kitty.T("message", "isTargetedDescription3"),
	};
end;
Kitty.ComboManager.isTargetedType = function(self, value)
	return Kitty.ComboManager.TYPE_BOOLEAN;
end;

-- Condition
--------#Can Cast#----------
Kitty.ComboManager.canCast = function(self, condition)
	local result = true;
	for index, value in ipairs(condition) do
		result = result and self.skillManager:canCast(value.name);
	end
	return result;
end;
Kitty.ComboManager.canCastHelp = function(self, condition)
	local str = "";
	for index, value in ipairs(condition) do
		if(str ~= "") then
			str = str .. ", ";
		end

		if(value.threshold > 0.0) then
			str = str .. Kitty.colorCyan(value.name .. Kitty.T("message", "OverDuration", value.threshold));
		else
			str = str .. Kitty.colorCyan(value.name);
		end
	end
	return Kitty.T("message", "CanCast", str);
end;
Kitty.ComboManager.canCastDescribe = function(self, condition)
	return {
		Kitty.T("message", "canCastDescription1"),
		Kitty.T("message", "canCastDescription2"),
		Kitty.T("message", "canCastDescription3"),
	};
end;
Kitty.ComboManager.canCastType = function(self, condition)
	return Kitty.ComboManager.TYPE_STRING_NUMBER_LIST;
end;

-- Condition
--------#Can Use#----------
Kitty.ComboManager.canUse = function(self, condition)
	local result = true;
	for index, value in ipairs(condition) do
		result = result and self.slotManager:canUse(value.name);
	end
	return result;
end;
Kitty.ComboManager.canUseHelp = function(self, condition)
	local str = "";
	for index, value in ipairs(condition) do
		if(str ~= "") then
			str = str .. ", ";
		end

		if(value.threshold > 0.0) then
			str = str .. Kitty.colorCyan(value.name .. Kitty.T("message", "OverDuration", value.threshold));
		else
			str = str .. Kitty.colorCyan(value.name);
		end
	end
	return Kitty.T("message", "UsableMessage", str);
end;
Kitty.ComboManager.canUseDescribe = function(self, condition)
	return {
		Kitty.T("message", "canUseDescription1"),
		Kitty.T("message", "canUseDescription2"),
		Kitty.T("message", "canUseDescription3"),
	};
end;
Kitty.ComboManager.canUseType = function(self, condition)
	return Kitty.ComboManager.TYPE_STRING_NUMBER_LIST;
end;

-- Condition
--------#Is Two Handed#----------
Kitty.ComboManager.isTwoHanded = function(self, value)
	if(value == nil) then
		value = true;
	end

	local isTwoHandedWeapon = nil
	if(Kitty.ClassManager.getWeaponType("player") == Kitty.ClassManager.TWO_HANDED) then
		isTwoHandedWeapon = true;
	else
		isTwoHandedWeapon = false;
	end

	if(value) then
		return isTwoHandedWeapon;
	else
		return not isTwoHandedWeapon;
	end
end;
Kitty.ComboManager.isTwoHandedHelp = function(self, value)
	if(value) then
		return Kitty.T("message", "TwoHanded");
	else
		return Kitty.T("message", "SingleHanded");
	end
end;
Kitty.ComboManager.isTwoHandedDescribe = function(self, value)
	return {
		Kitty.T("message", "isTwoHandedDescription1"),
		Kitty.T("message", "isTwoHandedDescription2"),
		Kitty.T("message", "isTwoHandedDescription3"),
	};
end;
Kitty.ComboManager.isTwoHandedType = function(self, value)
	return Kitty.ComboManager.TYPE_BOOLEAN;
end;

-- Condition
--------#Is Shield#----------
Kitty.ComboManager.isShield = function(self, value)
	if(value == nil) then
		value = true;
	end

	local isShield = nil
	if(Kitty.ClassManager.getWeaponType("player") == Kitty.ClassManager.SHIELD) then
		isShield = true;
	else
		isShield = false;
	end

	if(value) then
		return isShield;
	else
		return not isShield;
	end
end;
Kitty.ComboManager.isShieldHelp = function(self, value)
	if(value) then
		return Kitty.T("message", "HasShield");
	else
		return Kitty.T("message", "HasNotShield");
	end
end;
Kitty.ComboManager.isShieldDescribe = function(self, value)
	return {
		Kitty.T("message", "isShieldDescription1"),
		Kitty.T("message", "isShieldDescription2"),
		Kitty.T("message", "isShieldDescription3"),
	};
end;
Kitty.ComboManager.isShieldType = function(self, value)
	return Kitty.ComboManager.TYPE_BOOLEAN;
end;

-- Condition
--------#Is in Range#----------
Kitty.ComboManager.inRange = function(self, skill)
	local result = self.slotManager:inRange(skill);
	if(result ~= nil) then
		return self.slotManager:inRange(skill);
	else
		-- ショートカットなし
		SendWarningMsg(Kitty.format("Shortcut for inRange is not registered. SkillName:[<<1>>]", tostring(skill)));
		return false;
	end
end;
Kitty.ComboManager.inRangeHelp = function(self, skill)
	return Kitty.T("message", "InRange", Kitty.colorCyan(skill));
end;
Kitty.ComboManager.inRangeDescribe = function(self, skill)
	return {
		Kitty.T("message", "inRangeDescription1"),
		Kitty.T("message", "inRangeDescription2"),
		Kitty.T("message", "inRangeDescription3"),
	};
end;
Kitty.ComboManager.inRangeType = function(self, skill)
	return Kitty.ComboManager.TYPE_ACTION;
end;

-- Condition
--------#Is Requested#----------
Kitty.ComboManager.isRequest = function(self, value)
	if(value == nil) then
		value = true;
	end
	if(value) then
		return Kitty.isRequest;
	else
		return not Kitty.isRequest;
	end
end;
Kitty.ComboManager.isRequestHelp = function(self, value)
	if(value) then
		return Kitty.T("message", "IsRequestOn");
	else
		return Kitty.T("message", "IsRequestOff");
	end
end;
Kitty.ComboManager.isRequestDescribe = function(self, value)
	return {
		Kitty.T("message", "isRequestDescription1"),
		Kitty.T("message", "isRequestDescription2"),
		Kitty.T("message", "isRequestDescription3"),
	};
end;
Kitty.ComboManager.isRequestType = function(self, value)
	return Kitty.ComboManager.TYPE_BOOLEAN;
end;

--------------------------------------------------------------------------------
Kitty.ComboManager.func = function(self, func)
	if(func ~= nil) then
		return func(self.targetBuffManager, self.playerBuffManager, self.skillManager);
	end
end;
Kitty.ComboManager.funcHelp = function(self, func)
	return Kitty.T("message", "SpecialState");
end;
Kitty.ComboManager.funcDescribe = function(self, func)
	return {
		Kitty.T("message", "funcDescription1"),
		Kitty.T("message", "funcDescription2"),
		Kitty.T("message", "funcDescription3"),
	};
end;
Kitty.ComboManager.funcType = function(self, func)
	return Kitty.ComboManager.TYPE_OTHER;
end;

--------------------------------------------------------------------------------
Kitty.ComboManager.debugSkillList = {};
--Kitty.ComboManager.debugSkillList = {["ダーティトリック"]=true};
Kitty.ComboManager.check = function(self, targetList)
	-- スキルチェック
	-- コマンドごとにループ
	for _, command in ipairs(targetList) do
		-- 有効なコマンド
		if(command.enable ~= false) then	-- nilは実行する
			local result = false;

			if(command.commandType == "skill") then
				-- 詠唱可能チェック(スキル)
				result = self.skillManager:canCast(command.commandName);
				-- Debug.
				if(Kitty.ComboManager.debugSkillList[command.commandName] == true) then
					Kitty.print("canCast Result:[" .. tostring(result) .. "], Command:[" .. tostring(command.commandName) .. "]");
				end
			elseif(command.commandType == "suitskill") then
				-- 詠唱可能チェック(スキル)
				result = self.skillManager:canCast(command.commandName);
				-- Debug.
				if(Kitty.ComboManager.debugSkillList[command.commandName] == true) then
					Kitty.print("canCast Result:[" .. tostring(result) .. "], Command:[" .. tostring(command.commandName) .. "]");
				end
			elseif(command.commandType == "action") then
				-- 利用可能チェック(アクション)
				result = self.slotManager:canUse(command.commandName);
				-- Debug.
				if(Kitty.ComboManager.debugSkillList[command.commandName] == true) then
					Kitty.print("canUse Result:[" .. tostring(result) .. "], Command:[" .. tostring(command.commandName) .. "]");
				end
			elseif(command.commandType == "extra") then
				-- 利用可能チェック(Exスキル)
				local extraActionIndex = tonumber(command.commandName);
				if(extraActionIndex == nil) then
					-- スキル名指定
					local extraActionManager = Kitty.ExtraActionManager();
					result = extraActionManager:canUse(command.commandName);
				else
					-- インデックス指定
					result = Kitty.ExtraActionManager.canUseByIndex(extraActionIndex);
				end
			elseif(command.commandType == "macro") then
				-- マクロ
				result = self.macroManager:canExecute(command.commandName);
				if(result) then
					-- Cooldown判定
					result = self.cooldownManager:canCast(command.commandName);
				end
			elseif(command.commandType == "emote") then
				-- エモーション
				local emotionManager = Kitty.EmotionManager();
				result = emotionManager:canEmote(command.commandName);
				if(result) then
					-- Cooldown判定
					result = self.cooldownManager:canCast(command.commandName);
				end
			elseif(command.commandType == "proc") then
				-- プロシージャ
				local commandLists = Kitty.ComboManager.selectCommandListByName({command.commandName});
				if(#commandLists > 0) then
					-- コマンド発動条件をチェック
					result = self:checkCondition(command);
					if(result) then
						local commandType, commandName = self:check(commandLists[1]);	-- 再帰呼出し
						if(commandType ~= nil) then
							Kitty.debugPrint("Check result. CommandType:[" .. commandType .. "], CommandName:[" .. commandName .. "], ProcName:[" .. command.commandName .. "]");
							return commandType, commandName, command.commandName;
						else
							-- procはCT中
							result = false;
						end
					end
				else
					error("Invalid Proc. ProcName:[" .. tostring(command.commandName) .. "]");
				end
			elseif(command.commandType == "break") then
				-- ストッパー
				result = true;
			elseif(command.commandType == "debug") then
				-- デバッグメッセージ
				result = true;
			else
--				error("Invalid CommandType:[" .. tostring(command.commandType) .. "]");
			end

			if(result) then
				-- コマンド発動条件をチェック
				result = self:checkCondition(command);
			end

			if(result) then
				Kitty.debugPrint("Check result. CommandType:[" .. command.commandType .. "], CommandName:[" .. command.commandName .. "]");
				return command.commandType, command.commandName, nil;
			end
		end
	end

	-- Debug.
	Kitty.debugPrint("SelectedCommand:[nil], CommandName:[" .. tostring(targetList.info.name) .. "]");
	return nil;
end;
-- コマンドの発動条件をチェック
Kitty.ComboManager.checkCondition = function(self, command)
	local result = true;

	-- 発動条件ごとにループ
	for _, condition in ipairs(command) do
		-- チェック関数実行
		local func = self[condition.conditionType];
		assert(func, "Error: Function:[" .. tostring(condition.conditionType) .. "] is nothing.");
		result = Kitty.pcall(func, self, Kitty.ComboManager.getArgument(condition));

		-- Debug.
		if(Kitty.ComboManager.debugSkillList[command.commandName] == true) then
			Kitty.print("checkCondition Result:[" .. tostring(result) .. "], Command:[" .. tostring(command.commandName) .. "], ConditionType:[" .. tostring(condition.conditionType) .. "]", Kitty.ComboManager.getArgument(condition));
		end

		if(result ~= true) then
			break;
		end
	end
	return result;
end;

Kitty.ComboManager.cast = function(self, commandType, command)
	if(commandType == "skill") or (commandType == "suitskill") then
		-- 実行(スキル)
		self.skillManager:cast(command);

	elseif(commandType == "action") then
		-- 実行(アクション)
		self.slotManager:use(command);
	elseif(commandType == "extra") then
		-- 利用可能チェック(Exスキル)
		local extraActionIndex = tonumber(command);
		if(extraActionIndex == nil) then
			local extraActionManager = Kitty.ExtraActionManager();
			-- スキル名指定
			extraActionManager:use(command);
		else
			-- インデックス指定
			Kitty.ExtraActionManager.useByIndex(extraActionIndex);
		end
	elseif(commandType == "macro") then
		-- マクロ
		local totalEstimatedPeriod = self.macroManager:execute(command);
		if(totalEstimatedPeriod == nil) then
			Kitty.sendMessage(Kitty.format("This macro cannot be executed. MacroName:[<<1>>]", tostring(command)), "DEFAULT", 1, 0, 0);
		else
			-- Cooldown設定
			self.cooldownManager:onCast(command, totalEstimatedPeriod + 0.5);
		end
	elseif(commandType == "emote") then
		-- エモーション
		local emotionManager = Kitty.EmotionManager();
		emotionManager:doEmote(command);
		-- Cooldown設定
		self.cooldownManager:onCast(command, 0.5);
	elseif(commandType == "proc") then
		-- プロシージャ
		-- プロシージャは直接実行されない
		error("Error. Invalid argument. CommandType:[" .. tostring(commandType) .. "], Proc:[" .. tostring(command) .. "]");
	elseif(commandType == "break") then
		-- ストッパー
		if(command ~= nil and command ~= "") then
			SendSystemMsg(Kitty.ComboManager.formatMessage(command));
		end
	elseif(commandType == "debug") then
		-- デバッグメッセージ
		if(command ~= nil and command ~= "") then
			SendSystemMsg(Kitty.ComboManager.formatMessage(command));
		end
	end
end;

-- コンストラクタ
Kitty.ComboManager.constructor = function(self, slotManager, cooldownManager, macroManager)
	-- データメンバ
	local obj = {};
	-- スロット管理クラス
	obj.slotManager = slotManager;
	-- クールダウン管理クラス
	obj.cooldownManager = cooldownManager;
	-- バフ情報管理クラス
	obj.targetBuffManager = Kitty.BuffManager();
	obj.targetBuffManager:update("target");
	obj.playerBuffManager = Kitty.BuffManager();
	obj.playerBuffManager:update("player");
	-- スキル管理クラス
	obj.skillManager = Kitty.SkillManager(cooldownManager);
	obj.skillManager:update();
	-- マクロ管理クラス
	obj.macroManager = macroManager;

	return setmetatable(obj, {__index=Kitty.ComboManager});
end;
setmetatable(Kitty.ComboManager, {__call=Kitty.ComboManager.constructor});	-- コンストラクタを指定

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--[[
Kitty.ComboManager.commandList.[build].[Standard/Enhanced].vs[All/PC/PCCaster]

Kitty.ComboManager.commandList = {};
Kitty.ComboManager.commandList.WK = {};
Kitty.ComboManager.commandList.WK.vsAll = {};
Kitty.ComboManager.commandList.RS = {};
Kitty.ComboManager.commandList.RS.vsAll = {};
Kitty.ComboManager.commandList.RS.vsPC = {};
Kitty.ComboManager.commandList.RS.vsCaster = {
	{["skill"]="ウーンドアタック", ["playerBuff"]={"出血", ["流血"]=20.0}, ["playerEnergy"]={50, 100}},
};

skill				-- Skill名
playerEffect[]		-- PlayerのBuff/Debuff(どれかあるなら)
playerNonEffect[]	-- PlayerのBuff/Debuff(どれもなければ)
targetEffect[]		-- TargetのBuff/Debuff(どれかあるなら)
targetNonEffect[]	-- TargetのBuff/Debuff(どれもなければ)
playerHealth[]		-- PlayerのHP(単位は%)[min ～ max]
playerMana[]		-- Playerのマナ(単位は値)[min ～ max]
playerTension[]		-- Playerのテンション(単位は値)[min ～ max]
playerFocus[]		-- Playerのフォーカス(スカウトSP、単位は値)[min ～ max]
playerEnergy[]		-- Playerのエネルギー(ローグSP、単位は値)[min ～ max]
targetHealth[]
playerName[]
targetName[]
playerIsFearless
targetIsFearless
playerClass
targetClass
targetIsPC
targetIsCaster
targetIsBoss
isCombat
isCG
isTargeted
canCast
isTwoHanded
isShield
inRange
isRequest
func				-- 判定関数
note				-- "MPが50以上のときのみ"などのヘルプ
--]]
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
