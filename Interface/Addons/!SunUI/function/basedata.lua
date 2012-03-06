local S, C, L, DB = unpack(select(2, ...))


ActionBarDB = {
	["FontSize"] = 11,
	["MFontSize"] = 10,
	["PetBarSacle"] = 1,
	["ExtraBarSacle"] = 1.5,
	["ButtonSpacing"] = 5,
	["CooldownFlashSize"] = 64,
	["CooldownFlash"] = true,
	["Big4Layout"] = 1,
	["TotemBarSacle"] = 1,
	["Bar3Layout"] = 2,
	["Bar5Layout"] = 1,
	["ButtonSize"] = 34,
	["Bar2Layout"] = 1,
	["StanceBarSacle"] = 1,
	["HideHotKey"] = false,
	["Bar4Layout"] = 1,
	["MainBarSacle"] = 1,
	["Style"] = 1,
	["Bar1Layout"] = 1,
	["EnableBarFader"] = false,
	["HideMacroName"] = false,
}	
BuffDB = {
	["WarningTime"] = 15,
	["BuffDirection"] = 1,
	["DebuffDirection"] = 1,
	["Spacing"] = 8,
	["IconSize"] = 36,
	["IconPerRow"] = 16,
	["IconsPerRow"] = 12,
}
NameplateDB = {
	["CastBarHeight"] = 6,
	["HPWidth"] = 120,
	["enable"] = true,
	["CCAuraTrack"] = true,
	["HPHeight"] = 10,
	["CastBarIconSize"] = 23,
	["Fontsize"] = 9,
	["AuraTrack"] = true,
	["CastBarWidth"] = 110,
	["Showdebuff"] = true,
	["Combat"] = false,
}
ReminderDB = {
	["RaidBuffDirection"] = 1,
	["ClassBuffSound"] = false,
	["ClassBuffSize"] = 48,
	["ShowOnlyInParty"] = true,
	["ShowRaidBuff"] = true,
	["RaidBuffSize"] = 18,
	["ClassBuffSpace"] = 64,
	["ShowClassBuff"] = true,
}
ThreatDB = {
	["ThreatBarWidth"] = 240,
	["NameTextL"] = 3,
	["ThreatLimited"] = 3,
}
TooltipDB = {
	["HideInCombat"] = false,
	["FontSize"] = 11,
	["Cursor"] = true,
	["HideTitles"] = true,
}
UnitFrameDB = {
	["FontSize"] = 10,
	["BossHeight"] = 22,
	["Scale"] = 1,
	["PetHeight"] = 15,
	["PowerHeight"] = 0.7999999999999999,
	["Alpha3D"] = 0,
	["Fontsize"] = 10,
	["OnlyShowPlayer"] = false,
	["showpet"] = true,
	["playerCBuserplaced"] = false,
	["Width"] = 240,
	["Alpha3D"] = 0,
	["ClassColor"] = false,
	["Bossframes"] = true,
	["TargetCastBarHeight"] = 10,
	["EnableBarFader"] = false,
	["showarena"] = true,
	["PetWidth"] = 123,
	["BossScale"] = 1,
	["FocusCastBarWidth"] = 123,
	["ReverseHPbars"] = false,
	["TargetCastBarWidth"] = 240,
	["showparty"] = false,
	["PetCastBarWidth"] = 180,
	["Icon"] = 24,
	["FocusCastBarHeight"] = 20,
	["PlayerCastBarHeight"] = 10,
	["PlayerCastBarWidth"] = 460,
	["PowerClass"] = false,
	["ClassColorbars"] = false,
	["showfocus"] = true,
	["PetScale"] = 0.9,
	["showboss"] = true,
	["showtot"] = true,
	["focusCBuserplaced"] = true,
	["PowerColor"] = true,
	["targetCBuserplaced"] = false,
	["Height"] = 25,
	["Portraits"] = false,
	["BossWidth"] = 196,
	["EnableSwingTimer"] = false,
	["PetCastBarHeight"] = 10,
}

SkinDB = {
	["EnableDBMSkin"] = true,
	["HideRaidWarn"] = true,
}

