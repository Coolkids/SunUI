local S, L, DB, _, C = unpack(select(2, ...))

local r, g, b = DB.MyClassColor.r, DB.MyClassColor.g, DB.MyClassColor.b
local AuroraConfig = DB.AuroraConfig
DB.AuroraModules["Blizzard_AchievementUI"] = function()
	

	S.CreateBD(AchievementFrame)
	S.CreateSD(AchievementFrame)
	AchievementFrameCategories:SetBackdrop(nil)
	AchievementFrameSummary:SetBackdrop(nil)
	for i = 1, 17 do
		select(i, AchievementFrame:GetRegions()):Hide()
	end
	AchievementFrameSummaryBackground:Hide()
	AchievementFrameSummary:GetChildren():Hide()
	AchievementFrameCategoriesContainerScrollBarBG:SetAlpha(0)
	for i = 1, 4 do
		select(i, AchievementFrameHeader:GetRegions()):Hide()
	end
	AchievementFrameHeaderRightDDLInset:SetAlpha(0)
	select(2, AchievementFrameAchievements:GetChildren()):Hide()
	AchievementFrameAchievementsBackground:Hide()
	select(3, AchievementFrameAchievements:GetRegions()):Hide()
	AchievementFrameStatsBG:Hide()
	AchievementFrameSummaryAchievementsHeaderHeader:Hide()
	AchievementFrameSummaryCategoriesHeaderTexture:Hide()
	select(3, AchievementFrameStats:GetChildren()):Hide()
	select(5, AchievementFrameComparison:GetChildren()):Hide()
	AchievementFrameComparisonHeaderBG:Hide()
	AchievementFrameComparisonHeaderPortrait:Hide()
	AchievementFrameComparisonHeaderPortraitBg:Hide()
	AchievementFrameComparisonBackground:Hide()
	AchievementFrameComparisonDark:SetAlpha(0)
	AchievementFrameComparisonSummaryPlayerBackground:Hide()
	AchievementFrameComparisonSummaryFriendBackground:Hide()

	local first = 1
	hooksecurefunc("AchievementFrameCategories_Update", function()
		if first == 1 then
			for i = 1, 19 do
				_G["AchievementFrameCategoriesContainerButton"..i.."Background"]:Hide()
			end
			first = 0
		end
	end)

	AchievementFrameHeaderPoints:Point("TOP", AchievementFrame, "TOP", 0, -6)
	AchievementFrameFilterDropDown:Point("TOPRIGHT", AchievementFrame, "TOPRIGHT", -98, 1)
	AchievementFrameFilterDropDownText:ClearAllPoints()
	AchievementFrameFilterDropDownText:Point("CENTER", -10, 1)

	AchievementFrameSummaryCategoriesStatusBar:SetStatusBarTexture(DB.media.backdrop)
	AchievementFrameSummaryCategoriesStatusBar:GetStatusBarTexture():SetGradient("VERTICAL", 0, .4, 0, 0, .6, 0)
	AchievementFrameSummaryCategoriesStatusBarLeft:Hide()
	AchievementFrameSummaryCategoriesStatusBarMiddle:Hide()
	AchievementFrameSummaryCategoriesStatusBarRight:Hide()
	AchievementFrameSummaryCategoriesStatusBarFillBar:Hide()
	AchievementFrameSummaryCategoriesStatusBarTitle:SetTextColor(1, 1, 1)
	AchievementFrameSummaryCategoriesStatusBarTitle:Point("LEFT", AchievementFrameSummaryCategoriesStatusBar, "LEFT", 6, 0)
	AchievementFrameSummaryCategoriesStatusBarText:Point("RIGHT", AchievementFrameSummaryCategoriesStatusBar, "RIGHT", -5, 0)

	local bg = CreateFrame("Frame", nil, AchievementFrameSummaryCategoriesStatusBar)
	bg:Point("TOPLEFT", -1, 1)
	bg:Point("BOTTOMRIGHT", 1, -1)
	bg:SetFrameLevel(AchievementFrameSummaryCategoriesStatusBar:GetFrameLevel()-1)
	S.CreateBD(bg, .25)

	for i = 1, 3 do
		local tab = _G["AchievementFrameTab"..i]
		if tab then
			S.ReskinTab(tab)
		end
	end

	local gradOr, startR, startG, startB, startAlpha, endR, endG, endB, endAlpha = unpack(AuroraConfig.gradientAlpha)

	for i = 1, 7 do
		local bu = _G["AchievementFrameAchievementsContainerButton"..i]
		bu:DisableDrawLayer("BORDER")

		bu.background:SetTexture(DB.media.backdrop)
		bu.background:SetVertexColor(0, 0, 0, .25)

		bu.description:SetTextColor(.9, .9, .9)
		bu.description.SetTextColor = S.dummy
		bu.description:SetShadowOffset(1, -1)
		bu.description.SetShadowOffset = S.dummy

		_G["AchievementFrameAchievementsContainerButton"..i.."TitleBackground"]:Hide()
		_G["AchievementFrameAchievementsContainerButton"..i.."Glow"]:Hide()
		_G["AchievementFrameAchievementsContainerButton"..i.."RewardBackground"]:SetAlpha(0)
		_G["AchievementFrameAchievementsContainerButton"..i.."PlusMinus"]:SetAlpha(0)
		_G["AchievementFrameAchievementsContainerButton"..i.."Highlight"]:SetAlpha(0)
		_G["AchievementFrameAchievementsContainerButton"..i.."IconOverlay"]:Hide()
		_G["AchievementFrameAchievementsContainerButton"..i.."GuildCornerL"]:SetAlpha(0)
		_G["AchievementFrameAchievementsContainerButton"..i.."GuildCornerR"]:SetAlpha(0)

		local bg = CreateFrame("Frame", nil, bu)
		bg:Point("TOPLEFT", 2, -2)
		bg:Point("BOTTOMRIGHT", -2, 2)
		S.CreateBD(bg, 0)

		bu.icon.texture:SetTexCoord(.08, .92, .08, .92)
		S.CreateBG(bu.icon.texture)

		-- can't get a backdrop frame to appear behind the checked texture for some reason

		local ch = bu.tracked

		ch:SetNormalTexture("")
		ch:SetPushedTexture("")
		ch:SetHighlightTexture(DB.media.backdrop)

		local hl = ch:GetHighlightTexture()
		hl:Point("TOPLEFT", 4, -4)
		hl:Point("BOTTOMRIGHT", -4, 4)
		hl:SetVertexColor(r, g, b, .2)

		local check = ch:GetCheckedTexture()
		check:SetDesaturated(true)
		check:SetVertexColor(r, g, b)

		local tex = ch:CreateTexture(nil, "BACKGROUND")
		tex:Point("TOPLEFT", 4, -4)
		tex:Point("BOTTOMRIGHT", -4, 4)
		tex:SetTexture(DB.media.backdrop)
		tex:SetGradientAlpha(gradOr, startR, startG, startB, startAlpha, endR, endG, endB, endAlpha)

		local left = ch:CreateTexture(nil, "BACKGROUND")
		left:Width(1)
		left:SetTexture(0, 0, 0)
		left:Point("TOPLEFT", tex, -1, 1)
		left:Point("BOTTOMLEFT", tex, -1, -1)

		local right = ch:CreateTexture(nil, "BACKGROUND")
		right:Width(1)
		right:SetTexture(0, 0, 0)
		right:Point("TOPRIGHT", tex, 1, 1)
		right:Point("BOTTOMRIGHT", tex, 1, -1)

		local top = ch:CreateTexture(nil, "BACKGROUND")
		top:Height(1)
		top:SetTexture(0, 0, 0)
		top:Point("TOPLEFT", tex, -1, 1)
		top:Point("TOPRIGHT", tex, 1, -1)

		local bottom = ch:CreateTexture(nil, "BACKGROUND")
		bottom:Height(1)
		bottom:SetTexture(0, 0, 0)
		bottom:Point("BOTTOMLEFT", tex, -1, -1)
		bottom:Point("BOTTOMRIGHT", tex, 1, -1)
	end

	hooksecurefunc("AchievementButton_DisplayAchievement", function(button, category, achievement)
		local _, _, _, completed = GetAchievementInfo(category, achievement)
		if completed then
			if button.accountWide then
				button.label:SetTextColor(0, .6, 1)
			else
				button.label:SetTextColor(.9, .9, .9)
			end
		else
			if button.accountWide then
				button.label:SetTextColor(0, .3, .5)
			else
				button.label:SetTextColor(.65, .65, .65)
			end
		end
	end)

	hooksecurefunc("AchievementObjectives_DisplayCriteria", function(objectivesFrame, id)
		for i = 1, GetAchievementNumCriteria(id) do
			local name = _G["AchievementFrameCriteria"..i.."Name"]
			if name and select(2, name:GetTextColor()) == 0 then
				name:SetTextColor(1, 1, 1)
			end

			local bu = _G["AchievementFrameMeta"..i]
			if bu and select(2, bu.label:GetTextColor()) == 0 then
				bu.label:SetTextColor(1, 1, 1)
			end
		end
	end)

	hooksecurefunc("AchievementButton_GetProgressBar", function(index)
		local bar = _G["AchievementFrameProgressBar"..index]
		if not bar.reskinned then
			bar:SetStatusBarTexture(DB.media.backdrop)

			_G["AchievementFrameProgressBar"..index.."BG"]:SetTexture(0, 0, 0, .25)
			_G["AchievementFrameProgressBar"..index.."BorderLeft"]:Hide()
			_G["AchievementFrameProgressBar"..index.."BorderCenter"]:Hide()
			_G["AchievementFrameProgressBar"..index.."BorderRight"]:Hide()

			local bg = CreateFrame("Frame", nil, bar)
			bg:Point("TOPLEFT", -1, 1)
			bg:Point("BOTTOMRIGHT", 1, -1)
			S.CreateBD(bg, 0)

			bar.reskinned = true
		end
	end)

	hooksecurefunc("AchievementFrameSummary_UpdateAchievements", function()
		for i = 1, ACHIEVEMENTUI_MAX_SUMMARY_ACHIEVEMENTS do
			local bu = _G["AchievementFrameSummaryAchievement"..i]

			if bu.accountWide then
				bu.label:SetTextColor(0, .6, 1)
			else
				bu.label:SetTextColor(.9, .9, .9)
			end

			if not bu.reskinned then
				bu:DisableDrawLayer("BORDER")

				local bd = _G["AchievementFrameSummaryAchievement"..i.."Background"]

				bd:SetTexture(DB.media.backdrop)
				bd:SetVertexColor(0, 0, 0, .25)

				_G["AchievementFrameSummaryAchievement"..i.."TitleBackground"]:Hide()
				_G["AchievementFrameSummaryAchievement"..i.."Glow"]:Hide()
				_G["AchievementFrameSummaryAchievement"..i.."Highlight"]:SetAlpha(0)
				_G["AchievementFrameSummaryAchievement"..i.."IconOverlay"]:Hide()

				local text = _G["AchievementFrameSummaryAchievement"..i.."Description"]
				text:SetTextColor(.9, .9, .9)
				text.SetTextColor = S.dummy
				text:SetShadowOffset(1, -1)
				text.SetShadowOffset = S.dummy

				local bg = CreateFrame("Frame", nil, bu)
				bg:Point("TOPLEFT", 2, -2)
				bg:Point("BOTTOMRIGHT", -2, 2)
				S.CreateBD(bg, 0)

				local ic = _G["AchievementFrameSummaryAchievement"..i.."IconTexture"]
				ic:SetTexCoord(.08, .92, .08, .92)
				S.CreateBG(ic)

				bu.reskinned = true
			end
		end
	end)

	for i = 1, 10 do
		local bu = _G["AchievementFrameSummaryCategoriesCategory"..i]
		local bar = bu:GetStatusBarTexture()
		local label = _G["AchievementFrameSummaryCategoriesCategory"..i.."Label"]

		bu:SetStatusBarTexture(DB.media.backdrop)
		bar:SetGradient("VERTICAL", 0, .4, 0, 0, .6, 0)
		label:SetTextColor(1, 1, 1)
		label:Point("LEFT", bu, "LEFT", 6, 0)

		local bg = CreateFrame("Frame", nil, bu)
		bg:Point("TOPLEFT", -1, 1)
		bg:Point("BOTTOMRIGHT", 1, -1)
		bg:SetFrameLevel(bu:GetFrameLevel()-1)
		S.CreateBD(bg, .25)

		_G["AchievementFrameSummaryCategoriesCategory"..i.."Left"]:Hide()
		_G["AchievementFrameSummaryCategoriesCategory"..i.."Middle"]:Hide()
		_G["AchievementFrameSummaryCategoriesCategory"..i.."Right"]:Hide()
		_G["AchievementFrameSummaryCategoriesCategory"..i.."FillBar"]:Hide()
		_G["AchievementFrameSummaryCategoriesCategory"..i.."ButtonHighlight"]:SetAlpha(0)
		_G["AchievementFrameSummaryCategoriesCategory"..i.."Text"]:Point("RIGHT", bu, "RIGHT", -5, 0)
	end

	for i = 1, 20 do
		_G["AchievementFrameStatsContainerButton"..i.."BG"]:Hide()
		_G["AchievementFrameStatsContainerButton"..i.."BG"].Show = S.dummy
		_G["AchievementFrameStatsContainerButton"..i.."HeaderLeft"]:SetAlpha(0)
		_G["AchievementFrameStatsContainerButton"..i.."HeaderMiddle"]:SetAlpha(0)
		_G["AchievementFrameStatsContainerButton"..i.."HeaderRight"]:SetAlpha(0)
	end

	AchievementFrameComparisonHeader:Point("BOTTOMRIGHT", AchievementFrameComparison, "TOPRIGHT", 39, 25)

	local headerbg = CreateFrame("Frame", nil, AchievementFrameComparisonHeader)
	headerbg:Point("TOPLEFT", 20, -20)
	headerbg:Point("BOTTOMRIGHT", -28, -5)
	headerbg:SetFrameLevel(AchievementFrameComparisonHeader:GetFrameLevel()-1)
	S.CreateBD(headerbg, .25)

	local summaries = {AchievementFrameComparisonSummaryPlayer, AchievementFrameComparisonSummaryFriend}

	for _, frame in pairs(summaries) do
		frame:SetBackdrop(nil)
		local bg = CreateFrame("Frame", nil, frame)
		bg:Point("TOPLEFT", 2, -2)
		bg:Point("BOTTOMRIGHT", -2, 0)
		bg:SetFrameLevel(frame:GetFrameLevel()-1)
		S.CreateBD(bg, .25)
	end

	local bars = {AchievementFrameComparisonSummaryPlayerStatusBar, AchievementFrameComparisonSummaryFriendStatusBar}

	for _, bar in pairs(bars) do
		local name = bar:GetName()
		bar:SetStatusBarTexture(DB.media.backdrop)
		bar:GetStatusBarTexture():SetGradient("VERTICAL", 0, .4, 0, 0, .6, 0)
		_G[name.."Left"]:Hide()
		_G[name.."Middle"]:Hide()
		_G[name.."Right"]:Hide()
		_G[name.."FillBar"]:Hide()
		_G[name.."Title"]:SetTextColor(1, 1, 1)
		_G[name.."Title"]:Point("LEFT", bar, "LEFT", 6, 0)
		_G[name.."Text"]:Point("RIGHT", bar, "RIGHT", -5, 0)

		local bg = CreateFrame("Frame", nil, bar)
		bg:Point("TOPLEFT", -1, 1)
		bg:Point("BOTTOMRIGHT", 1, -1)
		bg:SetFrameLevel(bar:GetFrameLevel()-1)
		S.CreateBD(bg, .25)
	end

	for i = 1, 9 do
		local buttons = {_G["AchievementFrameComparisonContainerButton"..i.."Player"], _G["AchievementFrameComparisonContainerButton"..i.."Friend"]}

		for _, button in pairs(buttons) do
			button:DisableDrawLayer("BORDER")
			local bg = CreateFrame("Frame", nil, button)
			bg:Point("TOPLEFT", 2, -3)
			bg:Point("BOTTOMRIGHT", -2, 2)
			S.CreateBD(bg, 0)
		end

		local bd = _G["AchievementFrameComparisonContainerButton"..i.."PlayerBackground"]
		bd:SetTexture(DB.media.backdrop)
		bd:SetVertexColor(0, 0, 0, .25)

		local bd = _G["AchievementFrameComparisonContainerButton"..i.."FriendBackground"]
		bd:SetTexture(DB.media.backdrop)
		bd:SetVertexColor(0, 0, 0, .25)

		local text = _G["AchievementFrameComparisonContainerButton"..i.."PlayerDescription"]
		text:SetTextColor(.9, .9, .9)
		text.SetTextColor = S.dummy
		text:SetShadowOffset(1, -1)
		text.SetShadowOffset = S.dummy

		_G["AchievementFrameComparisonContainerButton"..i.."PlayerTitleBackground"]:Hide()
		_G["AchievementFrameComparisonContainerButton"..i.."PlayerGlow"]:Hide()
		_G["AchievementFrameComparisonContainerButton"..i.."PlayerIconOverlay"]:Hide()
		_G["AchievementFrameComparisonContainerButton"..i.."FriendTitleBackground"]:Hide()
		_G["AchievementFrameComparisonContainerButton"..i.."FriendGlow"]:Hide()
		_G["AchievementFrameComparisonContainerButton"..i.."FriendIconOverlay"]:Hide()

		local ic = _G["AchievementFrameComparisonContainerButton"..i.."PlayerIconTexture"]
		ic:SetTexCoord(.08, .92, .08, .92)
		S.CreateBG(ic)

		local ic = _G["AchievementFrameComparisonContainerButton"..i.."FriendIconTexture"]
		ic:SetTexCoord(.08, .92, .08, .92)
		S.CreateBG(ic)
	end

	S.ReskinClose(AchievementFrameCloseButton)
	S.ReskinScroll(AchievementFrameAchievementsContainerScrollBar)
	S.ReskinScroll(AchievementFrameStatsContainerScrollBar)
	S.ReskinScroll(AchievementFrameCategoriesContainerScrollBar)
	S.ReskinScroll(AchievementFrameComparisonContainerScrollBar)
	S.ReskinDropDown(AchievementFrameFilterDropDown)
end