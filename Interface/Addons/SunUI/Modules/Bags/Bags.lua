local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local

local B = S:NewModule("Bags", "AceEvent-3.0", "AceHook-3.0", "AceConsole-3.0")
B.modName = L["背包"]
B.order = 9
B.ProfessionColors = {
	[0x0008] = {224/255, 187/255, 74/255}, -- Leatherworking
	[0x0010] = {74/255, 77/255, 224/255}, -- Inscription
	[0x0020] = {18/255, 181/255, 32/255}, -- Herbs
	[0x0040] = {160/255, 3/255, 168/255}, -- Enchanting
	[0x0080] = {232/255, 118/255, 46/255}, -- Engineering
	[0x0200] = {8/255, 180/255, 207/255}, -- Gems
	[0x0400] = {105/255, 79/255,  7/255}, -- Mining
	[0x010000] = {222/255, 13/255,  65/255} -- Cooking
}

function B:GetOptions()
	local options = {
		BagSize = {
			type = "range", order = 1,
			name = L["背包图标"],
			min = 20, max = 50, step = 1,
			set = function(info, value)
				self.db.BagSize = value
				self:Layout(false) 
			end,
		},
		BankSize = {
			type = "range", order = 2,
			name = L["银行图标"],
			min = 20, max = 50, step = 1,
			set = function(info, value)
				self.db.BankSize = value
				self:Layout(true) 
			end,
		},
		Spacing = {
			type = "range", order = 3,
			name = L["图标间距"], desc = L["图标间距"],
			min = 0, max = 10, step = 1,
			set = function(info, value)
				self.db.Spacing = value
				self:Layout(true)
				self:Layout(false) 
			end,
		},
		BagWidth = {
			type = "input",
			name = L["背包框体宽度"],
			order = 4,
			get = function() return tostring(self.db.BagWidth) end,
			set = function(_, value) 
				self.db.BagWidth = tonumber(value) 
				self:Layout(false) 
			end,
		},
		BankWidth = {
			type = "input",
			name = L["银行框体宽度"],
			order = 5,
			get = function() return tostring(self.db.BankWidth) end,
			set = function(_, value) 
				self.db.BankWidth = tonumber(value) 
				self:Layout(true) 
			end,
		},
	}
	return options
end

function B:GetContainerFrame(arg)
	if type(arg) == "boolean" and arg == true then
		return self.BankFrame
	elseif type(arg) == "number" then
		if self.BankFrame then
			for _, bagID in ipairs(self.BankFrame.BagIDs) do
				if bagID == arg then
					return self.BankFrame
				end
			end
		end
	end
	return self.BagFrame
end

function B:Tooltip_Show()
	GameTooltip:SetOwner(self:GetParent(), "ANCHOR_TOP", 0, 4)
	GameTooltip:ClearLines()
	GameTooltip:AddLine(self.ttText)
	if self.ttText2 then
		GameTooltip:AddLine(" ")
		GameTooltip:AddDoubleLine(self.ttText2, self.ttText2desc, 1, 1, 1)
	end
	GameTooltip:Show()
end

function B:Tooltip_Hide()
	GameTooltip:Hide()
end

function B:DisableBlizzard()
	BankFrame:UnregisterAllEvents()
	for i=1, NUM_CONTAINER_FRAMES do
		_G["ContainerFrame"..i]:Kill()
	end
end

function B:SearchReset()
	SetItemSearch("")
end

function B:UpdateSearch()
	local MIN_REPEAT_CHARACTERS = 3
	local searchString = self:GetText()
	if (string.len(searchString) > MIN_REPEAT_CHARACTERS) then
		local repeatChar = true
		for i=1, MIN_REPEAT_CHARACTERS, 1 do
			if ( string.sub(searchString,(0-i), (0-i)) ~= string.sub(searchString,(-1-i),(-1-i)) ) then
				repeatChar = false
				break
			end
		end
		if ( repeatChar ) then
			B.ResetAndClear(self)
			return
		end
	end
	SetItemSearch(searchString)
end

function B:OpenEditbox()
	self.BagFrame.detail:Hide()
	self.BagFrame.editBox:Show()
	self.BagFrame.editBox:SetText(SEARCH)
	self.BagFrame.editBox:HighlightText()
end

function B:ResetAndClear()
	self:GetParent().detail:Show()
	self:ClearFocus()
	B:SearchReset()
end

function B:INVENTORY_SEARCH_UPDATE()
	for _, bagFrame in pairs(self.BagFrames) do
		for _, bagID in ipairs(bagFrame.BagIDs) do
			for slotID = 1, GetContainerNumSlots(bagID) do
				local _, _, _, _, _, _, _, isFiltered = GetContainerItemInfo(bagID, slotID)
				local button = bagFrame.Bags[bagID][slotID]
				
				if ( isFiltered ) then
					SetItemButtonDesaturated(button, 1);
					button:SetAlpha(0.4);
				else
					SetItemButtonDesaturated(button);
					button:SetAlpha(1);
				end
				
			end
		end
	end
	
	if(SunUIReagentBankFrameItem1) then
		for slotID=1, 98 do
			local _, _, _, _, _, _, _, isFiltered = GetContainerItemInfo(REAGENTBANK_CONTAINER, slotID);
			local button = _G["SunUIReagentBankFrameItem"..slotID]
			if ( isFiltered ) then
				SetItemButtonDesaturated(button, 1);
				button:SetAlpha(0.4);
			else
				SetItemButtonDesaturated(button);
				button:SetAlpha(1);
			end		
		end
	end
end

