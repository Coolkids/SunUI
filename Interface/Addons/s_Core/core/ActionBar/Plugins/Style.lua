-- Engines
local S, C, L, DB = unpack(select(2, ...))
if DB.Nuke == true then return end
local Module = LibStub("AceAddon-3.0"):GetAddon("Core"):NewModule("Style")
function Module:OnInitialize()
if ActionBarDB.Style == 1 then
C = ActionBarDB
local function StyleActionButton(self)
	if not self.Shadow then
		local Button  = self
		local Icon  = _G[self:GetName().."Icon"]
		local Count  = _G[self:GetName().."Count"]
		local Border  = _G[self:GetName().."Border"]
		local HotKey  = _G[self:GetName().."HotKey"]
		local Cooldown  = _G[self:GetName().."Cooldown"]
		local Name  = _G[self:GetName().."Name"]
		local Flash  = _G[self:GetName().."Flash"]
		local NormalTexture  = _G[self:GetName().."NormalTexture"]
		local FloatingBG  = _G[self:GetName().."FloatingBG"]
		
		if FloatingBG then
			FloatingBG:Hide()
		end
	
		if HotKey then		
			HotKey:ClearAllPoints()
			HotKey:SetPoint("TOPRIGHT", 1, -1)
			HotKey:SetFont(DB.Font, C["FontSize"]*S.Scale(1), "THINOUTLINE")
			
			if C["HideHotKey"] then
				HotKey:SetText("")
				HotKey:Hide()
				HotKey.Show = function() end
			end
		end
		
		if Name then		
			Name:ClearAllPoints()
			Name:SetPoint("BOTTOMLEFT", 0, 2)
			Name:SetFont(DB.Font, C["MFontSize"]*S.Scale(1), "THINOUTLINE")
			
			if C["HideMacroName"] then
				Name:SetText("")
				Name:Hide()
				Name.Show = function() end
			end
		end
		
		Count:ClearAllPoints()
		Count:SetPoint("BOTTOMRIGHT", 2, 0)
		Count:SetFont(DB.Font, C["FontSize"]*S.Scale(1), "THINOUTLINE")
		
		Flash:SetTexture("")
		--Flash:SetTexture(1, 1, 1, 0.5)
		Button:SetNormalTexture("")
		Button.SetNormalTexture = function() end
		
		Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
		Icon:SetPoint("TOPLEFT", 2, -2)
		Icon:SetPoint("BOTTOMRIGHT", -2, 2)
		
		Cooldown:ClearAllPoints()
		Cooldown:SetPoint("TOPLEFT", 2, -2)
		Cooldown:SetPoint("BOTTOMRIGHT", -2, 2)
		
		if NormalTexture then
			NormalTexture:ClearAllPoints()
			NormalTexture:SetAllPoints()
		end
		
		if Border then
			Border:ClearAllPoints()
			Border:SetPoint("TOPLEFT", -10, 10)
			Border:SetPoint("BOTTOMRIGHT", 10, -10)
		end
 
		local HighlightTexture = Button:CreateTexture("Frame", nil, self)
		HighlightTexture:SetTexture(1, 1, 1, 0.3)
		HighlightTexture:SetPoint("TOPLEFT", 2, -2)
		HighlightTexture:SetPoint("BOTTOMRIGHT", -2, 2)
		Button:SetHighlightTexture(HighlightTexture)

		local PushedTexture = Button:CreateTexture("Frame", nil, self)
		PushedTexture:SetTexture(0.9, 0.8, 0.1, 0.3)
		PushedTexture:SetPoint("TOPLEFT", 2, -2)
		PushedTexture:SetPoint("BOTTOMRIGHT", -2, 2)
		Button:SetHighlightTexture(PushedTexture)
		
		local CheckedTexture = Button:CreateTexture("Frame", nil, self)
		CheckedTexture:SetTexture(23/255,132/255,209/255,0.5)
		CheckedTexture:SetPoint("TOPLEFT", 2, -2)
		CheckedTexture:SetPoint("BOTTOMRIGHT", -2, 2)
		Button:SetCheckedTexture(CheckedTexture)
		
		Button.Shadow = S.MakeTexShadow(Button, Icon, 5)
	end
end
 
