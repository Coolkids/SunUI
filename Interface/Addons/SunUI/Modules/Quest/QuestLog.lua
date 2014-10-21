local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local Q = S:GetModule("Skins")
----------------------------------------------------------------------------------------
--	Quest level (yQuestLevel by Yleaf)
----------------------------------------------------------------------------------------
hooksecurefunc("QuestLogQuests_Update", function()
	for i, button in pairs(QuestMapFrame.QuestsFrame.Contents.Titles) do
		if button:IsShown() then
			local level = strmatch(GetQuestLink(button.questLogIndex), "quest:%d+:(%d+)")
			if level then
				local height = button.Text:GetHeight()
				button.Text:SetFormattedText("[%d] %s", level, button.Text:GetText())
				button.Check:SetPoint("LEFT", button.Text, button.Text:GetWrappedWidth() + 2, 0)
				button:SetHeight(button:GetHeight() - height + button.Text:GetHeight())
			end
		end
	end
end)

----------------------------------------------------------------------------------------
--	CTRL+Click to abandon a quest or ALT+Click to share a quest(by Suicidal Katt)
----------------------------------------------------------------------------------------
local enabled = true
local f = CreateFrame("frame",nil)
f.d = 0

local function AddQueue()
	if (f.d + 1) <= 1 then
		f.d = f.d + 1
		enabled = false
		f:SetScript("OnUpdate",function(self,elapsed)
			f.d = f.d - elapsed
			if f.d < 0 then
				f:SetScript("OnUpdate",nil)
				enabled = true
				f.d = 0
			end
		end)
	else
		return
	end
end

hooksecurefunc("QuestMapLogTitleButton_OnClick", function(self,button)
	if ( IsModifiedClick() ) then
		if enabled then
			AddQueue()
			if IsControlKeyDown() then
				QuestMapQuestOptions_AbandonQuest(self.questID)
				print("|cffffff00Quest abandoned: "..GetAbandonQuestName())
			elseif IsAltKeyDown() then
				QuestMapQuestOptions_ShareQuest(self.questID)
			end
		end
	end
end)

----------------------------------------------------------------------------------------
--	QuickQuestItem(by Suicidal Katt) 任务物品宏  新建一个全局任务物品宏 需要拖到动作条
----------------------------------------------------------------------------------------

local GTT = _G.GameTooltip
local GetAddOnMetadata = 			_G.GetAddOnMetadata
local GetContainerNumSlots = 		_G.GetContainerNumSlots
local GetContainerItemQuestInfo = 	_G.GetContainerItemQuestInfo
local GetContainerItemInfo = 		_G.GetContainerItemInfo
local GetItemInfo = 				_G.GetItemInfo
local GetNumQuestLogEntries = 		_G.GetNumQuestLogEntries
local GetQuestLogTitle = 			_G.GetQuestLogTitle
local GetQuestLogSpecialItemInfo = 	_G.GetQuestLogSpecialItemInfo
local InCombatLockdown = 			_G.InCombatLockdown

local Addon = "SunUI"
local sides = {"Left","Right"}
local global, character, debug, queuedItem, spaceNeeded

local defaults = {
	last = nil,
	itemlist = {},
	useTargets = false,
	targets = "",
}

local function copyTable(input)
	local tempTable = {}
	for key, value in pairs(input) do
		if type(value) == "table" then tempTable[key] = copyTable(value)
		else tempTable[key] = value end
	end
	return tempTable
end

local QQI_ParsedItems = {}
local QQI_QuestItems = {}
local QQI_DailyItems = {}
local QQI_DB

-- To do list:
-- 1. Create a way to detect recently used quest items that do not match the QQI_DB.itemlist.
-- 2. Create a timed delay after targeting or mouse'ingover a unit in which the macro resets to the QQI_ParsedItems table.
-- 3. Use the isDaily parameter to watch for zone changes and detect 'use' items in various zones.
-- 4. Options of course.

local function IsInInventory(itemName)
	for b = 0,4,1 do 
		for s = 1,GetContainerNumSlots(b),1 do 
			local _,_,_,_,readable,_,itemLink = GetContainerItemInfo(b,s)
			if itemLink then
				local itemString = GetItemInfo(itemLink)
				if itemName == itemString then
					return true
				end
			end
		end 
	end
	return false
end

function Q:QQI_MacroUpdater(macroSlot,itemName)
	if macroSlot and itemName then
		EditMacro(macroSlot, "任务物品宏","INV_MISC_QUESTIONMARK","#showtooltip\n/use "..itemName,nil,nil)
	elseif macroSlot and not itemName then
		EditMacro(macroSlot, "任务物品宏","Icon_PetFamily_Magical","--QQI MACRO--\n--No items available!--",nil,nil)
	end
