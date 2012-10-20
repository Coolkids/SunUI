local ex = Examiner;

-- Module
local mod = ex:CreateModule("Gear","Gear List (beta)");
mod.help = "Lists gear with enchants and gems, or the lack thereof";
mod:CreatePage(true,"");
mod:HasButton(true);

-- Variables
local NUM_BUTTONS = 9;
local BUTTON_HEIGHT = (283 / NUM_BUTTONS);
local NO_ENCHANT = NO.." "..ENSCRIBE;
local UpdateShownItems;
local buttons = {};
local shownSlots = {};
local gemTable = {};

-- Slots we dont want to show up
local IGNORED_SLOTS = {
	TabardSlot = true,
	ShirtSlot = true,
--	Trinket0Slot = true,
--	Trinket1Slot = true,
};

-- List of item slots that can be enchanted. The value is at what itemLevel we find the first valid enchant.
local ENCHANT_SLOT_LEVEL = {
	INVTYPE_HEAD = 60;		-- TBC faction head enchants or Vanilla Librams
	INVTYPE_NECK = nil;
	INVTYPE_SHOULDER = 60;	-- Argent Dawn & ZG enchants?
	INVTYPE_CLOAK = 1;
	INVTYPE_CHEST = 1;
	INVTYPE_ROBE = 1;
	INVTYPE_WRIST = 1;
	INVTYPE_HAND = 1;
	INVTYPE_WAIST = nil;	-- Ignore this, only Engineers can enchant belts
	INVTYPE_LEGS = 60;		-- TBC leg enchants or Vanilla Librams
	INVTYPE_FEET = 1;
	INVTYPE_FINGER = nil;	-- Enchanters can do rings, but we cannot check what profession someone is
	INVTYPE_TRINKET = nil;

	INVTYPE_BODY = nil;
	INVTYPE_TABARD = nil;

	INVTYPE_WEAPON = 1;
	INVTYPE_WEAPONMAINHAND = 1;
	INVTYPE_WEAPONOFFHAND = 1;
	INVTYPE_2HWEAPON = 1;
	INVTYPE_SHIELD = 1;
	INVTYPE_HOLDABLE = 300;
	INVTYPE_RANGED = 1;
	INVTYPE_RANGEDRIGHT = 1,	-- Not sure what is different with the "right" version
	INVTYPE_THROWN = nil;
	INVTYPE_RELIC = nil;
};

--------------------------------------------------------------------------------------------------------
--                                           Module Scripts                                           --
--------------------------------------------------------------------------------------------------------

-- OnInspectReady
function mod:OnInspectReady(unit)
	self:HasData(ex.itemsLoaded);
	if (ex.itemsLoaded) then
		self:BuildItemList();
	end
end
mod.OnInspect = mod.OnInspectReady;

-- OnCacheLoaded
function mod:OnCacheLoaded(entry,unit)
	self:HasData(true);
	self:BuildItemList();
end

-- OnClearInspect
function mod:OnClearInspect()
	self:HasData(nil);
	wipe(shownSlots);
end

--------------------------------------------------------------------------------------------------------
--                                           Widget Scripts                                           --
--------------------------------------------------------------------------------------------------------

-- Object OnEnter
local function ObjectItem_OnEnter(self,button)
	GameTooltip:SetOwner(self,"ANCHOR_BOTTOMRIGHT");
	if (self.link) then
		GameTooltip:SetHyperlink(self.link);
	elseif (self.missing) then
		GameTooltip:AddLine(EMPTY.." "..self.missing,1,0,0);
		GameTooltip:Show();
	end
end

--------------------------------------------------------------------------------------------------------
--                                                Code                                                --
--------------------------------------------------------------------------------------------------------

