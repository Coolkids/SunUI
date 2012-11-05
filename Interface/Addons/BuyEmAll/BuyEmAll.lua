-- BuyEmAll - Originally created and developed by Cogwheel up to version 2.8.4, now developed by Shinisuryu.
BuyEmAll = {}

local L = BUYEMALL_LOCALS;

-- These are used for the text on the Max and Stack buttons. See BuyEmAll.xml.
BUYEMALL_MAX = L.MAX;
BUYEMALL_STACK = L.STACK;

--[[
It's ALIVE!!! Muahahahahhahahaa!!!!!!
]]
function BuyEmAll:OnLoad()
	-- Set up confirmation dialog
	StaticPopupDialogs["BUYEMALL_CONFIRM"] = {
		preferredIndex = 3,
		text = L.CONFIRM,
		button1 = YES,
		button2 = NO,
		OnAccept = function(dialog) self:DoPurchase(dialog.data) end,
		timeout = 0,
		hideOnEscape = true,
	}
	self.ConfirmNoItemID = 0;
	StaticPopupDialogs["BUYEMALL_CONFIRM2"] = {
		preferredIndex = 3,
		text = L.CONFIRM,
		button1 = YES,
		button2 = NO,
		OnAccept = function(dialog) BuyMerchantItem(self.ConfirmNoItemID) end,
		timeout = 0,
		hideOnEscape = true,
	}
	if (BEAConfirmToggle == nil) then
		BEAConfirmToggle = 1;
	end
	
	self.OrigMerchantItemButton_OnModifiedClick = MerchantItemButton_OnModifiedClick;
	MerchantItemButton_OnModifiedClick = function(frame, button)
		self:MerchantItemButton_OnModifiedClick(frame, button);
	end
	
	self.OrigMerchantFrame_OnHide = MerchantFrame:GetScript("OnHide");
	MerchantFrame:SetScript("OnHide", function(...)
		return self:MerchantFrame_OnHide(...)
	end)
end


SLASH_BUYEMALL1 = "/buyemall"
SlashCmdList["BUYEMALL"] = function(message, editbox) BuyEmAll:SlashHandler(message, editbox) end
function BuyEmAll:SlashHandler(message, editbox)
	if message == "" then
		print("BuyEmAll: Use /buyemall confirm to enable/disable the large purchange confirm.");
	elseif message == "confirm" then
		if BEAConfirmToggle == 1 then
			BEAConfirmToggle = 0;
			print("BuyEmAll: Large purchase confirm window disabled.");
		elseif BEAConfirmToggle == 0 then
			BEAConfirmToggle = 1;
			print("BuyEmAll: Large purchase confirm window enabled.");
		end
	end
end


--[[
Makes sure the BuyEmAll frame goes away when you leave a vendor
]]
function BuyEmAll:MerchantFrame_OnHide(...)
	BuyEmAllFrame:Hide();
	return self.OrigMerchantFrame_OnHide(...);
end

function BuyEmAll:CogsFreeBagSpace(itemID)
	local freeSpace = 0;
	local itemSubType = GetItemFamily(itemID);
	local stackSize = select(8, GetItemInfo(itemID));
	
	for theBag = 0, 4 do
		local doBag = true;
		
		if theBag > 0 then -- 0 is always the backpack
			local bagLink = GetInventoryItemLink("player", 19 + theBag); -- Bag #1 is in inventory slot 20
			if bagLink then
				local bagSubType = GetItemFamily(bagLink);
				if bagSubType == itemSubType then
					doBag = true;
				elseif bagSubType == 0 then
					doBag = true;
				elseif bit.band(itemSubType, bagSubType) == bagSubType then
					doBag = true;
				else doBag = false;
				end
			else
				doBag = false;
			end
		end
		
		if doBag then
			local numSlot = GetContainerNumSlots(theBag);
			for theSlot = 1, numSlot do
				local itemLink = GetContainerItemLink(theBag, theSlot);
				if not itemLink then
					freeSpace = freeSpace + stackSize;
				elseif strfind(itemLink, "item:" .. itemID .. ":") then
					local _,itemCount = GetContainerItemInfo(theBag, theSlot);
					freeSpace = freeSpace + stackSize - itemCount;
				end
			end
		end
	end
	return freeSpace, stackSize;
