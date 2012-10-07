local mod	= DBM:NewMod(683, "DBM-TerraceofEndlessSpring", nil, 320)
local L		= mod:GetLocalizedStrings()
local sndWOP	= mod:NewSound(nil, "SoundWOP", true)

mod:SetRevision(("$Revision: 7834 $"):sub(12, -3))
mod:SetCreatureID(60585, 60586, 60583)--60583 Protector Kaolan, 60585 Elder Regail, 60586 Elder Asani
mod:SetModelID(41503)--Protector Kaolan, 41502 and 41504 are elders
mod:SetZone()
mod:SetUsedIcons(8, 7, 6, 5, 4, 3, 2, 1)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"SPELL_DAMAGE",
	"SPELL_MISSED"
)

--[[
--Both Elders use Overhwelming Corruption as their phase 3 ability. It's not worth warning for since it's just a periodic aoe you can't do anything about with stacking damage.
spellid = 117309 or spellid = 117227 or spellid = 111850 or spellid = 117519 and not(fulltype = SPELL_PERIODIC_DAMAGE) or spellid = 117986 or spellid = 117975 or spellid = 118077
--]]
local isDispeller = select(2, UnitClass("player")) == "MAGE"
	    		 or select(2, UnitClass("player")) == "PRIEST"
	    		 or select(2, UnitClass("player")) == "SHAMAN"

local warnPhase2					= mod:NewPhaseAnnounce(2)
local warnPhase3					= mod:NewPhaseAnnounce(3)
--Elder Asani
local warnCleansingWaters			= mod:NewTargetAnnounce(117309, 3)--Phase 1+ ability. If target scanning fails, will switch to spell announce
local warnCorruptingWaters			= mod:NewSpellAnnounce(117227, 4)--Phase 2+ ability.
--Elder Regail (Also uses Overwhelming Corruption in phase 3)
local warnLightningPrison			= mod:NewTargetAnnounce(111850, 3)--Phase 1+ ability.
local warnLightningStorm			= mod:NewSpellAnnounce(118077, 4)--Phase 2+ ability.								
--Protector Kaolan
local warnTouchofSha				= mod:NewTargetAnnounce(117519, 3, nil, mod:IsHealer())--Phase 1+ ability. He stops casting it when everyone in raid has it then ceases. If someone dies and is brezed, he casts it on them again.
local warnDefiledGround				= mod:NewSpellAnnounce(117986, 3, nil, mod:IsMelee())--Phase 2+ ability.
local warnExpelCorruption			= mod:NewSpellAnnounce(117975, 4)--Phase 3 ability.

--Elder Asani
local specWarnCleansingWaters		= mod:NewSpecialWarningTarget(117309, mod:IsTank())--It's being cast on the boss, move the boss
local specWarnCleansingWatersDispel	= mod:NewSpecialWarningDispel(117309, isDispeller)--The boss wasn't moved in time, now he needs to be dispelled.
local specWarnCorruptingWaters		= mod:NewSpecialWarningSwitch("ej5821", mod:IsDps())
--Elder Regail
local specWarnLightningPrison		= mod:NewSpecialWarningYou(111850)--Debuff you gain before you are hit with it.
local yellLightningPrison			= mod:NewYell(111850)
local specWarnLPmove				= mod:NewSpecialWarningMove(111850)
local specWarnLightningStorm		= mod:NewSpecialWarningSpell(118077, nil, nil, nil, true)--Since it's multiple targets, will just use spell instead of dispel warning.
--Protector Kaolan
local specWarnDefiledGround			= mod:NewSpecialWarningMove(117986)
local specWarnExpelCorruption		= mod:NewSpecialWarningSpell(117975, nil, nil, nil, true)--Entire raid needs to move.
--Minions of Fear
local specWarnCorruptedEssence		= mod:NewSpecialWarningStack(118191, true, 7)--Amount may need adjusting depending on what becomes an accepted strategy

