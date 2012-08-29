local S, C, L, DB = unpack(SunUI)
local addon, ns = ...
local cfg = {
	bar_width = 250,					-- group roll bar width
	bar_height = 25,					-- group roll bar height
	suppress_loot_spam = true,
}

UIParent:UnregisterEvent("START_LOOT_ROLL");
UIParent:UnregisterEvent("CANCEL_LOOT_ROLL");

if not (GetLocale=="enGB" or GetLocale=="enUS") then
	LOOT_ROLL_GREED = "%s has selected Greed for: %s"
	LOOT_ROLL_NEED = "%s has selected Need for: %s"
	LOOT_ROLL_PASSED = "%s passed on: %s"
	LOOT_ROLL_PASSED_AUTO = "%s automatically passed on: %s because he cannot loot that item."
	LOOT_ROLL_PASSED_AUTO_FEMALE = "%s automatically passed on: %s because she cannot loot that item."
	LOOT_ROLL_DISENCHANT = "%s has selected Disenchant for: %s"
end

local GFHCName, GFHCHeight = GameFontHighlightCenter:GetFont();
local grouplootlist, grouplootbars, grouplootrolls = {}, {}, {};
local rollstrings = { 
			[(LOOT_ROLL_PASSED_AUTO):gsub("%%1$s", "(.+)"):gsub("%%2$s", "(.+)")] = "pass", 
			[(LOOT_ROLL_PASSED_AUTO_FEMALE):gsub("%%1$s", "(.+)"):gsub("%%2$s", "(.+)")] = "pass", 
			[(LOOT_ROLL_PASSED):gsub("%%s", "(.+)")] = "pass", 
			[(LOOT_ROLL_GREED):gsub("%%s", "(.+)")] = "greed", 
			[(LOOT_ROLL_DISENCHANT):gsub("%%s", "(.+)")] = "disenchant", 
			[(LOOT_ROLL_NEED):gsub("%%s", "(.+)")] = "need" };

local function OnEvent(self, event, ...)
	if ( event == "CHAT_MSG_LOOT" ) then
		local msg = ...;
		for string, roll in pairs(rollstrings) do
			local _, _, player, item = string.find(msg, string);
			if ( player and item ) then
				local rollId;
				for index, value in ipairs(grouplootbars) do
					if ( value.rollId and item == value.rollLink ) then
						rollId = value.rollId;
						if ( not grouplootrolls[rollId] ) then
							grouplootrolls[rollId] = {};
						end
						if ( not grouplootrolls[rollId][roll] ) then
							grouplootrolls[rollId][roll] = {};
							grouplootrolls[rollId][roll].count = 0;
						end
						if ( not grouplootrolls[rollId][roll][player] ) then
							grouplootrolls[rollId][roll].count = grouplootrolls[rollId][roll].count+1;
							grouplootrolls[rollId][roll][player] = true;
						end
						if ( roll == "need" ) then
							value.needtext:SetText(grouplootrolls[rollId][roll].count);
						elseif ( roll == "greed" ) then
							value.greedtext:SetText(grouplootrolls[rollId][roll].count);
						elseif ( roll == "disenchant" ) then
							value.disenchanttext:SetText(grouplootrolls[rollId][roll].count);
						else
							value.passtext:SetText(grouplootrolls[rollId][roll].count);
						end
						return;
					end
				end
			end
		end
		return;
	end
	local rollId, rollTime = ...;
	table.insert(grouplootlist, { rollId = rollId, rollTime = rollTime });
	self:UpdateGroupLoot();
end

local function BarOnUpdate(self, elapsed)
	if ( self.rollId ) then
		local left = GetLootRollTimeLeft(self.rollId);
		local min, max = self:GetMinMaxValues();
		if ( (left < min) or (left > max) ) then
			left = min;
		end
		self:SetValue(left);
		
		if ( GameTooltip:IsOwned(self) ) then
			GameTooltip:SetOwner(self, "ANCHOR_BOTTOMLEFT");
			GameTooltip:SetLootRollItem(self.rollId);
		end
		CursorOnUpdate(self);
	end
end

