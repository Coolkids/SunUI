-- Simplified Chinese by Diablohu(diablohudream@gmail.com)
-- Last update: 11/14/2012

if GetLocale() ~= "zhCN" then return end
local L

------------
-- Imperial Vizier Zor'lok --
------------
L= DBM:GetModLocalization(745)

L:SetOptionLocalization({
	specwarnPlatform	= "特别警告：当战斗露台改变时",
	ArrowOnAttenuation	= "DBM箭头：当$spell:127834出现时指示移动的方向",
	specwarnExhale		= "特别警告：$spell:122761",
	specwarnExhaleB		= "特别警告：$spell:122761的预先警告",
	specwarnAttenuationL	= "特别警告：左旋音波",
	specwarnAttenuationR	= "特别警告：右旋音波",
	specwarnDR				= "特别警告：注意开减伤",
	MindControlIcon		= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(122740),
	SoundWOP			= "语音警告：重要技能",
	HudMAP				= "高级定位监视(HUD)：$spell:122761目标的位置",
	HudMAP2				= "高级定位监视(HUD)：$spell:122740的位置",
	optarrowRTI			= "<力与魄>出现前，显示箭头指向以下标记的玩家",
	none				= "不显示箭头",
	arrow1				= "星星",
	arrow2				= "大饼",
	arrow3				= "菱形",
	arrow4				= "三角",
	arrow5				= "月亮",
	arrow6				= "方块",
	arrow7				= "叉叉",
	optDR				= "P1阶段<力与魄>减伤",
	noDR				= "不关我事",
	DR1					= "P1第一次",
	DR2					= "P1第二次",
	DR3					= "P1第三次",
	DR4					= "P1第四次",
	DR5					= "P1第五次",
	optDRT				= "P2阶段<力与魄>减伤",
	noDRT				= "不关我事",
	DRT1				= "P2第一次",
	DRT2				= "P2第二次",
	DRT3				= "P2第三次",
	DRT4				= "P2第四次",
	DRT5				= "P2第五次"
})

L:SetMiscLocalization({
	Platform	= "%s朝他其中一个平台飞去了！",
	Defeat		= "我们不会向黑暗虚空的绝望屈服。如果女皇要我们去死，我们便照做。"
})

L:SetWarningLocalization({
	specwarnPlatform	= "作战区改变!",
	specwarnAttenuationL	= "← ← ←左左左",
	specwarnAttenuationR	= "右右右→ → →",
	specwarnExhale		= "吐气[%d] : %s",
	specwarnDR			= ">>本轮你开减伤<<",
	specwarnExhaleB		= "即将 >>%d层<< 吐气"
})

------------
-- Blade Lord Ta'yak --
------------
L= DBM:GetModLocalization(744)

L:SetOptionLocalization({
	UnseenStrikeArrow	= "DBM箭头：$spell:122949的目标",
	InfoFrame			= "资讯框：$spell:123474",
	RangeFrame			= "距离监视(8码)：$spell:123175",
	SpecWarnOverwhelmingAssaultOther = "特别警告：$spell:123081的层数",
	HudMAP				= "高级定位监视(HUD)：$spell:122949的位置",
	SoundWOP			= "语音警告：重要技能"
})

L:SetWarningLocalization({
	SpecWarnOverwhelmingAssaultOther 		= "%s 被压制 (%d层)"
})

-------------------------------
-- Garalon --
-------------------------------
L= DBM:GetModLocalization(713)

L:SetWarningLocalization({
	specwarnUnder	= "离开紫圈!",
	specWarnPungencyOtherFix = "%s 敏感 (%d)",
	specwarnCrushH	= "重碾 (%d)"
})

L:SetOptionLocalization({
	specwarnUnder		= "特别警告：你在BOSS下方",
	PheromonesIcon		= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(122835),
	InfoFrame			= "资讯框：$spell:123081层数监视",
	optTankMode			= "特别警告：费洛蒙换坦策略",
	two					= "二坦模式 (30层敏感以上提示)",
	three				= "三坦模式 (20层敏感以上提示)",
	SoundWOP			= "语音警告：重要技能",
	specWarnPungencyOtherFix = "特别警告：当别人的$spell:123081达到设定层数时",
	HudMAP				= "高级定位监视(HUD)：$spell:122835的位置",
	SoundFS				= "坦克倒计时：$spell:122735"
})

