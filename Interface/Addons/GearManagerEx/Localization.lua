------------------------------------------------------------
-- Localization.lua
--
-- Abin
-- 2009-6-10
------------------------------------------------------------

-- Default(English)
GEARMANAGEREX_LOCALE = {
	["wear set"] = "Wear set",
	["save set"] = "Save set",
	["rename set"] = "Rename set",
	["delete set"] = "Delete set",
	["put into bank"] = "Put into bank",
	["take from bank"] = "Take from bank",
	["wore set"] = "Current equipped set: |cff00ff00%s|r.",
	["quick strip"] = "Quick strip",
	["too fast"] = "You strip/wear too fast, please wait a second to avoid errors.",
	["wore back"] = "Wore back |cff00ff00%d|r items.",
	["stripped off"] = "Stripped off |cff00ff00%d|r items.",
	["tooltip prompt"] = "<Right-click for advanced set options>",
	["set saved"] = "Set |cff00ff00%s|r saved.",
	["bind to"] = "Bind to ",
	["open"] = "Open ",
	["set hotkey"] = "Set Hotkey",
	["name exists"] = "Set name |cff00ff00%s|r already exists, please type a new name.",
	["set renamed"] = "Set |cff00ff00%s|r has been renamed to |cff00ff00%s|r.",
	["label text"] = "Rename set |cff00ff00%s|r to:",
}

if (GetLocale() == "zhCN") then

	GEARMANAGEREX_LOCALE = {
		["wear set"] = "穿上套装",
		["save set"] = "保存套装",
		["rename set"] = "重命名套装",
		["delete set"] = "删除套装",
		["put into bank"] = "放入银行",
		["take from bank"] = "从银行取出",
		["wore set"] = "当前装备的套装为 |cff00ff00%s|r。",
		["quick strip"] = "一键脱光",
		["too fast"] = "你进行脱光/穿回动作过于快速，请稍候片刻以防出错。",
		["wore back"] = "已穿回 |cff00ff00%d|r 件装备。",
		["stripped off"] = "已脱下 |cff00ff00%d|r 件装备。",
		["tooltip prompt"] = "<点击右键进行套装高级选项>",
		["set saved"] = "套装 |cff00ff00%s|r 已保存。",
		["bind to"] = "绑定于",
		["open"] = "打开",
		["set hotkey"] = "套装快捷键",
		["name exists"] = "套装名称 |cff00ff00%s|r 已存在，请输入一个新名称。",
		["set renamed"] = "套装 |cff00ff00%s|r 已被重命名为 |cff00ff00%s|r。",
		["label text"] = "将套装 |cff00ff00%s|r 重命名为：",
	}

elseif (GetLocale() == "zhTW") then

	GEARMANAGEREX_LOCALE = {
		["wear set"] = "穿上套裝",
		["save set"] = "保存套裝",
		["rename set"] = "重命名套裝",
		["delete set"] = "刪除套裝",
		["put into bank"] = "放入銀行",
		["take from bank"] = "從銀行取出",
		["wore set"] = "當前裝備的套裝為 |cff00ff00%s|r。",
		["quick strip"] = "一鍵脫光",
		["too fast"] = "你進行脫光/穿回動作過于快速，請稍候片刻以防出錯。",
		["wore back"] = "已穿回 |cff00ff00%d|r 件裝備。",
		["stripped off"] = "已脫下 |cff00ff00%d|r 件裝備。",
		["tooltip prompt"] = "<點擊右鍵進行套裝高級選項>",
		["set saved"] = "套裝 |cff00ff00%s|r 已保存。",
		["bind to"] = "綁定於",
		["open"] = "打開",
		["set hotkey"] = "套裝快捷鍵",
		["name exists"] = "套裝名稱 |cff00ff00%s|r 已存在，請輸入一個新名稱。",
		["set renamed"] = "套裝 |cff00ff00%s|r 已被重命名為 |cff00ff00%s|r。",
		["label text"] = "將套裝 |cff00ff00%s|r 重命名為：",
	}
end