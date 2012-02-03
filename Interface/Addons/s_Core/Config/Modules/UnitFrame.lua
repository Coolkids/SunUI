-- Engines
local S, C, L, DB = unpack(select(2, ...))
local Core = LibStub("AceAddon-3.0"):GetAddon("Core")

-- Init
DB["Modules"]["UnitFrame"] = {}
local Module = DB["Modules"]["UnitFrame"]

-- LoadSettings
function Module.LoadSettings()
	local Default = {
		["FontSize"] = 10,
		["Width"] = 240,
		["Height"] = 25,
		["PowerHeight"] = 0.75,            
		["Bossframes"] = true,		--boss框体	
		["ClassColorbars"] = false,  --血条职业颜色
		["PowerColor"] = true,		--蓝条颜色
		["PowerClass"] = false,     --蓝条职业颜色
		["Portraits"] = false,		--头像
		["OnlyShowPlayer"] = false, -- only show player debuffs on target
		["Scale"] = 1,
		["PlayerCastBarHeight"] = 10,
		["PlayerCastBarWidth"] = 460,
		["TargetCastBarHeight"] = 10,
		["TargetCastBarWidth"] = 240,
		["FocusCastBarHeight"] = 10,
		["FocusCastBarWidth"] = 200,
		["PetCastBarHeight"] = 10,
		["PetCastBarWidth"] = 180,
		["Icon"] = 24,
	}
	if not UnitFrameDB then UnitFrameDB = {} end
	for key, value in pairs(Default) do
		if UnitFrameDB[key] == nil then UnitFrameDB[key] = value end
	end
	wipe(Default)
end

-- ResetToDefault
function Module.ResetToDefault()
	wipe(UnitFrameDB)
end

