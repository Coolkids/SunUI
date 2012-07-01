local L

--------------------------
--  Halfus Wyrmbreaker  --
--------------------------
L = DBM:GetModLocalization("HalfusWyrmbreaker")

L:SetGeneralLocalization({
	name =	"Halfus Wyrmbreaker"
})

L:SetOptionLocalization({
	SoundWOP = "Play Extra Warning Sound",
	ShowDrakeHealth		= "Show the health of released drakes\n(Requires Boss Health enabled)"
})

---------------------------
--  Valiona & Theralion  --
---------------------------
L = DBM:GetModLocalization("ValionaTheralion")

L:SetGeneralLocalization({
	name =	"Valiona & Theralion"
})

L:SetOptionLocalization({
	SoundWOP = "Play Extra Warning Sound",
	TBwarnWhileBlackout		= "Show $spell:92898 warning when $spell:86788 active",
	TwilightBlastArrow		= "Show DBM arrow when $spell:92898 is near you",
	RangeFrame				= "Show range frame (10)",
	BlackoutShieldFrame		= "Show boss health with a health bar for $spell:92878",
	BlackoutIcon			= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(92878),
	EngulfingIcon			= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(86622)
})

L:SetMiscLocalization({
	Trigger1				= "Deep Breath",
	BlackoutTarget			= "Blackout: %s"
})

----------------------------------
--  Twilight Ascendant Council  --
----------------------------------
L = DBM:GetModLocalization("AscendantCouncil")

L:SetGeneralLocalization({
	name =	"Twilight Ascendant Council"
})

L:SetWarningLocalization({
	specWarnBossLow			= "%s below 30%% - next phase soon!",
	SpecWarnGrounded		= "Get Grounded",
	SpecWarnSearingWinds	= "Get Searing Winds"
})

L:SetTimerLocalization({
	timerTransition			= "Phase Transition"
})

L:SetOptionLocalization({
	SoundWOP = "Play Extra Warning Sound",
	specWarnBossLow			= "Show special warning when Bosses are below 30% HP",
	SpecWarnGrounded		= "Show special warning when you are missing $spell:83581 debuff\n(~10sec before cast)",
	SpecWarnSearingWinds	= "Show special warning when you are missing $spell:83500 debuff\n(~10sec before cast)",
	timerTransition			= "Show Phase transition timer",
	RangeFrame				= "Show range frame automatically when needed",
	yellScrewed				= "Yell when you have $spell:83099 & $spell:92307 at same time",
	InfoFrame				= "Show info frame for players without $spell:83581 or $spell:83500",
	HeartIceIcon			= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(82665),
	BurningBloodIcon		= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(82660),
	LightningRodIcon		= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(83099),
	GravityCrushIcon		= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(84948),
	FrostBeaconIcon			= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(92307),
	StaticOverloadIcon		= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(92067),
	GravityCoreIcon			= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(92075)
})

L:SetMiscLocalization({
	Quake			= "The ground beneath you rumbles ominously....",
	Thundershock	= "The surrounding air crackles with energy....",
	Switch			= "Enough of this foolishness!",--"We will handle them!" comes 3 seconds after this one
	Phase3			= "An impressive display...",--"BEHOLD YOUR DOOM!" is about 13 seconds after
	Ignacious		= "Ignacious",
	Feludius		= "Feludius",
	Arion			= "Arion",
	Terrastra		= "Terrastra",
	Monstrosity		= "Elementium Monstrosity",
	Kill			= "Impossible....",
	blizzHatesMe	= "Beacon & Rod on me! Clear a path!",--You're probably fucked, and gonna kill half your raid if this happens, but worth a try anyways :).
	WrongDebuff	= "No %s"
})

----------------
--  Cho'gall  --
----------------
L = DBM:GetModLocalization("Chogall")

L:SetGeneralLocalization({
	name =	"Cho'gall"
})

L:SetOptionLocalization({
	SoundWOP = "Play Extra Warning Sound",
	CorruptingCrashArrow	= "Show DBM arrow when $spell:93178 is near you",
	InfoFrame				= "Show info frame for $spell:81701",
	RangeFrame				= "Show range frame (5) for $spell:82235",
	SetIconOnWorship		= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(91317),
	SetIconOnCrash		= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(93179),
	SetIconOnCreature		= "Set icons on Darkened Creations"
})

