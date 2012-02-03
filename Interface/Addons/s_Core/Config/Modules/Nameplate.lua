-- Engines
local S, C, L, DB = unpack(select(2, ...))
local Core = LibStub("AceAddon-3.0"):GetAddon("Core")

-- Init
DB["Modules"]["Nameplate"] = {}
local Module = DB["Modules"]["Nameplate"]

-- LoadSettings
function Module.LoadSettings()
	local Default = {
		["Fontsize"] = 10,						-- 姓名板字体大小
		["HPHeight"] = 6,						-- 姓名板血条高度
		["HPWidth"] = 120,						-- 姓名板血条宽度
		["CastBarIconSize"] = 20,				-- 姓名板施法条图标大小
		["CastBarHeight"] = 5,					-- 姓名板施法条高度
		["CastBarWidth"] = 120,					-- 姓名板施法条宽度
	}
	if not NameplateDB then NameplateDB = {} end
	for key, value in pairs(Default) do
		if NameplateDB[key] == nil then NameplateDB[key] = value end
	end
	wipe(Default)
end

-- ResetToDefault
function Module.ResetToDefault()
	wipe(NameplateDB)
end

-- BuildGUI
function Module.BuildGUI()
	if DB["Config"] then
		DB["Config"]["Nameplate"] =  {
			type = "group", order = 2,
			name = L["姓名板"],
			args = {
				Fontsize = {
					type = "input",
					name = L["姓名板字体大小"] ,
					desc = L["姓名板字体大小"] ,
					order = 1,
					get = function() return tostring(NameplateDB.Fontsize) end,
					set = function(_, value) NameplateDB.Fontsize = tonumber(value) end,
				},
				HPHeight = {
					type = "input",
					name = L["姓名板血条高度"],
					desc = L["姓名板血条高度"] ,
					order = 2,
					get = function() return tostring(NameplateDB.HPHeight) end,
					set = function(_, value) NameplateDB.HPHeight = tonumber(value) end,
				},
				HPWidth = {
					type = "input",
					name = L["姓名板血条宽度"],
					desc = L["姓名板血条宽度"],
					order = 3,
					get = function() return tostring(NameplateDB.HPWidth) end,
					set = function(_, value) NameplateDB.HPWidth = tonumber(value) end,
				},
				CastBarIconSize = {
					type = "input",
					name = L["姓名板施法条图标大小"],
					desc = L["姓名板施法条图标大小"],
					order = 4,
					get = function() return tostring(NameplateDB.CastBarIconSize) end,
					set = function(_, value) NameplateDB.CastBarIconSize = tonumber(value) end,
				},
				CastBarHeight = {
					type = "input",
					name = L["姓名板施法条高度"],
					desc = L["姓名板施法条高度"],
					order = 5,
					get = function() return tostring(NameplateDB.CastBarHeight) end,
					set = function(_, value) NameplateDB.CastBarHeight = tonumber(value) end,
				},
				CastBarWidth = {
					type = "input",
					name = L["姓名板施法条宽度"],
					desc = L["姓名板施法条宽度"],
					order = 6,
					get = function() return tostring(NameplateDB.CastBarWidth) end,
					set = function(_, value) NameplateDB.CastBarWidth = tonumber(value) end,
				},
			}
		}
	end
end