-- BuildGUI
function Module.BuildGUI()
	if DB["Config"] then
		DB["Config"]["UnitFrame"] =  {
			type = "group", order = 9,
			name = L["头像框体"],
			args = {
				group1 = {
					type = "group", order = 1,
					name = " ",guiInline = true,
					args = {
						Bossframes = {
							type = "toggle", order = 1,
							name = L["开启boss框体"],			
							get = function() return UnitFrameDB.Bossframes end,
							set = function(_, value) UnitFrameDB.Bossframes = value end,
						},
						ClassColorbars = {
							type = "toggle", order = 2,
							name = L["血条职业颜色"],			
							get = function() return UnitFrameDB.ClassColorbars end,
							set = function(_, value) UnitFrameDB.ClassColorbars = value end,
						},
						PowerColor = {
							type = "toggle", order = 3,
							name = L["蓝条颜色"],			
							get = function() return UnitFrameDB.PowerColor end,
							set = function(_, value) UnitFrameDB.PowerColor = value end,
						},
						PowerClass = {
							type = "toggle", order = 4,
							name = L["蓝条职业颜色"],			
							get = function() return UnitFrameDB.PowerClass end,
							set = function(_, value) UnitFrameDB.PowerClass = value end,
						},
						Portraits = {
							type = "toggle", order = 5,
							name = L["是否开启头像"],			
							get = function() return UnitFrameDB.Portraits end,
							set = function(_, value) UnitFrameDB.Portraits = value end,
						},
						OnlyShowPlayer = {
							type = "toggle", order = 6,
							name = L["是否只显示你释放的debuff"],			
							get = function() return UnitFrameDB.OnlyShowPlayer end,
							set = function(_, value) UnitFrameDB.OnlyShowPlayer = value end,
						},
					}
				},
				group2 = {
					type = "group", order = 2,
					name = " ",guiInline = true,
					args = {
						FontSize = {
							type = "range", order = 1,
							name = L["头像字体大小"], desc = L["法力条高度"],
							min = 8, max = 28, step = 1,
							get = function() return UnitFrameDB.FontSize end,
							set = function(_, value) UnitFrameDB.FontSize = value end,
						},
						--[[Width = {
							type = "input",
							name = "框体宽度：",
							desc = "请输入框体宽度",
							order = 2,
							get = function() return tostring(UnitFrameDB.Width) end,
							set = function(_, value) UnitFrameDB.Width = tonumber(value) end,
						},
						Height = {
							type = "input",
							name = "框体高度：",
							desc = "请输入框体高度",
							order = 3,
							get = function() return tostring(UnitFrameDB.Height) end,
							set = function(_, value) UnitFrameDB.Height = tonumber(value) end,
						},--]]
						PowerHeight = {
							type = "range", order = 2,
							name = L["法力条高度"], desc = L["法力条高度"],
							min = 0.7, max = 0.95, step = 0.01,
							get = function() return UnitFrameDB.PowerHeight end,
							set = function(_, value) UnitFrameDB.PowerHeight = value end,
						},
						
						Scale = {
							type = "range", order = 3,
							name = L["头像缩放大小"], desc = L["头像缩放大小"],
							min = 0.2, max = 2, step = 0.1,
							get = function() return UnitFrameDB.Scale end,
							set = function(_, value) UnitFrameDB.Scale = value end,
						},
					}
				},
				group3 = {
					type = "group", order = 3,
					name = " ",guiInline = true,
					args = {
						PlayerCastBarWidth = {
							type = "input",
							name = L["玩家施法条宽度"],
							desc = L["玩家施法条宽度"],
							order = 1,
							get = function() return tostring(UnitFrameDB.PlayerCastBarWidth) end,
							set = function(_, value) UnitFrameDB.PlayerCastBarWidth = tonumber(value) end,
						},
						PlayerCastBarHeight = {
							type = "input",
							name = L["玩家施法条高度"],
							desc = L["玩家施法条高度"],
							order = 2,
							get = function() return tostring(UnitFrameDB.PlayerCastBarHeight) end,
							set = function(_, value) UnitFrameDB.PlayerCastBarHeight = tonumber(value) end,
						},
						NewLine = {
							type = "description", order = 3,
							name = "\n",					
						},
						TargetCastBarWidth = {
							type = "input",
							name = L["目标施法条宽度"],
							desc = L["目标施法条宽度"],
							order = 4,
							get = function() return tostring(UnitFrameDB.TargetCastBarWidth) end,
							set = function(_, value) UnitFrameDB.TargetCastBarWidth = tonumber(value) end,
						},
						TargetCastBarHeight = {
							type = "input",
							name = L["目标施法条高度"],
							desc = L["目标施法条高度"],
							order = 5,
							get = function() return tostring(UnitFrameDB.TargetCastBarHeight) end,
							set = function(_, value) UnitFrameDB.TargetCastBarHeight = tonumber(value) end,
						},
						NewLine = {
							type = "description", order = 6,
							name = "\n",					
						},
						FocusCastBarWidth = {
							type = "input",
							name = L["焦点施法条宽度"],
							desc = L["焦点施法条宽度"],
							order = 7,
							get = function() return tostring(UnitFrameDB.FocusCastBarWidth) end,
							set = function(_, value) UnitFrameDB.FocusCastBarWidth = tonumber(value) end,
						},
						FocusCastBarHeight = {
							type = "input",
							name = L["焦点施法条高度"],
							desc = L["焦点施法条高度"],
							order = 8,
							get = function() return tostring(UnitFrameDB.TargetCastBarHeight) end,
							set = function(_, value) UnitFrameDB.TargetCastBarHeight = tonumber(value) end,
						},
						NewLine = {
							type = "description", order = 9,
							name = "\n",					
						},
						PetCastBarWidth = {
							type = "input",
							name = L["宠物施法条宽度"],
							desc = L["宠物施法条宽度"],
							order = 10,
							get = function() return tostring(UnitFrameDB.PetCastBarWidth) end,
							set = function(_, value) UnitFrameDB.PetCastBarWidth = tonumber(value) end,
						},
						PetCastBarHeight = {
							type = "input",
							name = L["宠物施法条高度"],
							desc = L["宠物施法条高度"],
							order = 11,
							get = function() return tostring(UnitFrameDB.PetCastBarHeight) end,
							set = function(_, value) UnitFrameDB.PetCastBarHeightt = tonumber(value) end,
						},
						NewLine = {
							type = "description", order = 12,
							name = "\n",					
						},
						Icon = {
							type = "range", order = 13,
							name = L["施法条图标大小"], desc = L["施法条图标大小"],
							min = 12, max = 64, step = 1,
							get = function() return UnitFrameDB.Icon end,
							set = function(_, value) UnitFrameDB.Icon = value end,
						},
					}
				},
			}
		}
	end
end