local gtt = GameTooltip;

-- Create Examiner Frame
local modName = ...;
local ex = CreateFrame("Frame",modName,UIParent);

-- Global Chat Message Function
function AzMsg(msg) DEFAULT_CHAT_FRAME:AddMessage(tostring(msg):gsub("|1","|cffffff80"):gsub("|2","|cffffffff"),0.5,0.75,1.0); end

-- Local Saved Tables
local cfg, cache;

-- Data Tables
local info = { Sets = {}, Items = {} };
local unitStats = {};
local equippedSlots = {};
local statTipStats1, statTipStats2 = {}, {};
ex.compareStats = {};
ex.unitStats = unitStats;
ex.info = info;

-- Misc Constants
local DELAYED_INSPECT_TIME = 1;
local CLASSIFICATION_NAMES = {
	worldboss = BOSS,
	rareelite = ITEM_QUALITY3_DESC..ELITE,
	elite = ELITE,
	rare = ITEM_QUALITY3_DESC,
};

-- Colors
local CACHE_VERTEX_COLOR = { 1, 1, 0.4 };
local LOADING_VERTEX_COLOR = { 0.5, 1, 0.5 };
local CLASS_COLORS = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS;

-- Texture Mapping
local TALENT_BACKGROUNDS = {
	"DeathKnightBlood", "DeathKnightFrost", "DeathKnightUnholy",
	"DruidBalance", "DruidFeralCombat", "DruidRestoration",
	"HunterBeastMastery", "HunterMarksmanship", "HunterSurvival",
--	"HunterPetCunning", "HunterPetFerocity", "HunterPetTenacity",
	"MageArcane", "MageFire", "MageFrost",
	"PaladinCombat", "PaladinHoly", "PaladinProtection",
	"PriestDiscipline", "PriestHoly", "PriestShadow",
	"RogueAssassination", "RogueCombat", "RogueSubtlety",
	"ShamanElementalCombat", "ShamanEnhancement", "ShamanRestoration",
	"WarlockCurses", "WarlockDestruction", "WarlockSummoning",
	"WarriorArms", "WarriorFury", "WarriorProtection",
};

-- Options
ex.options = {
	{ var = "makeMovable", default = false, label = "Make Examiner Movable", tip = "To freely move Examiner around, enable this option, otherwise it will behave like a normal frame, such as the Quest Log or Spellbook" },
	{ var = "autoInspect", default = true, label = "Auto Inspect on Target Change", tip = "With this option turned on, Examiner will automatically inspect your new target when you change it." },
	{ var = "clearInspectOnHide", default = false, label = "Clear Inspect Data on Hide", tip = "When Examiner gets hidden, this option will clear inspection data, thus freeing up some memory." },
	{ var = "percentRatings", default = false, label = "Show Ratings in Percentage", tip = "With this option enabled, ratings will be displayed in percent relative to the inspected person's level." },
	{ var = "combineAdditiveStats", default = true, label = "Combine Additive Stats", tip = "This option will combine certain stats which stacks with others.\n- Spell Power to specific schools\n- Intellect to Spell Power\n- AP to Ranged AP" },
	{ var = "tooltipSmartAnchor", default = false, label = "Smart Tooltip Anchor", tip = "Instead of showing item tooltips next to the item button, it will place it next to the Examiner window, in a fixed position" },
};

-- Binding Name
BINDING_HEADER_EXAMINER = modName;
BINDING_NAME_EXAMINER_OPEN = "Open "..modName;
BINDING_NAME_EXAMINER_TARGET = INSPECT.." "..TARGET;
BINDING_NAME_EXAMINER_MOUSEOVER = INSPECT.." Mouseover";

--------------------------------------------------------------------------------------------------------
--                                          Examiner Scripts                                          --
--------------------------------------------------------------------------------------------------------

-- OnShow
local function Examiner_OnShow(self)
	self:RegisterEvent("PLAYER_TARGET_CHANGED");
	self:RegisterEvent("UNIT_MODEL_CHANGED");
	self:RegisterEvent("UNIT_PORTRAIT_UPDATE");
	self:RegisterEvent("UNIT_INVENTORY_CHANGED");
	self:RegisterEvent("MODIFIER_STATE_CHANGED");
end

-- OnHide
local function Examiner_OnHide(self)
	self.model.isRotating = nil;
	self.model.isPanning = nil;
	self:UnregisterEvent("INSPECT_READY");
	self:UnregisterEvent("PLAYER_TARGET_CHANGED");
	self:UnregisterEvent("UNIT_MODEL_CHANGED");
	self:UnregisterEvent("UNIT_PORTRAIT_UPDATE");
	self:UnregisterEvent("UNIT_INVENTORY_CHANGED");
	self:UnregisterEvent("MODIFIER_STATE_CHANGED");
	if (cfg.clearInspectOnHide) then
		ex:ClearInspect();
	else
		self:SetScript("OnUpdate",nil);
	end
end

-- OnUpdate
local function Examiner_OnUpdate(self,elapsed)
	if (self:ValidateUnit()) and (CheckInteractDistance(self.unit,1)) then
		self:DoInspect(self.unit);
	end
end

--------------------------------------------------------------------------------------------------------
--                                           Event Handling                                           --
--------------------------------------------------------------------------------------------------------

