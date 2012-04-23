local S, _, _, DB = unpack(select(2, ...))

local map_scale = 0.9								-- Mini World Map scale
local isize = 20									-- group icons size

---------------- > Coordinates functions
local player, cursor
local function gen_string(point, X, Y)
	local t = WorldMapButton:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
	t:SetFont(DB.Font,15,"THINOUTLINE")
	t:SetPoint('BOTTOMLEFT', WorldMapButton, point, X, Y)
	t:SetJustifyH('LEFT')
	return t
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
		cursor:SetFormattedText('Cursor: %.2d,%.2d', 100 * cx, 100 * cy)
	else
		cursor:SetText("")
	end
	if px == 0 or py == 0 then
		player:SetText("")
	else
		player:SetFormattedText('Player: %.2d,%.2d', 100 * px, 100 * py)
	end
	-- gotta change coords position for maximized world map
	if WorldMapQuestScrollFrame:IsShown() then
		player:SetPoint('BOTTOMLEFT', WorldMapButton, 'BOTTOM',-120,0)
		cursor:SetPoint('BOTTOMLEFT', WorldMapButton, 'BOTTOM',50,0)
	else
		player:SetPoint('BOTTOMLEFT', WorldMapButton, 'BOTTOM',-120,-19)
		cursor:SetPoint('BOTTOMLEFT', WorldMapButton, 'BOTTOM',50,-19)
	end
end
local function UpdateCoords(self, elapsed)
	self.elapsed = self.elapsed - elapsed
	if self.elapsed <= 0 then
		self.elapsed = 0.1
		OnUpdate(player, cursor)
	end
end
local tpt = {"LEFT", self, "BOTTOM"}
local function gen_coords(self)
	if player or cursor then return end
	player = gen_string('BOTTOM',-120,-19)
	cursor = gen_string('BOTTOM',50,-19)
end

---------------- > Moving/removing world map elements
if map_scale==1 then map_scale = 0.99 end -- dirty hack to prevent 'division by zero'!
local function null() end
local w = CreateFrame"Frame"
w:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		SetCVar("questPOI", 1)
		gen_coords(self)
		local cond = false
		BlackoutWorld:Hide()
		BlackoutWorld.Show = null
		BlackoutWorld.Hide = null
		WORLDMAP_RATIO_MINI = map_scale
		WORLDMAP_WINDOWED_SIZE = map_scale 
		WORLDMAP_SETTINGS.size = map_scale 
		WorldMapBlobFrame.Show = null
		WorldMapBlobFrame.Hide = null
		WorldMapQuestPOI_OnLeave = function()
			WorldMapTooltip:Hide()
		end
		WorldMap_ToggleSizeDown()
		for i = 1,40 do
			local ri = _G["WorldMapRaid"..i]
			ri:SetWidth(isize)
			ri:SetHeight(isize)
		end
		if FeedbackUIMapTip then 
			FeedbackUIMapTip:Hide()
			FeedbackUIMapTip.Show = null
		end
	elseif event == "PLAYER_REGEN_DISABLED" then
		WorldMapFrameSizeUpButton:Disable()
		WorldMap_ToggleSizeDown()
		WorldMapBlobFrame:DrawBlob(WORLDMAP_SETTINGS.selectedQuestId, false)
		WorldMapBlobFrame:DrawBlob(WORLDMAP_SETTINGS.selectedQuestId, true)
	elseif event == "PLAYER_REGEN_ENABLED" then
		WorldMapFrameSizeUpButton:Enable()
	elseif event == "WORLD_MAP_UPDATE" then
		-- making sure that coordinates are not calculated when map is hidden
		if not WorldMapFrame:IsVisible() and cond then
			self.elapsed = nil
			self:SetScript('OnUpdate', nil)
			cond = false
		else
			self.elapsed = 0.1
			self:SetScript('OnUpdate', UpdateCoords)
			cond = true
		end
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
	end
