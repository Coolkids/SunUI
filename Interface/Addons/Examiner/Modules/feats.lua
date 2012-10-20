local ex = Examiner;
local gtt = GameTooltip;
local GetAchievementInfo = GetAchievementInfo;
local GetAchievementComparisonInfo = GetAchievementComparisonInfo;
local GetAchievementCategory = GetAchievementCategory;
local GetComparisonStatistic = GetComparisonStatistic;
local GetCategoryInfo = GetCategoryInfo;
local GetCategoryNumAchievements = GetCategoryNumAchievements;
local GetComparisonCategoryNumAchievements = GetComparisonCategoryNumAchievements;

-- Module
local mod = ex:CreateModule("Feats",ACHIEVEMENTS.." & "..STATISTICS);
mod.help = "Right Click for extended menu";
mod:CreatePage(true,"");
mod:HasButton(true);
mod.details = ex:CreateDetailObject();
mod.canCache = true;

-- Work Variables
local cfg;
local cache;
local feats = LibTableRecycler:New();
local catList = {};
local buttons = {};
local catDropDown;
local UpdateShownItems;

-- Constants
local NUM_BUTTONS = 8;
local BUTTON_HEIGHT = (252 / NUM_BUTTONS);
local GUILD_GUID_MASK_UPPER = 0x1FF20000;	-- Az: not sure this is ideal?
local professionFeatIds = { 1527, 1532, 1535, 1536, 1537, 1538, 1539, 1540, 1541, 1542, 1544 };
local featsSortMethods = { "none", "name", "category", "reward", "id", "value", "completed", "points" };

-- Stubs
local STUB_FEATS = -10;
local STUB_TRACKED = -11
local STUB_RECENT = -12;

-- Constatants from Blizzard_AchievementUI.lua
local FEAT_OF_STRENGTH_ID = 81;
local GUILD_CATEGORY_ID = 15076;
local GUILD_FEAT_OF_STRENGTH_ID = 15093;

-- Dialog Func
local FeatsFilterOkayFunc = function(text) cfg.featsFilter = text; mod:QueryFeats(); end

