﻿local E, L, V, P, G = unpack(ElvUI) --Import: Engine, Locales, ProfileDB, local
local AAQ = E:GetModule("Quest-SunUI")
local isRepeatableAuto = false --是否开启可重复交接任务自动交接（比如一包食材换徽记）

completed_quests = {}
incomplete_quests = {}
	
function AAQ:canAutomate ()
	if IsShiftKeyDown() then
		return false
	else
		return true
	end
end

function AAQ:strip_text (text)
	if not text then return end
	text = text:gsub('|c%x%x%x%x%x%x%x%x(.-)|r','%1')
	text = text:gsub('%[.*%]%s*','')
	text = text:gsub('(.+) %(.+%)', '%1')
	text = text:trim()
	return text
end

local function On_QUEST_PROGRESS ()
	if not AAQ:canAutomate() then return end
	if IsQuestCompletable() then
		CompleteQuest()
	end
end

local function On_QUEST_LOG_UPDATE ()
	if not AAQ:canAutomate() then return end
	local start_entry = GetQuestLogSelection()
	local num_entries = GetNumQuestLogEntries()
	local title
	local is_complete
	local no_objectives

	completed_quests = {}
	incomplete_quests = {}

	if num_entries > 0 then
		for i = 1, num_entries do
			SelectQuestLogEntry(i)
			title, _, _, _, _, _, is_complete = GetQuestLogTitle(i)
			no_objectives = GetNumQuestLeaderBoards(i) == 0
			if title then
				if is_complete or no_objectives then
					completed_quests[title] = true
				else
					incomplete_quests[title] = true
				end
			end
		end
	end

	SelectQuestLogEntry(start_entry)
end

local function On_GOSSIP_SHOW ()
	if not AAQ:canAutomate() then return end

	local button
	local text

	for i = 1, GetNumGossipActiveQuests()+GetNumGossipAvailableQuests() do
		button = _G['GossipTitleButton' .. i]
		if button:IsVisible() then
		text = AAQ:strip_text(button:GetText())	  
			if button.type == 'Available' then
				local isRepeatable = select(i+4,GetGossipAvailableQuests())
					if  isRepeatable and isRepeatableAuto then
						button:Click()
					elseif not isRepeatable then
						button:Click()
					end
			elseif button.type == 'Active' then
				if completed_quests[text] then
					button:Click()
				end
			end
		end
	end
end

local function On_QUEST_GREETING ()
	if not AAQ:canAutomate() then return end

	local button
	local text

	for i = 1, 32 do
		button = _G['QuestTitleButton' .. i]
		if button:IsVisible() then
			text = AAQ:strip_text(button:GetText())
			if completed_quests[text] then
				button:Click()
			elseif not incomplete_quests[text] then
				button:Click()
			end
		end
	end
end

local function On_QUEST_DETAIL ()
	if not AAQ:canAutomate() then return end
	AcceptQuest()
end

local function On_QUEST_COMPLETE ()
	if not AAQ:canAutomate() then return end
  
	if GetNumQuestChoices() <= 1	then
	--GetQuestReward(QuestFrameRewardPanel.itemChoice)
	if ( GetNumQuestChoices() == 1 ) then 
		QuestInfoFrame.itemChoice = 1	 
	end
		GetQuestReward(QuestInfoFrame.itemChoice)
	end
end


QuestInfoDescriptionText.SetAlphaGradient=function() return false end
function AAQ:CreateQuickSet()
	local quickquest = CreateFrame("CheckButton", nil, ObjectiveTrackerFrame.BlocksFrame.QuestHeader)
	quickquest:ClearAllPoints()
	quickquest:SetSize(22,22)
	quickquest:SetPoint("TOPRIGHT", ObjectiveTrackerBlocksFrame.QuestHeader, "TOPLEFT", -5, 0)
	quickquest:SetScript("OnClick", function(self)
		if AAQ.db.autoquest then 
			AAQ.db.autoquest = false
		else
			AAQ.db.autoquest = true
		end
		
		AAQ:UpdateAutoAccept()
		self:SetChecked(AAQ.db.autoquest)
	end)
	quickquest:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:AddLine("自动交接任务")
		GameTooltip:Show()
	end)
	quickquest:SetScript("OnEvent", function(self)
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		self:SetChecked(AAQ.db.autoquest)
	end)
	quickquest:SetScript("OnLeave", function() GameTooltip:Hide() end)
	quickquest:SetNormalTexture("Interface\\Buttons\\UI-CheckBox-Up")
	quickquest:SetPushedTexture("Interface\\Buttons\\UI-CheckBox-Down")
	quickquest:SetHighlightTexture("Interface\\Buttons\\UI-CheckBox-Highlight")
	quickquest:SetDisabledCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check-Disabled")
	quickquest:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check")
	quickquest:RegisterEvent("PLAYER_ENTERING_WORLD")
	local A = E:GetModule("Skins-SunUI")
	A:ReskinCheck(quickquest)
	--ObjectiveTrackerFrame.QuestHeader:HookScript("OnShow", function() quickquest:Show() end)
	--ObjectiveTrackerFrame.QuestHeader:HookScript("OnHide", function() quickquest:Hide() end)
end

function AAQ:UpdateAutoAccept()
	if self.db.autoquest then
		AAQ:RegisterEvent("GOSSIP_SHOW", On_GOSSIP_SHOW)
		AAQ:RegisterEvent("QUEST_COMPLETE", On_QUEST_COMPLETE)
		AAQ:RegisterEvent("QUEST_DETAIL", On_QUEST_DETAIL)
		AAQ:RegisterEvent("QUEST_GREETING", On_QUEST_GREETING)
		AAQ:RegisterEvent("QUEST_LOG_UPDATE", On_QUEST_LOG_UPDATE)
		AAQ:RegisterEvent("QUEST_PROGRESS", On_QUEST_PROGRESS)
		AAQ:RegisterEvent("QUEST_FINISHED", On_QUEST_PROGRESS)
	else
		self:UnregisterEvent("GOSSIP_SHOW")
		self:UnregisterEvent("QUEST_COMPLETE")
		self:UnregisterEvent("QUEST_DETAIL")
		self:UnregisterEvent("QUEST_FINISHED")
		self:UnregisterEvent("QUEST_GREETING")
		self:UnregisterEvent("QUEST_LOG_UPDATE")
		self:UnregisterEvent("QUEST_PROGRESS")
	end
end
function AAQ:initAutoAccept()
	self:UpdateAutoAccept()
	self:CreateQuickSet()
end