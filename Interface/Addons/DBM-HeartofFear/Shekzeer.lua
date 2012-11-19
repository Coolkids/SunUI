local mod	= DBM:NewMod(743, "DBM-HeartofFear", nil, 330)
local L		= mod:GetLocalizedStrings()
local sndWOP	= mod:NewSound(nil, "SoundWOP", true)

mod:SetRevision(("$Revision: 8127 $"):sub(12, -3))
mod:SetCreatureID(62837)--62847 Dissonance Field, 63591 Kor'thik Reaver, 63589 Set'thik Windblade
mod:SetModelID(42730)
mod:SetZone()
mod:SetUsedIcons(1, 2)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_AURA_REMOVED",
	"SPELL_CAST_SUCCESS",
	"SPELL_CAST_START",
	"CHAT_MSG_MONSTER_YELL",
	"UNIT_SPELLCAST_SUCCEEDED"
)

local warnScreech				= mod:NewSpellAnnounce(123735, 3, nil, mod:IsRanged())
local warnCryOfTerror			= mod:NewTargetAnnounce(123788, 3, nil, mod:IsHealer())
local warnEyes					= mod:NewStackAnnounce(123707, 2, nil, mod:IsTank())
local warnSonicDischarge		= mod:NewSoonAnnounce(123504, 4)--Iffy reliability but better then nothing i suppose.
local warnRetreat				= mod:NewSpellAnnounce(125098, 4)
local warnAmberTrap				= mod:NewAnnounce("warnAmberTrap", 2, 125826)
local warnTrapped				= mod:NewTargetAnnounce(125822, 1)--Trap used
local warnStickyResin			= mod:NewTargetAnnounce(124097, 3)
local warnFixate				= mod:NewTargetAnnounce(125390, 3, nil, false)--Spammy
local warnAdvance				= mod:NewSpellAnnounce(125304, 4)
local warnVisions				= mod:NewTargetAnnounce(124862, 4)--Visions of Demise
local warnPhase3				= mod:NewPhaseAnnounce(3)
local warnCalamity				= mod:NewSpellAnnounce(124845, 3, nil, mod:IsHealer())
local warnConsumingTerror		= mod:NewSpellAnnounce(124849, 4, nil, not mod:IsTank())

local specwarnSonicDischarge	= mod:NewSpecialWarningSpell(123504, nil, nil, nil, true)
local specWarnEyes				= mod:NewSpecialWarningStack(123707, mod:IsTank(), 4)
local specWarnEyesOther			= mod:NewSpecialWarningTarget(123707, mod:IsTank())
local specwarnCryOfTerror		= mod:NewSpecialWarningYou(123788)
local specWarnRetreat			= mod:NewSpecialWarningSpell(125098)
local specwarnAmberTrap			= mod:NewSpecialWarningSpell(125826, false)
local specwarnStickyResin		= mod:NewSpecialWarningYou(124097)
local yellStickyResin			= mod:NewYell(124097)
local specwarnFixate			= mod:NewSpecialWarningYou(125390, false)--Could be spammy, make optional, will use info frame to display this more constructively
local specWarnDispatch			= mod:NewSpecialWarningInterrupt(124077, mod:IsMelee())
local specWarnAdvance			= mod:NewSpecialWarningSpell(125304)
local specwarnVisions			= mod:NewSpecialWarningYou(124862)
local specwarnXJ				= mod:NewSpecialWarningMove(123184)
local yellVisions				= mod:NewYell(124862, nil, false)
local specWarnConsumingTerror	= mod:NewSpecialWarningSpell(124849, not mod:IsTank())

local timerScreechCD			= mod:NewNextTimer(7, 123735, nil, mod:IsRanged())
local timerCryOfTerror			= mod:NewTargetTimer(20, 123788, nil, mod:IsHealer())
local timerCryOfTerrorCD		= mod:NewCDTimer(25, 123788)
local timerEyes					= mod:NewTargetTimer(30, 123707, nil, mod:IsTank())
local timerEyesCD				= mod:NewNextTimer(11, 123707, nil, mod:IsTank())
local timerPhase1				= mod:NewNextTimer(156.4, 125304)--156.4 til ENGAGE fires and boss is out, 157.4 until "advance" fires though. But 156.4 is more accurate timer
local timerPhase2				= mod:NewNextTimer(151, 125098)--152 until trigger, but probalby 150 or 151 til adds are targetable.
local timerCalamityCD			= mod:NewCDTimer(6, 124845, nil, mod:IsHealer())
local timerVisionsCD			= mod:NewCDTimer(19.5, 124862)
local timerConsumingTerrorCD	= mod:NewCDTimer(32, 124849, nil, not mod:IsTank())

