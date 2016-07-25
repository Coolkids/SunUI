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