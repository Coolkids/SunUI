--------------------------------------------------------------
---Ãû×Ö:QuestGuru  ×÷Õß Lazzy-Kilrogg 
--------------------------------------------------------------

local qgc = QuestGuru
local QGC_LOADMSG = ""
QuestGuruSettings = {} --CFFFF8A08  |c

qgc.quests = {}

BINDING_HEADER_QUESTGURU = "QuestGuru"
BINDING_CATEGORY_QUESTGURU = "QuestGuru"
BINDING_NAME_QUESTGURU_TOGGLE = "Show/Hide QuestGuru"

function qgc:OnEvent(event)
	if event=="PLAYER_ENTERING_WORLD" then

		qgc:UnregisterEvent("PLAYER_ENTERING_WORLD")
		local scrollFrame = qgc.scrollFrame
		scrollFrame.update = qgc.UpdateLogList
		HybridScrollFrame_CreateButtons(scrollFrame, "QuestGuruListTemplate")
--		qgc.showLevels.text:SetText("Show Levels")
--		qgc.showTooltips.text:SetText("Show Tooltips")
--		qgc.showLevels:SetChecked(QuestGuruSettings.ShowLevels and true)
--		qgc.showTooltips:SetChecked(QuestGuruSettings.ShowTooltips and true)
		--QGC_FrameTitleText:SetFormattedText(TEXT(BINDING_HEADER_QUESTGURU).." v"..QUESTGURU_VERSION.." for "..QGC_NAME..", level "..QGC_LEVEL.." "..QGC_CLASS)
--		
		QuestLogPopupDetailFrame:HookScript("OnShow",function() qgc:Hide() end)
--		QGCRegistered = false;
--		QGCRegistered = RegisterAddonMessagePrefix("QuestGuru");
--		if	( QGCRegistered ) then
--			ChatFrame1:AddMessage("QuestGuru v"..QUESTGURU_VERSION.." activated! - ", 0, 128, 128,"|r - |cFFFFD700Lazzy-Kilrogg(US)|r");
--		end
		
		qgc:UpdateOverrides()
		qgc:RegisterEvent("UPDATE_BINDINGS")
	elseif event=="UPDATE_BINDINGS" then
		qgc:UpdateOverrides()
	elseif event=="QUEST_DETAIL" then
		qgc:Hide()
	else
		local selected = GetQuestLogSelection()
		if selected==0 then
			qgc:SelectFirstQuest()
		else
			qgc:UpdateLogList()
			qgc:SelectQuestIndex(selected)
		end
	end
end

function qgc:OnShow()
	if WorldMapFrame:IsVisible() then
		ToggleWorldMap() -- can't have world map up at same time due to potential details frame being up
	end
	if QuestLogPopupDetailFrame:IsVisible() then
		HideUIPanel(QuestLogPopupDetailFrame)
	end
	local selected = GetQuestLogSelection()
	if not selected or selected==0 then
		qgc:SelectFirstQuest()
	else
		qgc:SelectQuestIndex(selected)
	end
	PlaySound("igQuestLogOpen")
	SetPortraitTexture(QGC_FramePortrait, "player")
	qgc:RegisterEvent("QUEST_DETAIL")
	qgc:RegisterEvent("QUEST_LOG_UPDATE")
	qgc:RegisterEvent("QUEST_WATCH_LIST_CHANGED")
	qgc:RegisterEvent("SUPER_TRACKED_QUEST_CHANGED")
	qgc:RegisterEvent("GROUP_ROSTER_UPDATE")
	qgc:RegisterEvent("PARTY_MEMBER_ENABLE")
	qgc:RegisterEvent("PARTY_MEMBER_DISABLE")
	qgc:RegisterEvent("QUEST_POI_UPDATE")
	qgc:RegisterEvent("QUEST_WATCH_UPDATE")
	qgc:RegisterEvent("QUEST_ACCEPTED")
	qgc:RegisterEvent("UNIT_QUEST_LOG_CHANGED")
	if not tContains(UISpecialFrames,"QuestGuru") then
		tinsert(UISpecialFrames,"QuestGuru")
	end
	qgc.detail:ClearAllPoints()
	qgc.detail:SetPoint("TOPRIGHT",-32,-63)
end

