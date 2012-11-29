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
	SoundWOP			= "語音警告：重要技能",
	optDDall			= "只有在你的目標是水王時才提示打斷鏈(不選則總是提示)",
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
	SoundJK						= "語音警告：$spell:123011的預先警告",
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
	warnHideOver			= "%s 已結束"
})

L:SetTimerLocalization({
	timerSpecialCD			= "下一次特殊技能"
})

L:SetOptionLocalization({
	warnHideOver			= "警告：當$spell:123244結束時",
	timerSpecialCD			= "計時器：下一次特殊技能",
	SoundWOP				= "語音警告：重要技能",
	SetIconOnGuard		= "為$journal:6224設置團隊標記"
})

L:SetMiscLocalization{
	Victory	= "我...啊..喔!我曾經...?我是不是...?這一切...都太...模糊了。"--wtb alternate and less crappy victory event.
}


----------------------
-- Sha of Fear --
----------------------
L= DBM:GetModLocalization(709)

L:SetOptionLocalization({
	SoundDD				= "語音警告：$spell:131996",
	SoundWOP			= "語音警告：重要技能"
})