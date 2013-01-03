-- Simplified Chinese by Diablohu(diablohudream@gmail.com)
-- Last update: 12/19/2012

if GetLocale() ~= "zhCN" then return end
local L

------------
-- Protectors of the Endless --
------------
L= DBM:GetModLocalization(683)

L:SetWarningLocalization({
	specWarnDDL 	= ">> 下一次 到你斷 <<"
})

L:SetOptionLocalization({
	RangeFrame			= "距离监视(8码)：$spell:111850(智能)",
	HudMAP				= "高级定位监视(HUD)：$spell:111850的位置",
	SetIconOnPrison		= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(117436),
	SoundDW				= "语音警告：$spell:117283的驱散",
	SoundSDQ			= "语音警告：$spell:117436的驱散",
	SoundWOP			= "语音警告：重要技能",
	optDD4				= "使用四人打断链(不选则前3人循环)",
	optDDall			= "只有在你的目标是水王时才提示打断链(不选则总是提示)",
	specWarnDDL 		= "特殊警告：下一次到你打断",
	optDD				= "水王打断链",
	nodd				= "我不打断",
	DD1					= "打断1",
	DD2					= "打断2",
	DD3					= "打断3",
	DD4					= "打断4",
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
	warnHideProgress		= "命中：%s，伤害：%s，时间：%s"
})

L:SetTimerLocalization({
	timerSpecialCD			= "下一次特殊技能(%d)"
})

L:SetOptionLocalization({
	warnHideOver			= "警告：当$spell:123244结束时",
	warnHideProgress		= "警报：$spell:123244阶段的战斗统计",
	timerSpecialCD			= "计时器：下一次特殊技能",
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
	specWarnweisuo		= "恐惧畏缩 > %d <",
})

L:SetTimerLocalization({
	timerSpecialCD			= "下一次P2特殊技能"
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
	ShaAssist			= "特殊功能：启用恐怖喷散方向指示图",
	ShaStarMode			= "治疗/DPS的恐怖喷散指示使用星辰跑位模式(硬吃一击以减少跑位)"
})