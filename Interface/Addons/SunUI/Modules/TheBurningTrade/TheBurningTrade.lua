local S, L, DB, _, C = unpack(select(2, ...))
if(Skinner and Skinner.initialized) then Skinner.initialized.TradeFrame = true; end;
local Module = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("TheBurningTrade", "AceEvent-3.0", "AceHook-3.0")
TBT_SPELL_TABLE = {
	water = {
		{ level=80, sid=42955, iid=43523, name="", item="", rank="" },
	},

	stone = {
		{ level=0, sid=6201, iid={5512} },
	}
}
for _, v in pairs(TBT_SPELL_TABLE) do for _, vv in pairs(v) do vv.name, vv.rank = GetSpellInfo(vv.sid) end end

local function SetOrHookScript(frame, scriptName, func)
	if( frame:GetScript(scriptName) ) then
		frame:HookScript(scriptName, func);
	else
		frame:SetScript(scriptName, func);
	end
end

local function tcontains(onetable, onevalue)
	if(type(onetable)=="table") then
		return table.foreach(onetable, function(idx, value) if(value==onevalue) then return true end end)
	else
		return onetable==onevalue
	end
end

function TBTFrame_OnLoad(self)
	self:RegisterEvent("PLAYER_ENTERING_WORLD");
	self:RegisterEvent("TRADE_TARGET_ITEM_CHANGED");

	--display the trade recepient info
	local targetInfoText = TradeFrame:CreateFontString("TradeFrameTargetInfoText", "ARTWORK", "GameFontNormal");
	targetInfoText:SetWidth(100);
	targetInfoText:SetHeight(12);
	targetInfoText:SetJustifyH("RIGHT");
	targetInfoText:SetPoint("TOPLEFT", "TradeFrameRecipientNameText", "BOTTOMLEFT", 0, -8);
	hooksecurefunc("TradeFrame_OnShow", function(self)if(UnitExists("NPC"))then TradeFrameTargetInfoText:SetText(UnitClass("NPC").." - "..UnitLevel("NPC"));end end);

	--button for whisper
	local button = CreateFrame("Button", "TradeFrameTargetWhisperButton", TradeFrame, "UIPanelButtonTemplate");
	button:SetWidth(30);
	button:SetHeight(21);
	button:SetPoint("TOPLEFT", "TradeFrameTargetInfoText", "BOTTOMLEFT", 0, -2);
	button:SetText(TBT_RIGHT_BUTTON.whisper);
	button:SetScript("OnClick", function(self) 
		ChatFrame_SendTell(GetUnitName("NPC", true));
	end)
	S.Reskin(button)
	--button for emote1
	button = CreateFrame("Button", "TradeFrameTargetEmote1Button", TradeFrame, "UIPanelButtonTemplate");
	button:SetWidth(30);
	button:SetHeight(21);
	button:SetPoint("LEFT", "TradeFrameTargetWhisperButton", "RIGHT", 5, 0);
	button:SetText(TBT_RIGHT_BUTTON.ask);
	button:SetScript("OnClick", function(self) DoEmote("hungry", "NPC") end);
	S.Reskin(button)
	--button for emote2
	button = CreateFrame("Button", "TradeFrameTargetEmote2Button", TradeFrame, "UIPanelButtonTemplate");
	button:SetWidth(30);
	button:SetHeight(21);
	button:SetPoint("LEFT", "TradeFrameTargetEmote1Button", "RIGHT", 5, 0);
	button:SetText(TBT_RIGHT_BUTTON.thank);
	button:SetScript("OnClick", function(self) DoEmote("thank", "NPC") end);
	S.Reskin(button)
	--button for click-targetting, positioned at portrait.
	button = CreateFrame("Button", "TradeFrameTargetRecipientButton", TradeFrame, "SecureActionButtonTemplate") 
	button:SetAttribute("type", "target");
	button:SetAttribute("unit", "NPC");
	button:SetWidth(60)
	button:SetHeight(70)
	button:SetPoint("CENTER", "TradeFrame", "TOPLEFT", 210, -35);
	--for alt+leftclick quick trade
	hooksecurefunc("ContainerFrameItemButton_OnModifiedClick", function(self, button)

		if(button == "LeftButton" and IsAltKeyDown() ) then
			if(TradeFrame:IsVisible() and not InCombatLockdown()) then 
				PickupContainerItem(self:GetParent():GetID(), self:GetID());
				StackSplitFrame:Hide();
				TradeFrame_OnMouseUp();
				return
			end
			if(InboxFrame and InboxFrame:IsVisible()) then
				MailFrameTab_OnClick(nil, 2);
			end
			if(SendMailAttachment1 and SendMailAttachment1:IsVisible()) then
				UseContainerItem(self:GetParent():GetID(), self:GetID());
			elseif(AuctionsItemButton and AuctionsItemButton:IsVisible()) then
				PickupContainerItem(self:GetParent():GetID(), self:GetID());
				ClickAuctionSellItemButton();
				AuctionsFrameAuctions_ValidateAuction();
				if(CursorHasItem()) then ClearCursor(); end;
			end
		end

		--for shift+leftclick start auction search directly.
		if(button == "LeftButton" and IsShiftKeyDown() and AuctionFrame and AuctionFrame:IsVisible() and AuctionFrameBrowse:IsVisible()) then
			--AuctionFrameTab_OnClick(AuctionFrameTab1, 1);
			BrowseResetButton:GetScript("OnClick")(BrowseResetButton);
			ChatEdit_InsertLink(GetContainerItemLink(self:GetParent():GetID(), self:GetID()));
			AuctionFrameBrowse_Search();
		end

		--quick sell same item
		if(button=="RightButton" and IsControlKeyDown() and IsAltKeyDown() and AuctionsItemButton and AuctionsItemButton:IsVisible()) then
			PickupContainerItem(self:GetParent():GetID(), self:GetID());
			ClickAuctionSellItemButton();
			local name, texture, count, quality, canUse, price = GetAuctionSellItemInfo();
			if ( name == LAST_ITEM_AUCTIONED and count == LAST_ITEM_COUNT) then
				MoneyInputFrame_SetCopper(StartPrice, LAST_ITEM_START_BID);
				MoneyInputFrame_SetCopper(BuyoutPrice, LAST_ITEM_BUYOUT);
			end
			AuctionsFrameAuctions_ValidateAuction();
			if(AuctionsCreateAuctionButton:IsEnabled()==1) then
				AuctionsCreateAuctionButton_OnClick();
			else
				DEFAULT_CHAT_FRAME:AddMessage(TBT_CANT_CREATE_AUCTION);
			end
		end
	end)

