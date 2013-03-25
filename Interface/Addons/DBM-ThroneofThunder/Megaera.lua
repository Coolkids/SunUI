local mod	= DBM:NewMod(821, "DBM-ThroneofThunder", nil, 362)
local L		= mod:GetLocalizedStrings()
local sndWOP	= mod:NewSound(nil, "SoundWOP", true)

mod:SetRevision(("$Revision: 8979 $"):sub(12, -3))
mod:SetCreatureID(68065, 70212, 70235, 70247)--flaming 70212. Frozen 70235, Venomous 70247
mod:SetModelID(47414)--Hydra Fire Head, 47415 Frost Head, 47416 Poison Head
mod:SetUsedIcons(7, 6)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_AURA_REMOVED",
	"SPELL_DAMAGE",
	"SPELL_MISSED",
	"CHAT_MSG_RAID_BOSS_EMOTE",
	"RAID_BOSS_WHISPER",
	"UNIT_SPELLCAST_SUCCEEDED",
	"UNIT_DIED"
)

local warnRampage				= mod:NewCountAnnounce(139458, 3)
local warnArcticFreeze			= mod:NewStackAnnounce(139843, 3, nil, mod:IsTank() or mod:IsHealer())
local warnIgniteFlesh			= mod:NewStackAnnounce(137731, 3, nil, mod:IsTank() or mod:IsHealer())
local warnRotArmor				= mod:NewStackAnnounce(139840, 3, nil, mod:IsTank() or mod:IsHealer())
local warnArcaneDiffusion		= mod:NewStackAnnounce(139993, 3, nil, mod:IsTank() or mod:IsHealer())--Heroic
local warnCinders				= mod:NewTargetAnnounce(139822, 4)
local warnTorrentofIce			= mod:NewTargetAnnounce(139889, 4)
local warnNetherTear			= mod:NewSpellAnnounce(140138, 3)--Heroic

local specWarnRampage			= mod:NewSpecialWarningSpell(139458, nil, nil, nil, 2)
local specWarnArcticFreeze		= mod:NewSpecialWarningStack(139843, mod:IsTank(), 2)
local specWarnIgniteFlesh		= mod:NewSpecialWarningStack(137731, mod:IsTank(), 2)
local specWarnRotArmor			= mod:NewSpecialWarningStack(139840, mod:IsTank(), 2)
local specWarnArcaneDiffusion	= mod:NewSpecialWarningStack(139993, mod:IsTank(), 2)
local specWarnCinders			= mod:NewSpecialWarningYou(139822)
local yellCinders				= mod:NewYell(139822)
local specWarnTorrentofIceYou	= mod:NewSpecialWarningRun(139889)
local yellTorrentofIce			= mod:NewYell(139889)
local specWarnTorrentofIce		= mod:NewSpecialWarningMove(139889)
local specWarnNetherTear		= mod:NewSpecialWarningSwitch("ej7816", mod:IsDps())

local timerRampage				= mod:NewBuffActiveTimer(21, 139458)
local timerArcticFreezeCD		= mod:NewCDTimer(16, 139843, mod:IsTank() or mod:IsHealer())--breath cds are very often syncronized, but not always, sometimes if mobs not engaged same time they go off sync.
local timerIgniteFleshCD		= mod:NewCDTimer(16, 137731, mod:IsTank() or mod:IsHealer())--So must start cd bars for both in case of engage delays
local timerRotArmorCD			= mod:NewCDTimer(16, 139840, mod:IsTank() or mod:IsHealer())--This may have been PTR bug, if they stay synce don live, i will combine these 3 timers into 1
local timerArcaneDiffusionCD	= mod:NewCDTimer(17, 139993, mod:IsTank() or mod:IsHealer())
local timerCinderCD				= mod:NewCDTimer(25, 139822)
local timerTorrentofIceCD		= mod:NewCDTimer(16, 139866)
--local timerAcidRainCD			= mod:NewCDTimer(13.5, 139850)--Can only give time for next impact, no cast trigger so cannot warn cast very effectively. Maybe use some scheduling to pre warn. Although might be VERY spammy if you have many venomous up
local timerNetherTearCD			= mod:NewCDTimer(30, 140138)--Heroic

