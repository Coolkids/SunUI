local mod	= DBM:NewMod(745, "DBM-HeartofFear", nil, 330)
local L		= mod:GetLocalizedStrings()
local sndWOP	= mod:NewSound(nil, "SoundWOP", true)

mod:SetRevision(("$Revision: 7656 $"):sub(12, -3))
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
--	"SPELL_CAST_SUCCESS",
	"RAID_BOSS_EMOTE"
)

--[[WoL Reg expression
(spellid = 123791 or spellid = 122713) and fulltype = SPELL_CAST_START or (spell = "Inhale" or spell = "Exhale") and (fulltype = SPELL_AURA_APPLIED or fulltype = SPELL_AURA_APPLIED_DOSE or fulltype = SPELL_AURA_REMOVED) or spellid = 127834 or spell = "Convert" or spellid = 124018
--]]
--Notes: Currently, his phase 2 chi blast abiliteis are not detectable via traditional combat log. maybe with transcriptor.
local warnInhale			= mod:NewStackAnnounce(122852, 2)
local warnExhale			= mod:NewTargetAnnounce(122761, 3)
local warnForceandVerve		= mod:NewSpellAnnounce(122713, 4)
local warnAttenuation		= mod:NewSpellAnnounce(127834, 4)
local warnConvert			= mod:NewTargetAnnounce(122740, 4)

local specwarnPlatform		= mod:NewSpecialWarning("specwarnPlatform")
local specwarnForce			= mod:NewSpecialWarningSpell(122713)
local specwarnConvert		= mod:NewSpecialWarningSwitch(122740, not mod:IsHealer())
local specwarnExhale		= mod:NewSpecialWarningTarget(122761, mod:IsHealer() or mod:IsTank())
local specwarnAttenuation	= mod:NewSpecialWarningSpell(127834, nil, nil, nil, true)

--Timers aren't worth a crap, at all, this is a timerless fight and will probably stay that way unless blizz redesigns it.
--local timerExhaleCD			= mod:NewCDTimer(41, 122761)
local timerExhale				= mod:NewTargetTimer(6, 122761)
--local timerForceCD			= mod:NewCDTimer(48, 122713)--Phase 1, every 41 seconds since exhale keeps resetting it, phase 2, 48 seconds or as wildly high as 76 seconds if exhale resets it late in it's natural CD
local timerForce				= mod:NewBuffActiveTimer(12.5, 122713)
--local timerAttenuationCD		= mod:NewCDTimer(34, 127834)--34-41 second variations, when not triggered off exhale. It's ALWAYS 11 seconds after exhale.
local timerAttenuation			= mod:NewBuffActiveTimer(14, 127834)
--local timerConvertCD			= mod:NewCDTimer(41, 122740)--totally don't know this CD, but it's probably 41 like other specials in phase 1.

mod:AddBoolOption("MindControlIcon", true)

local MCTargets = {}
local MCIcon = 8
--local recentPlatformChange = false
--local platform = 0

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

local function showMCWarning()
	warnConvert:Show(table.concat(MCTargets, "<, >"))
	table.wipe(MCTargets)
	MCIcon = 8
	sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\findmc.mp3") --注意心控
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
--	recentPlatformChange = false
--	platform = 0
	table.wipe(MCTargets)
	table.wipe(ExhaleMarkers)
	table.wipe(MindControlMarkers)
end

function mod:OnCombatEnd()
	if self.Options.HudMAP or self.Options.HudMAP2 then
		DBMHudMap:FreeEncounterMarkers()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(122852) then
		warnInhale:Show(args.destName, args.amount or 1)
	elseif args:IsSpellID(122761) then
		warnExhale:Show(args.destName)
		specwarnExhale:Show(args.destName)
		timerExhale:Start(args.destName)
		if args.destName == UnitName("player") then
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\targetyou.mp3") --目標是你
		end
		if self.Options.HudMAP then
			local spelltext = GetSpellInfo(122761)
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
			local spelltext2 = GetSpellInfo(122740)
			MindControlMarkers[args.destName] = register(DBMHudMap:PlaceRangeMarkerOnPartyMember("targeting", args.destName, 3, nil, 1, 0, 0, 1):SetLabel(spelltext2))
		end
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
		warnAttenuation:Show()
		specwarnAttenuation:Show()
		timerAttenuation:Start()
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_ybzb.mp3") --音波準備
	elseif args:IsSpellID(122713) then
		warnForceandVerve:Show()
		specwarnForce:Show()
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_dyq.mp3") --快進定音區
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
--[[	elseif args:IsSpellID(123791) and recentPlatformChange then--No one is in melee range of boss, he's aoeing. (i.e., he's arrived at new platform)
		recentPlatformChange = false--we want to ignore when this happens as a result of players doing fight wrong. Only interested in platform changes.--]]
	end
end

--[[
function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(124018) then
		platform = 4--He moved to middle, it's phase 2, although platform "4" is better then adding an extra variable.
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ptwo.mp3") --P2
	end
end--]]

function mod:RAID_BOSS_EMOTE(msg)
	if msg == L.Platform or msg:find(L.Platform) then
		specwarnPlatform:Show()
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\justrun.mp3") --快跑
--		platform = platform + 1
--		recentPlatformChange = true
	end
end
