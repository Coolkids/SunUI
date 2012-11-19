if GetLocale() ~= "zhTW" then return end
local L

------------
-- Imperial Vizier Zor'lok --
------------
L= DBM:GetModLocalization(745)

L:SetOptionLocalization({
	specwarnPlatform	= "特別警告：當戰鬥露臺改變時",
	ArrowOnAttenuation	= "DBM箭頭：當$spell:127834出現時指示移動的方向",
	specwarnExhale		= "特別警告：$spell:122761",
	specwarnExhaleB		= "特別警告：$spell:122761的預先警告",
	specwarnAttenuationL	= "特別警告：左旋音波",
	specwarnAttenuationR	= "特別警告：右旋音波",
	specwarnDR				= "特別警告：注意開減傷",
	MindControlIcon		= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(122740),
	SoundWOP			= "語音警告：重要技能",
	HudMAP				= "高級定位監視(HUD)：$spell:122761目標的位置",
	HudMAP2				= "高級定位監視(HUD)：$spell:122740的位置",
	optarrowRTI			= "<定音區>出現時，顯示箭頭指向以下標記的玩家",
	none				= "不顯示箭頭",
	arrow1				= "星星",
	arrow2				= "大餅",
	arrow3				= "菱形",
	arrow4				= "三角",
	arrow5				= "月亮",
	arrow6				= "方塊",
	arrow7				= "叉叉",
	optDR				= "P1階段<力量與氣魄>減傷",
	noDR				= "不關我事",
	DR1					= "P1第一次",
	DR2					= "P1第二次",
	DR3					= "P1第三次",
	DR4					= "P1第四次",
	DR5					= "P1第五次",
	optDRT				= "P2階段<力量與氣魄>減傷",
	noDRT				= "不關我事",
	DRT1				= "P2第一次",
	DRT2				= "P2第二次",
	DRT3				= "P2第三次",
	DRT4				= "P2第四次",
	DRT5				= "P2第五次"
})

L:SetMiscLocalization({
	Platform	= "女皇大臣索拉格飛向他的其中一個露臺!",
	Defeat		= "我們不會屈服於黑暗虛空的絕望之下。如果她的意志要我們滅亡，那麼我們就該滅亡。"
})

L:SetWarningLocalization({
	specwarnPlatform	= "作戰區改變!",
	specwarnAttenuationL	= "← ← ←左左左",
	specwarnAttenuationR	= "右右右→ → →",
	specwarnExhale		= "吐氣[%d] : %s",
	specwarnDR			= ">>本輪你開減傷<<",
	specwarnExhaleB		= "即將 >>%d層<< 吐氣"
})

------------
-- Blade Lord Ta'yak --
------------
L= DBM:GetModLocalization(744)

L:SetOptionLocalization({
	UnseenStrikeArrow	= "DBM箭頭：$spell:122949的目標",
	InfoFrame			= "資訊框：$spell:123474",
	RangeFrame			= "距離監視(8碼)：$spell:123175",
	SpecWarnOverwhelmingAssaultOther = "特別警告：$spell:123081的層數",
	HudMAP				= "高級定位監視(HUD)：$spell:122949的位置",
	SoundWOP			= "語音警告：重要技能"
})

L:SetWarningLocalization({
	SpecWarnOverwhelmingAssaultOther 		= "%s 被壓制 (%d層)"
})

-------------------------------
-- Garalon --
-------------------------------
L= DBM:GetModLocalization(713)

L:SetWarningLocalization({
	specwarnUnder	= "離開紫圈!",
	specWarnPungencyOtherFix = "%s 敏感 (%d)"
})

L:SetOptionLocalization({
	specwarnUnder		= "特別警告：你在BOSS下方",
	PheromonesIcon		= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(122835),
	InfoFrame			= "資訊框：$spell:123081層數監視",
	optTankMode			= "特別警告：費洛蒙換坦策略",
	two					= "二坦模式 (30層敏感以上提示)",
	three				= "三坦模式 (20層敏感以上提示)",
	SoundWOP			= "語音警告：重要技能",
	specWarnPungencyOtherFix = "特別警告：當$spell:123081達到15層時",
	HudMAP				= "高級定位監視(HUD)：$spell:122835的位置",
	SoundFS				= "坦克倒計時：$spell:122735"
})