-- no need to watch these events while log isn't on screen
function qgc:OnHide()
	-- only keep this window in UISpecialFrames while it's up
	for i=#UISpecialFrames,1,-1 do
		if UISpecialFrames[i]=="QuestGuru" then
			tremove(UISpecialFrames,i)
		end
	end
	PlaySound("igQuestLogClose")
	qgc:UnregisterEvent("QUEST_DETAIL")
	qgc:UnregisterEvent("QUEST_LOG_UPDATE")
	qgc:UnregisterEvent("QUEST_WATCH_LIST_CHANGED")
	qgc:UnregisterEvent("SUPER_TRACKED_QUEST_CHANGED")
	qgc:UnregisterEvent("GROUP_ROSTER_UPDATE")
	qgc:UnregisterEvent("PARTY_MEMBER_ENABLE")
	qgc:UnregisterEvent("PARTY_MEMBER_DISABLE")
	qgc:UnregisterEvent("QUEST_POI_UPDATE")
	qgc:UnregisterEvent("QUEST_WATCH_UPDATE")
	qgc:UnregisterEvent("QUEST_ACCEPTED")
	qgc:UnregisterEvent("UNIT_QUEST_LOG_CHANGED")

	-- expand all headers when window hides so default doesn't lose track of collapsed quests
	local index = 1
	while index<=GetNumQuestLogEntries() do
		local _,_,_,isHeader,isCollapsed = GetQuestLogTitle(index)
		if isHeader and isCollapsed then
			ExpandQuestHeader(index)
		end
		index = index + 1
	end

end

function qgc:UpdateLogList()
	local numEntries,numQuests = GetNumQuestLogEntries()
	local scrollFrame = qgc.scrollFrame
	local offset = HybridScrollFrame_GetOffset(scrollFrame)
	local buttons = scrollFrame.buttons
	local selectedIndex = GetQuestLogSelection()

	qgc.count.text:SetText(format("%s \124cffffffff%d/%d",QUESTS_COLON,numQuests,MAX_QUESTLOG_QUESTS))

	for i=1, #buttons do
		local index = i + offset
		local button = buttons[i]
		button.index = index
		if ( index <= numEntries ) then
			local questTitle, level, suggestedGroup, isHeader, isCollapsed, isComplete, frequency, questID = GetQuestLogTitle(index)

			button.index = index
			button.questID = questID
			button.isHeader = isHeader
			button.isCollapsed = isCollapsed

			button.normalText:SetWidth(275)
			local maxWidth = 275 -- we may shrink normalText to accomidate check and tag icons

			local color = isHeader and QuestDifficultyColors["header"] or GetQuestDifficultyColor(level)
			if not isHeader and selectedIndex==index then
				button:SetNormalFontObject("GameFontHighlight")
				button.selected:SetVertexColor(color.r,color.g,color.b)
				button.selected:Show()
			else
				button:SetNormalFontObject(color.font)
				button.selected:Hide()
			end

			if isHeader then
				button:SetText(questTitle)
				button:SetNormalTexture(isCollapsed and "Interface\\Buttons\\UI-PlusButton-Up" or "Interface\\Buttons\\UI-MinusButton-Up")
				button:SetHighlightTexture("Interface\\Buttons\\UI-PlusButton-Hilight")
				button.check:Hide()
				button.tag:Hide()
			else
--				if QuestGuruSettings.ShowLevels then
--					button:SetText(format("  [%d] %s",level,questTitle))
--				else
--					button:SetText(format("  %s",questTitle))
--				end
				button:SetText(format("  [%d] %s",level,questTitle))
				button:SetNormalTexture("")
				button:SetHighlightTexture("")
				-- if quest is tracked, show check and shorted max normalText width
				if IsQuestWatched(index) then
					maxWidth = maxWidth - 16
					button.check:Show()
				else
					button.check:Hide()
				end
				-- display an icon to note what type of quest it is
				-- tag. daily icon can be alone or before other icons except for COMPLETED or FAILED
				local tagID
				local questTagID, tagName = GetQuestTagInfo(questID)
				if isComplete and isComplete<0 then
					tagID = "FAILED"
				elseif isComplete and isComplete>0 then
					tagID = "COMPLETED"
				elseif questTagID and questTagID==QUEST_TAG_ACCOUNT then
					local factionGroup = GetQuestFactionGroup(questID)
					if factionGroup then
						tagID = "ALLIANCE"
						if factionGroup==LE_QUEST_FACTION_HORDE then
							tagID = "HORDE"
						end
					else
						tagID = QUEST_TAG_ACCOUNT;
					end
				elseif frequency==LE_QUEST_FREQUENCY_DAILY and (not isComplete or isComplete==0) then
					tagID = "DAILY"
				elseif frequency==LE_QUEST_FREQUENCY_WEEKLY and (not isComplete or isComplete==0) then
					tagID = "WEEKLY"
				elseif questTagID then
					tagID = questTagID
				end
				button.tagID = nil
				button.tag:Hide()
				if tagID then -- this is a special type of quest
					maxWidth = maxWidth - 16
					local tagCoords = QUEST_TAG_TCOORDS[tagID]
					if tagCoords then
						button.tagID = tagID
						button.tag:SetTexCoord(unpack(tagCoords))
						button.tag:Show()
					end
				end

				-- If not a header see if any nearby group mates are on this quest
				local partyMembersOnQuest = 0
				for j=1,GetNumSubgroupMembers() do
					if IsUnitOnQuest(index,"party"..j) then
						partyMembersOnQuest = partyMembersOnQuest + 1
					end
				end
				if partyMembersOnQuest>0 then
					button.groupMates:SetText("["..partyMembersOnQuest.."]")
					button.partyMembersOnQuest = partyMembersOnQuest
					button.groupMates:Show()
				else
					button.partyMembersOnQuest = nil
					button.groupMates:Hide()
				end

			end

			-- limit normalText width to the maxWidth
			button.normalText:SetWidth(min(maxWidth,button.normalText:GetStringWidth()))

			button:Show()
		else
			button:Hide()
		end
	end

	if numEntries==0 then
		qgc.scrollFrame:Hide()
		qgc.emptyLog:Show()
		qgc.detail:Hide()
	else
		qgc.scrollFrame:Show()
		qgc.emptyLog:Hide()
	end

	qgc:UpdateControlButtons()

	HybridScrollFrame_Update(scrollFrame, 16*numEntries, 16)