end


--[[
Hooks left-clicks on merchant item buttons
]]
function BuyEmAll:MerchantItemButton_OnModifiedClick(frame, button)
	self.itemIndex = frame:GetID();
	if ChatFrame1EditBox:HasFocus() then ChatFrame1EditBox:Insert(GetMerchantItemLink(frame:GetID()));
	elseif MerchantFrame.selectedTab == 1
		and IsShiftKeyDown()
			and not IsControlKeyDown()
				and not ChatFrame1EditBox:HasFocus() then

		-- Set up various data before showing the BuyEmAll frame
		
		self.AltCurrencyMode = 0;

		local name, texture, price, quantity, numAvailable = 
			GetMerchantItemInfo(self.itemIndex);
		self.preset = quantity;
		self.price = price;
		self.itemName = name;
		self.available = numAvailable;

		-- Bypass for purchasable things without an itemid/itemlink, don't know any other way right now.
		if GetMerchantItemLink(self.itemIndex) == nil then
			self.ConfirmNoItemID = self.itemIndex;
			local dialog = StaticPopup_Show("BUYEMALL_CONFIRM2", quantity, self.itemName);
			return
		end

		self.itemID = tonumber(strmatch(GetMerchantItemLink(self.itemIndex), "item:(%d+):"));
		local bagMax, stack = self:CogsFreeBagSpace(self.itemID);
		self.stack = stack;
		self.fit = bagMax;

		if select(7,GetMerchantItemInfo(self.itemIndex)) == 1 then
			self:AltCurrencyHandling(self.itemIndex, frame);
			return
		end

		BuyEmAllCurrency1:SetTexture("Interface\\MONEYFRAME\\UI-GoldIcon");
		BuyEmAllCurrency2:SetTexture("Interface\\MONEYFRAME\\UI-SilverIcon"); -- Once known it's a standard transation, use regular money textures
		BuyEmAllCurrency3:SetTexture("Interface\\MONEYFRAME\\UI-CopperIcon");

		self.afford = floor(GetMoney() / ceil(price / self.preset));
		self.max = min(self.fit, self.afford);
		if numAvailable > -1 then
			self.max = min(self.max, numAvailable);
		end
		if self.max == 0 then
			return
		elseif self.max == 1 then
			MerchantItemButton_OnClick("LeftButton", 1);
			return
		end
		
		self.defaultStack = quantity;
		self.split = 1;
		
		self.partialFit = self.fit % stack;
		self:SetStackClick();
		
		-- Misc variables for help with error logs
		self.NPCName = UnitName("npc");
		self.ItemName = select(1,GetMerchantItemInfo(self.itemIndex));
		
		self:Show(frame);
	else
		self.OrigMerchantItemButton_OnModifiedClick(frame, button);
	end
end

