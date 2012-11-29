local mod	= DBM:NewMod(745, "DBM-HeartofFear", nil, 330)
local L		= mod:GetLocalizedStrings()
local sndWOP	= mod:NewSound(nil, "SoundWOP", true)

mod:SetRevision(("$Revision: 8153 $"):sub(12, -3))
mod:SetCreatureID(62980)
mod:SetModelID(42807)
mod:SetZone()

mod:RegisterCombat("combat")
mod:RegisterKill("yell", L.Defeat)

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_AURA_REMOVED",
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"RAID_BOSS_EMOTE",
	"UNIT_SPELLCAST_SUCCEEDED"
)

--[[WoL Reg expression
(spellid = 123791 or spellid = 122713) and fulltype = SPELL_CAST_START or (spell = "Inhale" or spell = "Exhale") and (fulltype = SPELL_AURA_APPLIED or fulltype = SPELL_AURA_APPLIED_DOSE or fulltype = SPELL_AURA_REMOVED) or spellid = 127834 or spell = "Convert" or spellid = 124018
(spellid = 123791 or spellid = 122713 or spellid = 122740 or spellid = 127834) and fulltype = SPELL_CAST_START or spellid = 124018
--]]
--Notes: Currently, his phase 2 chi blast abiliteis are not detectable via traditional combat log. maybe with transcriptor.
local warnInhale			= mod:NewStackAnnounce(122852, 2)
local warnExhale			= mod:NewTargetAnnounce(122761, 3)
local warnForceandVerve		= mod:NewCastAnnounce(122713, 4, 4)
local warnAttenuation		= mod:NewSpellAnnounce(127834, 4)
local warnConvert			= mod:NewTargetAnnounce(122740, 4)

local specwarnPlatform		= mod:NewSpecialWarning("specwarnPlatform")
local specwarnForce			= mod:NewSpecialWarningSpell(122713)
local specwarnConvert		= mod:NewSpecialWarningSwitch(122740, not mod:IsHealer())
local specwarnExhale		= mod:NewSpecialWarning("specwarnExhale")
local specwarnExhaleB		= mod:NewSpecialWarning("specwarnExhaleB")
local specwarnAttenuation	= mod:NewSpecialWarningSpell(127834, nil, nil, nil, true)

local specwarnAttenuationL	= mod:NewSpecialWarning("specwarnAttenuationL")
local specwarnAttenuationR	= mod:NewSpecialWarning("specwarnAttenuationR")

local specwarnDR			= mod:NewSpecialWarning("specwarnDR")

--Timers aren't worth a crap, at all, this is a timerless fight and will probably stay that way unless blizz redesigns it.
--http://us.battle.net/wow/en/forum/topic/7004456927 for more info on lack of timers.
--local timerExhaleCD			= mod:NewCDTimer(41, 122761)
local timerExhale				= mod:NewTargetTimer(6, 122761)
--local timerForceCD			= mod:NewCDTimer(48, 122713)--Phase 1, every 41 seconds since exhale keeps resetting it, phase 2, 48 seconds or as wildly high as 76 seconds if exhale resets it late in it's natural CD
local timerForceCast			= mod:NewCastTimer(4, 122713)
local timerForce				= mod:NewBuffActiveTimer(12.5, 122713)
--local timerAttenuationCD		= mod:NewCDTimer(34, 127834)--34-41 second variations, when not triggered off exhale. It's ALWAYS 11 seconds after exhale.
local timerAttenuation			= mod:NewBuffActiveTimer(14, 127834)
--local timerConvertCD			= mod:NewCDTimer(41, 122740)--totally don't know this CD, but it's probably 41 like other specials in phase 1.

local berserkTimer				= mod:NewBerserkTimer(660)

mod:AddBoolOption("MindControlIcon", true)
mod:AddBoolOption("ArrowOnAttenuation", true)

local MCTargets = {}
local MCIcon = 8
local platform = 0

local tqcount = 0
local qpcount = 0

local ptwo = false


