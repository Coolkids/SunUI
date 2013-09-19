local S, L, DB, _, C = unpack(select(2, ...))
local map_scale = 0.9								-- Mini World Map scale
local isize = 20									-- group icons size
local WM = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("WorldMap", "AceEvent-3.0", "AceHook-3.0")
local SunUIConfig = LibStub("AceAddon-3.0"):GetAddon("SunUI"):GetModule("SunUIConfig")
local player, cursor
local EJbuttonWidth, EJbuttonHeight = 30, 30
local EJbuttonImageWidth, EJbuttonImageHeigth = 21.6, 21.6
local ejbuttonscale = 1

function WM:ResizeEJBossButton()
	if WORLDMAP_SETTINGS.size == WORLDMAP_WINDOWED_SIZE then
		local index = 1
		while _G["EJMapButton"..index] do
			_G["EJMapButton"..index]:SetSize(EJbuttonWidth * ejbuttonscale, EJbuttonHeight * ejbuttonscale)
			_G["EJMapButton"..index].bgImage:SetSize(EJbuttonImageWidth * ejbuttonscale,EJbuttonImageHeigth * ejbuttonscale)
			index = index + 1
		end
	else
		local index = 1
		while _G["EJMapButton"..index] do
			_G["EJMapButton"..index]:SetSize(EJbuttonWidth, EJbuttonHeight)
			_G["EJMapButton"..index].bgImage:SetSize(EJbuttonImageWidth,EJbuttonImageHeigth)
			index = index + 1
		end
	end
end


function WM:CreateCoordString()
	if player or cursor then return end
	player = WorldMapButton:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	player:SetFont(DB.Font,14*SunUIConfig.db.profile.MiniDB.FontScale)
	player:SetPoint("BOTTOMLEFT", WorldMapButton, "BOTTOM", -120, -22)
	player:SetJustifyH("LEFT")
	cursor = WorldMapButton:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	cursor:SetFont(DB.Font,14*SunUIConfig.db.profile.MiniDB.FontScale)
	cursor:SetPoint("BOTTOMLEFT", WorldMapButton, "BOTTOM", 50, -22)
	cursor:SetJustifyH("LEFT")
end

function WM:PLAYER_ENTERING_WORLD()
	SetCVar("questPOI", 1)
	SetCVar("lockedWorldMap", 0)
	WM:CreateCoordString(self)
	local cond = false
	BlackoutWorld:Hide()
	BlackoutWorld.Show = function() end
	BlackoutWorld.Hide = function() end
	WORLDMAP_RATIO_MINI = map_scale
	WORLDMAP_WINDOWED_SIZE = map_scale 
	WORLDMAP_SETTINGS.size = map_scale
	WorldMapBlobFrame.Show = function() end
	WorldMapBlobFrame.Hide = function() end
	WorldMapQuestPOI_OnLeave = function()
		WorldMapTooltip:Hide()
	end
	WorldMap_ToggleSizeDown()
	for i = 1, 4 do 
		_G["WorldMapParty"..i]:SetWidth(24) 
		_G["WorldMapParty"..i]:SetHeight(24) 
	end 
	for i = 1, 40 do 
		_G["WorldMapRaid"..i]:SetWidth(24) 
		_G["WorldMapRaid"..i]:SetHeight(24) 
	end
	if FeedbackUIMapTip then 
		FeedbackUIMapTip:Hide()
		FeedbackUIMapTip.Show = function() end
	end
end

function WM:PLAYER_REGEN_DISABLED()
	WorldMapFrameSizeDownButton:Disable();
	WorldMapFrameSizeUpButton:Disable()
	WorldMap_ToggleSizeDown()
	WorldMapBlobFrame:DrawBlob(WORLDMAP_SETTINGS.selectedQuestId, false)
	WorldMapBlobFrame:DrawBlob(WORLDMAP_SETTINGS.selectedQuestId, true)
end

function WM:PLAYER_REGEN_ENABLED()
	WorldMapFrameSizeDownButton:Enable()
	WorldMapFrameSizeUpButton:Enable()
end

