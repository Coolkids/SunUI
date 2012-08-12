local S, C, L, DB = unpack(SunUI)
 
local Module = LibStub("AceAddon-3.0"):GetAddon("Core"):NewModule("Extra", "AceEvent-3.0")
function Module:OnInitialize()
	C = C["ActionBarDB"]
	local bar = CreateFrame("Frame","SunUIExtraActionBar",UIParent)
	bar:SetSize(C["ButtonSize"],C["ButtonSize"])
	bar:SetScale(C["ExtraBarSacle"])
	--bar:SetHitRectInsets(-10, -10, -10, -10)
	MoveHandle.SunUIExtraActionBar = S.MakeMove(bar, "SunUI特殊按钮", "extrabar", C["ExtraBarSacle"])

	--the frame
	local f = ExtraActionBarFrame
	f:SetParent(bar)
	f:ClearAllPoints()
	f:SetAllPoints(bar)
	f.ignoreFramePositionManager = true
	
	local b = ExtraActionButton1
	b:SetSize(C["ButtonSize"],C["ButtonSize"])
	UIPARENT_MANAGED_FRAME_POSITIONS.ExtraActionBarFrame = nil
	UIPARENT_MANAGED_FRAME_POSITIONS.PlayerPowerBarAlt.extraActionBarFrame = nil
	UIPARENT_MANAGED_FRAME_POSITIONS.CastingBarFrame.extraActionBarFrame = nil
  
	ExtraActionButton1Cooldown:SetPoint("TOPLEFT")
	ExtraActionButton1Cooldown:SetPoint("BOTTOMRIGHT")
	S.StripTextures(ExtraActionBarFrame, kill)
	S.StripTextures(ExtraActionButton1, kill)
end