end

function TBTFrame_SetButtonSpell(button, spell)
	if not InCombatLockdown() then
		button:SetAttribute("type", "spell");
		button:SetAttribute("spell", spell);
	end
end

function TBT_TradeItem(self, type)
	local iids,quantity,spell,maxRank,spells,i;
	maxRank = TBT_MaxSpellRank[type];
	TBTFrame_SetButtonSpell(self, "")

	local spells, npcLevel;
	spells = TBT_SPELL_TABLE[type];
	npcLevel = UnitLevel("npc");

	for i=maxRank or table.getn(spells), 1,-1 do
		if(spells[i].level <= npcLevel) then
			spell = spells[i].name --.."("..spells[i].rank..")" no spell rank in 4.0
			iids = spells[i].iid
			break;
		end
	end
		
	if(type=="water") then 
		quantity=15;
	else
		quantity=1;
	end

	local bag, slot = TBT_FindItem(iids, quantity, type)
	if(slot) then
		local emptySlot = false;
		for i=1,6 do
			if(not GetTradePlayerItemInfo(i)) then
				emptySlot = true;
			end;
		end
		if(emptySlot) then
			PickupContainerItem(bag, slot);
			StackSplitFrame:Hide();
			TradeFrame_OnMouseUp();
			return;
		end			
	end

	if(maxRank) then --can create this item
		TBTFrame_SetButtonSpell(self, spell);
	end
