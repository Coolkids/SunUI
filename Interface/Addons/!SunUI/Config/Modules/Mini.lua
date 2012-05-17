-- Engines
local S, C, L, DB = unpack(select(2, ...))
local Core = LibStub("AceAddon-3.0"):GetAddon("Core")
local mage, rogue= {}, {}
if DB.zone == "zhCN" then 
		mage = {
			[1] = "传送符文",
			[2] = "传送门符文",
			[3] = "魔粉", 
		}
		rogue = {
			[1] = "速效药膏",
			[2] = "致命药膏",
			[3] = "减速药膏",
			[4] = "麻痹药膏",
			[5] = "致伤药膏",
		}
	else
		mage = {
			[1] = "傳送符文",
			[2] = "傳送門符文",
			[3] = "魔粉", 
		}
		rogue = {
			[1] = "速效毒藥",
			[2] = "致命毒藥",
			[3] = "致殘毒藥",
			[4] = "麻痺毒藥",
			[5] = "致傷毒藥",
		}
end

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
	["ClassCDOpen"] = true,
	["ClassFontSize"] = 12,
	["ClassCDHeight"] = 8,
	["AutoUIscale"] = false,
	["ChatFilter"] = true,
	["ClassCDDirection"] = 1,
	["HideRaid"] = true,
	["HideRaidWarn"] = true,
	["Disenchat"] = true,
	["AutoBotton"] = true,
	["BloodShield"] = false,
	["RaidCD"] = false,
	["RaidCDWidth"] = 100,
	["RaidCDHeight"] = 8,
	["RaidCDDirection"] = 1,
	["RaidCDFontSize"] = 12,
	["AutoBuy"] = true,
	["mageone"] = 20,
	["magetwo"] = 20,
	["magethree"] = 100,
	["rogueone"] = 20,
	["roguetwo"] = 20,
	["roguethree"] = 20,
	["roguefour"] = 20,
	["roguefive"] = 20,
	["Resurrect"] = true,
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
					name = "Hide Blz RAID Frame",
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
				Resurrect = {
					type = "toggle",
					name = "Auto AcceptResurrect",
					order = 15,
					get = function() return MiniDB.Resurrect end,
					set = function(_, value) MiniDB.Resurrect = value end,
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
					get = function() return tostring(MiniDB.uiScale) end,
					set = function(_, value) MiniDB.uiScale = tonumber(value) end,
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
				AutoBotton = {
					type = "toggle",
					name = L["打开任务物品按钮"],
					order = 2,
					get = function() return MiniDB.AutoBotton end,
					set = function(_, value) MiniDB.AutoBotton = value end,
				},
				BloodShield = {
					type = "toggle",
					name = L["打开坦克护盾监视"],
					order = 3,
					get = function() return MiniDB.BloodShield end,
					set = function(_, value) MiniDB.BloodShield = value end,
				},
			}
		}
		DB["Config"]["RaidCD"] =  {
			type = "group", order = 17,
			name = "RaidCD",
			args = {
				RaidCD = {
					type = "toggle",
					name = L["打开团队技能CD监视"],
					order = 1,
					get = function() return MiniDB.RaidCD end,
					set = function(_, value) MiniDB.RaidCD = value end,
				},
				group = {
					type = "group", order = 2,
					name = " ",guiInline = true,
					disabled = not MiniDB.RaidCD,
					args = {
						RaidCDFontSize = {
							type = "range", order = 1,
							name = L["字体大小"], desc = L["字体大小"],
							min = 4, max = 28, step = 1,
							get = function() return MiniDB.RaidCDFontSize end,
							set = function(_, value) MiniDB.RaidCDFontSize = value end,
						},
						RaidCDWidth = {
							type = "input",
							name = L["框体宽度"],
							desc = L["框体宽度"],
							order = 2,
							get = function() return tostring(MiniDB.RaidCDWidth) end,
							set = function(_, value) MiniDB.RaidCDWidth = tonumber(value) end,
						},
						RaidCDHeight = {
							type = "input",
							name = L["框体高度"],
							desc = L["框体高度"],
							order = 3,
							get = function() return tostring(MiniDB.RaidCDHeight) end,
							set = function(_, value) MiniDB.RaidCDHeight = tonumber(value) end,
						},
						RaidCDDirection = {
							type = "select",
							name = L["计时条增长方向"],
							desc = L["计时条增长方向"],
							order = 4,
							values = {[1] = L["向下"], [2] = L["向上"]},
							get = function() return MiniDB.RaidCDDirection end,
							set = function(_, value) MiniDB.RaidCDDirection = value end,
						},
					}		
				},
			}
		}
		DB["Config"]["AutoBuy"] =  {
			type = "group", order = 18,
			name = "AutoBuy",
			args = {
				AutoBuy = {
					type = "toggle",
					name = L["打开自动补购"],
					order = 1,
					get = function() return MiniDB.AutoBuy end,
					set = function(_, value) MiniDB.AutoBuy = value end,
				},
				group = {
					type = "group", order = 2,
					name = " ",guiInline = true,
					disabled = not MiniDB.AutoBuy,
					args = {
						mageone = {
							type = "range", order = 1,
							name = mage[1], desc = mage[1],
							min = 0, max = 200, step = 1,
							get = function() return MiniDB.mageone end,
							set = function(_, value) MiniDB.mageone = value end,
						},
						magetwo = {
							type = "range", order = 2,
							name = mage[2], desc = mage[2],
							min = 0, max = 200, step = 1,
							get = function() return MiniDB.magetwo end,
							set = function(_, value) MiniDB.magetwo = value end,
						},
						magethree = {
							type = "range", order = 3,
							name = mage[3], desc = mage[3],
							min = 0, max = 1000, step = 1,
							get = function() return MiniDB.magethree end,
							set = function(_, value) MiniDB.magethree = value end,
						},
						rogueone = {
							type = "range", order = 4,
							name = rogue[1], desc = rogue[1],
							min = 0, max = 200, step = 1,
							get = function() return MiniDB.rogueone end,
							set = function(_, value) MiniDB.rogueone = value end,
						},
						roguetwo = {
							type = "range", order = 5,
							name = rogue[2], desc = rogue[2],
							min = 0, max = 200, step = 1,
							get = function() return MiniDB.roguetwo end,
							set = function(_, value) MiniDB.roguetwo = value end,
						},
						roguethree = {
							type = "range", order = 6,
							name = rogue[3], desc = rogue[3],
							min = 0, max = 200, step = 1,
							get = function() return MiniDB.roguethree end,
							set = function(_, value) MiniDB.roguethree = value end,
						},
						roguefour= {
							type = "range", order = 7,
							name = rogue[4], desc = rogue[4],
							min = 0, max = 200, step = 1,
							get = function() return MiniDB.roguefour end,
							set = function(_, value) MiniDB.roguefour = value end,
						},
						roguefive= {
							type = "range", order = 8,
							name = rogue[5], desc = rogue[5],
							min = 0, max = 200, step = 1,
							get = function() return MiniDB.roguefive end,
							set = function(_, value) MiniDB.roguefive = value end,
						},
					}		
				},
			}
		}
	end
end

