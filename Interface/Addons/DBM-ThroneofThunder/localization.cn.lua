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
	dr1					= "减伤提示:$spell:137313 1/3-1 [开始时提示]",
	dr2					= "减伤提示:$spell:137313 1/3-2 [五秒时提示]",
	dr3					= "减伤提示:$spell:137313 2/4-1",
	dr4					= "减伤提示:$spell:137313 2/4-2",
	RangeFrame			= "距离监视"
})


--------------
-- Horridon --
--------------
L= DBM:GetModLocalization(819)

L:SetWarningLocalization({
	warnAdds		= "%s",
	SpecWarnJSA		= ">>> 注意减伤 <<<",
	warnOrbofControl		= "支配宝珠掉落",
	specWarnOrbofControl		= ">>支配宝珠掉落<<"
})

L:SetTimerLocalization({
	timerDoor		= "下一个部族大门",
	timerAdds		= "下一次%s"
})

L:SetOptionLocalization({
	warnAdds			= "警告：小怪跳下",
	warnOrbofControl		= "警告：$journal:7092掉落",
	specWarnOrbofControl		= "特别警告：$journal:7092掉落",
	SoundWOP			= "语音警告：重要技能",
	SpecWarnJSA			= "特殊警告：注意减伤",
	ccsoon				= "语音警告：即将$spell:136767(当你是首领目标时无视此选项)",
	ddyls				= "语音警告：打断$spell:136797",
	dr1					= "减伤提示：$spell:136817 1",
	dr2					= "减伤提示：$spell:136817 2",
	dr3					= "减伤提示：$spell:136817 3",
	dr4					= "减伤提示：$spell:136817 4",
	SoundDB				= "语音警告：$spell:136741",
	SoundOrb			= "语音警告：$journal:7092",
	optQS				= "DEBUFF驱散链",
	noQS				= "不提示",
	QS1					= "顺序1",
	QS2					= "顺序2",
	QS3					= "顺序3",
	allQS				= "总是提示",
	timerDoor			= "计时器：下一个部族大门开啟",
	timerAdds			= "计时器：下一组小怪刷新"
})

L:SetMiscLocalization({
	newForces		= "之门中涌出",--Farraki forces pour from the Farraki Tribal Door!
	chargeTarget	= "开始拍打他的尾巴"--Horridon sets his eyes on Eraeshio and stamps his tail!
})

---------------------------
-- The Council of Elders --
---------------------------
L= DBM:GetModLocalization(816)

L:SetWarningLocalization({
	specWarnDDL 	= ">> 下一次 到你断 <<",
	specWarnPossessed		= "%s 附身 %s - 快转火!"
})

L:SetOptionLocalization({
	SoundWOP		= "语音警告：重要技能",
	SoundLs			= "倒计时：$spell:136521",	
	SoundHs			= "语音预警：$spell:136990",
	Soundspirit		= "倒计时：女祭司的各种魂灵",
	HudMAP			= "高级定位监视(HUD)：$spell:136992",
	HudMAP2			= "高级定位监视(HUD)：$spell:136922",
	optDD			= "沙王打断链",
	nodd			= "我不打断",
	DD1				= "打断1",
	DD2				= "打断2",
	DD3				= "打断3",
	optOC			= "当灵魂碎片叠加几层时提示你传递",
	five			= "5层",
	ten				= "10层",
	none			= "从不提示",
	specWarnDDL 	= "特殊警告：下一次到你打断",
	warnPossessed		= DBM_CORE_AUTO_ANNOUNCE_OPTIONS.target:format(136442),
	specWarnPossessed	= DBM_CORE_AUTO_SPEC_WARN_OPTIONS.switch:format(136442),
	warnSandBolt		= DBM_CORE_AUTO_ANNOUNCE_OPTIONS.target:format(136189),
	PHealthFrame		= "为$spell:136442消散显示剩余血量框(需要首领血量框架开启)",
	RangeFrame			= "距离监视",
	SetIconOnBitingCold	= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(136992),
	SetIconOnFrostBite	= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(136922)
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
	InfoFrame				= "信息框：没有$spell:137633效果的团员",
	SetIconOnTurtles		= "为$journal:7129设置团队标记"
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
	InfoFrame		= "资讯框：$journal:7006",
	SetIconOnCinders		= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(139822),
	SetIconOnTorrentofIce	= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(139889)
})

