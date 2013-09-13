-- Author: Nibelheim
-- Notes: Adjust Position, Colors and Auto-hide the Quest Watch Frame
-- Version: 1.2
local S, L, DB, _, C = unpack(select(2, ...))
local SunUIConfig = LibStub("AceAddon-3.0"):GetAddon("SunUI"):GetModule("SunUIConfig")
local nWFA = CreateFrame("Frame")
local EventsRegistered
local _G = _G
local WF;
local OrigWFSetPoint, OrigWFClearAllPoints;
local origWFHighlight;
local WFColorsHooked = true;
local Opts = {
	-- Font
	font = {
		outline = true,
		size = 13,
	},

	-- Hide Collapse/Expand Buttahn
	hidecollapsebutton = false,

	-- Text Colors
	colors = {
		enabled = true,	-- Enable Text Color modifications
		title = {r = 1, g = 1, b = 0},	-- Watch Frame Title
		lines = {
			-- Lines in their normal state
			normal = {
				header = {r = 171/255, g = 243/255, b = 50/255},
				objectives = {r = 0.7, g = 0.7, b = 0.7},
			},
			-- Lines when you mouse-over them
			highlight = {
				header = {r = 0, g = 0.85, b = 0.99},
				objectives = {r = 1, g = 1, b = 1},
			},
		},
	},

	-- Auto-Hide
	hidden = {
		enabled = true,		-- Enable Auto-Hiding
		-- Collapse the Watch Frame
		collapse = {
			pvp = true,
			arena = false,
			party = true,
			raid = true,
		},
		-- Hide the Watch Frame completely
		hide = {
			pvp = false,
			arena = true,
			party = false,
			raid = false,
		},
	},
}
-- Hide Quest Tracker based on zone
function nWFA.UpdateHideState()
	if not WF then WF = _G["WatchFrame"]; end
	
	local Inst, InstType = IsInInstance();
	local Hide = false;
	if Opts.hidden.enabled and Inst then
		if (InstType == "pvp" and Opts.hidden.hide.pvp) then			-- Battlegrounds
			Hide = true;
		elseif (InstType == "arena" and Opts.hidden.hide.arena) then	-- Arena
			Hide = true;
		elseif (InstType == "party" and Opts.hidden.hide.party) then	-- 5 Man Dungeons
			Hide = true;
		elseif (InstType == "raid" and Opts.hidden.hide.raid) then	-- Raid Dungeons
			Hide = true;
		end
	end
	if Hide then WF:Hide() else WF:Show() end
end

-- Collapse Quest Tracker based on zone
function nWFA.UpdateCollapseState()
	if not WF then WF = _G["WatchFrame"]; end
	if not Opts.hidden.enabled then return end
	
	local Inst, InstType = IsInInstance();
	local Collapsed = false;
	if Inst then
		if (InstType == "pvp" and Opts.hidden.collapse.pvp) then			-- Battlegrounds
			Collapsed = true;
		elseif (InstType == "arena" and Opts.hidden.collapse.arena) then	-- Arena
			Collapsed = true;
		elseif (InstType == "party" and Opts.hidden.collapse.party) then	-- 5 Man Dungeons
			Collapsed = true;
		elseif (InstType == "raid" and Opts.hidden.collapse.raid) then	-- Raid Dungeons
			Collapsed = true;
		end
	end
	
	if Collapsed then
		WF.userCollapsed = true;
		WatchFrame_Collapse(WF);
	else
		WF.userCollapsed = false;
		WatchFrame_Expand(WF);
	end	
end

