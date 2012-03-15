local class = select(2, UnitClass("player"))
local Frame = CreateFrame("Frame")
Frame:SetSize(48, 48)
Frame:SetPoint("TOP", UIParent, "TOP", 0, -35)

Frame.Cooldown = CreateFrame("Cooldown", nil, Frame)
Frame.Cooldown:SetAllPoints()
Frame.Cooldown:SetReverse(true)
Frame:Hide()

local function MakeShadow(f)
	if f.Shadow then return end
	local Shadow = CreateFrame("Frame", nil, f)
	Shadow:SetFrameLevel(0)
	Shadow:SetPoint("TOPLEFT", -3, 3)
	Shadow:SetPoint("BOTTOMRIGHT", 3, -3)
	Shadow:SetBackdrop({edgeFile = "Interface\\Addons\\!SunUI\\media\\glowTex", edgeSize = 3})
	Shadow:SetBackdropColor( .05, .05, .05, .9)
	Shadow:SetBackdropBorderColor(0, 0, 0, 1)
	f.Shadow = Shadow
	return Shadow
end
MakeShadow(Frame)

local function UpdateCDFrame(index, name, icon, start, duration)
	if Frame.Cooldown then
		Frame.Cooldown:SetReverse(false)
		CooldownFrame_SetTimer(Frame.Cooldown, start, duration, 1)
	end
end

local function  UpdateMakeIcon(Icon)
Frame.Icon = Frame:CreateTexture(nil, "ARTWORK")
Frame.Icon:SetTexture(Icon)
Frame.Icon:SetAllPoints(Frame)
Frame.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
end

Frame:SetScript("OnEvent", function(self, event)
	if class == "PRIEST" and UnitLevel("player") == 85 then 
			if ( UnitCanAttack("player", "target") and not UnitIsDead("target") and ( UnitHealth("target")/UnitHealthMax("target") < 1.25 ) ) then
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
   if class == "HUNTER" and UnitLevel("player") == 85 then 
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
   if class == "MAGE" and UnitLevel("player") == 85 then 
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
end)	
Frame:RegisterEvent("UNIT_HEALTH")
Frame:RegisterEvent("PLAYER_TARGET_CHANGED")
Frame:RegisterEvent("UNIT_POWER")

if class=="PRIEST" then
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