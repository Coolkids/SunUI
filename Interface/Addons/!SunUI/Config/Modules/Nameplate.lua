-- Engines
local S, C, L, DB = unpack(select(2, ...))
local Core = LibStub("AceAddon-3.0"):GetAddon("Core")

-- Init
DB["Modules"]["Nameplate"] = {}
local Module = DB["Modules"]["Nameplate"]

-- LoadSettings
function Module.LoadSettings()
	local Default = {
		["enable"] = true,
		["Fontsize"] = 10,						-- 姓名板字体大小
		["HPHeight"] = 10,						-- 姓名板血条高度
		["HPWidth"] = 130,						-- 姓名板血条宽度
		["CastBarIconSize"] = 23,				-- 姓名板施法条图标大小
		["CastBarHeight"] = 8,					-- 姓名板施法条高度
		["CastBarWidth"] = 130,					-- 姓名板施法条宽度
		["Combat"] = true,   --战斗自动显示
		["Showdebuff"] = true,   --debuff显示
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
				group1 = {
						type = "group", order = 1,
						name = " ",guiInline = true,
						args = {
					enable = {
						type = "toggle",
						name = L["启用姓名板"],
						order = 1,
						get = function() return NameplateDB.enable end,
						set = function(_, value) NameplateDB.enable = value end,
						},
					}
				},
				group2 = {
						type = "group", order = 2,
						name = " ",guiInline = true,disabled = not NameplateDB.enable,
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
					Combat = {
						type = "toggle",
						name = L["启用战斗显示"],
						order = 7,
						get = function() return NameplateDB.Combat end,
						set = function(_, value) NameplateDB.Combat = value end,
					},
					Showdebuff = {
						type = "toggle",
						name = L["启用debuff显示"],
						order = 8,
						get = function() return NameplateDB.Showdebuff end,
						set = function(_, value) NameplateDB.Showdebuff = value end,
					},
			}
		},
	}
}
	end
end





