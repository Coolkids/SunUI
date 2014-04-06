local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local A = S:GetModule("Skins")

local function LoadSkin()
	A:SetBD(WorldStateScoreFrame)
	A:ReskinScroll(WorldStateScoreScrollFrameScrollBar)
	WorldStateScoreFrame:DisableDrawLayer("BACKGROUND")
	WorldStateScoreFrameInset:DisableDrawLayer("BACKGROUND")
	WorldStateScoreFrame:DisableDrawLayer("BORDER")
	WorldStateScoreFrameInset:DisableDrawLayer("BORDER")
	WorldStateScoreFrameTopLeftCorner:Hide()
	WorldStateScoreFrameTopBorder:Hide()
	WorldStateScoreFrameTopRightCorner:Hide()
	select(2, WorldStateScoreScrollFrame:GetRegions()):Hide()
	select(3, WorldStateScoreScrollFrame:GetRegions()):Hide()
	WorldStateScoreFrameTab2:SetPoint("LEFT", WorldStateScoreFrameTab1, "RIGHT", -15, 0)
	WorldStateScoreFrameTab3:SetPoint("LEFT", WorldStateScoreFrameTab2, "RIGHT", -15, 0)
	for i = 1, 3 do
		A:CreateTab(_G["WorldStateScoreFrameTab"..i])
	end
	A:Reskin(WorldStateScoreFrameLeaveButton)
	A:ReskinClose(WorldStateScoreFrameCloseButton)
end

A:RegisterSkin("SunUI", LoadSkin)