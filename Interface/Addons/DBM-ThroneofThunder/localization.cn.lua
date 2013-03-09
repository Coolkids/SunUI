-- Simplified Chinese by Diablohu(diablohudream@gmail.com)
-- Last update: 3/2/2013

if GetLocale() ~= "zhCN" then return end
local L

--------------------------
-- Jin'rokh the Breaker --
--------------------------
L= DBM:GetModLocalization(827)

L:SetWarningLocalization({
	SpecWarnJSA			= ">>> 注意减伤 <<<"
})

L:SetOptionLocalization({
	SoundWOP			= "语音警告：重要技能",
	SpecWarnJSA			= "特殊警告：注意减伤",
	dr1					= "减伤提示:$spell:137313 1-1 [开始时提示]",
	dr2					= "减伤提示:$spell:137313 1-2 [八秒时提示]",
	dr3					= "减伤提示:$spell:137313 2-1",
	dr4					= "减伤提示:$spell:137313 2-2",
	dr5					= "减伤提示:$spell:137313 3-1",
	dr6					= "减伤提示:$spell:137313 3-2",
	dr7					= "减伤提示:$spell:137313 4-1",
	dr8					= "减伤提示:$spell:137313 4-2",
	RangeFrame			= "距离监视"
})


--------------
-- Horridon --
--------------
L= DBM:GetModLocalization(819)

L:SetWarningLocalization({
	warnAdds		= "%s",
	specWarnOrb		= ">>支配宝珠<<"
})

L:SetTimerLocalization({
	timerDoor		= "下一个部族大门",
	timerAdds		= "下一次%s"
})

L:SetOptionLocalization({
	SoundWOP			= "语音警告：重要技能",
	SoundDB				= "语音警告：$spell:136741",
	SoundOrb			= "语音警告：$journal:7092",
	specWarnOrb			= "特别警告：$journal:7092",
	warnAdds		= "警报：新的敌人加入战斗",
	timerDoor		= "计时条：下一个部族大门阶段",
	timerAdds		= "计时条：下一次小怪"
})

L:SetMiscLocalization({
	newForces		= "的门蜂拥而出!",--Farraki forces pour from the Farraki Tribal Door!
	controlOrb		= "支配宝珠",
	chargeTarget	= "用力拍动尾巴!"--Horridon sets his eyes on Eraeshio and stamps his tail!
})

---------------------------
-- The Council of Elders --
---------------------------
L= DBM:GetModLocalization(816)

L:SetOptionLocalization({
	SoundWOP		= "语音警告：重要技能",
	Soundspirit		= "倒计时：女祭司的各种魂灵",
	HudMAP			= "高级定位监视(HUD)：$spell:136992",
	HudMAP2			= "高级定位监视(HUD)：$spell:136922",
	warnPossessed	= DBM_CORE_AUTO_ANNOUNCE_OPTIONS.target:format(136442),
	warnSandBolt	= DBM_CORE_AUTO_ANNOUNCE_OPTIONS.target:format(136189),
	RangeFrame		= "距离监视"
})

------------
-- Tortos --
------------
L= DBM:GetModLocalization(825)

L:SetWarningLocalization({
	warnKickShell			= "%s由>%s<使用（%d次剩余）",
	specWarnCrystalShell	= "快去获得%s"
})

L:SetOptionLocalization({
	warnKickShell			= DBM_CORE_AUTO_ANNOUNCE_OPTIONS.spell:format(134031),
	SoundWOP				= "语音警告：重要技能",	
	SoundAE					= "倒计时：$spell:133939",	
	dr1						= "减伤提示:$spell:134920 1/4",
	dr2						= "减伤提示:$spell:134920 2/4",
	dr3						= "减伤提示:$spell:134920 3/4",
	dr4						= "减伤提示:$spell:134920 4/4",
	specWarnCrystalShell	= "特殊警报：当没有$spell:137633效果时",
	InfoFrame				= "信息框：没有$spell:137633效果的团员"
})

L:SetMiscLocalization({
	WrongDebuff		= "没有%s"
})

-------------
-- Megaera --
-------------
L= DBM:GetModLocalization(821)

L:SetOptionLocalization({
	SoundWOP		= "语音警告：重要技能",
	HudMAP			= "高级定位监视(HUD)：$spell:139822",
	HudMAP2			= "高级定位监视(HUD)：$spell:139889",
	dr1				= "减伤提示:$spell:139458 1",
	dr2				= "减伤提示:$spell:139458 2",
	dr3				= "减伤提示:$spell:139458 3",
	dr4				= "减伤提示:$spell:139458 4",
	dr5				= "减伤提示:$spell:139458 5",
	dr6				= "减伤提示:$spell:139458 6",
	dr7				= "减伤提示:$spell:139458 7",
	dr8				= "减伤提示:$spell:139458 8",
	InfoFrame		= "资讯框：$journal:7006"
})

L:SetMiscLocalization({
	rampageEnds		= "梅贾拉的怒气平息了。",
	Behind			= "迷雾中: "
})

------------
-- Ji-Kun --
------------
L= DBM:GetModLocalization(828)

L:SetWarningLocalization({
	warnFlock		= "%s %s (%d)",
	specWarnFlock	= "%s %s (%d)"
})

L:SetTimerLocalization({
	timerFlockCD	= "第%d波: %s"
})

L:SetOptionLocalization({
	SoundWOP		= "语音警告：重要技能",
	warnFlock		= DBM_CORE_AUTO_ANNOUNCE_OPTIONS.count:format("ej7348"),
	specWarnFlock	= DBM_CORE_AUTO_SPEC_WARN_OPTIONS.switch:format("ej7348"),
	timerFlockCD	= DBM_CORE_AUTO_TIMER_OPTIONS.nextcount:format("ej7348"),
	RangeFrame		= "距离监视(8码)：$spell:138923"
})

