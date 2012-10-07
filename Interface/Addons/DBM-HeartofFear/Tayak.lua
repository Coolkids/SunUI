local mod	= DBM:NewMod(744, "DBM-HeartofFear", nil, 330)
local L		= mod:GetLocalizedStrings()
local sndWOP	= mod:NewSound(nil, "SoundWOP", true)

mod:SetRevision(("$Revision: 7757 $"):sub(12, -3))
mod:SetCreatureID(62543)
mod:SetModelID(43141)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_AURA_REMOVED",
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"CHAT_MSG_RAID_BOSS_EMOTE",
	"UNIT_SPELLCAST_SUCCEEDED"
)

local warnTempestSlash					= mod:NewSpellAnnounce(122839, 2)
local warnOverwhelmingAssault			= mod:NewTargetAnnounce(123474, 3, nil, mod:IsTank() or mod:IsHealer())
local warnWindStep						= mod:NewTargetAnnounce(123175, 3)
local warnUnseenStrike					= mod:NewTargetAnnounce(122949, 4)
local warnIntensify						= mod:NewStackAnnounce(123471, 2)
local warnBladeTempest					= mod:NewCastAnnounce(125310, 4)--Phase 1 heroic
local warnStormUnleashed				= mod:NewSpellAnnounce(123814, 3)--Phase 2

local specWarnUnseenStrike				= mod:NewSpecialWarningTarget(122949)--Everyone needs to know this, and run to this person.
local yellUnseenStrike					= mod:NewYell(122949)
local specWarnOverwhelmingAssault		= mod:NewSpecialWarningStack(123474, mod:IsTank() or mod:IsHealer(), 2)
local specWarnOverwhelmingAssaultOther	= mod:NewSpecialWarning("SpecWarnOverwhelmingAssaultOther", mod:IsTank() or mod:IsHealer())
local specWarnBladeTempest				= mod:NewSpecialWarningRun(125310, true)
local specWarnStormUnleashed			= mod:NewSpecialWarningSpell(123814, nil, nil, nil, true)

local timerTempestSlashCD				= mod:NewNextTimer(15.5, 122839)
local timerOverwhelmingAssault			= mod:NewTargetTimer(45, 123474, nil, mod:IsTank())
local timerOverwhelmingAssaultCD		= mod:NewCDTimer(25.5, 123474, nil, mod:IsTank() or mod:IsHealer())--Only ability with a variation in 2 pulls so far. this one can vary 25-35 seconds. lowest CD is used because it's most common
local timerWindStepCD					= mod:NewNextTimer(30, 123175)
local timerUnseenStrikeCD				= mod:NewNextTimer(61, 122949)
local timerIntensifyCD					= mod:NewNextTimer(60, 123471)
local timerBladeTempest					= mod:NewBuffActiveTimer(9, 125310)
local timerBladeTempestCD				= mod:NewNextTimer(60, 125310)--Always cast after immediately intensify since they essencially have same CD
--local timerStormUnleashedCD			= mod:NewCDTimer(60, 123814)--Timer for switching sides, assuming it's time based and not health based, unsure yet, need more data. Also,the side swap does NOT show in transcriptor or CLEU AT ALL. Will need to use /yell to figure it out.

local ptwo = false

local OAtime = 1
local warnedOA = false
local castOA = false

mod:AddBoolOption("RangeFrame", mod:IsRanged())--For Wind Step
mod:AddBoolOption("UnseenStrikeArrow", false)
mod:AddBoolOption("InfoFrame", not mod:IsDps(), "sound")

mod:AddBoolOption("HudMAP", true, "sound")
local DBMHudMap = DBMHudMap
local free = DBMHudMap.free
local function register(e)	
	DBMHudMap:RegisterEncounterMarker(e)
	return e
end

local UnseenStrikeMarkers = {}

function mod:OnCombatStart(delay)
	timerTempestSlashCD:Start(10-delay)
	timerOverwhelmingAssaultCD:Start(15.5-delay)
	if not mod:IsDps() then
		sndWOP:Schedule(12, "Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_yzgj.mp3") --壓制準備
	end
	timerWindStepCD:Start(20.5-delay)
	timerUnseenStrikeCD:Start(30.5-delay)
	sndWOP:Schedule(27, "Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_wxdjzb.mp3") --無形打擊準備
	timerIntensifyCD:Start(-delay)
	if self:IsDifficulty("heroic10", "heroic25") then
		timerBladeTempestCD:Start(-delay)
		sndWOP:Schedule(57, "Interface\\AddOns\\DBM-Core\\extrasounds\\wwsoon.mp3") --準備旋風
	end
	if self.Options.RangeFrame then
		DBM.RangeCheck:Show(8)
	end
	ptwo = false
	warnedOA = false
	castOA = false
	table.wipe(UnseenStrikeMarkers)
end

