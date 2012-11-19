local mod	= DBM:NewMod(709, "DBM-TerraceofEndlessSpring", nil, 320)
local L		= mod:GetLocalizedStrings()
local sndWOP	= mod:NewSound(nil, "SoundWOP", true)
local sndDD	= mod:NewSound(nil, "SoundDD", mod:IsTank())

mod:SetRevision(("$Revision: 8113 $"):sub(12, -3))
mod:SetCreatureID(60999)--61042 Cheng Kang, 61046 Jinlun Kun, 61038 Yang Guoshi, 61034 Terror Spawn
mod:SetModelID(41772)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_CAST_START",
	"UNIT_SPELLCAST_SUCCEEDED",
	"UNIT_DIED"
)

local warnThrash						= mod:NewSpellAnnounce(131996, 4, nil, mod:IsTank() or mod:IsHealer())
local warnConjureTerrorSpawns			= mod:NewSpellAnnounce(119108, 3)
local warnBreathOfFearSoon				= mod:NewPreWarnAnnounce(119414, 10, 10)
local warnBreathOfFear					= mod:NewSpellAnnounce(119414, 3)
local warnOminousCackle					= mod:NewTargetAnnounce(129147, 4)--129147 is debuff, 119693 is cast. We do not reg warn cast cause we reg warn the actual targets instead. We special warn cast to give a little advanced heads up though.

local specWarnThrash					= mod:NewSpecialWarningSpell(131996, mod:IsTank())
local specWarnBreathOfFear				= mod:NewSpecialWarningSpell(119414, nil, nil, nil, true)
local specWarnOminousCackle				= mod:NewSpecialWarningSpell(119693, nil, nil, nil, true)--Cast, warns the entire raid.
local specWarnOminousCackleYou			= mod:NewSpecialWarningYou(129147)--You have debuff, just warns you.
local specWarnTerrorSpawn				= mod:NewSpecialWarningSwitch("ej6088",  mod:IsDps())
local specWarnDreadSpray				= mod:NewSpecialWarningSpell(120047, nil, nil, nil, true)--Platform ability, particularly nasty damage, and fear.
local specWarnDeathBlossom				= mod:NewSpecialWarningSpell(119888, nil, nil, nil, true)--Cast, warns the entire raid.
local specWarnShot						= mod:NewSpecialWarningStack(119086, true, 2)

local timerThrashCD						= mod:NewCDTimer(7, 131996, nil, mod:IsTank() or mod:IsHealer())--Every 7-12 seconds.
local timerBreathOfFearCD				= mod:NewNextTimer(33.3, 119414)--Based off bosses energy, he casts at 100 energy, and gains about 3 energy per second, so every 33-34 seconds is a breath.
local timerOminousCackleCD				= mod:NewNextTimer(55, 119693)
local timerDreadSpray					= mod:NewBuffActiveTimer(8, 120047)
local timerDreadSprayCD					= mod:NewNextTimer(20.5, 120047)
--local timerTerrorSpawnCD				= mod:NewNextTimer(60, 119108)--every 60 or so seconds, maybe a little more maybe a little less, not sure. this is just based on instinct after seeing where 30 fit.

local berserkTimer						= mod:NewBerserkTimer(900)

local ominousCackleTargets = {}
local platformGUIDs = {}
local onPlatform = false--Used to determine when YOU are sent to a platform, so we know to activate platformMob on next shoot
local platformMob = nil--Use this so we can filter platform events and show you only ones for YOUR platform while ignoring other platforms events.

local function warnOminousCackleTargets()
	warnOminousCackle:Show(table.concat(ominousCackleTargets, "<, >"))
	table.wipe(ominousCackleTargets)
end

function mod:OnCombatStart(delay)
	warnBreathOfFearSoon:Schedule(23.4-delay)
	if self:IsDifficulty("lfr25") then
		timerOminousCackleCD:Start(40-delay)
	else
		timerOminousCackleCD:Start(25.5-delay)
	end
