local S, L, G, _ = unpack(select(2, ...))

-----------------------------------------
-- This is the default configuration file
-----------------------------------------

G["ActionBarDB"] = {
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
	["BigSize2"] = 24,
	["Bar4Layout"] = 1,
	["BigSize3"] = 52,
	["HideHotKey"] = false,
	["MainBarSacle"] = 1,
	["Bar1Layout"] = 1,
	["BigSize4"] = 52,
	["ExtraBarSacle"] = 1.5,
	["ExpbarWidth"] = 120,
	["ExpbarHeight"] = 5,
	["ExpbarUp"] = true,
	["ExpbarFadeOut"] = false,
	["AllFade"] = false,
	["Bar1Fade"] = false,
	["Bar2Fade"] = false,
	["Bar3Fade"] = false,
	["Bar4Fade"] = false,
	["Bar5Fade"] = false,
	["StanceBarFade"] = false,
	["PetBarFade"] = false,
}
G["NameplateDB"] = {
	["CastBarWidth"] = 125,
	["HPWidth"] = 125,
	["enable"] = true,
	["Showdebuff"] = true,
	["HPHeight"] = 10,
	["CastBarIconSize"] = 15,
	["Fontsize"] = 10,
	["CastBarHeight"] = 6,
	["Combat"] = true,
	["NotCombat"] = false,
	["IconSize"] = 20,
}
G["TooltipDB"] = {
	["FontSize"] = 12,
	["HideInCombat"] = false,
	["Cursor"] = true,
	["HideTitles"] = true,
}
G["BuffDB"] = {
	["IconSize"] = 28,
	["BuffDirection"] = 1,
	["DebuffDirection"] = 1,
	["IconPerRow"] = 16,
	["FontSize"] = 13,
}
G["ReminderDB"] = {
	["ShowRaidBuff"] = true,
	["ShowOnlyInParty"] = true,
	["RaidBuffDirection"] = 1,
	["RaidBuffSize"] = 15,
	["ClassBuffSize"] = 32,
	["ShowClassBuff"] = true,
}
G["SkinDB"] = {
	["EnableDBMSkin"] = true,
}
G["UnitFrameDB"] = {
	["FontSize"] = 11,
	["focusCBuserplaced"] = true,
	["BossHeight"] = 15,
	["Scale"] = 1,
	["EnableVengeanceBar"] = true,
	["EnableThreat"] = true,
	["PetHeight"] = 20,
	["TargetCastBarHeight"] = 15,
	["EnableBarFader"] = false,
	["BossWidth"] = 140,
	["BossScale"] = 1,
	["TargetCastBarWidth"] = 150,
	["showparty"] = false,
	["targetCBuserplaced"] = false,
	["TargetAura"] = 1,
	["FocusCastBarWidth"] = 100,
	["showtot"] = true,
	["PlayerCastBarWidth"] = 300,
	["showpet"] = true,
	["PlayerCastBarHeight"] = 20,
	["playerCBuserplaced"] = false,
	["FocusCastBarHeight"] = 6,
	["Alpha3D"] = 0,
	["Width"] = 180,
	["ClassColor"] = true,
	["PetWidth"] = 100,
	["showboss"] = true,
	["PetScale"] = 1,
	["showfocus"] = true,
	["ReverseHPbars"] = false,
	["showarena"] = true,
	["Height"] = 20,
	["BigFocus"] = true,
	["PlayerBuff"] = 4,
	["CastBar"] = true,
	["Party3D"] = false,
	["TargetRange"] = false,
	["RangeAlpha"] = 0.6,
	["FocusDebuff"] = false,
	["TagFadeIn"] = true,
	["ShowThreatWarn"] = true,
}
G["MiniDB"] = {
	["AutoRepair"] = false,
	["IPhoneLock"] = true,
	["AutoQuest"] = true,
	["DNDFilter"] = true,
	["TimeStamps"] = true,
	["MiniMapPanels"] = true,
	["INVITE_WORD"] = "SunUI",
	["ChatFilter"] = true,
	["Icicle"] = false,
	["Autoinvite"] = false,
	["Disenchat"] = true,
	["LockUIscale"] = false,
	["Resurrect"] = false,
	["HideRaidWarn"] = true,
	["HideRaid"] = true,
	["AutoSell"] = true,
	["FastError"] = true,
	["ChatBackground"] = false,
	["UIscale"] = true,
	["uistyle"] = "stereo",
	["uitexture"] = "SunUI StatusBar6",
	["uitexturePath"] = "Interface\\AddOns\\SunUI\\media\\statusbars\\statusbar6",
	["AutoUIscale"] = false,
	["Combat"] = false, 
	["FogClear"] = true,
	["Aurora"] = true, 
	["uiScale"] = 0.9,
	["FontScale"] = 1,	
	
	
}
G["ClassCDDB"] = {
	["ClassCDOpen"] = true,
	["ClassFontSize"] = 12,
	["ClassCDIcon"] = false,
	["ClassCDIconSize"] = 25,
	["ClassCDIconDirection"] = 1,
	["ClassCDHeight"] = 8,
	["ClassCDWidth"] = 100,
	["ClassCDDirection"] = 1,
}
G["RaidCDDB"] = {	
	["RaidCD"] = true,
	["RaidCDFontSize"] = 12,
	["RaidCDWidth"] = 100,
	["RaidCDHeight"] = 8,
	["RaidCDDirection"] = 1,
	["RowNum"] = 10,
	["MaxNumber"] = 30,
	["RowDirection"] = "right",
}	
	
