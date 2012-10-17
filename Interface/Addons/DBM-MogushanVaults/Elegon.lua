local mod	= DBM:NewMod(726, "DBM-MogushanVaults", nil, 317)
local L		= mod:GetLocalizedStrings()
local sndWOP	= mod:NewSound(nil, "SoundWOP", true)
local sndCC	= mod:NewSound(nil, "SoundCC", true)
local sndDD = mod:NewSound(nil, "SoundDD", false)

mod:SetRevision(("$Revision: 7954 $"):sub(12, -3))
mod:SetCreatureID(60410)--Energy Charge (60913), Emphyreal Focus (60776), Cosmic Spark (62618), Celestial Protector (60793)
mod:SetModelID(41399)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_AURA_REMOVED",
	"UNIT_SPELLCAST_SUCCEEDED",
	"RAID_BOSS_EMOTE",
	"UNIT_HEALTH",
	"SPELL_CAST_START"
)

--[[
spellid = 116994 or spell = "Icy Touch"  and targetname = "Elegon" and sourcename = "Shiramune" and fulltype = SPELL_CAST_SUCCESS or spellid = 117960 and fulltype = SPELL_CAST_START or spellid = 117954 or spellid = 129711 or spell = "Draw Power" or spellid = 117204 or spellid = 117945 and not (fulltype = SPELL_DAMAGE) or spellid = 117949
--]]

local warnPhase1					= mod:NewPhaseAnnounce(1, 2)--117727 Charge Vortex
local warnBreath					= mod:NewSpellAnnounce(117960, 3)
local warnProtector					= mod:NewCountAnnounce(117954, 3)
local warnArcingEnergy				= mod:NewSpellAnnounce(117945, 2)--Cast randomly at 2 players, it is avoidable.
local warnClosedCircuit				= mod:NewTargetAnnounce(117949, 3, nil, mod:IsHealer())--what happens if you fail to avoid the above
local warnTotalAnnihilation			= mod:NewCastAnnounce(129711, 4)--Protector dying(exploding)
local warnPhase2					= mod:NewPhaseAnnounce(2, 3)--124967 Draw Power
local warnDrawPower					= mod:NewCountAnnounce(119387, 4)
local warnPhase3					= mod:NewPhaseAnnounce(3, 3)--116994 Unstable Energy Starting
local warnRadiatingEnergies			= mod:NewSpellAnnounce(118310, 4)

local warnCoresLeft				= mod:NewAddsLeftAnnounce("ej6193", 2, 117878)

local specWarnOvercharged			= mod:NewSpecialWarningStack(117878, nil, 6)
local specWarnTotalAnnihilation		= mod:NewSpecialWarningSpell(129711, nil, nil, nil, true)
local specWarnProtector				= mod:NewSpecialWarning("specWarnProtector")
local specWarnCharge				= mod:NewSpecialWarning("specWarnCharge")
local specWarnCore					= mod:NewSpecialWarningSwitch("ej6193")
local specWarnClosedCircuit			= mod:NewSpecialWarningDispel(117949, false)--Probably a spammy mess if this hits a few at once. But here in case someone likes spam.
local specWarnDrawPower				= mod:NewSpecialWarningStack(119387, nil, 1)
local specWarnDespawnFloor			= mod:NewSpecialWarning("specWarnDespawnFloor", nil, nil, nil, true)
local specWarnRadiatingEnergies		= mod:NewSpecialWarningSpell(118310, nil, nil, nil, true)

local timerBreathCD					= mod:NewCDTimer(18, 117960)
local timerProtectorCD				= mod:NewCDTimer(35.5, 117954)
local timerArcingEnergyCD			= mod:NewCDTimer(11.5, 117945)
local timerCharge					= mod:NewNextTimer(15, 119358)
local timerDespawnFloor				= mod:NewTimer(7, "timerDespawnFloor", 116994)
--Some timer work needs to be added for the adds spawning and reaching outer bubble
--(ie similar to yorsahj oozes reach, only for how long you have to kill adds before you fail and phase 2 ends)

local berserkTimer					= mod:NewBerserkTimer(570)

local phase2Started = false
local protectorCount = 0
local closedCircuitTargets = {}
local LowHP = {}
local sentAEHP = {}
local warnedAEHP = {}
local warned = 0
local coresCount = 0
local Protector = EJ_GetSectionInfo(6178)
mod:AddBoolOption("optDBPull", false, "sound")
mod:AddDropdownOption("optOC", {"six", "nine", "twelve", "fifteen", "none"}, "six", "sound")
mod:AddDropdownOption("optPos", {"nonepos", "posA", "posB", "posC", "posD", "posE", "posF"}, "nonepos", "sound")


