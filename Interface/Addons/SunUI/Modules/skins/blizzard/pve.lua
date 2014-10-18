local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local A = S:GetModule("Skins")

local function LoadSkin()
	PVEFrame:DisableDrawLayer("ARTWORK")
	PVEFrameLeftInset:DisableDrawLayer("BORDER")
	PVEFrameBlueBg:Hide()
	PVEFrameLeftInsetBg:Hide()
	PVEFrame.shadows:Hide()
	select(24, PVEFrame:GetRegions()):Hide()
	select(25, PVEFrame:GetRegions()):Hide()

	PVEFrameTab2:SetPoint("LEFT", PVEFrameTab1, "RIGHT", -15, 0)
	PVEFrameTab3:SetPoint("LEFT", PVEFrameTab2, "RIGHT", -15, 0)

	GroupFinderFrameGroupButton1.icon:SetTexture("Interface\\Icons\\INV_Helmet_08")
	GroupFinderFrameGroupButton2.icon:SetTexture("Interface\\Icons\\Icon_Scenarios")
	GroupFinderFrameGroupButton3.icon:SetTexture("Interface\\Icons\\inv_helmet_06")

	for i = 1, 4 do
		local bu = GroupFinderFrame["groupButton"..i]

		bu.ring:Hide()
		bu.bg:SetTexture(A.media.backdrop)
		bu.bg:SetVertexColor(r, g, b, .2)
		bu.bg:SetAllPoints()

		A:Reskin(bu, true)

		bu.icon:SetTexCoord(.08, .92, .08, .92)
		bu.icon:SetPoint("LEFT", bu, "LEFT")
		bu.icon:SetDrawLayer("OVERLAY")
		bu.icon.bg = A:CreateBG(bu.icon)
		bu.icon.bg:SetDrawLayer("ARTWORK")
	end

	hooksecurefunc("GroupFinderFrame_SelectGroupButton", function(index)
		local self = GroupFinderFrame
		for i = 1, 4 do
			local button = self["groupButton"..i]
			if i == index then
				button.bg:Show()
			else
				button.bg:Hide()
			end
		end
	end)

	A:ReskinPortraitFrame(PVEFrame)
	A:ReskinTab(PVEFrameTab1)
	A:ReskinTab(PVEFrameTab2)
	A:ReskinTab(PVEFrameTab3)
	
	--LFD
	
	LFDParentFrame:DisableDrawLayer("BACKGROUND")
	LFDParentFrameInset:DisableDrawLayer("BACKGROUND")
	LFDParentFrame:DisableDrawLayer("BORDER")
	LFDParentFrameInset:DisableDrawLayer("BORDER")
	LFDParentFrame:DisableDrawLayer("OVERLAY")

	LFDQueueFrameRandomScrollFrameScrollBackgroundTopLeft:Hide()
	LFDQueueFrameRandomScrollFrameScrollBackgroundBottomRight:Hide()
	LFDQueueFrameRandomScrollFrame:StripTextures(true)
	A:Reskin(LFDQueueFrameFindGroupButton)
	A:ReskinDropDown(LFDQueueFrameTypeDropDown)
	
	-- this fixes right border of second reward being cut off
	LFDQueueFrameRandomScrollFrame:SetWidth(LFDQueueFrameRandomScrollFrame:GetWidth()+1)

	hooksecurefunc("LFGDungeonListButton_SetDungeon", function(button, dungeonID)
		if not button.expandOrCollapseButton.plus then
			A:ReskinCheck(button.enableButton)
			A:ReskinExpandOrCollapse(button.expandOrCollapseButton)
		end
		if LFGCollapseList[dungeonID] then
			button.expandOrCollapseButton.plus:Show()
		else
			button.expandOrCollapseButton.plus:Hide()
		end

		button.enableButton:GetCheckedTexture():SetDesaturated(true)
	end)

	A:CreateBD(LFDRoleCheckPopup)
	A:Reskin(LFDRoleCheckPopupAcceptButton)
	A:Reskin(LFDRoleCheckPopupDeclineButton)
	A:Reskin(LFDQueueFrameRandomScrollFrameChildFrame.bonusRepFrame.ChooseButton)
	
	--LFG
	local function styleRewardButton(button)
		local buttonName = button:GetName()

		local icon = _G[buttonName.."IconTexture"]
		local cta = _G[buttonName.."ShortageBorder"]
		local count = _G[buttonName.."Count"]
		local na = _G[buttonName.."NameFrame"]

		A:CreateBG(icon)
		icon:SetTexCoord(.08, .92, .08, .92)
		icon:SetDrawLayer("OVERLAY")
		count:SetDrawLayer("OVERLAY")
		na:SetTexture(0, 0, 0, .25)
		na:SetSize(118, 39)

		if cta then
			cta:SetAlpha(0)
		end

		button.bg2 = CreateFrame("Frame", nil, button)
		button.bg2:SetPoint("TOPLEFT", na, "TOPLEFT", 10, 0)
		button.bg2:SetPoint("BOTTOMRIGHT", na, "BOTTOMRIGHT")
		A:CreateBD(button.bg2, 0)
	end

	hooksecurefunc("LFDQueueFrameRandom_UpdateFrame", function()
		for i = 1, LFD_MAX_REWARDS do
			local button = _G["LFDQueueFrameRandomScrollFrameChildFrameItem"..i]

			if button and not button.styled then
				styleRewardButton(button)
				button.styled = true
			end
		end
	end)
	hooksecurefunc("ScenarioQueueFrameRandom_UpdateFrame", function()
		for i = 1, 2 do
			local button = _G["ScenarioQueueFrameRandomScrollFrameChildFrameItem"..i]

			if button and not button.styled then
				styleRewardButton(button)
				button.styled = true
			end
		end
	end)
	hooksecurefunc("RaidFinderQueueFrameRewards_UpdateFrame", function()
		for i = 1, LFD_MAX_REWARDS do
			local button = _G["RaidFinderQueueFrameScrollFrameChildFrameItem"..i]

			if button and not button.styled then
				styleRewardButton(button)
				button.styled = true
			end
		end
	end)

	styleRewardButton(LFDQueueFrameRandomScrollFrameChildFrame.MoneyReward)
	styleRewardButton(ScenarioQueueFrameRandomScrollFrameChildFrame.MoneyReward)
	styleRewardButton(RaidFinderQueueFrameScrollFrameChildFrame.MoneyReward)

	LFGDungeonReadyDialogBackground:Hide()
	LFGDungeonReadyDialogBottomArt:Hide()
	LFGDungeonReadyDialogFiligree:Hide()

	--LFGDungeonReadyDialogRoleIconTexture:SetTexture(A.media.roleIcons)
	--LFGDungeonReadyDialogRoleIconLeaderIcon:SetTexture(A.media.roleIcons)
	LFGDungeonReadyDialogRoleIconLeaderIcon:SetTexCoord(0, 0.296875, 0.015625, 0.2875)

	local leaderBg = A:CreateBG(LFGDungeonReadyDialogRoleIconLeaderIcon)
	leaderBg:SetDrawLayer("ARTWORK", 2)
	leaderBg:SetPoint("TOPLEFT", LFGDungeonReadyDialogRoleIconLeaderIcon, 2, 0)
	leaderBg:SetPoint("BOTTOMRIGHT", LFGDungeonReadyDialogRoleIconLeaderIcon, -3, 4)

	hooksecurefunc("LFGDungeonReadyPopup_Update", function()
		leaderBg:SetShown(LFGDungeonReadyDialogRoleIconLeaderIcon:IsShown())
	end)

	do
		local left = LFGDungeonReadyDialogRoleIcon:CreateTexture(nil, "OVERLAY")
		left:SetWidth(1)
		left:SetTexture(A.media.backdrop)
		left:SetVertexColor(0, 0, 0)
		left:SetPoint("TOPLEFT", 9, -7)
		left:SetPoint("BOTTOMLEFT", 9, 10)

		local right = LFGDungeonReadyDialogRoleIcon:CreateTexture(nil, "OVERLAY")
		right:SetWidth(1)
		right:SetTexture(A.media.backdrop)
		right:SetVertexColor(0, 0, 0)
		right:SetPoint("TOPRIGHT", -8, -7)
		right:SetPoint("BOTTOMRIGHT", -8, 10)

		local top = LFGDungeonReadyDialogRoleIcon:CreateTexture(nil, "OVERLAY")
		top:SetHeight(1)
		top:SetTexture(A.media.backdrop)
		top:SetVertexColor(0, 0, 0)
		top:SetPoint("TOPLEFT", 9, -7)
		top:SetPoint("TOPRIGHT", -8, -7)

		local bottom = LFGDungeonReadyDialogRoleIcon:CreateTexture(nil, "OVERLAY")
		bottom:SetHeight(1)
		bottom:SetTexture(A.media.backdrop)
		bottom:SetVertexColor(0, 0, 0)
		bottom:SetPoint("BOTTOMLEFT", 9, 10)
		bottom:SetPoint("BOTTOMRIGHT", -8, 10)
	end

	hooksecurefunc("LFGDungeonReadyDialogReward_SetMisc", function(button)
		if not button.styled then
			local border = _G[button:GetName().."Border"]

			button.texture:SetTexCoord(.08, .92, .08, .92)

			border:SetTexture(0, 0, 0)
			border:SetDrawLayer("BACKGROUND")
			border:SetPoint("TOPLEFT", button.texture, -1, 1)
			border:SetPoint("BOTTOMRIGHT", button.texture, 1, -1)

			button.styled = true
		end

		button.texture:SetTexture("Interface\\Icons\\inv_misc_coin_02")
	end)

	hooksecurefunc("LFGDungeonReadyDialogReward_SetReward", function(button, dungeonID, rewardIndex, rewardType, rewardArg)
		if not button.styled then
			local border = _G[button:GetName().."Border"]

			button.texture:SetTexCoord(.08, .92, .08, .92)

			border:SetTexture(0, 0, 0)
			border:SetDrawLayer("BACKGROUND")
			border:SetPoint("TOPLEFT", button.texture, -1, 1)
			border:SetPoint("BOTTOMRIGHT", button.texture, 1, -1)

			button.styled = true
		end

		local name, texturePath, quantity
		if rewardType == "reward" then
			name, texturePath, quantity = GetLFGDungeonRewardInfo(dungeonID, rewardIndex);
		elseif rewardType == "shortage" then
			name, texturePath, quantity = GetLFGDungeonShortageRewardInfo(dungeonID, rewardArg, rewardIndex);
		end
		if texturePath then
			button.texture:SetTexture(texturePath)
		end
	end)

	A:CreateBD(LFGDungeonReadyDialog)
	LFGDungeonReadyDialog.SetBackdrop = S.dummy
	A:CreateBD(LFGInvitePopup)
	A:CreateBD(LFGDungeonReadyStatus)

	A:Reskin(LFGDungeonReadyDialogEnterDungeonButton)
	A:Reskin(LFGDungeonReadyDialogLeaveQueueButton)
	A:Reskin(LFGInvitePopupAcceptButton)
	A:Reskin(LFGInvitePopupDeclineButton)
	A:ReskinClose(LFGDungeonReadyDialogCloseButton)
	A:ReskinClose(LFGDungeonReadyStatusCloseButton)

	for _, roleButton in pairs({LFDQueueFrameRoleButtonTank, LFDQueueFrameRoleButtonHealer, LFDQueueFrameRoleButtonDPS, LFDQueueFrameRoleButtonLeader, LFRQueueFrameRoleButtonTank, LFRQueueFrameRoleButtonHealer, LFRQueueFrameRoleButtonDPS, RaidFinderQueueFrameRoleButtonTank, RaidFinderQueueFrameRoleButtonHealer, RaidFinderQueueFrameRoleButtonDPS, RaidFinderQueueFrameRoleButtonLeader}) do
		if roleButton.background then
			roleButton.background:SetTexture("")
		end

		--roleButton.cover:SetTexture(A.media.roleIcons)
		--roleButton:SetNormalTexture(A.media.roleIcons)

		roleButton.checkButton:SetFrameLevel(roleButton:GetFrameLevel() + 2)

		for i = 1, 2 do
			local left = roleButton:CreateTexture()
			left:SetDrawLayer("OVERLAY", i)
			left:SetWidth(1)
			left:SetTexture(A.media.backdrop)
			left:SetVertexColor(0, 0, 0)
			left:SetPoint("TOPLEFT", roleButton, 6, -5)
			left:SetPoint("BOTTOMLEFT", roleButton, 6, 7)
			roleButton["leftLine"..i] = left

			local right = roleButton:CreateTexture()
			right:SetDrawLayer("OVERLAY", i)
			right:SetWidth(1)
			right:SetTexture(A.media.backdrop)
			right:SetVertexColor(0, 0, 0)
			right:SetPoint("TOPRIGHT", roleButton, -6, -5)
			right:SetPoint("BOTTOMRIGHT", roleButton, -6, 7)
			roleButton["rightLine"..i] = right

			local top = roleButton:CreateTexture()
			top:SetDrawLayer("OVERLAY", i)
			top:SetHeight(1)
			top:SetTexture(A.media.backdrop)
			top:SetVertexColor(0, 0, 0)
			top:SetPoint("TOPLEFT", roleButton, 6, -5)
			top:SetPoint("TOPRIGHT", roleButton, -6, -5)
			roleButton["topLine"..i] = top

			local bottom = roleButton:CreateTexture()
			bottom:SetDrawLayer("OVERLAY", i)
			bottom:SetHeight(1)
			bottom:SetTexture(A.media.backdrop)
			bottom:SetVertexColor(0, 0, 0)
			bottom:SetPoint("BOTTOMLEFT", roleButton, 6, 7)
			bottom:SetPoint("BOTTOMRIGHT", roleButton, -6, 7)
			roleButton["bottomLine"..i] = bottom
		end

		roleButton.leftLine2:Hide()
		roleButton.rightLine2:Hide()
		roleButton.topLine2:Hide()
		roleButton.bottomLine2:Hide()

		local shortageBorder = roleButton.shortageBorder
		if shortageBorder then
			local icon = roleButton.incentiveIcon

			shortageBorder:SetTexture("")

			icon.border:SetTexture(0, 0, 0)
			icon.border:SetDrawLayer("BACKGROUND")
			icon.border:SetPoint("TOPLEFT", icon.texture, -1, 1)
			icon.border:SetPoint("BOTTOMRIGHT", icon.texture, 1, -1)

			icon:SetPoint("BOTTOMRIGHT", 3, -3)
			icon:SetSize(14, 14)
			icon.texture:SetSize(14, 14)
			icon.texture:SetTexCoord(.12, .88, .12, .88)
		end

		A:ReskinCheck(roleButton.checkButton)
	end

	for _, roleButton in pairs({LFDRoleCheckPopupRoleButtonTank, LFDRoleCheckPopupRoleButtonHealer, LFDRoleCheckPopupRoleButtonDPS, LFGInvitePopupRoleButtonTank, LFGInvitePopupRoleButtonHealer, LFGInvitePopupRoleButtonDPS}) do
		--roleButton.cover:SetTexture(A.media.roleIcons)
		--roleButton:SetNormalTexture(A.media.roleIcons)

		roleButton.checkButton:SetFrameLevel(roleButton:GetFrameLevel() + 2)

		local left = roleButton:CreateTexture(nil, "OVERLAY")
		left:SetWidth(1)
		left:SetTexture(A.media.backdrop)
		left:SetVertexColor(0, 0, 0)
		left:SetPoint("TOPLEFT", roleButton, 9, -7)
		left:SetPoint("BOTTOMLEFT", roleButton, 9, 11)

		local right = roleButton:CreateTexture(nil, "OVERLAY")
		right:SetWidth(1)
		right:SetTexture(A.media.backdrop)
		right:SetVertexColor(0, 0, 0)
		right:SetPoint("TOPRIGHT", roleButton, -9, -7)
		right:SetPoint("BOTTOMRIGHT", roleButton, -9, 11)

		local top = roleButton:CreateTexture(nil, "OVERLAY")
		top:SetHeight(1)
		top:SetTexture(A.media.backdrop)
		top:SetVertexColor(0, 0, 0)
		top:SetPoint("TOPLEFT", roleButton, 9, -7)
		top:SetPoint("TOPRIGHT", roleButton, -9, -7)

		local bottom = roleButton:CreateTexture(nil, "OVERLAY")
		bottom:SetHeight(1)
		bottom:SetTexture(A.media.backdrop)
		bottom:SetVertexColor(0, 0, 0)
		bottom:SetPoint("BOTTOMLEFT", roleButton, 9, 11)
		bottom:SetPoint("BOTTOMRIGHT", roleButton, -9, 11)

		A:ReskinCheck(roleButton.checkButton)
	end

	do
		local roleButtons = {LFGDungeonReadyStatusGroupedTank, LFGDungeonReadyStatusGroupedHealer, LFGDungeonReadyStatusGroupedDamager, LFGDungeonReadyStatusRolelessReady}

		for i = 1, 5 do
			tinsert(roleButtons, _G["LFGDungeonReadyStatusIndividualPlayer"..i])
		end

		for _, roleButton in pairs(roleButtons) do
			--roleButton.texture:SetTexture(A.media.roleIcons)
			roleButton.statusIcon:SetDrawLayer("OVERLAY", 2)

			local left = roleButton:CreateTexture(nil, "OVERLAY")
			left:SetWidth(1)
			left:SetTexture(A.media.backdrop)
			left:SetVertexColor(0, 0, 0)
			left:SetPoint("TOPLEFT", 7, -6)
			left:SetPoint("BOTTOMLEFT", 7, 8)

			local right = roleButton:CreateTexture(nil, "OVERLAY")
			right:SetWidth(1)
			right:SetTexture(A.media.backdrop)
			right:SetVertexColor(0, 0, 0)
			right:SetPoint("TOPRIGHT", -7, -6)
			right:SetPoint("BOTTOMRIGHT", -7, 8)

			local top = roleButton:CreateTexture(nil, "OVERLAY")
			top:SetHeight(1)
			top:SetTexture(A.media.backdrop)
			top:SetVertexColor(0, 0, 0)
			top:SetPoint("TOPLEFT", 7, -6)
			top:SetPoint("TOPRIGHT", -7, -6)

			local bottom = roleButton:CreateTexture(nil, "OVERLAY")
			bottom:SetHeight(1)
			bottom:SetTexture(A.media.backdrop)
			bottom:SetVertexColor(0, 0, 0)
			bottom:SetPoint("BOTTOMLEFT", 7, 8)
			bottom:SetPoint("BOTTOMRIGHT", -7, 8)
		end
	end

	LFGDungeonReadyStatusRolelessReady.texture:SetTexCoord(0.5234375, 0.78750, 0, 0.25875)

	hooksecurefunc("LFG_SetRoleIconIncentive", function(roleButton, incentiveIndex)
		if incentiveIndex then
			local tex
			if incentiveIndex == LFG_ROLE_SHORTAGE_PLENTIFUL then
				tex = "Interface\\Icons\\INV_Misc_Coin_19"
			elseif incentiveIndex == LFG_ROLE_SHORTAGE_UNCOMMON then
				tex = "Interface\\Icons\\INV_Misc_Coin_18"
			elseif incentiveIndex == LFG_ROLE_SHORTAGE_RARE then
				tex = "Interface\\Icons\\INV_Misc_Coin_17"
			end
			roleButton.incentiveIcon.texture:SetTexture(tex)
			roleButton.leftLine2:Show()
			roleButton.rightLine2:Show()
			roleButton.topLine2:Show()
			roleButton.bottomLine2:Show()
		else
			roleButton.leftLine2:Hide()
			roleButton.rightLine2:Hide()
			roleButton.topLine2:Hide()
			roleButton.bottomLine2:Hide()
		end
	end)

	hooksecurefunc("LFG_PermanentlyDisableRoleButton", function(button)
		if button.shortageBorder then
			button.leftLine2:SetVertexColor(.5, .45, .03)
			button.rightLine2:SetVertexColor(.5, .45, .03)
			button.topLine2:SetVertexColor(.5, .45, .03)
			button.bottomLine2:SetVertexColor(.5, .45, .03)
		end
	end)

	hooksecurefunc("LFG_DisableRoleButton", function(button)
		if button.shortageBorder then
			button.leftLine2:SetVertexColor(.5, .45, .03)
			button.rightLine2:SetVertexColor(.5, .45, .03)
			button.topLine2:SetVertexColor(.5, .45, .03)
			button.bottomLine2:SetVertexColor(.5, .45, .03)
		end
	end)

	hooksecurefunc("LFG_EnableRoleButton", function(button)
		if button.shortageBorder then
			button.leftLine2:SetVertexColor(1, .9, .06)
			button.rightLine2:SetVertexColor(1, .9, .06)
			button.topLine2:SetVertexColor(1, .9, .06)
			button.bottomLine2:SetVertexColor(1, .9, .06)
		end
	end)
	
	--LFGList
	local LFGListFrame = LFGListFrame

	-- [[ Category selection ]]

	local CategorySelection = LFGListFrame.CategorySelection

	CategorySelection.Inset.Bg:Hide()
	select(10, CategorySelection.Inset:GetRegions()):Hide()
	CategorySelection.Inset:DisableDrawLayer("BORDER")

	A:Reskin(CategorySelection.FindGroupButton)
	A:Reskin(CategorySelection.StartGroupButton)

	CategorySelection.CategoryButtons[1]:SetNormalFontObject(GameFontNormal)

	hooksecurefunc("LFGListCategorySelection_AddButton", function(self, btnIndex)
		local bu = self.CategoryButtons[btnIndex]

		if bu and not bu.styled then
			bu.Cover:Hide()

			bu.Icon:SetDrawLayer("BACKGROUND", 1)
			bu.Icon:SetTexCoord(.01, .99, .01, .99)

			local bg = A:CreateBG(bu)
			bg:SetPoint("TOPLEFT", 4, -4)
			bg:SetPoint("BOTTOMRIGHT", -4, 4)

			bu.styled = true
		end
	end)

	-- [[ Search panel ]]

	local SearchPanel = LFGListFrame.SearchPanel

	SearchPanel.ResultsInset.Bg:Hide()
	SearchPanel.ResultsInset:DisableDrawLayer("BORDER")

	A:Reskin(SearchPanel.RefreshButton)
	A:Reskin(SearchPanel.BackButton)
	A:Reskin(SearchPanel.SignUpButton)
	A:Reskin(SearchPanel.ScrollFrame.StartGroupButton)
	A:ReskinInput(SearchPanel.SearchBox)
	A:ReskinScroll(SearchPanel.ScrollFrame.scrollBar)

	SearchPanel.RefreshButton:SetSize(24, 24)
	SearchPanel.RefreshButton.Icon:SetPoint("CENTER")

	-- Auto complete frame

	SearchPanel.AutoCompleteFrame.BottomLeftBorder:Hide()
	SearchPanel.AutoCompleteFrame.BottomRightBorder:Hide()
	SearchPanel.AutoCompleteFrame.BottomBorder:Hide()
	SearchPanel.AutoCompleteFrame.LeftBorder:Hide()
	SearchPanel.AutoCompleteFrame.RightBorder:Hide()

	local function resultOnEnter(self)
		self.hl:Show()
	end

	local function resultOnLeave(self)
		self.hl:Hide()
	end

	local numResults = 1
	hooksecurefunc("LFGListSearchPanel_UpdateAutoComplete", function(self)
		local AutoCompleteFrame = self.AutoCompleteFrame

		for i = numResults, #AutoCompleteFrame.Results do
			local result = AutoCompleteFrame.Results[i]

			if numResults == 1 then
				result:SetPoint("TOPLEFT", AutoCompleteFrame.LeftBorder, "TOPRIGHT", -8, 1)
				result:SetPoint("TOPRIGHT", AutoCompleteFrame.RightBorder, "TOPLEFT", 5, 1)
			else
				result:SetPoint("TOPLEFT", AutoCompleteFrame.Results[i-1], "BOTTOMLEFT", 0, 1)
				result:SetPoint("TOPRIGHT", AutoCompleteFrame.Results[i-1], "BOTTOMRIGHT", 0, 1)
			end

			result:SetNormalTexture("")
			result:SetPushedTexture("")
			result:SetHighlightTexture("")

			local hl = result:CreateTexture(nil, "BACKGROUND")
			hl:SetAllPoints()
			hl:SetTexture(A.media.backdrop)
			hl:SetVertexColor(r, g, b, .2)
			hl:Hide()
			result.hl = hl

			A:CreateBD(result, .5)

			result:HookScript("OnEnter", resultOnEnter)
			result:HookScript("OnLeave", resultOnLeave)

			numResults = numResults + 1
		end
	end)

	-- [[ Application viewer ]]

	local ApplicationViewer = LFGListFrame.ApplicationViewer

	ApplicationViewer.InfoBackground:Hide()

	ApplicationViewer.Inset.Bg:Hide()
	ApplicationViewer.Inset:DisableDrawLayer("BORDER")

	local function headerOnEnter(self)
		self.hl:Show()
	end

	local function headerOnLeave(self)
		self.hl:Hide()
	end

	for _, headerName in pairs({"NameColumnHeader", "RoleColumnHeader", "ItemLevelColumnHeader"}) do
		local header = ApplicationViewer[headerName]
		header.Left:Hide()
		header.Middle:Hide()
		header.Right:Hide()

		header:SetHighlightTexture("")

		local hl = header:CreateTexture(nil, "BACKGROUND")
		hl:SetAllPoints()
		hl:SetTexture(A.media.backdrop)
		hl:SetVertexColor(r, g, b, .2)
		hl:Hide()
		header.hl = hl

		A:CreateBD(header, .25)

		header:HookScript("OnEnter", headerOnEnter)
		header:HookScript("OnLeave", headerOnLeave)
	end

	ApplicationViewer.RoleColumnHeader:SetPoint("LEFT", ApplicationViewer.NameColumnHeader, "RIGHT", 1, 0)
	ApplicationViewer.ItemLevelColumnHeader:SetPoint("LEFT", ApplicationViewer.RoleColumnHeader, "RIGHT", 1, 0)

	A:Reskin(ApplicationViewer.RefreshButton)
	A:Reskin(ApplicationViewer.RemoveEntryButton)
	A:Reskin(ApplicationViewer.EditButton)
	A:ReskinScroll(LFGListApplicationViewerScrollFrameScrollBar)

	ApplicationViewer.RefreshButton:SetSize(24, 24)
	ApplicationViewer.RefreshButton.Icon:SetPoint("CENTER")

	-- [[ Entry creation ]]

	local EntryCreation = LFGListFrame.EntryCreation

	EntryCreation.Inset.Bg:Hide()
	select(10, EntryCreation.Inset:GetRegions()):Hide()
	EntryCreation.Inset:DisableDrawLayer("BORDER")

	for i = 1, 9 do
		select(i, EntryCreation.Description:GetRegions()):Hide()
	end

	A:Reskin(EntryCreation.ListGroupButton)
	A:Reskin(EntryCreation.CancelButton)
	A:CreateBD(EntryCreation.Description, 0)
	A:CreateGradient(EntryCreation.Description)
	A:ReskinInput(EntryCreation.Name)
	A:ReskinInput(EntryCreation.ItemLevel.EditBox)
	A:ReskinInput(EntryCreation.VoiceChat.EditBox)
	A:ReskinDropDown(EntryCreation.CategoryDropDown)
	A:ReskinDropDown(EntryCreation.GroupDropDown)
	A:ReskinDropDown(EntryCreation.ActivityDropDown)
	A:ReskinCheck(EntryCreation.ItemLevel.CheckButton)
	A:ReskinCheck(EntryCreation.VoiceChat.CheckButton)

	-- Activity finder

	local ActivityFinder = EntryCreation.ActivityFinder

	ActivityFinder.Background:SetTexture("")
	ActivityFinder.Dialog.Bg:Hide()
	for i = 1, 9 do
		select(i, ActivityFinder.Dialog.BorderFrame:GetRegions()):Hide()
	end

	A:CreateBD(ActivityFinder.Dialog)
	ActivityFinder.Dialog:SetBackdropColor(.2, .2, .2, .9)

	A:Reskin(ActivityFinder.Dialog.SelectButton)
	A:Reskin(ActivityFinder.Dialog.CancelButton)
	A:ReskinInput(ActivityFinder.Dialog.EntryBox)
	A:ReskinScroll(LFGListEntryCreationSearchScrollFrameScrollBar)
	
	--LFR
	LFRQueueFrame:DisableDrawLayer("BACKGROUND")
	LFRBrowseFrame:DisableDrawLayer("BACKGROUND")
	LFRBrowseFrameRoleInset:DisableDrawLayer("BORDER")
	LFRQueueFrameRoleInset:DisableDrawLayer("BORDER")
	LFRQueueFrameListInset:DisableDrawLayer("BORDER")
	LFRQueueFrameCommentInset:DisableDrawLayer("BORDER")
	LFRQueueFrameSpecificListScrollFrameScrollBackgroundTopLeft:Hide()
	LFRQueueFrameSpecificListScrollFrameScrollBackgroundBottomRight:Hide()
	LFRBrowseFrameRoleInsetBg:Hide()
	LFRQueueFrameRoleInsetBg:Hide()
	LFRQueueFrameListInsetBg:Hide()
	LFRQueueFrameCommentInsetBg:Hide()
	for i = 1, 7 do
		_G["LFRBrowseFrameColumnHeader"..i]:DisableDrawLayer("BACKGROUND")
	end

	A:Reskin(LFRBrowseFrameSendMessageButton)
	A:Reskin(LFRBrowseFrameInviteButton)
	A:Reskin(LFRBrowseFrameRefreshButton)
	A:Reskin(LFRQueueFrameFindGroupButton)
	A:Reskin(LFRQueueFrameAcceptCommentButton)
	A:ReskinPortraitFrame(RaidBrowserFrame)
	A:ReskinScroll(LFRQueueFrameSpecificListScrollFrameScrollBar)
	A:ReskinScroll(LFRQueueFrameCommentScrollFrameScrollBar)
	A:ReskinScroll(LFRBrowseFrameListScrollFrameScrollBar)
	A:ReskinDropDown(LFRBrowseFrameRaidDropDown)

	for i = 1, 2 do
		local tab = _G["LFRParentFrameSideTab"..i]
		tab:GetRegions():Hide()
		tab:SetCheckedTexture(A.media.checked)
		if i == 1 then
			local a1, p, a2, x, y = tab:GetPoint()
			tab:SetPoint(a1, p, a2, x + 2, y)
		end
		A:CreateBG(tab)
		select(2, tab:GetRegions()):SetTexCoord(.08, .92, .08, .92)
	end

	for i = 1, NUM_LFR_CHOICE_BUTTONS do
		local bu = _G["LFRQueueFrameSpecificListButton"..i].enableButton
		A:ReskinCheck(bu)
		bu.SetNormalTexture = S.dummy
		bu.SetPushedTexture = S.dummy

		A:ReskinExpandOrCollapse(_G["LFRQueueFrameSpecificListButton"..i].expandOrCollapseButton)
	end

	hooksecurefunc("LFRQueueFrameSpecificListButton_SetDungeon", function(button, dungeonID)
		if LFGCollapseList[dungeonID] then
			button.expandOrCollapseButton.plus:Show()
		else
			button.expandOrCollapseButton.plus:Hide()
		end

		button.enableButton:GetCheckedTexture():SetDesaturated(true)
	end)
end

A:RegisterSkin("SunUI", LoadSkin)