L:SetMiscLocalization({
	UnderHim	= "下面",
	Heroicrush	= "他的对手"
})
----------------------
-- Wind Lord Mel'jarak --
----------------------
L= DBM:GetModLocalization(741)

L:SetOptionLocalization({
	SoundWOP			= "语音警告：重要技能",
	SoundDQ				= "语音警告：$spell:122149的驱散",
	SoundJR				= "语音警告：当你没有残渣时提示救琥珀",
	APArrow				= "DBM箭头：$spell:121881的位置",
	NearAP				= "特殊功能：$spell:121881在你20码范围内才播放语音(仅影响语音)",
	ReapetAP			= "特殊功能：若你的$spell:121881在5秒内无人打破则不停呼救",
	HudMAP				= "高级定位监视(HUD)：$spell:121885的位置",
	optHud				= "高级定位监视(HUD)：风之炸弹的位置",
	auto				= "当你中了炸弹时显示",
	always				= "总是显示",
	none				= "不显示",
	RangeFrame			= "距离监视(3码)：$spell:121881",
	AmberPrisonIcons	= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(121885)
})

L:SetMiscLocalization({
	Helpme				= "救我 ~~~",
	Reinforcements		= "Wind Lord Mel'jarak calls for reinforcements!"
})
------------
-- Amber-Shaper Un'sok --
------------
L= DBM:GetModLocalization(737)

L:SetWarningLocalization({
	warnReshapeLifeTutor		= "1:中断/益伤目标,, 2:中断自己, 3:回复体力/意志力, 4:脱离傀儡",
	warnAmberExplosion			= "%s 正在施放 %s",
	warnInterruptsAvailable		= "可打断 %s: %s",
	specwarnWillPower			= "意志低下！",
	specwarnAmberExplosionYou	= "打断 >你自己的< %s！",--Struggle for Control interrupt.
	specwarnAmberExplosionAM	= "%s：打断 %s!",--Amber Montrosity
	specwarnAmberExplosionOther	= "%s：打断 %s!"--Amber Montrosity
})

L:SetTimerLocalization{
	timerAmberExplosionAMCD		= "下一次%s: %s"
}

L:SetOptionLocalization({
	SoundWOP			= "语音警告：重要技能",
	warnReshapeLifeTutor		= "显示突变魁儡的能力说明效果",
	warnAmberExplosion			= "警报：$spell:122398正在施放，并警报来源",
	warnInterruptsAvailable		= "警报：可使用$spell:122402打断琥珀打击的成员",
	specwarnWillPower			= "特殊警报：在畸形体中意志低下时",
	specwarnAmberExplosionYou	= "特殊警报：打断自己的$spell:122398",
	specwarnAmberExplosionAM	= "特殊警报：打断琥珀畸怪的$spell:122402",
	specwarnAmberExplosionOther	= "特殊警报：打断畸形体的$spell:122398",
	timerAmberExplosionAMCD		= "计时条：琥珀畸怪的下一次$spell:122402",
	InfoFrame					= "信息框：意志值",
	FixNameplates				= "在战斗开始后自动关闭影响战斗的姓名面板\n（战斗结束后会自动恢复原始设置）"
})

L:SetMiscLocalization({
	WillPower					= "意志"
})

------------
-- Grand Empress Shek'zeer --
------------
L= DBM:GetModLocalization(743)

L:SetWarningLocalization({
	warnAmberTrap		= "琥珀陷阱：%d/5",
})

L:SetOptionLocalization({
	warnAmberTrap		= "警报：$spell:125826的生成，并提示进度", -- maybe bad translation.
	InfoFrame			= "信息框：受$spell:125390效果影响的玩家",
	InfoYB				= "信息框：音波能量监视(团队中必须有人做焦点)",
	SoundWOP			= "语音警告：重要技能",
	HudMAP				= "高级定位监视(HUD)：$spell:124863的位置",
	HudMAP2				= "高级定位监视(HUD)：$spell:124821的位置",
	RangeFrame			= "距离监视（5码）：$spell:123735",
	StickyResinIcons	= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(124097)
})

L:SetMiscLocalization({
	PlayerDebuffs		= "凝视",
	YellPhase3			= "别找借口了，女皇！消灭这些傻瓜，否则我会亲手杀了你！"

})