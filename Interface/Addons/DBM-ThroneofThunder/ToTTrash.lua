local mod	= DBM:NewMod("ToTTrash", "DBM-ThroneofThunder")
local L		= mod:GetLocalizedStrings()
local sndWOP	= mod:NewSound(nil, "SoundWOP", true)

mod:SetRevision(("$Revision: 8804 $"):sub(12, -3))
--mod:SetModelID(39378)
mod:SetZone()

mod:RegisterEvents(
	"SPELL_CAST_START",
	"SPELL_AURA_APPLIED",
	"UNIT_DIED"
)

local warnStormEnergy		= mod:NewTargetAnnounce(139322, 4)
local warnSpiritFire		= mod:NewTargetAnnounce(139895, 3)--This is morchok entryway trash that throws rocks at random poeple.
local warnStormCloud		= mod:NewTargetAnnounce(139900, 4)

local specWarnStormEnergy	= mod:NewSpecialWarningYou(139322)
local specWarnStormCloud	= mod:NewSpecialWarningYou(139900)

local timerSpiritfireCD		= mod:NewCDTimer(12, 139895)

mod:RemoveOption("HealthFrame")
mod:RemoveOption("SpeedKillTimer")
mod:AddBoolOption("RangeFrame")

mod:AddBoolOption("HudMAP", true, "sound")

local DBMHudMap = DBMHudMap
local free = DBMHudMap.free
local function register(e)	
	DBMHudMap:RegisterEncounterMarker(e)
	return e
end
local lightmaker = {}

local stormEnergyTargets = {}
local stormCloudTargets = {}

local function warnStormEnergyTargets()
	warnStormEnergy:Show(table.concat(stormEnergyTargets, "<, >"))
	table.wipe(stormEnergyTargets)
end

local function warnStormCloudTargets()
	warnStormCloud:Show(table.concat(stormCloudTargets, "<, >"))
	table.wipe(stormCloudTargets)
end

function mod:SpiritFireTarget(sGUID)
	local targetname = nil
	for i=1, DBM:GetNumGroupMembers() do
		if UnitGUID("raid"..i.."target") == sGUID then
			targetname = DBM:GetUnitFullName("raid"..i.."targettarget")
			break
		end
	end
	if targetname and self:AntiSpam(2, targetname) then--Anti spam using targetname as an identifier, will prevent same target being announced double/tripple but NOT prevent multiple targets being announced at once :)
		warnSpiritFire:Show(targetname)
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(139895) then
		self:ScheduleMethod(0.2, "SpiritFireTarget", args.sourceGUID)--Untested scan timing (don't even know if scanning works
		timerSpiritfireCD:Start()
		if self.Options.RangeFrame and not DBM.RangeCheck:IsShown() then
			DBM.RangeCheck:Show(10)
		end
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(139322) then
		stormEnergyTargets[#stormEnergyTargets + 1] = args.destName
		if args:IsPlayer() then
			DBM.Flash:Show(1, 0, 0)
			specWarnStormEnergy:Show()
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\runout.mp3")
		else
			lightmaker[args.destName] = register(DBMHudMap:PlaceRangeMarkerOnPartyMember("timer", args.destName, 10, 60, 1, 1, 1, 0.7):RegisterForAlerts())
		end
		if self.Options.RangeFrame and not DBM.RangeCheck:IsShown() then
			DBM.RangeCheck:Show(10)
		end
		self:Unschedule(warnStormEnergyTargets)
		self:Schedule(0.3, warnStormEnergyTargets)
	elseif args:IsSpellID(139900) then
		stormCloudTargets[#stormCloudTargets + 1] = args.destName
		if args:IsPlayer() then
			DBM.Flash:Show(1, 0, 0)			
			specWarnStormCloud:Show()
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\runout.mp3")
		else
			lightmaker[args.destName] = register(DBMHudMap:PlaceRangeMarkerOnPartyMember("timer", args.destName, 10, 60, 1, 1, 1, 0.7):RegisterForAlerts())
		end
		if self.Options.RangeFrame and not DBM.RangeCheck:IsShown() then
			DBM.RangeCheck:Show(10)
		end
		self:Unschedule(warnStormCloudTargets)
		self:Schedule(0.3, warnStormCloudTargets)
	end
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 70308 then--Soul-Fed Construct
		timerSpiritfireCD:Cancel()
		if self.Options.RangeFrame then
			DBM.RangeCheck:Hide()
		end
		if self.Options.HudMAP then
			DBMHudMap:FreeEncounterMarkers()
		end
	elseif cid == 70236 then--Zandalari Storm-Caller
		if self.Options.RangeFrame then
			DBM.RangeCheck:Hide()
		end
		if self.Options.HudMAP then
			DBMHudMap:FreeEncounterMarkers()
		end
	elseif cid == 70445 then--Stormbringer Draz'kil
		if self.Options.RangeFrame then
			DBM.RangeCheck:Hide()
		end
		if self.Options.HudMAP then
			DBMHudMap:FreeEncounterMarkers()
		end
	end
end
