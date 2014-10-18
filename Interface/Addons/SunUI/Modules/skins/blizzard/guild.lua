local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local A = S:GetModule("Skins")

local function LoadSkin()
    local r, g, b = RAID_CLASS_COLORS[S.myclass].r, RAID_CLASS_COLORS[S.myclass].g, RAID_CLASS_COLORS[S.myclass].b
	
    A:ReskinPortraitFrame(GuildFrame, true)
	A:CreateBD(GuildMemberDetailFrame)
	A:CreateBD(GuildMemberNoteBackground, .25)
	A:CreateBD(GuildMemberOfficerNoteBackground, .25)
	A:CreateBD(GuildLogFrame)
	A:CreateBD(GuildLogContainer, .25)
	A:CreateBD(GuildNewsFiltersFrame)
	A:CreateBD(GuildTextEditFrame)
	A:CreateBD(GuildTextEditContainer, .25)
	A:CreateBD(GuildRecruitmentInterestFrame, .25)
	A:CreateBD(GuildRecruitmentAvailabilityFrame, .25)
	A:CreateBD(GuildRecruitmentRolesFrame, .25)
	A:CreateBD(GuildRecruitmentLevelFrame, .25)
	for i = 1, 5 do
		A:ReskinTab(_G["GuildFrameTab"..i])
	end
	GuildFrameTabardBackground:Hide()
	GuildFrameTabardEmblem:Hide()
	GuildFrameTabardBorder:Hide()
	select(5, GuildInfoFrameInfo:GetRegions()):Hide()
	select(11, GuildMemberDetailFrame:GetRegions()):Hide()
	GuildMemberDetailCorner:Hide()
	for i = 1, 9 do
		select(i, GuildLogFrame:GetRegions()):Hide()
		select(i, GuildNewsFiltersFrame:GetRegions()):Hide()
		select(i, GuildTextEditFrame:GetRegions()):Hide()
	end
	GuildAllPerksFrame:GetRegions():Hide()
	GuildNewsFrame:GetRegions():Hide()
	GuildRewardsFrame:GetRegions():Hide()
	GuildNewsBossModelShadowOverlay:Hide()
	GuildInfoFrameInfoHeader1:SetAlpha(0)
	GuildInfoFrameInfoHeader2:SetAlpha(0)
	GuildInfoFrameInfoHeader3:SetAlpha(0)
	select(9, GuildInfoFrameInfo:GetRegions()):Hide()
	GuildRecruitmentCommentInputFrameTop:Hide()
	GuildRecruitmentCommentInputFrameTopLeft:Hide()
	GuildRecruitmentCommentInputFrameTopRight:Hide()
	GuildRecruitmentCommentInputFrameBottom:Hide()
	GuildRecruitmentCommentInputFrameBottomLeft:Hide()
	GuildRecruitmentCommentInputFrameBottomRight:Hide()
	GuildRecruitmentInterestFrameBg:Hide()
	GuildRecruitmentAvailabilityFrameBg:Hide()
	GuildRecruitmentRolesFrameBg:Hide()
	GuildRecruitmentLevelFrameBg:Hide()
	GuildRecruitmentCommentFrameBg:Hide()
	GuildNewsFrameHeader:SetAlpha(0)

	GuildFrameBottomInset:DisableDrawLayer("BACKGROUND")
	GuildFrameBottomInset:DisableDrawLayer("BORDER")
	GuildInfoFrameInfoBar1Left:SetAlpha(0)
	GuildInfoFrameInfoBar2Left:SetAlpha(0)
	select(2, GuildInfoFrameInfo:GetRegions()):SetAlpha(0)
	select(4, GuildInfoFrameInfo:GetRegions()):SetAlpha(0)
	GuildRosterColumnButton1:DisableDrawLayer("BACKGROUND")
	GuildRosterColumnButton2:DisableDrawLayer("BACKGROUND")
	GuildRosterColumnButton3:DisableDrawLayer("BACKGROUND")
	GuildRosterColumnButton4:DisableDrawLayer("BACKGROUND")
	GuildNewsBossModel:DisableDrawLayer("BACKGROUND")
	GuildNewsBossModel:DisableDrawLayer("OVERLAY")
	GuildNewsBossNameText:SetDrawLayer("ARTWORK")
	GuildNewsBossModelTextFrame:DisableDrawLayer("BACKGROUND")
	for i = 2, 6 do
		select(i, GuildNewsBossModelTextFrame:GetRegions()):Hide()
	end

	GuildMemberRankDropdown:HookScript("OnShow", function()
		GuildMemberDetailRankText:Hide()
	end)
	GuildMemberRankDropdown:HookScript("OnHide", function()
		GuildMemberDetailRankText:Show()
	end)

	hooksecurefunc("GuildNews_Update", function()
		local buttons = GuildNewsContainer.buttons
		for i = 1, #buttons do
			buttons[i].header:SetAlpha(0)
		end
	end)

	A:ReskinClose(GuildNewsFiltersFrameCloseButton)
	A:ReskinClose(GuildLogFrameCloseButton)
	A:ReskinClose(GuildMemberDetailCloseButton)
	A:ReskinClose(GuildTextEditFrameCloseButton)
	A:ReskinScroll(GuildPerksContainerScrollBar)
	A:ReskinScroll(GuildRosterContainerScrollBar)
	A:ReskinScroll(GuildNewsContainerScrollBar)
	A:ReskinScroll(GuildRewardsContainerScrollBar)
	A:ReskinScroll(GuildInfoDetailsFrameScrollBar)
	A:ReskinScroll(GuildLogScrollFrameScrollBar)
	A:ReskinScroll(GuildTextEditScrollFrameScrollBar)
	A:ReskinScroll(GuildInfoFrameApplicantsContainerScrollBar)
	A:ReskinDropDown(GuildRosterViewDropdown)
	A:ReskinDropDown(GuildMemberRankDropdown)
	A:ReskinInput(GuildRecruitmentCommentInputFrame)
	GuildRecruitmentCommentInputFrame:SetWidth(312)
	GuildRecruitmentCommentEditBox:SetWidth(284)
	GuildRecruitmentCommentFrame:ClearAllPoints()
	GuildRecruitmentCommentFrame:SetPoint("TOPLEFT", GuildRecruitmentLevelFrame, "BOTTOMLEFT", 0, 1)
	A:ReskinCheck(GuildRosterShowOfflineButton)
	for i = 1, 6 do
		A:ReskinCheck(_G["GuildNewsFilterButton"..i])
	end

	local a1, p, a2, x, y = GuildNewsBossModel:GetPoint()
	GuildNewsBossModel:ClearAllPoints()
	GuildNewsBossModel:SetPoint(a1, p, a2, x+5, y)

	local f = CreateFrame("Frame", nil, GuildNewsBossModel)
	f:SetPoint("TOPLEFT", 0, 1)
	f:SetPoint("BOTTOMRIGHT", 1, -52)
	f:SetFrameLevel(GuildNewsBossModel:GetFrameLevel()-1)
	A:CreateBD(f)

	local line = CreateFrame("Frame", nil, GuildNewsBossModel)
	line:SetPoint("BOTTOMLEFT", 0, -1)
	line:SetPoint("BOTTOMRIGHT", 0, -1)
	line:SetHeight(1)
	line:SetFrameLevel(GuildNewsBossModel:GetFrameLevel()-1)
	A:CreateBD(line, 0)

	GuildNewsFiltersFrame:SetWidth(224)
	GuildNewsFiltersFrame:SetPoint("TOPLEFT", GuildFrame, "TOPRIGHT", 1, -20)
	GuildMemberDetailFrame:SetPoint("TOPLEFT", GuildFrame, "TOPRIGHT", 1, -28)
	GuildLogFrame:SetPoint("TOPLEFT", GuildFrame, "TOPRIGHT", 1, 0)
	GuildTextEditFrame:SetPoint("TOPLEFT", GuildFrame, "TOPRIGHT", 1, 0)

	for i = 1, 5 do
		local bu = _G["GuildInfoFrameApplicantsContainerButton"..i]

		bu:SetBackdrop(nil)
		bu:SetHighlightTexture("")

		local bg = A:CreateBDFrame(bu, .25)
		bg:ClearAllPoints()
		bg:SetPoint("TOPLEFT", 0, 0)
		bg:SetPoint("BOTTOMRIGHT", 0, 1)

		bu:GetRegions():SetTexture(A.media.backdrop)
		bu:GetRegions():SetVertexColor(r, g, b, .2)
	end

	GuildFactionBarProgress:SetTexture(A.media.backdrop)
	GuildFactionBarLeft:Hide()
	GuildFactionBarMiddle:Hide()
	GuildFactionBarRight:Hide()
	GuildFactionBarShadow:SetAlpha(0)
	GuildFactionBarBG:Hide()
	GuildFactionBarCap:SetAlpha(0)
	GuildFactionBar.bg = CreateFrame("Frame", nil, GuildFactionFrame)
	GuildFactionBar.bg:SetPoint("TOPLEFT", GuildFactionFrame, -1, -1)
	GuildFactionBar.bg:SetPoint("BOTTOMRIGHT", GuildFactionFrame, -3, 0)
	GuildFactionBar.bg:SetFrameLevel(0)
	A:CreateBD(GuildFactionBar.bg, .25)

	for _, bu in pairs(GuildPerksContainer.buttons) do
		for i = 1, 4 do
			select(i, bu:GetRegions()):SetAlpha(0)
		end

		local bg = A:CreateBDFrame(bu, .25)
		bg:ClearAllPoints()
		bg:SetPoint("TOPLEFT", 1, -3)
		bg:SetPoint("BOTTOMRIGHT", 0, 4)

		bu.icon:SetTexCoord(.08, .92, .08, .92)
		A:CreateBG(bu.icon)
	end

	GuildPerksContainerButton1:SetPoint("LEFT", -1, 0)

	for _, bu in pairs(GuildRewardsContainer.buttons) do
		bu:SetNormalTexture("")

		bu:SetHighlightTexture("")
		bu.disabledBG:SetTexture("")

		local bg = A:CreateBDFrame(bu, .25)
		bg:ClearAllPoints()
		bg:SetPoint("TOPLEFT", 1, -1)
		bg:SetPoint("BOTTOMRIGHT", 0, 0)

		bu.icon:SetTexCoord(.08, .92, .08, .92)
		A:CreateBG(bu.icon)
	end

	local tcoords = {
		["WARRIOR"]     = {0.02, 0.23, 0.02, 0.23},
		["MAGE"]        = {0.27, 0.47609375, 0.02, 0.23},
		["ROGUE"]       = {0.51609375, 0.7221875, 0.02, 0.23},
		["DRUID"]       = {0.7621875, 0.96828125, 0.02, 0.23},
		["HUNTER"]      = {0.02, 0.23, 0.27, 0.48},
		["SHAMAN"]      = {0.27, 0.47609375, 0.27, 0.48},
		["PRIEST"]      = {0.51609375, 0.7221875, 0.27, 0.48},
		["WARLOCK"]     = {0.7621875, 0.96828125, 0.27, 0.48},
		["PALADIN"]     = {0.02, 0.23, 0.52, 0.73},
		["DEATHKNIGHT"] = {0.27, .48, 0.52, .73},
		["MONK"]		= {0.52, 0.71828125, 0.52, .73},
	}

	local UpdateIcons = function()
		local index
		local offset = HybridScrollFrame_GetOffset(GuildRosterContainer)
		local totalMembers, onlineMembers, onlineAndMobileMembers = GetNumGuildMembers()
		local visibleMembers = onlineAndMobileMembers
		local numbuttons = #GuildRosterContainer.buttons
		if GetGuildRosterShowOffline() then
			visibleMembers = totalMembers
		end

		for i = 1, numbuttons do
			local bu = GuildRosterContainer.buttons[i]

			if not bu.bg then
				bu:SetHighlightTexture(A.media.backdrop)
				bu:GetHighlightTexture():SetVertexColor(r, g, b, .2)

				bu.bg = A:CreateBG(bu.icon)
			end

			index = offset + i
			local name, _, _, _, _, _, _, _, _, _, classFileName  = GetGuildRosterInfo(index)
			if name and index <= visibleMembers and bu.icon:IsShown() then
				bu.icon:SetTexCoord(unpack(tcoords[classFileName]))
				bu.bg:Show()
			else
				bu.bg:Hide()
			end
		end
	end

	hooksecurefunc("GuildRoster_Update", UpdateIcons)
	hooksecurefunc(GuildRosterContainer, "update", UpdateIcons)

	A:Reskin(select(4, GuildTextEditFrame:GetChildren()))
	A:Reskin(select(3, GuildLogFrame:GetChildren()))

	local gbuttons = {"GuildAddMemberButton", "GuildViewLogButton", "GuildControlButton", "GuildTextEditFrameAcceptButton", "GuildMemberGroupInviteButton", "GuildMemberRemoveButton", "GuildRecruitmentInviteButton", "GuildRecruitmentMessageButton", "GuildRecruitmentDeclineButton", "GuildRecruitmentListGuildButton"}
	for i = 1, #gbuttons do
		A:Reskin(_G[gbuttons[i]])
	end

	local checkboxes = {"GuildRecruitmentQuestButton", "GuildRecruitmentDungeonButton", "GuildRecruitmentRaidButton", "GuildRecruitmentPvPButton", "GuildRecruitmentRPButton", "GuildRecruitmentWeekdaysButton", "GuildRecruitmentWeekendsButton"}
	for i = 1, #checkboxes do
		A:ReskinCheck(_G[checkboxes[i]])
	end

	A:ReskinCheck(GuildRecruitmentTankButton:GetChildren())
	A:ReskinCheck(GuildRecruitmentHealerButton:GetChildren())
	A:ReskinCheck(GuildRecruitmentDamagerButton:GetChildren())

	A:ReskinRadio(GuildRecruitmentLevelAnyButton)
	A:ReskinRadio(GuildRecruitmentLevelMaxButton)

	for i = 1, 3 do
		for j = 1, 6 do
			select(j, _G["GuildInfoFrameTab"..i]:GetRegions()):Hide()
			select(j, _G["GuildInfoFrameTab"..i]:GetRegions()).Show = S.dummy
		end
	end
end

A:RegisterSkin("Blizzard_GuildUI", LoadSkin)
