local S, C, L, DB = unpack(select(2, ...))
if DB.Nuke == true then return end
local Module = LibStub("AceAddon-3.0"):GetAddon("Core"):NewModule("Extra", "AceEvent-3.0")
function Module:OnInitialize()
	C = ActionBarDB
	local bar = CreateFrame("Frame","SunUIExtraActionBar",UIParent)
	bar:SetSize(C["ButtonSize"],C["ButtonSize"])
	bar:SetScale(C["ExtraBarSacle"])
 
	MoveHandle.SunUIExtraActionBar = S.MakeMove(bar, "SunUI特殊按钮", "extrabar", C["ExtraBarSacle"])
	ExtraActionBarFrame:SetPoint('CENTER', bar, 'CENTER')
	ExtraActionBarFrame:SetSize(C["ButtonSize"],C["ButtonSize"])
	ExtraActionBarFrame:SetScale(C["ExtraBarSacle"])
	ExtraActionButton1Cooldown:SetPoint("TOPLEFT")
	ExtraActionButton1Cooldown:SetPoint("BOTTOMRIGHT")
	UIPARENT_MANAGED_FRAME_POSITIONS.ExtraActionBarFrame = nil
	UIPARENT_MANAGED_FRAME_POSITIONS.PlayerPowerBarAlt.extraActionBarFrame = nil
	UIPARENT_MANAGED_FRAME_POSITIONS.CastingBarFrame.extraActionBarFrame = nil
end