L:SetMiscLocalization({
	Bloodlevel				= "Corruption"
})

----------------
--  Sinestra  --
----------------
L = DBM:GetModLocalization("Sinestra")

L:SetGeneralLocalization({
	name =	"Sinestra"
})

L:SetWarningLocalization({
	WarnFlameBreath		= "Flame Breath (%d)",
	WarnDragon			= "Twilight Whelp Spawned",
	WarnOrbSoon			= "Orbs in %d sec!",
	SpecWarnOrbs		= "Orbs coming! Watch Out!",
	warnWrackJump		= "%s jumped to >%s<",
	warnAggro			= "Players with Aggro (Orbs candidates): >%s< ",
	SpecWarnAggroOnYou	= "You have Aggro! Watch Orbs!",
	SpecWarnDispel		= "%d sec elapsed since last Wrack - Dispel Now!",
	SpecWarnEggWeaken	= "Twilight Carapace dissipated - Dps EGG Now!",
	SpecWarnEggShield	= "Twilight Capapace Regenerated!"
})

L:SetTimerLocalization({
	TimerFlameBreath			= "Next Flame Breath (%d)",
	TimerDragon			= "Next Twilight Whelps",
	TimerEggWeakening	= "Twilight Carapace dissipates",
	TimerEggWeaken		= "Twilight Capapace Regeneration",
	TimerOrbs			= "Shadow Orbs CD"
})

L:SetOptionLocalization({
	SoundWOP = "Play Extra Warning Sound",
	SoundDIS = "Play Warning Sound to dispel $spell:92955",
	SoundPAL1 = "Play Warning Sound when the first $spell:92955 player need $spell:6940 during odd turn",
	SoundPAL2 = "Play Warning Sound when the first $spell:92955 player need $spell:6940 during even turn",
	SoundMAura = "Play Warning Sound for $spell:31821 when the third $spell:92944 is coming",
	WarnFlameBreath		= "Show warning for $spell:92944",
	WarnDragon			= "Show warning when Twilight Whelp Spawns",
	WarnOrbSoon			= "Show pre-warning for Orbs (Before 5s, Every 1s)\n(Expected warning. may not be accurate. Can be spammy.)",
	warnWrackJump		= "Announce $spell:92955 jump targets",
	warnAggro			= "Announce players who have Aggro when Orbs spawn (Can be target of Orbs)",
	SpecWarnAggroOnYou	= "Show special warning if you have Aggro when Orbs spawn\n(Can be target of Orbs)",
	SpecWarnOrbs		= "Show special warning when Orbs spawn (Expected warning)",
	SpecWarnDispel		= "Show special warning to dispel $spell:92955\n(after certain time elapsed from casted/jumped)",
	SpecWarnEggWeaken	= "Show special warning when $spell:87654 dissipates",
	SpecWarnEggShield	= "Show special warning when $spell:87654 regenerated",
	TimerFlameBreath			= "Show timer for $spell:92944",
	TimerDragon			= "Show timer for new Twilight Whelp",
	TimerEggWeakening	= "Show timer for when $spell:87654 dissipates",
	TimerEggWeaken		= "Show timer for $spell:87654 regeneration",
	TimerOrbs			= "Show timer for next Orbs (Expected timer. may not be accurate)",
	SetIconOnOrbs		= "Set icons on players who have Aggro when Orbs spawn\n(Can be target of Orbs)",
	OrbsCountdown		= "Play countdown sound for Orbs",
	InfoFrame			= "Show info frame for players who have aggro"
})

L:SetMiscLocalization({
	YellDragon			= "Feed, children!  Take your fill from their meaty husks!",
	YellEgg				= "You mistake this for weakness?  Fool!",
	HasAggro			= "Has Aggro"
})

--------------------------
--  The Bastion of Twilight Trash  --
--------------------------
L = DBM:GetModLocalization("BoTrash")

L:SetGeneralLocalization({
	name =	"The Bastion of Twilight Trash"
})