L:SetMiscLocalization({
	eggsHatchL		= "The eggs in one of the lower nests begin to hatch!",
	eggsHatchU		= "The eggs in one of the upper nests begin to hatch!",
	U				= "上方",
	L				= "下方",
	UAndL			= "上方 & 下方"
})

--------------------------
-- Durumu the Forgotten --
--------------------------
L= DBM:GetModLocalization(818)

L:SetWarningLocalization({
	warnAddsLeft			= "迷雾剩餘: %d",
	specWarnFogRevealed		= "%s 出现!",
	specWarnDisintegrationBeam	= "%s (%s)",
	specWarnDisintegrationBeamL	= "← ← ←左左左",
	specWarnDisintegrationBeamR	= "右右右→ → →"
})

L:SetOptionLocalization({
	SoundWOP					= "语音警告：重要技能",
	HudMAP						= "高级定位监视(HUD)：$spell:133775时指向$journal:6901分界线",
	warnAddsLeft				= "警告：迷雾剩餘数量",
	specWarnFogRevealed			= "特别警告：迷雾被发现",
	specWarnDisintegrationBeam	= DBM_CORE_AUTO_SPEC_WARN_OPTIONS.spell:format("ej6882"),
	ArrowOnBeam					= "DBM箭头：$journal:6882的转动方向",
	specWarnDisintegrationBeamL			= "特殊警告：左转$spell:133775",
	specWarnDisintegrationBeamR			= "特殊警告：右转$spell:136316",
	SetIconRays					= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format("ej6891")
})

L:SetMiscLocalization({
	Eye		= "Eye"--What to localize here, "<72.0 20:04:19> [CHAT_MSG_MONSTER_EMOTE] CHAT_MSG_MONSTER_EMOTE#The Bright  Light reveals an Amber Fog!#Amber Fog###--------->Yellow Eye<---------##0#0##0#309#nil#0#false#false", -- [13413]
})

----------------
-- Primordius --
----------------
L= DBM:GetModLocalization(820)

L:SetOptionLocalization({
	SoundWOP		= "语音警告：重要技能",
	InfoFrame		= "资讯框：首领当前的$journal:6949技能",
	RangeFrame		= "显示距离框架(2码/5码)",
	SetIconOnBadOoze	= "为$spell:140506自动标记"
})

L:SetMiscLocalization({
	BossSpellInfo 	= "进化技能分析表",
	AE1				= "持续性AE",
	AE2				= "週期性AE (15s)",
	tar5			= "分散5码 (3s)",
	tar1			= "病原体点名 (30s)",
	speed			= "速度提升50%",
	tar2			= "分散2码 (10s)",
})

-----------------
-- Dark Animus --
-----------------
L= DBM:GetModLocalization(824)

L:SetWarningLocalization({
	warnMatterSwapped	= "%s：>%s<、>%s<交换"
})

L:SetOptionLocalization({
	SoundWOP			= "语音警告：重要技能",
	RangeFrame			= "显示距离框架(8码)",
	warnMatterSwapped	= "警报：$spell:138618交换的目标"
})

L:SetMiscLocalization({
	Pull		= "The orb explodes!"
})

--------------
-- Iron Qon --
--------------
L= DBM:GetModLocalization(817)

L:SetWarningLocalization({
	warnDeadZone	= "%s: %s / %s "
})

L:SetOptionLocalization({
	warnDeadZone	= DBM_CORE_AUTO_ANNOUNCE_OPTIONS.spell:format(137229),
	SoundWOP		= "语音警告：重要技能",
	SoundARAT		= "语音警告：报出$spell:137231的攻击方位",
	ReapetAP		= "特殊功能：若你中了$spell:136192则不停呼救",
	HudMAP			= "高级定位监视(HUD)：$spell:136192",
	RangeFrame		= "距离监视（动态，当存在多名团员过近时显示）",
	InfoFrame		= "信息框：$spell:136193"
})

L:SetMiscLocalization({
	Helpme			= "拉我一把 ~~~"
})

-------------------
-- Twin Consorts --
-------------------
L= DBM:GetModLocalization(829)

L:SetOptionLocalization({
	SoundWOP			= "语音警告：重要技能",
	HudMAP				= "高级定位监视(HUD)：$journal:7651星座辅助线",
	HudMAP2				= "高级定位监视(HUD)：$spell:136752",
	RangeFrame			= "距离监视(8码)"
})

L:SetMiscLocalization({
	DuskPhase		= "Lu'lin! Lend me your strength!"--Not in use, but a backup just in case, so translate in case it's switched to on moments notice on live or next PTR test
})

--------------
-- Lei Shen --
--------------
L= DBM:GetModLocalization(832)

L:SetOptionLocalization({
	SoundWOP		= "语音警告：重要技能",
	HudMAP			= "高级定位监视(HUD)：$spell:135695",
	HudMAP2			= "高级定位监视(HUD)：$spell:136295",
	RangeFrame		= "距离监视"--For two different spells
})

------------
-- Ra-den --
------------
L= DBM:GetModLocalization(831)

-------------
--  Trash  --
-------------
L = DBM:GetModLocalization("ToTTrash")

L:SetGeneralLocalization({
	name =	"雷电王座小怪"
})

L:SetOptionLocalization({
	SoundWOP		= "语音警告：重要技能",
	HudMAP			= "高级定位监视(HUD)：$spell:139322/$spell:139900",
	RangeFrame		= "距离监视(10码)"--For 3 different spells
})

