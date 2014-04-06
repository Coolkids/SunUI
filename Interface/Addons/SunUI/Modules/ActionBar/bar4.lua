local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local

local AB = S:GetModule("ActionBar")

function AB:CreateBar4()
	
	local bar = CreateFrame("Frame","SunUIActionBar4",UIParent, "SecureHandlerStateTemplate")
	if self.db.Bar4Layout == 2 then
		bar:SetWidth(self.db.ButtonSize*6+self.db.ButtonSpacing*5)
		bar:SetHeight(self.db.ButtonSize*2+self.db.ButtonSpacing)
	else  
		bar:SetWidth(self.db.ButtonSize)
		bar:SetHeight(self.db.ButtonSize*12+self.db.ButtonSpacing*11)
	end
	bar:SetPoint("RIGHT", "UIParent", "RIGHT", -10, 0)

	MultiBarRight:SetParent(bar)
	MultiBarRight:EnableMouse(false)

	if self.db.Bar4Layout == 1 then
		for i=1, 12 do
			local button = _G["MultiBarRightButton"..i]
			table.insert(AB.buttonList, button)
			button:ClearAllPoints()
			button:SetSize(self.db.ButtonSize, self.db.ButtonSize)
				if i == 1 then
					button:SetPoint("TOPLEFT", bar, 0,0)
				else
					local previous = _G["MultiBarRightButton"..i-1]
					button:SetPoint("TOP", previous, "BOTTOM", 0, -self.db.ButtonSpacing)
				end
		end
	elseif self.db.Bar4Layout == 2 then 
		for i=1, 12 do
			local button = _G["MultiBarRightButton"..i]
			table.insert(AB.buttonList, button)
			button:ClearAllPoints()
			button:SetSize(self.db.ButtonSize, self.db.ButtonSize)
				if i == 1 then
					button:SetPoint("TOPLEFT", bar, 0,0)	
				else
					local previous = _G["MultiBarRightButton"..i-1]
					if  i == 7 then
					previous = _G["MultiBarRightButton1"]
					button:SetPoint("TOPLEFT", previous, "BOTTOMLEFT", 0, -self.db.ButtonSpacing)
					else
					button:SetPoint("LEFT", previous, "RIGHT", self.db.ButtonSpacing, 0)
					end
				end
		end
	end
	RegisterStateDriver(bar, "visibility", AB.visibility)
	S:CreateMover(bar, "ActionBar4Mover", L["右2动作条锚点"], true, nil, "ALL,ACTIONBARS")
end