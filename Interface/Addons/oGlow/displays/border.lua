local _, ns = ...
local oGlow = ns.oGlow

local argcheck = oGlow.argcheck
local colorTable = ns.colorTable

local createBorder = function(self, point)
	local bc = self.oGlowBorder
	if(not bc) then
		if(not self:IsObjectType'Frame') then
			--bc = self:GetParent():CreateTexture(nil, 'OVERLAY')
			bc = CreateFrame("Frame", nil, self:GetParent())
		else
			--bc = self:CreateTexture(nil, "OVERLAY")
			bc = CreateFrame("Frame", nil, self)
		end

		--bc:SetTexture"Interface\\Buttons\\UI-ActionButton-Border"
		--bc:SetBlendMode("ADD")
		--bc:SetAlpha(.9)
		bc:SetBackdrop({
			edgeFile = "Interface\\Addons\\s_Core\\media\\glowTex",   --"Interface\\ChatFrame\\ChatFrameBackground", 
			edgeSize = 4, 
		})

		bc:SetWidth(44)
		bc:SetHeight(44)

		bc:SetPoint("CENTER", point or self)
		--bc:SetPoint("TOPLEFT", -1, point or 1)
		--bc:SetPoint("BOTTOMRIGHT", 1, point or -1)
		self.oGlowBorder = bc
	end

	return bc
end

local borderDisplay = function(frame, color)
	if(color) then
		local bc = createBorder(frame)
		local rgb = colorTable[color]

		if(rgb) then
			--bc:SetVertexColor(rgb[1], rgb[2], rgb[3])
			bc:SetBackdropBorderColor(rgb[1], rgb[2], rgb[3])
			bc:Show()
		end

		return true
	elseif(frame.oGlowBorder) then
		frame.oGlowBorder:Hide()
	end
end

oGlow:RegisterDisplay('Border', borderDisplay)
