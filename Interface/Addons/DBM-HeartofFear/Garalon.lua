local mod	= DBM:NewMod(713, "DBM-HeartofFear", nil, 330)
local L		= mod:GetLocalizedStrings()
local sndWOP	= mod:NewSound(nil, "SoundWOP", true)

mod:SetRevision(("$Revision: 8015 $"):sub(12, -3))
mod:SetCreatureID(63191)--Also has CID 62164. He has 2 CIDs for a single target, wtf? It seems 63191 is one players attack though so i'll try just it.
mod:SetModelID(42368)
mod:SetZone()
mod:SetUsedIcons(2)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_AURA_REMOVED",
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"RAID_BOSS_EMOTE",
	"SPELL_DAMAGE",
	"SPELL_MISSED"
)

--[[WoL Reg Expression (you can remove icy touch if you don't have a DK pull bosses, i use it for pull time)
spell = "Furious Swipe" and fulltype = SPELL_CAST_START or (spell = "Pheromones" or spell = "Fury") and (fulltype = SPELL_AURA_APPLIED or fulltype = SPELL_AURA_APPLIED_DOSE) or spell = "Broken Leg" and not (fulltype = SPELL_CAST_SUCCESS or fulltype = SPELL_DAMAGE) or spell = "Mend Leg" or (spell = "Icy Touch" or spell = "Crush") and fulltype = SPELL_CAST_SUCCESS
--]]
local warnFuriousSwipe			= mod:NewSpellAnnounce(122735, 3)
local warnPheromones			= mod:NewTargetAnnounce(122835, 4)
local warnFury					= mod:NewStackAnnounce(122754, 3)
local warnBrokenLeg				= mod:NewStackAnnounce(122786, 2)
local warnMendLeg				= mod:NewSpellAnnounce(123495, 1)
local warnCrush					= mod:NewSpellAnnounce(122774, 3)--On normal, only cast if you do fight wrong (be it on accident or actually on purpose. however, on heroic, this might have a CD)

local specwarnPheromonesTarget	= mod:NewSpecialWarningTarget(122835, false)
local specwarnPheromonesYou		= mod:NewSpecialWarningYou(122835)
local specwarnPheromonesNear	= mod:NewSpecialWarningClose(122835)
local specwarnCrush				= mod:NewSpecialWarningSpell(122774, true, nil, nil, true)--Maybe set to true later, not sure. Some strats on normal involve purposely having tanks rapidly pass debuff and create lots of stomps
local specwarnLeg				= mod:NewSpecialWarningSwitch("ej6270", mod:IsMelee())--If no legs are up (ie all dead), when one respawns, this special warning can be used to alert of a respawned leg and to switch back.
local specwarnPheromoneTrail	= mod:NewSpecialWarningMove(123120)--Because this starts doing damage BEFORE the visual is there.

local specwarnPungency			= mod:NewSpecialWarningStack(123081, mod:IsTank(), 20)
local specWarnPungencyOther		= mod:NewSpecialWarning("SpecWarnPungencyOther", mod:IsTank() or mod:IsHealer())

local timerFuriousSwipeCD		= mod:NewCDTimer(8, 122735)
local timerMendLegCD			= mod:NewCDTimer(30, 123495)
local timerFury					= mod:NewBuffActiveTimer(30, 122754)
local timerPungency				= mod:NewBuffFadesTimer(120, 123081)

local berserkTimer				= mod:NewBerserkTimer(420)

--mod:AddBoolOption("InfoFrame", true)--Not sure how to do yet, i need to see 25 man first to get a real feel for number of people with debuff at once.
mod:AddBoolOption("PheromonesIcon", true)
local sndFS		= mod:NewSound(nil, "SoundFS", mod:IsTank())
mod:AddBoolOption("InfoFrame", not mod:IsDps(), "sound")

local brokenLegs = 0
local Pn = 20

mod:AddBoolOption("HudMAP", true, "sound")
local DBMHudMap = DBMHudMap
local free = DBMHudMap.free
local function register(e)	
	DBMHudMap:RegisterEncounterMarker(e)
	return e
end

local PheromonesMarkers = {}

mod:AddDropdownOption("optTankMode", {"two", "three"}, "two", "sound")

function mod:OnCombatStart(delay)
	brokenLegs = 0
	timerFuriousSwipeCD:Start(-delay)--8-11 sec on pull
	berserkTimer:Start(-delay)
	sndFS:Schedule(5, "Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
	sndFS:Schedule(6, "Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
	sndFS:Schedule(7, "Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
	if mod.Options.InfoFrame then
		DBM.InfoFrame:SetHeader(GetSpellInfo(123081))
		DBM.InfoFrame:Show(3, "playerdebuffstacks", 123081)
	end
	table.wipe(PheromonesMarkers)
end

function mod:OnCombatEnd()
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
	if self.Options.HudMAP then
		DBMHudMap:FreeEncounterMarkers()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(122754) and args:GetDestCreatureID() == 63191 then--It applies to both creatureids, so we antispam it
		warnFury:Show(args.destName, args.amount or 1)
		timerFury:Start()
	elseif args:IsSpellID(122786) and args:GetDestCreatureID() == 63191 then--This one also hits both the leg and the boss, so filter second one here as well.
		warnBrokenLeg:Show(args.destName, args.amount or 1)
	elseif args:IsSpellID(122835) then
		warnPheromones:Show(args.destName)
		specwarnPheromonesTarget:Show(args.destName)
		if args:IsPlayer() then
			specwarnPheromonesYou:Show()
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\targetyou.mp3") --目標是你
		else
			local uId = DBM:GetRaidUnitId(args.destName)
			if uId then
				local x, y = GetPlayerMapPosition(uId)
				if x == 0 and y == 0 then
					SetMapToCurrentZone()
					x, y = GetPlayerMapPosition(uId)
				end
				local inRange = DBM.RangeCheck:GetDistance("player", x, y)
				if inRange and inRange < 9 then
					specwarnPheromonesNear:Show(args.destName)
				end
			end
			if self.Options.HudMAP then
				local spelltext = GetSpellInfo(122835)
				PheromonesMarkers[args.destName] = register(DBMHudMap:PlaceRangeMarkerOnPartyMember("targeting", args.destName, 2, nil, 0, 1, 0, 1):SetLabel(spelltext))
			end
		end
		if self.Options.PheromonesIcon then
			self:SetIcon(args.destName, 2)
		end
	elseif args:IsSpellID(123081) then
		if self:IsDifficulty("normal25", "heroic25") then--Is it also 4 min on LFR?
			timerPungency:Start(240, args.destName)
		else
			timerPungency:Start(args.destName)
		end
		Pn = self.Options.optTankMode == "two" and 30 or self.Options.optTankMode == "three" and 20
		if args:IsPlayer() then
			if (args.amount or 1) >= Pn and args.amount % 2 == 0 then
				specwarnPungency:Show(args.amount)
			end
		else
			if (args.amount or 1) >= Pn and args.amount % 2 == 0 and not UnitDebuff("player", GetSpellInfo(123081)) and not UnitIsDeadOrGhost("player") then
				specWarnPungencyOther:Show(args.destName, args.amount)
			end
		end
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(122786) then
		brokenLegs = (args.amount or 0)
		warnBrokenLeg:Show(brokenLegs)
	elseif args:IsSpellID(122835) then
		if self.Options.PheromonesIcon then
			self:SetIcon(args.destName, 0)
		end
		if args:IsPlayer() then
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\targetchange.mp3")--目標改變
		end
		if PheromonesMarkers[args.destName] then
			PheromonesMarkers[args.destName] = free(PheromonesMarkers[args.destName])
		end
	elseif args:IsSpellID(123081) then
		timerPungency:Cancel(args.destName)
		if mod:IsTank() then
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\changemt.mp3")--換坦嘲諷
		end
	end
end
mod.SPELL_AURA_REMOVED_DOSE = mod.SPELL_AURA_REMOVED

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(122735) then
		warnFuriousSwipe:Show()
		sndFS:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
		sndFS:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
		sndFS:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
		sndFS:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_hj.mp3") --揮擊
		timerFuriousSwipeCD:Start()
		sndFS:Schedule(5, "Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
		sndFS:Schedule(6, "Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
		sndFS:Schedule(7, "Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(122774) then
		warnCrush:Show()
--		specwarnCrush:Show()
	elseif args:IsSpellID(123495) then
		warnMendLeg:Show()
		timerMendLegCD:Start()
		if brokenLegs == 4 then--all his legs were broken when heal was cast, which means dps was on body.
			specwarnLeg:Show()--Warn to switch to respawned leg.
			if mod:IsDps() then
				sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_kdtb.mp3") --快打腿部
			end
		end
	end
end

function mod:SPELL_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 123120 and destGUID == UnitGUID("player") and self:AntiSpam(3) then
		specwarnPheromoneTrail:Show()
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\runaway.mp3") --快躲開
	end
end
mod.SPELL_MISSED = mod.SPELL_DAMAGE

function mod:RAID_BOSS_EMOTE(msg)
	if msg:find("spell:122774") then
		specwarnCrush:Show()
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_nyjd.mp3") --碾壓
	end
end
