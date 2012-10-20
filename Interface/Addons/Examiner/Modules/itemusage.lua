local ex = Examiner;
local cache, activeCache;
local GetItemInfo = GetItemInfo;

-- Module
local mod = ex:CreateModule("Items","Item Usage (beta)");
mod.help = "Shows general item usage.\nBased on the current shown cache";
mod:CreatePage(true,"Item Usage");
--mod:HasButton(true);

-- Variables
local NUM_BUTTONS = 10;
local BUTTON_HEIGHT = (283 / NUM_BUTTONS);
local UpdateShownItems;
local buttons = {};

-- Data Variables
local dbReqBuild = true;
local orderList, itemCount = {}, {};
local itemDataName, itemDataRarity, itemDataTexture = {}, {}, {};

--------------------------------------------------------------------------------------------------------
--                                           Item Data Query                                          --
--------------------------------------------------------------------------------------------------------

local function FillItemData(self,itemID)
	local itemName, _, itemRarity, _, _, _, _, _, _, itemTexture = GetItemInfo(itemID);
	if (itemName) then
		itemDataName[itemID] = itemName;
		itemDataRarity[itemID] = itemRarity;
		itemDataTexture[itemID] = itemTexture;
		return self[itemID];
	else
		return;
	end
end

local requestMeta = { __index = FillItemData };
setmetatable(itemDataName,requestMeta);
setmetatable(itemDataRarity,requestMeta);
setmetatable(itemDataTexture,requestMeta);

--------------------------------------------------------------------------------------------------------
--                                           Module Scripts                                           --
--------------------------------------------------------------------------------------------------------

-- OnInitialize
function mod:OnInitialize()
	cache = Examiner_Cache;
	local cacheMod = ex:GetModuleFromToken("Cache");
	if (cacheMod) then
		activeCache = cacheMod.activeCacheList;
	end
end

-- OnInspect
function mod:OnInspect(unit)
end

-- OnInspectReady
function mod:OnInspectReady(unit)
end

-- OnCacheLoaded
function mod:OnCacheLoaded(entry,unit)
end

-- OnClearInspect
function mod:OnClearInspect()
	-- Az: this is a bad way to clear data, should do it when examiner hides
	dbReqBuild = true;
	wipe(orderList);
	wipe(itemCount);

	wipe(itemDataName);
	wipe(itemDataRarity);
	wipe(itemDataTexture);

	for i = 1, NUM_BUTTONS do
		local btn = buttons[i];

		btn.itemID = nil;
		btn.link = nil;
		btn.noItem = nil;

		btn.name:SetText();
		btn.count:SetText();
		btn.icon:SetTexture();
	end
end

-- OnConfigChanged
function mod:OnConfigChanged(var,value)
	if (var == "cacheFilter") then
		dbReqBuild = true;
		if (self:IsShown()) then
			self:BuildDatabase();
		end
	end
end

-- OnCache
function mod:OnCache(entry)
	dbReqBuild = true;
	if (self:IsShown()) then
		self:BuildDatabase();
	end
end

-- OnClearInspect
function mod:OnPageChanged(module,shown)
	if (module.token == "Cache") then
		dbReqBuild = true;
	elseif (module == self) and (shown) then
		self:BuildDatabase();
	end
end

--------------------------------------------------------------------------------------------------------
--                                           Widget Scripts                                           --
--------------------------------------------------------------------------------------------------------

-- Item OnEnter
local function Item_OnClick(self,button)
	if (button == "LeftButton") and (self.itemID) then
		if (self.noItem) then
			local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(self.itemID);
			self.name:SetText(itemName or self.itemID);
			self.name:SetTextColor(GetItemQualityColor(itemRarity or 1));
			self.icon:SetTexture(itemTexture or "Interface\\Icons\\INV_Misc_QuestionMark");
		end
		local link = "item:"..self.itemID;
		local editBox = ChatEdit_GetActiveWindow();
		if (IsModifiedClick("DRESSUP")) then
			DressUpItemLink(link);
		elseif (IsModifiedClick("CHATLINK")) and (editBox) and (editBox:IsVisible()) then
			local _, itemLink = GetItemInfo(link);
			editBox:Insert(itemLink);
		end
	end
end

--------------------------------------------------------------------------------------------------------
--                                                Code                                                --
--------------------------------------------------------------------------------------------------------

-- Sort Entries
local function SortFunc(id1,id2)
	if (itemCount[id1] == itemCount[id2]) then
		if (itemDataRarity[id1] == itemDataRarity[id2]) then
			return (itemDataName[id1] or "") < (itemDataName[id2] or "");
		else
			return (itemDataRarity[id1] or 0) > (itemDataRarity[id2] or 0);
		end
	else
		return itemCount[id1] > itemCount[id2];
	end
end

