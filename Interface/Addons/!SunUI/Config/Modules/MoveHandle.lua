-- Engines
local S, C, L, DB = unpack(select(2, ...))
local Core = LibStub("AceAddon-3.0"):GetAddon("Core")

-- Init
DB["Modules"]["MoveHandle"] = {}
local Module = DB["Modules"]["MoveHandle"]

-- LoadSettings
function Module.LoadSettings()
	local Default = {
		["Buff"] = {"TOPRIGHT", "UIParent", "TOPRIGHT", -5, -5},
		["Debuff"] = {"TOPRIGHT", "UIParent", "TOPRIGHT", -5, -110},
		["Minimap"] = {"BOTTOMRIGHT", "UIParent", "BOTTOMRIGHT", -5, 25},
		["ShadowPet"] = {"BOTTOM","UIParent","BOTTOM", -316, 201},
		["ClassCD"] = {"BOTTOMRIGHT","UIParent","BOTTOMRIGHT", -336, 130},
		["Combatpoint"] = {"CENTER", "UIParent", "CENTER", 133, -139},
		["Threat"] = {"BOTTOM", "UIParent", "BOTTOM", -175, 262},
		["Reminder"] = {"BOTTOMLEFT","Minimap","TOPLEFT", 0, 30},
		["Class"] = {"CENTER", "UIParent", "CENTER", -150, 150},
		--["Combatpoint"] = {"CENTER", "UIParent", "CENTER", 133, -178},
		["CooldownFlash"] = {"CENTER", "UIParent", "CENTER", 0, -130},
		["InfoPanel"] = {"TOPLEFT", "UIParent", "TOPLEFT", 5, -5},
		["InfoPanel2"] = {"TOPRIGHT", "Minimap", "BOTTOMRIGHT", 0, -5},
		["RollFrame"] = {"TOP", "UIParent", "TOP", 0, -200},
		["bar1"] = {"BOTTOM", "UIParent", "BOTTOM", 0, 10 },
		["bar2"] = {"BOTTOM", "SunUIActionBar1", "TOP", 0, 4},
		["bar3"] = {"BOTTOMRIGHT", "SunUIActionBar1", "BOTTOMLEFT", -4, 0}, 
		["bar32"] = {"BOTTOMLEFT", "SunUIActionBar1", "BOTTOMRIGHT", 4, 0}, 
		["bar4"] = {"RIGHT", "UIParent", "RIGHT", -10, 0 }, 
		["bar51"] = {"BOTTOM", "MultiBarBottomLeftButton4", "TOP", 0, 4}, 
		["bar52"] = {"BOTTOM", "MultiBarBottomLeftButton5", "TOP", 0, 4 }, 
		["bar53"] = {"BOTTOMRIGHT", "MultiBarBottomRightButton3", "BOTTOMLEFT", -4, 0 }, 
		["bar54"] = {"BOTTOMLEFT", "MultiBarBottomRightButton9", "BOTTOMRIGHT", 4, 0 }, 
		["bar5"] = {"CENTER", "UIParent", "CENTER", 0, 0 }, 
		["stancebar"] = {"BOTTOMLEFT", "MultiBarBottomRightButton6", "TOPLEFT", 0, 4}, 
		["petbar"] = {"BOTTOMRIGHT", "MultiBarBottomRightButton12", "TOPRIGHT", 0, 4}, 
		["extrabar"] = {"BOTTOM", "UIParent", "BOTTOM", -184, 44 },
		["totembar"] = {"BOTTOM", "UIParent", "BOTTOM", 0, 100 }, 
		["vehicleexit"] = {"BOTTOM", "UIParent", "BOTTOM", 278, 66 }, 
		["PlayerFrame"] = {"BOTTOM", "UIParent", "BOTTOM", -175, 172},
		["TargetFrame"] = {"BOTTOM", "UIParent", "BOTTOM", 175, 172},
		["ToTFrame"] = {"BOTTOM", "UIParent", "BOTTOM", 0, 190},
		["FocusFrame"] = {"RIGHT", "UIParent", "RIGHT", -57, -138},
		["FocusTFrame"] = {"TOP", "oUF_SunUIFocus", "BOTTOM", 0, -30},
		["PetFrame"] = {"TOPRIGHT", "oUF_SunUIPlayer", "TOPLEFT", -5, 0},
		["PartyFrame"] = {"BOTTOMLEFT", "UIParent", "BOTTOMLEFT", 120, 362},
		["ArenaFrame"] = {"RIGHT", "UIParent", "RIGHT", -50, -60},
		["BossFrame"] = {"RIGHT", "UIParent", "RIGHT", -50, -60},
		["PlayerCastbar"] = {"BOTTOM","UIParent","BOTTOM",0,105},
		["TargetCastbar"] = {"TOP","oUF_SunUITarget","BOTTOM",0,-30},
		["FocusCastbar"] = {"TOP","oUF_SunUIFocus","BOTTOM",0,-20},
	}
	if not MoveHandleDB then MoveHandleDB = {} end
	for key, value in pairs(Default) do
		if MoveHandleDB[key] == nil then MoveHandleDB[key] = value end
	end
	wipe(Default)
end

-- ResetToDefault
function Module.ResetToDefault()
	wipe(MoveHandleDB)
end

-- BuildGUI
function Module.BuildGUI() end