-- Udate WatchFrame styling
function nWFA.UpdateStyle()
	local WFT = _G["WatchFrameTitle"];
	
	-- Header
	if Opts.colors.enabled then
		if not WFColorsHooked then nWFA.HookWFColors(); end
		if WFT then	
			WFT:SetTextColor(Opts.colors.title.r, Opts.colors.title.g, Opts.colors.title.b);
		end
	end
	
	-- Update all lines
	for i = 1, #WATCHFRAME_LINKBUTTONS do
		WatchFrameLinkButtonTemplate_Highlight(WATCHFRAME_LINKBUTTONS[i], false);
	end
	
	-- Button
	if Opts.hidecollapsebutton then
		WatchFrameCollapseExpandButton:Hide()
		WatchFrameCollapseExpandButton.Show = function() end
	end
end

-- Font Updates
function nWFA.HookFont()
	local WFT = _G["WatchFrameTitle"]
	
	local Flag
	if Opts.font.outline then
	Flag = "THINOUTLINE" 
	shadowoffset = {x = 0, y = 0}
	else 
	Flag = "None" 
	shadowoffset = {x = 1, y = -1}
	end
	
	WFT:SetFont(GameFontNormalSmall:GetFont(), Opts.font.size, Flag)
	WFT:SetShadowOffset(shadowoffset.x, shadowoffset.y)
	
	hooksecurefunc("WatchFrame_SetLine", function(line, anchor, verticalOffset, isHeader, text, dash, hasItem, isComplete)
		line.text:SetFont(GameFontNormalSmall:GetFont(), Opts.font.size, Flag)
		line.text:SetShadowOffset(shadowoffset.x, shadowoffset.y)
		if line.dash then
			line.dash:SetFont(GameFontNormalSmall:GetFont(), Opts.font.size, Flag)
			line.dash:SetShadowOffset(shadowoffset.x, shadowoffset.y)
		end
	end)
end

-- Hook into / replace WatchFrame functions for Colors
function nWFA.HookWFColors()
	-- Colors
	if Opts.colors.enabled then
		local lc = {
			n = {h = Opts.colors.lines.normal.header, o = Opts.colors.lines.normal.objectives},
			h = {h = Opts.colors.lines.highlight.header, o = Opts.colors.lines.highlight.objectives},
		};
		
		-- Hook into SetLine to change color of lines	
		hooksecurefunc("WatchFrame_SetLine", function(line, anchor, verticalOffset, isHeader, text, dash, hasItem, isComplete)
			if isHeader then 
				line.text:SetTextColor(lc.n.h.r, lc.n.h.g, lc.n.h.b);
			else
				line.text:SetTextColor(lc.n.o.r, lc.n.o.g, lc.n.o.b);
			end
		end)
		
		-- Replace Highlight function
		WatchFrameLinkButtonTemplate_Highlight = function(self, onEnter)
			local line;
			for index = self.startLine, self.lastLine do
				line = self.lines[index];
				if line then
					if index == self.startLine then
						-- header
						if onEnter then
							line.text:SetTextColor(lc.h.h.r, lc.h.h.g, lc.h.h.b);
						else
							line.text:SetTextColor(lc.n.h.r, lc.n.h.g, lc.n.h.b);
						end
					else
						if onEnter then
							line.text:SetTextColor(lc.h.o.r, lc.h.o.g, lc.h.o.b);
							line.dash:SetTextColor(lc.h.o.r, lc.h.o.g, lc.h.o.b);
						else
							line.text:SetTextColor(lc.n.o.r, lc.n.o.g, lc.n.o.b);
							line.dash:SetTextColor(lc.n.o.r, lc.n.o.g, lc.n.o.b);
						end
					end
				end
			end
		end
		WFColorsHooked = true
	end
end

----
function nWFA.PLAYER_ENTERING_WORLD()
	nWFA.UpdateCollapseState()
	nWFA.UpdateHideState()
end

function nWFA.PLAYER_LOGIN()
	nWFA.HookWFColors()
	nWFA.UpdateStyle()
	nWFA.HookFont()
end

local function EventHandler(self, event)
	if event == "PLAYER_LOGIN" then
		nWFA.PLAYER_LOGIN()
		S.Reskin(WatchFrameCollapseExpandButton)
	elseif event == "PLAYER_ENTERING_WORLD" then
		nWFA.PLAYER_ENTERING_WORLD()
	end
