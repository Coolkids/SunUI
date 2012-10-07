local L

------------
-- Imperial Vizier Zor'lok --
------------
L= DBM:GetModLocalization(745)

L:SetWarningLocalization({
	specwarnPlatform	= "Platform change",
	MindControlIcon		= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(122740)
})

L:SetOptionLocalization({
	specwarnPlatform	= "Show special warning when boss changes platforms",
	MindControlIcon		= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(122740),
	SoundWOP			= "Voice warning: important skills",
	HudMAP				= "HudMAP: $spell:122761 targeting",
	HudMAP2				= "HudMAP: $spell:122740",
	optarrowRTI			= "showing arrow pointing to the following tag game player when Set zone appears",
	none				= "none",
	arrow1				= "Star",
	arrow2				= "Circle",
	arrow3				= "Diamond",
	arrow4				= "Triangle",
	arrow5				= "moon",
	arrow6				= "Square",
	arrow7				= "Fork"
})

L:SetMiscLocalization({
	Platform	= "%s flies to one of his platforms!",
	Defeat		= "We will not give in to the despair of the dark void. If Her will for us is to perish, then it shall be so."
})


------------
-- Blade Lord Ta'yak --
------------
L= DBM:GetModLocalization(744)

L:SetOptionLocalization({
	UnseenStrikeArrow	= "Show DBM Arrow when someone is affected by $spell:122949",
	RangeFrame			= "Show range frame (8) for $spell:123175",
	InfoFrame			= "InfoFrame:$spell:123474",
	SpecWarnOverwhelmingAssaultOther = "Special warning: $spell:123081",
	HudMAP				= "HUDMAP:$spell:122949",
	SoundWOP			= "Voice warning: important skills"
})

L:SetWarningLocalization({
	SpecWarnOverwhelmingAssaultOther 		= "%s - (%d)"
})

-------------------------------
-- Garalon --
-------------------------------
L= DBM:GetModLocalization(713)

L:SetOptionLocalization({
	PheromonesIcon	= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(122835),
	InfoFrame			= "InfoFrame:$spell:123081",
	optTankMode			= "Special warning:how to change tank",
	two					= "2 tanks (30 stacks)",
	three				= "3 tanks (20 stacks)",
	SoundWOP			= "Voice warning: important skills",
	SpecWarnPungencyOther = "Special warning: $spell:123081",
	HudMAP				= "HUDMAP: $spell:122835µÄÎ»ÖÃ",
	SoundFS				= "Countdown: $spell:122735"
})

L:SetWarningLocalization({
	SpecWarnPungencyOther 		= "%s - (%d)"
})

----------------------
-- Wind Lord Mel'jarak --
----------------------
L= DBM:GetModLocalization(741)

L:SetOptionLocalization({
	SoundWOP			= "voice warning: important skills",
	SoundDQ				= "voice warning: $spell:122149 disperse",
	APArrow				= "DBM arrow: $spell:121881",
	NearAP				= "voice warning: only warn within 20 yards of $spell:121881",
	ReapetAP			= "special warning: if your $spell:121881 without breaking in 5 seconds then keeping yell",
	HudMAP				= "HUDMAP:$spell:121885",
	AmberPrisonIcons	= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(121885)
})

L:SetMiscLocalization({
	Helpme				= "Help me ~~~",
	Reinforcements		= "Wind Lord Mel'jarak calls for reinforcements!"
})

------------
-- Amber-Shaper Un'sok --
------------
L= DBM:GetModLocalization(737)

L:SetOptionLocalization({
	SoundWOP			= "voice warning: important skills"
})

------------
-- Grand Empress Shek'zeer --
------------
L= DBM:GetModLocalization(743)

L:SetOptionLocalization({
	InfoFrame		= "Show info frame for players affected by $spell:125390",
	RangeFrame		= "Show range frame (5) for $spell:123735",
	SoundWOP		= "voice warning: important skills",
	HudMAP			= "HUDMAP: $spell:124863",
})

L:SetMiscLocalization({
	PlayerDebuffs	= "Fixated"
})
