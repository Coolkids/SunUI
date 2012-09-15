local S, C, L, DB, _ = unpack(SunUI)
local _G = _G
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
				local skillID, isCollapsed, iconTexture, headerName, numOnline, numVisible, numPlayers, playerName, class, online, zone, skill, classFileName, isMobile = GetGuildTradeSkillInfo(button.guildIndex)
				if not headerName and playerName then
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
--[[--------------------------------------------------------------------
	CustomClassColors
	Change class colors without breaking parts of the Blizzard UI.
	Copyright (c) 2009¨C2012 Phanx <addons@phanx.net>. All rights reserved.
	See the accompanying README and LICENSE files for more information.
	http://www.wowinterface.com/downloads/info12513
	http://www.curse.com/addons/wow/classcolors
----------------------------------------------------------------------]]

local _, ns = ...
if ns.alreadyLoaded then
	return
end

local find, format, gsub, match, sub = string.find, string.format, string.gsub, string.match, string.sub
local pairs, type = pairs, type

------------------------------------------------------------------------

local addonFuncs = { }

local blizzHexColors = { }
for class, color in pairs(RAID_CLASS_COLORS) do
	blizzHexColors[color.colorStr] = class
end

------------------------------------------------------------------------
-- ChatConfigFrame.xml

do
	local function ColorLegend(self)
		for i = 1, #self.classStrings do
			local class = CLASS_SORT_ORDER[i]
			local color = RAID_CLASS_COLORS[class]
			self.classStrings[i]:SetFormattedText("|c%s%s|r\n", color.colorStr, LOCALIZED_CLASS_NAMES_MALE[class])
		end
	end
	ChatConfigChatSettingsClassColorLegend:HookScript("OnShow", ColorLegend)
	ChatConfigChannelSettingsClassColorLegend:HookScript("OnShow", ColorLegend)
end

------------------------------------------------------------------------
-- ChatFrame.lua

function GetColoredName(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12)
	local chatType = sub(event, 10)
	if sub(chatType, 1, 7) == "WHISPER" then
		chatType = "WHISPER"
	elseif sub(chatType, 1, 7) == "CHANNEL" then
		chatType = "CHANNEL"..arg8
	end

	local info = ChatTypeInfo[chatType]
	if info and info.colorNameByClass and arg12 ~= "" then
		local _, class = GetPlayerInfoByGUID(arg12)
		if class then
			local color = RAID_CLASS_COLORS[class]
			if color then
				return format("|c%s%s|r", color.colorStr, arg2)
			end
		end
	end

	return arg2
end

do
	-- Lines 3188-3208
	-- Fix class colors in raid roster listing
	local AddMessage = {}

	local function FixClassColors(frame, message, ...)
		if find(message, "|cff") then
			for hex, class in pairs(blizzHexColors) do
				local color = RAID_CLASS_COLORS[class]
				message = gsub(message, hex, color.colorStr)
			end
		end
		return AddMessage[frame](frame, message, ...)
	end

	for i = 1, NUM_CHAT_WINDOWS do
		local frame = _G["ChatFrame"..i]
		AddMessage[frame] = frame.AddMessage
		frame.AddMessage = FixClassColors
	end
end

------------------------------------------------------------------------
--	CompactUnitFrame.lua

do
	local UnitClass, UnitIsConnected = UnitClass, UnitIsConnected
	hooksecurefunc("CompactUnitFrame_UpdateHealthColor", function(frame)
		if frame.optionTable.useClassColors and UnitIsConnected(frame.unit) then
			local _, class = UnitClass(frame.unit)
			if class then
				local color = RAID_CLASS_COLORS[class]
				if color then
					local r, g, b = color.r, color.g, color.b
					frame.healthBar:SetStatusBarColor(r, g, b)
					frame.healthBar.r, frame.healthBar.g, frame.healthBar.g = r, g, b
				end
			end
		end
	end)
end
------------------------------------------------------------------------
--	LFDFrame.lua

