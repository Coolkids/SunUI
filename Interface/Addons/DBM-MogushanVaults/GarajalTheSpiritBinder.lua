local mod	= DBM:NewMod(682, "DBM-MogushanVaults", nil, 317)
local L		= mod:GetLocalizedStrings()
local sndWOP	= mod:NewSound(nil, "SoundWOP", true)
local sndTT		= mod:NewSound(nil, "SoundTT", false)

mod:SetRevision(("$Revision: 7955 $"):sub(12, -3))
mod:SetCreatureID(60143)
mod:SetModelID(41256)
mod:SetZone()
mod:SetUsedIcons(5, 6, 7, 8)
mod:SetMinSyncRevision(7751)

-- Sometimes it fails combat detection on "combat". Use yell instead until the problem being founded.
--I'd REALLY like to see some transcriptor logs that prove your bug, i pulled this boss like 20 times, on 25 man, 100% functional engage trigger, not once did this mod fail to start, on 25 man or 10 man.
--seems that combat detection fails only in lfr. (like DS Zonozz Void of Unmaking summon event.)
--"<102.8> [INSTANCE_ENCOUNTER_ENGAGE_UNIT] Fake Args:#1#1#Gara'jal the Spiritbinder#0xF150EAEF00000F5A#elit
--"<103.1> [CHAT_MSG_MONSTER_YELL] CHAT_MSG_MONSTER_YELL#It be dyin' time, now!#Gara'jal the Spiritbinder#####0#0##0#862##0#false#false", -- [291]
mod:RegisterCombat("yell", L.Pull)

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_REMOVED",
	"SPELL_CAST_SUCCESS",
	"UNIT_HEALTH",
	"UNIT_SPELLCAST_SUCCEEDED"
)

