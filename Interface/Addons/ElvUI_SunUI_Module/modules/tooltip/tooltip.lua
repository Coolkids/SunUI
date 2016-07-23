local E, L, V, P, G = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local TT = E:GetModule('Tooltip')
local types = {
	rare = " |cffFF44FFR|r ",
	elite = " |cffFFFF00+|r ",
	worldboss = " |cffFF1919B|r ",
	rareelite = " |cff9933FAR|r|cffFFFF00+|r ",
}

local reactionlist  = {
	[1] = FACTION_STANDING_LABEL1,
	[2] = FACTION_STANDING_LABEL2,
	[3] = FACTION_STANDING_LABEL3,
	[4] = FACTION_STANDING_LABEL4,
	[5] = FACTION_STANDING_LABEL5,
	[6] = FACTION_STANDING_LABEL6,
	[7] = FACTION_STANDING_LABEL7,
	[8] = FACTION_STANDING_LABEL8,
}

local gcol = {.35, 1, .6}										-- Guild Color
local pgcol = {1, .12, .8} 									-- Player's Guild Color

function GameTooltip_UnitColor(unit)
	local r, g, b = 1, 1, 1
	if UnitPlayerControlled(unit) then
		if UnitCanAttack(unit, "player") then
			if UnitCanAttack("player", unit) then
				r = FACTION_BAR_COLORS[2].r
				g = FACTION_BAR_COLORS[2].g
				b = FACTION_BAR_COLORS[2].b
			end
		elseif UnitCanAttack("player", unit) then
			r = FACTION_BAR_COLORS[4].r
			g = FACTION_BAR_COLORS[4].g
			b = FACTION_BAR_COLORS[4].b
		elseif UnitIsPVP(unit) then
			r = FACTION_BAR_COLORS[6].r
			g = FACTION_BAR_COLORS[6].g
			b = FACTION_BAR_COLORS[6].b
		end
	else
		local reaction = UnitReaction(unit, "player")
		if reaction then
			r = FACTION_BAR_COLORS[reaction].r
			g = FACTION_BAR_COLORS[reaction].g
			b = FACTION_BAR_COLORS[reaction].b
		end
	end
	if UnitIsPlayer(unit) then
		local class = select(2, UnitClass(unit))
		if class then
			r = RAID_CLASS_COLORS[class].r
			g = RAID_CLASS_COLORS[class].g
			b = RAID_CLASS_COLORS[class].b
		end
	end
	return r, g, b
end

local hex = function(r, g, b)
	return ('|cff%02x%02x%02x'):format(r * 255, g * 255, b * 255)
end

local truncate = function(value)
	if value >= 1e6 then
		return string.format('%.2fm', value / 1e6)
	elseif value >= 1e4 then
		return string.format('%.1fk', value / 1e3)
	else
		return string.format('%.0f', value)
	end
end
local function LevelColor(target)
	local player = UnitLevel("player")
	local temp, color = 0, {}
	if target > 0 then
		temp = target - player
	end
	if target < 0 then
		color = {["r"] = 1, ["g"] = 0.1, ["b"] = 0.1}
	elseif temp >= 5 then
		color = {["r"] = 1, ["g"] = 0, ["b"] = 0}
	elseif temp < 5 and temp >= 3 then
		color = {["r"] = 1, ["g"] = 0.5, ["b"] = 0.25}
	elseif temp < 3 and temp > -3 then
		color = {["r"] = 1, ["g"] = 1, ["b"] = 0}
	elseif temp <= -3 and temp > -9 then
		color = {["r"] = 0.25, ["g"] = 0.75, ["b"] = 0.25}
	elseif temp <= -9 then
		color = {["r"] = 0.5, ["g"] = 0.5, ["b"] = 0.5}	
	end
	return color
end