hooksecurefunc("LFDQueueFrameRandomCooldownFrame_Update", function()
	for i = 1, GetNumSubgroupMembers() do
		local _, class = UnitClass("party"..i)
		if class then
			local color = RAID_CLASS_COLORS[class]
			if color then
				_G["LFDQueueFrameCooldownFrameName"..i]:SetFormattedText("|c%s%s|r", color.colorStr, UnitName("party"..i))
			end
		end
	end
end)

------------------------------------------------------------------------
--	LFRFrame.lua

hooksecurefunc("LFRBrowseFrameListButton_SetData", function(button, index)
	local _, _, _, _, _, _, _, class = SearchLFGGetResults(index)
	if class then
		local color = RAID_CLASS_COLORS[class]
		if color then
			button.class:SetTextColor(color.r, color.g, color.b)
		end
	end
end)

------------------------------------------------------------------------
--	LootFrame.lua

hooksecurefunc("MasterLooterFrame_UpdatePlayers", function()
	-- TODO: Find a better way of doing this... Blizzard's way is frankly quite awful,
	--       creating multiple new local tables every time the function runs. :(
	for k, playerFrame in pairs(MasterLooterFrame) do
		if type(k) == "string" and match(k, "^player%d+$") and type(playerFrame) == "table" and playerFrame.id and playerFrame.Name then
			local i = playerFrame.id
			local _, class
			if IsInRaid() then
				_, class = UnitClass("raid"..i)
			elseif i > 1 then
				_, class = UnitClass("party"..i)
			else
				_, class = UnitClass("player")
			end
			if class then
				local color = RAID_CLASS_COLORS[class]
				if color then
					playerFrame.Name:SetTextColor(color.r, color.g, color.b)
				end
			end
		end
	end
end)

------------------------------------------------------------------------
--	LootHistory.lua

hooksecurefunc("LootHistoryFrame_UpdateItemFrame", function(self, itemFrame)
	local itemID = itemFrame.itemIdx
	local rollID, _, _, done, winnerID = C_LootHistory.GetItem(itemID)
	local expanded = self.expandedRolls[rollID]
	if done and winnerID and not expanded then
		local _, class = C_LootHistory.GetPlayerInfo(itemID, winnerID)
		if class then
			local color = RAID_CLASS_COLORS[class]
			if color then
				itemFrame.WinnerName:SetVertexColor(color.r, color.g, color.b)
			end
		end
	end
end)

hooksecurefunc("LootHistoryFrame_UpdatePlayerFrame", function(self, playerFrame)
	if playerFrame.playerIdx then
		local name, class = C_LootHistory.GetPlayerInfo(playerFrame.itemIdx, playerFrame.playerIdx)
		if name then
			local color = RAID_CLASS_COLORS[class]
			if color then
				playerFrame.PlayerName:SetVertexColor(color.r, color.g, color.b)
			end
		end
	end
end)

function LootHistoryDropDown_Initialize(self)
	local info = UIDropDownMenu_CreateInfo()
	info.isTitle = 1
	info.text = MASTER_LOOTER
	info.fontObject = GameFontNormalLeft
	info.notCheckable = 1
	UIDropDownMenu_AddButton(info)

	info = UIDropDownMenu_CreateInfo()
	info.notCheckable = 1
	local name, class = C_LootHistory.GetPlayerInfo(self.itemIdx, self.playerIdx)
	local color = RAID_CLASS_COLORS[class]
	info.text = format(MASTER_LOOTER_GIVE_TO, format("|c%s%s|r", color.colorStr, name))
	info.func = LootHistoryDropDown_OnClick

	UIDropDownMenu_AddButton(info)
end

------------------------------------------------------------------------
--	PaperDollFrame.lua

hooksecurefunc("PaperDollFrame_SetLevel", function()
	local className, class = UnitClass("player")
	local color = RAID_CLASS_COLORS[class]
	if color then
		local spec = GetSpecialization()
		if spec then
			local _, spec = GetSpecializationInfo(spec)
			if specName then
				CharacterLevelText:SetFormattedText(PLAYER_LEVEL, UnitLevel("player"), color.colorStr, specName, className)
			else
				CharacterLevelText:SetFormattedText(PLAYER_LEVEL_NO_SPEC, UnitLevel("player"), color.colorStr, className)
			end
		end
	end
end)

------------------------------------------------------------------------
--	RaidFinder.lua

hooksecurefunc("RaidFinderQueueFrameCooldownFrame_Update", function()
	local prefix, members
	if IsInRaid() then
		prefix, members = "raid", GetNumGroupMembers()
	else
		prefix, members = "party", GetNumSubgroupMembers()
	end

	local cooldowns = 0
	for i = 1, members do
		local unit = prefix .. i
		if UnitHasLFGDeserter(unit) and not UnitIsUnit(unit, "player") then
			cooldowns = cooldowns + 1
			if cooldowns <= MAX_RAID_FINDER_COOLDOWN_NAMES then
				local _, class = UnitClass(unit)
				if class then
					local color = RAID_CLASS_COLORS[class]
					if color then
						_G["RaidFinderQueueFrameCooldownFrameName" .. cooldowns]:SetFormattedText("|c%s%s|r", color.colorStr, UnitName(unit))
					end
				end
			end
		end
	end
end)

------------------------------------------------------------------------
--	RaidWarning.lua

do
	local AddMessage = RaidNotice_AddMessage
	RaidNotice_AddMessage = function(frame, message, ...)
		if find(message, "|cff") then
			for hex, class in pairs(blizzHexColors) do
				local color = RAID_CLASS_COLORS[class]
				message = gsub(message, hex, color.colorStr)
			end
		end
		return AddMessage(frame, message, ...)
	end
end

------------------------------------------------------------------------
--	Blizzard_Calendar.lua

addonFuncs["Blizzard_Calendar"] = function()
	local CalendarViewEventInviteListScrollFrame, CalendarCreateEventInviteListScrollFrame = CalendarViewEventInviteListScrollFrame, CalendarCreateEventInviteListScrollFrame
	local HybridScrollFrame_GetOffset = HybridScrollFrame_GetOffset
	local CalendarEventGetNumInvites, CalendarEventGetInvite = CalendarEventGetNumInvites, CalendarEventGetInvite

	hooksecurefunc("CalendarViewEventInviteListScrollFrame_Update", function()
		local _, namesReady = CalendarEventGetNumInvites()
		if not namesReady then return end

		local buttons = CalendarViewEventInviteListScrollFrame.buttons
		local offset = HybridScrollFrame_GetOffset(CalendarViewEventInviteListScrollFrame)
		for i = 1, #buttons do
			local _, _, _, class = CalendarEventGetInvite(i + offset)
			if class then
				local color = RAID_CLASS_COLORS[class]
				if color then
					local buttonName = buttons[i]:GetName()
					_G[buttonName.."Name"]:SetTextColor(color.r, color.g, color.b)
					_G[buttonName.."Class"]:SetTextColor(color.r, color.g, color.b)
				end
			end
		end
	end)

	hooksecurefunc("CalendarCreateEventInviteListScrollFrame_Update", function()
		local _, namesReady = CalendarEventGetNumInvites()
		if not namesReady then return end

		local buttons = CalendarCreateEventInviteListScrollFrame.buttons
		local offset = HybridScrollFrame_GetOffset(CalendarCreateEventInviteListScrollFrame)
		for i = 1, #buttons do
			local _, _, _, class = CalendarEventGetInvite(i + offset)
			if class then
				local color = RAID_CLASS_COLORS[class]
				if color then
					local buttonName = buttons[i]:GetName()
					_G[buttonName.."Name"]:SetTextColor(color.r, color.g, color.b)
					_G[buttonName.."Class"]:SetTextColor(color.r, color.g, color.b)
				end
			end
		end
	end)
end

------------------------------------------------------------------------
--	Blizzard_ChallengesUI.lua

addonFuncs["Blizzard_ChallengesUI"] = function()
	local F_PLAYER_CLASS = "%s - " .. PLAYER_CLASS
	local F_PLAYER_CLASS_NO_SPEC = "%s - " .. PLAYER_CLASS_NO_SPEC

	local ChallengesFrame = ChallengesFrame
	local GetChallengeBestTimeInfo, GetChallengeBestTimeNum, GetSpecializationInfoByID = GetChallengeBestTimeInfo, GetChallengeBestTimeNum, GetSpecializationInfoByID

	local gameTooltipTextLeft = setmetatable({}, { __index = function(t, i)
		local obj = _G["GameTooltipTextLeft"..i]
		if obj then
			rawset(t, i, obj)
		end
		return obj
	end })

	hooksecurefunc("ChallengesFrameGuild_OnEnter", function(self)
		local guildTime = ChallengesFrame.details.GuildTime
		if not guildTime.hasTime then return end

		for i = 1, GetChallengeBestTimeNum(guildTime.mapID, true) do
			local name, className, class, specID = GetChallengeBestTimeInfo(guildTime.mapID, i, true)
			if class then
				local color = RAID_CLASS_COLORS[class].colorStr
				if color then
					local _, specName = GetSpecializationInfoByID(specID)
					if specName and specName ~= "" then
						gameTooltipTextLeft[i+1]:SetFormattedText(F_PLAYER_CLASS, name, color, specName, className)
					else
						gameTooltipTextLeft[i+1]:SetFormattedText(F_PLAYER_CLASS_NO_SPEC, name, color, className)
					end
				end
			end
		end
	end)

	hooksecurefunc("ChallengesFrameRealm_OnEnter", function(self)
		local realmTime = ChallengesFrame.details.RealmTime
		if not realmTime.hasTime then return end

		for i = 1, GetChallengeBestTimeNum(realmTime.mapID, false) do
			local name, className, class, specID = GetChallengeBestTimeInfo(realmTime.mapID, i, false)
			if class then
				local color = RAID_CLASS_COLORS[class].colorStr
				if color then
					local _, specName = GetSpecializationInfoByID(specID)
					if specName and specName ~= "" then
						gameTooltipTextLeft[i+1]:SetFormattedText(F_PLAYER_CLASS, name, color, specName, className)
					else
						gameTooltipTextLeft[i+1]:SetFormattedText(F_PLAYER_CLASS_NO_SPEC, name, color, className)
					end
				end
			end
		end
	end)
end

------------------------------------------------------------------------
--	Blizzard_GuildRoster.lua

addonFuncs["Blizzard_GuildUI"] = function()
	hooksecurefunc("GuildRosterButton_SetStringText", function(buttonString, text, isOnline, class)
		if isOnline and class then
			local color = RAID_CLASS_COLORS[class]
			if color then
				buttonString:SetTextColor(color.r, color.g, color.b)
			end
		end
	end)
end

------------------------------------------------------------------------
--	InspectPaperDollFrame.lua

addonFuncs["Blizzard_InspectUI"] = function()
	local InspectFrame, InspectLevelText = InspectFrame, InspectLevelText
	local GetSpecialization, GetSpecializationInfo, UnitClass, UnitLevel = GetSpecialization, GetSpecializationInfo, UnitClass, UnitLevel

	hooksecurefunc("InspectPaperDollFrame_SetLevel", function()
		local unit = InspectFrame.unit
		if not unit then return end

		local className, class = UnitClass(unit)
		if class then
			local color = RAID_CLASS_COLORS[class]
			if color then
				local level = UnitLevel(unit)
				if level == -1 then
					level = "??"
				end
				local spec, specName, _ = GetSpecialization(true)
				if spec then
					_, specName = GetSpecializationInfo(spec, true)
				end
				if specName and specName ~= "" then
					InspectLevelText:SetFormattedText(PLAYER_LEVEL, level, color.colorStr, specName, className)
				else
					InspectLevelText:SetFormattedText(PLAYER_LEVEL_NO_SPEC, level, color.colorStr, className)
				end
			end
		end
	end)
end

------------------------------------------------------------------------
--	Blizzard_RaidUI.lua

addonFuncs["Blizzard_RaidUI"] = function()
	local min = math.min
	local GetNumGroupMembers, GetRaidRosterInfo, IsInRaid, UnitCanCooperate, UnitClass = GetNumGroupMembers, GetRaidRosterInfo, IsInRaid, UnitCanCooperate, UnitClass
	local MAX_RAID_MEMBERS, MEMBERS_PER_RAID_GROUP = MAX_RAID_MEMBERS, MEMBERS_PER_RAID_GROUP

	local raidGroup = setmetatable({}, { __index = function(t, i)
		local obj = _G["RaidGroup"..i]
		if obj then
			rawset(t, i, obj)
		end
		return obj
	end })
	local raidGroupButton = setmetatable({}, { __index = function(t, i)
		local obj = _G["RaidGroupButton"..i]
		if obj then
			rawset(t, i, obj)
		end
		return obj
	end })
	hooksecurefunc("RaidGroupFrame_Update", function()
		local isRaid = IsInRaid()
		if not isRaid then return end
		for i = 1, min(GetNumGroupMembers(), MAX_RAID_MEMBERS) do
			local name, _, subgroup, _, _, class, _, online, dead = GetRaidRosterInfo(i)
			if class and online and not dead and raidGroup[subgroup].nextIndex <= MEMBERS_PER_RAID_GROUP then
				local color = RAID_CLASS_COLORS[class]
				if color then
					local button = raidGroupButton[i]
					button.subframes.name:SetTextColor(color.r, color.g, color.b)
					button.subframes.class:SetTextColor(color.r, color.g, color.b)
					button.subframes.level:SetTextColor(color.r, color.g, color.b)
				end
			end
		end
	end)

	local raidGroupButtonName = setmetatable({}, { __index = function(t, i)
		local obj = _G["RaidGroupButton"..i.."Name"]
		if obj then
			rawset(t, i, obj)
		end
		return obj
	end })
	local raidGroupButtonClass = setmetatable({}, { __index = function(t, i)
		local obj = _G["RaidGroupButton"..i.."Class"]
		if obj then
			rawset(t, i, obj)
		end
		return obj
	end })
	local raidGroupButtonLevel = setmetatable({}, { __index = function(t, i)
		local obj = _G["RaidGroupButton"..i.."Level"]
		if obj then
			rawset(t, i, obj)
		end
		return obj
	end })
	hooksecurefunc("RaidGroupFrame_UpdateHealth", function(id)
		local _, _, _, _, _, class, _, online, dead = GetRaidRosterInfo(id)
		if class and online and not dead then
			local color = RAID_CLASS_COLORS[class]
			if color then
				local r, g, b = color.r, color.g, color.b
				raidGroupButtonName[id]:SetTextColor(r, g, b)
				raidGroupButtonClass[id]:SetTextColor(r, g, b)
				raidGroupButtonLevel[id]:SetTextColor(r, g, b)
			end
		end
	end)

	hooksecurefunc("RaidPullout_UpdateTarget", function(frame, button, unit, which)
		if UnitCanCooperate("player", unit) then
			frame = _G[frame]
			if frame["show"..which] then
				local _, class = UnitClass(unit)
				if class then
					local color = class and RAID_CLASS_COLORS[class]
					if color then
						_G[button..which.."Name"]:SetTextColor(color.r, color.g, color.b)
					end
				end
			end
		end
	end)

	local petowners = {}
	for i = 1, 40 do
		petowners["raidpet"..i] = "raid"..i
	end
	hooksecurefunc("RaidPulloutButton_UpdateDead", function(button, dead, class)
		if not dead then
			if class == "PETS" then
				local _
				_, class = UnitClass(petowners[button.unit])
			end
			if class then
				local color = RAID_CLASS_COLORS[class]
				if color then
					button.nameLabel:SetVertexColor(color.r, color.g, color.b)
				end
			end
		end
	end)
end

------------------------------------------------------------------------
--	Blizzard_TradeSkillUI.lua

addonFuncs["Blizzard_TradeSkillUI"] = function()
	local TRADE_SKILL_GUILD_CRAFTERS_DISPLAYED = TRADE_SKILL_GUILD_CRAFTERS_DISPLAYED
	local FauxScrollFrame_GetOffset, TradeSkillGuildCraftersFrame = FauxScrollFrame_GetOffset, TradeSkillGuildCraftersFrame
	local GetGuildRecipeInfoPostQuery, GetGuildRecipeMember = GetGuildRecipeInfoPostQuery, GetGuildRecipeMember

	hooksecurefunc("TradeSkillGuilCraftersFrame_Update", function()
		local _, _, numMembers = GetGuildRecipeInfoPostQuery()
		local offset = FauxScrollFrame_GetOffset(TradeSkillGuildCraftersFrame)
		for i = 1, TRADE_SKILL_GUILD_CRAFTERS_DISPLAYED do
			if i > numMembers then
				break
			end
			local _, class, online = GetGuildRecipeMember(i + offset)
			if class and online then
				local color = RAID_CLASS_COLORS[class]
				if color then
					_G["TradeSkillGuildCrafter"..i.."Text"]:SetTextColor(color.r, color.g, color.b)
				end
			end
		end
	end)
end

------------------------------------------------------------------------

local numAddons = 0

for addon, func in pairs(addonFuncs) do
	if IsAddOnLoaded(addon) then
		addonFuncs[addon] = nil
		func()
	else
		numAddons = numAddons + 1
	end
end

if numAddons > 0 then
	local f = CreateFrame("Frame")
	f:RegisterEvent("ADDON_LOADED")
	f:SetScript("OnEvent", function(self, event, addon)
		local func = addonFuncs[addon]
		if func then
			addonFuncs[addon] = nil
			numAddons = numAddons - 1
			func()
		end
		if numAddons == 0 then
			self:UnregisterEvent("ADDON_LOADED")
			self:SetScript("OnEvent", nil)
		end
	end)
end

local format = format
local pairs = pairs
local print = print
local table = table
local tostring = tostring
local type = type

local GRAY_FONT_COLOR_CODE = GRAY_FONT_COLOR_CODE
local GREEN_FONT_COLOR_CODE = GREEN_FONT_COLOR_CODE
local ORANGE_FONT_COLOR_CODE = ORANGE_FONT_COLOR_CODE
local RED_FONT_COLOR_CODE = RED_FONT_COLOR_CODE
local YELLOW_FONT_COLOR_CODE = YELLOW_FONT_COLOR_CODE

local FONT_COLOR_CODE_CLOSE = FONT_COLOR_CODE_CLOSE
local FRIENDS_BUTTON_TYPE_BNET = FRIENDS_BUTTON_TYPE_BNET
local FRIENDS_BUTTON_TYPE_WOW = FRIENDS_BUTTON_TYPE_WOW
local FRIENDS_FRIENDS_TO_DISPLAY = FRIENDS_FRIENDS_TO_DISPLAY
local LEVEL = LEVEL

local FriendsFrameFriendsScrollFrameScrollBar = FriendsFrameFriendsScrollFrameScrollBar
local FriendsListColorsDB = FriendsListColorsDB
local FriendsList_Update = FriendsList_Update
local GetFriendInfo = GetFriendInfo
local hooksecurefunc = hooksecurefunc
local UnitLevel = UnitLevel

local realIdColor = format("%02x%02x%02x", FRIENDS_BNET_NAME_COLOR.r*255, FRIENDS_BNET_NAME_COLOR.g*255, FRIENDS_BNET_NAME_COLOR.b*255)

-- create addon frame (hidden) and declare default variables
local addonName = ...
local f, cfg, db = CreateFrame("Frame"), {
  name="FriendsListColors",
  sname="FLC",
  slash={"/flc", "/friendslistcolors"},
  syntaxes={
    {"N", "C", "L", "Z", "S", "O"},
    {"NC", "CC", "LC", "ZC", "SC", "OC"},
    {"ND", "CD", "LD", "ZD", "SD", "OD"},
    {"Name", "Class", "Level", "Zone", "AFK/DNS", "Note"},
  },
  ccolors={},
  gray=GRAY_FONT_COLOR_CODE:sub(5),
  dummy={"Vladinator", "Druid", 85, "Good tank", "Stormwind City"},
  -- default configuration values if unconfigured
  defaults={
    syntax="$NC, {D!LEVEL} $LD $C", -- "Name, Level 80, Shaman" where name is  by class, level is colored by difficulty and class without specific color
  },
}
-- populate ccolors table
for k, v in pairs(RAID_CLASS_COLORS)do cfg.ccolors[k] = (v.colorStr or format("ff%02x%02x%02x", v.r*255, v.g*255, v.b*255)):sub(3) end

-- localized classes, i.e. locclasses["Magier"] returns "Mage"
local locclasses = {}
for k,v in pairs(LOCALIZED_CLASS_NAMES_MALE)do locclasses[v] = k end
for k,v in pairs(LOCALIZED_CLASS_NAMES_FEMALE)do locclasses[v] = k end

-- output
local function out(msg)
  print(format("|cff00ffff%s|r: %s", cfg.sname, tostring(msg)))
end

-- returns hex color (xxyyzz) using player level and an argument as "target level"
local getDiff = function(tar)
  --if type(tar) == "string" then return end
  local diff, col = tar - UnitLevel("player")
  if diff > 4 then
    col = RED_FONT_COLOR_CODE
  elseif diff > 2 then
    col = ORANGE_FONT_COLOR_CODE -- need more orange, this is like /emote
  elseif diff >= 0 then
    col = YELLOW_FONT_COLOR_CODE
  elseif diff >= -4 then
    col = GREEN_FONT_COLOR_CODE -- too bright green
  else
    col = GRAY_FONT_COLOR_CODE
  end
  return col:sub(0,4) == "|cff" and col:sub(5) or col -- remove "|cff" if present (don't know what will happen in the future with these constants)
end

-- format entries by special syntax I've defined for this addon
local form = function(str, ...) -- ... = 1:name, 2:class, 3:level, 4:zone, 5:status, 6:note
  if type(str) ~= "string" or str:len() == 0 then
    return "Fatal error in "..cfg.sname..", what have you done?" -- something fatal happen, oh no!
  end
  local values, code = {...}
  if #values > 0 then
    local dcolor = getDiff(values[3] or 0) -- with fallback value
    local ccolor = cfg.ccolors[(locclasses[values[2] or ""] or ""):gsub(" ",""):upper()] or cfg.gray -- with fallback value
    local syntaxes = cfg.syntaxes
    -- handle double chars like $XY
    for code in str:gmatch("%$%u%u") do
      -- color by class
      for k,v in pairs(syntaxes[2]) do
        if code == "$"..v then
          str = str:gsub(code, format("|cff%s%s%s", ccolor, values[k] or "", FONT_COLOR_CODE_CLOSE))
          break
        end
      end
      -- color by difficulty
      for k,v in pairs(syntaxes[3]) do
        if code == "$"..v then
          str = str:gsub(code, format("|cff%s%s%s", dcolor, values[k] or "", FONT_COLOR_CODE_CLOSE))
          break
        end
      end
    end
    -- handle single chars like $X
    for code in str:gmatch("%$%u") do
      for k,v in pairs(syntaxes[1]) do
        if code == "$"..v then
          str = str:gsub(code, format("|cff%s%s%s", ccolor, values[k] or "", FONT_COLOR_CODE_CLOSE))
          break
        end
      end
    end
    -- global variables {!LEVEL} becomes "Level" localized or just pure string if it's not found in _G
    for code in str:gmatch("%{%!(.+)%}") do
      str = str:gsub("%{%!"..code.."%}", _G[code] and tostring(_G[code]) or code)
    end
    -- global variables {X!LEVEL} (where X is C or D) becomes "Level" localized or just pure string if it's not found in _G. it's also colored by class or difficulty color
    for code1, code2 in str:gmatch("%{(%u)%!(.+)%}") do
      if code1 == "C" then
        str = str:gsub("%{"..code1.."%!"..code2.."%}", format("|cff%s%s%s", ccolor, _G[code2] and tostring(_G[code2]) or code2, FONT_COLOR_CODE_CLOSE))
      elseif code1 == "D" then
        str = str:gsub("%{"..code1.."%!"..code2.."%}", format("|cff%s%s%s", dcolor, _G[code2] and tostring(_G[code2]) or code2, FONT_COLOR_CODE_CLOSE))
      else
        str = str:gsub("%{"..code1.."%!"..code2.."%}", _G[code2] and tostring(_G[code2]) or code2) -- fallback, no coloring
      end
    end
  end
  return str
end

-- function will be referenced by the hook on the bottom and called when the friend list is updated by scrolling or the event is fired to update it
local updFunc = function()
  for index = 1, FRIENDS_FRIENDS_TO_DISPLAY do
    local friend = _G["FriendsFrameFriendsScrollFrameButton"..index]
    if friend and (friend.buttonType == FRIENDS_BUTTON_TYPE_BNET or friend.buttonType == FRIENDS_BUTTON_TYPE_WOW) and type(friend.id) == "number" then
      if friend.buttonType == FRIENDS_BUTTON_TYPE_BNET then
        local _, realName, _, _, _, _, client, connected, _, status1, status2, _, note, _, _ = BNGetFriendInfo(friend.id)
        if connected and client == BNET_CLIENT_WOW then
          if BNGetNumFriendToons(friend.id) > 0 then -- at logout this prevents errors, since the friend is online but without a toon when they logout
            _, name, client, _, _, _, _, class, _, zone, level, _, _, _, _, _ = BNGetFriendToonInfo(friend.id, 1)
            if name then
              if status1 then
                status = "<"..AFK..">"
              elseif status2 then
                status = "<"..DND..">"
              else
                status = ""
              end
              friend.name:SetText("|cff"..realIdColor..realName.."|r "..form(db.syntax, name, class, level, zone or "", status or "", ""))
              friend.name:SetTextColor(FRIENDS_WOW_NAME_COLOR.r, FRIENDS_WOW_NAME_COLOR.g, FRIENDS_WOW_NAME_COLOR.b)
            end
          end
        elseif not connected then -- append note at the end, like normal friends are shown when offline
          friend.name:SetText(realName.." "..form("$N |cffCCCCCC$O|r", "", "", 0, "", "", note or ""))
          friend.name:SetTextColor(FRIENDS_GRAY_COLOR.r, FRIENDS_GRAY_COLOR.g, FRIENDS_GRAY_COLOR.b)
        end
      else
        local name, level, class, zone, connected, status, note = GetFriendInfo(friend.id)
        if name then
          if connected then
            friend.name:SetText(form(db.syntax, name, class, level, zone or "", status or "", note or ""))
          else
            friend.name:SetText(form("$N |cffCCCCCC$O|r", name, class, level, zone or "", status or "", note or ""))
          end
        end
      end
    end
  end
end
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == cfg.name or addon == addonName then -- support loading when embedded
		FriendsListColorsDB = FriendsListColorsDB or cfg.defaults
		db = FriendsListColorsDB
		hooksecurefunc("FriendsList_Update", updFunc);
		hooksecurefunc("HybridScrollFrame_Update", updFunc);
	end
end)