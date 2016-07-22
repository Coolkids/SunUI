﻿local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB
local AB = S:GetModule("ActionBar")

local DAY, HOUR, MINUTE = 86400, 3600, 60 --used for formatting text
local DAYISH, HOURISH, MINUTEISH = 3600 * 23.5, 60 * 59.5, 59.5 --used for formatting text at transition points
local HALFDAYISH, HALFHOURISH, HALFMINUTEISH = DAY/2 + 0.5, HOUR/2 + 0.5, MINUTE/2 + 0.5 --used for calculating next update times
local FONT_SIZE = 20 --the base font size to use at a scale of 1
local MIN_SCALE = 0.5 --the minimum scale we want to show cooldown counts at, anything below this will be hidden
local MIN_DURATION = 2.5 --the minimum duration to show cooldown text for
local EXPIRING_DURATION = 3 --the minimum number of seconds a cooldown must be to use to display in the expiring format
local EXPIRING_FORMAT = S:RGBToHex(1,0,0)..'%.1f|r' --format for timers that are soon to expire
local SECONDS_FORMAT = S:RGBToHex(1,1,0)..'%d|r' --format for timers that have seconds remaining
local MINUTES_FORMAT = S:RGBToHex(1,1,1)..'%dm|r' --format for timers that have minutes remaining
local HOURS_FORMAT = S:RGBToHex(0.4,1,1)..'%dh|r' --format for timers that have hours remaining
local DAYS_FORMAT = S:RGBToHex(0.4,0.4,1)..'%dh|r' --format for timers that have days remaining

local floor = math.floor
local min = math.min
local GetTime = GetTime

local cooldown = getmetatable(ActionButton1Cooldown).__index

function AB:GetTimeText(s)
	--format text as seconds when below a minute
	if s < MINUTEISH then
		local seconds = tonumber(S:Round(s))
		if seconds > EXPIRING_DURATION then
			return SECONDS_FORMAT, seconds, s - (seconds - 0.51)
		else
			return EXPIRING_FORMAT, s, 0.051
		end
	--format text as minutes when below an hour
	elseif s < HOURISH then
		local minutes = tonumber(S:Round(s/MINUTE))
		return MINUTES_FORMAT, minutes, minutes > 1 and (s - (minutes*MINUTE - HALFMINUTEISH)) or (s - MINUTEISH)
	--format text as hours when below a day
	elseif s < DAYISH then
		local hours = tonumber(S:Round(s/HOUR))
		return HOURS_FORMAT, hours, hours > 1 and (s - (hours*HOUR - HALFHOURISH)) or (s - HOURISH)
	--format text as days
	else
		local days = tonumber(S:Round(s/DAY))
		return DAYS_FORMAT, days,  days > 1 and (s - (days*DAY - HALFDAYISH)) or (s - DAYISH)
	end
end

function AB:Cooldown_StopTimer(cd)
	cd.enabled = nil
	cd:Hide()
end

function AB:Timer_ForceUpdate(cd)
	cd.nextUpdate = 0
	cd:Show()
end

function AB:Cooldown_OnSizeChanged(cd, width, height)
	local fontScale = S:Round(width) / 36
	if fontScale == cd.fontScale then
		return
	end

	cd.fontScale = fontScale
	if fontScale < MIN_SCALE then
		cd:Hide()
	else
		cd.text:SetFont(S["media"].cdfont, fontScale * FONT_SIZE, 'OUTLINE')
		cd.text:SetShadowColor(0, 0, 0, 0.5)
		cd.text:SetShadowOffset(2, -2)
		if cd.enabled then
			self:Timer_ForceUpdate(cd)
		end
	end
end

local function Cooldown_OnUpdate(cd, elapsed)
	if cd.nextUpdate > 0 then
		cd.nextUpdate = cd.nextUpdate - elapsed
		return
	end

	local remain = cd.duration - (GetTime() - cd.start)
	if remain > 0.05 then
		if (cd.fontScale * cd:GetEffectiveScale() / UIParent:GetScale()) < MIN_SCALE then
			cd.text:SetText("")
			cd.nextUpdate  = 500
		else
			local formatStr, time, nextUpdate = AB:GetTimeText(remain)
			cd.text:SetFormattedText(formatStr, time)
			cd.nextUpdate = nextUpdate
		end
	else
		AB:Cooldown_StopTimer(cd)
	end
end