function B:UpdateSlot(bagID, slotID)
	if (self.Bags[bagID] and self.Bags[bagID].numSlots ~= GetContainerNumSlots(bagID)) or not self.Bags[bagID] or not self.Bags[bagID][slotID] then
		return
	end
	local slot = self.Bags[bagID][slotID]
	local bagType = self.Bags[bagID].type
	local texture, count, locked = GetContainerItemInfo(bagID, slotID)
	local clink = GetContainerItemLink(bagID, slotID)
	local specialType = select(2, GetContainerNumFreeSlots(bagID))
	slot:Show()
	if(slot.questIcon) then
		slot.questIcon:Hide();
	end
	slot.name, slot.rarity = nil, nil
	local start, duration, enable = GetContainerItemCooldown(bagID, slotID)
	if slot.cooldown then 
		CooldownFrame_SetTimer(slot.cooldown, start, duration, enable)
	end
	if ( duration > 0 and enable == 0 ) then
		SetItemButtonTextureVertexColor(slot, 0.4, 0.4, 0.4);
	else
		SetItemButtonTextureVertexColor(slot, 1, 1, 1);
	end
	if B.ProfessionColors[bagType] then
		slot.shadow:Show()
		slot.shadow:SetBackdropBorderColor(unpack(B.ProfessionColors[bagType]))
	else
		slot.shadow:Hide()
	end
	if (clink) then
		local iType, _
		slot.name, _, slot.rarity, _, _, iType = GetItemInfo(clink)
		if S:IsItemUnusable(clink) then
			SetItemButtonTextureVertexColor(slot, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
		else
			SetItemButtonTextureVertexColor(slot, 1, 1, 1)
		end
		local isQuestItem, questId, isActive = GetContainerItemQuestInfo(bagID, slotID)
		-- color slot according to item quality
		if questId and not isActive then
			slot:SetBackdropColor(0, 0, 0)
			slot.border:SetBackdropBorderColor(1, 0.8, 0.2)
			if(slot.questIcon) then
				slot.questIcon:Show();
			end
		elseif questId or isQuestItem then
			slot:SetBackdropColor(0, 0, 0)
			slot.border:SetBackdropBorderColor(1, 1, 0)
		elseif slot.rarity and slot.rarity > 1 then
			local r, g, b = GetItemQualityColor(slot.rarity)
			slot:SetBackdropColor(0, 0, 0)
			slot.border:SetBackdropBorderColor(r, g, b)
		else
			slot:SetBackdropColor(0, 0, 0, 0, 0)
			slot.border:SetBackdropBorderColor(0, 0, 0)
		end
	else
		--slot.iconTexture:SetAllPoints()
		--slot:StyleButton(true)
		slot:SetBackdropColor(0, 0, 0, 0)
		slot.border:SetBackdropBorderColor(0, 0, 0)
	end
	
	if(C_NewItems.IsNewItem(bagID, slotID)) then
		slot.shadow:Show()
		S:Flash(slot.shadow, 1, true)
	else
		slot.shadow:Hide()
		S:StopFlash(slot.shadow)
	end
	
	SetItemButtonTexture(slot, texture)
	SetItemButtonCount(slot, count)
	SetItemButtonDesaturated(slot, locked, 0.5, 0.5, 0.5)
end

function B:UpdateBagSlots(bagID)
	if(bagID == REAGENTBANK_CONTAINER) then
		for i=1, 98 do
			self:UpdateReagentSlot(i);
		end
	else
		for slotID = 1, GetContainerNumSlots(bagID) do
			if self.UpdateSlot then
				self:UpdateSlot(bagID, slotID);	
			else
				self:GetParent():GetParent():UpdateSlot(bagID, slotID);
			end
		end
	end
end

function B:UpdateCooldowns()
	for _, bagID in ipairs(self.BagIDs) do
		for slotID = 1, GetContainerNumSlots(bagID) do
			local start, duration, enable = GetContainerItemCooldown(bagID, slotID)
			CooldownFrame_SetTimer(self.Bags[bagID][slotID].cooldown, start, duration, enable)
			if ( duration > 0 and enable == 0 ) then
				SetItemButtonTextureVertexColor(self.Bags[bagID][slotID], 0.4, 0.4, 0.4);
			else
				SetItemButtonTextureVertexColor(self.Bags[bagID][slotID], 1, 1, 1);
			end					
		end
	end
end

function B:UpdateAllSlots()
	for _, bagID in ipairs(self.BagIDs) do
		if self.Bags[bagID] then
			self.Bags[bagID]:UpdateBagSlots(bagID)
		end
	end
end

function B:SetSlotAlphaForBag(f)
	for _, bagID in ipairs(f.BagIDs) do
		if f.Bags[bagID] then
			local numSlots = GetContainerNumSlots(bagID)
			for slotID = 1, numSlots do
				if f.Bags[bagID][slotID] then
					if bagID == self.id then
						f.Bags[bagID][slotID]:SetAlpha(1)
					else
						f.Bags[bagID][slotID]:SetAlpha(0.1)
					end
				end
			end
		end
	end
end

function B:ResetSlotAlphaForBags(f)
	for _, bagID in ipairs(f.BagIDs) do
		if f.Bags[bagID] then
			local numSlots = GetContainerNumSlots(bagID)
			for slotID = 1, numSlots do
				if f.Bags[bagID][slotID] then
					f.Bags[bagID][slotID]:SetAlpha(1)
				end
			end
		end
	end
end

function B:REAGENTBANK_PURCHASED()
	SunUIReagentBankFrame.cover:Hide()
end

function B:Layout(isBank)
	local A = S:GetModule("Skins")
	local f = self:GetContainerFrame(isBank)
	if not f then return end
	local buttonSize = isBank and self.db.BankSize or self.db.BagSize
	local buttonSpacing = self.db.Spacing
	local containerWidth = isBank and self.db.BankWidth or self.db.BagWidth
	local numContainerColumns = math.floor(containerWidth / (buttonSize + buttonSpacing))
	local holderWidth = ((buttonSize + buttonSpacing) * numContainerColumns) - buttonSpacing
	local numContainerRows = 0
	local bottomPadding = (containerWidth - holderWidth) / 2
	f.holderFrame:SetWidth(holderWidth)
	
	if(isBank) then
		f.reagentFrame:Width(holderWidth)
	end
	
	f.totalSlots = 0
	local lastButton
	local lastRowButton
	local lastContainerButton
	local numContainerSlots, fullContainerSlots = GetNumBankSlots()
	for i, bagID in ipairs(f.BagIDs) do
		--Bag Containers
		if (not isBank and bagID <= 3 ) or (isBank and bagID ~= -1 and numContainerSlots >= 1 and not (i - 1 > numContainerSlots)) then
			if not f.ContainerHolder[i] then
				if isBank then
					f.ContainerHolder[i] = CreateFrame("CheckButton", "SunUIBankBag" .. bagID - 4, f.ContainerHolder, "BankItemButtonBagTemplate")
				else
					f.ContainerHolder[i] = CreateFrame("CheckButton", "SunUIMainBag" .. bagID .. "Slot", f.ContainerHolder, "BagSlotButtonTemplate")
				end
				f.ContainerHolder[i]:StyleButton(true)
				f.ContainerHolder[i]:SetNormalTexture("")
				f.ContainerHolder[i]:SetCheckedTexture(nil)
				f.ContainerHolder[i]:SetPushedTexture("")
				f.ContainerHolder[i]:SetScript("OnClick", nil)
				f.ContainerHolder[i].id = isBank and bagID or bagID + 1
				f.ContainerHolder[i]:HookScript("OnEnter", function(self) B.SetSlotAlphaForBag(self, f) end)
				f.ContainerHolder[i]:HookScript("OnLeave", function(self) B.ResetSlotAlphaForBags(self, f) end)
				if isBank then
					f.ContainerHolder[i]:SetID(bagID - 4)
					if not f.ContainerHolder[i].tooltipText then
						f.ContainerHolder[i].tooltipText = ""
					end
				end
				f.ContainerHolder[i].iconTexture = _G[f.ContainerHolder[i]:GetName().."IconTexture"]
				f.ContainerHolder[i].iconTexture:SetInside()
				f.ContainerHolder[i].iconTexture:SetTexCoord(.08, .92, .08, .92)
				if not f.ContainerHolder[i].border then
					local border = CreateFrame("Frame", nil, f.ContainerHolder[i])
					border:SetAllPoints()
					border:SetFrameLevel(f.ContainerHolder[i]:GetFrameLevel()+1)
					f.ContainerHolder[i].border = border
					f.ContainerHolder[i].border:CreateBorder()
					A:CreateBackdropTexture(f.ContainerHolder[i], 0.6)
				end
			end
			f.ContainerHolder:SetSize(((buttonSize + buttonSpacing) * (isBank and i - 1 or i)) + buttonSpacing,buttonSize + (buttonSpacing * 2))
			if isBank then
				BankFrameItemButton_Update(f.ContainerHolder[i])
				BankFrameItemButton_UpdateLocked(f.ContainerHolder[i])
			end
			f.ContainerHolder[i]:SetSize(buttonSize, buttonSize)
			f.ContainerHolder[i]:ClearAllPoints()
			if (isBank and i == 2) or (not isBank and i == 1) then
				f.ContainerHolder[i]:SetPoint("BOTTOMLEFT", f.ContainerHolder, "BOTTOMLEFT", buttonSpacing, buttonSpacing)
			else
				f.ContainerHolder[i]:SetPoint("LEFT", lastContainerButton, "RIGHT", buttonSpacing, 0)
			end
			lastContainerButton = f.ContainerHolder[i]
		end
		--Bag Slots
		local numSlots = GetContainerNumSlots(bagID)
		if numSlots > 0 then
			if not f.Bags[bagID] then
				f.Bags[bagID] = CreateFrame("Frame", f:GetName().."Bag"..bagID, f.holderFrame)
				f.Bags[bagID]:SetID(bagID)
				f.Bags[bagID].UpdateBagSlots = B.UpdateBagSlots
				f.Bags[bagID].UpdateSlot = UpdateSlot
			end
			f.Bags[bagID].numSlots = numSlots
			f.Bags[bagID].type = select(2, GetContainerNumFreeSlots(bagID))
			--Hide unused slots
			for i = 1, MAX_CONTAINER_ITEMS do
				if f.Bags[bagID][i] then
					f.Bags[bagID][i]:Hide()
				end
			end
			for slotID = 1, numSlots do
				f.totalSlots = f.totalSlots + 1
				if not f.Bags[bagID][slotID] then
					f.Bags[bagID][slotID] = CreateFrame("CheckButton", f.Bags[bagID]:GetName().."Slot"..slotID, f.Bags[bagID], bagID == -1 and "BankItemButtonGenericTemplate" or "ContainerFrameItemButtonTemplate")
					f.Bags[bagID][slotID]:SetBackdrop({
						bgFile = S["media"].blank, 
						insets = { left = -S.mult, right = -S.mult, top = -S.mult, bottom = -S.mult }
					})
					if not f.Bags[bagID][slotID].border then
						local border = CreateFrame("Frame", nil, f.Bags[bagID][slotID])
						border:SetAllPoints()
						border:SetFrameLevel(f.Bags[bagID][slotID]:GetFrameLevel()+1)
						f.Bags[bagID][slotID].border = border
						f.Bags[bagID][slotID].border:CreateBorder()
						A:CreateBackdropTexture(f.Bags[bagID][slotID], 0.6)
					end
					if not f.Bags[bagID][slotID].shadow then
						local shadow = CreateFrame("Frame", nil, f.Bags[bagID][slotID])
						shadow:SetOutside(f.Bags[bagID][slotID], 3, 3)
						shadow:SetFrameLevel(0)
						f.Bags[bagID][slotID].shadow = shadow
						f.Bags[bagID][slotID].shadow:SetBackdrop( { 
							edgeFile = S["media"].glow,
							edgeSize = S:Scale(3),
							insets = {left = S:Scale(3), right = S:Scale(3), top = S:Scale(3), bottom = S:Scale(3)},
						})
						f.Bags[bagID][slotID].shadow:SetBackdropColor(0, 0, 0)
						f.Bags[bagID][slotID].shadow:Hide()
					end
					f.Bags[bagID][slotID]:StyleButton(true)
					f.Bags[bagID][slotID]:SetNormalTexture(nil)
					f.Bags[bagID][slotID]:SetCheckedTexture(nil)
					if(_G[f.Bags[bagID][slotID]:GetName().."NewItemTexture"]) then
						_G[f.Bags[bagID][slotID]:GetName().."NewItemTexture"]:Hide()
					end
					f.Bags[bagID][slotID].Count:ClearAllPoints()
					f.Bags[bagID][slotID].Count:SetPoint("BOTTOMRIGHT", 0, 2)
					f.Bags[bagID][slotID].Count:SetFont(S["media"].font, S["media"].fontsize, "OUTLINE")
					if(f.Bags[bagID][slotID].questIcon) then
						f.Bags[bagID][slotID].questIcon = _G[f.Bags[bagID][slotID]:GetName().."IconQuestTexture"]
						f.Bags[bagID][slotID].questIcon:SetTexture(TEXTURE_ITEM_QUEST_BANG)
						f.Bags[bagID][slotID].questIcon:SetAllPoints(f.Bags[bagID][slotID])
						f.Bags[bagID][slotID].questIcon:SetTexCoord(.08, .92, .08, .92)
						f.Bags[bagID][slotID].questIcon:Hide()
					end
					
					f.Bags[bagID][slotID].iconTexture = _G[f.Bags[bagID][slotID]:GetName().."IconTexture"]
					f.Bags[bagID][slotID].iconTexture:SetTexCoord(.08, .92, .08, .92)
					
					f.Bags[bagID][slotID].cooldown = _G[f.Bags[bagID][slotID]:GetName().."Cooldown"]
			
					f.Bags[bagID][slotID].bagID = bagID
					f.Bags[bagID][slotID].slotID = slotID
					
					if(f.Bags[bagID][slotID].BattlepayItemTexture) then
						f.Bags[bagID][slotID].BattlepayItemTexture:Hide()
					end
				end
				f.Bags[bagID][slotID]:SetID(slotID)
				f.Bags[bagID][slotID]:SetSize(buttonSize, buttonSize)
				f:UpdateSlot(bagID, slotID)
				if f.Bags[bagID][slotID]:GetPoint() then
					f.Bags[bagID][slotID]:ClearAllPoints()
				end
				if lastButton then
					if (f.totalSlots - 1) % numContainerColumns == 0 then
						f.Bags[bagID][slotID]:SetPoint("TOP", lastRowButton, "BOTTOM", 0, -buttonSpacing)
						lastRowButton = f.Bags[bagID][slotID]
						numContainerRows = numContainerRows + 1
					else
						f.Bags[bagID][slotID]:SetPoint("LEFT", lastButton, "RIGHT", buttonSpacing, 0)
					end
				else
					f.Bags[bagID][slotID]:SetPoint("TOPLEFT", f.holderFrame, "TOPLEFT")
					lastRowButton = f.Bags[bagID][slotID]
					numContainerRows = numContainerRows + 1
				end
				lastButton = f.Bags[bagID][slotID]
			end
		else
			--Hide unused slots
			for i = 1, MAX_CONTAINER_ITEMS do
				if f.Bags[bagID] and f.Bags[bagID][i] then
					f.Bags[bagID][i]:Hide()
				end
			end
			if f.Bags[bagID] then
				f.Bags[bagID].numSlots = numSlots
			end
			if self.isBank then
				if self.ContainerHolder[i] then
					BankFrameItemButton_Update(self.ContainerHolder[i])
					BankFrameItemButton_UpdateLocked(self.ContainerHolder[i])
				end
			end
		end
	end
	
	if(isBank and f.reagentFrame:IsShown()) then
		if(not IsReagentBankUnlocked()) then		
			f.reagentFrame.cover:Show();
			B:RegisterEvent("REAGENTBANK_PURCHASED")
		else
			f.reagentFrame.cover:Hide();
		end		


		local totalSlots = 0
		local lastRowButton
		numContainerRows = 1
		for i = 1, 98 do
			totalSlots = totalSlots + 1;

			if(not f.reagentFrame.slots[i]) then
				f.reagentFrame.slots[i] = CreateFrame("Button", "SunUIReagentBankFrameItem"..i, f.reagentFrame, "ReagentBankItemButtonGenericTemplate");
				f.reagentFrame.slots[i]:SetID(i)

				f.reagentFrame.slots[i]:StyleButton(true)
				f.reagentFrame.slots[i]:SetNormalTexture(nil);
				
				if not f.reagentFrame.slots[i].border then
					local border = CreateFrame("Frame", nil, f.reagentFrame.slots[i])
					border:SetAllPoints()
					border:SetFrameLevel(f.reagentFrame.slots[i]:GetFrameLevel()+1)
					f.reagentFrame.slots[i].border = border
					f.reagentFrame.slots[i].border:CreateBorder()
					A:CreateBackdropTexture(f.reagentFrame.slots[i], 0.6)
				end
				if not f.reagentFrame.slots[i].shadow then
					local shadow = CreateFrame("Frame", nil, f.reagentFrame.slots[i])
					shadow:SetOutside(f.reagentFrame.slots[i], 3, 3)
					shadow:SetFrameLevel(0)
					f.reagentFrame.slots[i].shadow = shadow
					f.reagentFrame.slots[i].shadow:SetBackdrop( { 
						edgeFile = S["media"].glow,
						edgeSize = S:Scale(3),
						insets = {left = S:Scale(3), right = S:Scale(3), top = S:Scale(3), bottom = S:Scale(3)},
					})
					f.reagentFrame.slots[i].shadow:SetBackdropColor(0, 0, 0)
					f.reagentFrame.slots[i].shadow:Hide()
				end
				
				
				f.reagentFrame.slots[i].Count:ClearAllPoints();
				f.reagentFrame.slots[i].Count:SetPoint('BOTTOMRIGHT', 0, 2);

				f.reagentFrame.slots[i].iconTexture = _G[f.reagentFrame.slots[i]:GetName()..'IconTexture'];
				f.reagentFrame.slots[i].iconTexture:SetTexCoord(.08, .92, .08, .92);
				f.reagentFrame.slots[i].IconBorder:SetAlpha(0)	
				f.reagentFrame.slots[i]:SetScript("OnClick", BankFrameItemButtonGeneric_OnClick)
				--f.reagentFrame.slots[i]:CreateShadow()
				--f.reagentFrame.slots[i].shadow:Hide()
			end

			f.reagentFrame.slots[i]:ClearAllPoints()
			f.reagentFrame.slots[i]:Size(buttonSize)
			if(f.reagentFrame.slots[i-1]) then
				if(totalSlots - 1) % numContainerColumns == 0 then
					f.reagentFrame.slots[i]:SetPoint('TOP', lastRowButton, 'BOTTOM', 0, -buttonSpacing);
					lastRowButton = f.reagentFrame.slots[i];
					numContainerRows = numContainerRows + 1;
				else
					f.reagentFrame.slots[i]:SetPoint('LEFT', f.reagentFrame.slots[i-1], 'RIGHT', buttonSpacing, 0);
				end
			else
				f.reagentFrame.slots[i]:SetPoint('TOPLEFT', f.reagentFrame, 'TOPLEFT');
				lastRowButton = f.reagentFrame.slots[i]
			end			

			self:UpdateReagentSlot(i)
		end	
	end
	
	
	
	
	f:SetSize(containerWidth, (((buttonSize + buttonSpacing) * numContainerRows) - buttonSpacing) + f.topOffset + f.bottomOffset); -- 8 is the cussion of the f.holderFrame
end

function B:UpdateReagentSlot(slotID)
	assert(slotID)
	local bagID = REAGENTBANK_CONTAINER
	local texture, count, locked = GetContainerItemInfo(bagID, slotID);
	local clink = GetContainerItemLink(bagID, slotID);
	local slot = _G["SunUIReagentBankFrameItem"..slotID]

	slot:Show();
	if(slot.questIcon) then
		slot.questIcon:Hide();
	end

	slot.name, slot.rarity = nil, nil;
	
	local start, duration, enable = GetContainerItemCooldown(bagID, slotID)
	CooldownFrame_SetTimer(slot.Cooldown, start, duration, enable)
	if ( duration > 0 and enable == 0 ) then
		SetItemButtonTextureVertexColor(slot, 0.4, 0.4, 0.4);
	else
		SetItemButtonTextureVertexColor(slot, 1, 1, 1);
	end				
	
	if B.ProfessionColors[bagType] then
		slot:SetBackdropBorderColor(unpack(B.ProfessionColors[bagType]))
	elseif (clink) then
		local iType;
		slot.name, _, slot.rarity, _, _, iType = GetItemInfo(clink);
		
		local isQuestItem, questId, isActiveQuest = GetContainerItemQuestInfo(bagID, slotID);
		local r, g, b

		if(slot.rarity) then
			r, g, b = GetItemQualityColor(slot.rarity);
			slot.shadow:SetBackdropBorderColor(r, g, b);
		end

		-- color slot according to item quality
		if questId and not isActive then
			slot:SetBackdropBorderColor(1.0, 0.3, 0.3);
			slot.questIcon:Show();
		elseif questId or isQuestItem then
			slot:SetBackdropBorderColor(1.0, 0.3, 0.3);
		elseif slot.rarity and slot.rarity > 1 then
			slot:SetBackdropBorderColor(r, g, b);
		else
			slot:SetBackdropBorderColor(unpack(S["media"].bordercolor));
		end
	else
		slot:SetBackdropBorderColor(unpack(S["media"].bordercolor));
	end

	if(C_NewItems.IsNewItem(bagID, slotID)) then
		slot.shadow:Show()
		S:Flash(slot.shadow, 1, true)
	else
		slot.shadow:Hide()
		S:StopFlash(slot.shadow)
	end
	
	SetItemButtonTexture(slot, texture);
	SetItemButtonCount(slot, count);
	SetItemButtonDesaturated(slot, locked, 0.5, 0.5, 0.5);	
end

function B:UpdateAll()
	if self.BagFrame then
		self:Layout()
	end
	if self.BankFrame then
		self:Layout(true)
	end
end

function B:OnEvent(event, ...)
	if event == "ITEM_LOCK_CHANGED" or event == "ITEM_UNLOCKED" then
		local bag, slot = ...
		if bag == REAGENTBANK_CONTAINER then
			B:UpdateReagentSlot(slot);
		else
			self:UpdateSlot(...);
		end
	elseif event == "BAG_UPDATE" then
		for _, bagID in ipairs(self.BagIDs) do
			local numSlots = GetContainerNumSlots(bagID)
			if (not self.Bags[bagID] and numSlots ~= 0) or (self.Bags[bagID] and numSlots ~= self.Bags[bagID].numSlots) then
				B:Layout(self.isBank)
				return
			end
		end
		self:UpdateBagSlots(...)
	elseif event == "BAG_UPDATE_COOLDOWN" then
		self:UpdateCooldowns()
	elseif event == "PLAYERBANKSLOTS_CHANGED" then
		self:UpdateAllSlots()
	elseif event == 'PLAYERREAGENTBANKSLOTS_CHANGED' then
		B:UpdateReagentSlot(...)
	end
end

function B:UpdateTokens()
	local f = self.BagFrame
	local numTokens = 0
	for i = 1, MAX_WATCHED_TOKENS do
		local name, count, icon, currencyID = GetBackpackCurrencyInfo(i)
		local button = f.currencyButton[i]
		button:ClearAllPoints()
		if name then
			button.icon:SetTexture(icon)
			button.text:SetText(name..": "..count)
			button.currencyID = currencyID
			button:Show()
			numTokens = numTokens + 1
		else
			button:Hide()
		end
	end
	if numTokens == 0 then
		f.bottomOffset = 8
		if f.currencyButton:IsShown() then
			f.currencyButton:Hide()
			self:Layout()
		end
		return
	elseif not f.currencyButton:IsShown() then
		f.bottomOffset = 28
		f.currencyButton:Show()
		self:Layout()
	end
	f.bottomOffset = 28
	if numTokens == 1 then
		f.currencyButton[1]:SetPoint("BOTTOM", f.currencyButton, "BOTTOM", -(f.currencyButton[1].text:GetWidth() / 2), 3)
	elseif numTokens == 2 then
		f.currencyButton[1]:SetPoint("BOTTOM", f.currencyButton, "BOTTOM", -(f.currencyButton[1].text:GetWidth()) - (f.currencyButton[1]:GetWidth() / 2), 3)
		f.currencyButton[2]:SetPoint("BOTTOMLEFT", f.currencyButton, "BOTTOM", f.currencyButton[2]:GetWidth() / 2, 3)
	else
		f.currencyButton[1]:SetPoint("BOTTOMLEFT", f.currencyButton, "BOTTOMLEFT", 3, 3)
		f.currencyButton[2]:SetPoint("BOTTOM", f.currencyButton, "BOTTOM", -(f.currencyButton[2].text:GetWidth() / 3), 3)
		f.currencyButton[3]:SetPoint("BOTTOMRIGHT", f.currencyButton, "BOTTOMRIGHT", -(f.currencyButton[3].text:GetWidth()) - (f.currencyButton[3]:GetWidth() / 2), 3)
	end
end

function B:Token_OnEnter()
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:SetBackpackToken(self:GetID())
end

function B:Token_OnClick()
	if ( IsModifiedClick("CHATLINK") ) then
		HandleModifiedItemClick(GetCurrencyLink(self.currencyID))
	end
end

function B:UpdateGoldText()
	self.BagFrame.goldText:SetText(GetCoinTextureString(GetMoney(), 12))
end

function B:ContructContainerFrame(name, isBank)
	local A = S:GetModule("Skins")
	local f = CreateFrame("Button", name, UIParent)
	A:SetBD(f)
	f:SetFrameStrata("DIALOG")
	f.UpdateSlot = B.UpdateSlot
	f.UpdateAllSlots = B.UpdateAllSlots
	f.UpdateBagSlots = B.UpdateBagSlots
	f.UpdateCooldowns = B.UpdateCooldowns
	f:RegisterEvent("ITEM_LOCK_CHANGED")
	f:RegisterEvent("ITEM_UNLOCKED")
	f:RegisterEvent("BAG_UPDATE_COOLDOWN")
	f:RegisterEvent("BAG_UPDATE")
	f:RegisterEvent("QUEST_ACCEPTED")
	f:RegisterUnitEvent("UNIT_QUEST_LOG_CHANGED", "player")
	f:RegisterEvent("PLAYERBANKSLOTS_CHANGED")
	f:SetMovable(true)
	f:RegisterForDrag("LeftButton", "RightButton")
	f:RegisterForClicks("AnyUp")
	f:SetScript("OnDragStart", function(self) self:StartMoving() end)
	f:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
	f:SetScript("OnClick", function(self) if IsControlKeyDown() then B:PositionBagFrames() end end)
	f:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	f.isBank = isBank
	f:SetScript("OnEvent", B.OnEvent)
	f:Hide()
	f.bottomOffset = isBank and 8 or 28
	f.topOffset = isBank and 45 or 50
	f.BagIDs = isBank and {-1, 5, 6, 7, 8, 9, 10, 11} or {0, 1, 2, 3, 4}
	f.Bags = {}
	f.closeButton = CreateFrame("Button", name.."CloseButton", f, "UIPanelCloseButton")
	f.closeButton:SetPoint("TOPRIGHT", -4, -4)
	A:ReskinClose(f.closeButton)
	f.holderFrame = CreateFrame("Frame", nil, f)
	f.holderFrame:SetPoint("TOP", f, "TOP", 0, -f.topOffset)
	f.holderFrame:SetPoint("BOTTOM", f, "BOTTOM", 0, 8)
	f.ContainerHolder = CreateFrame("Button", name.."ContainerHolder", f)
	f.ContainerHolder:SetPoint("BOTTOMLEFT", f, "TOPLEFT", 0, 1)
	A:CreateBD(f.ContainerHolder)
	f.ContainerHolder:Hide()
	if isBank then
		f.reagentFrame = CreateFrame("Frame", "SunUIReagentBankFrame", f);
		f.reagentFrame:SetPoint('TOP', f, 'TOP', 0, -f.topOffset);
		f.reagentFrame:SetPoint('BOTTOM', f, 'BOTTOM', 0, 8);	
		f.reagentFrame.slots = {}
		f.reagentFrame:SetID(REAGENTBANK_CONTAINER)
		f.reagentFrame:Hide()

		f.reagentFrame.cover = CreateFrame("Button", nil, f.reagentFrame)
		f.reagentFrame.cover:SetAllPoints(f.reagentFrame)
		--f.reagentFrame.cover:SetTemplate("Default", true)
		f.reagentFrame.cover:SetFrameStrata("FULLSCREEN_DIALOG")

		f.reagentFrame.cover.purchaseButton = CreateFrame("Button", nil, f.reagentFrame.cover)
		f.reagentFrame.cover.purchaseButton:Height(20)
		f.reagentFrame.cover.purchaseButton:Width(150)
		f.reagentFrame.cover.purchaseButton:SetPoint('CENTER', f.reagentFrame.cover, 'CENTER')
		f.reagentFrame.cover.purchaseButton:SetFrameLevel(f.reagentFrame.cover.purchaseButton:GetFrameLevel() + 2)
		--f.reagentFrame.cover.purchaseButton:SetTemplate('Default', true)
		f.reagentFrame.cover.purchaseButton.text = f.reagentFrame.cover.purchaseButton:CreateFontString(nil, 'OVERLAY')
		f.reagentFrame.cover.purchaseButton.text:FontTemplate()
		f.reagentFrame.cover.purchaseButton.text:SetPoint('CENTER')
		f.reagentFrame.cover.purchaseButton.text:SetJustifyH('CENTER')
		f.reagentFrame.cover.purchaseButton.text:SetText(PURCHASE)
		f.reagentFrame.cover.purchaseButton:SetScript("OnEnter", self.Tooltip_Show)
		f.reagentFrame.cover.purchaseButton:SetScript("OnLeave", self.Tooltip_Hide)
		f.reagentFrame.cover.purchaseButton:SetScript("OnClick", function()
			PlaySound("igMainMenuOption");
			StaticPopup_Show("CONFIRM_BUY_REAGENTBANK_TAB");
		end)

		f.reagentFrame.cover.purchaseText = f.reagentFrame.cover:CreateFontString(nil, 'OVERLAY')
		f.reagentFrame.cover.purchaseText:FontTemplate()
		f.reagentFrame.cover.purchaseText:SetPoint("BOTTOM", f.reagentFrame.cover.purchaseButton, "TOP", 0, 10)
		f.reagentFrame.cover.purchaseText:SetText(REAGENTBANK_PURCHASE_TEXT)
	
		--Bag Text
		f.bagText = f:CreateFontString(nil, 'OVERLAY')
		f.bagText:FontTemplate()
		f.bagText:SetPoint('TOPRIGHT', f, 'TOPRIGHT', -25, -4)
		f.bagText:SetJustifyH("RIGHT")	
		f.bagText:SetText(BANK)	
		
		--Sort Button
		f.sortButton = CreateFrame("Button", nil, f)
		f.sortButton:SetPoint("TOPLEFT", f, "TOPLEFT", 14, -4)
		f.sortButton:SetSize(55, 10)
		f.sortButton.ttText = L["整理背包"]
		f.sortButton.ttText2 = L["整理背包"]
		f.sortButton.ttText2desc = "左键逆向,右键正向"
		f.sortButton:SetScript("OnEnter", self.Tooltip_Show)
		f.sortButton:SetScript("OnLeave", self.Tooltip_Hide)
		f.sortButton:SetScript('OnMouseDown', function(self, button) 
			if InCombatLockdown() then return end
			if button == "RightButton" then JPack:Pack(nil, 1) else JPack:Pack(nil, 2) end 
		end)
		A:Reskin(f.sortButton)

		--Toggle Bags Button
		f.bagsButton = CreateFrame("Button", nil, f)
		f.bagsButton:SetPoint("LEFT", f.sortButton, "RIGHT", 3, 0)
		f.bagsButton:SetSize(55, 10)
		f.bagsButton.ttText = BAGSLOTTEXT
		f.bagsButton:SetScript("OnEnter", self.Tooltip_Show)
		f.bagsButton:SetScript("OnLeave", self.Tooltip_Hide)
		f.bagsButton:SetScript("OnClick", function()
		local numSlots, full = GetNumBankSlots()
			if numSlots >= 1 then
				ToggleFrame(f.ContainerHolder)
			else
				StaticPopup_Show("NO_BANK_BAGS")
			end
		end)
		A:Reskin(f.bagsButton)
		f:SetScript("OnHide", CloseBankFrame)
		
		f.purchaseBagButton = CreateFrame("Button", nil, f)
		f.purchaseBagButton:SetSize(55, 10)
		f.purchaseBagButton:SetPoint("LEFT", f.bagsButton, "RIGHT", 3, 0)
		f.purchaseBagButton:SetFrameLevel(f.purchaseBagButton:GetFrameLevel() + 2)
		f.purchaseBagButton.ttText = PURCHASE
		f.purchaseBagButton:SetScript("OnEnter", self.Tooltip_Show)
		f.purchaseBagButton:SetScript("OnLeave", self.Tooltip_Hide)
		f.purchaseBagButton:SetScript("OnClick", function()
			local _, full = GetNumBankSlots()
			if not full then
				StaticPopup_Show("BUY_BANK_SLOT")
			else
				StaticPopup_Show("CANNOT_BUY_BANK_SLOT")
			end
		end)
		A:Reskin(f.purchaseBagButton)
		
		f.reagentToggle = CreateFrame("Button", name..'ReagentButton', f);
		f.reagentToggle:SetSize(55, 10)
		f.reagentToggle:SetPoint("LEFT", f.purchaseBagButton, "RIGHT", 3, 0)
		A:Reskin(f.reagentToggle)
		f.reagentToggle.ttText = REAGENT_BANK;
		f.reagentToggle:SetScript("OnEnter", self.Tooltip_Show)
		f.reagentToggle:SetScript("OnLeave", self.Tooltip_Hide)
		f.reagentToggle:SetScript("OnClick", function()
			PlaySound("igCharacterInfoTab");
			if f.holderFrame:IsShown() then
				BankFrame.selectedTab = 2
				f.holderFrame:Hide()
				f.reagentFrame:Show()
				--f.editBox:SetPoint('RIGHT', f.depositButton, 'LEFT', -5, 0);
				f.bagText:SetText(REAGENT_BANK)
			else
				BankFrame.selectedTab = 1
				f.reagentFrame:Hide()
				f.holderFrame:Show()
				--f.editBox:SetPoint('TOPLEFT', f.sortButton, 'BOTTOMLEFT', 0, -5);
				f.bagText:SetText(BANK)
			end

			self:Layout(true)
			f:Show()
		end)
		A:Reskin(f.reagentToggle)
	else
		--Gold Text
		f.goldText = f:CreateFontString(nil, "OVERLAY")
		f.goldText:FontTemplate()
		f.goldText:SetPoint("BOTTOMRIGHT", f.holderFrame, "TOPRIGHT", -2, 4)
		f.goldText:SetJustifyH("RIGHT")
		--Search
		f.editBox = CreateFrame("EditBox", name.."EditBox", f)
		f.editBox:SetFrameLevel(f.editBox:GetFrameLevel() + 2)
		f.editBox:SetHeight(15)
		f.editBox:Hide()
		f.editBox:SetPoint("BOTTOMLEFT", f.holderFrame, "TOPLEFT", 3, 4)
		f.editBox:SetPoint("RIGHT", f.goldText, "LEFT", -5, 0)
		f.editBox:SetAutoFocus(true)
		f.editBox:SetScript("OnEscapePressed", self.ResetAndClear)
		f.editBox:SetScript("OnEnterPressed", self.ResetAndClear)
		f.editBox:SetScript("OnEditFocusLost", f.editBox.Hide)
		f.editBox:SetScript("OnEditFocusGained", f.editBox.HighlightText)
		f.editBox:SetScript("OnTextChanged", self.UpdateSearch)
		f.editBox:SetScript("OnChar", self.UpdateSearch)
		f.editBox:SetText(SEARCH)
		f.editBox:SetFont(S["media"].font, S["media"].fontsize, "OUTLINE")
		f.editBox:SetShadowColor(0, 0, 0)
		f.editBox:SetShadowOffset(1.25, -1.25)
		f.editBox.border = CreateFrame("Frame", nil, f.editBox)
		f.editBox.border:SetPoint("TOPLEFT", -3, 0)
		f.editBox.border:SetPoint("BOTTOMRIGHT", 0, 0)
		A:CreateBD(f.editBox.border, 0)
		f.detail = f:CreateFontString(nil, "OVERLAY")
		f.detail:FontTemplate()
		f.detail:SetAllPoints(f.editBox)
		f.detail:SetJustifyH("LEFT")
		f.detail:SetText(SEARCH)
		local button = CreateFrame("Button", nil, f)
		button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
		button:SetAllPoints(f.detail)
		button:SetScript("OnClick", function(f, btn)
			if btn == "RightButton" then
				self:OpenEditbox()
			else
				if f:GetParent().editBox:IsShown() then
					f:GetParent().editBox:Hide()
					f:GetParent().editBox:ClearFocus()
					f:GetParent().detail:Show()
					self:SearchReset()
				else
					self:OpenEditbox()
				end
			end
		end)
		--Sort Button
		f.sortButton = CreateFrame("Button", nil, f)
		f.sortButton:SetPoint("TOPLEFT", f, "TOPLEFT", 14, -4)
		f.sortButton:SetSize(55, 10)
		f.sortButton.ttText = L["整理背包"]
		f.sortButton.ttText2 = L["整理背包"]
		f.sortButton.ttText2desc = L["左键逆向,右键正向"]
		f.sortButton:SetScript("OnEnter", self.Tooltip_Show)
		f.sortButton:SetScript("OnLeave", self.Tooltip_Hide)
		f.sortButton:SetScript('OnMouseDown', function(self, button) 
			if button == "RightButton" then JPack:Pack(nil, 1) else JPack:Pack(nil, 2) end 
		end)
		A:Reskin(f.sortButton)
		
		--Bags Button
		f.bagsButton = CreateFrame("Button", nil, f)
		f.bagsButton:SetPoint("LEFT", f.sortButton, "RIGHT", 3, 0)
		f.bagsButton:SetSize(55, 10)
		f.bagsButton.ttText = BAGSLOTTEXT
		f.bagsButton:SetScript("OnEnter", self.Tooltip_Show)
		f.bagsButton:SetScript("OnLeave", self.Tooltip_Hide)
		f.bagsButton:SetScript("OnClick", function() ToggleFrame(f.ContainerHolder) end)
		A:Reskin(f.bagsButton)

		--Currency
		f.currencyButton = CreateFrame("Frame", nil, f)
		f.currencyButton:SetPoint("BOTTOM", 0, 1)
		f.currencyButton:SetPoint("TOPLEFT", f.holderFrame, "BOTTOMLEFT", 0, 18)
		f.currencyButton:SetPoint("TOPRIGHT", f.holderFrame, "BOTTOMRIGHT", 0, 18)
		f.currencyButton:SetHeight(22)
		for i = 1, MAX_WATCHED_TOKENS do
			f.currencyButton[i] = CreateFrame("Button", nil, f.currencyButton)
			f.currencyButton[i]:SetSize(16, 16)
			f.currencyButton[i]:SetID(i)
			f.currencyButton[i].icon = f.currencyButton[i]:CreateTexture(nil, "OVERLAY")
			A:CreateBD(f.currencyButton[i])
			f.currencyButton[i].icon:SetInside(nil, 1, 1)
			f.currencyButton[i].icon:SetTexCoord(.08, .92, .08, .92)
			f.currencyButton[i].text = f.currencyButton[i]:CreateFontString(nil, "OVERLAY")
			f.currencyButton[i].text:SetPoint("LEFT", f.currencyButton[i], "RIGHT", 2, 0)
			f.currencyButton[i].text:SetFont(S["media"].font, S["media"].fontsize, "OUTLINE")
			f.currencyButton[i].text:SetShadowColor(0, 0, 0)
			f.currencyButton[i].text:SetShadowOffset(1.25, -1.25)
			f.currencyButton[i]:SetScript("OnEnter", B.Token_OnEnter)
			f.currencyButton[i]:SetScript("OnLeave", function() GameTooltip:Hide() end)
			f.currencyButton[i]:SetScript("OnClick", B.Token_OnClick)
			f.currencyButton[i]:Hide()
		end
		f:SetScript("OnHide", CloseAllBags)
	end
	tinsert(UISpecialFrames, f:GetName()) --Keep an eye on this for taints..
	table.insert(self.BagFrames, f)
	return f
end

function B:PositionBagFrames()
	if self.BagFrame then
		self.BagFrame:ClearAllPoints()
		self.BagFrame:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -55, 30)
	end
	if self.BankFrame then
		self.BankFrame:ClearAllPoints()
		self.BankFrame:SetPoint("BOTTOMRIGHT", self.BagFrame, "BOTTOMLEFT", -30, 0)
	end
