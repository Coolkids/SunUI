-------------------------------------------------------------------------------------------
-----------!QuestItemButtonFix  ## Author: nbluewiz(everfinale@gmail.com)  from:curse
------------------------------------------------------------------------------------------
-- Item Button Function
local itemButtons = {}
local InCombatLockdown = _G.InCombatLockdown

local needUpdate = false

function Fix_ItemButton_OnEvent(self, event, ...)
	if ( event == "PLAYER_TARGET_CHANGED" ) then
		self.rangeTimer = -1
	elseif ( event == "BAG_UPDATE_COOLDOWN" ) then
		Fix_ItemButton_UpdateCooldown(self)
	end
end

function Fix_ItemButton_OnUpdate(self, elapsed)
	local rangeTimer = self.rangeTimer
	if ( rangeTimer ) then
		rangeTimer = rangeTimer - elapsed
		if ( rangeTimer <= 0 ) then
			local link, item, charges, showItemWhenComplete = GetQuestLogSpecialItemInfo(self.questLogIndex)
			if ( not charges or charges ~= self.charges ) then
				return
			end
			local valid = IsQuestLogSpecialItemInRange(self.questLogIndex)
			if ( valid == 0 ) then
				self.range:Show()
				self.range:SetVertexColor(1.0, 0.1, 0.1)
			elseif ( valid == 1 ) then
				self.range:Show()
				self.range:SetVertexColor(0.6, 0.6, 0.6)
			else
				self.range:Hide()
			end
			rangeTimer = 0.3
		end

		self.rangeTimer = rangeTimer
	end
end

function Fix_ItemButton_OnShow(self)
	self:RegisterEvent("PLAYER_TARGET_CHANGED")
	self:RegisterEvent("BAG_UPDATE_COOLDOWN")
end

function Fix_ItemButton_OnHide(self)
	self:UnregisterEvent("PLAYER_TARGET_CHANGED")
	self:UnregisterEvent("BAG_UPDATE_COOLDOWN")
end