-- Variables Loaded
function ex:VARIABLES_LOADED(event)
	-- Config
	if (not Examiner_Config) then
		Examiner_Config = {};
	end
	cfg = Examiner_Config;
	if (not cfg.caching) then
		cfg.caching = {};
	end
	self.cfg = cfg;
	-- Load Defaults
	if (cfg.showBackground == nil) then
		cfg.showBackground = true;
	end
	for _, option in ipairs(self.options) do
		if (cfg[option.var] == nil) then
			cfg[option.var] = option.default;
		end
	end
	-- Cache
	if (not Examiner_Cache) then
		Examiner_Cache = {};
	end
	cache = Examiner_Cache;
	-- SET: Background Visibility | Scale | Frame Movability
	self:ShowBackground();
	self:SetScale(cfg.scale or 1);
	self:SetMovable(cfg.makeMovable);
	if (cfg.makeMovable) and (cfg.left and cfg.bottom) then
		self:ClearAllPoints();
		self:SetPoint("BOTTOMLEFT",cfg.left,cfg.bottom);
	end
	-- HOOK: InspectUnit
	InspectUnit = function(...) ex:DoInspect(...); end	-- Az: Disable for debugging
	-- Init Modules
	for index, mod in ipairs(self.modules) do
		if (mod.OnInitialize) then
			mod:OnInitialize();
			mod.OnInitialize = nil;
		end
	end
	-- Is active page valid?
	if (cfg.activePage) and (cfg.activePage > #self.modules or not self.modules[cfg.activePage].page) then
		cfg.activePage = nil;
	end
	-- Initialise the Config for Modules
	for _, option in ipairs(self.options) do
		self:SendModuleEvent("OnConfigChanged",option.var,cfg[option.var]);
	end
	-- Remove this event
	self:UnregisterEvent(event);
	self[event] = nil;
end

-- Target Unit Changed
function ex:PLAYER_TARGET_CHANGED(event)
	if (cfg.autoInspect) and (UnitExists("target")) then
		self:DoInspect("target");
	elseif (self.unit == "target") then
		self.unit = nil;
		self:SetScript("OnUpdate",nil);
	end
end

-- Mouseover Unit Changed
function ex:UPDATE_MOUSEOVER_UNIT(event)
	self.unit = nil;
	self:SetScript("OnUpdate",nil);
	self:UnregisterEvent("UPDATE_MOUSEOVER_UNIT");
end

-- Model or Portrait Change
function ex:UNIT_MODEL_CHANGED(event,unit)
	if (unit and self:ValidateUnit() and UnitIsUnit(unit,self.unit)) then
		self.model:SetUnit(self.unit);
		SetPortraitTexture(self.portrait,self.unit);
	end
end
ex.UNIT_PORTRAIT_UPDATE = ex.UNIT_MODEL_CHANGED;

-- Rescan Gear on Item Change
function ex:UNIT_INVENTORY_CHANGED(event,unit)
	if (self:ValidateUnit() and UnitIsUnit(unit,self.unit) and CheckInteractDistance(self.unit,1)) then
		self:ScanGear(unit);
		self:SendModuleEvent("OnInspectReady",unit,self.guid);
	end
end

-- Modifier State Changed
function ex:MODIFIER_STATE_CHANGED(event)
	if (self.showingTooltip) then
		local mFocus = GetMouseFocus();
		if (GetMouseFocus and GetMouseFocus ~= UIParent) then
			local onEnterFunc = mFocus:GetScript("OnEnter");
			if (onEnterFunc) then
				onEnterFunc(mFocus);
			end
		end
	end
end

-- Inspect Ready -- This event will never fire when on a public transport mount for some odd reason
function ex:INSPECT_READY(event,guid)
	self:UnregisterEvent("INSPECT_READY");
	self:InspectReady(guid);
end

--------------------------------------------------------------------------------------------------------
--                                         Model Frame Scripts                                        --
--------------------------------------------------------------------------------------------------------

-- Model Frame Workaround
local function Model_OnShow(self)
	if (self.cleared) then
		self:ClearModel();
	end
end

local function Model_OnUpdate(self,elapsed)
	if (self.isRotating) then
		local endx, endy = GetCursorPosition();
		self.rotation = (endx - self.startx) / 34 + self:GetFacing();
		self:SetFacing(self.rotation);
		self.startx, self.starty = GetCursorPosition();
	elseif (self.isPanning) then
		local endx, endy = GetCursorPosition();
		local z, x, y = self:GetPosition(z,x,y);
		x = (endx - self.startx) / 45 + x;
		y = (endy - self.starty) / 45 + y;
		self:SetPosition(z,x,y);
		self.startx, self.starty = GetCursorPosition();
	end
end

local function Model_OnMouseWheel(self,delta)
	local z, x, y = self:GetPosition();
	local scale = (IsControlKeyDown() and 2 or 0.7);
	z = (delta > 0 and z + scale or z - scale);
	self:SetPosition(z,x,y);
end

local function Model_OnMouseDown(self,button)
	self.startx, self.starty = GetCursorPosition();
	if (button == "LeftButton") then
		self.isRotating = 1;
		if (IsControlKeyDown()) then
			ex:SetBackgroundTexture(true);
		end
	elseif (button == "RightButton") then
		self.isPanning = 1;
		if (IsControlKeyDown()) then
			cfg.showBackground = (not cfg.showBackground);
			ex:ShowBackground();
		end
	end
end

local function Model_OnMouseUp(self,button)
	if (button == "LeftButton") then
		self.isRotating = nil;
	elseif (button == "RightButton") then
		self.isPanning = nil;
	end
end

--------------------------------------------------------------------------------------------------------
--                                            Init Examiner                                           --
--------------------------------------------------------------------------------------------------------

-- Allow Inspect from Any Range
UnitPopupButtons.INSPECT.dist = 0;
-- UIPanelWindow Entry
UIPanelWindows[modName] = { area = "left", pushable = 1, whileDead = 1 };
-- Allows the use of Esc to close the window
UISpecialFrames[#UISpecialFrames + 1] = modName;

-- Examiner Main Frame
ex:SetWidth(384);
ex:SetHeight(440);
ex:SetPoint("CENTER");
ex:SetToplevel(1);
ex:EnableMouse(1);
ex:Hide();
ex:SetHitRectInsets(12,35,10,2);
ex:SetScript("OnShow",Examiner_OnShow);
ex:SetScript("OnHide",Examiner_OnHide);
ex:SetScript("OnEvent",function(self,event,...) self[event](self,event,...); end);
ex:SetScript("OnMouseDown",function(self,button) if (self:IsMovable()) then self:StartMoving(); end end);
ex:SetScript("OnMouseUp",function(self,button) if (self:IsMovable()) then self:StopMovingOrSizing(); cfg.left = self:GetLeft(); cfg.bottom = self:GetBottom() end end);

-- Events
ex:RegisterEvent("VARIABLES_LOADED");

-- Close Button
CreateFrame("Button",nil,ex,"UIPanelCloseButton"):SetPoint("TOPRIGHT",-30,-8);

-- Portrait
ex.portrait = ex:CreateTexture(nil,"BACKGROUND");
ex.portrait:SetWidth(60);
ex.portrait:SetHeight(60);
ex.portrait:SetPoint("TOPLEFT",7,-6);

-- FontStrings
ex.title = ex:CreateFontString(nil,"ARTWORK","GameFontNormal");
ex.title:SetPoint("TOP",5,-17);
ex.details = ex:CreateFontString(nil,"ARTWORK","GameFontHighlightSmall");
ex.details:SetPoint("TOP",5,-44);
ex.guild = ex:CreateFontString(nil,"ARTWORK","GameFontHighlightSmall");
ex.guild:SetPoint("TOP",ex.details,"BOTTOM",0,-2);

-- Dialog Textures
ex.dlgTopLeft = ex:CreateTexture(nil,"ARTWORK");
ex.dlgTopLeft:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-General-TopLeft");
ex.dlgTopLeft:SetPoint("TOPLEFT");
ex.dlgTopLeft:SetWidth(256);
ex.dlgTopLeft:SetHeight(256);
ex.dlgTopRight = ex:CreateTexture(nil,"ARTWORK");
ex.dlgTopRight:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-General-TopRight");
ex.dlgTopRight:SetPoint("TOPRIGHT");
ex.dlgTopRight:SetWidth(128);
ex.dlgTopRight:SetHeight(256);
ex.dlgBottomLeft = ex:CreateTexture(nil,"ARTWORK");
ex.dlgBottomLeft:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-General-BottomLeft");
ex.dlgBottomLeft:SetPoint("TOPLEFT",0,-256);
ex.dlgBottomLeft:SetWidth(256);
ex.dlgBottomLeft:SetHeight(256);
ex.dlgBottomRight = ex:CreateTexture(nil,"ARTWORK");
ex.dlgBottomRight:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-General-BottomRight");
ex.dlgBottomRight:SetPoint("TOPRIGHT",0,-256);
ex.dlgBottomRight:SetWidth(128);
ex.dlgBottomRight:SetHeight(256);

-- Background Textures -- Resize height, so they go beneath module buttons
local bgScale = 1.064;
ex.bgTopLeft = ex:CreateTexture(nil,"OVERLAY");
ex.bgTopLeft:SetPoint("TOPLEFT",21,-76);
ex.bgTopLeft:SetHeight(256 * bgScale);
ex.bgTopRight = ex:CreateTexture(nil,"OVERLAY");
ex.bgTopRight:SetPoint("LEFT",ex.bgTopLeft,"RIGHT");
ex.bgTopRight:SetHeight(256 * bgScale);
ex.bgBottomLeft = ex:CreateTexture(nil,"OVERLAY");
ex.bgBottomLeft:SetPoint("TOP",ex.bgTopLeft,"BOTTOM");
ex.bgBottomLeft:SetHeight(128 * bgScale);
ex.bgBottomRight = ex:CreateTexture(nil,"OVERLAY");
ex.bgBottomRight:SetPoint("LEFT",ex.bgBottomLeft,"RIGHT");
ex.bgBottomRight:SetHeight(128 * bgScale);

-- Model
ex.model = CreateFrame("PlayerModel",nil,ex);
ex.model:SetWidth(320);
ex.model:SetHeight(354);
ex.model:SetPoint("BOTTOM",-11,10);
ex.model:EnableMouse(1);
ex.model:EnableMouseWheel(1);
ex.model:SetScript("OnShow",Model_OnShow);
ex.model:SetScript("OnUpdate",Model_OnUpdate);
ex.model:SetScript("OnMouseDown",Model_OnMouseDown);
ex.model:SetScript("OnMouseUp",Model_OnMouseUp);
ex.model:SetScript("OnMouseWheel",Model_OnMouseWheel);

--------------------------------------------------------------------------------------------------------
--                                            Unit Details                                            --
--------------------------------------------------------------------------------------------------------

local uDetails = {};

-- Unit Detail String
function ex:SetUnitDetailString()
	-- Level
	local color = GetQuestDifficultyColor(info.level ~= -1 and info.level or 500);
	uDetails[#uDetails + 1] = format("%s |cff%.2x%.2x%.2x%s|r",LEVEL,color.r * 255,color.g * 255,color.b * 255,(info.level ~= -1 and info.level or "??"));
	-- Classification (non players only, so ok to use ex.unit)
	if (not info.raceFixed) then
		local classification = UnitClassification(ex.unit);
		if (CLASSIFICATION_NAMES[classification]) then
			uDetails[#uDetails + 1] = "("..CLASSIFICATION_NAMES[classification]..")";
		end
	end
	-- Race for Players / Family or Type for NPC's
	if (info.race) then
		uDetails[#uDetails + 1] = (info.race ~= "Not specified" and info.race or UNKNOWN);
	end
	-- Players Only: Class (+ Realm)
	if (info.raceFixed) then
		if (info.class) then
			local color = CLASS_COLORS[info.classFixed];
			uDetails[#uDetails + 1] = format("|cff%.2x%.2x%.2x%s|r",color.r * 255,color.g * 255,color.b * 255,info.class);
		end
		if (info.realm) then
			uDetails[#uDetails + 1] = "of "..info.realm
		end
	end
	-- Set Result
	self.details:SetText(table.concat(uDetails," "));
	wipe(uDetails);
end

-- Unit Guild String (Faction for NPC's)
function ex:SetUnitGuildString()
	-- Init as empty
	self.guild:SetText("");
	-- Players
	if (info.raceFixed) then
		if (info.guild and info.guildRank and info.guildIndex) then
			self.guild:SetFormattedText("%s (%d) of <%s>",info.guildRank,info.guildIndex,info.guild);
		end
	-- NPC's only, so ok to use 'ex.unit' here
	else
		LibGearExamTip:ClearLines();
		LibGearExamTip:SetUnit(ex.unit);
		local line;
		for i = 2, LibGearExamTip:NumLines() - 1 do
			line = _G["LibGearExamTipTextLeft"..i]:GetText();
			if (line:find("^"..TOOLTIP_UNIT_LEVEL:gsub("%%s",".+"))) then
				line = _G["LibGearExamTipTextLeft"..(i + 1)]:GetText();
				if (line ~= PVP_ENABLED) then
					self.guild:SetText(line);
					return;
				end
			end
		end
	end
end

-- Return name used for entires
function ex:GetEntryName()
	return (info.realm and info.name.."-"..info.realm or info.name);
end

--------------------------------------------------------------------------------------------------------
--                                           Cache Functions                                          --
--------------------------------------------------------------------------------------------------------

-- Cache Player
function ex:CachePlayer(override)
	if (cfg.caching.Core or override) then
		local entry = ex:GetEntryName();
		cache[entry] = CopyTable(info);
		self:SendModuleEvent("OnCache",cache[entry]);
		return 1;
	end
end

-- Load player from cache
function ex:LoadPlayerFromCache(entryName)
	local entry = cache[entryName];
	if (not entry) then
		return false;
	end
	-- Load Depending on Unit Token
	info.time = entry.time;
	info.zone = entry.zone;
	if (not self.unit or info.level == -1) then
		info.level = entry.level;
	end
	if (not self.unit or not UnitIsVisible(self.unit)) then
		info.pvpName = entry.pvpName;
		info.guild, info.guildRank, info.guildIndex = entry.guild, entry.guildRank, entry.guildIndex;
		--info.guildID, info.guildLevel, info.guildXP, info.guildMembers = entry.guildID, entry.guildLevel, entry.guildXP, entry.guildMembers; -- Old Pre-MoP
		info.guildLevel, info.guildXP, info.guildMembers = entry.guildLevel, entry.guildXP, entry.guildMembers;
		if (not self.unit) then
			info.name, info.realm = entry.name, entry.realm;
			info.level = entry.level;
			info.class, info.classFixed = entry.class, entry.classFixed;
			info.race, info.raceFixed = entry.race, entry.raceFixed;
			info.sex = entry.sex;
		end
	end
	-- Item Slots
	for slotName, slotId in next, LibGearExam.SlotIDs do
		local link = entry.Items[slotName];
		info.Items[slotName] = link;
		LibGearExam:ScanItemLink(link,unitStats);
	end
	-- Sets + Set Bonuses
	for setName, setEntry in next, entry.Sets do
		info.Sets[setName] = { count = setEntry.count, max = setEntry.max };
		local idx = 1;
		while (setEntry["setBonus"..idx]) do
			info.Sets[setName]["setBonus"..idx] = setEntry["setBonus"..idx];
			LibGearExam:ScanLineForPatterns(setEntry["setBonus"..idx],unitStats);
			idx = (idx + 1);
		end
	end
	-- Finalize
	self.isCacheEntry = true;
	self.itemsLoaded = true;
	-- Update UI
	self:SetBackgroundVertex(unpack(CACHE_VERTEX_COLOR));
	self:UpdateObjects();
	self:ShowModulePage();
	-- Modules: OnCacheLoaded
	self:SendModuleEvent("OnCacheLoaded",entry,self.unit);
	return true;
end

--------------------------------------------------------------------------------------------------------
--                                         Inspect Functions                                          --
--------------------------------------------------------------------------------------------------------

-- CanInspect function override as the normal function seems bugged.
local function Examiner_CanInspect(unit)
	-- If CanInspect() says yes, then go ahead. Otherwise only inspect if not npc, is visible, and in range, not only that, but the unit has to be friendly, or a non flagged foe.
	return CanInspect(unit) or (ex.unitType ~= 1 and UnitIsVisible(unit) and CheckInteractDistance(unit,1) and (ex.unitType == 3 or not UnitIsPVP(unit) or UnitIsPVPSanctuary(unit)));
end

-- Normal Open
function ex:OpenSimple()
	if (not info.name) then
		self:DoInspect("player");
	elseif (self:IsVisible()) then
		HideUIPanel(self);
	elseif (cfg.makeMovable) then
		self:Show();
	else
		ShowUIPanel(self);
	end
end

-- Normal Open
function ex:InspectMouseover()
	local unit = "mouseover";
	-- See if mouseover == unitframe unit
	local mouseFocus = GetMouseFocus();
	if (mouseFocus) then
		unit = (mouseFocus:GetAttribute("unit") or unit);
	end
	-- Show/Hide
	if (not UnitExists(unit)) then
		HideUIPanel(self);
	else
		self:DoInspect(unit);
	end
end

-- ClearInspect -- Clears all work variables. Always called before a new inspect request!
function ex:ClearInspect()
	INSPECTED_UNIT = nil;
	-- unit specific
	self.unit = nil;
	self.guid = nil;
	self.isSelf = nil;
	self.unitType = nil;
	self.canInspect = nil;
	-- data specific
	self.itemsLoaded = nil;
	self.isCacheEntry = nil;
	-- clear inspections
	ClearInspectPlayer();
	if (self.requestedAchievementData) then
		ClearAchievementComparisonUnit();
		self.requestedAchievementData = nil;
	end
	self.requestedHonorData = nil;
	-- core
	wipe(unitStats);
	for k, v in next, info do
		if (type(v) == "table") then
			wipe(v);
		else
			info[k] = nil;
		end
	end
	self:SetScript("OnUpdate",nil);
	-- Reset Vertex Color
	self:SetBackgroundVertex(1,1,1);
	-- post module event
	self:SendModuleEvent("OnClearInspect");
end

-- Inspect Ready
function ex:InspectReady(guid)
	if (self:ValidateUnit()) then
		local unit = self.unit;
		-- Guild Vars -- Returns zeros for unguilded people
		local info = self.info;
		if (info.guild) then
			--info.guildID, info.guildLevel, info.guildXP, info.guildMembers = GetInspectGuildInfo(unit);	-- Az: move this into guild.lua? -- Old Pre-MoP
			info.guildLevel, info.guildXP, info.guildMembers = GetInspectGuildInfo(unit);	-- MoP: No more guildID as first return -- Az: move this into guild.lua?
		end
		-- Scan Gear & Post InspectReady
		self:ScanGear(unit);
		self:ShowModulePage();
		self:SendModuleEvent("OnInspectReady",unit,guid);
		-- Cache
		if (self.itemsLoaded) then
			self:CachePlayer();
		end
		-- Reset Vertex Color
		self:SetBackgroundVertex(1,1,1);
	end
end

-- Inspect Unit
function ex:DoInspect(unit,openFlag)
	-- Clear
	self:ClearInspect();
	-- Check unit, fall back on player
	if (not unit or not UnitExists(unit)) then
		unit = "player";
	-- Convert "mouseover" and "target" units to party/raid unit
	elseif (unit == "mouseover") or (unit == "target") then
		local count = GetNumGroupMembers();
		if (count) and (count > 0) then
			local isRaid = IsInRaid();
			for i = 1, count do
				local token = (isRaid and "raid" or "party")..i;
				if (UnitIsUnit(unit,token)) then
					unit = token;
					break;
				end
			end
		end
	end
	-- Mouseover Event
	if (unit == "mouseover") then
		self:RegisterEvent("UPDATE_MOUSEOVER_UNIT");
	else
		self:UnregisterEvent("UPDATE_MOUSEOVER_UNIT");
	end
	-- Set Work Variables
	INSPECTED_UNIT = unit;
	self.unit = unit;
	self.guid = UnitGUID(unit);
	self.isSelf = UnitIsUnit(unit,"player");
	self.unitType = (not UnitIsPlayer(unit) and 1) or (UnitCanCooperate("player",unit) and 3) or 2;	-- Unit Type (1 = npc, 2 = opposing faction, 3 = same faction)
	self.canInspect = Examiner_CanInspect(unit);
	-- Gather Unit Info
	info.isSelf = self.isSelf;	-- This is what allows the cache module to filter out alts
	info.name, info.realm = UnitName(unit);
	if (info.realm == "") then
		info.realm = nil;
	end
	info.pvpName = UnitPVPName(unit);
	info.level = (UnitLevel(unit) or 0);
	info.sex = (UnitSex(unit) or 1);
	info.class, info.classFixed = UnitClass(unit);
	info.race, info.raceFixed = UnitRace(unit);
	if (not info.race) then
		info.race = UnitCreatureFamily(unit) or UnitCreatureType(unit);
	end
	info.guild, info.guildRank, info.guildIndex = GetGuildInfo(unit);
	info.time = time();
	info.zone = GetMinimapZoneText();
	local realZone = GetRealZoneText();
	if (realZone ~= info.zone) then
		info.zone = realZone..", "..info.zone;
	end
	-- Players we can Inspect
	if (self.canInspect) then
		-- Vertex Color = LOADING
		self:SetBackgroundVertex(unpack(LOADING_VERTEX_COLOR));
		-- Magic Inspect Supernova
		self:RegisterEvent("INSPECT_READY");
		NotifyInspect(unit);
		lastInspectRequest = GetTime();
		-- When we call ScanGear here, even before INSPECT_READY. We can sorta force the client into precaching the items.
		self:ScanGear(unit);
	end
	-- Update the UI Objects
	if (self.unitType == 1) and (cfg.activePage) then
		self.modules[cfg.activePage].page:Hide();
	else
		self:ShowModulePage();
	end
	self:UpdateObjects();
	-- Modules: OnInspect
	self:SendModuleEvent("OnInspect",unit,self.guid);
	-- Player Only Code
	if (self.unitType ~= 1) then
		-- We couldn't Inspect, try and see if we have them cached?
		if (not self.canInspect) and (not self:LoadPlayerFromCache(self:GetEntryName())) and (cfg.activePage) then
			self.modules[cfg.activePage].page:Hide();	-- Az: this is slightly bad to do, what if a module still have data to show? feats still work outside inspect range for example
		end
		-- Outside range, monitor range and inspect as soon as they are in range
		if (not CheckInteractDistance(unit,1)) then
			self:SetScript("OnUpdate",Examiner_OnUpdate);
		end
	end
	-- Show Examiner
	if (openFlag ~= false) and (not self:IsShown()) then
		if (cfg.makeMovable) then
			self:Show();
		else
			ShowUIPanel(self);
		end
	end
end

-- Scans the Gear
function ex:ScanGear(unit)
	wipe(unitStats);
	wipe(info.Sets);
	LibGearExam:ScanUnitItems(unit,unitStats,info.Sets);
	for slotName, slotId in next, LibGearExam.SlotIDs do
		local link = (GetInventoryItemLink(unit,slotId) or ""):match(LibGearExam.ITEMLINK_PATTERN);
		info.Items[slotName] = LibGearExam:FixItemStringLevel(link,ex.info.level);	-- Fix item string level
		if (link) then
			ex.itemsLoaded = true;
		end
	end
end

--------------------------------------------------------------------------------------------------------
--                                        Additional Inspection                                       --
--------------------------------------------------------------------------------------------------------

-- INSPECT_HONOR_UPDATE
function ex:INSPECT_HONOR_UPDATE(event)
	self:RequestHonorData();
	self:SendModuleEvent("OnHonorReady");
end

-- Requests Honor Data
function ex:RequestHonorData()
	if (self.requestedHonorData) then
		return;
	elseif (HasInspectHonorData()) then
		self:UnregisterEvent("INSPECT_HONOR_UPDATE");
		self:SendModuleEvent("OnHonorReady");
	else
		self.requestedHonorData = true;
		self:RegisterEvent("INSPECT_HONOR_UPDATE");
		RequestInspectHonorData();
	end
end

-- Achievement Inspection Ready
function ex:INSPECT_ACHIEVEMENT_READY(event,guid)
	if (AchievementFrameComparison) then
		AchievementFrameComparison:RegisterEvent("INSPECT_ACHIEVEMENT_READY");
	end
	self:UnregisterEvent("INSPECT_ACHIEVEMENT_READY");
	self:SendModuleEvent("OnAchievementReady",self.unit,guid);
end

-- Requests Achievement Data
function ex:RequestAchievementData()
	if (self.requestedAchievementData) then
		return;
	end
	-- Makes the Achievement UI, if loaded, not update when we query the achievements
	if (achievementFunctions) and (type(achievementFunctions.selectedCategory) == "string") then
		achievementFunctions.selectedCategory = 92;
	end
	if (AchievementFrameComparison) then
		AchievementFrameComparison:UnregisterEvent("INSPECT_ACHIEVEMENT_READY");
	end
	-- Request
	self.requestedAchievementData = true;
	self:RegisterEvent("INSPECT_ACHIEVEMENT_READY");
	SetAchievementComparisonUnit(self.unit);
end

--------------------------------------------------------------------------------------------------------
--                                          Helper Functions                                          --
--------------------------------------------------------------------------------------------------------

-- Format Time (sec)
function ex:FormatTime(time,short)
	-- bugged?
	if (time < 0) then
		return "n/a";
	-- under a min
	elseif (time < 60) then
		return time..(short and "s" or " seconds");
	-- less than 1 hour
	elseif (time < 60*60) then
		return format(short and "%dm %.2ds" or "%d minutes and %.2d seconds",time / 60,time % 60);
	-- less than 1 day
	elseif (time < 60*60*24) then
		time = (time/60);
		return format(short and "%dh %.2dm" or "%d hours and %.2d minutes",time / 60,time % 60);
	-- above 1 day
	else
		time = (time/60/60);
		return format(short and "%dd %.2dh" or "%d days and %.2d hours",time / 24,time % 24);
	end
end

-- Cache current stats for compare or clear previous marked one
function ex:CacheStatsForCompare(unmark)
	wipe(ex.compareStats);
	if (unmark) then
		ex.isComparing = nil;
	else
		ex.isComparing = true;
		ex.compareStats.entry = ex:GetEntryName();
		for k, v in next, unitStats do
			ex.compareStats[k] = v;
		end
		for slotName, itemLink in next, info.Items do
			ex.compareStats[slotName] = itemLink;
		end
	end
	-- Post OnCompare Event
	self:SendModuleEvent("OnCompare",ex.isComparing,ex.compareStats);
end

-- Sets the background vertex color
function ex:SetBackgroundVertex(r,g,b,a)
	self.dlgTopLeft:SetVertexColor(r,g,b,a);
	self.dlgTopRight:SetVertexColor(r,g,b,a);
	self.dlgBottomLeft:SetVertexColor(r,g,b,a);
	self.dlgBottomRight:SetVertexColor(r,g,b,a);
end

-- Toggle the Background
function ex:ShowBackground(show)
	if (show) or (show == nil and cfg.showBackground) then
		ex.bgTopLeft:Show();
		ex.bgTopRight:Show();
		ex.bgBottomLeft:Show();
		ex.bgBottomRight:Show();
	else
		ex.bgTopLeft:Hide();
		ex.bgTopRight:Hide();
		ex.bgBottomLeft:Hide();
		ex.bgBottomRight:Hide();
	end
end

-- Updates the Main Objects
function ex:UpdateObjects()
	-- Textures & Model
	if (UnitIsVisible(ex.unit)) then
		SetPortraitTexture(ex.portrait,ex.unit);
		ex.model:SetUnit(ex.unit);
		ex.model.cleared = nil;
	else
		ex.portrait:SetTexture("Interface\\CharacterFrame\\TemporaryPortrait-"..(info.sex == 3 and "Female" or "Male").."-"..info.raceFixed);
		ex.model:ClearModel();
		ex.model.cleared = 1;
	end
	ex:SetBackgroundTexture();
	-- Title, Detail & Guild Text
	ex.title:SetText(info.pvpName or info.name);
	ex:SetUnitDetailString();
	ex:SetUnitGuildString();
end

-- Show Module Page
function ex:ShowModulePage(index)
	-- hide current page
	local lastMod = ex.modules[cfg.activePage];
	if (lastMod) then
		lastMod.page:Hide();
	end
	-- when we have a new index
	if (index) then
		-- save old page
		if (cfg.activePage) then
			cfg.prevPage = cfg.activePage;
		end
		-- toggle page
		if (index == cfg.activePage) then
			self:SendModuleEvent("OnPageChanged",lastMod,false);
			cfg.activePage = nil;
		-- set active page
		else
			cfg.activePage = index;
		end
	end
	-- show active page
	if (cfg.activePage) then
		local shownMod = ex.modules[cfg.activePage];
		shownMod.page:Show();
		self:SendModuleEvent("OnPageChanged",shownMod,true);
	end
end

-- Background Texture -- param can be a texture, or true for loading racial texture, or nothing to load a random texture
function ex:SetBackgroundTexture(param)
	local texture;
	-- Find Texture
	if (type(param) == "string") then
		texture = param;
	elseif (param == true) or (not info.raceFixed) then
		texture = "Interface\\TalentFrame\\"..TALENT_BACKGROUNDS[random(#TALENT_BACKGROUNDS)].."-";
	else
		param = (info.raceFixed == "Gnome" and "Dwarf") or (info.raceFixed == "Troll" and "Orc") or (info.raceFixed);
		texture = "Interface\\DressUpFrame\\DressUpBackground-"..param;
	end
	-- Set Texture
	local normal = texture:find("DressUpFrame");
	ex.bgTopLeft:SetTexture(texture..(normal and "1" or "TopLeft"));
	ex.bgTopRight:SetTexture(texture..(normal and "2" or "TopRight"));
	ex.bgBottomLeft:SetTexture(texture..(normal and "3" or "BottomLeft"));
	ex.bgBottomRight:SetTexture(texture..(normal and "4" or "BottomRight"));
	-- Set Texture Width -- Scaled about 1.063 for the talent frame textures
	local scale = (normal and 1 or 1.063);
	ex.bgTopLeft:SetWidth(256 * scale);
	ex.bgTopRight:SetWidth(64 * scale);
	ex.bgBottomLeft:SetWidth(256 * scale);
	ex.bgBottomRight:SetWidth(64 * scale);
end

-- Check Last Unit
function ex:ValidateUnit()
	if (ex.unit) and (UnitExists(ex.unit)) and (UnitGUID(ex.unit) == ex.guid) then
		return 1;
	else
		ex.unit = nil;
		ex:SetScript("OnUpdate",nil);
		return;
	end
end

-- Hide GTT
function ex.HideGTT(self)
	gtt:Hide();
end

-- Item Button OnClick
function ex.ItemButton_OnClick(self,button)
	if (self.link) then
		local _, itemLink = GetItemInfo(self.link);
		if (button == "RightButton") then
			AzMsg("---|2 Gem Overview for "..itemLink.." |r---");
			for i = 1, 3 do
				local _, gemLink = GetItemGem(itemLink,i);
				if (gemLink) then
					AzMsg(format("Gem |1%d|r = %s",i,gemLink));
				end
			end
		elseif (button == "LeftButton") then
			local editBox = ChatEdit_GetActiveWindow();
			if (IsModifiedClick("DRESSUP")) then
				DressUpItemLink(itemLink);
			elseif (IsModifiedClick("CHATLINK")) and (editBox) and (editBox:IsVisible()) then
				editBox:Insert(itemLink);
			end
		end
	end
end

-- Item Button OnLeave
function ex.ItemButton_OnLeave(self)
	ex.showingTooltip = nil;
	ResetCursor();
	gtt:Hide();
end

-- Item Button OnEnter
function ex.ItemButton_OnEnter(self,motion)
	-- Inspect Cursor
	if (IsModifiedClick("DRESSUP")) then
		ShowInspectCursor();
	else
		ResetCursor();
	end
	-- Anchor
	ex.showingTooltip = true;
	gtt:SetOwner(self,"ANCHOR_NONE");
	if (cfg.tooltipSmartAnchor) then
		gtt:SetPoint("TOPLEFT",ex,"TOPRIGHT",-34,-12);
	else
		gtt:SetPoint("TOPLEFT",self,"TOPRIGHT");
	end
	-- Set Tip
	if (self.link) and (IsShiftKeyDown()) and (IsAltKeyDown()) then
		local linkToken, itemId, enchantId, gemId1, gemId2, gemId3, gemId4, suffixId, uniqueId, linkLvl, reforgeId = (":"):split(self.link);
		local itemName, _, itemRarity = GetItemInfo(self.link);
		gtt:AddLine(itemName,GetItemQualityColor(itemRarity));
		gtt:AddDoubleLine("itemId",itemId or 0,1,1,1);
		gtt:AddDoubleLine("enchantId",enchantId or 0,1,1,1);
		gtt:AddDoubleLine("gemId1",gemId1 or 0,1,1,1);
		gtt:AddDoubleLine("gemId2",gemId2 or 0,1,1,1);
		gtt:AddDoubleLine("gemId3",gemId3 or 0,1,1,1);
		gtt:AddDoubleLine("gemId4",gemId4 or 0,1,1,1);
		gtt:AddDoubleLine("suffixId",suffixId or 0,1,1,1);
		gtt:AddDoubleLine("uniqueId",format("0x%x",uniqueId or 0),1,1,1);
		gtt:AddDoubleLine("linkLvl",linkLvl or 0,1,1,1);
		gtt:AddDoubleLine("reforgeId",reforgeId or 0,1,1,1);
		gtt:Show();
	elseif (self.link) and (IsAltKeyDown()) then
		local itemName, _, itemRarity = GetItemInfo(self.link);
		gtt:AddLine(itemName,GetItemQualityColor(itemRarity));
		LibGearExam:ScanItemLink(self.link,statTipStats1);
		if (ex.isComparing) and (self.slotName) then
			LibGearExam:ScanItemLink(ex.compareStats[self.slotName],statTipStats2);
		end
		for index, statToken in ipairs(LibGearExam.StatNamesSorted) do
			if (statTipStats1[statToken]) or (statTipStats2 and statTipStats2[statToken]) then
				local statText = LibGearExam:GetStatValue(statToken,statTipStats1,ex.isComparing and statTipStats2,info.level,cfg.combineAdditiveStats,cfg.percentRatings);
				gtt:AddDoubleLine(LibGearExam:FormatStatName(statToken,cfg.percentRatings),statText,1,1,1);
			end
		end
		wipe(statTipStats1);
		wipe(statTipStats2);
		gtt:Show();
	elseif (self.id and ex:ValidateUnit() and CheckInteractDistance(ex.unit,1) and gtt:SetInventoryItem(ex.unit,self.id)) then
	elseif (self.link) then
		gtt:SetHyperlink(self.link);
	elseif (self.realLink) then
		-- Az: should not be like this anymore, a single call to GetItemInfo() would make the client cache the item, so just make some kind of postcacheload thingie, or just redo the OnCacheLoaded event?
		gtt:SetText(_G[self.slotName:upper()]);
		gtt:AddLine("ItemID: "..self.realLink:match(LibGearExam.ITEMLINK_PATTERN_ID),0,0.44,0.86);
		gtt:AddLine("This item was not in the local item cache, click this button to reload the cached player, so the item will update.",1,1,1,1);
		gtt:Show();
	elseif (self.slotName) then
		gtt:SetText(_G[self.slotName:upper()]);
	end
end

--------------------------------------------------------------------------------------------------------
--                                           Slash Handling                                           --
--------------------------------------------------------------------------------------------------------

-- Slash Help
ex.slashHelp = {
	" |2inspect <unit>|r = Inspects the given unit ('target' if no unit given)",
	" |2si <itemlink>|r = Scans one item and shows the total sum of its stats combined",
	" |2compare <itemlink1> <itemlink2>|r = Compares two items by listing the stat differences",
	" |2rating <stat> <rating> <level>|r = Rating Converter",
	" |2scale <value>|r = Sets the scale of the Examiner window (Default is 1)",
	" |2reset|r = Resets the position to the center, in case it was moved off screen",
	" |2clearcache|r = Clears the entire Examiner cache",
};

-- Slash Functions
ex.slashFuncs = {
	-- Inspect Unit
	inspect = function(cmd)
		ex:DoInspect(cmd == "" and "target" or cmd);
	end,
	-- Scan a Single Item
	si = function(cmd)
		if (cmd ~= "") then
			local itemStats = {};
			LibGearExam:ScanItemLink(cmd,itemStats);
			AzMsg("--- |2Scan Overview for "..cmd.."|r ---");
			for stat in next, itemStats do
				local statName = (cfg.percentRatings and LibGearExam.StatNames[stat] or LibGearExam.StatNames[stat].." "..RATING);
				local statText, altText = LibGearExam:GetStatValue(stat,itemStats,nil,UnitLevel("player"),cfg.combineAdditiveStats,cfg.percentRatings);
				AzMsg(format(altText and "%s = |1%s|r (|1%s|r)." or "%s = |1%s|r.",statName,statText,altText));
			end
		else
			AzMsg("No item link given.");
		end
	end,
	-- Compares two Items
	compare = function(cmd)
		if (cmd ~= "") then
			local item1, item2 = cmd:match("(|c.+|r)%s+(|c.+|r)");
			if (item1 and item2) then
				local itemStats1, itemStats2 = {}, {};
				LibGearExam:ScanItemLink(item1,itemStats1);
				LibGearExam:ScanItemLink(item2,itemStats2);
				AzMsg("--- |2Using "..item1.."|2 over "..item2.."|r ---");
				for statToken, statName in next, LibGearExam.StatNames do
					if (itemStats1[statToken] or itemStats2[statToken]) then
						if (not cfg.percentRatings) then
							statName = (statName.." "..RATING);
						end
						local statText = LibGearExam:GetStatValue(statToken,itemStats1,itemStats2,UnitLevel("player"),cfg.combineAdditiveStats,cfg.percentRatings);
						AzMsg(format("%s = |1%s|r.",statName,statText));
					end
				end
			else
				AzMsg("Could not parse item links.");
			end
		else
			AzMsg("No item links given.");
		end
	end,
	-- Rating Converter
	rating = function(cmd)
		local stat, rating, level = cmd:match("([^%s]+) (%d+%.?%d*) ?(%d*)");
		rating = tonumber(rating);
		if (stat and rating) then
			local _, classFixed = UnitClass("player");
			local value = LibGearExam:GetRatingInPercent(stat:upper(),rating,tonumber(level) or UnitLevel("player"));
			AzMsg("Converted Rating = |1"..(value or "Invalid Input"));
		else
			AzMsg("Invalid Input - Use: <stat> <rating> <level>");
		end
	end,
	-- Reset Window Position
	reset = function(cmd)
		if (cfg.makeMovable) then
			ex:ClearAllPoints();
			ex:SetPoint("CENTER");
		else
			AzMsg("This command is only available when Examiner is movable");
		end
	end,
	-- Scale
	scale = function(cmd)
		cmd = tonumber(cmd);
		if (type(cmd) == "number") then
			cfg.scale = cmd;
			ex:SetScale(cmd);
		end
	end,
	-- Clear Cache
	clearcache = function(cmd)
		wipe(cache);
	end,
	-- Az: TEST
	test = function(cmd)
		for name, entry in next, cache do
			ex:LoadPlayerFromCache(name);
		end
	end,
	-- Az: Test: Load all items, so they are cached locally
	loaditems = function(cmd)
		for name, entry in next, cache do
			for slotName, link in next, entry.Items do
				GetItemInfo(link);
			end
		end
	end,
};

-- Slash Handler
_G["SLASH_"..modName.."1"] = "/examiner";
_G["SLASH_"..modName.."2"] = "/ex";
SlashCmdList[modName] = function(cmd)
	-- Extract Parameters
	local param1, param2 = cmd:match("^([^%s]+)%s*(.*)$");
	param1 = (param1 and param1:lower() or cmd:lower());
	-- Check Param Function
	if (ex.slashFuncs[param1]) then
		ex.slashFuncs[param1](param2);
	-- Invalid or No Command
	else
		UpdateAddOnMemoryUsage();
		AzMsg(format("----- |2%s|r |1%s|r ----- |1%.2f |2kb|r -----",modName,GetAddOnMetadata(modName,"Version"),GetAddOnMemoryUsage(modName)));
		AzMsg("The following |2parameters|r are valid for this addon:");
		for index, help in ipairs(ex.slashHelp) do
			AzMsg(help);
		end
	end
end