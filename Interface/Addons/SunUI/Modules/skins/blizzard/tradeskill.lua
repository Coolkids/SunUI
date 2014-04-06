local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local A = S:GetModule("Skins")

local function LoadSkin()
	A:ReskinPortraitFrame(TradeSkillFrame, true)
	A:CreateBD(TradeSkillGuildFrame)
	A:CreateSD(TradeSkillGuildFrame)
	A:CreateBD(TradeSkillGuildFrameContainer, .25)

	TradeSkillFramePortrait:Hide()
	TradeSkillFramePortrait.Show = S.dummy
	for i = 18, 20 do
		select(i, TradeSkillFrame:GetRegions()):Hide()
		select(i, TradeSkillFrame:GetRegions()).Show = S.dummy
	end
	TradeSkillHorizontalBarLeft:Hide()
	select(22, TradeSkillFrame:GetRegions()):Hide()
	for i = 1, 3 do
		select(i, TradeSkillExpandButtonFrame:GetRegions()):Hide()
		select(i, TradeSkillFilterButton:GetRegions()):Hide()
	end
	for i = 1, 9 do
		select(i, TradeSkillGuildFrame:GetRegions()):Hide()
	end
	TradeSkillListScrollFrame:GetRegions():Hide()
	select(2, TradeSkillListScrollFrame:GetRegions()):Hide()
	TradeSkillDetailHeaderLeft:Hide()
	select(6, TradeSkillDetailScrollChildFrame:GetRegions()):Hide()
	TradeSkillDetailScrollFrameTop:SetAlpha(0)
	TradeSkillDetailScrollFrameBottom:SetAlpha(0)
	TradeSkillFrameBg:Hide()
	TradeSkillFrameInsetBg:Hide()
	TradeSkillFrameTitleBg:Hide()
	TradeSkillFramePortraitFrame:Hide()
	TradeSkillFrameTopBorder:Hide()
	TradeSkillFrameTopRightCorner:Hide()
	TradeSkillCreateAllButton_RightSeparator:Hide()
	TradeSkillCreateButton_LeftSeparator:Hide()
	TradeSkillCancelButton_LeftSeparator:Hide()
	TradeSkillViewGuildCraftersButton_RightSeparator:Hide()
	TradeSkillGuildCraftersFrameTrack:Hide()
	TradeSkillRankFrameBorder:Hide()
	TradeSkillRankFrameBackground:Hide()

	TradeSkillDetailScrollFrame:SetHeight(176)

	local a1, p, a2, x, y = TradeSkillGuildFrame:GetPoint()
	TradeSkillGuildFrame:ClearAllPoints()
	TradeSkillGuildFrame:Point(a1, p, a2, x + 16, y)

	TradeSkillLinkButton:Point("LEFT", 0, -1)

	A:Reskin(TradeSkillCreateButton)
	A:Reskin(TradeSkillCreateAllButton)
	A:Reskin(TradeSkillCancelButton)
	A:Reskin(TradeSkillViewGuildCraftersButton)
	A:Reskin(TradeSkillFilterButton)

	TradeSkillRankFrame:SetStatusBarTexture(A["media"].backdrop)
	TradeSkillRankFrame.SetStatusBarColor = S.dummy
	TradeSkillRankFrame:GetStatusBarTexture():SetGradient("VERTICAL", .1, .3, .9, .2, .4, 1)

	local bg = CreateFrame("Frame", nil, TradeSkillRankFrame)
	bg:Point("TOPLEFT", -1, 1)
	bg:Point("BOTTOMRIGHT", 1, -1)
	bg:SetFrameLevel(TradeSkillRankFrame:GetFrameLevel()-1)
	A:CreateBD(bg, .25)

	for i = 1, MAX_TRADE_SKILL_REAGENTS do
		local bu = _G["TradeSkillReagent"..i]
		local na = _G["TradeSkillReagent"..i.."NameFrame"]
		local ic = _G["TradeSkillReagent"..i.."IconTexture"]

		na:Hide()

		ic:SetTexCoord(.08, .92, .08, .92)
		ic:SetDrawLayer("ARTWORK")
		A:CreateBG(ic)

		local bd = CreateFrame("Frame", nil, bu)
		bd:Point("TOPLEFT", 39, -1)
		bd:Point("BOTTOMRIGHT", 0, 1)
		bd:SetFrameLevel(0)
		A:CreateBD(bd, .25)

		_G["TradeSkillReagent"..i.."Name"]:SetParent(bd)
	end

	local reskinned = false
	local function SkinSkillIcon()
		local ic =TradeSkillSkillIcon:GetNormalTexture()
		if ic then
			ic:SetTexCoord(.08, .92, .08, .92)
			ic:Point("TOPLEFT", 1, -1)
			ic:Point("BOTTOMRIGHT", -1, 1)
		end
		if not reskinned == true then
			TradeSkillSkillIcon:StyleButton(1)
			TradeSkillSkillIcon:SetPushedTexture(nil)
			if ic then
				A:CreateBD(TradeSkillSkillIcon)
				reskinned = true
			end
		end
	end
	hooksecurefunc("TradeSkillFrame_SetSelection", SkinSkillIcon)

	hooksecurefunc("TradeSkillFrame_Update", function()
		local numTradeSkills = GetNumTradeSkills()
		local diplayedSkills = TRADE_SKILLS_DISPLAYED
		local hasFilterBar = TradeSkillFilterBar:IsShown()
		if  hasFilterBar then
			diplayedSkills = TRADE_SKILLS_DISPLAYED - 1
		end
		local buttonIndex = 0

		for i = 1, diplayedSkills do
			if hasFilterBar then
				buttonIndex = i + 1
			else
				buttonIndex = i
			end

			local skillButton = _G["TradeSkillSkill"..buttonIndex]

			if not skillButton.reskinned then
				skillButton.reskinned = true

				skillButton.SubSkillRankBar.BorderLeft:Hide()
				skillButton.SubSkillRankBar.BorderRight:Hide()
				skillButton.SubSkillRankBar.BorderMid:Hide()

				skillButton.SubSkillRankBar:SetHeight(12)
				skillButton.SubSkillRankBar:SetStatusBarTexture(A["media"].backdrop)
				skillButton.SubSkillRankBar:GetStatusBarTexture():SetGradient("VERTICAL", .1, .3, .9, .2, .4, 1)
				A:CreateBDFrame(skillButton.SubSkillRankBar, .25)
			end
		end
	end)

	TradeSkillIncrementButton:SetPoint("RIGHT", TradeSkillCreateButton, "LEFT", -9, 0)

	A:ReskinClose(TradeSkillFrameCloseButton)
	A:ReskinClose(TradeSkillGuildFrameCloseButton)
	A:ReskinScroll(TradeSkillDetailScrollFrameScrollBar)
	A:ReskinScroll(TradeSkillListScrollFrameScrollBar)
	A:ReskinScroll(TradeSkillGuildCraftersFrameScrollBar)
	A:ReskinInput(TradeSkillInputBox)
	A:ReskinInput(TradeSkillFrameSearchBox)
	A:ReskinArrow(TradeSkillDecrementButton, "left")
	A:ReskinArrow(TradeSkillIncrementButton, "right")
	A:ReskinArrow(TradeSkillLinkButton, "right")
end

A:RegisterSkin("Blizzard_TradeSkillUI", LoadSkin)