--NOTES
--Syncing is used for all warnings because the realms don't share combat events. You won't get warnings for other realm any other way.
--Voodoo dolls do not have a CD, they are linked to banishment (or player deaths), when he banishes current tank, he reapplies voodoo dolls to new tank and new players. If tank dies, he just recasts voodoo on a new current threat target.
--Latency checks are used for good reason (to prevent lagging users from sending late events and making our warnings go off again incorrectly). if you play with high latency and want to bypass latency check, do so with in game GUI option.
local warnTotem						= mod:NewSpellAnnounce(116174, 2)
local warnVoodooDolls				= mod:NewTargetAnnounce(122151, 3)
local warnCrossedOver				= mod:NewTargetAnnounce(116161, 3)
local warnBanishment				= mod:NewTargetAnnounce(116272, 3)
local warnSuicide					= mod:NewPreWarnAnnounce(116325, 5, 4)--Pre warn 5 seconds before you die so you take whatever action you need to, to prevent. (this is effect that happens after 30 seconds of Soul Sever

local specWarnTotem					= mod:NewSpecialWarningSpell(116174, false)
local specWarnBanishment			= mod:NewSpecialWarningYou(116272)
local specWarnBanishmentOther		= mod:NewSpecialWarningTarget(116272, mod:IsTank())
local specWarnVoodooDolls			= mod:NewSpecialWarningSpell(122151, false)
local specWarnGD					= mod:NewSpecialWarningYou(122181)
local specWarnVoodooDollsMe			= mod:NewSpecialWarningYou(122151, false)

local timerTotemCD					= mod:NewNextTimer(36, 116174)
local timerBanishmentCD				= mod:NewNextTimer(65, 116272)
local timerSoulSever				= mod:NewBuffFadesTimer(30, 116278)--Tank version of spirit realm
local timerCrossedOver				= mod:NewBuffFadesTimer(30, 116161)--Dps version of spirit realm
local timerShadowyAttackCD			= mod:NewCDTimer(8, "ej6698", nil, nil, nil, 117222)

local prewarnedPhase2 = false
local warnPhase2Soon					= mod:NewPrePhaseAnnounce(2, 3)
local inTotem = false

--local countdownCrossedOver			= mod:NewCountdown(30, 116161)
local berserkTimer					= mod:NewBerserkTimer(360)

mod:AddBoolOption("SetIconOnVoodoo", true)

local voodooDollTargets = {}
local crossedOverTargets = {}
local voodooDollTargetIcons = {}
mod:AddBoolOption("InfoFrame", true, "sound")

local guids = {}
local voodooDollWarned = false
local guidTableBuilt = false--Entirely for DCs, so we don't need to reset between pulls cause it doesn't effect building table on combat start and after a DC then it will be reset to false always
local function buildGuidTable()
	table.wipe(guids)
	for i = 1, DBM:GetGroupMembers() do
		guids[UnitGUID("raid"..i) or "none"] = GetRaidRosterInfo(i)
	end
end

local function warnVoodooDollTargets()
	warnVoodooDolls:Show(table.concat(voodooDollTargets, "<, >"))
	if not voodooDollWarned then
		specWarnVoodooDolls:Show()
	end
	voodooDollWarned = false
	table.wipe(voodooDollTargets)
end

local function warnCrossedOverTargets()
	warnCrossedOver:Show(table.concat(crossedOverTargets, "<, >"))
	table.wipe(crossedOverTargets)
end

local function removeIcon(target)
	for i,j in ipairs(voodooDollTargetIcons) do
		if j == target then
			table.remove(voodooDollTargetIcons, i)
			mod:SetIcon(target, 0)
			break
		end
	end
end

--[[
local function ClearVoodooTargets()
	table.wipe(voodooDollTargetIcons)
end--]]

do
	local function sort_by_group(v1, v2)
		return DBM:GetRaidSubgroup(DBM:GetUnitFullName(v1)) < DBM:GetRaidSubgroup(DBM:GetUnitFullName(v2))
	end
	function mod:SetVoodooIcons()
		table.sort(voodooDollTargetIcons, sort_by_group)
		local voodooIcon = 8
		for i, v in ipairs(voodooDollTargetIcons) do
			-- DBM:SetIcon() is used because of follow reasons
			--1. It checks to make sure you're on latest dbm version, if you are not, it disables icon setting so you don't screw up icons (ie example, a newer version of mod does icons differently)
			--2. It checks global dbm option "DontSetIcons"
			self:SetIcon(v, voodooIcon)
			voodooIcon = voodooIcon - 1
		end
--		self:Schedule(1.5, ClearVoodooTargets)--Table wipe delay so if icons go out too early do to low fps or bad latency, when they get new target on table, resort and reapplying should auto correct teh icon within .2-.4 seconds at most.
	end
end

function mod:OnCombatStart(delay)
	voodooDollWarned = false
	buildGuidTable()
	table.wipe(voodooDollTargets)
	table.wipe(crossedOverTargets)
	table.wipe(voodooDollTargetIcons)
	timerShadowyAttackCD:Start(7-delay)
	timerTotemCD:Start(-delay)
	timerBanishmentCD:Start(-delay)
	prewarnedPhase2 = false
	inTotem = false
	if not self:IsDifficulty("lfr25") then -- lfr seems not berserks.
		berserkTimer:Start(-delay)
	end
end

function mod:OnCombatEnd()
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
end

function mod:SPELL_AURA_APPLIED(args)--We don't use spell cast success for actual debuff on >player< warnings since it has a chance to be resisted.
	if args:IsSpellID(122151) then
		if args:IsPlayer() and (not mod:IsTank()) then
			specWarnVoodooDollsMe:Show()
			voodooDollWarned = true
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_wwsn.mp3")--娃娃是你
		elseif mod:IsHealer() and self:AntiSpam(2, 3) then
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_wdww.mp3")--巫毒娃娃(外場治療)
		end
		if self:LatencyCheck() then
			self:SendSync("VoodooTargets", args.destGUID)
		end
	elseif args:IsSpellID(116161, 116160) then -- 116161 is normal and heroic, 116160 is lfr.
		if args:IsPlayer() then
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_kj.mp3")--跨界
			warnSuicide:Schedule(25)
--			countdownCrossedOver:Start(30)
			timerCrossedOver:Start(30)
			sndWOP:Schedule(23.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_jjsw.mp3")--即將死亡
			sndWOP:Schedule(25, "Interface\\AddOns\\DBM-Core\\extrasounds\\countfive.mp3")
			sndWOP:Schedule(26, "Interface\\AddOns\\DBM-Core\\extrasounds\\countfour.mp3")
			sndWOP:Schedule(27, "Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
			sndWOP:Schedule(28, "Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
			sndWOP:Schedule(29, "Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
		end
		if mod.Options.InfoFrame then
			DBM.InfoFrame:SetHeader(GetSpellInfo(116161))
			DBM.InfoFrame:Show(10, "playerbaddebuff", 116161)
		end
		if not self:IsDifficulty("lfr25") then -- lfr totems not breakable, instead totems can click. so lfr warns can be spam, not needed to warn. also CLEU fires all players, no need to use sync.
			crossedOverTargets[#crossedOverTargets + 1] = args.destName
			self:Unschedule(warnCrossedOverTargets)
			self:Schedule(0.3, warnCrossedOverTargets)		
		end
	elseif args:IsSpellID(116278) then--this is tank spell, no delays?
		if args:IsPlayer() then--no latency check for personal notice you aren't syncing.
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_kj.mp3")
			timerSoulSever:Start()
			warnSuicide:Schedule(25)
			sndWOP:Schedule(23.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_jjsw.mp3")
			sndWOP:Schedule(25, "Interface\\AddOns\\DBM-Core\\extrasounds\\countfive.mp3")
			sndWOP:Schedule(26, "Interface\\AddOns\\DBM-Core\\extrasounds\\countfour.mp3")
			sndWOP:Schedule(27, "Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
			sndWOP:Schedule(28, "Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
			sndWOP:Schedule(29, "Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
		end
	elseif args:IsSpellID(116260) then
		if args:IsPlayer() then
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_kj.mp3")
		end
		if mod.Options.InfoFrame then
			DBM.InfoFrame:SetHeader(GetSpellInfo(116260))
			DBM.InfoFrame:Show(10, "playerbaddebuff", 116260)
		end
	elseif args:IsSpellID(117752) then
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_kl.mp3") --狂亂	
	end
	--[[
	if UnitDebuff("player", GetSpellInfo(122181)) then
		if not inTotem then
			specWarnGD:Show()
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_jrgd.mp3") --進入管道
		end
		inTotem = true
	else
		inTotem = false
	end]]
end

function mod:SPELL_AURA_REMOVED(args)--We don't use spell cast success for actual debuff on >player< warnings since it has a chance to be resisted.
	if args:IsSpellID(116161, 116160) and args:IsPlayer() then
		warnSuicide:Cancel()
--		countdownCrossedOver:Cancel()
		timerCrossedOver:Cancel()	
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_kj.mp3")
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_jjsw.mp3")
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\countfive.mp3")
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\countfour.mp3")
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
	elseif args:IsSpellID(116278) and args:IsPlayer() then
		timerSoulSever:Cancel()
		warnSuicide:Cancel()
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_kj.mp3")
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_jjsw.mp3")
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\countfive.mp3")
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\countfour.mp3")
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
	elseif args:IsSpellID(122151) then
		self:SendSync("VoodooGoneTargets", args.destGUID)
	elseif args:IsSpellID(116260) then
		if args:IsPlayer() then
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_kj.mp3")
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(116174) then
		if self:LatencyCheck() then
			self:SendSync("SummonTotem")
		end
		sndTT:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_lhtt.mp3")--靈魂圖騰(外場)
	elseif args:IsSpellID(116272) then
		if args:IsPlayer() then--no latency check for personal notice you aren't syncing.
			specWarnBanishment:Show()
		elseif not mod:IsDps() then
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\changemt.mp3") --換坦嘲諷
		end
		if self:LatencyCheck() then
			self:SendSync("BanishmentTarget", args.destGUID)
		end
	end
end

function mod:OnSync(msg, guid)
	--Make sure we build a table if we DCed mid fight, before we try comparing any syncs to that table.
	if not guidTableBuilt then
		buildGuidTable()
		guidTableBuilt = true
	end
	if msg == "SummonTotem" then
		warnTotem:Show()
		specWarnTotem:Show()
		if self:IsDifficulty("lfr25") then
			timerTotemCD:Start(20.5)
		else
			timerTotemCD:Start()
		end
	elseif msg == "VoodooTargets" and guids[guid] then
		voodooDollTargets[#voodooDollTargets + 1] = guids[guid]
		self:Unschedule(warnVoodooDollTargets)
		self:Schedule(0.3, warnVoodooDollTargets)
		if self.Options.SetIconOnVoodoo then
			table.insert(voodooDollTargetIcons, DBM:GetRaidUnitId(guids[guid]))
			self:UnscheduleMethod("SetVoodooIcons")
			if self:LatencyCheck() then--lag can fail the icons so we check it before allowing.
				self:ScheduleMethod(1, "SetVoodooIcons")
			end
		end
	elseif msg == "VoodooGoneTargets" and guids[guid] and self.Options.SetIconOnVoodoo then
		removeIcon(DBM:GetRaidUnitId(guids[guid]))
	elseif msg == "BanishmentTarget" and guids[guid] then
		warnBanishment:Show(guids[guid])
		timerBanishmentCD:Start()
		if guid ~= UnitGUID("player") then--make sure YOU aren't target before warning "other"
			specWarnBanishmentOther:Show(guids[guid])
		end
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, _, _, spellId)
	if (spellId == 117215 or spellId == 117218 or spellId == 117219 or spellId == 117222) and self:AntiSpam(2, 1) then--Shadowy Attacks
		timerShadowyAttackCD:Start()
	elseif spellId == 116964 and self:AntiSpam(2, 2) then--Summon Totem
		if self:LatencyCheck() then
			self:SendSync("SummonTotem")
		end
	end
end

function mod:UNIT_HEALTH(uId)
	if self:GetUnitCreatureId(uId) == 60143 then
		local h = UnitHealth(uId) / UnitHealthMax(uId) * 100
		if h > 30 and prewarnedPhase2 then
			prewarnedPhase2 = false
		elseif h > 23 and h < 25 and not prewarnedPhase2 then
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ptwo.mp3") --2階段準備
			prewarnedPhase2 = true
			warnPhase2Soon:Show()
		end
	end
end