end

function Q:QQI_UpdateMacro(unit)
	local isFound,macroSlot = self:QQI_MacroFinder()
	if isFound and macroSlot then
		if unit then -- Unit Update is the only point we save QQI_DB.last since we have a Unit we can match a quest item to.
			local itemName = QQI_DB.itemlist[UnitName(unit)]
			if itemName and IsInInventory( itemName ) then
				if not InCombatLockdown() then
					self:QQI_MacroUpdater( macroSlot, itemName )
				else -- Only places information for QQI_DB.last if we're in combat.
					QQI_DB.last = itemName
					queuedItem = true
				end
			end
		else -- Use Parsed Item List
			if not InCombatLockdown() then
				if queuedItem then
					if QQI_DB.last then
						self:QQI_MacroUpdater( macroSlot, QQI_DB.last )
						QQI_DB.last = nil
						queuedItem = false
					end
				else
					if QQI_ParsedItems and #QQI_ParsedItems > 0 then
						local useList = ""
						for f=0,#QQI_ParsedItems do -- Creates a multiline string for the macro to use all parsed items. (This is affected by macro character limits of course)
							if f == 1 then
								useList = QQI_ParsedItems[f]
							elseif f > 1 then
								useList = useList.."\n/use "..QQI_ParsedItems[f]
							end
						end
						self:QQI_MacroUpdater( macroSlot, useList )
					else
						self:QQI_MacroUpdater( macroSlot, false)
					end
				end				
			end
		end
	else
		self:QQI_CreateMacro()
	end
end

function Q:QQI_ParseInventory()
	QQI_ParsedItems = {} -- Clear the table.
	for b = 0,4,1 do 
		for s = 1,GetContainerNumSlots(b),1 do 
			local IsQuestItem,StartsQuest,_ = GetContainerItemQuestInfo(b,s)
			local _,_,_,_,readable,_,itemLink = GetContainerItemInfo(b,s)
			--local startTime, duration, isEnabled = GetContainerItemCooldown(b,s)
			if IsQuestItem and not StartsQuest and not readable then
				local itemString = GetItemInfo(itemLink)
				if not tContains(QQI_ParsedItems,itemString) then
					tinsert(QQI_ParsedItems,itemString)
				end
			end
		end 
	end
	self:QQI_UpdateMacro()
end

function Q:QQI_ParseQuestLog()
	QQI_QuestItems = {} -- Clear the table.
	--QQI_DailyItems = {}
	for i=1,GetNumQuestLogEntries() do
		local questLogTitleText,_,_,_,isHeader,_,_,isDaily,_,_ = GetQuestLogTitle(i) -- isDaily may possibly be used later
		if not isHeader then
			local link,icon,charges = GetQuestLogSpecialItemInfo(i) -- charges may play a role later
			--[[if isDaily then
				if link then
					local itemName = GetItemInfo(link)
					QQI_DailyItems[questLogTitleText] = itemName
				else
					QQI_DailyItems[questLogTitleText] = nil
				end
			else]]
				if link then
					local itemName = GetItemInfo(link)
					QQI_QuestItems[questLogTitleText] = itemName
				else
					QQI_QuestItems[questLogTitleText] = nil
				end
			--end
		end
	end
	self:QQI_UpdateMacro()
end

function Q:QQI_ParseTooltip()
	for i=1,2 do -- sides[i] checks 'Left' and 'Right'
		for n=1,GTT:NumLines() do
			if _G["GameTooltipText"..sides[i]..n] then 
				local TooltipText = _G["GameTooltipText"..sides[i]..n]:GetText()
				if TooltipText then
					for k,v in pairs(QQI_QuestItems) do
						if k == TooltipText and v ~= nil then -- May need to be changed to string.find / match for more accurate results
							if UnitExists("mouseover") then
								QQI_DB.itemlist[UnitName("mouseover")] = v
								self:QQI_UpdateMacro("mouseover")
							end
						end
					end
				end
			end
		end
	end
end

function Q:QQI_MacroFinder()
	global,character = GetNumMacros()
	local found = false
	for i=1, global do
		local name = GetMacroInfo(i)
		if name == "任务物品宏" then
			found = true
			return true, i
		end
	end
	if not found then
		return false, nil
	end
end

function Q:QQI_CreateMacro()
	if spaceNeeded then	return end
	if InCombatLockdown() then return end
	
	global,character = GetNumMacros()
	local isFound, macroSlot = QQI_MacroFinder()
	local hasSpace = global < 36 -- Checks to make sure there is macro space (36 is max in global?).
	if hasSpace then 
		if not isFound and not InCombatLockdown() then
			CreateMacro("任务物品宏","INV_MISC_QUESTIONMARK","--任务物品宏--",nil,nil)
			self:QQI_ParseQuestLog()
			self:QQI_ParseInventory()
			self:QQI_UpdateMacro()
		end
	else
		print(": No global macro space. Please delete a macro to create space.")
		spaceNeeded = true
	end