--local soundTorrentofIce			= mod:NewSound(139889)

mod:AddBoolOption("SetIconOnCinders", true)
mod:AddBoolOption("SetIconOnTorrentofIce", true)

--count will go to hell fast on a DC though. Need to figure out some kind of head status recovery to get active/inactive head counts.
--Maybe add an info frame that shows head status too would be cool such as
---------------------------
--Flaming head: A: 0 I: 2 -
--Frozen head: A: 1 I: 1  -
--Venomous head: A: 1 I: 1-
---------------------------
mod:AddBoolOption("InfoFrame", true, "sound")

mod:AddBoolOption("HudMAP", true, "sound")
mod:AddBoolOption("HudMAP2", true, "sound")

local DBMHudMap = DBMHudMap
local free = DBMHudMap.free
local function register(e)	
	DBMHudMap:RegisterEncounterMarker(e)
	return e
end
local FireMarkers = {}
local IceMarkers = {}

local Ramcount = 0

local combat = false

for i = 1, 8 do
	mod:AddBoolOption("dr"..i, false, "sound")
end

local function MyJS()
	if (mod.Options.dr1 and Ramcount == 1) or (mod.Options.dr2 and Ramcount == 2) or (mod.Options.dr3 and Ramcount == 3) or (mod.Options.dr4 and Ramcount == 4) or (mod.Options.dr5 and Ramcount == 5) or (mod.Options.dr6 and Ramcount == 6) or (mod.Options.dr7 and Ramcount == 7) or (mod.Options.dr8 and Ramcount == 8) then
		return true
	end
	return false
end

local fireInFront = 0
local venomInFront = 0
local iceInFront = 0
local arcaneInFront = 0
local fireBehind = 0
local venomBehind = 0
local iceBehind = 0
local arcaneBehind = 0
local rampageCast = 0
local activeHeadGUIDS = {}
local headdead = false
local firecount = 0
local icecount = 0

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
	if UnitExists("boss2target") and UnitDetailedThreatSituation(unit, "boss2") then
		return true
	end
	if UnitExists("boss3target") and UnitDetailedThreatSituation(unit, "boss3") then
		return true
	end
	if UnitExists("boss4target") and UnitDetailedThreatSituation(unit, "boss4") then
		return true
	end
	if UnitExists("boss5target") and UnitDetailedThreatSituation(unit, "boss5") then
		return true
	end
	return false
end

local function showheadinfo()
	if not combat then return end
	if mod.Options.InfoFrame then
		local fireinfo = "|cFFFF6347"..EJ_GetSectionInfo(6998) .. "|r: "..fireInFront
		local fireinfob = "|cFFFF6347"..L.Behind.."|r"..fireBehind
		local iceinfo = "|cFF0080FF"..EJ_GetSectionInfo(7002) .. "|r: "..iceInFront
		local iceinfob = "|cFF0080FF"..L.Behind.."|r"..iceBehind
		local venominfo = "|cFF088A08"..EJ_GetSectionInfo(7004) .. "|r: "..venomInFront
		local venominfob = "|cFF088A08"..L.Behind.."|r"..venomBehind
		local arcaneinfo = "|cFFB91FC7"..EJ_GetSectionInfo(7005) .. "|r: "..arcaneInFront
		local arcaneinfob = "|cFFB91FC7"..L.Behind.."|r"..arcaneBehind
		if mod:IsDifficulty("heroic10", "heroic25") then
			DBM.InfoFrame:Show(4, "other", iceinfob, iceinfo, venominfob, venominfo, fireinfob, fireinfo, arcaneinfob, arcaneinfo)
		else
			DBM.InfoFrame:Show(3, "other", iceinfob, iceinfo, venominfob, venominfo, fireinfob, fireinfo)
		end
	end
end

