local S, C, L, DB = unpack(select(2, ...))
if DB.Nuke == true then return end
local Module = LibStub("AceAddon-3.0"):GetAddon("Core"):NewModule("Bar5", "AceEvent-3.0")
function Module:OnInitialize()
C = ActionBarDB 
if C["Big4Layout"] == 1 then

local barDB = DB.bars.bar5  
  local bar = CreateFrame("Frame","rABS_MultiBarLeft",UIParent, "SecureHandlerStateTemplate")

  bar:SetHitRectInsets(-DB.barinset, -DB.barinset, -DB.barinset, -DB.barinset)

  MultiBarLeft:SetParent(bar)

for i=1, 2 do
    local button = _G["MultiBarLeftButton"..i]
    button:ClearAllPoints()
    button:Size(C["ButtonSize"]*2)
    if i == 1 then
      button:Point("BOTTOMRIGHT", MultiBarBottomLeftButton1, "BOTTOMLEFT", -C["ButtonSpacing"]-2,0)
    else
      local previous = _G["MultiBarLeftButton"..i-1]      
      button:Point("RIGHT", previous, "LEFT", -C["ButtonSpacing"]-2, 0 )
    end
  end
  
  for i=3, 10 do
    local button = _G["MultiBarLeftButton"..i]
    button:ClearAllPoints()
  end
  
  for i=11, 12 do
    local button = _G["MultiBarLeftButton"..i]
    button:ClearAllPoints()
    button:Size(C["ButtonSize"]*2)
    if i == 11 then
      button:Point("TOPLEFT", MultiBarBottomRightButton12, "TOPRIGHT", C["ButtonSpacing"]+2,0)
    else
      local previous = _G["MultiBarLeftButton"..i-1]      
      button:Point("LEFT", previous, "RIGHT", C["ButtonSpacing"]+2, 0)
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