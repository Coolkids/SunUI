local S, C, L, DB = unpack(select(2, ...))
local SunUIConfig = LibStub("AceAddon-3.0"):GetAddon("Core"):NewModule("SunUIConfig", "AceConsole-3.0", "AceEvent-3.0")
local db = {}
local defaults
local DEFAULT_WIDTH = 800
local DEFAULT_HEIGHT = 500
local AC = LibStub("AceConfig-3.0")
local ACD = LibStub("AceConfigDialog-3.0")
local Version = 20120323
local beta = "0819A"
local aglin = false
function SunUIConfig:LoadDefaults()
	--Defaults
	defaults = {
		profile = {
			ActionBarDB = {
				["FontSize"] = 14,
				["MFontSize"] = 12,
				["PetBarSacle"] = 1,
				["ButtonSpacing"] = 4,
				["CooldownFlashSize"] = 48,
				["CooldownFlash"] = true,
				["BigSize1"] = 24,
				["TotemBarSacle"] = 1,
				["Bar3Layout"] = 2,
				["Bar5Layout"] = 1,
				["Bar2Layout"] = 1,
				["Big4Layout"] = 1,
				["ButtonSize"] = 24,
				["HideMacroName"] = false,
				["StanceBarSacle"] = 1,
				["Style"] = 1,
				["BigSize2"] = 24,
				["Bar4Layout"] = 1,
				["BigSize3"] = 52,
				["HideHotKey"] = false,
				["MainBarSacle"] = 1,
				["EnableBarFader"] = false,
				["Bar1Layout"] = 1,
				["BigSize4"] = 52,
				["ExtraBarSacle"] = 1.5,
			},
			NameplateDB = {
				["CastBarWidth"] = 110,
				["HPWidth"] = 110,
				["enable"] = true,
				["Showdebuff"] = true,
				["HPHeight"] = 6,
				["CastBarIconSize"] = 15,
				["Fontsize"] = 12,
				["CastBarHeight"] = 4,
				["Combat"] = true,
				["NotCombat"] = false,
			},
			TooltipDB = {
				["FontSize"] = 12,
				["HideInCombat"] = false,
				["Cursor"] = true,
				["HideTitles"] = true,
			},
			BuffDB = {
				["IconSize"] = 28,
				["BuffDirection"] = 1,
				["DebuffDirection"] = 1,
				["IconPerRow"] = 16,
				["FontSize"] = 13,
			},
			ThreatDB = {
				["ThreatBarWidth"] = 180,
				["NameTextL"] = 3,
				["ThreatLimited"] = 3,
			},
			ReminderDB = {
				["ShowRaidBuff"] = true,
				["ShowOnlyInParty"] = true,
				["RaidBuffDirection"] = 1,
				["RaidBuffSize"] = 15,
				["ClassBuffSize"] = 32,
				["ShowClassBuff"] = true,
			},
			SkinDB = {
				["EnableDBMSkin"] = true,
			},
			UnitFrameDB = {
				--大小
				["FontSize"] = 11,
				["Height"] = 20,
				["Width"] = 180,
				["Scale"] = 1,
				["PetHeight"] = 10,
				["PetWidth"] = 100,
				["PetScale"] = 0.9,
				["BossHeight"] = 15,
				["BossWidth"] = 140,
				["BossScale"] = 1,
				["Alpha3D"] = 0,
				["TargetAura"] = 1,
				["TargetRange"] = false,
				["RangeAlpha"] = 0.6,
				["BigFocus"] = true,
				["FocusDebuff"] = false,
				["ClassColor"] = false,
				["ReverseHPbars"] = false,
				["showarena"] = true,
				["showboss"] = true,
				["showfocus"] = true,
				["showpet"] = true,
				["showtot"] = true,
				["showparty"] = false,
				["EnableSwingTimer"] = false,
				["EnableBarFader"] = false,
				["Party3D"] = false,
				["PlayerBuff"] = 4,
				["CastBar"] = true,
				["targetCBuserplaced"] = false,
				["TargetCastBarHeight"] = 20,
				["TargetCastBarWidth"] = 300,
				["focusCBuserplaced"] = true,
				["FocusCastBarWidth"] = 100,
				["FocusCastBarHeight"] = 6,	
				["playerCBuserplaced"] = false,
				["PlayerCastBarWidth"] = 300,
				["PlayerCastBarHeight"] = 20,			
			},
			MiniDB = {
				--小东西设置
				["AutoRepair"] = false,
				["Icicle"] = false,
				["Autoinvite"] = false,
				["Disenchat"] = true,
				["HideRaidWarn"] = true,
				["Resurrect"] = false,
				["igonoreOld"] = false,
				["Interrupt"] = true,
				["HideRaid"] = true,
				["FastError"] = true,
				["MiniMapPanels"] = true,
				["INVITE_WORD"] = "SunUI",
				["ChatFilter"] = true,
				["IPhoneLock"] = true,
				["AutoQuest"] = true,
				["FatigueWarner"] = true,
				["DNDFilter"] = true,
				["TimeStamps"] = true,
				["AutoSell"] = true,
				--UI缩放
				["uiScale"] = 0.9,
				["FontScale"] = 1,
				--内置CD
				["ClassCDOpen"] = true,
				["ClassCDHeight"] = 8,
				["ClassCDWidth"] = 100,
				["ClassCDDirection"] = 1,
				["ClassFontSize"] = 12,
				["ClassCDIcon"] = false,
				["ClassCDIconSize"] = 25,
				["ClassCDIconDirection"] = 1,
				--SunUI扩展
				["Flump"] = false,
				["AutoBotton"] = true,
				["BloodShield"] = false,
				--Raid CD
				["RaidCD"] = true,
				["RaidCDFontSize"] = 12,
				["RaidCDWidth"] = 100,
				["RaidCDHeight"] = 8,
				["RaidCDDirection"] = 1,
				--AutoBuy
				["AutoBuy"] = true,
				["mageone"] = 20,
				["magetwo"] = 20,
				["magethree"] = 100,
				["rogueone"] = 20,
				["roguetwo"] = 20,
				["roguethree"] = 20,
				["roguefour"] = 20,
				["roguefive"] = 20,
			},
			InfoPanelDB = {
				["OpenTop"] = true,
				["OpenBottom"] = true,
				["Friend"] = false,
				["Guild"] = false,
			},
			MoveHandleDB = {
				--头像
				["PlayerFrame"] = {"BOTTOM", "UIParent", "BOTTOM", -175, 172},
				["TargetFrame"] = {"BOTTOM", "UIParent", "BOTTOM", 175, 172},
				["ToTFrame"] = {"BOTTOM", "UIParent", "BOTTOM", 0, 190},
				["PetFrame"] = {"TOPRIGHT", "oUF_SunUIPlayer", "TOPLEFT", -5, 0},
				["FocusFrame"] = {"RIGHT", "UIParent", "RIGHT", -57, -138},
				["PartyFrame"] = {"LEFT", "UIParent", "LEFT", 10, 0},
				["FocusTFrame"] = {"TOP", "oUF_SunUIFocus", "BOTTOM", 0, -30},
				["BossFrame"] = {"RIGHT", "UIParent", "RIGHT", -50, -60},
				["ArenaFrame"] = {"RIGHT", "UIParent", "RIGHT", -50, -60},
				--施法条
				["PlayerCastbar"] = {"CENTER", "UIParent", "CENTER", 0, -110},
				["TargetCastbar"] = {"CENTER", "UIParent", "CENTER", 0, 95},
				["FocusCastbar"] = {"TOP", "oUF_SunUIFocus", "BOTTOM", 0, -20},
				--动作条
				["bar1"] = {"BOTTOM", "UIParent", "BOTTOM", 0, 13},
				["bar2"] = {"BOTTOM", "SunUIActionBar1", "TOP", 0, 4},
				["bar3"] = {"BOTTOMRIGHT", "SunUIActionBar1", "BOTTOMLEFT", -4, 0},
				["bar32"] = {"BOTTOMLEFT", "SunUIActionBar1", "BOTTOMRIGHT", 4, 0},	
				["bar4"] = {"RIGHT", "UIParent", "RIGHT", -10, 0},
				["bar5"] = {"CENTER", "UIParent", "CENTER", 0, 0},
				["bar51"] = {"BOTTOM", "MultiBarBottomLeftButton4", "TOP", 0, 4},
				["bar52"] = {"BOTTOM", "MultiBarBottomLeftButton5", "TOP", 0, 4},
				["bar53"] = {"BOTTOMRIGHT", "MultiBarBottomRightButton3", "BOTTOMLEFT", -4, 0},
				["bar54"] = {"BOTTOMLEFT", "MultiBarBottomRightButton9", "BOTTOMRIGHT", 4, 0},
				["petbar"] = {"BOTTOMRIGHT", "MultiBarBottomRightButton12", "TOPRIGHT", 0, 4},
				["stancebar"] = {"BOTTOMLEFT", "MultiBarBottomRightButton6", "TOPLEFT", 0, 4},
				["totembar"] = {"BOTTOM", "UIParent", "BOTTOM", -175, 292},
				["vehicleexit"] = {"BOTTOM", "UIParent", "BOTTOM", 278, 66},
				["extrabar"] = {"BOTTOM", "UIParent", "BOTTOM", -194, 54},
				--Blz界面
				["Minimap"] = {"TOPLEFT", "UIParent", "TOPLEFT", 5, -5},
				["Buff"] = {"TOPRIGHT", "UIParent", "TOPRIGHT", -5, -5},
				["Debuff"] = {"TOPRIGHT", "UIParent", "TOPRIGHT", -5, -160},
				["RollFrame"] = {"TOP", "UIParent", "TOP", 0, -200},
				["Tooltip"] = {"BOTTOMRIGHT", "UIParent", "BOTTOMRIGHT", -50, 160},
				--插件增强
				["CooldownFlash"] = {"CENTER", "UIParent", "CENTER", 0, -130},
				["Class"] = {"CENTER", "UIParent", "CENTER", -150, 150},
				["Reminder"] = {"TOPLEFT", "Minimap", "BOTTOMLEFT", 0, -20},
				["ShadowPet"] = {"BOTTOM", "UIParent", "BOTTOM", -316, 201},	
				["Threat"] = {"BOTTOM", "UIParent", "BOTTOM", -175, 262},
				["ClassCD"] = {"LEFT", "UIParent", "LEFT", 30, 240},
				["RaidCD"] = {"LEFT", "UIParent", "LEFT", 30, 0},
				["AutoButton"] = {"RIGHT", "UIParent", "RIGHT", -270, 188},
				["BloodShield"] = {"BOTTOM", "UIParent", "BOTTOM", -285, 172},
				["InfoPanel"] = {"TOPLEFT", "Minimap", "TOPRIGHT", 5, 3},
				["healpriest"] = {"CENTER", "UIParent", "CENTER", 0, 135},
			},
		},
	}
