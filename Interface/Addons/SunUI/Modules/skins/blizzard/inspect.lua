local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local A = S:GetModule("Skins")

local function LoadSkin()
	A:SetBD(InspectFrame)
	InspectFrame:DisableDrawLayer("BACKGROUND")
	InspectFrame:DisableDrawLayer("BORDER")
	InspectFrameInset:DisableDrawLayer("BACKGROUND")
	InspectFrameInset:DisableDrawLayer("BORDER")
	InspectModelFrame:DisableDrawLayer("OVERLAY")
	InspectTalentFrame:DisableDrawLayer("BACKGROUND")
	InspectTalentFrame:DisableDrawLayer("BORDER")

	-- InspectPVPTeam1:DisableDrawLayer("BACKGROUND")
	-- InspectPVPTeam2:DisableDrawLayer("BACKGROUND")
	-- InspectPVPTeam3:DisableDrawLayer("BACKGROUND")
	InspectFramePortrait:Hide()
	InspectGuildFrameBG:Hide()
	for i = 1, 5 do
		select(i, InspectModelFrame:GetRegions()):Hide()
	end
	InspectFramePortraitFrame:Hide()
	InspectFrameTopBorder:Hide()
	InspectFrameTopRightCorner:Hide()
	-- InspectPVPFrameBG:SetAlpha(0)
	-- InspectPVPFrameBottom:SetAlpha(0)
	for i = 1, 4 do
		local tab = _G["InspectFrameTab"..i]
		A:CreateTab(tab)
		if i ~= 1 then
			tab:SetPoint("LEFT", _G["InspectFrameTab"..i-1], "RIGHT", -15, 0)
		end
	end
	--[[
	for i = 1, MAX_TALENT_TIERS do
		local row = _G["TalentsTalentRow"..i]
		row:DisableDrawLayer("BORDER")

		for j = 1, NUM_TALENT_COLUMNS do
			local bu = _G["TalentsTalentRow"..i.."Talent"..j]
			local border = _G["TalentsTalentRow"..i.."Talent"..j.."Border"]
			local ic = _G["TalentsTalentRow"..i.."Talent"..j.."IconTexture"]

			border:Kill()
			bu:SetHighlightTexture("")
			bu.Slot:SetAlpha(0)

			ic:SetDrawLayer("ARTWORK")
			ic:SetTexCoord(.08, .92, .08, .92)
			A:CreateBG(ic)
		end
	end
	--]]
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
		local slot = _G["Inspect"..slots[i].."Slot"]
		local icon = _G["Inspect"..slots[i].."SlotIconTexture"]
		_G["Inspect"..slots[i].."SlotFrame"]:Hide()
		slot:SetNormalTexture("")
		slot:StripTextures()
		slot.backgroundTextureName = ""
		slot.checkRelic = nil
		slot:SetNormalTexture("")
		slot:StyleButton()
		icon:SetTexCoord(.08, .92, .08, .92)
		icon:Point("TOPLEFT", 2, -2)
		icon:Point("BOTTOMRIGHT", -2, 2)
		slot.glow = CreateFrame("Frame", nil, slot)
		slot.glow:SetAllPoints()
		slot.glow:CreateBorder()
	end
	select(7, InspectMainHandSlot:GetRegions()):Kill()

	A:ReskinClose(InspectFrameCloseButton)

	local CheckItemBorderColor = CreateFrame("Frame")

	local function ColorItemBorder(slotName, itemLink)
		local target = _G["Inspect"..slotName.."Slot"]
		local icon = _G["Inspect"..slotName.."SlotIconTexture"]
		local glow = target.glow
		if itemLink then
			local _, _, rarity, _, _, _, _, _, _, _, _ = GetItemInfo(itemLink)
			if rarity and rarity > 1 then
				glow:SetAllPoints()
				glow:SetBackdropBorderColor(GetItemQualityColor(rarity))
				target:SetBackdrop({
					bgFile = A["media"].blank, 
					insets = { left = -S.mult, right = -S.mult, top = -S.mult, bottom = -S.mult }
				})
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

	local _MISSING = {}

	CheckItemBorderColor:SetScript("OnUpdate", function(self, elapsed)
		local unit = InspectFrame.unit
		if(not unit) then
			self:Hide()
			table.wipe(_MISSING)
		end

		for i, slotName in next, _MISSING do
			local itemLink = GetInventoryItemLink(unit, i)
			if(itemLink) then
				ColorItemBorder(slotName, itemLink)

				_MISSING[i] = nil
			end
		end

		if(not next(_MISSING)) then
			self:Hide()
		end
	end)

	local function update()
		if(not InspectFrame or not InspectFrame:IsShown()) then return end

		local unit = InspectFrame.unit
		for i, slotName in next, slots do
			local itemLink = GetInventoryItemLink(unit, i)
			local itemTexture = GetInventoryItemTexture(unit, i)

			if(itemTexture and not itemLink) then
				_MISSING[i] = slotName
				CheckItemBorderColor:Show()
			end

			ColorItemBorder(slotName, itemLink)
		end
	end

	local function SlotUpdate(self)
		local unit = InspectFrame.unit
		local itemLink = GetInventoryItemLink(unit, self:GetID())
		ColorItemBorder(self:GetName():match("Inspect(.+)Slot"), itemLink)
	end

	CheckItemBorderColor:RegisterEvent("PLAYER_TARGET_CHANGED")
	CheckItemBorderColor:RegisterEvent("UNIT_INVENTORY_CHANGED")
	CheckItemBorderColor:RegisterEvent("INSPECT_READY")
	CheckItemBorderColor:SetScript("OnEvent", function(self, event, unit)
		if event == "UNIT_INVENTORY_CHANGED" then
			if(InspectFrame.unit == unit) then
				update()
			end
		else
			update()
		end
	end)
	InspectFrame:HookScript("OnShow", update)
	hooksecurefunc("InspectPaperDollItemSlotButton_Update", SlotUpdate)

	-- PvP

	InspectPVPFrame.BG:Hide()

	for i = 1, 3 do
		local div = InspectPVPFrame["Div"..i]

		div:SetTexture(1, 1, 1, .2)
		div:SetHeight(1)
	end

	-- Talents

	local inspectSpec = InspectTalentFrame.InspectSpec

	inspectSpec.ring:Hide()

	for i = 1, 7 do
		local row = InspectTalentFrame.InspectTalents["tier"..i]
		for j = 1, 3 do
			local bu = row["talent"..j]

			bu.Slot:Hide()
			bu.border:SetTexture("")

			bu.icon:SetDrawLayer("ARTWORK")
			bu.icon:SetTexCoord(.08, .92, .08, .92)

			A:CreateBG(bu.icon)
		end
	end

	inspectSpec.specIcon:SetTexCoord(.08, .92, .08, .92)
	A:CreateBG(inspectSpec.specIcon)

	local function updateIcon(self)
		local spec = nil
		if INSPECTED_UNIT ~= nil then
			spec = GetInspectSpecialization(INSPECTED_UNIT)
		end
		if spec ~= nil and spec > 0 then
			local role1 = GetSpecializationRoleByID(spec)
			if role1 ~= nil then
				local _, _, _, icon = GetSpecializationInfoByID(spec)
				self.specIcon:SetTexture(icon)
			end
		end
	end

	inspectSpec:HookScript("OnShow", updateIcon)
	InspectTalentFrame:HookScript("OnEvent", function(self, event, unit)
		if not InspectFrame:IsShown() then return end
		if event == "INSPECT_READY" and InspectFrame.unit and UnitGUID(InspectFrame.unit) == unit then
			updateIcon(self.InspectSpec)
		end
	end)

	--local roleIcon = inspectSpec.roleIcon

	--roleIcon:SetTexture(A.media.roleIcons)

	do
		local left = inspectSpec:CreateTexture(nil, "OVERLAY")
		left:SetWidth(1)
		left:SetTexture(A.media.backdrop)
		left:SetVertexColor(0, 0, 0)
		left:SetPoint("TOPLEFT", roleIcon, 2, -2)
		left:SetPoint("BOTTOMLEFT", roleIcon, 2, 2)

		local right = inspectSpec:CreateTexture(nil, "OVERLAY")
		right:SetWidth(1)
		right:SetTexture(A.media.backdrop)
		right:SetVertexColor(0, 0, 0)
		right:SetPoint("TOPRIGHT", roleIcon, -2, -2)
		right:SetPoint("BOTTOMRIGHT", roleIcon, -2, 2)

		local top = inspectSpec:CreateTexture(nil, "OVERLAY")
		top:SetHeight(1)
		top:SetTexture(A.media.backdrop)
		top:SetVertexColor(0, 0, 0)
		top:SetPoint("TOPLEFT", roleIcon, 2, -2)
		top:SetPoint("TOPRIGHT", roleIcon, -2, -2)

		local bottom = inspectSpec:CreateTexture(nil, "OVERLAY")
		bottom:SetHeight(1)
		bottom:SetTexture(A.media.backdrop)
		bottom:SetVertexColor(0, 0, 0)
		bottom:SetPoint("BOTTOMLEFT", roleIcon, 2, 2)
		bottom:SetPoint("BOTTOMRIGHT", roleIcon, -2, 2)
	end

	local function updateGlyph(self, clear)
		local id = self:GetID()
		local talentGroup = PlayerTalentFrame and PlayerTalentFrame.talentGroup
		local enabled, glyphType, glyphTooltipIndex, glyphSpell, iconFilename = GetGlyphSocketInfo(id, talentGroup, true, INSPECTED_UNIT);

		if not glyphType then return end

		if enabled and glyphSpell and not clear then
			if iconFilename then
				self.glyph:SetTexture(iconFilename)
			else
				self.glyph:SetTexture("Interface\\Spellbook\\UI-Glyph-Rune1")
			end
		end
	end

	hooksecurefunc("InspectGlyphFrameGlyph_UpdateSlot", updateGlyph)

	for i = 1, 6 do
		local glyph = InspectTalentFrame.InspectGlyphs["Glyph"..i]

		glyph:HookScript("OnShow", updateGlyph)

		glyph.ring:Hide()

		glyph.glyph:SetDrawLayer("ARTWORK")
		glyph.glyph:SetTexCoord(.08, .92, .08, .92)
		A:CreateBDFrame(glyph.glyph, .25)
	end

	for i = 1, 4 do
		local tab = _G["InspectFrameTab"..i]
		A:ReskinTab(tab)
		if i ~= 1 then
			tab:SetPoint("LEFT", _G["InspectFrameTab"..i-1], "RIGHT", -15, 0)
		end
	end

	A:ReskinPortraitFrame(InspectFrame, true)
	
end

A:RegisterSkin("Blizzard_InspectUI", LoadSkin)