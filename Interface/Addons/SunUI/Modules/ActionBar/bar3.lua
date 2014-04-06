local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local

local AB = S:GetModule("ActionBar")

function AB:CreateBar3()
	
	local bar = CreateFrame("Frame","SunUIActionBar3",UIParent, "SecureHandlerStateTemplate")
	local bar2 = CreateFrame("Frame","SunUIActionBar3_2",UIParent, "SecureHandlerStateTemplate")
	if self.db.Bar3Layout == 1 then
		bar:SetWidth(self.db.ButtonSize*12+self.db.ButtonSpacing*11)
		bar:SetHeight(self.db.ButtonSize)
	else
		bar:SetWidth(self.db.ButtonSize*3+self.db.ButtonSpacing*2)
		bar:SetHeight(self.db.ButtonSize*2+self.db.ButtonSpacing)
		bar2:SetWidth(self.db.ButtonSize*3+self.db.ButtonSpacing*2)
		bar2:SetHeight(self.db.ButtonSize*2+self.db.ButtonSpacing)
	end

	if self.db.Bar3Layout == 1 then
		bar:SetPoint("BOTTOMRIGHT", "ActionBar1Mover", "BOTTOMLEFT", -4, 0)
	else
		bar:SetPoint("BOTTOMRIGHT", "ActionBar1Mover", "BOTTOMLEFT", -4, 0)
		bar2:SetPoint("BOTTOMLEFT", "ActionBar1Mover", "BOTTOMRIGHT", 4, 0)
	end


	MultiBarBottomRight:SetParent(bar)
	MultiBarBottomRight:EnableMouse(false)
	if self.db.Bar3Layout == 1 then
		for i=1, 12 do
			local button = _G["MultiBarBottomRightButton"..i]
			table.insert(AB.buttonList, button)
			button:SetSize(self.db.ButtonSize,self.db.ButtonSize)
			button:ClearAllPoints()
			if i == 1 then
				button:SetPoint("BOTTOMLEFT", bar, 0,0)
			else
				local previous = _G["MultiBarBottomRightButton"..i-1]     
				button:SetPoint("LEFT", previous, "RIGHT", self.db.ButtonSpacing, 0) 
			end
		end
		RegisterStateDriver(bar, "visibility", AB.visibility)
		S:CreateMover(bar, "ActionBar3Mover", L["右下动作条锚点"], true, nil, "ALL,ACTIONBARS")
	elseif self.db.Bar3Layout == 2 then
		for i = 1, 12 do
			button = _G["MultiBarBottomRightButton"..i]
			table.insert(AB.buttonList, button)
			button:SetSize(self.db.ButtonSize, self.db.ButtonSize)
			button:ClearAllPoints()
			if i == 1 then
				button:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 0, 0)
			elseif i <= 3 then
				button:SetPoint("RIGHT", _G["MultiBarBottomRightButton"..i-1], "LEFT", -self.db.ButtonSpacing, 0)
			elseif i == 4 then
				button:SetPoint("BOTTOMLEFT", _G["MultiBarBottomRightButton1"], "TOPLEFT", 0, self.db.ButtonSpacing)
			elseif i <= 6 then
				button:SetPoint("RIGHT", _G["MultiBarBottomRightButton"..i-1], "LEFT", -self.db.ButtonSpacing, 0)	
			elseif i == 7 then
				button:SetPoint("BOTTOMLEFT", bar2, "BOTTOMLEFT", 0, 0)
			elseif i <= 9 then
				button:SetPoint("LEFT", _G["MultiBarBottomRightButton"..i-1], "RIGHT", self.db.ButtonSpacing, 0)
			elseif i == 10 then
				button:SetPoint("BOTTOMLEFT", _G["MultiBarBottomRightButton7"], "TOPLEFT", 0, self.db.ButtonSpacing)
			elseif i <= 12 then
				button:SetPoint("LEFT", _G["MultiBarBottomRightButton"..i-1], "RIGHT", self.db.ButtonSpacing, 0)	
			end
		end
		RegisterStateDriver(bar, "visibility", AB.visibility)
		RegisterStateDriver(bar2, "visibility", AB.visibility)
		S:CreateMover(bar, "ActionBar3Mover", L["右下动作条锚点"], true, nil, "ALL,ACTIONBARS")
		S:CreateMover(bar2, "ActionBar3_2Mover", L["右下动作条锚点"], true, nil, "ALL,ACTIONBARS")
	end
end