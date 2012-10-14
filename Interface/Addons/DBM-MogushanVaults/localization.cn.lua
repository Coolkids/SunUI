-- Simplified Chinese by Diablohu(diablohudream@gmail.com)
-- Last update: 10/13/2012

if GetLocale() ~= "zhCN" then return end
local L

------------
-- The Stone Guard --
------------
L= DBM:GetModLocalization(679)

L:SetWarningLocalization({
	SpecWarnOverloadSoon	= "%s: 7秒后可施放",
	specWarnMySD				= "你拉的BOSS点了全团石化",
	specWarnBreakJasperChains	= "扯断红玉锁链！"
})

L:SetOptionLocalization({
	SoundWOP			= "语音警告：重要技能",
	InfoFrame			= "信息框：过载能量监视器",
	AInfoFrame			= "信息框：简化过载监视器(不要和上边重选)",
	specWarnMySD		= "特殊警报：当你拉的首領点了石化时(坦克)",
	SpecWarnOverloadSoon	= "特殊警报：过载预警",
	specWarnBreakJasperChains	= "特殊警报：可扯断$spell:130395",
	ArrowOnJasperChains			= "DBM箭头：当你受到$spell:130395效果影响时"
})

L:SetMiscLocalization({
	Overload	= "%s要超载了!",
	SDNOT		= "[未石化]",
	SDBLUE		= "[|cFFFFA500石化|r:|cFF0080FF蓝|r]",
	SDGREEN		= "[|cFFFFA500石化|r:|cFF088A08绿|r]",
	SDRED		= "[|cFFFFA500石化|r:|cFFFF0404红|r]",
	SDPURPLE	= "[|cFFFFA500石化|r:|cFF9932CD紫|r]",
	NEXTR		= "|cFFFFA500下次超载|r:|cFFFF0404红色|r",
	NEXTG		= "|cFFFFA500下次超载|r:|cFF088A08绿色|r",
	NEXTB		= "|cFFFFA500下次超载|r:|cFF0080FF蓝色|r",
	NEXTP		= "|cFFFFA500下次超载|r:|cFF9932CD紫色|r"
})


------------
-- Feng the Accursed --
------------
L= DBM:GetModLocalization(689)

L:SetWarningLocalization({
	WarnPhase	= "第 %d 阶段"
})

L:SetOptionLocalization({
	SoundWOP			= "语音警告：重要技能",
	InfoFrame			= "资讯框：坦克减益状态层数监视",
	HudMAP				= "高级定位监视(HUD)：$spell:116784的位置",
	HudMAP2				= "高级定位监视(HUD)：$spell:116417",
	WarnPhase			= "警告：阶段转换"
})

L:SetMiscLocalization({
	Fire		= "噢，至高的神啊!藉由我来融化他们的血肉吧!",
	Arcane		= "噢，上古的贤者!赐予我秘法的智慧!",
	Nature		= "噢，伟大的灵魂!赐予我大地之力!",--I did not log this one, text is probably not right
	Shadow		= "Great soul of champions past! Bear to me your shield!"
})


-------------------------------
-- Gara'jal the Spiritbinder --
-------------------------------
L= DBM:GetModLocalization(682)

L:SetOptionLocalization({
	SoundWOP			= "语音警告：重要技能",
	SoundTT				= "语音警告：$spell:116174",
	SetIconOnVoodoo		= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(122151),
	InfoFrame			= "资讯框：$spell:116161的玩家 (标注\"治疗\"需团员选择角色类型)"
})

L:SetMiscLocalization({
	Pull		= "死亡时间到！"
})


----------------------
-- The Spirit Kings --
----------------------
L = DBM:GetModLocalization(687)

L:SetOptionLocalization({
	RangeFrame			= "距离监视(8码)",
	SoundWOP			= "语音警告：重要技能",
	SoundDS				= "语音警告：$spell:117697和$spell:117961的驱散",
	InfoFrame			= "资讯框：$spell:118303的目标",
	HudMAP				= "高级定位监视(HUD)：$spell:118047的位置",
	HudMAP2				= "高级定位监视(HUD)：$spell:118303的目标",
	SoundCT				= "语音警告：$spell:117833的打断"
})


------------
-- Elegon --
------------
L = DBM:GetModLocalization(726)

L:SetWarningLocalization({
	specWarnDespawnFloor		= "中场即将消失!",
	specWarnCharge				= "聚焦能量 [%d] - 转换目标",
	specWarnProtector			= "星穹保卫者 [%d] - 转换目标"
})

L:SetTimerLocalization({
	timerDespawnFloor			= "中场消失!"
})

L:SetOptionLocalization({
	SoundWOP					= "语音警告：重要技能",
	SoundCC						= "语音警告：$spell:117949的驱散",
	SoundDD						= "语音警告：為消掉$spell:117878播放额外音效",
	optDBPull					= "语音警告：為正在坦$journal:6178的坦克播放$spell:117960警告",
	specWarnDespawnFloor		= "特殊警告：中场地板消失前",
	specWarnCharge				= "特殊警告：聚焦能量",
	specWarnProtector			= "特殊警告：$journal:6178",
	timerDespawnFloor			= "计时器：中场地板消失",
	InfoFrame					= "资讯框：$spell:117878层数最高的5名团员",
	optOC						= "\"能量超载\"叠加几层时，开始报警(每三层报警一次)",
	six							= "6层",
	nine						= "9层",
	twelve						= "12层",
	fifteen						= "15层",
	none						= "不报警",
	optPos						= "DBM箭头：\"聚焦能量\"出现前指向\"以太焦镜\"(入口起逆时针)",
	nonepos						= "不显示",
	posA 						= "1号位",
	posB 						= "2号位",
	posC 						= "3号位",
	posD						= "4号位",
	posE 						= "5号位",
	posF 						= "6号位"
})

L:SetMiscLocalization({
	Floor				= "能量漩涡的能量正在降低!"
})
------------
-- Will of the Emperor --
------------
L= DBM:GetModLocalization(677)

L:SetOptionLocalization({
	InfoFrame			= "资讯框：$spell:116525的目标",
	SoundWOP			= "语音警告：重要技能",
	SoundADD			= "语音警告：$spell:ej5678",
	optBY				= "语音警告：仅提示此首领的毁灭风暴",
	tarfoc				= "当前目标和专注目标",
	Janxi				= "剑曦(左侧傀儡)",
	Qinxi				= "秦希(右侧傀儡)",
	none				= "这个傢伙很懒,谁的提示都不想听"
})

L:SetMiscLocalization({
	Pull		= "机器开始嗡嗡作响了!到下层去!",--Emote
	Rage		= "皇帝之怒响彻群山。",--Yell
	Strength	= "皇帝的力量出现在壁龛中!",--Emote
	Courage		= "皇帝的勇气出现在壁龛中!",--Emote
	Boss		= "两个巨型构造体出现在大型的壁龛中!"--Emote
})