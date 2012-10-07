local mod	= DBM:NewMod(741, "DBM-HeartofFear", nil, 330)
local L		= mod:GetLocalizedStrings()
local sndWOP	= mod:NewSound(nil, "SoundWOP", true)
local LibRange = LibStub("LibRangeCheck-2.0")

mod:SetRevision(("$Revision: 7834 $"):sub(12, -3))
mod:SetCreatureID(62397)
mod:SetModelID(42645)
mod:SetZone()
mod:SetUsedIcons(1, 2)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_REFRESH",
	"SPELL_AURA_REMOVED",
	"SPELL_CAST_START",
	"RAID_BOSS_EMOTE",
	"UNIT_DIED",
	"UNIT_SPELLCAST_SUCCEEDED",
	"SPELL_DAMAGE",
	"SPELL_MISSED"
)
local isDispeller = select(2, UnitClass("player")) == "MAGE"
	    		 or select(2, UnitClass("player")) == "PRIEST"
	    		 or select(2, UnitClass("player")) == "SHAMAN" 
local warnRainOfBlades					= mod:NewSpellAnnounce(122406, 4)
local warnRecklessness					= mod:NewTargetAnnounce(125873, 3)
local warnImpalingSpear					= mod:NewPreWarnAnnounce(122224, 5, 3)--Pre warn your CC is about to break. Maybe need to localize it later to better explain what option is for.
local warnAmberPrison					= mod:NewTargetAnnounce(121881, 3)
local warnCorrosiveResin				= mod:NewTargetAnnounce(122064, 3)
local warnMending						= mod:NewCastAnnounce(122193, 4)
local warnQuickening					= mod:NewCastAnnounce(122149, 4)
local warnKorthikStrike					= mod:NewSpellAnnounce(123963, 3)--Target scanning does NOT work

local specWarnWhirlingBlade				= mod:NewSpecialWarningSpell(121896, nil, nil, nil, true)
local specWarnWindBomb					= mod:NewSpecialWarningSpell(131813)
local specWarnRainOfBlades				= mod:NewSpecialWarningSpell(122406, nil, nil, nil, true)
local specWarnRecklessness				= mod:NewSpecialWarningTarget(125873)
local specWarnReinforcements			= mod:NewSpecialWarningSpell("ej6554", mod:IsTank())
local specWarnAmberPrison				= mod:NewSpecialWarningYou(121881)
local yellAmberPrison					= mod:NewYell(121881)
local specWarnAmberPrisonOther			= mod:NewSpecialWarningSpell(121881, false)--Only people who are freeing these need to know this.
local specWarnCorrosiveResin			= mod:NewSpecialWarningRun(122064)
local yellCorrosiveResin				= mod:NewYell(122064)
local specWarnCorrosiveResinPool		= mod:NewSpecialWarningMove(122125)
local specWarnMending					= mod:NewSpecialWarningInterrupt(122193, false)--Whoever is doing this or feels responsible should turn it on.
local specWarnQuickening				= mod:NewSpecialWarningSpell(122149, false)--^^
local specWarnQuickeningDispel			= mod:NewSpecialWarningSpell(122149, isDispeller)
local specWarnKorthikStrike				= mod:NewSpecialWarningSpell(123963, nil, nil, nil, true)--Depends on if target scanning works, otherwise, tanks going to get a lot of wrong spam, :)

local timerWhirlingBladeCD				= mod:NewNextTimer(45.5, 121896)
local timerRainOfBladesCD				= mod:NewNextTimer(61.5, 122406)--60 CD, but Cd starts when last cast ends, IE 60+cast time. Starting cd off cast start is 61.5, but on pull it's 60.0
local timerRecklessness					= mod:NewBuffActiveTimer(30, 125873)
local timerReinforcementsCD				= mod:NewNextCountTimer(50, "ej6554")--EJ says it's 45 seconds after adds die but it's actually 50 in logs. EJ is not updated for current tuning.
local timerImpalingSpear				= mod:NewTargetTimer(50, 122224)--Filtered to only show your own target, may change to a popup option later that lets you pick whether you show ALL of them or your own (all will be spammy)
local timerAmberPrisonCD				= mod:NewNextTimer(36, 121876)--each add has their own CD. This is on by default since it concerns everyone.
local timerCorrosiveResinCD				= mod:NewNextTimer(36, 122064)--^^
local timerMendingCD					= mod:NewNextTimer(36, 122193, nil, false)--To reduce bar spam, only those dealing with this should turn CD bar on, off by default
local timerQuickeningCD					= mod:NewNextTimer(36, 122149, nil, false)--^^
local timerKorthikStrikeCD				= mod:NewCDTimer(40.5, 123963)--^^

local berserkTimer						= mod:NewBerserkTimer(480)

mod:AddBoolOption("SoundDQ", mod:IsDps() and isDispeller, "sound")
mod:AddBoolOption("AmberPrisonIcons", true)
mod:AddBoolOption("NearAP", true, "sound")
mod:AddBoolOption("ReapetAP", true, "sound")

