local S, C, L, DB = unpack(select(2, ...))
if DB.Nuke == true then return end
local Module = LibStub("AceAddon-3.0"):GetAddon("Core"):NewModule("Bar6", "AceEvent-3.0")
function Module:OnInitialize()
C = ActionBarDB 
if C["Big4Layout"] == 2 then
  local barDB = DB.bars.bar5
  local bar = CreateFrame("Frame","rABS_MultiBarLeft",UIParent, "SecureHandlerStateTemplate")


  if C["Bar5Layout"] == 2 then
    bar:SetWidth(C["ButtonSize"]*6+C["ButtonSpacing"]*5)
    bar:SetHeight(C["ButtonSize"]*2+C["ButtonSpacing"])
  else  
    bar:SetWidth(C["ButtonSize"])
    bar:SetHeight(C["ButtonSize"]*12+C["ButtonSpacing"]*11)
  end
  if C["Bar5Layout"] == 2 then
    bar:SetPoint(C["bar5"].a1,C["bar5"].af,C["bar5"].a2,C["bar5"].x+((C["ButtonSize"]*6+C["ButtonSpacing"]*6)/2),C["bar5"].y-(C["ButtonSize"]*1+C["ButtonSpacing"]*1)+0.5)
  else 
    bar:SetPoint(C["bar5"].a1,C["bar5"].af,C["bar5"].a2,C["bar5"].x,C["bar5"].y)
  end
  bar:SetHitRectInsets(-DB.barinset, -DB.barinset, -DB.barinset, -DB.barinset)
  
  if barDB.testmode then
    bar:SetBackdrop(DB.backdrop)
    bar:SetBackdropColor(1,0.8,1,0.6)
  end
  bar:SetScale(C["MainBarSacle"])

  DB.applyDragFunctionality(bar,barDB.userplaced,barDB.locked)

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
		
  if barDB.showonmouseover then    
    local function lighton(alpha)
      if MultiBarLeft:IsShown() then
        for i=1, 12 do
          local pb = _G["MultiBarLeftButton"..i]
          pb:SetAlpha(alpha)
        end
      end
    end    
    bar:EnableMouse(true)
    bar:SetScript("OnEnter", function(self) lighton(1) end)
    bar:SetScript("OnLeave", function(self) lighton(0) end)  
    for i=1, 12 do
      local pb = _G["MultiBarLeftButton"..i]
      pb:SetAlpha(0)
      pb:HookScript("OnEnter", function(self) lighton(1) end)
      pb:HookScript("OnLeave", function(self) lighton(0) end)
    end    
  end
  end
 end 