local function BarOnEvent(self, event, ...)
	local rollId = ...;
	if ( self.rollId and rollId == self.rollId ) then
		for index, value in ipairs(grouplootlist) do
			if ( self.rollId == value.rollId ) then
				tremove(grouplootlist, index);
				break;
			end
		end
		grouplootrolls[self.rollId] = nil;
		StaticPopup_Hide("CONFIRM_LOOT_ROLL", self.rollId);
		self.rollId = nil;
		sGroupLoot:UpdateGroupLoot();
	end
end

local function BarOnClick(self)
	HandleModifiedItemClick(self.rollLink);
end

local function BarOnEnter(self)
	if not self.rollId then return end
	GameTooltip:SetOwner(self, "ANCHOR_BOTTOMLEFT");
	GameTooltip:SetLootRollItem(self.rollId);
	if IsShiftKeyDown() then GameTooltip_ShowCompareItem() end
	if IsModifiedClick("DRESSUP") then ShowInspectCursor() else ResetCursor() end
	CursorUpdate(self);
end

local function BarOnLeave(self)
	GameTooltip:Hide();
	ResetCursor();
end

local function BarButtonOnClick(self, button)
	RollOnLoot(self:GetParent().rollId, self.type)
	--RollOnLoot(self:GetParent().rollID, self:GetID());
end

local function BarButtonOnEnter(self)
	local rolltext;
	if ( self.roll == "need" ) then
		rolltext = NEED;
	elseif ( self.roll == "greed" ) then
		rolltext = GREED;
	elseif ( self.roll == "disenchant" ) then
		rolltext = ROLL_DISENCHANT;
	else
		rolltext = PASS;
	end
	local rollId = self:GetParent().rollId;
	GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT");
	GameTooltip:SetText(rolltext);
	if ( grouplootrolls[rollId] and grouplootrolls[rollId][self.roll] ) then
		for index, value in pairs(grouplootrolls[rollId][self.roll]) do
			if ( index ~= "count" ) then
				GameTooltip:AddLine(index, 1, 1, 1);
			end
		end
	end
	GameTooltip:Show();
end

local function BarButtonOnLeave(self)
	GameTooltip:Hide();
end

local frame = CreateFrame("Frame", "sGroupLoot", UIParent);
frame:RegisterEvent("CHAT_MSG_LOOT");
frame:RegisterEvent("START_LOOT_ROLL");
frame:SetScript("OnEvent", OnEvent);

