local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local

local FG = S:NewModule("Filger", "AceEvent-3.0", "AceHook-3.0", "AceConsole-3.0")
FG.modName = "技能监视"
FG.order = 23
function FG:GetOptions()
	local options = {
		Enable = {
			type = "toggle",
			name = L["启用"],
			order = 1,
		},
		ShowTooltip = {
			type = "toggle",
			name = L["鼠标提示"],
			order = 2,
		},
	}
	return options
end

FG["filger_settings"] = {
	config_mode = false,
	max_test_icon = 5,
}

FG["filger_position"] = {
	targetdebuff = {"BOTTOM", UIParent, "BOTTOM",  227,  335},	-- "目标debuff"
	playerbuff   = {"BOTTOM", UIParent, "BOTTOM", -227,  335},	-- "玩家buff
	playercd     = {"BOTTOM", UIParent, "BOTTOM", -227,  405},	-- "玩家技能CD"
	enbuff       = {"BOTTOM", UIParent, "BOTTOM", -227,  370},	-- "玩家饰品附魔触发buff"
	alldebuff    = {"TOP",    UIParent, "TOP",     200, -157},	-- "玩家Debuff"
	imbuff       = {"TOP",    UIParent, "TOP",     200, -203},	-- "玩家重要Buff"
	pvpdebuff    = {"TOP",    UIParent, "TOP",     200, -249},	-- "玩家PVPDebuff"
}

function FG:Info()
	return "\n\n此模块使用ShestakUI_Filger的代码做可移动化处理\n\n解锁方法:在控制台中解锁  选择技能监视  即可移动\n\n添加新的技能 请修改文件: SunUI\\modules\\watch\\spells.lua\n\n方法参考:  http://bbs.ngacn.cc/read.php?tid=5002683&_ff=200&_ff=200  \n\n如果实在无法自己添加可以加入QQ群: 180175370 获取帮助"
end