function WM:WORLD_MAP_UPDATE()
	if (GetNumDungeonMapLevels() == 0) then
		WorldMapLevelUpButton:Hide()
		WorldMapLevelDownButton:Hide()
	else
		WorldMapLevelUpButton:Show()
		WorldMapLevelUpButton:ClearAllPoints()
		WorldMapLevelUpButton:SetPoint("TOPLEFT", WorldMapFrameCloseButton, "BOTTOMLEFT", 8, 8)
		WorldMapLevelUpButton:SetFrameStrata("MEDIUM")
		WorldMapLevelUpButton:SetFrameLevel(100)
		WorldMapLevelUpButton:SetParent("WorldMapFrame")
		WorldMapLevelDownButton:ClearAllPoints()
		WorldMapLevelDownButton:Show()
		WorldMapLevelDownButton:SetPoint("TOP", WorldMapLevelUpButton, "BOTTOM",0,-2)
		WorldMapLevelDownButton:SetFrameStrata("MEDIUM")
		WorldMapLevelDownButton:SetFrameLevel(100)
		WorldMapLevelDownButton:SetParent("WorldMapFrame")
	end
	if IsInRaid() then
		local count = 0;
		for i=1, MAX_RAID_MEMBERS do
			local unit = "raid"..i
			local partyX, partyY = GetPlayerMapPosition(unit)
			if not ( (partyX == 0 and partyY == 0) or UnitIsUnit(unit, "player") ) then
				count = count + 1
			end
		end
		for i=count+1, MAX_RAID_MEMBERS do
			_G["WorldMapRaid"..i]:Hide()
		end
	end
end

function WM:SkinWorldMap()
	WorldMapFrame.backdrop = CreateFrame("Frame", nil, WorldMapFrame)
	WorldMapFrame.backdrop:Point("TOPLEFT", WorldMapFrame, -2, 2)
	WorldMapFrame.backdrop:Point("BOTTOMRIGHT", WorldMapFrame, 2, -2)
	S.SetBD(WorldMapFrame.backdrop)
	WorldMapFrame.backdrop:SetFrameLevel(0)

	WorldMapDetailFrame.backdrop = CreateFrame("Frame", nil, WorldMapFrame)
	S.SetBD(WorldMapDetailFrame.backdrop)
	WorldMapDetailFrame.backdrop:Point("TOPLEFT", WorldMapDetailFrame, -2, 2)
	WorldMapDetailFrame.backdrop:Point("BOTTOMRIGHT", WorldMapDetailFrame, 2, -2)
	WorldMapDetailFrame.backdrop:SetFrameLevel(WorldMapDetailFrame:GetFrameLevel() - 2)

	S.ReskinDropDown(WorldMapZoneMinimapDropDown)
	S.ReskinDropDown(WorldMapContinentDropDown)
	S.ReskinDropDown(WorldMapZoneDropDown)

	S.ReskinDropDown(WorldMapShowDropDown)
	WorldMapShowDropDown:ClearAllPoints()
	WorldMapShowDropDown:SetPoint("TOPRIGHT", WorldMapButton, "BOTTOMRIGHT", 18, 2)

	S.Reskin(WorldMapZoomOutButton)
	WorldMapZoomOutButton:Point("LEFT", WorldMapZoneDropDown, "RIGHT", 0, 4)
	WorldMapLevelUpButton:Point("TOPLEFT", WorldMapLevelDropDown, "TOPRIGHT", -2, 8)
	WorldMapLevelDownButton:Point("BOTTOMLEFT", WorldMapLevelDropDown, "BOTTOMRIGHT", -2, 2)

	S.ReskinCheck(WorldMapTrackQuest)
	WorldMapFrameSizeUpButton:SetFrameStrata("HIGH")
	WorldMapFrameSizeUpButton.SetFrameStrata = function() end
	WorldMapFrameSizeDownButton:SetFrameStrata("HIGH")
	WorldMapFrameSizeDownButton:SetFrameLevel(99)
	WorldMapFrameSizeDownButton.SetFrameStrata = function() end
	WorldMapFrameCloseButton:SetFrameStrata("HIGH")
	WorldMapFrameCloseButton:SetFrameLevel(99)
	WorldMapFrameCloseButton.SetFrameStrata = function() end
	WorldMapLevelUpButton:SetFrameStrata("HIGH")
	WorldMapLevelUpButton:SetFrameLevel(99)
	WorldMapLevelUpButton.SetFrameStrata = function() end
	WorldMapLevelDownButton:SetFrameStrata("HIGH")
	WorldMapLevelDownButton.SetFrameStrata = function() end