InfoPanelDB = {
	["BottomHeight"] = 13,
	["OpenTop"] = true,
	["OpenBottom"] = true,
	["BottomWidth"] = 440,
	["MemNum"] = 5,
}
MoveHandleDB = {
	["bar3"] = {
		"BOTTOM", -- [1]
		"SunUIActionBar2", -- [2]
		"TOP", -- [3]
		0, -- [4]
		5, -- [5]
	},
	["TargetCastbar"] = {
		"BOTTOM", -- [1]
		"UIParent", -- [2]
		"BOTTOM", -- [3]
		227.6981404250867, -- [4]
		199.9548160562789, -- [5]
	},
	["Buff"] = {
		"TOPRIGHT", -- [1]
		"UIParent", -- [2]
		"TOPRIGHT", -- [3]
		-5, -- [4]
		-5, -- [5]
	},
	["PlayerCastbar"] = {
		"BOTTOM", -- [1]
		"UIParent", -- [2]
		"BOTTOM", -- [3]
		-1.69824901140635, -- [4]
		140.6366511650806, -- [5]
	},
	["Minimap"] = {
		"BOTTOMRIGHT", -- [1]
		"UIParent", -- [2]
		"BOTTOMRIGHT", -- [3]
		-10, -- [4]
		29, -- [5]
	},
	["totembar"] = {
		"BOTTOM", -- [1]
		"UIParent", -- [2]
		"BOTTOM", -- [3]
		0, -- [4]
		166, -- [5]
	},
	["Debuff"] = {
		"TOPRIGHT", -- [1]
		"UIParent", -- [2]
		"TOPRIGHT", -- [3]
		-5, -- [4]
		-140, -- [5]
	},
	["Combatpoint"] = {
		"CENTER", -- [1]
		"UIParent", -- [2]
		"CENTER", -- [3]
		226, -- [4]
		-297, -- [5]
	},
	["vehicleexit"] = {
		"BOTTOM", -- [1]
		"UIParent", -- [2]
		"BOTTOM", -- [3]
		431.5837790637644, -- [4]
		85.80951579937789, -- [5]
	},
	["RollFrame"] = {
		"TOP", -- [1]
		"UIParent", -- [2]
		"TOP", -- [3]
		0, -- [4]
		-200, -- [5]
	},
	["Class"] = {
		"TOPLEFT", -- [1]
		"UIParent", -- [2]
		"TOPLEFT", -- [3]
		307.2003851121865, -- [4]
		-224.8297548397155, -- [5]
	},
	["Threat"] = {
		"CENTER", -- [1]
		"UIParent", -- [2]
		"CENTER", -- [3]
		-225, -- [4]
		-133, -- [5]
	},
	["FocusCastbar"] = {
		"RIGHT", -- [1]
		"UIParent", -- [2]
		"RIGHT", -- [3]
		-99, -- [4]
		-165, -- [5]
	},
	["bar2"] = {
		"BOTTOM", -- [1]
		"SunUIActionBar1", -- [2]
		"TOP", -- [3]
		0, -- [4]
		5, -- [5]
	},
	["bar1"] = {
		"BOTTOM", -- [1]
		"UIParent", -- [2]
		"BOTTOM", -- [3]
		0, -- [4]
		10, -- [5]
	},
	["extrabar"] = {
		"BOTTOM", -- [1]
		"UIParent", -- [2]
		"BOTTOM", -- [3]
		-259.1991969535657, -- [4]
		59.38035613304149, -- [5]
	},
	["ClassCD"] = {
		"BOTTOM", -- [1]
		"UIParent", -- [2]
		"BOTTOM", -- [3]
		-434.1817458738224, -- [4]
		229.9032052794286, -- [5]
	},
	["ShadowPet"] = {
		"CENTER", -- [1]
		"UIParent", -- [2]
		"CENTER", -- [3]
		-423, -- [4]
		-223, -- [5]
	},
	["InfoPanel"] = {
		"TOPLEFT", -- [1]
		"UIParent", -- [2]
		"TOPLEFT", -- [3]
		5, -- [4]
		-5, -- [5]
	},
	["Reminder"] = {
		"BOTTOMRIGHT", -- [1]
		"UIParent", -- [2]
		"BOTTOMRIGHT", -- [3]
		-52, -- [4]
		211, -- [5]
	},
	["stancebar"] = {
		"BOTTOMLEFT", -- [1]
		"MultiBarBottomRightButton6", -- [2]
		"TOPLEFT", -- [3]
		0, -- [4]
		5, -- [5]
	},
	["bar5"] = {
		"RIGHT", -- [1]
		"UIParent", -- [2]
		"RIGHT", -- [3]
		-38, -- [4]
		0, -- [5]
	},
	["CooldownFlash"] = {
		"BOTTOM", -- [1]
		"UIParent", -- [2]
		"CENTER", -- [3]
		0, -- [4]
		150, -- [5]
	},
	["petbar"] = {
		"BOTTOMRIGHT", -- [1]
		"MultiBarBottomRightButton12", -- [2]
		"TOPRIGHT", -- [3]
		0, -- [4]
		5, -- [5]
	},
	["InfoPanel2"] = {
		"TOPRIGHT", -- [1]
		"Minimap", -- [2]
		"BOTTOMRIGHT", -- [3]
		0, -- [4]
		-5, -- [5]
	},
	["bar4"] = {
		"RIGHT", -- [1]
		"UIParent", -- [2]
		"RIGHT", -- [3]
		-10, -- [4]
		0, -- [5]
	},
}

MiniDB = {
	["ClassCDWidth"] = 100,
	["uiScale"] = 0.7,
	["AutoRepair"] = false,
	["Icicle"] = false,
	["MiniMapPanels"] = true,
	["UIscale"] = true,
	["FastError"] = true,
	["AutoSell"] = true,
	["LockUIscale"] = false,
	["Flump"] = true,
	["Autoinvite"] = false,
	["Interrupt"] = true,
	["INVITE_WORD"] = "SunUI",
	["ClassCDHeight"] = 20,
	["ClassCDOpen"] = false,
	["ClassFontSize"] = 15,
	["ClassCDDirection"] = 1,
	["AutoUIscale"] = false,
	["ChatFilter"] = true,
	["FontScale"] = 0.8600000000000001,
	["igonoreOld"] = false,
	["HideRaid"] = true,
}