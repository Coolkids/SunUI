local S, C, L, DB = unpack(select(2, ...))
if DB.Nuke == true then return end
local Module = LibStub("AceAddon-3.0"):GetAddon("Core"):NewModule("stancebar", "AceEvent-3.0")
local barDB = DB.bars.totembar  
function Module:OnInitialize()
C = ActionBarDB  
	local a1, af, a2, x, y = unpack(MoveHandleDB["stancebar"]) 
    local num = NUM_SHAPESHIFT_SLOTS

    local bar = CreateFrame("Frame","SunUIStanceBar",UIParent, "SecureHandlerStateTemplate")
    bar:SetWidth(C["ButtonSize"]*6+C["ButtonSpacing"]*(6-1))
    bar:SetHeight(C["ButtonSize"])
    --bar:SetPoint(a1,af,a2,x,y)
    bar:SetHitRectInsets(-10, -10, -10, -10)
    
    bar:SetScale(C["StanceBarSacle"])
    MoveHandle.SunUIStanceBar = S.MakeMove(bar, "SunUI姿态栏", "stancebar", C["StanceBarSacle"])

    ShapeshiftBarFrame:SetParent(bar)
    ShapeshiftBarFrame:EnableMouse(false)
    
    for i=1, num do
      local button = _G["ShapeshiftButton"..i]
      button:SetSize(C["ButtonSize"], C["ButtonSize"])
      button:ClearAllPoints()
      if i == 1 then
        button:SetPoint("BOTTOMLEFT", bar, 0,0)
      else
        local previous = _G["ShapeshiftButton"..i-1]      
        button:SetPoint("LEFT", previous, "RIGHT", C["ButtonSpacing"], 0)
      end
    end
    
    local function rABS_MoveShapeshift()
      ShapeshiftButton1:SetPoint("BOTTOMLEFT", bar, 0,0)
    end
    hooksecurefunc("ShapeshiftBar_Update", rABS_MoveShapeshift);
    
 end     
    if barDB.showonmouseover then    
      local function lighton(alpha)
        if ShapeshiftBarFrame:IsShown() then
          for i=1, num do
            local pb = _G["ShapeshiftButton"..i]
            pb:SetAlpha(alpha)
          end
        end
      end    
      bar:EnableMouse(true)
      bar:SetScript("OnEnter", function(self) lighton(1) end)
      bar:SetScript("OnLeave", function(self) lighton(0) end)  
      for i=1, num do
        local pb = _G["ShapeshiftButton"..i]
        pb:SetAlpha(0)
        pb:HookScript("OnEnter", function(self) lighton(1) end)
        pb:HookScript("OnLeave", function(self) lighton(0) end)
      end    
    end