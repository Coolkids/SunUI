local S, C, L, DB = unpack(select(2, ...))
if DB.Nuke == true then return end
local Module = LibStub("AceAddon-3.0"):GetAddon("Core"):NewModule("Bar5", "AceEvent-3.0")
function Module:OnInitialize()
C = ActionBarDB 
if C["Big4Layout"] == 1 then

local barDB = DB.bars.bar5  
  local bar = CreateFrame("Frame","rABS_MultiBarLeft",UIParent, "SecureHandlerStateTemplate")
  bar:SetHeight(C["ButtonSize"]*12+C["ButtonSpacing"]*11)
  bar:SetWidth(C["ButtonSize"])
  bar:SetPoint(C["bar5"].a1,C["bar5"].af,C["bar5"].a2,C["bar5"].x,C["bar5"].y)
  bar:SetHitRectInsets(-DB.barinset, -DB.barinset, -DB.barinset, -DB.barinset)
  
  if barDB.testmode then
    bar:SetBackdrop(DB.backdrop)
    bar:SetBackdropColor(1,0.8,1,0.6)
  end
  bar:SetScale(C["MainBarSacle"])

  DB.applyDragFunctionality(bar,barDB.userplaced,barDB.locked)

  MultiBarLeft:SetParent(bar)

for i=1, 2 do
    local button = _G["MultiBarLeftButton"..i]
    button:ClearAllPoints()
    button:SetSize(C["ButtonSize"], C["ButtonSize"])
    button:SetScale(C["MainBarSacle"]+S.Scale(1)/2+0.1)
    if i == 1 then
      button:SetPoint("RIGHT", MultiBarBottomLeftButton1, "LEFT", -C["ButtonSpacing"],(C["ButtonSize"]+C["ButtonSpacing"])/2)
    else
      local previous = _G["MultiBarLeftButton"..i-1]      
      button:SetPoint("TOP", previous, "BOTTOM", 0, -C["ButtonSpacing"])
    end
  end
  
  for i=3, 10 do
    local button = _G["MultiBarLeftButton"..i]
    button:ClearAllPoints()
  end
  
  for i=11, 12 do
    local button = _G["MultiBarLeftButton"..i]
    button:ClearAllPoints()
    button:SetSize(C["ButtonSize"], C["ButtonSize"])
    button:SetScale(C["MainBarSacle"]+S.Scale(1)/2+0.1)
    if i == 11 then
      button:SetPoint("LEFT", MultiBarBottomLeftButton12, "RIGHT", C["ButtonSpacing"],(C["ButtonSize"]+C["ButtonSpacing"])/2)
    else
      local previous = _G["MultiBarLeftButton"..i-1]      
      button:SetPoint("TOP", previous, "BOTTOM", 0, -C["ButtonSpacing"])
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