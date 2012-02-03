local S, C, L, DB = unpack(select(2, ...))
  rABS_Frames = {
    "rABS_MainMenuBar",
    "rABS_MultiBarBottomLeft",
    "rABS_MultiBarBottomRight",
    "rABS_MultiBarLeft",
    "rABS_MultiBarRight",
    "rABS_StanceBar",
    "rABS_PetBar",
    "rABS_VehicleExit",
    "rABS_Bags",
    "rABS_MicroMenu",
    "rABS_TotemBar",
    "rABS_ExtraActionBar",
  }
DB.applyDragFunctionality = function(f,userplaced,locked)
    --f:SetScript("OnDragStart", function(s) if IsAltKeyDown() and IsShiftKeyDown() then s:StartMoving() end end)
	f:SetScript("OnDragStart", function(s) s:StartMoving() end)
    f:SetScript("OnDragStop", function(s) s:StopMovingOrSizing() end)
    
    local t = f:CreateTexture(nil,"OVERLAY",nil,6)
    t:SetAllPoints(f)
    t:SetTexture(0,1,0)
    t:SetAlpha(0)
    f.dragtexture = t    
    f:SetHitRectInsets(-15,-15,-15,-15)
    f:SetClampedToScreen(true)
    
    if not userplaced then
      f:SetMovable(false)
    else
      f:SetMovable(true)
      f:SetUserPlaced(true)
      if not locked then
        f.dragtexture:SetAlpha(0.2)
        f:EnableMouse(true)
        f:RegisterForDrag("LeftButton")
        f:SetScript("OnEnter", function(s) 
          GameTooltip:SetOwner(s, "ANCHOR_TOP")
          GameTooltip:AddLine(s:GetName(), 0, 1, 0.5, 1, 1, 1)
          GameTooltip:AddLine(L["鼠标左键拖动我!"], 1, 1, 1, 1, 1, 1)
          GameTooltip:Show()
        end)
        f:SetScript("OnLeave", function(s) GameTooltip:Hide() end)
      else
        f.dragtexture:SetAlpha(0)
        f:EnableMouse(nil)
        f:RegisterForDrag(nil)
        f:SetScript("OnEnter", nil)
        f:SetScript("OnLeave", nil)
      end
    end  
  end
  function rABS_unlockFrames()
    for _, v in pairs(rABS_Frames) do
      f = _G[v]
      if f and f:IsUserPlaced() then
        --print(f:GetName())
        if f:IsShown() then
          f.state = "shown"
        else
          f.state = "hidden"
          f:Show()
        end
        f.dragtexture:SetAlpha(0.2)
        f:EnableMouse(true)
        f:RegisterForDrag("LeftButton")
        f:SetScript("OnEnter", function(s)
          GameTooltip:SetOwner(s, "ANCHOR_TOP")
          GameTooltip:AddLine(s:GetName(), 0, 1, 0.5, 1, 1, 1)
          GameTooltip:AddLine(L["鼠标左键拖动我!"], 1, 1, 1, 1, 1, 1)
          GameTooltip:Show()
        end)
        f:SetScript("OnLeave", function(s) GameTooltip:Hide() end)
      end
    end
  end

  function rABS_lockFrames()
    for _, v in pairs(rABS_Frames) do
      f = _G[v]
      if f and f:IsUserPlaced() then
        f.dragtexture:SetAlpha(0)
        f:EnableMouse(nil)
        f:RegisterForDrag(nil)
        f:SetScript("OnEnter", nil)
        f:SetScript("OnLeave", nil)
        if f.state == "hidden" then
          f:Hide()
        end
      end
    end
  end

  local function SlashCmd(cmd)
    if (cmd:match"unlock") then
      rABS_unlockFrames()
    elseif (cmd:match"lock") then
      rABS_lockFrames()
    end
  end

  SlashCmdList["rabs"] = SlashCmd;
  SLASH_rabs1 = "/ab";
