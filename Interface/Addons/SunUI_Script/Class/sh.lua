local S, C, L, DB = unpack(SunUI)
	
local start, duration
local spellIDs = {
	["PRIEST"] = 32379,
	["HUNTER"] = 53351,
	["MAGE"] = 12051,
	["WARLOCK"] = nil,
	["PALADIN"] = nil,
	["ROGUE"] = nil,
	["DRUID"] = nil,
	["SHAMAN"] = nil,
	["WARRIOR"] = nil,
	["DEATHKNIGHT"] = nil,
} 

local Frame = CreateFrame("Frame", "SH", UIParent)
Frame:SetSize(48, 48)
Frame:SetPoint("TOP", UIParent, "TOP", 0, -35)
Frame.Cooldown = CreateFrame("Cooldown", nil, Frame)
Frame.Cooldown:SetAllPoints()
Frame.Cooldown:SetReverse(true)
Frame:CreateShadow()
Frame:Hide()

local function UpdateFrame() 
	if Frame.Icon then return end
	local Icon = select(3, GetSpellInfo(spellIDs[DB.MyClass]))
	Frame.Icon = Frame:CreateTexture(nil, "ARTWORK") 
	Frame.Icon:SetTexture(Icon) 
	Frame.Icon:SetAllPoints(Frame)
	Frame.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
end
Frame:SetScript("OnEvent", function(self, event)
	if DB.MyClass == "PRIEST" and UnitLevel("player") > 50 then 
		if ( UnitCanAttack("player", "target") and not UnitIsDead("target") and ( UnitHealth("target")/UnitHealthMax("target") < 0.2 ) and not UnitIsDead("player") ) then		
			self:Show()
			UpdateFrame()
			if event == "SPELL_UPDATE_COOLDOWN" then
				local start, duration = GetSpellCooldown(spellIDs[DB.MyClass])
				Frame.Cooldown:SetReverse(false)
				CooldownFrame_SetTimer(Frame.Cooldown, start, duration, 1)
				if start > 1.5 and duration > 1.5 then
					ActionButton_HideOverlayGlow(self)
				else
					ActionButton_ShowOverlayGlow(self)
				end
			end
		else self:Hide()
		end
	elseif DB.MyClass == "HUNTER" and UnitLevel("player") > 50 then 
		if ( UnitCanAttack("player", "target") and not UnitIsDead("target") and ( UnitHealth("target")/UnitHealthMax("target") < 0.2 ) and not UnitIsDead("player") ) then
			self:Show()
			UpdateFrame()
			if event == "SPELL_UPDATE_COOLDOWN" then
				local start, duration = GetSpellCooldown(spellIDs[DB.MyClass])
				Frame.Cooldown:SetReverse(false)
				CooldownFrame_SetTimer(Frame.Cooldown, start, duration, 1)
				if start > 1.5 and duration > 1.5 then
					ActionButton_HideOverlayGlow(self)
				else
					ActionButton_ShowOverlayGlow(self)
				end
			end
		else self:Hide()
		end
   elseif DB.MyClass == "MAGE" and UnitLevel("player") > 50 then 
		if (( UnitPower("player")/UnitPowerMax("player") < 0.4 ) and not UnitIsDead("player") ) then
			self:Show()
			UpdateFrame()
			if event == "SPELL_UPDATE_COOLDOWN" then
				local start, duration = GetSpellCooldown(spellIDs[DB.MyClass])
				Frame.Cooldown:SetReverse(false)
				CooldownFrame_SetTimer(Frame.Cooldown, start, duration, 1)
				if start > 1.5 and duration > 1.5 then
					ActionButton_HideOverlayGlow(self)
				else
					ActionButton_ShowOverlayGlow(self)
				end
			end
		else self:Hide()
		end
	end
end)	

Frame:RegisterEvent("UNIT_HEALTH")
Frame:RegisterEvent("PLAYER_TARGET_CHANGED")
Frame:RegisterEvent("UNIT_POWER")
Frame:RegisterEvent("SPELL_UPDATE_COOLDOWN")	

if DB.PlayerName == "Coolkid" then
	local ShadowOrbs = CreateFrame("Frame", nil, f)

	ShadowOrbs.text = S.MakeFontString(ShadowOrbs, 60*S.Scale(1), "OUTLINEMONOCHROME")
	ShadowOrbs.text:SetPoint("CENTER", UIParent, "CENTER", 0, -55)
	ShadowOrbs.text:SetText("")
	ShadowOrbs.text:SetTextColor(.86,.22,1)
	ShadowOrbs:SetAllPoints(ShadowOrbs.text)
	ShadowOrbs:Hide()
	ShadowOrbs:SetScript("OnEvent",function()
		local numShadowOrbs = UnitPower('player', SPELL_POWER_SHADOW_ORBS)
		if numShadowOrbs == 0 then
			ShadowOrbs:Hide()
		else
			ShadowOrbs:Show()
			ShadowOrbs.text:SetText(numShadowOrbs)
		end
	end)

	ShadowOrbs:RegisterEvent("PLAYER_ENTERING_WORLD")
	ShadowOrbs:RegisterEvent("UNIT_POWER")
	ShadowOrbs:RegisterEvent("UNIT_DISPLAYPOWER")
end