local timerQJ					= mod:NewTargetTimer(120, 124821)
local timerDQ					= mod:NewBuffFadesTimer(30, 124827)

mod:AddBoolOption("InfoFrame")--On by default because these do more then just melee, they interrupt spellcasting (bad for healers)
mod:AddBoolOption("RangeFrame", mod:IsRanged())
mod:AddBoolOption("StickyResinIcons", true)

local sentLowHP = {}
local warnedLowHP = {}
local visonsTargets = {}
local resinIcon = 2
local shaName = EJ_GetEncounterInfo(709)
local phase3Started = false
local warnedhp = false

local function warnVisionsTargets()
	warnVisions:Show(table.concat(visonsTargets, "<, >"))
	timerVisionsCD:Start()
	table.wipe(visonsTargets)
end

local ptwo = false

mod:AddBoolOption("HudMAP", true, "sound")
mod:AddBoolOption("HudMAP2", false, "sound")
local DBMHudMap = DBMHudMap
local free = DBMHudMap.free
local function register(e)	
	DBMHudMap:RegisterEncounterMarker(e)
	return e
end
local DeadMarkers = {}
local QJMarkers = {}

function mod:OnCombatStart(delay)
	phase3Started = false
	resinIcon = 2
	timerScreechCD:Start(-delay)
	timerEyesCD:Start(-delay)
	timerPhase2:Start(-delay)
	table.wipe(sentLowHP)
	table.wipe(warnedLowHP)
	table.wipe(visonsTargets)
	table.wipe(DeadMarkers)
	table.wipe(QJMarkers)
	ptwo = false
	warnedhp = false
	if self.Options.RangeFrame then
		DBM.RangeCheck:Show(5)
	end
	self:RegisterShortTermEvents(
		"UNIT_HEALTH_FREQUENT_UNFILTERED"
	)
end

