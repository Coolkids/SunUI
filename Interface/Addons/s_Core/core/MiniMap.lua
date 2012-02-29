-- Engines
local S, C, L, DB = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("Core"):NewModule("MiniMap", "AceTimer-3.0")
if DB.Nuke == true then return end
Minimap:SetMaskTexture("Interface\\ChatFrame\\ChatFrameBackground")
Minimap:SetFrameStrata("BACKGROUND")
Minimap:ClearAllPoints()
Minimap:Size(S.Scale(145), S.Scale(145))
Minimap:CreateShadow()

function Module:OnInitialize()
	MoveHandle.Minimap = S.MakeMoveHandle(Minimap, L["小地图"], "Minimap")
end

LFGSearchStatus:SetClampedToScreen(true)
LFGDungeonReadyStatus:SetClampedToScreen(true)

local frames = {
    "GameTimeFrame",
    "MinimapBorderTop",
    "MinimapNorthTag",
    "MinimapBorder",
    "MinimapZoneTextButton",
    "MinimapZoomOut",
    "MinimapZoomIn",
    "MiniMapVoiceChatFrame",
    "MiniMapWorldMapButton",
    "MiniMapMailBorder",
    "MiniMapBattlefieldBorder",
--    "FeedbackUIButton",
}

for i in pairs(frames) do
	_G[frames[i]]:Hide()
	_G[frames[i]].Show = function() end
end
MinimapCluster:EnableMouse(false)

-- Tracking
MiniMapTrackingBackground:SetAlpha(0)
MiniMapTrackingButton:SetAlpha(0)
MiniMapTracking:ClearAllPoints()
MiniMapTracking:Point("BOTTOMLEFT", Minimap, -5, -5)
MiniMapTracking:SetScale(1)

-- BG icon
MiniMapBattlefieldFrame:ClearAllPoints()
MiniMapBattlefieldFrame:Point("TOP", Minimap, "TOP", 2, 8)

-- Random Group icon
MiniMapLFGFrame:ClearAllPoints()
MiniMapLFGFrameBorder:SetAlpha(0)
MiniMapLFGFrame:Point("TOP", Minimap, "TOP", 1, 8)
MiniMapLFGFrame:SetFrameStrata("MEDIUM")

-- Instance Difficulty flag
MiniMapInstanceDifficulty:ClearAllPoints()
MiniMapInstanceDifficulty:Point("TOPRIGHT", Minimap, "TOPRIGHT", 2, 2)
MiniMapInstanceDifficulty:SetScale(0.1)
MiniMapInstanceDifficulty:SetAlpha(0)
MiniMapInstanceDifficulty:SetFrameStrata("LOW")

-- Guild Instance Difficulty flag
GuildInstanceDifficulty:ClearAllPoints()
GuildInstanceDifficulty:Point("TOPRIGHT", Minimap, "TOPRIGHT", 2, 2)
GuildInstanceDifficulty:SetScale(0.1)
GuildInstanceDifficulty:SetAlpha(0)
GuildInstanceDifficulty:SetFrameStrata("LOW")

-- Mail icon
MiniMapMailFrame:ClearAllPoints()
MiniMapMailFrame:Point("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 2, -6)
MiniMapMailIcon:SetTexture("Interface\\AddOns\\s_Core\\media\\mail")

-- Invites Icon
GameTimeCalendarInvitesTexture:ClearAllPoints()
GameTimeCalendarInvitesTexture:SetParent("Minimap")
GameTimeCalendarInvitesTexture:Point("TOPRIGHT")

if FeedbackUIButton then
FeedbackUIButton:ClearAllPoints()
FeedbackUIButton:Point("TOPLEFT", Minimap, "TOPLEFT", 6, -6)
FeedbackUIButton:SetScale(0.8)
end

if StreamingIcon then
StreamingIcon:ClearAllPoints()
StreamingIcon:Point("TOPRIGHT", Minimap, "TOPRIGHT", 8, 8)
StreamingIcon:SetScale(0.8)
end

-- Enable mouse scrolling
Minimap:EnableMouseWheel(true)
Minimap:SetScript("OnMouseWheel", function(self, z)
	local c = Minimap:GetZoom()
	if z > 0 and c < 5 then
		Minimap:SetZoom(c+1)
	elseif z < 0 and c > 0 then
		Minimap:SetZoom(c-1)
	end
end)

local menuFrame = CreateFrame("Frame", "m_MinimapRightClickMenu", UIParent, "UIDropDownMenuTemplate")
local menuList = {
    {text = L["角色信息"], func = function() ToggleCharacter("PaperDollFrame") end},
    {text = L["法术书"], func = function() ToggleSpellBook("spell") end},
    {text = L["天赋"], func = function() ToggleTalentFrame() end},
    {text = L["成就"], func = function() ToggleAchievementFrame() end},
    {text = L["任务日志"], func = function() ToggleFrame(QuestLogFrame) end},
    {text = L["社交"], func = function() ToggleFriendsFrame(1) end},
    {text = L["公会"], func = function() ToggleGuildFrame(1) end},
    {text = "PvP", func = function() ToggleFrame(PVPFrame) end},
    {text = L["地城查找器"], func = function() ToggleFrame(LFDParentFrame) end},
	{text = L["团队查找器"], func = function() ToggleFrame(RaidParentFrame) end},
    {text = L["帮助"], func = function() ToggleHelpFrame() end},
    {text = L["行事历"], func = function() if(not CalendarFrame) then LoadAddOn("Blizzard_Calendar") end Calendar_Toggle() end},
	{text = L["地城手册"],func = function() ToggleEncounterJournal() end},
}

Minimap:SetScript("OnMouseUp", function(self, button)
	if button == "RightButton" then
		EasyMenu(menuList, menuFrame, "cursor", 0, 0, "MENU", 2)
	else
		Minimap_OnClick(self)
	end
end)
