local S, C, L, DB = unpack(select(2, ...))

ActionBarDB = {
	["bar3"] = {
		["y"] = 96,
		["x"] = 0,
		["a2"] = "BOTTOM",
		["a1"] = "BOTTOM",
		["af"] = "UIParent",
	},
	["FontSize"] = 11,
	["MFontSize"] = 10,
	["PetBarSacle"] = 0.7,
	["ButtonSpacing"] = 2,
	["ExtraBarSacle"] = 1.5,
	["CooldownFlashSize"] = 76,
	["extrabar"] = {
		["y"] = 135,
		["x"] = -210,
		["a2"] = "BOTTOM",
		["a1"] = "BOTTOM",
		["af"] = "UIParent",
	},
	["Big4Layout"] = 1,
	["CooldownFlash"] = true,
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
	["stancebar"] = {
		["y"] = 170,
		["x"] = 0,
		["a2"] = "BOTTOM",
		["a1"] = "BOTTOM",
		["af"] = "UIParent",
	},
	["Bar2Layout"] = 1,
	["Bar4Layout"] = 1,
	["bar2"] = {
		["y"] = 60,
		["x"] = 0,
		["a2"] = "BOTTOM",
		["a1"] = "BOTTOM",
		["af"] = "UIParent",
	},
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
	["HideHotKey"] = false,
	["MainBarSacle"] = 1,
	["Bar1Layout"] = 1,
	["Style"] = 1,
	["ButtonSize"] = 34,
	["HideMacroName"] = false,
	["petbar"] = {
		["y"] = 189,
		["x"] = 123,
		["a2"] = "BOTTOM",
		["a1"] = "BOTTOM",
		["af"] = "UIParent",
	},
	["totembar"] = {
		["y"] = 166,
		["x"] = 0,
		["a2"] = "BOTTOM",
		["a1"] = "BOTTOM",
		["af"] = "UIParent",
	},
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
	["IconPerRow"] = 16,
	["IconsPerRow"] = 12,
}
NameplateDB = {
	["CastBarHeight"] = 6,
	["HPWidth"] = 130,
	["enable"] = true,
	["CCAuraTrack"] = true,
	["HPHeight"] = 10,
	["CastBarIconSize"] = 23,
	["Fontsize"] = 9,
	["AuraTrack"] = true,
	["CastBarWidth"] = 130,
	["Showdebuff"] = true,
	["Combat"] = true,
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
	["PowerHeight"] = 0.7999999999999999,
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
	["Height"] = 25,
	["Portraits"] = false,
	["FocusCastBarHeight"] = 10,
	["FontSize"] = 10,
	["FocusCastBarWidth"] = 200,
}
MoveHandleDB = {
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
	["CooldownFlash"] = {
		"CENTER", -- [1]
		"UIParent", -- [2]
		"CENTER", -- [3]
		224.1842192896622, -- [4]
		238.2529801406015, -- [5]
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
		-23.12885107058042, -- [4]
		192.1724864967988, -- [5]
	},
	["Threat"] = {
		"CENTER", -- [1]
		"UIParent", -- [2]
		"CENTER", -- [3]
		-226.6984767144569, -- [4]
		-122.8096417540383, -- [5]
	},
	["FocusCastbar"] = {
		"RIGHT", -- [1]
		"UIParent", -- [2]
		"RIGHT", -- [3]
		-99, -- [4]
		-165, -- [5]
	},
	["ClassCD"] = {
		"CENTER", -- [1]
		"UIParent", -- [2]
		"CENTER", -- [3]
		415, -- [4]
		-380, -- [5]
	},
	["InfoPanel"] = {
		"TOPLEFT", -- [1]
		"UIParent", -- [2]
		"TOPLEFT", -- [3]
		4.679353760963765, -- [4]
		-3.206483724702225, -- [5]
	},
	["PetCastbar"] = {
		"CENTER", -- [1]
		"UIParent", -- [2]
		"CENTER", -- [3]
		-442.8375973977576, -- [4]
		-188.4295811563075, -- [5]
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
	["Debuff"] = {
		"TOPRIGHT", -- [1]
		"UIParent", -- [2]
		"TOPRIGHT", -- [3]
		-5, -- [4]
		-140, -- [5]
	},
	["RollFrame"] = {
		"TOP", -- [1]
		"UIParent", -- [2]
		"TOP", -- [3]
		-8.491578200954438, -- [4]
		-256.0460909266831, -- [5]
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