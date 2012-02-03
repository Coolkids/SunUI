local S, C, L, DB = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("Core"):NewModule("Bar4", "AceEvent-3.0")
local barDB = DB.bars.bar4  
  local bar = CreateFrame("Frame","rABS_MultiBarRight",UIParent, "SecureHandlerStateTemplate")
  function Module:OnInitialize()
  C = ActionBarDB

  if C["Bar4Layout"] == 2 then
    bar:SetWidth(C["ButtonSize"]*6+C["ButtonSpacing"]*5)
    bar:SetHeight(C["ButtonSize"]*2+C["ButtonSpacing"])
  else  
    bar:SetWidth(C["ButtonSize"])
    bar:SetHeight(C["ButtonSize"]*12+C["ButtonSpacing"]*11)
  end
  if C["Bar4Layout"] == 2 then
    bar:SetPoint(C["bar4"].a1,C["bar4"].af,C["bar4"].a2,C["bar4"].x+((C["ButtonSize"]*6+C["ButtonSpacing"]*6)/2),C["bar4"].y-(C["ButtonSize"]*1+C["ButtonSpacing"]*1)+0.5)
  else 
    bar:SetPoint(C["bar4"].a1,C["bar4"].af,C["bar4"].a2,C["bar4"].x,C["bar4"].y)
  end
  bar:SetHitRectInsets(-DB.barinset, -DB.barinset, -DB.barinset, -DB.barinset)
  
  if barDB.testmode then
    bar:SetBackdrop(DB.backdrop)
    bar:SetBackdropColor(1,0.8,1,0.6)
  end
  bar:SetScale(C["MainBarSacle"])

  DB.applyDragFunctionality(bar,barDB.userplaced,barDB.locked)

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
 
 
  if barDB.showonmouseover then    
    local function lighton(alpha)
      if MultiBarRight:IsShown() then
        for i=1, 12 do
          local pb = _G["MultiBarRightButton"..i]
          pb:SetAlpha(alpha)
        end
      end
    end    
    bar:EnableMouse(true)
    bar:SetScript("OnEnter", function(self) lighton(1) end)
    bar:SetScript("OnLeave", function(self) lighton(0) end)  
    for i=1, 12 do
      local pb = _G["MultiBarRightButton"..i]
      pb:SetAlpha(0)
      pb:HookScript("OnEnter", function(self) lighton(1) end)
      pb:HookScript("OnLeave", function(self) lighton(0) end)
    end    
  end
end