local S, L, DB, _, C = unpack(select(2, ...))
local AAQ = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("AutoAccept", "AceEvent-3.0")
local SunUIConfig = LibStub("AceAddon-3.0"):GetAddon("SunUI"):GetModule("SunUIConfig")
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

function AAQ:UpdateSet()
	if C["AutoQuest"] then
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
function AAQ:OnInitialize()
	C = SunUIConfig.db.profile.MiniDB
	self:UpdateSet()
end