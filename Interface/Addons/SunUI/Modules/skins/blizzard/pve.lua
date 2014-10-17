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
	--PVEFrameTab3:SetPoint("LEFT", PVEFrameTab2, "RIGHT", -15, 0)
	
	GroupFinderFrameGroupButton1.icon:SetTexture("Interface\\Icons\\INV_Helmet_08")
	GroupFinderFrameGroupButton2.icon:SetTexture("Interface\\Icons\\inv_helmet_06")
	GroupFinderFrameGroupButton3.icon:SetTexture("Interface\\Icons\\Icon_Scenarios")
	
	local function onEnter(self)
		self:SetBackdropColor(r, g, b, .4)
	end
	
	local function onLeave(self)
		self:SetBackdropColor(0, 0, 0, 0)
	end

	for i = 1, 4 do
		local bu = GroupFinderFrame["groupButton"..i]

		bu.ring:Hide()
		bu.bg:SetTexture(A["media"].backdrop)
		bu.bg:SetVertexColor(r, g, b, .2)
		bu.bg:SetAllPoints()

		
		A:Reskin(bu, true)			
		bu:SetScript("OnEnter", onEnter)
		bu:SetScript("OnLeave", onLeave)

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
	A:CreateTab(PVEFrameTab1)
	A:CreateTab(PVEFrameTab2)
	A:CreateTab(PVEFrameTab3)

	A:Reskin(LFDQueueFrameFindGroupButton)
	A:Reskin(LFDQueueFrameCancelButton)
	A:Reskin(LFDRoleCheckPopupAcceptButton)
	A:Reskin(LFDRoleCheckPopupDeclineButton)
	A:Reskin(LFDQueueFramePartyBackfillBackfillButton)
	A:Reskin(RaidFinderQueueFramePartyBackfillBackfillButton)
	A:Reskin(LFDQueueFramePartyBackfillNoBackfillButton)
	A:Reskin(LFDQueueFrameRandomScrollFrameChildFrameBonusRepFrame.ChooseButton)
	A:Reskin(ScenarioQueueFrameRandomScrollFrameChildFrameBonusRepFrame.ChooseButton)
	A:Reskin(RaidFinderQueueFramePartyBackfillNoBackfillButton)
	A:ReskinClose(LFGDungeonReadyStatusCloseButton)
	A:ReskinCheck(LFGInvitePopupRoleButtonTank:GetChildren())
	A:ReskinCheck(LFGInvitePopupRoleButtonHealer:GetChildren())
	A:ReskinCheck(LFGInvitePopupRoleButtonDPS:GetChildren())
	A:CreateBD(LFGInvitePopup)
	A:CreateSD(LFGInvitePopup)
	A:Reskin(LFGInvitePopupAcceptButton)
	A:Reskin(LFGInvitePopupDeclineButton)
	A:ReskinCheck(LFDQueueFrameRoleButtonTank:GetChildren())
	A:ReskinCheck(LFDQueueFrameRoleButtonHealer:GetChildren())
	A:ReskinCheck(LFDQueueFrameRoleButtonDPS:GetChildren())
	A:ReskinCheck(LFDQueueFrameRoleButtonLeader:GetChildren())
	A:ReskinCheck(RaidFinderQueueFrameRoleButtonTank:GetChildren())
	A:ReskinCheck(RaidFinderQueueFrameRoleButtonHealer:GetChildren())
	A:ReskinCheck(RaidFinderQueueFrameRoleButtonDPS:GetChildren())
	A:ReskinCheck(RaidFinderQueueFrameRoleButtonLeader:GetChildren())
	A:ReskinCheck(LFDRoleCheckPopupRoleButtonTank:GetChildren())
	A:ReskinCheck(LFDRoleCheckPopupRoleButtonHealer:GetChildren())
	A:ReskinCheck(LFDRoleCheckPopupRoleButtonDPS:GetChildren())
	A:ReskinScroll(LFDQueueFrameSpecificListScrollFrameScrollBar)
	A:ReskinScroll(LFDQueueFrameRandomScrollFrameScrollBar)
	A:ReskinScroll(ScenarioQueueFrameRandomScrollFrameScrollBar)
	A:ReskinDropDown(LFDQueueFrameTypeDropDown)

	LFDParentFrame:DisableDrawLayer("BACKGROUND")
	LFDParentFrame:DisableDrawLayer("BORDER")
	LFDParentFrame:DisableDrawLayer("OVERLAY")
	LFDParentFrameInset:DisableDrawLayer("BACKGROUND")
	LFDParentFrameInset:DisableDrawLayer("BORDER")
	LFDQueueFrameBackground:Hide()
	LFDQueueFrameCooldownFrameBlackFilter:SetAlpha(.6)
	LFDQueueFrameRandomScrollFrameScrollBackground:Hide()
	LFDQueueFramePartyBackfill:SetAlpha(.6)
	LFDQueueFrameFindGroupButton_RightSeparator:Hide()
	LFDQueueFrameSpecificListScrollFrameScrollBackgroundTopLeft:Hide()
	LFDQueueFrameSpecificListScrollFrameScrollBackgroundBottomRight:Hide()
	LFDQueueFrameSpecificListScrollFrameScrollBarScrollDownButton:SetPoint("TOP", LFDQueueFrameSpecificListScrollFrameScrollBar, "BOTTOM", 0, 2)
	LFDQueueFrameRandomScrollFrameScrollBarScrollDownButton:SetPoint("TOP", LFDQueueFrameRandomScrollFrameScrollBar, "BOTTOM", 0, 2)
	LFDQueueFrameRandomScrollFrame:SetWidth(304)

	hooksecurefunc("LFGRewardsFrame_SetItemButton", function(parentFrame, dungeonID, index)
		local parentName = parentFrame:GetName()
		local button = _G[parentName.."Item"..index]
		local icon = _G[parentName.."Item"..index.."IconTexture"]
		icon:SetTexCoord(.08, .92, .08, .92)
		if not button.reskinned then
			local cta = _G[parentName.."Item"..index.."ShortageBorder"]
			local count = _G[parentName.."Item"..index.."Count"]
			local na = _G[parentName.."Item"..index.."NameFrame"]

			A:CreateBG(icon)
			icon:SetDrawLayer("OVERLAY")
			count:SetDrawLayer("OVERLAY")
			na:SetTexture(0, 0, 0, .25)
			na:SetSize(118, 39)
			cta:SetAlpha(0)

			button.bg2 = CreateFrame("Frame", nil, button)
			button.bg2:SetPoint("TOPLEFT", na, "TOPLEFT", 10, 0)
			button.bg2:SetPoint("BOTTOMRIGHT", na, "BOTTOMRIGHT")
			A:CreateBD(button.bg2, 0)

			button.reskinned = true
		end
	end)

	LFGDungeonReadyDialog.SetBackdrop = S.dummy
	LFGDungeonReadyDialogBackground:Hide()
	LFGDungeonReadyDialogBottomArt:Hide()
	LFGDungeonReadyDialogFiligree:Hide()
	A:Reskin(LFGDungeonReadyDialogEnterDungeonButton)
	A:Reskin(LFGDungeonReadyDialogLeaveQueueButton)
	A:Reskin(LFDQueueFrameNoLFDWhileLFRLeaveQueueButton)

	for i = 1, 9 do
		select(i, QueueStatusFrame:GetRegions()):Hide()
	end

	QueueStatusMinimapButtonBorder:Kill()
	QueueStatusMinimapButton:ClearAllPoints()
	QueueStatusMinimapButton:Point("TOP", Minimap, "TOP")
	QueueStatusFrame:ClearAllPoints()
	QueueStatusFrame:Point("TOPLEFT", Minimap, "TOPRIGHT", 5, 2)
	A:Reskin(LFRQueueFrameFindGroupButton)
	A:Reskin(LFRQueueFrameAcceptCommentButton)
	A:Reskin(LFRBrowseFrameSendMessageButton)
	A:Reskin(LFRBrowseFrameInviteButton)
	A:Reskin(LFRBrowseFrameRefreshButton)
	A:ReskinCheck(LFRQueueFrameRoleButtonTank:GetChildren())
	A:ReskinCheck(LFRQueueFrameRoleButtonHealer:GetChildren())
	A:ReskinCheck(LFRQueueFrameRoleButtonDPS:GetChildren())
	A:ReskinDropDown(LFRBrowseFrameRaidDropDown)
	LFRQueueFrame:DisableDrawLayer("BACKGROUND")
	LFRBrowseFrame:DisableDrawLayer("BACKGROUND")
	for i = 1, 7 do
		_G["LFRBrowseFrameColumnHeader"..i]:DisableDrawLayer("BACKGROUND")
	end
	RaidParentFrame:DisableDrawLayer("BACKGROUND")
	RaidParentFrame:DisableDrawLayer("BORDER")
	RaidParentFrameInset:DisableDrawLayer("BORDER")
	RaidFinderFrameRoleInset:DisableDrawLayer("BORDER")
	LFRQueueFrameRoleInset:DisableDrawLayer("BORDER")
	LFRQueueFrameListInset:DisableDrawLayer("BORDER")
	LFRQueueFrameCommentInset:DisableDrawLayer("BORDER")
	LFRQueueFrameRoleInsetBg:Hide()
	LFRQueueFrameListInsetBg:Hide()
	LFRQueueFrameCommentInsetBg:Hide()
	RaidFinderQueueFrameBackground:Hide()
	RaidParentFrameInsetBg:Hide()
	RaidFinderFrameRoleInsetBg:Hide()
	RaidFinderFrameRoleBackground:Hide()
	RaidParentFramePortraitFrame:Hide()
	RaidParentFramePortrait:Hide()
	RaidParentFrameTopBorder:Hide()
	RaidParentFrameTopRightCorner:Hide()
	RaidFinderFrameFindRaidButton_RightSeparator:Hide()
	RaidFinderFrameBottomInset:DisableDrawLayer("BORDER")
	RaidFinderFrameBottomInsetBg:Hide()
	RaidFinderFrameBtnCornerRight:Hide()
	RaidFinderFrameButtonBottomBorder:Hide()

	A:Reskin(RaidFinderFrameFindRaidButton)
	A:Reskin(RaidFinderFrameCancelButton)
	A:Reskin(RaidFinderQueueFrameIneligibleFrameLeaveQueueButton)
	A:ReskinDropDown(RaidFinderQueueFrameSelectionDropDown)
	A:ReskinClose(RaidParentFrameCloseButton)

	-- Scenario finder
	ScenarioFinderFrameInset:DisableDrawLayer("BORDER")
	ScenarioFinderFrame.TopTileStreaks:Hide()
	ScenarioFinderFrameBtnCornerRight:Hide()
	ScenarioFinderFrameButtonBottomBorder:Hide()
	ScenarioQueueFrame.Bg:Hide()
	ScenarioFinderFrameInset:GetRegions():Hide()

	A:Reskin(ScenarioQueueFrameFindGroupButton)
	A:ReskinDropDown(ScenarioQueueFrameTypeDropDown)
	
	-- Raid frame (social frame)
	A:Reskin(RaidFrameRaidBrowserButton)

	-- Looking for raid
	LFRBrowseFrameRoleInset:DisableDrawLayer("BORDER")
	LFRQueueFrameSpecificListScrollFrameScrollBackgroundTopLeft:Hide()
	LFRQueueFrameSpecificListScrollFrameScrollBackgroundBottomRight:Hide()
	LFRBrowseFrameRoleInsetBg:Hide()
	
	A:ReskinPortraitFrame(RaidBrowserFrame)
	A:ReskinScroll(LFRQueueFrameSpecificListScrollFrameScrollBar)
	A:ReskinScroll(LFRQueueFrameCommentScrollFrameScrollBar)
	
	for i = 1, 2 do
		local tab = _G["LFRParentFrameSideTab"..i]
		tab:GetRegions():Hide()
		tab:SetCheckedTexture(A["media"].checked)
		if i == 1 then
			local a1, p, a2, x, y = tab:GetPoint()
			tab:SetPoint(a1, p, a2, x + 11, y)
		end
		A:CreateBG(tab)
		A:CreateSD(tab, 5, 0, 0, 0, 1, 1)
		select(2, tab:GetRegions()):SetTexCoord(.08, .92, .08, .92)
	end

	--Flex Raid
	--[[FlexRaidFrameScrollFrame:StripTextures()
	FlexRaidFrameBottomInset:StripTextures()
	hooksecurefunc("FlexRaidFrame_Update", function()
		FlexRaidFrame.ScrollFrame.Background:SetTexture(nil)
	end)

	A:ReskinDropDown(FlexRaidFrameSelectionDropDown)
	A:Reskin(FlexRaidFrameStartRaidButton)--]]
end

A:RegisterSkin("SunUI", LoadSkin)
