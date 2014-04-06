local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local A = S:GetModule("Skins")

local function LoadSkin()
	A:SetBD(GMSurveyFrame, 0, 0, -32, 4)
	A:CreateBD(GMSurveyCommentFrame, .25)
	for i = 1, 11 do
		A:CreateBD(_G["GMSurveyQuestion"..i], .25)
	end

	for i = 1, 11 do
		select(i, GMSurveyFrame:GetRegions()):Hide()
	end
	GMSurveyHeaderLeft:Hide()
	GMSurveyHeaderRight:Hide()
	GMSurveyHeaderCenter:Hide()
	GMSurveyScrollFrameTop:SetAlpha(0)
	GMSurveyScrollFrameMiddle:SetAlpha(0)
	GMSurveyScrollFrameBottom:SetAlpha(0)
	A:Reskin(GMSurveySubmitButton)
	A:Reskin(GMSurveyCancelButton)
	A:ReskinClose(GMSurveyCloseButton, "TOPRIGHT", GMSurveyFrame, "TOPRIGHT", -36, -4)
	A:ReskinScroll(GMSurveyScrollFrameScrollBar)
end

A:RegisterSkin("Blizzard_GMSurveyUI", LoadSkin)