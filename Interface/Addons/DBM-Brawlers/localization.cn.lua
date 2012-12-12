-- Simplified Chinese by Diablohu(diablohudream@gmail.com)
-- Last update: 12/2/2012

if GetLocale() ~= "zhCN" then return end
local L

-----------------------
-- Brawlers --
-----------------------
L= DBM:GetModLocalization("Brawlers")

L:SetGeneralLocalization({
	name = "争斗者协会"
})

L:SetWarningLocalization({
	specWarnYourTurn	= "该你上场了！"
})

L:SetOptionLocalization({
	specWarnYourTurn	= "特殊警报：轮到玩家登场",
	SpectatorMode		= "在观看比赛时显示警报与计时条"
})

L:SetMiscLocalization({
	Bizmo			= "比兹莫",
	--I wish there was a better way to do this....so much localizing. :(
	EnteringArena1	= "请大家鼓掌欢迎——",
	EnteringArena2	= "现在进场的是一位",
	EnteringArena3	= "Look out... here comes",
	Victory1		= "is our victor",
	Victory2		= "Congratulations",
	Victory3		= "辉煌的胜利",
	Victory4		= "获胜！",
	Victory5		= "Keep 'em comin'",
	Victory6		= "Great job not dying",
	Lost1			= "were you even trying",
	Lost2			= "Now would you kindly remove your corpse",
	Lost3			= "So much blood! Nice",
	Lost4			= "Get back in line and try again",
	Lost5			= "you're gonna have to break a few eggs",
	Lost6			= "try not to die so much",
	Lost7			= "呃……真是一团糟",
	Lost8			= "His name was",--LoL at fight club reference here
})


------------
-- Rank 1 --
------------
L= DBM:GetModLocalization("BrawlRank1")

L:SetGeneralLocalization({
	name = "Rank 1"
})

------------
-- Rank 2 --
------------
L= DBM:GetModLocalization("BrawlRank2")

L:SetGeneralLocalization({
	name = "Rank 2"
})

------------
-- Rank 3 --
------------
L= DBM:GetModLocalization("BrawlRank3")

L:SetGeneralLocalization({
	name = "Rank 3"
})

------------
-- Rank 4 --
------------
L= DBM:GetModLocalization("BrawlRank4")

L:SetGeneralLocalization({
	name = "Rank 4"
})

------------
-- Rank 5 --
------------
L= DBM:GetModLocalization("BrawlRank5")

L:SetGeneralLocalization({
	name = "Rank 5"
})

------------
-- Rank 6 --
------------
L= DBM:GetModLocalization("BrawlRank6")

L:SetGeneralLocalization({
	name = "Rank 6"
})

------------
-- Rank 7 --
------------
L= DBM:GetModLocalization("BrawlRank7")

L:SetGeneralLocalization({
	name = "Rank 7"
})

------------
-- Rank 8 --
------------
L= DBM:GetModLocalization("BrawlRank8")

L:SetGeneralLocalization({
	name = "Rank 8"
})