local apnear = 20
local addsCount = 0
local amberPrisonIcon = 2
local amberPrisonTargets = {}
local ptwo = false

mod:AddBoolOption("HudMAP", true, "sound")
local DBMHudMap = DBMHudMap
local free = DBMHudMap.free
local function register(e)	
	DBMHudMap:RegisterEncounterMarker(e)
	return e
end
local AmberPrisonMarkerscast = {}
local AmberPrisonMarkers = {}

local function warnAmberPrisonTargets()
	warnAmberPrison:Show(table.concat(amberPrisonTargets, "<, >"))
	table.wipe(amberPrisonTargets)
end

local function isTank(unit)
	-- 1. check blizzard tanks first
	-- 2. check blizzard roles second
	if GetPartyAssignment("MAINTANK", unit, 1) then
		return true
	end
	if UnitGroupRolesAssigned(unit) == "TANK" then
		return true
	end
	return false
end

function mod:checkdebuff()
    if UnitDebuff("player", GetSpellInfo(121885)) then
		SendChatMessage(L.Helpme, "SAY")
        self:ScheduleMethod(4, "checkdebuff")
	end
end

function mod:OnCombatStart(delay)
	addsCount = 0
	amberPrisonIcon = 2
	ptwo = false
	table.wipe(amberPrisonTargets)
	timerWhirlingBladeCD:Start(35.5-delay)
	timerRainOfBladesCD:Start(60-delay)
	berserkTimer:Start(-delay)
	if mod:IsHealer() then
		sndWOP:Schedule(57, "Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
		sndWOP:Schedule(58, "Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
		sndWOP:Schedule(59, "Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
	end
	table.wipe(AmberPrisonMarkerscast)
	table.wipe(AmberPrisonMarkers)
end

function mod:OnCombatEnd()
	if self.Options.HudMAP then
		DBMHudMap:FreeEncounterMarkers()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(122224) and args.sourceName == UnitName("player") then
		warnImpalingSpear:Schedule(45)
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_kzjs.mp3")
		sndWOP:Schedule(45, "Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_kzjs.mp3") --控制即將結束	
		timerImpalingSpear:Start(args.destName)
	elseif args:IsSpellID(121881) then--Not a mistake, 121881 is targeting spellid.
		amberPrisonTargets[#amberPrisonTargets + 1] = args.destName
		if self.Options.HudMAP then
			AmberPrisonMarkerscast[args.destName] = register(DBMHudMap:PlaceRangeMarkerOnPartyMember("timer", args.destName, 3, 3, 1, 1, 1, 1):Appear():RegisterForAlerts():Rotate(360, 3))
		end
		if args:IsPlayer() then
			specWarnAmberPrison:Show()
			yellAmberPrison:Yell()
			if self.Options.ReapetAP then
				self:ScheduleMethod(5, "checkdebuff")
			end
			if not self:IsDifficulty("lfr25") then
				sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\runout.mp3") --離開人群
				DBM.RangeCheck:Show(3)
				self:Schedule(5, function()
					DBM.RangeCheck:Hide()
				end)
			end
		else
			self:Unschedule(warnAmberPrisonTargets)
			self:Schedule(0.3, warnAmberPrisonTargets)
			specWarnAmberPrisonOther:Show()
			local uId = DBM:GetRaidUnitId(args.destName)
			if uId then
				local x, y = GetPlayerMapPosition(uId)
				if x == 0 and y == 0 then
					SetMapToCurrentZone()
					x, y = GetPlayerMapPosition(uId)
				end
				local inRange = DBM.RangeCheck:GetDistance("player", x, y)
				apnear = self.Options.NearAP and 20 or 200
				if inRange and inRange < apnear then
					if not UnitDebuff("player", GetSpellInfo(122055)) then
						if math.random(1, 2) == 1 then
							sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\helpme.mp3") --救我
						else
							sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\helpme2.mp3")
						end
					end
				end
			end
		end
		if self.Options.AmberPrisonIcons then
			self:SetIcon(args.destName, amberPrisonIcon)
			if amberPrisonIcon == 2 then
				amberPrisonIcon = 1
			else
				amberPrisonIcon = 2
			end
		end
	elseif args:IsSpellID(122064) then
		warnCorrosiveResin:Show(args.destName)
		if args:IsPlayer() then
			specWarnCorrosiveResin:Show()
			yellCorrosiveResin:Yell()
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\keepmove.mp3")--保持移動
		end
	elseif args:IsSpellID(122125) and args:IsPlayer() then
		specWarnCorrosiveResinPool:Show()
	elseif args:IsSpellID(125873) then
		addsCount = addsCount + 1
		warnRecklessness:Show(args.destName)
		specWarnRecklessness:Show(args.destName)
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_lumang.mp3") --魯莽
		timerRecklessness:Start()
		timerReinforcementsCD:Start(50, addsCount)--We count them cause some groups may elect to kill a 2nd group of adds and start a second bar to form before first ends.
	elseif args:IsSpellID(122149) and self:AntiSpam(1, 5) then
		if isDispeller and self.Options.SoundDQ then
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\dispelnow.mp3") --快驅散
			specWarnQuickeningDispel:Show()
		end
	elseif args:IsSpellID(121885) then
		if self.Options.HudMAP then
			local spelltext = GetSpellInfo(121885)
			AmberPrisonMarkers[args.destName] = register(DBMHudMap:PlaceRangeMarkerOnPartyMember("targeting", args.destName, 3, nil, 1, 0, 0, 1):SetLabel(spelltext))
		end
	end
end
mod.SPELL_AURA_REFRESH = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(122224) and args.sourceName == UnitName("player") then
		warnImpalingSpear:Cancel()
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_kzjs.mp3")
		timerImpalingSpear:Cancel(args.destName)
	elseif args:IsSpellID(121885) and self.Options.AmberPrisonIcons then--Not a mistake, 121885 is frozon spellid
		self:SetIcon(args.destName, 0)
		if AmberPrisonMarkers[args.destName] then
			AmberPrisonMarkers[args.destName] = free(AmberPrisonMarkers[args.destName])
		end
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(122406) then
		warnRainOfBlades:Show()
		specWarnRainOfBlades:Show()
		if mod:IsHealer() then
			if not ptwo then
				timerRainOfBladesCD:Start()
				sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
				sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
				sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
				sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\healall.mp3") --注意群療
				sndWOP:Schedule(58, "Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
				sndWOP:Schedule(59, "Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
				sndWOP:Schedule(60, "Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
			else
				timerRainOfBladesCD:Start(49)
				sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
				sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
				sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
				sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\healall.mp3") --注意群療
				sndWOP:Schedule(46, "Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
				sndWOP:Schedule(47, "Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
				sndWOP:Schedule(48, "Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
			end
		else
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\aesoon.mp3")
		end
	elseif args:IsSpellID(121876) then
		timerAmberPrisonCD:Start(36, args.sourceGUID)
	elseif args:IsSpellID(122064) then
		timerCorrosiveResinCD:Start(36, args.sourceGUID)
	elseif args:IsSpellID(122193) then
		warnMending:Show()
		specWarnMending:Show(args.sourceName)
		timerMendingCD:Start(36, args.sourceGUID)
		if (args.sourceGUID == UnitGUID("target")) or (args.sourceGUID == UnitGUID("focus")) then
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\kickcast.mp3")--快打斷
		end
	elseif args:IsSpellID(122149) then
		warnQuickening:Show()
		specWarnQuickening:Show(args.sourceName)
		timerQuickeningCD:Start(36, args.sourceGUID)
	end
end


function mod:RAID_BOSS_EMOTE(msg)
	if msg == L.Reinforcements or msg:find(L.Reinforcements) then
		specWarnReinforcements:Show()
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_xcqcx.mp3") --新蟲群出現
	end
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 62405 then--Sra'thik Amber-Trapper
		timerAmberPrisonCD:Cancel(args.destGUID)
		timerCorrosiveResinCD:Cancel(args.destGUID)
	elseif cid == 62408 then--Zar'thik Battle-Mender
		timerMendingCD:Cancel(args.destGUID)
		timerQuickeningCD:Cancel(args.destGUID)
	elseif cid == 62402 then--The Kor'thik
		timerKorthikStrikeCD:Cancel()--No need for GUID cancelation, this ability seems to be off a timed trigger and they all do it together, unlike other mob sets.
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, _, _, spellId)
	if spellId == 124850 and self:AntiSpam(2, 1) then--Whirling Blade (Throw Cast spellid)
		specWarnWhirlingBlade:Show()
		timerWhirlingBladeCD:Start()
--	"<173.1> [UNIT_SPELLCAST_SUCCEEDED] The Kor'thik [[boss4:Kor'thik Strike::0:123963]]", -- [10366]
--	"<175.6> [CLEU] SPELL_CAST_START#false#0xF130F3C200000FC8#Kor'thik Elite Blademaster#2632#0#0x0000000000000000#nil#-2147483648#-2147483648#122409#Kor'thik Strike#1", -- [10535]
--	"<175.6> [CLEU] SPELL_CAST_START#false#0xF130F3C200000FC7#Kor'thik Elite Blademaster#2632#8#0x0000000000000000#nil#-2147483648#-2147483648#122409#Kor'thik Strike#1", -- [10536]
	elseif spellId == 123963 and self:AntiSpam(2, 2) then--Kor'thik Strike Trigger, only triggered once, then all non CCed Kor'thik cast the strike about 2 sec later
		warnKorthikStrike:Show()
--		specWarnKorthikStrike:Show()
		timerKorthikStrikeCD:Start()
	elseif spellId == 131813 and self:AntiSpam(2, 3) then
		if not ptwo then
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ptwo.mp3")--P2
			specWarnWindBomb:Show()
		end
		ptwo = true
	end
end

function mod:SPELL_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 122125 and destGUID == UnitGUID("player") and self:AntiSpam(3, 4) then
		specWarnCorrosiveResinPool:Show()
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\runaway.mp3")--快躲開
	end
end
mod.SPELL_MISSED = mod.SPELL_DAMAGE