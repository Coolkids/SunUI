local S, C, L, DB = unpack(SunUI)
 
local Module = LibStub("AceAddon-3.0"):GetAddon("Core"):NewModule("Bar5", "AceEvent-3.0")
function Module:OnInitialize()
	C = C["ActionBarDB"]
	if C["Big4Layout"] == 1 then
		local bar51 = CreateFrame("Frame","SunUIMultiBarLeft1",UIParent, "SecureHandlerStateTemplate")
		local bar52 = CreateFrame("Frame","SunUIMultiBarLeft2",UIParent, "SecureHandlerStateTemplate")
		local bar53 = CreateFrame("Frame","SunUIMultiBarLeft3",UIParent, "SecureHandlerStateTemplate")
		local bar54 = CreateFrame("Frame","SunUIMultiBarLeft4",UIParent, "SecureHandlerStateTemplate")
		bar51:SetWidth(C["BigSize1"])
		bar51:SetHeight(C["BigSize1"])
		bar51:SetHitRectInsets(-10, -10, -10, -10)
		MoveHandle.SunUIMultiBarLeft1 = S.MakeMove(bar51, "SunUIBigActionBar1", "bar51", 1)
			
		bar52:SetWidth(C["BigSize2"])
		bar52:SetHeight(C["BigSize2"])
		bar52:SetHitRectInsets(-10, -10, -10, -10)
		MoveHandle.SunUIMultiBarLeft2 = S.MakeMove(bar52, "SunUIBigActionBar2", "bar52", 1)
			
		bar53:SetWidth(C["BigSize3"])
		bar53:SetHeight(C["BigSize3"])
		bar53:SetHitRectInsets(-10, -10, -10, -10)
		MoveHandle.SunUIMultiBarLeft3 = S.MakeMove(bar53, "SunUIBigActionBar3", "bar53", 1)
			
		bar54:SetWidth(C["BigSize4"])
		bar54:SetHeight(C["BigSize4"])
		bar54:SetHitRectInsets(-10, -10, -10, -10)
		MoveHandle.SunUIMultiBarLeft4 = S.MakeMove(bar54, "SunUIBigActionBar4", "bar54", 1)

		MultiBarLeft:SetParent(bar51)
		for i=1, 2 do
			local button = _G["MultiBarLeftButton"..i]
			button:ClearAllPoints()
			button:SetSize(C["BigSize"..i], C["BigSize"..i])
			if i == 1 then
				button:SetAllPoints(bar51)
			else
				button:SetAllPoints(bar52)
			end
		end
		  
		for i=3, 10 do
			local button = _G["MultiBarLeftButton"..i]
			button:ClearAllPoints()
		 end
		  
		for i=11, 12 do
			local button = _G["MultiBarLeftButton"..i]
			button:ClearAllPoints()
			local b = 0
			b = i - 8
			button:SetSize(C["BigSize"..b], C["BigSize"..b])
			if i == 11 then
				button:SetAllPoints(bar53)
			else
				button:SetAllPoints(bar54)
			end
		end
	elseif C["Big4Layout"] == 2 then
	
		local bar = CreateFrame("Frame","SunUIActionBar5",UIParent, "SecureHandlerStateTemplate")
		if C["Bar5Layout"] == 2 then
			bar:SetWidth(C["ButtonSize"]*6+C["ButtonSpacing"]*5)
			bar:SetHeight(C["ButtonSize"]*2+C["ButtonSpacing"])
		else  
			bar:SetWidth(C["ButtonSize"])
			bar:SetHeight(C["ButtonSize"]*12+C["ButtonSpacing"]*11)
		end
		MoveHandle.SunUIActionBar5 = S.MakeMove(bar, "SunUIActionBar5", "bar5", C["MainBarSacle"])
		bar:SetHitRectInsets(-10, -10, -10, -10)
  
		bar:SetScale(C["MainBarSacle"])

		MultiBarLeft:SetParent(bar)
		if C["Bar5Layout"] == 1 then 
			for i=1, 12 do
				local button = _G["MultiBarLeftButton"..i]
				button:ClearAllPoints()
				button:SetSize(C["ButtonSize"], C["ButtonSize"])
					if i == 1 then
						button:SetPoint("TOPLEFT", bar, 0,0)
					else
						local previous = _G["MultiBarLeftButton"..i-1]
						button:SetPoint("TOP", previous, "BOTTOM", 0, -C["ButtonSpacing"])
					end
			end
		end
		if C["Bar5Layout"] == 2 then 
			for i=1, 12 do
				local button = _G["MultiBarLeftButton"..i]
				button:ClearAllPoints()
				button:SetSize(C["ButtonSize"], C["ButtonSize"])
				if i == 1 then
					button:SetPoint("TOPLEFT", bar, 0,0)	
				else
					local previous = _G["MultiBarLeftButton"..i-1]
					if  i == 7 then
						previous = _G["MultiBarLeftButton1"]
						button:SetPoint("TOPLEFT", previous, "BOTTOMLEFT", 0, -C["ButtonSpacing"])
					else
						button:SetPoint("LEFT", previous, "RIGHT", C["ButtonSpacing"], 0)
					end
				end
			end
		end
	end
end