end

function WM:SmallSkin()
	WorldMapDetailFrame.backdrop:Show()
	WorldMapFrame.backdrop:Hide()
	WorldMapDetailFrame.backdrop:ClearAllPoints()
	WorldMapDetailFrame.backdrop:SetPoint("BOTTOMRIGHT", WorldMapButton, 8, -30)
	WorldMapDetailFrame.backdrop:SetPoint("TOPLEFT", WorldMapButton, -8, 25)
	WorldMapDetailFrame.backdrop:SetFrameLevel(0)
	WorldMapDetailFrame.backdrop:SetFrameStrata(WorldMapDetailFrame:GetFrameStrata())
	WorldMapFrame.scale = map_scale
	--WorldMapDetailFrame:SetScale(map_scale) --Block
	WorldMapButton:SetScale(map_scale)
	WorldMapFrameAreaFrame:SetScale(map_scale)
	WorldMapTitleButton:Show()
	WorldMapFrameMiniBorderLeft:Hide()
	WorldMapFrameMiniBorderRight:Hide()
	WorldMapPOIFrame.ratio = map_scale
	WorldMapFrameSizeUpButton:Show()
	WorldMapFrameSizeUpButton:ClearAllPoints()
	WorldMapFrameSizeUpButton:SetPoint("TOPRIGHT", WorldMapButton, "TOPRIGHT",-10,27)
	WorldMapFrameSizeUpButton:SetFrameStrata("MEDIUM")
	WorldMapFrameSizeUpButton:SetScale(map_scale)
	WorldMapFrameCloseButton:ClearAllPoints()
	WorldMapFrameCloseButton:SetPoint("TOPRIGHT", WorldMapButton, "TOPRIGHT",10,27)
	WorldMapFrameCloseButton:SetFrameStrata("MEDIUM")
	WorldMapFrameCloseButton:SetScale(map_scale)
	WorldMapFrameTitle:ClearAllPoints()
	WorldMapFrameTitle:SetPoint("BOTTOM", WorldMapDetailFrame, "TOP", 0, 5)
	WorldMapTitleButton:SetFrameStrata("TOOLTIP")
	WorldMapTitleButton:ClearAllPoints()
	WorldMapTitleButton:SetPoint("BOTTOM", WorldMapDetailFrame, "TOP",0,0)
	WorldMapTooltip:SetFrameStrata("TOOLTIP")
	WorldMapLevelDropDown.Show = function() end
	WorldMapLevelDropDown:Hide()
	WorldMapTrackQuest:SetScale(map_scale)
	WorldMapLevelDownButton:SetScale(map_scale)
	WorldMapLevelUpButton:SetScale(map_scale)
	WorldMapFrame_SetOpacity(WORLDMAP_SETTINGS.opacity)
end

function WM:LargeSkin()
	if not InCombatLockdown() then
		WorldMapFrame:SetParent(UIParent)
		WorldMapFrame:EnableMouse(false)
		WorldMapFrame:EnableKeyboard(false)
		SetUIPanelAttribute(WorldMapFrame, "area", "center");
		SetUIPanelAttribute(WorldMapFrame, "allowOtherPanels", true)
	end

	WorldMapDetailFrame.backdrop:Hide()
	WorldMapFrame.backdrop:Show()
	WorldMapFrame.backdrop:ClearAllPoints()
	WorldMapFrame.backdrop:Point("TOPLEFT", WorldMapDetailFrame, "TOPLEFT", -25, 70)
	WorldMapFrame.backdrop:Point("BOTTOMRIGHT", WorldMapDetailFrame, "BOTTOMRIGHT", 25, -30)
	WorldMapTrackQuest:SetScale(1)
	WorldMapFrameCloseButton:SetScale(1)
	WorldMapLevelDownButton:SetScale(1)
	WorldMapLevelUpButton:SetScale(1)
	WorldMapFrame:EnableKeyboard(nil)
	WorldMapFrame:EnableMouse(nil)
	UIPanelWindows["WorldMapFrame"].area = "center"
	WorldMapFrame:SetAttribute("UIPanelLayout-defined", nil)
	WorldMapBossButtonFrame:Show()