function mod:OnCombatStart(delay)
	table.wipe(activeHeadGUIDS)
	table.wipe(FireMarkers)
	table.wipe(IceMarkers)
	rampageCast = 0
	fireInFront = 0
	venomInFront = 0
	iceInFront = 0
	fireBehind = 1
	venomBehind = 0
	iceBehind = 0
	Ramcount = 0
	combat = true
	headdead = false
	timerCinderCD:Start(26)
	if self:IsDifficulty("heroic10", "heroic25") then
		arcaneBehind = 1
		arcaneInFront = 0
--		timerNetherTearCD:Start()
	end
	if self.Options.InfoFrame then
		DBM.InfoFrame:SetHeader(EJ_GetSectionInfo(7006))
		showheadinfo()
	end
	self:RegisterShortTermEvents(
		"INSTANCE_ENCOUNTER_ENGAGE_UNIT"--We register here to prevent detecting first heads on pull before variables reset from first engage fire. We'll catch them on delayed engages fired couple seconds later
	)
end

function mod:OnCombatEnd()
	self:UnregisterShortTermEvents()
	combat = false
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
	if self.Options.HudMAP or self.Options.HudMAP2 then
		DBMHudMap:FreeEncounterMarkers()
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(139866) then
		icecount = icecount + 1
		if iceBehind == 2 then
			if icecount%2==1 then
				timerTorrentofIceCD:Start(15)
			else
				timerTorrentofIceCD:Start(13)
			end
		elseif iceBehind == 3 then
			if icecount%3==0 then
				timerTorrentofIceCD:Start(8)
			else
				timerTorrentofIceCD:Start(10)
			end
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(140138) then
		warnNetherTear:Show()
		specWarnNetherTear:Show()
--		timerNetherTearCD:Start()--TODO: see if cast more often if more than 1 arcane head.
		if self:AntiSpam(10, 4) then
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\dragonnow.mp3")  --小龍出現
		end
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(139843) then
		local uId = DBM:GetRaidUnitId(args.destName)
		if isTank(uId) then
			warnArcticFreeze:Show(args.destName, args.amount or 1)
			timerArcticFreezeCD:Start(args.sourceGUID)
			if args:IsPlayer() then
				if (args.amount or 1) >= 2 then
					specWarnArcticFreeze:Show(args.amount)
				end
			end
		end
	elseif args:IsSpellID(137731) then
		local uId = DBM:GetRaidUnitId(args.destName)
		if isTank(uId) then
			warnIgniteFlesh:Show(args.destName, args.amount or 1)
			timerIgniteFleshCD:Start(args.sourceGUID)
			if args:IsPlayer() then
				if (args.amount or 1) >= 2 then
					specWarnIgniteFlesh:Show(args.amount)
				end
			end
		end
	elseif args:IsSpellID(139840) then
		local uId = DBM:GetRaidUnitId(args.destName)
		if isTank(uId) then
			warnRotArmor:Show(args.destName, args.amount or 1)
			timerRotArmorCD:Start(args.sourceGUID)
			if args:IsPlayer() then
				if (args.amount or 1) >= 2 then
					specWarnRotArmor:Show(args.amount)
				end
			end
		end
	elseif args:IsSpellID(139993) then
		local uId = DBM:GetRaidUnitId(args.destName)
		if isTank(uId) then
			warnArcaneDiffusion:Show(args.destName, args.amount or 1)
			timerArcaneDiffusionCD:Start(args.sourceGUID)
			if args:IsPlayer() then
				if (args.amount or 1) >= 2 then
					specWarnArcaneDiffusion:Show(args.amount)
				end
			end
		end
	elseif args:IsSpellID(139822) then
		firecount = firecount + 1
		warnCinders:Show(args.destName)
		if not headdead then
			timerCinderCD:Start()
		else
			if fireBehind == 2 then
				if firecount%2==1 then
					timerCinderCD:Start(15)
				else
					timerCinderCD:Start(13)
				end
			elseif fireBehind == 3 then
				if firecount%3==0 then
					timerCinderCD:Start(8)
				else
					timerCinderCD:Start(10)
				end
			end
		end
		if args:IsPlayer() then
			specWarnCinders:Show()
			yellCinders:Yell()
			DBM.Flash:Show(1, 0, 0)
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_hydn.mp3")  --快跑 火焰點你
		end
		if self.Options.HudMAP then
			local spelltext = GetSpellInfo(139822)
			FireMarkers[args.destName] = register(DBMHudMap:PlaceRangeMarkerOnPartyMember("highlight", args.destName, 3, 10, 1, 0 ,0 ,0.8):SetLabel(spelltext))
		end
		if self.Options.SetIconOnCinders then
			self:SetIcon(args.destName, 7)
		end
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(139822) then
		if args:IsPlayer() then
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\safenow.mp3")
		end
		if FireMarkers[args.destName] then
			FireMarkers[args.destName] = free(FireMarkers[args.destName])
		end
		if self.Options.SetIconOnCinders then
			self:SetIcon(args.destName, 0)
		end
	end
