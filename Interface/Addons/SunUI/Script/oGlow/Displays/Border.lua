local _, ns = ...
local oGlow = ns.oGlow
local S, _, _, _ = unpack(select(2, ...))
local argcheck = oGlow.argcheck
local colorTable = ns.colorTable

local createBorder = function(self, point)
	local bc = self.oGlowBorder
	if(not bc) then
		if(not self:IsObjectType'Frame') then
			bc = CreateFrame("Frame", nil, self:GetParent())
		else
			bc = CreateFrame("Frame", nil, self)
		end
		bc:SetBackdrop({
			edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",   --, 
			edgeSize = S.mult+0.2, 
		})
		bc:SetAllPoints(self)
		self.oGlowBorder = bc
	end

	return bc
end

local borderDisplay = function(frame, color)
	if(color) then
		local bc = createBorder(frame)
		local rgb = colorTable[color]

		if(rgb) then
			bc:SetBackdropBorderColor(rgb[1], rgb[2], rgb[3])
			bc:Show()
		end

		return true
	elseif(frame.oGlowBorder) then
		frame.oGlowBorder:Hide()
	end
end

oGlow:RegisterDisplay('Border', borderDisplay)
