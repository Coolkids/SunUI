-- Engines
local S, C, L, DB = unpack(select(2, ...))
local Core = LibStub("AceAddon-3.0"):GetAddon("Core")

-- Init
DB["Modules"]["Buff"] = {}
local Module = DB["Modules"]["Buff"]

-- LoadSettings
function Module.LoadSettings()
	local Default = {
		["IconSize"] = 36,
		["BuffDirection"] = 1,
		["DebuffDirection"] = 1,
		["IconPerRow"] = 16,
	}
	if not BuffDB then BuffDB = {} end
	for key, value in pairs(Default) do
		if BuffDB[key] == nil then BuffDB[key] = value end
	end
	wipe(Default)
end

-- ResetToDefault
function Module.ResetToDefault()
	wipe(BuffDB)
end

-- BuildGUI
function Module.BuildGUI()
	if DB["Config"] then
		DB["Config"]["Buff"] =  {
			type = "group", order = 4,
			name = L["增益效果"],
			args = {
				IconSize = {
					type = "input",
					name = L["图标大小"],
					desc = L["图标大小"],
					order = 1,
					get = function() return tostring(BuffDB.IconSize) end,
					set = function(_, value) BuffDB.IconSize = tonumber(value) end,
				},
				IconPerRow = {
					type = "input",
					name = L["每行图标数"],
					desc = L["每行图标数"],
					order = 2,
					get = function() return tostring(BuffDB.IconPerRow) end,
					set = function(_, value) BuffDB.IconPerRow = tonumber(value) end,
				},
				BuffDirection = {
					type = "select",
					name = L["BUFF增长方向"],
					desc = L["BUFF增长方向"],
					order = 3,
					values = {[1] = L["从右向左"], [2] = L["从左向右"]},
					get = function() return BuffDB.BuffDirection end,
					set = function(_, value) BuffDB.BuffDirection = value end,
				},
				DebuffDirection = {
					type = "select",
					name = L["DEBUFF增长方向"],
					desc = L["DEBUFF增长方向"],
					order = 4,
					values = {[1] = L["从右向左"], [2] = L["从左向右"]},
					get = function() return BuffDB.DebuffDirection end,
					set = function(_, value) BuffDB.DebuffDirection = value end,
				},
			},
		}
	end
end