end

function mod:SPELL_DAMAGE(sourceGUID, _, _, _, destGUID, _, _, _, spellId, spellName)
	if spellId == 139850 and self:AntiSpam(2, 1) then
--		timerAcidRainCD:Start(13.5)--TODO, it should be cast more often more heads there are. this is timing with two heads in back. Find out timing with 1 head, or 3 or 4
	elseif spellId == 139889 and destGUID == UnitGUID("player") and self:AntiSpam(2, 2) then
		specWarnTorrentofIce:Show()
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\runaway.mp3") --快躲開
	end
end
mod.SPELL_MISSED = mod.SPELL_DAMAGE

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg, _, _, _, target)
	if msg:find("spell:139458") then
		rampageCast = rampageCast + 1
		warnRampage:Show(rampageCast)
		timerArcticFreezeCD:Cancel()
		timerIgniteFleshCD:Cancel()
		timerRotArmorCD:Cancel()
		--Not if back ones always cancel here, they seem too
--		timerCinderCD:Cancel()
--		timerTorrentofIceCD:Cancel()
--		timerAcidRainCD:Cancel()
--		timerNetherTearCD:Cancel()
		specWarnRampage:Show()
		timerRampage:Start()
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\gather.mp3")--快集合		
		Ramcount = Ramcount + 1		
		if MyJS() then
			sndWOP:Schedule(1, "Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_zyjs.mp3") --注意減傷
		end		
	elseif msg == L.rampageEnds or msg:find(L.rampageEnds) then
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\scattersoon.mp3")--注意分散
		if iceInFront > 0 then
			timerArcticFreezeCD:Start(10)
		end
		if fireInFront > 0 then
			timerIgniteFleshCD:Start(10)
		end
		if venomInFront > 0 then
			timerRotArmorCD:Start(10)
		end
		if iceBehind > 0 then
--			timerTorrentofIceCD:Start(40)--40-45
		end
		if fireBehind > 0 then
--			timerCinderCD:Start(30)--30-35
		end
		if venomBehind > 0 then
--			timerAcidRainCD:Start(23)
		end
		if arcaneBehind > 0 then
--			timerNetherTearCD:Start()
		end
	end
end

function mod:RAID_BOSS_WHISPER(msg)
	if msg:find("spell:139866") then
		specWarnTorrentofIceYou:Show()
		yellTorrentofIce:Yell()
--		soundTorrentofIce:Play()
		self:SendSync("IceTarget", UnitGUID("player"))
		DBM.Flash:Show(0, 0, 1)
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\justrun.mp3") --快跑
	end
end

local function CheckHeads(GUID)
	for i = 1, 5 do
		if UnitExists("boss"..i) and not activeHeadGUIDS[UnitGUID("boss"..i)] then--Check if new units exist we haven't detected and added yet.
			activeHeadGUIDS[UnitGUID("boss"..i)] = true
			local cid = mod:GetCIDFromGUID(UnitGUID("boss"..i))
			if cid == 70235 then--Frozen
				iceInFront = iceInFront + 1
				if iceBehind > 0 then
					iceBehind = iceBehind - 1
				end
			elseif cid == 70212 then--Flaming
				fireInFront = fireInFront + 1
				if fireBehind > 0 then
					fireBehind = fireBehind - 1
				end
			elseif cid == 70247 then--Venomous
				venomInFront = venomInFront + 1
				if venomBehind > 0 then
					venomBehind = venomBehind - 1
				end
			elseif cid == 70248 then--Arcane
				arcaneInFront = arcaneInFront + 1
				if arcaneBehind > 0 then
					arcaneBehind = arcaneBehind - 1
				end
			end
		end
	end
	showheadinfo()
