local S, L, DB, _, C = unpack(select(2, ...))
local r, g, b = DB.MyClassColor.r, DB.MyClassColor.g, DB.MyClassColor.b
local AuroraConfig = DB.AuroraConfig

DB.AuroraModules["Blizzard_TradeSkillUI"] = function()
	S.CreateBD(TradeSkillGuildFrame)
	S.CreateSD(TradeSkillGuildFrame)
	S.CreateBD(TradeSkillGuildFrameContainer, .25)
	TradeSkillFramePortrait:Hide()
	TradeSkillFramePortrait.Show = S.dummy
	for i = 18, 20 do
		select(i, TradeSkillFrame:GetRegions()):Hide()
		select(i, TradeSkillFrame:GetRegions()).Show = S.dummy
	end
	TradeSkillHorizontalBarLeft:Hide()
	select(22, TradeSkillFrame:GetRegions()):Hide()
	for i = 1, 3 do
		select(i, TradeSkillExpandButtonFrame:GetRegions()):SetAlpha(0)
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
	TradeSkillGuildCraftersFrameTrack:Hide()
	TradeSkillRankFrameBorder:Hide()
	TradeSkillRankFrameBackground:Hide()

	TradeSkillDetailScrollFrame:Height(176)

	local a1, p, a2, x, y = TradeSkillGuildFrame:GetPoint()
	TradeSkillGuildFrame:ClearAllPoints()
	TradeSkillGuildFrame:Point(a1, p, a2, x + 16, y)

	TradeSkillLinkButton:Point("LEFT", 0, -1)

	S.Reskin(TradeSkillCreateButton)
	S.Reskin(TradeSkillCreateAllButton)
	S.Reskin(TradeSkillCancelButton)
	S.Reskin(TradeSkillViewGuildCraftersButton)
	S.Reskin(TradeSkillFilterButton)

	TradeSkillRankFrame:SetStatusBarTexture(DB.media.backdrop)
	TradeSkillRankFrame.SetStatusBarColor = S.dummy
	TradeSkillRankFrame:GetStatusBarTexture():SetGradient("VERTICAL", .1, .3, .9, .2, .4, 1)

	local bg = CreateFrame("Frame", nil, TradeSkillRankFrame)
	bg:Point("TOPLEFT", -1, 1)
	bg:Point("BOTTOMRIGHT", 1, -1)
	bg:SetFrameLevel(TradeSkillRankFrame:GetFrameLevel()-1)
	S.CreateBD(bg, .25)

	for i = 1, MAX_TRADE_SKILL_REAGENTS do
		local bu = _G["TradeSkillReagent"..i]
		local ic = _G["TradeSkillReagent"..i.."IconTexture"]

		_G["TradeSkillReagent"..i.."NameFrame"]:SetAlpha(0)

		ic:SetTexCoord(.08, .92, .08, .92)
		ic:SetDrawLayer("ARTWORK")
		S.CreateBG(ic)

		local bd = CreateFrame("Frame", nil, bu)
		bd:Point("TOPLEFT", 39, -1)
		bd:Point("BOTTOMRIGHT", 0, 1)
		bd:SetFrameLevel(0)
		S.CreateBD(bd, .25)

		_G["TradeSkillReagent"..i.."Name"]:SetParent(bd)
	end

	hooksecurefunc("TradeSkillFrame_SetSelection", function()
		local ic = TradeSkillSkillIcon:GetNormalTexture()
		if ic then
			ic:SetTexCoord(.08, .92, .08, .92)
			ic:Point("TOPLEFT", 1, -1)
			ic:Point("BOTTOMRIGHT", -1, 1)
			S.CreateBD(TradeSkillSkillIcon)
		else
			TradeSkillSkillIcon:SetBackdrop(nil)
		end
	end)

	local colourExpandOrCollapse = S.colourExpandOrCollapse
	local clearExpandOrCollapse = S.clearExpandOrCollapse

	local gradOr, startR, startG, startB, startAlpha, endR, endG, endB, endAlpha = unpack(AuroraConfig.gradientAlpha)

	local function styleSkillButton(skillButton)
		skillButton:SetNormalTexture("")
		skillButton.SetNormalTexture = S.dummy
		skillButton:SetPushedTexture("")

		skillButton.bg = CreateFrame("Frame", nil, skillButton)
		skillButton.bg:Size(13, 13)
		skillButton.bg:Point("LEFT", 4, 1)
		skillButton.bg:SetFrameLevel(skillButton:GetFrameLevel()-1)
		S.CreateBD(skillButton.bg, 0)

		skillButton.tex = skillButton:CreateTexture(nil, "BACKGROUND")
		skillButton.tex:Point("TOPLEFT", skillButton.bg, 1, -1)
		skillButton.tex:Point("BOTTOMRIGHT", skillButton.bg, -1, 1)
		skillButton.tex:SetTexture(DB.media.backdrop)
		skillButton.tex:SetGradientAlpha(gradOr, startR, startG, startB, startAlpha, endR, endG, endB, endAlpha)

		skillButton.minus = skillButton:CreateTexture(nil, "OVERLAY")
		skillButton.minus:Size(7, 1)
		skillButton.minus:SetPoint("CENTER", skillButton.bg)
		skillButton.minus:SetTexture(DB.media.backdrop)
		skillButton.minus:SetVertexColor(1, 1, 1)

		skillButton.plus = skillButton:CreateTexture(nil, "OVERLAY")
		skillButton.plus:Size(1, 7)
		skillButton.plus:SetPoint("CENTER", skillButton.bg)
		skillButton.plus:SetTexture(DB.media.backdrop)
		skillButton.plus:SetVertexColor(1, 1, 1)

		skillButton:HookScript("OnEnter", colourExpandOrCollapse)
		skillButton:HookScript("OnLeave", clearExpandOrCollapse)
	end

	styleSkillButton(TradeSkillCollapseAllButton)
	TradeSkillCollapseAllButton:SetDisabledTexture("")
	TradeSkillCollapseAllButton:SetHighlightTexture("")

	hooksecurefunc("TradeSkillFrame_Update", function()
		local numTradeSkills = GetNumTradeSkills()
		local skillOffset = FauxScrollFrame_GetOffset(TradeSkillListScrollFrame)
		local skillIndex
		local diplayedSkills = TRADE_SKILLS_DISPLAYED
		local hasFilterBar = TradeSkillFilterBar:IsShown()
		if hasFilterBar then
			diplayedSkills = TRADE_SKILLS_DISPLAYED - 1
		end
		local buttonIndex = 0

		for i = 1, diplayedSkills do
			skillIndex = i + skillOffset
			_, skillType, _, isExpanded = GetTradeSkillInfo(skillIndex)
			if hasFilterBar then
				buttonIndex = i + 1
			else
				buttonIndex = i
			end

			local skillButton = _G["TradeSkillSkill"..buttonIndex]

			if not skillButton.styled then
				skillButton.styled = true

				local buttonHighlight = _G["TradeSkillSkill"..buttonIndex.."Highlight"]
				buttonHighlight:SetTexture("")
				buttonHighlight.SetTexture = S.dummy

				skillButton.SubSkillRankBar.BorderLeft:Hide()
				skillButton.SubSkillRankBar.BorderRight:Hide()
				skillButton.SubSkillRankBar.BorderMid:Hide()

				skillButton.SubSkillRankBar:Height(12)
				skillButton.SubSkillRankBar:SetStatusBarTexture(DB.media.backdrop)
				skillButton.SubSkillRankBar:GetStatusBarTexture():SetGradient("VERTICAL", .1, .3, .9, .2, .4, 1)
				S.CreateBDFrame(skillButton.SubSkillRankBar, .25)

				styleSkillButton(skillButton)
			end

			if skillIndex <= numTradeSkills then
				if skillType == "header" or skillType == "subheader" then
					if skillType == "subheader" then
						skillButton.bg:Point("LEFT", 24, 1)
					else
						skillButton.bg:Point("LEFT", 4, 1)
					end

					skillButton.bg:Show()
					skillButton.tex:Show()
					skillButton.minus:Show()
					if isExpanded then
						skillButton.plus:Hide()
					else
						skillButton.plus:Show()
					end
				else
					skillButton.bg:Hide()
					skillButton.tex:Hide()
					skillButton.minus:Hide()
					skillButton.plus:Hide()
				end
			end

			if TradeSkillCollapseAllButton.collapsed == 1 then
				TradeSkillCollapseAllButton.plus:Show()
			else
				TradeSkillCollapseAllButton.plus:Hide()
			end
		end
	end)

	TradeSkillIncrementButton:Point("RIGHT", TradeSkillCreateButton, "LEFT", -9, 0)

	S.ReskinPortraitFrame(TradeSkillFrame, true)
	S.ReskinClose(TradeSkillGuildFrameCloseButton)
	S.ReskinScroll(TradeSkillDetailScrollFrameScrollBar)
	S.ReskinScroll(TradeSkillListScrollFrameScrollBar)
	S.ReskinScroll(TradeSkillGuildCraftersFrameScrollBar)
	S.ReskinInput(TradeSkillInputBox, nil, 33)
	S.ReskinInput(TradeSkillFrameSearchBox)
	S.ReskinArrow(TradeSkillDecrementButton, "left")
	S.ReskinArrow(TradeSkillIncrementButton, "right")
	S.ReskinArrow(TradeSkillLinkButton, "right")
end