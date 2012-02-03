local S, C, L, DB = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("Core"):NewModule("Bar3", "AceEvent-3.0")
local barDB = DB.bars.bar3  
  local bar = CreateFrame("Frame","rABS_MultiBarBottomRight",UIParent, "SecureHandlerStateTemplate")
  function Module:OnInitialize()
  C = ActionBarDB

  if C["Bar3Layout"] == 2 then
    bar:SetWidth(C["ButtonSize"]*6+C["ButtonSpacing"]*5)
    bar:SetHeight(C["ButtonSize"]*2+C["ButtonSpacing"])
  else  
    bar:SetWidth(C["ButtonSize"]*12+C["ButtonSpacing"]*11)
    bar:SetHeight(C["ButtonSize"])
  end
  if C["Bar3Layout"] == 2 then
    bar:SetPoint(C["bar3"].a1,C["bar3"].af,C["bar3"].a2,C["bar3"].x-((C["ButtonSize"]*6+C["ButtonSpacing"]*6)/2),C["bar3"].y)
  else 
    bar:SetPoint(C["bar3"].a1,C["bar3"].af,C["bar3"].a2,C["bar3"].x,C["bar3"].y)
  end
  bar:SetHitRectInsets(-DB.barinset, -DB.barinset, -DB.barinset, -DB.barinset)
  
  if barDB.testmode then
    bar:SetBackdrop(DB.backdrop)
    bar:SetBackdropColor(1,0.8,1,0.6)
  end
  bar:SetScale(C["MainBarSacle"])

  DB.applyDragFunctionality(bar,barDB.userplaced,barDB.locked)

  MultiBarBottomRight:SetParent(bar)
 
  for i=1, 12 do
    local button = _G["MultiBarBottomRightButton"..i]
    button:SetSize(C["ButtonSize"], C["ButtonSize"])
    button:ClearAllPoints()
    if i == 1 then
      button:SetPoint("BOTTOMLEFT", bar, 0,0)
    else
      local previous = _G["MultiBarBottomRightButton"..i-1]      
      if C["Bar3Layout"] == 2 and i == 7 then
        previous = _G["MultiBarBottomRightButton1"]
        button:SetPoint("BOTTOMLEFT", previous, "TOPLEFT", 0, C["ButtonSpacing"])
      else
        button:SetPoint("LEFT", previous, "RIGHT", C["ButtonSpacing"], 0)
      end
      
    end
  end
   end 
  if barDB.showonmouseover then    
    local function lighton(alpha)
      if MultiBarBottomRight:IsShown() then
        for i=1, 12 do
          local pb = _G["MultiBarBottomRightButton"..i]
          pb:SetAlpha(alpha)
        end
      end
    end    
    bar:EnableMouse(true)
    bar:SetScript("OnEnter", function(self) lighton(1) end)
    bar:SetScript("OnLeave", function(self) lighton(0) end)  
    for i=1, 12 do
      local pb = _G["MultiBarBottomRightButton"..i]
      pb:SetAlpha(0)
      pb:HookScript("OnEnter", function(self) lighton(1) end)
      pb:HookScript("OnLeave", function(self) lighton(0) end)
    end    
  end