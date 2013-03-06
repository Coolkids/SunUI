local S, L, DB, _, C = unpack(select(2, ...))
DB.AuroraModules = {}
DB.AuroraModules["SunUI"] = {}
DB.media = {
	["arrowUp"] = "Interface\\AddOns\\SunUI\\media\\arrow-up-active",
	["arrowDown"] = "Interface\\AddOns\\SunUI\\media\\arrow-down-active",
	["arrowLeft"] = "Interface\\AddOns\\SunUI\\media\\arrow-left-active",
	["arrowRight"] = "Interface\\AddOns\\SunUI\\media\\arrow-right-active",
	["backdrop"] = "Interface\\ChatFrame\\ChatFrameBackground",
	["checked"] = "Interface\\AddOns\\SunUI\\media\\CheckButtonHilight",
	["glow"] = "Interface\\AddOns\\SunUI\\media\\glowTex",
}
DB.AuroraConfig = {
	["alpha"] = 0.5,
	["bags"] = true,
	["chatBubbles"] = true,
	["enableFont"] = true,
	["gradientAlpha"] = {"VERTICAL", 0, 0, 0, .3, .35, .35, .35, .35},
	["loot"] = true,
	["useCustomColour"] = false,
		["customColour"] = {r = 1, g = 1, b = 1},
	["map"] = true,
	["qualityColour"] = true,
	["tooltips"] = true,
}