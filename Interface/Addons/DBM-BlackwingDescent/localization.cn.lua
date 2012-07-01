if GetLocale() ~= "zhCN" then return end

local L

--------------
--  Magmaw  --
--------------
L = DBM:GetModLocalization("Magmaw")

L:SetGeneralLocalization({
	name 				= "熔喉"
})

L:SetWarningLocalization({
	SpecWarnInferno			= "炽焰白骨结构体 即将到来 (~4秒)"
})

L:SetTimerLocalization({
})

L:SetOptionLocalization({
	SoundWOP = "为重要技能播放额外的警告语音",
	SpecWarnInferno			= "为$spell:92190显示预先特别警告 (~4秒)",
	RangeFrame			= "第2阶段时显示距离框 (5码)"
})

L:SetMiscLocalization({
	Slump				= "%s向前倒下，暴露出他的钳子！",
	HeadExposed			= "%s将自己钉在刺上，露出了他的头！",
	YellPhase2			= "难以置信，你们竟然真要击败我的熔岩巨虫了！也许我可以帮你们……扭转局势。"
})

-------------------------------
--  Dark Iron Golem Council  --
-------------------------------
L = DBM:GetModLocalization("DarkIronGolemCouncil")

L:SetGeneralLocalization({
	name 				= "全能金刚防御系统"
})

L:SetWarningLocalization({
	SpecWarnActivated		= "转换目标到 %s!",
	specWarnGenerator		= "能量发生器 - 拉开%s!"
})

L:SetTimerLocalization({
	timerArcaneBlowbackCast		= "奥术反冲",
	timerShadowConductorCast	= "暗影灌注",
	timerNefAblity			= "奈法技能冷却",
	timerArcaneLockout		= "奥术歼灭者锁定"
})

L:SetOptionLocalization({
	SoundWOP = "为重要技能播放额外的警告语音",
	timerShadowConductorCast	= "为$spell:92048的施放显示计时条",
	timerArcaneBlowbackCast		= "为$spell:91879的施放显示计时条",
	timerArcaneLockout		= "为$spell:91542法术锁定显示计时条",
	timerNefAblity			= "为困难模式奈法技能冷却显示计时条",
	SpecWarnActivated		= "当新金刚启动时显示特别警告",
	specWarnGenerator		= "当金刚获得$spell:91557时显示特别警告",
	AcquiringTargetIcon		= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(79501),
	ConductorIcon			= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(79888),
	ShadowConductorIcon		= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(92053),
	SetIconOnActivated			= "为最新激活的金刚设定标记"
})

L:SetMiscLocalization({
	Magmatron			= "熔岩金刚",
	Electron			= "电荷金刚",
	Toxitron			= "剧毒金刚",
	Arcanotron			= "奥能金刚",
	YellTargetLock			= "暗影包围! 远离我!"
})

----------------
--  Maloriak  --
----------------
L = DBM:GetModLocalization("Maloriak")

L:SetGeneralLocalization({
	name 				= "马洛拉克"
})

L:SetWarningLocalization({
	WarnPhase			= "%s阶段",
	WarnRemainingAdds		= "剩余%d畸变怪"
})

L:SetTimerLocalization({
	TimerPhase			= "下一阶段"
})

L:SetOptionLocalization({
	SoundWOP = "为重要技能播放额外的警告语音",
	WarnPhase			= "为各阶段即将到来显示警告",
	WarnRemainingAdds		= "显示剩余多少畸变怪的警告",
	TimerPhase			= "为下一阶段显示计时条",
	RangeFrame			= "蓝色阶段时显示距离框 (6码)",
	SetTextures			= "自动在黑暗阶段停用材质投射\n(离开黑暗阶段后再次启用)",
	FlashFreezeIcon			= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(92979),
	BitingChillIcon			= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(77760),
	ConsumingFlamesIcon		= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(77786)
})

L:SetMiscLocalization({
	YellRed				= "红瓶|r扔进了大锅里！",
	YellBlue			= "蓝瓶|r扔进了大锅里！",
	YellGreen			= "绿瓶|r扔进了大锅里！",
	YellDark			= "黑暗|r魔法！",
	Red				= "红瓶",
	Blue				= "蓝瓶",
	Green				= "绿瓶",
	Dark				= "黑瓶"
})

-----------------
--  Chimaeron  --
-----------------
L = DBM:GetModLocalization("Chimaeron")

L:SetGeneralLocalization({
	name 				= "奇美隆"
})

L:SetWarningLocalization({
})

L:SetTimerLocalization({
})

L:SetOptionLocalization({
	SoundWOP = "为重要技能播放额外的警告语音",
	RangeFrame			= "显示距离框 (6码)",
	SetIconOnSlime			= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(82935),
	InfoFrame			= "在信息框显示低血量(低于1万血)玩家"
})

L:SetMiscLocalization({
	HealthInfo			= "血量信息"
})

-----------------
--  Atramedes  --
-----------------
L = DBM:GetModLocalization("Atramedes")

L:SetGeneralLocalization({
	name 				= "艾卓曼德斯"
})

L:SetWarningLocalization({
	SpecWarnFiend		= "喧闹恶鬼 出现!",
	WarnAirphase			= "空中阶段",
	WarnGroundphase			= "地面阶段",
	WarnShieldsLeft			= "使用了远古矮人护盾 - 剩余%d次",
	warnAddSoon			= "喧闹恶鬼已被召唤了",
	specWarnAddTargetable		= "可以攻击%s了"
})

