local S, C, L, DB = unpack(select(2, ...))
if DB.Nuke == true then return end
local Module = LibStub("AceAddon-3.0"):GetAddon("Core"):NewModule("Bar3", "AceEvent-3.0")
local barDB = DB.bars.bar3  
  local bar = CreateFrame("Frame","SunUIActionBar3",UIParent, "SecureHandlerStateTemplate")
  function Module:OnInitialize()
  C = ActionBarDB
	local a1, af, a2, x, y = unpack(MoveHandleDB["bar3"]) 
  if C["Bar3Layout"] == 1 then
    bar:Width(C["ButtonSize"]*12+C["ButtonSpacing"]*13)
    bar:Height(C["ButtonSize"])
  end
  bar:SetScale(C["MainBarSacle"])
  if C["Bar3Layout"] == 1 then
    --bar:Point(a1,af,a2,x-((C["ButtonSize"]*6+C["ButtonSpacing"]*6)/2),y)
   MoveHandle.SunUIActionBar3 = S.MakeMove(bar, "SunUIActionBar3", "bar3", C["MainBarSacle"])
  end
  bar:SetHitRectInsets(-10, -10, -10, -10)
  
  
  
  MultiBarBottomRight:SetParent(bar)
 if C["Bar3Layout"] == 1 then
	  for i=1, 12 do
		local button = _G["MultiBarBottomRightButton"..i]
		button:Size(C["ButtonSize"], C["ButtonSize"])
		button:ClearAllPoints()
		if i == 1 then
		  button:Point("BOTTOMLEFT", bar, 0,0)
		else
		  local previous = _G["MultiBarBottomRightButton"..i-1]     
		  button:Point("LEFT", previous, "RIGHT", C["ButtonSpacing"], 0) 
		end
	  end
  end
	if C["Bar3Layout"] == 2 then
	for i = 1, 12 do
		Button = _G["MultiBarBottomRightButton"..i]
		Button:Size(C["ButtonSize"], C["ButtonSize"])
		Button:ClearAllPoints()
		if i == 1 then
				Button:Point("BOTTOMRIGHT", SunUIActionBar1, "BOTTOMLEFT", -C["ButtonSpacing"], 0)
			elseif i <= 3 then
				Button:Point("RIGHT", _G["MultiBarBottomRightButton"..i-1], "LEFT", -C["ButtonSpacing"], 0)
			elseif i == 4 then
				Button:Point("BOTTOMLEFT", _G["MultiBarBottomRightButton1"], "TOPLEFT", 0, C["ButtonSpacing"])
			elseif i <= 6 then
				Button:Point("RIGHT", _G["MultiBarBottomRightButton"..i-1], "LEFT", -C["ButtonSpacing"], 0)	
			elseif i == 7 then
				Button:Point("BOTTOMLEFT", SunUIActionBar1, "BOTTOMRIGHT", C["ButtonSpacing"], 0)
			elseif i <= 9 then
				Button:Point("LEFT", _G["MultiBarBottomRightButton"..i-1], "RIGHT", C["ButtonSpacing"], 0)
			elseif i == 10 then
				Button:Point("BOTTOMLEFT", _G["MultiBarBottomRightButton7"], "TOPLEFT", 0, C["ButtonSpacing"])
			elseif i <= 12 then
				Button:Point("LEFT", _G["MultiBarBottomRightButton"..i-1], "RIGHT", C["ButtonSpacing"], 0)	
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