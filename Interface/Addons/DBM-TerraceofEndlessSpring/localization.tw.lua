if GetLocale() ~= "zhTW" then return end
local L

------------
-- Protectors of the Endless --
------------
L= DBM:GetModLocalization(683)

L:SetWarningLocalization({
	specWarnDDL 	= ">> 下一次 到你斷 <<"
})

L:SetOptionLocalization({
	RangeFrame			= "距離監視(8碼)：$spell:111850(智能)",
	HudMAP				= "高級定位監視(HUD)：$spell:111850的位置",
	SetIconOnPrison		= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(117436),
	SoundDW				= "語音警告：$spell:117283的驅散",
	SoundSDQ			= "語音警告：$spell:117436的驅散",
	SoundWOP			= "語音警告：重要技能",
	optDDall			= "只有在你的目標是水王時才提示打斷鏈(不選則總是提示)",
	optDD4				= "使用四人打斷鏈(不選則前3人循環)",
	specWarnDDL 		= "特殊警告：下一次到你打斷",
	optDD				= "水王打斷鏈",
	nodd				= "我不打斷",
	DD1					= "打斷1",
	DD2					= "打斷2",
	DD3					= "打斷3",
	DD4					= "打斷4",
})


------------
-- Tsulong --
------------
L= DBM:GetModLocalization(742)

L:SetOptionLocalization({
	SoundWOP					= "語音警告：重要技能",
	WarnJK						= "語音警告：$spell:123011的預先警告",
	HudMAP						= "高級定位監視(HUD)：$spell:122770的位置(僅10人)",
	optDS						= "\"恐怖陰影\"疊加幾層時，開始報警",
	six							= "6層",
	nine						= "9層",
	twelve						= "12層",
	fifteen						= "15層",
	none						= "不報警",
})

L:SetMiscLocalization{
	Victory	= "謝謝你，陌生人。我重獲自由了。"
}


-------------------------------
-- Lei Shi --
-------------------------------
L= DBM:GetModLocalization(729)

L:SetWarningLocalization({
	warnHideOver			= "%s 結束",
	warnHideProgress		= "擊中：%s，傷害：%s，時間：%s"
})

L:SetTimerLocalization({
	timerSpecialCD			= "下一次特殊技能(%d)"
})

L:SetOptionLocalization({
	warnHideOver			= "警告：當$spell:123244結束時",
	warnHideProgress		= "當$spell:123244結束後顯示統計",
	timerSpecialCD			= "計時器：下一次特殊技能",
	SoundWOP				= "語音警告：重要技能",
	SetIconOnGuardfix		= "為$journal:6224設置團隊標記",
	RangeFrame				= "距離監視(3碼)：$spell:123121(與坦克距離)",
	GWHealthFrame			= "生命監視：移除$spell:123461還需要的傷害"
})

L:SetMiscLocalization{
	Victory	= "我...啊..喔!我曾經...?我是不是...?這一切...都太...模糊了。"--wtb alternate and less crappy victory event.
}


----------------------
-- Sha of Fear --
----------------------
L= DBM:GetModLocalization(709)

L:SetWarningLocalization({
	specWarnyinmo		= "隱沒 > %d <",
	specWarnfuxian		= "浮現! 新出現>%d<個畏懼之子",
	specWarnweisuo		= "恐懼畏縮 > %d <", 
})

L:SetTimerLocalization({
	timerSpecialCD			= "下一次P2特殊技能"
})

L:SetOptionLocalization({
	SoundDD				= "語音警告：$spell:131996",
	SoundWOP			= "語音警告：重要技能",
	RangeFrame			= "距離監視（2碼）：$spell:119519",
	pscount				= "語音警告：為恐怖噴散報數",
	HudMAP				= "高級定位監視(HUD)：$spell:120519",
	InfoFrame			= "資訊框：$spell:120629",
	timerSpecialCD		= "計時器：下一次P2特殊技能",
	specWarnyinmo		= "特殊警告：$spell:120455",
	specWarnfuxian		= "特殊警告：$spell:120458",
	specWarnweisuo		= "特殊警告：$spell:120629",
	ShaAssist			= "特殊功能：啟用恐怖噴散方向指示圖",
	ShaStarMode			= "治療/DPS的恐怖噴散指示使用星辰跑位模式(硬吃一擊以減少跑位)"
})