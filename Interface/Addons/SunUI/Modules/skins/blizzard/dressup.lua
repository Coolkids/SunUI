local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local A = S:GetModule("Skins")

local function LoadSkin()
	A:SetBD(DressUpFrame, 10, -12, -34, 74)
	DressUpFramePortrait:Hide()
	DressUpBackgroundTopLeft:Hide()
	DressUpBackgroundTopRight:Hide()
	DressUpBackgroundBotLeft:Hide()
	DressUpBackgroundBotRight:Hide()
	for i = 2, 5 do
		select(i, DressUpFrame:GetRegions()):Hide()
	end
	DressUpFrameResetButton:SetPoint("RIGHT", DressUpFrameCancelButton, "LEFT", -1, 0)
	A:Reskin(DressUpFrameCancelButton)
	A:Reskin(DressUpFrameResetButton)
	A:ReskinClose(DressUpFrameCloseButton, "TOPRIGHT", DressUpFrame, "TOPRIGHT", -38, -16)
end

A:RegisterSkin("SunUI", LoadSkin)