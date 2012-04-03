local wow_version, wow_build, wow_data, tocversion = GetBuildInfo()

-- UIDropDownMenu FrameLevels do not properly follow their parent and need to be
-- fixed to prevent the button being under the background.
-- Confirmed fixed in Cataclysm.
if tocversion < 40000 then
	local function FixMenuFrameLevels()
		for l=1,UIDROPDOWNMENU_MAXLEVELS do
			for b=1,UIDROPDOWNMENU_MAXBUTTONS do
				local button = _G["DropDownList"..l.."Button"..b]
				if button then 
					local button_parent = button:GetParent()
					if button_parent then 
						local button_level = button:GetFrameLevel()
						local parent_level = button_parent:GetFrameLevel()
						if button_level <= parent_level then 
							button:SetFrameLevel(parent_level + 2) 
						end  
					end  
				end  
			end  
		end  
	end
	hooksecurefunc("UIDropDownMenu_CreateFrames", FixMenuFrameLevels)
end

-- Fix incorrect translations in the German Locale.  For whatever reason
-- Blizzard changed the oneletter time abbreviations to be 3 letter in
-- the German Locale.
if tocversion < 40000 and GetLocale() == "deDE" then
	if tocversion < 40000 then
		-- Only this one is fixed in Cataclysm.
		MINUTE_ONELETTER_ABBR = "%d m"
	end
	DAY_ONELETTER_ABBR = "%d d"
end

-- fixes the issue with InterfaceOptionsFrame_OpenToCategory not actually opening the Category (and not even scrolling to it)
-- Confirmed still broken in Cataclysm as of build 13329 (4.0.3a) 
do
	local doNotRun = false
	local function get_panel_name(panel)
		local cat = INTERFACEOPTIONS_ADDONCATEGORIES
		if ( type(panel) == "string" ) then
			for i, p in pairs(cat) do
				if p.name == panel then
					if p.parent then
						return get_panel_name(p.parent)
					else
						return panel
					end
				end
			end
		elseif ( type(panel) == "table" ) then
			for i, p in pairs(cat) do
				if p == panel then
					if p.parent then
						return get_panel_name(p.parent)
					else
						return panel.name
					end
				end
			end
		end
	end

	local function InterfaceOptionsFrame_OpenToCategory_Fix(panel)
		if InCombatLockdown() then return end
		if doNotRun then return end
		local panelName = get_panel_name(panel);
		if not panelName then return end -- if its not part of our list return early
		local noncollapsedHeaders = {}
		local shownpanels = 0
		local mypanel 
		local t = {}
		for i, panel in ipairs(INTERFACEOPTIONS_ADDONCATEGORIES) do
			if not panel.parent or noncollapsedHeaders[panel.parent] then
				if panel.name == panelName then
					panel.collapsed = true
					t.element = panel
					InterfaceOptionsListButton_ToggleSubCategories(t)
					noncollapsedHeaders[panel.name] = true
					mypanel = shownpanels + 1
				end
				if not panel.collapsed then
					noncollapsedHeaders[panel.name] = true
				end
				shownpanels = shownpanels + 1
			end
		end
		local Smin, Smax = InterfaceOptionsFrameAddOnsListScrollBar:GetMinMaxValues()
		InterfaceOptionsFrameAddOnsListScrollBar:SetValue((Smax/(shownpanels-15))*(mypanel-2))
		doNotRun = true
		InterfaceOptionsFrame_OpenToCategory(panel)
		doNotRun = false
	end
	hooksecurefunc("InterfaceOptionsFrame_OpenToCategory", InterfaceOptionsFrame_OpenToCategory_Fix)
end

-- Fix for minimap ping points not updating as your character moves.
-- Original code taken from AntiRadarJam by Lombra with permission.
-- Confirmed fixed in Cataclysm.
if tocversion < 40000 then
	MinimapPing:HookScript("OnUpdate", function(self, elapsed)
		if self.fadeOut or self.timer > MINIMAPPING_FADE_TIMER then
			Minimap_SetPing(Minimap:GetPingPosition())
		end
	end)
end

-- Fix for errors when opening the map that people started finding with
-- 4.0.3a.  The problem exists because QuestPOIGetQuestIDByVisible does
-- not sort completed quests to the top.  If there is an uncompleted
-- quest then Blizzard's implementation of the POI icons breaks since it
-- assumes that all the buttons from 1 to the last known index exists.
--
-- This fix makes the quests sort in the order that the rest of Blizzard's
-- code assumes they will.
if tonumber(wow_build) >= 13329 then
	local QuestMapUpdateAllQuests_blizz = QuestMapUpdateAllQuests
	local QuestPOIGetQuestIDByVisibleIndex_blizz = QuestPOIGetQuestIDByVisibleIndex
	local cache = {}

	local function sort_by_completed(a, b)
		if not a then
			return false
		elseif not b then
			return true
		end

		-- completed first
		local a_completed, b_completed = a.isComplete, b.isComplete
		if a_completed and not b_completed then
			return true
		elseif not a_completed and b_completed then
			return false
		end

		-- keep original order otherwise
		local a_id, b_id = a.i, b.i
		if not a_id then 
			return false
		elseif not b_id then
			return true
		end
		return a_id < b_id
	end

	function QuestMapUpdateAllQuests()
		for i=1,#cache do
			if cache[i] then
				wipe(cache[i])
			end
		end
		local playerMoney = GetMoney();
		local numEntries = QuestMapUpdateAllQuests_blizz()
		for i=1,numEntries do
			local entry = cache[i]
			if not entry then
				entry = {}
				cache[i] = entry
			end
			local questId, questLogIndex = QuestPOIGetQuestIDByVisibleIndex_blizz(i)
			local _, _, _, _, _, _, isComplete = GetQuestLogTitle(questLogIndex)
			local requiredMoney = GetQuestLogRequiredMoney(questLogIndex)
			local numObjectives = GetNumQuestLeaderBoards(questLogIndex)
			if isComplete and isComplete < 0 then
				isComplete = false
			elseif numObjectives == 0 and playerMoney >= requiredMoney then
				isComplete = true
			end
			entry.i = i
			entry.questId = questId
			entry.questLogIndex = questLogIndex
			entry.isComplete = isComplete
		end 
		sort(cache, sort_by_completed)
		return numEntries
	end

	function QuestPOIGetQuestIDByVisibleIndex(i)
		local entry = cache[i]
		if not entry then return nil,nil end
		return entry.questId, entry.questLogIndex
	end

end
