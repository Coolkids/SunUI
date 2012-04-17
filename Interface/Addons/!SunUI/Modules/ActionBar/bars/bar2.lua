local S, C, L, DB = unpack(select(2, ...))
if DB.Nuke == true then return end
local Module = LibStub("AceAddon-3.0"):GetAddon("Core"):NewModule("Bar2", "AceEvent-3.0")
function Module:OnInitialize()
	C = ActionBarDB
	local bar = CreateFrame("Frame","SunUIActionBar2",UIParent, "SecureHandlerStateTemplate")
	if C["Bar2Layout"] == 2 then
		bar:SetWidth(C["ButtonSize"]*6+C["ButtonSpacing"]*5)
		bar:SetHeight(C["ButtonSize"]*2+C["ButtonSpacing"])
	else  
		bar:SetWidth(C["ButtonSize"]*12+C["ButtonSpacing"]*11)
		bar:SetHeight(C["ButtonSize"])
	end
	bar:SetScale(C["MainBarSacle"])
	MoveHandle.SunUIActionBar2 = S.MakeMove(bar, "SunUIActionBar2", "bar2", C["MainBarSacle"])
	bar:SetHitRectInsets(-10, -10, -10, -10)

	MultiBarBottomLeft:SetParent(bar)
	for i=1, 12 do
		local button = _G["MultiBarBottomLeftButton"..i]
		button:SetSize(C["ButtonSize"], C["ButtonSize"])
		button:ClearAllPoints()
		if i == 1 then
			button:SetPoint("BOTTOMLEFT", bar, 0,0)
		else
			local previous = _G["MultiBarBottomLeftButton"..i-1]      
			if C["Bar2Layout"] == 2 and i == 7 then
				previous = _G["MultiBarBottomLeftButton1"]
				button:SetPoint("BOTTOMLEFT", previous, "TOPLEFT", 0, C["ButtonSpacing"])
			else
				button:SetPoint("LEFT", previous, "RIGHT", C["ButtonSpacing"], 0)
			end
		end
	end
end 