function frame:UpdateGroupLoot()
	for index, value in ipairs(grouplootbars) do
		value:Hide();
	end
	table.sort(grouplootlist, function(a, b)
		return a.rollId < b.rollId;
	end);
	local bar, texture, name, count, quality, bindOnPickUp, color;
	for index, value in ipairs(grouplootlist) do
		bar = grouplootbars[index];
		if ( not bar ) then
			bar = CreateFrame("StatusBar", "sGroupLootBar"..index, UIParent);
			bar:EnableMouse(1);
			bar:SetWidth(cfg.bar_width);
			bar:SetHeight(cfg.bar_height);
			bar:SetStatusBarTexture(DB.Statusbar);
			if ( index == 1 ) then
				MoveHandle.RollFrame = S.MakeMoveHandle(bar, "Roll", "RollFrame")
			else
				bar:SetPoint("TOP", grouplootbars[index-1], "BOTTOM", 0, -17);
			end
			bar:SetScript("OnUpdate", BarOnUpdate);
			bar:RegisterEvent("CANCEL_LOOT_ROLL");
			bar:SetScript("OnEvent", BarOnEvent);
			bar:SetScript("OnMouseUp", BarOnClick);
			bar:SetScript("OnEnter", BarOnEnter);
			bar:SetScript("OnLeave", BarOnLeave);
			bar:CreateShadow()
			local gradient = bar:CreateTexture(nil, "BACKGROUND")
			gradient:SetPoint("TOPLEFT")
			gradient:SetPoint("BOTTOMRIGHT")
			gradient:SetTexture(DB.Statusbar)
			gradient:SetGradientAlpha("VERTICAL", .3, .3, .3, .6, .1, .1, .1, .6)
					
			bar.pass = CreateFrame("Button", "$perentPassButton", bar);
			bar.pass.type = 0;
			bar.pass.roll = "pass";
			bar.pass:SetWidth(28);
			bar.pass:SetHeight(28);
			bar.pass:SetNormalTexture("Interface\\Buttons\\UI-GroupLoot-Pass-Up");
			bar.pass:SetHighlightTexture("Interface\\Buttons\\UI-GroupLoot-Pass-Down");
			bar.pass:SetPoint("RIGHT", -5, 1);
			bar.pass:SetScript("OnClick", BarButtonOnClick);
			bar.pass:SetScript("OnEnter", BarButtonOnEnter);
			bar.pass:SetScript("OnLeave", BarButtonOnLeave);
			bar.passtext = bar.pass:CreateFontString("$perentText", "ARTWORK");
			bar.passtext:SetFont(GFHCName, GFHCHeight, "OUTLINE");
			bar.passtext:SetShadowColor(1, 1, 1, 0);
			bar.passtext:SetPoint("CENTER");
			
			bar.greed = CreateFrame("Button", "$perentGreedButton", bar);
			bar.greed.type = 2;
			bar.greed.roll = "greed";
			bar.greed:SetWidth(28);
			bar.greed:SetHeight(28);
			bar.greed:SetNormalTexture("Interface\\Buttons\\UI-GroupLoot-Coin-Up");
			bar.greed:SetPushedTexture("Interface\\Buttons\\UI-GroupLoot-Coin-Down");
			bar.greed:SetHighlightTexture("Interface\\Buttons\\UI-GroupLoot-Coin-Highlight");
			bar.greed:SetPoint("RIGHT", bar.pass, "LEFT", -2, -4);
			bar.greed:SetScript("OnClick", BarButtonOnClick);
			bar.greed:SetScript("OnEnter", BarButtonOnEnter);
			bar.greed:SetScript("OnLeave", BarButtonOnLeave);
			bar.greedtext = bar.greed:CreateFontString("$perentText", "ARTWORK");
			bar.greedtext:SetFont(GFHCName, GFHCHeight, "OUTLINE");
			bar.greedtext:SetShadowColor(1, 1, 1, 0);
			bar.greedtext:SetPoint("CENTER", 0, 3);
			
			bar.disenchant = CreateFrame("Button", "$perentGreedButton", bar);
			bar.disenchant.type = 3;
			bar.disenchant.roll = "disenchant";
			bar.disenchant:SetWidth(28);
			bar.disenchant:SetHeight(28);
			bar.disenchant:SetNormalTexture("Interface\\Buttons\\UI-GroupLoot-DE-Up");
			bar.disenchant:SetPushedTexture("Interface\\Buttons\\UI-GroupLoot-DE-Down");
			bar.disenchant:SetHighlightTexture("Interface\\Buttons\\UI-GroupLoot-DE-Highlight");
			bar.disenchant:SetPoint("RIGHT", bar.greed, "LEFT", -2, 2);
			bar.disenchant:SetScript("OnClick", BarButtonOnClick);
			bar.disenchant:SetScript("OnEnter", BarButtonOnEnter);
			bar.disenchant:SetScript("OnLeave", BarButtonOnLeave);
			bar.disenchanttext = bar.disenchant:CreateFontString("$perentText", "ARTWORK");
			bar.disenchanttext:SetFont(GFHCName, GFHCHeight, "OUTLINE");
			bar.disenchanttext:SetShadowColor(1, 1, 1, 0);
			bar.disenchanttext:SetPoint("CENTER", 0, 1);

			bar.need = CreateFrame("Button", "$perentNeedButton", bar);
			bar.need.type = 1;
			bar.need.roll = "need";
			bar.need:SetWidth(28);
			bar.need:SetHeight(28);
			bar.need:SetNormalTexture("Interface\\Buttons\\UI-GroupLoot-Dice-Up");
			bar.need:SetPushedTexture("Interface\\Buttons\\UI-GroupLoot-Dice-Down");
			bar.need:SetHighlightTexture("Interface\\Buttons\\UI-GroupLoot-Dice-Highlight");
			bar.need:SetPoint("RIGHT", bar.disenchant, "LEFT", -2, 0);
			bar.need:SetScript("OnClick", BarButtonOnClick);
			bar.need:SetScript("OnEnter", BarButtonOnEnter);
			bar.need:SetScript("OnLeave", BarButtonOnLeave);
			bar.needtext = bar.need:CreateFontString("$perentText", "ARTWORK");
			bar.needtext:SetFont(GFHCName, GFHCHeight, "OUTLINE");
			bar.needtext:SetShadowColor(1, 1, 1, 0);
			bar.needtext:SetPoint("CENTER", 0, 1);
			
			bar.text = bar:CreateFontString("$perentText", "ARTWORK", "GameFontHighlightLeft");
			--bar.text:SetFont(GFHCName, GFHCHeight, "THINOUTLINE");
			bar.text:SetPoint("LEFT", 5, 0);
			bar.text:SetPoint("RIGHT", bar.need, "LEFT");
			