G["InfoPanelDB"] = {
	["OpenTop"] = true,
	["OpenBottom"] = true,
	["Friend"] = false,
	["Guild"] = false,
}
G["MoveHandleDB"] = {
	--动作条
	["bar1"] = {"BOTTOM", "UIParent", "BOTTOM", 0, 13},
	["bar2"] = {"BOTTOM","SunUIActionBar1", "TOP",  0,  4},	
	["bar3"] = {"BOTTOMRIGHT", "SunUIActionBar1", "BOTTOMLEFT", -4, 0},
	["bar32"] = {"BOTTOMLEFT", "SunUIActionBar1", "BOTTOMRIGHT", 4, 0},
	["bar4"] = {"RIGHT", "UIParent", "RIGHT", -10, 0},
	["bar5"] = {"RIGHT","UIParent", "RIGHT", -40, 0},
	["bar51"] = {"BOTTOM", "MultiBarBottomLeftButton4", "TOP", 0, 4},
	["bar52"] = {"BOTTOM", "MultiBarBottomLeftButton5", "TOP", 0, 4},
	["bar53"] = {"BOTTOMRIGHT", "MultiBarBottomRightButton3", "BOTTOMLEFT", -4, 0},
	["bar54"] = {"BOTTOMLEFT", "MultiBarBottomRightButton9","BOTTOMRIGHT",  4,  0},
	["stancebar"] = {"BOTTOMLEFT", "MultiBarBottomRightButton6", "TOPLEFT", 0, 4},
	["petbar"] = {"BOTTOMRIGHT", "MultiBarBottomRightButton12", "TOPRIGHT",  0,  4},
	["vehicleexit"] = {"BOTTOM", "UIParent", "BOTTOM", 278, 66},
	["extrabar"] = {"CENTER", "UIParent", "CENTER", 0, -135},
	["totembar"] = {"BOTTOM", "UIParent", "BOTTOM", -175, 292},
	--头像
	["PlayerFrame"] = {"BOTTOM", "UIParent", "BOTTOM", -175, 172},
	["TargetFrame"] = {"BOTTOM", "UIParent", "BOTTOM",  175,  172},
	["PetFrame"] = {"TOPRIGHT", "SunUF_Player", "TOPLEFT", -5, 0},
	["ToTFrame"] = {"BOTTOM", "UIParent", "BOTTOM", 0, 172},
	["FocusTFrame"] = {"TOP", "SunUF_Focus", "BOTTOM", 0, -30},
	["BossFrame"] = {"RIGHT", "UIParent", "RIGHT", -50, -60},
	["FocusFrame"] = {"RIGHT", "UIParent", "RIGHT", -57, -138},
	["PartyFrame"] = {"LEFT", "UIParent", "LEFT", 10, 0},
	["ArenaFrame"] = {"RIGHT", "UIParent", "RIGHT", -50, -60},
	--小地图
	["Minimap"] = {"TOPLEFT", "UIParent", "TOPLEFT", 5, -5},
	--buff/debuff
	["Buff"] = {"TOPRIGHT", "UIParent", "TOPRIGHT", -5, -5},
	["Debuff"] = {"TOPRIGHT", "UIParent", "TOPRIGHT", -5, -110},
	--roll点
	["RollFrame"] = {"TOP", "UIParent", "TOP", 0, -200},
	--buff提醒
	["Reminder"] = {"TOPLEFT", "Minimap", "BOTTOMLEFT", 0, -20},
	["Class"] = {"CENTER", "UIParent", "CENTER", -150, 150},
	--施法条
	["PlayerCastbar"] = {"BOTTOM", "UIParent", "BOTTOM",0, 110},
	["TargetCastbar"] = {"CENTER", "UIParent", "CENTER",0, -170},
	["FocusCastbar"] = {"TOP", "SunUF_Focus", "BOTTOM", 0, -20},
	--内置CD 团队CD
	["ClassCD"] = {"LEFT", "UIParent", "LEFT", 30, 240},
	["RaidCD"] =  {"LEFT", "UIParent", "LEFT", 30, 0},
	--冷却图标闪闪的
	["CooldownFlash"] = {"TOP", "UIParent", "TOP", 0, -95},
	--鼠标提示
	["Tooltip"] = {"BOTTOMRIGHT", "UIParent", "BOTTOMRIGHT", -50, 160},
	--仇恨监视
	["Threat"] = {"BOTTOM", "UIParent", "BOTTOM", -177, 262},
	--宠物计时
	["ShadowPet"] = {"BOTTOM", "UIParent", "BOTTOM", -322, 201},
	--信息条
	["InfoPanel"] = {"TOPLEFT", "Minimap", "TOPRIGHT", 20, 3},
	--Mini
	["BloodShield"] = {"BOTTOM", "UIParent", "BOTTOM", -285,  172},
	["AutoButton"] = {"RIGHT", "UIParent", "RIGHT", -270, 188},
	--经验条
	["expbar"] = {"LEFT", "Minimap", "RIGHT", 5,0},
	--powerbar
	["PowerBar"] = {"CENTER", "UIParent", "CENTER", 0, -120},
	--成就移动
	["AchievementHolder"] = {"RIGHT", "UIParent", "RIGHT", -220, -100},
	--警告框体
	["Warn"] = {"TOP", "UIParent", "TOP", 0, -35},
	--燃火
	["Ignite"] = {"BOTTOM", "UIParent", "BOTTOM",  285,  168},
	--职业斩杀
	["ClassTools"] = {"TOP", "UIParent", "TOP", 0, -35},
	--职业助手
	["RuneOfPower"] = {"TOP", "UIParent", "TOP", 0, -35},
}
G["PowerBarDB"] = {
	["Open"] = true,
	["Width"] = 200,
	["Height"] = 5,
	["Scale"] = 1,
	["Fade"] = true,
	["HealthPower"] = true,
}
G["WarnDB"] = {
	["Open"] = true,
	["Width"] = 128,
	["Height"] = 64,
	["FontSize"] = 15,
	["Health"] = true,
}
G["AnnounceDB"] = {
	["Open"] = true,
	["Interrupt"] = true,
	["Channel"] = true,
	["Mislead"] = true,
	["BaoM"] = true,
	["Give"] = true,
	["Resurrect"] = true,
	["Heal"] = true,
	["Flump"] = false,
}
G["BagDB"] = {
	["BagSize"] = 32,
	["BankSize"] = 32,
	["Spacing"] = 5,
	["BagWidth"] = 400,
	["BankWidth"] = 580,
}
G["EquipmentDB"] = {
	["Enable"] = true,
}
G["ClassToolsDB"] = {
	["Enable"] = true,
	["Size"] = 48,
	["Scale"] = 1,
	["EnableIgniteWatch"] = true,
	["IgniteWatchSize"] = 24,
	["EnableSpiritShellWatch"] = true,
	["SpiritShellWatchSize"] = 24,
	["ROPEnable"] = true,
	["ROPSize"] = 24,
}