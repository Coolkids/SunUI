local S, L, DB, _, C = unpack(select(2, ...))

local colorTable = setmetatable(
	{},
	{__index = function(self, val)
		local r, g, b = GetItemQualityColor(val)
		rawset(self, val, {r, g, b})

		return self[val]
	end}
)

local createBorder = function(self, point)
	local bc = self.oGlowBorder
	if not bc then
		if(not self:IsObjectType'Frame') then
			bc = CreateFrame("Frame", nil, self:GetParent())
		else
			bc = CreateFrame("Frame", nil, self)
		end
		bc:SetBackdrop({
			edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
			edgeSize = S.mult, 
		})
		bc:SetAllPoints(self)
		self.oGlowBorder = bc
	end
	return bc
end

local borderDisplay = function(frame, color)
	if color then
		local bc = createBorder(frame)
		local rgb = colorTable[color]

		if rgb then
			bc:SetBackdropBorderColor(rgb[1], rgb[2], rgb[3])
			bc:Show()
		end

		return true
	elseif frame.oGlowBorder then
		frame.oGlowBorder:Hide()
	end
end

function oGlow:RegisterColor(name, r, g, b)
	if(rawget(colorTable, name)) then
		return nil, string.format("Color [%s] is already registered.", name)
	else
		rawset(colorTable, name, {r, g, b})
	end

	return true
end

oGlow:RegisterDisplay("Border", borderDisplay)