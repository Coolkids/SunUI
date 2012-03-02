-- Engines
local S, C, L, DB = unpack(select(2, ...))
local Core = LibStub("AceAddon-3.0"):GetAddon("Core")

-- Init
DB["Modules"]["ActionBar"] = {}
local Module = DB["Modules"]["ActionBar"]

-- LoadSettings
function Module.LoadSettings()
	local Default = {
		["HideHotKey"] = false,
		["HideMacroName"] = false,
		["CooldownFlash"] = true,
		["EnableBarFader"] = false,
		["CooldownFlashSize"] = 64,
		["Bar1Layout"] = 1,
		["Bar2Layout"] = 1,
		["Bar3Layout"] = 1,
		["Bar4Layout"] = 1,
		["Bar5Layout"] = 1,
		["ButtonSize"] = 34,
		["ButtonSpacing"] = 1,
		["FontSize"] = 11,
		["MFontSize"] = 10,
		["MainBarSacle"] = 1,
		["ExtraBarSacle"] = 1.5,
		["PetBarSacle"] = 0.7,
		["StanceBarSacle"] = 0.7,
		["TotemBarSacle"] = 1,
		["Big4Layout"] = 1,
		["Style"] = 1,
	}
	if not ActionBarDB then ActionBarDB = {} end
	for key, value in pairs(Default) do
		if ActionBarDB[key] == nil then ActionBarDB[key] = value end
	end
	wipe(Default)
end

-- ResetToDefault
function Module.ResetToDefault()
	wipe(ActionBarDB)
end