--Elder Asani
local timerCleansingWatersCD		= mod:NewCDTimer(32.5, 117309)
local timerCorruptingWatersCD		= mod:NewCDTimer(42, 117227)
--Elder Regail
local timerLightningPrisonCD		= mod:NewCDTimer(25, 111850, nil, mod:IsHealer())--*This currently seems bugged and can be prevented by interrupting lightning bolt casts (it locks out entire school and can prevent this being cast
local timerLightningStormCD			= mod:NewCDTimer(42, 118077)--Shorter Cd in phase 3 32 seconds.
local timerLightningStorm			= mod:NewBuffActiveTimer(14, 118077)
--Protector Kaolan
local timerTouchOfShaCD				= mod:NewCDTimer(37.4, 117519)--Timer seemed longer on heroic then it even was on normal, considering most heroic modes have same timings as normal this tier, i'm guessing every 20 sec was just too often for 10 man, normal or heroic. For now we'll assume all modes got this nerf. 25 man may still be 20 tho, will need to find out and see
local timerDefiledGroundCD			= mod:NewCDTimer(15.5, 117986, nil, mod:IsMelee())
local timerExpelCorruptionCD		= mod:NewCDTimer(39, 117975)

mod:AddBoolOption("SoundDW", mod:IsDps() and isDispeller, "sound")
mod:AddBoolOption("RangeFrame")--For Lightning Prison
mod:AddBoolOption("SetIconOnPrison", true)--For Lightning Prison (icons don't go out until it's DISPELLABLE, not when targetting is up).

local phase = 1
local totalTouchOfSha = 0
local scansDone = 0
local prisonTargets = {}
local prisonIcon = 1--Will try to start from 1 and work up, to avoid using icons you are probalby putting on bosses (unless you really fail at spreading).
local prisonDebuff = GetSpellInfo(79339)
local prisonCount = 0

mod:AddBoolOption("HudMAP", true, "sound")
local DBMHudMap = DBMHudMap
local free = DBMHudMap.free
local function register(e)	
	DBMHudMap:RegisterEncounterMarker(e)
	return e
end

local LightningPrisonCastMarkers = {}
local LightningPrisonMarkers = {}


local DebuffFilter
do
	DebuffFilter = function(uId)
		return UnitDebuff(uId, prisonDebuff)
	end
end

local function checkdebuffend(destname)
    if UnitDebuff(destname, GetSpellInfo(117436)) then
        mod:Schedule(0.1, function()
			checkdebuffend(destname)
		end)
	else
		prisonCount = prisonCount - 1
		if prisonCount == 0 and mod.Options.RangeFrame then
			DBM.RangeCheck:Hide()
		end
		if mod.Options.SetIconOnPrison then
			mod:SetIcon(destname, 0)
		end
		if LightningPrisonMarkers[destname] then
			LightningPrisonMarkers[destname] = free(LightningPrisonMarkers[destname])
		end
	end
end


local function warnPrisonTargets()
	if mod.Options.RangeFrame then
		if UnitDebuff("player", GetSpellInfo(111850)) then--You have debuff, show everyone
			DBM.RangeCheck:Show(8, nil)
		else--You do not have debuff, only show players who do
			DBM.RangeCheck:Show(8, DebuffFilter)
		end
	end
	warnLightningPrison:Show(table.concat(prisonTargets, "<, >"))
	timerLightningPrisonCD:Start()
	table.wipe(prisonTargets)
	prisonIcon = 1
end

function mod:WatersTarget()
	scansDone = scansDone + 1
	local targetname, uId = self:GetBossTarget(60586)
	if targetname and uId then
		if UnitIsFriend("player", uId) then--He's targeting a friendly unit, he doesn't cast this on players, so it's wrong target.
			if scansDone < 15 then--Make sure no infinite loop.
				self:ScheduleMethod(0.1, "WatersTarget")--Check multiple times to find a target that isn't a player.
			end
		else--He's not targeting a player, it's definitely breeze target.
			warnCleansingWaters:Show(targetname)
			for i = 1, 3 do
				if UnitName("boss"..i) == targetname then
					if UnitName("boss"..i.."target") == UnitName("player") then--You are targeting the target of this spell.
						specWarnCleansingWaters:Show(targetname)
						sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\bossout.mp3") --拉開boss
					else
						sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_jhzs.mp3") --淨化之水
					end
				end
			end			
		end
	else--target was nil, lets schedule a rescan here too.
		if scansDone < 15 then--Make sure not to infinite loop here as well.
			self:ScheduleMethod(0.1, "WatersTarget")
		end
	end
end

function mod:OnCombatStart(delay)
	phase = 1
	totalTouchOfSha = 0
	prisonCount = 0
	scansDone = 0
	table.wipe(prisonTargets)
	table.wipe(LightningPrisonCastMarkers)
	table.wipe(LightningPrisonMarkers)
	timerCleansingWatersCD:Start(12-delay)
	timerLightningPrisonCD:Start(15.5-delay)--May be off a tiny bit, (or a lot of blizzard doesn't fix bug where cast doesn't happen at all)
	if self:IsDifficulty("normal10", "normal25") then
		timerTouchOfShaCD:Start(36-delay)
	else
		timerTouchOfShaCD:Start(10-delay)
	end
end

function mod:OnCombatEnd()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
	if self.Options.HudMAP then
		DBMHudMap:FreeEncounterMarkers()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(117519) then
		totalTouchOfSha = totalTouchOfSha + 1
		warnTouchofSha:Show(args.destName)
		if totalTouchOfSha < DBM:GetGroupMembers() then--This ability will not be cast if everyone in raid has it.
			if self:IsDifficulty("normal10", "normal25") then
				timerTouchOfShaCD:Start()
			else
				timerTouchOfShaCD:Start(20)
			end
		end
	elseif args:IsSpellID(111850) then--111850 is targeting debuff (NOT dispelable one)
		prisonTargets[#prisonTargets + 1] = args.destName
		prisonCount = prisonCount + 1
		if args:IsPlayer() and self:AntiSpam(2, 1) then
			specWarnLightningPrison:Show()
			yellLightningPrison:Yell()
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\runout.mp3") --跑開人群
		end
		if self.Options.HudMAP then
			if args:IsPlayer() then
				LightningPrisonCastMarkers[args.destName] = register(DBMHudMap:PlaceRangeMarkerOnPartyMember("targeting", args.destName, 8, 3, 1, 1, 1, 1):RegisterForAlerts():Appear())
			else
				LightningPrisonCastMarkers[args.destName] = register(DBMHudMap:PlaceRangeMarkerOnPartyMember("timer", args.destName, 8, 2.8, 1, 1, 1, 1):RegisterForAlerts():Rotate(360, 3):Appear())
			end
		end
		self:Unschedule(warnPrisonTargets)
		self:Schedule(0.3, warnPrisonTargets)
	elseif args:IsSpellID(117436) then--111850 is pre warning, mainly for player, 117436 is the actual final result, mainly for the healer dispels
		if self.Options.SetIconOnPrison then
			self:SetIcon(args.destName, prisonIcon)
			prisonIcon = prisonIcon + 1
		end
		if mod:IsHealer() and self:AntiSpam(2, 2) then
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_qssd.mp3")--驅散閃電
		end
		if self.Options.HudMAP then
			if not args:IsPlayer() then
				LightningPrisonMarkers[args.destName] = register(DBMHudMap:PlaceRangeMarkerOnPartyMember("highlight", args.destName, 8, nil, 0, 1, 0, 1):RegisterForAlerts())
				checkdebuffend(args.destName)
			end
		end
	elseif args:IsSpellID(117283) then
		if args.destName == UnitName("boss1") or args.destName == UnitName("boss2") or args.destName == UnitName("boss3") then
			specWarnCleansingWatersDispel:Show(args.destName)
			if isDispeller and self.Options.SoundDW and self:AntiSpam(2, 3) then
				sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_qszl.mp3") --驅散治療
			end
		end
	elseif args:IsSpellID(117052) then--Phase changes
		--Here we go off applied because then we can detect both targets in phase 1 to 2 transition.
		--There is some possiblity that other timers are reset or altered on phase 2-3 start. Light in case of Lightning storm Cd resetting in phase 3.
		--If any are missing that actually ALTER during a phase 2 or 3 transition they will be updated here.
		if phase == 2 then
			if args:GetDestCreatureID() == 60585 then--Elder Regail
				timerLightningStormCD:Start(20)
			elseif args:GetDestCreatureID() == 60586 then--Elder Asani
				timerCorruptingWatersCD:Start(11.5)
			elseif args:GetDestCreatureID() == 60583 then--Protector Kaolan
				timerDefiledGroundCD:Start(5)
			end
		elseif phase == 3 then
			if args:GetDestCreatureID() == 60583 then--Elder Regail
				timerLightningStormCD:Start(9.5)--His LS cd seems to reset in phase 3 since the CD actually changes.
			elseif args:GetDestCreatureID() == 60583 then--Protector Kaolan
				timerExpelCorruptionCD:Start(5)
			end
		end
	elseif args:IsSpellID(118191) then
		if args:IsPlayer() then
			if (args.amount or 1) >= 7 then
				specWarnCorruptedEssence:Show(args.amount)
				if args.amount % 2 == 0 then
					sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_zyfh.mp3") --注意腐化
				end
			end
		end
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(117519) then
		totalTouchOfSha = totalTouchOfSha - 1
	elseif args:IsSpellID(117436) then
		prisonCount = prisonCount - 1
		--print("BUG is FIXED!")
		if prisonCount == 0 and self.Options.RangeFrame then
			DBM.RangeCheck:Hide()
		end
		if self.Options.SetIconOnPrison then
			self:SetIcon(args.destName, 0)
		end
		if LightningPrisonMarkers[args.destName] then
			LightningPrisonMarkers[args.destName] = free(LightningPrisonMarkers[args.destName])
		end
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(117309) then
		scansDone = 0
		self:WatersTarget()
		timerCleansingWatersCD:Start()
	elseif args:IsSpellID(117975) then
		warnExpelCorruption:Show()
		specWarnExpelCorruption:Show()
		if mod:IsTank() then
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\bossout.mp3") --拉開boss
		else
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_ylhq.mp3") --遠離黑球
		end
		timerExpelCorruptionCD:Start()
	elseif args:IsSpellID(117227) then
		warnCorruptingWaters:Show()
		specWarnCorruptingWaters:Show()
		timerCorruptingWatersCD:Start()
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_sqkd.mp3")--水球快打
	elseif args:IsSpellID(118077) then
		warnLightningStorm:Show()
		specWarnLightningStorm:Show()
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_sdfb.mp3") --閃電風暴
		sndWOP:Schedule(1.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
		sndWOP:Schedule(4.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
		sndWOP:Schedule(7.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
		sndWOP:Schedule(10, "Interface\\AddOns\\DBM-Core\\extrasounds\\countfour.mp3")
		if phase == 3 then
			timerLightningStormCD:Start(32)
		else
			timerLightningStormCD:Start(41)
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(117986) then
		warnDefiledGround:Show()
		timerDefiledGroundCD:Start()
		for i = 1, 3 do
			if UnitName("boss"..i) == args.sourcename then
				if UnitName("boss"..i.."target") == UnitName("player") then
					specWarnDefiledGround:Show()
					sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\runaway.mp3")--快躲開
				end
			end
		end
	elseif args:IsSpellID(117052) and phase < 3 then--Phase changes
		phase = phase + 1
		--We cancel timers for whatever boss just died (ie boss that cast the buff) We do this on success instead of applied since it's only cast ONCE (even if it applies to 2 bosses
		if args:GetSrcCreatureID() == 60585 then--Elder Regail
			timerLightningPrisonCD:Cancel()
			timerLightningStormCD:Cancel()
			if self.Options.RangeFrame then
				DBM.RangeCheck:Hide()
			end
		elseif args:GetSrcCreatureID() == 60586 then--Elder Asani
			timerCleansingWatersCD:Cancel()
			timerCorruptingWatersCD:Cancel()
		elseif args:GetSrcCreatureID() == 60583 then--Protector Kaolan
			timerTouchOfShaCD:Cancel()
			timerDefiledGroundCD:Cancel()
		end
	end
end

function mod:SPELL_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 117436 and destGUID == UnitGUID("player") and self:AntiSpam(3, 4) then
		specWarnLPmove:Show()
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\runaway.mp3") --快躲開
		--[[
	elseif spellId == 117988 and destGUID == UnitGUID("player") and self:AntiSpam(3, 5) then
		specWarnDefiledGround:Show()
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\runaway.mp3") --快躲開]]
	end
end
mod.SPELL_MISSED = mod.SPELL_DAMAGE