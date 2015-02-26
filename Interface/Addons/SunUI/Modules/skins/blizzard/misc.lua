local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local A = S:GetModule("Skins")

local function LoadSkin()
	local r, g, b = RAID_CLASS_COLORS[S.myclass].r, RAID_CLASS_COLORS[S.myclass].g, RAID_CLASS_COLORS[S.myclass].b

	GameFontBlackMedium:SetTextColor(1, 1, 1)
	InvoiceTextFontNormal:SetTextColor(1, 1, 1)
	InvoiceTextFontSmall:SetTextColor(1, 1, 1)
	AvailableServicesText:SetTextColor(1, 1, 1)
	AvailableServicesText:SetShadowColor(0, 0, 0)

	local BlizzardMenuButtons = {
		"Options",
		"SoundOptions",
		"UIOptions",
		"Keybindings",
		"Macros",
		"Ratings",
		"AddOns",
		"Logout",
		"Quit",
		"Continue",
		"MacOptions",
		"Help"
	}

	for i = 1, getn(BlizzardMenuButtons) do
		local MenuButtons = _G["GameMenuButton"..BlizzardMenuButtons[i]]
		if MenuButtons then
			local a1,f,a2,xx,yy = MenuButtons:GetPoint()
			MenuButtons:ClearAllPoints()
			MenuButtons:SetPoint(a1,f,a2,xx,yy-1)
			GameMenuFrame:SetHeight(GameMenuFrame:GetHeight()+1)
		end
	end
	
	for i = 1, 4 do
		for j = 1, 3 do
			A:Reskin(_G["StaticPopup"..i.."Button"..j])
		end
		local bu = _G["StaticPopup"..i.."ItemFrame"]
		_G["StaticPopup"..i.."ItemFrameNameFrame"]:Hide()
		_G["StaticPopup"..i.."ItemFrameNormalTexture"]:Hide()
		_G["StaticPopup"..i.."ItemFrameIconTexture"]:SetTexCoord(.08, .92, .08, .92)

		bu:StyleButton(true)
		A:CreateBG(bu)

		A:ReskinInput(_G["StaticPopup"..i.."EditBox"], 20)
	end

	local inputs = {
		"StaticPopup1MoneyInputFrameGold",
		"StaticPopup1MoneyInputFrameSilver",
		"StaticPopup1MoneyInputFrameCopper",
		"StaticPopup2MoneyInputFrameGold",
		"StaticPopup2MoneyInputFrameSilver",
		"StaticPopup2MoneyInputFrameCopper",
		"StaticPopup3MoneyInputFrameGold",
		"StaticPopup3MoneyInputFrameSilver",
		"StaticPopup3MoneyInputFrameCopper",
		"StaticPopup4MoneyInputFrameGold",
		"StaticPopup4MoneyInputFrameSilver",
		"StaticPopup4MoneyInputFrameCopper",
		"BagItemSearchBox",
		"BankItemSearchBox"
	}
	for i = 1, #inputs do
		local input = _G[inputs[i]]
		A:ReskinInput(input)
	end

	StaticPopup1MoneyInputFrameSilver:SetPoint("LEFT", StaticPopup1MoneyInputFrameGold, "RIGHT", 1, 0)
	StaticPopup1MoneyInputFrameCopper:SetPoint("LEFT", StaticPopup1MoneyInputFrameSilver, "RIGHT", 1, 0)
	StaticPopup2MoneyInputFrameSilver:SetPoint("LEFT", StaticPopup2MoneyInputFrameGold, "RIGHT", 1, 0)
	StaticPopup2MoneyInputFrameCopper:SetPoint("LEFT", StaticPopup2MoneyInputFrameSilver, "RIGHT", 1, 0)
	StaticPopup3MoneyInputFrameSilver:SetPoint("LEFT", StaticPopup3MoneyInputFrameGold, "RIGHT", 1, 0)
	StaticPopup3MoneyInputFrameCopper:SetPoint("LEFT", StaticPopup3MoneyInputFrameSilver, "RIGHT", 1, 0)
	StaticPopup4MoneyInputFrameSilver:SetPoint("LEFT", StaticPopup4MoneyInputFrameGold, "RIGHT", 1, 0)
	StaticPopup4MoneyInputFrameCopper:SetPoint("LEFT", StaticPopup4MoneyInputFrameSilver, "RIGHT", 1, 0)
	StackSplitFrame:GetRegions():Hide()

	local buttons = {
		"VideoOptionsFrameOkay",
		"VideoOptionsFrameCancel",
		"VideoOptionsFrameDefaults",
		"VideoOptionsFrameApply",
		"AudioOptionsFrameOkay",
		"AudioOptionsFrameCancel",
		"AudioOptionsFrameDefaults",
		"InterfaceOptionsFrameDefaults",
		"InterfaceOptionsFrameOkay",
		"InterfaceOptionsFrameCancel",
		"InterfaceOptionsSocialPanelTwitterLoginButton",
		"ChatConfigFrameOkayButton",
		"ChatConfigFrameDefaultButton",
		"StackSplitOkayButton",
		"StackSplitCancelButton",
		"GameMenuButtonHelp",
		"GameMenuButtonStore",
		"GameMenuButtonOptions",
		"GameMenuButtonUIOptions",
		"GameMenuButtonKeybindings",
		"GameMenuButtonMacros",
		"GameMenuButtonLogout",
		"GameMenuButtonQuit",
		"GameMenuButtonContinue",
		"GameMenuButtonMacOptions",
		"GameMenuButtonWhatsNew",
		"GameMenuButtonAddons",
		"ColorPickerOkayButton",
		"ColorPickerCancelButton",
		"GuildInviteFrameJoinButton",
		"GuildInviteFrameDeclineButton",
		"RolePollPopupAcceptButton",
		"GhostFrame",
		"InterfaceOptionsHelpPanelResetTutorials",
		"SideDressUpModelResetButton"
	}

	for i = 1, #buttons do
		local button = _G[buttons[i]]
		A:Reskin(button)
	end

	A:ReskinClose(RolePollPopupCloseButton)
	A:ReskinClose(ItemRefCloseButton)
	A:ReskinClose(FloatingBattlePetTooltip.CloseButton)

	local FrameBDs = {
		"StaticPopup1",
		"StaticPopup2",
		"StaticPopup3",
		"StaticPopup4",
		"GameMenuFrame",
		"InterfaceOptionsFrame",
		"VideoOptionsFrame",
		"AudioOptionsFrame",
		"ChatConfigFrame",
		"StackSplitFrame",
		"AddFriendFrame",
		"FriendsFriendsFrame",
		"ColorPickerFrame",
		"ReadyCheckFrame",
		"RolePollPopup",
		"GuildInviteFrame",
		"ChannelFrameDaughterFrame",
		"LFDRoleCheckPopup",
		"LFGDungeonReadyStatus",
		"LFGDungeonReadyDialog",
		"PVPReadyDialog"
	}
	for i = 1, #FrameBDs do
		local FrameBD = _G[FrameBDs[i]]
		A:CreateBD(FrameBD)
		A:CreateSD(FrameBD)
	end

	PVPReadyDialogBackground:Hide()
	PVPReadyDialogBottomArt:Hide()
	PVPReadyDialogFiligree:Hide()

	A:CreateBD(PVPReadyDialog)
	PVPReadyDialog.SetBackdrop = S.dummy
	A:CreateSD(PVPReadyDialog)

	A:Reskin(PVPReadyDialog.enterButton)
	A:Reskin(PVPReadyDialog.leaveButton)
	A:ReskinClose(PVPReadyDialogCloseButton)

	for i = 1, 10 do
		select(i, GuildInviteFrame:GetRegions()):Hide()
	end

	-- [[ Headers ]]
	local header = {
		"GameMenuFrame",
		"InterfaceOptionsFrame",
		"AudioOptionsFrame",
		"VideoOptionsFrame",
		"ChatConfigFrame",
		"ColorPickerFrame"
	}
	for i = 1, #header do
		local title = _G[header[i].."Header"]
		if title then
			title:SetTexture("")
			title:ClearAllPoints()
			if title == _G["GameMenuFrameHeader"] then
				title:SetPoint("TOP", GameMenuFrame, 0, 7)
			else
				title:SetPoint("TOP", header[i], 0, 0)
			end
		end
	end

	-- [[ Simple backdrops ]]
	local bds = {
		"AutoCompleteBox",
		"BNToastFrame",
		"TicketStatusFrameButton",
		"GearManagerDialogPopup",
		"TokenFramePopup",
		"ReputationDetailFrame",
		"RaidInfoFrame",
		"ScrollOfResurrectionSelectionFrame",
		"ScrollOfResurrectionFrame",
		"VoiceChatTalkers",
		"QueueStatusFrame"
	}

	for i = 1, #bds do
		A:CreateBD(_G[bds[i]])
	end

	-- Dropdown lists
	local function SkinDropDownList(level, index)
		for i = 1, UIDROPDOWNMENU_MAXLEVELS do
			local menu = _G["DropDownList"..i.."MenuBackdrop"]
			local backdrop = _G["DropDownList"..i.."Backdrop"]
			if not backdrop.reskinned then
				A:CreateBD(menu)
				A:CreateBD(backdrop)
				A:CreateStripesThin(menu)
				backdrop.reskinned = true
			end
		end
	end
	hooksecurefunc("UIDropDownMenu_CreateFrames", SkinDropDownList)

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
					listFrame:SetPoint("TOPLEFT", anchorName, "BOTTOMLEFT", 16, 9)
				end
			end
		else
			local point, anchor, relPoint, _, y = listFrame:GetPoint()
			if point:find("RIGHT") then
				listFrame:SetPoint(point, anchor, relPoint, -14, y)
			else
				listFrame:SetPoint(point, anchor, relPoint, 9, y)
			end
		end

		for j = 1, UIDROPDOWNMENU_MAXBUTTONS do
			local bu = _G["DropDownList"..level.."Button"..j]
			local _, _, _, x = bu:GetPoint()
			if bu:IsShown() and x then
				local hl = _G["DropDownList"..level.."Button"..j.."Highlight"]
				local check = _G["DropDownList"..level.."Button"..j.."Check"]

				hl:SetPoint("TOPLEFT", -x + 1, 0)
				hl:SetPoint("BOTTOMRIGHT", listFrame:GetWidth() - bu:GetWidth() - x - 1, 0)

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
						check:SetTexture(A["media"].backdrop)
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
	
	hooksecurefunc("UIDropDownMenu_SetIconImage", function(icon, texture)
		if texture:find("Divider") then
			icon:SetTexture(1, 1, 1, .2)
			icon:SetHeight(1)
		end
	end)

	-- Ghost frame
	GhostFrameContentsFrameIcon:SetTexCoord(.08, .92, .08, .92)
	GhostFrameLeft:Hide()
	GhostFrameRight:Hide()
	GhostFrameMiddle:Hide()
	for i = 3, 6 do
		select(i, GhostFrame:GetRegions()):Hide()
	end

	local GhostBD = CreateFrame("Frame", nil, GhostFrameContentsFrame)
	GhostBD:SetPoint("TOPLEFT", GhostFrameContentsFrameIcon, -1, 1)
	GhostBD:SetPoint("BOTTOMRIGHT", GhostFrameContentsFrameIcon, 1, -1)
	A:CreateBD(GhostBD, 0)

	-- Option panels
	local line = VideoOptionsFrame:CreateTexture(nil, "ARTWORK")
	line:Size(1, 536)
	line:SetPoint("LEFT", 205, 18)
	line:SetTexture(1, 1, 1, .2)

	A:CreateBD(AudioOptionsSoundPanelPlayback, .25)
	A:CreateBD(AudioOptionsSoundPanelHardware, .25)
	A:CreateBD(AudioOptionsSoundPanelVolume, .25)
	A:CreateBD(AudioOptionsVoicePanelTalking, .25)
	A:CreateBD(AudioOptionsVoicePanelBinding, .25)
	A:CreateBD(AudioOptionsVoicePanelListening, .25)

	AudioOptionsSoundPanelPlaybackTitle:SetPoint("BOTTOMLEFT", AudioOptionsSoundPanelPlayback, "TOPLEFT", 5, 2)
	AudioOptionsSoundPanelHardwareTitle:SetPoint("BOTTOMLEFT", AudioOptionsSoundPanelHardware, "TOPLEFT", 5, 2)
	AudioOptionsSoundPanelVolumeTitle:SetPoint("BOTTOMLEFT", AudioOptionsSoundPanelVolume, "TOPLEFT", 5, 2)
	AudioOptionsVoicePanelTalkingTitle:SetPoint("BOTTOMLEFT", AudioOptionsVoicePanelTalking, "TOPLEFT", 5, 2)
	AudioOptionsVoicePanelListeningTitle:SetPoint("BOTTOMLEFT", AudioOptionsVoicePanelListening, "TOPLEFT", 5, 2)

	local dropdowns = {
		"Display_DisplayModeDropDown",
		"Display_ResolutionDropDown",
		"Display_RefreshDropDown",
		"Display_PrimaryMonitorDropDown",
		"Display_AntiAliasingDropDown",
		"Display_VerticalSyncDropDown",
		"Graphics_TextureResolutionDropDown",
		"Graphics_FilteringDropDown",
		"Graphics_ProjectedTexturesDropDown",
		"Graphics_ShadowsDropDown",
		"Graphics_LiquidDetailDropDown",
		"Graphics_SunshaftsDropDown",
		"Graphics_ParticleDensityDropDown",
		"Graphics_ViewDistanceDropDown",
		"Graphics_EnvironmentalDetailDropDown",
		"Graphics_DepthEffectsDropDown",
		"Graphics_GroundClutterDropDown",
		"Graphics_SSAODropDown",
		"Graphics_DepthEffectsDropDown",
		"Graphics_LightingQualityDropDown",
		"Graphics_OutlineModeDropDown",
		"RaidGraphics_DisplayModeDropDown",
		"RaidGraphics_ResolutionDropDown",
		"RaidGraphics_RefreshDropDown",
		"RaidGraphics_PrimaryMonitorDropDown",
		"RaidGraphics_MultiSampleDropDown",
		"RaidGraphics_VerticalSyncDropDown",
		"RaidGraphics_TextureResolutionDropDown",
		"RaidGraphics_FilteringDropDown",
		"RaidGraphics_ProjectedTexturesDropDown",
		"RaidGraphics_ShadowsDropDown",
		"RaidGraphics_LiquidDetailDropDown",
		"RaidGraphics_SunshaftsDropDown",
		"RaidGraphics_ParticleDensityDropDown",
		"RaidGraphics_ViewDistanceDropDown",
		"RaidGraphics_EnvironmentalDetailDropDown",
		"RaidGraphics_GroundClutterDropDown",
		"RaidGraphics_SSAODropDown",
		"RaidGraphics_RefractionDropDown",
		"Advanced_BufferingDropDown",
		"Advanced_LagDropDown",
		"Advanced_HardwareCursorDropDown",
		"Advanced_MultisampleAntiAliasingDropDown",
		"Advanced_MultisampleAlphaTest",
		"Advanced_PostProcessAntiAliasingDropDown",
		"Advanced_ResampleQualityDropDown",
		"AudioOptionsSoundPanelHardwareDropDown",
		"AudioOptionsSoundPanelSoundChannelsDropDown",
		"AudioOptionsVoicePanelInputDeviceDropDown",
		"AudioOptionsVoicePanelChatModeDropDown",
		"AudioOptionsVoicePanelOutputDeviceDropDown",
		"InterfaceOptionsLanguagesPanelLocaleDropDown",
		"InterfaceOptionsLanguagesPanelAudioLocaleDropDown",
		"InterfaceOptionsStatusTextPanelDisplayDropDown"
	}
	for i = 1, #dropdowns do
		A:ReskinDropDown(_G[dropdowns[i]])
	end

	Graphics_RightQuality:GetRegions():Hide()
	Graphics_RightQuality:DisableDrawLayer("BORDER")
	RaidGraphics_RightQuality:GetRegions():Hide()
	RaidGraphics_RightQuality:DisableDrawLayer("BORDER")
	
	local sliders = {
		"Graphics_Quality",
		"RaidGraphics_Quality",
		"Advanced_UIScaleSlider",
		"Advanced_MaxFPSSlider",
		"Advanced_MaxFPSBKSlider",
		"Advanced_RenderScaleSlider",
		"Advanced_GammaSlider",
		"AudioOptionsSoundPanelSoundQuality",
		"AudioOptionsSoundPanelMasterVolume",
		"AudioOptionsSoundPanelSoundVolume",
		"AudioOptionsSoundPanelMusicVolume",
		"AudioOptionsSoundPanelAmbienceVolume",
		"AudioOptionsSoundPanelDialogVolume",
		"AudioOptionsVoicePanelMicrophoneVolume",
		"AudioOptionsVoicePanelSpeakerVolume",
		"AudioOptionsVoicePanelSoundFade",
		"AudioOptionsVoicePanelMusicFade",
		"AudioOptionsVoicePanelAmbienceFade"
	}
	for i = 1, #sliders do
		A:ReskinSlider(_G[sliders[i]])
	end

	Graphics_Quality.SetBackdrop = S.dummy

	local checkboxes = {
		"Advanced_UseUIScale",
		"Advanced_MaxFPSCheckBox",
		"Advanced_MaxFPSBKCheckBox",
		"Advanced_DesktopGamma",
		"NetworkOptionsPanelOptimizeSpeed",
		"NetworkOptionsPanelUseIPv6",
		"AudioOptionsSoundPanelEnableSound",
		"AudioOptionsSoundPanelSoundEffects",
		"AudioOptionsSoundPanelErrorSpeech",
		"AudioOptionsSoundPanelEmoteSounds",
		"AudioOptionsSoundPanelPetSounds",
		"AudioOptionsSoundPanelMusic",
		"AudioOptionsSoundPanelLoopMusic",
		"AudioOptionsSoundPanelAmbientSounds",
		"AudioOptionsSoundPanelDialogSounds",
		"AudioOptionsSoundPanelSoundInBG",
		"AudioOptionsSoundPanelReverb",
		"AudioOptionsSoundPanelHRTF",
		"AudioOptionsSoundPanelEnableDSPs",
		"AudioOptionsSoundPanelUseHardware",
		"AudioOptionsVoicePanelEnableVoice",
		"AudioOptionsVoicePanelEnableMicrophone",
		"AudioOptionsVoicePanelPushToTalkSound",
		"AudioOptionsSoundPanelPetBattleMusic",
		"Display_RaidSettingsEnabledCheckBox",
		"Advanced_ShowHDModels",
		"NetworkOptionsPanelAdvancedCombatLogging"
	}
	for i = 1, #checkboxes do
		A:ReskinCheck(_G[checkboxes[i]])
	end

	A:Reskin(RecordLoopbackSoundButton)
	A:Reskin(PlayLoopbackSoundButton)
	A:Reskin(AudioOptionsVoicePanelChatMode1KeyBindingButton)

	local line = InterfaceOptionsFrame:CreateTexture(nil, "ARTWORK")
	line:Size(1, 536)
	line:SetPoint("LEFT", 205, 18)
	line:SetTexture(1, 1, 1, .2)

	local checkboxes = {
		"InterfaceOptionsControlsPanelStickyTargeting",
		"InterfaceOptionsControlsPanelAutoDismount",
		"InterfaceOptionsControlsPanelAutoClearAFK",
		"InterfaceOptionsControlsPanelBlockTrades",
		"InterfaceOptionsControlsPanelBlockGuildInvites",
		"InterfaceOptionsControlsPanelBlockChatChannelInvites",
		"InterfaceOptionsControlsPanelLootAtMouse",
		"InterfaceOptionsControlsPanelAutoLootCorpse",
		"InterfaceOptionsControlsPanelInteractOnLeftClick",
		"InterfaceOptionsControlsPanelReverseCleanUpBags",
		"InterfaceOptionsControlsPanelReverseNewLoot",
		"InterfaceOptionsCombatPanelAttackOnAssist",
		"InterfaceOptionsCombatPanelStopAutoAttack",
		"InterfaceOptionsCombatPanelNameplateClassColors",
		"InterfaceOptionsCombatPanelTargetOfTarget",
		"InterfaceOptionsCombatPanelShowSpellAlerts",
		"InterfaceOptionsCombatPanelReducedLagTolerance",
		"InterfaceOptionsCombatPanelActionButtonUseKeyDown",
		"InterfaceOptionsCombatPanelEnemyCastBarsOnPortrait",
		"InterfaceOptionsCombatPanelEnemyCastBarsOnNameplates",
		"InterfaceOptionsCombatPanelEnemyCastBarsOnOnlyTargetNameplates",
		"InterfaceOptionsCombatPanelEnemyCastBarsNameplateSpellNames",
		"InterfaceOptionsCombatPanelAutoSelfCast",
		"InterfaceOptionsDisplayPanelShowCloak",
		"InterfaceOptionsDisplayPanelShowHelm",
		"InterfaceOptionsDisplayPanelShowAggroPercentage",
		"InterfaceOptionsDisplayPanelPlayAggroSounds",
		"InterfaceOptionsDisplayPanelShowSpellPointsAvg",
		"InterfaceOptionsDisplayPanelemphasizeMySpellEffects",
		"InterfaceOptionsDisplayPanelShowFreeBagSpace",
		"InterfaceOptionsDisplayPanelCinematicSubtitles",
		"InterfaceOptionsDisplayPanelShowAccountAchievments",
		"InterfaceOptionsDisplayPanelRotateMinimap",
		"InterfaceOptionsDisplayPanelScreenEdgeFlash",
		"InterfaceOptionsObjectivesPanelAutoQuestTracking",
		"InterfaceOptionsObjectivesPanelAutoQuestProgress",
		"InterfaceOptionsObjectivesPanelMapQuestDifficulty",
		"InterfaceOptionsObjectivesPanelWatchFrameWidth",
		"InterfaceOptionsObjectivesPanelMapFade",
		"InterfaceOptionsSocialPanelProfanityFilter",
		"InterfaceOptionsSocialPanelSpamFilter",
		"InterfaceOptionsSocialPanelChatBubbles",
		"InterfaceOptionsSocialPanelPartyChat",
		"InterfaceOptionsSocialPanelChatHoverDelay",
		"InterfaceOptionsSocialPanelGuildMemberAlert",
		"InterfaceOptionsSocialPanelChatMouseScroll",
		"InterfaceOptionsSocialPanelEnableTwitter",
		"InterfaceOptionsSocialPanelWholeChatWindowClickable",
		"InterfaceOptionsActionBarsPanelBottomLeft",
		"InterfaceOptionsActionBarsPanelBottomRight",
		"InterfaceOptionsActionBarsPanelRight",
		"InterfaceOptionsActionBarsPanelRightTwo",
		"InterfaceOptionsActionBarsPanelLockActionBars",
		"InterfaceOptionsActionBarsPanelAlwaysShowActionBars",
		"InterfaceOptionsActionBarsPanelSecureAbilityToggle",
		"InterfaceOptionsActionBarsPanelCountdownCooldowns",
		"InterfaceOptionsNamesPanelMyName",
		"InterfaceOptionsNamesPanelMinus",
		"InterfaceOptionsNamesPanelFriendlyPlayerNames",
		"InterfaceOptionsNamesPanelFriendlyPets",
		"InterfaceOptionsNamesPanelFriendlyGuardians",
		"InterfaceOptionsNamesPanelFriendlyTotems",
		"InterfaceOptionsNamesPanelUnitNameplatesFriends",
		"InterfaceOptionsNamesPanelUnitNameplatesFriendlyPets",
		"InterfaceOptionsNamesPanelUnitNameplatesFriendlyGuardians",
		"InterfaceOptionsNamesPanelUnitNameplatesFriendlyTotems",
		"InterfaceOptionsNamesPanelGuilds",
		"InterfaceOptionsNamesPanelGuildTitles",
		"InterfaceOptionsNamesPanelTitles",
		"InterfaceOptionsNamesPanelNonCombatCreature",
		"InterfaceOptionsNamesPanelEnemyPlayerNames",
		"InterfaceOptionsNamesPanelEnemyPets",
		"InterfaceOptionsNamesPanelEnemyGuardians",
		"InterfaceOptionsNamesPanelEnemyTotems",
		"InterfaceOptionsNamesPanelUnitNameplatesEnemies",
		"InterfaceOptionsNamesPanelUnitNameplatesEnemyPets",
		"InterfaceOptionsNamesPanelUnitNameplatesEnemyGuardians",
		"InterfaceOptionsNamesPanelUnitNameplatesEnemyTotems",
		"InterfaceOptionsNamesPanelUnitNameplatesNameplateClassColors",
		"InterfaceOptionsNamesPanelUnitNameplatesEnemyMinus",
		"InterfaceOptionsCombatTextPanelTargetDamage",
		"InterfaceOptionsCombatTextPanelPeriodicDamage",
		"InterfaceOptionsCombatTextPanelPetDamage",
		"InterfaceOptionsCombatTextPanelHealing",
		"InterfaceOptionsCombatTextPanelHealingAbsorbTarget",
		"InterfaceOptionsCombatTextPanelHealingAbsorbSelf",
		"InterfaceOptionsCombatTextPanelTargetEffects",
		"InterfaceOptionsCombatTextPanelOtherTargetEffects",
		"InterfaceOptionsCombatTextPanelEnableFCT",
		"InterfaceOptionsCombatTextPanelDodgeParryMiss",
		"InterfaceOptionsCombatTextPanelDamageReduction",
		"InterfaceOptionsCombatTextPanelRepChanges",
		"InterfaceOptionsCombatTextPanelReactiveAbilities",
		"InterfaceOptionsCombatTextPanelFriendlyHealerNames",
		"InterfaceOptionsCombatTextPanelCombatState",
		"InterfaceOptionsCombatTextPanelComboPoints",
		"InterfaceOptionsCombatTextPanelLowManaHealth",
		"InterfaceOptionsCombatTextPanelEnergyGains",
		"InterfaceOptionsCombatTextPanelPeriodicEnergyGains",
		"InterfaceOptionsCombatTextPanelHonorGains",
		"InterfaceOptionsCombatTextPanelAuras",
		"InterfaceOptionsCombatTextPanelPetBattle",
		"InterfaceOptionsStatusTextPanelPlayer",
		"InterfaceOptionsStatusTextPanelPet",
		"InterfaceOptionsStatusTextPanelParty",
		"InterfaceOptionsStatusTextPanelTarget",
		"InterfaceOptionsStatusTextPanelAlternateResource",
		"InterfaceOptionsStatusTextPanelPercentages",
		"InterfaceOptionsStatusTextPanelXP",
		"InterfaceOptionsUnitFramePanelPartyBackground",
		"InterfaceOptionsUnitFramePanelPartyPets",
		"InterfaceOptionsUnitFramePanelArenaEnemyFrames",
		"InterfaceOptionsUnitFramePanelArenaEnemyCastBar",
		"InterfaceOptionsUnitFramePanelArenaEnemyPets",
		"InterfaceOptionsUnitFramePanelFullSizeFocusFrame",
		"CompactUnitFrameProfilesRaidStylePartyFrames",
		"CompactUnitFrameProfilesGeneralOptionsFrameKeepGroupsTogether",
		"CompactUnitFrameProfilesGeneralOptionsFrameHorizontalGroups",
		"CompactUnitFrameProfilesGeneralOptionsFrameDisplayIncomingHeals",
		"CompactUnitFrameProfilesGeneralOptionsFrameDisplayPowerBar",
		"CompactUnitFrameProfilesGeneralOptionsFrameDisplayAggroHighlight",
		"CompactUnitFrameProfilesGeneralOptionsFrameUseClassColors",
		"CompactUnitFrameProfilesGeneralOptionsFrameDisplayPets",
		"CompactUnitFrameProfilesGeneralOptionsFrameDisplayMainTankAndAssist",
		"CompactUnitFrameProfilesGeneralOptionsFrameDisplayBorder",
		"CompactUnitFrameProfilesGeneralOptionsFrameShowDebuffs",
		"CompactUnitFrameProfilesGeneralOptionsFrameDisplayOnlyDispellableDebuffs",
		"CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate2Players",
		"CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate3Players",
		"CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate5Players",
		"CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate10Players",
		"CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate15Players",
		"CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate25Players",
		"CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate40Players",
		"CompactUnitFrameProfilesGeneralOptionsFrameAutoActivateSpec1",
		"CompactUnitFrameProfilesGeneralOptionsFrameAutoActivateSpec2",
		"CompactUnitFrameProfilesGeneralOptionsFrameAutoActivatePvP",
		"CompactUnitFrameProfilesGeneralOptionsFrameAutoActivatePvE",
		"InterfaceOptionsBuffsPanelBuffDurations",
		"InterfaceOptionsBuffsPanelDispellableDebuffs",
		"InterfaceOptionsBuffsPanelCastableBuffs",
		"InterfaceOptionsBuffsPanelConsolidateBuffs",
		"InterfaceOptionsBuffsPanelShowAllEnemyDebuffs",
		"InterfaceOptionsBattlenetPanelOnlineFriends",
		"InterfaceOptionsBattlenetPanelOfflineFriends",
		"InterfaceOptionsBattlenetPanelBroadcasts",
		"InterfaceOptionsBattlenetPanelFriendRequests",
		"InterfaceOptionsBattlenetPanelConversations",
		"InterfaceOptionsBattlenetPanelShowToastWindow",
		"InterfaceOptionsCameraPanelFollowTerrain",
		"InterfaceOptionsCameraPanelHeadBob",
		"InterfaceOptionsCameraPanelWaterCollision",
		"InterfaceOptionsCameraPanelSmartPivot",
		"InterfaceOptionsMousePanelInvertMouse",
		"InterfaceOptionsMousePanelClickToMove",
		"InterfaceOptionsMousePanelWoWMouse",
		"InterfaceOptionsMousePanelEnableMouseSpeed",
		"InterfaceOptionsHelpPanelShowTutorials",
		"InterfaceOptionsHelpPanelLoadingScreenTips",
		"InterfaceOptionsHelpPanelEnhancedTooltips",
		"InterfaceOptionsHelpPanelShowLuaErrors",
		"InterfaceOptionsHelpPanelColorblindMode",
		"InterfaceOptionsHelpPanelMovePad",
		"InterfaceOptionsControlsPanelAutoOpenLootHistory",
		"InterfaceOptionsCombatPanelLossOfControl",
		"InterfaceOptionsAccessibilityPanelMovePad",
		"InterfaceOptionsAccessibilityPanelColorblindMode"
	}
	for i = 1, #checkboxes do
		A:ReskinCheck(_G[checkboxes[i]])
	end

	local dropdowns = {
		"InterfaceOptionsControlsPanelAutoLootKeyDropDown",
		"InterfaceOptionsCombatPanelTOTDropDown",
		"InterfaceOptionsCombatPanelFocusCastKeyDropDown",
		"InterfaceOptionsCombatPanelSelfCastKeyDropDown",
		"InterfaceOptionsDisplayPanelAggroWarningDisplay",
		"InterfaceOptionsDisplayPanelWorldPVPObjectiveDisplay",
		"InterfaceOptionsDisplayPanelOutlineDropDown",
		"InterfaceOptionsObjectivesPanelQuestSorting",
		"InterfaceOptionsSocialPanelChatStyle",
		"InterfaceOptionsSocialPanelTimestamps",
		"InterfaceOptionsSocialPanelWhisperMode",
		"InterfaceOptionsSocialPanelBnWhisperMode",
		"InterfaceOptionsSocialPanelConversationMode",
		"InterfaceOptionsActionBarsPanelPickupActionKeyDropDown",
		"InterfaceOptionsNamesPanelNPCNamesDropDown",
		"InterfaceOptionsNamesPanelUnitNameplatesMotionDropDown",
		"InterfaceOptionsCombatTextPanelFCTDropDown",
		"InterfaceOptionsCombatTextPanelTargetModeDropDown",
		"CompactUnitFrameProfilesProfileSelector",
		"CompactUnitFrameProfilesGeneralOptionsFrameSortByDropdown",
		"CompactUnitFrameProfilesGeneralOptionsFrameHealthTextDropdown",
		"InterfaceOptionsCameraPanelStyleDropDown",
		"InterfaceOptionsMousePanelClickMoveStyleDropDown",
		"InterfaceOptionsAccessibilityPanelColorFilterDropDown",
		"Advanced_GraphicsAPIDropDown",
		"InterfaceOptionsCombatPanelLossOfControlFullDropDown",
		"InterfaceOptionsCombatPanelLossOfControlSilenceDropDown",
		"InterfaceOptionsCombatPanelLossOfControlInterruptDropDown",
		"InterfaceOptionsCombatPanelLossOfControlDisarmDropDown",
		"InterfaceOptionsCombatPanelLossOfControlRootDropDown"
	}
	for i = 1, #dropdowns do
		A:ReskinDropDown(_G[dropdowns[i]])
	end

	local sliders = {
		"InterfaceOptionsCombatPanelSpellAlertOpacitySlider",
		"InterfaceOptionsCombatPanelMaxSpellStartRecoveryOffset",
		"CompactUnitFrameProfilesGeneralOptionsFrameHeightSlider",
		"CompactUnitFrameProfilesGeneralOptionsFrameWidthSlider",
		"InterfaceOptionsBattlenetPanelToastDurationSlider",
		"InterfaceOptionsCameraPanelMaxDistanceSlider",
		"InterfaceOptionsCameraPanelFollowSpeedSlider",
		"InterfaceOptionsMousePanelMouseSensitivitySlider",
		"InterfaceOptionsMousePanelMouseLookSpeedSlider",
		"InterfaceOptionsAccessibilityPanelColorblindStrengthSlider"
	}
	for i = 1, #sliders do
		A:ReskinSlider(_G[sliders[i]])
	end

	A:Reskin(CompactUnitFrameProfilesSaveButton)
	A:Reskin(CompactUnitFrameProfilesDeleteButton)
	A:Reskin(CompactUnitFrameProfilesGeneralOptionsFrameResetPositionButton)
	A:Reskin(InterfaceOptionsHelpPanelResetTutorials)

	CompactUnitFrameProfilesGeneralOptionsFrameAutoActivateBG:Hide()

	VideoOptionsFrameCategoryFrame:DisableDrawLayer("BACKGROUND")
	InterfaceOptionsFrameCategories:DisableDrawLayer("BACKGROUND")
	InterfaceOptionsFrameAddOns:DisableDrawLayer("BACKGROUND")
	VideoOptionsFramePanelContainer:DisableDrawLayer("BORDER")
	InterfaceOptionsFramePanelContainer:DisableDrawLayer("BORDER")
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
	VideoOptionsFrameOkay:SetPoint("BOTTOMRIGHT", VideoOptionsFrameCancel, "BOTTOMLEFT", -1, 0)
	InterfaceOptionsFrameOkay:SetPoint("BOTTOMRIGHT", InterfaceOptionsFrameCancel, "BOTTOMLEFT", -1, 0)

	local lightbds = {
		"ChatConfigCategoryFrame",
		"ChatConfigBackgroundFrame",
		"ChatConfigChatSettingsLeft",
		"ChatConfigChatSettingsClassColorLegend",
		"ChatConfigChannelSettingsLeft",
		"ChatConfigChannelSettingsClassColorLegend",
		"ChatConfigOtherSettingsCombat",
		"ChatConfigOtherSettingsSystem",
		"ChatConfigOtherSettingsPVP",
		"ChatConfigOtherSettingsCreature",
		"HelpFrameTicketScrollFrame",
		"HelpFrameGM_ResponseScrollFrame1",
		"HelpFrameGM_ResponseScrollFrame2",
		"GuildRegistrarFrameEditBox",
	}
	for i = 1, #lightbds do
		A:CreateBD(_G[lightbds[i]], .25)
	end

	--实名好友弹窗位置
	A:ReskinClose(BNToastFrameCloseButton)
	--[[BNToastFrame:HookScript("OnShow", function(self)
		self:ClearAllPoints()
		if TempEnchant1:IsShown() or TempEnchant2:IsShown() then
			self:SetPoint("TOPLEFT", Minimap, "BOTTOMLEFT", -3, -51)
		else
			self:SetPoint("TOPLEFT", Minimap, "BOTTOMLEFT", -3, -17)
		end
	end)--]]

	ChatConfigFrameDefaultButton:SetWidth(125)
	ChatConfigFrameDefaultButton:SetPoint("TOPLEFT", ChatConfigCategoryFrame, "BOTTOMLEFT", 0, -4)
	ChatConfigFrameOkayButton:SetPoint("TOPRIGHT", ChatConfigBackgroundFrame, "BOTTOMRIGHT", 0, -4)

	hooksecurefunc("PanelTemplates_DeselectTab", function(tab)
		_G[tab:GetName().."Text"]:SetPoint("CENTER", tab, "CENTER")
	end)

	hooksecurefunc("PanelTemplates_SelectTab", function(tab)
		_G[tab:GetName().."Text"]:SetPoint("CENTER", tab, "CENTER")
	end)

	if IsMacClient() then
		A:CreateBD(MacOptionsFrame)
		MacOptionsFrameHeader:SetTexture("")
		MacOptionsFrameHeader:ClearAllPoints()
		MacOptionsFrameHeader:SetPoint("TOP", MacOptionsFrame, 0, 0)

		A:CreateBD(MacOptionsFrameMovieRecording, .25)
		A:CreateBD(MacOptionsITunesRemote, .25)

		A:Reskin(MacOptionsButtonKeybindings)
		A:Reskin(MacOptionsButtonCompress)
		A:Reskin(MacOptionsFrameCancel)
		A:Reskin(MacOptionsFrameOkay)
		A:Reskin(MacOptionsFrameDefaults)

		A:ReskinDropDown(MacOptionsFrameResolutionDropDown)
		A:ReskinDropDown(MacOptionsFrameFramerateDropDown)
		A:ReskinDropDown(MacOptionsFrameCodecDropDown)
		for i = 1, 10 do
			if _G["MacOptionsFrameCheckButton"..i] then
				A:ReskinCheck(_G["MacOptionsFrameCheckButton"..i])
			end
		end
		A:ReskinSlider(MacOptionsFrameQualitySlider)

		MacOptionsButtonCompress:SetWidth(136)

		MacOptionsFrameCancel:SetWidth(96)
		MacOptionsFrameCancel:SetHeight(22)
		MacOptionsFrameCancel:ClearAllPoints()
		MacOptionsFrameCancel:SetPoint("LEFT", MacOptionsButtonKeybindings, "RIGHT", 107, 0)

		MacOptionsFrameOkay:SetWidth(96)
		MacOptionsFrameOkay:SetHeight(22)
		MacOptionsFrameOkay:ClearAllPoints()
		MacOptionsFrameOkay:SetPoint("LEFT", MacOptionsButtonKeybindings, "RIGHT", 5, 0)

		MacOptionsButtonKeybindings:SetWidth(96)
		MacOptionsButtonKeybindings:SetHeight(22)
		MacOptionsButtonKeybindings:ClearAllPoints()
		MacOptionsButtonKeybindings:SetPoint("LEFT", MacOptionsFrameDefaults, "RIGHT", 5, 0)

		MacOptionsFrameDefaults:SetWidth(96)
		MacOptionsFrameDefaults:SetHeight(22)
	end

	SideDressUpModel:HookScript("OnShow", function(self)
		self:ClearAllPoints()
		self:SetPoint("LEFT", self:GetParent():GetParent(), "RIGHT", 1, 0)
	end)
	SideDressUpModel.bg = CreateFrame("Frame", nil, SideDressUpModel)
	SideDressUpModel.bg:SetPoint("TOPLEFT", 0, 1)
	SideDressUpModel.bg:SetPoint("BOTTOMRIGHT", 1, -1)
	SideDressUpModel.bg:SetFrameLevel(SideDressUpModel:GetFrameLevel()-1)
	A:CreateBD(SideDressUpModel.bg)
	A:Reskin(SideDressUpModelResetButton)
	A:ReskinClose(SideDressUpModelCloseButton)
	select(5, SideDressUpModelCloseButton:GetRegions()):Hide()
	for i = 1, 4 do
		select(i, SideDressUpFrame:GetRegions()):Hide()
	end
	GraphicsButton:StripTextures(true)
	RaidButton:StripTextures(true)
end

A:RegisterSkin("SunUI", LoadSkin)
