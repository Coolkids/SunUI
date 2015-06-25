local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local A = S:GetModule("Skins")

local function LoadSkin()
	local r, g, b = RAID_CLASS_COLORS[S.myclass].r, RAID_CLASS_COLORS[S.myclass].g, RAID_CLASS_COLORS[S.myclass].b

	EncounterJournalEncounterFrameInfo:DisableDrawLayer("BACKGROUND")
	EncounterJournal:DisableDrawLayer("BORDER")
	EncounterJournalInset:DisableDrawLayer("BORDER")
	EncounterJournalNavBar:DisableDrawLayer("BORDER")
	EncounterJournalSearchResults:DisableDrawLayer("BORDER")
	EncounterJournal:DisableDrawLayer("OVERLAY")
	EncounterJournalInstanceSelectDungeonTab:DisableDrawLayer("OVERLAY")
	EncounterJournalInstanceSelectRaidTab:DisableDrawLayer("OVERLAY")

	EncounterJournalPortrait:Hide()
	EncounterJournalInstanceSelectBG:Hide()
	EncounterJournalNavBar:GetRegions():Hide()
	EncounterJournalNavBarOverlay:Hide()
	EncounterJournalBg:Hide()
	EncounterJournalTitleBg:Hide()
	EncounterJournalInsetBg:Hide()
	EncounterJournalInstanceSelectDungeonTabMid:Hide()
	EncounterJournalInstanceSelectDungeonTabLeft:Hide()
	EncounterJournalInstanceSelectDungeonTabRight:Hide()
	EncounterJournalInstanceSelectRaidTabMid:Hide()
	EncounterJournalInstanceSelectRaidTabLeft:Hide()
	EncounterJournalInstanceSelectRaidTabRight:Hide()
	EncounterJournalNavBarHomeButtonLeft:Hide()
	for i = 8, 10 do
		select(i, EncounterJournalInstanceSelectDungeonTab:GetRegions()):SetAlpha(0)
		select(i, EncounterJournalInstanceSelectRaidTab:GetRegions()):SetAlpha(0)
	end
	EncounterJournalEncounterFrameInfoModelFrameShadow:Hide()
	EncounterJournalEncounterFrameInfoModelFrame.dungeonBG:Hide()
	EncounterJournalEncounterFrameInfoDifficultyUpLeft:SetAlpha(0)
	EncounterJournalEncounterFrameInfoDifficultyUpRIGHT:SetAlpha(0)
	EncounterJournalEncounterFrameInfoDifficultyDownLeft:SetAlpha(0)
	EncounterJournalEncounterFrameInfoDifficultyDownRIGHT:SetAlpha(0)
	select(5, EncounterJournalEncounterFrameInfoDifficulty:GetRegions()):Hide()
	select(6, EncounterJournalEncounterFrameInfoDifficulty:GetRegions()):Hide()
	EncounterJournalEncounterFrameInfoLootScrollFrameFilterToggleUpLeft:SetAlpha(0)
	EncounterJournalEncounterFrameInfoLootScrollFrameFilterToggleUpRIGHT:SetAlpha(0)
	EncounterJournalEncounterFrameInfoLootScrollFrameFilterToggleDownLeft:SetAlpha(0)
	EncounterJournalEncounterFrameInfoLootScrollFrameFilterToggleDownRIGHT:SetAlpha(0)
	select(5, EncounterJournalEncounterFrameInfoLootScrollFrameFilterToggle:GetRegions()):Hide()
	select(6, EncounterJournalEncounterFrameInfoLootScrollFrameFilterToggle:GetRegions()):Hide()
	EncounterJournalSearchResultsBg:Hide()

	A:SetBD(EncounterJournal)
	A:CreateBD(EncounterJournalSearchResults, .75)

	-- [[ Dungeon / raid tabs ]]

	local function onEnable(self)
		self:SetHeight(self.storedHeight) -- prevent it from resizing
		self:SetBackdropColor(0, 0, 0, 0)
	end

	local function onDisable(self)
		self:SetBackdropColor(r, g, b, .2)
	end

	local function onClick(self)
		self:GetFontString():SetTextColor(1, 1, 1)
	end

	for _, tabName in pairs({"EncounterJournalInstanceSelectSuggestTab", "EncounterJournalInstanceSelectDungeonTab", "EncounterJournalInstanceSelectRaidTab"}) do
		local tab = _G[tabName]
		local text = tab:GetFontString()

		tab:DisableDrawLayer("OVERLAY")

		tab.mid:Hide()
		tab.left:Hide()
		tab.right:Hide()

		tab.midHighlight:SetAlpha(0)
		tab.leftHighlight:SetAlpha(0)
		tab.rightHighlight:SetAlpha(0)

		tab:SetHeight(tab.storedHeight)
		tab.grayBox:GetRegions():SetAllPoints(tab)

		text:SetPoint("CENTER")
		text:SetTextColor(1, 1, 1)

		tab:HookScript("OnEnable", onEnable)
		tab:HookScript("OnDisable", onDisable)
		tab:HookScript("OnClick", onClick)

		A:Reskin(tab)
	end

	EncounterJournalInstanceSelectSuggestTab:SetBackdropColor(r, g, b, .2)

	-- [[ Side tabs ]]

	EncounterJournalEncounterFrameInfoOverviewTab:ClearAllPoints()
	EncounterJournalEncounterFrameInfoOverviewTab:SetPoint("TOPLEFT", EncounterJournalEncounterFrameInfo, "TOPRIGHT", 9, -35)
	EncounterJournalEncounterFrameInfoLootTab:ClearAllPoints()
	EncounterJournalEncounterFrameInfoLootTab:SetPoint("TOP", EncounterJournalEncounterFrameInfoOverviewTab, "BOTTOM", 0, 1)
	EncounterJournalEncounterFrameInfoBossTab:ClearAllPoints()
	EncounterJournalEncounterFrameInfoBossTab:SetPoint("TOP", EncounterJournalEncounterFrameInfoLootTab, "BOTTOM", 0, 1)

	local tabs = {EncounterJournalEncounterFrameInfoOverviewTab, EncounterJournalEncounterFrameInfoLootTab, EncounterJournalEncounterFrameInfoBossTab, EncounterJournalEncounterFrameInfoModelTab}
	for _, tab in pairs(tabs) do
		tab:SetScale(.75)

		tab:SetBackdrop({
			bgFile = A["media"].backdrop,
			edgeFile = A["media"].backdrop,
			edgeSize = 1 / .75,
		})

		tab:SetBackdropColor(0, 0, 0, .5)
		tab:SetBackdropBorderColor(0, 0, 0)

		tab:SetNormalTexture("")
		tab:SetPushedTexture("")
		tab:SetDisabledTexture("")
		tab:SetHighlightTexture("")
	end

	-- [[ Instance select ]]

	A:ReskinDropDown(EncounterJournalInstanceSelectTierDropDown)

	local index = 1

	local function listInstances()
		while true do
			local bu = EncounterJournal.instanceSelect.scroll.child["instance"..index]
			if not bu then return end

			bu:SetNormalTexture("")
			bu:SetHighlightTexture("")
			bu:SetPushedTexture("")

			bu.bgImage:SetDrawLayer("BACKGROUND", 1)

			local bg = A:CreateBG(bu.bgImage)
			bg:SetPoint("TOPLEFT", 3, -3)
			bg:SetPoint("BOTTOMRIGHT", -4, 2)

			index = index + 1
		end
	end

	hooksecurefunc("EncounterJournal_ListInstances", listInstances)
	listInstances()

	-- [[ Encounter frame ]]

	EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollChildHeader:Hide()
	EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollChildTitle:SetFontObject("GameFontNormalLarge")

	EncounterJournalEncounterFrameInfoEncounterTitle:SetTextColor(1, 1, 1)
	EncounterJournalEncounterFrameInstanceFrameLoreScrollFrameScrollChildLore:SetTextColor(1, 1, 1)
	EncounterJournalEncounterFrameInfoDetailsScrollFrameScrollChildDescription:SetTextColor(1, 1, 1)
	EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollChildLoreDescription:SetTextColor(1, 1, 1)
	EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollChildTitle:SetTextColor(1, 1, 1)
	EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollChild.overviewDescription.Text:SetTextColor(1, 1, 1)

	A:CreateBDFrame(EncounterJournalEncounterFrameInfoModelFrame, .25)

	EncounterJournalEncounterFrameInfoCreatureButton1:SetPoint("TOPLEFT", EncounterJournalEncounterFrameInfoModelFrame, 0, -35)

	do
		local numBossButtons = 1
		local bossButton

		hooksecurefunc("EncounterJournal_DisplayInstance", function()
			bossButton = _G["EncounterJournalBossButton"..numBossButtons]
			while bossButton do
				A:Reskin(bossButton, true)

				bossButton.text:SetTextColor(1, 1, 1)
				bossButton.text.SetTextColor = S.dummy

				local hl = bossButton:GetHighlightTexture()
				hl:SetTexture(r, g, b, .2)
				hl:SetPoint("TOPLEFT", 2, -1)
				hl:SetPoint("BOTTOMRIGHT", 0, 1)

				bossButton.creature:SetPoint("TOPLEFT", 0, -4)

				numBossButtons = numBossButtons + 1
				bossButton = _G["EncounterJournalBossButton"..numBossButtons]
			end

			-- move last tab
			local _, point = EncounterJournalEncounterFrameInfoModelTab:GetPoint()
			EncounterJournalEncounterFrameInfoModelTab:SetPoint("TOP", point, "BOTTOM", 0, 1)
		end)
	end

	hooksecurefunc("EncounterJournal_ToggleHeaders", function(self)
		local index = 1
		local header = _G["EncounterJournalInfoHeader"..index]
		while header do
			if not header.styled then
				header.flashAnim.Play = S.dummy

				header.descriptionBG:SetAlpha(0)
				header.descriptionBGBottom:SetAlpha(0)
				for i = 4, 18 do
					select(i, header.button:GetRegions()):SetTexture("")
				end

				header.description:SetTextColor(1, 1, 1)
				header.button.title:SetTextColor(1, 1, 1)
				header.button.title.SetTextColor = S.dummy
				header.button.expandedIcon:SetTextColor(1, 1, 1)
				header.button.expandedIcon.SetTextColor = S.dummy

				A:Reskin(header.button)

				header.button.abilityIcon:SetTexCoord(.08, .92, .08, .92)
				header.button.bg = A:CreateBG(header.button.abilityIcon)

				header.styled = true
			end

			if header.button.abilityIcon:IsShown() then
				header.button.bg:Show()
			else
				header.button.bg:Hide()
			end

			index = index + 1
			header = _G["EncounterJournalInfoHeader"..index]
		end
	end)

	hooksecurefunc("EncounterJournal_SetUpOverview", function(self, role, index)
		local header = self.overviews[index]
		if not header.styled then
			header.flashAnim.Play = S.dummy

			header.descriptionBG:SetAlpha(0)
			header.descriptionBGBottom:SetAlpha(0)
			for i = 4, 18 do
				select(i, header.button:GetRegions()):SetTexture("")
			end

			header.button.title:SetTextColor(1, 1, 1)
			header.button.title.SetTextColor = S.dummy
			header.button.expandedIcon:SetTextColor(1, 1, 1)
			header.button.expandedIcon.SetTextColor = S.dummy

			A:Reskin(header.button)

			header.styled = true
		end
	end)

	hooksecurefunc("EncounterJournal_SetBullets", function(object, description)
		local parent = object:GetParent()

		if parent.Bullets then
			for _, bullet in pairs(parent.Bullets) do
				if not bullet.styled then
					bullet.Text:SetTextColor(1, 1, 1)
					bullet.styled = true
				end
			end
		end
	end)

	local items = EncounterJournal.encounter.info.lootScroll.buttons

	for i = 1, #items do
		local item = items[i]

		item.boss:SetTextColor(1, 1, 1)
		item.slot:SetTextColor(1, 1, 1)
		item.armorType:SetTextColor(1, 1, 1)

		item.bossTexture:SetAlpha(0)
		item.bosslessTexture:SetAlpha(0)

		item.icon:SetPoint("TOPLEFT", 1, -1)

		item.icon:SetTexCoord(.08, .92, .08, .92)
		item.icon:SetDrawLayer("OVERLAY")
		A:CreateBG(item.icon)

		local bg = CreateFrame("Frame", nil, item)
		bg:SetPoint("TOPLEFT")
		bg:SetPoint("BOTTOMRIGHT", 0, 1)
		bg:SetFrameLevel(item:GetFrameLevel() - 1)
		A:CreateBD(bg, .25)
	end

	-- [[ Search results ]]

	EncounterJournalSearchResultsBg:Hide()
	for i = 3, 11 do
		select(i, EncounterJournalSearchResults:GetRegions()):Hide()
	end

	A:CreateBD(EncounterJournalSearchResults)
	EncounterJournalSearchResults:SetBackdropColor(.15, .15, .15, .9)

	EncounterJournalSearchBoxSearchButton1BotLeftCorner:Hide()
	EncounterJournalSearchBoxSearchButton1BotRightCorner:Hide()
	EncounterJournalSearchBoxSearchButton1BottomBorder:Hide()
	EncounterJournalSearchBoxSearchButton1LeftBorder:Hide()
	EncounterJournalSearchBoxSearchButton1RightBorder:Hide()

	local function resultOnEnter(self)
		self.hl:Show()
	end

	local function resultOnLeave(self)
		self.hl:Hide()
	end

	local function styleSearchButton(result, index)
		if index == 1 then
			result:SetPoint("TOPLEFT", EncounterJournalSearchBox, "BOTTOMLEFT", 0, 1)
			result:SetPoint("TOPRIGHT", EncounterJournalSearchBox, "BOTTOMRIGHT", -5, 1)
		else
			result:SetPoint("TOPLEFT", EncounterJournalSearchBox["sbutton"..index-1], "BOTTOMLEFT", 0, 1)
			result:SetPoint("TOPRIGHT", EncounterJournalSearchBox["sbutton"..index-1], "BOTTOMRIGHT", 0, 1)
		end

		result:SetNormalTexture("")
		result:SetPushedTexture("")
		result:SetHighlightTexture("")

		local hl = result:CreateTexture(nil, "BACKGROUND")
		hl:SetAllPoints()
		hl:SetTexture(A["media"].backdrop)
		hl:SetVertexColor(r, g, b, .2)
		hl:Hide()
		result.hl = hl

		A:CreateBD(result)
		result:SetBackdropColor(.1, .1, .1, .9)

		if result.icon then
			result:GetRegions():Hide() -- icon frame

			result.icon:SetTexCoord(.08, .92, .08, .92)

			local bg = A:CreateBG(result.icon)
			bg:SetDrawLayer("BACKGROUND", 1)
		end

		result:HookScript("OnEnter", resultOnEnter)
		result:HookScript("OnLeave", resultOnLeave)
	end

	for i = 1, 5 do
		styleSearchButton(EncounterJournalSearchBox["sbutton"..i], i)
	end

	styleSearchButton(EncounterJournalSearchBox.showAllResults, 6)

	hooksecurefunc("EncounterJournal_SearchUpdate", function()
		local scrollFrame = EncounterJournal.searchResults.scrollFrame
		local offset = HybridScrollFrame_GetOffset(scrollFrame)
		local results = scrollFrame.buttons
		local result, index

		local numResults = EJ_GetNumSearchResults()

		for i = 1, #results do
			result = results[i]
			index = offset + i

			if index <= numResults then
				if not result.styled then
					result:SetNormalTexture("")
					result:SetPushedTexture("")
					result:GetRegions():Hide()

					result.resultType:SetTextColor(1, 1, 1)
					result.path:SetTextColor(1, 1, 1)

					A:CreateBG(result.icon)

					result.styled = true
				end

				if result.icon:GetTexCoord() == 0 then
					result.icon:SetTexCoord(.08, .92, .08, .92)
				end
			end
		end
	end)

	hooksecurefunc(EncounterJournal.searchResults.scrollFrame, "update", function(self)
		for i = 1, #self.buttons do
			local result = self.buttons[i]

			if result.icon:GetTexCoord() == 0 then
				result.icon:SetTexCoord(.08, .92, .08, .92)
			end
		end
	end)

	A:ReskinClose(EncounterJournalSearchResultsCloseButton)
	A:ReskinScroll(EncounterJournalSearchResultsScrollFrameScrollBar)

	-- [[ Various controls ]]

	A:Reskin(EncounterJournalNavBarHomeButton)
	A:Reskin(EncounterJournalInstanceSelectDungeonTab)
	A:Reskin(EncounterJournalInstanceSelectRaidTab)
	A:Reskin(EncounterJournalEncounterFrameInfoDifficulty)
	A:Reskin(EncounterJournalEncounterFrameInfoResetButton)
	A:Reskin(EncounterJournalEncounterFrameInfoLootScrollFrameFilterToggle)
	A:ReskinClose(EncounterJournalCloseButton)
	A:ReskinInput(EncounterJournalSearchBox)
	A:ReskinScroll(EncounterJournalInstanceSelectScrollFrameScrollBar)
	A:ReskinScroll(EncounterJournalEncounterFrameInstanceFrameLoreScrollFrameScrollBar)
	A:ReskinScroll(EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollBar)
	A:ReskinScroll(EncounterJournalEncounterFrameInfoBossesScrollFrameScrollBar)
	A:ReskinScroll(EncounterJournalEncounterFrameInfoDetailsScrollFrameScrollBar)
	A:ReskinScroll(EncounterJournalEncounterFrameInfoLootScrollFrameScrollBar)

	-- [[ Suggest frame ]]

	local suggestFrame = EncounterJournal.suggestFrame

	-- Tooltip

	local EncounterJournalTooltip = EncounterJournalTooltip

	A:CreateBD(EncounterJournalTooltip)

	EncounterJournalTooltip.Item1.newBg = A:ReskinIcon(EncounterJournalTooltip.Item1.icon)
	EncounterJournalTooltip.Item2.newBg = A:ReskinIcon(EncounterJournalTooltip.Item2.icon)

	local function rewardOnEnter()
		for i = 1, 2 do
			local item = EncounterJournalTooltip["Item"..i]
			if item:IsShown() then
				if item.IconBorder:IsShown() then
					item.newBg:SetVertexColor(item.IconBorder:GetVertexColor())
					item.IconBorder:Hide()
				else
					item.newBg:SetVertexColor(0, 0, 0)
				end
			end
		end
	end

	-- Suggestion 1

	local suggestion = suggestFrame.Suggestion1

	suggestion.bg:Hide()

	A:CreateBD(suggestion, .25)

	suggestion.icon:SetPoint("TOPLEFT", 135, -15)
	A:CreateBG(suggestion.icon)

	local centerDisplay = suggestion.centerDisplay

	centerDisplay.title.text:SetTextColor(1, 1, 1)
	centerDisplay.description.text:SetTextColor(.9, .9, .9)

	A:Reskin(suggestion.button)

	local reward = suggestion.reward

	reward:HookScript("OnEnter", rewardOnEnter)
	reward.text:SetTextColor(.9, .9, .9)
	reward.iconRing:Hide()
	reward.iconRingHighlight:SetTexture("")
	A:CreateBG(reward.icon)

	A:ReskinArrow(suggestion.prevButton, "left")
	A:ReskinArrow(suggestion.nextButton, "right")

	-- Suggestion 2 and 3

	for i = 2, 3 do
		local suggestion = suggestFrame["Suggestion"..i]

		suggestion.bg:Hide()

		A:CreateBD(suggestion, .25)

		suggestion.icon:SetPoint("TOPLEFT", 10, -10)
		A:CreateBG(suggestion.icon)

		local centerDisplay = suggestion.centerDisplay

		centerDisplay:ClearAllPoints()
		centerDisplay:SetPoint("TOPLEFT", 85, -10)
		centerDisplay.title.text:SetTextColor(1, 1, 1)
		centerDisplay.description.text:SetTextColor(.9, .9, .9)

		A:Reskin(centerDisplay.button)

		local reward = suggestion.reward

		reward:HookScript("OnEnter", rewardOnEnter)
		reward.iconRing:Hide()
		reward.iconRingHighlight:SetTexture("")
		A:CreateBG(reward.icon)
	end

	-- Hook functions

	hooksecurefunc("EJSuggestFrame_RefreshDisplay", function()
		local self = suggestFrame

		if #self.suggestions > 0 then
			local suggestion = self.Suggestion1
			local data = self.suggestions[1]

			suggestion.iconRing:Hide()

			if data.iconPath then
				suggestion.icon:SetMask(nil)
				suggestion.icon:SetTexCoord(.08, .92, .08, .92)
			end
		end

		if #self.suggestions > 1 then
			for i = 2, #self.suggestions do
				local suggestion = self["Suggestion"..i]
				if not suggestion then break end

				local data = self.suggestions[i]

				suggestion.iconRing:Hide()

				if data.iconPath then
					suggestion.icon:SetMask(nil)
					suggestion.icon:SetTexCoord(.08, .92, .08, .92)
				end
			end
		end
	end)

	hooksecurefunc("EJSuggestFrame_UpdateRewards", function(suggestion)
		if suggestion.reward.data then
			suggestion.reward.icon:SetMask(nil)
			suggestion.reward.icon:SetTexCoord(.08, .92, .08, .92)
		end
	end)
end

A:RegisterSkin("Blizzard_EncounterJournal", LoadSkin)