-- BuildItemList
function mod:BuildItemList()
	wipe(shownSlots);
	local items = ex.info.Items;
	local slots = LibGearExam.Slots;
	for index, slotName in ipairs(slots) do
		if (not IGNORED_SLOTS[slotName]) and (items[slotName]) then
			shownSlots[#shownSlots + 1] = slotName;
		end
	end
	self.page.header:SetText("Gear List ("..#shownSlots..")");
	UpdateShownItems();
end

-- Update
function UpdateShownItems()
	local items = ex.info.Items;
	FauxScrollFrame_Update(mod.scroll,#shownSlots,#buttons,BUTTON_HEIGHT);
	local index = mod.scroll.offset;
	-- Loop
	for i = 1, NUM_BUTTONS do
		index = (index + 1);
		local btn = buttons[i];
		local slotName = shownSlots[index];
		local link = items[slotName];
		if (link) then
			local itemName, _, itemRarity, itemLevel, _, _, _, _, itemEquipLoc, itemTexture = GetItemInfo(link);
			btn.link = link;
--			btn.name:SetText(itemName);
--			btn.name:SetTextColor(GetItemQualityColor(itemRarity or 0));
			btn.level:SetText(itemLevel);
			btn.icon:SetTexture(itemTexture or "Interface\\Icons\\INV_Misc_QuestionMark");
			btn:Show();

			btn.iconFrame.link = link;
			btn.iconFrame.slotName = shownSlots[index];
			btn.iconFrame.id = LibGearExam.SlotIDs[shownSlots[index]];

			-- Gem Scan -- Directly from unit or just from link
			if (ex:ValidateUnit() and CheckInteractDistance(ex.unit,1)) then
				LibGearExam:GetGemInfo(nil,gemTable,ex.unit,slotName);
			else
				LibGearExam:GetGemInfo(link,gemTable);
			end
			for i = 1, MAX_NUM_SOCKETS do
				local obj = btn["Gem"..i];
				if (gemTable[i]) then
					local itemName, _, _, _, _, _, _, _, _, itemTexture = GetItemInfo(gemTable[i]);
					if (itemName) then
						obj.link = gemTable[i];
						obj.missing = nil;
						obj.icon:SetTexture(itemTexture);
					else
						obj.link = nil;
						obj.missing = gemTable[i];
						obj.icon:SetTexture("Interface\\ItemSocketingFrame\\UI-EmptySocket-"..gemTable[i]:match("([^%s]+)"));
					end
					obj:Show();
				else
					obj:Hide();
				end
			end
			-- Enchant
			local enchantID, enchantName = LibGearExam:GetEnchantInfo(link);
			if (enchantID) then
				btn.enchant:SetText(enchantName:gsub("and ","and\n"));
				btn.enchant:SetTextColor(0.5,1,0.5);
			else
				local slotEnchantLevel = ENCHANT_SLOT_LEVEL[itemEquipLoc];
				if (slotEnchantLevel) and (not itemLevel or itemLevel >= slotEnchantLevel) then
					btn.enchant:SetText(NO_ENCHANT);
					btn.enchant:SetTextColor(1,0.5,0.5);
				else
					btn.enchant:SetText("");
				end
			end
		else
			btn:Hide();
		end
	end
	-- Update Tooltip After Scroll
	local gttOwner = GameTooltip:GetOwner();
	local onEnterFunc = gttOwner and gttOwner:GetScript("OnEnter");
	if (onEnterFunc) then
		onEnterFunc(gttOwner);
	end
	-- cleanup
	wipe(gemTable);
end

--------------------------------------------------------------------------------------------------------
--                                           Widget Creation                                          --
--------------------------------------------------------------------------------------------------------

-- Create Buttons
for i = 1, NUM_BUTTONS do
	local btn = CreateFrame("Button",nil,mod.page);
	buttons[i] = btn;

	btn:SetHeight(BUTTON_HEIGHT);
	btn:RegisterForClicks("LeftButtonDown","RightButtonDown");
	btn:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight");
	btn:Hide();

	if (i == 1) then
		btn:SetPoint("TOPLEFT",8,-36.5);
		btn:SetPoint("TOPRIGHT",-28,-36.5);
	else
		btn:SetPoint("TOPLEFT",buttons[i - 1],"BOTTOMLEFT");
		btn:SetPoint("TOPRIGHT",buttons[i - 1],"BOTTOMRIGHT");
	end

	-- Gems
	for x = 1, MAX_NUM_SOCKETS do
		local obj = CreateFrame("Button",nil,btn);
		obj:SetWidth(18);
		obj:SetHeight(18);
		obj:EnableMouse(1);

		obj:SetScript("OnClick",ex.ItemButton_OnClick);
		obj:SetScript("OnEnter",ObjectItem_OnEnter);
		obj:SetScript("OnLeave",ex.HideGTT);

		obj.index = x;

		obj.icon = obj:CreateTexture(nil,"ARTWORK");
		obj.icon:SetAllPoints();
		obj.icon:SetTexture("Interface\\Icons\\INV_Scroll_03");
		obj.icon:SetTexCoord(0.07,0.93,0.07,0.93);

		if (x == 1) then
			obj:SetPoint("RIGHT",-4,0);
		else
			obj:SetPoint("RIGHT",btn["Gem"..(x - 1)],"LEFT",-2,0);
		end

		btn["Gem"..x] = obj;
		obj:Show();
	end

	btn.iconFrame = CreateFrame("Button",nil,btn);
	btn.iconFrame:SetPoint("LEFT",3,0);
	btn.iconFrame:SetWidth(BUTTON_HEIGHT - 2);
	btn.iconFrame:SetHeight(BUTTON_HEIGHT - 2);
	btn.iconFrame:SetScript("OnClick",ex.ItemButton_OnClick);
	btn.iconFrame:SetScript("OnEnter",ex.ItemButton_OnEnter);
	btn.iconFrame:SetScript("OnLeave",ex.ItemButton_OnLeave);
	btn.iconFrame:RegisterForClicks("LeftButtonUp","RightButtonUp");
	btn.iconFrame.hasItem = true;

	btn.level = btn.iconFrame:CreateFontString(nil,"ARTWORK","GameFontHighlightSmall");
	btn.level:SetPoint("BOTTOM",0,1);
	btn.level:SetTextColor(1,1,1);
	btn.level:SetFont(GameFontNormal:GetFont(),10,"OUTLINE");

	btn.icon = btn.iconFrame:CreateTexture(nil,"ARTWORK");
	btn.icon:SetAllPoints();
	btn.icon:SetTexCoord(0.07,0.93,0.07,0.93);

--	btn.val = btn:CreateFontString(nil,"ARTWORK","GameFontHighlightSmall");
--	btn.val:SetPoint("RIGHT",-4,0);
--	btn.val:SetTextColor(1,1,0);

	btn.name = btn:CreateFontString(nil,"ARTWORK","GameFontHighlightSmall");
	btn.name:SetPoint("LEFT",btn.icon,"RIGHT",3,6);
	btn.name:SetPoint("RIGHT",btn.Gem3,"LEFT",-8,6);
	btn.name:SetJustifyH("LEFT");
	btn.name:Hide();

	btn.enchant = btn:CreateFontString(nil,"ARTWORK","GameFontHighlightSmall");
--	btn.enchant:SetPoint("TOPLEFT",btn.name,"BOTTOMLEFT",0,-2);
--	btn.enchant:SetPoint("TOPRIGHT",btn.name,"BOTTOMRIGHT",0,-2);

	btn.enchant:SetPoint("TOPLEFT",btn.iconFrame,"TOPRIGHT",2,-2);
	btn.enchant:SetPoint("BOTTOMLEFT",btn.iconFrame,"BOTTOMRIGHT",2,2);
	btn.enchant:SetWidth(150);

	btn.enchant:SetJustifyH("LEFT");
	btn.enchant:SetTextColor(0.6,0.6,0.6);
	btn.enchant:SetWordWrap(true);
end

-- Scroll
mod.scroll = CreateFrame("ScrollFrame","Examiner"..mod.token.."Scroll",mod.page,"FauxScrollFrameTemplate");
mod.scroll:SetPoint("TOPLEFT",buttons[1]);
mod.scroll:SetPoint("BOTTOMRIGHT",buttons[NUM_BUTTONS],-6,-1);
mod.scroll:SetScript("OnVerticalScroll",function(self,offset) FauxScrollFrame_OnVerticalScroll(self,offset,BUTTON_HEIGHT,UpdateShownItems) end);