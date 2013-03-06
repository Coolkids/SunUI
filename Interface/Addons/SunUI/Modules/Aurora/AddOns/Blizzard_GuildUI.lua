local S, L, DB, _, C = unpack(select(2, ...))
local r, g, b = DB.MyClassColor.r, DB.MyClassColor.g, DB.MyClassColor.b
local AuroraConfig = DB.AuroraConfig

DB.AuroraModules["Blizzard_GuildUI"] = function()
	
	S.ReskinPortraitFrame(GuildFrame, true)
	S.CreateBD(GuildMemberDetailFrame)
	S.CreateBD(GuildMemberNoteBackground, .25)
	S.CreateBD(GuildMemberOfficerNoteBackground, .25)
	S.CreateBD(GuildLogFrame)
	S.CreateBD(GuildLogContainer, .25)
	S.CreateBD(GuildNewsFiltersFrame)
	S.CreateBD(GuildTextEditFrame)
	S.CreateBD(GuildTextEditContainer, .25)
	S.CreateBD(GuildRecruitmentInterestFrame, .25)
	S.CreateBD(GuildRecruitmentAvailabilityFrame, .25)
	S.CreateBD(GuildRecruitmentRolesFrame, .25)
	S.CreateBD(GuildRecruitmentLevelFrame, .25)
	for i = 1, 5 do
		S.ReskinTab(_G["GuildFrameTab"..i])
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
	select(2, GuildNewPerksFrame:GetRegions()):Hide()
	select(3, GuildNewPerksFrame:GetRegions()):Hide()
	GuildAllPerksFrame:GetRegions():Hide()
	GuildNewsFrame:GetRegions():Hide()
	GuildRewardsFrame:GetRegions():Hide()
	GuildNewsBossModelShadowOverlay:Hide()
	GuildPerksToggleButtonLeft:Hide()
	GuildPerksToggleButtonMiddle:Hide()
	GuildPerksToggleButtonRight:Hide()
	GuildPerksToggleButtonHighlightLeft:Hide()
	GuildPerksToggleButtonHighlightMiddle:Hide()
	GuildPerksToggleButtonHighlightRight:Hide()
	GuildNewPerksFrameHeader1:SetAlpha(0)
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

	S.ReskinClose(GuildNewsFiltersFrameCloseButton)
	S.ReskinClose(GuildLogFrameCloseButton)
	S.ReskinClose(GuildMemberDetailCloseButton)
	S.ReskinClose(GuildTextEditFrameCloseButton)
	S.ReskinScroll(GuildPerksContainerScrollBar)
	S.ReskinScroll(GuildRosterContainerScrollBar)
	S.ReskinScroll(GuildNewsContainerScrollBar)
	S.ReskinScroll(GuildRewardsContainerScrollBar)
	S.ReskinScroll(GuildInfoDetailsFrameScrollBar)
	S.ReskinScroll(GuildLogScrollFrameScrollBar)
	S.ReskinScroll(GuildTextEditScrollFrameScrollBar)
	S.ReskinScroll(GuildInfoFrameApplicantsContainerScrollBar)
	S.ReskinDropDown(GuildRosterViewDropdown)
	S.ReskinDropDown(GuildMemberRankDropdown)
	S.ReskinInput(GuildRecruitmentCommentInputFrame)
	GuildRecruitmentCommentInputFrame:Width(312)
	GuildRecruitmentCommentEditBox:Width(284)
	GuildRecruitmentCommentFrame:ClearAllPoints()
	GuildRecruitmentCommentFrame:Point("TOPLEFT", GuildRecruitmentLevelFrame, "BOTTOMLEFT", 0, 1)
	S.ReskinCheck(GuildRosterShowOfflineButton)
	for i = 1, 7 do
		S.ReskinCheck(_G["GuildNewsFilterButton"..i])
	end

	local a1, p, a2, x, y = GuildNewsBossModel:GetPoint()
	GuildNewsBossModel:ClearAllPoints()
	GuildNewsBossModel:Point(a1, p, a2, x+5, y)

	local f = CreateFrame("Frame", nil, GuildNewsBossModel)
	f:Point("TOPLEFT", 0, 1)
	f:Point("BOTTOMRIGHT", 1, -52)
	f:SetFrameLevel(GuildNewsBossModel:GetFrameLevel()-1)
	S.CreateBD(f)

	local line = CreateFrame("Frame", nil, GuildNewsBossModel)
	line:Point("BOTTOMLEFT", 0, -1)
	line:Point("BOTTOMRIGHT", 0, -1)
	line:Height(1)
	line:SetFrameLevel(GuildNewsBossModel:GetFrameLevel()-1)
	S.CreateBD(line, 0)

	GuildNewsFiltersFrame:Width(224)
	GuildNewsFiltersFrame:Point("TOPLEFT", GuildFrame, "TOPRIGHT", 1, -20)
	GuildMemberDetailFrame:Point("TOPLEFT", GuildFrame, "TOPRIGHT", 1, -28)
	GuildLogFrame:Point("TOPLEFT", GuildFrame, "TOPRIGHT", 1, 0)
	GuildTextEditFrame:Point("TOPLEFT", GuildFrame, "TOPRIGHT", 1, 0)

	for i = 1, 5 do
		local bu = _G["GuildInfoFrameApplicantsContainerButton"..i]
		S.CreateBD(bu, .25)
		bu:SetHighlightTexture("")
		bu:GetRegions():SetTexture(DB.media.backdrop)
		bu:GetRegions():SetVertexColor(r, g, b, .2)
	end

	GuildFactionBarProgress:SetTexture(DB.media.backdrop)
	GuildFactionBarLeft:Hide()
	GuildFactionBarMiddle:Hide()
	GuildFactionBarRight:Hide()
	GuildFactionBarShadow:SetAlpha(0)
	GuildFactionBarBG:Hide()
	GuildFactionBarCap:SetAlpha(0)
	GuildFactionBar.bg = CreateFrame("Frame", nil, GuildFactionFrame)
	GuildFactionBar.bg:Point("TOPLEFT", GuildFactionFrame, -1, -1)
	GuildFactionBar.bg:Point("BOTTOMRIGHT", GuildFactionFrame, -3, 0)
	GuildFactionBar.bg:SetFrameLevel(0)
	S.CreateBD(GuildFactionBar.bg, .25)

	GuildXPFrame:ClearAllPoints()
	GuildXPFrame:Point("TOP", GuildFrame, "TOP", 0, -40)
	GuildXPBarProgress:SetTexture(DB.media.backdrop)
	GuildXPBarLeft:SetAlpha(0)
	GuildXPBarRight:SetAlpha(0)
	GuildXPBarMiddle:SetAlpha(0)
	GuildXPBarBG:SetAlpha(0)
	GuildXPBarShadow:SetAlpha(0)
	GuildXPBarShadow:SetAlpha(0)
	GuildXPBarCap:SetAlpha(0)
	GuildXPBarDivider1:Hide()
	GuildXPBarDivider2:Hide()
	GuildXPBarDivider3:Hide()
	GuildXPBarDivider4:Hide()
	GuildXPBar.bg = CreateFrame("Frame", nil, GuildXPBar)
	GuildXPBar.bg:Point("TOPLEFT", GuildXPBar, 0, -3)
	GuildXPBar.bg:Point("BOTTOMRIGHT", GuildXPBar, 0, 1)
	GuildXPBar.bg:SetFrameLevel(0)
	S.CreateBD(GuildXPBar.bg, .25)

	local perkbuttons = {"GuildLatestPerkButton", "GuildNextPerkButton"}
	for _, button in pairs(perkbuttons) do
		local bu = _G[button]
		local ic = _G[button.."IconTexture"]
		local na = _G[button.."NameFrame"]

		na:SetAlpha(0)
		ic:SetTexCoord(.08, .92, .08, .92)
		ic:SetDrawLayer("OVERLAY")
		S.CreateBG(ic)

		bu.bg = CreateFrame("Frame", nil, bu)
		bu.bg:Point("TOPLEFT", 0, -1)
		bu.bg:Point("BOTTOMRIGHT", 0, 2)
		bu.bg:SetFrameLevel(0)
		S.CreateBD(bu.bg, .25)
	end

	select(5, GuildLatestPerkButton:GetRegions()):Hide()
	select(6, GuildLatestPerkButton:GetRegions()):Hide()

	for _, bu in pairs(GuildPerksContainer.buttons) do
		bu.DisableDrawLayer = S.dummy

		for i = 1, 6 do
			select(i, bu:GetRegions()):SetAlpha(0)
		end

		bu.icon:SetTexCoord(.08, .92, .08, .92)
		S.CreateBG(bu.icon)
	end

	GuildPerksContainerButton1:Point("LEFT", -1, 0)

	for _, bu in pairs(GuildRewardsContainer.buttons) do
		local nt = bu:GetNormalTexture()

		bu:SetHighlightTexture("")
		bu.disabledBG:SetTexture("")

		local bg = CreateFrame("Frame", nil, bu)
		bg:Point("TOPLEFT", 0, -1)
		bg:SetPoint("BOTTOMRIGHT")
		S.CreateBD(bg, 0)

		nt:SetTexture(DB.media.backdrop)
		nt:SetVertexColor(0, 0, 0, .25)
		nt:Point("TOPLEFT", 0, -1)
		nt:Point("BOTTOMRIGHT", 0, 1)

		bu.icon:SetTexCoord(.08, .92, .08, .92)
		S.CreateBG(bu.icon)
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
				bu:SetHighlightTexture(DB.media.backdrop)
				bu:GetHighlightTexture():SetVertexColor(r, g, b, .2)

				bu.bg = S.CreateBG(bu.icon)
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

	GuildLevelFrame:SetAlpha(0)
	local closebutton = select(4, GuildTextEditFrame:GetChildren())
	S.Reskin(closebutton)
	local logbutton = select(3, GuildLogFrame:GetChildren())
	S.Reskin(logbutton)
	local gbuttons = {"GuildAddMemberButton", "GuildViewLogButton", "GuildControlButton", "GuildTextEditFrameAcceptButton", "GuildMemberGroupInviteButton", "GuildMemberRemoveButton", "GuildRecruitmentInviteButton", "GuildRecruitmentMessageButton", "GuildRecruitmentDeclineButton", "GuildPerksToggleButton", "GuildRecruitmentListGuildButton"}
	for i = 1, #gbuttons do
		S.Reskin(_G[gbuttons[i]])
	end

	local checkboxes = {"GuildRecruitmentQuestButton", "GuildRecruitmentDungeonButton", "GuildRecruitmentRaidButton", "GuildRecruitmentPvPButton", "GuildRecruitmentRPButton", "GuildRecruitmentWeekdaysButton", "GuildRecruitmentWeekendsButton"}
	for i = 1, #checkboxes do
		S.ReskinCheck(_G[checkboxes[i]])
	end

	S.ReskinCheck(GuildRecruitmentTankButton:GetChildren())
	S.ReskinCheck(GuildRecruitmentHealerButton:GetChildren())
	S.ReskinCheck(GuildRecruitmentDamagerButton:GetChildren())

	S.ReskinRadio(GuildRecruitmentLevelAnyButton)
	S.ReskinRadio(GuildRecruitmentLevelMaxButton)

	for i = 1, 3 do
		for j = 1, 6 do
			select(j, _G["GuildInfoFrameTab"..i]:GetRegions()):Hide()
			select(j, _G["GuildInfoFrameTab"..i]:GetRegions()).Show = S.dummy
		end
	end
end