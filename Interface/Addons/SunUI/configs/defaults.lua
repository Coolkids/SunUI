--插件默认设置  P角色设置G共公设置
local S, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB

G["media"]={
	font = "SunUI Font",
	dmgfont = "SunUI Combat",
	fontsize = 12,
	fontflag = "THINOUTLINE",
	gloss = "SunUI Gloss",
	blank = "SunUI Blank",
	normal = "SunUI Normal",
	cdfont = "SunUI Roadway",
	pxfont = "SunUI PIXEL",
	glow = "SunUI GlowBorder",
	backdropcolor = { .1, .1, .1 },
	backdropfadecolor = { .04, .04, .04, .7 },
	bordercolor = { 0, 0, 0 },
}
P["layout"]={
	mainLayout = 1,
}

G["general"]={
	uiscale = 0.75,
	theme = "Shadow",
}

P["ActionBar"]={
	FontSize = 12,
	MFontSize = 10,
	ButtonSpacing = 4,
	CooldownFlashSize = 48,
	CooldownFlash = true,
	Bar4Layout = 1,
	Bar1Layout = 1,
	Bar3Layout = 2,
	Bar5Layout = 1,
	Bar2Layout = 1,
	Big4Layout = 1,
	ButtonSize = 24,
	HideMacroName = false,
	BigSize2 = 24,
	BigSize3 = 52,
	BigSize1 = 24,
	BigSize4 = 52,
	HideHotKey = false,
	AllFade = false,
	Bar1Fade = false,
	Bar2Fade = false,
	Bar3Fade = false,
	Bar4Fade = false,
	Bar5Fade = false,
	StanceBarFade = false,
	PetBarFade = false,
	CooldownAlhpa = 0.6,
}

P["Bags"]={
	BagSize = 32,
	BankSize = 32,
	Spacing = 5,
	BagWidth = 400,
	BankWidth = 580,
	EquipType = true,
}

P["Buff"]={
	IconSize = 28,
	BuffDirection = 1,
	DebuffDirection = 1,
	IconPerRow = 16,
}

P["Chat"]={
	DNDFilter = false,
	TimeStamps = true,
	ChatBackground = false,
	ChatEditBoxColor = false,
	ChannelBar = true,
	ChatFilter = true,
}

P["NamePlates"]={
	enable = true,
	HPWidth = 125,
	Showdebuff = true,
	HPHeight = 8,
	Fontsize = 9,
	IconSize = 15,
	classicon = true,
	enhancethreat = true,
	health_value = true,
	health_value_config = 2,
	castbar_name = true,
}

P["PowerBar"]={
	Open = true,
	Width = 200,
	Height = 5,
	Fade = true,
	HealthPower = true,
	DisableText = true,
	HealthPowerPer = false,
	ManaPowerPer = false,	
}

P["Quest"]={
	AutoQuest = true,
	QuestGuru = true,
}

P["Tooltip"]={
	ScaleSize = 1,
	HideInCombat = false,
	Cursor = true,
	HideTitles = true,
}

P["MiniTools"]={
	AutoSell = true,
	AutoRepair = true,
	FastError = true,
	HideRaidWarn = true,
	Disenchat = true,
	Resurrect = true,
	LowHealth = true,
	LowHealthPer = 0.3,
	afklock = true,
	combat = false,
	currencycap = true,
}

P["Notifications"]={
	Notification = true,
	playSounds = false,
}

P["UnitFrames"]={
	layout = 2, --DPS/TANK   1为治疗
	healerClasscolours = false,				-- colour unitframes by class in healer layout
	absorb = true, 							-- absorb bar/over absorb glow
	castbarSeparate = true, 				-- true for a separate player cast bar
	castbarSeparateOnlyCasters = false, 		-- separate bar only for mages/warlocks/priests
	targettarget = true, 					-- show target of target frame
	enableArena = true,					-- enable arena/flag carrier frames
	hideblz = true,
	powerbar = false,
	auraFilter = false,
	altPowerHeight = 1,
	powerHeight = 1,
	playerWidth = 229,
	playerHeight = 14,
	targetWidth = 229,
	targetHeight = 14,
	targettargetWidth = 229,
	targettargetHeight = 8,
	focusWidth = 113,
	focusHeight = 8,
	focusTargetWidth = 113,
	focusTargetHeight = 8,
	petWidth = 113,
	petHeight = 8,
	bossWidth = 170,
	bossHeight = 14,
	arenaWidth = 229,
	arenaHeight = 14,
	num_player_debuffs = 8,
	num_target_debuffs = 16,
	num_target_buffs = 16,
	num_boss_buffs = 4,
	num_arena_buffs = 8,
	num_focus_debuffs = 4,
	playerbuffsize = 26,
	targetbuffsize = 13,
	focusbuffsize = 22,
	bossbuffsize = 26,
	arenabuffsize = 26,
	fader = false,
	castbarwidth = 220,
	castbarheight = 14,
}

P["InfoBar"]={
	infobar1 = true, 	
		topback = true, 	
		latency = true, 	
		fps = true, 	
		memory = true, 	
		currenry = true, 	
	infobar2 = true, 	
		bottomback = true, 	
		clock = true, 	
		durability = true, 	
		dungeonhelper = true, 	
		specs = true, 	
}

P["BufferReminder"]={
	ShowRaidBuff = true, 	
		ShowOnlyInParty = true, 	
		RaidBuffDirection = 1, 	
	ShowClassBuff = true, 	
		ClassBuffSize = 32,
}

P["Announce"]={
	Open = true,
	Interrupt = true,
	Channel = true,
	Mislead = true,
	BaoM = true,
	Give = true,
	Resurrect = true,
	Heal = true,
}

P["AutoEquipment"] = {
	Enable = true,
	bindLayout = true,
	FirstLayout = 1,
	SecondLayout = 2,
}
P["ClassAT"] = {
	Enable = true,
	Icon = true,
	Size = 48,
}

P["ClassCD"] = {
	ClassCDOpen = true,
	ClassCDIcon = false,
	ClassCDIconSize = 25,
	ClassCDIconDirection = 1,
	ClassCDHeight = 8,
	ClassCDWidth = 100,
	ClassCDDirection = 1,
}
P["RaidCD"] = {
	RaidCD = true,
	RaidCDWidth = 100,
	RaidCDHeight = 8,
	RaidCDDirection = 1,
	RowNum = 10,
	MaxNumber = 30,
	RowDirection = "right",
}

P["Filger"] = {

}

P["SunUI_RaidFrameGUISuppest"] = {
	
}

P["SunUI_LayoutManger"] = {
	
}