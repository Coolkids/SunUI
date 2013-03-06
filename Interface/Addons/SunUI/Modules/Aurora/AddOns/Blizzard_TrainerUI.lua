local S, L, DB, _, C = unpack(select(2, ...))
local r, g, b = DB.MyClassColor.r, DB.MyClassColor.g, DB.MyClassColor.b
local AuroraConfig = DB.AuroraConfig

DB.AuroraModules["Blizzard_TrainerUI"] = function()
	ClassTrainerFrameBottomInset:DisableDrawLayer("BORDER")
	ClassTrainerFrame.BG:Hide()
	ClassTrainerFrameBottomInsetBg:Hide()
	ClassTrainerFrameMoneyBg:SetAlpha(0)

	ClassTrainerStatusBarSkillRank:ClearAllPoints()
	ClassTrainerStatusBarSkillRank:SetPoint("CENTER", ClassTrainerStatusBar, "CENTER", 0, 0)

	local bg = CreateFrame("Frame", nil, ClassTrainerFrameSkillStepButton)
	bg:Point("TOPLEFT", 42, -2)
	bg:Point("BOTTOMRIGHT", 0, 2)
	bg:SetFrameLevel(ClassTrainerFrameSkillStepButton:GetFrameLevel()-1)
	S.CreateBD(bg, .25)

	ClassTrainerFrameSkillStepButton:SetNormalTexture("")
	ClassTrainerFrameSkillStepButton:SetHighlightTexture("")
	ClassTrainerFrameSkillStepButton.disabledBG:SetTexture("")

	ClassTrainerFrameSkillStepButton.selectedTex:Point("TOPLEFT", 43, -3)
	ClassTrainerFrameSkillStepButton.selectedTex:Point("BOTTOMRIGHT", -1, 3)
	ClassTrainerFrameSkillStepButton.selectedTex:SetTexture(DB.media.backdrop)
	ClassTrainerFrameSkillStepButton.selectedTex:SetVertexColor(r, g, b, .2)

	local icbg = CreateFrame("Frame", nil, ClassTrainerFrameSkillStepButton)
	icbg:Point("TOPLEFT", ClassTrainerFrameSkillStepButtonIcon, -1, 1)
	icbg:Point("BOTTOMRIGHT", ClassTrainerFrameSkillStepButtonIcon, 1, -1)
	S.CreateBD(icbg, 0)

	ClassTrainerFrameSkillStepButtonIcon:SetTexCoord(.08, .92, .08, .92)

	hooksecurefunc("ClassTrainerFrame_Update", function()
		for _, bu in next, ClassTrainerFrame.scrollFrame.buttons do
			if not bu.styled then
				local bg = CreateFrame("Frame", nil, bu)
				bg:Point("TOPLEFT", 42, -6)
				bg:Point("BOTTOMRIGHT", 0, 6)
				bg:SetFrameLevel(bu:GetFrameLevel()-1)
				S.CreateBD(bg, .25)

				bu.name:SetParent(bg)
				bu.name:Point("TOPLEFT", bu.icon, "TOPRIGHT", 6, -2)
				bu.subText:SetParent(bg)
				bu.money:SetParent(bg)
				bu.money:Point("TOPRIGHT", bu, "TOPRIGHT", 5, -8)
				bu:SetNormalTexture("")
				bu:SetHighlightTexture("")
				bu.disabledBG:Hide()
				bu.disabledBG.Show = S.dummy

				bu.selectedTex:Point("TOPLEFT", 43, -6)
				bu.selectedTex:Point("BOTTOMRIGHT", -1, 7)
				bu.selectedTex:SetTexture(DB.media.backdrop)
				bu.selectedTex:SetVertexColor(r, g, b, .2)

				bu.icon:SetTexCoord(.08, .92, .08, .92)
				S.CreateBG(bu.icon)

				bu.styled = true
			end
		end
	end)

	ClassTrainerStatusBarLeft:Hide()
	ClassTrainerStatusBarMiddle:Hide()
	ClassTrainerStatusBarRight:Hide()
	ClassTrainerStatusBarBackground:Hide()
	ClassTrainerStatusBar:Point("TOPLEFT", ClassTrainerFrame, "TOPLEFT", 64, -35)
	ClassTrainerStatusBar:SetStatusBarTexture(DB.media.backdrop)

	ClassTrainerStatusBar:GetStatusBarTexture():SetGradient("VERTICAL", .1, .3, .9, .2, .4, 1)

	local bd = CreateFrame("Frame", nil, ClassTrainerStatusBar)
	bd:Point("TOPLEFT", -1, 1)
	bd:Point("BOTTOMRIGHT", 1, -1)
	bd:SetFrameLevel(ClassTrainerStatusBar:GetFrameLevel()-1)
	S.CreateBD(bd, .25)

	S.ReskinPortraitFrame(ClassTrainerFrame, true)
	S.Reskin(ClassTrainerTrainButton)
	S.ReskinScroll(ClassTrainerScrollFrameScrollBar)
	S.ReskinDropDown(ClassTrainerFrameFilterDropDown)
end