end
nWFA:RegisterEvent("PLAYER_LOGIN")
nWFA:RegisterEvent("PLAYER_ENTERING_WORLD")
nWFA:SetScript("OnEvent", EventHandler)


local downtex = WatchFrameCollapseExpandButton:CreateTexture(nil, "ARTWORK")
downtex:SetSize(8, 8)
downtex:SetPoint("CENTER", 1, 0)
downtex:SetVertexColor(1, 1, 1)

if WatchFrame.userCollapsed then
	downtex:SetTexture("Interface\\AddOns\\SunUI\\media\\arrow-down-active")
else
	downtex:SetTexture("Interface\\AddOns\\SunUI\\media\\arrow-up-active")
end

hooksecurefunc("WatchFrame_Collapse", function() downtex:SetTexture("Interface\\AddOns\\SunUI\\media\\arrow-down-active") end)
hooksecurefunc("WatchFrame_Expand", function() downtex:SetTexture("Interface\\AddOns\\SunUI\\media\\arrow-up-active") end)

----------------------------------------------------------------------------------------
--	Skin WatchFrame item buttons
----------------------------------------------------------------------------------------
hooksecurefunc("WatchFrameItem_UpdateCooldown", function(self)
	if not self.skinned and not InCombatLockdown() then
		local icon = _G[self:GetName().."IconTexture"]
		local border = _G[self:GetName().."NormalTexture"]
		local count = _G[self:GetName().."Count"]
		local hotkey = _G[self:GetName().."HotKey"]

		self:CreateShadow()
		icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		count:ClearAllPoints()
		count:SetPoint("BOTTOMRIGHT", 0, 2)
		border:SetTexture(nil)
		self:StyleButton(true)
		self.skinned = true
	end
end)

local quickquest = CreateFrame("CheckButton", nil, WatchFrameCollapseExpandButton)
quickquest:ClearAllPoints()
quickquest:SetSize(22,22)
quickquest:SetPoint("TOPRIGHT", WatchFrame, "TOPLEFT", -5, 0)
quickquest:SetScript("OnClick", function(self)
	if SunUIConfig.db.profile.MiniDB.AutoQuest then 
		SunUIConfig.db.profile.MiniDB.AutoQuest = false
	else
		SunUIConfig.db.profile.MiniDB.AutoQuest = true
	end
	local AAQ = LibStub("AceAddon-3.0"):GetAddon("SunUI"):GetModule("AutoAccept")
	AAQ:UpdateSet()
	self:SetChecked(SunUIConfig.db.profile.MiniDB.AutoQuest)
end)
quickquest:SetScript("OnEnter", function(self)
 	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:AddLine(L["自动交接任务"])
	GameTooltip:Show()
end)
quickquest:SetScript("OnEvent", function(self)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	self:SetChecked(SunUIConfig.db.profile.MiniDB.AutoQuest)
	-- if WatchFrameCollapseExpandButton:IsShown() then
		-- self:Show()
	-- end
end)
quickquest:SetScript("OnLeave", function() GameTooltip:Hide() end)
quickquest:SetNormalTexture("Interface\\Buttons\\UI-CheckBox-Up")
quickquest:SetPushedTexture("Interface\\Buttons\\UI-CheckBox-Down")
quickquest:SetHighlightTexture("Interface\\Buttons\\UI-CheckBox-Highlight")
quickquest:SetDisabledCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check-Disabled")
quickquest:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check")
quickquest:RegisterEvent("PLAYER_ENTERING_WORLD")
S.ReskinCheck(quickquest)
-- WatchFrameCollapseExpandButton:HookScript("OnShow", function()
	-- print("Show")
	-- quickquest:Show()
-- end)
-- WatchFrameCollapseExpandButton:HookScript("OnHide", function()
	-- print("Hide")
	-- quickquest:Hide()
-- end)