local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local

local AB = S:GetModule("ActionBar")

function AB:CreateBar1()
	local bar = CreateFrame("Frame","SunUIActionBar1",UIParent, "SecureHandlerStateTemplate")
	if self.db.Bar1Layout == 2 then
		bar:SetWidth(self.db.ButtonSize*6+self.db.ButtonSpacing*5)
		bar:SetHeight(self.db.ButtonSize*2+self.db.ButtonSpacing)
	else
		bar:SetWidth(self.db.ButtonSize*12+self.db.ButtonSpacing*11)
		bar:SetHeight(self.db.ButtonSize)
	end
	bar:SetPoint("BOTTOM", "UIParent", "BOTTOM", 0, 13)
	MainMenuBarArtFrame:SetParent(bar)
	MainMenuBarArtFrame:EnableMouse(false)

	for i = 1, 12 do
		local button = _G["ActionButton"..i]
		button:SetSize(self.db.ButtonSize, self.db.ButtonSize)
		button:ClearAllPoints()
		table.insert(AB.buttonList, button)
		if i == 1 then
			button:Point("BOTTOMLEFT", bar, 0,0)
		else
			local previous = _G["ActionButton"..i-1]
			if self.db.Bar1Layout == 2 and i == 7 then
				previous = _G["ActionButton1"]
				button:SetPoint("BOTTOMLEFT", previous, "TOPLEFT", 0, self.db.ButtonSpacing)
			else
				button:SetPoint("LEFT", previous, "RIGHT", self.db.ButtonSpacing, 0)
			end
		end
	end
	RegisterStateDriver(bar, "visibility", AB.visibility)
	S:CreateMover(bar, "ActionBar1Mover", L["主动作条锚点"], true, nil, "ALL,ACTIONBARS")
end