--	timerTerrorSpawnCD:Start(25.5-delay)--still not perfect, it's hard to do yells when you're always the tank sent out of range of them. I need someone else to do /yell when they spawn and give me timing
--	self:ScheduleMethod(25.5-delay, "TerrorSpawns")
	timerBreathOfFearCD:Start(-delay)
	onPlatform = false
	platformMob = nil
	table.wipe(ominousCackleTargets)
	table.wipe(platformGUIDs)
	berserkTimer:Start(-delay)
	self:Schedule(23.4, function()
		if not onPlatform then
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_tenkj.mp3") --10秒後恐懼之息
			if not mod:IsTank() then
				sndWOP:Schedule(5.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\countfive.mp3")
				sndWOP:Schedule(6.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\countfour.mp3")
				sndWOP:Schedule(7.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
				sndWOP:Schedule(8.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
				sndWOP:Schedule(9.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
			end
		end
	end)
end

--This may now be depricated, i think blizz synced these up to omninous cackle.
--[[function mod:TerrorSpawns()
	if self:IsInCombat() then
		timerTerrorSpawnCD:Start()
		self:UnscheduleMethod("TerrorSpawns")
		self:ScheduleMethod(60, "TerrorSpawns")
	end
end--]]

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(119414) and self:AntiSpam(5, 1) then--using this with antispam is still better then registering SPELL_CAST_SUCCESS for a single event when we don't have to. Less cpu cause mod won't have to check every SPELL_CAST_SUCCESS event.
		warnBreathOfFear:Show()
		if not onPlatform then--not in middle, not your problem
			specWarnBreathOfFear:Show()
			timerBreathOfFearCD:Start()
		end
		warnBreathOfFearSoon:Schedule(23.4)
		self:Schedule(23.4, function()
			if not onPlatform then
				sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_tenkj.mp3") --10秒後恐懼之息
				if not mod:IsTank() then
					sndWOP:Schedule(5.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\countfive.mp3")
					sndWOP:Schedule(6.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\countfour.mp3")
					sndWOP:Schedule(7.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
					sndWOP:Schedule(8.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
					sndWOP:Schedule(9.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
				end
			end
		end)
	elseif args:IsSpellID(129147) then
		ominousCackleTargets[#ominousCackleTargets + 1] = args.destName
		if args:IsPlayer() then
			onPlatform = true
			specWarnOminousCackleYou:Show()
			timerBreathOfFearCD:Cancel()
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\telesoon.mp3")--準備傳送
		elseif (not mod:IsDps()) and (not onPlatform) and self:AntiSpam(2, 4) then
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\changemt.mp3")--換坦嘲諷
		end
		self:Unschedule(warnOminousCackleTargets)
		self:Schedule(2, warnOminousCackleTargets)--this actually staggers a bit, so wait the full 2 seconds to get em all in one table
		--"<76.6> [CLEU] SPELL_AURA_APPLIED#false#0x0100000000181B61#Lycanx#1298#0#0x0100000000181B61#Lycanx#1298#0#129147#Ominous Cackle#32#DEBUFF", -- [12143]
		--"<78.3> [CLEU] SPELL_AURA_APPLIED#false#0x0100000000011E0F#Derevka#1300#0#0x0100000000011E0F#Derevka#1300#0#129147#Ominous Cackle#32#DEBUFF", -- [12440]
	elseif args:IsSpellID(120047) and platformMob and args.sourceName == platformMob  then--might change
		timerDreadSpray:Start()
		timerDreadSprayCD:Start()
		if mod:IsHealer() then
			sndWOP:Schedule(19, "Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_kbpszb.mp3")--恐怖噴散準備
		end
	elseif args:IsSpellID(118977) and args:IsPlayer() then--Fearless, you're leaving platform
		onPlatform = false
		platformMob = nil
	elseif args:IsSpellID(131996) and not onPlatform then
		warnThrash:Show()
		specWarnThrash:Show()
		if not mod:IsDps() then
			sndDD:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\doubleat.mp3")--雙重攻擊
		end
		timerThrashCD:Start()
	elseif args:IsSpellID(119086) then
		if args:IsPlayer() and (args.amount or 1) >= 2 and self:AntiSpam(3, 2) then
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\firecircle.mp3")--注意火圈
			specWarnShot:Show(args.amount)
		end
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(120047) then
		timerDreadSpray:Cancel(args.sourceGUID)
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(119593, 119692, 119693) then--This seems to have multiple spellids, depending on which platform he's going to send you to. TODO, figure out which is which platform and add additional warnings
		specWarnOminousCackle:Show()
		if self:IsDifficulty("lfr25") then
			timerOminousCackleCD:Start(90)--Far less often on LFR
		else
			timerOminousCackleCD:Start()
		end
	elseif args:IsSpellID(119862) and onPlatform and not platformGUIDs[args.sourceGUID] then--Best way to track engaging one of the side adds, they cast this instantly.
		platformGUIDs[args.sourceGUID] = true
		platformMob = args.sourceName--Get name of your platform mob so we can determine which mob you have engaged
		timerDreadSprayCD:Start(10.5, args.sourceGUID)--We can accurately start perfectly accurate spray cd bar off their first shoot cast.
		if mod:IsHealer() then
			sndWOP:Schedule(9, "Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_kbpszb.mp3")--恐怖噴散準備
		end
	elseif args:IsSpellID(119888) and platformMob and args.sourceName == platformMob then
		specWarnDeathBlossom:Show()
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_jykd.mp3") --劍雨快躲
		sndWOP:Schedule(2.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\countfour.mp3")
		sndWOP:Schedule(3.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
		sndWOP:Schedule(4.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
		sndWOP:Schedule(5.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, _, _, spellId)
	if spellId == 119108 and self:AntiSpam(2, 3) then
		if not onPlatform then
			specWarnTerrorSpawn:Show()
			if mod:IsDps() then
				sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_kdkjzz.mp3") --快打恐懼之子
			end
		end
		warnConjureTerrorSpawns:Show()
	end
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 61042 or cid == 61046 or cid == 61038 then
		timerDreadSpray:Cancel(args.destGUID)
		timerDreadSprayCD:Cancel(args.destGUID)
		if mod:IsHealer() then
			sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_kbpszb.mp3")
		end
	end
end