end)
w:RegisterEvent("PLAYER_ENTERING_WORLD")
w:RegisterEvent("WORLD_MAP_UPDATE")
w:RegisterEvent("PLAYER_REGEN_DISABLED")
w:RegisterEvent("PLAYER_REGEN_ENABLED")


---------------- > Styling mini World Map
-- for the love of GOD do not change values in this function
local function m_MapShrink()
	if not w.bg then w.bg = CreateFrame("Frame", nil, WorldMapButton) end
	if w.bg then w.bg:Show() end
	w.bg:SetParent("WorldMapDetailFrame")
	w.bg:SetFrameStrata("MEDIUM")
	w.bg:SetFrameLevel(50)
	w.bg:SetPoint("BOTTOMRIGHT", WorldMapButton, 8, -30)
	w.bg:SetPoint("TOPLEFT", WorldMapButton, -8, 25)
	S.CreateBD(w.bg)
	S.CreateSD(w.bg, 6, 0, 0, 0, 1, 0)
	WorldMapDetailFrame:ClearAllPoints()
	WorldMapDetailFrame:SetPoint("CENTER")
	WorldMapFrame.scale = map_scale
	WorldMapDetailFrame:SetScale(map_scale)
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
	WorldMapFrameTitle:SetPoint("BOTTOM", WorldMapDetailFrame, "TOP", 0, 0)
	WorldMapTitleButton:SetFrameStrata("TOOLTIP")
	WorldMapTitleButton:ClearAllPoints()
	WorldMapTitleButton:SetPoint("BOTTOM", WorldMapDetailFrame, "TOP",0,0)
	WorldMapTooltip:SetFrameStrata("TOOLTIP")
	WorldMapLevelDropDown.Show = null
	WorldMapLevelDropDown:Hide()
	WorldMapQuestShowObjectives:SetScale(map_scale)
	WorldMapQuestShowObjectives:SetScale(map_scale)
	WorldMapShowDigSites:SetScale(map_scale)
	WorldMapTrackQuest:SetScale(map_scale)
	WorldMapLevelDownButton:SetScale(map_scale)
	WorldMapLevelUpButton:SetScale(map_scale)
	WorldMapShowDropDown:ClearAllPoints()
	WorldMapShowDropDown:SetPoint("TOPRIGHT", WorldMapButton, "BOTTOMRIGHT",15,2)
	WorldMapFrame_SetOpacity(WORLDMAP_SETTINGS.opacity)
	WorldMapQuestShowObjectives_AdjustPosition()
	WorldMapFrameTitle:ClearAllPoints()
	WorldMapFrameTitle:SetPoint("BOTTOMLEFT", WorldMapDetailFrame, 9, 5)
	WorldMapFrameTitle:SetParent(WorldMapButton)
	WorldMapFrameTitle:SetFont(DB.Font,18,"THINOUTLINE")
	WorldMapFrameTitle:SetShadowOffset(0, 0)
	WorldMapFrameTitle:SetTextColor(1, 1, 1)
	WorldMapTrackQuest:SetParent(WorldMapButton)
	WorldMapTrackQuest:ClearAllPoints()
	WorldMapTrackQuest:SetPoint("TOPLEFT", WorldMapDetailFrame, 9, -5)
	WorldMapTrackQuestText:SetFont(DB.Font,18,"THINOUTLINE")
	WorldMapTrackQuestText:SetShadowOffset(0, 0)
	WorldMapTrackQuestText:SetTextColor(1, 1, 1)
	WorldMapShowDigSites:SetParent(WorldMapButton)
	WorldMapShowDigSites:ClearAllPoints()
	WorldMapShowDigSites:SetPoint("BOTTOMRIGHT", WorldMapButton, "BOTTOMRIGHT", 0, 19)
	WorldMapShowDigSitesText:SetFont(DB.Font,18,"THINOUTLINE")
	WorldMapShowDigSitesText:SetShadowOffset(0, 0)
	WorldMapShowDigSitesText:ClearAllPoints()
	WorldMapShowDigSitesText:SetPoint("RIGHT",WorldMapShowDigSites,"LEFT",-4,1)
	WorldMapShowDigSitesText:SetTextColor(1, 1, 1)