function BuyEmAll:AltCurrencyHandling(itemIndex, frame)
	self.AltCurrencyMode = 1;

	local price1, price2, price3 = 0, 0, 0;
	self.price1, self.price2, self.price3 = 0, 0, 0;
	
	self.AltCurrency1Type, self.AltCurrency2Type, self.AltCurrency3Type = 0, 0, 0;
	self.AltCurrency1, self.AltCurrency2, self.AltCurrency3 = 0, 0, 0;
	local Afford1, Afford2, Afford3 = 99999, 99999, 99999;

	local NumAltCurrency = GetMerchantItemCostInfo(itemIndex);

	self.NumAltCurrency = NumAltCurrency;
	if (NumAltCurrency == 1) or (NumAltCurrency == 2) or (NumAltCurrency == 3) then
		if (select(3,GetMerchantItemCostItem(itemIndex, 1)) == nil) then -- Itemlink check
			self.AltCurrency1Type = 0; -- 0 = Pure currency, 1 = Item/Currency, possibly more later
			self.AltCurrency1Tex = select(1,GetMerchantItemCostItem(itemIndex, 1)); -- Grabs texture path, hopefully the same no matter the language
			self.AltCurrency1 = self:AltCurrencyTranslating(self.AltCurrency1Tex);
			price1 = select(2,GetMerchantItemCostItem(itemIndex, 1));
			Afford1 = floor(select(2,GetCurrencyInfo(self.AltCurrency1)) / price1) * self.preset;
		else
			self.AltCurrency1Type = 1;
			self.AltCurrency1 = tonumber(strmatch(select(3,GetMerchantItemCostItem(itemIndex, 1)), "item:(%d+):"));
			self.AltCurrency1Tex = select(10, GetItemInfo(self.AltCurrency1));
			price1 = select(2,GetMerchantItemCostItem(itemIndex, 1));
			Afford1 = floor(GetItemCount(self.AltCurrency1) / price1) * self.preset;
			if (self.AltCurrency1 == 79254) then Afford1 = Afford1 + (floor(GetItemCount(61978) / price1) * self.preset) end
		end
	end
	if (NumAltCurrency == 2) or (NumAltCurrency == 3) then
		if (select(3,GetMerchantItemCostItem(itemIndex, 2)) == nil) then
			self.AltCurrency2Type = 0;
			self.AltCurrency2Tex = select(1,GetMerchantItemCostItem(itemIndex, 2));
			self.AltCurrency2 = self:AltCurrencyTranslating(self.AltCurrency2Tex);
			price2 = select(2,GetMerchantItemCostItem(itemIndex, 2));
			Afford2 = floor(select(2,GetCurrencyInfo(self.AltCurrency2)) / price2) * self.preset;
		else
			self.AltCurrency2Type = 1;
			self.AltCurrency2 = tonumber(strmatch(select(3,GetMerchantItemCostItem(itemIndex, 2)), "item:(%d+):"));
			self.AltCurrency2Tex = select(10, GetItemInfo(self.AltCurrency2));
			price2 = select(2,GetMerchantItemCostItem(itemIndex, 2));
			Afford2 = floor(GetItemCount(self.AltCurrency2) / price2) * self.preset;
		end
	end
	if (NumAltCurrency == 3) then
		if (select(3,GetMerchantItemCostItem(itemIndex, 3)) == nil) then
			self.AltCurrency3Type = 0;
			self.AltCurrency3Tex = select(1,GetMerchantItemCostItem(itemIndex, 3));
			self.AltCurrency3 = self:AltCurrencyTranslating(self.AltCurrency3Tex);
			price3 = select(2,GetMerchantItemCostItem(itemIndex, 3));
			Afford3 = floor(select(2,GetCurrencyInfo(self.AltCurrency3)) / price3) * self.preset;
		else
			self.AltCurrency3Type = 1;
			self.AltCurrency3 = tonumber(strmatch(select(3,GetMerchantItemCostItem(itemIndex, 3)), "item:(%d+):"));
			self.AltCurrency3Tex = select(10, GetItemInfo(self.AltCurrency3));
			price3 = select(2,GetMerchantItemCostItem(itemIndex, 3));
			Afford3 = floor(GetItemCount(self.AltCurrency3) / price3) * self.preset;
		end
	end

	self.price1 = price1;
	self.price2 = price2;
	self.price3 = price3;

	self.afford = min(Afford1, Afford2, Afford3);
	
	self.max = min(self.fit, self.afford);

	if self.available > -1 then
		self.max = min(self.max, self.available * self.preset);
	end

	if self.max == 0 then
		return
	elseif self.max == 1 then
		MerchantItemButton_OnClick("LeftButton", 1);
		return
	end
	
	self.defaultStack = self.preset;
	self.split = self.defaultStack;
	
	self.partialFit = self.fit % self.stack;
	self:SetStackClick();
	
	-- Misc variables for help with error logs
	self.NPCName = UnitName("npc");
	self.ItemName = select(1,GetMerchantItemInfo(self.itemIndex));

	self:Show(frame);
end