end

function B:ToggleBags(id)
	if id and GetContainerNumSlots(id) == 0 then return end --Closes a bag when inserting a new container..
	if self.BagFrame:IsShown() then
		self:CloseBags()
	else
		self:OpenBags()
	end
end

function B:ToggleBackpack()
	if ( IsOptionFrameOpen() ) then
		return
	end
	if IsBagOpen(0) then
		self:OpenBags()
	else
		self:CloseBags()
	end
end

function B:OpenBags()
	self.BagFrame:Show()
	self.BagFrame:UpdateAllSlots()
end

function B:CloseBags()
	self.BagFrame:Hide()
	if self.BankFrame then
		self.BankFrame:Hide()
	end
end

function B:OpenBank()
	if not self.BankFrame then
		self.BankFrame = self:ContructContainerFrame("SunUI_Bank", true)
		self:PositionBagFrames()
	end
	self:Layout(true)
	
	self.BankFrame:Show()
	self.BankFrame:UpdateAllSlots()
	self.BagFrame:Show()
	self:UpdateTokens()
end

function B:PLAYERBANKBAGSLOTS_CHANGED()
	self:Layout(true)
end

function B:CloseBank()
	if not self.BankFrame then return end -- WHY???, WHO KNOWS!
	self.BankFrame:Hide()
