local S, C, L, DB = unpack(select(2, ...))


ActionBarDB = {
	["FontSize"] = 11,
	["MFontSize"] = 10,
	["PetBarSacle"] = 0.7,
	["ExtraBarSacle"] = 1.5,
	["ButtonSpacing"] = 1,
	["CooldownFlashSize"] = 64,
	["CooldownFlash"] = true,
	["Big4Layout"] = 1,
	["TotemBarSacle"] = 1,
	["Bar3Layout"] = 1,
	["Bar5Layout"] = 1,
	["ButtonSize"] = 34,
	["Bar2Layout"] = 1,
	["StanceBarSacle"] = 0.9,
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
	["Fontsize"] = 10,
	["OnlyShowPlayer"] = false,
	["showpet"] = true,
	["playerCBuserplaced"] = false,
	["Width"] = 240,
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
MoveHandleDB = {
	["bar3"] = {
		"BOTTOMLEFT", -- [1]
		"SunUIActionBar2", -- [2]
		"TOPLEFT", -- [3]
		0, -- [4]
		5, -- [5]
	},
	["TargetCastbar"] = {
		"CENTER", -- [1]
		"UIParent", -- [2]
		"CENTER", -- [3]
		226, -- [4]
		-257, -- [5]
	},
	["Buff"] = {
		"TOPRIGHT", -- [1]
		"UIParent", -- [2]
		"TOPRIGHT", -- [3]
		-5, -- [4]
		-5, -- [5]
	},
	["Class"] = {
		"TOPLEFT", -- [1]
		"UIParent", -- [2]
		"TOPLEFT", -- [3]
		264.5352588942658, -- [4]
		-234.8138933050517, -- [5]
	},
	["Minimap"] = {
		"BOTTOMRIGHT", -- [1]
		"UIParent", -- [2]
		"BOTTOMRIGHT", -- [3]
		-20, -- [4]
		27, -- [5]
	},
	["InfoPanel2"] = {
		"TOPRIGHT", -- [1]
		"Minimap", -- [2]
		"BOTTOMRIGHT", -- [3]
		0, -- [4]
		-5, -- [5]
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
	["Reminder"] = {
		"BOTTOMRIGHT", -- [1]
		"UIParent", -- [2]
		"BOTTOMRIGHT", -- [3]
		-24.82629867665552, -- [4]
		192.3181289236894, -- [5]
	},
	["RollFrame"] = {
		"CENTER", -- [1]
		"UIParent", -- [2]
		"CENTER", -- [3]
		-5.095013439950329, -- [4]
		222.0826620879891, -- [5]
	},
	["ShadowPet"] = {
		"CENTER", -- [1]
		"UIParent", -- [2]
		"CENTER", -- [3]
		-423, -- [4]
		-223, -- [5]
	},
	["Threat"] = {
		"CENTER", -- [1]
		"UIParent", -- [2]
		"CENTER", -- [3]
		-226.6983366736619, -- [4]
		-105.8261505671037, -- [5]
	},
	["FocusCastbar"] = {
		"RIGHT", -- [1]
		"UIParent", -- [2]
		"RIGHT", -- [3]
		-99, -- [4]
		-165, -- [5]
	},
	["bar2"] = {
		"BOTTOMLEFT", -- [1]
		"SunUIActionBar1", -- [2]
		"TOPLEFT", -- [3]
		0, -- [4]
		5, -- [5]
	},
	["bar1"] = {
		"BOTTOM", -- [1]
		"UIParent", -- [2]
		"BOTTOM", -- [3]
		0, -- [4]
		15, -- [5]
	},
	["ClassCD"] = {
		"CENTER", -- [1]
		"UIParent", -- [2]
		"CENTER", -- [3]
		415, -- [4]
		-380, -- [5]
	},
	["bar5"] = {
		"RIGHT", -- [1]
		"UIParent", -- [2]
		"RIGHT", -- [3]
		-38, -- [4]
		0, -- [5]
	},
	["PlayerCastbar"] = {
		"CENTER", -- [1]
		"UIParent", -- [2]
		"CENTER", -- [3]
		0, -- [4]
		-335, -- [5]
	},
	["InfoPanel"] = {
		"TOPLEFT", -- [1]
		"UIParent", -- [2]
		"TOPLEFT", -- [3]
		5, -- [4]
		-5, -- [5]
	},
	["totembar"] = {
		"BOTTOM", -- [1]
		"UIParent", -- [2]
		"BOTTOM", -- [3]
		0, -- [4]
		166, -- [5]
	},
	["stancebar"] = {
		"BOTTOMLEFT", -- [1]
		"SunUIActionBar3", -- [2]
		"TOPLEFT", -- [3]
		0, -- [4]
		5, -- [5]
	},
	["vehicleexit"] = {
		"BOTTOM", -- [1]
		"UIParent", -- [2]
		"BOTTOM", -- [3]
		309.265986839721, -- [4]
		94.33438541715815, -- [5]
	},
	["CooldownFlash"] = {
		"TOP", -- [1]
		"UIParent", -- [2]
		"TOP", -- [3]
		-8.491911891911482, -- [4]
		-222.2246809593068, -- [5]
	},
	["petbar"] = {
		"BOTTOMRIGHT", -- [1]
		"SunUIActionBar3", -- [2]
		"TOPRIGHT", -- [3]
		0, -- [4]
		5, -- [5]
	},
	["extrabar"] = {
		"BOTTOM", -- [1]
		"UIParent", -- [2]
		"BOTTOM", -- [3]
		-189, -- [4]
		39, -- [5]
	},
	["bar4"] = {
		"RIGHT", -- [1]
		"UIParent", -- [2]
		"RIGHT", -- [3]
		-10, -- [4]
		0, -- [5]
	},
}
SkinDB = {
	["EnableDBMSkin"] = true,
	["EnableSkadaSkin"] = true,
	["EnablePallyPowerSkin"] = true,
	["EnableOmenSkin"] = true,
	["EnableQuartzSkin"] = true,
	["EnableBigWigsSkin"] = true,
	["EnableRecountSkin"] = true,
}
CoreVersion = 1204
InfoPanelDB = {
	["BottomHeight"] = 13,
	["OpenTop"] = true,
	["OpenBottom"] = true,
	["BottomWidth"] = 440,
}


MiniDB = {
	["ClassCDWidth"] = 140,
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
}