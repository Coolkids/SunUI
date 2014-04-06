local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local A = S:GetModule("Skins")

local function LoadSkin()
	A:Reskin(RaidFrameRaidInfoButton)
	A:Reskin(RaidFrameConvertToRaidButton)
	A:Reskin(RaidInfoExtendButton)
	A:Reskin(RaidInfoCancelButton)
	A:ReskinClose(RaidInfoCloseButton)
	A:ReskinScroll(RaidInfoScrollFrameScrollBar)
	A:ReskinCheck(RaidFrameAllAssistCheckButton)
	RaidInfoInstanceLabel:DisableDrawLayer("BACKGROUND")
	RaidInfoIDLabel:DisableDrawLayer("BACKGROUND")
	RaidInfoDetailFooter:Hide()
	RaidInfoDetailHeader:Hide()
	RaidInfoDetailCorner:Hide()
	RaidInfoFrameHeader:Hide()
	RaidInfoFrame:SetPoint("TOPLEFT", RaidFrame, "TOPRIGHT", 1, -28)
end

A:RegisterSkin("SunUI", LoadSkin)