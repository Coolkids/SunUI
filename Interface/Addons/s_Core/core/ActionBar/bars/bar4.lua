local S, C, L, DB = unpack(select(2, ...))
if DB.Nuke == true then return end
local Module = LibStub("AceAddon-3.0"):GetAddon("Core"):NewModule("Bar4", "AceEvent-3.0")
local barDB = DB.bars.bar4  
  local bar = CreateFrame("Frame","SunUIActionBar4",UIParent, "SecureHandlerStateTemplate")
  function Module:OnInitialize()
  C = ActionBarDB
	local a1, af, a2, x, y = unpack(MoveHandleDB["bar4"]) 
  if C["Bar4Layout"] == 2 then
    bar:Width(C["ButtonSize"]*6+C["ButtonSpacing"]*5)
    bar:Height(C["ButtonSize"]*2+C["ButtonSpacing"])
  else  
    bar:Width(C["ButtonSize"])
    bar:Height(C["ButtonSize"]*12+C["ButtonSpacing"]*11+10)
  end
   bar:SetScale(C["MainBarSacle"])
  if C["Bar4Layout"] == 2 then
    --bar:Point(a1,af,a2,x+((C["ButtonSize"]*6+C["ButtonSpacing"]*6)/2),y-(C["ButtonSize"]*1+C["ButtonSpacing"]*1)+0.5)
   MoveHandle.SunUIActionBar4 = S.MakeMove(bar, "SunUIActionBar4", "bar4", C["MainBarSacle"])
  else 
   MoveHandle.SunUIActionBar4 = S.MakeMove(bar, "SunUIActionBar4", "bar4", C["MainBarSacle"])
  end
  bar:SetHitRectInsets(-DB.barinset, -DB.barinset, -DB.barinset, -DB.barinset)
  
 

  

  MultiBarRight:SetParent(bar)

 if C["Bar4Layout"] == 1 then
	 for i=1, 12 do
		local button = _G["MultiBarRightButton"..i]
		button:ClearAllPoints()
		button:Size(C["ButtonSize"], C["ButtonSize"])
			if i == 1 then
			  button:Point("TOPLEFT", bar, 0,0)
			else
			 local previous = _G["MultiBarRightButton"..i-1]
			 button:Point("TOP", previous, "BOTTOM", 0, -C["ButtonSpacing"])
			end
	 end
 end 
if C["Bar4Layout"] == 2 then 
	  for i=1, 12 do
		local button = _G["MultiBarRightButton"..i]
		button:ClearAllPoints()
		button:Size(C["ButtonSize"], C["ButtonSize"])
			if i == 1 then
				button:Point("TOPLEFT", bar, 0,0)	
			else
				local previous = _G["MultiBarRightButton"..i-1]
				if  i == 7 then
				previous = _G["MultiBarRightButton1"]
				button:Point("TOPLEFT", previous, "BOTTOMLEFT", 0, -C["ButtonSpacing"])
				else
				button:Point("LEFT", previous, "RIGHT", C["ButtonSpacing"], 0)
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