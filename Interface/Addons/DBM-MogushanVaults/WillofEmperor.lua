local mod	= DBM:NewMod(677, "DBM-MogushanVaults", nil, 317)
local L		= mod:GetLocalizedStrings()
local sndWOP	= mod:NewSound(nil, "SoundWOP", true)
local sndADD1A	= mod:NewSound(nil, "SoundADD1A", mod:IsDps())
local sndADD1	= mod:NewSound(nil, "SoundADD1", mod:IsDps())
local sndADD2A	= mod:NewSound(nil, "SoundADD2A", mod:IsDps())
local sndADD2	= mod:NewSound(nil, "SoundADD2", mod:IsDps())
local sndADD3A	= mod:NewSound(nil, "SoundADD3A", mod:IsDps())
local sndADD3	= mod:NewSound(nil, "SoundADD3", mod:IsDps())

mod:SetRevision(("$Revision: 7963 $"):sub(12, -3))
mod:SetCreatureID(60399, 60400)--60396 (Rage), 60397 (Strength), 60398 (Courage), 60480 (Titan Spark), 60399 (Qin-xi), 60400 (Jan-xi)
mod:SetModelID(41391)
mod:SetZone()
--mod:SetMinSyncRevision(7708)

mod:RegisterCombat("emote", L.Pull)
mod:SetMinCombatTime(25)

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_REMOVED",
	"UNIT_SPELLCAST_SUCCEEDED",
	"CHAT_MSG_MONSTER_YELL",
	"UNIT_DIED",
	"UNIT_POWER"
)

mod:RegisterEvents(
	"RAID_BOSS_EMOTE"
)

