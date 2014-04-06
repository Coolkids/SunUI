local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local

local AB = S:GetModule("ActionBar")

function AB:CreateBar2()
	local bar = CreateFrame("Frame","SunUIActionBar2",UIParent, "SecureHandlerStateTemplate")
	if self.db.Bar2Layout == 2 then
		bar:SetWidth(self.db.ButtonSize*6+self.db.ButtonSpacing*5)
		bar:SetHeight(self.db.ButtonSize*2+self.db.ButtonSpacing)
	else  
		bar:SetWidth(self.db.ButtonSize*12+self.db.ButtonSpacing*11)
		bar:SetHeight(self.db.ButtonSize)
	end
	bar:SetPoint("BOTTOM","ActionBar1Mover", "TOP",  0,  4)
	MultiBarBottomLeft:SetParent(bar)
	MultiBarBottomLeft:EnableMouse(false)

	for i=1, 12 do
		local button = _G["MultiBarBottomLeftButton"..i]
		table.insert(AB.buttonList, button)
		button:SetSize(self.db.ButtonSize, self.db.ButtonSize)
		button:ClearAllPoints()
		if i == 1 then
			button:SetPoint("BOTTOMLEFT", bar, 0,0)
		else
			local previous = _G["MultiBarBottomLeftButton"..i-1]      
			if self.db.Bar2Layout == 2 and i == 7 then
				previous = _G["MultiBarBottomLeftButton1"]
				button:SetPoint("BOTTOMLEFT", previous, "TOPLEFT", 0, self.db.ButtonSpacing)
			else
				button:SetPoint("LEFT", previous, "RIGHT", self.db.ButtonSpacing, 0)
			end
		end
	end
	
	RegisterStateDriver(bar, "visibility", AB.visibility)
	S:CreateMover(bar, "ActionBar2Mover", L["左下动作条锚点"], true, nil, "ALL,ACTIONBARS")
end