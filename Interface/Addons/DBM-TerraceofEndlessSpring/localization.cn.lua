-- Simplified Chinese by Diablohu(diablohudream@gmail.com)
-- Last update: 12/19/2012

if GetLocale() ~= "zhCN" then return end
local L

------------
-- Protectors of the Endless --
------------
L= DBM:GetModLocalization(683)

L:SetWarningLocalization({
	warnGroupOrder		= "小怪处理 - %s组",
	specWarnYourGroup	= "快去打小怪! 到你了!",
	specWarnYourEnd		= ">>小怪结束<<",
	specWarnDDL 	= ">> 下一次 到你断 <<",
	SpecWarnJSA		= "%s﹪ >>注意减伤<<"
})

L:SetOptionLocalization({
	warnGroupOrder		= "警告：小怪处理组",
	specWarnYourGroup	= "特殊警告：到你处理小怪",
	specWarnYourEnd		= "特殊警告：本轮处理小怪已经结束",
	RangeFrame			= "距离监视(8码)：$spell:111850(智能)",
	HudMAP				= "高级定位监视(HUD)：$spell:111850的位置",
	SetIconOnPrison		= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(117436),
	SoundDW				= "语音警告：$spell:117283的驱散",
	SoundSDQ			= "语音警告：$spell:117436的驱散",
	SoundWOP			= "语音警告：重要技能",
	SoundWater			= "语音警告：$spell:117309时提示拉开BOSS(坦克)",
	optDD4				= "使用四人打断链(不选则前3人循环)",
	opthelpDD			= "语音警告：$spell:118077出现时提示您帮忙打断第一次$spell:118312",
	specWarnDDL 		= "特殊警告：下一次到你打断",
	optDD				= "水王打断链",
	nodd				= "我不打断",
	DD1					= "打断1",
	DD2					= "打断2",
	DD3					= "打断3",
	DD4					= "打断4",
	optMob				= "选择您的小怪处理组编号",
	Mob1				= "小怪处理组1",
	Mob2				= "小怪处理组2",
	Mob3				= "小怪处理组3",
	Mob4				= "小怪处理组4",
	Mob5				= "小怪处理组5",
	noMob				= "不提示",
	optMobSet			= "小怪处理策略(支持4或5组循环,若跳组请用数字0填充)",
	warndr9				= "减伤提示：三阶段水王90%血",
	warndr8				= "减伤提示：三阶段水王80%血",
	warndr7				= "减伤提示：三阶段水王70%血",
	warndr6				= "减伤提示：三阶段水王60%血",
	warndr5				= "减伤提示：三阶段水王50%血",
	warndr4				= "减伤提示：三阶段水王40%血",
	warndr3				= "减伤提示：三阶段水王30%血",
	warndr2				= "减伤提示：三阶段水王20%血",
	warndr1				= "减伤提示：三阶段水王10%血",
	SpecWarnJSA			= "特别警告：注意开减伤",
	helpdispset			= "输入一个重点关注的团员,当其被点名闪电牢笼时会提示你帮忙驱散"
})


------------
-- Tsulong --
------------
L= DBM:GetModLocalization(742)

L:SetOptionLocalization({
	SoundWOP					= "语音警告：重要技能",
	WarnJK						= "语音警告：$spell:123011的预先警告",
	HudMAP						= "高级定位监视(HUD)：$spell:122770的位置(仅10人)",
	optDS						= "\"恐怖阴影\"叠加几层时，开始报警",
	six							= "6层",
	nine						= "9层",
	twelve						= "12层",
	fifteen						= "15层",
	none						= "不报警",
})

L:SetMiscLocalization{
	Victory	= "谢谢你，陌生人。我自由了。"
}


-------------------------------
-- Lei Shi --
-------------------------------
L= DBM:GetModLocalization(729)

