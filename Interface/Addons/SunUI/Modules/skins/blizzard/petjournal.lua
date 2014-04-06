local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local A = S:GetModule("Skins")

local function LoadSkin()
	local r, g, b = RAID_CLASS_COLORS[S.myclass].r, RAID_CLASS_COLORS[S.myclass].g, RAID_CLASS_COLORS[S.myclass].b
	for i = 1, 14 do
		if i ~= 8 then
			select(i, PetJournalParent:GetRegions()):Hide()
		end
	end
	for i = 1, 9 do
		select(i, MountJournal.MountCount:GetRegions()):Hide()
		select(i, PetJournal.PetCount:GetRegions()):Hide()
	end

	MountJournalMountButton_RightSeparator:Hide()
	MountJournal.LeftInset:Hide()
	MountJournal.RightInset:Hide()
	PetJournal.LeftInset:Hide()
	PetJournal.RightInset:Hide()
	PetJournal.PetCardInset:Hide()
	PetJournal.loadoutBorder:Hide()
	MountJournal.MountDisplay:GetRegions():Hide()
	MountJournal.MountDisplay.YesMountsTex:SetAlpha(0)
	MountJournal.MountDisplay.NoMountsTex:SetAlpha(0)
	MountJournal.MountDisplay.ShadowOverlay:Hide()
	PetJournalFilterButtonLeft:Hide()
	PetJournalFilterButtonRight:Hide()
	PetJournalFilterButtonMiddle:Hide()
	PetJournalTutorialButton.Ring:Hide()

	A:CreateBD(PetJournalParent)
	A:CreateSD(PetJournalParent)
	A:CreateBD(MountJournal.MountCount, .25)
	A:CreateBD(PetJournal.PetCount, .25)
	A:CreateBD(MountJournal.MountDisplay.ModelFrame, .25)

	A:Reskin(MountJournalMountButton)
	A:Reskin(PetJournalSummonButton)
	A:Reskin(PetJournalFindBattle)
	A:Reskin(PetJournalFilterButton)
	A:CreateTab(PetJournalParentTab1)
	A:CreateTab(PetJournalParentTab2)
	A:ReskinClose(PetJournalParentCloseButton)
	A:ReskinScroll(MountJournalListScrollFrameScrollBar)
	A:ReskinScroll(PetJournalListScrollFrameScrollBar)
	A:ReskinInput(PetJournalSearchBox)
	A:ReskinInput(MountJournalSearchBox)
	A:ReskinArrow(MountJournal.MountDisplay.ModelFrame.RotateLeftButton, "left")
	A:ReskinArrow(MountJournal.MountDisplay.ModelFrame.RotateRightButton, "right")

	PetJournalTutorialButton:SetPoint("TOPLEFT", PetJournal, "TOPLEFT", -14, 14)

	PetJournalParentTab2:SetPoint("LEFT", PetJournalParentTab1, "RIGHT", -15, 0)

	PetJournalHealPetButtonBorder:Hide()
	PetJournalHealPetButtonIconTexture:SetTexCoord(.08, .92, .08, .92)
	PetJournal.HealPetButton:StyleButton(true)
	A:CreateBG(PetJournal.HealPetButton)

	local scrollFrames = {MountJournal.ListScrollFrame.buttons, PetJournal.listScroll.buttons}
	for _, scrollFrame in pairs(scrollFrames) do
		for i = 1, #scrollFrame do
			local bu = scrollFrame[i]

			bu:GetRegions():Hide()
			bu:SetHighlightTexture("")

			bu.selectedTexture:Point("TOPLEFT", 1, -1)
			bu.selectedTexture:Point("BOTTOMRIGHT", -1, 1)
			bu.selectedTexture:SetTexture(A["media"].backdrop)
			bu.selectedTexture:SetVertexColor(r, g, b, .2)

			local bg = CreateFrame("Frame", nil, bu)
			bg:Point("TOPLEFT", 1, -1)
			bg:Point("BOTTOMRIGHT", -1, 1)
			bg:SetFrameLevel(bu:GetFrameLevel()-1)
			A:CreateBD(bg, .25)
			bu.bg = bg

			bu.icon:SetTexCoord(.08, .92, .08, .92)
			bu.icon:SetDrawLayer("OVERLAY")
			A:CreateBG(bu.icon)

			bu.name:SetParent(bg)
			bu:StyleButton()

			if bu.DragButton then
				bu.DragButton:StyleButton(1)
				bu.DragButton.ActiveTexture:SetTexture(A["media"].checked)
			else
				bu.dragButton:StyleButton(1)
				bu.dragButton.ActiveTexture:SetTexture(A["media"].checked)
				bu.dragButton.levelBG:SetAlpha(0)
				bu.dragButton.level:SetFont(S["media"].font, 12, "OUTLINE")
				bu.dragButton.level:SetTextColor(1, 1, 1)
			end
		end
	end

	local function updateScroll()
		local buttons = MountJournal.ListScrollFrame.buttons
		for i = 1, #buttons do
			local bu = buttons[i]
			if i == 2 then
				bu:Point("TOPLEFT", buttons[i-1], "BOTTOMLEFT", 0, -1)
			elseif i > 2 then
				bu:SetPoint("TOPLEFT", buttons[i-1], "BOTTOMLEFT", 0, 0)
			end
		end
	end

	hooksecurefunc("MountJournal_UpdateMountList", updateScroll)
	MountJournalListScrollFrame:HookScript("OnVerticalScroll", updateScroll)
	MountJournalListScrollFrame:HookScript("OnMouseWheel", updateScroll)

	local tooltips = {PetJournalPrimaryAbilityTooltip, PetJournalSecondaryAbilityTooltip}
	for _, f in pairs(tooltips) do
		f:DisableDrawLayer("BACKGROUND")
		local bg = CreateFrame("Frame", nil, f)
		bg:SetAllPoints()
		bg:SetFrameLevel(0)
		A:CreateBD(bg)
	end

	PetJournalLoadoutBorderSlotHeaderText:SetParent(PetJournal)
	PetJournalLoadoutBorderSlotHeaderText:Point("CENTER", PetJournalLoadoutBorderTop, "TOP", 0, 4)

	local card = PetJournalPetCard

	PetJournalPetCardBG:Hide()
	card.AbilitiesBG:SetAlpha(0)
	card.PetInfo.levelBG:SetAlpha(0)
	card.PetInfo.qualityBorder:SetAlpha(0)

	card.PetInfo.level:SetFont(S["media"].font, 12, "OUTLINE")
	card.PetInfo.level:SetTextColor(1, 1, 1)

	card.PetInfo.icon:SetTexCoord(.08, .92, .08, .92)
	card.PetInfo.icon.bg = CreateFrame("Frame", nil, card.PetInfo)
	card.PetInfo.icon.bg:Point("TOPLEFT", card.PetInfo.icon, -2, 2)
	card.PetInfo.icon.bg:Point("BOTTOMRIGHT", card.PetInfo.icon, 2, -2)
	card.PetInfo.icon.bg:SetFrameLevel(card.PetInfo:GetFrameLevel()-1)
	A:CreateBD(card.PetInfo.icon.bg)

	A:CreateBD(card, .25)

	for i = 2, 12 do
		select(i, card.xpBar:GetRegions()):Hide()
	end

	card.xpBar:SetStatusBarTexture(A["media"].backdrop)
	A:CreateBDFrame(card.xpBar, .25)

	PetJournalPetCardHealthFramehealthStatusBarLeft:Hide()
	PetJournalPetCardHealthFramehealthStatusBarRight:Hide()
	PetJournalPetCardHealthFramehealthStatusBarMiddle:Hide()
	PetJournalPetCardHealthFramehealthStatusBarBGMiddle:Hide()

	card.HealthFrame.healthBar:SetStatusBarTexture(A["media"].backdrop)
	A:CreateBDFrame(card.HealthFrame.healthBar, .25)

	for i = 1, 6 do
		local bu = card["spell"..i]

		bu.icon:SetTexCoord(.08, .92, .08, .92)
		A:CreateBG(bu.icon)
	end

	for i = 1, 3 do
		local bu = PetJournal.Loadout["Pet"..i]

		_G["PetJournalLoadoutPet"..i.."BG"]:Hide()

		bu.iconBorder:SetAlpha(0)
		bu.qualityBorder:SetAlpha(0)
		bu.levelBG:SetAlpha(0)
		bu.helpFrame:GetRegions():Hide()

		bu.level:SetFont(S["media"].font, 12, "OUTLINE")
		bu.level:SetTextColor(1, 1, 1)

		bu.icon:SetTexCoord(.08, .92, .08, .92)
		bu.icon.bg = CreateFrame("Frame", nil, bu)
		bu.icon.bg:Point("TOPLEFT", bu.icon, -2, 2)
		bu.icon.bg:Point("BOTTOMRIGHT", bu.icon, 2, -2)
		bu.icon.bg:SetFrameLevel(bu:GetFrameLevel()-1)
		A:CreateBD(bu.icon.bg)

		bu.setButton:GetRegions():Point("TOPLEFT", bu.icon, -5, 5)
		bu.setButton:GetRegions():Point("BOTTOMRIGHT", bu.icon, 5, -5)
		bu.dragButton:StyleButton(true)

		A:CreateBD(bu, .25)

		for i = 2, 12 do
			select(i, bu.xpBar:GetRegions()):Hide()
		end

		bu.xpBar:SetStatusBarTexture(A["media"].backdrop)
		A:CreateBDFrame(bu.xpBar, .25)

		_G["PetJournalLoadoutPet"..i.."HealthFramehealthStatusBarLeft"]:Hide()
		_G["PetJournalLoadoutPet"..i.."HealthFramehealthStatusBarRight"]:Hide()
		_G["PetJournalLoadoutPet"..i.."HealthFramehealthStatusBarMiddle"]:Hide()
		_G["PetJournalLoadoutPet"..i.."HealthFramehealthStatusBarBGMiddle"]:Hide()

		bu.healthFrame.healthBar:SetStatusBarTexture(A["media"].backdrop)
		A:CreateBDFrame(bu.healthFrame.healthBar, .25)

		for j = 1, 3 do
			local spell = bu["spell"..j]

			spell:StyleButton(true)

			spell.selected:SetTexture(nil)
			spell:GetRegions():Hide()

			spell.FlyoutArrow:SetTexture(A["media"].arrowDown)
			spell.FlyoutArrow:SetSize(8, 8)
			spell.FlyoutArrow:SetTexCoord(0, 1, 0, 1)

			spell.icon:SetTexCoord(.08, .92, .08, .92)
			A:CreateBG(spell.icon)
		end
	end

 	hooksecurefunc("PetJournal_UpdatePetLoadOut", function()
		for i = 1, 3 do
			local petID, _, _, _, locked =  C_PetJournal.GetPetLoadOutInfo(i)
			local bu = PetJournal.Loadout["Pet"..i]
			bu.icon.bg:SetShown(not bu.helpFrame:IsShown())
			local r, g, b = bu.qualityBorder:GetVertexColor()
			if r == 1 and g == 1 then r, g, b = 0, 0, 0 end

			bu.icon.bg:SetBackdropBorderColor(r, g, b)
			bu.dragButton:SetEnabled(not bu.helpFrame:IsShown())
			if not locked and petID then
				local _, customName, _, _, _, _, _, name = C_PetJournal.GetPetInfoByPetID(petID)
				local rarity = select(5,C_PetJournal.GetPetStats(petID))
				local hex  = select(4,GetItemQualityColor(rarity-1))
                name = customName or name
                bu.name:SetText("|c"..hex..name.."|r")
            end
		end
	end)

	hooksecurefunc("PetJournal_UpdatePetCard", function(self)
		local r, g, b = self.PetInfo.qualityBorder:GetVertexColor()
		if r == 1 and g == 1 then r, g, b = 0, 0, 0 end

		self.PetInfo.icon.bg:SetBackdropBorderColor(r, g, b)
		if PetJournalPetCard.petID  then
            local speciesID, customName, _, _, _, _, _, name, icon, petType, creatureID, sourceText, description, isWild, canBattle, tradable = C_PetJournal.GetPetInfoByPetID(PetJournalPetCard.petID)
            if canBattle then
                local health, maxHealth, power, speed, rarity = C_PetJournal.GetPetStats(PetJournalPetCard.petID)
                PetJournalPetCard.QualityFrame.quality:SetText(_G["BATTLE_PET_BREED_QUALITY"..rarity])
                local r,g,b,hex  = GetItemQualityColor(rarity-1)

                name = customName or name
                PetJournalPetCard.PetInfo.name:SetText("|c"..hex..name.."|r")
            end
        end
	end)

	PetJournal.SpellSelect.BgEnd:Hide()
	PetJournal.SpellSelect.BgTiled:Hide()

	for i = 1, 2 do
		local bu = PetJournal.SpellSelect["Spell"..i]

		bu:StyleButton(true)

		bu.icon:SetDrawLayer("ARTWORK")
		bu.icon:SetTexCoord(.08, .92, .08, .92)
		A:CreateBG(bu.icon)
	end

     local function UpdatePetList()
        local scrollFrame = PetJournal.listScroll
        local offset = HybridScrollFrame_GetOffset(scrollFrame)
        local petButtons = scrollFrame.buttons
        for i = 1,#petButtons do
            pet = petButtons[i]
            index = offset + i
            local petID, speciesID, isOwned, customName, level, favorite, isRevoked, name, icon, petType, creatureID, sourceText, description, isWildPet, canBattle = C_PetJournal.GetPetInfoByIndex(index)
            if petID then
                local health, maxHealth, attack, speed, rarity = C_PetJournal.GetPetStats(petID)
                if rarity then
                    local r, g, b, hex  = GetItemQualityColor(rarity - 1)
                    name = customName or name
                    pet.name:SetText("|c"..hex..name.."|r")
                end
            end
        end
    end

    hooksecurefunc("PetJournal_UpdatePetList", UpdatePetList)
    hooksecurefunc(PetJournal.listScroll, "update", UpdatePetList)
end

A:RegisterSkin("Blizzard_PetJournal", LoadSkin)