L:SetMiscLocalization({
	rampageEnds		= "墨格瑞拉的怒火平息了",
	Behind			= "迷雾中: "
})

------------
-- Ji-Kun --
------------
L= DBM:GetModLocalization(828)

L:SetWarningLocalization({
	warnFlock		= "%s %s (%s)",
	specWarnFlock	= "%s %s (%s)"
})

L:SetTimerLocalization({
	timerFlockCD	= "第%d波: %s"
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
	add21			= "第十三波$journal:7348(上)",
	add22			= "第十三波$journal:7348(下)",
	add23			= "第十四波$journal:7348(上)",
	add24			= "第十四波$journal:7348(下)",
	add25			= "第十五波$journal:7348(上)",
	add26			= "第十五波$journal:7348(下)",
	RangeFrame		= "距离监视(8码)：$spell:138923"
})

L:SetMiscLocalization({
	eggsHatchL		= "下层某个鸟巢中的蛋开始孵化了",
	eggsHatchU		= "上层某个鸟巢中的蛋开始孵化了",
	U				= "上方",
	L				= "下方",
	UAndL			= "上方 & 下方",
	TrippleD		= "三个 (2x下)",
	TrippleU		= "三个 (2x上)"
})

--------------------------
-- Durumu the Forgotten --
--------------------------
L= DBM:GetModLocalization(818)

L:SetWarningLocalization({
	warnAddsLeft				= "雾兽剩餘: %d",
	specWarnFogRevealed			= "照出%s了!",
	specWarnDisintegrationBeam	= "%s (%s)"
})

L:SetOptionLocalization({
	SoundWOP					= "语音警告：重要技能",
	optDD						= "三元光分担策略",
	nodd						= "不分担",
	DD1							= "A:红黄蓝",
	DD2							= "B:黄蓝红",
	DD3							= "C:蓝红黄",
	HudMAP						= "高级定位监视(HUD)：三元光分担",
	warnAddsLeft				= "警告：雾兽剩余数量",
	specWarnFogRevealed			= "特别警告：雾兽被照出",
	specWarnDisintegrationBeam	= DBM_CORE_AUTO_SPEC_WARN_OPTIONS.spell:format("ej6882"),
	ArrowOnBeam					= "DBM箭头：$journal:6882的转动方向",
	specWarnDisintegrationBeamL			= "特殊警告：左转$spell:133775",
	specWarnDisintegrationBeamR			= "特殊警告：右转$spell:136316",
	SetIconRays					= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format("ej6891")
})

L:SetMiscLocalization({
	Eye		= "魔眼"
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
	Pull		= "宝珠爆炸了！"
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

L:SetWarningLocalization({
	warnNight		= "黑夜阶段",
	warnDay			= "白天阶段",
	warnDusk		= "黄昏阶段"
})

L:SetTimerLocalization({
	timerDayCD		= "白天阶段",
	timerDuskCD		= "黄昏阶段",
})

L:SetOptionLocalization({
	SoundWOP			= "语音警告：重要技能",
	HudMAP				= "高级定位监视(HUD)：$journal:7651星座辅助线",
	HudMAP2				= "高级定位监视(HUD)：$spell:136752",
	warnNight		= "警告：黑夜阶段",
	warnDay			= "警告：白天阶段",
	warnDusk		= "警告：黄昏阶段",
	timerDayCD		= "计时器：白天阶段",
	timerDuskCD		= "计时器：黄昏阶段",
	RangeFrame			= "距离监视(8码)"
})

L:SetMiscLocalization({
	DuskPhase		= "露琳！将你的力量借给我！"--Not in use, but a backup just in case, so translate in case it's switched to on moments notice on live or next PTR test
})

--------------
-- Lei Shen --
--------------
L= DBM:GetModLocalization(832)

L:SetOptionLocalization({
	SoundWOP		= "语音警告：重要技能",
	HudMAP			= "高级定位监视(HUD)：$spell:135695",
	HudMAP2			= "高级定位监视(HUD)：$spell:136295",
	RangeFrame		= "距离监视",--For two different spells
	StaticShockArrow	= "DBM箭头：$spell:135695",
	OverchargeArrow		= "DBM箭头：$spell:136295",
	SetIconOnOvercharge	= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(136295),
	SetIconOnStaticShock= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(135695)
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

