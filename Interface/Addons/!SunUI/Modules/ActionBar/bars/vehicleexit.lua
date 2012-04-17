local S, C, L, DB = unpack(select(2, ...))
if DB.Nuke == true then return end
local Module = LibStub("AceAddon-3.0"):GetAddon("Core"):NewModule("vehicleexit", "AceEvent-3.0")
function Module:OnInitialize()
	C = ActionBarDB
	local bar = CreateFrame("Frame","Vehicle",UIParent, "SecureHandlerStateTemplate")
	bar:SetHeight(C["ButtonSize"])
	bar:SetWidth(C["ButtonSize"])
	bar:SetScale(S.Scale(1))
	MoveHandle.Vehicle = S.MakeMoveHandle(bar, "SunUI离开载具按钮", "vehicleexit")
	bar:SetHitRectInsets(-10, -10, -10, -10)

	local veb = CreateFrame("BUTTON", nil, bar, "SecureHandlerClickTemplate");
	veb:SetAllPoints(bar)
	veb:RegisterForClicks("AnyUp")
	veb:SetNormalTexture("Interface\\Vehicles\\UI-Vehicles-Button-Exit-Up")
	veb:SetPushedTexture("Interface\\Vehicles\\UI-Vehicles-Button-Exit-Down")
	veb:SetHighlightTexture("Interface\\Vehicles\\UI-Vehicles-Button-Exit-Down")
	veb:SetScript("OnClick", function(self) VehicleExit() end)
	RegisterStateDriver(veb, "visibility", "[target=vehicle,exists] show;hide")
end