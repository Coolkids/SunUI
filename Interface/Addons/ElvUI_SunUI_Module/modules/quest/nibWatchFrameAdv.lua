-- Author: Nibelheim
-- Notes: Adjust Position, Colors and Auto-hide the Quest Watch Frame
-- Version: 1.2

local E, L, V, P, G = unpack(ElvUI) --Import: Engine, Locales, ProfileDB, local
local nWFA = CreateFrame("Frame")
local EventsRegistered
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
	if Hide then
		nWFA.hidden = true
		ObjectiveTrackerFrame.realUIHidden = true
		ObjectiveTrackerFrame:Hide()
	else
		local oldHidden = nWFA.hidden
		nWFA.hidden = false
		ObjectiveTrackerFrame.realUIHidden = false
		ObjectiveTrackerFrame:Show()
	end
end

-- Collapse Quest Tracker based on zone
function nWFA.UpdateCollapseState()
	if not Opts.hidden.enabled then return end
	
	local Inst, InstType = GetInstanceInfo();
	local isInGarrison = Inst:find("Garrison")
	local Collapsed = false;
	if Inst then
		if (InstType == "pvp" and Opts.hidden.collapse.pvp) then			-- Battlegrounds
			Collapsed = true;
		elseif (InstType == "arena" and Opts.hidden.collapse.arena) then	-- Arena
			Collapsed = true;
		elseif (((InstType == "party" and not isInGarrison) or (InstType == "scenario")) and Opts.hidden.collapse.party) then	-- 5 Man Dungeons
			Collapsed = true;
		elseif (InstType == "raid" and Opts.hidden.collapse.raid) then	-- Raid Dungeons
			Collapsed = true;
		end
	end
	
	if Collapsed then
		nWFA.userCollapsed = true;
		ObjectiveTrackerFrame.userCollapsed = true
		ObjectiveTracker_Collapse()
	else
		nWFA.userCollapsed = false;
		ObjectiveTrackerFrame.userCollapsed = false
		ObjectiveTracker_Expand()
	end	
end

function nWFA.PLAYER_ENTERING_WORLD()
	nWFA.UpdateCollapseState()
	nWFA.UpdateHideState()
end

local function EventHandler(self, event)
	if event == "PLAYER_LOGIN" then
		local A = E:GetModule("Skins-SunUI")
		A:Reskin(WatchFrameCollapseExpandButton)
	elseif event == "PLAYER_ENTERING_WORLD" then
		nWFA.PLAYER_ENTERING_WORLD()
	end
end
nWFA:RegisterEvent("PLAYER_LOGIN")
nWFA:RegisterEvent("PLAYER_ENTERING_WORLD")
nWFA:SetScript("OnEvent", EventHandler)

--[[
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

]]