--[[ 			bar.border = {};
			bar.border.topleft = bar:CreateTexture(nil, "OVERLAY");
			bar.border.topleft:SetTexture(nil);
			bar.border.topleft:SetPoint("TOPLEFT", -3, 3);
			bar.border.topleft:SetWidth(12);
			bar.border.topleft:SetHeight(12);
			bar.border.topleft:SetTexCoord(0, 1/3, 0, 1/3);
			bar.border.bottomleft = bar:CreateTexture(nil, "OVERLAY");
			bar.border.bottomleft:SetTexture(nil);
			bar.border.bottomleft:SetPoint("BOTTOMLEFT", -3, -3);
			bar.border.bottomleft:SetWidth(12);
			bar.border.bottomleft:SetHeight(12);
			bar.border.bottomleft:SetTexCoord(0, 1/3, 2/3, 1);
			bar.border.topright = bar:CreateTexture(nil, "OVERLAY");
			bar.border.topright:SetTexture(nil);
			bar.border.topright:SetPoint("TOPRIGHT", 3, 3);
			bar.border.topright:SetWidth(12);
			bar.border.topright:SetHeight(12);
			bar.border.topright:SetTexCoord(2/3, 1, 0, 1/3);
			bar.border.bottomright = bar:CreateTexture(nil, "OVERLAY");
			bar.border.bottomright:SetTexture(nil);
			bar.border.bottomright:SetPoint("BOTTOMRIGHT", 3, -3);
			bar.border.bottomright:SetWidth(12);
			bar.border.bottomright:SetHeight(12);
			bar.border.bottomright:SetTexCoord(2/3, 1, 2/3, 1);
			bar.border.top = bar:CreateTexture(nil, "OVERLAY");
			bar.border.top:SetTexture(cnil);
			bar.border.top:SetPoint("TOPLEFT", bar.border.topleft, "TOPRIGHT");
			bar.border.top:SetPoint("TOPRIGHT", bar.border.topright, "TOPLEFT");
			bar.border.top:SetHeight(12);
			bar.border.top:SetTexCoord(1/3, 2/3, 0, 1/3);
			bar.border.bottom = bar:CreateTexture(nil, "OVERLAY");
			bar.border.bottom:SetTexture(nil);
			bar.border.bottom:SetPoint("BOTTOMLEFT", bar.border.bottomleft, "BOTTOMRIGHT");
			bar.border.bottom:SetPoint("BOTTOMRIGHT", bar.border.bottomright, "BOTTOMLEFT");
			bar.border.bottom:SetHeight(12);
			bar.border.bottom:SetTexCoord(1/3, 2/3, 2/3, 1);
			bar.border.left = bar:CreateTexture(nil, "OVERLAY");
			bar.border.left:SetTexture(nil);
			bar.border.left:SetPoint("TOPLEFT", bar.border.topleft, "BOTTOMLEFT");
			bar.border.left:SetPoint("BOTTOMLEFT", bar.border.bottomleft, "TOPLEFT");
			bar.border.left:SetWidth(12);
			bar.border.left:SetTexCoord(0, 1/3, 1/3, 2/3);
			bar.border.right = bar:CreateTexture(nil, "OVERLAY");
			bar.border.right:SetTexture(nil);
			bar.border.right:SetPoint("TOPRIGHT", bar.border.topright, "BOTTOMRIGHT");
			bar.border.right:SetPoint("BOTTOMRIGHT", bar.border.bottomright, "TOPRIGHT");
			bar.border.right:SetWidth(12);
			bar.border.right:SetTexCoord(2/3, 1, 1/3, 2/3); ]]
			
			bar.hasItem = 1;
			
            bar.icon = bar:CreateTexture(nil, "BACKGROUND")
            bar.icon:SetSize(33,33)
            bar.icon:ClearAllPoints()
            bar.icon:SetPoint("RIGHT", bar, "LEFT", -7,0)
            bar.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			S.CreateShadow(bar, bar.icon)