end

local function CreatePlayerSpellButton(id, type)
	local button = CreateFrame("Button", "TradeFramePlayerSpell"..id.."Button", TradeFrame, "UIPanelButtonTemplate, SecureActionButtonTemplate");
	button:SetWidth(45);
	button:SetHeight(21);
	button:SetText(TBT_LEFT_BUTTON[type]);
	--S.Reskin(button)
	return button
end

function TBTFrame_CreateLeftButton(class)
	--everyone can trade others water
	local button = CreatePlayerSpellButton(1, "water");
	button:SetPoint("TOPLEFT", "TradeFrame", "TOPLEFT", 72, -30);
	button:SetScript("PreClick", function(self) TBT_TradeItem(self, "water") end);
	button:SetScript("PostClick", function(self) TBTFrame_SetButtonSpell(self,"") end);
	S.Reskin(button)
	local type = class=="WARLOCK" and "stone" or class=="ROGUE" and "unlock" or nil;

	if(type) then
		button = CreatePlayerSpellButton(2, type)
		button:SetPoint("LEFT", "TradeFramePlayerSpell1Button", "RIGHT", 5, 0);
	end

	if(type=="stone") then
		button:SetScript("PreClick", function(self) TBT_TradeItem(self, type) end);
		button:SetScript("PostClick", function(self) TBTFrame_SetButtonSpell(self,"") end);
	elseif(type=="unlock") then
		button:SetAttribute("type","spell");
		button:SetAttribute("spell", GetSpellInfo(1804));
		button:SetScript("PostClick", function(self) ClickTargetTradeButton(7); end);		
	end

end

TBT_MaxSpellRank = {};

function TBTFrame_OnEvent(self, event, ...)
	if(event == "PLAYER_ENTERING_WORLD") then
		self:UnregisterEvent("PLAYER_ENTERING_WORLD");
		local _,class = UnitClass("player")
		TBTFrame_CreateLeftButton(class);

		if(class=="MAGE") then
			TBT_MaxSpellRank["water"] = 1
		elseif(class=="WARLOCK")then
			TBT_MaxSpellRank["stone"] = 1
		end
	elseif(event == "TRADE_TARGET_ITEM_CHANGED") then
		local link = GetTradeTargetItemLink(7)
		if(link) then
			local type = select(9, GetItemInfo(link))
			ChatFrame1:AddMessage(type)
		end
	end
end

function TBT_FindItem(iids,quantity,type)
	local bag,slog,i;
	for bag=0,NUM_CONTAINER_FRAMES do
		for slot=1,GetContainerNumSlots(bag) do
			local _, count, locked, _ = GetContainerItemInfo(bag, slot)
			if (count and not locked and count >= quantity ) then
				local itemId = GetContainerItemID(bag, slot);
				if(tcontains(iids, itemId)) then
					TBT_debug("found itemId=",itemId);
					return bag, slot;
				end
			end
		end
	end
end

function TBT_debug(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
	if(1) then return; end
	local msg = "";
	if(arg1) then msg = msg..arg1.."," else msg = msg.." ," end 
	if(arg2) then msg = msg..arg2.."," else msg = msg.." ," end
	if(arg3) then msg = msg..arg3.."," else msg = msg.." ," end
	if(arg4) then msg = msg..arg4.."," else msg = msg.." ," end
	if(arg5) then msg = msg..arg5.."," else msg = msg.." ," end
	if(arg6) then msg = msg..arg6.."," else msg = msg.." ," end
	if(arg7) then msg = msg..arg7.."," else msg = msg.." ," end
	DEFAULT_CHAT_FRAME:AddMessage(msg);
end

function Module:OnInitialize()
	local frame = CreateFrame("Frame");
	frame:SetScript("OnEvent", TBTFrame_OnEvent);
	TBTFrame_OnLoad(frame);
end