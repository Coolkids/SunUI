-- This module is existed in Examiner in 2009 and 2010, but was there after removed.
-- The reason was that I had hoped Blizzard would implement the feature into WoW nativly, but that didn't happen.
-- Now I've included this module again with Examiner, in hopes that someone would mold it into a working state with the new MoP expansion.
-- Module is disabled by default, and probably wouldn't work even if enabled.

local ex = Examiner;
local gtt = GameTooltip;

-- Modules
local mod = ex:CreateModule("Glyphs");
mod:CreatePage(false,GLYPHS);
mod:CreateButton(GLYPHS,GLYPHS,"Only shown for people with Examiner");
mod.canCache = true;

-- Variables
local BUTTON_HEIGHT = 40;
local NUM_GLYPHS = GetNumGlyphSockets();
local addonPrefix = "ExaminerGlyphs";
local replyToken = "glyphData";
local iconBase = "Interface\\Spellbook\\UI-Glyph-Rune-";
local cfg, cache;

-- Data Tables
local glyphBtns = {};
local glyphData = {};
local sendData = {};

-- Glyph Type Colors
local GLYPH_COLORS = {
--	[1] = { 1, 0.25, 0 },
--	[2] = { 0, 0.25, 1 },
	[1] = { 1, 1, 0 },
	[2] = { 0, 0.75, 1 },
};

