local S, C, L, DB = unpack(select(2, ...))
local _
	
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
			end
		else self:Hide()
		end
	end
end)	

Frame:RegisterEvent("UNIT_HEALTH")
Frame:RegisterEvent("PLAYER_TARGET_CHANGED")
Frame:RegisterEvent("UNIT_POWER")
Frame:RegisterEvent("SPELL_UPDATE_COOLDOWN")	

if DB.MyClass == "PRIEST" then
	local talent = CreateFrame("Frame", nil, UIParent)
	talent:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
	talent:RegisterEvent("PLAYER_ENTERING_WORLD")
	talent:RegisterEvent("PLAYER_TALENT_UPDATE")
	talent:HookScript("OnEvent", function(self, event)
		if event == "PLAYER_TALENT_UPDATE" or event == "ACTIVE_TALENT_GROUP_CHANGED" or event == "PLAYER_ENTERING_WORLD" then
			self:UnregisterEvent("PLAYER_ENTERING_WORLD")
			local tree = GetSpecialization()
			if tree ~= 3 then
				Frame:UnregisterAllEvents()
			else
				Frame:RegisterEvent("UNIT_HEALTH")
				Frame:RegisterEvent("PLAYER_TARGET_CHANGED")
				Frame:RegisterEvent("UNIT_POWER")
				Frame:RegisterEvent("SPELL_UPDATE_COOLDOWN")
				self:Hide()
			end
		end
	end)
end