local S, _, _, DB = unpack(select(2, ...))
local Frame = CreateFrame("Frame")
	  Frame:SetWidth(48)
      Frame:SetHeight(48)  
      Frame:SetPoint("TOP", UIParent, "TOP", 0, -35)
	  Frame.Cooldown = CreateFrame("Cooldown", nil, Frame)
	  Frame.Cooldown:SetAllPoints()
	  Frame.Cooldown:SetReverse(true)
	  
	  Frame.Border = S.MakeBorder(Frame, 1.5)
	  Frame.bgFile = S.MakeBG(Frame, 1.5)
	  Frame.Shadow = S.MakeShadow(Frame, 3)
	  Frame:Hide()
local function UpdateCDFrame(index, name, icon, start, duration)
	if Frame.Cooldown then
		Frame.Cooldown:SetReverse(false)
		CooldownFrame_SetTimer(Frame.Cooldown, start, duration, 1)
	end
end
local function  UpdateMakeIcon(Icon)
Frame.Icon = Frame:CreateTexture(nil, "ARTWORK") 
Frame.Icon:SetWidth(48)
Frame.Icon:SetHeight(48)
Frame.Icon:SetTexture(Icon) 
Frame.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
Frame.Icon:SetPoint("CENTER", Frame, "CENTER", 0, 0)
end
Frame:RegisterEvent("UNIT_HEALTH")
Frame:RegisterEvent("PLAYER_TARGET_CHANGED")
Frame:RegisterEvent("UNIT_POWER")

Frame:SetScript("OnEvent", function(self, event)
	if DB.MyClass == "PRIEST" and UnitLevel("player") == 85 then 
		if event == "UNIT_HEALTH" or event == "PLAYER_TARGET_CHANGED"  then 
			if ( UnitCanAttack("player", "target") and not UnitIsDead("target") and ( UnitHealth("target")/UnitHealthMax("target") < 0.25 ) ) then
			local _, _, Icon = select(1, GetSpellInfo(32379))
			 UpdateMakeIcon(Icon)
			self:Show()
				if GetSpellCooldown(32379) and select(2, GetSpellCooldown(32379)) > 1.5 then
					local start, duration = GetSpellCooldown(32379)
					UpdateCDFrame(KEY, name, icon, start, duration)
				end 
			else self:Hide()
			end
		end
    end
   if DB.MyClass == "HUNTER" and UnitLevel("player") == 85 then 
		if event == "UNIT_HEALTH" or event == "PLAYER_TARGET_CHANGED"  then 
			if ( UnitCanAttack("player", "target") and not UnitIsDead("target") and ( UnitHealth("target")/UnitHealthMax("target") < 0.2 ) ) then
			local _, _, Icon = select(1, GetSpellInfo(53351))
			UpdateMakeIcon(Icon)
			self:Show()
				if GetSpellCooldown(53351) and select(2, GetSpellCooldown(53351)) > 1.5 then
					local start, duration = GetSpellCooldown(53351)
					UpdateCDFrame(KEY, name, icon, start, duration)
				end 
			else self:Hide()
			end
		end
   end
   if DB.MyClass == "MAGE" and UnitLevel("player") == 85 then 
		if event == "UNIT_POWER" then 
			if ( UnitPower("player")/UnitPowerMax("player") < 0.4 ) then
			local _, _, Icon = select(1, GetSpellInfo(12051))
			UpdateMakeIcon(Icon)
			self:Show()
				if GetSpellCooldown(12051) and select(2, GetSpellCooldown(12051)) > 1.5 then
					local start, duration = GetSpellCooldown(12051)
					UpdateCDFrame(KEY, name, icon, start, duration)
				end 
			else self:Hide()
			end
		end
   end
end)	