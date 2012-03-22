local S, C, L, DB = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("Core"):NewModule("Combatpoint")
if (DB.MyClass ~= "ROGUE" and DB.MyClass ~= "DRUID") then return end
function Module:OnInitialize()
local origPawWidth, origPawHeight = 512, 137
local pawWidth = 100
local comboBar = {
			[1]	= {r = 0.05, g = 0.43, b = 0.72},
			[2]	= {r = 0.71, g = 0.21, b = 0.82},
			[3]	= {r = 0.24, g = 0.67, b = 0.23},
			[4]	= {r = 0.95, g = 0.71, b = 0.00},
			[5]	= {r = 0.72, g = 0.05, b = 0.05},
		}

-- Disable Blizz combobar
ComboFrame:Hide()
ComboFrame:SetScript("OnUpdate", nil)
ComboFrame:SetScript("OnEvent", nil)
ComboFrame:UnregisterAllEvents()

local hideCombo
local updateInterval = 10
local lastUpdate = 0
local texScale = pawWidth / origPawWidth

combo = CreateFrame("Frame", nil, UIParent)
combo:SetFrameLevel(12)
combo:Size(origPawWidth * texScale, origPawHeight * texScale)
MoveHandle.Combatpoint = S.MakeMoveHandle(combo, L["连击点"], "Combatpoint")
combo:SetAlpha(0.5)
local t = combo:CreateTexture(nil, "ARTWORK", self, -5)
t:SetTexture([[Interface\AddOns\!SunUI\Media\pawsCombo]])
t:SetTexCoord(0, 1.0, 0, 0.268)
t:SetAllPoints()

combo.glow = CreateFrame("Frame", nil, UIParent)
combo.glow:SetAlpha(0)
local t2 = combo.glow:CreateTexture(nil, "ARTWORK", self, -1)
t2:SetTexture([[Interface\AddOns\!SunUI\Media\pawsCombo]])
t2:SetTexCoord(0, 1.0, 0.268, 0.54)
t2:SetAllPoints()

combo.animShow = {}
combo.animHide = {}

local xary = { 15, 109, 203, 297, 395 } -- Position of combo paws
for i = 1, MAX_COMBO_POINTS do
	combo[i] = CreateFrame("Frame", nil, combo)
	combo[i]:Point("LEFT", xary[i] * texScale, 0)
	combo[i]:Size(101 * texScale, 108 * texScale) -- 101,108 (29, 32)
	combo[i]:SetAlpha(0)

	local r = combo[i]:CreateTexture(nil, "OVERLAY")  
	r:SetTexture([[Interface\AddOns\!SunUI\Media\pawsCombo]])
	r:SetTexCoord(0.027, 0.227, 0.54, 0.75)
	r:SetAllPoints()
	combo[i].tex = r
	
	combo.animShow[i] = combo[i]:CreateAnimationGroup()
	local showPoint = combo.animShow[i]:CreateAnimation("Alpha")
	showPoint:SetChange(1)
	showPoint:SetDuration(0.2)
	showPoint:SetOrder(1)
	combo.animShow[i]:SetScript("OnFinished", function()
		combo[i]:SetAlpha(1.0)
	end)
	
	combo.animHide[i] = combo[i]:CreateAnimationGroup()
	local hidePoint = combo.animHide[i]:CreateAnimation("Alpha")
	hidePoint:SetChange(-1.0)
	hidePoint:SetDuration(0.3)
	hidePoint:SetOrder(1)
	combo.animHide[i]:SetScript("OnFinished", function()
		combo[i]:SetAlpha(0)
	end)
end

combo.glowPulse = combo.glow:CreateAnimationGroup()
local pulseIn = combo.glowPulse:CreateAnimation("Alpha")
pulseIn:SetChange(1)
pulseIn:SetDuration(0.5)
pulseIn:SetOrder(1)
local pulseOut = combo.glowPulse:CreateAnimation("Alpha")
pulseOut:SetChange(-1)
pulseOut:SetDuration(0.5)
pulseOut:SetOrder(2)
combo.glowPulse:SetScript("OnFinished", function()
	if (not combo.glow.stopPulse) then
		combo.glowPulse:Play()
	end
end)
combo.glow.stopPulse 	= true

combo.animHideSelf = combo:CreateAnimationGroup()
local hideBar = combo.animHideSelf:CreateAnimation("Alpha")
hideBar:SetChange(-0.5)
hideBar:SetDuration(0.3)
hideBar:SetOrder(1)
combo.animHideSelf:SetScript("OnFinished", function()

	if (combo.glowPulse:IsPlaying()) then combo.glowPulse:Stop() end
	combo.glow:SetAlpha(0)
	combo:SetAlpha(0)
end)

local function UpdateComboPoints()
	local cp
	if (UnitHasVehicleUI("player") or UnitHasVehicleUI("vehicle")) then
		cp = GetComboPoints("vehicle", "target")
	else
		cp = GetComboPoints("player", "target")
	end
	
	for i = 1, MAX_COMBO_POINTS do
		if (cp > 0) then
			combo[i].tex:SetVertexColor(comboBar[cp].r, comboBar[cp].g, comboBar[cp].b, 1.0)
		else
			combo[i].tex:SetVertexColor(0, 0, 0, 1.0)
		end
		
		local isShown = combo[i]:GetAlpha() > 0 or combo.animShow[i]:IsPlaying()
		local shouldShow = i <= cp
		
		if isShown ~= shouldShow then 
			if (isShown) then 
				combo.animHide[i]:Play()
			else 
				combo.animShow[i]:Play()
			end
		end
	end
	
	if (cp == MAX_COMBO_POINTS) then
		combo.glow.stopPulse = false
		combo.glowPulse:Play()
	else
		combo.glow.stopPulse = true
	end
end

local function OnUpdate(self, elapsed)
	if (InCombatLockdown()) then return end -- In combat
	
	if (self:GetAlpha() <= 0 or self.animHideSelf:IsPlaying()) then return end -- Already hidden/hiding
	
	lastUpdate = lastUpdate + elapsed 
	if (lastUpdate > updateInterval) then
		hideCombo = true
		for i = 1, MAX_COMBO_POINTS do
			local isShown = self[i]:GetAlpha() > 0 or self.animHide[i]:IsPlaying()
			if (isShown) then hideCombo = false end
		end
		if (hideCombo) then 
			self.animHideSelf:Play()
			self:SetScript("OnUpdate", nil)
		end
		lastUpdate = 0
	end
end
			
local function OnEvent(self, event)
	if (event == "PLAYER_REGEN_DISABLED") then
		if (combo.animHideSelf:IsPlaying()) then combo.animHideSelf:Stop() end
		combo:SetAlpha(1.0) 
	elseif (event == "PLAYER_REGEN_ENABLED") then
		combo:SetAlpha(0.5) 
		combo:SetScript("OnUpdate", OnUpdate)
	else
		UpdateComboPoints()
	end
end

combo:RegisterEvent("PLAYER_REGEN_DISABLED")
combo:RegisterEvent("PLAYER_REGEN_ENABLED")
combo:RegisterEvent("UNIT_COMBO_POINTS")
combo:RegisterEvent("PLAYER_TARGET_CHANGED")
combo:SetScript("OnEvent", OnEvent)
end