end

function WM:QuestSkin()
	if not InCombatLockdown() then
		WorldMapFrame:SetParent(UIParent)
		WorldMapFrame:EnableMouse(false)
		WorldMapFrame:EnableKeyboard(false)
		SetUIPanelAttribute(WorldMapFrame, "area", "center");
		SetUIPanelAttribute(WorldMapFrame, "allowOtherPanels", true)
	end

	WorldMapFrame.backdrop:ClearAllPoints()
	WorldMapFrame.backdrop:Point("TOPLEFT", WorldMapDetailFrame, "TOPLEFT", -25, 70)
	WorldMapFrame.backdrop:Point("BOTTOMRIGHT", WorldMapDetailFrame, "BOTTOMRIGHT", 325, -235)  

	if not WorldMapQuestDetailScrollFrame.backdrop then
		WorldMapQuestDetailScrollFrame.backdrop = CreateFrame("Frame", nil, WorldMapQuestDetailScrollFrame)
		S.CreateBD(WorldMapQuestDetailScrollFrame.backdrop)
		WorldMapQuestDetailScrollFrame.backdrop:SetFrameLevel(0)
		WorldMapQuestDetailScrollFrame.backdrop:Point("TOPLEFT", -22, 2)
		WorldMapQuestDetailScrollFrame.backdrop:Point("BOTTOMRIGHT", 23, -4)
	end

	if not WorldMapQuestRewardScrollFrame.backdrop then
		WorldMapQuestRewardScrollFrame.backdrop = CreateFrame("Frame", nil, WorldMapQuestRewardScrollFrame)
		S.CreateBD(WorldMapQuestRewardScrollFrame.backdrop)
		WorldMapQuestRewardScrollFrame.backdrop:SetFrameLevel(0)
		WorldMapQuestRewardScrollFrame.backdrop:Point("TOPLEFT", -2, 2)
		WorldMapQuestRewardScrollFrame.backdrop:Point("BOTTOMRIGHT", 22, -4)
	end

	if not WorldMapQuestScrollFrame.backdrop then
		WorldMapQuestScrollFrame.backdrop = CreateFrame("Frame", nil, WorldMapQuestScrollFrame)
		S.CreateBD(WorldMapQuestScrollFrame.backdrop)
		WorldMapQuestScrollFrame.backdrop:SetFrameLevel(0)
		WorldMapQuestScrollFrame.backdrop:Point("TOPLEFT", 0, 2)
		WorldMapQuestScrollFrame.backdrop:Point("BOTTOMRIGHT", 24, -3)
	end
end

local function Cursor()
	local left, top = WorldMapDetailFrame:GetLeft() or 0, WorldMapDetailFrame:GetTop() or 0
	local width, height = WorldMapDetailFrame:GetWidth(), WorldMapDetailFrame:GetHeight()
	local scale = WorldMapDetailFrame:GetEffectiveScale()
	local x, y = GetCursorPosition()
	local cx = (x/scale - left) / width
	local cy = (top - y/scale) / height
	if cx < 0 or cx > 1 or cy < 0 or cy > 1 then return end
	return cx, cy
end

local function OnUpdate(player, cursor)
	local cx, cy = Cursor()
	local px, py = GetPlayerMapPosition("player")
	if cx and cy then
		cursor:SetFormattedText(MOUSE_LABEL..": %.2d,%.2d", 100 * cx, 100 * cy)
	else
		cursor:SetText("")
	end
	if px == 0 or py == 0 then
		player:SetText("")
	else
		player:SetFormattedText(PLAYER..": %.2d,%.2d", 100 * px, 100 * py)
	end
	-- gotta change coords position for maximized world map
	if WorldMapQuestScrollFrame:IsShown() then
		player:SetPoint("BOTTOMLEFT", WorldMapButton, "BOTTOM",-120,0)
		cursor:SetPoint("BOTTOMLEFT", WorldMapButton, "BOTTOM",50,0)
	else
		player:SetPoint("BOTTOMLEFT", WorldMapButton, "BOTTOM",-120,-22)
		cursor:SetPoint("BOTTOMLEFT", WorldMapButton, "BOTTOM",50,-22)
	end