function AB:CreateCooldownTimer(parent)
	local scaler = CreateFrame("Frame", nil, parent)
	scaler:SetAllPoints()

	local timer = CreateFrame("Frame", nil, scaler)
	timer:Hide()
	timer:SetAllPoints()
	timer:SetScript("OnUpdate", Cooldown_OnUpdate)

	local text = timer:CreateFontString(nil, "OVERLAY")
	text:SetPoint("CENTER", 1, 1)
	text:SetJustifyH("CENTER")
	timer.text = text

	self:Cooldown_OnSizeChanged(timer, parent:GetSize())
	parent:SetScript("OnSizeChanged", function(_, ...) self:Cooldown_OnSizeChanged(timer, ...) end)

	parent.timer = timer
	return timer
end

function AB:OnSetCooldown(cd, start, duration, charges, maxCharges)
	if cd.noOCC then return end

	local remainingCharges = charges or 0
	--start timer
	if start > 0 and duration > MIN_DURATION and remainingCharges == 0 then
		local timer = cd.timer or self:CreateCooldownTimer(cd)
		timer.start = start
		timer.duration = duration
		timer.enabled = true
		timer.nextUpdate = 0
		if timer.fontScale >= MIN_SCALE then timer:Show() end
	--stop timer
	else
		local timer = cd.timer
		if timer then
			self:Cooldown_StopTimer(timer)
		end
	end
end

local active, hooked = {}, {}
function AB:RegisterCooldown(frame)
	if not hooked[frame.cooldown] then
		frame.cooldown:HookScript("OnShow", function(cd) active[cd] = true end)
		frame.cooldown:HookScript("OnHide", function(cd) active[cd] = nil end)
		hooked[frame.cooldown] = true
	end
end

function AB:UpdateCooldown(cd)
	local button = cd:GetParent()
	local start, duration, enable = GetActionCooldown(button.action)

	self:OnSetCooldown(cd, start, duration)
end

function AB:ACTIONBAR_UPDATE_COOLDOWN()
	for cooldown in pairs(active) do
		self:UpdateCooldown(cooldown)
		if AB.db.cooldownalpha then
			self:UpdateCDAlpha(cooldown:GetParent())
		end
	end
end

local function CDStop(frame)
	frame:SetScript("OnUpdate", nil)
	frame:SetAlpha(1)
	local index = frame:GetName():match("MultiCastActionButton(%d)")
	if index then
		_G["MultiCastSlotButton"..index]:SetAlpha(1)
	end
end

local function CDUpdate(frame)
	if frame.StopTime < GetTime() then
		CDStop(frame)
	else
		frame:SetAlpha(AB.db.CooldownAlhpa)
		local index = frame:GetName():match("MultiCastActionButton(%d)")
		if index then
			_G["MultiCastSlotButton"..index]:SetAlpha(AB.db.CooldownAlhpa)
		end
	end
end

function AB:UpdateCDAlpha(self)
	if not AB.db.stancealpha and self:GetName():find("MultiCast") then return end
	local start, duration, enable = GetActionCooldown(self.action)
	if start>0 and duration > 1.5 then
		self.StopTime = start + duration
		self:SetScript("OnUpdate", CDUpdate)
	else
		CDStop(self)
	end
end

function AB:UpdateShapeshiftCDAlpha()
	for i=1, NUM_STANCE_SLOTS do
		button = _G["ShapeshiftButton"..i]
		local start, duration, enable = GetShapeshiftFormCooldown(i)
		if start>0 and duration > 1.5 then
			button.StopTime = start + duration
			button:SetScript("OnUpdate", CDUpdate)
		else
			CDStop(button)
		end
	end
end

function AB:CooldownFrame_Set(self, start, duration, enable, charges, maxCharges)
	if not self.ex then
		self.ex = CreateFrame("Cooldown", nil, self)
		self.ex:SetAllPoints(self)
	end
	if start and duration then
		self.ex:SetCooldown(start,duration,1,1)
	end
end

function AB:CreateCooldown()
	self:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN")
	self:SecureHook("SetActionUIButton", "RegisterCooldown")
	self:SecureHook("ActionBarButtonEventsFrame_RegisterFrame", "RegisterCooldown")

	if ActionBarButtonEventsFrame.frames then
		for _, frame in pairs(ActionBarButtonEventsFrame.frames) do
			self:RegisterCooldown(frame)
		end
	end

	if not self.hooks[cooldown] then
		self:SecureHook(cooldown, "SetCooldown", "OnSetCooldown")
	end

	self:SecureHook("CooldownFrame_Set")
end