local function StyleShapeShiftButton()
	for i = 1, NUM_SHAPESHIFT_SLOTS do
		local Button  = _G["ShapeshiftButton"..i]
		if not Button.Shadow then
			local Icon  = _G["ShapeshiftButton"..i.."Icon"]
			local Flash  = _G["ShapeshiftButton"..i.."Flash"]
			local Border  = _G["ShapeshiftButton"..i.."Border"]
			local NormalTexture  = _G["ShapeshiftButton"..i.."NormalTexture2"]
			
			Border:SetTexture(nil)
			Border = function() end
			
			Flash:SetTexture("")
			Button:SetNormalTexture("")
			Button.SetNormalTexture = function() end

			Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
			Icon:SetPoint("TOPLEFT", 2, -2)
			Icon:SetPoint("BOTTOMRIGHT",  -2, 2)
			
			if NormalTexture then
				NormalTexture:ClearAllPoints()
				NormalTexture:SetAllPoints()
			end
			
			local HighlightTexture = Button:CreateTexture("Frame", nil, self)
			HighlightTexture:SetTexture(1, 1, 1, 0.3)
			HighlightTexture:SetPoint("TOPLEFT", 2, -2)
			HighlightTexture:SetPoint("BOTTOMRIGHT", -2, 2)
			Button:SetHighlightTexture(HighlightTexture)

			local PushedTexture = Button:CreateTexture("Frame", nil, self)
			PushedTexture:SetTexture(0.1, 0.1, 0.1, 0.5)
			PushedTexture:SetPoint("TOPLEFT", 2, -2)
			PushedTexture:SetPoint("BOTTOMRIGHT", -2, 2)
			Button:SetHighlightTexture(PushedTexture)
			
			local CheckedTexture = Button:CreateTexture("frame", nil, self)
			CheckedTexture:SetTexture(1, 1, 1, 0.5)
			CheckedTexture:SetPoint("TOPLEFT", 2, -2)
			CheckedTexture:SetPoint("BOTTOMRIGHT", -2, 2)
			Button:SetCheckedTexture(CheckedTexture)
			
			Button.Shadow = S.MakeTexShadow(Button, Icon, 5)
		end
	end
end

local function StylePetButton()
	for i = 1, NUM_PET_ACTION_SLOTS do
		local Button  = _G["PetActionButton"..i]
		if not Button.Shadow then
			local Icon  = _G["PetActionButton"..i.."Icon"]
			local Flash  = _G["PetActionButton"..i.."Flash"]
			local Shine = _G["PetActionButton"..i.."Shine"]
			local Border  = _G["ShapeshiftButton"..i.."Border"]
			local AutoCastable = _G["PetActionButton"..i.."AutoCastable"]
			local NormalTexture  = _G["PetActionButton"..i.."NormalTexture2"]

			Border:SetTexture(nil)
			Border = function() end
			
			Flash:SetTexture("")
			Button:SetNormalTexture("")
			Button.SetNormalTexture = function() end

			Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
			Icon:SetPoint("TOPLEFT", 2, -2)
			Icon:SetPoint("BOTTOMRIGHT",  -2, 2)
			
			if NormalTexture then
				NormalTexture:ClearAllPoints()
				NormalTexture:SetAllPoints()
			end

			if Shine then
				Shine:ClearAllPoints()
				Shine:SetPoint("TOPLEFT", 2, -2)
				Shine:SetPoint("BOTTOMRIGHT", -2, 2)
			end
			
			if AutoCastable then
				AutoCastable:ClearAllPoints()
				AutoCastable:SetPoint("TOPLEFT", -12, 12)
				AutoCastable:SetPoint("BOTTOMRIGHT", 12, -12)
			end

			local HighlightTexture = Button:CreateTexture("Frame", nil, self)
			HighlightTexture:SetTexture(1, 1, 1, 0.3)
			HighlightTexture:SetPoint("TOPLEFT", 2, -2)
			HighlightTexture:SetPoint("BOTTOMRIGHT", -2, 2)
			Button:SetHighlightTexture(HighlightTexture)

			local PushedTexture = Button:CreateTexture("Frame", nil, self)
			PushedTexture:SetTexture(0.1, 0.1, 0.1, 0.5)
			PushedTexture:SetPoint("TOPLEFT", 2, -2)
			PushedTexture:SetPoint("BOTTOMRIGHT", -2, 2)
			Button:SetHighlightTexture(PushedTexture)
			
			local CheckedTexture = Button:CreateTexture("frame", nil, self)
			CheckedTexture:SetTexture(1, 1, 1, 0.5)
			CheckedTexture:SetPoint("TOPLEFT", 2, -2)
			CheckedTexture:SetPoint("BOTTOMRIGHT", -2, 2)
			Button:SetCheckedTexture(CheckedTexture)
			
			Button.Shadow = S.MakeTexShadow(Button, Icon, 4)
		end
	end
end
	
	hooksecurefunc("ActionButton_Update", StyleActionButton)
	hooksecurefunc("ShapeshiftBar_Update", StyleShapeShiftButton)
	hooksecurefunc("ShapeshiftBar_UpdateState", StyleShapeShiftButton)
	hooksecurefunc("PetActionBar_Update", StylePetButton)
end
end