L:SetTimerLocalization({
	TimerFiend		= "喧闹恶鬼",
	TimerAirphase			= "下一次 空中阶段",
	TimerGroundphase		= "下一次 地面阶段"
})

L:SetOptionLocalization({
	SoundWOP = "为重要技能播放额外的警告语音",
	SpecWarnFiend		= "当喧闹恶鬼出现时显示特别警告",
	WarnAirphase			= "当艾卓曼德斯升空时显示警告",
	WarnGroundphase			= "当艾卓曼德斯降落时显示警告",
	WarnShieldsLeft			= "当远古矮人护盾使用后显示警告",
	warnAddSoon			= "当奈法利安召唤喧闹恶鬼时显示警告",
	specWarnAddTargetable		= "当喧闹恶鬼可以被选择攻击时显示特别警告",
	TimerFiend		= "为下一次喧闹恶鬼出现显示计时条",
	TimerAirphase			= "为下一次空中阶段显示计时条",
	TimerGroundphase		= "为下一次地面阶段显示计时条",
	InfoFrame			= "在信息框显示音量值",
	TrackingIcon			= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(78092)
})

L:SetMiscLocalization({
	AncientDwarvenShield		= "远古矮人护盾",
	Soundlevel			= "音量",
	YellPestered			= "喧闹恶鬼在我这里！",--npc 49740
	NefAdd				= "艾卓曼德斯，那些英雄就在那边！",
	Airphase			= "对，跑吧！每跑一步你的心跳都会加快。这心跳声，洪亮如雷，震耳欲聋。你逃不掉的！"
})

----------------
--  Nefarian  --
----------------
L = DBM:GetModLocalization("Nefarian")

L:SetGeneralLocalization({
	name 				= "奈法利安的末日"
})

L:SetWarningLocalization({
	OnyTailSwipe			= "龙尾扫击 (奥妮)",
	NefTailSwipe			= "龙尾扫击 (奈法)",
	SpecWarnElectrocute		= "通电 (%d)",
	OnyBreath			= "暗影烈焰吐息 (奥妮)",
	NefBreath			= "暗影烈焰吐息 (奈法)",
	specWarnShadowblazeSoon	= "%s",
	warnShadowblazeSoon		= "%s"
})

L:SetTimerLocalization({
	timerNefLanding			= "奈法利安降落",
	OnySwipeTimer			= "龙尾扫击冷却 (奥妮)",
	NefSwipeTimer			= "龙尾扫击冷却 (奈法)",
	OnyBreathTimer			= "暗影烈焰吐息冷却 (奥妮)",
	NefBreathTimer			= "暗影烈焰吐息冷却 (奈法)"
})

L:SetOptionLocalization({
	SoundWOP = "为重要技能播放额外的警告语音",
	SoundHelp = "当你的焦点目标中了$spell:79339时播放警告语音(辅助打断)",
	SpecWarnElectrocute		= "为$spell:81198显示特别警告",
	OnyTailSwipe			= "为奥妮克希亚的$spell:77827显示警告",
	NefTailSwipe			= "为奈法利安的$spell:77827显示警告",
	OnyBreath			= "为奥妮克希亚的$spell:94124显示警告",
	NefBreath			= "为奈法利安的$spell:94124显示警告",
	specWarnCinderMove		= "当你中了$spell:79339需要跑开时显示特别警告(爆炸前5秒)",
	warnShadowblazeSoon		= "显示$spell:81031的5秒倒计时(只有当计时条与喊话同步后才显示)",
	specWarnShadowblazeSoon	= "显示$spell:81031的预先特别警告\n(初始5秒前警告，喊话同步后会精确到1秒)",
	timerNefLanding			= "为奈法利安降落地面显示计时条",
	OnySwipeTimer			= "为奥妮克希亚的$spell:77827的冷却时间显示计时条",
	NefSwipeTimer			= "为奈法利安的$spell:77827的冷却时间显示计时条",
	OnyBreathTimer			= "为奥妮克希亚的$spell:94124的冷却时间显示计时条",
	NefBreathTimer			= "为奈法利安的$spell:94124的冷却时间显示计时条",
	InfoFrame			= "在信息框显示奥妮克希亚的电流充能",
	SetWater			= "进入战斗后自动关闭液体细节效果(离开战斗后再启用)",
	TankArrow			= "为风筝坚骨战士的玩家显示DBM箭头\n(仅适用于一个风筝坦克)",--npc 41918
	SetIconOnCinder			= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(79339),
	RangeFrame			= "为$spell:79339显示距离框 (10码)(智能区别显示)"
})

L:SetMiscLocalization({
	NefAoe				= "空气中激荡的电流噼啪作响！",
	YellPhase2 			= "诅咒你们，凡人！你们丝毫不尊重他人财产的行为必须受到严厉处罚！",
	YellPhase3			= "我一直在尝试扮演好客的主人，可你们就是不肯受死！该卸下伪装了……杀光你们！",
	YellShadowBlaze			= "血肉化为灰烬！",
	Nefarian			= "奈法利安",
	Onyxia				= "奥妮克希亚",
	Charge				= "电流充能",
	ShadowBlazeExact		= "暗影爆燃火花落地 剩余 %d 秒",
	ShadowBlazeEstimate		= "即将 暗影爆燃火花(约5秒)"
})

--------------
--  Blackwing Descent Trash  --
--------------
L = DBM:GetModLocalization("BWDTrash")

L:SetGeneralLocalization({
	name = "黑翼血环小怪"
})

L:SetWarningLocalization({
})

L:SetTimerLocalization({
})

L:SetOptionLocalization({
})

L:SetMiscLocalization({
})