--[[             bar.iborder = {};
            bar.iborder.topleft = bar:CreateTexture(nil, "OVERLAY");
            bar.iborder.topleft:SetTexture(nil);
            bar.iborder.topleft:SetPoint("TOPLEFT", bar.icon, "TOPLEFT", -4, 4);
            bar.iborder.topleft:SetWidth(12);
            bar.iborder.topleft:SetHeight(12);
            bar.iborder.topleft:SetTexCoord(0, 1/3, 0, 1/3);
            bar.iborder.bottomleft = bar:CreateTexture(nil, "OVERLAY");
            bar.iborder.bottomleft:SetTexture(nil);
            bar.iborder.bottomleft:SetPoint("BOTTOMLEFT", bar.icon, "BOTTOMLEFT",-4, -4);
            bar.iborder.bottomleft:SetWidth(12);
            bar.iborder.bottomleft:SetHeight(12);
            bar.iborder.bottomleft:SetTexCoord(0, 1/3, 2/3, 1);
            bar.iborder.topright = bar:CreateTexture(nil, "OVERLAY");
            bar.iborder.topright:SetTexture(nil);
            bar.iborder.topright:SetPoint("TOPRIGHT",bar.icon, "TOPRIGHT", 4, 4);
            bar.iborder.topright:SetWidth(12);
            bar.iborder.topright:SetHeight(12);
            bar.iborder.topright:SetTexCoord(2/3, 1, 0, 1/3);
            bar.iborder.bottomright = bar:CreateTexture(nil, "OVERLAY");
            bar.iborder.bottomright:SetTexture(nil);
            bar.iborder.bottomright:SetPoint("BOTTOMRIGHT", bar.icon, "BOTTOMRIGHT", 4, -4);
            bar.iborder.bottomright:SetWidth(12);
            bar.iborder.bottomright:SetHeight(12);
            bar.iborder.bottomright:SetTexCoord(2/3, 1, 2/3, 1);
            bar.iborder.top = bar:CreateTexture(nil, "OVERLAY");
            bar.iborder.top:SetTexture(nil);
            bar.iborder.top:SetPoint("TOPLEFT", bar.iborder.topleft, "TOPRIGHT");
            bar.iborder.top:SetPoint("TOPRIGHT", bar.iborder.topright, "TOPLEFT");
            bar.iborder.top:SetHeight(12);
            bar.iborder.top:SetTexCoord(1/3, 2/3, 0, 1/3);
            bar.iborder.bottom = bar:CreateTexture(nil, "OVERLAY");
            bar.iborder.bottom:SetTexture(nil);
            bar.iborder.bottom:SetPoint("BOTTOMLEFT", bar.iborder.bottomleft, "BOTTOMRIGHT");
            bar.iborder.bottom:SetPoint("BOTTOMRIGHT", bar.iborder.bottomright, "BOTTOMLEFT");
            bar.iborder.bottom:SetHeight(12);
            bar.iborder.bottom:SetTexCoord(1/3, 2/3, 2/3, 1);
            bar.iborder.left = bar:CreateTexture(nil, "OVERLAY");
            bar.iborder.left:SetTexture(nil);
            bar.iborder.left:SetPoint("TOPLEFT", bar.iborder.topleft, "BOTTOMLEFT");
            bar.iborder.left:SetPoint("BOTTOMLEFT", bar.iborder.bottomleft, "TOPLEFT");
            bar.iborder.left:SetWidth(12);
            bar.iborder.left:SetTexCoord(0, 1/3, 1/3, 2/3);
            bar.iborder.right = bar:CreateTexture(nil, "OVERLAY");
            bar.iborder.right:SetTexture(nil);
            bar.iborder.right:SetPoint("TOPRIGHT", bar.iborder.topright, "BOTTOMRIGHT");
            bar.iborder.right:SetPoint("BOTTOMRIGHT", bar.iborder.bottomright, "TOPRIGHT");
            bar.iborder.right:SetWidth(12);
            bar.iborder.right:SetTexCoord(2/3, 1, 1/3, 2/3);   ]]
			
			tinsert(grouplootbars, bar);
		end

		texture, name, count, quality, bindOnPickUp, Needable, Greedable, Disenchantable = GetLootRollItemInfo(value.rollId);
		color = ITEM_QUALITY_COLORS[quality];
		if Disenchantable then bar.disenchant:Enable() else bar.disenchant:Disable() end
		if Needable then bar.need:Enable() else bar.need:Disable() end
		if Greedable then bar.greed:Enable() else bar.greed:Disable() end
			SetDesaturation(bar.disenchant:GetNormalTexture(), not Disenchantable)
			SetDesaturation(bar.need:GetNormalTexture(), not Needable)
			SetDesaturation(bar.greed:GetNormalTexture(), not Greedable)

