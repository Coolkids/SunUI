if GetLocale() ~= "zhTW" then return end
local L

-----------------------
-- Sha of Anger --
-----------------------
L= DBM:GetModLocalization(691)

L:SetOptionLocalization({
	SoundWOP			= "語音警告：重要技能",
	RangeFrame			= "距離監視：$spell:119622",
	HudMAP				= "高級定位監視(HUD)：$spell:119622",
	SetIconOnMC			= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(119622)
})

-----------------------
-- Salyis --
-----------------------
L= DBM:GetModLocalization(725)

L:SetOptionLocalization({
	SoundWOP			= "語音警告：重要技能"
})

--------------
-- Oondasta --
--------------
L= DBM:GetModLocalization(826)

L:SetOptionLocalization({
	SoundWOP			= "語音警告：重要技能",
	RangeFrame			= "距離監視：$spell:137511"
})

L:SetMiscLocalization({
	Pull				= "How dare you interrupt our preparations! The Zandalari will not be stopped, not this time!"
})

---------------------------
-- Nalak, The Storm Lord --
---------------------------
L= DBM:GetModLocalization(814)

L:SetOptionLocalization({
	RangeFrame			= "距離監視(10碼)：$spell:136340"
})