function Fix_ItemButton_OnEnter(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:SetQuestLogSpecialItem(self.questLogIndex)
end

function Fix_ItemButton_OnLeave(self)
	GameTooltip:Hide()
end

function Fix_ItemButton_UpdateCooldown(itemButton)
	local start, duration, enable = GetQuestLogSpecialItemCooldown(itemButton.questLogIndex)
	if ( start ) then
		CooldownFrame_Set(itemButton.cooldown, start, duration, enable)
		if ( duration > 0 and enable == 0 ) then
			SetItemButtonTextureVertexColor(itemButton, 0.4, 0.4, 0.4)
		else
			SetItemButtonTextureVertexColor(itemButton, 1, 1, 1)
		end
	end
end

local function Fix_MakeItemButton(index)
	if itemButtons[index] then
		return itemButtons[index]
	end

	if InCombatLockdown() then return nil end

	local buttonName = "Fix_ItemButton"..index
	local button = CreateFrame("Button", buttonName, UIParent, "SecureActionButtonTemplate")

	button:SetWidth(26)
	button:SetHeight(26)

	button:SetScript("OnEvent", Fix_ItemButton_OnEvent)
	button:SetScript("OnUpdate", Fix_ItemButton_OnUpdate)
	button:SetScript("OnShow", Fix_ItemButton_OnShow)
	button:SetScript("OnHide", Fix_ItemButton_OnHide)
	button:SetScript("OnEnter", Fix_ItemButton_OnEnter)
	button:SetScript("OnLeave", Fix_ItemButton_OnLeave)
	button:RegisterForClicks("AnyUp")
	button:SetHighlightTexture([[Interface\Buttons\ButtonHilight-Square]])
	button:SetPushedTexture([[Interface\Buttons\UI-Quickslot-Depress]])

	button.icon = button:CreateTexture(buttonName.."Icon", "BORDER")
	button.icon:SetAllPoints()

	button.cooldown = CreateFrame("Cooldown", buttonName.."Cooldown", button, "CooldownFrameTemplate")
	button.cooldown:SetAllPoints()

	button.range = button:CreateFontString(buttonName.."Range", "ARTWORK", "NumberFontNormalSmallGray")
	button.range:SetSize(29, 10)
	button.range:SetJustifyH("LEFT")
	button.range:SetText("●")
	button.range:SetPoint("TOPRIGHT", button.icon, 16, -2)

	button.count = button:CreateFontString(buttonName.."Count", "BORDER", "NumberFontNormal")
	button.count:SetJustifyH("RIGHT")
	button.count:SetPoint("BOTTOMRIGHT", button.icon, -3, 2)

	button.questLogIndex = index
	button.rangeTimer = -1

	itemButtons[index] = button
	return button
end

local function Fix_GetItemButton(index)
	if itemButtons[index] then
		return itemButtons[index]
	end
end

local function Fix_O_Update()
	local inScenario = C_Scenario.IsInScenario()

	for i = 1, 25 do
		local questID, title, questLogIndex, numObjectives, requiredMoney, isComplete, startEvent, isAutoComplete, failureTime, timeElapsed, questType, isTask, isStory, isOnMap, hasLocalPOI = GetQuestWatchInfo(i)

		if questID and not ObjectiveTrackerFrame.collapsed then
			local block = QUEST_TRACKER_MODULE.usedBlocks[questID]
			if block then
				-- hide original item button
				if block.itemButton then
					block.itemButton:Hide()
				end

				local link, item, charges, showItemWhenComplete = GetQuestLogSpecialItemInfo(questLogIndex)
				if ( item and ( not isComplete or showItemWhenComplete ) ) then
					local button = Fix_GetItemButton(i)
					if not button then
						button = Fix_MakeItemButton(i)
					end
					if not InCombatLockdown() then
						local diff = (inScenario and 0) or (BONUS_OBJECTIVE_TRACKER_MODULE.firstBlock and (BONUS_OBJECTIVE_TRACKER_MODULE.firstBlock.state == "ENTERING") and BONUS_OBJECTIVE_TRACKER_MODULE.contentsAnimHeight + 25) or 0
						local right = block:GetRight() and block:GetRight() - 2
						local top = block:GetTop() and block:GetTop() + 1
						if right and top then
							button:SetPoint("TOPRIGHT", UIParent, "BOTTOMLEFT", right, top+diff)
							button:Show()
							button.questLogIndex = questLogIndex
							button.charges = charges
							button.rangeTimer = -1
							SetItemButtonTexture(button, item)
							SetItemButtonCount(button, charges)
							button:SetAttribute("type*","item")
							button:SetAttribute("item", link)
							Fix_ItemButton_UpdateCooldown(button)
						end
					else
						needUpdate = true
					end
				else
					local button = Fix_GetItemButton(i)
					if button then
						if not InCombatLockdown() then
							button:Hide()
						else
							needUpdate = true
						end
					end
				end
			end
		else
			local button = Fix_GetItemButton(i)
			if button then
				if not InCombatLockdown() then
					button:Hide()
				else
					needUpdate = true
				end
			end
		end
	end
end

hooksecurefunc("ObjectiveTracker_Update", Fix_O_Update)

ObjectiveTrackerFrame:HookScript("OnHide", function()
	if not InCombatLockdown() then
		for _, button in pairs(itemButtons) do
			button:Hide()
		end
	end
end)
ObjectiveTrackerFrame:HookScript("OnShow", function()
	ObjectiveTracker_Update(OBJECTIVE_TRACKER_UPDATE_QUEST)
end)

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")

function Fix_EventFrame_OnEvent(self, event, ...)
	if needUpdate then
		needUpdate = false
		ObjectiveTracker_Update(OBJECTIVE_TRACKER_UPDATE_QUEST)
	end
end
eventFrame:SetScript("OnEvent", Fix_EventFrame_OnEvent)
