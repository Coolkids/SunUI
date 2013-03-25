local mod	= DBM:NewMod(827, "DBM-ThroneofThunder", nil, 362)
local L		= mod:GetLocalizedStrings()
-- BH ADD
local sndWOP	= mod:NewSound(nil, "SoundWOP", true)
local sndIon	= mod:NewSound(nil, "SoundWOP", true)
local sndIonCD	= mod:NewSound(nil, "SoundWOP", true)

mod:SetRevision(("$Revision: 8978 $"):sub(12, -3))
mod:SetCreatureID(69465)
mod:SetModelID(47552)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_REMOVED",
	-- BH ADD
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

local timerFocusedLightningCD		= mod:NewCDTimer(10, 137399)--10-18 second variation, tends to lean toward 11-12 except when delayed by other casts such as throw or storm. Pull one also seems to variate highly
local timerStaticBurstCD			= mod:NewCDTimer(19, 137162, mod:IsTank())
local timerThrowCD					= mod:NewCDTimer(26, 137175)--90-93 variable (26-30 seconds after storm. verified in well over 50 logs)
local timerStorm					= mod:NewBuffActiveTimer(17, 137313)--2 second cast, 15 second duration
local timerStormCD					= mod:NewCDTimer(60.5, 137313)--90-93 variable (60.5~67 seconds after throw)
local timerIonizationCD				= mod:NewNextTimer(60.5, 138732)
-- BH ADD
local specWarnLightningCrack			= mod:NewSpecialWarningMove(137485)
local specWarnJSA				= mod:NewSpecialWarning("SpecWarnJSA")
local stormcount = 0
-- BH ADD END

-- BH DELETE local soundFocusedLightning			= mod:NewSound(137422)

local berserkTimer					= mod:NewBerserkTimer(540)

-- BH DELETE local countdownIonization			= mod:NewCountdown(60.5, 138732)

mod:AddBoolOption("RangeFrame")
-- BH ADD
local focusme = false
local inoizame = false
for i = 1, 4 do
	mod:AddBoolOption("dr"..i, false, "sound")
end
local function MyJS1()
	if (mod.Options.dr1 and stormcount %2 == 1) or (mod.Options.dr3 and stormcount %2 == 0) then
		return true
	end
	return false
end
local function MyJS2()
	if (mod.Options.dr2 and stormcount %2 == 1) or (mod.Options.dr4 and stormcount %2 == 0) then
		return true
	end
	return false
end
-- BH ADD END

local scansDone = 0

function mod:TargetScanner(Force)
	scansDone = scansDone + 1
	local targetname, uId = self:GetBossTarget(69465)
	if UnitExists(targetname) then
		if self:IsTanking(uId, "boss1") and not Force then
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
	timerFocusedLightningCD:Start(8-delay)
	timerStaticBurstCD:Start(13-delay)
	timerThrowCD:Start(30-delay)
	-- BH ADD
	focusme = false
	inoizame = false
	stormcount = 0
	if self:IsDifficulty("heroic10", "heroic25") then
		timerIonizationCD:Start(-delay)
