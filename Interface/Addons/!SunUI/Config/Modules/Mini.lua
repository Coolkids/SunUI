-- Engines
local S, C, L, DB = unpack(select(2, ...))
local Core = LibStub("AceAddon-3.0"):GetAddon("Core")

-- Init
DB["Modules"]["Mini"] = {}
local Module = DB["Modules"]["Mini"]
local ui = SetUIScale()
-- LoadSettings
function Module.LoadSettings()
	local Default = {
	["ClassCDWidth"] = 80,
	["AutoSell"] = true,
	["uiScale"] = ui,
	["AutoRepair"] = false,
	["Icicle"] = false,
	["MiniMapPanels"] = true,
	["UIscale"] = true,
	["igonoreOld"] = false,
	["FastError"] = true,
	["FontScale"] = 1,
	["LockUIscale"] = false,
	["Flump"] = false,
	["Autoinvite"] = false,
	["Interrupt"] = true,
	["INVITE_WORD"] = "SunUI",
	["BagScale"] = 1,
	["ClassCDOpen"] = true,
	["ClassFontSize"] = 12,
	["ClassCDHeight"] = 8,
	["AutoUIscale"] = false,
	["ChatFilter"] = true,
	["ClassCDDirection"] = 1,
	["HideRaid"] = true,
	["HideRaidWarn"] = true,
	["Disenchat"] = true,
	}
	if not MiniDB then MiniDB = {} end
	for key, value in pairs(Default) do
		if MiniDB[key] == nil then MiniDB[key] = value end
	end
	wipe(Default)
end

-- ResetToDefault
function Module.ResetToDefault()
	wipe(MiniDB)
end

