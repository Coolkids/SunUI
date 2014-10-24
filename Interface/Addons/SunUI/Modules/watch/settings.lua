local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local

local FG = S:NewModule("Filger", "AceEvent-3.0", "AceHook-3.0", "AceConsole-3.0")
FG.modName = "ººƒ‹º‡ ”"

FG["filger_settings"] = {
	config_mode = false,
	max_test_icon = 5,
	show_tooltip = true,
}

FG["filger_position"] = {
	player_buff_icon = {"BOTTOM", UIParent, "BOTTOM", -274, 255},	-- "P_BUFF_ICON"
	player_proc_icon = {"BOTTOM", UIParent, "BOTTOM", -274, 300},	-- "P_PROC_ICON"
	special_proc_icon = {"TOP", UIParent, "TOP", 200, -203},	-- "SPECIAL_P_BUFF_ICON"
	target_debuff_icon = {"BOTTOM", UIParent, "BOTTOM", 75, 220},	-- "T_DEBUFF_ICON"
	target_buff_icon = {"BOTTOM", UIParent, "BOTTOM", 75, 280},	-- "T_BUFF"
	pve_debuff = {"TOP", UIParent, "TOP", 200, -249},			-- "PVE/PVP_DEBUFF"
	pve_cc = {"TOP", UIParent, "TOP", 200, -203},				-- "PVE/PVP_CC"
	cooldown = {"BOTTOM", UIParent, "BOTTOM", -274, 290},		-- "COOLDOWN"
	target_bar = {"BOTTOM", UIParent, "BOTTOM", 75, 220},	-- "T_DE/BUFF_BAR"
}