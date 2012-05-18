local S, C, L, DB = unpack(SunUI)
 
local Module = LibStub("AceAddon-3.0"):GetAddon("Core"):NewModule("Extra", "AceEvent-3.0")
function Module:OnInitialize()
	C = ActionBarDB
	local bar = CreateFrame("Frame","SunUIExtraActionBar",UIParent)
	bar:SetSize(C["ButtonSize"],C["ButtonSize"])
	bar:SetScale(C["ExtraBarSacle"])
 
	MoveHandle.SunUIExtraActionBar = S.MakeMove(bar, "SunUI特殊按钮", "extrabar", C["ExtraBarSacle"])

	local f = ExtraActionBarFrame
	f:SetParent(bar)
	f:ClearAllPoints()
	f:SetAllPoints(bar)
	f.ignoreFramePositionManager = true

  --the button
	local b = ExtraActionButton1
	bar.button = b
	ExtraActionButton1Cooldown:SetPoint("TOPLEFT")
	ExtraActionButton1Cooldown:SetPoint("BOTTOMRIGHT")
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