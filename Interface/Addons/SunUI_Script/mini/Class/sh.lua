local S, C, L, DB = unpack(SunUI)

local Module = LibStub("AceAddon-3.0"):GetAddon("Core"):NewModule("SH")
function Module:OnInitialize()
	local Frame = CreateFrame("Frame")
		Frame:SetWidth(48)
		Frame:SetHeight(48)  
		Frame:SetPoint("TOP", UIParent, "TOP", 0, -35)
		Frame.Cooldown = CreateFrame("Cooldown", nil, Frame)
		Frame.Cooldown:SetAllPoints()
		Frame.Cooldown:SetReverse(true)
		  
		Frame:CreateShadow()
		Frame:Hide()
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
	local function UpdateFrame() 
		if Frame.Icon then return end
		local Icon = select(3, GetSpellInfo(spellIDs[select(2, UnitClass("player"))]))
		Frame.Icon = Frame:CreateTexture(nil, "ARTWORK") 
		Frame.Icon:SetTexture(Icon) 
		Frame.Icon:SetAllPoints(Frame)
		Frame.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	end

	Frame:SetScript("OnEvent", function(self, event)
		if select(2, UnitClass("player")) == "PRIEST" and UnitLevel("player") == 85 then 
			if ( UnitCanAttack("player", "target") and not UnitIsDead("target") and ( UnitHealth("target")/UnitHealthMax("target") < 0.25 ) and not UnitIsDead("player") ) then		
				self:Show()
				UpdateFrame()
				if event == "SPELL_UPDATE_COOLDOWN" then
					local start, duration = GetSpellCooldown(spellIDs[select(2, UnitClass("player"))])
					Frame.Cooldown:SetReverse(false)
					CooldownFrame_SetTimer(Frame.Cooldown, start, duration, 1)
				end
			else self:Hide()
			end
		elseif select(2, UnitClass("player")) == "HUNTER" and UnitLevel("player") == 85 then 
			if ( UnitCanAttack("player", "target") and not UnitIsDead("target") and ( UnitHealth("target")/UnitHealthMax("target") < 0.2 ) and not UnitIsDead("player") ) then
				self:Show()
				UpdateFrame()
				if event == "SPELL_UPDATE_COOLDOWN" then
					local start, duration = GetSpellCooldown(spellIDs[select(2, UnitClass("player"))])
					Frame.Cooldown:SetReverse(false)
					CooldownFrame_SetTimer(Frame.Cooldown, start, duration, 1)
				end
			else self:Hide()
			end
	   elseif select(2, UnitClass("player")) == "MAGE" and UnitLevel("player") == 85 then 
			if (( UnitPower("player")/UnitPowerMax("player") < 0.4 ) and not UnitIsDead("player") ) then
				self:Show()
				UpdateFrame()
				if event == "SPELL_UPDATE_COOLDOWN" then
					local start, duration = GetSpellCooldown(spellIDs[select(2, UnitClass("player"))])
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

	if DB.PlayerName == "Coolkid" then
		local sp=CreateFrame("Frame")
		sp:SetScript("OnEvent",function(self)
			if GetShapeshiftForm() == 1 then
					SetCVar('CombatHealing',0)
			else
					SetCVar('CombatHealing',1)
			end
		end)
		sp:RegisterEvent("PLAYER_ENTERING_WORLD")	
		sp:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
		sp:RegisterEvent("UPDATE_SHAPESHIFT_FORMS")
	end
	
end