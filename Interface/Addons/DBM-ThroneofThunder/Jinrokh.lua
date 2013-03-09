if select(4, GetBuildInfo()) < 50200 then return end--Don't load on live
local mod	= DBM:NewMod(827, "DBM-ThroneofThunder", nil, 362)
local L		= mod:GetLocalizedStrings()
local sndWOP	= mod:NewSound(nil, "SoundWOP", true)
local sndIon	= mod:NewSound(nil, "SoundWOP", true)

mod:SetRevision(("$Revision: 8831 $"):sub(12, -3))
mod:SetCreatureID(69465)
mod:SetModelID(47552)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START",
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_REMOVED",
	"SPELL_DAMAGE",
	"SPELL_MISSED",
	"SPELL_PERIODIC_DAMAGE",
	"SPELL_PERIODIC_MISSED",
	"CHAT_MSG_RAID_BOSS_EMOTE",
	"RAID_BOSS_WHISPER"
)

local warnFocusedLightning			= mod:NewTargetAnnounce(137399, 4)
local warnStaticBurst				= mod:NewTargetAnnounce(137162, 3, nil, mod:IsTank() or mod:IsHealer())
local warnThrow						= mod:NewTargetAnnounce(137175, 2)
local warnStorm						= mod:NewSpellAnnounce(137313, 3)
local warnIonization				= mod:NewSpellAnnounce(138732, 4)

local specWarnFocusedLightning		= mod:NewSpecialWarningRun(137422)
local yellFocusedLightning			= mod:NewYell(137422)
local specWarnStaticBurst			= mod:NewSpecialWarningYou(137162, mod:IsTank())
local specWarnStaticBurstOther		= mod:NewSpecialWarningTarget(137162, mod:IsTank())
local specWarnThrow					= mod:NewSpecialWarningYou(137175, mod:IsTank())
local specWarnThrowOther			= mod:NewSpecialWarningTarget(137175, mod:IsTank())
local specWarnStorm					= mod:NewSpecialWarningSpell(137313, nil, nil, nil, 2)
local specWarnElectrifiedWaters		= mod:NewSpecialWarningMove(138006)
local specWarnIonization			= mod:NewSpecialWarningSpell(138732, not mod:IsTank(), nil, nil, 2)
local specWarnLightningCrack		= mod:NewSpecialWarningMove(137485)

local specWarnJSA					= mod:NewSpecialWarning("SpecWarnJSA")

local timerFocusedLightningCD		= mod:NewCDTimer(10, 137399)--10-18 second variation, tends to lean toward 11-12 except when delayed by other casts such as throw or storm. Pull one also seems to variate highly
local timerStaticBurstCD			= mod:NewCDTimer(19, 137162, mod:IsTank())
local timerThrowCD					= mod:NewNextTimer(33, 137175)--90-93 variable (but always 33 seconds after storm, the only variation is between first and second one really)
local timerStormCD					= mod:NewNextTimer(60, 137313)--90-93 variable (but ALWAYS 60 seconds after throw, so we use throw as trigger point)
local timerStorm					= mod:NewCastTimer(15, 137313)
local timerIonizationCD				= mod:NewCDTimer(60, 138732)

local stormcount = 0
--local soundFocusedLightning			= mod:NewSound(137422)

local berserkTimer					= mod:NewBerserkTimer(540)

mod:AddBoolOption("RangeFrame")


--黑手減傷

for i = 1, 8 do
	mod:AddBoolOption("dr"..i, false, "sound")
end

local function MyJS1()
	if (mod.Options.dr1 and stormcount == 1) or (mod.Options.dr3 and stormcount == 2) or (mod.Options.dr5 and stormcount == 3) or (mod.Options.dr7 and stormcount == 4) then
		return true
	end
	return false
end

local function MyJS2()
	if (mod.Options.dr2 and stormcount == 1) or (mod.Options.dr4 and stormcount == 2) or (mod.Options.dr6 and stormcount == 3) or (mod.Options.dr8 and stormcount == 4) then
		return true
	end
	return false
end

--減傷結束



local scansDone = 0

local focusme = false
local inoizame = false

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

function mod:TargetScanner(Force)
	scansDone = scansDone + 1
	local targetname, uId = self:GetBossTarget(69465)
	if UnitExists(targetname) then
		if isTank(uId) and not Force then
			if scansDone < 12 then
				self:ScheduleMethod(0.025, "TargetScanner")
			else
				self:TargetScanner(true)
			end
		else
			warnFocusedLightning:Show(targetname)
		end
	else
		if scansDone < 12 then
			self:ScheduleMethod(0.025, "TargetScanner")
		end
	end
end

function mod:OnCombatStart(delay)
	timerFocusedLightningCD:Start(-delay)
	timerStaticBurstCD:Start(13-delay)
	timerThrowCD:Start(30-delay)
	focusme = false
	inoizame = false
	if self:IsDifficulty("heroic10", "heroic25") then
		timerIonizationCD:Start(60-delay)
	end
	stormcount = 0
	berserkTimer:Start(-delay)
end

function mod:OnCombatEnd()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(137399) then
		scansDone = 0
		self:TargetScanner()
		timerFocusedLightningCD:Start()
	elseif args:IsSpellID(137313) then
		stormcount = stormcount + 1
		warnStorm:Show()
