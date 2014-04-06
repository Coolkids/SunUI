local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local A = S:GetModule("Skins")

local function LoadSkin()
	local r, g, b = RAID_CLASS_COLORS[S.myclass].r, RAID_CLASS_COLORS[S.myclass].g, RAID_CLASS_COLORS[S.myclass].b
	A:SetBD(LookingForGuildFrame)
	A:CreateBD(LookingForGuildInterestFrame, .25)
	LookingForGuildInterestFrameBg:Hide()
	A:CreateBD(LookingForGuildAvailabilityFrame, .25)
	LookingForGuildAvailabilityFrameBg:Hide()
	A:CreateBD(LookingForGuildRolesFrame, .25)
	LookingForGuildRolesFrameBg:Hide()
	A:CreateBD(LookingForGuildCommentFrame, .25)
	LookingForGuildCommentFrameBg:Hide()
	A:CreateBD(LookingForGuildCommentInputFrame, .12)
	LookingForGuildFrame:DisableDrawLayer("BACKGROUND")
	LookingForGuildFrame:DisableDrawLayer("BORDER")
	LookingForGuildFrameInset:DisableDrawLayer("BACKGROUND")
	LookingForGuildFrameInset:DisableDrawLayer("BORDER")
	for i = 1, 5 do
		local bu = _G["LookingForGuildBrowseFrameContainerButton"..i]
		A:CreateBD(bu, .25)
		bu:SetHighlightTexture("")
		bu:GetRegions():SetTexture(A["media"].backdrop)
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
	LookingForGuildFrameTabardBackground:Hide()
	LookingForGuildFrameTabardEmblem:Hide()
	LookingForGuildFrameTabardBorder:Hide()
	LookingForGuildFramePortraitFrame:Hide()
	LookingForGuildFrameTopBorder:Hide()
	LookingForGuildFrameTopRightCorner:Hide()
	LookingForGuildBrowseButton_LeftSeparator:Hide()
	LookingForGuildRequestButton_RightSeparator:Hide()

	A:Reskin(LookingForGuildBrowseButton)
	A:Reskin(LookingForGuildRequestButton)

	A:ReskinScroll(LookingForGuildBrowseFrameContainerScrollBar)
	A:ReskinClose(LookingForGuildFrameCloseButton)
	A:ReskinCheck(LookingForGuildQuestButton)
	A:ReskinCheck(LookingForGuildDungeonButton)
	A:ReskinCheck(LookingForGuildRaidButton)
	A:ReskinCheck(LookingForGuildPvPButton)
	A:ReskinCheck(LookingForGuildRPButton)
	A:ReskinCheck(LookingForGuildWeekdaysButton)
	A:ReskinCheck(LookingForGuildWeekendsButton)
	A:ReskinCheck(LookingForGuildTankButton:GetChildren())
	A:ReskinCheck(LookingForGuildHealerButton:GetChildren())
	A:ReskinCheck(LookingForGuildDamagerButton:GetChildren())
	A:CreateBD(GuildFinderRequestMembershipFrame)
	A:CreateSD(GuildFinderRequestMembershipFrame)
	for i = 1, 6 do
		select(i, GuildFinderRequestMembershipFrameInputFrame:GetRegions()):Hide()
	end
	A:Reskin(GuildFinderRequestMembershipFrameAcceptButton)
	A:Reskin(GuildFinderRequestMembershipFrameCancelButton)
	A:ReskinInput(GuildFinderRequestMembershipFrameInputFrame)
end

A:RegisterSkin("Blizzard_LookingForGuildUI", LoadSkin)