function BuyEmAll:AltCurrencyTranslating(Texture)
	if (strmatch(Texture, "-(%a+)-") == "Honor") then
		return 392;
	elseif (strmatch(Texture, "-(%a+)-") == "Conquest") then
		return 390;
	elseif (strmatch(Texture, "-(%a+)$") == "justice") then
		return 395;
	elseif (strmatch(Texture, "-(%a+)$") == "valor") then
		return 396;
	elseif (strmatch(Texture, "_(%a+)$") == "sealofkings") then
		return 614;
	elseif (strmatch(Texture, "%a+_%a+$") == "primal_shadow") then
		return 615;
	elseif (Texture == "Interface\\Icons\\inv_relics_idolofferocity") then
		return 402;
	end
end

--[[
Prepare the various UI elements of the BuyEmAll frame and show it
]]
function BuyEmAll:Show(frame)
	self.typing = 0;
	BuyEmAllLeftButton:Disable();
	BuyEmAllRightButton:Enable();
 
	BuyEmAllStackButton:Enable();
	if self.max < self.stackClick then
		BuyEmAllStackButton:Disable();
	end

	BuyEmAllFrame:ClearAllPoints();
	BuyEmAllFrame:SetPoint("BOTTOMLEFT", frame, "TOPLEFT", 0, 0);

	BuyEmAllFrame:Show(frame);
	self:UpdateDisplay();
end


--[[
If the amount is more than stack and defaultStack, show a confirmation.
Otherwise, do the purchase
]]
function BuyEmAll:VerifyPurchase(amount)
	amount = amount or self.split;
	if (amount > 0) then
		amount = (amount / self.preset) * self.preset;	
		if amount > self.stack and amount > self.defaultStack then
			if BEAConfirmToggle == 1 then
				self:DoConfirmation(amount);
			else
				self:DoPurchase(amount);
			end
		else
			self:DoPurchase(amount);
		end
	end
end


--[[
Makes the actual purchase(s)
]]
function BuyEmAll:DoPurchase(amount)
	BuyEmAllFrame:Hide();
	local numLoops, purchAmount, leftover;

	if amount <= self.stack then
		purchAmount = amount;
		numLoops = 1;
		leftover = 0;
	else
		if (amount % self.stack) > 0 then
			purchAmount = self.stack;
			numLoops = floor(amount/self.stack);
			leftover = amount % self.stack;
		else
			purchAmount = self.stack;
			numLoops = floor(amount/self.stack);
			leftover = 0;
		end
	end
	
	for i = 1, numLoops do
		BuyMerchantItem(self.itemIndex, purchAmount);
	end
	
	if leftover > 0 then BuyMerchantItem(self.itemIndex, leftover) end
end


