local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local A = S:GetModule("Skins")

local function LoadSkin()
	local r, g, b = RAID_CLASS_COLORS[S.myclass].r, RAID_CLASS_COLORS[S.myclass].g, RAID_CLASS_COLORS[S.myclass].b
	
	--QuestFrame
	QuestFrame:StripTextures(true)
	QuestFrameInset:Kill()
	QuestFrameDetailPanel:StripTextures(true)
	QuestDetailScrollFrame:StripTextures(true)
	QuestNpcNameFrame:Hide()
	QuestDetailScrollChildFrame:StripTextures(true)
	QuestRewardScrollFrame:StripTextures(true)
	QuestRewardScrollChildFrame:StripTextures(true)
	QuestFrameProgressPanel:StripTextures(true)
	QuestFrameRewardPanel:StripTextures(true)
	A:SetBD(QuestFrame)
	
	QuestFrameDetailPanel:DisableDrawLayer("BACKGROUND")
	QuestFrameProgressPanel:DisableDrawLayer("BACKGROUND")
	QuestFrameRewardPanel:DisableDrawLayer("BACKGROUND")
	QuestFrameGreetingPanel:DisableDrawLayer("BACKGROUND")
	QuestFrameDetailPanel:DisableDrawLayer("BORDER")
	QuestFrameRewardPanel:DisableDrawLayer("BORDER")

	QuestDetailScrollFrameTop:Hide()
	QuestDetailScrollFrameBottom:Hide()
	QuestDetailScrollFrameMiddle:Hide()
	QuestProgressScrollFrameTop:Hide()
	QuestProgressScrollFrameBottom:Hide()
	QuestProgressScrollFrameMiddle:Hide()
	QuestRewardScrollFrameTop:Hide()
	QuestRewardScrollFrameBottom:Hide()
	QuestRewardScrollFrameMiddle:Hide()
	QuestGreetingScrollFrameTop:Hide()
	QuestGreetingScrollFrameBottom:Hide()
	QuestGreetingScrollFrameMiddle:Hide()

	QuestFrameProgressPanelMaterialTopLeft:SetAlpha(0)
	QuestFrameProgressPanelMaterialTopRight:SetAlpha(0)
	QuestFrameProgressPanelMaterialBotLeft:SetAlpha(0)
	QuestFrameProgressPanelMaterialBotRight:SetAlpha(0)

	local line = QuestFrameGreetingPanel:CreateTexture()
	line:SetTexture(1, 1, 1, .2)
	line:SetSize(256, 1)
	line:SetPoint("CENTER", QuestGreetingFrameHorizontalBreak)

	QuestGreetingFrameHorizontalBreak:SetTexture("")

	QuestFrameGreetingPanel:HookScript("OnShow", function()
		line:SetShown(QuestGreetingFrameHorizontalBreak:IsShown())
	end)

	for i = 1, MAX_REQUIRED_ITEMS do
		local bu = _G["QuestProgressItem"..i]
		local ic = _G["QuestProgressItem"..i.."IconTexture"]
		local na = _G["QuestProgressItem"..i.."NameFrame"]
		local co = _G["QuestProgressItem"..i.."Count"]

		ic:SetSize(40, 40)
		ic:SetTexCoord(.08, .92, .08, .92)
		ic:SetDrawLayer("OVERLAY")

		A:CreateBD(bu, .25)

		na:Hide()
		co:SetDrawLayer("OVERLAY")

		local line = CreateFrame("Frame", nil, bu)
		line:SetSize(1, 40)
		line:SetPoint("RIGHT", ic, 1, 0)
		A:CreateBD(line)
	end

	QuestDetailScrollFrame:SetWidth(302) -- else these buttons get cut off

	hooksecurefunc(QuestProgressRequiredMoneyText, "SetTextColor", function(self, r, g, b)
		if r == 0 then
			self:SetTextColor(.8, .8, .8)
		elseif r == .2 then
			self:SetTextColor(1, 1, 1)
		end
	end)

	for _, questButton in pairs({"QuestFrameAcceptButton", "QuestFrameDeclineButton", "QuestFrameCompleteQuestButton", "QuestFrameCompleteButton", "QuestFrameGoodbyeButton", "QuestFrameGreetingGoodbyeButton"}) do
		A:Reskin(_G[questButton])
	end

	A:ReskinScroll(QuestProgressScrollFrameScrollBar)
	A:ReskinScroll(QuestRewardScrollFrameScrollBar)
	A:ReskinScroll(QuestDetailScrollFrameScrollBar)
	A:ReskinScroll(QuestGreetingScrollFrameScrollBar)

	-- Text colour stuff

	QuestProgressRequiredItemsText:SetTextColor(1, 1, 1)
	QuestProgressRequiredItemsText:SetShadowColor(0, 0, 0)
	QuestProgressTitleText:SetTextColor(1, 1, 1)
	QuestProgressTitleText:SetShadowColor(0, 0, 0)
	QuestProgressTitleText.SetTextColor = S.dummy
	QuestProgressText:SetTextColor(1, 1, 1)
	QuestProgressText.SetTextColor = S.dummy
	GreetingText:SetTextColor(1, 1, 1)
	GreetingText.SetTextColor = S.dummy
	AvailableQuestsText:SetTextColor(1, 1, 1)
	AvailableQuestsText.SetTextColor = S.dummy
	AvailableQuestsText:SetShadowColor(0, 0, 0)
	CurrentQuestsText:SetTextColor(1, 1, 1)
	CurrentQuestsText.SetTextColor = S.dummy
	CurrentQuestsText:SetShadowColor(0, 0, 0)

	-- [[ Quest NPC model ]]

	QuestNPCModelShadowOverlay:Hide()
	QuestNPCModelBg:Hide()
	QuestNPCModel:DisableDrawLayer("OVERLAY")
	QuestNPCModelNameText:SetDrawLayer("ARTWORK")
	QuestNPCModelTextFrameBg:Hide()
	QuestNPCModelTextFrame:DisableDrawLayer("OVERLAY")

	local npcbd = CreateFrame("Frame", nil, QuestNPCModel)
	npcbd:SetPoint("TOPLEFT", -1, 1)
	npcbd:SetPoint("RIGHT", 2, 0)
	npcbd:SetPoint("BOTTOM", QuestNPCModelTextScrollFrame)
	npcbd:SetFrameLevel(0)
	A:CreateBD(npcbd)

	local npcLine = CreateFrame("Frame", nil, QuestNPCModel)
	npcLine:SetPoint("BOTTOMLEFT", 0, -1)
	npcLine:SetPoint("BOTTOMRIGHT", 1, -1)
	npcLine:SetHeight(1)
	npcLine:SetFrameLevel(0)
	A:CreateBD(npcLine, 0)

	hooksecurefunc("QuestFrame_ShowQuestPortrait", function(parentFrame, _, _, _, x, y)
		if parentFrame == QuestLogPopupDetailFrame or parentFrame == QuestFrame then
			x = x + 3
		end

		QuestNPCModel:SetPoint("TOPLEFT", parentFrame, "TOPRIGHT", x, y)
	end)

	A:ReskinScroll(QuestNPCModelTextScrollFrameScrollBar)
	
	--QuestInfo
	-- [[ Item reward highlight ]]

	QuestInfoItemHighlight:GetRegions():Hide()

	local function clearHighlight()
		for _, button in pairs(QuestInfoRewardsFrame.RewardButtons) do
			button.bg:SetBackdropColor(0, 0, 0, .25)
		end
	end

	local function setHighlight(self)
		clearHighlight()

		local _, point = self:GetPoint()
		if point then
			point.bg:SetBackdropColor(r, g, b, .2)
		end
	end

	hooksecurefunc(QuestInfoItemHighlight, "SetPoint", setHighlight)
	QuestInfoItemHighlight:HookScript("OnShow", setHighlight)
	QuestInfoItemHighlight:HookScript("OnHide", clearHighlight)

	-- [[ Shared ]]

	local function restyleSpellButton(bu)
		local name = bu:GetName()
		local icon = bu.Icon

		_G[name.."NameFrame"]:Hide()
		_G[name.."SpellBorder"]:Hide()

		icon:SetPoint("TOPLEFT", 3, -2)
		icon:SetDrawLayer("ARTWORK")
		icon:SetTexCoord(.08, .92, .08, .92)
		A:CreateBG(icon)

		local bg = CreateFrame("Frame", nil, bu)
		bg:SetPoint("TOPLEFT", 2, -1)
		bg:SetPoint("BOTTOMRIGHT", 0, 14)
		bg:SetFrameLevel(0)
		A:CreateBD(bg, .25)
	end

	-- [[ Objectives ]]

	restyleSpellButton(QuestInfoSpellObjectiveFrame)

	local function colourObjectivesText()
		if not QuestInfoFrame.questLog then return end

		local objectivesTable = QuestInfoObjectivesFrame.Objectives
		local numVisibleObjectives = 0

		for i = 1, GetNumQuestLeaderBoards() do
			local text, type, finished = GetQuestLogLeaderBoard(i)

			if (type ~= "spell" and type ~= "log" and numVisibleObjectives < MAX_OBJECTIVES) then
				numVisibleObjectives = numVisibleObjectives + 1
				local objective = objectivesTable[numVisibleObjectives]

				if finished then
					objective:SetTextColor(.9, .9, .9)
				else
					objective:SetTextColor(1, 1, 1)
				end
			end
		end
	end

	hooksecurefunc("QuestMapFrame_ShowQuestDetails", colourObjectivesText)
	hooksecurefunc("QuestInfo_Display", colourObjectivesText)

	-- [[ Quest rewards ]]

	restyleSpellButton(QuestInfoRewardSpell)

	local function restyleRewardButton(bu, isMapQuestInfo)
		bu.NameFrame:Hide()

		bu.Icon:SetTexCoord(.08, .92, .08, .92)
		bu.Icon:SetDrawLayer("BACKGROUND", 1)
		A:CreateBG(bu.Icon, 1)

		local bg = CreateFrame("Frame", nil, bu)
		bg:SetPoint("TOPLEFT", bu, 1, 1)

		if isMapQuestInfo then
			bg:SetPoint("BOTTOMRIGHT", bu, -3, 0)
			bu.Icon:SetSize(29, 29)
		else
			bg:SetPoint("BOTTOMRIGHT", bu, -3, 1)
		end

		bg:SetFrameLevel(0)
		A:CreateBD(bg, .25)

		bu.bg = bg
	end

	hooksecurefunc("QuestInfo_GetRewardButton", function(rewardsFrame, index)
		local bu = rewardsFrame.RewardButtons[index]

		if not bu.restyled then
			restyleRewardButton(bu, rewardsFrame == MapQuestInfoRewardsFrame)

			bu.restyled = true
		end
	end)

	restyleRewardButton(QuestInfoSkillPointFrame)
	restyleRewardButton(MapQuestInfoRewardsFrame.SpellFrame, true)
	restyleRewardButton(MapQuestInfoRewardsFrame.XPFrame, true)
	restyleRewardButton(MapQuestInfoRewardsFrame.MoneyFrame, true)
	restyleRewardButton(MapQuestInfoRewardsFrame.SkillPointFrame, true)

	MapQuestInfoRewardsFrame.XPFrame.Name:SetShadowOffset(0, 0)

	-- [[ Change text colours ]]

	hooksecurefunc(QuestInfoRequiredMoneyText, "SetTextColor", function(self, r, g, b)
		if r == 0 then
			self:SetTextColor(.8, .8, .8)
		elseif r == .2 then
			self:SetTextColor(1, 1, 1)
		end
	end)

	QuestInfoTitleHeader:SetTextColor(1, 1, 1)
	QuestInfoTitleHeader.SetTextColor = S.dummy
	QuestInfoTitleHeader:SetShadowColor(0, 0, 0)

	QuestInfoDescriptionHeader:SetTextColor(1, 1, 1)
	QuestInfoDescriptionHeader.SetTextColor = S.dummy
	QuestInfoDescriptionHeader:SetShadowColor(0, 0, 0)

	QuestInfoObjectivesHeader:SetTextColor(1, 1, 1)
	QuestInfoObjectivesHeader.SetTextColor = S.dummy
	QuestInfoObjectivesHeader:SetShadowColor(0, 0, 0)

	QuestInfoRewardsFrame.Header:SetTextColor(1, 1, 1)
	QuestInfoRewardsFrame.Header.SetTextColor = S.dummy
	QuestInfoRewardsFrame.Header:SetShadowColor(0, 0, 0)

	QuestInfoDescriptionText:SetTextColor(1, 1, 1)
	QuestInfoDescriptionText.SetTextColor = S.dummy

	QuestInfoObjectivesText:SetTextColor(1, 1, 1)
	QuestInfoObjectivesText.SetTextColor = S.dummy

	QuestInfoGroupSize:SetTextColor(1, 1, 1)
	QuestInfoGroupSize.SetTextColor = S.dummy

	QuestInfoRewardText:SetTextColor(1, 1, 1)
	QuestInfoRewardText.SetTextColor = S.dummy

	QuestInfoSpellObjectiveLearnLabel:SetTextColor(1, 1, 1)
	QuestInfoSpellObjectiveLearnLabel.SetTextColor = S.dummy

	QuestInfoRewardsFrame.ItemChooseText:SetTextColor(1, 1, 1)
	QuestInfoRewardsFrame.ItemChooseText.SetTextColor = S.dummy

	QuestInfoRewardsFrame.ItemReceiveText:SetTextColor(1, 1, 1)
	QuestInfoRewardsFrame.ItemReceiveText.SetTextColor = S.dummy

	QuestInfoRewardsFrame.SpellLearnText:SetTextColor(1, 1, 1)
	QuestInfoRewardsFrame.SpellLearnText.SetTextColor = S.dummy

	QuestInfoRewardsFrame.PlayerTitleText:SetTextColor(1, 1, 1)
	QuestInfoRewardsFrame.PlayerTitleText.SetTextColor = S.dummy

	QuestInfoRewardsFrame.XPFrame.ReceiveText:SetTextColor(1, 1, 1)
	QuestInfoRewardsFrame.XPFrame.ReceiveText.SetTextColor = S.dummy
	
	
	--QuestMapFrame
	
	local QuestMapFrame = QuestMapFrame

	-- [[ Quest scroll frame ]]

	local QuestScrollFrame = QuestScrollFrame
	local StoryHeader = QuestScrollFrame.Contents.StoryHeader

	QuestMapFrame.VerticalSeparator:Hide()
	QuestScrollFrame.Background:Hide()

	A:CreateBD(QuestScrollFrame.StoryTooltip)
	A:Reskin(QuestScrollFrame.ViewAll)
	A:ReskinScroll(QuestScrollFrame.ScrollBar)

	-- Story header

	StoryHeader.Background:Hide()
	StoryHeader.Shadow:Hide()

	do
		local bg = A:CreateBDFrame(StoryHeader, .25)
		bg:SetPoint("TOPLEFT", 0, -1)
		bg:SetPoint("BOTTOMRIGHT", -4, 0)

		local hl = StoryHeader.HighlightTexture

		hl:SetTexture(A.media.backdrop)
		hl:SetVertexColor(r, g, b, .2)
		hl:SetPoint("TOPLEFT", 1, -2)
		hl:SetPoint("BOTTOMRIGHT", -5, 1)
		hl:SetDrawLayer("BACKGROUND")
		hl:Hide()

		StoryHeader:HookScript("OnEnter", function()
			hl:Show()
		end)

		StoryHeader:HookScript("OnLeave", function()
			hl:Hide()
		end)
	end

	-- [[ Quest details ]]

	local DetailsFrame = QuestMapFrame.DetailsFrame
	local RewardsFrame = DetailsFrame.RewardsFrame
	local CompleteQuestFrame = DetailsFrame.CompleteQuestFrame

	DetailsFrame:GetRegions():Hide()
	select(2, DetailsFrame:GetRegions()):Hide()
	select(3, DetailsFrame:GetRegions()):Hide()
	select(6, DetailsFrame.ShareButton:GetRegions()):Hide()
	select(7, DetailsFrame.ShareButton:GetRegions()):Hide()

	A:Reskin(DetailsFrame.BackButton)
	A:Reskin(DetailsFrame.AbandonButton)
	A:Reskin(DetailsFrame.ShareButton)
	A:Reskin(DetailsFrame.TrackButton)

	DetailsFrame.AbandonButton:ClearAllPoints()
	DetailsFrame.AbandonButton:SetPoint("BOTTOMLEFT", DetailsFrame, -1, 0)
	DetailsFrame.AbandonButton:SetWidth(95)

	DetailsFrame.ShareButton:ClearAllPoints()
	DetailsFrame.ShareButton:SetPoint("LEFT", DetailsFrame.AbandonButton, "RIGHT", 1, 0)
	DetailsFrame.ShareButton:SetWidth(94)

	DetailsFrame.TrackButton:ClearAllPoints()
	DetailsFrame.TrackButton:SetPoint("LEFT", DetailsFrame.ShareButton, "RIGHT", 1, 0)
	DetailsFrame.TrackButton:SetWidth(96)

	-- Rewards frame

	RewardsFrame.Background:Hide()
	select(2, RewardsFrame:GetRegions()):Hide()

	-- Scroll frame

	A:ReskinScroll(DetailsFrame.ScrollFrame.ScrollBar)

	-- Complete quest frame
	CompleteQuestFrame:GetRegions():Hide()
	select(2, CompleteQuestFrame:GetRegions()):Hide()
	select(6, CompleteQuestFrame.CompleteButton:GetRegions()):Hide()
	select(7, CompleteQuestFrame.CompleteButton:GetRegions()):Hide()

	A:Reskin(CompleteQuestFrame.CompleteButton)

	-- [[ Quest log popup detail frame ]]

	local QuestLogPopupDetailFrame = QuestLogPopupDetailFrame

	select(18, QuestLogPopupDetailFrame:GetRegions()):Hide()
	QuestLogPopupDetailFramePageBg:Hide()
	QuestLogPopupDetailFrameScrollFrameTop:Hide()
	QuestLogPopupDetailFrameScrollFrameBottom:Hide()
	QuestLogPopupDetailFrameScrollFrameMiddle:Hide()

	A:ReskinPortraitFrame(QuestLogPopupDetailFrame, true)
	A:ReskinScroll(QuestLogPopupDetailFrameScrollFrameScrollBar)
	A:Reskin(QuestLogPopupDetailFrame.AbandonButton)
	A:Reskin(QuestLogPopupDetailFrame.TrackButton)
	A:Reskin(QuestLogPopupDetailFrame.ShareButton)

	-- Show map button

	local ShowMapButton = QuestLogPopupDetailFrame.ShowMapButton

	ShowMapButton.Texture:Hide()
	ShowMapButton.Highlight:SetTexture("")
	ShowMapButton.Highlight:SetTexture("")

	ShowMapButton:SetSize(ShowMapButton.Text:GetStringWidth() + 14, 22)
	ShowMapButton.Text:ClearAllPoints()
	ShowMapButton.Text:SetPoint("CENTER", 1, 0)

	ShowMapButton:ClearAllPoints()
	ShowMapButton:SetPoint("TOPRIGHT", QuestLogPopupDetailFrame, -30, -25)

	A:Reskin(ShowMapButton)

	ShowMapButton:HookScript("OnEnter", function(self)
		self.Text:SetTextColor(GameFontHighlight:GetTextColor())
	end)

	ShowMapButton:HookScript("OnLeave", function(self)
		self.Text:SetTextColor(GameFontNormal:GetTextColor())
	end)

	-- Bottom buttons

	QuestLogPopupDetailFrame.ShareButton:ClearAllPoints()
	QuestLogPopupDetailFrame.ShareButton:SetPoint("LEFT", QuestLogPopupDetailFrame.AbandonButton, "RIGHT", 1, 0)
	QuestLogPopupDetailFrame.ShareButton:SetPoint("RIGHT", QuestLogPopupDetailFrame.TrackButton, "LEFT", -1, 0)
	
	--QueueStatusFrame
	
	for i = 1, 9 do
		select(i, QueueStatusFrame:GetRegions()):Hide()
	end

	A:CreateBD(QueueStatusFrame)

	hooksecurefunc("QueueStatusFrame_GetEntry", function(self, entryIndex)
		local entry = self.StatusEntries[entryIndex]

		if not entry.styled then
			for _, roleButton in pairs({entry.HealersFound, entry.TanksFound, entry.DamagersFound}) do
				--roleButton.Texture:SetTexture(A.media.roleIcons)
				--roleButton.Cover:SetTexture(A.media.roleIcons)

				local left = roleButton:CreateTexture(nil, "OVERLAY")
				left:SetWidth(1)
				left:SetTexture(A.media.backdrop)
				left:SetVertexColor(0, 0, 0)
				left:SetPoint("TOPLEFT", 5, -3)
				left:SetPoint("BOTTOMLEFT", 5, 6)

				local right = roleButton:CreateTexture(nil, "OVERLAY")
				right:SetWidth(1)
				right:SetTexture(A.media.backdrop)
				right:SetVertexColor(0, 0, 0)
				right:SetPoint("TOPRIGHT", -4, -3)
				right:SetPoint("BOTTOMRIGHT", -4, 6)

				local top = roleButton:CreateTexture(nil, "OVERLAY")
				top:SetHeight(1)
				top:SetTexture(A.media.backdrop)
				top:SetVertexColor(0, 0, 0)
				top:SetPoint("TOPLEFT", 5, -3)
				top:SetPoint("TOPRIGHT", -4, -3)

				local bottom = roleButton:CreateTexture(nil, "OVERLAY")
				bottom:SetHeight(1)
				bottom:SetTexture(A.media.backdrop)
				bottom:SetVertexColor(0, 0, 0)
				bottom:SetPoint("BOTTOMLEFT", 5, 6)
				bottom:SetPoint("BOTTOMRIGHT", -4, 6)
			end

			for i = 1, LFD_NUM_ROLES do
				local roleIcon = entry["RoleIcon"..i]

				--roleIcon:SetTexture(A.media.roleIcons)

				entry["RoleIconBorders"..i] = {}
				local borders = entry["RoleIconBorders"..i]

				local left = entry:CreateTexture(nil, "OVERLAY")
				left:SetWidth(1)
				left:SetTexture(A.media.backdrop)
				left:SetVertexColor(0, 0, 0)
				left:SetPoint("TOPLEFT", roleIcon, 2, -2)
				left:SetPoint("BOTTOMLEFT", roleIcon, 2, 3)
				tinsert(borders, left)

				local right = entry:CreateTexture(nil, "OVERLAY")
				right:SetWidth(1)
				right:SetTexture(A.media.backdrop)
				right:SetVertexColor(0, 0, 0)
				right:SetPoint("TOPRIGHT", roleIcon, -2, -2)
				right:SetPoint("BOTTOMRIGHT", roleIcon, -2, 3)
				tinsert(borders, right)

				local top = entry:CreateTexture(nil, "OVERLAY")
				top:SetHeight(1)
				top:SetTexture(A.media.backdrop)
				top:SetVertexColor(0, 0, 0)
				top:SetPoint("TOPLEFT", roleIcon, 2, -2)
				top:SetPoint("TOPRIGHT", roleIcon, -2, -2)
				tinsert(borders, top)

				local bottom = entry:CreateTexture(nil, "OVERLAY")
				bottom:SetHeight(1)
				bottom:SetTexture(A.media.backdrop)
				bottom:SetVertexColor(0, 0, 0)
				bottom:SetPoint("BOTTOMLEFT", roleIcon, 2, 3)
				bottom:SetPoint("BOTTOMRIGHT", roleIcon, -2, 3)
				tinsert(borders, bottom)
			end

			entry.styled = true
		end
	end)

	hooksecurefunc("QueueStatusEntry_SetMinimalDisplay", function(entry)
		for i = 1, LFD_NUM_ROLES do
			for _, border in pairs(entry["RoleIconBorders"..i]) do
				border:Hide()
			end
		end
	end)

	hooksecurefunc("QueueStatusEntry_SetFullDisplay", function(entry)
		for i = 1, LFD_NUM_ROLES do
			local shown = entry["RoleIcon"..i]:IsShown()

			for _, border in pairs(entry["RoleIconBorders"..i]) do
				border:SetShown(shown)
			end
		end
	end)
	
	----QuestTitleButton 按钮颜色 MAX_NUM_QUESTS
	hooksecurefunc("QuestFrameGreetingPanel_OnShow", function()
		for i = 1, MAX_NUM_QUESTS do
			local questTitleButton = _G["QuestTitleButton"..i]
			if questTitleButton then
				local text = questTitleButton:GetText()
				if text and text:find("|cff000000") then
					text = string.gsub(text, "|cff000000", "|cffFFFF00")
					questTitleButton:SetText(text)
				elseif text then
					text = string.gsub(text, "|cff......", "|cffFFFFFF")
					questTitleButton:SetText(text)
					questTitleButton:GetFontString():SetTextColor(1, 1, 1)
				end
			end
		end
	end)
end

A:RegisterSkin("SunUI", LoadSkin)