-- Build Database
function mod:BuildDatabase()
	-- Do we need a rebuild?
	if (not dbReqBuild) then
		UpdateShownItems();
		return;
	end
	-- count
	wipe(itemCount);
	if (activeCache) and (#activeCache > 0) then
		for index, entryName in ipairs(activeCache) do
			local tbl = cache[entryName];
			for slot, link in next, tbl.Items do
				local itemID = tonumber(link:match(LibGearExam.ITEMLINK_PATTERN_ID));
				if (itemID) then
					itemCount[itemID] = (itemCount[itemID] or 0) + 1;
				end
			end
		end
	else
		for name, tbl in next, cache do
			for slot, link in next, tbl.Items do
				local itemID = tonumber(link:match(LibGearExam.ITEMLINK_PATTERN_ID));
				if (itemID) then
					itemCount[itemID] = (itemCount[itemID] or 0) + 1;
				end
			end
		end
	end
	-- items
	wipe(orderList);
	for id, count in next, itemCount do
		orderList[#orderList + 1] = id;
	end
	table.sort(orderList,SortFunc);
	-- fin
	dbReqBuild = false;
	self.page.header:SetFormattedText("Item Usage (%d)",#orderList);
	UpdateShownItems();
end

-- Update
function UpdateShownItems()
	FauxScrollFrame_Update(mod.scroll,#orderList,#buttons,BUTTON_HEIGHT);
	local index = mod.scroll.offset;
	local gttOwner = GameTooltip:GetOwner();
	-- Loop
	for i = 1, NUM_BUTTONS do
		index = (index + 1);
		local btn = buttons[i];
		local id = orderList[index];
		if (id) then
			local count = itemCount[id];
			local itemName = itemDataName[id];
			local itemRarity = itemDataRarity[id];
			local itemTexture = itemDataTexture[id];

			btn.itemID = id;
			btn.link = "item:"..id;
			btn.noItem = (not itemName and 1 or nil);

			btn.name:SetText(itemName or (id.." - Click to Reload"));
			btn.name:SetTextColor(GetItemQualityColor(itemRarity or 1));
			btn.count:SetText(count);
			btn.icon:SetTexture(itemTexture or "Interface\\Icons\\INV_Misc_QuestionMark");
			btn:Show();

			if (gttOwner == btn) then
				ex.ItemButton_OnEnter(btn);
			end
		else
			btn:Hide();
		end
	end
end

--------------------------------------------------------------------------------------------------------
--                                           Widget Creation                                          --
--------------------------------------------------------------------------------------------------------

-- Buttons
for i = 1, NUM_BUTTONS do
	local btn = CreateFrame("Button",nil,mod.page);
	buttons[i] = btn;

	btn:SetHeight(BUTTON_HEIGHT);
	btn:RegisterForClicks("LeftButtonDown","RightButtonDown");
	btn:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight");

	if (i == 1) then
		btn:SetPoint("TOPLEFT",8,-36.5);
		btn:SetPoint("TOPRIGHT",-28,-36.5);
	else
		btn:SetPoint("TOPLEFT",buttons[i - 1],"BOTTOMLEFT");
		btn:SetPoint("TOPRIGHT",buttons[i - 1],"BOTTOMRIGHT");
	end

	btn:SetScript("OnClick",Item_OnClick);
	btn:SetScript("OnEnter",ex.ItemButton_OnEnter);
	btn:SetScript("OnLeave",ex.ItemButton_OnLeave);

	btn.icon = btn:CreateTexture(nil,"ARTWORK");
	btn.icon:SetWidth(BUTTON_HEIGHT - 2);
	btn.icon:SetHeight(BUTTON_HEIGHT - 2);
	btn.icon:SetPoint("LEFT",2,0);
	btn.icon:SetTexCoord(0.07,0.93,0.07,0.93);

	btn.count = btn:CreateFontString(nil,"ARTWORK","GameFontHighlight");
	btn.count:SetPoint("RIGHT",-4,0);
	btn.count:SetTextColor(1,1,0);

	btn.name = btn:CreateFontString(nil,"ARTWORK","GameFontHighlight");
	btn.name:SetPoint("LEFT",btn.icon,"RIGHT",3,0);
	btn.name:SetPoint("RIGHT",btn.count,"LEFT",-8,0);
	btn.name:SetJustifyH("LEFT");
end

-- Scroll
mod.scroll = CreateFrame("ScrollFrame","Examiner"..mod.token.."Scroll",mod.page,"FauxScrollFrameTemplate");
mod.scroll:SetPoint("TOPLEFT",buttons[1]);
mod.scroll:SetPoint("BOTTOMRIGHT",buttons[NUM_BUTTONS],-6,-1);
mod.scroll:SetScript("OnVerticalScroll",function(self,offset) FauxScrollFrame_OnVerticalScroll(self,offset,BUTTON_HEIGHT,UpdateShownItems) end);