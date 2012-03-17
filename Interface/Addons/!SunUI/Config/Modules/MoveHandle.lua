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
		["Debuff"] = {"TOPRIGHT", "UIParent", "TOPRIGHT", -5, -140},
		["Minimap"] = {"BOTTOMRIGHT", "UIParent", "BOTTOMRIGHT", -10, 29},
		["PlayerCastbar"] = {"CENTER","UIParent","CENTER",0,-335},
		["TargetCastbar"] = {"CENTER","UIParent","CENTER",226,-257},
		["FocusCastbar"] = {"RIGHT","UIParent","RIGHT",-99,-165},
		["ShadowPet"] = {"CENTER","UIParent","CENTER", -423, -223},
		["ClassCD"] = {"CENTER","UIParent","CENTER", 415, -380},
		["Threat"] = {"CENTER","UIParent","CENTER", -225, -133},
		["Reminder"] = {"BOTTOMRIGHT","UIParent","BOTTOMRIGHT", -52, 211},
		["Class"] = {"CENTER", "UIParent", "CENTER", -150, 150},
		["Combatpoint"] = {"CENTER","UIParent","CENTER",226,-297},
		["CooldownFlash"] = {"BOTTOM", "UIParent", "CENTER", 0, 150},
		["InfoPanel"] = {"TOPLEFT", "UIParent", "TOPLEFT", 5, -5},
		["InfoPanel2"] = {"TOPRIGHT", "Minimap", "BOTTOMRIGHT", 0, -5},
		["RollFrame"] = {"TOP", "UIParent", "TOP", 0, -200},
		["bar1"] = {"BOTTOM", "UIParent", "BOTTOM", 0, 10 },
		["bar2"] = {"BOTTOM", "SunUIActionBar1", "TOP", 0, 5},
		["bar3"] = {"BOTTOMRIGHT", "SunUIActionBar1", "BOTTOMLEFT", -4, 0}, 
		["bar32"] = {"BOTTOMLEFT", "SunUIActionBar1", "BOTTOMRIGHT", 4, 0}, 
		["bar4"] = {"RIGHT", "UIParent", "RIGHT", -10, 0 }, 
		["bar51"] = {"CENTER", "UIParent", "CENTER", 0, 0}, 
		["bar52"] = {"CENTER", "UIParent", "CENTER", 39, 0 }, 
		["bar53"] = {"CENTER", "UIParent", "CENTER", -39, 0 }, 
		["bar54"] = {"CENTER", "UIParent", "CENTER", -78, 0 }, 
		["bar5"] = {"CENTER", "UIParent", "CENTER", 0, 0 }, 
		["stancebar"] = {"BOTTOMLEFT", "MultiBarBottomRightButton6", "TOPLEFT", 0, 3}, 
		["petbar"] = {"BOTTOMRIGHT", "MultiBarBottomRightButton12", "TOPRIGHT", 0, 3}, 
		["extrabar"] = {"BOTTOM", "UIParent", "BOTTOM", -189, 39 },
		["totembar"] = {"BOTTOM", "UIParent", "BOTTOM", 0, 166 }, 
		["vehicleexit"] = {"BOTTOM", "UIParent", "BOTTOM", 311, 96 }, 
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