if GetLocale() ~= "zhTW" then return end

local L

------------
--  Omen  --
------------
L = DBM:GetModLocalization("Omen")

L:SetGeneralLocalization({
	name = "年獸"
})

-----------------------
--  Apothecary Trio  --
-----------------------
L = DBM:GetModLocalization("ApothecaryTrio")

L:SetGeneralLocalization({
	name 			= "藥劑師三人組"
})

L:SetTimerLocalization({
	HummelActive		= "胡默爾 開始活動",
	BaxterActive		= "巴克斯特 開始活動",
	FryeActive		= "弗萊伊 開始活動"
})

L:SetOptionLocalization({
	TrioActiveTimer		= "為藥劑師三人組開始活動顯示計時器"
})

L:SetMiscLocalization({
	SayCombatStart		= "他們有告訴你我是誰還有我為什麼這麼做嗎?"
})

-------------
--  Ahune  --
-------------
L = DBM:GetModLocalization("Ahune")

L:SetGeneralLocalization({
	name 			= "艾胡恩"
})

L:SetWarningLocalization({
	Submerged		= "艾胡恩已隱沒",
	Emerged			= "艾胡恩已現身",
	specWarnAttack		= "艾胡恩擁有易傷 - 現在攻擊!"
})

L:SetTimerLocalization({
	SubmergTimer		= "隱沒",
	EmergeTimer		= "現身",
	TimerCombat		= "戰鬥開始"
})

L:SetOptionLocalization({
	Submerged		= "當艾胡恩隱沒時顯示警告",
	Emerged			= "當艾胡恩現身時顯示警告",
	specWarnAttack		= "當艾胡恩擁有易傷時顯示特別警告",
	SubmergTimer		= "為隱沒顯示計時器",
	EmergeTimer		= "為現身顯示計時器",
	TimerCombat		= "為戰鬥開始顯示計時器"
})

L:SetMiscLocalization({
	Pull			= "冰石已經溶化了!"
})

----------------------
--  Coren Direbrew  --
----------------------
L = DBM:GetModLocalization("CorenDirebrew")

L:SetGeneralLocalization({
	name 			= "寇仁·恐酒"
})

L:SetWarningLocalization({
	specWarnBrew		= "在他再丟你一個前喝掉酒!",
	specWarnBrewStun	= "提示:你瘋狂了,記得下一次喝啤酒!"
})

L:SetOptionLocalization({
	specWarnBrew		= "為$spell:47376顯示特別警告",
	specWarnBrewStun	= "為$spell:47340顯示特別警告",
	YellOnBarrel		= "當你中了$spell:51413時大喊"
})

L:SetMiscLocalization({
	YellBarrel		= "我中了空桶(暈)"
})

-------------------------
--  Headless Horseman  --
-------------------------
L = DBM:GetModLocalization("HeadlessHorseman")

L:SetGeneralLocalization({
	name 			= "無頭騎士"
})

L:SetWarningLocalization({
	WarnPhase				= "階段 %d",
	warnHorsemanSoldiers	= "跳動的南瓜出現了!",
	warnHorsemanHead	= "躲開旋風斬 - 快打頭顱!"
})

L:SetTimerLocalization{
	TimerCombatStart		= "戰鬥開始"
}

L:SetOptionLocalization({
	WarnPhase				= "為每次階段轉換顯示警告",
	TimerCombatStart		= "為戰鬥開始顯示計時器",
	warnHorsemanSoldiers	= "為跳動的南瓜出現顯示警告",
	warnHorsemanHead	= "為騎士頭顱出現顯示警告"
})

L:SetMiscLocalization({
	HorsemanSummon			= "騎士甦醒...",
	HorsemanSoldiers	= "士兵們起立，挺身奮戰!讓這個位死去的騎士得到最後的勝利!"
})

------------------------------
--  The Abominable Greench  --
------------------------------
L = DBM:GetModLocalization("Greench")

L:SetGeneralLocalization({
	name = "可惡的格林奇"
})

--------------------------
--  Blastenheimer 5000  --
--------------------------
L = DBM:GetModLocalization("Cannon")

L:SetGeneralLocalization({
	name = "衝擊者5000型超級大砲"
})

-------------
--  Gnoll  --
-------------
L = DBM:GetModLocalization("Gnoll")

L:SetGeneralLocalization({
	name = "痛扁豺狼人"
})

L:SetWarningLocalization({
	warnGameOverQuest	= "獲得%d點，此次最多可能取得%d點。",
	warnGameOverNoQuest	= "此次遊戲最多可能取得%d點。",
	warnGnoll		= "豺狼人出現",
	warnHogger		= "霍格出現",
	specWarnHogger	= "霍格出現!"
})

L:SetOptionLocalization({
	warnGameOver		= "當遊戲結束時顯示最多可以取得的點數",
	warnGnoll		= "當豺狼人出現時顯示警告",
	warnHogger		= "當霍格出現時顯示警告",
	specWarnHogger	= "當霍格出現時顯示特別警告"
})

------------------------
--  Shooting Gallery  --
------------------------
L = DBM:GetModLocalization("Shot")

L:SetGeneralLocalization({
	name = "打靶場"
})

L:SetOptionLocalization({
	SetBubbles			= "為$spell:101871自動禁用對話泡泡"
})

----------------------
--  Tonk Challenge  --
----------------------
L = DBM:GetModLocalization("Tonks")

L:SetGeneralLocalization({
	name = "坦克的挑戰"
})
