local L

------------
-- Protectors of the Endless --
------------
L= DBM:GetModLocalization(683)

L:SetOptionLocalization({
	RangeFrame			= "Show range frame (8) for $spell:111850\n(Shows everyone if you have debuff, only players with debuff if not)",
	SetIconOnPrison		= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(117436),
	HudMAP 				= "HudMAP: $spell:111850",
	SoundDW 			= "voice warning: $spell:117283 disperse",
	SoundWOP			= "voice warning: important skills"
})


------------
-- Tsulong --
------------
L= DBM:GetModLocalization(742)

L:SetOptionLocalization ({
	SoundWOP 	= "voice warning: important skills",
	SoundJK 	= "voice warning: $spell:123011 advance warning",
	HudMAP 		= "HudMAP:$spell:122770 (only 10N/10H Mode) ",
	optDS 		= "shadow of terror, how many stacks start warning",
	six 		= "6",
	nine 		= "9",
	twelve 		= "12",
	fifteen 	= "15",
	none 		= "Don't warning"
})

L:SetMiscLocalization{
	Victory	= "I thank you, strangers. I have been freed."
}


-------------------------------
-- Lei Shi --
-------------------------------
L= DBM:GetModLocalization(729)

L:SetWarningLocalization({
	warnHideOver			= "%s has ended"
})

L:SetTimerLocalization({
	timerSpecialCD			= "Next Special"
})

L:SetOptionLocalization({
	warnHideOver			= "Show warning when $spell:123244 has ended",
	timerSpecialCD			= "Show timer for when next special ability will be cast.",
	SoundWOP 				= "voice warning: important skills",
	SetIconOnGuard		= "Set icons on $journal:6224"
})

L:SetMiscLocalization{
	Victory	= "I... ah... oh! Did I...? Was I...? It was... so... cloudy."--wtb alternate and less crappy victory event.
}


----------------------
-- Sha of Fear --
----------------------
L= DBM:GetModLocalization(709)

L:SetOptionLocalization ({
	SoundDD = "voice warning: $spell:131996",
	SoundWOP = "voice warning: important skills"
})