local OCn = 0
local POSn = ""

local chargePos = {
  ["A"] = 	{ 25, 45 },
  ["B"] = 	{ 21, 42 },
  ["C"] = 	{ 17, 45 },
  ["D"] = 	{ 17, 57 },
  ["E"] = 	{ 21, 60 },
  ["F"] = 	{ 25, 58 },
}

local function warnClosedCircuitTargets()
	warnClosedCircuit:Show(table.concat(closedCircuitTargets, "<, >"))
	table.wipe(closedCircuitTargets)
	if mod:IsHealer() and mod:AntiSpam(3, 1) then
		sndCC:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_qssd.mp3")--驅散閃電
	end
end

function mod:OnCombatStart(delay)
	protectorCount = 0
	coresCount = 0
	table.wipe(closedCircuitTargets)
	timerBreathCD:Start(8-delay)
	table.wipe(LowHP)
	table.wipe(sentAEHP)
	table.wipe(warnedAEHP)
	warned = 0
	if not mod:IsDps() then
		sndWOP:Schedule(6, "Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_zbhx.mp3") --準備火息
	end
	timerProtectorCD:Start(12-delay)
	berserkTimer:Start(-delay)
end

function checkTankPull()
	if (not (mod:IsTank() and UnitName("target") == Protector)) or mod.Options.optDBPull then
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_zbhx.mp3")
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(124967) and not phase2Started then--Phase 2 begin/Phase 1 end
		phase2Started = true--because if you aren't fucking up, you should get more then one draw power.
		protectorCount = 0--better to reset protector Count on phase2.
		warnPhase2:Show()
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ptwo.mp3") --P2
		POSn = self.Options.optPos == "posA" and "A" or self.Options.optPos == "posB" and "B" or self.Options.optPos == "posC" and "C" or self.Options.optPos == "posD" and "D" or self.Options.optPos == "posE" and "E" or self.Options.optPos == "posF" and "F" or self.Options.optPos == "nonepos" and "NONE"
		if POSn ~= "NONE" then
			DBM.Arrow:ShowRunTo(chargePos[POSn][1]/100,chargePos[POSn][2]/100)
		end
		timerBreathCD:Cancel()
		timerCharge:Start()
		if not mod:IsHealer() then
			sndWOP:Schedule(12, "Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
			sndWOP:Schedule(13, "Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
			sndWOP:Schedule(14, "Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
		end
		if not mod:IsDps() then
			sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_zbhx.mp3")
			self:Unschedule(checkTankPull)
		end
		timerProtectorCD:Cancel()	
	elseif args:IsSpellID(116994) then--Phase 3 begin/Phase 2 end
		phase2Started = false
--		warnPhase3:Show()
--		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\pthree.mp3") --P3
	elseif args:IsSpellID(117878) and args:IsPlayer() then
		OCn = self.Options.optOC == "six" and 6 or self.Options.optOC == "nine" and 9 or self.Options.optOC == "twelve" and 12 or self.Options.optOC == "fifteen" and 15 or self.Options.optOC == "none" and 99
		if (args.amount or 1) >= OCn and args.amount % 3 == 0 and self:IsInCombat() then--Warn every 3 stacks at 6 and above.
			specWarnOvercharged:Show(args.amount)
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_czgg.mp3") --超載過高
			warnedCZ = true
		end
	elseif args:IsSpellID(119387) then -- do not add other spellids.
		warnDrawPower:Show(args.amount or 1)
		specWarnDrawPower:Show(args.amount or 1)
	elseif args:IsSpellID(118310) then--Below 50% health
		warnRadiatingEnergies:Show()
		specWarnRadiatingEnergies:Show()--Give a good warning so people standing outside barrior don't die.
	elseif args:IsSpellID(132265, 116598) and self:AntiSpam(30, 2) then
		warnPhase3:Show()
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\pthree.mp3") --P3
		coresCount = 0
		if not mod:IsHealer() then
			sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
			sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
			sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
		end
		DBM.Arrow:Hide()
		specWarnCore:Show()
--		timerDespawnFloor:Start()--Should be pretty accurate, may need minor tweak
	elseif args:IsSpellID(119360) then
		if not mod:IsHealer() then
			sndWOP:Schedule(0.2, "Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
			sndWOP:Schedule(1.2, "Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
			sndWOP:Schedule(2.2, "Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
		end
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(116994) then--phase 3 end
		warnPhase1:Show()
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\phasechange.mp3")
		warned = warned + 1
		if warned == 2 then
			self:Schedule(2, function()
				if not UnitDebuff("player", GetSpellInfo(117870)) then
					sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_kjzc.mp3") --快進中場
				end
			end)
		end
	elseif args:IsSpellID(117878) and args:IsPlayer() and self:IsInCombat() then
		sndDD:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\di.mp3") --~
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(117960) then
		warnBreath:Show()
		timerBreathCD:Start()
		if not mod:IsDps() then
			if warned ~=2 then
				self:Schedule(16, checkTankPull)
			else
				sndWOP:Schedule(10, "Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_zbhx.mp3")
			end
		end
	elseif args:IsSpellID(117954) then
		protectorCount = protectorCount + 1
		warnProtector:Show(protectorCount)
		specWarnProtector:Show(protectorCount)
		timerProtectorCD:Start()
		warnedPH = false
		if mod:IsDps() then
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_bwzkd.mp3") --保衛者快打
		else
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_bwzcx.mp3") --保衛者出現
		end
	elseif args:IsSpellID(117945) then
		warnArcingEnergy:Show()
		timerArcingEnergyCD:Start(args.sourceGUID)
	elseif args:IsSpellID(129711) then
		warnTotalAnnihilation:Show()
		specWarnTotalAnnihilation:Show()
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_zbbz.mp3") --準備爆炸
		if mod:IsHealer() then
			sndWOP:Schedule(1.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
			sndWOP:Schedule(2.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
			sndWOP:Schedule(3.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
		end
		timerArcingEnergyCD:Cancel(args.sourceGUID)--add is dying, so this add is done casting arcing Energy
	elseif args:IsSpellID(117949) then
		closedCircuitTargets[#closedCircuitTargets + 1] = args.destName
		specWarnClosedCircuit:Show(args.destName)
		self:Unschedule(warnClosedCircuitTargets)
		self:Schedule(0.3, warnClosedCircuitTargets)
	elseif args:IsSpellID(119358) then
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_dqkd.mp3") --電球快打
		coresCount = coresCount + 1
		specWarnCharge:Show(coresCount)
		if coresCount == 1 then
			sndWOP:Schedule(1.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
		elseif coresCount == 2 then
			sndWOP:Schedule(1.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
		elseif coresCount == 3 then
			sndWOP:Schedule(1.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
		elseif coresCount == 4 then
			sndWOP:Schedule(1.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\countfour.mp3")
		elseif coresCount == 5 then
			sndWOP:Schedule(1.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\countfive.mp3")
		elseif coresCount == 6 then
			sndWOP:Schedule(1.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\countsix.mp3")
		end
	end
end

function mod:RAID_BOSS_EMOTE(msg)
	if msg == L.Floor or msg:find(L.Floor) then
		if UnitDebuff("player", GetSpellInfo(117870)) then
			sndWOP:Schedule(1, "Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_lkzc.mp3") --離開中場
		else
			sndWOP:Schedule(1, "Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_zcxs.mp3") --中場即將消失
		end
		specWarnDespawnFloor:Show()
		timerDespawnFloor:Start()--Should be pretty accurate, may need minor tweak
	end
end

function mod:UNIT_HEALTH(uId)
	local cid = self:GetUnitCreatureId(uId)
	local guid = UnitGUID(uId)
	if cid == 60793 then
		if UnitHealth(uId) / UnitHealthMax(uId) <= 0.4 and not LowHP[guid] then
			if mod:IsTank() and UnitName("target") == Protector then
				sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\checkhp.mp3") --注意血量
				LowHP[guid] = true
			end
		end
		if UnitHealth(uId) / UnitHealthMax(uId) <= 0.4 and not sentAEHP[guid] then
			sentAEHP[guid] = true
			self:SendSync("aehealth", guid)
		end
	end
end

function mod:OnSync(msg, guid)
	if msg == "aehealth" and guid and not warnedAEHP[guid] then
		warnedAEHP[guid] = true
		if mod:IsHealer() then
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\aesoon.mp3") --準備AE
		end
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, _, _, spellId)
	if spellId == 127362 and self:AntiSpam(5, 3) then
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\failed.mp3") --~
	end
end