local S, C, L, DB = unpack(select(2, ...))
if DB.Nuke == true then return end
local Module = LibStub("AceAddon-3.0"):GetAddon("Core"):NewModule("Bar4", "AceEvent-3.0")
function Module:OnInitialize()
	C = ActionBarDB
	local bar = CreateFrame("Frame","SunUIActionBar4",UIParent, "SecureHandlerStateTemplate")
	 if C["Bar4Layout"] == 2 then
		bar:SetWidth(C["ButtonSize"]*6+C["ButtonSpacing"]*5)
		bar:SetHeight(C["ButtonSize"]*2+C["ButtonSpacing"])
	 else  
		bar:SetWidth(C["ButtonSize"])
		bar:SetHeight(C["ButtonSize"]*12+C["ButtonSpacing"]*11)
	 end
		bar:SetScale(C["MainBarSacle"])
		bar:SetHitRectInsets(-10, -10, -10, -10)
	MoveHandle.SunUIActionBar4 = S.MakeMove(bar, "SunUIActionBar4", "bar4", C["MainBarSacle"])
	MultiBarRight:SetParent(bar)

	if C["Bar4Layout"] == 1 then
		for i=1, 12 do
			local button = _G["MultiBarRightButton"..i]
			button:ClearAllPoints()
			button:SetSize(C["ButtonSize"], C["ButtonSize"])
				if i == 1 then
					button:SetPoint("TOPLEFT", bar, 0,0)
				else
					local previous = _G["MultiBarRightButton"..i-1]
					button:SetPoint("TOP", previous, "BOTTOM", 0, -C["ButtonSpacing"])
				end
		end
	end 
	if C["Bar4Layout"] == 2 then 
		for i=1, 12 do
			local button = _G["MultiBarRightButton"..i]
			button:ClearAllPoints()
			button:SetSize(C["ButtonSize"], C["ButtonSize"])
				if i == 1 then
					button:SetPoint("TOPLEFT", bar, 0,0)	
				else
					local previous = _G["MultiBarRightButton"..i-1]
					if  i == 7 then
					previous = _G["MultiBarRightButton1"]
					button:SetPoint("TOPLEFT", previous, "BOTTOMLEFT", 0, -C["ButtonSpacing"])
					else
					button:SetPoint("LEFT", previous, "RIGHT", C["ButtonSpacing"], 0)
					end
				end
		end
	end
end