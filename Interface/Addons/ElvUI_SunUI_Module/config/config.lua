local E, L, V, P, G = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local LSM = LibStub("LibSharedMedia-3.0")

P["quest_sunui"]={
	["autoquest"] = true
}

P["Chat_SunUI"]={
	ChannelBar = true,
}

P["Notifications"]={
	Notification = true,
	playSounds = false,
}

P["Announce"]={
	Open = true,
	Interrupt = false,
	Channel = true,
	Mislead = true,
	BaoM = true,
	Give = true,
	Resurrect = true,
	Heal = true,
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

--PowerBar设置 就是屏幕中间的那个条条
P["PowerBar"]={    
	Open = true,    --开关
	Width = 200,	--宽度
	Height = 5,		--高度
	Fade = true,	--脱离战斗渐隐
	HealthPower = true,    --开启血量/魔法值
	DisableText = true,		--开启血量/魔法值文字 true为隐藏文字 false为开启文字
	HealthPowerPer = true,		--血量百分比化
	ManaPowerPer = true,		--魔法值百分比化
}

P["SunUI_Modules"]={
	CooldownFlashSize = 48,
	CooldownFlash = true,

}