end	

function SunUIConfig:OnInitialize()	
	self:Load()
	self.OnInitialize = nil
end

function SunUIConfig:ShowConfig() 
	ACD[ACD.OpenFrames.SunUIConfig and "Close" or "Open"](ACD,"SunUIConfig") 
end

function SunUIConfig:Load()
	self:LoadDefaults()

	-- Create savedvariables
	self.db = LibStub("AceDB-3.0"):New("SunUIConfig", defaults)
	self.db.RegisterCallback(self, "OnProfileChanged", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileCopied", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileReset", "OnProfileChanged")
	db = self.db.profile
	
	self:SetupOptions()
end

function SunUIConfig:OnProfileChanged(event, database, newProfileKey)
	StaticPopup_Show("CFG_RELOAD")
end

function SunUIConfig:SetupOptions()
	AC:RegisterOptionsTable("SunUIConfig", self.GenerateOptions)
	ACD:SetDefaultSize("SunUIConfig", DEFAULT_WIDTH, DEFAULT_HEIGHT)

	--Create Profiles Table
	self.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db);
	AC:RegisterOptionsTable("SunUIProfiles", self.profile)
	self.profile.order = -10
	
	self.SetupOptions = nil
end

function SunUIConfig.GenerateOptions()
	if SunUIConfig.noconfig then assert(false, SunUIConfig.noconfig) end
	if not SunUIConfig.Options then
		SunUIConfig.GenerateOptionsInternal()
		SunUIConfig.GenerateOptionsInternal = nil
	end
	return SunUIConfig.Options
end