--Rage
local warnRageActivated			= mod:NewSpellAnnounce("ej5678", 3, 116525)
local warnFocusedAssault		= mod:NewTargetAnnounce(116525, 2, nil, false)--Completely and totally spammy, this option is just here for those that want this info despite the spam.
--Strength
local warnStrengthActivated		= mod:NewSpellAnnounce("ej5677", 3, 116550)
local warnEnergizingSmash		= mod:NewSpellAnnounce(116550, 3, nil, mod:IsMelee())--Also might be spammy
--Courage
local warnCourageActivated		= mod:NewSpellAnnounce("ej5676", 3, 116778)
local warnFocusedDefense		= mod:NewTargetAnnounce(116778, 4)
--Sparks (Heroic Only)
--local warnSpark					= mod:NewCountAnnounce("ej5674", 3)--Probably not very accurate. Not without wasting stupid amounts of cpu same way we do on spine. :\
local warnFocusedEnergy			= mod:NewTargetAnnounce(116829, 4)
--Jan-xi and Qin-xi
local warnBossesActivated		= mod:NewSpellAnnounce("ej5726", 3, 116815)
local warnArcLeft				= mod:NewCountAnnounce(116968, 4, nil, mod:IsMelee())--This is a pre warn, gives you time to move
local warnArcRight				= mod:NewCountAnnounce(116971, 4, nil, mod:IsMelee())--This is a pre warn, gives you time to move
local warnArcCenter				= mod:NewCountAnnounce(116972, 4, nil, mod:IsMelee())--This is a pre warn, gives you time to move
local warnStomp					= mod:NewCountAnnounce(116969, 4, nil, mod:IsMelee())--This is NOT a pre warn, only fires when stomp ends cast. :(
local warnTitanGas				= mod:NewCountAnnounce(116779, 4)

--Rage
local specWarnFocusedAssault	= mod:NewSpecialWarningYou(116525, false)
--Strength
local specWarnStrengthActivated	= mod:NewSpecialWarningSpell("ej5677", mod:IsTank())--These still need to be tanked. so give tanks special warning when these spawn, and dps can enable it too depending on dps strat.
--Courage
local specWarnCourageActivated	= mod:NewSpecialWarningSwitch("ej5676", mod:IsDps())--These really need to die asap. If they reach the tank, you will have a dead tank on hands very soon after.
local specWarnFocusedDefense	= mod:NewSpecialWarningYou(116778)
--Sparks (Heroic Only)
local specWarnFocusedEnergy		= mod:NewSpecialWarningYou(116829)
--Jan-xi and Qin-xi
local specWarnBossesActivated	= mod:NewSpecialWarningSwitch("ej5726", mod:IsTank())
local specWarnCombo				= mod:NewSpecialWarningSpell("ej5672", mod:IsMelee())
local specWarnTitanGas			= mod:NewSpecialWarningSpell(116779, nil, nil, nil, true)

--Rage
local timerRageActivates		= mod:NewNextTimer(11, "ej5678", nil, nil, nil, 116525)
--Strength
local timerStrengthActivates	= mod:NewNextTimer(9, "ej5677", nil, nil, nil, 116550)
--Courage
local timerCourageActivates		= mod:NewNextTimer(115, "ej5676", nil, nil, nil, 116778)
--Jan-xi and Qin-xi
local timerBossesActivates		= mod:NewNextTimer(109, "ej5726", nil, nil, nil, 116815)--Might be a little funny sounding "Next Jan-xi and Qin-xi" May just localize it later.
--local timerComboCD				= mod:NewCDTimer(14.2, "ej5672", nil, nil, nil, 116835)--20 seconds after last one ENDED (or rathor, how long it takes to charge up 20 energy) We start timer at 1 energy though so more like 19 seconds.
local timerTitanGas				= mod:NewBuffActiveTimer(30, 116779)
local timerTitanGasCD			= mod:NewNextCountTimer(150, 116779)

mod:AddBoolOption("InfoFrame", false)

mod:AddDropdownOption("optBY", {"tarfoc", "Janxi", "Qinxi", "none"}, "tarfoc", "sound")

local comboWarned = false
local sparkCount = 0
local comboCount = 0
local titanGasCast = 0
local focusedAssault = GetSpellInfo(116525)

local Isstomp = 0

function mod:OnCombatStart(delay)
	comboWarned = false
	sparkCount = 0
	comboCount = 0
	titanGasCast = 0
	Isstomp = 0
	timerBossesActivates:Start(-delay)--Still start here to give perspective
	timerCourageActivates:Start(75-delay)
	timerTitanGasCD:Start(221-delay, 1)
	if self.Options.InfoFrame then
		DBM.InfoFrame:SetHeader(focusedAssault)
		DBM.InfoFrame:Show(10, "playerbaddebuff", 116525)
	end
end

function mod:OnCombatEnd()
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(116525) then
		warnFocusedAssault:Show(args.destName)
		if args:IsPlayer() then
			specWarnFocusedAssault:Show()
		end
	elseif args:IsSpellID(116778) then
		warnFocusedDefense:Show(args.destName)
		if args:IsPlayer() then
			specWarnFocusedDefense:Show()
			if not mod:IsTank() then
				sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\justrun.mp3") --快跑
			end
		end
	elseif args:IsSpellID(116829) then
		warnFocusedEnergy:Show(args.destName)
		if args:IsPlayer() then
			specWarnFocusedEnergy:Show()
		end
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(116778) then
		if args:IsPlayer() then
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\safenow.mp3") --安全
		end
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.Rage or msg:find(L.Rage) then
		warnRageActivated:Schedule(11)
		sndADD1A:Schedule(5, "Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_qjbzb.mp3") --輕甲
		sndADD1:Schedule(10, "Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_qjbcx.mp3")
		timerRageActivates:Start()--They actually spawn 11 seconds after yell
	end
end

function mod:RAID_BOSS_EMOTE(msg)
	if msg == L.Strength or msg:find(L.Strength) then
		warnStrengthActivated:Schedule(9)
		sndADD3A:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_zjbzb.mp3") --重甲
		sndADD3:Schedule(8, "Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_zjbcx.mp3")
		specWarnStrengthActivated:Schedule(9)
		timerStrengthActivates:Start()--They actually spawn 10 seconds after emote
	elseif msg == L.Courage or msg:find(L.Courage) then
		warnCourageActivated:Schedule(10)
		specWarnCourageActivated:Schedule(10)
--		timerCourageActivates:Update()--They actually spawn 10 seconds after emote
		if timerCourageActivates:GetTime() > 80 then--First timer
			timerCourageActivates:Update(105, 115)
		else--first timer
			timerCourageActivates:Update(65, 75)
		end
		sndADD2A:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_dbzb.mp3") --盾兵
		sndADD2:Schedule(8, "Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_dbkd.mp3")
	elseif msg == L.Boss or msg:find(L.Boss) then
		warnBossesActivated:Schedule(10)
		specWarnBossesActivated:Schedule(10)
		timerBossesActivates:Update(99, 109)
		sndWOP:Schedule(8, "Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_szcz.mp3") --雙子
	elseif msg:find("spell:116779") then
		timerCourageActivates:Start(105)--Resets timer
		if self:IsDifficulty("heroic10", "heroic25") then--On heroic the boss activates this perminantly on pull and it's always present
			if not self:IsInCombat() then
				DBM:StartCombat(self, 0)
			end
		else
			titanGasCast = titanGasCast + 1
			warnTitanGas:Show(titanGasCast)
			specWarnTitanGas:Show()
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_ttqt.mp3") --泰坦氣體
			if titanGasCast < 4 then -- after Titan Gas casted 3 times, Titan Gas lasts permanently. (soft enrage)
				timerTitanGas:Start()
				timerTitanGasCD:Start(150, titanGasCast+1)
			end
		end
	end
end

function chooseboss(BuId)
	if mod.Options.optBY == "tarfoc" and (BuId ~= "target") and (BuId ~= "focus") then
		return false
	elseif mod.Options.optBY == "Janxi" and (UnitName(BuId) ~= UnitName("boss2")) then
		return false
	elseif mod.Options.optBY == "Qinxi" and (UnitName(BuId) ~= UnitName("boss1")) then
		return false
	elseif mod.Options.optBY == "none" then
		return false
	else
		return true
	end
end

function checkisstomp()
	if mod:IsDps() then
		sndWOP:Schedule(1, "Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
		sndWOP:Schedule(2, "Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
	end
	mod:Schedule(2, function() Isstomp = 0 end)
	mod:Schedule(4, function() 
		if Isstomp ~= 1 and comboCount ~= 0 then
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_jt.mp3") --踐踏
		end
	end)
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, _, _, spellId)
	if spellId == 116556 and uId == "target" then
		warnEnergizingSmash:Show()
--[[	elseif spellId == 117746 then--Spark Spawning
		self:SendSync("SparkSpawned")--]]
	end
	if (not chooseboss(uId)) then return end
	if spellId == 116968 and self:AntiSpam(2, 1) then--Arc Left
		Isstomp = 1
		comboCount = comboCount + 1
		checkisstomp()
		warnArcLeft:Show(comboCount)
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_left.mp3") --左側
		if mod:IsHealer() then
			if comboCount == 5 then
				sndWOP:Schedule(1, "Interface\\AddOns\\DBM-Core\\extrasounds\\countfive.mp3")
			end
			if comboCount == 4 then
				sndWOP:Schedule(1, "Interface\\AddOns\\DBM-Core\\extrasounds\\countfour.mp3")
			end
			if comboCount == 3 then
				sndWOP:Schedule(1, "Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
			end
			if comboCount == 2 then
				sndWOP:Schedule(1, "Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
			end
			if comboCount == 1 then
				sndWOP:Schedule(1, "Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
			end
		end
	elseif spellId == 116971 and self:AntiSpam(2, 2) then--Arc Right
		Isstomp = 1
		comboCount = comboCount + 1
		checkisstomp()
		warnArcRight:Show(comboCount)
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_right.mp3") --右側
		if mod:IsHealer() then
			if comboCount == 5 then
				sndWOP:Schedule(1, "Interface\\AddOns\\DBM-Core\\extrasounds\\countfive.mp3")
			end
			if comboCount == 4 then
				sndWOP:Schedule(1, "Interface\\AddOns\\DBM-Core\\extrasounds\\countfour.mp3")
			end
			if comboCount == 3 then
				sndWOP:Schedule(1, "Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
			end
			if comboCount == 2 then
				sndWOP:Schedule(1, "Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
			end
			if comboCount == 1 then
				sndWOP:Schedule(1, "Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
			end
		end
	elseif spellId == 116972 and self:AntiSpam(2, 3) then--Arc Center
		Isstomp = 1
		comboCount = comboCount + 1
		checkisstomp()
		warnArcCenter:Show(comboCount)
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_center.mp3") --前方
--		specWarnArcCenter:Show()
		if mod:IsHealer() then
			if comboCount == 5 then
				sndWOP:Schedule(1, "Interface\\AddOns\\DBM-Core\\extrasounds\\countfive.mp3")
			end
			if comboCount == 4 then
				sndWOP:Schedule(1, "Interface\\AddOns\\DBM-Core\\extrasounds\\countfour.mp3")
			end
			if comboCount == 3 then
				sndWOP:Schedule(1, "Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
			end
			if comboCount == 2 then
				sndWOP:Schedule(1, "Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
			end
			if comboCount == 1 then
				sndWOP:Schedule(1, "Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
			end
		end
	elseif (spellId == 116969 or spellId == 132425) and self:AntiSpam(2, 4) then--Stomp
		comboCount = comboCount + 1
		warnStomp:Show(comboCount)
	end
end

--Although, again, it might fail in sync handler antispam throttle if multiple spawn within a single second. Might need more work.
--[[function mod:OnSync(msg)
	if msg == "SparkSpawned" then
		sparkCount = sparkCount + 1
		warnSpark:Show(sparkCount)
	end
end-]]

--[[function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 60480 and sparkCount > 0 then--Titan Spark
		sparkCount = sparkCount - 1
		warnSpark:Show(sparkCount)
	end
end--]]

--[[
"<121.7> MANA#0#1#20#0#0", -- [1]--Start Power Gain
"<138.5> MANA#0#18#20#0#0", -- [18]--Beware! here to give 2.4ish sec warning of incoming special.
"<139.7> MANA#0#19#20#0#0", -- [19]
"<140.5> MANA#0#20#20#0#0", -- [20]--Full Power
"<140.9> Qin-xi [boss2:Arc Right::0:116971]", -- [22]--Begin Combo
"<144.1> Qin-xi [boss2:Arc Center::0:116972]", -- [24]
"<149.8> Qin-xi [boss2:Stomp::0:116969]", -- [26]
"<150.6> Qin-xi [boss2:Arc Right::0:116971]", -- [28]
"<153.8> Qin-xi [boss2:Arc Left::0:116968]", -- [30]
"<157.0> Qin-xi [boss2:Arc Right::0:116971]", -- [31]
"<162.2> Qin-xi [boss2:Stomp::0:116969]", -- [33]
"<162.6> Qin-xi [boss2:Arc Center::0:116972]", -- [35]
"<166.3> Qin-xi [boss2:Arc Left::0:116968]", -- [37]
--]]
-- Seems that Jan-xi and Qin-xi mana are not identical. So as time goes, this stuff can be broken.
-- also timerComboCD is not be fixed. their mana increases 1 or 2 randomly every boss's melee attacks.
-- 
function mod:UNIT_POWER(uId)
	if (not chooseboss(uId)) then return end
	if (self:GetUnitCreatureId(uId) == 60399 or self:GetUnitCreatureId(uId) == 60400) and UnitPower(uId) == 18 and not comboWarned then
		comboWarned = true
		specWarnCombo:Show()
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_zbbyz.mp3") --準備半月斬
	elseif (self:GetUnitCreatureId(uId) == 60399 or self:GetUnitCreatureId(uId) == 60400) and UnitPower(uId) == 1 then
		comboWarned = false
		comboCount = 0
--		timerComboCD:Start()
	end
end
