-- (c) 2011 Califpornia aka Ennie
-- Эн <Снежная Лавина> @ EU-Ясеневый лес
-- Inspired by Seerah`s KeepingTabs (http://www.wowinterface.com/downloads/info18120-KeepingTabs.html)

--Open directly to the Guild Roster tab 
local S, C, L, DB = unpack(SunUI)
--when switching to the guild frame

local Module = LibStub("AceAddon-3.0"):GetAddon("Core"):NewModule("socialtabs")
function Module:OnInitialize()

-- Always show looking for guild tab
local lfguild = false

-- Hide raid tab from social window, since it's exact copy from Raid window
local hideraid = false

-- Scale level of unified social window
local wscale = 1
------------------------

local f = CreateFrame("Frame")

local CurFrame = FriendsFrame
local TabArray = {}
local VisibleFrames = {}
local playerLevel = UnitLevel("player")

local function ToggleFrameByType(ftype)
	if (ftype == 'social') then
		ToggleFriendsFrame()
	elseif (ftype == 'guild') then
		ToggleGuildFrame()
	elseif (ftype == 'lfd') then
		ToggleLFDParentFrame()
	elseif (ftype == 'lfr') then
		ToggleRaidFrame()
	elseif (ftype == 'pvp') then
		TogglePVPFrame()
	elseif (ftype == 'lfg') then
		ToggleGuildFinder()
	end
end

local function UpdateTabCheckedState(ftype, chkd)
	for k, v in pairs(TabArray) do
		if (v) then TabArray[k][ftype]:SetChecked(chkd) end
	end
end

local function UpdateTabEnabledState(ftype, enabled)
	for k, v in pairs(TabArray) do
		if (v) then
			if enabled then
				TabArray[k][ftype]:Enable()
				SetDesaturation(TabArray[k][ftype]:GetNormalTexture(), false)
				TabArray[k][ftype]:SetAlpha(1)
			else
				TabArray[k][ftype]:Disable()
				TabArray[k][ftype]:SetAlpha(0.5)
				SetDesaturation(TabArray[k][ftype]:GetNormalTexture(), true)
			end
		end
	end
end

local function UpdateTabVisibleState(ftype, enabled)
	for k, v in pairs(TabArray) do
		if (v) then
			if enabled then
				TabArray[k][ftype]:Show()
			else
				TabArray[k][ftype]:Hide()
			end
		end
	end
end


local function CloseAllTabs()
	-- keep other frames open if CTRL modifier is pressed
	if (not IsControlKeyDown()) then
		for k, v in pairs(VisibleFrames) do
			if (v) then ToggleFrameByType(k) end
		end
	end
end

local function Tab_OnClick(self)
	CloseAllTabs()
	ToggleFrameByType(self.ToggleFrameType)
end

local function CreateTabs(fr, frtype)
	local frametabs = {}
	-- Social tab
	frametabs['social'] = CreateFrame("CheckButton", nil, fr, "SpellBookSkillLineTabTemplate")
	frametabs['social']:Show()
	frametabs['social']:SetPoint("TOPLEFT", fr, "TOPRIGHT", 8, -35)
	frametabs['social']:SetFrameStrata("LOW")
	frametabs['social'].tooltip = SOCIAL_BUTTON
	frametabs['social']:SetNormalTexture("Interface\\FriendsFrame\\Battlenet-Portrait")
	frametabs['social'].ToggleFrame = FriendsFrame
	frametabs['social'].ToggleFrameType = 'social'
	frametabs['social']:SetScript("OnClick", Tab_OnClick)
	frametabs['social']:CreateShadow("Background")
	--S.ReskinFrame(frametabs['social'])
	-- Guild tab
	frametabs['guild'] = CreateFrame("CheckButton", nil, fr, "SpellBookSkillLineTabTemplate")
	frametabs['guild']:Show()
	frametabs['guild']:SetPoint("TOPLEFT", frametabs['social'], "BOTTOMLEFT", 0, -15)
	frametabs['guild']:SetFrameStrata("LOW")
	frametabs['guild'].tooltip = GUILD
	frametabs['guild']:CreateShadow("Background")
	--S.ReskinFrame(frametabs['guild'])
	if GetGuildTabardFileNames() then
		frametabs['guild']:SetNormalTexture("Interface\\SpellBook\\GuildSpellbooktabBG")
		frametabs['guild'].TabardEmblem:Show()
		frametabs['guild'].TabardIconFrame:Show()
		SetLargeGuildTabardTextures("player", frametabs['guild'].TabardEmblem, frametabs['guild']:GetNormalTexture(), frametabs['guild'].TabardIconFrame)
	else
		frametabs['guild']:SetNormalTexture("Interface\\GuildFrame\\GuildLogo-NoLogo")
	end
	frametabs['guild'].ToggleFrame = GuildFrame
	frametabs['guild'].ToggleFrameType = 'guild'
	frametabs['guild']:SetScript("OnClick", Tab_OnClick)
	-- restricted to trial accounts
	if (IsTrialAccount() or (not IsInGuild())) then
		frametabs['guild']:SetAlpha(0.5)
		SetDesaturation(frametabs['guild']:GetNormalTexture(), true)
		frametabs['guild']:Disable()
	end



	-- LFD tab
	frametabs['lfd'] = CreateFrame("CheckButton", nil, fr, "SpellBookSkillLineTabTemplate")
	frametabs['lfd']:Show()
	frametabs['lfd']:SetPoint("TOPLEFT", frametabs['guild'], "BOTTOMLEFT", 0, -15)
	frametabs['lfd']:SetFrameStrata("LOW")
	frametabs['lfd'].tooltip = LOOKING_FOR_DUNGEON
	frametabs['lfd']:SetNormalTexture("Interface\\LFGFrame\\UI-LFG-PORTRAIT")
	frametabs['lfd'].ToggleFrame = LFDParentFrame
	frametabs['lfd'].ToggleFrameType = 'lfd'
	frametabs['lfd']:SetScript("OnClick", Tab_OnClick)
	if (playerLevel < SHOW_LFD_LEVEL) then
		frametabs['lfd']:SetAlpha(0.5)
		SetDesaturation(frametabs['lfd']:GetNormalTexture(), true)
		frametabs['lfd']:Disable()
	end
	frametabs['lfd']:CreateShadow("Background")
	--S.ReskinFrame(frametabs['lfd'])
	-- LFR tab
	frametabs['lfr'] = CreateFrame("CheckButton", nil, fr, "SpellBookSkillLineTabTemplate")
	frametabs['lfr']:Show()
	frametabs['lfr']:SetPoint("TOPLEFT", frametabs['lfd'], "BOTTOMLEFT", 0, -15)
	frametabs['lfr']:SetFrameStrata("LOW")
	frametabs['lfr'].tooltip = RAID_FINDER
	frametabs['lfr']:SetNormalTexture("Interface\\LFGFrame\\UI-LFR-PORTRAIT")
	frametabs['lfr'].ToggleFrame = RaidParentFrame
	frametabs['lfr'].ToggleFrameType = 'lfr'
	frametabs['lfr']:SetScript("OnClick", Tab_OnClick)
	frametabs['lfr']:CreateShadow("Background")
	--S.ReskinFrame(frametabs['lfr'])
	-- PVP tab
	frametabs['pvp'] = CreateFrame("CheckButton", nil, fr, "SpellBookSkillLineTabTemplate")
	frametabs['pvp']:Show()
	frametabs['pvp']:SetPoint("TOPLEFT", frametabs['lfr'], "BOTTOMLEFT", 0, -15)
	frametabs['pvp']:SetFrameStrata("LOW")
	frametabs['pvp'].tooltip = PLAYER_V_PLAYER
	frametabs['pvp']:SetNormalTexture("Interface\\BattlefieldFrame\\UI-Battlefield-Icon")
	frametabs['pvp'].ToggleFrame = PvpFrame
	frametabs['pvp'].ToggleFrameType = 'pvp'
	frametabs['pvp']:SetScript("OnClick", Tab_OnClick)
	if (playerLevel < SHOW_PVP_LEVEL) then
		frametabs['pvp']:SetAlpha(0.5)
		SetDesaturation(frametabs['pvp']:GetNormalTexture(), true)
		frametabs['pvp']:Disable()
	end
	frametabs['pvp']:CreateShadow("Background")
	--S.ReskinFrame(frametabs['pvp'])
	-- LFG tab
	frametabs['lfg'] = CreateFrame("CheckButton", nil, fr, "SpellBookSkillLineTabTemplate")
	frametabs['lfg']:Show()
	frametabs['lfg']:SetPoint("TOPLEFT", frametabs['pvp'], "BOTTOMLEFT", 0, -15)
	frametabs['lfg']:SetFrameStrata("LOW")
	frametabs['lfg'].tooltip = LOOKINGFORGUILD
	frametabs['lfg']:SetNormalTexture("Interface\\GuildFrame\\GuildLogo-NoLogo.blp")
	frametabs['lfg'].ToggleFrame = 'lfg'
	frametabs['lfg'].ToggleFrameType = 'lfg'
	frametabs['lfg']:SetScript("OnClick", Tab_OnClick)
	frametabs['lfg']:CreateShadow("Background")
	--S.ReskinFrame(frametabs['lfg'])
	-- restricted to trial accounts
	if (IsTrialAccount()) then
		frametabs['lfg']:SetAlpha(0.5)
		SetDesaturation(frametabs['lfg']:GetNormalTexture(), true)
		frametabs['lfg']:Disable()
	end
	if (IsInGuild() and (not lfguild)) then
		frametabs['lfg']:Hide()
	end

	-- set scale
	fr:SetScale(wscale)

	-- first show, no onShow event yet
	CloseAllTabs()
	VisibleFrames[frtype] = true

	fr:HookScript("OnShow", function()
		VisibleFrames[frtype] = true
		UpdateTabCheckedState(frtype, true)
	end)

	fr:HookScript("OnHide", function()
		VisibleFrames[frtype] = false
		UpdateTabCheckedState(frtype, false)
	end)

	TabArray[fr:GetName()] = frametabs
	UpdateTabCheckedState(frtype, true)
end


FriendsFrame:HookScript("OnShow", function()
		if not TabArray[FriendsFrame:GetName()] then
			CreateTabs(FriendsFrame, 'social')
			if hideraid then
				FriendsFrameTab4:Hide()
			end
		end
	end)
LFDParentFrame:HookScript("OnShow", function()
		if not TabArray[LFDParentFrame:GetName()] then
			CreateTabs(LFDParentFrame, 'lfd')
		end
	end)
RaidParentFrame:HookScript("OnShow", function()
		if not TabArray[RaidParentFrame:GetName()] then
			CreateTabs(RaidParentFrame, 'lfr')

			LFRParentFrameSideTab1:SetPoint("TOPLEFT", LFRParentFrame, "TOPRIGHT", 0, -316)
		end
	end)
PVPFrame:HookScript("OnShow", function()
		if not TabArray[PVPFrame:GetName()] then
			CreateTabs(PVPFrame, 'pvp')
		end
	end)
f:SetScript("OnEvent", function(self, event, addon)
	if (event == 'ADDON_LOADED') then
		if (addon == "Blizzard_GuildUI") then
			CreateTabs(GuildFrame, 'guild')
		elseif (addon == "Blizzard_LookingForGuildUI") then
			CreateTabs(LookingForGuildFrame, 'lfg')
		end
	elseif (event == 'PLAYER_LEVEL_UP') then
		playerLevel = UnitLevel("player")
		if (playerLevel >= SHOW_LFD_LEVEL) then
			UpdateTabEnabledState('lfd', true)
		end
		if (playerLevel >= SHOW_PVP_LEVEL) then
			UpdateTabEnabledState('pvp', true)
		end
	elseif (event == 'PLAYER_GUILD_UPDATE') then
		-- guild button update
		UpdateTabEnabledState('guild', IsInGuild())
		-- guild finder button update
		if (lfguild or (not IsInGuild())) then
			UpdateTabVisibleState('lfg', true)
		else
			UpdateTabVisibleState('lfg', false)
		end
		-- guild button texture update
		for k, v in pairs(TabArray) do
			if (v['guild']) then
				if GetGuildTabardFileNames() then
					v['guild']:SetNormalTexture("Interface\\SpellBook\\GuildSpellbooktabBG")
					v['guild'].TabardEmblem:Show()
					v['guild'].TabardIconFrame:Show()
					SetLargeGuildTabardTextures("player", v['guild'].TabardEmblem, v['guild']:GetNormalTexture(), v['guild'].TabardIconFrame)
				else
					v['guild']:SetNormalTexture("Interface\\GuildFrame\\GuildLogo-NoLogo")
				end
			end
		end
	end
end)
f:RegisterEvent("ADDON_LOADED")
if (not IsTrialAccount()) then
	f:RegisterEvent("PLAYER_GUILD_UPDATE");
end
f:RegisterEvent("PLAYER_LEVEL_UP");
end