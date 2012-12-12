local S, C, L, DB = unpack(select(2, ...))
local _
----------------------------------------------------------------------------------------
--	PvP/PvE tabs on own frame(SocialTabs by Califpornia)
----------------------------------------------------------------------------------------
local hookAtLoad = {"PVEFrame", "RaidBrowserFrame", "PVPFrame"}
local SocialTabs = CreateFrame("Frame")
local TabRefArray = {}
local VisibleFrames = {}

local function HideOtherFrames(fname)
	if IsControlKeyDown() then return end
	for k, v in pairs(VisibleFrames) do
		if k ~= fname and v then
			HideUIPanel(_G[k])
		end
	end
end

local function SetTabCheckedState(fname, isChecked)
	for k, v in pairs(TabRefArray) do
		if v then TabRefArray[k][fname]:SetChecked(isChecked) end
	end
end

local function SetTabEnabledState(fname, isEnabled)
	for k, v in pairs(TabRefArray) do
		if v then
			if isEnabled then
				TabRefArray[k][fname]:Enable()
				SetDesaturation(TabRefArray[k][fname]:GetNormalTexture(), false)
				TabRefArray[k][fname]:SetAlpha(1)
			else
				TabRefArray[k][fname]:Disable()
				TabRefArray[k][fname]:SetAlpha(0.5)
				SetDesaturation(TabRefArray[k][fname]:GetNormalTexture(), true)
			end
		end
	end
end

local function SetTabVisibleState(fname, isVisible)
	for k, v in pairs(TabRefArray) do
		if v then
			if isVisible then
				TabRefArray[k][fname]:Show()
			else
				TabRefArray[k][fname]:Hide()
			end
		end
	end
end

local function Tab_OnClick(self)
	local frame = _G[self.ToggleFrame]
	if frame:IsShown() then
		HideUIPanel(frame)
	else
		if self.ToggleFrame == "PVEFrame" then
			ToggleLFDParentFrame()
		else
			ShowUIPanel(frame)
		end
	end
end

local function SkinTab(f, t)
	f:Show()
	f:StripTextures()
	f:SetNormalTexture(t)
	f:GetNormalTexture():SetTexCoord(0.1, 0.9, 0.1, 0.9)
	f:SetCheckedTexture("Interface\\AddOns\\SunUI\\media\\CheckButtonHilight")
	S.CreateBG(f)
	S.CreateSD(f, 5, 0, 0, 0, 1, 1)
	f:GetHighlightTexture():SetTexture(1, 1, 1, 0.3)
	f:GetHighlightTexture():SetAllPoints(f:GetNormalTexture())
end

local function STHookFrame(fname)
	local frame = _G[fname]
	local prevtab
	local frametabs = {}

	-- PvE tab
	frametabs["PVEFrame"] = CreateFrame("CheckButton", "LFDSideTab", frame, "SpellBookSkillLineTabTemplate")
	SkinTab(frametabs["PVEFrame"], "Interface\\Icons\\INV_Helmet_08")
	frametabs["PVEFrame"]:SetPoint("TOPLEFT", frame, "TOPRIGHT", 11, -35)
	frametabs["PVEFrame"].tooltip = LOOKING_FOR_DUNGEON
	frametabs["PVEFrame"].ToggleFrame = "PVEFrame"
	frametabs["PVEFrame"]:SetScript("OnClick", Tab_OnClick)
	prevtab = frametabs["PVEFrame"]

	-- Raid Browser tab
	frametabs["RaidBrowserFrame"] = CreateFrame("CheckButton", "LFRSideTab", frame, "SpellBookSkillLineTabTemplate")
	SkinTab(frametabs["RaidBrowserFrame"], "Interface\\LFGFrame\\UI-LFR-PORTRAIT")
	frametabs["RaidBrowserFrame"]:SetPoint("TOPLEFT", prevtab, "BOTTOMLEFT", 0, -15)
	frametabs["RaidBrowserFrame"].tooltip = LOOKING_FOR_RAID
	frametabs["RaidBrowserFrame"].ToggleFrame = "RaidBrowserFrame"
	frametabs["RaidBrowserFrame"]:SetScript("OnClick", Tab_OnClick)
	prevtab = frametabs["RaidBrowserFrame"]

	-- PVP tab
	frametabs["PVPFrame"] = CreateFrame("CheckButton", "PVPSideTab", frame, "SpellBookSkillLineTabTemplate")
	SkinTab(frametabs["PVPFrame"], "Interface\\BattlefieldFrame\\UI-Battlefield-Icon")
	frametabs["PVPFrame"]:SetPoint("TOPLEFT", prevtab, "BOTTOMLEFT", 0, -15)
	frametabs["PVPFrame"].tooltip = PLAYER_V_PLAYER
	frametabs["PVPFrame"].ToggleFrame = "PVPFrame"
	frametabs["PVPFrame"]:SetScript("OnClick", Tab_OnClick)
	prevtab = frametabs["PVPFrame"]

	if fname == "RaidBrowserFrame" then
		LFRParentFrameSideTab1:SetPoint("TOPLEFT", frametabs["PVPFrame"], "BOTTOMLEFT", 0, -15)
	end

	TabRefArray[fname] = frametabs

	frame:HookScript("OnShow", function()
		HideOtherFrames(fname)
		VisibleFrames[fname] = true
		SetTabCheckedState(fname, true)
	end)

	frame:HookScript("OnHide", function()
		VisibleFrames[fname] = false
		SetTabCheckedState(fname, false)
	end)
end

local function InitSocialTabs()
	for i = 1, #hookAtLoad do
		STHookFrame(hookAtLoad[i])
	end
end

SocialTabs:SetScript("OnEvent", function(self, event, addon)
	if event == "ADDON_LOADED" and addon == "SunUI" then
		InitSocialTabs()
	end
end)
SocialTabs:RegisterEvent("ADDON_LOADED")