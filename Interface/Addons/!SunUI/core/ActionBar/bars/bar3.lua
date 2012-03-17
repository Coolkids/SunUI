local S, C, L, DB = unpack(select(2, ...))
if DB.Nuke == true then return end
local Module = LibStub("AceAddon-3.0"):GetAddon("Core"):NewModule("Bar3", "AceEvent-3.0")
local barDB = DB.bars.bar3  
  local bar = CreateFrame("Frame","SunUIActionBar3",UIParent, "SecureHandlerStateTemplate")
  local bar2 = CreateFrame("Frame","SunUIActionBar32",UIParent, "SecureHandlerStateTemplate")
  function Module:OnInitialize()
  C = ActionBarDB
	local a1, af, a2, x, y = unpack(MoveHandleDB["bar3"]) 
  if C["Bar3Layout"] == 1 then
    bar:SetWidth(C["ButtonSize"]*12+C["ButtonSpacing"]*11)
    bar:SetHeight(C["ButtonSize"])
	else
	bar:SetWidth(C["ButtonSize"]*3+C["ButtonSpacing"]*2)
    bar:SetHeight(C["ButtonSize"]*2+C["ButtonSpacing"])
	bar2:SetWidth(C["ButtonSize"]*3+C["ButtonSpacing"]*2)
    bar2:SetHeight(C["ButtonSize"]*2+C["ButtonSpacing"])
	bar2:SetScale(C["MainBarSacle"])
  end
  bar:SetScale(C["MainBarSacle"])
  
  if C["Bar3Layout"] == 1 then
    --bar:SetPoint(a1,af,a2,x-((C["ButtonSize"]*6+C["ButtonSpacing"]*6)/2),y)
   MoveHandle.SunUIActionBar3 = S.MakeMove(bar, "SunUIActionBar3", "bar3", C["MainBarSacle"])
   else
   MoveHandle.SunUIActionBar3 = S.MakeMove(bar, "SunUIActionBar3", "bar3", C["MainBarSacle"])
   MoveHandle.SunUIActionBar32 = S.MakeMove(bar2, "SunUIActionBar3", "bar32", C["MainBarSacle"])
  end
  bar:SetHitRectInsets(-10, -10, -10, -10)
  
  
  
  MultiBarBottomRight:SetParent(bar)
 if C["Bar3Layout"] == 1 then
	  for i=1, 12 do
		local button = _G["MultiBarBottomRightButton"..i]
		button:SetSize(C["ButtonSize"], C["ButtonSize"])
		button:ClearAllPoints()
		if i == 1 then
		  button:SetPoint("BOTTOMLEFT", bar, 0,0)
		else
		  local previous = _G["MultiBarBottomRightButton"..i-1]     
		  button:SetPoint("LEFT", previous, "RIGHT", C["ButtonSpacing"], 0) 
		end
	  end
  end
	if C["Bar3Layout"] == 2 then
	for i = 1, 12 do
		Button = _G["MultiBarBottomRightButton"..i]
		Button:SetSize(C["ButtonSize"], C["ButtonSize"])
		Button:ClearAllPoints()
		if i == 1 then
				Button:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 0, 0)
			elseif i <= 3 then
				Button:SetPoint("RIGHT", _G["MultiBarBottomRightButton"..i-1], "LEFT", -C["ButtonSpacing"], 0)
			elseif i == 4 then
				Button:SetPoint("BOTTOMLEFT", _G["MultiBarBottomRightButton1"], "TOPLEFT", 0, C["ButtonSpacing"])
			elseif i <= 6 then
				Button:SetPoint("RIGHT", _G["MultiBarBottomRightButton"..i-1], "LEFT", -C["ButtonSpacing"], 0)	
			elseif i == 7 then
				Button:SetPoint("BOTTOMLEFT", bar2, "BOTTOMLEFT", 0, 0)
			elseif i <= 9 then
				Button:SetPoint("LEFT", _G["MultiBarBottomRightButton"..i-1], "RIGHT", C["ButtonSpacing"], 0)
			elseif i == 10 then
				Button:SetPoint("BOTTOMLEFT", _G["MultiBarBottomRightButton7"], "TOPLEFT", 0, C["ButtonSpacing"])
			elseif i <= 12 then
				Button:SetPoint("LEFT", _G["MultiBarBottomRightButton"..i-1], "RIGHT", C["ButtonSpacing"], 0)	
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