local L

--------------------------
-- Jin'rokh the Breaker --
--------------------------
L= DBM:GetModLocalization(827)

L:SetWarningLocalization({
	SpecWarnJSA			= ">>> Note damage reduction <<<"
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
	RangeFrame		= "Show range frame"
})


--------------
-- Horridon --
--------------
L= DBM:GetModLocalization(819)

L:SetWarningLocalization({
	warnAdds	= "%s"
})

L:SetTimerLocalization({
	timerDoor		= "Next Tribal Door",
	timerAdds		= "Next %s"
})

L:SetOptionLocalization({
	SoundWOP			= "语音警告：重要技能",
	SoundDB				= "语音警告：$spell:136741",
	SoundOrb			= "语音警告：$journal:7092",
	specWarnOrb			= "特别警告：$journal:7092",
	warnAdds		= "Announce when new adds jump down",
	timerDoor		= "Show timer for next Tribal Door phase",
	timerAdds		= "Show timer for when next add jumps down"
})

L:SetMiscLocalization({
	newForces		= "forces pour from the",--Farraki forces pour from the Farraki Tribal Door!
	chargeTarget	= "stamps his tail!"--Horridon sets his eyes on Eraeshio and stamps his tail!
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
	RangeFrame		= "Show range frame"
})

------------
-- Tortos --
------------
L= DBM:GetModLocalization(825)

L:SetWarningLocalization({
	warnKickShell			= "%s used by >%s< (%d remaining)",
	specWarnCrystalShell	= "Get %s"
})

L:SetOptionLocalization({
	warnKickShell			= DBM_CORE_AUTO_ANNOUNCE_OPTIONS.spell:format(134031),
	SoundWOP				= "语音警告：重要技能",	
	SoundAE					= "倒计时：$spell:133939",	
	dr1						= "减伤提示:$spell:134920 1/4",
	dr2						= "减伤提示:$spell:134920 2/4",
	dr3						= "减伤提示:$spell:134920 3/4",
	dr4						= "减伤提示:$spell:134920 4/4",
	specWarnCrystalShell	= "Show special warning when you are missing $spell:137633 debuff",
	InfoFrame				= "Show info frame for players without $spell:137633"
})

L:SetMiscLocalization({
	WrongDebuff		= "No %s"
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
	rampageEnds	= "Megaera's rage subsides.",
	Behind			= "Behind fog: "
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
	timerFlockCD	= "Nest (%d): %s"
})

L:SetOptionLocalization({
	SoundWOP		= "语音警告：重要技能",
	warnFlock		= DBM_CORE_AUTO_ANNOUNCE_OPTIONS.count:format("ej7348"),
	specWarnFlock	= DBM_CORE_AUTO_SPEC_WARN_OPTIONS.switch:format("ej7348"),
	timerFlockCD	= DBM_CORE_AUTO_TIMER_OPTIONS.nextcount:format("ej7348"),
	add1			= "第一波$journal:7348(下)",
	add2			= "第二波$journal:7348(下)",
	add3			= "第三波$journal:7348(下)",
	add4			= "第四波$journal:7348(上)",
	add5			= "第四波$journal:7348(下)",
	add6			= "第五波$journal:7348(上)",
	add7			= "第五波$journal:7348(下)",
	add8			= "第六波$journal:7348(上)",
	add9			= "第七波$journal:7348(上)",
	add10			= "第七波$journal:7348(下)",
	add11			= "第八波$journal:7348(上)",
	add12			= "第八波$journal:7348(下)",
	add13			= "第九波$journal:7348(上)",
	add14			= "第九波$journal:7348(下)",
	add15			= "第十波$journal:7348(上)",
	add16			= "第十波$journal:7348(下)",
	add17			= "第十一波$journal:7348(上)",
	add18			= "第十一波$journal:7348(下)",
	add19			= "第十二波$journal:7348(上)",
	add20			= "第十二波$journal:7348(下)",
	RangeFrame		= "Show range frame (8) for $spell:138923"
})

L:SetMiscLocalization({
	eggsHatchL		= "The eggs in one of the lower nests begin to hatch!",
	eggsHatchU		= "The eggs in one of the upper nests begin to hatch!",
	Upper			= "Upper",
	Lower			= "Lower",
	UpperAndLower	= "Upper & Lower"
})

--------------------------
-- Durumu the Forgotten --
--------------------------
L= DBM:GetModLocalization(818)

L:SetWarningLocalization({
	warnAddsLeft				= "Fogs remaining: %d",
	specWarnFogRevealed			= "%s revealed!",
	specWarnDisintegrationBeam	= "%s (%s)",
	specWarnDisintegrationBeamL	= "← ← ←Left",
	specWarnDisintegrationBeamR	= "Right→ → →"
})

L:SetOptionLocalization({
	SoundWOP					= "语音警告：重要技能",
	HudMAP						= "高级定位监视(HUD)：$spell:133775时指向$journal:6901分界线",
	warnAddsLeft				= "Announce how many Fogs remain",
	specWarnFogRevealed			= "Show special warning when a fog is revealed",
	specWarnDisintegrationBeam	= DBM_CORE_AUTO_SPEC_WARN_OPTIONS.spell:format("ej6882"),
	ArrowOnBeam					= "Show DBM Arrow during $journal:6882 to indicate which direction to move",
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
	RangeFrame			= "Show range frame (5/2)",
	SetIconOnBadOoze	= "Set icon on Living Fluid that drops $spell:140506"
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
	warnMatterSwapped	= "%s: >%s< and >%s< swapped"
})

L:SetOptionLocalization({
	SoundWOP			= "语音警告：重要技能",
	RangeFrame			= "显示距离框架(8码)",
	warnMatterSwapped	= "Announce targets swapped by $spell:138618"
})

L:SetMiscLocalization({
	Pull		= "The orb explodes!"
})

--------------
-- Iron Qon --
--------------
L= DBM:GetModLocalization(817)

L:SetWarningLocalization({
	warnDeadZone	= "%s: %s and %s shielded"
})

L:SetOptionLocalization({
	warnDeadZone	= DBM_CORE_AUTO_ANNOUNCE_OPTIONS.spell:format(137229),
	SoundWOP		= "语音警告：重要技能",
	SoundARAT		= "语音警告：报出$spell:137231的攻击方位",
	ReapetAP		= "特殊功能：若你中了$spell:136192则不停呼救",
	HudMAP			= "高级定位监视(HUD)：$spell:136192",
	RangeFrame		= "Show dynamic range frame\n(This is a smart range frame that shows when too many are too close)",
	InfoFrame		= "Show info frame for players with $spell:136193"
})

L:SetMiscLocalization({
	Helpme			= "Help me! ~~~"
})

-------------------
-- Twin Consorts --
-------------------
L= DBM:GetModLocalization(829)

L:SetOptionLocalization({
	SoundWOP			= "语音警告：重要技能",
	HudMAP				= "高级定位监视(HUD)：$journal:7651星座辅助线",
	HudMAP2				= "高级定位监视(HUD)：$spell:136752",
	RangeFrame		= "Show range frame (8)"
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
	RangeFrame		= "Show range frame"--For two different spells
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
	name =	"Throne of Thunder Trash"
})

L:SetOptionLocalization({
	SoundWOP		= "语音警告：重要技能",
	HudMAP			= "高级定位监视(HUD)：$spell:139322/$spell:139900",
	RangeFrame		= "Show range frame (10)"--For 3 different spells
})