end
hooksecurefunc("WorldMap_ToggleSizeDown", m_MapShrink)

local function m_MapEnlarge()
	if w.bg then w.bg:Hide() end
	WorldMapQuestShowObjectives:SetScale(1)
	WorldMapTrackQuest:SetScale(1)
	WorldMapFrameCloseButton:SetScale(1)
	WorldMapShowDigSites:SetScale(1)
	WorldMapLevelDownButton:SetScale(1)
	WorldMapLevelUpButton:SetScale(1)
	WorldMapLevelDropDown.Show = WorldMapLevelDropDown:Show()
	WorldMapFrame:EnableKeyboard(nil)
	WorldMapFrame:EnableMouse(true)
	WorldMapShowDropDown:ClearAllPoints()
	WorldMapShowDropDown:SetPoint("LEFT", WorldMapShowDigSites, "RIGHT",115,0)
	UIPanelWindows["WorldMapFrame"].area = "center"
	WorldMapFrameMiniBorderLeft:SetAlpha(0)
	WorldMapFrameMiniBorderRight:SetAlpha(0)
	WorldMapFrameCloseButton:ClearAllPoints()
	WorldMapFrameCloseButton:SetPoint("TOPRIGHT", WorldMapButton, "TOPRIGHT", 3, 3)
	WorldMapFrameCloseButton:SetFrameStrata("HIGH")
	WorldMapFrameSizeDownButton:ClearAllPoints()
	WorldMapFrameSizeDownButton:SetPoint("TOPRIGHT", WorldMapButton, "TOPRIGHT", 3, -18)
	WorldMapFrameSizeDownButton:SetFrameStrata("HIGH")
	WorldMapFrame:SetAttribute("UIPanelLayout-defined", nil)
	WorldMapFrameTitle:ClearAllPoints()
	WorldMapFrameTitle:SetPoint("BOTTOMLEFT", WorldMapDetailFrame, 9, 5)
	WorldMapFrameTitle:SetParent(WorldMapButton)
	WorldMapFrameTitle:SetFont(DB.Font,18,"THINOUTLINE")
	WorldMapFrameTitle:SetShadowOffset(0, 0)
	WorldMapFrameTitle:SetTextColor(1, 1, 1)
	WorldMapTrackQuest:SetParent(WorldMapButton)
	WorldMapTrackQuest:ClearAllPoints()
	WorldMapTrackQuest:SetPoint("TOPLEFT", WorldMapDetailFrame, 9, -5)
	WorldMapTrackQuestText:SetFont(DB.Font,18,"THINOUTLINE")
	WorldMapTrackQuestText:SetShadowOffset(0, 0)
	WorldMapTrackQuestText:SetTextColor(1, 1, 1)
	WorldMapShowDigSites:SetParent(WorldMapButton)
	WorldMapShowDigSites:ClearAllPoints()
	WorldMapShowDigSites:SetPoint("BOTTOMRIGHT", WorldMapButton, "BOTTOMRIGHT", 0, 19)
	WorldMapShowDigSitesText:SetFont(DB.Font,18,"THINOUTLINE")
	WorldMapShowDigSitesText:SetShadowOffset(0, 0)
	WorldMapShowDigSitesText:ClearAllPoints()
	WorldMapShowDigSitesText:SetPoint("RIGHT",WorldMapShowDigSites,"LEFT",-4,1)
	WorldMapShowDigSitesText:SetTextColor(1, 1, 1)
end
hooksecurefunc("WorldMap_ToggleSizeUp", m_MapEnlarge)