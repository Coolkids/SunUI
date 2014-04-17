local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local

local AB = S:GetModule("ActionBar")

function AB:CreateBar5()
	
	if self.db.Big4Layout == 1 then
		local bar51 = CreateFrame("Frame","SunUIMultiBarLeft1",UIParent, "SecureHandlerStateTemplate")
		local bar52 = CreateFrame("Frame","SunUIMultiBarLeft2",UIParent, "SecureHandlerStateTemplate")
		local bar53 = CreateFrame("Frame","SunUIMultiBarLeft3",UIParent, "SecureHandlerStateTemplate")
		local bar54 = CreateFrame("Frame","SunUIMultiBarLeft4",UIParent, "SecureHandlerStateTemplate")
		bar51:SetWidth(self.db.BigSize1)
		bar51:SetHeight(self.db.BigSize1)
		bar51:SetPoint("BOTTOM", "MultiBarBottomLeftButton4", "TOP", 0, 4)

		bar52:SetWidth(self.db.BigSize2)
		bar52:SetHeight(self.db.BigSize2)
		bar52:SetPoint("BOTTOM", "MultiBarBottomLeftButton5", "TOP", 0, 4)

		bar53:SetWidth(self.db.BigSize3)
		bar53:SetHeight(self.db.BigSize3)
		bar53:SetPoint("BOTTOMRIGHT", "MultiBarBottomRightButton3", "BOTTOMLEFT", -4, 0)

		bar54:SetWidth(self.db.BigSize4)
		bar54:SetHeight(self.db.BigSize4)
		bar54:SetPoint("BOTTOMLEFT", "MultiBarBottomRightButton9","BOTTOMRIGHT",  4,  0)

		MultiBarLeft:SetParent(bar51)
		MultiBarLeft:EnableMouse(false)
		for i=1, 4 do
			local button = _G["MultiBarLeftButton"..i]
			button:ClearAllPoints()
			button:SetSize(self.db["BigSize"..i], self.db["BigSize"..i])
			if i == 1 then
				button:SetAllPoints(bar51)
			elseif i == 2 then
				button:SetAllPoints(bar52)
			elseif i == 3 then
				button:SetAllPoints(bar53)
			else
				button:SetAllPoints(bar54)
			end
			if self.db["BigSize"..i] < 10 then
				button:ClearAllPoints()
				button:SetParent(S.HiddenFrame)
				--button:Kill()
			end
		end

		for i=5, 12 do
			local button = _G["MultiBarLeftButton"..i]
			button:ClearAllPoints()
			button:Kill()
		end
		if S:IsDeveloper() then 
			_G["MultiBarLeftButton1"]:ClearAllPoints()
			_G["MultiBarLeftButton2"]:ClearAllPoints()
		end
		RegisterStateDriver(bar51, "visibility", AB.visibility)
		RegisterStateDriver(bar52, "visibility", AB.visibility)
		RegisterStateDriver(bar53, "visibility", AB.visibility)
		RegisterStateDriver(bar54, "visibility", AB.visibility)
		S:CreateMover(bar51, "ActionBar5_1Mover", L["大动作条锚点"].."1", true, nil, "ALL,ACTIONBARS")
		S:CreateMover(bar52, "ActionBar5_2Mover", L["大动作条锚点"].."2", true, nil, "ALL,ACTIONBARS")
		S:CreateMover(bar53, "ActionBar5_3Mover", L["大动作条锚点"].."3", true, nil, "ALL,ACTIONBARS")
		S:CreateMover(bar54, "ActionBar5_4Mover", L["大动作条锚点"].."4", true, nil, "ALL,ACTIONBARS")
	elseif self.db.Big4Layout == 2 then
		local bar = CreateFrame("Frame","SunUIActionBar5",UIParent, "SecureHandlerStateTemplate")
		if self.db.Bar5Layout == 2 then
			bar:SetWidth(self.db.ButtonSize*6+self.db.ButtonSpacing*5)
			bar:SetHeight(self.db.ButtonSize*2+self.db.ButtonSpacing)
		else  
			bar:SetWidth(self.db.ButtonSize)
			bar:SetHeight(self.db.ButtonSize*12+self.db.ButtonSpacing*11)
		end
		bar:SetPoint("RIGHT","UIParent", "RIGHT", -40, 0)

		MultiBarLeft:SetParent(bar)
		MultiBarLeft:EnableMouse(false)
		if self.db.Bar5Layout == 1 then 
			for i=1, 12 do
				local button = _G["MultiBarLeftButton"..i]
				table.insert(AB.buttonList, button)
				button:ClearAllPoints()
				button:SetSize(self.db.ButtonSize, self.db.ButtonSize)
					if i == 1 then
						button:SetPoint("TOPLEFT", bar, 0,0)
					else
						local previous = _G["MultiBarLeftButton"..i-1]
						button:SetPoint("TOP", previous, "BOTTOM", 0, -self.db.ButtonSpacing)
					end
			end
		elseif self.db.Bar5Layout == 2 then 
			for i=1, 12 do
				local button = _G["MultiBarLeftButton"..i]
				table.insert(AB.buttonList, button)
				button:ClearAllPoints()
				button:SetSize(self.db.ButtonSize, self.db.ButtonSize)
				if i == 1 then
					button:SetPoint("TOPLEFT", bar, 0,0)	
				else
					local previous = _G["MultiBarLeftButton"..i-1]
					if  i == 7 then
						previous = _G["MultiBarLeftButton1"]
						button:SetPoint("TOPLEFT", previous, "BOTTOMLEFT", 0, -self.db.ButtonSpacing)
					else
						button:SetPoint("LEFT", previous, "RIGHT", self.db.ButtonSpacing, 0)
					end
				end
			end
		end
		RegisterStateDriver(bar, "visibility", AB.visibility)
		S:CreateMover(bar, "ActionBar5Mover", L["右1动作条锚点"], true, nil, "ALL,ACTIONBARS")
	end
end