--[[
Changes the money display to however much amount of the item will cost. If
amount is not specified, it uses the current split value.
]]
function BuyEmAll:UpdateDisplay()
	local purchase = self.split;
	if (self.AltCurrencyMode == 0) then
		local cost = 0;
		if self.defaultStack > 1 then
			cost = purchase * (self.price / self.defaultStack);
		else
			cost = purchase * self.price;
		end
		cost = ceil(cost);
		local gold = floor(abs(cost / 10000));
		local silver = floor(abs(mod(cost / 100, 100)));
		local copper = floor(abs(mod(cost, 100)));

		BuyEmAllCurrencyAmt1:SetText(gold);
		BuyEmAllCurrencyAmt2:SetText(silver);
		BuyEmAllCurrencyAmt3:SetText(copper);
	elseif (self.AltCurrencyMode == 1) then
		if ((purchase % self.preset) ~= 0) then
			if ((purchase % self.preset) <= (self.preset / 2)) then
				if ((purchase - (purchase % self.preset)) == 0) then
					purchase = self.preset;
				end
				purchase = purchase - (purchase % self.preset);
			elseif ((purchase % self.preset) > (self.preset / 2)) then
				purchase = purchase + (self.preset - (purchase % self.preset));
			end
		end
		if ((self.NumAltCurrency == 1) or (self.NumAltCurrency == 2) or (self.NumAltCurrency == 3)) then
			local cost1 = purchase * self.price1;
			BuyEmAllCurrencyAmt1:SetText(cost1);
			BuyEmAllCurrency1:SetTexture(self.AltCurrency1Tex);
		end
		if ((self.NumAltCurrency == 2) or (self.NumAltCurrency == 3)) then
			local cost2 = purchase * self.price2;
			BuyEmAllCurrencyAmt2:SetText(cost2);
			BuyEmAllCurrency2:SetTexture(self.AltCurrency2Tex);
		end
		if ((self.NumAltCurrency == 3)) then
			local cost3 = purchase * self.price3;
			BuyEmAllCurrencyAmt3:SetText(cost3);
			BuyEmAllCurrency3:SetTexture(self.AltCurrency3Tex);
		end
	end

	BuyEmAllText:SetText(self.split);
	
	BuyEmAllLeftButton:Enable();
	BuyEmAllRightButton:Enable();
	BuyEmAllMaxButton:Enable();
	if (self.split == self.max) then
		BuyEmAllRightButton:Disable();
		BuyEmAllMaxButton:Disable();
	elseif (self.AltCurrencyMode == 0) and (self.split == 1) then
		BuyEmAllLeftButton:Disable();
	elseif (self.AltCurrencyMode == 1) and (self.split == self.preset) then
		BuyEmAllLeftButton:Disable();
	end
	
	self:SetStackClick();
	BuyEmAllStackButton:Enable();
	if self.max < self.stackClick then
		BuyEmAllStackButton:Disable();
	end
end


--[[
Shows the confirmation dialog
]]
function BuyEmAll:DoConfirmation(amount)
	local dialog = StaticPopup_Show("BUYEMALL_CONFIRM", amount, self.itemName);
	dialog.data = amount;
end


--[[
Calculates the amount that the Stack button will enter
]]
function BuyEmAll:SetStackClick()
	local increase = (self.partialFit == 0 and self.stack or self.partialFit) - (self.split % self.stack);
	self.stackClick = self.split + (increase == 0 and self.stack or increase);
end

function BuyEmAll:DeStackClick()
	local decrease = tonumber(BuyEmAllText:GetText());
	if decrease <= self.stack then
		self.split = 1;
		self:UpdateDisplay();
	else
		self.split = decrease - self.stack;
		self:UpdateDisplay();
	end
end


--[[
OnClick handler for the four main buttons
]]
function BuyEmAll:OnClick(frame,button)
	if frame == BuyEmAllOkayButton then
		amount = tonumber(BuyEmAllText:GetText());
		self:VerifyPurchase(amount);
	elseif frame == BuyEmAllCancelButton then
		BuyEmAllFrame:Hide();
	elseif frame == BuyEmAllStackButton then
		if button == "LeftButton" then
			self.split = self.stackClick;
			self:UpdateDisplay();
			if frame:IsEnabled() == 1 then
				self:OnEnter(frame);
			else
				GameTooltip:Hide();
			end
		elseif button == "RightButton" then
			self:DeStackClick();
			if frame:IsEnabled() == 1 then
				self:OnEnter(frame);
			else
				GameTooltip:Hide();
			end
		end
	elseif frame == BuyEmAllMaxButton then
		self.split = self.max;
		self:UpdateDisplay();
	end
end


--[[
Allows you to type a number to buy. This is adapted directly from the Default
UI's code.
]]
function BuyEmAll:OnChar(text)
	if text < "0" or text > "9" then
		return
	end

	if self.typing == 0 then
		self.typing = 1;
		self.split = 0;
	end

	local split = (self.split * 10) + text;

	if split == self.split then
		if self.split == 0 then
			self.split = 1;
		end
		self:UpdateDisplay();
		return
	end

	if split <= self.max then
		self.split = split;
	elseif split == 0 then
		self.split = 1;
	end
	self:UpdateDisplay();
end


