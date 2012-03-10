local S, C, L, DB = unpack(SunUI)
for i = 1, 4 do
	_G["WorldMapParty"..i]:Width(32)
	_G["WorldMapParty"..i]:Height(32)
end
for i = 1, 40 do
	_G["WorldMapRaid"..i]:Width(32)
	_G["WorldMapRaid"..i]:Height(32)
end

hooksecurefunc("WorldMapUnit_Update", function(self)
	if not self.group then
		self.group = self:CreateFontString(nil, "OVERLAY", "TextStatusBarText")
		self.group:Point("CENTER")
	end
	self.group:SetText("")
	if self.unit then
		if string.find(self.unit, "raid") then
			self.group:SetText(select(3, GetRaidRosterInfo(string.sub(self.unit, 5))))
		end
		if UnitAffectingCombat(self.unit) then
			self.icon:SetVertexColor(0.8, 0, 0)
		elseif UnitIsDeadOrGhost(self.unit) then
			self.icon:SetVertexColor(0.5, 0.5, 0.5)
		end
	end
end)


local function colorCode(eclass)
	local colorRGB = RAID_CLASS_COLORS[eclass] or NORMAL_FONT_COLOR
	return format("|CFF%2x%2x%2x", colorRGB.r*255, colorRGB.g*255, colorRGB.b*255)
end

local function MapUnit_OnEnter(self, motion, map)
	if map == "WorldMap" then
		WorldMapPOIFrame.allowBlobTooltip = false
	end
	local x, y = self:GetCenter()
	local parentX, parentY = self:GetParent():GetCenter()
	if ( x > parentX ) then
		if map == "WorldMap" then
			WorldMapTooltip:SetOwner(self, "ANCHOR_LEFT")
		else
			GameTooltip:SetOwner(self, "ANCHOR_LEFT")
		end
	else
		if map == "WorldMap" then
			WorldMapTooltip:SetOwner(self, "ANCHOR_RIGHT")
		else
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		end
	end

	local unitButton, unit
	local newLineString = ""
	local tooltipText = ""
	local name, subgroup, class, fileName, nameText, server

	if ( map == "WorldMap" and WorldMapPlayer:IsMouseOver() ) then
		name = UnitName(WorldMapPlayer.unit)
		if ( PlayerIsPVPInactive(WorldMapPlayer.unit) ) then
			tooltipText = format(PLAYER_IS_PVP_AFK, "-> "..name.." <-")
		else
			_, fileName = UnitClass(WorldMapPlayer.unit)
			tooltipText = "-> "..colorCode(fileName)..name.."|r".." <-"
		end
		newLineString = "\n"
	end
	for i=1, MAX_PARTY_MEMBERS do
		unitButton = _G[map.."Party"..i]
		if ( unitButton:IsVisible() and unitButton:IsMouseOver() ) then
			name = UnitName(unitButton.unit)
			class, fileName = UnitClass(unitButton.unit)
			if ( PlayerIsPVPInactive(unitButton.unit) ) then
				tooltipText = tooltipText..newLineString..format(PLAYER_IS_PVP_AFK, class.." "..name)
			else
				tooltipText = tooltipText..newLineString..class.." "..colorCode(fileName)..name.."|r"
			end
			newLineString = "\n"
		end
	end
	for i=1, MAX_RAID_MEMBERS do
		unitButton = _G[map.."Raid"..i]
		if ( unitButton:IsVisible() and unitButton:IsMouseOver() ) then
			if ( unitButton.name ) then
				if ( PlayerIsPVPInactive(unitButton.name) ) then
					tooltipText = tooltipText..newLineString..format(PLAYER_IS_PVP_AFK, unitButton.name)
				else
					tooltipText = tooltipText..newLineString..unitButton.name
				end
			else
				unit = unitButton.unit
				nameText, _, subgroup, _, class, fileName = GetRaidRosterInfo(string.sub(unit, 5))
				_, _, name, server = string.find(nameText, "([^%-]+)%-(.+)")
				if PlayerIsPVPInactive(unit) then
					if name and server then
						name = name.."-"..server
					else
						name = nameText
					end
					tooltipText = tooltipText..newLineString..format(PLAYER_IS_PVP_AFK, "["..subgroup.."] "..class.." "..name)
				else
					if name and server then
						name = colorCode(fileName)..name.."|r".."|CFFFFFFFF-|r|CFFFFD200"..server.."|r"
					else
						name = colorCode(fileName)..nameText.."|r"
					end
					tooltipText = tooltipText..newLineString.."["..subgroup.."] "..class.." "..name
				end
			end
			newLineString = "\n"
		end
	end
	if map == "WorldMap" then
		for _, v in pairs(MAP_VEHICLES) do
			if ( v:IsVisible() and v:IsMouseOver() ) then
				if ( v.name ) then
					tooltipText = tooltipText..newLineString..v.name
				end
				newLineString = "\n"
			end
		end
		for i = 1, NUM_WORLDMAP_DEBUG_OBJECTS do
			unitButton = _G["WorldMapDebugObject"..i]
			if ( unitButton:IsVisible() and unitButton:IsMouseOver() ) then
				tooltipText = tooltipText..newLineString..unitButton.name
				newLineString = "\n"
			end
		end
		WorldMapTooltip:SetText(tooltipText)
		WorldMapTooltip:Show()
	else
		GameTooltip:SetText(tooltipText)
		GameTooltip:Show()
	end
end

function WorldMapUnit_OnEnter(self, motion)
	MapUnit_OnEnter(self, motion, "WorldMap")
end

hooksecurefunc("BattlefieldMinimap_LoadUI", function()
	if BattlefieldMinimap then
		function BattlefieldMinimapUnit_OnEnter(self, motion)
			MapUnit_OnEnter(self, motion, "BattlefieldMinimap")
		end
	end
end)