L:SetWarningLocalization({
	warnHideOver			= "%s 结束",
	SpecWarnJSA				= ">>> 注意减伤 <<<",
	warnHideProgress		= "命中：%s，伤害：%s，时间：%s"
})

L:SetTimerLocalization({
	timerSpecialCD			= "下一次特殊技能(%d)"
})

L:SetOptionLocalization({
	warnHideOver			= "警告：当$spell:123244结束时",
	warnHideProgress		= "警报：$spell:123244阶段的战斗统计",
	timerSpecialCD			= "计时器：下一次特殊技能",
	HudMAP					= "高级定位监视(HUD)：超过5层的$spell:123705携带者",
	InfoFrame				= "信息框：首领的$spell:123712",
	SpecWarnJSA				= "特殊警告：注意减伤",
	unseenjs1				= "减伤提示:滚开1",
	unseenjs2				= "减伤提示:滚开2",
	unseenjs3				= "减伤提示:滚开3",
	unseenjs4				= "减伤提示:滚开4",
	unseenjs5				= "减伤提示:滚开5",
	SoundWOP				= "语音警告：重要技能",
	SetIconOnGuardfix		= "为$journal:6224设置团队标记",
	RangeFrame				= "距离监视（3码）：应对$spell:123121（隐藏阶段时显示所有人，其余时仅显示坦克位置）",
	GWHealthFrame			= "生命值监视：移除$spell:123461还需要的伤害"
})


L:SetMiscLocalization{
	Victory	= "我……啊……噢！我……？眼睛……好……模糊。"--wtb alternate and less crappy victory event.
}


----------------------
-- Sha of Fear --
----------------------
L= DBM:GetModLocalization(709)

L:SetWarningLocalization({
	specWarnyinmo		= "隐没 > %d <",
	specWarnfuxian		= "浮现! 新出现>%d<个畏惧之子",
	specWarnweisuo		= "畏惧蜷缩 > %d <",
	specWarningpreHud	= "畏惧蜷缩 即将来临",
	MoveWarningLeft		= "← ← 向左一格",
	MoveWarningRight	= "向右一格 → →",
	MoveWarningBack		= "→ → 回原位 ← ←"
})

L:SetTimerLocalization({
	timerSpecialCD			= "下一次P2特殊技能",
	timerSpoHudCD			= "下一次 畏惧蜷缩 或 龙卷水涌",
	timerSpoStrCD			= "下一次 龙卷水涌 或 宿怨打击",
	timerHudStrCD			= "下一次 畏惧蜷缩 或 宿怨打击"
})

L:SetOptionLocalization({
	SoundDD				= "语音警告：$spell:131996",
	SoundWOP			= "语音警告：重要技能",
	RangeFrame			= "距离监视（2码）：应对$spell:119519",
	pscount				= "语音警告：为恐怖喷散报数",
	HudMAP				= "高级定位监视(HUD)：$spell:120519",
	InfoFrame			= "信息框：$spell:120629",
	timerSpecialCD		= "计时器：下一次P2特殊技能",
	specWarnyinmo		= "特殊警告：$spell:120455",
	specWarnfuxian		= "特殊警告：$spell:120458",
	specWarnweisuo		= "特殊警告：$spell:120629",
	specWarningpreHud	= "特殊警告：$spell:120629的预警",
	MoveWarningLeft		= "特殊警告：向左一格",
	MoveWarningRight	= "特殊警告：向右一格",
	MoveWarningBack		= "特殊警告：回原位",
	ShaAssist			= "特殊功能：启用恐怖喷散方向指示图",
	ShaStarMode			= "治疗/DPS的恐怖喷散指示使用星辰跑位模式(硬吃一击以减少跑位)",
	timerSpoHudCD		= "计时器：$spell:120629或$spell:120519",
	timerSpoStrCD		= "计时器：$spell:120519或$spell:120672",
	timerHudStrCD		= "计时器：$spell:120629或$spell:120672",
	SetIconOnWS			= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(120629)
})