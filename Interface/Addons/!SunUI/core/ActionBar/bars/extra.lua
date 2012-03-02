local S, C, L, DB = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("Core"):NewModule("extra", "AceEvent-3.0")
local barDB = DB.bars.extrabar
  local bar = CreateFrame("Frame","SunUIExtraActionBar",UIParent,"SecureHandlerStateTemplate")
  function Module:OnInitialize()
  C = ActionBarDB
  local a1, af, a2, x, y = unpack(MoveHandleDB["extrabar"]) 
  bar:Size(C["ButtonSize"],C["ButtonSize"])
  bar:SetHitRectInsets(-DB.barinset, -DB.barinset, -DB.barinset, -DB.barinset)
  bar:SetScale(C["ExtraBarSacle"])
 
  MoveHandle.SunUIExtraActionBar = S.MakeMove(bar, "SunUI特殊按钮", "extrabar", C["ExtraBarSacle"])

  --the frame
  local f = ExtraActionBarFrame
  f:SetParent(bar)
  f:ClearAllPoints()
  f:Point("CENTER", 0, 0)
  f.ignoreFramePositionManager = true

  --the button
  local b = ExtraActionButton1
  b:Size(C["ButtonSize"],C["ButtonSize"])
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