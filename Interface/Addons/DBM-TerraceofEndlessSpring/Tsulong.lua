local mod	= DBM:NewMod(742, "DBM-TerraceofEndlessSpring", nil, 320)
local L		= mod:GetLocalizedStrings()
local sndWOP	= mod:NewSound(nil, "SoundWOP", true)
local sndJK		= mod:NewSound(nil, "SoundJK", true)

mod:SetRevision(("$Revision: 8117 $"):sub(12, -3))
mod:SetCreatureID(62442)--62919 Unstable Sha, 62969 Embodied Terror
mod:SetModelID(42532)

mod:RegisterCombat("combat")
mod:RegisterKill("yell", L.Victory)

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"RAID_BOSS_EMOTE",
	"UNIT_SPELLCAST_SUCCEEDED",
	"UNIT_DIED"
)

local warnNight							= mod:NewSpellAnnounce("ej6310", 2, 108558)
local warnSunbeam						= mod:NewSpellAnnounce(122789, 3)
local warnShadowBreath					= mod:NewSpellAnnounce(122752, 3)
local warnNightmares					= mod:NewTargetAnnounce(122770, 4)--Target scanning will only work on 1 target on 25 man (only is 1 target on 10 man so they luck out)
local warnDarkOfNight					= mod:NewSpellAnnounce("ej6550", 4, 130013)--Heroic
local warnDay							= mod:NewSpellAnnounce("ej6315", 2, 122789)
local warnSummonUnstableSha				= mod:NewSpellAnnounce("ej6320", 3, "Interface\\Icons\\achievement_raid_terraceofendlessspring04")
local warnSummonEmbodiedTerror			= mod:NewSpellAnnounce("ej6316", 4, "Interface\\Icons\\achievement_raid_terraceofendlessspring04")
local warnTerrorize						= mod:NewTargetAnnounce(123012, 4, nil, mod:IsHealer())
local warnSunBreath						= mod:NewSpellAnnounce(122855, 3)
local warnLightOfDay					= mod:NewSpellAnnounce("ej6551", 4, 123716, mod:IsHealer())--Heroic

local specWarnShadowBreath				= mod:NewSpecialWarningSpell(122752, mod:IsTank() or mod:IsHealer())
local specWarnSunBreath					= mod:NewSpecialWarningSpell(122855, mod:IsHealer())
local specWarnDreadShadows				= mod:NewSpecialWarningStack(122768, nil, 9)--For heroic, 10 is unhealable, and it stacks pretty fast so adaquate warning to get over there would be abou 5-6
local specWarnNightmares				= mod:NewSpecialWarningYou(122770)
local specWarnNightmaresNear			= mod:NewSpecialWarningClose(122770)
local specWarnSunbeam					= mod:NewSpecialWarningSpell(122789)
local yellNightmares					= mod:NewYell(122770)
local specWarnDarkOfNight				= mod:NewSpecialWarningSwitch("ej6550", mod:IsDps())
local specWarnTerrorize					= mod:NewSpecialWarningDispel(123012, mod:IsHealer())
local specWarnLightOfDay				= mod:NewSpecialWarningSpell("ej6551", mod:IsHealer())

