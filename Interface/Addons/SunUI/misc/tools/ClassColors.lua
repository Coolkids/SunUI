local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
if (IsAddOnLoaded("yClassColor")) then return end

----------------------------------------------------------------------------------------
--	Class color guild/friends/etc list(yClassColor by yleaf)
----------------------------------------------------------------------------------------
local GUILD_INDEX_MAX = 12
local SMOOTH = {1, 0, 0, 1, 1, 0, 0, 1, 0}
local myName = UnitName("player")
local BC = {}
for k, v in pairs(LOCALIZED_CLASS_NAMES_MALE) do
	BC[v] = k
end
for k, v in pairs(LOCALIZED_CLASS_NAMES_FEMALE) do
	BC[v] = k
end
local RAID_CLASS_COLORS = RAID_CLASS_COLORS
local WHITE_HEX = "|cffffffff"

local function Hex(r, g, b)
	if type(r) == "table" then
		if (r.r) then r, g, b = r.r, r.g, r.b else r, g, b = unpack(r) end
	end

	if not r or not g or not b then
		r, g, b = 1, 1, 1
	end

	return format("|cff%02x%02x%02x", r * 255, g * 255, b * 255)
end

local function ColorGradient(perc, ...)
	if perc >= 1 then
		local r, g, b = select(select("#", ...) - 2, ...)
		return r, g, b
	elseif perc <= 0 then
		local r, g, b = ...
		return r, g, b
	end

	local num = select("#", ...) / 3

	local segment, relperc = math.modf(perc * (num - 1))
	local r1, g1, b1, r2, g2, b2 = select((segment * 3) + 1, ...)

	return r1 + (r2 - r1) * relperc, g1 + (g2 - g1) * relperc, b1 + (b2 - b1) * relperc
end

local guildRankColor = setmetatable({}, {
	__index = function(t, i)
		if i then
			local c = Hex(ColorGradient(i / GUILD_INDEX_MAX, unpack(SMOOTH)))
			if c then
				t[i] = c
				return c
			else
				t[i] = t[0]
			end
		end
	end
})
guildRankColor[0] = WHITE_HEX

local diffColor = setmetatable({}, {
	__index = function(t, i)
		local c = i and GetQuestDifficultyColor(i)
		t[i] = c and Hex(c) or t[0]
		return t[i]
	end
})
diffColor[0] = WHITE_HEX

local classColor = setmetatable({}, {
	__index = function(t, i)
		local c = i and RAID_CLASS_COLORS[BC[i] or i]
		if c then
			t[i] = Hex(c)
			return t[i]
		else
			return WHITE_HEX
		end
	end
})

local WHITE = {1, 1, 1}
local classColorRaw = setmetatable({}, {
	__index = function(t, i)
		local c = i and RAID_CLASS_COLORS[BC[i] or i]
		if not c then return WHITE end
		t[i] = c
		return c
	end
})

-- WhoList
hooksecurefunc("WhoList_Update", function()
	local whoOffset = FauxScrollFrame_GetOffset(WhoListScrollFrame)

	local playerZone = GetRealZoneText()
	local playerGuild = GetGuildInfo("player")
	local playerRace = UnitRace("player")

	for i = 1, WHOS_TO_DISPLAY, 1 do
		local index = whoOffset + i
		local nameText = getglobal("WhoFrameButton"..i.."Name")
		local levelText = getglobal("WhoFrameButton"..i.."Level")
		local classText = getglobal("WhoFrameButton"..i.."Class")
		local variableText = getglobal("WhoFrameButton"..i.."Variable")

		local name, guild, level, race, class, zone, classFileName = GetWhoInfo(index)
		if name then
			if zone == playerZone then
				zone = "|cff00ff00"..zone
			end
			if guild == playerGuild then
				guild = "|cff00ff00"..guild
			end
			if race == playerRace then
				race = "|cff00ff00"..race
			end
			local columnTable = {zone, guild, race}

			local c = classColorRaw[classFileName]
			nameText:SetTextColor(c.r, c.g, c.b)
			levelText:SetText(diffColor[level]..level)
			variableText:SetText(columnTable[UIDropDownMenu_GetSelectedID(WhoFrameDropDown)])
		end
	end
end)

-- LFRBrowseList
hooksecurefunc("LFRBrowseFrameListButton_SetData", function(button, index)
	local name, level, areaName, className, comment, partyMembers, status, class, encountersTotal, encountersComplete, isLeader, isTank, isHealer, isDamage = SearchLFGGetResults(index)

	if index and class and name and level and (name ~= myName) then
		button.name:SetText(classColor[class]..name)
		button.class:SetText(classColor[class]..className)
		button.level:SetText(diffColor[level]..level)
	end
end)

