local ex = Examiner;
local gtt = GameTooltip;

-- Module
local mod = ex:CreateModule("ItemSlots");
mod.slotBtns = {};

-- Variables
local cfg, cache;
local statTipStats1, statTipStats2 = {}, {};
local ITEM_ICON_UNKNOWN = "Interface\\Icons\\INV_Misc_QuestionMark";

-- Options
ex.options[#ex.options + 1] = { var = "总是显示物品等级", default = true, label = "总是显示物品等级", tip = "With this enabled, the items will always show their item levels, instead of having to hold down the ALT key." };

--------------------------------------------------------------------------------------------------------
--                                           Module Scripts                                           --
--------------------------------------------------------------------------------------------------------

-- OnInitialize
function mod:OnInitialize()
	cfg = Examiner_Config;
	cache = Examiner_Cache;
end

-- OnInspectReady
function mod:OnInspectReady(unit,guid)
	self:UpdateItemSlots();
	self:ShowItemSlotButtons();
end
mod.OnInspect = mod.OnInspectReady;

-- OnCacheLoaded
function mod:OnCacheLoaded(entry,unit)
	self:UpdateItemSlots();
	self:ShowItemSlotButtons();
end

-- OnPageChanged
function mod:OnPageChanged(module,shown)
	self:ShowItemSlotButtons();
end

-- OnConfigChanged
function mod:OnConfigChanged(var,value)
	if (var == "alwaysShowItemLevel") then
		for index, button in ipairs(self.slotBtns) do
			if (value) and (button.link) then
				button.level:Show();
			else
				button.level:Hide();
			end
		end
	end
end

--------------------------------------------------------------------------------------------------------
--                                          Helper Functions                                          --
--------------------------------------------------------------------------------------------------------

-- Show the Item Slot Buttons
function mod:ShowItemSlotButtons()
	local shownMod = (cfg.activePage and ex.modules[cfg.activePage]);
	local visible = (ex.itemsLoaded) and (not shownMod or shownMod.showItems or not shownMod.page:IsShown());
	for _, button in ipairs(self.slotBtns) do
		if (visible) then
			button:Show();
		else
			button:Hide();
		end
	end
end

-- UpdateSlot: Updates slot from "button.link"
function mod:UpdateItemSlots()
	for index, button in ipairs(self.slotBtns) do
		local link = ex.info.Items[button.slotName];
		if (cfg.alwaysShowItemLevel) then
			button.level:Show();
		end
		button.realLink = nil;
		button.link = link;
		if (not link) then
			button.texture:SetTexture(button.bgTexture);
			button.border:Hide();
			button.level:SetText("");
		else
			local _, _, itemRarity, itemLevel, _, _, _, _, _, itemTexture = GetItemInfo(link);
			if (itemTexture) then
				button.texture:SetTexture(itemTexture or ITEM_ICON_UNKNOWN);
				local r,g,b = GetItemQualityColor(itemRarity and itemRarity > 0 and itemRarity or 0);
				button.border:SetVertexColor(r,g,b);
				button.border:Show();
				button.level:SetText(itemLevel);
			else
				button.realLink = link;
				button.link = nil;
				button.texture:SetTexture(ITEM_ICON_UNKNOWN);
				button.border:Hide();
				button.level:SetText("");
			end
		end
	end
end

--------------------------------------------------------------------------------------------------------
--                                          Item Slot Scripts                                         --
--------------------------------------------------------------------------------------------------------

-- OnEvent -- MODIFIER_STATE_CHANGED
local function OnEvent(self,event,key,state)
	-- Update Tip
	if (gtt:IsOwned(self)) then
		self:GetScript("OnEnter")(self);
	end
	-- Toggle ItemLevel
	if (not cfg.alwaysShowItemLevel) then
		if (self.link) and (IsAltKeyDown()) then
			self.level:Show();
		else
			self.level:Hide();
		end
	end
end

-- OnDrag
local function OnDrag(self)
	if (ex:ValidateUnit() and UnitIsUnit(ex.unit,"player")) then
		PickupInventoryItem(self.id);
	end
end

-- OnClick
local function OnClick(self,button)
	if (CursorHasItem()) then
		OnDrag(self);
	elseif (self.link) then
		if (button == "RightButton") then
			AzMsg("---|2 Gem Overview for "..select(2,GetItemInfo(self.link)).." |r---");
			for i = 1, 3 do
				local _, gemLink = GetItemGem(self.link,i);
				if (gemLink) then
					AzMsg(format("Gem |1%d|r = %s",i,gemLink));
				end
			end
		elseif (button == "LeftButton") then
			local editBox = ChatEdit_GetActiveWindow();
			if (IsModifiedClick("DRESSUP")) then
				DressUpItemLink(self.link);
			elseif (IsModifiedClick("CHATLINK")) and (editBox) and (editBox:IsVisible()) then
				local _, itemLink = GetItemInfo(self.link);
				editBox:Insert(itemLink);
			else
				OnDrag(self);
			end
		end
	elseif (self.realLink) then
		-- Az: this needs to be changed, look at shared onenter func for more info
		-- Az: should not be like this anymore, a single call to GetItemInfo() would make the client cache the item, so just make some kind of postcacheload thingie, or just redo the OnCacheLoaded event?
		local entryName = ex:GetEntryName();
		ex:ClearInspect();
		ex:LoadPlayerFromCache(entryName);
		self:GetScript("OnEnter")(self);
	end
end

-- OnShow
local function OnShow(self)
	self:RegisterEvent("MODIFIER_STATE_CHANGED");
end

-- OnHide
local function OnHide(self)
	self:UnregisterEvent("MODIFIER_STATE_CHANGED");
	if (not cfg.alwaysShowItemLevel) then
		self.level:Hide();
	end
end

--------------------------------------------------------------------------------------------------------
--                                           Widget Creation                                          --
--------------------------------------------------------------------------------------------------------

for index, slot in ipairs(LibGearExam.Slots) do
	local btn = CreateFrame("Button","ExaminerItemButton"..slot,ex.model); -- Some other mods bug if you create this nameless
	btn:SetWidth(37);
	btn:SetHeight(37);
	btn:RegisterForClicks("LeftButtonUp","RightButtonUp");
	btn:RegisterForDrag("LeftButton");
	btn:SetPushedTexture("Interface\\Buttons\\UI-Quickslot-Depress");
	btn:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square");

	btn:SetScript("OnShow",OnShow);
	btn:SetScript("OnHide",OnHide);
	btn:SetScript("OnClick",OnClick);
	btn:SetScript("OnEnter",ex.ItemButton_OnEnter);
	btn:SetScript("OnLeave",ex.ItemButton_OnLeave);
	btn:SetScript("OnEvent",OnEvent);
	btn:SetScript("OnDragStart",OnDrag);
	btn:SetScript("OnReceiveDrag",OnDrag);

	btn.id, btn.bgTexture = GetInventorySlotInfo(slot);
	btn.slotName = slot;

	btn.texture = btn:CreateTexture(nil,"BACKGROUND");
	btn.texture:SetAllPoints();

	btn.border = btn:CreateTexture(nil,"OVERLAY");
	btn.border:SetTexture("Interface\\Addons\\Examiner\\Textures\\Border");
	btn.border:SetWidth(41);
	btn.border:SetHeight(41);
	btn.border:SetPoint("CENTER");

	btn.level = btn:CreateFontString(nil,"ARTWORK","GameFontHighlight");
	btn.level:SetFont(GameFontHighlight:GetFont(),12,"OUTLINE");
	btn.level:SetPoint("BOTTOM",0,4);
	btn.level:Hide();

	if (index == 1) then
		btn:SetPoint("TOPLEFT",4,-3);
	elseif (index == 9) then
		btn:SetPoint("TOPRIGHT",-4,-3);
	elseif (index == 17) then
		btn:SetPoint("BOTTOM",-26.5,27);	-- Az: the X offset might need adjusting
	elseif (index <= 16) then
		btn:SetPoint("TOP",mod.slotBtns[index - 1],"BOTTOM",0,-4);
	else
		btn:SetPoint("LEFT",mod.slotBtns[index - 1],"RIGHT",5,0);
	end

	mod.slotBtns[index] = btn;
end