-- BuildGUI
function Module.BuildGUI()
	if DB["Config"] then
		DB["Config"]["ActionBar"] =  {
			type = "group", order = 1,
			name = L["动作条"],
			args = {
				group1 = {
					type = "group", order = 1,
					name = " ",guiInline = true,
					args = {
						Bar1Layout = {
							type = "select", order = 1,
							name = L["bar1布局"], desc = L["请选择主动作条布局"],
							values = {[1] = L["12x1布局"], [2] =L["6x2布局"]},
							get = function() return ActionBarDB.Bar1Layout end,
							set = function(_, value) ActionBarDB.Bar1Layout = value end,
						},
						Bar2Layout = {
							type = "select", order = 2,
							name = L["bar2布局"], desc = L["请选择主动作条布局"],
							values = {[1] = L["12x1布局"], [2] =L["6x2布局"]},
							get = function() return ActionBarDB.Bar2Layout end,
							set = function(_, value) ActionBarDB.Bar2Layout = value end,
						},
						Bar3Layout = {
							type = "select", order = 3,
							name = L["bar3布局"], desc = L["请选择主动作条布局"],
							values = {[1] = L["12x1布局"], [2] =L["6x2布局"]},
							get = function() return ActionBarDB.Bar3Layout end,
							set = function(_, value) ActionBarDB.Bar3Layout = value end,
						},	
						Bar4Layout = {
							type = "select", order = 4,
							name = L["bar4布局"], desc = L["请选择主动作条布局"],
							values = {[1] = L["12x1布局"], [2] =L["6x2布局"]},
							get = function() return ActionBarDB.Bar4Layout end,
							set = function(_, value) ActionBarDB.Bar4Layout = value end,
						},	
						Bar5Layout = {
							type = "select", order = 5,
							name = L["bar5布局"], desc = L["请选择主动作条布局"],disabled = (ActionBarDB.Big4Layout == 1),
							values = {[1] = "12x1布局", [2] = "6x2布局"},
							get = function() return ActionBarDB.Bar5Layout end,
							set = function(_, value) ActionBarDB.Bar5Layout = value end,
						},	
						Big4Layout = {
							type = "select", order = 6,
							name = L["4方块布局"], desc = L["请选择主动作条布局"],
							values = {[1] = L["4方块布局"],  [2] = L["不要4方块布局"] },
							get = function() return ActionBarDB.Big4Layout end,
							set = function(_, value) ActionBarDB.Big4Layout = value end,
						},
						Style = {
							type = "select", order = 7,
							name = L["动作条皮肤风格"], desc = L["请选择动作条皮肤风格"],
							values = {[1] = L["阴影风格"], [2] = L["框框风格"]},
							get = function() return ActionBarDB.Style end,
							set = function(_, value) ActionBarDB.Style = value end,
						},
					}
				},
				group2 = {
					type = "group", order = 2,
					name = " ",guiInline = true,
					args = {
						HideHotKey = {
							type = "toggle", order = 1,
							name = L["隐藏快捷键显示"],			
							get = function() return ActionBarDB.HideHotKey end,
							set = function(_, value) ActionBarDB.HideHotKey = value end,
						},
						HideMacroName = {
							type = "toggle", order = 2,
							name = L["隐藏宏名称显示"],		
							get = function() return ActionBarDB.HideMacroName end,
							set = function(_, value) ActionBarDB.HideMacroName = value end,
						},
						CooldownFlash = {
							type = "toggle", order = 3,
							name = L["冷却闪光"],		
							get = function() return ActionBarDB.CooldownFlash end,
							set = function(_, value) ActionBarDB.CooldownFlash = value end,
						},
						EnableBarFader = {
							type = "toggle", order = 4,
							name = "动作条渐隐",		
							get = function() return ActionBarDB.EnableBarFader end,
							set = function(_, value) ActionBarDB.EnableBarFader = value end,
						},
					}
				},
				group3 = {
					type = "group", order = 3,
					name = " ",guiInline = true,
					args = {
						ButtonSize = {
							type = "range", order = 1,
							name = L["动作条按钮大小"], desc = L["动作条按钮大小"],
							min = 16, max = 64, step = 1,
							get = function() return ActionBarDB.ButtonSize end,
							set = function(_, value) ActionBarDB.ButtonSize = value end,
						},
						ButtonSpacing = {
							type = "range", order = 2,
							name = L["动作条间距大小"], desc = L["动作条间距大小"],
							min = 0, max = 6, step = 1,
							get = function() return ActionBarDB.ButtonSpacing end,
							set = function(_, value) ActionBarDB.ButtonSpacing = value end,
						},
						FontSize = {
							type = "range", order = 3,
							name = L["动作条字体大小"], desc = L["动作条字体大小"],
							min = 1, max = 36, step = 1,
							get = function() return ActionBarDB.FontSize end,
							set = function(_, value) ActionBarDB.FontSize = value end,
						},
						MFontSize = {
							type = "range", order = 4,
							name = L["宏名字字体大小"], desc = L["宏名字字体大小"],
							min = 1, max = 36, step = 1,
							get = function() return ActionBarDB.MFontSize end,
							set = function(_, value) ActionBarDB.MFontSize = value end,
						},
						MainBarSacle = {
							type = "range", order = 5,
							name = L["主动作条缩放大小"], desc = L["主动作条缩放大小"],
							min = 0, max = 3, step = 0.1,
							get = function() return ActionBarDB.MainBarSacle end,
							set = function(_, value) ActionBarDB.MainBarSacle = value end,
						},
						ExtraBarSacle = {
							type = "range", order = 6,
							name = L["特殊按钮缩放大小"], desc = L["特殊按钮缩放大小"],
							min = 0, max = 3, step = 0.1,
							get = function() return ActionBarDB.ExtraBarSacle end,
							set = function(_, value) ActionBarDB.ExtraBarSacle = value end,
						},
						PetBarSacle = {
							type = "range", order = 7,
							name = L["宠物条缩放大小"], desc = L["宠物条缩放大小"],
							min = 0, max = 3, step = 0.1,
							get = function() return ActionBarDB.PetBarSacle end,
							set = function(_, value) ActionBarDB.PetBarSacle = value end,
						},
						StanceBarSacle = {
							type = "range", order = 8,
							name = L["姿态栏缩放大小"], desc = L["姿态栏缩放大小"],
							min = 0, max = 3, step = 0.1,
							get = function() return ActionBarDB.StanceBarSacle end,
							set = function(_, value) ActionBarDB.StanceBarSacle = value end,
						},
						TotemBarSacle = {
							type = "range", order = 9,
							name = L["图腾栏缩放大小"], desc = L["图腾栏缩放大小"],
							min = 0, max = 3, step = 0.1,
							get = function() return ActionBarDB.TotemBarSacle end,
							set = function(_, value) ActionBarDB.TotemBarSacle = value end,
						},
					}
				},
				group4 = {
					type = "group", order = 3,
					name = " ",guiInline = true, disabled = not ActionBarDB.CooldownFlash,
					args = {
						CooldownFlashSize = {
							type = "input",
							name = L["冷却闪光图标大小"],
							desc = L["冷却闪光图标大小"],
							order = 1,
							get = function() return tostring(ActionBarDB.CooldownFlashSize) end,
							set = function(_, value) ActionBarDB.CooldownFlashSize = tonumber(value) end,
						},
					}
				},
			}
		}
	end
end