L:SetMiscLocalization({
	UnderHim	= "在他下面",
	Heroicrush	= "他的對手"
})

----------------------
-- Wind Lord Mel'jarak --
----------------------
L= DBM:GetModLocalization(741)

L:SetOptionLocalization({
	SoundWOP			= "語音警告：重要技能",
	SoundDQ				= "語音警告：$spell:122149的驅散",
	SoundJR				= "語音警告：當你沒有殘渣時提示救琥珀",
	APArrow				= "DBM箭頭：$spell:121881的位置",
	NearAP				= "特殊功能：$spell:121881在你30碼範圍內才播放語音(僅影響語音)",
	ReapetAP			= "特殊功能：若你的$spell:121881在5秒內無人打破則不停呼救",
	HudMAP				= "高級定位監視(HUD)：$spell:121885的位置",
	optHud				= "高級定位監視(HUD)：風之炸彈的位置",
	auto				= "當你中了炸彈時顯示",
	always				= "總是顯示",
	none				= "不顯示",
	RangeFrame			= "距離監視(3碼)：$spell:121881",
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
	warnReshapeLifeTutor		= "1:中斷/益傷目標,, 2:中斷自己, 3:回復體力/意志力, 4:脫離魁儡",
	warnAmberExplosion			= "%s 正在釋放 %s",
	warnInterruptsAvailable		= "可打斷 %s: %s",
	specwarnWillPower			= "意志過低!",
	specwarnAmberExplosionYou	= "打斷 >你自己的< %s!",--Struggle for Control interrupt.
	specwarnAmberExplosionAM	= "%s：打斷 %s!",--Amber Montrosity
	specwarnAmberExplosionOther	= "%s：打斷 %s!"--Amber Montrosity
})

L:SetTimerLocalization{
	timerAmberExplosionAMCD		= "%s 冷卻：%s"
}

L:SetOptionLocalization({
	SoundWOP					= "語音警告：重要技能",
	warnReshapeLifeTutor		= "顯示突變魁儡的能力說明效果",
	warnAmberExplosion			= "警告：$spell:122398",
	warnInterruptsAvailable		= "警告：誰可以打斷$spell:122402",
	specwarnWillPower			= "特殊警告：你的傀儡意志過低",
	specwarnAmberExplosionYou	= "特殊警告：打斷你自己的$spell:122398",
	specwarnAmberExplosionAM	= "特殊警告：打斷琥珀巨怪的$spell:122402",
	specwarnAmberExplosionOther	= "特殊警告：打斷無人控制傀儡體的$spell:122398",
	timerAmberExplosionAMCD		= "計時器：琥珀巨怪的下一次$spell:122402",
	InfoFrame					= "資訊框：玩家的意志力",
	FixNameplates				= "開戰自動禁用干擾的單位名條(離開戰鬥後恢復)"
})

L:SetMiscLocalization({
	WillPower					= "意志力"
})

------------
-- Grand Empress Shek'zeer --
------------
L= DBM:GetModLocalization(743)

L:SetWarningLocalization({
	warnAmberTrap		= "琥珀陷阱：%d/5",
})

L:SetOptionLocalization({
	warnAmberTrap		= "警告：$spell:125826的生成和進度", -- maybe bad translation.
	InfoFrame			= "資訊框：被$spell:125390的團員",
	SoundWOP			= "語音警告：重要技能",
	HudMAP				= "高級定位監視(HUD)：$spell:124863的位置",
	HudMAP2				= "高級定位監視(HUD)：$spell:124821的位置",
	RangeFrame			= "距離監視(5碼)：$spell:123735",
	StickyResinIcons	= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(124097)
})

L:SetMiscLocalization({
	PlayerDebuffs	= "被凝視",
	YellPhase3		= "不要再找藉口了，女皇!消滅這些侏儒，否則我會親自殺了妳!"
})
