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
	f:SetPoint("CENTER", bar, "CENTER")
	f.ignoreFramePositionManager = true
	
	local b = ExtraActionButton1
	b:SetSize(C["ButtonSize"],C["ButtonSize"])
	UIPARENT_MANAGED_FRAME_POSITIONS.ExtraActionBarFrame = nil
	UIPARENT_MANAGED_FRAME_POSITIONS.PlayerPowerBarAlt.extraActionBarFrame = nil
	UIPARENT_MANAGED_FRAME_POSITIONS.CastingBarFrame.extraActionBarFrame = nil
  
	ExtraActionButton1Cooldown:SetPoint("TOPLEFT")
	ExtraActionButton1Cooldown:SetPoint("BOTTOMRIGHT")
	
	--style texture
	--local s = b.style
	--s:SetTexture(nil)
	local disableTexture = function(self)
		self.button.style:SetTexture(nil);
	end
	hooksecurefunc("ExtraActionBar_OnShow", disableTexture)
end