end

function B:PLAYER_ENTERING_WORLD()
	ToggleBackpack()
	ToggleBackpack()
	self:UpdateGoldText()
end

function B:Initialize()
	S.bags = self
	self.BagFrames = {}
	self.BagFrame = self:ContructContainerFrame("SunUI_Bags")
	self:SecureHook("OpenAllBags", "OpenBags")
	self:SecureHook("CloseAllBags", "CloseBags")
	self:SecureHook("ToggleBag", "ToggleBags")
	self:SecureHook("ToggleAllBags", "ToggleBackpack")
	self:SecureHook("ToggleBackpack")
	self:SecureHook("BackpackTokenFrame_Update", "UpdateTokens")
	self:PositionBagFrames()
	self:Layout()
	self:DisableBlizzard()
	self:RegisterEvent("INVENTORY_SEARCH_UPDATE")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("PLAYER_MONEY", "UpdateGoldText")
	self:RegisterEvent("PLAYER_TRADE_MONEY", "UpdateGoldText")
	self:RegisterEvent("TRADE_MONEY_CHANGED", "UpdateGoldText")
	self:RegisterEvent("BANKFRAME_OPENED", "OpenBank")
	self:RegisterEvent("BANKFRAME_CLOSED", "CloseBank")
	self:RegisterEvent("PLAYERBANKBAGSLOTS_CHANGED")
	StackSplitFrame:SetFrameStrata("DIALOG")
	self:HookScript(TradeFrame, "OnShow", "OpenBags")
	self:HookScript(TradeFrame, "OnHide", "CloseBags")
end

StaticPopupDialogs["BUY_BANK_SLOT"] = {
	text = CONFIRM_BUY_BANK_SLOT,
	button1 = YES,
	button2 = NO,
	OnAccept = function(self)
		PurchaseSlot()
	end,
	OnShow = function(self)
		MoneyFrame_Update(self.moneyFrame, GetBankSlotCost())
	end,
	hasMoneyFrame = 1,
	timeout = 0,
	hideOnEscape = 1,
}

StaticPopupDialogs["CANNOT_BUY_BANK_SLOT"] = {
	text = ERR_BANKSLOT_FAILED_TOO_MANY,
	button1 = ACCEPT,
	timeout = 0,
	whileDead = 1,	
}

StaticPopupDialogs["NO_BANK_BAGS"] = {
	text = format(SPELL_FAILED_NEED_AMMO_POUCH, BAGSLOTTEXT),
	button1 = ACCEPT,
	timeout = 0,
	whileDead = 1,	
}

S:RegisterModule(B:GetName())