mod:AddBoolOption("HudMAP", true, "sound")
mod:AddBoolOption("HudMAP2", true, "sound")
local DBMHudMap = DBMHudMap
local free = DBMHudMap.free
local function register(e)	
	DBMHudMap:RegisterEncounterMarker(e)
	return e
end
local ExhaleMarkers = {}
local MindControlMarkers = {}

mod:AddDropdownOption("optarrowRTI", {"none", "arrow1", "arrow2", "arrow3", "arrow4", "arrow5", "arrow6", "arrow7"}, "none", "sound")

mod:AddDropdownOption("optDR", {"noDR", "DR1", "DR2", "DR3", "DR4", "DR5"}, "noDR", "sound")
mod:AddDropdownOption("optDRT", {"noDRT", "DRT1", "DRT2", "DRT3", "DRT4", "DRT5"}, "noDRT", "sound")

local function showMCWarning()
	warnConvert:Show(table.concat(MCTargets, "<, >"))
	table.wipe(MCTargets)
	MCIcon = 8
end

local function ArrowRTI(rindex)
    for i = 1, GetNumGroupMembers() do
        if GetRaidTargetIndex(UnitName("raid"..i)) == rindex then
			HudMap:AddEdge(1, 1, 1, 1, 10, "player", UnitName("raid"..i))
			break
		end
	end
end

function mod:OnCombatStart(delay)
	platform = 0
	qpcount = 0
	ptwo = false
	table.wipe(MCTargets)
	berserkTimer:Start(-delay)
	table.wipe(ExhaleMarkers)
	table.wipe(MindControlMarkers)
end

