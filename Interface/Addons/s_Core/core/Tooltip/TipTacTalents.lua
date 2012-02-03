local S, C, L, DB = unpack(select(2, ...))
local gtt = GameTooltip;
local GetTalentTabInfo = GetTalentTabInfo;

-- Constants
local TALENTS_PREFIX = L["主天赋"];
local TALENTS_PREFIX2 = L["副天赋"];
local CACHE_SIZE = 25;		-- Change cache size here (Default 25)
local INSPECT_DELAY = 0.2;
local INSPECT_FREQ = 2;

-- Variables
local ttt = CreateFrame("Frame","TipTacTalents");
local cache = {};
local seccache = {};
local current = {};
local sec = {};

-- Time of the last inspect reuqest. Init this to zero, just to make sure. This is a global so other addons could use this variable as well
lastInspectRequest = 0;

-- Allow these to be accessed through other addons
ttt.cache = cache;
ttt.seccache = seccache;
ttt.current = current;
ttt.sec = sec;

ttt:Hide();

--------------------------------------------------------------------------------------------------------
--                                           Gather Talents                                           --
--------------------------------------------------------------------------------------------------------

local function GatherTalents(isInspect)
	-- Inspect functions will always use the active spec when not inspecting
	local group = GetActiveTalentGroup(isInspect);
	-- Get points per tree, and set "primaryTree" to the tree with most points
	local primaryTree = 1;
	local secTree = 1;
	for i = 1, 3 do
		local _, _, _, _, pointsSpent = GetTalentTabInfo(i,isInspect,nil,1);
		current[i] = pointsSpent;
		if (current[i] > current[primaryTree]) then
			primaryTree = i;
		end
	end
	local _, tabName = GetTalentTabInfo(primaryTree,isInspect,nil,1);
	current.tree = tabName;
	for i = 1, 3 do
		local _, _, _, _, secpointsSpent = GetTalentTabInfo(i,isInspect,nil,2);
		sec[i] = secpointsSpent;
		if (sec[i] > sec[secTree]) then
			secTree = i;
		end
	end
	local _, sectabName = GetTalentTabInfo(secTree,isInspect,nil,2);
	sec.tree = sectabName;	
	
	-- Az: Clear Inspect, as we are done using it
	if (isInspect) then
		ClearInspectPlayer();
	end
	-- Customise output. Use TipTac setting if it exists, otherwise just use formatting style one.
	local talentFormat = 1;
	if (current[primaryTree] == 0) then
		current.format = "无天赋";
	elseif (talentFormat == 1) then
		current.format = current.tree.." ("..current[1].."/"..current[2].."/"..current[3]..")";
	end
	if (sec[secTree] == 0) then
		sec.format = "无天赋";
	elseif (talentFormat == 1) then
		sec.format = sec.tree.." ("..sec[1].."/"..sec[2].."/"..sec[3]..")";
	end	
	-- Set the tips line output, for inspect, only update if the tip is still showing a unit!
	if (not isInspect) then
		if (group == 1) then
			gtt:AddLine(TALENTS_PREFIX.."|c000EEE00 "..current.format.."|r");
			gtt:AddLine(TALENTS_PREFIX2.."|c88888888 "..sec.format.."|r");
		else
			gtt:AddLine(TALENTS_PREFIX.."|c88888888 "..current.format.."|r");
			gtt:AddLine(TALENTS_PREFIX2.."|c000EEE00 "..sec.format.."|r");
		end
	elseif (gtt:GetUnit()) then
		for i = 2, gtt:NumLines() do
			if ((_G["GameTooltipTextLeft"..i]:GetText() or ""):match("^"..TALENTS_PREFIX)) then
				if (group == 1) then
					_G["GameTooltipTextLeft"..i]:SetFormattedText("%s%s",TALENTS_PREFIX,"|c000EEE00 "..current.format.."|r");
				else
					_G["GameTooltipTextLeft"..i]:SetFormattedText("%s%s",TALENTS_PREFIX,"|c88888888 "..current.format.."|r");
				end

				-- Do not call Show() if the tip is fading out, this only works with TipTac, if TipTacTalents are used alone, it might still bug the fadeout
				if (not gtt.fadeOut) then
					gtt:Show();
				end
			--	break;
			end
			if ((_G["GameTooltipTextLeft"..i]:GetText() or ""):match("^"..TALENTS_PREFIX2)) then
				if (group == 1) then
					_G["GameTooltipTextLeft"..i]:SetFormattedText("%s%s",TALENTS_PREFIX2,"|c88888888 "..sec.format.."|r");
				else
					_G["GameTooltipTextLeft"..i]:SetFormattedText("%s%s",TALENTS_PREFIX2,"|c000EEE00 "..sec.format.."|r");
				end
				-- Do not call Show() if the tip is fading out, this only works with TipTac, if TipTacTalents are used alone, it might still bug the fadeout
				if (not gtt.fadeOut) then
					gtt:Show();
				end
			--	break;
			end			
		end
	end
	-- Organise Cache
	local cacheSize = CACHE_SIZE;
	for i = #cache, 1, -1 do
		if (current.name == cache[i].name) then
			tremove(cache,i);
			break;
		end
	end
	if (#cache > cacheSize) then
		tremove(cache,1);
	end
	-- Cache the new entry
	if (cacheSize > 0) then
		cache[#cache + 1] = CopyTable(current);
	end
	
	for i = #seccache, 1, -1 do
		if (sec.name == seccache[i].name) then
			tremove(seccache,i);
			break;
		end
	end
	if (#seccache > cacheSize) then
		tremove(seccache,1);
	end
	-- Cache the new entry
	if (cacheSize > 0) then
		seccache[#seccache + 1] = CopyTable(sec);
	end	
end

--------------------------------------------------------------------------------------------------------
--                                           Event Handling                                           --
--------------------------------------------------------------------------------------------------------

-- OnEvent
ttt:SetScript("OnEvent",function(self,event,guid)
	self:UnregisterEvent(event);
	if (guid == current.guid or guid == sec.guid) then
		GatherTalents(1);
	end
end);

-- OnUpdate
ttt:SetScript("OnUpdate",function(self,elapsed)
	self.nextUpdate = (self.nextUpdate - elapsed);
	if (self.nextUpdate <= 0) then
		self:Hide();
		-- Make sure the mouseover unit is still our unit
		if (UnitGUID("mouseover") == current.guid) then
			lastInspectRequest = GetTime();
			self:RegisterEvent("INSPECT_READY");
			-- Az: Fix the blizzard inspect copypasta code (Blizzard_InspectUI\InspectPaperDollFrame.lua @ line 23)
			if (InspectFrame) then
				InspectFrame.unit = "player";
			end
			NotifyInspect(current.unit);
		end
	end
end);

-- HOOK: OnTooltipSetUnit
gtt:HookScript("OnTooltipSetUnit",function(self,...)
--	if C["tooltip"].ShowTalent ~= true) then
--		return;
--	end
	-- Abort any delayed inspect in progress
	ttt:Hide();
	-- Get the unit -- Check the UnitFrame unit if this tip is from a concated unit, such as "targettarget".
	local _, unit = self:GetUnit();
	if (not unit) then
		local mFocus = GetMouseFocus();
		if (mFocus) and (mFocus.unit) then
			unit = mFocus.unit;
		end
	end
	-- No Unit or not a Player
	if (not unit) or (not UnitIsPlayer(unit)) then
		return;
	end
	-- Only bother for players over level 9
	local level = UnitLevel(unit);
	if (level > 9 or level == -1) then
		-- Wipe Current Record
		wipe(current);
		current.unit = unit;
		current.name = UnitName(unit);
		current.guid = UnitGUID(unit);
		wipe(sec);
		sec.unit = unit;
		sec.name = UnitName(unit);
		sec.guid = UnitGUID(unit);
		
		-- No need for inspection on the player
		if (UnitIsUnit(unit,"player")) then
			GatherTalents();
			return;
		end
		group = GetActiveTalentGroup(1);
		-- Show Cached Talents, If Available
		local cacheLoaded = false;
		for _, entry in ipairs(cache) do
			if (current.name == entry.name) then
				if (group == 1) then
					self:AddLine(TALENTS_PREFIX.."|c000EEE00 "..entry.format.."|r");
				else
					self:AddLine(TALENTS_PREFIX.."|c88888888 "..entry.format.."|r");
				end
				current.tree = entry.tree;
				current.format = entry.format;
				current[1], current[2], current[3] = entry[1], entry[2], entry[3];
				cacheLoaded = true;
				break;
			end
		end
		for _, secentry in ipairs(seccache) do
			if (sec.name == secentry.name) then
				if (group == 2) then
					self:AddLine(TALENTS_PREFIX2.."|c000EEE00 "..secentry.format.."|r");
				else
					self:AddLine(TALENTS_PREFIX2.."|c88888888 "..secentry.format.."|r");
				end
				sec.tree = secentry.tree;
				sec.format = secentry.format;
				sec[1], sec[2], sec[3] = secentry[1], secentry[2], secentry[3];
				cacheLoaded = true;
				break;
			end
		end
		-- Queue an inspect request
		local isInspectOpen = (InspectFrame and InspectFrame:IsShown()) or (Examiner and Examiner:IsShown());
		if (CanInspect(unit)) and (not isInspectOpen) then
			local lastInspectTime = (GetTime() - lastInspectRequest);
			ttt.nextUpdate = (lastInspectTime > INSPECT_FREQ) and INSPECT_DELAY or (INSPECT_FREQ - lastInspectTime + INSPECT_DELAY);
			ttt:Show();
			if (not cacheLoaded) then
				self:AddLine(TALENTS_PREFIX.."Loading...");
				self:AddLine(TALENTS_PREFIX2.."Loading...");
			end
		end
	end
end);