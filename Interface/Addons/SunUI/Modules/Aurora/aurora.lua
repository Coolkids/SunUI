local S, L, DB, _, C = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("Aurora", "AceEvent-3.0")
local SunUIConfig = LibStub("AceAddon-3.0"):GetAddon("SunUI"):GetModule("SunUIConfig")
local alpha = .5
local class = DB.MyClass
local media = DB.media
local AuroraConfig = DB.AuroraConfig
local r, g, b = DB.MyClassColor.r, DB.MyClassColor.g, DB.MyClassColor.b
local gradOr, startR, startG, startB, startAlpha, endR, endG, endB, endAlpha = unpack(AuroraConfig.gradientAlpha)
local classcolours = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS

function Module:ADDON_LOADED(event, addon)
	for module, moduleFunc in pairs(DB.AuroraModules) do
		if type(moduleFunc) == "function" then
			if module == addon then
				moduleFunc()
			end
		elseif type(moduleFunc) == "table" then
			if module == addon then
				for _, moduleFunc in pairs(DB.AuroraModules[module]) do
					moduleFunc()
				end
			end
		end
	end
	if addon == "SunUI" then
		-- [[ Headers ]]

		local header = {"GameMenuFrame", "InterfaceOptionsFrame", "AudioOptionsFrame", "VideoOptionsFrame", "ChatConfigFrame", "ColorPickerFrame"}
		for i = 1, #header do
		local title = _G[header[i].."Header"]
			if title then
				title:SetTexture("")
				title:ClearAllPoints()
				if title == _G["GameMenuFrameHeader"] then
					title:Point("TOP", GameMenuFrame, 0, 7)
				else
					title:SetPoint("TOP", header[i], 0, 0)
				end
			end
		end

		-- [[ Simple backdrops ]]

		local bds = {"AutoCompleteBox", "BNToastFrame", "TicketStatusFrameButton", "GearManagerDialogPopup", "TokenFramePopup", "ReputationDetailFrame", "RaidInfoFrame", "ScrollOfResurrectionSelectionFrame", "ScrollOfResurrectionFrame", "VoiceChatTalkers", "ReportPlayerNameDialog", "ReportCheatingDialog", "QueueStatusFrame"}

		for i = 1, #bds do
			local bd = _G[bds[i]]
			if bd then
				S.CreateBD(bd)
			else
				print("Aurora: "..bds[i].." was not found.")
			end
		end

		local lightbds = {"SecondaryProfession1", "SecondaryProfession2", "SecondaryProfession3", "SecondaryProfession4", "ChatConfigChatSettingsClassColorLegend", "ChatConfigChannelSettingsClassColorLegend", "FriendsFriendsList", "HelpFrameTicketScrollFrame", "HelpFrameGM_ResponseScrollFrame1", "HelpFrameGM_ResponseScrollFrame2", "FriendsFriendsNoteFrame", "AddFriendNoteFrame", "ScrollOfResurrectionSelectionFrameList", "HelpFrameReportBugScrollFrame", "HelpFrameSubmitSuggestionScrollFrame", "ReportPlayerNameDialogCommentFrame", "ReportCheatingDialogCommentFrame"}
		for i = 1, #lightbds do
			local bd = _G[lightbds[i]]
			if bd then
				S.CreateBD(bd, .25)
			else
				print("Aurora: "..lightbds[i].." was not found.")
			end
		end

		-- [[?Scroll bars ]]

		local scrollbars = {"FriendsFrameFriendsScrollFrameScrollBar", "CharacterStatsPaneScrollBar", "LFDQueueFrameSpecificListScrollFrameScrollBar", "HelpFrameKnowledgebaseScrollFrameScrollBar", "HelpFrameReportBugScrollFrameScrollBar", "HelpFrameSubmitSuggestionScrollFrameScrollBar", "HelpFrameTicketScrollFrameScrollBar", "PaperDollTitlesPaneScrollBar", "PaperDollEquipmentManagerPaneScrollBar", "SendMailScrollFrameScrollBar", "OpenMailScrollFrameScrollBar", "RaidInfoScrollFrameScrollBar", "ReputationListScrollFrameScrollBar", "FriendsFriendsScrollFrameScrollBar", "HelpFrameGM_ResponseScrollFrame1ScrollBar", "HelpFrameGM_ResponseScrollFrame2ScrollBar", "HelpFrameKnowledgebaseScrollFrame2ScrollBar", "WhoListScrollFrameScrollBar", "GearManagerDialogPopupScrollFrameScrollBar", "LFDQueueFrameRandomScrollFrameScrollBar", "ScrollOfResurrectionSelectionFrameListScrollFrameScrollBar", "ChannelRosterScrollFrameScrollBar"}
		for i = 1, #scrollbars do
			local scrollbar = _G[scrollbars[i]]
			if scrollbar then
				S.ReskinScroll(scrollbar)
			else
				print("Aurora: "..scrollbars[i].." was not found.")
			end
		end

		-- [[ Dropdowns ]]

		local dropdowns = {"LFDQueueFrameTypeDropDown", "LFRBrowseFrameRaidDropDown", "WhoFrameDropDown", "FriendsFriendsFrameDropDown", "RaidFinderQueueFrameSelectionDropDown", "WorldMapShowDropDown", "Advanced_GraphicsAPIDropDown"}
		for i = 1, #dropdowns do
			local dropdown = _G[dropdowns[i]]
			if dropdown then
				S.ReskinDropDown(dropdown)
			else
				print("Aurora: "..dropdowns[i].." was not found.")
			end
		end

		-- [[ Input frames ]]

		local inputs = {"AddFriendNameEditBox", "SendMailNameEditBox", "SendMailSubjectEditBox", "SendMailMoneyGold", "SendMailMoneySilver", "SendMailMoneyCopper", "StaticPopup1MoneyInputFrameGold", "StaticPopup1MoneyInputFrameSilver", "StaticPopup1MoneyInputFrameCopper", "StaticPopup2MoneyInputFrameGold", "StaticPopup2MoneyInputFrameSilver", "StaticPopup2MoneyInputFrameCopper", "GearManagerDialogPopupEditBox", "HelpFrameKnowledgebaseSearchBox", "ChannelFrameDaughterFrameChannelName", "ChannelFrameDaughterFrameChannelPassword", "BagItemSearchBox", "BankItemSearchBox", "ScrollOfResurrectionSelectionFrameTargetEditBox", "ScrollOfResurrectionFrameNoteFrame"}
		for i = 1, #inputs do
			local input = _G[inputs[i]]
			if input then
				S.ReskinInput(input)
			else
				print("Aurora: "..inputs[i].." was not found.")
			end
		end

		S.ReskinInput(FriendsFrameBroadcastInput)
		S.ReskinInput(StaticPopup1EditBox, 20)
		S.ReskinInput(StaticPopup2EditBox, 20)

		-- [[ Arrows ]]

		S.ReskinArrow(SpellBookPrevPageButton, "left")
		S.ReskinArrow(SpellBookNextPageButton, "right")
		S.ReskinArrow(InboxPrevPageButton, "left")
		S.ReskinArrow(InboxNextPageButton, "right")
		S.ReskinArrow(MerchantPrevPageButton, "left")
		S.ReskinArrow(MerchantNextPageButton, "right")
		S.ReskinArrow(CharacterFrameExpandButton, "left")
		S.ReskinArrow(TabardCharacterModelRotateLeftButton, "left")
		S.ReskinArrow(TabardCharacterModelRotateRightButton, "right")

		hooksecurefunc("CharacterFrame_Expand", function()
			select(15, CharacterFrameExpandButton:GetRegions()):SetTexture(media.arrowLeft)
		end)

		hooksecurefunc("CharacterFrame_Collapse", function()
			select(15, CharacterFrameExpandButton:GetRegions()):SetTexture(media.arrowRight)
		end)

		-- [[ Check boxes ]]

		local checkboxes = {"TokenFramePopupInactiveCheckBox", "TokenFramePopupBackpackCheckBox", "ReputationDetailAtWarCheckBox", "ReputationDetailInactiveCheckBox", "ReputationDetailMainScreenCheckBox"}
		for i = 1, #checkboxes do
			local checkbox = _G[checkboxes[i]]
			if checkbox then
				S.ReskinCheck(checkbox)
			else
				print("Aurora: "..checkboxes[i].." was not found.")
			end
		end

		S.ReskinCheck(LFDQueueFrameRoleButtonTank.checkButton)
		S.ReskinCheck(LFDQueueFrameRoleButtonHealer.checkButton)
		S.ReskinCheck(LFDQueueFrameRoleButtonDPS.checkButton)
		S.ReskinCheck(LFDQueueFrameRoleButtonLeader.checkButton)
		S.ReskinCheck(LFRQueueFrameRoleButtonTank.checkButton)
		S.ReskinCheck(LFRQueueFrameRoleButtonHealer.checkButton)
		S.ReskinCheck(LFRQueueFrameRoleButtonDPS.checkButton)
		S.ReskinCheck(LFDRoleCheckPopupRoleButtonTank.checkButton)
		S.ReskinCheck(LFDRoleCheckPopupRoleButtonHealer.checkButton)
		S.ReskinCheck(LFDRoleCheckPopupRoleButtonDPS.checkButton)
		S.ReskinCheck(RaidFinderQueueFrameRoleButtonTank.checkButton)
		S.ReskinCheck(RaidFinderQueueFrameRoleButtonHealer.checkButton)
		S.ReskinCheck(RaidFinderQueueFrameRoleButtonDPS.checkButton)
		S.ReskinCheck(RaidFinderQueueFrameRoleButtonLeader.checkButton)
		S.ReskinCheck(LFGInvitePopupRoleButtonTank.checkButton)
		S.ReskinCheck(LFGInvitePopupRoleButtonHealer.checkButton)
		S.ReskinCheck(LFGInvitePopupRoleButtonDPS.checkButton)

		-- [[ Radio buttons ]]

		local radiobuttons = {"ReportPlayerNameDialogPlayerNameCheckButton", "ReportPlayerNameDialogGuildNameCheckButton", "ReportPlayerNameDialogArenaTeamNameCheckButton", "SendMailSendMoneyButton", "SendMailCODButton"}
		for i = 1, #radiobuttons do
			local radiobutton = _G[radiobuttons[i]]
			if radiobutton then
				S.ReskinRadio(radiobutton)
			else
				print("Aurora: "..radiobuttons[i].." was not found.")
			end
		end

		S.ReskinRadio(RolePollPopupRoleButtonTank.checkButton)
		S.ReskinRadio(RolePollPopupRoleButtonHealer.checkButton)
		S.ReskinRadio(RolePollPopupRoleButtonDPS.checkButton)

		-- [[ Backdrop frames ]]

		S.SetBD(DressUpFrame, 10, -12, -34, 74)
		S.SetBD(HelpFrame)
		S.SetBD(SpellBookFrame)
		S.SetBD(RaidParentFrame)

		local FrameBDs = {"StaticPopup1", "StaticPopup2", "GameMenuFrame", "InterfaceOptionsFrame", "VideoOptionsFrame", "AudioOptionsFrame", "LFGDungeonReadyStatus", "ChatConfigFrame", "StackSplitFrame", "AddFriendFrame", "FriendsFriendsFrame", "ColorPickerFrame", "ReadyCheckFrame", "LFDRoleCheckPopup", "LFGDungeonReadyDialog", "RolePollPopup", "GuildInviteFrame", "ChannelFrameDaughterFrame", "LFGInvitePopup"}
		for i = 1, #FrameBDs do
			FrameBD = _G[FrameBDs[i]]
			S.CreateBD(FrameBD)
			S.CreateSD(FrameBD)
		end

		LFGDungeonReadyDialog.SetBackdrop = S.dummy

		-- Dropdown lists

		hooksecurefunc("UIDropDownMenu_CreateFrames", function(level, index)
			for i = 1, UIDROPDOWNMENU_MAXLEVELS do
				local menu = _G["DropDownList"..i.."MenuBackdrop"]
				local backdrop = _G["DropDownList"..i.."Backdrop"]
				if not backdrop.reskinned then
					S.CreateBD(menu)
					S.CreateBD(backdrop)
					backdrop.reskinned = true
				end
			end
		end)

		local createBackdrop = function(parent, texture)
			local bg = parent:CreateTexture(nil, "BACKGROUND")
			bg:SetTexture(0, 0, 0, .5)
			bg:SetPoint("CENTER", texture)
			bg:Size(12, 12)
			parent.bg = bg

			local left = parent:CreateTexture(nil, "BACKGROUND")
			left:Width(1)
			left:SetTexture(0, 0, 0)
			left:SetPoint("TOPLEFT", bg)
			left:SetPoint("BOTTOMLEFT", bg)
			parent.left = left

			local right = parent:CreateTexture(nil, "BACKGROUND")
			right:Width(1)
			right:SetTexture(0, 0, 0)
			right:SetPoint("TOPRIGHT", bg)
			right:SetPoint("BOTTOMRIGHT", bg)
			parent.right = right

			local top = parent:CreateTexture(nil, "BACKGROUND")
			top:Height(1)
			top:SetTexture(0, 0, 0)
			top:SetPoint("TOPLEFT", bg)
			top:SetPoint("TOPRIGHT", bg)
			parent.top = top

			local bottom = parent:CreateTexture(nil, "BACKGROUND")
			bottom:Height(1)
			bottom:SetTexture(0, 0, 0)
			bottom:SetPoint("BOTTOMLEFT", bg)
			bottom:SetPoint("BOTTOMRIGHT", bg)
			parent.bottom = bottom
		end

		local toggleBackdrop = function(bu, show)
			if show then
				bu.bg:Show()
				bu.left:Show()
				bu.right:Show()
				bu.top:Show()
				bu.bottom:Show()
			else
				bu.bg:Hide()
				bu.left:Hide()
				bu.right:Hide()
				bu.top:Hide()
				bu.bottom:Hide()
			end
		end

		hooksecurefunc("ToggleDropDownMenu", function(level, _, dropDownFrame, anchorName)
			if not level then level = 1 end

			local uiScale = UIParent:GetScale()

			local listFrame = _G["DropDownList"..level]

			if level == 1 then
				if not anchorName then
					local xOffset = dropDownFrame.xOffset and dropDownFrame.xOffset or 16
					local yOffset = dropDownFrame.yOffset and dropDownFrame.yOffset or 9
					local point = dropDownFrame.point and dropDownFrame.point or "TOPLEFT"
					local relativeTo = dropDownFrame.relativeTo and dropDownFrame.relativeTo or dropDownFrame
					local relativePoint = dropDownFrame.relativePoint and dropDownFrame.relativePoint or "BOTTOMLEFT"

					listFrame:ClearAllPoints()
					listFrame:SetPoint(point, relativeTo, relativePoint, xOffset, yOffset)

					-- make sure it doesn't go off the screen
					local offLeft = listFrame:GetLeft()/uiScale
					local offRight = (GetScreenWidth() - listFrame:GetRight())/uiScale
					local offTop = (GetScreenHeight() - listFrame:GetTop())/uiScale
					local offBottom = listFrame:GetBottom()/uiScale

					local xAddOffset, yAddOffset = 0, 0
					if offLeft < 0 then
						xAddOffset = -offLeft
					elseif offRight < 0 then
						xAddOffset = offRight
					end

					if offTop < 0 then
						yAddOffset = offTop
					elseif offBottom < 0 then
						yAddOffset = -offBottom
					end
					listFrame:ClearAllPoints()
					listFrame:SetPoint(point, relativeTo, relativePoint, xOffset + xAddOffset, yOffset + yAddOffset)
				elseif anchorName ~= "cursor" then
					-- this part might be a bit unreliable
					local _, _, relPoint, xOff, yOff = listFrame:GetPoint()
					if relPoint == "BOTTOMLEFT" and xOff == 0 and floor(yOff) == 5 then
						listFrame:Point("TOPLEFT", anchorName, "BOTTOMLEFT", 16, 9)
					end
				end
			else
				local point, anchor, relPoint, _, y = listFrame:GetPoint()
				if point:find("RIGHT") then
					listFrame:Point(point, anchor, relPoint, -14, y)
				else
					listFrame:Point(point, anchor, relPoint, 9, y)
				end
			end

			for j = 1, UIDROPDOWNMENU_MAXBUTTONS do
				local bu = _G["DropDownList"..level.."Button"..j]
				local _, _, _, x = bu:GetPoint()
				if bu:IsShown() and x then
					local hl = _G["DropDownList"..level.."Button"..j.."Highlight"]
					local check = _G["DropDownList"..level.."Button"..j.."Check"]

					hl:Point("TOPLEFT", -x + 1, 0)
					hl:Point("BOTTOMRIGHT", listFrame:GetWidth() - bu:GetWidth() - x - 1, 0)

					if not bu.bg then
						createBackdrop(bu, check)
						hl:SetTexture(r, g, b, .2)
						_G["DropDownList"..level.."Button"..j.."UnCheck"]:SetTexture("")
					end

					if not bu.notCheckable then
						toggleBackdrop(bu, true)

						-- only reliable way to see if button is radio or or check...
						local _, co = check:GetTexCoord()

						if co == 0 then
							check:SetTexture("Interface\\Buttons\\UI-CheckBox-Check")
							check:SetVertexColor(r, g, b, 1)
							check:Size(20, 20)
							check:SetDesaturated(true)
						else
							check:SetTexture(media.backdrop)
							check:SetVertexColor(r, g, b, .6)
							check:Size(10, 10)
							check:SetDesaturated(false)
						end

						check:SetTexCoord(0, 1, 0, 1)
					else
						toggleBackdrop(bu, false)
					end
				end
			end
		end)

		-- [[ Custom skins ]]

		-- Pet stuff

		if class == "HUNTER" or class == "MAGE" or class == "DEATHKNIGHT" or class == "WARLOCK" then
			if class == "HUNTER" then
				PetStableBottomInset:DisableDrawLayer("BACKGROUND")
				PetStableBottomInset:DisableDrawLayer("BORDER")
				PetStableLeftInset:DisableDrawLayer("BACKGROUND")
				PetStableLeftInset:DisableDrawLayer("BORDER")
				PetStableModelShadow:Hide()
				PetStableModelRotateLeftButton:Hide()
				PetStableModelRotateRightButton:Hide()
				PetStableFrameModelBg:Hide()
				PetStablePrevPageButtonIcon:SetTexture("")
				PetStableNextPageButtonIcon:SetTexture("")

				S.ReskinPortraitFrame(PetStableFrame, true)
				S.ReskinArrow(PetStablePrevPageButton, "left")
				S.ReskinArrow(PetStableNextPageButton, "right")

				PetStableSelectedPetIcon:SetTexCoord(.08, .92, .08, .92)
				S.CreateBG(PetStableSelectedPetIcon)

				for i = 1, NUM_PET_ACTIVE_SLOTS do
					local bu = _G["PetStableActivePet"..i]

					bu.Background:Hide()
					bu.Border:Hide()

					bu:SetNormalTexture("")
					bu.Checked:SetTexture(media.checked)

					_G["PetStableActivePet"..i.."IconTexture"]:SetTexCoord(.08, .92, .08, .92)
					S.CreateBD(bu, .25)
				end

				for i = 1, NUM_PET_STABLE_SLOTS do
					local bu = _G["PetStableStabledPet"..i]
					local bd = CreateFrame("Frame", nil, bu)
					bd:Point("TOPLEFT", -1, 1)
					bd:Point("BOTTOMRIGHT", 1, -1)
					S.CreateBD(bd, .25)
					bu:SetNormalTexture("")
					bu:DisableDrawLayer("BACKGROUND")
					_G["PetStableStabledPet"..i.."IconTexture"]:SetTexCoord(.08, .92, .08, .92)
				end
			end

			hooksecurefunc("PetPaperDollFrame_UpdateIsAvailable", function()
				if not HasPetUI() then
					CharacterFrameTab3:SetPoint("LEFT", CharacterFrameTab2, "LEFT", 0, 0)
				else
					CharacterFrameTab3:Point("LEFT", CharacterFrameTab2, "RIGHT", -15, 0)
				end
			end)

			PetModelFrameRotateLeftButton:Hide()
			PetModelFrameRotateRightButton:Hide()
			PetModelFrameShadowOverlay:Hide()
			PetPaperDollPetModelBg:SetAlpha(0)
		end

		-- Ghost frame

		GhostFrameContentsFrameIcon:SetTexCoord(.08, .92, .08, .92)

		local GhostBD = CreateFrame("Frame", nil, GhostFrameContentsFrame)
		GhostBD:Point("TOPLEFT", GhostFrameContentsFrameIcon, -1, 1)
		GhostBD:Point("BOTTOMRIGHT", GhostFrameContentsFrameIcon, 1, -1)
		S.CreateBD(GhostBD, 0)

		-- Mail frame

		SendMailMoneyInset:DisableDrawLayer("BORDER")
		InboxFrame:GetRegions():Hide()
		SendMailMoneyBg:Hide()
		SendMailMoneyInsetBg:Hide()
		OpenMailFrameIcon:Hide()
		OpenMailHorizontalBarLeft:Hide()
		select(18, MailFrame:GetRegions()):Hide()
		select(26, OpenMailFrame:GetRegions()):Hide()

		OpenMailLetterButton:SetNormalTexture("")
		OpenMailLetterButton:SetPushedTexture("")
		OpenMailLetterButtonIconTexture:SetTexCoord(.08, .92, .08, .92)

		local bgmail = CreateFrame("Frame", nil, OpenMailLetterButton)
		bgmail:Point("TOPLEFT", -1, 1)
		bgmail:Point("BOTTOMRIGHT", 1, -1)
		bgmail:SetFrameLevel(OpenMailLetterButton:GetFrameLevel()-1)
		S.CreateBD(bgmail)

		OpenMailMoneyButton:SetNormalTexture("")
		OpenMailMoneyButton:SetPushedTexture("")
		OpenMailMoneyButtonIconTexture:SetTexCoord(.08, .92, .08, .92)

		local bgmoney = CreateFrame("Frame", nil, OpenMailMoneyButton)
		bgmoney:Point("TOPLEFT", -1, 1)
		bgmoney:Point("BOTTOMRIGHT", 1, -1)
		bgmoney:SetFrameLevel(OpenMailMoneyButton:GetFrameLevel()-1)
		S.CreateBD(bgmoney)

		for i = 1, INBOXITEMS_TO_DISPLAY do
			local it = _G["MailItem"..i]
			local bu = _G["MailItem"..i.."Button"]
			local st = _G["MailItem"..i.."ButtonSlot"]
			local ic = _G["MailItem"..i.."Button".."Icon"]
			local line = select(3, _G["MailItem"..i]:GetRegions())

			local a, b = it:GetRegions()
			a:Hide()
			b:Hide()

			bu:SetCheckedTexture(media.checked)

			st:Hide()
			line:Hide()
			ic:SetTexCoord(.08, .92, .08, .92)

			local bg = CreateFrame("Frame", nil, bu)
			bg:Point("TOPLEFT", -1, 1)
			bg:Point("BOTTOMRIGHT", 1, -1)
			bg:SetFrameLevel(bu:GetFrameLevel()-1)
			S.CreateBD(bg, 0)
		end

		for i = 1, ATTACHMENTS_MAX_SEND do
			local button = _G["SendMailAttachment"..i]
			button:GetRegions():Hide()

			local bg = CreateFrame("Frame", nil, button)
			bg:Point("TOPLEFT", -1, 1)
			bg:Point("BOTTOMRIGHT", 1, -1)
			bg:SetFrameLevel(0)
			S.CreateBD(bg, .25)
		end

		for i = 1, ATTACHMENTS_MAX_RECEIVE do
			local bu = _G["OpenMailAttachmentButton"..i]
			local ic = _G["OpenMailAttachmentButton"..i.."IconTexture"]

			bu:SetNormalTexture("")
			bu:SetPushedTexture("")
			ic:SetTexCoord(.08, .92, .08, .92)

			local bg = CreateFrame("Frame", nil, bu)
			bg:Point("TOPLEFT", -1, 1)
			bg:Point("BOTTOMRIGHT", 1, -1)
			bg:SetFrameLevel(0)
			S.CreateBD(bg, .25)
		end

		hooksecurefunc("SendMailFrame_Update", function()
			for i = 1, ATTACHMENTS_MAX_SEND do
				local button = _G["SendMailAttachment"..i]
				if button:GetNormalTexture() then
					button:GetNormalTexture():SetTexCoord(.08, .92, .08, .92)
				end
			end
		end)

		S.ReskinPortraitFrame(MailFrame, true)
		S.ReskinPortraitFrame(OpenMailFrame, true)

		-- Currency frame

		TokenFrame:HookScript("OnShow", function()
			for i=1, GetCurrencyListSize() do
				local button = _G["TokenFrameContainerButton"..i]

				if button and not button.reskinned then
					button.highlight:Point("TOPLEFT", 1, 0)
					button.highlight:Point("BOTTOMRIGHT", -1, 0)
					button.highlight.SetPoint = S.dummy
					button.highlight:SetTexture(r, g, b, .2)
					button.highlight.SetTexture = S.dummy
					button.categoryMiddle:SetAlpha(0)
					button.categoryLeft:SetAlpha(0)
					button.categoryRight:SetAlpha(0)

					if button.icon and button.icon:GetTexture() then
						button.icon:SetTexCoord(.08, .92, .08, .92)
						S.CreateBG(button.icon)
					end
					button.reskinned = true
				end
			end
		end)

		S.ReskinScroll(TokenFrameContainerScrollBar)

		-- Reputation frame

		local function UpdateFactionSkins()
			for i = 1, GetNumFactions() do
				local statusbar = _G["ReputationBar"..i.."ReputationBar"]

				if statusbar then
					statusbar:SetStatusBarTexture(media.backdrop)

					if not statusbar.reskinned then
						S.CreateBD(statusbar, .25)
						statusbar.reskinned = true
					end

					_G["ReputationBar"..i.."Background"]:SetTexture(nil)
					_G["ReputationBar"..i.."ReputationBarHighlight1"]:SetTexture(nil)
					_G["ReputationBar"..i.."ReputationBarHighlight2"]:SetTexture(nil)
					_G["ReputationBar"..i.."ReputationBarAtWarHighlight1"]:SetTexture(nil)
					_G["ReputationBar"..i.."ReputationBarAtWarHighlight2"]:SetTexture(nil)
					_G["ReputationBar"..i.."ReputationBarLeftTexture"]:SetTexture(nil)
					_G["ReputationBar"..i.."ReputationBarRightTexture"]:SetTexture(nil)
				end
			end
		end

		ReputationFrame:HookScript("OnShow", UpdateFactionSkins)
		ReputationFrame:HookScript("OnEvent", UpdateFactionSkins)

		for i = 1, NUM_FACTIONS_DISPLAYED do
			local bu = _G["ReputationBar"..i.."ExpandOrCollapseButton"]
			S.ReskinExpandOrCollapse(bu)
		end

		hooksecurefunc("ReputationFrame_Update", function()
			local numFactions = GetNumFactions()
			local factionIndex, factionButton, isCollapsed
			local factionOffset = FauxScrollFrame_GetOffset(ReputationListScrollFrame)

			for i = 1, NUM_FACTIONS_DISPLAYED do
				factionIndex = factionOffset + i
				factionButton = _G["ReputationBar"..i.."ExpandOrCollapseButton"]

				if factionIndex <= numFactions then
					_, _, _, _, _, _, _, _, _, isCollapsed = GetFactionInfo(factionIndex)
					if isCollapsed then
						factionButton.plus:Show()
					else
						factionButton.plus:Hide()
					end
				end
			end
		end)

		-- LFD frame

		LFDQueueFrameRandomScrollFrameScrollBackgroundTopLeft:Hide()
		LFDQueueFrameRandomScrollFrameScrollBackgroundBottomRight:Hide()

		hooksecurefunc("LFDQueueFrameRandom_UpdateFrame", function()
			for i = 1, LFD_MAX_REWARDS do
				local button = _G["LFDQueueFrameRandomScrollFrameChildFrameItem"..i]

				if button and not button.styled then
					local icon = _G["LFDQueueFrameRandomScrollFrameChildFrameItem"..i.."IconTexture"]
					local cta = _G["LFDQueueFrameRandomScrollFrameChildFrameItem"..i.."ShortageBorder"]
					local count = _G["LFDQueueFrameRandomScrollFrameChildFrameItem"..i.."Count"]
					local na = _G["LFDQueueFrameRandomScrollFrameChildFrameItem"..i.."NameFrame"]

					S.CreateBG(icon)
					icon:SetTexCoord(.08, .92, .08, .92)
					icon:SetDrawLayer("OVERLAY")
					count:SetDrawLayer("OVERLAY")
					na:SetTexture(0, 0, 0, .25)
					na:Size(118, 39)
					cta:SetAlpha(0)

					button.bg2 = CreateFrame("Frame", nil, button)
					button.bg2:Point("TOPLEFT", na, "TOPLEFT", 10, 0)
					button.bg2:SetPoint("BOTTOMRIGHT", na, "BOTTOMRIGHT")
					S.CreateBD(button.bg2, 0)

					button.styled = true
				end
			end
		end)

		hooksecurefunc("LFGDungeonListButton_SetDungeon", function(button, dungeonID)
			if not button.expandOrCollapseButton.plus then
				S.ReskinCheck(button.enableButton)
				S.ReskinExpandOrCollapse(button.expandOrCollapseButton)
			end
			if LFGCollapseList[dungeonID] then
				button.expandOrCollapseButton.plus:Show()
			else
				button.expandOrCollapseButton.plus:Hide()
			end

			button.enableButton:GetCheckedTexture():SetDesaturated(true)
		end)

		local bonusValor = LFDQueueFrameRandomScrollFrameChildFrameBonusValor
		bonusValor.Border:Hide()
		bonusValor.Icon:SetTexCoord(.08, .92, .08, .92)
		bonusValor.Icon:Point("CENTER", bonusValor.Border, -3, 0)
		bonusValor.Icon:Size(24, 24)
		bonusValor.BonusText:Point("LEFT", bonusValor.Border, "RIGHT", -5, -1)
		S.CreateBG(bonusValor.Icon)
		
		S.Reskin(LFDQueueFrameRandomScrollFrameChildFrame.bonusRepFrame.ChooseButton)

		-- Raid Finder

		RaidFinderFrameBottomInset:DisableDrawLayer("BORDER")
		RaidFinderFrameBottomInsetBg:Hide()
		RaidFinderFrameBtnCornerRight:Hide()
		RaidFinderFrameButtonBottomBorder:Hide()
		RaidFinderQueueFrameScrollFrameScrollBackground:Hide()
		RaidFinderQueueFrameScrollFrameScrollBackgroundTopLeft:Hide()
		RaidFinderQueueFrameScrollFrameScrollBackgroundBottomRight:Hide()

		for i = 1, LFD_MAX_REWARDS do
			local button = _G["RaidFinderQueueFrameScrollFrameChildFrameItem"..i]

			if button then
				local icon = _G["RaidFinderQueueFrameScrollFrameChildFrameItem"..i.."IconTexture"]
				local cta = _G["RaidFinderQueueFrameScrollFrameChildFrameItem"..i.."ShortageBorder"]
				local count = _G["RaidFinderQueueFrameScrollFrameChildFrameItem"..i.."Count"]
				local na = _G["RaidFinderQueueFrameScrollFrameChildFrameItem"..i.."NameFrame"]

				S.CreateBG(icon)
				icon:SetTexCoord(.08, .92, .08, .92)
				icon:SetDrawLayer("OVERLAY")
				count:SetDrawLayer("OVERLAY")
				na:SetTexture(0, 0, 0, .25)
				na:Size(118, 39)
				cta:SetAlpha(0)

				button.bg2 = CreateFrame("Frame", nil, button)
				button.bg2:Point("TOPLEFT", na, "TOPLEFT", 10, 0)
				button.bg2:SetPoint("BOTTOMRIGHT", na, "BOTTOMRIGHT")
				S.CreateBD(button.bg2, 0)
			end
		end

		S.ReskinScroll(RaidFinderQueueFrameScrollFrameScrollBar)

		-- Scenario finder

		ScenarioFinderFrameInset:DisableDrawLayer("BORDER")
		ScenarioFinderFrame.TopTileStreaks:Hide()
		ScenarioFinderFrameBtnCornerRight:Hide()
		ScenarioFinderFrameButtonBottomBorder:Hide()
		ScenarioQueueFrameRandomScrollFrameScrollBackground:Hide()
		ScenarioQueueFrameRandomScrollFrameScrollBackgroundTopLeft:Hide()
		ScenarioQueueFrameRandomScrollFrameScrollBackgroundBottomRight:Hide()
		ScenarioQueueFrame.Bg:Hide()
		ScenarioFinderFrameInset:GetRegions():Hide()

		ScenarioQueueFrameRandomScrollFrame:Width(304)

		hooksecurefunc("ScenarioQueueFrameRandom_UpdateFrame", function()
			for i = 1, 2 do
				local button = _G["ScenarioQueueFrameRandomScrollFrameChildFrameItem"..i]

				if button and not button.styled then
					local icon = _G["ScenarioQueueFrameRandomScrollFrameChildFrameItem"..i.."IconTexture"]
					local cta = _G["ScenarioQueueFrameRandomScrollFrameChildFrameItem"..i.."ShortageBorder"]
					local count = _G["ScenarioQueueFrameRandomScrollFrameChildFrameItem"..i.."Count"]
					local na = _G["ScenarioQueueFrameRandomScrollFrameChildFrameItem"..i.."NameFrame"]

					S.CreateBG(icon)
					icon:SetTexCoord(.08, .92, .08, .92)
					icon:SetDrawLayer("OVERLAY")
					count:SetDrawLayer("OVERLAY")
					na:SetTexture(0, 0, 0, .25)
					na:Size(118, 39)
					cta:SetAlpha(0)

					button.bg2 = CreateFrame("Frame", nil, button)
					button.bg2:Point("TOPLEFT", na, "TOPLEFT", 10, 0)
					button.bg2:SetPoint("BOTTOMRIGHT", na, "BOTTOMRIGHT")
					S.CreateBD(button.bg2, 0)

					button.styled = true
				end
			end
		end)
		
		local bonusValor = ScenarioQueueFrameRandomScrollFrameChildFrameBonusValor
		bonusValor.Border:Hide()
		bonusValor.Icon:SetTexCoord(.08, .92, .08, .92)
		bonusValor.Icon:Point("CENTER", bonusValor.Border, -3, 0)
		bonusValor.Icon:SetSize(24, 24)
		bonusValor.BonusText:Point("LEFT", bonusValor.Border, "RIGHT", -5, -1)
		S.CreateBG(bonusValor.Icon)
				
		S.Reskin(ScenarioQueueFrameFindGroupButton)
		S.Reskin(ScenarioQueueFrameRandomScrollFrameChildFrame.bonusRepFrame.ChooseButton)
		S.ReskinDropDown(ScenarioQueueFrameTypeDropDown)
		S.ReskinScroll(ScenarioQueueFrameRandomScrollFrameScrollBar)

		-- Raid frame (social frame)

		S.Reskin(RaidFrameRaidBrowserButton)
		S.ReskinCheck(RaidFrameAllAssistCheckButton)

		-- Looking for raid

		LFRBrowseFrameRoleInset:DisableDrawLayer("BORDER")
		LFRQueueFrameSpecificListScrollFrameScrollBackgroundTopLeft:Hide()
		LFRQueueFrameSpecificListScrollFrameScrollBackgroundBottomRight:Hide()
		LFRBrowseFrameRoleInsetBg:Hide()

		S.ReskinPortraitFrame(RaidBrowserFrame)
		S.ReskinScroll(LFRQueueFrameSpecificListScrollFrameScrollBar)
		S.ReskinScroll(LFRQueueFrameCommentScrollFrameScrollBar)

		for i = 1, 2 do
			local tab = _G["LFRParentFrameSideTab"..i]
			tab:GetRegions():Hide()
			tab:SetCheckedTexture(media.checked)
			if i == 1 then
				local a1, p, a2, x, y = tab:GetPoint()
				tab:Point(a1, p, a2, x + 11, y)
			end
			S.CreateBG(tab)
			S.CreateSD(tab, 5, 0, 0, 0, 1, 1)
			select(2, tab:GetRegions()):SetTexCoord(.08, .92, .08, .92)
		end
		for i = 1, NUM_LFR_CHOICE_BUTTONS do
			local bu = _G["LFRQueueFrameSpecificListButton"..i].enableButton
			S.ReskinCheck(bu)
			bu.SetNormalTexture = S.dummy
			bu.SetPushedTexture = S.dummy
			S.ReskinExpandOrCollapse(_G["LFRQueueFrameSpecificListButton"..i].expandOrCollapseButton)
		end
		hooksecurefunc("LFRQueueFrameSpecificListButton_SetDungeon", function(button, dungeonID)
			if LFGCollapseList[dungeonID] then
				button.expandOrCollapseButton.plus:Show()
			else
				button.expandOrCollapseButton.plus:Hide()
			end
			button.enableButton:GetCheckedTexture():SetDesaturated(true)
		 end)
		
		-- Spellbook frame

		for i = 1, SPELLS_PER_PAGE do
			local bu = _G["SpellButton"..i]
			local ic = _G["SpellButton"..i.."IconTexture"]

			_G["SpellButton"..i.."SlotFrame"]:SetAlpha(0)
			_G["SpellButton"..i.."Highlight"]:SetAlpha(0)

			bu.EmptySlot:SetAlpha(0)
			bu.TextBackground:Hide()
			bu.TextBackground2:Hide()
			bu.UnlearnedFrame:SetAlpha(0)

			bu:SetCheckedTexture("")
			bu:SetPushedTexture("")

			ic:SetTexCoord(.08, .92, .08, .92)

			ic.bg = S.CreateBG(bu)
		end

		hooksecurefunc("SpellButton_UpdateButton", function(self)
			local slot, slotType = SpellBook_GetSpellBookSlot(self);
			local name = self:GetName();
			local subSpellString = _G[name.."SubSpellName"]

			subSpellString:SetTextColor(1, 1, 1)
			if slotType == "FUTURESPELL" then
				local level = GetSpellAvailableLevel(slot, SpellBookFrame.bookType)
				if (level and level > UnitLevel("player")) then
					self.RequiredLevelString:SetTextColor(.7, .7, .7)
					self.SpellName:SetTextColor(.7, .7, .7)
					subSpellString:SetTextColor(.7, .7, .7)
				end
			end

			local ic = _G[name.."IconTexture"]
			if not ic.bg then return end
			if ic:IsShown() then
				ic.bg:Show()
			else
				ic.bg:Hide()
			end
		end)

		SpellBookSkillLineTab1:Point("TOPLEFT", SpellBookSideTabsFrame, "TOPRIGHT", 11, -36)

		hooksecurefunc("SpellBookFrame_UpdateSkillLineTabs", function()
			for i = 1, GetNumSpellTabs() do
				local tab = _G["SpellBookSkillLineTab"..i]

				if not tab.styled then
					tab:GetRegions():Hide()
					tab:SetCheckedTexture(media.checked)

					S.CreateBG(tab)
					S.CreateSD(tab, 5, 0, 0, 0, 1, 1)

					tab:GetNormalTexture():SetTexCoord(.08, .92, .08, .92)

					tab.styled = true
				end
			end
		end)

		local coreTabsSkinned = false
		hooksecurefunc("SpellBookCoreAbilities_UpdateTabs", function()
			if coreTabsSkinned then return end
			coreTabsSkinned = true
			for i = 1, GetNumSpecializations() do
				local tab = SpellBookCoreAbilitiesFrame.SpecTabs[i]

				tab:GetRegions():Hide()
				tab:SetCheckedTexture(media.checked)

				S.CreateBG(tab)
				S.CreateSD(tab, 5, 0, 0, 0, 1, 1)

				tab:GetNormalTexture():SetTexCoord(.08, .92, .08, .92)

				if i == 1 then
					tab:Point("TOPLEFT", SpellBookCoreAbilitiesFrame, "TOPRIGHT", 11, -53)
				end
			end
		end)

		hooksecurefunc("SpellBook_UpdateCoreAbilitiesTab", function()
			for i = 1, #SpellBookCoreAbilitiesFrame.Abilities do
				local bu = SpellBook_GetCoreAbilityButton(i)
				if not bu.reskinned then
					bu.EmptySlot:SetAlpha(0)
					bu.ActiveTexture:SetAlpha(0)
					bu.FutureTexture:SetAlpha(0)
					bu.RequiredLevel:SetTextColor(1, 1, 1)

					bu.iconTexture:SetTexCoord(.08, .92, .08, .92)
					bu.iconTexture.bg = S.CreateBG(bu.iconTexture)

					if bu.FutureTexture:IsShown() then
						bu.Name:SetTextColor(.8, .8, .8)
						bu.InfoText:SetTextColor(.7, .7, .7)
					else
						bu.Name:SetTextColor(1, 1, 1)
						bu.InfoText:SetTextColor(.9, .9, .9)
					end
					bu.reskinned = true
				end
			end
		end)

		hooksecurefunc("SpellBook_UpdateWhatHasChangedTab", function()
			for i = 1, #SpellBookWhatHasChanged.ChangedItems do
				local bu = SpellBook_GetWhatChangedItem(i)
				bu.Ring:Hide()
				select(2, bu:GetRegions()):Hide()
				bu:SetTextColor(.9, .9, .9)
				bu.Title:SetTextColor(1, 1, 1)
			end
		end)

		SpellBookFrameTutorialButton.Ring:Hide()
		SpellBookFrameTutorialButton:Point("TOPLEFT", SpellBookFrame, "TOPLEFT", -12, 12)

		-- Professions

		local professions = {"PrimaryProfession1", "PrimaryProfession2", "SecondaryProfession1", "SecondaryProfession2", "SecondaryProfession3", "SecondaryProfession4"}

		for _, button in pairs(professions) do
			local bu = _G[button]
			bu.professionName:SetTextColor(1, 1, 1)
			bu.missingHeader:SetTextColor(1, 1, 1)
			bu.missingText:SetTextColor(1, 1, 1)

			bu.statusBar:Height(13)
			bu.statusBar:SetStatusBarTexture(media.backdrop)
			bu.statusBar:GetStatusBarTexture():SetGradient("VERTICAL", 0, .6, 0, 0, .8, 0)
			bu.statusBar.rankText:SetPoint("CENTER")

			local _, p = bu.statusBar:GetPoint()
			bu.statusBar:Point("TOPLEFT", p, "BOTTOMLEFT", 1, -3)

			_G[button.."StatusBarLeft"]:Hide()
			bu.statusBar.capRight:SetAlpha(0)
			_G[button.."StatusBarBGLeft"]:Hide()
			_G[button.."StatusBarBGMiddle"]:Hide()
			_G[button.."StatusBarBGRight"]:Hide()

			local bg = CreateFrame("Frame", nil, bu.statusBar)
			bg:Point("TOPLEFT", -1, 1)
			bg:Point("BOTTOMRIGHT", 1, -1)
			bg:SetFrameLevel(bu:GetFrameLevel()-1)
			S.CreateBD(bg, .25)
		end

		local professionbuttons = {"PrimaryProfession1SpellButtonTop", "PrimaryProfession1SpellButtonBottom", "PrimaryProfession2SpellButtonTop", "PrimaryProfession2SpellButtonBottom", "SecondaryProfession1SpellButtonLeft", "SecondaryProfession1SpellButtonRight", "SecondaryProfession2SpellButtonLeft", "SecondaryProfession2SpellButtonRight", "SecondaryProfession3SpellButtonLeft", "SecondaryProfession3SpellButtonRight", "SecondaryProfession4SpellButtonLeft", "SecondaryProfession4SpellButtonRight"}

		for _, button in pairs(professionbuttons) do
			local icon = _G[button.."IconTexture"]
			local bu = _G[button]
			_G[button.."NameFrame"]:SetAlpha(0)

			bu:SetPushedTexture("")
			bu:SetCheckedTexture(media.checked)
			bu:GetHighlightTexture():Hide()

			if icon then
				icon:SetTexCoord(.08, .92, .08, .92)
				icon:ClearAllPoints()
				icon:Point("TOPLEFT", 2, -2)
				icon:Point("BOTTOMRIGHT", -2, 2)
				S.CreateBG(icon)
			end
		end

		for i = 1, 2 do
			local bu = _G["PrimaryProfession"..i]
			local bg = CreateFrame("Frame", nil, bu)
			bg:SetPoint("TOPLEFT")
			bg:Point("BOTTOMRIGHT", 0, -4)
			bg:SetFrameLevel(0)
			S.CreateBD(bg, .25)
		end

		-- Merchant Frame

		MerchantMoneyInset:DisableDrawLayer("BORDER")
		MerchantExtraCurrencyInset:DisableDrawLayer("BORDER")
		BuybackBG:SetAlpha(0)
		MerchantMoneyBg:Hide()
		MerchantMoneyInsetBg:Hide()
		MerchantFrameBottomLeftBorder:SetAlpha(0)
		MerchantFrameBottomRightBorder:SetAlpha(0)
		MerchantExtraCurrencyBg:SetAlpha(0)
		MerchantExtraCurrencyInsetBg:Hide()

		S.ReskinPortraitFrame(MerchantFrame, true)
		S.ReskinDropDown(MerchantFrameLootFilter)

		for i = 1, BUYBACK_ITEMS_PER_PAGE do
			local button = _G["MerchantItem"..i]
			local bu = _G["MerchantItem"..i.."ItemButton"]
			local mo = _G["MerchantItem"..i.."MoneyFrame"]
			local ic = bu.icon
			bu:SetHighlightTexture("")
			_G["MerchantItem"..i.."SlotTexture"]:Hide()
			_G["MerchantItem"..i.."NameFrame"]:Hide()
			_G["MerchantItem"..i.."Name"]:Height(20)

			local a1, p, a2= bu:GetPoint()
			bu:Point(a1, p, a2, -2, -2)
			bu:SetNormalTexture("")
			bu:SetPushedTexture("")
			bu:Size(40, 40)

			local a3, p2, a4, x, y = mo:GetPoint()
			mo:Point(a3, p2, a4, x, y+2)

			S.CreateBD(bu, 0)

			button.bd = CreateFrame("Frame", nil, button)
			button.bd:Point("TOPLEFT", 39, 0)
			button.bd:SetPoint("BOTTOMRIGHT")
			button.bd:SetFrameLevel(0)
			S.CreateBD(button.bd, .25)

			ic:SetTexCoord(.08, .92, .08, .92)
			ic:ClearAllPoints()
			ic:Point("TOPLEFT", 1, -1)
			ic:Point("BOTTOMRIGHT", -1, 1)

			for j = 1, 3 do
				S.CreateBG(_G["MerchantItem"..i.."AltCurrencyFrameItem"..j.."Texture"])
				_G["MerchantItem"..i.."AltCurrencyFrameItem"..j.."Texture"]:SetTexCoord(.08, .92, .08, .92)
			end
		end

		hooksecurefunc("MerchantFrame_UpdateMerchantInfo", function()
			local numMerchantItems = GetMerchantNumItems()
			for i = 1, MERCHANT_ITEMS_PER_PAGE do
				local index = ((MerchantFrame.page - 1) * MERCHANT_ITEMS_PER_PAGE) + i
				if index <= numMerchantItems then
					local name, texture, price, stackCount, numAvailable, isUsable, extendedCost = GetMerchantItemInfo(index)
					if extendedCost and (price <= 0) then
						_G["MerchantItem"..i.."AltCurrencyFrame"]:Point("BOTTOMLEFT", "MerchantItem"..i.."NameFrame", "BOTTOMLEFT", 0, 35)
					end

					if AuroraConfig.qualityColour then
						local bu = _G["MerchantItem"..i.."ItemButton"]
						local name = _G["MerchantItem"..i.."Name"]
						if bu.link then
							local _, _, quality = GetItemInfo(bu.link)
							local r, g, b = GetItemQualityColor(quality)

							name:SetTextColor(r, g, b)
						else
							name:SetTextColor(1, 1, 1)
						end
					end
				end
			end

			if AuroraConfig.qualityColour then
				local name = GetBuybackItemLink(GetNumBuybackItems())
				if name then
					local _, _, quality = GetItemInfo(name)
					local r, g, b = GetItemQualityColor(quality)

					MerchantBuyBackItemName:SetTextColor(r, g, b)
				end
			end
		end)

		if AuroraConfig.qualityColour then
			hooksecurefunc("MerchantFrame_UpdateBuybackInfo", function()
				for i = 1, BUYBACK_ITEMS_PER_PAGE do
					local itemLink = GetBuybackItemLink(i)
					local name = _G["MerchantItem"..i.."Name"]

					if itemLink then
						local _, _, quality = GetItemInfo(itemLink)
						local r, g, b = GetItemQualityColor(quality)

						name:SetTextColor(r, g, b)
					else
						name:SetTextColor(1, 1, 1)
					end
				end
			end)
		end

		MerchantBuyBackItemSlotTexture:Hide()
		MerchantBuyBackItemNameFrame:Hide()
		MerchantBuyBackItemItemButton:SetNormalTexture("")
		MerchantBuyBackItemItemButton:SetPushedTexture("")

		S.CreateBD(MerchantBuyBackItemItemButton, 0)
		S.CreateBD(MerchantBuyBackItem, .25)

		MerchantBuyBackItemItemButtonIconTexture:SetTexCoord(.08, .92, .08, .92)
		MerchantBuyBackItemItemButtonIconTexture:ClearAllPoints()
		MerchantBuyBackItemItemButtonIconTexture:Point("TOPLEFT", 1, -1)
		MerchantBuyBackItemItemButtonIconTexture:Point("BOTTOMRIGHT", -1, 1)

		MerchantGuildBankRepairButton:SetPushedTexture("")
		S.CreateBG(MerchantGuildBankRepairButton)
		MerchantGuildBankRepairButtonIcon:SetTexCoord(0.595, 0.8075, 0.05, 0.52)

		MerchantRepairAllButton:SetPushedTexture("")
		S.CreateBG(MerchantRepairAllButton)
		MerchantRepairAllIcon:SetTexCoord(0.31375, 0.53, 0.06, 0.52)

		MerchantRepairItemButton:SetPushedTexture("")
		S.CreateBG(MerchantRepairItemButton)
		local ic = MerchantRepairItemButton:GetRegions()
		ic:SetTexture("Interface\\Icons\\INV_Hammer_20")
		ic:SetTexCoord(.08, .92, .08, .92)

		hooksecurefunc("MerchantFrame_UpdateCurrencies", function()
			for i = 1, MAX_MERCHANT_CURRENCIES do
				local bu = _G["MerchantToken"..i]
				if bu and not bu.reskinned then
					local ic = _G["MerchantToken"..i.."Icon"]
					local co = _G["MerchantToken"..i.."Count"]

					ic:SetTexCoord(.08, .92, .08, .92)
					ic:SetDrawLayer("OVERLAY")
					ic:Point("LEFT", co, "RIGHT", 2, 0)
					co:Point("TOPLEFT", bu, "TOPLEFT", -2, 0)

					S.CreateBG(ic)
					bu.reskinned = true
				end
			end
		end)

		-- Friends Frame

		FriendsFrameIcon:Hide()

		S.ReskinPortraitFrame(FriendsFrame, true)
		S.Reskin(FriendsFrameAddFriendButton)
		S.Reskin(FriendsFrameSendMessageButton)
		S.Reskin(FriendsFrameIgnorePlayerButton)
		S.Reskin(FriendsFrameUnsquelchButton)
		S.Reskin(FriendsFrameMutePlayerButton)
		S.ReskinDropDown(FriendsFrameStatusDropDown)

		for i = 1, FRIENDS_TO_DISPLAY do
			local bu = _G["FriendsFrameFriendsScrollFrameButton"..i]
			local ic = bu.gameIcon

			bu.background:Hide()
			bu.travelPassButton:SetAlpha(0)
			bu.travelPassButton:EnableMouse(false)

			bu:SetHighlightTexture(media.backdrop)
			bu:GetHighlightTexture():SetVertexColor(.24, .56, 1, .2)

			ic:Size(22, 22)
			ic:SetTexCoord(.15, .85, .15, .85)

			bu.bg = CreateFrame("Frame", nil, bu)
			bu.bg:SetAllPoints(ic)
			S.CreateBD(bu.bg, 0)
		end

		local function UpdateScroll()
			for i = 1, FRIENDS_TO_DISPLAY do
				local bu = _G["FriendsFrameFriendsScrollFrameButton"..i]

				if bu.gameIcon:IsShown() then
					bu.bg:Show()
					bu.gameIcon:Point("TOPRIGHT", bu, "TOPRIGHT", -2, -2)
				else
					bu.bg:Hide()
				end
			end
		end

		local bu1 = FriendsFrameFriendsScrollFrameButton1
		bu1.bg:Point("BOTTOMRIGHT", bu1.gameIcon, 0, -1)

		hooksecurefunc("FriendsFrame_UpdateFriends", UpdateScroll)
		hooksecurefunc(FriendsFrameFriendsScrollFrame, "update", UpdateScroll)

		FriendsFrameStatusDropDown:ClearAllPoints()
		FriendsFrameStatusDropDown:Point("TOPLEFT", FriendsFrame, "TOPLEFT", 10, -28)

		FriendsTabHeaderSoRButton:SetPushedTexture("")
		FriendsTabHeaderSoRButtonIcon:SetTexCoord(.08, .92, .08, .92)
		local SoRBg = CreateFrame("Frame", nil, FriendsTabHeaderSoRButton)
		SoRBg:Point("TOPLEFT", -1, 1)
		SoRBg:Point("BOTTOMRIGHT", 1, -1)
		S.CreateBD(SoRBg, 0)

		FriendsFrameBattlenetFrame:GetRegions():Hide()
		S.CreateBD(FriendsFrameBattlenetFrame, .25)

		FriendsFrameBattlenetFrame.Tag:SetParent(FriendsListFrame)
		FriendsFrameBattlenetFrame.Tag:Point("TOP", FriendsFrame, "TOP", 0, -8)

		hooksecurefunc("FriendsFrame_CheckBattlenetStatus", function()
			if BNFeaturesEnabled() then
				local frame = FriendsFrameBattlenetFrame

				frame.BroadcastButton:Hide()

				if BNConnected() then
					frame:Hide()
					FriendsFrameBroadcastInput:Show()
					FriendsFrameBroadcastInput_UpdateDisplay()
				end
			end
		end)

		hooksecurefunc("FriendsFrame_Update", function()
			if FriendsFrame.selectedTab == 1 and FriendsTabHeader.selectedTab == 1 and FriendsFrameBattlenetFrame.Tag:IsShown() then
				FriendsFrameTitleText:Hide()
			else
				FriendsFrameTitleText:Show()
			end
		end)

		local whoBg = CreateFrame("Frame", nil, WhoFrameEditBoxInset)
		whoBg:SetPoint("TOPLEFT")
		whoBg:Point("BOTTOMRIGHT", -1, 1)
		whoBg:SetFrameLevel(WhoFrameEditBoxInset:GetFrameLevel()-1)
		S.CreateBD(whoBg, .25)

		-- Battletag invite frame

		for i = 1, 9 do
			select(i, BattleTagInviteFrame.NoteFrame:GetRegions()):Hide()
		end

		S.CreateBD(BattleTagInviteFrame)
		S.CreateSD(BattleTagInviteFrame)
		S.CreateBD(BattleTagInviteFrame.NoteFrame, .25)

		local _, send, cancel = BattleTagInviteFrame:GetChildren()
		S.Reskin(send)
		S.Reskin(cancel)

		S.ReskinScroll(BattleTagInviteFrameScrollFrameScrollBar)

		-- Nav Bar

		local function navButtonFrameLevel(self)
			for i=1, #self.navList do
				local navButton = self.navList[i]
				local lastNav = self.navList[i-1]
				if navButton and lastNav then
					navButton:SetFrameLevel(lastNav:GetFrameLevel() - 2)
					navButton:ClearAllPoints()
					navButton:Point("LEFT", lastNav, "RIGHT", 1, 0)
				end
			end
		end

		hooksecurefunc("NavBar_AddButton", function(self, buttonData)
			local navButton = self.navList[#self.navList]


			if not navButton.skinned then
				S.Reskin(navButton)
				navButton:GetRegions():SetAlpha(0)
				select(2, navButton:GetRegions()):SetAlpha(0)
				select(3, navButton:GetRegions()):SetAlpha(0)

				navButton.skinned = true

				navButton:HookScript("OnClick", function()
					navButtonFrameLevel(self)
				end)
			end

			navButtonFrameLevel(self)
		end)

		-- Character frame

		S.ReskinPortraitFrame(CharacterFrame, true)

		local slots = {
			"Head", "Neck", "Shoulder", "Shirt", "Chest", "Waist", "Legs", "Feet", "Wrist",
			"Hands", "Finger0", "Finger1", "Trinket0", "Trinket1", "Back", "MainHand",
			"SecondaryHand", "Tabard",
		}

		for i = 1, #slots do
			local slot = _G["Character"..slots[i].."Slot"]
			local ic = _G["Character"..slots[i].."SlotIconTexture"]
			_G["Character"..slots[i].."SlotFrame"]:Hide()

			slot:SetNormalTexture("")
			slot:SetPushedTexture("")
			ic:SetTexCoord(.08, .92, .08, .92)

			slot.bg = S.CreateBG(slot)
		end

		select(10, CharacterMainHandSlot:GetRegions()):Hide()
		select(10, CharacterSecondaryHandSlot:GetRegions()):Hide()

		hooksecurefunc("PaperDollItemSlotButton_Update", function()
			for i = 1, #slots do
				local slot = _G["Character"..slots[i].."Slot"]
				local ic = _G["Character"..slots[i].."SlotIconTexture"]

				if i == 18 then i = 19 end

				if GetInventoryItemLink("player", i) then
					ic:SetAlpha(1)
					slot.bg:SetAlpha(1)
				else
					ic:SetAlpha(0)
					slot.bg:SetAlpha(0)
				end
			end
		end)

		for i = 1, #PAPERDOLL_SIDEBARS do
			local tab = _G["PaperDollSidebarTab"..i]

			if i == 1 then
				for i = 1, 4 do
					local region = select(i, tab:GetRegions())
					region:SetTexCoord(0.16, 0.86, 0.16, 0.86)
					region.SetTexCoord = S.dummy
				end
			end

			tab.Highlight:SetTexture(r, g, b, .2)
			tab.Highlight:Point("TOPLEFT", 3, -4)
			tab.Highlight:Point("BOTTOMRIGHT", -1, 0)
			tab.Hider:SetTexture(.3, .3, .3, .4)
			tab.TabBg:SetAlpha(0)

			select(2, tab:GetRegions()):ClearAllPoints()
			if i == 1 then
				select(2, tab:GetRegions()):Point("TOPLEFT", 3, -4)
				select(2, tab:GetRegions()):Point("BOTTOMRIGHT", -1, 0)
			else
				select(2, tab:GetRegions()):Point("TOPLEFT", 2, -4)
				select(2, tab:GetRegions()):Point("BOTTOMRIGHT", -1, -1)
			end

			tab.bg = CreateFrame("Frame", nil, tab)
			tab.bg:Point("TOPLEFT", 2, -3)
			tab.bg:Point("BOTTOMRIGHT", 0, -1)
			tab.bg:SetFrameLevel(0)
			S.CreateBD(tab.bg)

			tab.Hider:Point("TOPLEFT", tab.bg, 1, -1)
			tab.Hider:Point("BOTTOMRIGHT", tab.bg, -1, 1)
		end

		for i = 1, NUM_GEARSET_ICONS_SHOWN do
			local bu = _G["GearManagerDialogPopupButton"..i]
			local ic = _G["GearManagerDialogPopupButton"..i.."Icon"]

			bu:SetCheckedTexture(media.checked)
			select(2, bu:GetRegions()):Hide()
			ic:Point("TOPLEFT", 1, -1)
			ic:Point("BOTTOMRIGHT", -1, 1)
			ic:SetTexCoord(.08, .92, .08, .92)

			S.CreateBD(bu, .25)
		end

		local sets = false
		PaperDollSidebarTab3:HookScript("OnClick", function()
			if sets == false then
				for i = 1, 9 do
					local bu = _G["PaperDollEquipmentManagerPaneButton"..i]
					local bd = _G["PaperDollEquipmentManagerPaneButton"..i.."Stripe"]
					local ic = _G["PaperDollEquipmentManagerPaneButton"..i.."Icon"]
					_G["PaperDollEquipmentManagerPaneButton"..i.."BgTop"]:SetAlpha(0)
					_G["PaperDollEquipmentManagerPaneButton"..i.."BgMiddle"]:Hide()
					_G["PaperDollEquipmentManagerPaneButton"..i.."BgBottom"]:SetAlpha(0)

					bu.HighlightBar:SetTexture(r, g, b, .1)
					bu.HighlightBar:SetDrawLayer("BACKGROUND")
					bu.SelectedBar:SetTexture(r, g, b, .2)
					bu.SelectedBar:SetDrawLayer("BACKGROUND")

					bd:Hide()
					bd.Show = S.dummy
					ic:SetTexCoord(.08, .92, .08, .92)

					S.CreateBG(ic)
				end
				sets = true
			end
		end)

		hooksecurefunc("EquipmentFlyout_DisplayButton", function(button)
			if not button.styled then
				button:SetNormalTexture("")
				button:SetPushedTexture("")
				button.bg = S.CreateBG(button)

				button.icon:SetTexCoord(.08, .92, .08, .92)

				button.styled = true
			end

			if AuroraConfig.qualityColour then
				local location = button.location
				if not location then return end
				if location >= EQUIPMENTFLYOUT_FIRST_SPECIAL_LOCATION then return end

				local id = EquipmentManager_GetItemInfoByLocation(location)
				local _, _, quality = GetItemInfo(id)
				local r, g, b = GetItemQualityColor(quality)

				if r == 1 and g == 1 then r, g, b = 0, 0, 0 end

				button.bg:SetVertexColor(r, g, b)
			end
		end)

		-- Quest Frame

		S.ReskinPortraitFrame(QuestLogFrame, true)
		S.ReskinPortraitFrame(QuestLogDetailFrame, true)
		S.ReskinPortraitFrame(QuestFrame, true)

		S.CreateBD(QuestLogCount, .25)

		QuestFrameDetailPanel:DisableDrawLayer("BACKGROUND")
		QuestFrameProgressPanel:DisableDrawLayer("BACKGROUND")
		QuestFrameRewardPanel:DisableDrawLayer("BACKGROUND")
		QuestFrameGreetingPanel:DisableDrawLayer("BACKGROUND")
		EmptyQuestLogFrame:DisableDrawLayer("BACKGROUND")
		QuestFrameDetailPanel:DisableDrawLayer("BORDER")
		QuestFrameRewardPanel:DisableDrawLayer("BORDER")

		select(18, QuestLogFrame:GetRegions()):Hide()
		select(18, QuestLogDetailFrame:GetRegions()):Hide()

		QuestLogFramePageBg:Hide()
		QuestLogFrameBookBg:Hide()
		QuestLogDetailFramePageBg:Hide()
		QuestLogScrollFrameTop:Hide()
		QuestLogScrollFrameBottom:Hide()
		QuestLogScrollFrameMiddle:Hide()
		QuestLogDetailScrollFrameTop:Hide()
		QuestLogDetailScrollFrameBottom:Hide()
		QuestLogDetailScrollFrameMiddle:Hide()
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
		QuestDetailLeftBorder:Hide()
		QuestDetailBotLeftCorner:Hide()
		QuestDetailTopLeftCorner:Hide()

		QuestNPCModelShadowOverlay:Hide()
		QuestNPCModelBg:Hide()
		QuestNPCModel:DisableDrawLayer("OVERLAY")
		QuestNPCModelNameText:SetDrawLayer("ARTWORK")
		QuestNPCModelTextFrameBg:Hide()
		QuestNPCModelTextFrame:DisableDrawLayer("OVERLAY")

		for i = 1, 9 do
			select(i, QuestLogCount:GetRegions()):Hide()
		end

		QuestLogDetailTitleText:SetDrawLayer("OVERLAY")
		QuestInfoItemHighlight:GetRegions():Hide()
		QuestInfoSpellObjectiveFrameNameFrame:Hide()
		QuestFrameProgressPanelMaterialTopLeft:SetAlpha(0)
		QuestFrameProgressPanelMaterialTopRight:SetAlpha(0)
		QuestFrameProgressPanelMaterialBotLeft:SetAlpha(0)
		QuestFrameProgressPanelMaterialBotRight:SetAlpha(0)

		QuestLogFramePushQuestButton:ClearAllPoints()
		QuestLogFramePushQuestButton:Point("LEFT", QuestLogFrameAbandonButton, "RIGHT", 1, 0)
		QuestLogFramePushQuestButton:Width(100)
		QuestLogFrameTrackButton:ClearAllPoints()
		QuestLogFrameTrackButton:Point("LEFT", QuestLogFramePushQuestButton, "RIGHT", 1, 0)

		QuestLogFrameShowMapButton.texture:Hide()
		QuestLogFrameShowMapButtonHighlight:SetAlpha(0)
		QuestLogFrameShowMapButton:Size(QuestLogFrameShowMapButton.text:GetStringWidth() + 14, 22)
		QuestLogFrameShowMapButton.text:ClearAllPoints()
		QuestLogFrameShowMapButton.text:Point("CENTER", 1, 0)
		S.Reskin(QuestLogFrameShowMapButton)

		local line = QuestFrameGreetingPanel:CreateTexture()
		line:SetTexture(1, 1, 1, .2)
		line:Size(256, 1)
		line:SetPoint("CENTER", QuestGreetingFrameHorizontalBreak)

		QuestGreetingFrameHorizontalBreak:SetTexture("")

		QuestFrameGreetingPanel:HookScript("OnShow", function()
			line:SetShown(QuestGreetingFrameHorizontalBreak:IsShown())
		end)

		local npcbd = CreateFrame("Frame", nil, QuestNPCModel)
		npcbd:Point("TOPLEFT", 0, 1)
		npcbd:Point("RIGHT", 1, 0)
		npcbd:SetPoint("BOTTOM", QuestNPCModelTextScrollFrame)
		npcbd:SetFrameLevel(QuestNPCModel:GetFrameLevel()-1)
		S.CreateBD(npcbd)

		local npcLine = CreateFrame("Frame", nil, QuestNPCModel)
		npcLine:Point("BOTTOMLEFT", 0, -1)
		npcLine:Point("BOTTOMRIGHT", 0, -1)
		npcLine:Height(1)
		npcLine:SetFrameLevel(QuestNPCModel:GetFrameLevel()-1)
		S.CreateBD(npcLine, 0)

		QuestInfoSkillPointFrameIconTexture:Size(40, 40)
		QuestInfoSkillPointFrameIconTexture:SetTexCoord(.08, .92, .08, .92)

		local bg = CreateFrame("Frame", nil, QuestInfoSkillPointFrame)
		bg:Point("TOPLEFT", -3, 0)
		bg:Point("BOTTOMRIGHT", -3, 0)
		bg:Lower()
		S.CreateBD(bg, .25)

		QuestInfoSkillPointFrameNameFrame:Hide()
		QuestInfoSkillPointFrameName:SetParent(bg)
		QuestInfoSkillPointFrameIconTexture:SetParent(bg)
		QuestInfoSkillPointFrameSkillPointBg:SetParent(bg)
		QuestInfoSkillPointFrameSkillPointBgGlow:SetParent(bg)
		QuestInfoSkillPointFramePoints:SetParent(bg)

		local skillPointLine = QuestInfoSkillPointFrame:CreateTexture(nil, "BACKGROUND")
		skillPointLine:Size(1, 40)
		skillPointLine:Point("RIGHT", QuestInfoSkillPointFrameIconTexture, 1, 0)
		skillPointLine:SetTexture(media.backdrop)
		skillPointLine:SetVertexColor(0, 0, 0)

		QuestInfoRewardSpellIconTexture:Size(40, 40)
		QuestInfoRewardSpellIconTexture:SetTexCoord(.08, .92, .08, .92)
		QuestInfoRewardSpellIconTexture:SetDrawLayer("OVERLAY")

		local bg = CreateFrame("Frame", nil, QuestInfoRewardSpell)
		bg:Point("TOPLEFT", 9, -1)
		bg:Point("BOTTOMRIGHT", -10, 13)
		bg:Lower()
		S.CreateBD(bg, .25)

		QuestInfoRewardSpellNameFrame:Hide()
		QuestInfoRewardSpellSpellBorder:Hide()
		QuestInfoRewardSpellName:SetParent(bg)
		QuestInfoRewardSpellIconTexture:SetParent(bg)

		local spellLine = QuestInfoRewardSpell:CreateTexture(nil, "BACKGROUND")
		spellLine:Size(1, 40)
		spellLine:Point("RIGHT", QuestInfoRewardSpellIconTexture, 1, 0)
		spellLine:SetTexture(media.backdrop)
		spellLine:SetVertexColor(0, 0, 0)

		local function clearHighlight()
			for i = 1, MAX_NUM_ITEMS do
				_G["QuestInfoItem"..i]:SetBackdropColor(0, 0, 0, .25)
			end
		end

		local function setHighlight(self)
			clearHighlight()

			local _, point = self:GetPoint()
			point:SetBackdropColor(r, g, b, .2)
		end

		hooksecurefunc(QuestInfoItemHighlight, "SetPoint", setHighlight)
		QuestInfoItemHighlight:HookScript("OnShow", setHighlight)
		QuestInfoItemHighlight:HookScript("OnHide", clearHighlight)

		for i = 1, MAX_REQUIRED_ITEMS do
			local bu = _G["QuestProgressItem"..i]
			local ic = _G["QuestProgressItem"..i.."IconTexture"]
			local na = _G["QuestProgressItem"..i.."NameFrame"]
			local co = _G["QuestProgressItem"..i.."Count"]

			ic:Size(40, 40)
			ic:SetTexCoord(.08, .92, .08, .92)
			ic:SetDrawLayer("OVERLAY")

			S.CreateBD(bu, .25)

			na:Hide()
			co:SetDrawLayer("OVERLAY")

			local line = CreateFrame("Frame", nil, bu)
			line:Size(1, 40)
			line:Point("RIGHT", ic, 1, 0)
			S.CreateBD(line)
		end

		for i = 1, MAX_NUM_ITEMS do
			local bu = _G["QuestInfoItem"..i]
			local ic = _G["QuestInfoItem"..i.."IconTexture"]
			local na = _G["QuestInfoItem"..i.."NameFrame"]
			local co = _G["QuestInfoItem"..i.."Count"]

			ic:Point("TOPLEFT", 1, -1)
			ic:Size(39, 39)
			ic:SetTexCoord(.08, .92, .08, .92)
			ic:SetDrawLayer("OVERLAY")

			S.CreateBD(bu, .25)

			na:Hide()
			co:SetDrawLayer("OVERLAY")

			local line = CreateFrame("Frame", nil, bu)
			line:Size(1, 40)
			line:Point("RIGHT", ic, 1, 0)
			S.CreateBD(line)
		end

		local function updateQuest()
			local numEntries = GetNumQuestLogEntries()

			local buttons = QuestLogScrollFrame.buttons
			local numButtons = #buttons
			local scrollOffset = HybridScrollFrame_GetOffset(QuestLogScrollFrame)
			local questLogTitle, questIndex
			local isHeader, isCollapsed

			for i = 1, numButtons do
				questLogTitle = buttons[i]
				questIndex = i + scrollOffset

				if not questLogTitle.reskinned then
					questLogTitle.reskinned = true

					questLogTitle:SetNormalTexture("")
					questLogTitle.SetNormalTexture = S.dummy
					questLogTitle:SetPushedTexture("")
					questLogTitle:SetHighlightTexture("")
					questLogTitle.SetHighlightTexture = S.dummy

					questLogTitle.bg = CreateFrame("Frame", nil, questLogTitle)
					questLogTitle.bg:Size(13, 13)
					questLogTitle.bg:Point("LEFT", 4, 0)
					questLogTitle.bg:SetFrameLevel(questLogTitle:GetFrameLevel()-1)
					S.CreateBD(questLogTitle.bg, 0)

					questLogTitle.tex = questLogTitle:CreateTexture(nil, "BACKGROUND")
					questLogTitle.tex:SetAllPoints(questLogTitle.bg)
					questLogTitle.tex:SetTexture(media.backdrop)
					questLogTitle.tex:SetGradientAlpha(gradOr, startR, startG, startB, startAlpha, endR, endG, endB, endAlpha)

					questLogTitle.minus = questLogTitle:CreateTexture(nil, "OVERLAY")
					questLogTitle.minus:Size(7, 1)
					questLogTitle.minus:SetPoint("CENTER", questLogTitle.bg)
					questLogTitle.minus:SetTexture(media.backdrop)
					questLogTitle.minus:SetVertexColor(1, 1, 1)

					questLogTitle.plus = questLogTitle:CreateTexture(nil, "OVERLAY")
					questLogTitle.plus:Size(1, 7)
					questLogTitle.plus:SetPoint("CENTER", questLogTitle.bg)
					questLogTitle.plus:SetTexture(media.backdrop)
					questLogTitle.plus:SetVertexColor(1, 1, 1)
				end

				if questIndex <= numEntries then
					_, _, _, _, isHeader, isCollapsed = GetQuestLogTitle(questIndex)
					if isHeader then
						questLogTitle.bg:Show()
						questLogTitle.tex:Show()
						questLogTitle.minus:Show()
						if isCollapsed then
							questLogTitle.plus:Show()
						else
							questLogTitle.plus:Hide()
						end
					else
						questLogTitle.bg:Hide()
						questLogTitle.tex:Hide()
						questLogTitle.minus:Hide()
						questLogTitle.plus:Hide()
					end
				end
			end
		end

		hooksecurefunc("QuestLog_Update", updateQuest)
		QuestLogScrollFrame:HookScript("OnVerticalScroll", updateQuest)
		QuestLogScrollFrame:HookScript("OnMouseWheel", updateQuest)

		hooksecurefunc("QuestFrame_ShowQuestPortrait", function(parentFrame, _, _, _, x, y)
			QuestNPCModel:Point("TOPLEFT", parentFrame, "TOPRIGHT", x+6, y)
		end)

		hooksecurefunc(QuestProgressRequiredMoneyText, "SetTextColor", function(self, r, g, b)
			if r == 0 then
				self:SetTextColor(.8, .8, .8)
			elseif r == .2 then
				self:SetTextColor(1, 1, 1)
			end
		end)

		local questButtons = {"QuestLogFrameAbandonButton", "QuestLogFramePushQuestButton", "QuestLogFrameTrackButton", "QuestLogFrameCancelButton", "QuestFrameAcceptButton", "QuestFrameDeclineButton", "QuestFrameCompleteQuestButton", "QuestFrameCompleteButton", "QuestFrameGoodbyeButton", "QuestFrameGreetingGoodbyeButton", "QuestLogFrameCompleteButton"}
		for i = 1, #questButtons do
			S.Reskin(_G[questButtons[i]])
		end

		S.ReskinScroll(QuestLogScrollFrameScrollBar)
		S.ReskinScroll(QuestLogDetailScrollFrameScrollBar)
		S.ReskinScroll(QuestProgressScrollFrameScrollBar)
		S.ReskinScroll(QuestRewardScrollFrameScrollBar)
		S.ReskinScroll(QuestDetailScrollFrameScrollBar)
		S.ReskinScroll(QuestGreetingScrollFrameScrollBar)
		S.ReskinScroll(QuestNPCModelTextScrollFrameScrollBar)

		-- Gossip Frame

		GossipGreetingScrollFrameTop:Hide()
		GossipGreetingScrollFrameBottom:Hide()
		GossipGreetingScrollFrameMiddle:Hide()
		select(19, GossipFrame:GetRegions()):Hide()

		GossipGreetingText:SetTextColor(1, 1, 1)

		NPCFriendshipStatusBar:GetRegions():Hide()
		NPCFriendshipStatusBarNotch1:SetTexture(0, 0, 0)
		NPCFriendshipStatusBarNotch1:Size(1, 16)
		NPCFriendshipStatusBarNotch2:SetTexture(0, 0, 0)
		NPCFriendshipStatusBarNotch2:Size(1, 16)
		NPCFriendshipStatusBarNotch3:SetTexture(0, 0, 0)
		NPCFriendshipStatusBarNotch3:Size(1, 16)
		NPCFriendshipStatusBarNotch4:SetTexture(0, 0, 0)
		NPCFriendshipStatusBarNotch4:Size(1, 16)
		select(7, NPCFriendshipStatusBar:GetRegions()):Hide()

		NPCFriendshipStatusBar.icon:Point("TOPLEFT", -30, 7)
		S.CreateBDFrame(NPCFriendshipStatusBar, .25)

		S.ReskinPortraitFrame(GossipFrame, true)
		S.Reskin(GossipFrameGreetingGoodbyeButton)
		S.ReskinScroll(GossipGreetingScrollFrameScrollBar)

		-- StaticPopup

		for i = 1, 2 do
			local bu = _G["StaticPopup"..i.."ItemFrame"]
			_G["StaticPopup"..i.."ItemFrameNameFrame"]:Hide()
			_G["StaticPopup"..i.."ItemFrameIconTexture"]:SetTexCoord(.08, .92, .08, .92)

			bu:SetNormalTexture("")
			bu:SetPushedTexture("")
			S.CreateBG(bu)
		end

		-- PvP cap bar

		local function CaptureBar()
			if not NUM_EXTENDED_UI_FRAMES then return end
			for i = 1, NUM_EXTENDED_UI_FRAMES do
				local barname = "WorldStateCaptureBar"..i
				local bar = _G[barname]

				if bar and bar:IsVisible() then
					bar:ClearAllPoints()
					bar:Point("TOP", UIParent, "TOP", 0, -120)
					if not bar.skinned then
						local left = _G[barname.."LeftBar"]
						local right = _G[barname.."RightBar"]
						local middle = _G[barname.."MiddleBar"]

						left:SetTexture(media.backdrop)
						right:SetTexture(media.backdrop)
						middle:SetTexture(media.backdrop)
						left:SetDrawLayer("BORDER")
						middle:SetDrawLayer("ARTWORK")
						right:SetDrawLayer("BORDER")

						left:SetGradient("VERTICAL", .1, .4, .9, .2, .6, 1)
						right:SetGradient("VERTICAL", .7, .1, .1, .9, .2, .2)
						middle:SetGradient("VERTICAL", .8, .8, .8, 1, 1, 1)

						_G[barname.."RightLine"]:SetAlpha(0)
						_G[barname.."LeftLine"]:SetAlpha(0)
						select(4, bar:GetRegions()):Hide()
						_G[barname.."LeftIconHighlight"]:SetAlpha(0)
						_G[barname.."RightIconHighlight"]:SetAlpha(0)

						bar.bg = bar:CreateTexture(nil, "BACKGROUND")
						bar.bg:Point("TOPLEFT", left, -1, 1)
						bar.bg:Point("BOTTOMRIGHT", right, 1, -1)
						bar.bg:SetTexture(media.backdrop)
						bar.bg:SetVertexColor(0, 0, 0)

						bar.bgmiddle = CreateFrame("Frame", nil, bar)
						bar.bgmiddle:Point("TOPLEFT", middle, -1, 1)
						bar.bgmiddle:Point("BOTTOMRIGHT", middle, 1, -1)
						S.CreateBD(bar.bgmiddle, 0)

						bar.skinned = true
					end
				end
			end
		end

		hooksecurefunc("UIParent_ManageFramePositions", CaptureBar)

		-- Achievement popup

		local function fixBg(f)
			if f:GetObjectType() == "AnimationGroup" then
				f = f:GetParent()
			end
			f.bg:SetBackdropColor(0, 0, 0, AuroraConfig.alpha)
		end

		hooksecurefunc("AlertFrame_FixAnchors", function()
			for i = 1, MAX_ACHIEVEMENT_ALERTS do
				local frame = _G["AchievementAlertFrame"..i]

				if frame then
					frame:SetAlpha(1)
					frame.SetAlpha = S.dummy

					local ic = _G["AchievementAlertFrame"..i.."Icon"]
					local texture = _G["AchievementAlertFrame"..i.."IconTexture"]
					local guildName = _G["AchievementAlertFrame"..i.."GuildName"]

					ic:ClearAllPoints()
					ic:Point("LEFT", frame, "LEFT", -26, 0)

					if not frame.bg then
						frame.bg = CreateFrame("Frame", nil, frame)
						frame.bg:Point("TOPLEFT", texture, -10, 12)
						frame.bg:Point("BOTTOMRIGHT", texture, "BOTTOMRIGHT", 240, -12)
						frame.bg:SetFrameLevel(frame:GetFrameLevel()-1)
						S.CreateBD(frame.bg)

						frame:HookScript("OnEnter", fixBg)
						frame:HookScript("OnShow", fixBg)
						frame.animIn:HookScript("OnFinished", fixBg)
						S.CreateBD(frame.bg)

						S.CreateBG(texture)

						_G["AchievementAlertFrame"..i.."Background"]:Hide()
						_G["AchievementAlertFrame"..i.."IconOverlay"]:Hide()
						_G["AchievementAlertFrame"..i.."GuildBanner"]:SetTexture("")
						_G["AchievementAlertFrame"..i.."GuildBorder"]:SetTexture("")
						_G["AchievementAlertFrame"..i.."OldAchievement"]:SetTexture("")

						guildName:ClearAllPoints()
						guildName:Point("TOPLEFT", 50, -14)
						guildName:Point("TOPRIGHT", -50, -14)

						_G["AchievementAlertFrame"..i.."Unlocked"]:SetTextColor(1, 1, 1)
						_G["AchievementAlertFrame"..i.."Unlocked"]:SetShadowOffset(1, -1)
					end

					frame.glow:Hide()
					frame.shine:Hide()
					frame.glow.Show = S.dummy
					frame.shine.Show = S.dummy

					texture:SetTexCoord(.08, .92, .08, .92)

					if guildName:IsShown() then
						_G["AchievementAlertFrame"..i.."Shield"]:Point("TOPRIGHT", -10, -22)
					end
				end
			end
		end)

		-- Guild challenges

		local challenge = CreateFrame("Frame", nil, GuildChallengeAlertFrame)
		challenge:Point("TOPLEFT", 8, -12)
		challenge:Point("BOTTOMRIGHT", -8, 13)
		challenge:SetFrameLevel(GuildChallengeAlertFrame:GetFrameLevel()-1)
		S.CreateBD(challenge)
		S.CreateBG(GuildChallengeAlertFrameEmblemBackground)

		GuildChallengeAlertFrameGlow:SetTexture("")
		GuildChallengeAlertFrameShine:SetTexture("")
		GuildChallengeAlertFrameEmblemBorder:SetTexture("")

		-- Dungeon completion rewards

		local bg = CreateFrame("Frame", nil, DungeonCompletionAlertFrame1)
		bg:Point("TOPLEFT", 6, -14)
		bg:Point("BOTTOMRIGHT", -6, 6)
		bg:SetFrameLevel(DungeonCompletionAlertFrame1:GetFrameLevel()-1)
		S.CreateBD(bg)

		DungeonCompletionAlertFrame1DungeonTexture:SetDrawLayer("ARTWORK")
		DungeonCompletionAlertFrame1DungeonTexture:SetTexCoord(.02, .98, .02, .98)
		S.CreateBG(DungeonCompletionAlertFrame1DungeonTexture)

		DungeonCompletionAlertFrame1.dungeonArt1:SetAlpha(0)
		DungeonCompletionAlertFrame1.dungeonArt2:SetAlpha(0)
		DungeonCompletionAlertFrame1.dungeonArt3:SetAlpha(0)
		DungeonCompletionAlertFrame1.dungeonArt4:SetAlpha(0)
		DungeonCompletionAlertFrame1.raidArt:SetAlpha(0)

		DungeonCompletionAlertFrame1.dungeonTexture:Point("BOTTOMLEFT", DungeonCompletionAlertFrame1, "BOTTOMLEFT", 13, 13)
		DungeonCompletionAlertFrame1.dungeonTexture.SetPoint = S.dummy

		DungeonCompletionAlertFrame1.shine:Hide()
		DungeonCompletionAlertFrame1.shine.Show = S.dummy
		DungeonCompletionAlertFrame1.glow:Hide()
		DungeonCompletionAlertFrame1.glow.Show = S.dummy

		hooksecurefunc("DungeonCompletionAlertFrame_ShowAlert", function()
			local bu = DungeonCompletionAlertFrame1Reward1
			local index = 1
			while bu do
				if not bu.styled then
					_G["DungeonCompletionAlertFrame1Reward"..index.."Border"]:Hide()
					bu.texture:SetTexCoord(.08, .92, .08, .92)
					S.CreateBG(bu.texture)

					bu.styled = true
				end
				index = index + 1
				bu = _G["DungeonCompletionAlertFrame1Reward"..index]
			end
		end)

		-- Challenge popup

		hooksecurefunc("AlertFrame_SetChallengeModeAnchors", function()
			local frame = ChallengeModeAlertFrame1

			if frame then
				frame:SetAlpha(1)
				frame.SetAlpha = S.dummy

				if not frame.bg then
					frame.bg = CreateFrame("Frame", nil, frame)
					frame.bg:Point("TOPLEFT", ChallengeModeAlertFrame1DungeonTexture, -12, 12)
					frame.bg:Point("BOTTOMRIGHT", ChallengeModeAlertFrame1DungeonTexture, 243, -12)
					frame.bg:SetFrameLevel(frame:GetFrameLevel()-1)
					S.CreateBD(frame.bg)

					frame:HookScript("OnEnter", fixBg)
					frame:HookScript("OnShow", fixBg)
					frame.animIn:HookScript("OnFinished", fixBg)

					S.CreateBG(ChallengeModeAlertFrame1DungeonTexture)
				end

				frame:GetRegions():Hide()

				ChallengeModeAlertFrame1Shine:Hide()
				ChallengeModeAlertFrame1Shine.Show = S.dummy
				ChallengeModeAlertFrame1GlowFrame:Hide()
				ChallengeModeAlertFrame1GlowFrame.Show = S.dummy
				ChallengeModeAlertFrame1Border:Hide()
				ChallengeModeAlertFrame1Border.Show = S.dummy

				ChallengeModeAlertFrame1DungeonTexture:SetTexCoord(.08, .92, .08, .92)
			end
		end)

		-- Scenario alert

		hooksecurefunc("AlertFrame_SetScenarioAnchors", function()
			local frame = ScenarioAlertFrame1

			if frame then
				frame:SetAlpha(1)
				frame.SetAlpha = S.dummy

				if not frame.bg then
					frame.bg = CreateFrame("Frame", nil, frame)
					frame.bg:Point("TOPLEFT", ScenarioAlertFrame1DungeonTexture, -12, 12)
					frame.bg:Point("BOTTOMRIGHT", ScenarioAlertFrame1DungeonTexture, 244, -12)
					frame.bg:SetFrameLevel(frame:GetFrameLevel()-1)
					S.CreateBD(frame.bg)

					frame:HookScript("OnEnter", fixBg)
					frame:HookScript("OnShow", fixBg)
					frame.animIn:HookScript("OnFinished", fixBg)

					S.CreateBG(ScenarioAlertFrame1DungeonTexture)
					ScenarioAlertFrame1DungeonTexture:SetDrawLayer("OVERLAY")
				end

				frame:GetRegions():Hide()
				select(3, frame:GetRegions()):Hide()

				ScenarioAlertFrame1Shine:Hide()
				ScenarioAlertFrame1Shine.Show = S.dummy
				ScenarioAlertFrame1GlowFrame:Hide()
				ScenarioAlertFrame1GlowFrame.Show = S.dummy

				ScenarioAlertFrame1DungeonTexture:SetTexCoord(.08, .92, .08, .92)
			end
		end)
	
		hooksecurefunc("ScenarioAlertFrame_ShowAlert", function()
			local bu = ScenarioAlertFrame1Reward1
			local index = 1
			
			while bu do
				if not bu.styled then
					_G["ScenarioAlertFrame1Reward"..index.."Border"]:Hide()
					bu.texture:SetTexCoord(.08, .92, .08, .92)
					S.CreateBG(bu.texture)
					bu.styled = true
				end
				index = index + 1
				bu = _G["ScenarioAlertFrame1Reward"..index]
			end
		end)
		-- Loot won alert

		-- I still don't know why I can't parent bg to frame
		local function showHideBg(self)
			self.bg:SetShown(self:IsShown())
		end

		local function onUpdate(self)
			self.bg:SetAlpha(self:GetAlpha())
		end

		hooksecurefunc("LootWonAlertFrame_SetUp", function(frame)
			if not frame.bg then
				frame.bg = CreateFrame("Frame", nil, UIParent)
				frame.bg:Point("TOPLEFT", frame, 10, -10)
				frame.bg:Point("BOTTOMRIGHT", frame, -10, 10)
				frame.bg:SetFrameStrata("DIALOG")
				frame.bg:SetFrameLevel(frame:GetFrameLevel()-1)
				frame.bg:SetShown(frame:IsShown())
				S.CreateBD(frame.bg)

				frame:HookScript("OnShow", showHideBg)
				frame:HookScript("OnHide", showHideBg)
				frame:HookScript("OnUpdate", onUpdate)

				frame.Background:Hide()
				frame.IconBorder:Hide()
				frame.glow:SetTexture("")
				frame.shine:SetTexture("")

				frame.Icon:SetTexCoord(.08, .92, .08, .92)
				S.CreateBG(frame.Icon)
			end
		end)

		-- Money won alert

		hooksecurefunc("MoneyWonAlertFrame_SetUp", function(frame)
			if not frame.bg then
				frame.bg = CreateFrame("Frame", nil, UIParent)
				frame.bg:Point("TOPLEFT", frame, 10, -10)
				frame.bg:Point("BOTTOMRIGHT", frame, -10, 10)
				frame.bg:SetFrameStrata("DIALOG")
				frame.bg:SetFrameLevel(frame:GetFrameLevel()-1)
				frame.bg:SetShown(frame:IsShown())
				S.CreateBD(frame.bg)

				frame:HookScript("OnShow", showHideBg)
				frame:HookScript("OnHide", showHideBg)
				frame:HookScript("OnUpdate", onUpdate)

				frame.Background:Hide()
				frame.IconBorder:Hide()

				frame.Icon:SetTexCoord(.08, .92, .08, .92)
				S.CreateBG(frame.Icon)
			end
		end)

		-- Criteria alert

		hooksecurefunc("CriteriaAlertFrame_ShowAlert", function()
			for i = 1, MAX_ACHIEVEMENT_ALERTS do
				local frame = _G["CriteriaAlertFrame"..i]
				if frame and not frame.bg then
					local icon = _G["CriteriaAlertFrame"..i.."IconTexture"]

					frame.bg = CreateFrame("Frame", nil, UIParent)
					frame.bg:Point("TOPLEFT", icon, -6, 5)
					frame.bg:Point("BOTTOMRIGHT", icon, 236, -5)
					frame.bg:SetFrameStrata("DIALOG")
					frame.bg:SetFrameLevel(frame:GetFrameLevel()-1)
					frame.bg:SetShown(frame:IsShown())
					S.CreateBD(frame.bg)

					frame:SetScript("OnShow", showHideBg)
					frame:SetScript("OnHide", showHideBg)
					frame:HookScript("OnUpdate", onUpdate)

					_G["CriteriaAlertFrame"..i.."Background"]:Hide()
					_G["CriteriaAlertFrame"..i.."IconOverlay"]:Hide()
					frame.glow:Hide()
					frame.glow.Show = S.dummy
					frame.shine:Hide()
					frame.shine.Show = S.dummy

					_G["CriteriaAlertFrame"..i.."Unlocked"]:SetTextColor(.9, .9, .9)

					icon:SetTexCoord(.08, .92, .08, .92)
					S.CreateBG(icon)
				end
			end
		end)

		-- Help frame

		for i = 1, 15 do
			local bu = _G["HelpFrameKnowledgebaseScrollFrameButton"..i]
			bu:DisableDrawLayer("ARTWORK")
			S.CreateBD(bu, 0)

			S.CreateGradient(bu)
		end

		local function colourTab(f)
			f.text:SetTextColor(1, 1, 1)
			f:SetBackdropBorderColor(r, g, b)
		end

		local function clearTab(f)
			f.text:SetTextColor(1, .82, 0)
			f:SetBackdropBorderColor(0, 0, 0)
		end

		local function styleTab(bu)
			bu.selected:SetTexture(r, g, b, .2)
			bu.selected:SetDrawLayer("BACKGROUND")
			bu.text:SetFont(DB.Font, 14)
			S.Reskin(bu, true)
			bu:SetScript("OnEnter", colourTab)
			bu:SetScript("OnLeave", clearTab)
		end

		for i = 1, 6 do
			styleTab(_G["HelpFrameButton"..i])
		end
		styleTab(HelpFrameButton16)

		HelpFrameAccountSecurityOpenTicket.text:SetFont(DB.Font, 14)
		HelpFrameOpenTicketHelpOpenTicket.text:SetFont(DB.Font, 14)
		HelpFrameOpenTicketHelpTopIssues.text:SetFont(DB.Font, 14)
		HelpFrameOpenTicketHelpItemRestoration.text:SetFont(DB.Font, 14)

		HelpFrameCharacterStuckHearthstone:Size(56, 56)
		S.CreateBG(HelpFrameCharacterStuckHearthstone)
		HelpFrameCharacterStuckHearthstoneIconTexture:SetTexCoord(.08, .92, .08, .92)

		-- Option panels

		local options = false
		VideoOptionsFrame:HookScript("OnShow", function()
			if options == true then return end
			options = true

			local line = VideoOptionsFrame:CreateTexture(nil, "ARTWORK")
			line:Size(1, 512)
			line:Point("LEFT", 205, 30)
			line:SetTexture(1, 1, 1, .2)

			S.CreateBD(AudioOptionsSoundPanelPlayback, .25)
			S.CreateBD(AudioOptionsSoundPanelHardware, .25)
			S.CreateBD(AudioOptionsSoundPanelVolume, .25)
			S.CreateBD(AudioOptionsVoicePanelTalking, .25)
			S.CreateBD(AudioOptionsVoicePanelBinding, .25)
			S.CreateBD(AudioOptionsVoicePanelListening, .25)

			AudioOptionsSoundPanelPlaybackTitle:Point("BOTTOMLEFT", AudioOptionsSoundPanelPlayback, "TOPLEFT", 5, 2)
			AudioOptionsSoundPanelHardwareTitle:Point("BOTTOMLEFT", AudioOptionsSoundPanelHardware, "TOPLEFT", 5, 2)
			AudioOptionsSoundPanelVolumeTitle:Point("BOTTOMLEFT", AudioOptionsSoundPanelVolume, "TOPLEFT", 5, 2)
			AudioOptionsVoicePanelTalkingTitle:Point("BOTTOMLEFT", AudioOptionsVoicePanelTalking, "TOPLEFT", 5, 2)
			AudioOptionsVoicePanelListeningTitle:Point("BOTTOMLEFT", AudioOptionsVoicePanelListening, "TOPLEFT", 5, 2)

			local dropdowns = {"Graphics_DisplayModeDropDown", "Graphics_ResolutionDropDown", "Graphics_RefreshDropDown", "Graphics_PrimaryMonitorDropDown", "Graphics_MultiSampleDropDown", "Graphics_VerticalSyncDropDown", "Graphics_TextureResolutionDropDown", "Graphics_FilteringDropDown", "Graphics_ProjectedTexturesDropDown", "Graphics_ShadowsDropDown", "Graphics_LiquidDetailDropDown", "Graphics_SunshaftsDropDown", "Graphics_ParticleDensityDropDown", "Graphics_ViewDistanceDropDown", "Graphics_EnvironmentalDetailDropDown", "Graphics_GroundClutterDropDown", "Graphics_SSAODropDown", "Advanced_BufferingDropDown", "Advanced_LagDropDown", "Advanced_HardwareCursorDropDown", "InterfaceOptionsLanguagesPanelLocaleDropDown", "AudioOptionsSoundPanelHardwareDropDown", "AudioOptionsSoundPanelSoundChannelsDropDown", "AudioOptionsVoicePanelInputDeviceDropDown", "AudioOptionsVoicePanelChatModeDropDown", "AudioOptionsVoicePanelOutputDeviceDropDown"}
			for i = 1, #dropdowns do
				S.ReskinDropDown(_G[dropdowns[i]])
			end

			Graphics_RightQuality:GetRegions():Hide()
			Graphics_RightQuality:DisableDrawLayer("BORDER")

			local sliders = {"Graphics_Quality", "Advanced_UIScaleSlider", "Advanced_MaxFPSSlider", "Advanced_MaxFPSBKSlider", "Advanced_GammaSlider", "AudioOptionsSoundPanelSoundQuality", "AudioOptionsSoundPanelMasterVolume", "AudioOptionsSoundPanelSoundVolume", "AudioOptionsSoundPanelMusicVolume", "AudioOptionsSoundPanelAmbienceVolume", "AudioOptionsVoicePanelMicrophoneVolume", "AudioOptionsVoicePanelSpeakerVolume", "AudioOptionsVoicePanelSoundFade", "AudioOptionsVoicePanelMusicFade", "AudioOptionsVoicePanelAmbienceFade"}
			for i = 1, #sliders do
				S.ReskinSlider(_G[sliders[i]])
			end

			Graphics_Quality.SetBackdrop = S.dummy

			local checkboxes = {"Advanced_UseUIScale", "Advanced_MaxFPSCheckBox", "Advanced_MaxFPSBKCheckBox", "Advanced_DesktopGamma", "NetworkOptionsPanelOptimizeSpeed", "NetworkOptionsPanelUseIPv6", "AudioOptionsSoundPanelEnableSound", "AudioOptionsSoundPanelSoundEffects", "AudioOptionsSoundPanelErrorSpeech", "AudioOptionsSoundPanelEmoteSounds", "AudioOptionsSoundPanelPetSounds", "AudioOptionsSoundPanelMusic", "AudioOptionsSoundPanelLoopMusic", "AudioOptionsSoundPanelPetBattleMusic", "AudioOptionsSoundPanelAmbientSounds", "AudioOptionsSoundPanelSoundInBG", "AudioOptionsSoundPanelReverb", "AudioOptionsSoundPanelHRTF", "AudioOptionsSoundPanelEnableDSPs", "AudioOptionsSoundPanelUseHardware", "AudioOptionsVoicePanelEnableVoice", "AudioOptionsVoicePanelEnableMicrophone", "AudioOptionsVoicePanelPushToTalkSound"}
			for i = 1, #checkboxes do
				S.ReskinCheck(_G[checkboxes[i]])
			end

			S.Reskin(RecordLoopbackSoundButton)
			S.Reskin(PlayLoopbackSoundButton)
			S.Reskin(AudioOptionsVoicePanelChatMode1KeyBindingButton)
		end)

		local interface = false
		InterfaceOptionsFrame:HookScript("OnShow", function()
			if interface == true then return end
			interface = true

			local line = InterfaceOptionsFrame:CreateTexture(nil, "ARTWORK")
			line:Size(1, 546)
			line:Point("LEFT", 205, 10)
			line:SetTexture(1, 1, 1, .2)

			local checkboxes = {"InterfaceOptionsControlsPanelStickyTargeting", "InterfaceOptionsControlsPanelAutoDismount", "InterfaceOptionsControlsPanelAutoClearAFK", "InterfaceOptionsControlsPanelBlockTrades", "InterfaceOptionsControlsPanelBlockGuildInvites", "InterfaceOptionsControlsPanelLootAtMouse", "InterfaceOptionsControlsPanelAutoLootCorpse", "InterfaceOptionsControlsPanelInteractOnLeftClick", "InterfaceOptionsCombatPanelAttackOnAssist", "InterfaceOptionsCombatPanelStopAutoAttack", "InterfaceOptionsNamesPanelUnitNameplatesNameplateClassColors", "InterfaceOptionsCombatPanelTargetOfTarget", "InterfaceOptionsCombatPanelShowSpellAlerts", "InterfaceOptionsCombatPanelReducedLagTolerance", "InterfaceOptionsCombatPanelActionButtonUseKeyDown", "InterfaceOptionsCombatPanelEnemyCastBarsOnPortrait", "InterfaceOptionsCombatPanelEnemyCastBarsOnNameplates", "InterfaceOptionsCombatPanelAutoSelfCast", "InterfaceOptionsCombatPanelLossOfControl", "InterfaceOptionsDisplayPanelShowCloak", "InterfaceOptionsDisplayPanelShowHelm", "InterfaceOptionsDisplayPanelShowAggroPercentage", "InterfaceOptionsDisplayPanelPlayAggroSounds", "InterfaceOptionsDisplayPanelShowSpellPointsAvg", "InterfaceOptionsDisplayPanelShowFreeBagSpace", "InterfaceOptionsDisplayPanelCinematicSubtitles", "InterfaceOptionsDisplayPanelRotateMinimap", "InterfaceOptionsDisplayPanelShowAccountAchievments", "InterfaceOptionsObjectivesPanelAutoQuestTracking", "InterfaceOptionsObjectivesPanelMapQuestDifficulty", "InterfaceOptionsObjectivesPanelWatchFrameWidth", "InterfaceOptionsSocialPanelProfanityFilter", "InterfaceOptionsSocialPanelSpamFilter", "InterfaceOptionsSocialPanelChatBubbles", "InterfaceOptionsSocialPanelPartyChat", "InterfaceOptionsSocialPanelChatHoverDelay", "InterfaceOptionsSocialPanelGuildMemberAlert", "InterfaceOptionsSocialPanelChatMouseScroll", "InterfaceOptionsSocialPanelWholeChatWindowClickable", "InterfaceOptionsActionBarsPanelBottomLeft", "InterfaceOptionsActionBarsPanelBottomRight", "InterfaceOptionsActionBarsPanelRight", "InterfaceOptionsActionBarsPanelRightTwo", "InterfaceOptionsActionBarsPanelLockActionBars", "InterfaceOptionsActionBarsPanelAlwaysShowActionBars", "InterfaceOptionsActionBarsPanelSecureAbilityToggle", "InterfaceOptionsNamesPanelMyName", "InterfaceOptionsNamesPanelFriendlyPlayerNames", "InterfaceOptionsNamesPanelFriendlyPets", "InterfaceOptionsNamesPanelFriendlyGuardians", "InterfaceOptionsNamesPanelFriendlyTotems", "InterfaceOptionsNamesPanelUnitNameplatesFriends", "InterfaceOptionsNamesPanelUnitNameplatesFriendlyPets", "InterfaceOptionsNamesPanelUnitNameplatesFriendlyGuardians", "InterfaceOptionsNamesPanelUnitNameplatesFriendlyTotems", "InterfaceOptionsNamesPanelGuilds", "InterfaceOptionsNamesPanelGuildTitles", "InterfaceOptionsNamesPanelTitles", "InterfaceOptionsNamesPanelNonCombatCreature", "InterfaceOptionsNamesPanelEnemyPlayerNames", "InterfaceOptionsNamesPanelEnemyPets", "InterfaceOptionsNamesPanelEnemyGuardians", "InterfaceOptionsNamesPanelEnemyTotems", "InterfaceOptionsNamesPanelUnitNameplatesEnemies", "InterfaceOptionsNamesPanelUnitNameplatesEnemyPets", "InterfaceOptionsNamesPanelUnitNameplatesEnemyGuardians", "InterfaceOptionsNamesPanelUnitNameplatesEnemyTotems", "InterfaceOptionsCombatTextPanelTargetDamage", "InterfaceOptionsCombatTextPanelPeriodicDamage", "InterfaceOptionsCombatTextPanelPetDamage", "InterfaceOptionsCombatTextPanelHealing", "InterfaceOptionsCombatTextPanelTargetEffects", "InterfaceOptionsCombatTextPanelOtherTargetEffects", "InterfaceOptionsCombatTextPanelEnableFCT", "InterfaceOptionsCombatTextPanelDodgeParryMiss", "InterfaceOptionsCombatTextPanelDamageReduction", "InterfaceOptionsCombatTextPanelRepChanges", "InterfaceOptionsCombatTextPanelReactiveAbilities", "InterfaceOptionsCombatTextPanelFriendlyHealerNames", "InterfaceOptionsCombatTextPanelCombatState", "InterfaceOptionsCombatTextPanelComboPoints", "InterfaceOptionsCombatTextPanelLowManaHealth", "InterfaceOptionsCombatTextPanelEnergyGains", "InterfaceOptionsCombatTextPanelPeriodicEnergyGains", "InterfaceOptionsCombatTextPanelHonorGains", "InterfaceOptionsCombatTextPanelAuras", "InterfaceOptionsStatusTextPanelPlayer", "InterfaceOptionsStatusTextPanelPet", "InterfaceOptionsStatusTextPanelParty", "InterfaceOptionsStatusTextPanelTarget", "InterfaceOptionsStatusTextPanelAlternateResource", "InterfaceOptionsStatusTextPanelXP", "InterfaceOptionsBattlenetPanelOnlineFriends", "InterfaceOptionsBattlenetPanelOfflineFriends", "InterfaceOptionsBattlenetPanelBroadcasts", "InterfaceOptionsBattlenetPanelFriendRequests", "InterfaceOptionsBattlenetPanelConversations", "InterfaceOptionsBattlenetPanelShowToastWindow", "InterfaceOptionsCameraPanelFollowTerrain", "InterfaceOptionsCameraPanelHeadBob", "InterfaceOptionsCameraPanelWaterCollision", "InterfaceOptionsCameraPanelSmartPivot", "InterfaceOptionsMousePanelInvertMouse", "InterfaceOptionsMousePanelClickToMove", "InterfaceOptionsMousePanelWoWMouse", "InterfaceOptionsHelpPanelShowTutorials", "InterfaceOptionsHelpPanelEnhancedTooltips", "InterfaceOptionsHelpPanelShowLuaErrors", "InterfaceOptionsHelpPanelColorblindMode", "InterfaceOptionsHelpPanelMovePad", "InterfaceOptionsControlsPanelAutoOpenLootHistory", "InterfaceOptionsUnitFramePanelPartyPets", "InterfaceOptionsUnitFramePanelArenaEnemyFrames", "InterfaceOptionsUnitFramePanelArenaEnemyCastBar", "InterfaceOptionsUnitFramePanelArenaEnemyPets", "InterfaceOptionsUnitFramePanelFullSizeFocusFrame", "InterfaceOptionsBuffsPanelDispellableDebuffs", "InterfaceOptionsBuffsPanelCastableBuffs", "InterfaceOptionsBuffsPanelConsolidateBuffs", "InterfaceOptionsBuffsPanelShowAllEnemyDebuffs"}
			for i = 1, #checkboxes do
				S.ReskinCheck(_G[checkboxes[i]])
			end

			local dropdowns = {"InterfaceOptionsControlsPanelAutoLootKeyDropDown", "InterfaceOptionsCombatPanelFocusCastKeyDropDown", "InterfaceOptionsCombatPanelSelfCastKeyDropDown", "InterfaceOptionsCombatPanelLossOfControlFullDropDown", "InterfaceOptionsCombatPanelLossOfControlSilenceDropDown", "InterfaceOptionsCombatPanelLossOfControlInterruptDropDown", "InterfaceOptionsCombatPanelLossOfControlDisarmDropDown", "InterfaceOptionsCombatPanelLossOfControlRootDropDown", "InterfaceOptionsSocialPanelChatStyle", "InterfaceOptionsSocialPanelTimestamps", "InterfaceOptionsSocialPanelWhisperMode", "InterfaceOptionsSocialPanelBnWhisperMode", "InterfaceOptionsSocialPanelConversationMode", "InterfaceOptionsActionBarsPanelPickupActionKeyDropDown", "InterfaceOptionsNamesPanelNPCNamesDropDown", "InterfaceOptionsNamesPanelUnitNameplatesMotionDropDown", "InterfaceOptionsCombatTextPanelFCTDropDown", "InterfaceOptionsStatusTextPanelDisplayDropDown", "InterfaceOptionsCameraPanelStyleDropDown", "InterfaceOptionsMousePanelClickMoveStyleDropDown"}
			for i = 1, #dropdowns do
				S.ReskinDropDown(_G[dropdowns[i]])
			end

			local sliders = {"InterfaceOptionsCombatPanelSpellAlertOpacitySlider", "InterfaceOptionsCombatPanelMaxSpellStartRecoveryOffset", "InterfaceOptionsBattlenetPanelToastDurationSlider", "InterfaceOptionsCameraPanelMaxDistanceSlider", "InterfaceOptionsCameraPanelFollowSpeedSlider", "InterfaceOptionsMousePanelMouseSensitivitySlider", "InterfaceOptionsMousePanelMouseLookSpeedSlider"}
			for i = 1, #sliders do
				S.ReskinSlider(_G[sliders[i]])
			end

			S.Reskin(InterfaceOptionsHelpPanelResetTutorials)

			if IsAddOnLoaded("Blizzard_CompactRaidFrames") then
				CompactUnitFrameProfilesGeneralOptionsFrameAutoActivateBG:Hide()

				local boxes = {CompactUnitFrameProfilesRaidStylePartyFrames, CompactUnitFrameProfilesGeneralOptionsFrameKeepGroupsTogether, CompactUnitFrameProfilesGeneralOptionsFrameDisplayIncomingHeals, CompactUnitFrameProfilesGeneralOptionsFrameDisplayPowerBar, CompactUnitFrameProfilesGeneralOptionsFrameDisplayAggroHighlight, CompactUnitFrameProfilesGeneralOptionsFrameUseClassColors, CompactUnitFrameProfilesGeneralOptionsFrameDisplayPets, CompactUnitFrameProfilesGeneralOptionsFrameDisplayMainTankAndAssist, CompactUnitFrameProfilesGeneralOptionsFrameDisplayBorder, CompactUnitFrameProfilesGeneralOptionsFrameShowDebuffs, CompactUnitFrameProfilesGeneralOptionsFrameDisplayOnlyDispellableDebuffs, CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate2Players, CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate3Players, CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate5Players, CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate10Players, CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate15Players, CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate25Players, CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate40Players, CompactUnitFrameProfilesGeneralOptionsFrameAutoActivateSpec1, CompactUnitFrameProfilesGeneralOptionsFrameAutoActivateSpec2, CompactUnitFrameProfilesGeneralOptionsFrameAutoActivatePvP, CompactUnitFrameProfilesGeneralOptionsFrameAutoActivatePvE}

				for _, box in next, boxes do
					S.ReskinCheck(box)
				end

				S.Reskin(CompactUnitFrameProfilesSaveButton)
				S.Reskin(CompactUnitFrameProfilesDeleteButton)
				S.Reskin(CompactUnitFrameProfilesGeneralOptionsFrameResetPositionButton)
				S.ReskinDropDown(CompactUnitFrameProfilesProfileSelector)
				S.ReskinDropDown(CompactUnitFrameProfilesGeneralOptionsFrameSortByDropdown)
				S.ReskinDropDown(CompactUnitFrameProfilesGeneralOptionsFrameHealthTextDropdown)
				S.ReskinSlider(CompactUnitFrameProfilesGeneralOptionsFrameHeightSlider)
				S.ReskinSlider(CompactUnitFrameProfilesGeneralOptionsFrameWidthSlider)
			end
		end)

		hooksecurefunc("InterfaceOptions_AddCategory", function()
			local num = #INTERFACEOPTIONS_ADDONCATEGORIES
			for i = 1, num do
				local bu = _G["InterfaceOptionsFrameAddOnsButton"..i.."Toggle"]
				if bu and not bu.reskinned then
					S.ReskinExpandOrCollapse(bu)
					bu:SetPushedTexture("")
					bu.SetPushedTexture = S.dummy
					bu.reskinned = true
				end
			end
		end)

		hooksecurefunc("OptionsListButtonToggle_OnClick", function(self)
			if self:GetParent().element.collapsed then
				self.plus:Show()
			else
				self.plus:Hide()
			end
		end)

		-- SideDressUp

		SideDressUpModel:HookScript("OnShow", function(self)
			self:ClearAllPoints()
			self:Point("LEFT", self:GetParent():GetParent(), "RIGHT", 1, 0)
		end)

		SideDressUpModel.bg = CreateFrame("Frame", nil, SideDressUpModel)
		SideDressUpModel.bg:Point("TOPLEFT", 0, 1)
		SideDressUpModel.bg:Point("BOTTOMRIGHT", 1, -1)
		SideDressUpModel.bg:SetFrameLevel(SideDressUpModel:GetFrameLevel()-1)
		S.CreateBD(SideDressUpModel.bg)

		-- Trade Frame

		TradePlayerEnchantInset:DisableDrawLayer("BORDER")
		TradePlayerItemsInset:DisableDrawLayer("BORDER")
		TradeRecipientEnchantInset:DisableDrawLayer("BORDER")
		TradeRecipientItemsInset:DisableDrawLayer("BORDER")
		TradePlayerInputMoneyInset:DisableDrawLayer("BORDER")
		TradeRecipientMoneyInset:DisableDrawLayer("BORDER")
		TradeRecipientBG:Hide()
		TradePlayerEnchantInsetBg:Hide()
		TradePlayerItemsInsetBg:Hide()
		TradePlayerInputMoneyInsetBg:Hide()
		TradeRecipientEnchantInsetBg:Hide()
		TradeRecipientItemsInsetBg:Hide()
		TradeRecipientMoneyBg:Hide()
		TradeRecipientPortraitFrame:Hide()
		TradeRecipientBotLeftCorner:Hide()
		TradeRecipientLeftBorder:Hide()
		select(4, TradePlayerItem7:GetRegions()):Hide()
		select(4, TradeRecipientItem7:GetRegions()):Hide()
		TradeFramePlayerPortrait:Hide()
		TradeFrameRecipientPortrait:Hide()

		S.ReskinPortraitFrame(TradeFrame, true)
		S.Reskin(TradeFrameTradeButton)
		S.Reskin(TradeFrameCancelButton)
		S.ReskinInput(TradePlayerInputMoneyFrameGold)
		S.ReskinInput(TradePlayerInputMoneyFrameSilver)
		S.ReskinInput(TradePlayerInputMoneyFrameCopper)

		TradePlayerInputMoneyFrameSilver:Point("LEFT", TradePlayerInputMoneyFrameGold, "RIGHT", 1, 0)
		TradePlayerInputMoneyFrameCopper:Point("LEFT", TradePlayerInputMoneyFrameSilver, "RIGHT", 1, 0)

		for i = 1, MAX_TRADE_ITEMS do
			local bu1 = _G["TradePlayerItem"..i.."ItemButton"]
			local bu2 = _G["TradeRecipientItem"..i.."ItemButton"]

			_G["TradePlayerItem"..i.."SlotTexture"]:Hide()
			_G["TradePlayerItem"..i.."NameFrame"]:Hide()
			_G["TradeRecipientItem"..i.."SlotTexture"]:Hide()
			_G["TradeRecipientItem"..i.."NameFrame"]:Hide()

			bu1:SetNormalTexture("")
			bu1:SetPushedTexture("")
			bu1.icon:SetTexCoord(.08, .92, .08, .92)
			bu2:SetNormalTexture("")
			bu2:SetPushedTexture("")
			bu2.icon:SetTexCoord(.08, .92, .08, .92)

			local bg1 = CreateFrame("Frame", nil, bu1)
			bg1:Point("TOPLEFT", -1, 1)
			bg1:Point("BOTTOMRIGHT", 1, -1)
			bg1:SetFrameLevel(bu1:GetFrameLevel()-1)
			S.CreateBD(bg1, .25)

			local bg2 = CreateFrame("Frame", nil, bu2)
			bg2:Point("TOPLEFT", -1, 1)
			bg2:Point("BOTTOMRIGHT", 1, -1)
			bg2:SetFrameLevel(bu2:GetFrameLevel()-1)
			S.CreateBD(bg2, .25)
		end

		-- Tutorial Frame

		S.CreateBD(TutorialFrame)
		S.CreateSD(TutorialFrame)

		TutorialFrameBackground:Hide()
		TutorialFrameBackground.Show = S.dummy
		TutorialFrame:DisableDrawLayer("BORDER")

		S.Reskin(TutorialFrameOkayButton, true)
		S.ReskinClose(TutorialFrameCloseButton)
		S.ReskinArrow(TutorialFramePrevButton, "left")
		S.ReskinArrow(TutorialFrameNextButton, "right")

		TutorialFrameOkayButton:ClearAllPoints()
		TutorialFrameOkayButton:Point("BOTTOMLEFT", TutorialFrameNextButton, "BOTTOMRIGHT", 10, 0)

		-- because gradient alpha and OnUpdate doesn't work for some reason...

		select(14, TutorialFrameOkayButton:GetRegions()):Hide()
		select(15, TutorialFramePrevButton:GetRegions()):Hide()
		select(15, TutorialFrameNextButton:GetRegions()):Hide()
		select(14, TutorialFrameCloseButton:GetRegions()):Hide()
		TutorialFramePrevButton:SetScript("OnEnter", nil)
		TutorialFrameNextButton:SetScript("OnEnter", nil)
		TutorialFrameOkayButton:SetBackdropColor(0, 0, 0, .25)
		TutorialFramePrevButton:SetBackdropColor(0, 0, 0, .25)
		TutorialFrameNextButton:SetBackdropColor(0, 0, 0, .25)

		-- Loot history

		for i = 1, 9 do
			select(i, LootHistoryFrame:GetRegions()):Hide()
		end
		LootHistoryFrameScrollFrame:GetRegions():Hide()

		LootHistoryFrame.ResizeButton:Point("TOP", LootHistoryFrame, "BOTTOM", 0, -1)
		LootHistoryFrame.ResizeButton:SetFrameStrata("LOW")

		S.ReskinArrow(LootHistoryFrame.ResizeButton, "down")
		LootHistoryFrame.ResizeButton:Size(32, 12)

		S.CreateBD(LootHistoryFrame)
		S.CreateSD(LootHistoryFrame)

		S.ReskinClose(LootHistoryFrame.CloseButton)
		S.ReskinScroll(LootHistoryFrameScrollFrameScrollBar)

		hooksecurefunc("LootHistoryFrame_UpdateItemFrame", function(self, frame)
			local rollID, _, _, isDone, winnerIdx = C_LootHistory.GetItem(frame.itemIdx)
			local expanded = self.expandedRolls[rollID]

			if not frame.styled then
				frame.Divider:Hide()
				frame.NameBorderLeft:Hide()
				frame.NameBorderRight:Hide()
				frame.NameBorderMid:Hide()
				frame.IconBorder:Hide()

				frame.WinnerRoll:SetTextColor(.9, .9, .9)

				frame.Icon:SetTexCoord(.08, .92, .08, .92)
				frame.Icon:SetDrawLayer("ARTWORK")
				frame.bg = S.CreateBG(frame.Icon)
				frame.bg:SetVertexColor(frame.IconBorder:GetVertexColor())

				S.ReskinExpandOrCollapse(frame.ToggleButton)
				frame.ToggleButton:GetNormalTexture():SetAlpha(0)
				frame.ToggleButton:GetPushedTexture():SetAlpha(0)
				frame.ToggleButton:GetDisabledTexture():SetAlpha(0)

				frame.styled = true
			end

			if isDone and not expanded and winnerIdx then
				local name, class = C_LootHistory.GetPlayerInfo(frame.itemIdx, winnerIdx)
				if name then
					local colour = classcolours[class]
					frame.WinnerName:SetVertexColor(colour.r, colour.g, colour.b)
				end
			end

			frame.bg:SetVertexColor(frame.IconBorder:GetVertexColor())
			frame.ToggleButton.plus:SetShown(not expanded)
		end)

		hooksecurefunc("LootHistoryFrame_UpdatePlayerFrame", function(_, playerFrame)
			if not playerFrame.styled then
				playerFrame.RollText:SetTextColor(.9, .9, .9)
				playerFrame.WinMark:SetDesaturated(true)

				playerFrame.styled = true
			end

			if playerFrame.playerIdx then
				local name, class, _, _, isWinner = C_LootHistory.GetPlayerInfo(playerFrame.itemIdx, playerFrame.playerIdx)

				if name then
					local colour = classcolours[class]
					playerFrame.PlayerName:SetTextColor(colour.r, colour.g, colour.b)

					if isWinner then
						playerFrame.WinMark:SetVertexColor(colour.r, colour.g, colour.b)
					end
				end
			end
		end)

		LootHistoryDropDown.initialize = function(self)
			local info = UIDropDownMenu_CreateInfo();
			info.isTitle = 1;
			info.text = MASTER_LOOTER;
			info.fontObject = GameFontNormalLeft;
			info.notCheckable = 1;
			UIDropDownMenu_AddButton(info);

			info = UIDropDownMenu_CreateInfo();
			info.notCheckable = 1;
			local name, class = C_LootHistory.GetPlayerInfo(self.itemIdx, self.playerIdx);
			local classColor = classcolours[class];
			local colorCode = string.format("|cFF%02x%02x%02x",  classColor.r*255,  classColor.g*255,  classColor.b*255);
			info.text = string.format(MASTER_LOOTER_GIVE_TO, colorCode..name.."|r");
			info.func = LootHistoryDropDown_OnClick;
			UIDropDownMenu_AddButton(info);
		end

		-- Master looter frame

		for i = 1, 9 do
			select(i, MasterLooterFrame:GetRegions()):Hide()
		end

		MasterLooterFrame.Item.NameBorderLeft:Hide()
		MasterLooterFrame.Item.NameBorderRight:Hide()
		MasterLooterFrame.Item.NameBorderMid:Hide()
		MasterLooterFrame.Item.IconBorder:Hide()

		MasterLooterFrame.Item.Icon:SetTexCoord(.08, .92, .08, .92)
		MasterLooterFrame.Item.Icon:SetDrawLayer("ARTWORK")
		MasterLooterFrame.Item.bg = S.CreateBG(MasterLooterFrame.Item.Icon)

		MasterLooterFrame:HookScript("OnShow", function(self)
			self.Item.bg:SetVertexColor(self.Item.IconBorder:GetVertexColor())
			LootFrame:SetAlpha(.4)
		end)

		MasterLooterFrame:HookScript("OnHide", function(self)
			LootFrame:SetAlpha(1)
		end)

		S.CreateBD(MasterLooterFrame)
		S.ReskinClose(select(3, MasterLooterFrame:GetChildren()))

		hooksecurefunc("MasterLooterFrame_UpdatePlayers", function()
			for i = 1, MAX_RAID_MEMBERS do
				local playerFrame = MasterLooterFrame["player"..i]
				if playerFrame then
					if not playerFrame.styled then
						playerFrame.Bg:Point("TOPLEFT", 1, -1)
						playerFrame.Bg:Point("BOTTOMRIGHT", -1, 1)
						playerFrame.Highlight:Point("TOPLEFT", 1, -1)
						playerFrame.Highlight:Point("BOTTOMRIGHT", -1, 1)

						playerFrame.Highlight:SetTexture(media.backdrop)

						S.CreateBD(playerFrame, 0)

						playerFrame.styled = true
					end
					local colour = classcolours[select(2, UnitClass(playerFrame.Name:GetText()))]
					playerFrame.Name:SetTextColor(colour.r, colour.g, colour.b)
					playerFrame.Highlight:SetVertexColor(colour.r, colour.g, colour.b, .2)
				else
					break
				end
			end
		end)

		-- Missing loot frame

		MissingLootFrameCorner:Hide()

		hooksecurefunc("MissingLootFrame_Show", function()
			for i = 1, GetNumMissingLootItems() do
				local bu = _G["MissingLootFrameItem"..i]

				if not bu.styled then
					_G["MissingLootFrameItem"..i.."NameFrame"]:Hide()

					bu.icon:SetTexCoord(.08, .92, .08, .92)
					S.CreateBG(bu.icon)

					bu.styled = true
				end
			end
		end)

		S.CreateBD(MissingLootFrame)
		S.ReskinClose(MissingLootFramePassButton)

		-- BN conversation

		BNConversationInviteDialogHeader:SetTexture("")

		S.CreateBD(BNConversationInviteDialog)
		S.CreateBD(BNConversationInviteDialogList, .25)

		S.Reskin(BNConversationInviteDialogInviteButton)
		S.Reskin(BNConversationInviteDialogCancelButton)
		S.ReskinScroll(BNConversationInviteDialogListScrollFrameScrollBar)
		for i = 1, BN_CONVERSATION_INVITE_NUM_DISPLAYED do
			S.ReskinCheck(_G["BNConversationInviteDialogListFriend"..i].checkButton)
		end

		-- Taxi Frame

		TaxiFrame:DisableDrawLayer("BORDER")
		TaxiFrame:DisableDrawLayer("OVERLAY")
		TaxiFrame.Bg:Hide()
		TaxiFrame.TitleBg:Hide()

		S.SetBD(TaxiFrame, 3, -23, -5, 3)
		S.ReskinClose(TaxiFrame.CloseButton, "TOPRIGHT", TaxiRouteMap, "TOPRIGHT", -4, -4)

		-- Tabard frame

		TabardFrameMoneyInset:DisableDrawLayer("BORDER")
		TabardFrameCustomizationBorder:Hide()
		TabardFrameMoneyBg:Hide()
		TabardFrameMoneyInsetBg:Hide()

		for i = 19, 28 do
			select(i, TabardFrame:GetRegions()):Hide()
		end

		for i = 1, 5 do
			_G["TabardFrameCustomization"..i.."Left"]:Hide()
			_G["TabardFrameCustomization"..i.."Middle"]:Hide()
			_G["TabardFrameCustomization"..i.."Right"]:Hide()
			S.ReskinArrow(_G["TabardFrameCustomization"..i.."LeftButton"], "left")
			S.ReskinArrow(_G["TabardFrameCustomization"..i.."RightButton"], "right")
		end

		S.ReskinPortraitFrame(TabardFrame, true)
		S.CreateBD(TabardFrameCostFrame, .25)
		S.Reskin(TabardFrameAcceptButton)
		S.Reskin(TabardFrameCancelButton)

		-- Guild registrar frame

		GuildRegistrarFrameTop:Hide()
		GuildRegistrarFrameBottom:Hide()
		GuildRegistrarFrameMiddle:Hide()
		select(19, GuildRegistrarFrame:GetRegions()):Hide()
		select(6, GuildRegistrarFrameEditBox:GetRegions()):Hide()
		select(7, GuildRegistrarFrameEditBox:GetRegions()):Hide()

		GuildRegistrarFrameEditBox:Height(20)

		S.ReskinPortraitFrame(GuildRegistrarFrame, true)
		S.CreateBD(GuildRegistrarFrameEditBox, .25)
		S.Reskin(GuildRegistrarFrameGoodbyeButton)
		S.Reskin(GuildRegistrarFramePurchaseButton)
		S.Reskin(GuildRegistrarFrameCancelButton)

		-- World state score frame

		select(2, WorldStateScoreScrollFrame:GetRegions()):Hide()
		select(3, WorldStateScoreScrollFrame:GetRegions()):Hide()

		WorldStateScoreFrameTab2:Point("LEFT", WorldStateScoreFrameTab1, "RIGHT", -15, 0)
		WorldStateScoreFrameTab3:Point("LEFT", WorldStateScoreFrameTab2, "RIGHT", -15, 0)

		S.ReskinPortraitFrame(WorldStateScoreFrame, true)
		S.Reskin(WorldStateScoreFrameLeaveButton)
		S.ReskinScroll(WorldStateScoreScrollFrameScrollBar)

		for i = 1, 3 do
			S.ReskinTab(_G["WorldStateScoreFrameTab"..i])
		end

		-- Item text

		select(18, ItemTextFrame:GetRegions()):Hide()
		InboxFrameBg:Hide()
		ItemTextScrollFrameMiddle:SetAlpha(0)
		ItemTextScrollFrameTop:SetAlpha(0)
		ItemTextScrollFrameBottom:SetAlpha(0)
		ItemTextPrevPageButton:GetRegions():Hide()
		ItemTextNextPageButton:GetRegions():Hide()
		ItemTextMaterialTopLeft:SetAlpha(0)
		ItemTextMaterialTopRight:SetAlpha(0)
		ItemTextMaterialBotLeft:SetAlpha(0)
		ItemTextMaterialBotRight:SetAlpha(0)

		S.ReskinPortraitFrame(ItemTextFrame, true)
		S.ReskinScroll(ItemTextScrollFrameScrollBar)
		S.ReskinArrow(ItemTextPrevPageButton, "left")
		S.ReskinArrow(ItemTextNextPageButton, "right")

		-- Petition frame

		select(18, PetitionFrame:GetRegions()):Hide()
		select(19, PetitionFrame:GetRegions()):Hide()
		select(23, PetitionFrame:GetRegions()):Hide()
		select(24, PetitionFrame:GetRegions()):Hide()
		PetitionFrameTop:Hide()
		PetitionFrameBottom:Hide()
		PetitionFrameMiddle:Hide()

		S.ReskinPortraitFrame(PetitionFrame, true)
		S.Reskin(PetitionFrameSignButton)
		S.Reskin(PetitionFrameRequestButton)
		S.Reskin(PetitionFrameRenameButton)
		S.Reskin(PetitionFrameCancelButton)

		-- Mac options

		if IsMacClient() then
			S.CreateBD(MacOptionsFrame)
			MacOptionsFrameHeader:SetTexture("")
			MacOptionsFrameHeader:ClearAllPoints()
			MacOptionsFrameHeader:SetPoint("TOP", MacOptionsFrame, 0, 0)

			S.CreateBD(MacOptionsFrameMovieRecording, .25)
			S.CreateBD(MacOptionsITunesRemote, .25)
			S.CreateBD(MacOptionsFrameMisc, .25)

			S.Reskin(MacOptionsButtonKeybindings)
			S.Reskin(MacOptionsButtonCompress)
			S.Reskin(MacOptionsFrameCancel)
			S.Reskin(MacOptionsFrameOkay)
			S.Reskin(MacOptionsFrameDefaults)

			S.ReskinDropDown(MacOptionsFrameResolutionDropDown)
			S.ReskinDropDown(MacOptionsFrameFramerateDropDown)
			S.ReskinDropDown(MacOptionsFrameCodecDropDown)

			for i = 1, 11 do
				S.ReskinCheck(_G["MacOptionsFrameCheckButton"..i])
			end
			S.ReskinSlider(MacOptionsFrameQualitySlider)

			MacOptionsButtonCompress:Width(136)

			MacOptionsFrameCancel:Width(96)
			MacOptionsFrameCancel:Height(22)
			MacOptionsFrameCancel:ClearAllPoints()
			MacOptionsFrameCancel:Point("LEFT", MacOptionsButtonKeybindings, "RIGHT", 107, 0)

			MacOptionsFrameOkay:Width(96)
			MacOptionsFrameOkay:Height(22)
			MacOptionsFrameOkay:ClearAllPoints()
			MacOptionsFrameOkay:Point("LEFT", MacOptionsButtonKeybindings, "RIGHT", 5, 0)

			MacOptionsButtonKeybindings:Width(96)
			MacOptionsButtonKeybindings:Height(22)
			MacOptionsButtonKeybindings:ClearAllPoints()
			MacOptionsButtonKeybindings:Point("LEFT", MacOptionsFrameDefaults, "RIGHT", 5, 0)

			MacOptionsFrameDefaults:Width(96)
			MacOptionsFrameDefaults:Height(22)
		end

		-- Micro button alerts

		local microButtons = {TalentMicroButtonAlert, CompanionsMicroButtonAlert}
			for _, button in pairs(microButtons) do
			button:DisableDrawLayer("BACKGROUND")
			button:DisableDrawLayer("BORDER")
			button.Arrow:Hide()

			S.SetBD(button)
			S.ReskinClose(button.CloseButton)
		end

		-- Cinematic popup

		CinematicFrameCloseDialog:HookScript("OnShow", function(self)
			self:SetScale(UIParent:GetScale())
		end)

		S.CreateBD(CinematicFrameCloseDialog)
		S.CreateSD(CinematicFrameCloseDialog)
		S.Reskin(CinematicFrameCloseDialogConfirmButton)
		S.Reskin(CinematicFrameCloseDialogResumeButton)

		-- Bonus roll

		BonusRollFrame.Background:SetAlpha(0)
		BonusRollFrame.IconBorder:Hide()
		BonusRollFrame.BlackBackgroundHoist.Background:Hide()

		BonusRollFrame.PromptFrame.Icon:SetTexCoord(.08, .92, .08, .92)
		S.CreateBG(BonusRollFrame.PromptFrame.Icon)

		BonusRollFrame.PromptFrame.Timer.Bar:SetTexture(media.backdrop)

		S.CreateBD(BonusRollFrame)
		S.CreateBDFrame(BonusRollFrame.PromptFrame.Timer, .25)

		-- Chat config

		hooksecurefunc("ChatConfig_CreateCheckboxes", function(frame, checkBoxTable, checkBoxTemplate)
			if frame.styled then return end

			frame:SetBackdrop(nil)

			local checkBoxNameString = frame:GetName().."CheckBox"

			if checkBoxTemplate == "ChatConfigCheckBoxTemplate" then
				for index, value in ipairs(checkBoxTable) do
					local checkBoxName = checkBoxNameString..index
					local checkbox = _G[checkBoxName]

					checkbox:SetBackdrop(nil)

					local bg = CreateFrame("Frame", nil, checkbox)
					bg:Point("TOPLEFT")
					bg:Point("BOTTOMRIGHT", 0, 1)
					bg:SetFrameLevel(checkbox:GetFrameLevel()-1)
					S.CreateBD(bg, .25)

					S.ReskinCheck(_G[checkBoxName.."Check"])
				end
			elseif checkBoxTemplate == "ChatConfigCheckBoxWithSwatchTemplate" or checkBoxTemplate == "ChatConfigCheckBoxWithSwatchAndClassColorTemplate" then
				for index, value in ipairs(checkBoxTable) do
					local checkBoxName = checkBoxNameString..index
					local checkbox = _G[checkBoxName]

					checkbox:SetBackdrop(nil)

					local bg = CreateFrame("Frame", nil, checkbox)
					bg:SetPoint("TOPLEFT")
					bg:Point("BOTTOMRIGHT", 0, 1)
					bg:SetFrameLevel(checkbox:GetFrameLevel()-1)
					S.CreateBD(bg, .25)

					S.ReskinColourSwatch(_G[checkBoxName.."ColorSwatch"])

					S.ReskinCheck(_G[checkBoxName.."Check"])

					if checkBoxTemplate == "ChatConfigCheckBoxWithSwatchAndClassColorTemplate" then
						S.ReskinCheck(_G[checkBoxName.."ColorClasses"])
					end
				end
			end

			frame.styled = true
		end)

		hooksecurefunc("ChatConfig_CreateTieredCheckboxes", function(frame, checkBoxTable, checkBoxTemplate, subCheckBoxTemplate)
			if frame.styled then return end

			local checkBoxNameString = frame:GetName().."CheckBox"

			for index, value in ipairs(checkBoxTable) do
				local checkBoxName = checkBoxNameString..index

				S.ReskinCheck(_G[checkBoxName])

				if value.subTypes then
					local subCheckBoxNameString = checkBoxName.."_"

					for k, v in ipairs(value.subTypes) do
						S.ReskinCheck(_G[subCheckBoxNameString..k])
					end
				end
			end

			frame.styled = true
		end)

		hooksecurefunc("ChatConfig_CreateColorSwatches", function(frame, swatchTable, swatchTemplate)
			if frame.styled then return end

			frame:SetBackdrop(nil)

			local nameString = frame:GetName().."Swatch"

			for index, value in ipairs(swatchTable) do
				local swatchName = nameString..index
				local swatch = _G[swatchName]

				swatch:SetBackdrop(nil)

				local bg = CreateFrame("Frame", nil, swatch)
				bg:SetPoint("TOPLEFT")
				bg:Point("BOTTOMRIGHT", 0, 1)
				bg:SetFrameLevel(swatch:GetFrameLevel()-1)
				S.CreateBD(bg, .25)

				S.ReskinColourSwatch(_G[swatchName.."ColorSwatch"])
			end

			frame.styled = true
		end)

		for i = 1, 5 do
			_G["CombatConfigTab"..i.."Left"]:Hide()
			_G["CombatConfigTab"..i.."Middle"]:Hide()
			_G["CombatConfigTab"..i.."Right"]:Hide()
		end

		local line = ChatConfigFrame:CreateTexture()
		line:Size(1, 460)
		line:SetPoint("TOPLEFT", ChatConfigCategoryFrame, "TOPRIGHT")
		line:SetTexture(1, 1, 1, .2)

		ChatConfigCategoryFrame:SetBackdrop(nil)
		ChatConfigBackgroundFrame:SetBackdrop(nil)
		ChatConfigCombatSettingsFilters:SetBackdrop(nil)
		CombatConfigColorsHighlighting:SetBackdrop(nil)
		CombatConfigColorsColorizeUnitName:SetBackdrop(nil)
		CombatConfigColorsColorizeSpellNames:SetBackdrop(nil)
		CombatConfigColorsColorizeDamageNumber:SetBackdrop(nil)
		CombatConfigColorsColorizeDamageSchool:SetBackdrop(nil)
		CombatConfigColorsColorizeEntireLine:SetBackdrop(nil)

		local combatBoxes = {CombatConfigColorsHighlightingLine, CombatConfigColorsHighlightingAbility, CombatConfigColorsHighlightingDamage, CombatConfigColorsHighlightingSchool, CombatConfigColorsColorizeUnitNameCheck, CombatConfigColorsColorizeSpellNamesCheck, CombatConfigColorsColorizeSpellNamesSchoolColoring, CombatConfigColorsColorizeDamageNumberCheck, CombatConfigColorsColorizeDamageNumberSchoolColoring, CombatConfigColorsColorizeDamageSchoolCheck, CombatConfigColorsColorizeEntireLineCheck, CombatConfigFormattingShowTimeStamp, CombatConfigFormattingShowBraces, CombatConfigFormattingUnitNames, CombatConfigFormattingSpellNames, CombatConfigFormattingItemNames, CombatConfigFormattingFullText, CombatConfigSettingsShowQuickButton, CombatConfigSettingsSolo, CombatConfigSettingsParty, CombatConfigSettingsRaid}

		for _, box in next, combatBoxes do
			S.ReskinCheck(box)
		end

		local bg = CreateFrame("Frame", nil, ChatConfigCombatSettingsFilters)
		bg:Point("TOPLEFT", 3, 0)
		bg:Point("BOTTOMRIGHT", 0, 1)
		bg:SetFrameLevel(ChatConfigCombatSettingsFilters:GetFrameLevel()-1)
		S.CreateBD(bg, .25)

		S.Reskin(CombatLogDefaultButton)
		S.Reskin(ChatConfigCombatSettingsFiltersCopyFilterButton)
		S.Reskin(ChatConfigCombatSettingsFiltersAddFilterButton)
		S.Reskin(ChatConfigCombatSettingsFiltersDeleteButton)
		S.Reskin(CombatConfigSettingsSaveButton)
		S.ReskinArrow(ChatConfigMoveFilterUpButton, "up")
		S.ReskinArrow(ChatConfigMoveFilterDownButton, "down")
		S.ReskinInput(CombatConfigSettingsNameEditBox)
		S.ReskinRadio(CombatConfigColorsColorizeEntireLineBySource)
		S.ReskinRadio(CombatConfigColorsColorizeEntireLineByTarget)
		S.ReskinColourSwatch(CombatConfigColorsColorizeSpellNamesColorSwatch)
		S.ReskinColourSwatch(CombatConfigColorsColorizeDamageNumberColorSwatch)

		ChatConfigMoveFilterUpButton:Size(28, 28)
		ChatConfigMoveFilterDownButton:Size(28, 28)

		ChatConfigCombatSettingsFiltersAddFilterButton:Point("RIGHT", ChatConfigCombatSettingsFiltersDeleteButton, "LEFT", -1, 0)
		ChatConfigCombatSettingsFiltersCopyFilterButton:Point("RIGHT", ChatConfigCombatSettingsFiltersAddFilterButton, "LEFT", -1, 0)
		ChatConfigMoveFilterUpButton:Point("TOPLEFT", ChatConfigCombatSettingsFilters, "BOTTOMLEFT", 3, 0)
		ChatConfigMoveFilterDownButton:Point("LEFT", ChatConfigMoveFilterUpButton, "RIGHT", 1, 0)

		-- Level up display

		LevelUpDisplaySide:HookScript("OnShow", function(self)
			for i = 1, #self.unlockList do
				local f = _G["LevelUpDisplaySideUnlockFrame"..i]

				if not f.restyled then
					f.icon:SetTexCoord(.08, .92, .08, .92)
					S.CreateBG(f.icon)
				end
			end
		end)

		-- Movie Frame

		MovieFrame.CloseDialog:HookScript("OnShow", function(self)
			self:SetScale(UIParent:GetScale())
		end)

		S.CreateBD(MovieFrame.CloseDialog)
		S.CreateSD(MovieFrame.CloseDialog)
		S.Reskin(MovieFrame.CloseDialog.ConfirmButton)
		S.Reskin(MovieFrame.CloseDialog.ResumeButton)

		-- Pet battle queue popup

		S.CreateBD(PetBattleQueueReadyFrame)
		S.CreateSD(PetBattleQueueReadyFrame)
		S.CreateBG(PetBattleQueueReadyFrame.Art)
		S.Reskin(PetBattleQueueReadyFrame.AcceptButton)
		S.Reskin(PetBattleQueueReadyFrame.DeclineButton)

		-- PVP Banner Frame

		for i = 1, 3 do
			for j = 1, 2 do
				select(i, _G["PVPBannerFrameCustomization"..j]:GetRegions()):Hide()
			end
		end

		for i = 18, 28 do
			select(i, PVPBannerFrame:GetRegions()):SetTexture("")
		end

		PVPBannerFrameCustomizationBorder:Hide()

		S.ReskinPortraitFrame(PVPBannerFrame, true)
		S.Reskin(select(6, PVPBannerFrame:GetChildren()))
		S.Reskin(PVPBannerFrameAcceptButton)
		S.Reskin(PVPColorPickerButton1)
		S.Reskin(PVPColorPickerButton2)
		S.Reskin(PVPColorPickerButton3)
		S.ReskinInput(PVPBannerFrameEditBox, 20)
		S.ReskinArrow(PVPBannerFrameCustomization1LeftButton, "left")
		S.ReskinArrow(PVPBannerFrameCustomization1RightButton, "right")
		S.ReskinArrow(PVPBannerFrameCustomization2LeftButton, "left")
		S.ReskinArrow(PVPBannerFrameCustomization2RightButton, "right")

		-- [[ Hide regions ]]

		local bglayers = {"SpellBookFrame", "LFDParentFrame", "LFDParentFrameInset", "WhoFrameColumnHeader1", "WhoFrameColumnHeader2", "WhoFrameColumnHeader3", "WhoFrameColumnHeader4", "RaidInfoInstanceLabel", "RaidInfoIDLabel", "CharacterFrameInsetRight", "LFRQueueFrame", "LFRBrowseFrame", "HelpFrameMainInset", "CharacterModelFrame", "HelpFrame", "HelpFrameLeftInset", "EquipmentFlyoutFrameButtons", "VideoOptionsFrameCategoryFrame", "InterfaceOptionsFrameCategories", "InterfaceOptionsFrameAddOns", "RaidParentFrame"}
		for i = 1, #bglayers do
			_G[bglayers[i]]:DisableDrawLayer("BACKGROUND")
		end
		local borderlayers = {"WhoFrameListInset", "WhoFrameEditBoxInset", "ChannelFrameLeftInset", "ChannelFrameRightInset", "SpellBookFrame", "SpellBookFrameInset", "LFDParentFrame", "LFDParentFrameInset", "CharacterFrameInsetRight", "HelpFrame", "HelpFrameLeftInset", "HelpFrameMainInset", "CharacterModelFrame", "VideoOptionsFramePanelContainer", "InterfaceOptionsFramePanelContainer", "RaidParentFrame", "RaidParentFrameInset", "RaidFinderFrameRoleInset", "LFRQueueFrameRoleInset", "LFRQueueFrameListInset", "LFRQueueFrameCommentInset"}
		for i = 1, #borderlayers do
			_G[borderlayers[i]]:DisableDrawLayer("BORDER")
		end
		local overlayers = {"SpellBookFrame", "LFDParentFrame", "CharacterModelFrame"}
		for i = 1, #overlayers do
			_G[overlayers[i]]:DisableDrawLayer("OVERLAY")
		end
		for i = 1, 6 do
			for j = 1, 3 do
				select(i, _G["FriendsTabHeaderTab"..j]:GetRegions()):Hide()
				select(i, _G["FriendsTabHeaderTab"..j]:GetRegions()).Show = S.dummy
			end
			select(i, ScrollOfResurrectionFrameNoteFrame:GetRegions()):Hide()
		end
		EquipmentFlyoutFrameButtons:DisableDrawLayer("ARTWORK")
		OpenStationeryBackgroundLeft:Hide()
		OpenStationeryBackgroundRight:Hide()
		for i = 4, 7 do
			select(i, SendMailFrame:GetRegions()):Hide()
		end
		SendStationeryBackgroundLeft:Hide()
		SendStationeryBackgroundRight:Hide()
		DressUpFramePortrait:Hide()
		DressUpBackgroundTopLeft:Hide()
		DressUpBackgroundTopRight:Hide()
		DressUpBackgroundBotLeft:Hide()
		DressUpBackgroundBotRight:Hide()
		for i = 1, 4 do
			select(i, GearManagerDialogPopup:GetRegions()):Hide()
			select(i, SideDressUpFrame:GetRegions()):Hide()
		end
		StackSplitFrame:GetRegions():Hide()
		ReputationDetailCorner:Hide()
		ReputationDetailDivider:Hide()
		RaidInfoDetailFooter:Hide()
		RaidInfoDetailHeader:Hide()
		RaidInfoDetailCorner:Hide()
		RaidInfoFrameHeader:Hide()
		for i = 1, 9 do
			select(i, FriendsFriendsNoteFrame:GetRegions()):Hide()
			select(i, AddFriendNoteFrame:GetRegions()):Hide()
			select(i, ReportPlayerNameDialogCommentFrame:GetRegions()):Hide()
			select(i, ReportCheatingDialogCommentFrame:GetRegions()):Hide()
			select(i, QueueStatusFrame:GetRegions()):Hide()
		end
		HelpFrameHeader:Hide()
		ReadyCheckPortrait:SetAlpha(0)
		select(2, ReadyCheckListenerFrame:GetRegions()):Hide()
		HelpFrameLeftInsetBg:Hide()
		LFDQueueFrameBackground:Hide()
		select(3, HelpFrameReportBug:GetChildren()):Hide()
		select(3, HelpFrameSubmitSuggestion:GetChildren()):Hide()
		select(4, HelpFrameTicket:GetChildren()):Hide()
		HelpFrameKnowledgebaseStoneTex:Hide()
		HelpFrameKnowledgebaseNavBarOverlay:Hide()
		GhostFrameLeft:Hide()
		GhostFrameRight:Hide()
		GhostFrameMiddle:Hide()
		for i = 3, 6 do
			select(i, GhostFrame:GetRegions()):Hide()
		end
		PaperDollSidebarTabs:GetRegions():Hide()
		select(2, PaperDollSidebarTabs:GetRegions()):Hide()
		select(6, PaperDollEquipmentManagerPaneEquipSet:GetRegions()):Hide()
		select(5, HelpFrameGM_Response:GetChildren()):Hide()
		select(6, HelpFrameGM_Response:GetChildren()):Hide()
		HelpFrameKnowledgebaseNavBarHomeButtonLeft:Hide()
		TokenFramePopupCorner:Hide()
		GearManagerDialogPopupScrollFrame:GetRegions():Hide()
		select(2, GearManagerDialogPopupScrollFrame:GetRegions()):Hide()
		for i = 1, 10 do
			select(i, GuildInviteFrame:GetRegions()):Hide()
		end
		CharacterFrameExpandButton:GetNormalTexture():SetAlpha(0)
		CharacterFrameExpandButton:GetPushedTexture():SetAlpha(0)
		InboxPrevPageButton:GetRegions():Hide()
		InboxNextPageButton:GetRegions():Hide()
		MerchantPrevPageButton:GetRegions():Hide()
		MerchantNextPageButton:GetRegions():Hide()
		select(2, MerchantPrevPageButton:GetRegions()):Hide()
		select(2, MerchantNextPageButton:GetRegions()):Hide()
		BNToastFrameCloseButton:SetAlpha(0)
		LFDQueueFrameRandomScrollFrameScrollBackground:Hide()
		ChannelFrameDaughterFrameCorner:Hide()
		LFDQueueFrameSpecificListScrollFrameScrollBackgroundTopLeft:Hide()
		LFDQueueFrameSpecificListScrollFrameScrollBackgroundBottomRight:Hide()
		for i = 1, MAX_DISPLAY_CHANNEL_BUTTONS do
			_G["ChannelButton"..i]:SetNormalTexture("")
		end
		CharacterStatsPaneTop:Hide()
		CharacterStatsPaneBottom:Hide()
		hooksecurefunc("PaperDollFrame_CollapseStatCategory", function(categoryFrame)
			categoryFrame.BgMinimized:Hide()
		end)
		hooksecurefunc("PaperDollFrame_ExpandStatCategory", function(categoryFrame)
			categoryFrame.BgTop:Hide()
			categoryFrame.BgMiddle:Hide()
			categoryFrame.BgBottom:Hide()
		end)
		local titles = false
		hooksecurefunc("PaperDollTitlesPane_Update", function()
			if titles == false then
				for i = 1, 17 do
					_G["PaperDollTitlesPaneButton"..i]:DisableDrawLayer("BACKGROUND")
				end
				titles = true
			end
		end)
		ReputationListScrollFrame:GetRegions():Hide()
		select(2, ReputationListScrollFrame:GetRegions()):Hide()
		select(3, ReputationDetailFrame:GetRegions()):Hide()
		MerchantNameText:SetDrawLayer("ARTWORK")
		SendScrollBarBackgroundTop:Hide()
		select(4, SendMailScrollFrame:GetRegions()):Hide()
		for i = 1, 7 do
			_G["LFRBrowseFrameColumnHeader"..i]:DisableDrawLayer("BACKGROUND")
		end
		HelpFrameKnowledgebaseTopTileStreaks:Hide()
		for i = 2, 5 do
			select(i, DressUpFrame:GetRegions()):Hide()
		end
		ChannelFrameDaughterFrameTitlebar:Hide()
		OpenScrollBarBackgroundTop:Hide()
		select(2, OpenMailScrollFrame:GetRegions()):Hide()
		HelpFrameKnowledgebaseNavBar:GetRegions():Hide()
		select(2, WhoListScrollFrame:GetRegions()):Hide()
		select(2, GuildChallengeAlertFrame:GetRegions()):Hide()
		LFGDungeonReadyDialogBackground:Hide()
		LFGDungeonReadyDialogBottomArt:Hide()
		LFGDungeonReadyDialogFiligree:Hide()
		InterfaceOptionsFrameTab1TabSpacer:SetAlpha(0)
		for i = 1, 2 do
			_G["InterfaceOptionsFrameTab"..i.."Left"]:SetAlpha(0)
			_G["InterfaceOptionsFrameTab"..i.."Middle"]:SetAlpha(0)
			_G["InterfaceOptionsFrameTab"..i.."Right"]:SetAlpha(0)
			_G["InterfaceOptionsFrameTab"..i.."LeftDisabled"]:SetAlpha(0)
			_G["InterfaceOptionsFrameTab"..i.."MiddleDisabled"]:SetAlpha(0)
			_G["InterfaceOptionsFrameTab"..i.."RightDisabled"]:SetAlpha(0)
			_G["InterfaceOptionsFrameTab2TabSpacer"..i]:SetAlpha(0)
		end
		ChannelRosterScrollFrameTop:SetAlpha(0)
		ChannelRosterScrollFrameBottom:SetAlpha(0)
		FriendsFrameFriendsScrollFrameTop:Hide()
		FriendsFrameFriendsScrollFrameMiddle:Hide()
		FriendsFrameFriendsScrollFrameBottom:Hide()
		WhoFrameListInsetBg:Hide()
		WhoFrameEditBoxInsetBg:Hide()
		ChannelFrameLeftInsetBg:Hide()
		ChannelFrameRightInsetBg:Hide()
		RaidFinderQueueFrameBackground:Hide()
		RaidParentFrameInsetBg:Hide()
		RaidFinderFrameRoleInsetBg:Hide()
		RaidFinderFrameRoleBackground:Hide()
		RaidParentFramePortraitFrame:Hide()
		RaidParentFramePortrait:Hide()
		RaidParentFrameTopBorder:Hide()
		RaidParentFrameTopRightCorner:Hide()
		LFRQueueFrameRoleInsetBg:Hide()
		LFRQueueFrameListInsetBg:Hide()
		LFRQueueFrameCommentInsetBg:Hide()
		select(5, SideDressUpModelCloseButton:GetRegions()):Hide()
		IgnoreListFrameTop:Hide()
		IgnoreListFrameMiddle:Hide()
		IgnoreListFrameBottom:Hide()
		PendingListFrameTop:Hide()
		PendingListFrameMiddle:Hide()
		PendingListFrameBottom:Hide()
		ScrollOfResurrectionSelectionFrameBackground:Hide()

		ReadyCheckFrame:HookScript("OnShow", function(self) if UnitIsUnit("player", self.initiator) then self:Hide() end end)

		-- [[ Text colour functions ]]

		NORMAL_QUEST_DISPLAY = "|cffffffff%s|r"
		TRIVIAL_QUEST_DISPLAY = "|cffffffff%s (low level)|r"

		GameFontBlackMedium:SetTextColor(1, 1, 1)
		QuestFont:SetTextColor(1, 1, 1)
		MailFont_Large:SetTextColor(1, 1, 1)
		MailFont_Large:SetShadowColor(0, 0, 0)
		MailFont_Large:SetShadowOffset(1, -1)
		MailTextFontNormal:SetTextColor(1, 1, 1)
		MailTextFontNormal:SetShadowOffset(1, -1)
		MailTextFontNormal:SetShadowColor(0, 0, 0)
		InvoiceTextFontNormal:SetTextColor(1, 1, 1)
		InvoiceTextFontSmall:SetTextColor(1, 1, 1)
		SpellBookPageText:SetTextColor(.8, .8, .8)
		QuestProgressRequiredItemsText:SetTextColor(1, 1, 1)
		QuestProgressRequiredItemsText:SetShadowColor(0, 0, 0)
		QuestInfoRewardsHeader:SetShadowColor(0, 0, 0)
		QuestProgressTitleText:SetShadowColor(0, 0, 0)
		QuestInfoTitleHeader:SetShadowColor(0, 0, 0)
		AvailableServicesText:SetTextColor(1, 1, 1)
		AvailableServicesText:SetShadowColor(0, 0, 0)
		PetitionFrameCharterTitle:SetTextColor(1, 1, 1)
		PetitionFrameCharterTitle:SetShadowColor(0, 0, 0)
		PetitionFrameMasterTitle:SetTextColor(1, 1, 1)
		PetitionFrameMasterTitle:SetShadowColor(0, 0, 0)
		PetitionFrameMemberTitle:SetTextColor(1, 1, 1)
		PetitionFrameMemberTitle:SetShadowColor(0, 0, 0)
		QuestInfoTitleHeader:SetTextColor(1, 1, 1)
		QuestInfoTitleHeader.SetTextColor = S.dummy
		QuestInfoDescriptionHeader:SetTextColor(1, 1, 1)
		QuestInfoDescriptionHeader.SetTextColor = S.dummy
		QuestInfoDescriptionHeader:SetShadowColor(0, 0, 0)
		QuestInfoObjectivesHeader:SetTextColor(1, 1, 1)
		QuestInfoObjectivesHeader.SetTextColor = S.dummy
		QuestInfoObjectivesHeader:SetShadowColor(0, 0, 0)
		QuestInfoRewardsHeader:SetTextColor(1, 1, 1)
		QuestInfoRewardsHeader.SetTextColor = S.dummy
		QuestInfoDescriptionText:SetTextColor(1, 1, 1)
		QuestInfoDescriptionText.SetTextColor = S.dummy
		QuestInfoObjectivesText:SetTextColor(1, 1, 1)
		QuestInfoObjectivesText.SetTextColor = S.dummy
		QuestInfoGroupSize:SetTextColor(1, 1, 1)
		QuestInfoGroupSize.SetTextColor = S.dummy
		QuestInfoRewardText:SetTextColor(1, 1, 1)
		QuestInfoRewardText.SetTextColor = S.dummy
		QuestInfoItemChooseText:SetTextColor(1, 1, 1)
		QuestInfoItemChooseText.SetTextColor = S.dummy
		QuestInfoItemReceiveText:SetTextColor(1, 1, 1)
		QuestInfoItemReceiveText.SetTextColor = S.dummy
		QuestInfoSpellLearnText:SetTextColor(1, 1, 1)
		QuestInfoSpellLearnText.SetTextColor = S.dummy
		QuestInfoXPFrameReceiveText:SetTextColor(1, 1, 1)
		QuestInfoXPFrameReceiveText.SetTextColor = S.dummy
		QuestProgressTitleText:SetTextColor(1, 1, 1)
		QuestProgressTitleText.SetTextColor = S.dummy
		QuestProgressText:SetTextColor(1, 1, 1)
		QuestProgressText.SetTextColor = S.dummy
		ItemTextPageText:SetTextColor(1, 1, 1)
		ItemTextPageText.SetTextColor = S.dummy
		GreetingText:SetTextColor(1, 1, 1)
		GreetingText.SetTextColor = S.dummy
		AvailableQuestsText:SetTextColor(1, 1, 1)
		AvailableQuestsText.SetTextColor = S.dummy
		AvailableQuestsText:SetShadowColor(0, 0, 0)
		QuestInfoSpellObjectiveLearnLabel:SetTextColor(1, 1, 1)
		QuestInfoSpellObjectiveLearnLabel.SetTextColor = S.dummy
		CurrentQuestsText:SetTextColor(1, 1, 1)
		CurrentQuestsText.SetTextColor = S.dummy
		CurrentQuestsText:SetShadowColor(0, 0, 0)
		CoreAbilityFont:SetTextColor(1, 1, 1)
		SystemFont_Large:SetTextColor(1, 1, 1)

		for i = 1, MAX_OBJECTIVES do
			local objective = _G["QuestInfoObjective"..i]
			objective:SetTextColor(1, 1, 1)
			objective.SetTextColor = S.dummy
		end

		hooksecurefunc("UpdateProfessionButton", function(self)
			self.spellString:SetTextColor(1, 1, 1);
			self.subSpellString:SetTextColor(1, 1, 1)
		end)

		function PaperDollFrame_SetLevel()
			local primaryTalentTree = GetSpecialization()
			local classDisplayName, class = UnitClass("player")
			local classColor = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]
			local classColorString = format("ff%.2x%.2x%.2x", classColor.r * 255, classColor.g * 255, classColor.b * 255)
			local specName

			if (primaryTalentTree) then
				_, specName = GetSpecializationInfo(primaryTalentTree);
			end

			if (specName and specName ~= "") then
				CharacterLevelText:SetFormattedText(PLAYER_LEVEL, UnitLevel("player"), classColorString, specName, classDisplayName);
			else
				CharacterLevelText:SetFormattedText(PLAYER_LEVEL_NO_SPEC, UnitLevel("player"), classColorString, classDisplayName);
			end
		end

		-- [[ Change positions ]]

		ChatConfigFrameDefaultButton:Width(125)
		ChatConfigFrameDefaultButton:Point("TOPLEFT", ChatConfigCategoryFrame, "BOTTOMLEFT", 0, -4)
		ChatConfigFrameOkayButton:Point("TOPRIGHT", ChatConfigBackgroundFrame, "BOTTOMRIGHT", 0, -4)
		ReputationDetailFrame:Point("TOPLEFT", ReputationFrame, "TOPRIGHT", 1, -28)
		PaperDollEquipmentManagerPaneEquipSet:Width(PaperDollEquipmentManagerPaneEquipSet:GetWidth()-1)
		PaperDollEquipmentManagerPaneSaveSet:Point("LEFT", PaperDollEquipmentManagerPaneEquipSet, "RIGHT", 1, 0)
		GearManagerDialogPopup:Point("LEFT", PaperDollFrame, "RIGHT", 1, 0)
		DressUpFrameResetButton:Point("RIGHT", DressUpFrameCancelButton, "LEFT", -1, 0)
		SendMailMailButton:Point("RIGHT", SendMailCancelButton, "LEFT", -1, 0)
		OpenMailDeleteButton:Point("RIGHT", OpenMailCancelButton, "LEFT", -1, 0)
		OpenMailReplyButton:Point("RIGHT", OpenMailDeleteButton, "LEFT", -1, 0)
		HelpFrameReportBugScrollFrameScrollBar:Point("TOPLEFT", HelpFrameReportBugScrollFrame, "TOPRIGHT", 1, -16)
		HelpFrameSubmitSuggestionScrollFrameScrollBar:Point("TOPLEFT", HelpFrameSubmitSuggestionScrollFrame, "TOPRIGHT", 1, -16)
		HelpFrameTicketScrollFrameScrollBar:Point("TOPLEFT", HelpFrameTicketScrollFrame, "TOPRIGHT", 1, -16)
		HelpFrameGM_ResponseScrollFrame1ScrollBar:Point("TOPLEFT", HelpFrameGM_ResponseScrollFrame1, "TOPRIGHT", 1, -16)
		HelpFrameGM_ResponseScrollFrame2ScrollBar:Point("TOPLEFT", HelpFrameGM_ResponseScrollFrame2, "TOPRIGHT", 1, -16)
		RaidInfoFrame:Point("TOPLEFT", RaidFrame, "TOPRIGHT", 1, -28)
		TokenFramePopup:Point("TOPLEFT", TokenFrame, "TOPRIGHT", 1, -28)
		CharacterFrameExpandButton:Point("BOTTOMRIGHT", CharacterFrameInset, "BOTTOMRIGHT", -14, 6)
		TabardCharacterModelRotateRightButton:Point("TOPLEFT", TabardCharacterModelRotateLeftButton, "TOPRIGHT", 1, 0)
		LFDQueueFrameSpecificListScrollFrameScrollBarScrollDownButton:Point("TOP", LFDQueueFrameSpecificListScrollFrameScrollBar, "BOTTOM", 0, 2)
		LFDQueueFrameRandomScrollFrameScrollBarScrollDownButton:Point("TOP", LFDQueueFrameRandomScrollFrameScrollBar, "BOTTOM", 0, 2)
		MerchantFrameTab2:Point("LEFT", MerchantFrameTab1, "RIGHT", -15, 0)
		SendMailMoneySilver:Point("LEFT", SendMailMoneyGold, "RIGHT", 1, 0)
		SendMailMoneyCopper:Point("LEFT", SendMailMoneySilver, "RIGHT", 1, 0)
		StaticPopup1MoneyInputFrameSilver:Point("LEFT", StaticPopup1MoneyInputFrameGold, "RIGHT", 1, 0)
		StaticPopup1MoneyInputFrameCopper:Point("LEFT", StaticPopup1MoneyInputFrameSilver, "RIGHT", 1, 0)
		StaticPopup2MoneyInputFrameSilver:Point("LEFT", StaticPopup2MoneyInputFrameGold, "RIGHT", 1, 0)
		StaticPopup2MoneyInputFrameCopper:Point("LEFT", StaticPopup2MoneyInputFrameSilver, "RIGHT", 1, 0)
		WhoFrameWhoButton:Point("RIGHT", WhoFrameAddFriendButton, "LEFT", -1, 0)
		WhoFrameAddFriendButton:Point("RIGHT", WhoFrameGroupInviteButton, "LEFT", -1, 0)
		FriendsFrameTitleText:Point("TOP", FriendsFrame, "TOP", 0, -8)
		VideoOptionsFrameOkay:Point("BOTTOMRIGHT", VideoOptionsFrameCancel, "BOTTOMLEFT", -1, 0)
		InterfaceOptionsFrameOkay:Point("BOTTOMRIGHT", InterfaceOptionsFrameCancel, "BOTTOMLEFT", -1, 0)

		-- [[ Tabs ]]

		for i = 1, 5 do
			S.ReskinTab(_G["SpellBookFrameTabButton"..i])
		end

		for i = 1, 4 do
			S.ReskinTab(_G["FriendsFrameTab"..i])
			if _G["CharacterFrameTab"..i] then
				S.ReskinTab(_G["CharacterFrameTab"..i])
			end
		end

		for i = 1, 2 do
			S.ReskinTab(_G["MerchantFrameTab"..i])
			S.ReskinTab(_G["MailFrameTab"..i])
		end

		-- [[ Buttons ]]

		for i = 1, 2 do
			for j = 1, 3 do
				S.Reskin(_G["StaticPopup"..i.."Button"..j])
			end
		end

		local buttons = {"VideoOptionsFrameOkay", "VideoOptionsFrameCancel", "VideoOptionsFrameDefaults", "VideoOptionsFrameApply", "AudioOptionsFrameOkay", "AudioOptionsFrameCancel", "AudioOptionsFrameDefaults", "InterfaceOptionsFrameDefaults", "InterfaceOptionsFrameOkay", "InterfaceOptionsFrameCancel", "ChatConfigFrameOkayButton", "ChatConfigFrameDefaultButton", "DressUpFrameCancelButton", "DressUpFrameResetButton", "WhoFrameWhoButton", "WhoFrameAddFriendButton", "WhoFrameGroupInviteButton", "SendMailMailButton", "SendMailCancelButton", "OpenMailReplyButton", "OpenMailDeleteButton", "OpenMailCancelButton", "OpenMailReportSpamButton", "ChannelFrameNewButton", "RaidFrameRaidInfoButton", "RaidFrameConvertToRaidButton", "GearManagerDialogPopupOkay", "GearManagerDialogPopupCancel", "StackSplitOkayButton", "StackSplitCancelButton", "GameMenuButtonHelp", "GameMenuButtonOptions", "GameMenuButtonUIOptions", "GameMenuButtonKeybindings", "GameMenuButtonMacros", "GameMenuButtonLogout", "GameMenuButtonQuit", "GameMenuButtonContinue", "GameMenuButtonMacOptions", "LFDQueueFrameFindGroupButton", "LFRQueueFrameFindGroupButton", "LFRQueueFrameAcceptCommentButton", "AddFriendEntryFrameAcceptButton", "AddFriendEntryFrameCancelButton", "FriendsFriendsSendRequestButton", "FriendsFriendsCloseButton", "ColorPickerOkayButton", "ColorPickerCancelButton", "LFGDungeonReadyDialogEnterDungeonButton", "LFGDungeonReadyDialogLeaveQueueButton", "LFRBrowseFrameSendMessageButton", "LFRBrowseFrameInviteButton", "LFRBrowseFrameRefreshButton", "LFDRoleCheckPopupAcceptButton", "LFDRoleCheckPopupDeclineButton", "GuildInviteFrameJoinButton", "GuildInviteFrameDeclineButton", "FriendsFramePendingButton1AcceptButton", "FriendsFramePendingButton1DeclineButton", "RaidInfoExtendButton", "RaidInfoCancelButton", "PaperDollEquipmentManagerPaneEquipSet", "PaperDollEquipmentManagerPaneSaveSet", "HelpFrameAccountSecurityOpenTicket", "HelpFrameCharacterStuckStuck", "HelpFrameOpenTicketHelpTopIssues", "HelpFrameOpenTicketHelpOpenTicket", "ReadyCheckFrameYesButton", "ReadyCheckFrameNoButton", "RolePollPopupAcceptButton", "HelpFrameTicketSubmit", "HelpFrameTicketCancel", "HelpFrameKnowledgebaseSearchButton", "GhostFrame", "HelpFrameGM_ResponseNeedMoreHelp", "HelpFrameGM_ResponseCancel", "GMChatOpenLog", "HelpFrameKnowledgebaseNavBarHomeButton", "AddFriendInfoFrameContinueButton", "LFDQueueFramePartyBackfillBackfillButton", "LFDQueueFramePartyBackfillNoBackfillButton", "ChannelFrameDaughterFrameOkayButton", "ChannelFrameDaughterFrameCancelButton", "PendingListInfoFrameContinueButton", "LFDQueueFrameNoLFDWhileLFRLeaveQueueButton", "InterfaceOptionsHelpPanelResetTutorials", "RaidFinderFrameFindRaidButton", "RaidFinderQueueFrameIneligibleFrameLeaveQueueButton", "SideDressUpModelResetButton", "LFGInvitePopupAcceptButton", "LFGInvitePopupDeclineButton", "RaidFinderQueueFramePartyBackfillBackfillButton", "RaidFinderQueueFramePartyBackfillNoBackfillButton", "ScrollOfResurrectionSelectionFrameAcceptButton", "ScrollOfResurrectionSelectionFrameCancelButton", "ScrollOfResurrectionFrameAcceptButton", "ScrollOfResurrectionFrameCancelButton", "HelpFrameReportBugSubmit", "HelpFrameSubmitSuggestionSubmit", "ReportPlayerNameDialogReportButton", "ReportPlayerNameDialogCancelButton", "ReportCheatingDialogReportButton", "ReportCheatingDialogCancelButton", "HelpFrameOpenTicketHelpItemRestoration"}
		for i = 1, #buttons do
		local reskinbutton = _G[buttons[i]]
			if reskinbutton then
				S.Reskin(reskinbutton)
			else
				print("Aurora: "..buttons[i].." was not found.")
			end
		end

		if IsAddOnLoaded("ACP") then S.Reskin(GameMenuButtonAddOns) end

		local closebuttons = {"SpellBookFrameCloseButton", "HelpFrameCloseButton", "RaidInfoCloseButton", "RolePollPopupCloseButton", "ItemRefCloseButton", "TokenFramePopupCloseButton", "ReputationDetailCloseButton", "ChannelFrameDaughterFrameDetailCloseButton", "LFGDungeonReadyStatusCloseButton", "RaidParentFrameCloseButton", "SideDressUpModelCloseButton", "LFGDungeonReadyDialogCloseButton", "StaticPopup1CloseButton"}
		for i = 1, #closebuttons do
			local closebutton = _G[closebuttons[i]]
			S.ReskinClose(closebutton)
		end

		S.ReskinClose(DressUpFrameCloseButton, "TOPRIGHT", DressUpFrame, "TOPRIGHT", -38, -16)
	end
end


function Module:OnInitialize()
	C = SunUIConfig.db.profile.MiniDB
	if not C["Aurora"] and IsAddOnLoaded("Aurora") then return end
	Module:RegisterEvent("ADDON_LOADED")
end