--BH DELETE	countdownIonization:Start(-delay)
		sndIonCD:Schedule(56, "Interface\\AddOns\\DBM-Core\\extrasounds\\ex_tt_dlzb.mp3")
		sndIonCD:Schedule(57, "Interface\\AddOns\\DBM-Core\\extrasounds\\countfour.mp3")
		sndIonCD:Schedule(58, "Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
		sndIonCD:Schedule(59, "Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
		sndIonCD:Schedule(60, "Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
	end
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
		warnStorm:Show()
--BH DELETE	specWarnStorm:Show()
		timerStorm:Start()
		timerStaticBurstCD:Start(22.5)--May need tweaking
		timerThrowCD:Start()
		--BH ADD
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_tt_sdfbzb.mp3")
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\countfour.mp3")
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
		stormcount = stormcount + 1
		if stormcount == 1 then
			sndWOP:Schedule(1, "Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
		elseif stormcount == 2 then
			sndWOP:Schedule(1, "Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
		elseif stormcount == 3 then
			sndWOP:Schedule(1, "Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
		elseif stormcount == 4 then
			sndWOP:Schedule(1, "Interface\\AddOns\\DBM-Core\\extrasounds\\countfour.mp3")
		end
		if MyJS1() then
			specWarnJSA:Show()
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_zyjs.mp3") --注意減傷
		else
			specWarnStorm:Show()
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_sdfb.mp3") --閃電風暴
		end
		if MyJS2() then
			specWarnJSA:Schedule(5)
			sndWOP:Schedule(5, "Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_zyjs.mp3")
		end		
		sndWOP:Schedule(15, "Interface\\AddOns\\DBM-Core\\extrasounds\\ex_tt_fbjs.mp3") --風暴結束
		--BH ADD END		
		if self:IsDifficulty("heroic10", "heroic25") then
			timerIonizationCD:Start()
--BH DELETE		countdownIonization:Start()
			sndIonCD:Schedule(56, "Interface\\AddOns\\DBM-Core\\extrasounds\\ex_tt_dlzb.mp3")
			sndIonCD:Schedule(57, "Interface\\AddOns\\DBM-Core\\extrasounds\\countfour.mp3")
			sndIonCD:Schedule(58, "Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
			sndIonCD:Schedule(59, "Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
			sndIonCD:Schedule(60, "Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
		end
	elseif args:IsSpellID(138732) then
		warnIonization:Show()
		specWarnIonization:Show()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(137162) then
		timerStaticBurstCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(137162) then
		warnStaticBurst:Show(args.destName)
		if args:IsPlayer() then
			specWarnStaticBurst:Show()
		else
			specWarnStaticBurstOther:Show(args.destName)
		end
		if mod:IsTank() then
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\changemt.mp3") --換坦嘲諷
		end
	elseif args:IsSpellID(138732) and args:IsPlayer() then
		--BH MODIFY
		if self.Options.RangeFrame then
			if self:IsDifficulty("heroic25") then
				DBM.RangeCheck:Show(4)
			else
				DBM.RangeCheck:Show(8)
			end
		end
		inoizame = true
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_tt_dlzh.mp3") --電離子化
		self:Schedule(16, function()
			if UnitDebuff("player", GetSpellInfo(138732)) then
				DBM.Flash:Show(1, 0, 0)
				self:Schedule(0.5, function() DBM.Flash:Show(0, 0, 1) end)
				self:Schedule(1, function() DBM.Flash:Show(1, 0, 0) end)
			end
		 end)
		sndIon:Schedule(16, "Interface\\AddOns\\DBM-Core\\extrasounds\\runout.mp3")	--離開人群
		sndIon:Schedule(16.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\runout.mp3")
		sndIon:Schedule(17, "Interface\\AddOns\\DBM-Core\\extrasounds\\runout.mp3")
		sndIon:Schedule(18.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\countsix.mp3")
		sndIon:Schedule(19.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\countfive.mp3")
		sndIon:Schedule(20.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\countfour.mp3")
		sndIon:Schedule(21.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
		sndIon:Schedule(22.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
		sndIon:Schedule(23.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
		--BH MODIFY END
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(138732) and args:IsPlayer() then
		--BH MODIFY
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
		--BH MODIFY END
	end
end

function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, destName, _, _, spellId)
	if spellId == 138006 and destGUID == UnitGUID("player") and self:AntiSpam() then
		specWarnElectrifiedWaters:Show()
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\runaway.mp3") --快躲開
	end
end
mod.SPELL_PERIODIC_MISSED = mod.SPELL_PERIODIC_DAMAGE

--BH ADD
function mod:SPELL_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 137485 and destGUID == UnitGUID("player") and self:AntiSpam(2, 2) then
		specWarnLightningCrack:Show()
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\runaway.mp3") --快躲開
	end
end
mod.SPELL_MISSED = mod.SPELL_DAMAGE
--BH ADD END

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg, _, _, _, target)
	if msg:find("spell:137175") then
		warnThrow:Show(target)
		timerStormCD:Start()
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_tt_lttz.mp3") --雷霆投擲
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
		specWarnFocusedLightning:Show()
		yellFocusedLightning:Yell()
--BH DELETE	soundFocusedLightning:Play()
		if self.Options.RangeFrame then
			DBM.RangeCheck:Show(8)
		end
		focusme = true
		DBM.Flash:Show(1, 0, 0)
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_tt_sddn.mp3") --閃電點你
	end
end