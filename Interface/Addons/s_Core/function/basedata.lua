local S, C, L, DB = unpack(select(2, ...))

ActionBarDB = {
	["bar3"] = {
		["y"] = 96,
		["x"] = 0,
		["a2"] = "BOTTOM",
		["a1"] = "BOTTOM",
		["af"] = "UIParent",
	},
	["CooldownFlashSize"] = 64,
	["FontSize"] = 11,
	["MFontSize"] = 10,
	["PetBarSacle"] = 0.7,
	["ButtonSpacing"] = 1,
	["totembar"] = {
		["y"] = 166,
		["x"] = 0,
		["a2"] = "BOTTOM",
		["a1"] = "BOTTOM",
		["af"] = "UIParent",
	},
	["extrabar"] = {
		["y"] = 135,
		["x"] = -210,
		["a2"] = "BOTTOM",
		["a1"] = "BOTTOM",
		["af"] = "UIParent",
	},
	["ExtraBarSacle"] = 1.5,
	["TotemBarSacle"] = 1,
	["vehicleexit"] = {
		["y"] = 130,
		["x"] = 170,
		["a2"] = "BOTTOM",
		["a1"] = "BOTTOM",
		["af"] = "UIParent",
	},
	["Bar3Layout"] = 1,
	["Bar5Layout"] = 1,
	["Big4Layout"] = 1,
	["Bar2Layout"] = 1,
	["bar2"] = {
		["y"] = 60,
		["x"] = 0,
		["a2"] = "BOTTOM",
		["a1"] = "BOTTOM",
		["af"] = "UIParent",
	},
	["ButtonSize"] = 34,
	["bar1"] = {
		["y"] = 24,
		["x"] = 0,
		["a2"] = "BOTTOM",
		["a1"] = "BOTTOM",
		["af"] = "UIParent",
	},
	["StanceBarSacle"] = 1.3,
	["bar5"] = {
		["y"] = 0,
		["x"] = -38,
		["a2"] = "RIGHT",
		["a1"] = "RIGHT",
		["af"] = "UIParent",
	},
	["Bar1Layout"] = 1,
	["MainBarSacle"] = 1,
	["stancebar"] = {
		["y"] = 170,
		["x"] = 0,
		["a2"] = "BOTTOM",
		["a1"] = "BOTTOM",
		["af"] = "UIParent",
	},
	["HideHotKey"] = false,
	["CooldownFlash"] = true,
	["Style"] = 1,
	["Bar4Layout"] = 1,
	["petbar"] = {
		["y"] = 189,
		["x"] = 123,
		["a2"] = "BOTTOM",
		["a1"] = "BOTTOM",
		["af"] = "UIParent",
	},
	["HideMacroName"] = false,
	["bar4"] = {
		["y"] = 0,
		["x"] = -10,
		["a2"] = "RIGHT",
		["a1"] = "RIGHT",
		["af"] = "UIParent",
	},
}
BuffDB = {
	["WarningTime"] = 15,
	["BuffDirection"] = 1,
	["DebuffDirection"] = 1,
	["Spacing"] = 8,
	["IconSize"] = 36,
	["IconsPerRow"] = 12,
}
NameplateDB = {
	["HPHeight"] = 6,
	["CastBarWidth"] = 120,
	["Fontsize"] = 10,
	["HPWidth"] = 120,
	["CastBarHeight"] = 5,
	["CastBarIconSize"] = 20,
	["AuraTrack"] = true,
	["CCAuraTrack"] = true,
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
	["PetCastBarHeight"] = 10,
	["Scale"] = 1,
	["PowerHeight"] = 0.75,
	["Fontsize"] = 10,
	["TargetCastBarWidth"] = 240,
	["PetCastBarWidth"] = 180,
	["Icon"] = 24,
	["PowerColor"] = true,
	["PlayerCastBarHeight"] = 10,
	["OnlyShowPlayer"] = false,
	["PowerClass"] = false,
	["ClassColorbars"] = false,
	["Width"] = 240,
	["PlayerCastBarWidth"] = 460,
	["Bossframes"] = true,
	["TargetCastBarHeight"] = 10,
	["Portraits"] = false,
	["Height"] = 25,
	["FocusCastBarHeight"] = 10,
	["FontSize"] = 10,
	["FocusCastBarWidth"] = 200,
}
MoveHandleDB = {
	["Threat"] = {
		"CENTER", -- [1]
		"UIParent", -- [2]
		"CENTER", -- [3]
		-226.6984767144569, -- [4]
		-122.8096417540383, -- [5]
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
	["PlayerCastbar"] = {
		"CENTER", -- [1]
		"UIParent", -- [2]
		"CENTER", -- [3]
		0, -- [4]
		-335, -- [5]
	},
	["ClassCD"] = {
		"CENTER", -- [1]
		"UIParent", -- [2]
		"CENTER", -- [3]
		415, -- [4]
		-380, -- [5]
	},
	["Minimap"] = {
		"BOTTOMRIGHT", -- [1]
		"UIParent", -- [2]
		"BOTTOMRIGHT", -- [3]
		-9.809866448399959, -- [4]
		28.69835007600359, -- [5]
	},
	["InfoPanel"] = {
		"TOPLEFT", -- [1]
		"UIParent", -- [2]
		"TOPLEFT", -- [3]
		3.171168827794269, -- [4]
		-4.90486648600857, -- [5]
	},
	["Debuff"] = {
		"TOPRIGHT", -- [1]
		"UIParent", -- [2]
		"TOPRIGHT", -- [3]
		-5, -- [4]
		-140, -- [5]
	},
	["FocusCastbar"] = {
		"RIGHT", -- [1]
		"UIParent", -- [2]
		"RIGHT", -- [3]
		-99, -- [4]
		-165, -- [5]
	},
	["PetCastbar"] = {
		"CENTER", -- [1]
		"UIParent", -- [2]
		"CENTER", -- [3]
		-442.8375973977576, -- [4]
		-188.4295811563075, -- [5]
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
		-142.0132171705879, -- [4]
		215.949838043641, -- [5]
	},
	["ShadowPet"] = {
		"CENTER", -- [1]
		"UIParent", -- [2]
		"CENTER", -- [3]
		-423.31500029745, -- [4]
		-221.2541982493533, -- [5]
	},
	["Class"] = {
		"TOPLEFT", -- [1]
		"UIParent", -- [2]
		"TOPLEFT", -- [3]
		375.2405357927998, -- [4]
		-185.5203211638703, -- [5]
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
MiniDB = {
	["ClassCDWidth"] = 140,
	["AutoSell"] = true,
	["uiScale"] = 0.6999999880790701,
	["AutoRepair"] = true,
	["Icicle"] = false,
	["MiniMapPanels"] = true,
	["UIscale"] = false,
	["FastError"] = true,
	["Autoinvite"] = false,
	["Interrupt"] = true,
	["igonoreOld "] = false,
	["ClassCDOpen"] = false,
	["ClassFontSize"] = 15,
	["ClassCDDirection"] = 1,
	["AutoUIscale"] = false,
	["ChatFilter"] = true,
	["LockUIscale"] = false,
	["INVITE_WORD"] = "SunUI",
	["ClassCDHeight"] = 20,
}