end

--Only real way to detect heads moving from back to front.
function mod:INSTANCE_ENCOUNTER_ENGAGE_UNIT()
	self:Unschedule(CheckHeads)
	self:Schedule(1, CheckHeads)--Delay check to make sure dying heads are cleared before accidentally adding them back in after they cast "feign death" but before they actually die"
end

--Unfortunately we need to update the counts sooner than UNIT_DIED fires because we need those counts BEFORE CHAT_MSG_RAID_BOSS_EMOTE fires.
function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, _, _, spellId)
	if spellId == 70628 and self:AntiSpam(2, 3) then--Permanent Feign Death
		local cid = self:GetCIDFromGUID(UnitGUID(uId))
		if cid == 70235 then--Frozen
			iceInFront = iceInFront - 1
			iceBehind = iceBehind + 2
		elseif cid == 70212 then--Flaming
			fireInFront = fireInFront - 1
			fireBehind = fireBehind + 2
		elseif cid == 70247 then--Venomous
			venomInFront = venomInFront - 1
			venomBehind = venomBehind + 2
		elseif cid == 70248 then--Arcane
			arcaneInFront = arcaneInFront - 1
			arcaneBehind = arcaneBehind + 2
		end
		showheadinfo()
	end
end

local function clearHeadGUID(GUID)
	activeHeadGUIDS[GUID] = nil
end

--Nil out front boss GUIDs and cancel timers for correct died unit so those units can activate again later
function mod:UNIT_DIED(args)
	headdead = true
	firecount = 0
	icecount = 0
	timerCinderCD:Cancel()
	timerTorrentofIceCD:Cancel()
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 70235 then--Frozen
		self:Schedule(5, clearHeadGUID, args.destGUID)
		if fireBehind == 2 then
			timerCinderCD:Start(33)
		elseif fireBehind == 3 then
			timerCinderCD:Start(29)
		end
		if iceBehind == 2 then
			timerTorrentofIceCD:Start(35)
		elseif iceBehind == 3 then
			timerTorrentofIceCD:Start(31)
		end
	elseif cid == 70212 then--Flaming
		self:Schedule(5, clearHeadGUID, args.destGUID)
		if fireBehind == 2 then
			timerCinderCD:Start(36)
		elseif fireBehind == 3 then
			timerCinderCD:Start(31)
		end
		if iceBehind == 2 then
			timerTorrentofIceCD:Start(37)
		elseif iceBehind == 3 then
			timerTorrentofIceCD:Start(33)
		end
	elseif cid == 70247 then--Venomous
		self:Schedule(5, clearHeadGUID, args.destGUID)
		if fireBehind == 2 then
			timerCinderCD:Start(33)
		elseif fireBehind == 3 then
			timerCinderCD:Start(29)
		end
		if iceBehind == 2 then
			timerTorrentofIceCD:Start(37)
		elseif iceBehind == 3 then
			timerTorrentofIceCD:Start(33)
		end
	elseif cid == 70248 then--Arcane
		self:Schedule(5, clearHeadGUID, args.destGUID)
		if fireBehind == 2 then
			timerCinderCD:Start(33)
		elseif fireBehind == 3 then
			timerCinderCD:Start(29)
		end
		if iceBehind == 2 then
			timerTorrentofIceCD:Start(37)
		elseif iceBehind == 3 then
			timerTorrentofIceCD:Start(33)
		end
	end
end

--TODO, check for an aura method instead?
function mod:OnSync(msg, guid)
	if msg == "IceTarget" and guid then
		local target = DBM:GetFullPlayerNameByGUID(guid)
		warnTorrentofIce:Show(target)
		if self.Options.SetIconOnTorrentofIce then
			self:SetIcon(target, 6, 8)--do not have cleu, so use scheduler.
		end
	end
end
