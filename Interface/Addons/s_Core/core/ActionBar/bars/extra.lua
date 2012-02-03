local S, C, L, DB = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("Core"):NewModule("extra", "AceEvent-3.0")
local barDB = DB.bars.extrabar
  local bar = CreateFrame("Frame","rABS_ExtraActionBar",UIParent,"SecureHandlerStateTemplate")
  function Module:OnInitialize()
  C = ActionBarDB

  bar:SetSize(C["ButtonSize"],C["ButtonSize"])
  bar:SetPoint(C["extrabar"].a1,C["extrabar"].af,C["extrabar"].a2,C["extrabar"].x,C["extrabar"].y)
  bar:SetHitRectInsets(-DB.barinset, -DB.barinset, -DB.barinset, -DB.barinset)
  bar:SetScale(C["ExtraBarSacle"])
  DB.applyDragFunctionality(bar,barDB.userplaced,barDB.locked)

  --the frame
  local f = ExtraActionBarFrame
  f:SetParent(bar)
  f:ClearAllPoints()
  f:SetPoint("CENTER", 0, 0)
  f.ignoreFramePositionManager = true

  --the button
  local b = ExtraActionButton1
  b:SetSize(C["ButtonSize"],C["ButtonSize"])
  bar.button = b

  --style texture
  local s = b.style
  s:SetTexture(nil)
  local disableTexture = function(style, texture)
    if not texture then return end
    if string.sub(texture,1,9) == "Interface" then
      style:SetTexture(nil) --bzzzzzzzz
    end
  end
  hooksecurefunc(s, "SetTexture", disableTexture)

  --register the event, make sure the damn button shows up
  bar:RegisterEvent("UPDATE_EXTRA_ACTIONBAR")
  bar:RegisterEvent("PLAYER_REGEN_ENABLED")
  bar:SetScript("OnEvent", function(self, event, ...)
    if (HasExtraActionBar()) then
      self:Show()
      self.button:Show()
    else
      self:Hide()
    end
  end)
  end