end

local function UpdateCoords(self, elapsed)
	self.elapsed = (self.elapsed or 0.1) - elapsed
	if self.elapsed <= 0 then
		self.elapsed = 0.1
		OnUpdate(player, cursor)
	end
end

function WM:OnUpdate(self, elapsed)
	if self:IsShown() then
		UpdateCoords(self, elapsed)
	end
	if InCombatLockdown() then
		WorldMapFrameSizeDownButton:Disable()
		WorldMapFrameSizeUpButton:Disable()
	else
		WorldMapFrameSizeDownButton:Enable()
		WorldMapFrameSizeUpButton:Enable()
	end
	if WORLDMAP_SETTINGS.size == WORLDMAP_FULLMAP_SIZE then
		WorldMapFrameSizeUpButton:Hide()
		WorldMapFrameSizeDownButton:Show()
	elseif WORLDMAP_SETTINGS.size == WORLDMAP_WINDOWED_SIZE then
		WorldMapFrameSizeUpButton:Show()
		WorldMapFrameSizeDownButton:Hide()
	elseif WORLDMAP_SETTINGS.size == WORLDMAP_QUESTLIST_SIZE then
		WorldMapFrameSizeUpButton:Hide()
		WorldMapFrameSizeDownButton:Show()
	end
end

function WM:FixSkin()
	if not InCombatLockdown() and WorldMapFrame:GetFrameStrata() == "MEDIUM" then
		--print(WorldMapFrame:GetFrameStrata())
		WorldMapFrame:SetFrameStrata("HIGH") --Block
	end
	WorldMapFrame:StripTextures()
	if WORLDMAP_SETTINGS.size == WORLDMAP_FULLMAP_SIZE then
		self:LargeSkin()
	elseif WORLDMAP_SETTINGS.size == WORLDMAP_WINDOWED_SIZE then
		self:SmallSkin()
	elseif WORLDMAP_SETTINGS.size == WORLDMAP_QUESTLIST_SIZE then
		self:QuestSkin()
	end

	if not InCombatLockdown() then
		WorldMapFrameSizeDownButton:Show()
		WorldMapFrame:SetFrameLevel(10)
	else
		WorldMapFrameSizeDownButton:Disable()
		WorldMapFrameSizeUpButton:Disable()
	end

	WorldMapFrameAreaLabel:SetFont(GameFontNormalSmall:GetFont(), 50, "OUTLINE")
	WorldMapFrameAreaLabel:SetShadowOffset(S.mult, -S.mult)
	WorldMapFrameAreaLabel:SetTextColor(0.90, 0.8294, 0.6407)

	WorldMapFrameAreaDescription:SetFont(GameFontNormalSmall:GetFont(), 40, "OUTLINE")
	WorldMapFrameAreaDescription:SetShadowOffset(S.mult, -S.mult)

	WorldMapZoneInfo:SetFont(GameFontNormalSmall:GetFont(), 27, "OUTLINE")
	WorldMapZoneInfo:SetShadowOffset(S.mult, -S.mult)
end

function WM:OnInitialize()
	if IsAddOnLoaded("Mapster") or IsAddOnLoaded("Carbonite") then
		return
	end
	self:SkinWorldMap()
	WorldMapFrame:HookScript("OnShow", function() WM:FixSkin() end)
	WorldMapFrame:HookScript("OnUpdate", function(self, elapsed) WM:OnUpdate(self, elapsed) end)
	self:SecureHook("WorldMapFrame_SetFullMapView", "LargeSkin")
	self:SecureHook("WorldMapFrame_SetQuestMapView", "QuestSkin")
	self:SecureHook("EncounterJournal_AddMapButtons", "ResizeEJBossButton")
	self:SecureHook("WorldMap_ToggleSizeUp", "LargeSkin")
	self:SecureHook("WorldMap_ToggleSizeDown", "SmallSkin")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("WORLD_MAP_UPDATE")
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
end 