local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local A = S:GetModule("Skins")

local function LoadSkin()
	local r, g, b = RAID_CLASS_COLORS[S.myclass].r, RAID_CLASS_COLORS[S.myclass].g, RAID_CLASS_COLORS[S.myclass].b
	A:SetBD(CharacterFrame)
	A:SetBD(PetStableFrame)
	local frames = {
		"CharacterFrame",
		"CharacterFrameInset",
		"CharacterFrameInsetRight",
		"CharacterModelFrame",
	}
	for i = 1, #frames do
		_G[frames[i]]:DisableDrawLayer("BACKGROUND")
		_G[frames[i]]:DisableDrawLayer("BORDER")
	end
	CharacterModelFrame:DisableDrawLayer("OVERLAY")
	CharacterFramePortrait:Hide()
	CharacterFrameExpandButton:GetNormalTexture():SetAlpha(0)
	CharacterFrameExpandButton:GetPushedTexture():SetAlpha(0)
	CharacterStatsPaneTop:Hide()
	CharacterStatsPaneBottom:Hide()
	CharacterFramePortraitFrame:Hide()
	CharacterFrameTopRightCorner:Hide()
	CharacterFrameTopBorder:Hide()
	CharacterFrameExpandButton:SetPoint("BOTTOMRIGHT", CharacterFrameInset, "BOTTOMRIGHT", -14, 6)
	ReputationListScrollFrame:GetRegions():Hide()
	ReputationDetailCorner:Hide()
	ReputationDetailDivider:Hide()
	select(2, ReputationListScrollFrame:GetRegions()):Hide()
	select(3, ReputationDetailFrame:GetRegions()):Hide()
	for i = 1, 4 do
		select(i, GearManagerDialogPopup:GetRegions()):Hide()
	end
	GearManagerDialogPopupScrollFrame:GetRegions():Hide()
	select(2, GearManagerDialogPopupScrollFrame:GetRegions()):Hide()
	ReputationDetailFrame:SetPoint("TOPLEFT", ReputationFrame, "TOPRIGHT", 1, -28)
	PaperDollEquipmentManagerPaneEquipSet:SetWidth(PaperDollEquipmentManagerPaneEquipSet:GetWidth()-1)
	PaperDollEquipmentManagerPaneSaveSet:SetPoint("LEFT", PaperDollEquipmentManagerPaneEquipSet, "RIGHT", 1, 0)
	GearManagerDialogPopup:SetPoint("LEFT", PaperDollFrame, "RIGHT", 1, 0)
	PaperDollSidebarTabs:GetRegions():Hide()
	select(2, PaperDollSidebarTabs:GetRegions()):Hide()
	select(6, PaperDollEquipmentManagerPaneEquipSet:GetRegions()):Hide()

	A:ReskinClose(CharacterFrameCloseButton)
	A:ReskinScroll(CharacterStatsPaneScrollBar)
	A:ReskinScroll(PaperDollTitlesPaneScrollBar)
	A:ReskinScroll(PaperDollEquipmentManagerPaneScrollBar)
	A:ReskinScroll(ReputationListScrollFrameScrollBar)
	A:ReskinScroll(GearManagerDialogPopupScrollFrameScrollBar)
	A:ReskinArrow(CharacterFrameExpandButton, "left")
	A:Reskin(PaperDollEquipmentManagerPaneEquipSet)
	A:Reskin(PaperDollEquipmentManagerPaneSaveSet)
	A:Reskin(GearManagerDialogPopupOkay)
	A:Reskin(GearManagerDialogPopupCancel)
	A:ReskinClose(ReputationDetailCloseButton)
	A:ReskinCheck(ReputationDetailAtWarCheckBox)
	A:ReskinCheck(ReputationDetailInactiveCheckBox)
	A:ReskinCheck(ReputationDetailMainScreenCheckBox)
	A:ReskinCheck(ReputationDetailLFGBonusReputationCheckBox)
	A:ReskinInput(GearManagerDialogPopupEditBox)

	hooksecurefunc("CharacterFrame_Expand", function()
		select(15, CharacterFrameExpandButton:GetRegions()):SetTexture("Interface\\AddOns\\SunUI\\media\\arrow-left-active")
	end)

	hooksecurefunc("CharacterFrame_Collapse", function()
		select(15, CharacterFrameExpandButton:GetRegions()):SetTexture("Interface\\AddOns\\SunUI\\media\\arrow-right-active")
	end)

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

	for i = 1, 4 do
		A:CreateTab(_G["CharacterFrameTab"..i])
	end

	hooksecurefunc("PaperDollFrame_SetLevel", function()
        local primaryTalentTree = GetSpecialization()
        local classDisplayName, class = UnitClass("player")
        local classColor
		if CUSTOM_CLASS_COLORS then
			classColor = CUSTOM_CLASS_COLORS[class]
		else
			classColor = RAID_CLASS_COLORS[class]
		end
        local classColorString = format("ff%.2x%.2x%.2x", classColor.r * 255, classColor.g * 255, classColor.b * 255)

        if (primaryTalentTree) then
            local _, specName = GetSpecializationInfo(primaryTalentTree)
            CharacterLevelText:SetFormattedText(PLAYER_LEVEL, UnitLevel("player"), classColorString, specName, classDisplayName);
        else
            CharacterLevelText:SetFormattedText(PLAYER_LEVEL_NO_SPEC, UnitLevel("player"), classColorString, classDisplayName);
        end
	end)

	EquipmentFlyoutFrameButtons:DisableDrawLayer("BACKGROUND")
	EquipmentFlyoutFrameButtons:DisableDrawLayer("ARTWORK")

	local slots = {
		"Head",
		"Neck",
		"Shoulder",
		"Shirt",
		"Chest",
		"Waist",
		"Legs",
		"Feet",
		"Wrist",
		"Hands",
		"Finger0",
		"Finger1",
		"Trinket0",
		"Trinket1",
		"Back",
		"MainHand",
		"SecondaryHand",
		"Tabard"
	}

	for i = 1, #slots do
		local slot = _G["Character"..slots[i].."Slot"]
		local ic = _G["Character"..slots[i].."SlotIconTexture"]
		_G["Character"..slots[i].."SlotFrame"]:Hide()
		slot:StripTextures()
		slot.backgroundTextureName = ""
		slot.checkRelic = nil
		slot:SetNormalTexture("")
		slot:StyleButton()
		slot:SetBackdrop({
					bgFile = A["media"].blank, 
					insets = { left = -S.mult, right = -S.mult, top = -S.mult, bottom = -S.mult }
				})
		ic:SetTexCoord(.08, .92, .08, .92)
		ic:Point("TOPLEFT", 1, -1)
		ic:Point("BOTTOMRIGHT", -1, 1)
		slot.glow = CreateFrame("Frame", nil, slot)
		slot.glow:SetAllPoints()
		slot.glow:CreateBorder()
	end

	select(8, CharacterMainHandSlot:GetRegions()):Kill()
	select(8, CharacterSecondaryHandSlot:GetRegions()):Kill()
	--[[
	local function SkinItemFlyouts()
		for i = 1, (EquipmentFlyoutFrame.totalItems or 0) do
			local bu = _G["EquipmentFlyoutFrameButton"..i]
			local icon = _G["EquipmentFlyoutFrameButton"..i.."IconTexture"]
			if bu and not bu.reskinned then
				bu.IconBorder:Hide()
				bu:SetNormalTexture("")
				bu:StyleButton()
				icon:SetTexCoord(.08, .92, .08, .92)
				icon:Point("TOPLEFT", 2, -2)
				icon:Point("BOTTOMRIGHT", -2, 2)
				bu.reskinned = true
			end
		end
	end
	EquipmentFlyoutFrameButtons:HookScript("OnShow", SkinItemFlyouts)
	hooksecurefunc("EquipmentFlyout_Show", SkinItemFlyouts)
	]]
	EquipmentFlyoutFrameButtons.bg1:SetAlpha(0)
	hooksecurefunc("EquipmentFlyout_CreateButton", function()
		local bu = EquipmentFlyoutFrame.buttons[#EquipmentFlyoutFrame.buttons]
		local border = bu.IconBorder

		bu:SetNormalTexture("")
		bu:SetPushedTexture("")
		bu:StyleButton()
		--A:CreateBG(bu)
		border:SetTexture(A.media.backdrop)
		--border:SetPoint("TOPLEFT", -1, 1)
		--border:SetPoint("BOTTOMRIGHT", 1, -1)
		border:SetDrawLayer("BACKGROUND", 1)
		border:SetAlpha(0)
		
		bu.icon:SetTexCoord(.08, .92, .08, .92)
		bu.icon:Point("TOPLEFT", 2, -2)
		bu.icon:Point("BOTTOMRIGHT", -2, 2)
	end)
	local function ColorItemBorder()
		for i = 1, #slots do
			-- Colour the equipment slots by rarity
			local target = _G["Character"..slots[i].."Slot"]
			local icon = _G["Character"..slots[i].."SlotIconTexture"]
			local slotId, _, _ = GetInventorySlotInfo(slots[i].."Slot")
			local itemId = GetInventoryItemID("player", slotId)

			local glow = target.glow

			if itemId then
				local _, _, rarity, _, _, _, _, _, _, _, _ = GetItemInfo(itemId)
				if rarity and rarity > 1 then
					glow:SetAllPoints()
					glow:SetBackdropBorderColor(GetItemQualityColor(rarity))
					target:SetBackdropColor(0, 0, 0)
				else
					glow:Point("TOPLEFT", 1, -1)
					glow:Point("BOTTOMRIGHT", -1, 1)
					glow:SetBackdropBorderColor(0, 0, 0)
					target:SetBackdropColor(0, 0, 0, 0)
				end
			else
				glow:SetBackdropBorderColor(0, 0, 0, 0)
				target:SetBackdropColor(0, 0, 0, 0)
			end
		end
	end

	local CheckItemBorderColor = CreateFrame("Frame")
	CheckItemBorderColor:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
	CheckItemBorderColor:SetScript("OnEvent", ColorItemBorder)
	CharacterFrame:HookScript("OnShow", ColorItemBorder)
	ColorItemBorder()

	local function ColorFlyOutItemBorder(self)
		local location = self.location
		local glow = self.glow
		if(not glow) then
			self.glow = glow
			glow = CreateFrame("Frame", nil, self)
			glow:SetAllPoints()
			glow:CreateBorder()
			self.glow = glow
			self:SetBackdrop({
					bgFile = A["media"].blank, 
					insets = { left = -S.mult, right = -S.mult, top = -S.mult, bottom = -S.mult }
				})
		end
		if (not location) or (location >= EQUIPMENTFLYOUT_FIRST_SPECIAL_LOCATION) then
			self.glow:Point("TOPLEFT", 1, -1)
			self.glow:Point("BOTTOMRIGHT", -1, 1)
			self.glow:SetBackdropBorderColor(0, 0, 0)
			self:SetBackdropColor(0, 0, 0, 0)
			return
		end
		local id = EquipmentManager_GetItemInfoByLocation(location)
		local icon = _G[self:GetName().."IconTexture"]
		if id then
			local _, _, rarity, _, _, _, _, _, _, _, _ = GetItemInfo(id)
			if rarity and rarity > 1 then
				glow:SetAllPoints()
				glow:SetBackdropBorderColor(GetItemQualityColor(rarity))
				self:SetBackdropColor(0, 0, 0)
			else
				glow:Point("TOPLEFT", 1, -1)
				glow:Point("BOTTOMRIGHT", -1, 1)
				glow:SetBackdropBorderColor(0, 0, 0)
				self:SetBackdropColor(0, 0, 0, 0)
			end
		else
			glow:Point("TOPLEFT", 1, -1)
			glow:Point("BOTTOMRIGHT", -1, 1)
			glow:SetBackdropBorderColor(0, 0, 0)
			self:SetBackdropColor(0, 0, 0, 0)
		end
	end

	hooksecurefunc("EquipmentFlyout_DisplayButton", ColorFlyOutItemBorder)
	hooksecurefunc("EquipmentFlyout_Show", function()
		local flyout = EquipmentFlyoutFrame
		local buttonAnchor = flyout.buttonFrame
		local p1, parent, p2, x, y = buttonAnchor:GetPoint()
		if p2 == "TOPRIGHT" then
			buttonAnchor:ClearAllPoints()
			buttonAnchor:Point(p1, parent, p2, x, 2)
		elseif p2 == "BOTTOMLEFT" then
			buttonAnchor:ClearAllPoints()
			buttonAnchor:Point(p1, parent, p2, -2, y)
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
		tab.bg:Point("TOPLEFT", 1, -3)
		tab.bg:Point("BOTTOMRIGHT", 0, -1)
		tab.bg:SetFrameLevel(0)
		A:CreateBD(tab.bg)

		tab.Hider:Point("TOPLEFT", tab.bg, 1, -1)
		tab.Hider:Point("BOTTOMRIGHT", tab.bg, -1, 1)
	end

	for i = 1, NUM_GEARSET_ICONS_SHOWN do
		local bu = _G["GearManagerDialogPopupButton"..i]
		local ic = _G["GearManagerDialogPopupButton"..i.."Icon"]

		bu:SetCheckedTexture(A["media"].checked)
		select(2, bu:GetRegions()):Hide()
		ic:Point("TOPLEFT", 1, -1)
		ic:Point("BOTTOMRIGHT", -1, 1)
		ic:SetTexCoord(.08, .92, .08, .92)

		A:CreateBD(bu, .25)
		bu.pushed = true
		bu:StyleButton(1)
	end

	local sets = false
	PaperDollSidebarTab3:HookScript("OnClick", function()
		if sets == false then
			for i = 1, 8 do
				local bu = _G["PaperDollEquipmentManagerPaneButton"..i]
				local bd = _G["PaperDollEquipmentManagerPaneButton"..i.."Stripe"]
				local ic = _G["PaperDollEquipmentManagerPaneButton"..i.."Icon"]
				_G["PaperDollEquipmentManagerPaneButton"..i.."BgTop"]:SetAlpha(0)
				_G["PaperDollEquipmentManagerPaneButton"..i.."BgMiddle"]:Hide()
				_G["PaperDollEquipmentManagerPaneButton"..i.."BgBottom"]:SetAlpha(0)

				bd:Hide()
				bd.Show = S.dummy
				ic:SetTexCoord(.08, .92, .08, .92)

				A:CreateBG(ic)
			end
			sets = true
		end
	end)

	-- Reputation frame
	local function UpdateFactionSkins()
		for i = 1, GetNumFactions() do
			local statusbar = _G["ReputationBar"..i.."ReputationBar"]

			if statusbar then
				statusbar:SetStatusBarTexture(A["media"].backdrop)

				if not statusbar.reskinned then
				--	A:CreateBD(statusbar, .25)
					local frame = CreateFrame("Frame",nil, statusbar)
					A:CreateBD(frame, .25)
					frame:SetFrameLevel(statusbar:GetFrameLevel() -1)
					frame:Point("TOPLEFT", -1, 1)
					frame:Point("BOTTOMRIGHT", 1, -1)
					statusbar.reskinned = true
				end

				_G["ReputationBar"..i.."Background"]:SetTexture(nil)
				-- _G["ReputationBar"..i.."LeftLine"]:SetAlpha(0)
				-- _G["ReputationBar"..i.."BottomLine"]:SetAlpha(0)
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
	hooksecurefunc("ReputationFrame_OnEvent", UpdateFactionSkins)

	-- Pet stuff
	if S.myclass == "HUNTER" or S.myclass == "MAGE" or S.myclass == "DEATHKNIGHT" or S.myclass == "WARLOCK" then
		if S.myclass == "HUNTER" then
			PetStableFrame:DisableDrawLayer("BACKGROUND")
			PetStableFrame:DisableDrawLayer("BORDER")
			PetStableFrameInset:DisableDrawLayer("BACKGROUND")
			PetStableFrameInset:DisableDrawLayer("BORDER")
			PetStableBottomInset:DisableDrawLayer("BACKGROUND")
			PetStableBottomInset:DisableDrawLayer("BORDER")
			PetStableLeftInset:DisableDrawLayer("BACKGROUND")
			PetStableLeftInset:DisableDrawLayer("BORDER")
			PetStableFramePortrait:Hide()
			PetStableModelShadow:Hide()
			PetStableFramePortraitFrame:Hide()
			PetStableFrameTopBorder:Hide()
			PetStableFrameTopRightCorner:Hide()
			PetStableModelRotateLeftButton:Hide()
			PetStableModelRotateRightButton:Hide()

			PetStableSelectedPetIcon:SetTexCoord(.08, .92, .08, .92)
			local bd = CreateFrame("Frame", nil, PetStableFrame)
			bd:Point("TOPLEFT", PetStableSelectedPetIcon, -1, 1)
			bd:Point("BOTTOMRIGHT", PetStableSelectedPetIcon, 1, -1)
			A:CreateBD(bd, .25)

			A:ReskinClose(PetStableFrameCloseButton)
			A:ReskinArrow(PetStablePrevPageButton, "left")
			A:ReskinArrow(PetStableNextPageButton, "right")

			for i = 1, 10 do
				local bu = _G["PetStableStabledPet"..i]
				local bd = CreateFrame("Frame", nil, bu)
				bd:Point("TOPLEFT", -1, 1)
				bd:Point("BOTTOMRIGHT", 1, -1)
				bd:SetFrameLevel(0)
				A:CreateBD(bd, .25)
				bu:StripTextures()
				bu:StyleButton(true)
				_G["PetStableStabledPet"..i.."IconTexture"]:SetTexCoord(.08, .92, .08, .92)
			end

			for i = 1, 5 do
				local bu = _G["PetStableActivePet"..i]
				local bd = CreateFrame("Frame", nil, bu)
				bd:Point("TOPLEFT", -1, 1)
				bd:Point("BOTTOMRIGHT", 1, -1)
				bd:SetFrameLevel(0)
				A:CreateBD(bd, .25)
				bu:StripTextures()
				bu:StyleButton(true)
				_G["PetStableActivePet"..i.."IconTexture"]:SetTexCoord(.08, .92, .08, .92)
			end
		end

		local function FixTab()
			if CharacterFrameTab2:IsShown() then
				CharacterFrameTab3:SetPoint("LEFT", CharacterFrameTab2, "RIGHT", -15, 0)
			else
				CharacterFrameTab3:SetPoint("LEFT", CharacterFrameTab1, "RIGHT", -15, 0)
			end
		end
		CharacterFrame:HookScript("OnEvent", FixTab)
		CharacterFrame:HookScript("OnShow", FixTab)

		PetModelFrameRotateLeftButton:Hide()
		PetModelFrameRotateRightButton:Hide()
		PetModelFrameShadowOverlay:Hide()
		PetPaperDollPetModelBg:SetAlpha(0)
	end
end

A:RegisterSkin("SunUI", LoadSkin)