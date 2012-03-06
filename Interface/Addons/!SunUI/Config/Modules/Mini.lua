-- Engines
local S, C, L, DB = unpack(select(2, ...))
local Core = LibStub("AceAddon-3.0"):GetAddon("Core")

-- Init
DB["Modules"]["Mini"] = {}
local Module = DB["Modules"]["Mini"]

-- LoadSettings
function Module.LoadSettings()
	local Default = {
		["AutoSell"] = true,
		["AutoRepair"] = true,
		["ChatFilter"] = true,
		["FastError"] = true,
		["Interrupt"] = true,
		["Icicle"] = false,
		["MiniMapPanels"] = true,
		["HideRaid"] = true,
		["UIscale"] = false,
		["AutoUIscale"] = false,
		["LockUIscale"] = false,
		["Autoinvite"] = false,
		["INVITE_WORD"] = "SunUI",
		["igonoreOld"] = false,
		["uiScale"] = 0.69999998807907,
		["ClassCDOpen"] = false,
		["ClassCDDirection"] = 1,
		["ClassCDWidth"] = 140,
		["ClassCDHeight"] = 20,
		["ClassFontSize"] = 15,
		["FontScale"] = 0.8,
		["Flump"] = true,
		
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
			type = "group", order = 10,
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
			}
		}
			DB["Config"]["UI"] =  {
			type = "group", order = 11,
			name = L["UI缩放"],
			args = {
				uiScale = {
					type = "range", order = 1,
					name = L["UI缩放大小"], desc = L["UI缩放大小"],
					min = 0.40, max = 1.20, step = 0.01,
					get = function() return MiniDB.uiScale end,
					set = function(_, value) MiniDB.uiScale = value end,
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
				UIscale = {
					type = "toggle",
					name = L["启用插件UI缩放设定"],
					order = 4,
					get = function() return MiniDB.UIscale end,
					set = function(_, value) MiniDB.UIscale = value end,
				},
				AutoUIscale = {
					type = "toggle",
					name = L["自动设定UI缩放"], desc = L["需要开启插件UI缩放设定"],
					order = 5,
					disabled = not MiniDB.UIscale,
					get = function() return MiniDB.AutoUIscale end,
					set = function(_, value) MiniDB.AutoUIscale = value end,
				},
				LockUIscale = {
					type = "toggle",
					name = L["锁定UI缩放"], desc = L["需要开启插件UI缩放设定"],
					order = 6,
					disabled = not MiniDB.UIscale,
					get = function() return MiniDB.LockUIscale end,
					set = function(_, value) MiniDB.LockUIscale = value end,
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
			type = "group", order = 12,
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
			type = "group", order = 13,
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