local timerNightCD						= mod:NewNextTimer(121, "ej6310", nil, nil, nil, 130013)
local timerSunbeamCD					= mod:NewCDTimer(41, 122789)
local timerShadowBreathCD				= mod:NewCDTimer(28, 122752, nil, mod:IsTank() or mod:IsHealer())
local timerNightmaresCD					= mod:NewCDTimer(15.5, 122770)
local timerDarkOfNightCD				= mod:NewCDTimer(30.5, "ej6550", nil, nil, nil, 130013)
local timerDayCD						= mod:NewNextTimer(121, "ej6315", nil, nil, nil, 122789)
local timerSummonUnstableShaCD			= mod:NewCDTimer(18, "ej6320", nil, nil,nil, "Interface\\Icons\\achievement_raid_terraceofendlessspring04")
local timerSummonEmbodiedTerrorCD		= mod:NewCDTimer(41, "ej6316", nil, nil, nil, "Interface\\Icons\\achievement_raid_terraceofendlessspring04")
local timerTerrorizeCD					= mod:NewNextTimer(14, 123012)--Besides being cast 14 seconds after they spawn, i don't know if they recast it if they live too long, their health was too undertuned to find out.
local timerSunBreathCD					= mod:NewCDTimer(29, 122855)
--local timerLightOfDayCD					= mod:NewCDTimer(30.5, "ej6551", nil, mod:IsHealer(), nil, 123716)--Don't have timing for this yet, heroic logs i was sent always wiped VERY early in light phase.

local berserkTimer						= mod:NewBerserkTimer(500)--a little over 8 min, basically 3rd dark phase is auto berserk.

local terrorName = EJ_GetSectionInfo(6316)
local targetScansDone = 0

mod:AddBoolOption("HudMAP", true, "sound")
local DBMHudMap = DBMHudMap
local free = DBMHudMap.free
local function register(e)	
	DBMHudMap:RegisterEncounterMarker(e)
	return e
end
local NightmaresMarkers = {}

local sndJKNext = {}

mod:AddDropdownOption("optDS", {"six", "nine", "twelve", "fifteen", "none"}, "six", "sound")
local DSn = 0
local terrorN = 0
local daytime = 0

local function isTank(unit)
	-- 1. check blizzard tanks first
	-- 2. check blizzard roles second
	-- 3. check boss1's highest threat target
	if GetPartyAssignment("MAINTANK", unit, 1) then
		return true
	end
	if UnitGroupRolesAssigned(unit) == "TANK" then
		return true
	end
	if UnitExists("boss1target") and UnitDetailedThreatSituation(unit, "boss1") then
		return true
	end
	return false
end

function mod:ShadowsTarget(targetname)
	warnNightmares:Show(targetname)
	if self.Options.HudMAP and self:IsDifficulty("normal10", "heroic10") then
		NightmaresMarkers[targetname] = register(DBMHudMap:PlaceStaticMarkerOnPartyMember("highlight", targetname, 9, 4, 0, 1, 0, 0.5):Appear():RegisterForAlerts())
	end
	if targetname == UnitName("player") then
		specWarnNightmares:Show()
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\runaway.mp3")--快躲開
		yellNightmares:Yell()
	else
		local uId = DBM:GetRaidUnitId(targetname)
		if uId then
			local x, y = GetPlayerMapPosition(uId)
			if x == 0 and y == 0 then
				SetMapToCurrentZone()
				x, y = GetPlayerMapPosition(uId)
			end
			local inRange = DBM.RangeCheck:GetDistance("player", x, y)
			if inRange and inRange < 10 then
				specWarnNightmaresNear:Show(targetname)
				sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\runaway.mp3")--快躲開
			elseif not self:IsDifficulty("normal10", "heroic10") then
				sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\firecircle.mp3")--注意火圈
			end
		end
	end
end

function mod:TargetScanner(ScansDone)
	targetScansDone = targetScansDone + 1
	local targetname, uId = self:GetBossTarget(62442)
	if UnitExists(targetname) then--Better way to check if target exists and prevent nil errors at same time, without stopping scans from starting still. so even if target is nil, we stil do more checks instead of just blowing off a warning.
		if isTank(uId) and not ScansDone then--He's targeting his highest threat target.
			if targetScansDone < 16 then--Make sure no infinite loop.
				self:ScheduleMethod(0.05, "TargetScanner")--Check multiple times to be sure it's not on something other then tank.
			else
				self:TargetScanner(true)--It's still on tank, force true isTank and activate else rule and warn target is on tank.
			end
		else--He's not targeting highest threat target (or isTank was set to true after 16 scans) so this has to be right target.
			self:UnscheduleMethod("TargetScanner")--Unschedule all checks just to be sure none are running, we are done.
			self:ShadowsTarget(targetname)
		end
	else--target was nil, lets schedule a rescan here too.
		if targetScansDone < 16 then--Make sure not to infinite loop here as well.
			self:ScheduleMethod(0.05, "TargetScanner")
		end
	end
