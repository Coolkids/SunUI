local n = select(2, ...)
local S, _, L, DB = unpack(SunUI)
-- window settings
n.windowsettings = {
	-- pos = { "TOPLEFT", 4, -4 },
	pos = { "BOTTOMRIGHT", Minimap, "BOTTOMLEFT", -7, 0 },
	width = 200,
	maxlines = 9,
	backgroundalpha = 0,
	scrollbar = true,

	titleheight = 11,
	titlealpha = 0,
	titlefont = ChatFrame1:GetFont(),
	titlefontsize = 12,
	titlefontcolor = {1, .82, 0},
	buttonhighlightcolor = {1, 1, 1},

	lineheight = 11,
	linegap = 1,
	linealpha = 1,
	linetexture = "Interface\\Addons\\!SunUI\\media\\statusbar7",
	linefont = ChatFrame1:GetFont(),
	linefontsize = 12,
	linefontcolor = {1, 1, 1},
}

-- core settings
n.coresettings = {
	refreshinterval = 1,
	minfightlength = 15,
	combatseconds = 3,
	shortnumbers = true,
}

-- available types and their order
n.types = {
	{
		name = L["伤害"],
		id = "dd",
		c = {.25, .66, .35},
	},
	{
		name = L["伤害目标"],
		id = "dd",
		view = "Targets",
		onlyfights = true,
		c = {.25, .66, .35},
	},
	{
		name = L["伤害承受: 目标"],
		id = "dt",
		view = "Targets",
		onlyfights = true,
		c = {.66, .25, .25},
	},
	{
		name = L["伤害承受: 技能"],
		id = "dt",
		view = "Spells",
		c = {.66, .25, .25},
	},
	{
		name = L["队友误伤"],
		id = "ff",
		c = {.63, .58, .24},
	},
	{
		name = L["治疗及吸收"],
		id = "hd",
		id2 = "ga",
		c = {.25, .5, .85},
	},
--	{
--		name = "Healing Taken: Abilities",
--		id = "ht",
--		view = "Spells",
--		c = {.25, .5, .85},
--	},
--	{
--		name = "Healing",
--		id = "hd",
--		c = {.25, .5, .85},
--	},
--	{
--		name = "Guessed Absorbs",
--		id = "ga",
--		c = {.25, .5, .85},
--	},
	{
		name = L["过量治疗"],
		id = "oh",
		c = {.25, .5, .85},
	},
	{
		name = L["驱散"],
		id = "dp",
		c = {.58, .24, .63},
	},
	{
		name = L["打断"],
		id = "ir",
		c = {.09, .61, .55},
	},
	{
		name = L["法力获取"],
		id = "pg",
		c = {48/255, 113/255, 191/255},
	},
	{
		name = L["死亡记录"],
		id = "deathlog",
		view = "Deathlog",
		onlyfights = true,
		c = {.66, .25, .25},
	},
}