end

--[[ list entry handling ]]

function qgc:ListEntryOnClick()
	local index = self.index
	if self.isHeader then
		if self.isCollapsed then
			ExpandQuestHeader(index)
		else
			CollapseQuestHeader(index)
		end
	else
		if IsModifiedClick("CHATLINK") and ChatEdit_GetActiveWindow() then
			local link = GetQuestLink(index)
			if link then
				ChatEdit_InsertLink(link)
			end
		elseif IsModifiedClick("QUESTWATCHTOGGLE") then
			qgc:ToggleWatch(index)
		else
			qgc:SelectQuestIndex(index)
		end
	end
	qgc:UpdateLogList()
end

function qgc:ToggleWatch(index)
	if not index then
		index = GetQuestLogSelection()
	end
	if index>0 then
		if IsQuestWatched(index) then -- already watched, remove from watch
			RemoveQuestWatch(index)
		else -- not watched, see if there's room to add, add if so
			if GetNumQuestWatches() >= MAX_WATCHABLE_QUESTS then
				UIErrorsFrame:AddMessage(format(QUEST_WATCH_TOO_MANY,MAX_WATCHABLE_QUESTS),1,0.1,0.1,1)
			else
				AddQuestWatch(index)
			end
		end
	end
end

-- tooltip
function qgc:ListEntryOnEnter()
--	if self.isHeader or not QuestGuruSettings.ShowTooltips then
--		return
--	end

	local index = self.index

	GameTooltip:SetOwner(self,"ANCHOR_RIGHT")
	GameTooltip:AddLine((GetQuestLogTitle(index)),1,.82,0)

	-- add tag if one exists
	if self.tagID then
		local tagID, tagName = GetQuestTagInfo(self.questID)
		if tagName then
			GameTooltip:AddLine(tagName,.9,.9,.9)
		else
			tagName = self.tagID=="COMPLETED" and AUCTION_TIME_LEFT0 or _G[self.tagID]
			if tagName then
				GameTooltip:AddLine(tagName,.9,.9,.9)
			end
		end
		if QUEST_TAG_TCOORDS[self.tagID] then
			GameTooltip:AddTexture("Interface\\QuestFrame\\QuestTypeIcons", unpack(QUEST_TAG_TCOORDS[self.tagID]))
		end
	end
	-- list members on quest if they exist
	if self.partyMembersOnQuest then
		GameTooltip:AddLine(PARTY_QUEST_STATUS_ON,1,.82,0)
		for j=1,GetNumSubgroupMembers() do
			if IsUnitOnQuest(index,"party"..j) then
				GameTooltip:AddLine(GetUnitName("party"..j),.9,.9,.9)
			end
		end
		GameTooltip:AddLine(" ")
	end

	-- description
	if isComplete and isComplete>0 then
		GameTooltip:AddLine(GetQuestLogCompletionText(index),1,1,1,true)
	else
		local _, objectiveText = GetQuestLogQuestText(index)
		GameTooltip:AddLine(objectiveText,.85,.85,.85,true)
		local requiredMoney = GetQuestLogRequiredMoney(index)
		local numObjectives = GetNumQuestLeaderBoards(index)
		for i=1,numObjectives do
			local text, objectiveType, finished = GetQuestLogLeaderBoard(i,index)
			if ( text ) then
				local color = HIGHLIGHT_FONT_COLOR
				if ( finished ) then
					color = GRAY_FONT_COLOR
				end
				GameTooltip:AddLine(QUEST_DASH..text, color.r, color.g, color.b, true)
			end
		end
		if ( requiredMoney > 0 ) then
			local playerMoney = GetMoney()
			local color = HIGHLIGHT_FONT_COLOR
			if ( requiredMoney <= playerMoney ) then
				playerMoney = requiredMoney
				color = GRAY_FONT_COLOR
			end
			GameTooltip:AddLine(QUEST_DASH..GetMoneyString(playerMoney).." / "..GetMoneyString(requiredMoney), color.r, color.g, color.b);
		end

	end


	GameTooltip:Show()