-- BuildGUI
function Module.BuildGUI()
	if DB["Config"] then
		DB["Config"]["Mini"] =  {
			type = "group", order = 11,
			name = L["小东西设置"],
			args = {
				AutoSell = {
					type = "toggle",
					name = L["启用出售垃圾"],
					order = 1,
					get = function() return MiniDB.AutoSell end,
					set = function(_, value) MiniDB.AutoSell = value end,
				},
				AutoRepair = {
					type = "toggle",
					name = L["启用自动修理"],
					order = 2,
					get = function() return MiniDB.AutoRepair end,
					set = function(_, value) MiniDB.AutoRepair = value end,
				},
				ChatFilter = {
					type = "toggle",
					name = L["启用聊天信息过滤"],
					order = 3,
					get = function() return MiniDB.ChatFilter end,
					set = function(_, value) MiniDB.ChatFilter = value end,
				},
				FastError = {
					type = "toggle",
					name = L["启用系统红字屏蔽"],
					order = 4,
					get = function() return MiniDB.FastError end,
					set = function(_, value) MiniDB.FastError = value end,
				},
				Interrupt = {
					type = "toggle",
					name = L["启用打断通报"],
					order = 5,
					get = function() return MiniDB.Interrupt end,
					set = function(_, value) MiniDB.Interrupt = value end,
				},
				Icicle = {
					type = "toggle",
					name = L["PVP冷却计时"], desc = L["警告"],
					order = 6,
					get = function() return MiniDB.Icicle end,
					set = function(_, value) 
						StaticPopupDialogs["alarm"] = {
							text = L["警告"],
							button1 = OKAY,
							OnAccept = function()
							end,
							timeout = 0,
							hideOnEscape = 1,
						}
						StaticPopup_Show("alarm")
						MiniDB.Icicle = value end,
				},
				MiniMapPanels = {
					type = "toggle",
					name = L["启用团队工具"], desc = L["需要团长或者助理权限"],
					order = 8,
					get = function() return MiniDB.MiniMapPanels end,
					set = function(_, value) MiniDB.MiniMapPanels = value end,
				},
				Autoinvite = {
					type = "toggle",
					name = L["启用自动邀请"],
					order = 9,
					get = function() return MiniDB.Autoinvite end,
					set = function(_, value) MiniDB.Autoinvite = value end,
				},
				INVITE_WORD = {
					type = "input",
					name = L["自动邀请关键字"],
					desc = L["自动邀请关键字"],
					disabled = not MiniDB.Autoinvite,
					order = 10,
					get = function() return tostring(MiniDB.INVITE_WORD) end,
					set = function(_, value) MiniDB.INVITE_WORD = tonumber(value) end,
				},
				igonoreOld = {
					type = "toggle",
					name = L["启用自动离开有进度的随机副本或团队"],
					order = 11,
					get = function() return MiniDB.igonoreOld end,
					set = function(_, value) MiniDB.igonoreOld = value end,
				},
				HideRaid = {
					type = "toggle",
					name = "隐藏Blz团队框架",
					order = 12,
					get = function() return MiniDB.HideRaid end,
					set = function(_, value) MiniDB.HideRaid = value end,
				},
				HideRaidWarn = {
					type = "toggle",
					name = L["隐藏团队警告"],
					order = 13,
					get = function() return MiniDB.HideRaidWarn end,
					set = function(_, value) MiniDB.HideRaidWarn = value end,
				},
				Disenchat = {
					type = "toggle",
					name = "Quick Disenchat",
					order = 14,
					get = function() return MiniDB.Disenchat end,
					set = function(_, value) MiniDB.Disenchat = value end,
				},
				BagScale = {
					type = "range",
					name = "背包缩放大小",
					order = 15,
					min = 0.2, max = 2, step = 0.1,
					get = function() return MiniDB.BagScale end,
					set = function(_, value) MiniDB.BagScale = value end,
				},
			}
		}
			DB["Config"]["UI"] =  {
			type = "group", order = 12,
			name = L["UI缩放"],
			args = {
				uiScale = {
					type = "input", order = 1,
					name = L["UI缩放大小"], desc = L["UI缩放大小"],
					get = function() return tostring(GetCVar("uiScale")) end,
					set = function(_, value) MiniDB.uiScale = tostring(value) end,
				},
				accept = {
					type = "execute", order = 2,
					name = L["应用"], desc = L["应用"],
					func = function()  SetCVar("useUiScale", 1) SetCVar("uiScale", MiniDB.uiScale) RestartGx()end,
				},	
				NewLine = {
					type = "description", order = 3,
					name = "\n",					
				},
				NewLine = {
					type = "description", order = 7,
					name = "\n",					
				},
				FontScale = {
					type = "range", order = 8,
					name = L["全局字体大小"], desc = L["全局字体大小"],
					min = 0.20, max = 2.50, step = 0.01,
					get = function() return MiniDB.FontScale end,
					set = function(_, value) MiniDB.FontScale = value end,
				},				
			}
		}
		DB["Config"]["ClassCD"] =  {
			type = "group", order = 13,
			name = L["内置CD"],
			args = {
				ClassCDOpen = {
					type = "toggle",
					name = L["启动内置CD"], desc = L["警告"],
					order = 1,
					get = function() return MiniDB.ClassCDOpen end,
					set = function(_, value) 
						StaticPopupDialogs["alarm"] = {
							text = L["警告"],
							button1 = OKAY,
							OnAccept = function()
							end,
							timeout = 0,
							hideOnEscape = 1,
						}
						StaticPopup_Show("alarm")
						MiniDB.ClassCDOpen = value end,
				},
				group = {
					type = "group", order = 2,
					name = " ",guiInline = true,
					disabled = not MiniDB.ClassCDOpen,
					args = {
						ClassFontSize = {
							type = "range", order = 3,
							name = L["内置CD字体大小"], desc = L["内置CD字体大小"],
							min = 4, max = 28, step = 1,
							get = function() return MiniDB.ClassFontSize end,
							set = function(_, value) MiniDB.ClassFontSize = value end,
						},
						ClassCDWidth = {
							type = "input",
							name = L["框体宽度"],
							desc = L["框体宽度"],
							order = 4,
							get = function() return tostring(MiniDB.ClassCDWidth) end,
							set = function(_, value) MiniDB.ClassCDWidth = tonumber(value) end,
						},
						ClassCDHeight = {
							type = "input",
							name = L["框体高度"],
							desc = L["框体高度"],
							order = 5,
							get = function() return tostring(MiniDB.ClassCDHeight) end,
							set = function(_, value) MiniDB.ClassCDHeight = tonumber(value) end,
						},
						ClassCDDirection = {
							type = "select",
							name = L["计时条增长方向"],
							desc = L["计时条增长方向"],
							order = 6,
							values = {[1] = L["向下"], [2] = L["向上"]},
							get = function() return MiniDB.ClassCDDirection end,
							set = function(_, value) MiniDB.ClassCDDirection = value end,
						},
					}		
				},
			}
		}
		DB["Config"]["Script"] =  {
			type = "group", order = 14,
			name = "SunUI Script",
			args = {
				Flump = {
					type = "toggle",
					name = L["启用施法通告"],
					order = 1,
					get = function() return MiniDB.Flump end,
					set = function(_, value) MiniDB.Flump = value end,
				},
			}
		}
	end
end

