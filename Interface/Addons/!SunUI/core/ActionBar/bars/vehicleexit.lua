local S, C, L, DB = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("Core"):NewModule("vehicleexit", "AceEvent-3.0")
local barDB = DB.bars.vehicleexit
  local bar = CreateFrame("Frame","Vehicle",UIParent, "SecureHandlerStateTemplate")
function Module:OnInitialize()
C = ActionBarDB
	local a1, af, a2, x, y = unpack(MoveHandleDB["vehicleexit"]) 
  bar:Height(C["ButtonSize"])
  bar:Width(C["ButtonSize"])
   bar:SetScale(1)
  MoveHandle.Vehicle = S.MakeMoveHandle(bar, "SunUI离开载具按钮", "vehicleexit")
  bar:SetHitRectInsets(-DB.barinset, -DB.barinset, -DB.barinset, -DB.barinset)
 
  

  local veb = CreateFrame("BUTTON", nil, bar, "SecureHandlerClickTemplate");
  veb:SetAllPoints(bar)
  veb:RegisterForClicks("AnyUp")
  veb:SetNormalTexture("Interface\\Vehicles\\UI-Vehicles-Button-Exit-Up")
  veb:SetPushedTexture("Interface\\Vehicles\\UI-Vehicles-Button-Exit-Down")
  veb:SetHighlightTexture("Interface\\Vehicles\\UI-Vehicles-Button-Exit-Down")
  veb:SetScript("OnClick", function(self) VehicleExit() end)
  RegisterStateDriver(veb, "visibility", "[target=vehicle,exists] show;hide")
  end