--[[ 		if ( bindOnPickUp ) then
			bar.border.topleft:SetVertexColor(194/255, 172/255, 114/255, 1);
			bar.border.bottomleft:SetVertexColor(194/255, 172/255, 114/255, 1);
			bar.border.topright:SetVertexColor(194/255, 172/255, 114/255, 1);
			bar.border.bottomright:SetVertexColor(194/255, 172/255, 114/255, 1);
			bar.border.top:SetVertexColor(194/255, 172/255, 114/255, 1);
			bar.border.bottom:SetVertexColor(194/255, 172/255, 114/255, 1);
			bar.border.left:SetVertexColor(194/255, 172/255, 114/255, 1);
			bar.border.right:SetVertexColor(194/255, 172/255, 114/255, 1);
			
            bar.iborder.topleft:SetVertexColor(194/255, 172/255, 114/255, 1);
            bar.iborder.bottomleft:SetVertexColor(194/255, 172/255, 114/255, 1);
            bar.iborder.topright:SetVertexColor(194/255, 172/255, 114/255, 1);
            bar.iborder.bottomright:SetVertexColor(194/255, 172/255, 114/255, 1);
            bar.iborder.top:SetVertexColor(194/255, 172/255, 114/255, 1);
            bar.iborder.bottom:SetVertexColor(194/255, 172/255, 114/255, 1);
            bar.iborder.left:SetVertexColor(194/255, 172/255, 114/255, 1);
            bar.iborder.right:SetVertexColor(194/255, 172/255, 114/255, 1);
		else
			bar.border.topleft:SetVertexColor(0.25, 0.25, 0.25, 1);
			bar.border.bottomleft:SetVertexColor(0.25, 0.25, 0.25, 1);
			bar.border.topright:SetVertexColor(0.25, 0.25, 0.25, 1);
			bar.border.bottomright:SetVertexColor(0.25, 0.25, 0.25, 1);
			bar.border.top:SetVertexColor(0.25, 0.25, 0.25, 1);
			bar.border.bottom:SetVertexColor(0.25, 0.25, 0.25, 1);
			bar.border.left:SetVertexColor(0.25, 0.25, 0.25, 1);
			bar.border.right:SetVertexColor(0.25, 0.25, 0.25, 1);
			
            bar.iborder.topleft:SetVertexColor(0.25, 0.25, 0.25, 1);
            bar.iborder.bottomleft:SetVertexColor(0.25, 0.25, 0.25, 1);
            bar.iborder.topright:SetVertexColor(0.25, 0.25, 0.25, 1);
            bar.iborder.bottomright:SetVertexColor(0.25, 0.25, 0.25, 1);
            bar.iborder.top:SetVertexColor(0.25, 0.25, 0.25, 1);
            bar.iborder.bottom:SetVertexColor(0.25, 0.25, 0.25, 1);
            bar.iborder.left:SetVertexColor(0.25, 0.25, 0.25, 1);
            bar.iborder.right:SetVertexColor(0.25, 0.25, 0.25, 1);
		end ]]
			
		bar:SetStatusBarColor(color.r, color.g, color.b, 1);
		bar:SetMinMaxValues(0, value.rollTime);
		local spar =  bar:CreateTexture(nil, "OVERLAY")
		spar:SetTexture[[Interface\CastingBar\UI-CastingBar-Spark]]
		spar:SetBlendMode("ADD")
		spar:SetAlpha(.8)
		spar:SetPoint("TOPLEFT", bar:GetStatusBarTexture(), "TOPRIGHT", -10, 13)
		spar:SetPoint("BOTTOMRIGHT", bar:GetStatusBarTexture(), "BOTTOMRIGHT", 10, -13)
		
		bar.passtext:SetText(grouplootrolls[value.rollId] and grouplootrolls[value.rollId]["pass"] and grouplootrolls[value.rollId]["pass"].count or "");
		bar.disenchanttext:SetText(grouplootrolls[value.rollId] and grouplootrolls[value.rollId]["disenchant"] and grouplootrolls[value.rollId]["disenchant"].count or "");
		bar.greedtext:SetText(grouplootrolls[value.rollId] and grouplootrolls[value.rollId]["greed"] and grouplootrolls[value.rollId]["greed"].count or "");
		bar.needtext:SetText(grouplootrolls[value.rollId] and grouplootrolls[value.rollId]["need"] and grouplootrolls[value.rollId]["need"].count or "");
		bar.text:SetText(count > 1 and name.." x"..count or name);
        bar.icon:SetTexture(texture) 

		bar.rollId = value.rollId;
		bar.rollLink = GetLootRollItemLink(value.rollId);
		
		bar:Show();
	end