-- Options
ex.options[#ex.options + 1] = { var = "inspectFeats", default = true, label = "Request Achievement Data", tip = "Asks the server for achievement data when inspecting a player" };
ex.options[#ex.options + 1] = { var = "featsSpecialTooltip", default = false, label = "Special Achievement Tooltip", tip = "Show a tooltip that displays a little more information than the default achievement tooltips" };

-- OnShow
mod.page:SetScript("OnShow",function(self) if (#feats == 0) then mod:QueryFeats(); end end);

--------------------------------------------------------------------------------------------------------
--                                           Module Scripts                                           --
--------------------------------------------------------------------------------------------------------

-- OnInitialize
function mod:OnInitialize()
	cfg = Examiner_Config;
	cache = Examiner_Cache;
	-- Defaults
	cfg.featsCat = cfg.featsCat or 92;	-- 92 is the General category
	cfg.featsStub = cfg.featsStub or -1;
	cfg.featsSort = cfg.featsSort or "none";
	cfg.featsFilter = cfg.featsFilter or "";
	-- Add cache sort method
	local cacheMod = ex:GetModuleFromToken("Cache");
	if (cacheMod) and (cacheMod.cacheSortMethods) then
		cacheMod.cacheSortMethods[#cacheMod.cacheSortMethods + 1] = "achievementPoints";
	end
end

-- OnButtonClick
function mod:OnButtonClick(frame,button)
	-- left
	if (button == "LeftButton") then
		if (IsShiftKeyDown()) then
			AzDialog:Show("Enter new feats filter...",cfg.featsFilter,FeatsFilterOkayFunc);
		end
	-- right
	elseif (IsShiftKeyDown()) then
		cfg.featsFilter = "";
		cfg.featsHideComplete = false;
		cfg.featsHideIncomplete = false;
		self:QueryFeats();
	end
end

-- OnInspect -- Request Achievements, which work even when CanInspect() returns false, range seems to not matter either, unit just have to be in loading range.
function mod:OnInspect(unit)
	if (cfg.inspectFeats and ex.unitType ~= 1 and UnitIsVisible(unit)) then
		ex:RequestAchievementData();
	end
end

-- Achievements Update "Feats"
function mod:OnAchievementReady(unit,guid)
	self:HasData(true);
	if (self:IsShown()) then
		self:QueryFeats();
	end
	-- Details
	self.details:Add(TRADE_SKILLS);
	for index, id in ipairs(professionFeatIds) do
		local skill = GetComparisonStatistic(id);
		local val, max = skill:match("(%d+) / (%d+)");
		if (val and max) then
			local _, name = GetAchievementInfo(id);
			self.details:Add(name,skill);
		end
	end
	self.details:Update();
end

-- OnCacheLoaded
function mod:OnCacheLoaded(entry,unit)
	if (not unit) then
		self:HasData(nil);
		if (entry.achievementPoints) then
			self.details:Add(ACHIEVEMENTS);
			self.details:Add("Points",entry.achievementPoints);
			self.details:Update();
		end
	end
end

-- OnCache
function mod:OnCache(entry,unit)
	if (self:CanCache()) and (self.hasData) then
		entry.achievementPoints = GetComparisonAchievementPoints();
	end
end

-- OnClearInspect
function mod:OnClearInspect()
	self:HasData(nil);
	self.details:Clear();
	feats:Recycle();
	self.page.header:SetText();
	for i = 1, #buttons do
		buttons[i]:Hide();
	end
end

--------------------------------------------------------------------------------------------------------
--                                          Helper Functions                                          --
--------------------------------------------------------------------------------------------------------

-- Construct Achievement Link
local function ConstructAchievementLink(guid,name,id,completed,day,month,year)
	if (ex.isSelf) then
		return GetAchievementLink(id);
	elseif (not guid) then
		local _, _, _, _, _, _, _, _, flags = GetAchievementInfo(id);
		local notGuildAchievement = (bit.band(flags,ACHIEVEMENT_FLAGS_GUILD) ~= ACHIEVEMENT_FLAGS_GUILD);
		--guid = (notGuildAchievement and ex.guid) or (ex.info.guildID and format("0x%.8x%.8x",GUILD_GUID_MASK_UPPER,ex.info.guildID) or 0); -- Old Pre-MoP
		guid = (notGuildAchievement and ex.guid or 0);
	end
	completed = (completed and 1 or 0);
	local bits = (completed * 0x7fffffff);
	return format("|cffffff00|Hachievement:%d:%s:%d:%d:%d:%d:%u:%u:%u:%u|h[%s]|h|r",id,tostring(guid):gsub("0x",""),completed,month or 0,day or 0,year or 0,bits,bits,bits,bits,name);
end

-- Red/Green Color
local function BoolCol(bool)
	return (bool and "|cff80ff80" or "|cffff8080");
end

-- Sort Feats Table
local function SortFeatsListFunc(a,b)
	if (cfg.featsSort == "date") and (a.day == b.day) and (a.month == b.month) and (a.year == b.year) or (cfg.featsSort ~= "date") and (a[cfg.featsSort] == b[cfg.featsSort]) then
		return a.name < b.name;
	elseif (cfg.featsSort == "completed") then
		return a[cfg.featsSort] and true;
	elseif (cfg.featsSort == "date") then
		local aValue = (a.year or 0) * 366 + (a.month or 0) * 31 + (a.day or 0);
		local bValue = (b.year or 0) * 366 + (b.month or 0) * 31 + (b.day or 0);
		return (aValue > bValue);
	else
		return (a[cfg.featsSort] or "") < (b[cfg.featsSort] or "");
	end
end

--------------------------------------------------------------------------------------------------------
--                                                Menu                                                --
--------------------------------------------------------------------------------------------------------

-- Menu Init Items
function mod.MenuInit(parent,list)
	-- filter
	list[1].text = "Filter"; list[1].header = 1;
	list[2].text = "Set Filter..."; list[2].value = 1;
	list[3].text = "Hide Complete"; list[3].value = 2; list[3].checked = cfg.featsHideComplete;
	list[4].text = "Hide Incomplete"; list[4].value = 3; list[4].checked = cfg.featsHideIncomplete;
	-- sort
	list[5].header = 1;
	list[6].text = "Sort Method"; list[6].header = 1;
	for index, method in ipairs(featsSortMethods) do
		list[index + 6].text = "Sort by "..method; list[index + 6].value = method; list[index + 6].checked = (cfg.featsSort == method);
	end
	-- sort: date
	local tbl = list[#list];
	tbl.text = "Sort by date"; tbl.value = "date"; tbl.checked = (cfg.featsSort == "date");
end

-- Menu Select Item
function mod.MenuSelect(parent,entry)
	-- Sort
	if (type(entry.value) == "string") then
		cfg.featsSort = entry.value;
		if (cfg.featsSort ~= "none") then
			sort(feats,SortFeatsListFunc);
			UpdateShownItems();
		else
			mod:QueryFeats();
		end
	-- Filter
	elseif (entry.value == 1) then
		AzDialog:Show("Enter new feats filter...",cfg.featsFilter,FeatsFilterOkayFunc);
	elseif (entry.value == 2) then
		cfg.featsHideComplete = not cfg.featsHideComplete;
		mod:QueryFeats();
	elseif (entry.value == 3) then
		cfg.featsHideIncomplete = not cfg.featsHideIncomplete;
		mod:QueryFeats();
	end
end

--------------------------------------------------------------------------------------------------------
--                                           Feats Functions                                          --
--------------------------------------------------------------------------------------------------------

-- FeatsEntry: OnClick
local function FeatsEntry_OnClick(self,button,down)
	local entry = feats[self.index];
	if (IsModifiedClick("CHATLINK")) then
		local isPlayer = ex:ValidateUnit() and UnitIsUnit(ex.unit,"player");
		local editBox = ChatEdit_GetActiveWindow();
		if (editBox and editBox:IsVisible()) then
			if (IsControlKeyDown()) then
				local type = (cfg.featsStub == GUILD_CATEGORY_ID and ex.info.guild or ex.info.name);
				local value = (entry.value and ": "..entry.value:gsub("|T[^|]-GoldIcon[^|]-|t","g"):gsub("|T[^|]-SilverIcon[^|]-|t","s"):gsub("|T[^|]-CopperIcon[^|]-|t","c") or "");
				editBox:Insert(type..": "..entry.name..value);
			else
				editBox:Insert(ConstructAchievementLink(nil,entry.name,entry.id,entry.completed,entry.day,entry.month,entry.year));
			end
		elseif (isPlayer) then
			if (IsTrackedAchievement(entry.id)) then
				RemoveTrackedAchievement(entry.id);
				if (cfg.featsStub == STUB_TRACKED) then
					mod:QueryFeats();
				end
			elseif (not entry.completed) then	-- One of the 4.0 patches made it impossible to track a completed achievement
				AddTrackedAchievement(entry.id);
			end
		end
	elseif (feats.sub) and (button == "RightButton") then
		mod:QueryFeats();
	elseif (button == "LeftButton") then
		mod:QuerySubFeats(entry.id);
	end
end

-- FeatsEntry: OnEnter
local function FeatsEntry_OnEnter(self,motion)
	local entry = feats[self.index];
	if (not entry) then
		return;
	end
	-- Player Tooltip
	local isPlayer = ex:ValidateUnit() and UnitIsUnit(ex.unit,"player");
	if (IsControlKeyDown()) then
		gtt:SetOwner(self,"ANCHOR_RIGHT");
		gtt:SetHyperlink(GetAchievementLink(entry.id));
		return;
	end
	-- Default Tooltip
	if (cfg.featsSpecialTooltip and IsAltKeyDown()) or (not cfg.featsSpecialTooltip and not IsAltKeyDown()) then
		gtt:SetOwner(self,"ANCHOR_RIGHT");
		gtt:SetHyperlink(ConstructAchievementLink(nil,entry.name,entry.id,entry.completed,entry.day,entry.month,entry.year));
		return;
	end
	-- Special Tooltip
	gtt:SetOwner(self,"ANCHOR_RIGHT");
	gtt:AddDoubleLine(entry.name,entry.value,nil,nil,nil,1,1,1);
	gtt:AddLine("<"..entry.category..">");
	gtt:AddLine(entry.reward,0.2,0.6,1);
	gtt:AddLine(entry.description,1,1,1,1);
	gtt:AddDoubleLine("Achievement Points",tostring(entry.points),0.25,.75,0.25,1,1,1);
	if (entry.year and entry.month and entry.day) then
		gtt:AddDoubleLine("Date Completed",format("%d.%.2d.%.2d",entry.year + 2000,entry.month,entry.day),0.25,0.75,0.25,1,1,1);
	end
	if (cfg.showFeatsId) then
		gtt:AddDoubleLine("Cat / Achievement ID",entry.catId.." / "..entry.id,0.25,0.75,0.25,1,1,1);
	end
	-- Criteria
 	local nCriteria = GetAchievementNumCriteria(entry.id);
 	if (nCriteria and nCriteria > 0) then
		gtt:AddLine(" ");
		gtt:AddLine("Achievement Criteria |cffffffff"..nCriteria);
		local index = 1;
		while (true) do
			--description, type, completed, quantity, reqQuantity, charName, flags, assetID, quantityString, criteriaID = GetAchievementCriteriaInfo(achievementID, criteriaNum)
			--local criteriaName, completed, month, day, year, charName, unknown = GetCriteriaComparisonInfo(entry.id,i,1);
			--gtt:AddDoubleLine(criteriaName and criteriaName ~= "" and (criteriaName.." ") or "n/a",criteriaNameOld,1,1,1);
			local criteriaName1, _, criteriaComplete1 = GetAchievementCriteriaInfo(entry.id,index);
			local criteriaName2, _, criteriaComplete2;
			if (index + 1 <= nCriteria) then
				criteriaName2, _, criteriaComplete2 = GetAchievementCriteriaInfo(entry.id,index + 1);
			end
--			criteriaComplete1 = (GetCriteriaComparisonInfo(entry.id,i,1) ~= nil);
--			if (criteriaName2) then
--				criteriaComplete2 = (GetCriteriaComparisonInfo(entry.id,i + 1,1) ~= nil);
--			end
			if (not criteriaName1) or (index == 43) then
				break;
			elseif (index == 41) then
				criteriaName2 = "...";
				criteriaComplete2 = false;
			end
			local r1, g1, b1 = (isPlayer and criteriaComplete1 and 0.25 or 0.5), (isPlayer and criteriaComplete1 and 0.75 or 0.5), (isPlayer and criteriaComplete1 and 0.25 or 0.5);
			local r2, g2, b2 = (isPlayer and criteriaComplete2 and 0.25 or 0.5), (isPlayer and criteriaComplete2 and 0.75 or 0.5), (isPlayer and criteriaComplete2 and 0.25 or 0.5);
			criteriaName1 = criteriaName1 and (isPlayer and "" or BoolCol(criteriaComplete1).."*|r")..(criteriaName1 == "" and "n/a" or criteriaName1);
			criteriaName2 = criteriaName2 and (criteriaName2 == "" and "n/a" or criteriaName2)..((isPlayer or criteriaName2 == "...") and "" or BoolCol(criteriaComplete2).."*");
			gtt:AddDoubleLine(criteriaName1,criteriaName2,r1,g1,b1,r2,g2,b2);
			index = (index + 2);
		end
	end
	-- Show
	gtt:Show();
end

-- ScrollBar: Feats update -- This is a local function, defined at the header
function UpdateShownItems()
	-- Header
	local hasFilter = (cfg.featsFilter ~= "" or cfg.featsHideComplete or cfg.featsHideIncomplete);
	local title = (cfg.featsStub == -2 and STATISTICS) or (cfg.featsStub == GUILD_CATEGORY_ID and GUILD.." "..ACHIEVEMENTS) or ACHIEVEMENTS;
	local points = (ex.isSelf and GetTotalAchievementPoints(cfg.featsStub == GUILD_CATEGORY_ID) or GetComparisonAchievementPoints());
	mod.page.header:SetFormattedText("%s (%d)%s",title,points,(hasFilter and " |cffffff00*" or ""));
	-- Update
	FauxScrollFrame_Update(mod.scroll,#feats,#buttons,BUTTON_HEIGHT);
	local gttOwner = gtt:GetOwner();
	local index = mod.scroll.offset;
	for i = 1, #buttons do
		index = (index + 1);
		local entry = feats[index];
		local btn = buttons[i];
		if (entry) then
			btn.index = index;
			btn.name:SetFormattedText("%s%s%s",BoolCol(entry.completed),entry.name,(entry.reward and "|cffffff00 *" or ""));
			btn.category:SetText((cfg.featsStub == -2 or cfg.featsCat == -1) and entry.category or entry.description);
			btn.val:SetText(entry.value);
			btn.icon:SetTexture(entry.icon or "Interface\\Icons\\INV_Misc_QuestionMark");
			if (btn == gttOwner) then
				FeatsEntry_OnEnter(btn);
			end
			btn:Show();
		else
			btn:Hide();
		end
	end
	-- Set Width
	buttons[1]:SetPoint("TOPRIGHT",#feats <= #buttons and -12 or -26,-68);
end

-- Add Feat Entry
local function AddFeatEntry(id,name,points,description,icon,reward)
	-- For guild achievements, we have to call "SetFocusedAchievement" to request the information from the server
	-- Az: This does not update immediately, we need to wait for some event? Perhaps CRITERIA_UPDATE, not sure.
	if (cfg.featsStub == GUILD_CATEGORY_ID) then
--local requiresRep, hasRep, repLevel = GetAchievementGuildRep(id);	-- Az: implement?
		SetFocusedAchievement(id);
	end
	-- Init
	local friendCompleted, friendMonth, friendDay, friendYear = GetAchievementComparisonInfo(id); -- Also returns a 5th parameter, which is 0 most of the time, guessing they are flags
	if (ex.isSelf) then
		local _, _, _, completed, month, day, year = GetAchievementInfo(id);
		friendCompleted, friendMonth, friendDay, friendYear = completed, month, day, year;
	end
	local catId = GetAchievementCategory(id);
	local value = ex.isSelf and GetStatistic(id) or GetComparisonStatistic(id);
	-- Cat
	local catName;
	local category, catParent = GetCategoryInfo(catId);
	while (catParent > 0) do
		catName, catParent = GetCategoryInfo(catParent);
		category = catName.." - "..category;
	end
	-- Cleanup
	if (icon == "") then
		icon = nil;
	end
	if (value == 0 or value == "0" or value == "--") then
		value = nil;
	end
	if (reward == "") then
		reward = nil;
	end
	if (cfg.featsStub == -2) then
		friendCompleted = (value ~= nil);
	end
	-- Filter + Add
	if (not cfg.featsHideComplete or not friendCompleted) and (not cfg.featsHideIncomplete or friendCompleted) then
		local filter = cfg.featsFilter:upper();
		if (filter == "") or (name:upper():find(filter)) or (description:upper():find(filter)) or (reward and reward:upper():find(filter)) then
			local tbl = feats:Fetch();
			tbl.id = id; tbl.category = category; tbl.catId = catId; tbl.name = name; tbl.icon = icon; tbl.points = points; tbl.reward = reward; tbl.description = description; tbl.value = value; tbl.completed = friendCompleted; tbl.month = friendMonth; tbl.day = friendDay; tbl.year = friendYear;
		end
	end
end

-- Add List of Achievements
local function AddAchievementList(...)
	for i = 1, select("#",...) do
		local idParam = select(i,...);
		local id, name, points, _, _, _, _, description, _, icon, reward = GetAchievementInfo(idParam);
		AddFeatEntry(id,name,points,description,icon,reward);
	end
end

-- Query "Feats"
function mod:QueryFeats()
	if (not self.hasData) then
		return;
	end
	feats.sub = nil;
	feats:Recycle();
	-- List Tracked Achievements
	if (cfg.featsStub == STUB_TRACKED) then
		AddAchievementList(GetTrackedAchievements());
	-- List Recent Achievements
	elseif (cfg.featsStub == STUB_RECENT) then
		AddAchievementList(GetLatestCompletedComparisonAchievements());
	-- Brute Force "Feats of Strength" achievements
	elseif (cfg.featsStub == STUB_FEATS) then
		for i = 1, 10000 do
			local success, id, name, points, _, _, _, _, description, _, icon, reward = pcall(GetAchievementInfo,i);	-- As of UI 40000, this will generate an error if an invalid achievement id is used, so we use pcall().
			if (success and id) then
				local catID = GetAchievementCategory(id);
				if (catID == FEAT_OF_STRENGTH_ID or catID == GUILD_FEAT_OF_STRENGTH_ID) then
					AddFeatEntry(id,name,points,description,icon,reward);
				end
			end
		end
	-- List Selected Category
	else
		for i = 1, GetCategoryNumAchievements(cfg.featsCat) do
			local id, name, points, _, _, _, _, description, _, icon, reward = GetAchievementInfo(cfg.featsCat,i);
			AddFeatEntry(id,name,points,description,icon,reward);
		end
	end
	-- Fin
	catDropDown:InitSelectedItem(cfg.featsCat);
	if (cfg.featsSort ~= "none") then
		sort(feats,SortFeatsListFunc);
	end
	UpdateShownItems();
end

-- Query Sub Feats
function mod:QuerySubFeats(id)
	-- Get First
	while (GetPreviousAchievement(id)) do
		id = GetPreviousAchievement(id);
	end
	-- Check if there are any followup achievements
	if (not GetNextAchievement(id)) then
		return;
	end
	-- Init
	feats:Recycle();
	local _, name, points, description, icon, reward;
	-- loop
	while (id) do
		id, name, points, _, _, _, _, description, _, icon, reward = GetAchievementInfo(id);
		AddFeatEntry(id,name,points,description,icon,reward);
		id = GetNextAchievement(id);
	end
	-- Fin
	if (cfg.featsSort ~= "none") then
		sort(feats,SortFeatsListFunc);
	end
	UpdateShownItems();
	feats.sub = 1;
end

--------------------------------------------------------------------------------------------------------
--                                         Category Drop Down                                         --
--------------------------------------------------------------------------------------------------------

-- Adds entries from one type of achievements
local function AddCategoryListEntries(func,list,stub,color,showComplete)
	func(catList);
	for _, catId in next, catList do
		local catName, catParent = GetCategoryInfo(catId);
		if (catParent) and (catParent < 0 or catParent == stub) then
			local count = GetCategoryNumAchievements(catId);
			local complete = showComplete and GetComparisonCategoryNumAchievements(catId);
			local tbl = list[#list + 1];
			tbl.text = showComplete and (color..catName.."|cffc0c0c0 ("..complete.."/"..count..")") or (color..catName.."|cffc0c0c0 ("..count..")");
			tbl.value = catId; tbl.stub = stub;
			for _, catId2 in next, catList do
				local catName2, catParent2 = GetCategoryInfo(catId2);
				if (catParent2 == catId) then
					local count = GetCategoryNumAchievements(catId2);
					local complete = showComplete and GetComparisonCategoryNumAchievements(catId2);
					local tbl = list[#list + 1];
					tbl.text = showComplete and (color.."     "..catName2.."|cffc0c0c0 ("..complete.."/"..count..")") or (color.."     "..catName2.."|cffc0c0c0 ("..count..")");
					tbl.value = catId2; tbl.stub = stub;
				end
			end
		end
	end
	wipe(catList);
end

-- InitFunc
local function FeatsDropDown_InitFunc(dropDown,list)
	-- All Feats of Strength
	local tbl = list[#list + 1];
	tbl.text = "|cff00c0ffFeats of Strength Query"; tbl.value = STUB_FEATS; tbl.stub = STUB_FEATS;
	-- Tracked Achievements
	local isPlayer = ex:ValidateUnit() and UnitIsUnit(ex.unit,"player");
	if (isPlayer) then
		local tbl = list[#list + 1];
		tbl.text = "|cff00c0ffTracked Achievements |cffc0c0c0("..GetNumTrackedAchievements()..")"; tbl.value = STUB_TRACKED; tbl.stub = STUB_TRACKED;
	end
	-- Recent Achievements
	local tbl = list[#list + 1];
	tbl.text = "|cff00c0ffRecent Achievements"; tbl.value = STUB_RECENT; tbl.stub = STUB_RECENT;
	-- Achievements
	local tbl = list[#list + 1];
	tbl.text = "All Achievements |cffc0c0c0("..GetComparisonCategoryNumAchievements(-1).."/"..GetCategoryNumAchievements(-1)..")"; tbl.value = -1; tbl.stub = -1;
	AddCategoryListEntries(GetCategoryList,list,-1,"|cff00ff00",true);
	-- Statistics
	local tbl = list[#list + 1];
	tbl.text = "All Statistics |cffc0c0c0("..GetCategoryNumAchievements(-2)..")"; tbl.value = -2; tbl.stub = -2;
	AddCategoryListEntries(GetStatisticsCategoryList,list,-2,"|cffffff00",false);
	-- Guild -- Az: Add root for guild achievements?
	if (ex.isSelf) then
--	local tbl = list[#list + 1];
--	tbl.text = "Guild Achievements |cffc0c0c0("..GetCategoryNumAchievements(-2)..")"; tbl.value = -2; tbl.stub = -2;
		AddCategoryListEntries(GetGuildCategoryList,list,GUILD_CATEGORY_ID,"|cff00FFFF",false);
	end
end

-- DropDown Text
local cat = mod.page:CreateFontString(nil,"ARTWORK","GameFontNormalSmall");
cat:SetPoint("TOPLEFT",14,-46);
cat:SetText("Category:");

-- DropDown
catDropDown = AzDropDown.CreateDropDown(mod.page,240,true,FeatsDropDown_InitFunc,function(dropDown,entry) cfg.featsCat = entry.value; cfg.featsStub = entry.stub; mod:QueryFeats(); end);
catDropDown:SetPoint("TOPRIGHT",-8,-40);

--------------------------------------------------------------------------------------------------------
--                                           Widget Creation                                          --
--------------------------------------------------------------------------------------------------------

-- Buttons
for i = 1, NUM_BUTTONS do
	local btn = CreateFrame("Button",nil,mod.page);
	btn:SetHeight(BUTTON_HEIGHT);
	btn:RegisterForClicks("LeftButtonDown","RightButtonDown");
	btn:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight");
	btn:Hide();

	if (i == 1) then
		btn:SetPoint("TOPLEFT",8,-68);
		btn:SetPoint("TOPRIGHT",-28,-68);
	else
		btn:SetPoint("TOPLEFT",buttons[i - 1],"BOTTOMLEFT");
		btn:SetPoint("TOPRIGHT",buttons[i - 1],"BOTTOMRIGHT");
	end

	btn:SetScript("OnClick",FeatsEntry_OnClick);
	btn:SetScript("OnEnter",FeatsEntry_OnEnter);
	btn:SetScript("OnLeave",ex.HideGTT);

	btn.icon = btn:CreateTexture(nil,"ARTWORK");
	btn.icon:SetPoint("LEFT",3,0);
	btn.icon:SetWidth(BUTTON_HEIGHT - 2);
	btn.icon:SetHeight(BUTTON_HEIGHT - 2);
	btn.icon:SetTexCoord(0.07,0.93,0.07,0.93);

	btn.val = btn:CreateFontString(nil,"ARTWORK","GameFontHighlightSmall");
	btn.val:SetPoint("RIGHT",-4,0);
	btn.val:SetTextColor(1,1,0);

	btn.name = btn:CreateFontString(nil,"ARTWORK","GameFontHighlightSmall");
	btn.name:SetPoint("LEFT",btn.icon,"RIGHT",3,6);
	btn.name:SetPoint("RIGHT",btn.val,"LEFT",-8,6);
	btn.name:SetJustifyH("LEFT");

	btn.category = btn:CreateFontString(nil,"ARTWORK","GameFontHighlightSmall");
	btn.category:SetPoint("TOPLEFT",btn.name,"BOTTOMLEFT",0,-2);
	btn.category:SetPoint("TOPRIGHT",btn.name,"BOTTOMRIGHT",0,-2);
	btn.category:SetJustifyH("LEFT");

	buttons[i] = btn;
end

-- Feats Scroll
mod.scroll = CreateFrame("ScrollFrame","Examiner"..mod.token.."Scroll",mod.page,"FauxScrollFrameTemplate");
mod.scroll:SetPoint("TOPLEFT",buttons[1]);
mod.scroll:SetPoint("BOTTOMRIGHT",buttons[#buttons],-6,-1);
mod.scroll:SetScript("OnVerticalScroll",function(self,offset) FauxScrollFrame_OnVerticalScroll(self,offset,BUTTON_HEIGHT,UpdateShownItems) end);