function mod:OnCombatEnd()
	self:UnregisterShortTermEvents()
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
	if self.Options.HudMAP or self.Options.HudMAP2 then
		DBMHudMap:FreeEncounterMarkers()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(123707) then
		warnEyes:Show(args.destName, args.amount or 1)
		timerEyes:Start(args.destName)
		timerEyesCD:Start()
		if args:IsPlayer() and (args.amount or 1) >= 4 then
			specWarnEyes:Show(args.amount)
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_csgg.mp3") --層數過高
		else
			if (args.amount or 1) >= 3 and not UnitDebuff("player", GetSpellInfo(123735)) and not UnitIsDeadOrGhost("player") then
				specWarnEyesOther:Show(args.destName)
				if mod:IsTank() then
					sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\changemt.mp3") --換坦嘲諷
				end
			end
		end
	elseif args:IsSpellID(123788) then
		warnCryOfTerror:Show(args.destName)
		timerCryOfTerror:Start(args.destName)
		timerCryOfTerrorCD:Start()
		if args:IsPlayer() then
			DBM.Flash:Show(1, 0, 0)
			specwarnCryOfTerror:Show()
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_kjyy.mp3") --快進音域
		end
	elseif args:IsSpellID(124748) then
		warnAmberTrap:Show(args.amount or 1)
	elseif args:IsSpellID(125822) then
		warnTrapped:Show(args.destName)
	elseif args:IsSpellID(125390) then
		warnFixate:Show(args.destName)
		if args:IsPlayer() then
			specwarnFixate:Show()
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\justrun.mp3") --快跑
		end
	elseif args:IsSpellID(124862) then
		visonsTargets[#visonsTargets + 1] = args.destName
		if args:IsPlayer() then
			specwarnVisions:Show()
			yellVisions:Yell()
			DBM.Flash:Show(1, 0, 0)
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\runout.mp3") --離開人群
			sndWOP:Schedule(1.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
			sndWOP:Schedule(2.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
			sndWOP:Schedule(3.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
		end
		if mod:IsHealer() then
			sndWOP:Schedule(4, "Interface\\AddOns\\DBM-Core\\extrasounds\\dispelnow.mp3")
		end
		self:Unschedule(warnVisionsTargets)
		self:Schedule(0.3, warnVisionsTargets)
		if self.Options.HudMAP then
			DeadMarkers[args.destName] = register(DBMHudMap:PlaceRangeMarkerOnPartyMember("targeting", args.destName, 9, nil, 0, 1, 0, 1):Appear():RegisterForAlerts())
		end
	elseif args:IsSpellID(124097) then
		warnStickyResin:Show(args.destName)
		if args:IsPlayer() then
			specwarnStickyResin:Show()
			DBM.Flash:Show(1, 0, 0)
			yellStickyResin:Yell()
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_szkp.mp3") --樹脂
		end
		if self.Options.StickyResinIcons then
			self:SetIcon(args.destName, resinIcon)
			if resinIcon == 2 then
				resinIcon = 1
			else
				resinIcon = 2
			end
		end
	elseif args:IsSpellID(123184) then
		if not UnitDebuff("player", GetSpellInfo(123788)) then
			if args:IsPlayer() then
				specwarnXJ:Show()
				sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\runaway.mp3") --快躲開
			end
		end
	elseif args:IsSpellID(124821) then
		timerQJ:Start(120, args.destName)
		if self.Options.HudMAP2 then
			QJMarkers[args.destName] = register(DBMHudMap:PlaceRangeMarkerOnPartyMember("timer", args.destName, 2, nil, 0, 1, 0, 1):Appear():RegisterForAlerts():Rotate(360, 120))
		end
	elseif args:IsSpellID(124827) then
		if args:IsPlayer() then
			timerDQ:Start()
		end
	elseif args:IsSpellID(124077) then
		if args.sourceGUID == UnitGUID("target") then--Only show warning for your own target.
			specWarnDispatch:Show(args.sourceName)
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\kickcast.mp3")--快打斷
		end
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(123788) then
		timerCryOfTerror:Cancel(args.destName)
	elseif args:IsSpellID(123707) then
		if mod:IsTank() and (not ptwo) then
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\changemt.mp3") --換坦嘲諷
		end
	elseif args:IsSpellID(125390) then
		if args:IsPlayer() then
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\safenow.mp3") --安全
		end
	elseif args:IsSpellID(124097) then
		if self.Options.StickyResinIcons then
			self:SetIcon(args.destName, 0)
		end
	elseif args:IsSpellID(124862) then
		if DeadMarkers[args.destName] then
			DeadMarkers[args.destName] = free(DeadMarkers[args.destName])
		end
	elseif args:IsSpellID(124821) then
		timerQJ:Cancel(args.destName)
		if QJMarkers[args.destName] then
			QJMarkers[args.destName] = free(QJMarkers[args.destName])
		end
	elseif args:IsSpellID(124827) then
		if args:IsPlayer() then
			timerDQ:Cancel()
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(123735) then
		warnScreech:Show()
		timerScreechCD:Start()
	elseif args:IsSpellID(124748) then
		warnAmberTrap:Show(1)
	elseif args:IsSpellID(125826) then
		warnAmberTrap:Show()
		specwarnAmberTrap:Show()
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_xjwc.mp3") --陷阱完成
	elseif args:IsSpellID(124845) then
		warnCalamity:Show()
		timerCalamityCD:Start()
	--"<33.5 22:57:49> [CHAT_MSG_MONSTER_YELL] CHAT_MSG_MONSTER_YELL#No more excuses, Empress! Eliminate these cretins or I will kill you myself!#Sha of Fear###Grand Empress Shek'zeer
	--"<36.8 22:57:52> [CLEU] SPELL_CAST_SUCCESS#false#0xF130F9C600007497#Sha of Fear#2632#0#0x0000000000000000#nil#-2147483648#-2147483648#125451#Ultimate Corruption#1", -- [7436]
	--backup phase 3 trigger for unlocalized languages
	elseif args:IsSpellID(125451) and not phase3Started then
		phase3Started = true
		self:UnregisterShortTermEvents()
		if self.Options.RangeFrame then
			DBM.RangeCheck:Hide()
		end
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\ptwo.mp3")
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\countfour.mp3")
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
		timerPhase2:Cancel()
		timerConsumingTerrorCD:Cancel()
		timerScreechCD:Cancel()
		warnPhase3:Show()
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\pthree.mp3")--p3
		timerVisionsCD:Start(4)
		timerCalamityCD:Start(9)
		timerConsumingTerrorCD:Start(11)
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(124849) then
		warnConsumingTerror:Show()
		specWarnConsumingTerror:Show()
		timerConsumingTerrorCD:Start()
		if mod:IsTank() then
			DBM.Flash:Show(1, 0, 0)
		end
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_kjts.mp3")--恐懼吞噬
	end
end

--[[ Yell comes 3 seconds sooner then combat log event, so it's better phase 3 transitioner to start better timers, especially for first visions of demise
"<33.5 22:57:49> [CHAT_MSG_MONSTER_YELL] CHAT_MSG_MONSTER_YELL#No more excuses, Empress! Eliminate these cretins or I will kill you myself!#Sha of Fear###Grand Empress Shek'zeer
"<36.8 22:57:52> [CLEU] SPELL_CAST_SUCCESS#false#0xF130F9C600007497#Sha of Fear#2632#0#0x0000000000000000#nil#-2147483648#-2147483648#125451#Ultimate Corruption#1", -- [7436]
--]]
function mod:CHAT_MSG_MONSTER_YELL(msg)
	if (msg == L.YellPhase3 or msg:find(L.YellPhase3)) and not phase3Started then
		phase3Started = true
		self:UnregisterShortTermEvents()
		if self.Options.RangeFrame then
			DBM.RangeCheck:Hide()
		end
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\ptwo.mp3")
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\countfour.mp3")
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
		timerPhase2:Cancel()
		timerConsumingTerrorCD:Cancel()
		timerScreechCD:Cancel()
		warnPhase3:Show()
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\pthree.mp3")--p3
		timerVisionsCD:Start(7)
		timerCalamityCD:Start(12)
		timerConsumingTerrorCD:Start(14)
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, _, _, spellId)
	if spellId == 125098 and self:AntiSpam(2, 1) then--Yell is about 1.5 seconds faster then this event, BUT, it also requires localizing. I don't think doing it this way hurts anything.
		self:UnregisterShortTermEvents()
		timerScreechCD:Cancel()
		timerCryOfTerrorCD:Cancel()
		timerEyesCD:Cancel()
		warnRetreat:Show()
		specWarnRetreat:Show()
		timerPhase1:Start()
		ptwo = true
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\phasechange.mp3")--階段轉換
		sndWOP:Schedule(152, "Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_nwzb.mp3") --女王準備
		sndWOP:Schedule(153, "Interface\\AddOns\\DBM-Core\\extrasounds\\countfour.mp3")
		sndWOP:Schedule(154, "Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
		sndWOP:Schedule(155, "Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
		sndWOP:Schedule(156, "Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
		if self.Options.InfoFrame then
			DBM.InfoFrame:SetHeader(L.PlayerDebuffs)
			DBM.InfoFrame:Show(10, "playerbaddebuff", 125390)
		end
		if self.Options.RangeFrame then
			DBM.RangeCheck:Hide()
		end
	elseif spellId == 125304 and self:AntiSpam(2, 1) then
		timerPhase1:Cancel()--If you kill everything it should end early.
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_nwzb.mp3")
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\countfive.mp3")
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\countfour.mp3")
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
		warnAdvance:Show()
		specWarnAdvance:Show()
		timerPhase2:Start()--Assumed same as pull
		ptwo = false
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\phasechange.mp3")--階段轉換
		sndWOP:Schedule(147, "Interface\\AddOns\\DBM-Core\\extrasounds\\ptwo.mp3")--P2
		sndWOP:Schedule(148, "Interface\\AddOns\\DBM-Core\\extrasounds\\countfour.mp3")
		sndWOP:Schedule(149, "Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
		sndWOP:Schedule(150, "Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
		sndWOP:Schedule(151, "Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
		if self.Options.InfoFrame then--Will do this more accurately when i have an accurate count of mobs for all difficulties and then i can hide it when mobcount reaches 0
			DBM.InfoFrame:Hide()
		end
		if self.Options.RangeFrame then
			DBM.RangeCheck:Show(5)
		end
		self:RegisterShortTermEvents(
			"UNIT_HEALTH_FREQUENT_UNFILTERED"
		)
	end
end

--May not be that reliable, because they don't have a special unitID and there is little reason to target them.
--So it may miss some of them, not sure of any other way to PRE-warn though. Can warn on actual cast/damage but not too effective.
function mod:UNIT_HEALTH_FREQUENT_UNFILTERED(uId)
	local cid = self:GetUnitCreatureId(uId)
	local guid = UnitGUID(uId)
	if cid == 62847 and UnitHealth(uId) / UnitHealthMax(uId) <= 0.1 and not sentLowHP[guid] then
		sentLowHP[guid] = true
		self:SendSync("lowhealth", guid)
	end	
	if uId == "player" then
		if UnitDebuff("player", GetSpellInfo(123184)) then
			if UnitHealth(uId) / UnitHealthMax(uId) <= 0.5 and not warnedhp then
				sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\checkhp.mp3")--注意血量
				warnedhp = true
			end
		else
			warnedhp = false
		end
	end
end

function mod:OnSync(msg, guid)
	if msg == "lowhealth" and guid and not warnedLowHP[guid] then
		warnedLowHP[guid] = true
		warnSonicDischarge:Show()--This only works if someone in raid is actually targeting them :(
		specwarnSonicDischarge:Show()--But is extremly useful when they are.
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_ybbz.mp3") --音波爆炸準備
	end
end
