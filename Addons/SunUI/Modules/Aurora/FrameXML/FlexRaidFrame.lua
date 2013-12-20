local S, L, DB, _, C = unpack(select(2, ...))

local r, g, b = DB.MyClassColor.r, DB.MyClassColor.g, DB.MyClassColor.b
local AuroraConfig = DB.AuroraConfig

tinsert(DB.AuroraModules["SunUI"], function()
	FlexRaidFrameBottomInset.Bg:Hide()
	FlexRaidFrameBottomInset:DisableDrawLayer("BORDER")

	FlexRaidFrameScrollFrameScrollBackground:Hide()
	FlexRaidFrameScrollFrameBackground:Hide()
	FlexRaidFrameScrollFrameBackgroundCover:Hide()
	FlexRaidFrameScrollFrameScrollBackgroundTopLeft:Hide()
	FlexRaidFrameScrollFrameScrollBackgroundBottomRight:Hide()

	S.Reskin(FlexRaidFrame.StartButton)
	S.ReskinDropDown(FlexRaidFrameSelectionDropDown)
end)