-- WorldStateScoreList
hooksecurefunc("WorldStateScoreFrame_Update", function()
	local inArena = IsActiveBattlefieldArena()
	local offset = FauxScrollFrame_GetOffset(WorldStateScoreScrollFrame)

	for i = 1, MAX_WORLDSTATE_SCORE_BUTTONS do
		local index = offset + i
		local name, killingBlows, honorableKills, deaths, honorGained, faction, rank, race, class, classToken, damageDone, healingDone = GetBattlefieldScore(index)
		if name then
			local n, r = strsplit("-", name, 2)
			n = classColor[class]..n.."|r"

			if name == myName then
				n = ">>> "..n.." <<<"
			end

			if r then
				local color
				if inArena then
					if faction == 1 then
						color = "|cffffd100"
					else
						color = "|cff19ff19"
					end
				else
					if faction == 1 then
						color = "|cff00adf0"
					else
						color = "|cffff1919"
					end
				end
				r = color..r.."|r"
				n = n.."|cffffffff - |r"..r
			end

			local button = _G["WorldStateScoreButton"..i]
			button.name.text:SetText(n)
		end
	end
end)

local _VIEW

local function viewChanged(view)
	_VIEW = view
end

-- GuildList
local function update()
	_VIEW = _VIEW or GetCVar("guildRosterView")
	local playerArea = GetRealZoneText()
	local buttons = GuildRosterContainer.buttons

	for i, button in ipairs(buttons) do
		if button:IsShown() and button.online and button.guildIndex then
			if _VIEW == "tradeskill" then
				local skillID, isCollapsed, iconTexture, headerName, numOnline, numVisible, numPlayers, playerDisplayName, playerFullName, class, online, zone, skill, classFileName, isMobile = GetGuildTradeSkillInfo(button.guildIndex)
				if not headerName and playerDisplayName then
					local c = classColorRaw[classFileName]
					button.string1:SetTextColor(c.r, c.g, c.b)
					if zone == playerArea then
						button.string2:SetText("|cff00ff00"..zone)
					end
				end
			else
				local name, rank, rankIndex, level, class, zone, note, officernote, online, status, classFileName, achievementPnts, achievementRank, isMobile = GetGuildRosterInfo(button.guildIndex)
				local displayedName = classColor[classFileName]..name
				if _VIEW == "playerStatus" then
					button.string1:SetText(diffColor[level]..level)
					button.string2:SetText(displayedName)
					if zone == playerArea then
						button.string3:SetText("|cff00ff00"..zone)
					end
				elseif _VIEW == "guildStatus" then
					button.string1:SetText(displayedName)
					if rankIndex and rank then
						button.string2:SetText(guildRankColor[rankIndex]..rank)
					end
				elseif _VIEW == "achievement" then
					button.string1:SetText(diffColor[level]..level)
					if classFileName and name then
						button.string2:SetText(displayedName)
					end
				elseif _VIEW == "weeklyxp" or _VIEW == "totalxp" then
					button.string1:SetText(diffColor[level]..level)
					button.string2:SetText(displayedName)
				end
			end
		end
	end
end

local loaded = false
hooksecurefunc("GuildFrame_LoadUI", function()
	if loaded then
		return
	else
		loaded = true
		hooksecurefunc("GuildRoster_SetView", viewChanged)
		hooksecurefunc("GuildRoster_Update", update)
		hooksecurefunc(GuildRosterContainer, "update", update)
	end
end)

-- FriendsList
local WHITE = {r = 1, g = 1, b = 1}
local FRIENDS_LEVEL_TEMPLATE = FRIENDS_LEVEL_TEMPLATE:gsub("%%d", "%%s")
FRIENDS_LEVEL_TEMPLATE = FRIENDS_LEVEL_TEMPLATE:gsub("%$d", "%$s")
local function friendsFrame()
	local scrollFrame = FriendsFrameFriendsScrollFrame
	local offset = HybridScrollFrame_GetOffset(scrollFrame)
	local buttons = scrollFrame.buttons

	local playerArea = GetRealZoneText()

	for i = 1, #buttons do
		local nameText, infoText
		button = buttons[i]
		index = offset + i
		if button:IsShown() then
			if button.buttonType == FRIENDS_BUTTON_TYPE_WOW then
				local name, level, class, area, connected, status, note = GetFriendInfo(button.id)
				if connected then
					nameText = classColor[class]..name.."|r, "..format(FRIENDS_LEVEL_TEMPLATE, diffColor[level]..level.."|r", class)
					if areaName == playerArea then
						infoText = format("|cff00ff00%s|r", area)
					end
				end
			elseif button.buttonType == FRIENDS_BUTTON_TYPE_BNET then
				local _, givenName, surname, toonName, toonID, client, isOnline, _, _, _, _, _, _, _ = BNGetFriendInfo(button.id)
				if isOnline and client == BNET_CLIENT_WOW then
					local _, toonName, client, _, _, _, _, class, _, zoneName, level, _ = BNGetGameAccountInfo(toonID)
					if givenName and surname and toonName and class then
						nameText = format(BATTLENET_NAME_FORMAT, givenName, surname).." "..FRIENDS_WOW_NAME_COLOR_CODE.."("..classColor[class]..classColor[class]..toonName..FRIENDS_WOW_NAME_COLOR_CODE..")"
						if zoneName == playerArea then
							infoText = format("|cff00ff00%s|r", zoneName)
						end
					end
				end
			end
		end

		if nameText then
			button.name:SetText(nameText)
		end
		if infoText then
			button.info:SetText(infoText)
		end
	end
end
hooksecurefunc(FriendsFrameFriendsScrollFrame, "update", friendsFrame)
hooksecurefunc("FriendsFrame_UpdateFriends", friendsFrame)