local function On_OnTooltipSetUnit(self)
	local unit = select(2, self:GetUnit())
	if unit then
		local unitClassification = types[UnitClassification(unit)] or " "
		local creatureType = UnitCreatureType(unit) or ""
		local unitName = UnitName(unit)
		local unitLevel = UnitLevel(unit)
		local diffColor = LevelColor(unitLevel)
		--local diffColor = unitLevel > 0 and GetQuestDifficultyColor(UnitLevel(unit)) or QuestDifficultyColors["impossible"]
		--print(diffColor.r, diffColor.g, diffColor.b, unitLevel)
		if unitLevel < 0 then unitLevel = '??' end
		if UnitIsPlayer(unit) then
			local unitRace = UnitRace(unit)
			local unitClass, class = UnitClass(unit)
			local guild, rank, tmp2 = GetGuildInfo(unit)
			local playerGuild = GetGuildInfo("player")
			GameTooltipStatusBar:SetStatusBarColor(unpack({GameTooltip_UnitColor(unit)}))
			local a1, a2, a3, a4 = unpack(CLASS_ICON_TCOORDS[class])
			local a1, a2, a3, a4 = a1*62.5 or 0, a2*62.5 or 0, a3*62.5 or 0, a4*62.5 or 0
			local classtr = "|TInterface\\TargetingFrame\\UI-Classes-Circles:"..E.db.tooltip.textFontSize..":"..E.db.tooltip.textFontSize..":0:0:64:64:"..a1..":"..a2..":"..a3..":"..a4.."|t"
			--print(classtr)
			if guild then
				if guild:len()> 30 then guild = guild:sub(1, 30).."..." end
				GameTooltipTextLeft2:SetFormattedText("<%s>"..hex(1, 1, 1).." %s|r", guild, rank.."  ("..tmp2..")")
				if IsInGuild() and guild == playerGuild then
					GameTooltipTextLeft2:SetTextColor(pgcol[1], pgcol[2], pgcol[3])
				else
					GameTooltipTextLeft2:SetTextColor(gcol[1], gcol[2], gcol[3])
				end
			end
			local old = _G["GameTooltipTextLeft1"]:GetText()
			
			_G["GameTooltipTextLeft1"]:SetText(old.. " " ..classtr)
			
			for i=1, GameTooltip:NumLines() do
				if _G["GameTooltipTextLeft"..i]:GetText() and (_G["GameTooltipTextLeft" .. i]:GetText()==FACTION_ALLIANCE or  _G["GameTooltipTextLeft" .. i]:GetText()==FACTION_HORDE) then
					_G["GameTooltipTextLeft"..i]:SetText(nil)
					break
				end
			end
			if UnitFactionGroup(unit) and UnitFactionGroup(unit) ~= "Neutral" then
				GameTooltipTextLeft1:SetText("|TInterface\\Addons\\ElvUI_SunUI_Module\\media\\UI-PVP-"..select(1, UnitFactionGroup(unit))..".blp:16:16:0:0:64:64:5:40:0:35|t"..GameTooltipTextLeft1:GetText())
			end
		elseif ( UnitIsWildBattlePet(unit) or UnitIsBattlePetCompanion(unit) ) then
			local petLevel = UnitBattlePetLevel(unit)
			local petType = _G["BATTLE_PET_DAMAGE_NAME_"..UnitBattlePetType(unit)]
			for i=2, GameTooltip:NumLines() do
				local text = _G["GameTooltipTextLeft" .. i]:GetText()
				if text:find(LEVEL) then
					_G["GameTooltipTextLeft" .. i]:SetText(petLevel .. unitClassification .. petType)
					break
				end
			end
		else
			for i=2, GameTooltip:NumLines() do
				if _G["GameTooltipTextLeft" .. i]:GetText():find(LEVEL) or _G["GameTooltipTextLeft" .. i]:GetText():find(creatureType) then
					_G["GameTooltipTextLeft" .. i]:SetText(string.format(hex(diffColor.r, diffColor.g, diffColor.b).."%s|r", unitLevel) .. unitClassification .. creatureType)
					break
				end
			end
		end
		if (not UnitIsPlayer(unit)) then 
			local reaction = UnitReaction(unit, "player");
			if ( reaction ) then
				local r = FACTION_BAR_COLORS[reaction].r
				local g = FACTION_BAR_COLORS[reaction].g
				local b = FACTION_BAR_COLORS[reaction].b
				for i=2, GameTooltip:NumLines() do
					if _G["GameTooltipTextLeft" .. i]:GetText():find(LEVEL) or _G["GameTooltipTextLeft" .. i]:GetText():find(creatureType) then
						_G["GameTooltipTextLeft" .. i]:SetText(string.format(hex(diffColor.r, diffColor.g, diffColor.b).."%s|r", unitLevel) .. unitClassification .. creatureType .. hex(r, g, b) .."  (".. reactionlist[reaction] .. ")|r")
						break
					end
				end
				GameTooltipStatusBar:SetStatusBarColor(r, g, b)
			end
		end
		if UnitIsPVP(unit) then
			for i = 2, GameTooltip:NumLines() do
				if _G["GameTooltipTextLeft"..i]:GetText() and _G["GameTooltipTextLeft"..i]:GetText():find(PVP) then
					_G["GameTooltipTextLeft"..i]:SetText(nil)
					break
				end
			end
		end
	end
end


GameTooltip:HookScript("OnTooltipSetUnit", On_OnTooltipSetUnit)
