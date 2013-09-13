local S, L, DB, _, C = unpack(select(2, ...))

local r, g, b = DB.MyClassColor.r, DB.MyClassColor.g, DB.MyClassColor.b
local AuroraConfig = DB.AuroraConfig
DB.AuroraModules["Blizzard_LookingForGuildUI"] = function()
	S.SetBD(LookingForGuildFrame)
	S.CreateBD(LookingForGuildInterestFrame, .25)
	LookingForGuildInterestFrameBg:Hide()
	S.CreateBD(LookingForGuildAvailabilityFrame, .25)
	LookingForGuildAvailabilityFrameBg:Hide()
	S.CreateBD(LookingForGuildRolesFrame, .25)
	LookingForGuildRolesFrameBg:Hide()
	S.CreateBD(LookingForGuildCommentFrame, .25)
	LookingForGuildCommentFrameBg:Hide()
	S.CreateBD(LookingForGuildCommentInputFrame, .12)
	LookingForGuildFrame:DisableDrawLayer("BACKGROUND")
	LookingForGuildFrame:DisableDrawLayer("BORDER")
	LookingForGuildFrameInset:DisableDrawLayer("BACKGROUND")
	LookingForGuildFrameInset:DisableDrawLayer("BORDER")
	S.CreateBD(GuildFinderRequestMembershipFrame)
	S.CreateSD(GuildFinderRequestMembershipFrame)
	for i = 1, 5 do
		local bu = _G["LookingForGuildBrowseFrameContainerButton"..i]
		S.CreateBD(bu, .25)
		bu:SetHighlightTexture("")
		bu:GetRegions():SetTexture(DB.media.backdrop)
		bu:GetRegions():SetVertexColor(r, g, b, .2)
	end
	for i = 1, 9 do
		select(i, LookingForGuildCommentInputFrame:GetRegions()):Hide()
	end
	for i = 1, 3 do
		for j = 1, 6 do
			select(j, _G["LookingForGuildFrameTab"..i]:GetRegions()):Hide()
			select(j, _G["LookingForGuildFrameTab"..i]:GetRegions()).Show = S.dummy
		end
	end
	for i = 1, 6 do
		select(i, GuildFinderRequestMembershipFrameInputFrame:GetRegions()):Hide()
	end
	LookingForGuildFrameTabardBackground:Hide()
	LookingForGuildFrameTabardEmblem:Hide()
	LookingForGuildFrameTabardBorder:Hide()
	LookingForGuildFramePortraitFrame:Hide()
	LookingForGuildFrameTopBorder:Hide()
	LookingForGuildFrameTopRightCorner:Hide()

	for _, roleButton in pairs({LookingForGuildTankButton, LookingForGuildHealerButton, LookingForGuildDamagerButton}) do
		roleButton.cover:SetTexture(DB.media.roleIcons)
		roleButton:SetNormalTexture(DB.media.roleIcons)

		roleButton.checkButton:SetFrameLevel(roleButton:GetFrameLevel() + 2)

		local left = roleButton:CreateTexture()
		left:SetDrawLayer("OVERLAY", 1)
		left:SetWidth(1)
		left:SetTexture(DB.media.backdrop)
		left:SetVertexColor(0, 0, 0)
		left:Point("TOPLEFT", 5, -4)
		left:Point("BOTTOMLEFT", 5, 6)

		local right = roleButton:CreateTexture()
		right:SetDrawLayer("OVERLAY", 1)
		right:SetWidth(1)
		right:SetTexture(DB.media.backdrop)
		right:SetVertexColor(0, 0, 0)
		right:Point("TOPRIGHT", -5, -4)
		right:Point("BOTTOMRIGHT", -5, 6)

		local top = roleButton:CreateTexture()
		top:SetDrawLayer("OVERLAY", 1)
		top:SetHeight(1)
		top:SetTexture(DB.media.backdrop)
		top:SetVertexColor(0, 0, 0)
		top:Point("TOPLEFT", 5, -4)
		top:Point("TOPRIGHT", -5, -4)

		local bottom = roleButton:CreateTexture()
		bottom:SetDrawLayer("OVERLAY", 1)
		bottom:SetHeight(1)
		bottom:SetTexture(DB.media.backdrop)
		bottom:SetVertexColor(0, 0, 0)
		bottom:Point("BOTTOMLEFT", 5, 6)
		bottom:Point("BOTTOMRIGHT", -5, 6)

		S.ReskinCheck(roleButton.checkButton)
	end

	S.Reskin(LookingForGuildBrowseButton)
	S.Reskin(LookingForGuildRequestButton)
	S.Reskin(GuildFinderRequestMembershipFrameAcceptButton)
	S.Reskin(GuildFinderRequestMembershipFrameCancelButton)

	S.ReskinScroll(LookingForGuildBrowseFrameContainerScrollBar)
	S.ReskinClose(LookingForGuildFrameCloseButton)
	S.ReskinCheck(LookingForGuildQuestButton)
	S.ReskinCheck(LookingForGuildDungeonButton)
	S.ReskinCheck(LookingForGuildRaidButton)
	S.ReskinCheck(LookingForGuildPvPButton)
	S.ReskinCheck(LookingForGuildRPButton)
	S.ReskinCheck(LookingForGuildWeekdaysButton)
	S.ReskinCheck(LookingForGuildWeekendsButton)
	S.ReskinInput(GuildFinderRequestMembershipFrameInputFrame)
end