end

local QQI = CreateFrame("Frame", nil)
QQI:SetScript("OnEvent",function(self,event,...)
	local arg1,arg2,arg3,arg4 = ...
	if event == "ADDON_LOADED" and arg1 == Addon then
		QQI_DB = copyTable(defaults)
		self:UnregisterEvent("ADDON_LOADED")
	elseif event == "PLAYER_ENTERING_WORLD" then
		Q:QQI_CreateMacro()
	elseif event == "PLAYER_TARGET_CHANGED" then
		Q:QQI_UpdateMacro("target")
	elseif event == "UPDATE_MOUSEOVER_UNIT" then
		Q:QQI_UpdateMacro("mouseover")
	elseif event == "PLAYER_REGEN_ENABLED" then
		Q:QQI_UpdateMacro()
	elseif event == "QUEST_LOG_UPDATE" or (event == "UNIT_QUEST_LOG_CHANGED" and arg1 == "player") then
		Q:QQI_ParseQuestLog()
		self:UnregisterEvent("QUEST_LOG_UPDATE")
	elseif event == "BAG_UPDATE" then
		Q:QQI_ParseInventory()
	elseif event == "PLAYER_ALIVE" then
		GTT:HookScript("OnShow",QQI_ParseTooltip)
	--[[else
		if debug then
			if arg2 then
				print(event.." "..arg1.." "..arg2)
			elseif arg1 then
				print(event.." "..arg1)
			else
				print(event)
			end
		end]]
	end
end)

QQI:RegisterEvent("ADDON_LOADED")
QQI:RegisterEvent("PLAYER_ALIVE")
QQI:RegisterEvent("PLAYER_FOCUS_CHANGED")
QQI:RegisterEvent("PLAYER_TARGET_CHANGED")
QQI:RegisterEvent("PLAYER_ENTERING_WORLD")
QQI:RegisterEvent("PLAYER_REGEN_ENABLED")
QQI:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
QQI:RegisterEvent("BAG_UPDATE")
QQI:RegisterEvent("QUEST_LOG_UPDATE")
QQI:RegisterEvent("UNIT_QUEST_LOG_CHANGED")

--[[
----------------------------------------------------------------------------------------
--	Count of daily quests(DailyQuestCounter by Karl_w_w)
----------------------------------------------------------------------------------------
hooksecurefunc("QuestLog_UpdateQuestCount", function()
	local dailyQuestsComplete = GetDailyQuestsCompleted()
	local parent = QuestLogCount:GetParent()
	local width = QuestLogQuestCount:GetWidth()

	if not QuestLogDailyQuestCount then
		QuestLogDailyQuestCount = QuestLogCount:CreateFontString("QuestLogDailyQuestCount", "ARTWORK", "GameFontNormalSmall")
		QuestLogDailyQuestCount:SetPoint("TOPRIGHT", QuestLogQuestCount, "BOTTOMRIGHT", 0, -2)
	end

	if not QuestLogDailyQuestCountMouseOverFrame then
		QuestLogDailyQuestCountMouseOverFrame = CreateFrame("Frame", "QuestLogDailyQuestCountMouseOverFrame", QuestLogCount)
		QuestLogDailyQuestCountMouseOverFrame:SetAllPoints(QuestLogCount)
		QuestLogDailyQuestCountMouseOverFrame:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText(format(QUEST_LOG_DAILY_TOOLTIP, GetDailyQuestsCompleted(), SecondsToTime(GetQuestResetTime(), nil, 1)))
			end)
		QuestLogDailyQuestCountMouseOverFrame:SetScript("OnLeave", GameTooltip_Hide)
	end

	if dailyQuestsComplete > 0 then
		QuestLogDailyQuestCount:SetFormattedText(QUEST_LOG_DAILY_COUNT_TEMPLATE, dailyQuestsComplete)
		QuestLogDailyQuestCount:Show()
		if QuestLogDailyQuestCount:GetWidth() > width then
			width = QuestLogDailyQuestCount:GetWidth()
		end
		QuestLogCount:SetHeight(32)
		QuestLogCount:SetPoint("TOPLEFT", parent, "TOPLEFT", 70, -26)
	else
		QuestLogDailyQuestCount:Hide()
		QuestLogCount:SetHeight(20)
		QuestLogCount:SetPoint("TOPLEFT", parent, "TOPLEFT", 70, -33)
	end
	QuestLogCount:SetWidth(width + 15)
end)
]]