-- Options
ex.options[#ex.options + 1] = { var = "inspectGlyphs", default = true, label = "Enable Glyph Inspection", tip = "Allows Examiner to send and receive glyph data over the addon whisper channel" };

--------------------------------------------------------------------------------------------------------
--                                          Button Functions                                          --
--------------------------------------------------------------------------------------------------------

-- OnInitialize
function mod:OnInitialize()
	cfg = Examiner_Config;
	cache = Examiner_Cache;
end

-- OnConfigChanged
function mod:OnConfigChanged(var,value)
	if (var == "inspectGlyphs") then
		if (value) then
			self.page:RegisterEvent("CHAT_MSG_ADDON");
		else
			self.page:UnregisterEvent("CHAT_MSG_ADDON");
		end
	end
end

-- OnInspect
function mod:OnInspect(unit)
	-- can only send addon message to our own faction
	if (cfg.inspectGlyphs) and (ex.unitType == 3) and (UnitIsConnected(unit)) then
		local name, realm = UnitName(unit);
		if (realm and realm ~= "") then
			name = name.."-"..realm:gsub(" ","");
		end
		SendAddonMessage(addonPrefix,"request","WHISPER",name);
		self.button:Enable();
	else
		self.page:Hide();
		self.button:Disable();
	end
end

-- OnClearInspect
function mod:OnClearInspect()
	for i = 1, NUM_GLYPHS do
		wipe(glyphData[i]);
		glyphBtns[i]:Hide();
	end
end

-- OnCacheLoaded
function mod:OnCacheLoaded(entry,unit)
	if (entry.Glyphs) then
		glyphData = CopyTable(entry.Glyphs);
		self:UpdateGlyphs();
		self.button:Enable();
	elseif (not unit) then
		self.page:Hide();
		self.button:Disable();
	end
end

--------------------------------------------------------------------------------------------------------
--                                               Events                                               --
--------------------------------------------------------------------------------------------------------

-- Chat Message Addon
function mod.page:CHAT_MSG_ADDON(event,prefix,msg,type,sender)
	if (prefix == addonPrefix) then
		-- request
		if (msg == "request") then
			sendData[#sendData + 1] = replyToken;
			local spec = GetActiveTalentGroup();
			for i = 1, NUM_GLYPHS do
				sendData[#sendData + 1] = "@";
				local enabled, type, spellId, icon = GetGlyphSocketInfo(i,spec);
				if (enabled and spellId) then
					sendData[#sendData + 1] = type;
					sendData[#sendData + 1] = ",";
					sendData[#sendData + 1] = spellId;
					sendData[#sendData + 1] = ",";
					sendData[#sendData + 1] = icon:match("%d+$");
				end
			end
			SendAddonMessage(addonPrefix,table.concat(sendData),"WHISPER",sender);
			wipe(sendData);
		-- reply
		elseif (msg:sub(1,#replyToken) == replyToken) then
			local index = 1;
			for type, spellId, iconId in msg:gmatch("@(%d),(%d+),(%d+)") do
				glyphData[index].type = tonumber(type);
				glyphData[index].spellId = tonumber(spellId);
				glyphData[index].iconId = tonumber(iconId);
				index = (index + 1);
			end
			mod:UpdateGlyphs();
			-- cache -- az: not happy with this
			if (mod:CanCache()) then
				local entry = cache[ex:GetEntryName()];
				if (entry) and (time() - entry.time <= 8) then
					entry.Glyphs = CopyTable(glyphData);
				end
			end
		end
	end
end

--------------------------------------------------------------------------------------------------------
--                                                Code                                                --
--------------------------------------------------------------------------------------------------------

-- Sort Glyphs
local function SortGlyphsFunc(a,b)
	if (not a.spellId or not b.spellId) then
		return a.spellId ~= nil;
	elseif (a.type == b.type) then
		return GetSpellInfo(a.spellId) < GetSpellInfo(b.spellId);
	else
		return a.type < b.type;
	end
end

-- Update Glyphs
function mod:UpdateGlyphs()
	sort(glyphData,SortGlyphsFunc);
	for i = 1, NUM_GLYPHS do
		local data = glyphData[i];
		local btn = glyphBtns[i];
		if (data.spellId) then
			btn.icon:SetTexture(iconBase..data.iconId);
			btn.icon:SetVertexColor(unpack(GLYPH_COLORS[data.type]));
			btn.text:SetFormattedText("%s\n|cffc0c0c0%s (%d)",GetSpellInfo(data.spellId),(data.type == 1 and MAJOR_GLYPH or MINOR_GLYPH),data.spellId);
			btn.text:SetTextColor(unpack(GLYPH_COLORS[data.type]));
			btn.data = data;
			btn:Show();
		else
			btn:Hide();
		end
	end
end

--------------------------------------------------------------------------------------------------------
--                                           Widget Creation                                          --
--------------------------------------------------------------------------------------------------------

-- OnEnter
local function OnEnter(self)
	GameTooltip:SetOwner(self,"ANCHOR_RIGHT");
	GameTooltip:SetHyperlink("spell:"..self.data.spellId);
	local tip = GameTooltipTextLeft2:GetText();
	GameTooltipTextLeft2:SetFormattedText("|cff66baff%s|r\n%s",(self.data.type == 1 and MAJOR_GLYPH or MINOR_GLYPH),tip);
	GameTooltip:Show();
end

-- OnClick
local function OnClick(self,button)
	if (IsShiftKeyDown()) and (ChatEdit_GetActiveWindow():IsShown()) then
		ChatEdit_GetActiveWindow():Insert(GetSpellLink(self.data.spellId));
	end
end

-- Create Glyph Buttons
for i = 1, NUM_GLYPHS do
	local btn = CreateFrame("Button",nil,mod.page);
	btn:SetWidth(200);
	btn:SetHeight(BUTTON_HEIGHT);
	btn:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight");
	btn:SetScript("OnClick",OnClick);
	btn:SetScript("OnEnter",OnEnter);
	btn:SetScript("OnLeave",ex.HideGTT);
	btn:Hide();

	if (i == 1) then
		btn:SetPoint("TOPLEFT",8,-40);
	else
		btn:SetPoint("TOP",glyphBtns[i - 1],"BOTTOM",0,0);
	end

	btn.icon = btn:CreateTexture(nil,"ARTWORK");
	btn.icon:SetWidth(BUTTON_HEIGHT - 2);
	btn.icon:SetHeight(BUTTON_HEIGHT - 2);
	btn.icon:SetPoint("LEFT",2,0);

	btn.bg = btn:CreateTexture(nil,"BACKGROUND");
	btn.bg:SetPoint("TOPLEFT",btn.icon);
	btn.bg:SetPoint("BOTTOMRIGHT",btn.icon);
	btn.bg:SetTexture("Interface\\Buttons\\WHITE8X8");
	btn.bg:SetVertexColor(1,1,1,0.5);

	btn.text = btn:CreateFontString(nil,"ARTWORK","GameFontHighlight");
	btn.text:SetPoint("LEFT",btn.icon,"RIGHT",4,0);
	btn.text:SetJustifyH("LEFT");

	glyphData[i] = {};
	glyphBtns[i] = btn;
end