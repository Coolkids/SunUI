local n = select(2, ...)
-- window settings
n.windowsettings = {
	-- pos = { "TOPLEFT", 4, -4 },
	pos = { "BOTTOMRIGHT", Minimap, "BOTTOMLEFT", -5, 0 },
	width = 290,
	maxlines = 8,
	backgroundalpha = 0,
	scrollbar = true,

	titleheight = 15,
	titlealpha = 0,
	titlefont = ChatFrame1:GetFont(),
	titlefontsize = 16,
	titlefontcolor = {1, .82, 0},
	buttonhighlightcolor = {1, 1, 1},

	lineheight = 14,
	linegap = 1,
	linealpha = 1,
	linetexture = "Interface\\Addons\\s_Core\\media\\statusbar7",
	linefont = ChatFrame1:GetFont(),
	linefontsize = 16,
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
		name = "伤害",
		id = "dd",
		c = {.25, .66, .35},
	},
	{
		name = "伤害目标",
		id = "dd",
		view = "Targets",
		onlyfights = true,
		c = {.25, .66, .35},
	},
	{
		name = "伤害承受: 目标",
		id = "dt",
		view = "Targets",
		onlyfights = true,
		c = {.66, .25, .25},
	},
	{
		name = "伤害承受: 技能",
		id = "dt",
		view = "Spells",
		c = {.66, .25, .25},
	},
	{
		name = "队友误伤",
		id = "ff",
		c = {.63, .58, .24},
	},
	{
		name = "治疗及吸收",
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
		name = "过量治疗",
		id = "oh",
		c = {.25, .5, .85},
	},
	{
		name = "驱散",
		id = "dp",
		c = {.58, .24, .63},
	},
	{
		name = "打断",
		id = "ir",
		c = {.09, .61, .55},
	},
	{
		name = "法力获取",
		id = "pg",
		c = {48/255, 113/255, 191/255},
	},
	{
		name = "死亡记录",
		id = "deathlog",
		view = "Deathlog",
		onlyfights = true,
		c = {.66, .25, .25},
	},
}