function SunUIConfig.GenerateOptionsInternal()
	local _, _, L, _ = unpack(SunUI)
	StaticPopupDialogs["CFG_RELOAD"] = {
		text = "改变参数需重载应用设置",
		button1 = ACCEPT,
		button2 = CANCEL,
		OnAccept = function() ReloadUI() end,
		timeout = 0,
		whileDead = 1,
	}
	
	SunUIConfig.Options = {
		type = "group",
		name = "|cff00d2ffSun|r|cffffffffUI|r",
		args = {
			Header = {
				order = 1,
				type = "header",
				name = beta,
				width = "full",		
			},
			Unlock = {
				order = 2,
				type = "execute",
				name = L["解锁框体"],
				func = function()
					--ACD["Close"](ACD,"SunUIConfig")
					if not UnitAffectingCombat("player") then
						for _, value in pairs(MoveHandle) do value:Show() end
						if not aglin then SlashCmdList.TOGGLEGRID() aglin = true end
					end
					--GameTooltip_Hide()
				end,
			},
			Lock = {
				order = 3,
				type = "execute",
				name = L["锁定框体"],
				func = function()
					if not UnitAffectingCombat("player") then
						for _, value in pairs(MoveHandle) do value:Hide() end
						if aglin then SlashCmdList.TOGGLEGRID() aglin = false end
					end
				end,
			},
			Reload = {
				order = 4,
				type = "execute",
				name = L["应用(重载界面)"],
				func = function()
					if not UnitAffectingCombat("player") then
						ReloadUI()
					end
				end,
			},
			ActionBarDB = {
				order = 5,
				type = "group",
				name = L["动作条"],
				get = function(info) return db.ActionBarDB[ info[#info] ] end,
				set = function(info, value) db.ActionBarDB[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,
				args = {
					group1 = {
					type = "group", order = 1,
					name = " ",guiInline = true,
					args = {
						Bar1Layout = {
							type = "select", order = 1,
							name = L["bar1布局"], desc = L["请选择主动作条布局"],
							values = {[1] = L["12x1布局"], [2] =L["6x2布局"]},
						},
						Bar2Layout = {
							type = "select", order = 2,
							name = L["bar2布局"], desc = L["请选择主动作条布局"],
							values = {[1] = L["12x1布局"], [2] =L["6x2布局"]},
						},
						Bar3Layout = {
							type = "select", order = 3,
							name = L["bar3布局"], desc = L["请选择主动作条布局"],
							values = {[1] = L["12x1布局"], [2] =L["6x2布局"]},
						},	
						Bar4Layout = {
							type = "select", order = 4,
							name = L["bar4布局"], desc = L["请选择主动作条布局"],
							values = {[1] = L["12x1布局"], [2] =L["6x2布局"]},
						},	
						Bar5Layout = {
							type = "select", order = 5,
							name = L["bar5布局"], desc = L["请选择主动作条布局"],disabled = (db.ActionBarDB.Big4Layout == 1),
							values = {[1] = "12x1布局", [2] = "6x2布局"},
						},	
						Big4Layout = {
							type = "select", order = 6,
							name = L["4方块布局"], desc = L["请选择主动作条布局"],
							values = {[1] = L["4方块布局"],  [2] = L["不要4方块布局"] },
						},
						Style = {
							type = "select", order = 7,
							name = L["动作条皮肤风格"], desc = L["请选择动作条皮肤风格"],
							values = {[1] = L["阴影风格"], [2] = L["框框风格"]},
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
							},
							HideMacroName = {
								type = "toggle", order = 2,
								name = L["隐藏宏名称显示"],		
							},
							CooldownFlash = {
								type = "toggle", order = 3,
								name = L["冷却闪光"],		
							},
							EnableBarFader = {
								type = "toggle", order = 4,
								name = L["动作条渐隐"],		
							},
							UnLock = {
								type = "execute",
								name = "按鍵綁定",
								order = 5,
								func = function()
									SlashCmdList.MOUSEOVERBIND()
								end,
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
							},
							ButtonSpacing = {
								type = "range", order = 2,
								name = L["动作条间距大小"], desc = L["动作条间距大小"],
								min = 0, max = 6, step = 1,
							},
							FontSize = {
								type = "range", order = 3,
								name = L["动作条字体大小"], desc = L["动作条字体大小"],
								min = 1, max = 36, step = 1,
							},
							MFontSize = {
								type = "range", order = 4,
								name = L["宏名字字体大小"], desc = L["宏名字字体大小"],
								min = 1, max = 36, step = 1,
							},
							MainBarSacle = {
								type = "range", order = 5,
								name = L["主动作条缩放大小"], desc = L["主动作条缩放大小"],
								min = 0, max = 3, step = 0.1,
							},
							ExtraBarSacle = {
								type = "range", order = 6,
								name = L["特殊按钮缩放大小"], desc = L["特殊按钮缩放大小"],
								min = 0, max = 3, step = 0.1,
							},
							PetBarSacle = {
								type = "range", order = 7,
								name = L["宠物条缩放大小"], desc = L["宠物条缩放大小"],
								min = 0, max = 3, step = 0.1,
							},
							StanceBarSacle = {
								type = "range", order = 8,
								name = L["姿态栏缩放大小"], desc = L["姿态栏缩放大小"],
								min = 0, max = 3, step = 0.1,
							},
							TotemBarSacle = {
								type = "range", order = 9,
								name = L["图腾栏缩放大小"], desc = L["图腾栏缩放大小"],
								min = 0, max = 3, step = 0.1,
							},
						}
					},
					group4 = {
						type = "group", order = 4,
						name = " ",guiInline = true, disabled = not db.ActionBarDB.CooldownFlash,
						args = {
							CooldownFlashSize = {
								type = "input",
								name = L["冷却闪光图标大小"],
								desc = L["冷却闪光图标大小"],
								order = 1,
								get = function() return tostring(db.ActionBarDB.CooldownFlashSize) end,
								set = function(_, value) db.ActionBarDB.CooldownFlashSize = tonumber(value) end,
							},
						}
					},
					group5 = {
						type = "group", order = 5,
						name = " ",guiInline = true, disabled = (db.ActionBarDB.Big4Layout ~= 1),
						args = {
							BigSize1 = {
								type = "range", order = 1,
								name = "Big1大小", desc = L["动作条按钮大小"],
								min = 6, max = 80, step = 1,
							},
							BigSize2 = {
								type = "range", order = 2,
								name = "Big2大小", desc = L["动作条按钮大小"],
								min = 6, max = 80, step = 1,
							},
							BigSize3 = {
								type = "range", order = 3,
								name = "Big3大小", desc = L["动作条按钮大小"],
								min = 6, max = 80, step = 1,
							},
							BigSize4 = {
								type = "range", order = 4,
								name = "Big4大小", desc = L["动作条按钮大小"],
								min = 6, max = 80, step = 1,
							},
						}
					},
				}
			},
			BuffDB = {
				order = 6,
				type = "group",
				name = L["增益效果"],
				get = function(info) return db.BuffDB[ info[#info] ] end,
				set = function(info, value) db.BuffDB[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,
				args = {
					IconSize = {
						type = "input",
						name = L["图标大小"],
						desc = L["图标大小"],
						order = 1,
						get = function() return tostring(db.BuffDB.IconSize) end,
						set = function(_, value) db.BuffDB.IconSize = tonumber(value) end,
					},
					IconPerRow = {
						type = "input",
						name = L["每行图标数"],
						desc = L["每行图标数"],
						order = 2,
						get = function() return tostring(db.BuffDB.IconPerRow) end,
						set = function(_, value) db.BuffDB.IconPerRow = tonumber(value) end,
					},
					BuffDirection = {
						type = "select",
						name = L["BUFF增长方向"],
						desc = L["BUFF增长方向"],
						order = 3,
						values = {[1] = L["从右向左"], [2] = L["从左向右"]},
					},
					DebuffDirection = {
						type = "select",
						name = L["DEBUFF增长方向"],
						desc = L["DEBUFF增长方向"],
						order = 4,
						values = {[1] = L["从右向左"], [2] = L["从左向右"]},
					},
					FontSize = {
						type = "input",
						name = L["字体大小"],
						desc = L["字体大小"],
						order = 5,
						get = function() return tostring(db.BuffDB.FontSize) end,
						set = function(_, value) db.BuffDB.FontSize = tonumber(value) end,
					},
				},
			},
			NameplateDB = {
				order = 7,
				type = "group",
				name = L["姓名板"],
				get = function(info) return db.NameplateDB[ info[#info] ] end,
				set = function(info, value) db.NameplateDB[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,
				args = {
						group1 = {
						type = "group", order = 1,
						name = " ",guiInline = true,
						args = {
							enable = {
								type = "toggle",
								name = L["启用姓名板"],
								order = 1,
								},
							}
						},
						group2 = {
						type = "group", order = 2,
						name = " ",guiInline = true,disabled = not db.NameplateDB.enable,
							args = {
								Fontsize = {
									type = "input",
									name = L["姓名板字体大小"] ,
									desc = L["姓名板字体大小"] ,
									order = 1,
									get = function() return tostring(db.NameplateDB.Fontsize) end,
									set = function(_, value) db.NameplateDB.Fontsize = tonumber(value) end,
								},
								HPHeight = {
									type = "input",
									name = L["姓名板血条高度"],
									desc = L["姓名板血条高度"] ,
									order = 2,
									get = function() return tostring(db.NameplateDB.HPHeight) end,
									set = function(_, value) db.NameplateDB.HPHeight = tonumber(value) end,
								},
								HPWidth = {
									type = "input",
									name = L["姓名板血条宽度"],
									desc = L["姓名板血条宽度"],
									order = 3,
									get = function() return tostring(db.NameplateDB.HPWidth) end,
									set = function(_, value) db.NameplateDB.HPWidth = tonumber(value) end,
								},
								CastBarIconSize = {
									type = "input",
									name = L["姓名板施法条图标大小"],
									desc = L["姓名板施法条图标大小"],
									order = 4,
									get = function() return tostring(db.NameplateDB.CastBarIconSize) end,
									set = function(_, value) db.NameplateDB.CastBarIconSize = tonumber(value) end,
								},
								CastBarHeight = {
									type = "input",
									name = L["姓名板施法条高度"],
									desc = L["姓名板施法条高度"],
									order = 5,
									get = function() return tostring(db.NameplateDB.CastBarHeight) end,
									set = function(_, value) db.NameplateDB.CastBarHeight = tonumber(value) end,
								},
								CastBarWidth = {
									type = "input",
									name = L["姓名板施法条宽度"],
									desc = L["姓名板施法条宽度"],
									order = 6,
									get = function() return tostring(db.NameplateDB.CastBarWidth) end,
									set = function(_, value) db.NameplateDB.CastBarWidth = tonumber(value) end,
								},
								Combat = {
									type = "toggle",
									name = L["启用战斗显示"],
									order = 7,
								},
								NotCombat = {
									type = "toggle",
									name = "启用脱离战斗隐藏",
									order = 8,
								},
								Showdebuff = {
									type = "toggle",
									name = L["启用debuff显示"],
									order = 9,
								},
							}
						},
				}
			},
			TooltipDB = {
				order = 8,
				type = "group",
				name = L["鼠标提示"],
				get = function(info) return db.TooltipDB[ info[#info] ] end,
				set = function(info, value) db.TooltipDB[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,
				args = {
					Cursor = {
						type = "toggle",
						name = L["提示框体跟随鼠标"],
						order = 1,
					},
					HideInCombat = {
						type = "toggle",
						name = L["进入战斗自动隐藏"],
						order = 2,
					},
					FontSize = {
						type = "range", order = 3,
						name = L["字体大小"], desc = L["字体大小"],
						min = 2, max = 22, step = 1,
					},
					HideTitles = {
						type = "toggle",
						name = L["隐藏头衔"],
						order = 4,
					},
				}
			},
			ThreatDB = {
				order = 9,
				type = "group",
				name = L["仇恨监视"],
				get = function(info) return db.ThreatDB[ info[#info] ] end,
				set = function(info, value) db.ThreatDB[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,
				args = {
					ThreatBarWidth = {
					type = "input",
					name = L["仇恨条宽度"],
					desc = L["仇恨条宽度"],
					order = 1,
					get = function() return tostring(db.ThreatDB.ThreatBarWidth) end,
					set = function(_, value) db.ThreatDB.ThreatBarWidth = tonumber(value) end,
					},
					NameTextL = {
						type = "input",
						name = L["仇恨条姓名长度"],
						desc = L["仇恨条姓名长度"],
						order = 2,
						get = function() return tostring(db.ThreatDB.NameTextL) end,
						set = function(_, value) db.ThreatDB.NameTextL = tonumber(value) end,
					},
					ThreatLimited = {
						type = "input",
						name = L["显示仇恨人数"],
						desc = L["显示仇恨人数"],
						order = 3,
						get = function() return tostring(db.ThreatDB.ThreatLimited) end,
						set = function(_, value) db.ThreatDB.ThreatLimited = tonumber(value) end,
					},
				}
			},
			ReminderDB = {
				order = 10,
				type = "group",
				name = L["缺失提醒"],
				get = function(info) return db.ReminderDB[ info[#info] ] end,
				set = function(info, value) db.ReminderDB[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,
				args = {
					ShowRaidBuff = {
						type = "toggle", order = 1,
						name = L["显示团队增益缺失提醒"],
					},
					Gruop_1 = {
						type = "group", order = 2,
						name = " ", guiInline = true, disabled = not db.ReminderDB.ShowRaidBuff,
						args = {
							ShowOnlyInParty = {
								type = "toggle", order = 1,
								name = L["只在队伍中显示"],
							}, 
							RaidBuffSize = {
								type = "input", order = 2,
								name = L["团队增益图标大小"], desc = L["团队增益图标大小"],
								get = function() return tostring(db.ReminderDB.RaidBuffSize) end,
								set = function(_, value) db.ReminderDB.RaidBuffSize = tonumber(value) end,
							},
							RaidBuffDirection = {
								type = "select", order = 3,
								name = L["团队增益图标排列方式"], desc = L["团队增益图标排列方式"],
								values = {[1] = L["横排"], [2] = L["竖排"]},
								get = function() return db.ReminderDB.RaidBuffDirection end,
								set = function(_, value) db.ReminderDB.RaidBuffDirection = value end,
							},
						},
					},
					ShowClassBuff = {
						type = "toggle", order = 3,
						name = L["显示职业增益缺失提醒"],
					},
					Gruop_2 = {
						type = "group", order = 4,
						name = " ", guiInline = true, disabled = not db.ReminderDB.ShowClassBuff,
						args = {
							ClassBuffSize = {
								type = "input", order = 1,
								name = L["职业增益图标大小"], desc = L["职业增益图标大小"],
								get = function() return tostring(db.ReminderDB.ClassBuffSize) end,
								set = function(_, value) db.ReminderDB.ClassBuffSize = tonumber(value) end,
							},
						},
					},
				}
			},
			SkinDB = {
				order = 11,
				type = "group",
				name = L["界面皮肤"],
				get = function(info) return db.SkinDB[ info[#info] ] end,
				set = function(info, value) db.SkinDB[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,
				args = {	
					EnableDBMSkin = {
					type = "toggle",
					name = L["启用DBM皮肤"],
					order = 1,
					},
				}
			},
			UnitFrameDB = {
				order = 12,
				type = "group",
				name = L["头像框体"],
				get = function(info) return db.UnitFrameDB[ info[#info] ] end,
				set = function(info, value) db.UnitFrameDB[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,
				args = {
					group1 = {
					type = "group", order = 1,
					name = "大小",guiInline = true,
					args = {
						FontSize = {
							type = "range", order = 1,
							name = L["头像字体大小"],
							min = 2, max = 28, step = 1,
							get = function() return db.UnitFrameDB.FontSize end,
							set = function(_, value) db.UnitFrameDB.FontSize = value end,
						},
						Width = {
							type = "input",
							name = L["玩家与目标框体宽度"],
							desc = L["玩家与目标框体宽度"],
							order = 2,
							get = function() return tostring(db.UnitFrameDB.Width) end,
							set = function(_, value) db.UnitFrameDB.Width = tonumber(value) end,
						},
						Height = {
							type = "input",
							name = L["玩家与目标框体高度"],
							desc = L["玩家与目标框体高度"],
							order = 3,
							get = function() return tostring(db.UnitFrameDB.Height) end,
							set = function(_, value) db.UnitFrameDB.Height = tonumber(value) end,
						},
						Scale = {
							type = "range", order = 4,
							name = L["头像缩放大小"], desc = L["头像缩放大小"],
							min = 0.2, max = 2, step = 0.1,
							get = function() return db.UnitFrameDB.Scale end,
							set = function(_, value) db.UnitFrameDB.Scale = value end,
						},
						PetWidth = {
							type = "input",
							name = L["宠物ToT焦点框体宽度"],
							order = 5,
							get = function() return tostring(db.UnitFrameDB.PetWidth) end,
							set = function(_, value) db.UnitFrameDB.PetWidth = tonumber(value) end,
						},
						PetHeight = {
							type = "input",
							name = L["宠物ToT焦点框体高度"],
							order = 6,
							get = function() return tostring(db.UnitFrameDB.PetHeight) end,
							set = function(_, value) db.UnitFrameDB.PetHeight = tonumber(value) end,
						},
						PetScale = {
							type = "range", order = 7,
							name = L["宠物ToT焦点缩放大小"],
							min = 0.2, max = 2, step = 0.1,
							get = function() return db.UnitFrameDB.PetScale end,
							set = function(_, value) db.UnitFrameDB.PetScale = value end,
						},
						BossWidth = {
							type = "input",
							name = L["Boss小队竞技场框体宽度"],
							desc = L["Boss小队竞技场框体宽度"],
							order = 8,
							get = function() return tostring(db.UnitFrameDB.BossWidth) end,
							set = function(_, value) db.UnitFrameDB.BossWidth = tonumber(value) end,
						},
						BossHeight = {
							type = "input",
							name = L["Boss小队竞技场框体高度"],
							desc = L["Boss小队竞技场框体高度"],
							order = 9,
							get = function() return tostring(db.UnitFrameDB.BossHeight) end,
							set = function(_, value) db.UnitFrameDB.BossHeight = tonumber(value) end,
						},
						BossScale = {
							type = "range", order = 10,
							name = L["Boss小队竞技场缩放大小"],
							min = 0.2, max = 2, step = 0.1,
							get = function() return db.UnitFrameDB.BossScale end,
							set = function(_, value) db.UnitFrameDB.BossScale = value end,
						},
						Alpha3D = {
							type = "range", order = 11,
							name = L["头像透明度"],
							min = 0, max = 1, step = 0.1,
							get = function() return db.UnitFrameDB.Alpha3D end,
							set = function(_, value) db.UnitFrameDB.Alpha3D = value end,
						},
						BigFocus = {
							type = "toggle", order = 12,
							name = "BigFocus",
						},
						CastBar = {
							type = "toggle", order = 13,
							name = "施法条开关",
						},
						TargetRange = {
							type = "toggle", order = 14,
							name = "距离监视",
							desc = "超过40码头像渐隐",
						}, 
						RangeAlpha = {
							type = "range", order = 15,
							name = "距离监视透明度",
							desc = "超出距离头像透明度",
							min = 0, max = 1, step = 0.1,
							get = function() return db.UnitFrameDB.RangeAlpha end,
							set = function(_, value) db.UnitFrameDB.RangeAlpha = value end,
						}, 
						FocusDebuff = {
							type = "toggle", order = 16,disabled = not db.UnitFrameDB.showfocus,
							name = "焦点debuff过滤",
							desc = "只显示玩家释放的debuff",
						}, 
					}
					},
					group2 = {
						type = "group", order = 2,
						name = " ",guiInline = true,
						args = {
							ReverseHPbars = {
								type = "toggle", order = 1,
								name = "血条非透明模式",
								desc = "不打钩为透明模式",
								get = function() return db.UnitFrameDB.ReverseHPbars end,
								set = function(_, value) db.UnitFrameDB.ReverseHPbars = value end,
							},
							ClassColor = {
								type = "toggle", order = 2,
								name = L["开启头像职业血条颜色"],			
							},
							showtot = {
								type = "toggle", order = 3,
								name = L["开启目标的目标"],			
							},
							showpet = {
								type = "toggle", order = 4,
								name = L["开启宠物框体"],			
							},
							showfocus = {
								type = "toggle", order = 5,
								name = L["开启焦点框体"],			
							},
							showparty = {
								type = "toggle", order = 6,
								name = L["开启小队框体"],			
							},
							Party3D = {
							type = "toggle", order = 7,disabled = not db.UnitFrameDB.showparty,
							name = "小队头像",
							},
							showboss = {
								type = "toggle", order = 8,
								name = L["开启boss框体"],			
							},
							showarena = {
								type = "toggle", order = 9,
								name = L["开启竞技场框体"],			
							},
							EnableSwingTimer = {
								type = "toggle", order = 10,
								name = L["开启物理攻击计时条"],			
							},
							EnableBarFader = {
								type = "toggle", order = 11,
								name = L["开启头像渐隐"],			
							},
							TargetAura = {
								type = "select", order = 12,
								name = L["目标增减益"],
								values = {[1] = L["显示"], [2] =L["不显示"], [3] = "Only Player"},
							},
							PlayerBuff = {
								type = "select",
								name = "玩家框体BUFF显示",
								desc = "玩家框体BUFF显示",
								order = 13,
								values = {[1] = "debuff", [2] = "buff", [3] = "debuff+buff", [4] = "none"},
							},
						}
					},
					group3 = {
						type = "group", order = 3,
						name = " ",guiInline = true,disabled = (db.UnitFrameDB.CastBar == false),
						args = {
							playerCBuserplaced = {
								type = "toggle", order = 1,
								name = L["锁定玩家施法条到玩家头像"],			
							},
							PlayerCastBarWidth = {
								type = "input",
								name = L["玩家施法条宽度"],
								desc = L["玩家施法条宽度"],
								order = 2,
								get = function() return tostring(db.UnitFrameDB.PlayerCastBarWidth) end,
								set = function(_, value) db.UnitFrameDB.PlayerCastBarWidth = tonumber(value) end,
							},
							PlayerCastBarHeight = {
								type = "input",
								name = L["玩家施法条高度"],
								desc = L["玩家施法条高度"],
								order = 3,
								get = function() return tostring(db.UnitFrameDB.PlayerCastBarHeight) end,
								set = function(_, value) db.UnitFrameDB.PlayerCastBarHeight = tonumber(value) end,
							},
							NewLine = {
								type = "description", order = 4,
								name = "\n",					
							},
							targetCBuserplaced = {
								type = "toggle", order = 5,
								name = L["锁定目标施法条到目标框体"],			
							},
							TargetCastBarWidth = {
								type = "input",
								name = L["目标施法条宽度"],
								desc = L["目标施法条宽度"],
								order = 6,
								get = function() return tostring(db.UnitFrameDB.TargetCastBarWidth) end,
								set = function(_, value) db.UnitFrameDB.TargetCastBarWidth = tonumber(value) end,
							},
							TargetCastBarHeight = {
								type = "input",
								name = L["目标施法条高度"],
								desc = L["目标施法条高度"],
								order = 7,
								get = function() return tostring(db.UnitFrameDB.TargetCastBarHeight) end,
								set = function(_, value) db.UnitFrameDB.TargetCastBarHeight = tonumber(value) end,
							},
							NewLine = {
								type = "description", order = 8,
								name = "\n",					
							},
							focusCBuserplaced = {
								type = "toggle", order = 9,
								name = L["锁定焦点施法条到焦点框体"],			
							},
							FocusCastBarWidth = {
								type = "input",
								name = L["焦点施法条宽度"],
								desc = L["焦点施法条宽度"],
								order = 10,
								get = function() return tostring(db.UnitFrameDB.FocusCastBarWidth) end,
								set = function(_, value) db.UnitFrameDB.FocusCastBarWidth = tonumber(value) end,
							},
							FocusCastBarHeight = {
								type = "input",
								name = L["焦点施法条高度"],
								desc = L["焦点施法条高度"],
								order = 11,
								get = function() return tostring(db.UnitFrameDB.FocusCastBarHeight) end,
								set = function(_, value) db.UnitFrameDB.FocusCastBarHeight = tonumber(value) end,
							},
						}
					},
				}
			},
			MiniDB = {
				order = 13,
				type = "group",
				name = "Mini",
				get = function(info) return db.MiniDB[ info[#info] ] end,
				set = function(info, value) db.MiniDB[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,
				args = {
					group1 = {
					type = "group", order = 1,
					name = L["小东西设置"],
						args = {
							AutoSell = {
								type = "toggle",
								name = L["启用出售垃圾"],
								order = 1,
							},
							AutoRepair = {
								type = "toggle",
								name = L["启用自动修理"],
								order = 2,
							},
							ChatFilter = {
								type = "toggle",
								name = L["启用聊天信息过滤"],
								order = 3,
							},
							FastError = {
								type = "toggle",
								name = L["启用系统红字屏蔽"],
								order = 4,
							},
							Interrupt = {
								type = "toggle",
								name = L["启用打断通报"],
								order = 5,
							},
							Icicle = {
								type = "toggle",
								name = L["PVP冷却计时"], desc = L["警告"],
								order = 6,
								get = function() return db.MiniDB.Icicle end,
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
									db.MiniDB.Icicle = value end,
							},
							MiniMapPanels = {
								type = "toggle",
								name = L["启用团队工具"], desc = L["需要团长或者助理权限"],
								order = 8,
							},
							Autoinvite = {
								type = "toggle",
								name = L["启用自动邀请"],
								order = 9,
							},
							INVITE_WORD = {
								type = "input",
								name = L["自动邀请关键字"],
								desc = L["自动邀请关键字"],
								disabled = not db.MiniDB.Autoinvite,
								order = 10,
								get = function() return tostring(db.MiniDB.INVITE_WORD) end,
								set = function(_, value) db.MiniDB.INVITE_WORD = tonumber(value) end,
							},
							igonoreOld = {
								type = "toggle",
								name = "副本排队助手",
								desc = L["启用自动离开有进度的随机副本或团队"],
								order = 11,
							},
							HideRaid = {
								type = "toggle",
								name = "Hide Blz RAID Frame",
								desc = "隐藏暴雪团队框架",
								order = 12,
							},
							HideRaidWarn = {
								type = "toggle",
								name = L["隐藏团队警告"],
								order = 13,
							},
							Disenchat = {
								type = "toggle",
								name = "Quick Disenchat",
								desc = "快速分解",
								order = 14,
							},
							Resurrect = {
								type = "toggle",
								name = "Auto AcceptResurrect",
								desc = "自动接受复活",
								order = 15,
							},
							IPhoneLock = {
								type = "toggle",
								name = "SlideLock",
								desc = "AFK锁屏",
								order = 16,
							},
							AutoQuest = {
								type = "toggle",
								name = "AutoQuest",
								desc = "自动交接任务",
								order = 17,
							},
							FatigueWarner = {
								type = "toggle",
								name = "FatigueWarner",
								desc = "疲劳报警",
								order = 18,
							},
							DNDFilter = {
								type = "toggle",
								name = "DNDFilter",
								desc = "过滤DND/AFK自动回复消息",
								order = 19,
							},
							TimeStamps = {
								type = "toggle",
								name = "TimeStamps",
								desc = "聊天时间戳",
								order = 20,
							},
						}
					},
					group2 = {
					type = "group", order = 2,
					name = L["UI缩放"],
						args = {
							uiScale = {
								type = "input", order = 1,
								name = L["UI缩放大小"], desc = L["UI缩放大小"],
								get = function() return tostring(db.MiniDB.uiScale) end,
								set = function(_, value) db.MiniDB.uiScale = tonumber(value) end,
							},
							accept = {
								type = "execute", order = 2,
								name = L["应用"], desc = L["应用"],
								func = function()  SetCVar("useUiScale", 1) SetCVar("uiScale", db.MiniDB.uiScale) RestartGx()end,
							},	
							NewLine = {
								type = "description", order = 3,
								name = "\n",					
							},
							FontScale = {
								type = "range", order = 4,
								name = L["全局字体大小"], desc = L["全局字体大小"],
								min = 0.20, max = 2.50, step = 0.01,
							},
						}
					},
					group3 = {
					type = "group", order = 3,
					name = L["内置CD"],
						args = {
							ClassCDOpen = {
								type = "toggle",
								name = L["启动内置CD"], desc = L["警告"],
								order = 1,
								get = function() return db.MiniDB.ClassCDOpen end,
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
									db.MiniDB.ClassCDOpen = value end,
							},
							group = {
								type = "group", order = 2,
								name = " ",guiInline = true,
								disabled = not db.MiniDB.ClassCDOpen,
								args = {
									ClassCDIcon = {
										type = "toggle",
										name = "启用图标模式",
										order = 1,
									},
									ClassCDIconSize = {
										type = "input",
										name = L["图标大小"],
										desc = L["图标大小"], disabled = not db.MiniDB.ClassCDIcon,
										order = 2,
										get = function() return tostring(db.MiniDB.ClassCDIconSize) end,
										set = function(_, value) db.MiniDB.ClassCDIconSize = tonumber(value) end,
									},
									ClassCDIconDirection = {
										type = "select",
										name = L["BUFF增长方向"],
										desc = L["BUFF增长方向"],
										order = 3, disabled = not db.MiniDB.ClassCDIcon,
										values = {[1] = L["从左向右"], [2] = L["从右向左"]},
										get = function() return db.MiniDB.ClassCDIconDirection end,
										set = function(_, value) db.MiniDB.ClassCDIconDirection = value end,
									},
									ClassFontSize = {
										type = "range", order = 4,
										name = L["内置CD字体大小"], desc = L["内置CD字体大小"], disabled = db.MiniDB.ClassCDIcon,
										min = 4, max = 28, step = 1,
										--get = function() return db.MiniDB.ClassFontSize end,
										--set = function(_, value) db.MiniDB.ClassFontSize = value end,
									},
									ClassCDWidth = {
										type = "input",
										name = L["框体宽度"],
										desc = L["框体宽度"], disabled = db.MiniDB.ClassCDIcon,
										order = 5,
										get = function() return tostring(db.MiniDB.ClassCDWidth) end,
										set = function(_, value) db.MiniDB.ClassCDWidth = tonumber(value) end,
									},
									ClassCDHeight = {
										type = "input",
										name = L["框体高度"],
										desc = L["框体高度"],
										order = 6, disabled = db.MiniDB.ClassCDIcon,
										get = function() return tostring(db.MiniDB.ClassCDHeight) end,
										set = function(_, value) db.MiniDB.ClassCDHeight = tonumber(value) end,
									},
									ClassCDDirection = {
										type = "select",
										name = L["计时条增长方向"],
										desc = L["计时条增长方向"],
										order = 7, disabled = db.MiniDB.ClassCDIcon,
										values = {[1] = L["向下"], [2] = L["向上"]},
										get = function() return db.MiniDB.ClassCDDirection end,
										set = function(_, value) db.MiniDB.ClassCDDirection = value end,
									},
								}		
							},
						}
					},
					group4 = {
					type = "group", order = 4,
					name = "SunUI Script",
						args = {
							Flump = {
								type = "toggle",
								name = L["启用施法通告"],
								order = 1,
							},
							AutoBotton = {
								type = "toggle",
								name = L["打开任务物品按钮"],
								order = 2,
							},
							BloodShield = {
								type = "toggle",
								name = L["打开坦克护盾监视"],
								order = 3,
							},
						}
					},
					group5 = {
					type = "group", order = 5,
					name = "RaidCD",
						args = {
							RaidCD = {
								type = "toggle",
								name = L["打开团队技能CD监视"],
								order = 1,
							},
							group = {
								type = "group", order = 2,
								name = " ",guiInline = true,
								disabled = not db.MiniDB.RaidCD,
								args = {
									RaidCDFontSize = {
										type = "range", order = 1,
										name = L["字体大小"], desc = L["字体大小"],
										min = 4, max = 28, step = 1,
										get = function() return db.MiniDB.RaidCDFontSize end,
										set = function(_, value) db.MiniDB.RaidCDFontSize = value end,
									},
									RaidCDWidth = {
										type = "input",
										name = L["框体宽度"],
										desc = L["框体宽度"],
										order = 2,
										get = function() return tostring(db.MiniDB.RaidCDWidth) end,
										set = function(_, value) db.MiniDB.RaidCDWidth = tonumber(value) end,
									},
									RaidCDHeight = {
										type = "input",
										name = L["框体高度"],
										desc = L["框体高度"],
										order = 3,
										get = function() return tostring(db.MiniDB.RaidCDHeight) end,
										set = function(_, value) db.MiniDB.RaidCDHeight = tonumber(value) end,
									},
									RaidCDDirection = {
										type = "select",
										name = L["计时条增长方向"],
										desc = L["计时条增长方向"],
										order = 4,
										values = {[1] = L["向下"], [2] = L["向上"]},
										get = function() return db.MiniDB.RaidCDDirection end,
										set = function(_, value) db.MiniDB.RaidCDDirection = value end,
									},
								}		
							},
						}
					},
					group6 = {
					type = "group", order = 6,
					name = "AutoBuy",
						args = {
							AutoBuy = {
								type = "toggle",
								name = L["打开自动补购"],
								order = 1,
							},
							group = {
								type = "group", order = 2,
								name = " ",guiInline = true,
								disabled = not db.MiniDB.AutoBuy,
								args = {
									mageone = {
										type = "range", order = 1,
										name = L["传送符文"],
										min = 0, max = 200, step = 1,
									},
									magetwo = {
										type = "range", order = 2,
										name = L["传送门符文"],
										min = 0, max = 200, step = 1,
									},
									magethree = {
										type = "range", order = 3,
										name = L["魔粉"],
										min = 0, max = 1000, step = 1,
									},
									rogueone = {
										type = "range", order = 4,
										name = L["速效药膏"],
										min = 0, max = 200, step = 1,
									},
									roguetwo = {
										type = "range", order = 5,
										name = L["致命药膏"],
										min = 0, max = 200, step = 1,
									},
									roguethree = {
										type = "range", order = 6,
										name = L["减速药膏"],
										min = 0, max = 200, step = 1,
									},
									roguefour= {
										type = "range", order = 7,
										name = L["麻痹药膏"],
										min = 0, max = 200, step = 1,
									},
									roguefive= {
										type = "range", order = 8,
										name = L["致伤药膏"],
										min = 0, max = 200, step = 1,
									},
								}		
							},
						}
					}	
				}
			},
			InfoPanelDB = {
				order = 14,
				type = "group",
				name = L["信息面板"],
				get = function(info) return db.InfoPanelDB[ info[#info] ] end,
				set = function(info, value) db.InfoPanelDB[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,
				args = {
					OpenTop = {
					type = "toggle",
					name = L["启用顶部信息条"],
					order = 1,
					},
					OpenBottom = {
						type = "toggle",
						name = L["启用底部信息条"],
						order = 2,
					},
					Friend = {
					type = "toggle",
					name = FRIENDS,
					order = 3,
					},
					Guild = {
						type = "toggle",
						name = GUILD,
						order = 4,
					},
				}
			},	
			Other = {
				order = 15,
				type = "group",
				name = "Raid and Filger",
				args = {
					UnlockRiad = {
						type = "execute",
						name = L["团队框架"],
						order = 1,
						func = function()
							if not UnitAffectingCombat("player") then
								if IsAddOnLoaded("Freebgrid") then 
									LoadAddOn('Freebgrid_Config')
									local RF = LibStub and LibStub("AceConfigDialog-3.0", true)
											RF:Open("Freebgrid")
											RF:Close("SunUIConfig")
								end
							end
						end
					},
					UnlockFilger = {
					type = "execute",
					name = L["技能监视"] ,
					order = 1,
					func = function()
						if not UnitAffectingCombat("player") then
							if IsAddOnLoaded("RayWatcher") then 
								local bF = LibStub and LibStub("AceConfigDialog-3.0", true)
										bF:Open("RayWatcherConfig")
										bF:Close("SunUIConfig")
							end
						end
					end
					},
				}
			},
		}
	}
	SunUIConfig.Options.args.profiles = SunUIConfig.profile
end

local function BuildFrame()
	local f = CreateFrame("Frame", "SunUI_InstallFrame", UIParent)
	f:SetSize(400, 400)
	f:SetPoint("CENTER")
	f:SetFrameStrata("HIGH")
	S.CreateBD(f)
	S.CreateSD(f)

	local sb = CreateFrame("StatusBar", nil, f)
	sb:SetPoint("BOTTOM", f, "BOTTOM", 0, 60)
	sb:SetSize(320, 20)
	sb:SetStatusBarTexture(DB.Statusbar)
	sb:Hide()
	
	local sbd = CreateFrame("Frame", nil, sb)
	sbd:SetPoint("TOPLEFT", sb, -1, 1)
	sbd:SetPoint("BOTTOMRIGHT", sb, 1, -1)
	sbd:SetFrameLevel(sb:GetFrameLevel()-1)
	S.CreateBD(sbd, .25)

	local header = f:CreateFontString(nil, "OVERLAY")
	header:SetFont(DB.Font, 16, "THINOUTLINE")
	header:SetPoint("TOP", f, "TOP", 0, -20)

	local body = f:CreateFontString(nil, "OVERLAY")
	body:SetJustifyH("LEFT")
	body:SetFont(DB.Font, 13, "THINOUTLINE")
	body:SetWidth(f:GetWidth()-40)
	body:SetPoint("TOPLEFT", f, "TOPLEFT", 20, -60)

	local credits = f:CreateFontString(nil, "OVERLAY")
	credits:SetFont(DB.Font, 9, "THINOUTLINE")
	credits:SetText("SunUI by Coolkid @ 天空之牆 - TW")
	credits:SetPoint("BOTTOM", f, "BOTTOM", 0, 4)

	local sbt = sb:CreateFontString(nil, "OVERLAY")
	sbt:SetFont(DB.Font, 13, "THINOUTLINE")
	sbt:SetPoint("CENTER", sb)

	local option1 = CreateFrame("Button", "SunUI_Install_Option1", f, "UIPanelButtonTemplate")
	option1:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 20, 20)
	option1:SetSize(128, 25)
	S.Reskin(option1)

	local option2 = CreateFrame("Button", "SunUI_Install_Option2", f, "UIPanelButtonTemplate")
	option2:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -20, 20)
	option2:SetSize(128, 25)
	S.Reskin(option2)
	--local close = CreateFrame("Button", "SunUI_Install_CloseButton", f, "UIPanelCloseButton")
	--close:SetPoint("TOPRIGHT", f, "TOPRIGHT")
	--S.ReskinClose(close)
	--SetUpChat
	local function SetChat()
		local channels = {
				"SAY",
				"EMOTE",
				"YELL",
				"GUILD",
				"OFFICER",
				"GUILD_ACHIEVEMENT",
				"ACHIEVEMENT",
				"WHISPER",
				"PARTY",
				"PARTY_LEADER",
				"RAID",
				"RAID_LEADER",
				"RAID_WARNING",
				"BATTLEGROUND",
				"BATTLEGROUND_LEADER",
				"CHANNEL1",
				"CHANNEL2",
				"CHANNEL3",
				"CHANNEL4",
				"CHANNEL5",
				"CHANNEL6",
				"CHANNEL7",
			}
			
		for i, v in ipairs(channels) do
			ToggleChatColorNamesByClassGroup(true, v)
		end
		
		FCF_SetLocked(ChatFrame1, nil)
		FCF_SetChatWindowFontSize(self, ChatFrame1, 15) 
		ChatFrame1:ClearAllPoints()
		ChatFrame1:SetPoint("BOTTOMLEFT", 5, 28)
		ChatFrame1:SetWidth(327)
		ChatFrame1:SetHeight(122)
		ChatFrame1:SetUserPlaced(true)
		for i = 1,10 do FCF_SetWindowAlpha(_G["ChatFrame"..i], 0) end
		FCF_SavePositionAndDimensions(ChatFrame1)
		FCF_SetLocked(ChatFrame1, 1)
	end
	--SetUpDBM
	local function SetDBM()
		if not IsAddOnLoaded("DBM-Core") then return end
		DBM_SavedOptions.Enabled = true
		DBT_SavedOptions["DBM"].Scale = 1
		DBT_SavedOptions["DBM"].HugeScale = 1
		DBT_SavedOptions["DBM"].Texture = DB.Statusbar
		DBT_SavedOptions["DBM"].ExpandUpwards = false
		DBT_SavedOptions["DBM"].BarXOffset = 0
		DBT_SavedOptions["DBM"].BarYOffset = 12
		DBT_SavedOptions["DBM"].IconLeft = true
		DBT_SavedOptions["DBM"].Texture = "Interface\\Buttons\\WHITE8x8"
		DBT_SavedOptions["DBM"].IconRight = false	
		DBT_SavedOptions["DBM"].Flash = false
		DBT_SavedOptions["DBM"].FadeIn = true
		DBM_SavedOptions["DisableCinematics"] = true
		DBT_SavedOptions["DBM"].TimerX = 420
		DBT_SavedOptions["DBM"].TimerY = -29
		DBT_SavedOptions["DBM"].TimerPoint = "TOPLEFT"
		DBT_SavedOptions["DBM"].StartColorR = 1
		DBT_SavedOptions["DBM"].StartColorG = 1
		DBT_SavedOptions["DBM"].StartColorB = 0
		DBT_SavedOptions["DBM"].EndColorR = 1
		DBT_SavedOptions["DBM"].EndColorG = 0
		DBT_SavedOptions["DBM"].EndColorB = 0
		DBT_SavedOptions["DBM"].Width = 130
		DBT_SavedOptions["DBM"].HugeWidth = 155
		DBT_SavedOptions["DBM"].HugeTimerPoint = "TOP"
		DBT_SavedOptions["DBM"].HugeTimerX = -150
		DBT_SavedOptions["DBM"].HugeTimerY = -207
		DBM_SavedOptions["SpecialWarningFontColor"] = {
			0.40,
			0.78,
			1,
		}
	end
	--按钮
	local step4 = function()
		sb:SetValue(4)
		PlaySoundFile("Sound\\interface\\LevelUp.wav")
		header:SetText("安装完毕")
		body:SetText("现在已经安装完毕.\n\n请点击结束重载界面完成最后安装.\n\nEnjoy!")
		sbt:SetText("4/4")
		option1:Hide()
		option2:SetText("结束")
		option2:SetScript("OnClick", function()
			ReloadUI()
		end)
	end

	local step3 = function()
		sb:SetValue(3)
		header:SetText("3. 安装DBM设置")
		body:SetText("如果你没有安装DBM这一步将不会生效,请确定您安装了DBM\n\n即将安装DBM设置.\n\n当然您也可以输入/dbm进行设置.")
		sbt:SetText("3/4")
		option1:SetScript("OnClick", step4)
		option2:SetScript("OnClick", function()
			SetDBM()
			step4()
		end)
	end

	local step2 = function()
		sb:SetValue(2)
		header:SetText("2. 聊天框设置")
		body:SetText("将按照插件默认设置配置聊天框,详细微调请鼠标右点聊天标签")
		sbt:SetText("2/4")
		option1:SetScript("OnClick", step3)
		option2:SetScript("OnClick", function()
			SetChat()
			step3()
		end)
	end

	local step1 = function()
		sb:SetMinMaxValues(0, 4)
		sb:Show()
		sb:SetValue(1)
		sb:GetStatusBarTexture():SetGradient("VERTICAL", 0.20, .9, 0.12, 0.36, 1, 0.30)
		header:SetText("1. 载入SunUI核心数据")
		body:SetText("这一步将载入SunUI默认参数,请不要跳过\n\n更多详细设置在SunUI控制台内\n\n打开控制台方法:1.Esc>SunUI 2.输入命令/sunui 3.聊天框右侧上部渐隐按钮集合内点击S按钮")
		sbt:SetText("1/4")
		option1:Show()
		option1:SetText("跳过")
		option2:SetText("下一步")
		option1:SetScript("OnClick", step2)
		option2:SetScript("OnClick", function()
			CoreVersion = Version
			step2()
		end)
	end

	local tut6 = function()
		sb:SetValue(6)
		header:SetText("6. 结束")
		body:SetText("教程结束.更多详细设置请见/sunui 如果遇到灵异问题或者使用Bug 请到http://bbs.ngacn.cc/read.php?tid=4743077&_fp=1&_ff=200 回复记得带上BUG截图 亲~~")
		sbt:SetText("6/6")
		option1:Show()
		option1:SetText("结束")
		option2:SetText("安装")
		option1:SetScript("OnClick", function()
			UIFrameFade(f,{
				mode = "OUT",
				timeToFade = 0.5,
				finishedFunc = function(f) f:Hide() end,
				finishedArg1 = f,
			})
		end)
		option2:SetScript("OnClick", step1)
	end

	local tut5 = function()
		sb:SetValue(5)
		header:SetText("5. 命令")
		body:SetText("一些常用命令 \n/sunui 控制台 全局解锁什么的 ps:绝大部分设置需要重载生效 \n/align 在屏幕上显示网格,方便安排布局\n/hb 绑定动作条快捷键\n/rl 重载UI\n/wf 解锁任务追踪框体\n/vs 载具移动\n/pdb 插件全商业技能\n/rw2 buff监控设置\n/autoset 自动设置UI缩放\n/setdbm 重新设置DBM\n/setsunui重新打开安装向导")
		sbt:SetText("5/6")
		option2:SetScript("OnClick", tut6)
	end

	local tut4 = function()
		sb:SetValue(4)
		header:SetText("4. 您应该知道的东西")
		body:SetText("SunUI 95%的设置都是可以通过图形界面来完成的, 大多数的设置在/sunui中 少部分的设置在ESC>界面中.\n经验条在动作条下面..鼠标指向显示")
		sbt:SetText("4/6")
		option2:SetScript("OnClick", tut5)
	end

	local tut3 = function()
		sb:SetValue(3)
		header:SetText("3. 特性")
		body:SetText("SunUI是重新设计过的暴雪用户界面.具有大量人性化设计.您可以在各个细节中体验到")
		sbt:SetText("3/6")
		option2:SetScript("OnClick", tut4)
	end

	local tut2 = function()
		sb:SetValue(2)
		header:SetText("2.单位框架")
		body:SetText("SunUI的头像部分使用mono的oUF_Mono为模版进行改进而来.增加了更多额外的设置.自由度很高,你可以使用/sunui ->头像设置 进行更多的个性化设置. \n而团队框架则没有选用oUF部分,而是使用了暴雪内建团队框架的改良版,它比oUF的团队框架有更低的内存与CPU占用.更适合老爷机器.")
		sbt:SetText("2/6")
		option2:SetScript("OnClick", tut3)
	end

	local tut1 = function()
		sb:SetMinMaxValues(0, 6)
		sb:Show()
		sb:SetValue(1)
		sb:GetStatusBarTexture():SetGradient("VERTICAL", 0, 0.65, .9, .1, .9, 1)
		header:SetText("1. 概述")
		body:SetText("欢迎使用SunUI\n SunUI是一个类Tukui但是又不是Tukui的整合插件.它界面整洁清晰,功能齐全,整体看起来华丽而不臃肿.内存CPU占用小即使是老爷机也能跑.适用于宽频界面.")

		sbt:SetText("1/6")
		option1:Hide()
		option2:SetText("下一个")
		option2:SetScript("OnClick", tut2)
	end
	
	header:SetText("欢迎")
	body:SetText("欢迎您使用SunUI \n\n\n\n几个小步骤将引导你安装SunUI. \n\n\n为了达到最佳的使用效果,请不要随意跳过这个安装程序\n\n\n\n\n如果需要再次安装 请输入命令/sunui")

	option1:SetText("教程")
	option2:SetText("安装SunUI")

	option1:SetScript("OnClick", tut1)
	option2:SetScript("OnClick", step1)
end
SlashCmdList["SETSUNUI"] = function()
	if not UnitAffectingCombat("player") then
		BuildFrame()
	end
end
SLASH_SETSUNUI1 = "/setsunui"
function SunUIConfig:OnEnable()
	local Button = CreateFrame("Button", "SunUIGameMenuButton", GameMenuFrame, "GameMenuButtonTemplate")
		S.Reskin(Button)
		Button:SetSize(GameMenuButtonHelp:GetWidth(), GameMenuButtonHelp:GetHeight())
		Button:SetText("|cffDDA0DDSun|r|cff44CCFFUI|r")
		Button:SetPoint(GameMenuButtonHelp:GetPoint())
		Button:SetScript("OnClick", function()
			HideUIPanel(GameMenuFrame)
			SunUIConfig:ShowConfig()
		end)
	GameMenuButtonHelp:SetPoint("TOP", Button, "BOTTOM", 0, -1)
	GameMenuFrame:SetHeight(GameMenuFrame:GetHeight()+Button:GetHeight())
	if not CoreVersion or (CoreVersion < Version) then 
			BuildFrame()
	end	
	SunUIConfig:RegisterChatCommand("sunui", "ShowConfig")
end

SlashCmdList["CLEARSUNUI"] = function()
	if not UnitAffectingCombat("player") then
		wipe(SunUIConfig)
		wipe(CoreVersion)
	end
end
SLASH_CLEARSUNUI1 = "/clearset"