function mod:OnCombatEnd()
	if self.Options.HudMAP or self.Options.HudMAP2 then
		DBMHudMap:FreeEncounterMarkers()
	end
	if self.Options.ArrowOnAttenuation then
		DBM.Arrow:Hide()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(122852) then
		warnInhale:Show(args.destName, args.amount or 1)
		tqcount = args.amount or 1
	elseif args:IsSpellID(122761) then
		warnExhale:Show(args.destName)
		specwarnExhale:Show(tqcount, args.destName)
		timerExhale:Start(args.destName)
		if args.destName == UnitName("player") then
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\targetyou.mp3") --目標是你
		end
		if self.Options.HudMAP then
			local spelltext = GetSpellInfo(122761).." - "..args.destName
			ExhaleMarkers[args.destName] = register(DBMHudMap:PlaceRangeMarkerOnPartyMember("targeting", args.destName, 3, 6, 1, 0, 0, 1):SetLabel(spelltext))
		end
	elseif args:IsSpellID(122740) then
		MCTargets[#MCTargets + 1] = args.destName
		if self.Options.MindControlIcon then
			self:SetIcon(args.destName, MCIcon)
			MCIcon = MCIcon - 1
		end
		self:Unschedule(showMCWarning)
		self:Schedule(0.9, showMCWarning)
		if self.Options.HudMAP2 then
			local spelltext2 = args.destName
			MindControlMarkers[args.destName] = register(DBMHudMap:PlaceRangeMarkerOnPartyMember("targeting", args.destName, 3, nil, 1, 0, 0, 1):SetLabel(spelltext2))
		end
		if self:AntiSpam(2, 2) then
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\findmc.mp3") --注意心控
		end
	--"<112.7 21:19:19> [CLEU] SPELL_CAST_START#false#0xF150F60400001A34#Imperial Vizier Zor'lok#68168#0#0x0000000000000000#nil#-2147483648#-2147483648#127834#Attenuation#0", -- [30640] --First ID is universal spell cast start spellid
	--"<114.3 21:19:21> [CLEU] SPELL_AURA_APPLIED#false#0xF130F8420000203A#Imperial Vizier Zor'lok#2632#0#0xF130F8420000203A#Imperial Vizier Zor'lok#2632#0#122474#Attenuation#0#BUFF", -- [30914] --Second ID is direction (one of two buffs he gets, he also gets a buff from cast ID)
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(122761) then
		timerExhale:Cancel(args.destName)
		if ExhaleMarkers[args.destName] then
			ExhaleMarkers[args.destName] = free(ExhaleMarkers[args.destName])
		end
	elseif args:IsSpellID(122740) then
		if self.Options.MindControlIcon then
			self:SetIcon(args.destName, 0)
		end
		if MindControlMarkers[args.destName] then
			MindControlMarkers[args.destName] = free(MindControlMarkers[args.destName])
		end
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(127834) then
--		warnAttenuation:Show()
--		specwarnAttenuation:Show()
		timerAttenuation:Start()
--		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_ybzb.mp3") --音波準備
	elseif args:IsSpellID(122713) then
		warnForceandVerve:Show()
		specwarnForce:Show()
		if mod:IsHealer() then
			sndWOP:Schedule(2, "Interface\\AddOns\\DBM-Core\\extrasounds\\healall.mp3") --注意群療
		end
		timerForce:Start()		
		if self.Options.optarrowRTI == "arrow1" then
			ArrowRTI(1)
		elseif self.Options.optarrowRTI == "arrow2" then
			ArrowRTI(2)
		elseif self.Options.optarrowRTI == "arrow3" then
			ArrowRTI(3)
		elseif self.Options.optarrowRTI == "arrow4" then
			ArrowRTI(4)
		elseif self.Options.optarrowRTI == "arrow5" then
			ArrowRTI(5)
		elseif self.Options.optarrowRTI == "arrow6" then
			ArrowRTI(6)
		elseif self.Options.optarrowRTI == "arrow7" then
			ArrowRTI(7)
		end
	elseif args:IsSpellID(122761) and self:AntiSpam(2, 1) then
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_tqzb.mp3") --吐氣準備
		specwarnExhaleB:Show(tqcount)
--[[	elseif args:IsSpellID(123791) and recentPlatformChange then--No one is in melee range of boss, he's aoeing. (i.e., he's arrived at new platform)
		recentPlatformChange = false--we want to ignore when this happens as a result of players doing fight wrong. Only interested in platform changes.--]]
	elseif args:IsSpellID(122474, 122496, 123721, 122513) then
		if self.Options.ArrowOnAttenuation then
			DBM.Arrow:ShowStatic(90, 9)
		end
		specwarnAttenuationL:Show()
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_zzyb.mp3") --左轉音波
	elseif args:IsSpellID(122479, 122497, 123722, 122514) then
		if self.Options.ArrowOnAttenuation then
			DBM.Arrow:ShowStatic(270, 9)
		end
		specwarnAttenuationR:Show()
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_yzyb.mp3") --右轉音波
	end
end


function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(124018) then
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ptwo.mp3") --P2
		ptwo = true
		qpcount = 0
	end
end

function mod:RAID_BOSS_EMOTE(msg)
	if msg == L.Platform or msg:find(L.Platform) then
		platform = platform + 1
		specwarnPlatform:Show()
		if platform < 4 then
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\justrun.mp3") --快跑
		end
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, _, _, spellId)
	if spellId == 122933 and self:AntiSpam(2, 1) then--Clear Throat (4 seconds before force and verve)
		warnForceandVerve:Show()
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_dyq.mp3") --快進定音區
		timerForceCast:Start()
		qpcount = qpcount + 1
		if (((self.Options.optDR == "DR1" and qpcount == 1) or (self.Options.optDR == "DR2" and qpcount == 2) or (self.Options.optDR == "DR3" and qpcount == 3) or (self.Options.optDR == "DR4" and qpcount == 4) or (self.Options.optDR == "DR5" and qpcount == 5)) and not ptwo) or (((self.Options.optDRT == "DRT1" and qpcount == 1) or (self.Options.optDRT == "DRT2" and qpcount == 2) or (self.Options.optDRT == "DRT3" and qpcount == 3) or (self.Options.optDRT == "DRT4" and qpcount == 4) or (self.Options.optDRT == "DRT5" and qpcount == 5)) and ptwo) then
			sndWOP:Schedule(3, "Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_zyjs.mp3") --注意減傷
			specwarnDR:Schedule(3)
		end
	end
end