--[[
Key handler for keys other than 0-9
]]
function BuyEmAll:OnKeyDown(key)
	if key == "BACKSPACE" or key == "DELETE" then
		if self.typing == 0 or self.split == 1 then
			return
		end

		self.split = floor(self.split / 10);
		if self.split <= 1 then
			self.split = 1;
			self.typing = 0;
		end
		
		self:UpdateDisplay();
	elseif key == "ENTER" then
		self:VerifyPurchase();
	elseif key == "ESCAPE" then
		BuyEmAllFrame:Hide();
	elseif key == "LEFT" or key == "DOWN" then
		BuyEmAll:Left_Click();
	elseif key == "RIGHT" or key == "UP" then
		BuyEmAll:Right_Click();
	elseif key == "PRINTSCREEN" then
		Screenshot();
	end
end


--[[
Decreases the amount by however much is necessary to go down to the next
lowest multiple of the preset stack size.
]]
function BuyEmAll:Left_Click()
	if (self.AltCurrencyMode == 0) then
		self.split = self.split - 1;
		self:UpdateDisplay();
	else
		self.split = self.split - self.preset;
		self:UpdateDisplay();
	end
end


--[[
Increases the amount by however much is necessary to go up to the next highest
multiple of the preset stack size.
]]
function BuyEmAll:Right_Click()
	if (self.AltCurrencyMode == 0) then
		self.split = self.split + 1;
		self:UpdateDisplay();
	else
		self.split = self.split + self.preset;
		self:UpdateDisplay();
	end
end


--[[
This table is used for the two functions that follow
]]
BuyEmAll.lines = {
	stack = {
		label = L.STACK_PURCH,
		field = "stackClick",
		{ label = L.STACK_SIZE, field = "stack" },
		{ label = L.PARTIAL, field = "partialFit" },
	},
	max = {
		label = L.MAX_PURCH,
		field = "max",
		{ label = L.AFFORD, field = "afford" },
		{ label = L.FIT, field = "fit" },
		{
			label = L.AVAILABLE, 
			field = "available",
			Hide = function()
				return BuyEmAll.available <= 1
			end
		},
	},
}


--[[
Shows tooltips when you hover over the Stack or Max buttons
]]
function BuyEmAll:OnEnter(frame)
	local lines = self.lines[frame == BuyEmAllMaxButton and "max" or "stack"];
	
	lines.amount = self[lines.field];
	for i, line in ipairs(lines) do
		line.amount = self[line.field];
	end
		
	self:CreateTooltip(frame, lines);
end


--[[
Creates the tooltip from the given lines table. See the structure of lines above for
more insight.
]]
function BuyEmAll:CreateTooltip(frame, lines)
	GameTooltip:SetOwner(frame, "ANCHOR_BOTTOMRIGHT");
	GameTooltip:SetText(lines.label.."|cFFFFFFFF - |r"..GREEN_FONT_COLOR_CODE..lines.amount.."|r");

	for _, line in ipairs(lines) do
		if not (line.Hide and line.Hide()) then
			local color = 
				line.amount == lines.amount and GREEN_FONT_COLOR or HIGHLIGHT_FONT_COLOR;
			GameTooltip:AddDoubleLine(line.label, line.amount, 1,1,1, color.r,color.g,color.b);
		end
	end
	
	--SetTooltipMoney(GameTooltip, ceil(lines.amount / self.preset) * self.price);
	-- Need to replace, but also need to understand tooltips more to do so. x.x
	
	GameTooltip:Show();
end


--[[
Hides the tooltip
]]
function BuyEmAll:OnLeave()
	GameTooltip:Hide();
	--GameTooltip_ClearMoney(GameTooltip);
	-- Not needed because of previous commenting out.
end


--[[
When the BuyEmAll frame is closed, close any confirmations waiting for a
response as well as clear the currencies.
]]
function BuyEmAll:OnHide()
	BuyEmAllCurrency1:SetTexture();
	BuyEmAllCurrency2:SetTexture();
	BuyEmAllCurrency3:SetTexture();
	BuyEmAllCurrencyAmt1:SetText();
	BuyEmAllCurrencyAmt2:SetText();
	BuyEmAllCurrencyAmt3:SetText();
	StaticPopup_Hide("BUYEMALL_CONFIRM");
end
