if GetLocale() ~= "zhTW" then return end
local L

------------
-- The Stone Guard --
------------
L= DBM:GetModLocalization(679)

L:SetWarningLocalization({
	SpecWarnOverloadSoon		= "七秒後：%s",
	specWarnMySD				= "你拉的王點了全團石化",
	specWarnBreakJasperChains	= "拉斷晶紅鎖鏈!"
})

L:SetOptionLocalization({
	SoundWOP			= "語音警告：重要技能",
	InfoFrame			= "信息框：超載能量監視器",
	AInfoFrame			= "信息框：簡化超載監視器(不要和上邊重選)",
	SpecWarnOverloadSoon	= "特殊警報：即將超載",
	specWarnMySD		= "特殊警報：你拉的王點了石化時(坦克)",
	specWarnBreakJasperChains	= "特殊警報：當安全時拉斷$spell:130395",
	ArrowOnJasperChains			= "DBM箭頭：當你獲得$spell:130395時"
})

L:SetMiscLocalization({
	Overload	= "%s要超載了!",
	SDNOT		= "[未石化]",
	SDBLUE		= "[|cFFFFA500石化|r:|cFF0080FF藍|r]",
	SDGREEN		= "[|cFFFFA500石化|r:|cFF088A08綠|r]",
	SDRED		= "[|cFFFFA500石化|r:|cFFFF0404紅|r]",
	SDPURPLE	= "[|cFFFFA500石化|r:|cFF9932CD紫|r]",
	NEXTR		= "|cFFFFA500下次超載|r:|cFFFF0404紅色|r",
	NEXTG		= "|cFFFFA500下次超載|r:|cFF088A08綠色|r",
	NEXTB		= "|cFFFFA500下次超載|r:|cFF0080FF藍色|r",
	NEXTP		= "|cFFFFA500下次超載|r:|cFF9932CD紫色|r"
})


------------
-- Feng the Accursed --
------------
L= DBM:GetModLocalization(689)

L:SetWarningLocalization({
	WarnPhase	= "第 %d 階段"
})

L:SetOptionLocalization({
	SoundWOP			= "語音警告：重要技能",
	InfoFrame			= "資訊框：坦克減益狀態層數監視",
	HudMAP				= "高級定位監視(HUD)：$spell:116784的位置",
	HudMAP2				= "高級定位監視(HUD)：$spell:116417",
	WarnPhase			= "警告：階段轉換"
})

L:SetMiscLocalization({
	Fire		= "噢，至高的神啊!藉由我來融化他們的血肉吧!",
	Arcane		= "噢，上古的賢者!賜予我秘法的智慧!",
	Nature		= "噢，偉大的靈魂!賜予我大地之力!",--I did not log this one, text is probably not right
	Shadow		= "英雄之靈!以盾護我之身!"
})


-------------------------------
-- Gara'jal the Spiritbinder --
-------------------------------
L= DBM:GetModLocalization(682)

L:SetOptionLocalization({
	SoundWOP			= "語音警告：重要技能",
	SoundTT				= "語音警告：$spell:116174",
	SetIconOnVoodoo		= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(122151),
	InfoFrame			= "資訊框：$spell:116161的玩家 (標注\"治療\"需團員選擇角色類型)"
})

L:SetMiscLocalization({
	Pull		= "受死吧，你們!"
})

----------------------
-- The Spirit Kings --
----------------------
L = DBM:GetModLocalization(687)

L:SetOptionLocalization({
	RangeFrame			= "距離監視(8碼)",
	SoundWOP			= "語音警告：重要技能",
	SoundDS				= "語音警告：$spell:117697和$spell:117961的驅散",
	InfoFrame			= "資訊框：$spell:118303的目標",
	HudMAP				= "高級定位監視(HUD)：$spell:118047的位置",
	HudMAP2				= "高級定位監視(HUD)：$spell:118303的目標",
	SoundCT				= "語音警告：$spell:117833的打斷"
})

------------
-- Elegon --
------------
L = DBM:GetModLocalization(726)

L:SetWarningLocalization({
	specWarnDespawnFloor		= "中場即將消失!",
	specWarnCharge				= "能量電荷 [%d] - 轉換目標",
	specWarnProtector			= "星穹保衛者 [%d] - 轉換目標"
})

L:SetTimerLocalization({
	timerDespawnFloor			= "中場消失!"
})

L:SetOptionLocalization({
	SoundWOP					= "語音警告：重要技能",
	SoundCC						= "語音警告：$spell:117949的驅散",
	SoundDD						= "語音警告：為消掉$spell:117878播放額外音效",
	optDBPull					= "語音警告：為正在坦$journal:6178的坦克播放$spell:117960警告",
	specWarnDespawnFloor		= "特殊警告：中場地板消失前",
	specWarnCharge				= "特殊警告：能量電荷",
	specWarnProtector			= "特殊警告：$journal:6178",
	timerDespawnFloor			= "計時器：中場地板消失",
	InfoFrame					= "資訊框：$spell:117878層數最高的5名團員",
	optOC						= "\"超載\"疊加幾層時，開始報警(每三層報警一次)",
	six							= "6層",
	nine						= "9層",
	twelve						= "12層",
	fifteen						= "15層",
	none						= "不報警",
	optPos						= "DBM箭頭：\"能量電荷\"出現前指向\"至高天核\"(入口起逆時針)",
	nonepos						= "不顯示",
	posA 						= "1號位",
	posB 						= "2號位",
	posC 						= "3號位",
	posD						= "4號位",
	posE 						= "5號位",
	posF 						= "6號位"
})

L:SetMiscLocalization({
	Floor				= "能量漩渦的能量正在降低!"
})
------------
-- Will of the Emperor --
------------
L= DBM:GetModLocalization(677)

L:SetOptionLocalization({
	InfoFrame			= "資訊框：$spell:116525的目標",
	SoundWOP			= "語音警告：重要技能",
	SoundADD			= "語音警告：$spell:ej5678",
	optBY				= "語音警告：僅提示此首領的毀滅連擊",
	tarfoc				= "當前目標和專注目標",
	Janxi				= "臻璽(左側傀儡)",
	Qinxi				= "秦璽(右側傀儡)",
	none				= "這個傢伙很懶,誰的提示都不想聽"
})

L:SetMiscLocalization({
	Pull		= "這台機器啟動了!到下一層去!",--Emote
	Rage		= "大帝之怒響徹群山。",--Yell
	Strength	= "帝王之力出現在壁龕裡!",--Emote
	Courage		= "帝王之勇出現在壁龕裡!",--Emote
	Boss		= "兩個泰坦魁儡出現在大壁龕裡!"--Emote
})