--		specWarnStorm:Show()
		timerStaticBurstCD:Start(22.5)--May need tweaking
		timerThrowCD:Start()
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_tt_sdfbzb.mp3")
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\countfour.mp3")
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")

		if stormcount == 1 then
			sndWOP:Schedule(1, "Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
		elseif stormcount == 2 then
			sndWOP:Schedule(1, "Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
		elseif stormcount == 3 then
			sndWOP:Schedule(1, "Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
		elseif stormcount == 4 then
			sndWOP:Schedule(1, "Interface\\AddOns\\DBM-Core\\extrasounds\\countfour.mp3")
		end
		
		--黑手減傷
		if MyJS1() then
			specWarnJSA:Show()
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_zyjs.mp3") --注意減傷
		else
			specWarnStorm:Show()
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_sdfb.mp3") --閃電風暴
		end
		if MyJS2() then
			specWarnJSA:Schedule(8)
			sndWOP:Schedule(8, "Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_zyjs.mp3")
		end
		--減傷結束
		
		sndWOP:Schedule(15, "Interface\\AddOns\\DBM-Core\\extrasounds\\ex_tt_fbjs.mp3") --風暴結束
		
		if self:IsDifficulty("heroic10", "heroic25") then
			timerIonizationCD:Start(61.5)
		end
	elseif args:IsSpellID(138732) then
		warnIonization:Show()
		specWarnIonization:Show()
		if not mod:IsTank() then
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_tt_dlzh.mp3") --電離子化
		end
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(137162) then
		warnStaticBurst:Show(args.destName)
		timerStaticBurstCD:Start()
		if args:IsPlayer() then
			specWarnStaticBurst:Show()
		else
			specWarnStaticBurstOther:Show(args.destName)
		end
		if mod:IsTank() then
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\changemt.mp3") --換坦嘲諷
		end
	elseif args:IsSpellID(138732) and args:IsPlayer() then
		if self.Options.RangeFrame then
			if self:IsDifficulty("heroic25") then
				DBM.RangeCheck:Show(4)
			else
				DBM.RangeCheck:Show(8)
			end
		end
		inoizame = true
		sndIon:Schedule(16, "Interface\\AddOns\\DBM-Core\\extrasounds\\runout.mp3")	--離開人群
		sndIon:Schedule(17.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\countseven.mp3")
		sndIon:Schedule(18.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\countsix.mp3")
		sndIon:Schedule(19.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\countfive.mp3")
		sndIon:Schedule(20.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\countfour.mp3")
		sndIon:Schedule(21.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
		sndIon:Schedule(22.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
		sndIon:Schedule(23.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
	elseif args:IsSpellID(137313) then
		timerStorm:Start()
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(138732) and args:IsPlayer() then
		inoizame = false
		if self.Options.RangeFrame then
			if focusme then
				DBM.RangeCheck:Show(8)
			else
				DBM.RangeCheck:Hide()
			end
		end
		sndIon:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\runout.mp3")
		sndIon:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\countseven.mp3")
		sndIon:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\countsix.mp3")
		sndIon:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\countfive.mp3")
		sndIon:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\countfour.mp3")
		sndIon:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
		sndIon:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
		sndIon:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
		sndIon:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\safenow.mp3")
	elseif args:IsSpellID(137422) and args:IsPlayer() then
		focusme = false
		if self.Options.RangeFrame then
			if inoizame then
				if self:IsDifficulty("heroic25") then
					DBM.RangeCheck:Show(4)
				else
					DBM.RangeCheck:Show(8)
				end
			else
				DBM.RangeCheck:Hide()
			end
		end
	end
end

function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, destName, _, _, spellId)
	if spellId == 138006 and destGUID == UnitGUID("player") and self:AntiSpam() then
		specWarnElectrifiedWaters:Show()
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\runaway.mp3") --快躲開
	end
end
mod.SPELL_PERIODIC_MISSED = mod.SPELL_PERIODIC_DAMAGE

function mod:SPELL_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 137485 and destGUID == UnitGUID("player") and self:AntiSpam(2, 2) then
		specWarnLightningCrack:Show()
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\runaway.mp3") --快躲開
	end
end
mod.SPELL_MISSED = mod.SPELL_DAMAGE

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg, _, _, _, target)
	if msg:find("spell:137175") then
		warnThrow:Show(target)
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_tt_lttz.mp3") --雷霆投擲
		timerStormCD:Start()
		sndWOP:Schedule(55, "Interface\\AddOns\\DBM-Core\\extrasounds\\ex_tt_sdfbzb.mp3") -- 閃電風暴準備
		sndWOP:Schedule(56.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\countfour.mp3")
		sndWOP:Schedule(57.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
		sndWOP:Schedule(58.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
		sndWOP:Schedule(59.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
		if target == UnitName("player") then
			specWarnThrow:Show()
		else
			specWarnThrowOther:Show(target)
		end
	end
end

--"<294.8 20:14:02> [RAID_BOSS_WHISPER] RAID_BOSS_WHISPER#|TInterface\\Icons\\ability_vehicle_electrocharge:20|t%s's |cFFFF0000|Hspell:137422|h[Focused Lightning]|h|r fixates on you. Run!#Jin'rokh the Breaker#0#false", -- [12425]
function mod:RAID_BOSS_WHISPER(msg)
	if msg:find("spell:137422") then--In case target scanning fails, personal warnings still always go off. Target scanning is just so everyone else in raid knows who it's on (since only target sees this emote)
		focusme = true
		specWarnFocusedLightning:Show()
		yellFocusedLightning:Yell()
--		soundFocusedLightning:Play()
		if self.Options.RangeFrame then
			DBM.RangeCheck:Show(8)
		end
		DBM.Flash:Show(1, 0, 0)
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_tt_sddn.mp3") --閃電點你
	end
end