end

--[[ selection ]]

function qgc:SelectQuestIndex(index)

	SelectQuestLogEntry(index)

	StaticPopup_Hide("ABANDON_QUEST")
	StaticPopup_Hide("ABANDON_QUEST_WITH_ITEMS")
	SetAbandonQuest()

	if ( index == 0 ) then
		qgc.selectedIndex = nil
		QuestGuruDetailScrollFrame:Hide()
	elseif index>0 and index<=GetNumQuestLogEntries() and not select(4,GetQuestLogTitle(index)) then
		QuestGuruDetailScrollFrame:Show()
		QuestInfo_Display(QUEST_TEMPLATE_LOG, QuestGuruDetailScrollChildFrame)
		QuestGuruDetailScrollFrameScrollBar:SetValue(0) -- scroll to top
	end

	qgc:UpdateLogList()
end

-- selects the first quest in the log (if any)
function qgc:SelectFirstQuest()
	for i=1,GetNumQuestLogEntries() do
		if not select(4,GetQuestLogTitle(i)) then
			qgc:SelectQuestIndex(i)
			return
		end
	end
	qgc:SelectQuestIndex(0) -- if we reached here, select nothing
end

--[[ control buttons ]]

function qgc:UpdateControlButtons()
	local selectionIndex = GetQuestLogSelection()
	if selectionIndex==0 then
		qgc.abandon:Disable()
		qgc.push:Disable()
		qgc.track:Disable()
	else
		local questID = select(8,GetQuestLogTitle(selectionIndex))
		qgc.abandon:SetEnabled(GetAbandonQuestName() and CanAbandonQuest(questID))
		qgc.push:SetEnabled(GetQuestLogPushable() and IsInGroup())
		qgc.track:Enable()
	end
end

--[[ map button ]]

function qgc:ShowMap()
	qgc:Hide() -- can't let map quest details fight with our details
	local selectionIndex = GetQuestLogSelection()
	if selectionIndex==0 then
		ToggleWorldMap()
	else
		local questID = select(8,GetQuestLogTitle(selectionIndex))
		if not WorldMapFrame:IsVisible() then
			ToggleWorldMap()
		end
		QuestMapFrame_ShowQuestDetails(questID)
	end
end

--[[ overrides ]]

-- if a user sets a key in Key Bindings -> AddOns -> QuestGuru, then
-- we leave the default binding and micro button alone.
-- if no key is set, we override the default's binding and hook the macro button

function qgc:UpdateOverrides()
	local key = GetBindingKey("QUESTGURU_TOGGLE")
	if key and qgc.overridingKey then
		ClearOverrideBindings(qgc)
		qgc.overridingKey = nil
	else -- there's no binding for addon, so override the default stuff
		-- hook the ToggleQuestLog (if it's not been hooked before)
		if not qgc.oldToggleQuestLog then
			qgc.oldToggleQuestLog = ToggleQuestLog
			function ToggleQuestLog(...)
				if qgc.overridingKey then
					qgc:SetShown(not qgc:IsVisible()) -- to toggle our window if overriding
					return
				else
					return qgc.oldToggleQuestLog(...) -- and default stuff if they clear overriding
				end
			end
		end
		-- now see if default toggle quest binding has changed
		local newKey = GetBindingKey("TOGGLEQUESTLOG")
		if qgc.overridingKey~=newKey and newKey then
			ClearOverrideBindings(qgc)
			SetOverrideBinding(qgc,false,newKey,"QUESTGURU_TOGGLE")
			qgc.overridingKey = newKey
		end
	end
end
