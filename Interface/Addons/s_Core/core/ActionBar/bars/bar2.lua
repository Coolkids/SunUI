local S, C, L, DB = unpack(select(2, ...))
if DB.Nuke == true then return end
local Module = LibStub("AceAddon-3.0"):GetAddon("Core"):NewModule("Bar2", "AceEvent-3.0")
local barDB = DB.bars.bar1  
  local bar = CreateFrame("Frame","SunUIActionBar2",UIParent, "SecureHandlerStateTemplate")
function Module:OnInitialize()
C = ActionBarDB
	local a1, af, a2, x, y = unpack(MoveHandleDB["bar2"]) 
  if C["Bar2Layout"] == 2 then
    bar:Width(C["ButtonSize"]*6+C["ButtonSpacing"]*5)
    bar:Height(C["ButtonSize"]*2+C["ButtonSpacing"])
  else  
    bar:Width(C["ButtonSize"]*12+C["ButtonSpacing"]*11+10)
    bar:Height(C["ButtonSize"])
  end
  bar:SetScale(C["MainBarSacle"])
  if C["Bar2Layout"] == 2 then
    --bar:Point(a1,af,a2,x+((C["ButtonSize"]*6+C["ButtonSpacing"]*6)/2),y-(C["ButtonSize"]*1+C["ButtonSpacing"]*1)+0.5)
	MoveHandle.SunUIActionBar2 = S.MakeMove(bar, "SunUIActionBar2", "bar2", C["MainBarSacle"])
  else 
   MoveHandle.SunUIActionBar2 = S.MakeMove(bar, "SunUIActionBar2", "bar2", C["MainBarSacle"])
  end
  bar:SetHitRectInsets(-DB.barinset, -DB.barinset, -DB.barinset, -DB.barinset)

  MultiBarBottomLeft:SetParent(bar)

  for i=1, 12 do
    local button = _G["MultiBarBottomLeftButton"..i]
    button:Size(C["ButtonSize"], C["ButtonSize"])
    button:ClearAllPoints()
    if i == 1 then
      button:Point("BOTTOMLEFT", bar, 0,0)
    else
      local previous = _G["MultiBarBottomLeftButton"..i-1]      
      if C["Bar2Layout"] == 2 and i == 7 then
        previous = _G["MultiBarBottomLeftButton1"]
        button:Point("BOTTOMLEFT", previous, "TOPLEFT", 0, C["ButtonSpacing"])
      else
        button:Point("LEFT", previous, "RIGHT", C["ButtonSpacing"], 0)
      end
      
    end
  end
  
  if barDB.showonmouseover then    
    local function lighton(alpha)
      if MultiBarBottomLeft:IsShown() then
        for i=1, 12 do
          local pb = _G["MultiBarBottomLeftButton"..i]
          pb:SetAlpha(alpha)
        end
      end
    end    
    bar:EnableMouse(true)
    bar:SetScript("OnEnter", function(self) lighton(1) end)
    bar:SetScript("OnLeave", function(self) lighton(0) end)  
    for i=1, 12 do
      local pb = _G["MultiBarBottomLeftButton"..i]
      pb:SetAlpha(0)
      pb:HookScript("OnEnter", function(self) lighton(1) end)
      pb:HookScript("OnLeave", function(self) lighton(0) end)
    end    
end
 end 