function mod:OnCombatEnd()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
	if self.Options.HudMAP then
		DBMHudMap:FreeEncounterMarkers()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(123474) then
		warnOverwhelmingAssault:Show(args.destName, args.amount or 1)
		timerOverwhelmingAssault:Start(args.destName)
		if args:IsPlayer() then
			if (args.amount or 1) >= 2 then
				specWarnOverwhelmingAssault:Show(args.amount)
			end
		else
			if (args.amount or 1) >= 1 and not UnitDebuff("player", GetSpellInfo(123474)) and not UnitIsDeadOrGhost("player") then--Other tank has at least one stack and you have none
				specWarnOverwhelmingAssaultOther:Show(args.destName, args.amount or 1)--So nudge you to taunt it off other tank already.
			end
		end
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(123474) then
		timerOverwhelmingAssault:Cancel(args.destName)
		if mod:IsTank() and (not ptwo) then
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\changemt.mp3") --換坦嘲諷
		end
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(125310) then
		warnBladeTempest:Show()
		specWarnBladeTempest:Show()
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\justrun.mp3") --快跑
--		soundBladeTempest:Play()
		timerBladeTempest:Start()
		sndWOP:Schedule(5, "Interface\\AddOns\\DBM-Core\\extrasounds\\countfive.mp3")
		sndWOP:Schedule(6, "Interface\\AddOns\\DBM-Core\\extrasounds\\countfour.mp3")
		sndWOP:Schedule(7, "Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
		sndWOP:Schedule(8, "Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
		sndWOP:Schedule(9, "Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
		timerBladeTempestCD:Start()--Start CD here, since this might miss.
		sndWOP:Schedule(57, "Interface\\AddOns\\DBM-Core\\extrasounds\\wwsoon.mp3") --準備旋風
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(123474) then
		timerOverwhelmingAssaultCD:Start()--Start CD here, since this might miss.
		if mod.Options.InfoFrame then
			DBM.InfoFrame:SetHeader(GetSpellInfo(123474))
			DBM.InfoFrame:Show(3, "playerdebuffstacks", 123474)
		end
		if not mod:IsDps() then
			sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_yzgj.mp3")
			self:Schedule(17, function()
				warnedOA = true
				castOA = false
			end)
			sndWOP:Schedule(17, "Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_yzgj.mp3")
		end
		OAtime = GetTime()
		warnedOA = false
		castOA = true
	elseif args:IsSpellID(123175) then
		warnWindStep:Show(args.destName)
		timerWindStepCD:Start()
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg, _, _, _, target)
	if msg:find("spell:122949") then--Does not show in combat log except for after it hits. IT does fire a UNIT_SPELLCAST event but has no target info. The only way to get target is emote.
		warnUnseenStrike:Show(target)
		specWarnUnseenStrike:Show(target)
		timerUnseenStrikeCD:Start()
		if target == UnitName("player") then
			yellUnseenStrike:Yell()
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\targetyou.mp3") --目標是你
		else
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\gather.mp3") --快集合
			if self.Options.HudMAP then
				UnseenStrikeMarkers[target] = register(DBMHudMap:PlaceRangeMarkerOnPartyMember("timer", target, 2, 5, 0, 1, 0, 1):Appear():RegisterForAlerts():Rotate(360, 5))
				UnseenStrikeMarkers[target] = register(DBMHudMap:AddEdge(1, 1, 1, 1, 5, "player", target))
			end
		end
		sndWOP:Schedule(1.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
		sndWOP:Schedule(2.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
		sndWOP:Schedule(3.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
		sndWOP:Schedule(50, "Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_wxdjzb.mp3") --無形打擊準備
		if self.Options.UnseenStrikeArrow then
			DBM.Arrow:ShowRunTo(target, 1)
			self:Schedule(5, function()
				DBM.Arrow:Hide()
			end)
		end
		if ((GetTime() - OAtime > 15) and not warnedOA) or (warnedOA and not castOA) then
			sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_yzgj.mp3")
			sndWOP:Schedule(7, "Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_yzgj.mp3")
		end
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, _, _, spellId)
	if spellId == 122839 and self:AntiSpam(2, 1) then--Tempest Slash. DO NOT ADD OTHER SPELLID. 122839 is primary cast, 122842 is secondary cast 3 seconds later. We only need to warn for primary and start CD off it and it alone.
		warnTempestSlash:Show()
		timerTempestSlashCD:Start()
	elseif spellId == 123814 and self:AntiSpam(2, 2) then--Do not add other spellids here either. 123814 is only cast once, it starts the channel. everything else is cast every 1-2 seconds as periodic triggers.
		timerTempestSlashCD:Cancel()
		timerOverwhelmingAssaultCD:Cancel()
		if not mod:IsDps() then
			sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_yzgj.mp3")
		end
		timerWindStepCD:Cancel()
		timerUnseenStrikeCD:Cancel()
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_wxdjzb.mp3")
		timerIntensifyCD:Cancel()
		timerBladeTempestCD:Cancel()
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\wwsoon.mp3")
		warnStormUnleashed:Show()
		specWarnStormUnleashed:Show()
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ptwo.mp3") --P2
		ptwo = true
--		timerStormUnleashedCD:Show()--Timer for when he switches sides, there is no yell, or trigger in CLEU or transcriptor for it, need to figure out timing based on using good ole diagnostic /yell
	end
end