end

function mod:OnCombatStart(delay)
	timerShadowBreathCD:Start(8.5-delay)
	if not mod:IsDps() then
		sndWOP:Schedule(6, "Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_zbhx.mp3")--準備火息
	end
	timerNightmaresCD:Start(13.5-delay)
	timerDayCD:Start(-delay)
	sndWOP:Schedule(116.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_btzb.mp3")--白天準備
	sndWOP:Schedule(118, "Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
	sndWOP:Schedule(119, "Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
	sndWOP:Schedule(120, "Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
	if not self:IsDifficulty("lfr25") then
		berserkTimer:Start(-delay)
	end
	if self:IsDifficulty("heroic10", "heroic25") then
		timerDarkOfNightCD:Start(10-delay)
	end
	terrorN = 0
	daytime = 0
	table.wipe(NightmaresMarkers)
	table.wipe(sndJKNext)
end

function mod:OnCombatEnd()
	if self.Options.HudMAP then
		DBMHudMap:FreeEncounterMarkers()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(122768) and args:IsPlayer() then
		DSn = self.Options.optDS == "six" and 6 or self.Options.optDS == "nine" and 9 or self.Options.optDS == "twelve" and 12 or self.Options.optDS == "fifteen" and 15 or self.Options.optDS == "none" and 99
		if (args.amount or 1) >= DSn then
			if args.amount % 3 == 0 then
				specWarnDreadShadows:Show(args.amount)
				sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_kzyg.mp3")--快找陽光
			end
		end
	elseif args:IsSpellID(123012) then
		warnTerrorize:Show(args.destName)
		specWarnTerrorize:Show(args.destName)
		if mod:IsHealer() then
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\dispelnow.mp3")--快驅散
			if GetTime() - daytime < 96 then
				sndJKNext[args.sourceGUID] = mod:NewSound(nil, "SoundJK", true)
				sndJKNext[args.sourceGUID]:Schedule(18, "Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_qszb.mp3")--驅散準備
				sndJKNext[args.sourceGUID]:Schedule(19, "Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
				sndJKNext[args.sourceGUID]:Schedule(20, "Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
				sndJKNext[args.sourceGUID]:Schedule(21, "Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
			end
		end
	elseif args:IsSpellID(122789) then
		if args:IsPlayer() then
			specWarnSunbeam:Show()
		end
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(122855) then
		warnSunBreath:Show()
		specWarnSunBreath:Show()
		timerSunBreathCD:Start()
		if not mod:IsDps() then
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_zbhx.mp3")
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(122752) then
		warnShadowBreath:Show()
		specWarnShadowBreath:Show()
		timerShadowBreathCD:Start()
		if not mod:IsDps() then
			sndWOP:Schedule(26, "Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_zbhx.mp3")
		end
	end
end

function mod:RAID_BOSS_EMOTE(msg)
	if msg:find("spell:122789") then
		timerSunbeamCD:Start()
	elseif msg:find(terrorName) then
		timerTerrorizeCD:Start()--always cast 14-15 seconds after one spawns (Unless stunned, if you stun the mob you can delay the cast, using this timer)
		warnSummonEmbodiedTerror:Show()
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_kjjx.mp3")--恐懼具現
		terrorN = terrorN + 1
		if mod:IsHealer() then
			sndJK:Schedule(10, "Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_qszb.mp3")--驅散準備
			sndJK:Schedule(11, "Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
			sndJK:Schedule(12, "Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
			sndJK:Schedule(13, "Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
		end
		timerSummonEmbodiedTerrorCD:Start()
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, _, _, spellId)
	if spellId == 122770 and self:AntiSpam(2, 1) then--Nightmares (Night Phase)
		targetScansDone = 0
		self:TargetScanner()
		timerNightmaresCD:Start()
	elseif spellId == 123252 and self:AntiSpam(2, 2) then--Dread Shadows Cancel (Sun Phase)
		daytime = GetTime()
		timerShadowBreathCD:Cancel()
		if not mod:IsDps() then
			sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_zbhx.mp3")
		end
		timerSunbeamCD:Cancel()
		timerNightmaresCD:Cancel()
		timerDarkOfNightCD:Cancel()
		warnDay:Show()
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\phasechange.mp3")--階段轉換
		timerSunBreathCD:Start()
		timerNightCD:Start()
		sndWOP:Schedule(116.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_hyzb.mp3")--黑夜準備
		sndWOP:Schedule(118, "Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
		sndWOP:Schedule(119, "Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
		sndWOP:Schedule(120, "Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
	elseif spellId == 122953 and self:AntiSpam(2, 1) then--Summon Unstable Sha (122946 is another ID, but it always triggers at SAME time as Dread Shadows Cancel so can just trigger there too without additional ID scanning.
		warnSummonUnstableSha:Show()
		if mod:IsDps() then
			sndWOP:Schedule(4, "Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_kdbwds.mp3")--快打不穩定煞
		end
		timerSummonUnstableShaCD:Start()
	elseif spellId == 122767 and self:AntiSpam(2, 2) then--Dread Shadows (Night Phase)
		timerSummonUnstableShaCD:Cancel()
		timerSummonEmbodiedTerrorCD:Cancel()
		timerSunBreathCD:Cancel()
--		timerLightOfDayCD:Cancel()
		warnNight:Show()
		sndJK:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_qszb.mp3")
		sndJK:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
		sndJK:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
		sndJK:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
		for i,j in pairs(sndJKNext) do
			sndJKNext[i]:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_qszb.mp3")
			sndJKNext[i]:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
			sndJKNext[i]:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
			sndJKNext[i]:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
		end
		table.wipe(sndJKNext)
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\phasechange.mp3")
		timerShadowBreathCD:Start(10)
		if not mod:IsDps() then
			sndWOP:Schedule(8, "Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_zbhx.mp3")
		end
		timerNightmaresCD:Start(16)
		timerDayCD:Start()
		sndWOP:Schedule(116.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_btzb.mp3")
		sndWOP:Schedule(118, "Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
		sndWOP:Schedule(119, "Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
		sndWOP:Schedule(120, "Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
		if self:IsDifficulty("heroic10", "heroic25") then
--			timerDarkOfNightCD:Start(10-delay)--Not enough information yet, no logs of this phase starting anywhere but combat start, and those timers differ. This might have first cast IMMEDIATELY on phase start like day does
		end
	elseif spellId == 123813 and self:AntiSpam(2, 3) then--The Dark of Night (Night Phase)
		warnDarkOfNight:Show()
		specWarnDarkOfNight:Show()
		timerDarkOfNightCD:Start()
		if mod:IsDps() then
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_aykd.mp3")--暗影快打
		end
	elseif spellId == 123816 and self:AntiSpam(2, 3) then--The Light of Day (Day Phase)
		warnLightOfDay:Show()
		specWarnLightOfDay:Show()
		if mod:IsHealer() then
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_ghcx.mp3")--光華出現
		end
--		timerLightOfDayCD:Start()
	end
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 62969 then
		terrorN = terrorN - 1
		if terrorN == 0 then
			sndJK:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_qszb.mp3")
			sndJK:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
			sndJK:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
			sndJK:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
		end
		if sndJKNext[args.destGUID] then
			sndJKNext[args.destGUID]:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_qszb.mp3")
			sndJKNext[args.destGUID]:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
			sndJKNext[args.destGUID]:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
			sndJKNext[args.destGUID]:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
		end
	end
end