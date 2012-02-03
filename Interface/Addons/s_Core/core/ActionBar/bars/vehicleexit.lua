local S, C, L, DB = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("Core"):NewModule("vehicleexit", "AceEvent-3.0")
local barDB = DB.bars.vehicleexit
  local bar = CreateFrame("Frame","rABS_VehicleExit",UIParent, "SecureHandlerStateTemplate")
function Module:OnInitialize()
C = ActionBarDB

  bar:SetHeight(C["ButtonSize"])
  bar:SetWidth(C["ButtonSize"])
  bar:SetPoint(C["vehicleexit"].a1,C["vehicleexit"].af,C["vehicleexit"].a2,C["vehicleexit"].x,C["vehicleexit"].y)
  bar:SetHitRectInsets(-DB.barinset, -DB.barinset, -DB.barinset, -DB.barinset)

  if barDB.testmode then
    bar:SetBackdrop(DB.backdrop)
    bar:SetBackdropColor(1,0.8,1,0.6)
  end
  bar:SetScale(1)

  DB.applyDragFunctionality(bar,barDB.userplaced,barDB.locked)
end
  local veb = CreateFrame("BUTTON", nil, bar, "SecureHandlerClickTemplate");
  veb:SetAllPoints(bar)
  veb:RegisterForClicks("AnyUp")
  veb:SetNormalTexture("Interface\\Vehicles\\UI-Vehicles-Button-Exit-Up")
  veb:SetPushedTexture("Interface\\Vehicles\\UI-Vehicles-Button-Exit-Down")
  veb:SetHighlightTexture("Interface\\Vehicles\\UI-Vehicles-Button-Exit-Down")
  veb:SetScript("OnClick", function(self) VehicleExit() end)
  RegisterStateDriver(veb, "visibility", "[target=vehicle,exists] show;hide")
  