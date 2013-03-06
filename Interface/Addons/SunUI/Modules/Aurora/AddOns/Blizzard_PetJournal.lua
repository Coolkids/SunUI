local S, L, DB, _, C = unpack(select(2, ...))
local r, g, b = DB.MyClassColor.r, DB.MyClassColor.g, DB.MyClassColor.b
local AuroraConfig = DB.AuroraConfig

DB.AuroraModules["Blizzard_PetJournal"] = function()
	local PetJournal = PetJournal
	local MountJournal = MountJournal

	if IsAddOnLoaded("BattlePetTabs") then
			PetJournal:HookScript("OnShow", function(self)
				if not self.styledTabs then
					BattlePetTabsTab1:Point("TOPLEFT", "$parent", "BOTTOMLEFT", 10, 0)
					for i = 1, 8 do
						local bu = _G["BattlePetTabsTab"..i.."Button"]

						_G["BattlePetTabsTab"..i]:GetRegions():Hide()

						bu:SetNormalTexture("")
						bu:SetPushedTexture("")
						bu:SetCheckedTexture(DB.media.checked)

						S.CreateBG(bu)
						S.CreateSD(bu, 5, 0, 0, 0, 1, 1)

						_G["BattlePetTabsTab"..i.."ButtonIconTexture"]:SetTexCoord(.08, .92, .08, .92)
					end

					self.styledTabs = true
				end
			end)
		end

	for i = 1, 14 do
		if i ~= 8 then
			select(i, PetJournalParent:GetRegions()):Hide()
		end
	end
	for i = 1, 9 do
		select(i, MountJournal.MountCount:GetRegions()):Hide()
		select(i, PetJournal.PetCount:GetRegions()):Hide()
	end

	MountJournal.LeftInset:Hide()
	MountJournal.RightInset:Hide()
	PetJournal.LeftInset:Hide()
	PetJournal.RightInset:Hide()
	PetJournal.PetCardInset:Hide()
	PetJournal.loadoutBorder:Hide()
	MountJournal.MountDisplay.YesMountsTex:SetAlpha(0)
	MountJournal.MountDisplay.NoMountsTex:SetAlpha(0)
	MountJournal.MountDisplay.ShadowOverlay:Hide()
	PetJournalFilterButtonLeft:Hide()
	PetJournalFilterButtonRight:Hide()
	PetJournalFilterButtonMiddle:Hide()
	PetJournalTutorialButton.Ring:Hide()

	S.CreateBD(PetJournalParent)
	S.CreateSD(PetJournalParent)
	S.CreateBD(MountJournal.MountCount, .25)
	S.CreateBD(PetJournal.PetCount, .25)
	S.CreateBD(MountJournal.MountDisplay.ModelFrame, .25)

	S.Reskin(MountJournalMountButton)
	S.Reskin(PetJournalSummonButton)
	S.Reskin(PetJournalFindBattle)
	S.Reskin(PetJournalFilterButton)
	S.ReskinTab(PetJournalParentTab1)
	S.ReskinTab(PetJournalParentTab2)
	S.ReskinClose(PetJournalParentCloseButton)
	S.ReskinScroll(MountJournalListScrollFrameScrollBar)
	S.ReskinScroll(PetJournalListScrollFrameScrollBar)
	S.ReskinInput(MountJournalSearchBox)
	S.ReskinInput(PetJournalSearchBox)
	S.ReskinArrow(MountJournal.MountDisplay.ModelFrame.RotateLeftButton, "left")
	S.ReskinArrow(MountJournal.MountDisplay.ModelFrame.RotateRightButton, "right")

	PetJournalTutorialButton:Point("TOPLEFT", PetJournal, "TOPLEFT", -14, 14)

	PetJournalParentTab2:Point("LEFT", PetJournalParentTab1, "RIGHT", -15, 0)

	PetJournalHealPetButtonBorder:Hide()
	PetJournalHealPetButtonIconTexture:SetTexCoord(.08, .92, .08, .92)
	PetJournal.HealPetButton:SetPushedTexture("")
	S.CreateBG(PetJournal.HealPetButton)

	local scrollFrames = {MountJournal.ListScrollFrame.buttons, PetJournal.listScroll.buttons}
	for _, scrollFrame in pairs(scrollFrames) do
		for i = 1, #scrollFrame do
			local bu = scrollFrame[i]

			bu:GetRegions():Hide()
			bu:SetHighlightTexture("")

			bu.selectedTexture:Point("TOPLEFT", 0, -1)
			bu.selectedTexture:Point("BOTTOMRIGHT", 0, 1)
			bu.selectedTexture:SetTexture(DB.media.backdrop)
			bu.selectedTexture:SetVertexColor(r, g, b, .2)

			local bg = CreateFrame("Frame", nil, bu)
			bg:Point("TOPLEFT", 0, -1)
			bg:Point("BOTTOMRIGHT", 0, 1)
			bg:SetFrameLevel(bu:GetFrameLevel()-1)
			S.CreateBD(bg, .25)
			bu.bg = bg

			bu.icon:SetTexCoord(.08, .92, .08, .92)
			bu.icon:SetDrawLayer("OVERLAY")
			bu.icon.bg = S.CreateBG(bu.icon)

			bu.name:SetParent(bg)

			if bu.DragButton then
				bu.DragButton.ActiveTexture:SetTexture(DB.media.checked)
			else
				bu.dragButton.ActiveTexture:SetTexture(DB.media.checked)
				bu.dragButton.levelBG:SetAlpha(0)
				bu.dragButton.level:SetFontObject(GameFontNormal)
				bu.dragButton.level:SetTextColor(1, 1, 1)
			end
		end
	end

	local function updateScroll()
		local buttons = MountJournal.ListScrollFrame.buttons
		for i = 1, #buttons do
			local bu = buttons[i]
			if bu.index ~= nil then
				bu.bg:Show()
				bu.icon:Show()
				bu.icon.bg:Show()
			else
				bu.bg:Hide()
				bu.icon:Hide()
				bu.icon.bg:Hide()
			end
		end
	end

	local bu1 = MountJournal.ListScrollFrame.buttons[1]
	bu1.bg:Point("TOPLEFT", 0, -1)
	bu1.bg:Point("BOTTOMRIGHT", -1, 1)
	bu1.selectedTexture:Point("TOPLEFT", 0, -1)
	bu1.selectedTexture:Point("BOTTOMRIGHT", -1, 1)

	hooksecurefunc("MountJournal_UpdateMountList", updateScroll)
	hooksecurefunc(MountJournalListScrollFrame, "update", updateScroll)

	local tooltips = {PetJournalPrimaryAbilityTooltip, PetJournalSecondaryAbilityTooltip}
	for _, f in pairs(tooltips) do
		f:DisableDrawLayer("BACKGROUND")
		local bg = CreateFrame("Frame", nil, f)
		bg:SetAllPoints()
		bg:SetFrameLevel(0)
		S.CreateBD(bg)
	end

	PetJournalLoadoutBorderSlotHeaderText:SetParent(PetJournal)
	PetJournalLoadoutBorderSlotHeaderText:Point("CENTER", PetJournalLoadoutBorderTop, "TOP", 0, 4)

	local card = PetJournalPetCard

	PetJournalPetCardBG:Hide()
	card.AbilitiesBG:SetAlpha(0)
	card.PetInfo.levelBG:SetAlpha(0)
	card.PetInfo.qualityBorder:SetAlpha(0)

	card.PetInfo.level:SetFontObject(GameFontNormal)
	card.PetInfo.level:SetTextColor(1, 1, 1)

	card.PetInfo.icon:SetTexCoord(.08, .92, .08, .92)
	card.PetInfo.icon.bg = S.CreateBG(card.PetInfo.icon)

	S.CreateBD(card, .25)

	for i = 2, 12 do
		select(i, card.xpBar:GetRegions()):Hide()
	end

	card.xpBar:SetStatusBarTexture(DB.media.backdrop)
	S.CreateBDFrame(card.xpBar, .25)

	PetJournalPetCardHealthFramehealthStatusBarLeft:Hide()
	PetJournalPetCardHealthFramehealthStatusBarRight:Hide()
	PetJournalPetCardHealthFramehealthStatusBarMiddle:Hide()
	PetJournalPetCardHealthFramehealthStatusBarBGMiddle:Hide()

	card.HealthFrame.healthBar:SetStatusBarTexture(DB.media.backdrop)
	S.CreateBDFrame(card.HealthFrame.healthBar, .25)

	for i = 1, 6 do
		local bu = card["spell"..i]

		bu.icon:SetTexCoord(.08, .92, .08, .92)
		S.CreateBG(bu.icon)
	end

	hooksecurefunc("PetJournal_UpdatePetCard", function(self)
		local border = self.PetInfo.qualityBorder
		local r, g, b

		if border:IsShown() then
			r, g, b = self.PetInfo.qualityBorder:GetVertexColor()
		else
			r, g, b = 0, 0, 0
		end

		self.PetInfo.icon.bg:SetVertexColor(r, g, b)
	end)

	for i = 1, 3 do
		local bu = PetJournal.Loadout["Pet"..i]

		_G["PetJournalLoadoutPet"..i.."BG"]:Hide()

		bu.iconBorder:SetAlpha(0)
		bu.qualityBorder:SetAlpha(0)
		bu.levelBG:SetAlpha(0)
		bu.helpFrame:GetRegions():Hide()

		bu.level:SetFontObject(GameFontNormal)
		bu.level:SetTextColor(1, 1, 1)

		bu.icon:SetTexCoord(.08, .92, .08, .92)
		bu.icon.bg = CreateFrame("Frame", nil, bu)
		bu.icon.bg:Point("TOPLEFT", bu.icon, -1, 1)
		bu.icon.bg:Point("BOTTOMRIGHT", bu.icon, 1, -1)
		bu.icon.bg:SetFrameLevel(bu:GetFrameLevel()-1)
		S.CreateBD(bu.icon.bg, .25)

		bu.setButton:GetRegions():Point("TOPLEFT", bu.icon, -5, 5)
		bu.setButton:GetRegions():Point("BOTTOMRIGHT", bu.icon, 5, -5)

		S.CreateBD(bu, .25)

		for i = 2, 12 do
			select(i, bu.xpBar:GetRegions()):Hide()
		end

		bu.xpBar:SetStatusBarTexture(DB.media.backdrop)
		S.CreateBDFrame(bu.xpBar, .25)

		_G["PetJournalLoadoutPet"..i.."HealthFramehealthStatusBarLeft"]:Hide()
		_G["PetJournalLoadoutPet"..i.."HealthFramehealthStatusBarRight"]:Hide()
		_G["PetJournalLoadoutPet"..i.."HealthFramehealthStatusBarMiddle"]:Hide()
		_G["PetJournalLoadoutPet"..i.."HealthFramehealthStatusBarBGMiddle"]:Hide()

		bu.healthFrame.healthBar:SetStatusBarTexture(DB.media.backdrop)
		S.CreateBDFrame(bu.healthFrame.healthBar, .25)

		for j = 1, 3 do
			local spell = bu["spell"..j]

			spell:SetPushedTexture("")

			spell.selected:SetTexture(DB.media.checked)

			spell:GetRegions():Hide()

			spell.FlyoutArrow:SetTexture(DB.media.arrowDown)
			spell.FlyoutArrow:Size(8, 8)
			spell.FlyoutArrow:SetTexCoord(0, 1, 0, 1)

			spell.icon:SetTexCoord(.08, .92, .08, .92)
			S.CreateBG(spell.icon)
		end
	end

	hooksecurefunc("PetJournal_UpdatePetLoadOut", function()
		for i = 1, 3 do
			local bu = PetJournal.Loadout["Pet"..i]

			bu.icon.bg:SetShown(not bu.helpFrame:IsShown())
			bu.icon.bg:SetBackdropBorderColor(bu.qualityBorder:GetVertexColor())

			bu.dragButton:SetEnabled(not bu.helpFrame:IsShown())
		end
	end)

	PetJournal.SpellSelect.BgEnd:Hide()
	PetJournal.SpellSelect.BgTiled:Hide()

	for i = 1, 2 do
		local bu = PetJournal.SpellSelect["Spell"..i]

		bu:SetCheckedTexture(DB.media.checked)
		bu:SetPushedTexture("")

		bu.icon:SetDrawLayer("ARTWORK")
		bu.icon:SetTexCoord(.08, .92, .08, .92)
		S.CreateBG(bu.icon)
	end

	local function ColourPetQuality()
		local petButtons = PetJournal.listScroll.buttons
		if petButtons then
			for i = 1, #petButtons do
				local bu = petButtons[i]

				local index = bu.index
				if index then
					local petID, _, isOwned = C_PetJournal.GetPetInfoByIndex(index)

					if petID and isOwned then
						local _, _, _, _, rarity = C_PetJournal.GetPetStats(petID)

						if rarity then
							local color = ITEM_QUALITY_COLORS[rarity-1]
							bu.name:SetTextColor(color.r, color.g, color.b)
						else
							bu.name:SetTextColor(1, 1, 1)
						end
					else
						bu.name:SetTextColor(.5, .5, .5)
					end
				end
			end
		end
	end

	PetJournal.listScroll.buttons[1].selectedTexture:Point("TOPLEFT", 0, -1)
	PetJournal.listScroll.buttons[1].selectedTexture:Point("BOTTOMRIGHT", -1, 1)

	hooksecurefunc("PetJournal_UpdatePetList", ColourPetQuality)
	hooksecurefunc(PetJournalListScrollFrame, "update", ColourPetQuality)
end