end

------> Suppressing detailed loot spamm
-- FFFFFFFFFUUUCKK GODDAMN LOCALIZATION CRAP
if not (GetLocale=="enGB" or GetLocale=="enUS") then
	LOOT_ROLL_ALL_PASSED = "Everyone passed on: %s";
	LOOT_ROLL_DISENCHANT = "%s has selected Disenchant for: %s";
	LOOT_ROLL_DISENCHANT_SELF = "You have selected Disenchant for: %s";
	LOOT_ROLL_GREED = "%s has selected Greed for: %s";
	LOOT_ROLL_GREED_SELF = "You have selected Greed for: %s";
	LOOT_ROLL_NEED = "%s has selected Need for: %s";
	LOOT_ROLL_NEED_SELF = "You have selected Need for: %s";
	LOOT_ROLL_PASSED = "%s passed on: %s";
	LOOT_ROLL_PASSED_AUTO = "%s automatically passed on: %s because he cannot loot that item.";
	LOOT_ROLL_PASSED_AUTO_FEMALE = "%s automatically passed on: %s because she cannot loot that item.";
	LOOT_ROLL_PASSED_SELF = "You passed on: %s";
	LOOT_ROLL_PASSED_SELF_AUTO = "You automatically passed on: %s because you cannot loot that item.";
	LOOT_ROLL_ROLLED_DE = "Disenchant Roll - %d for %s by %s";
	LOOT_ROLL_ROLLED_GREED = "Greed Roll - %d for %s by %s";
	LOOT_ROLL_ROLLED_NEED = "Need Roll - %d for %s by %s";
end
if cfg.suppress_loot_spam then
	ChatFrame_AddMessageEventFilter("CHAT_MSG_LOOT", function(self, event, msg)
		if msg:match("(.*) has?v?e? selected (.+) for: (.+)") or msg:match("(.+) Roll . (%d+) for (.+) by (.+)")
			or msg:match("You passed on: ") or msg:match(" automatically passed on: ") or (msg:match(" passed on: ") and not msg:match("Everyone passed on: ")) then
			return true
--[[ 			
		elseif msg:match("%s won: %s") then
			return false, gsub(msg, "%s won: %s", "%1$s won: %3$s |cff818181(Need - %2$d)|r" or "%1$s won: %3$s |cff818181(Greed - %2$d)|r") ]]
		end
	end)
end

--[[ 
LOOT_ROLL_WON 
"%s won: %s"
LOOT_ROLL_WON_NO_SPAM_GREED 
"%1$s won: %3$s |cff818181(Greed - %2$d)|r"
LOOT_ROLL_WON_NO_SPAM_NEED 
"%1$s won: %3$s |cff818181(Need - %2$d)|r"
LOOT_ROLL_YOU_WON 
"You won: %s"
LOOT_ROLL_YOU_WON_NO_SPAM_GREED 
"You won: %2$s |cff818181(Greed - %1$d)|r"
LOOT_ROLL_YOU_WON_NO_SPAM_NEED 
"You won: %2$s |cff818181(Need - %1$d)|r" 

%f -> (%d+%.?%d*)
]]