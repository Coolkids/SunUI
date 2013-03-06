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
	S.ReskinCheck(LookingForGuildTankButton:GetChildren())
	S.ReskinCheck(LookingForGuildHealerButton:GetChildren())
	S.ReskinCheck(LookingForGuildDamagerButton:GetChildren())
	S.ReskinInput(GuildFinderRequestMembershipFrameInputFrame)
end