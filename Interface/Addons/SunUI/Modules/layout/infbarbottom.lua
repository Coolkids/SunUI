local S, C, L, DB, _ = unpack(select(2, ...))
local Core = LibStub("AceAddon-3.0"):GetAddon("SunUI")
local Module = Core:NewModule("InfoPanelBottom")

local function BuildClock()
	local Clock = CreateFrame("Frame", "InfoPanelBottom1", BottomInfoPanel)
	Clock.Text = S.MakeFontString(Clock)
	Clock.Text:SetTextColor(DB.MyClassColor.r,DB.MyClassColor.g,DB.MyClassColor.b)
	Clock.Text:SetShadowColor(0, 0, 0)
	Clock.Text:SetShadowOffset(S.mult, -S.mult)
	Clock.Text:SetPoint("LEFT", BottomInfoPanel, "LEFT", 10, 2)
	Clock.Text:SetShadowOffset(S.mult, -S.mult)
	Clock.Text:SetShadowColor(0, 0, 0, 0.4)
	Clock:SetAllPoints(Clock.Text)
	Clock:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
		GameTooltip:ClearLines()
		GameTooltip:AddLine(date"%A, %B %d", 0.40, 0.78, 1)
		GameTooltip:AddLine(" ")
		GameTooltip:AddDoubleLine(TIMEMANAGER_TOOLTIP_LOCALTIME, GameTime_GetLocalTime(true), 0.75, 0.9, 1, 1, 1, 1)
		GameTooltip:AddDoubleLine(TIMEMANAGER_TOOLTIP_REALMTIME, GameTime_GetGameTime(true), 0.75, 0.9, 1, 1, 1, 1)
		GameTooltip:AddLine(" ")
		for i = 1, 2 do
			local _, localizedName, isActive, _, startTime, _ = GetWorldPVPAreaInfo(i)
			GameTooltip:AddDoubleLine(format(localizedName, ""), isActive and WINTERGRASP_IN_PROGRESS or startTime==0 and "N/A" or S.FormatTime(startTime), 0.75, 0.9, 1, 1, 1, 1)
		end
		local oneraid = false
			for i = 1, GetNumSavedInstances() do
				local name, _, reset, difficulty, locked, extended, _, isRaid, maxPlayers = GetSavedInstanceInfo(i)
				if isRaid and (locked or extended) then
					local tr, tg, tb, diff
					if not oneraid then
						GameTooltip:AddLine(" ")
						GameTooltip:AddLine(RAID_INFO, 0.75, 0.9, 1)
						oneraid = true
					end
					if extended then tr, tg, tb = 0.3, 1, 0.3 else tr, tg, tb = 1, 1, 1 end
					if difficulty == 3 or difficulty == 4 then diff = "H" else diff = "N" end
					GameTooltip:AddDoubleLine(format("%s |cffaaaaaa(%s%s)", name, maxPlayers, diff), S.FormatTime(reset), 1, 1, 1, tr, tg, tb)
				end
			end	
		GameTooltip:Show()
	end)
	Clock:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	Clock:SetScript("OnMouseDown", function(self, button)
		if button == "LeftButton" then
			ToggleTimeManager()
		elseif button == "RightButton" then
			ToggleCalendar()
		end
	end)
	Clock.Timer = 0
	Clock:SetScript("OnUpdate", function(self, elapsed)
		self.Timer = self.Timer + elapsed
		if self.Timer > 1 then
			self.Timer = 0
			local Text = GameTime_GetLocalTime(true)
			local index = Text:find(":")
			self.Text:SetText(Text:sub(index-2, index-1).." : "..Text:sub(index+1, index+2))
		end
	end)
	RequestRaidInfo()
end

local function BuildFriend()
	if C["InfoPanelDB"]["Friend"] ~= true then return end
	StaticPopupDialogs.SET_BN_BROADCAST = {
		text = BN_BROADCAST_TOOLTIP,
		button1 = ACCEPT,
		button2 = CANCEL,
		hasEditBox = 1,
		editBoxWidth = 350,
		maxLetters = 127,
		OnAccept = function(self) BNSetCustomMessage(self.editBox:GetText()) end,
		OnShow = function(self) self.editBox:SetText(select(3, BNGetInfo()) ) self.editBox:SetFocus() end,
		OnHide = ChatEdit_FocusActiveWindow,
		EditBoxOnEnterPressed = function(self) BNSetCustomMessage(self:GetText()) self:GetParent():Hide() end,
		EditBoxOnEscapePressed = function(self) self:GetParent():Hide() end,
		timeout = 0,
		exclusive = 1,
		whileDead = 1,
		hideOnEscape = 1
	}
	local classc = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[select(2,UnitClass('player'))] 
	-- localized references for global functions (about 50% faster)
	local join 			= string.join
	local find			= string.find
	local format		= string.format
	local sort			= table.sort

	local Stat = CreateFrame("Frame", "InfoPanelBottom2", BottomInfoPanel)
	Stat:EnableMouse(true)

	local Text  = S.MakeFontString(Stat)
	Text:SetTextColor(DB.MyClassColor.r,DB.MyClassColor.g,DB.MyClassColor.b)
	Text:SetShadowOffset(S.mult, -S.mult)
	Text:SetShadowColor(0, 0, 0, 0.4)
	Text:SetPoint("LEFT", InfoPanelBottom1, "RIGHT", 3, 0)
	Stat:SetAllPoints(Text)

	local menuFrame = CreateFrame("Frame", "FriendRightClickMenu", UIParent, "UIDropDownMenuTemplate")
	local menuList = {
		{ text = OPTIONS_MENU, isTitle = true,notCheckable=true},
		{ text = INVITE, hasArrow = true,notCheckable=true, },
		{ text = CHAT_MSG_WHISPER_INFORM, hasArrow = true,notCheckable=true, },
		{ text = PLAYER_STATUS, hasArrow = true, notCheckable=true,
			menuList = {
				{ text = "|cff2BC226"..AVAILABLE.."|r", notCheckable=true, func = function() if IsChatAFK() then SendChatMessage("", "AFK") elseif IsChatDND() then SendChatMessage("", "DND") end end },
				{ text = "|cffE7E716"..DND.."|r", notCheckable=true, func = function() if not IsChatDND() then SendChatMessage("", "DND") end end },
				{ text = "|cffFF0000"..AFK.."|r", notCheckable=true, func = function() if not IsChatAFK() then SendChatMessage("", "AFK") end end },
			},
		},
		{ text = BN_BROADCAST_TOOLTIP, notCheckable=true, func = function() StaticPopup_Show("SET_BN_BROADCAST") end },
	}

	local function inviteClick(self, arg1, arg2, checked)
		menuFrame:Hide()
		InviteUnit(arg1)
	end

	local function whisperClick(self,arg1,arg2,checked)
		menuFrame:Hide() 
		SetItemRef( "player:"..arg1, ("|Hplayer:%1$s|h[%1$s]|h"):format(arg1), "LeftButton" )		 
	end

	local levelNameString = "|cff%02x%02x%02x%d|r |cff%02x%02x%02x%s|r"
	local clientLevelNameString = "[%s] |cff%02x%02x%02x%d|r |cff%02x%02x%02x%s|r%s |cff%02x%02x%02x%s|r"
	local levelNameClassString = "|cff%02x%02x%02x%d|r %s%s%s"
	local worldOfWarcraftString = "World of Warcraft"
	local battleNetString = "Battle.NET"
	local wowString = "WoW"
	local otherGameInfoString = "[%s] (%s)"
	local otherGameInfoString2 = "%s %s"
	local tthead, ttsubh, ttoff = {r=0.4, g=0.78, b=1}, {r=0.75, g=0.9, b=1}, {r=.3,g=1,b=.3}
	local activezone, inactivezone = {r=0.3, g=1.0, b=0.3}, {r=0.65, g=0.65, b=0.65}
	local statusTable = { "|cffFFFFFF [|r|cffFF0000"..'AFK'.."|r|cffFFFFFF]|r", "|cffFFFFFF [|r|cffFF0000"..'DND'.."|r|cffFFFFFF]|r", "" }
	local groupedTable = { "|cffaaaaaa*|r", "" } 
	local friendTable, BNTable = {}, {}
	local friendOnline, friendOffline = gsub(ERR_FRIEND_ONLINE_SS,"\124Hplayer:%%s\124h%[%%s%]\124h",""), gsub(ERR_FRIEND_OFFLINE_S,"%%s","")
	local dataValid = false

	local function BuildFriendTable(total)
		wipe(friendTable)
		local name, level, class, area, connected, status, note
		for i = 1, total do
			name, level, class, area, connected, status, note = GetFriendInfo(i)
			
			if connected then 
				for k,v in pairs(LOCALIZED_CLASS_NAMES_MALE) do if class == v then class = k end end
				friendTable[i] = { name, level, class, area, connected, status, note }
			end
		end
		sort(friendTable, function(a, b)
			if a[1] and b[1] then
				return a[1] < b[1]
			end
		end)
	end

	local function BuildBNTable(total)
		wipe(BNTable)
		local presenceID, givenName, surname, toonName, toonID, client, isOnline, isAFK, isDND, noteText, realmName, faction, race, class, zoneName, level
		for i = 1, total do
			if GetLocale() == "zhCN" then
				presenceID, surname, givenName, toonName, toonID, client, isOnline, _, isAFK, isDND, _, noteText = BNGetFriendInfo(i)
			else
				presenceID, givenName, surname, toonName, toonID, client, isOnline, _, isAFK, isDND, _, noteText = BNGetFriendInfo(i)
			end

			if isOnline then 
				_, _, _, realmName, faction, _, race, class, _, zoneName, level = BNGetToonInfo(presenceID)
				for k,v in pairs(LOCALIZED_CLASS_NAMES_MALE) do if class == v then class = k end end
				BNTable[i] = { presenceID, givenName, surname, toonName, toonID, client, isOnline, isAFK, isDND, noteText, realmName, faction, race, class, zoneName, level }
			end
		end
		sort(BNTable, function(a, b)
			if a[2] and b[2] then
				if a[2] == b[2] then return a[3] < b[3] end
				return a[2] < b[2]
			end
		end)
	end

	local function Update(self, event, ...)
		local _, onlineFriends = GetNumFriends()
		local _, numBNetOnline = BNGetNumFriends()

		-- special handler to detect friend coming online or going offline
		-- when this is the case, we invalidate our buffered table and update the 
		-- datatext information
		if event == "CHAT_MSG_SYSTEM" then
			local message = select(1, ...)
			if not (string.find(message, friendOnline) or string.find(message, friendOffline)) then return end
		end

		-- force update when showing tooltip
		dataValid = false

		Text:SetText(format(true and "%s: "..("|cff%.2x%.2x%.2x"):format(classc.r * 255, classc.g * 255, classc.b * 255).."%d" or "%s:%d","好友",onlineFriends + numBNetOnline))
		self:SetAllPoints(Text)
	end

	Stat:SetScript("OnMouseUp", function(self, btn)
		if btn ~= "RightButton" then return end
		
		GameTooltip:Hide()
		
		local menuCountWhispers = 0
		local menuCountInvites = 0
		local classc, levelc, info
		
		menuList[2].menuList = {}
		menuList[3].menuList = {}
		
		if #friendTable > 0 then
			for i = 1, #friendTable do
				info = friendTable[i]
				if (info[5]) then
					menuCountInvites = menuCountInvites + 1
					menuCountWhispers = menuCountWhispers + 1
		
					classc, levelc = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[info[3]], GetQuestDifficultyColor(info[2])
					if classc == nil then classc = GetQuestDifficultyColor(info[2]) end
		
					menuList[2].menuList[menuCountInvites] = {text = format(levelNameString,levelc.r*255,levelc.g*255,levelc.b*255,info[2],classc.r*255,classc.g*255,classc.b*255,info[1]), arg1 = info[1],notCheckable=true, func = inviteClick}
					menuList[3].menuList[menuCountWhispers] = {text = format(levelNameString,levelc.r*255,levelc.g*255,levelc.b*255,info[2],classc.r*255,classc.g*255,classc.b*255,info[1]), arg1 = info[1],notCheckable=true, func = whisperClick}
				end
			end
		end
		if #BNTable > 0 then
			local realID, playerFaction, grouped
			for i = 1, #BNTable do
				info = BNTable[i]
				if (info[7]) then
					realID = (BATTLENET_NAME_FORMAT):format(info[2], info[3])
					menuCountWhispers = menuCountWhispers + 1
					menuList[3].menuList[menuCountWhispers] = {text = realID, arg1 = realID,notCheckable=true, func = whisperClick}

					if select(1, UnitFactionGroup("player")) == "Horde" then playerFaction = 0 else playerFaction = 1 end
					if info[6] == wowString and info[11] == myrealm and playerFaction == info[12] then
						classc, levelc = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[info[14]], GetQuestDifficultyColor(info[16])
						if classc == nil then classc = GetQuestDifficultyColor(info[16]) end

						if UnitInParty(info[4]) or UnitInRaid(info[4]) then grouped = 1 else grouped = 2 end
						menuCountInvites = menuCountInvites + 1
						menuList[2].menuList[menuCountInvites] = {text = format(levelNameString,levelc.r*255,levelc.g*255,levelc.b*255,info[16],classc.r*255,classc.g*255,classc.b*255,info[4]), arg1 = info[4],notCheckable=true, func = inviteClick}
					end
				end
			end
		end

		EasyMenu(menuList, menuFrame, "cursor", 0, 0, "MENU", 2)
	end)
		
	Stat:SetScript("OnMouseDown", function(self, btn) if btn == "LeftButton" then ToggleFriendsFrame(1) end end)

	Stat:SetScript("OnEnter", function(self)
		local online, total = 0, GetNumFriends()
			local name, level, class, zone, connected, status, note, classc, levelc, zone_r, zone_g, zone_b, grouped
			for i = 0, total do if select(5, GetFriendInfo(i)) then online = online + 1 end end
			local BNonline, BNtotal = 0, BNGetNumFriends()
			local presenceID, presenceName, battleTag, toonName, toonID, client, isOnline
			if BNtotal > 0 then
				for i = 1, BNtotal do if select(8, BNGetFriendInfo(i)) then BNonline = BNonline + 1 end end
			end
			local totalonline = online + BNonline
			local totalfriends = total + BNtotal
			if online > 0 or BNonline > 0 then
				GameTooltip:SetOwner(self, "ANCHOR_NONE")
				GameTooltip:ClearAllPoints()
				GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
				GameTooltip:ClearLines()
				GameTooltip:AddDoubleLine(FRIENDS_LIST, format("%s: %s/%s", GUILD_ONLINE_LABEL, totalonline, totalfriends), tthead.r, tthead.g, tthead.b, tthead.r, tthead.g, tthead.b)
				if online > 0 then
					GameTooltip:AddLine(" ")
					GameTooltip:AddLine(CHARACTER_FRIEND)
					for i = 1, total do
						name, level, class, zone, connected, status, note = GetFriendInfo(i)
						if not connected then break end
						if GetRealZoneText() == zone then zone_r, zone_g, zone_b = 0.3, 1.0, 0.3 else zone_r, zone_g, zone_b = 0.65, 0.65, 0.65 end
						for k, v in pairs(LOCALIZED_CLASS_NAMES_MALE) do if class == v then class = k end end
						if GetLocale() ~= "enUS" then -- feminine class localization (unsure if it's really needed)
							for k, v in pairs(LOCALIZED_CLASS_NAMES_FEMALE) do if class == v then class = k end end
						end
						classc, levelc = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class], GetQuestDifficultyColor(level)
						grouped = (UnitInParty(name) or UnitInRaid(name)) and (GetRealZoneText() == zone and " |cff7fff00*|r" or " |cffff7f00*|r") or ""
						GameTooltip:AddDoubleLine(format("|cff%02x%02x%02x%d|r %s%s%s", levelc.r * 255, levelc.g * 255, levelc.b * 255, level, name, grouped, " "..status), zone, classc.r, classc.g, classc.b, zone_r, zone_g, zone_b)
						if self.altdown and note then GameTooltip:AddLine("  "..note, ttsubh.r, ttsubh.g, ttsubh.b, 1) end
					end
				end
				if BNonline > 0 then
					GameTooltip:AddLine(" ")
					GameTooltip:AddLine(BATTLENET_OPTIONS_LABEL)
					for i = 1, BNtotal do
						_, presenceName, battleTag, _, toonName, toonID, client, isOnline, _, isAFK, isDND = BNGetFriendInfo(i)
						if battleTag == nil then battleTag = "" end
						if not isOnline then break end
						if isAFK then
							status = "|cffE7E716"..L_CHAT_AFK.."|r"
						else
							if isDND then
								status = "|cffff0000"..L_CHAT_DND.."|r"
							else
								status = ""
							end
						end
						if client == "WoW" then
							local _, toonName, client, realmName, _, _, _, class, _, zoneName, level = BNGetToonInfo(toonID)
							for k, v in pairs(LOCALIZED_CLASS_NAMES_MALE) do if class == v then class = k end end
							if GetLocale() ~= "enUS" then -- feminine class localization (unsure if it's really needed)
								for k, v in pairs(LOCALIZED_CLASS_NAMES_FEMALE) do if class == v then class = k end end
							end
							classc, levelc = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class], GetQuestDifficultyColor(level)
							if UnitInParty(toonName) or UnitInRaid(toonName) then grouped = "|cffaaaaaa*|r" else grouped = "" end
							GameTooltip:AddDoubleLine(format("%s (|cff%02x%02x%02x%d|r |cff%02x%02x%02x%s|r%s) |cff%02x%02x%02x%s|r", client, levelc.r * 255, levelc.g * 255, levelc.b * 255, level, classc.r * 255, classc.g * 255, classc.b * 255, toonName, grouped, 255, 0, 0, status), presenceName.." "..battleTag, 238, 238, 238, 238, 238, 238)
							if self.altdown then
								if GetRealZoneText() == zone then zone_r, zone_g, zone_b = 0.3, 1.0, 0.3 else zone_r, zone_g, zone_b = 0.65, 0.65, 0.65 end
								if GetRealmName() == realmName then realm_r, realm_g, realm_b = 0.3, 1.0, 0.3 else realm_r, realm_g, realm_b = 0.65, 0.65, 0.65 end
								GameTooltip:AddDoubleLine("  "..zoneName, realmName, zone_r, zone_g, zone_b, realm_r, realm_g, realm_b)
							end
						else
							GameTooltip:AddDoubleLine("|cffeeeeee"..client.." ("..toonName..")|r", "|cffeeeeee"..presenceName.." "..battleTag.."|r")
						end
					end
				end
				GameTooltip:Show()
			else
				GameTooltip:Hide()
			end
	end)

	Stat:RegisterEvent("BN_FRIEND_ACCOUNT_ONLINE")
	Stat:RegisterEvent("BN_FRIEND_ACCOUNT_OFFLINE")
	Stat:RegisterEvent("BN_FRIEND_INFO_CHANGED")
	Stat:RegisterEvent("BN_FRIEND_TOON_ONLINE")
	Stat:RegisterEvent("BN_FRIEND_TOON_OFFLINE")
	Stat:RegisterEvent("BN_TOON_NAME_UPDATED")
	Stat:RegisterEvent("FRIENDLIST_UPDATE")
	Stat:RegisterEvent("PLAYER_ENTERING_WORLD")
	Stat:RegisterEvent("CHAT_MSG_SYSTEM")

	Stat:SetScript("OnLeave", function() GameTooltip:Hide() end)
	Stat:SetScript("OnEvent", Update)
end

local function BuildGuild()
	if C["InfoPanelDB"]["Guild"] ~= true then return end
	-- localized references for global functions (about 50% faster)
	local join 			= string.join
	local format		= string.format
	local find			= string.find
	local gsub			= string.gsub
	local sort			= table.sort
	local ceil			= math.ceil

	local tthead, ttsubh, ttoff = {r=0.4, g=0.78, b=1}, {r=0.75, g=0.9, b=1}, {r=.3,g=1,b=.3}
	local activezone, inactivezone = {r=0.3, g=1.0, b=0.3}, {r=0.65, g=0.65, b=0.65}
	local displayString = join("", S.RGBToHex(DB.MyClassColor.r,DB.MyClassColor.g,DB.MyClassColor.b)..GUILD.."|r", ": %d|r")
	local noGuildString = join("", "",L["没有工会"])
	local guildInfoString = "%s [%d]"
	local guildInfoString2 = join("", GUILD, ": %d/%d")
	local guildMotDString = "%s |cffaaaaaa- |cffffffff%s"
	local levelNameString = "|cff%02x%02x%02x%d|r |cff%02x%02x%02x%s|r %s"
	local levelNameStatusString = "|cff%02x%02x%02x%d|r %s %s"
	local nameRankString = "%s |cff999999-|cffffffff %s"
	local guildXpCurrentString = gsub(join("", S.RGBToHex(ttsubh.r, ttsubh.g, ttsubh.b), GUILD_EXPERIENCE_CURRENT), ": ", ":|r |cffffffff", 1)
	local guildXpDailyString = gsub(join("", S.RGBToHex(ttsubh.r, ttsubh.g, ttsubh.b), GUILD_EXPERIENCE_DAILY), ": ", ":|r |cffffffff", 1)
	local standingString = join("", S.RGBToHex(ttsubh.r, ttsubh.g, ttsubh.b), "%s:|r |cFFFFFFFF%s/%s (%s%%)")
	local moreMembersOnlineString = join("", "+ %d ", FRIENDS_LIST_ONLINE, "...")
	local noteString = join("", "|cff999999   ", LABEL_NOTE, ":|r %s")
	local officerNoteString = join("", "|cff999999   ", GUILD_RANK1_DESC, ":|r %s")
	local friendOnline, friendOffline = gsub(ERR_FRIEND_ONLINE_SS,"\124Hplayer:%%s\124h%[%%s%]\124h",""), gsub(ERR_FRIEND_OFFLINE_S,"%%s","")
	local guildTable, guildXP, guildMotD = {}, {}, ""

	local Stat = CreateFrame("Frame", "InfoPanelBottom3", BottomInfoPanel)
	Stat:EnableMouse(true)

	local Text  = S.MakeFontString(Stat)
	Text:SetTextColor(DB.MyClassColor.r,DB.MyClassColor.g,DB.MyClassColor.b)
	Text:SetShadowOffset(S.mult, -S.mult)
	Text:SetShadowColor(0, 0, 0, 0.4)
	Text:SetPoint("LEFT", InfoPanelBottom2 or InfoPanelBottom1, "RIGHT", 3, 0)
	Stat:SetAllPoints(Text)
	local function SortGuildTable(shift)
		sort(guildTable, function(a, b)
			if a and b then
				if shift then
					return a[10] < b[10]
				else
					return a[1] < b[1]
				end
			end
		end)
	end

	local function BuildGuildTable()
		wipe(guildTable)
		local name, rank, level, zone, note, officernote, connected, status, class
		local count = 0
		for i = 1, GetNumGuildMembers() do
			name, rank, rankIndex, level, _, zone, note, officernote, connected, status, class = GetGuildRosterInfo(i)
			-- we are only interested in online members
			if status == 0 then
							   sflag = ""
							elseif status == 1 then
							   sflag = "|cffFFFFFF [|r|cffFF0000"..'AFK'.."|r|cffFFFFFF]|r"
							else
							   sflag = "|cffFFFFFF [|r|cffFF0000"..'DND'.."|r|cffFFFFFF]|r"
			  end
			if connected then 
				count = count + 1
				guildTable[count] = { name, rank, level, zone, note, officernote, connected, sflag, class, rankIndex }
			end
		end
		SortGuildTable(IsShiftKeyDown())
	end


	local function UpdateGuildXP()
		local currentXP, remainingXP = UnitGetGuildXP("player")
		local nextLevelXP = currentXP + remainingXP
		local percentTotal = ceil((currentXP / nextLevelXP) * 100)
		--local percentDaily = ceil((dailyXP / maxDailyXP) * 100)
		
		guildXP[0] = { currentXP, nextLevelXP, percentTotal }
		--guildXP[1] = { dailyXP, maxDailyXP, percentDaily }
	end

	local function UpdateGuildMessage()
		guildMotD = GetGuildRosterMOTD()
	end

	local function Update(self, event, ...)	
		if IsInGuild() then
			-- special handler to request guild roster updates when guild members come online or go
			-- offline, since this does not automatically trigger the GuildRoster update from the server
			if event == "CHAT_MSG_SYSTEM" then
				local message = select(1, ...)
				if find(message, friendOnline) or find(message, friendOffline) then GuildRoster() end
			end
			-- our guild xp changed, recalculate it
			if event == "GUILD_XP_UPDATE" then UpdateGuildXP() return end
			-- our guild message of the day changed
			if event == "GUILD_MOTD" then UpdateGuildMessage() return end
			-- when we enter the world and guildframe is not available then
			-- load guild frame, update guild message and guild xp
			if event == "PLAYER_ENTERING_WORLD" then
				if not GuildFrame and IsInGuild() then LoadAddOn("Blizzard_GuildUI") UpdateGuildMessage() UpdateGuildXP() end
			end
			-- an event occured that could change the guild roster, so request update, and wait for guild roster update to occur
			if event ~= "GUILD_ROSTER_UPDATE" and event~="PLAYER_GUILD_UPDATE" then GuildRoster() return end

			local total, online = GetNumGuildMembers()
			
			Text:SetFormattedText(displayString, online)
		else
			Text:SetText(L["没有工会"])
		end
	end
		
	local menuFrame = CreateFrame("Frame", "GuildRightClickMenu", UIParent, "UIDropDownMenuTemplate")
	local menuList = {
		{ text = OPTIONS_MENU, isTitle = true, notCheckable=true},
		{ text = INVITE, hasArrow = true, notCheckable=true,},
		{ text = CHAT_MSG_WHISPER_INFORM, hasArrow = true, notCheckable=true,}
	}

	local function inviteClick(self, arg1, arg2, checked)
		menuFrame:Hide()
		InviteUnit(arg1)
	end

	local function whisperClick(self,arg1,arg2,checked)
		menuFrame:Hide()
		SetItemRef( "player:"..arg1, ("|Hplayer:%1$s|h[%1$s]|h"):format(arg1), "LeftButton" )
	end

	local function ToggleGuildFrame()
		if IsInGuild() then
			if not GuildFrame then LoadAddOn("Blizzard_GuildUI") end
			GuildFrame_Toggle()
			GuildFrame_TabClicked(GuildFrameTab2)
		else
			if not LookingForGuildFrame then LoadAddOn("Blizzard_LookingForGuildUI") end
			if LookingForGuildFrame then LookingForGuildFrame_Toggle() end
		end
	end

	Stat:SetScript("OnMouseUp", function(self, btn)
		if btn ~= "RightButton" or not IsInGuild() then return end
		if InCombatLockdown() then return end
		
		GameTooltip:Hide()

		local classc, levelc, grouped, info
		local menuCountWhispers = 0
		local menuCountInvites = 0

		menuList[2].menuList = {}
		menuList[3].menuList = {}

		for i = 1, #guildTable do
			info = guildTable[i]
			if info[7] and info[1] ~= DB.myname then
				local classc, levelc = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[info[9]], GetQuestDifficultyColor(info[3])

				if UnitInParty(info[1]) or UnitInRaid(info[1]) then
					grouped = "|cffaaaaaa*|r"
				else
					menuCountInvites = menuCountInvites +1
					grouped = ""
					menuList[2].menuList[menuCountInvites] = {text = format(levelNameString, levelc.r*255,levelc.g*255,levelc.b*255, info[3], classc.r*255,classc.g*255,classc.b*255, info[1], ""), arg1 = info[1],notCheckable=true, func = inviteClick}
				end
				menuCountWhispers = menuCountWhispers + 1
				menuList[3].menuList[menuCountWhispers] = {text = format(levelNameString, levelc.r*255,levelc.g*255,levelc.b*255, info[3], classc.r*255,classc.g*255,classc.b*255, info[1], grouped), arg1 = info[1],notCheckable=true, func = whisperClick}
			end
		end

		EasyMenu(menuList, menuFrame, "cursor", 0, 0, "MENU", 2)
	end)

	Stat:SetScript("OnMouseDown", function(self, btn)
		if btn ~= "LeftButton" then return end
		ToggleGuildFrame()
	end)

	Stat:SetScript("OnEnter", function(self)
		if InCombatLockdown() or not IsInGuild() then return end
		
		local total, online = GetNumGuildMembers()
		GuildRoster()
		BuildGuildTable()
		
		
		local guildName, guildRank = GetGuildInfo('player')
		local guildLevel = GetGuildLevel()

		GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
		
		GameTooltip:ClearLines()
		GameTooltip:AddDoubleLine(format(guildInfoString, guildName, guildLevel), format(guildInfoString2, online, total),tthead.r,tthead.g,tthead.b,tthead.r,tthead.g,tthead.b)
		GameTooltip:AddLine(guildRank, unpack(tthead))
		GameTooltip:AddLine(' ')
		
		if guildMotD ~= "" then GameTooltip:AddLine(format(guildMotDString, GUILD_MOTD, guildMotD), ttsubh.r, ttsubh.g, ttsubh.b, 1) end
		
		local col = S.RGBToHex(ttsubh.r, ttsubh.g, ttsubh.b)
		GameTooltip:AddLine(' ')
		if GetGuildLevel() ~= 25 then
			if guildXP[0] and guildXP[1] then
				local currentXP, nextLevelXP, percentTotal = unpack(guildXP[0])
				local dailyXP, maxDailyXP, percentDaily = unpack(guildXP[1])
						
				GameTooltip:AddLine(format(guildXpCurrentString, S.ShortValue(currentXP), S.ShortValue(nextLevelXP), percentTotal))
				GameTooltip:AddLine(format(guildXpDailyString, S.ShortValue(dailyXP), S.ShortValue(maxDailyXP), percentDaily))
			end
		end
		
		local _, _, standingID, barMin, barMax, barValue = GetGuildFactionInfo()
		if standingID ~= 8 then -- Not Max Rep
			barMax = barMax - barMin
			barValue = barValue - barMin
			barMin = 0
			GameTooltip:AddLine(format(standingString, COMBAT_FACTION_CHANGE, S.ShortValue(barValue), S.ShortValue(barMax), ceil((barValue / barMax) * 100)))
		end
		
		local zonec, classc, levelc, info
		local shown = 0
		
		GameTooltip:AddLine(' ')
		for i = 1, #guildTable do
			-- if more then 30 guild members are online, we don't Show any more, but inform user there are more
			if 30 - shown <= 1 then
				if online - 30 > 1 then GameTooltip:AddLine(format(moreMembersOnlineString, online - 30), ttsubh.r, ttsubh.g, ttsubh.b) end
				break
			end

			info = guildTable[i]
			if GetRealZoneText() == info[4] then zonec = activezone else zonec = inactivezone end
			classc, levelc = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[info[9]], GetQuestDifficultyColor(info[3])
			
			if IsShiftKeyDown() then
				GameTooltip:AddDoubleLine(format(nameRankString, info[1], info[2]), info[4], classc.r, classc.g, classc.b, zonec.r, zonec.g, zonec.b)
				if info[5] ~= "" then GameTooltip:AddLine(format(noteString, info[5]), ttsubh.r, ttsubh.g, ttsubh.b, 1) end
				if info[6] ~= "" then GameTooltip:AddLine(format(officerNoteString, info[6]), ttoff.r, ttoff.g, ttoff.b, 1) end
			else
				GameTooltip:AddDoubleLine(format(levelNameStatusString, levelc.r*255, levelc.g*255, levelc.b*255, info[3], info[1], info[8]), info[4], classc.r,classc.g,classc.b, zonec.r,zonec.g,zonec.b)
			end
			shown = shown + 1
		end
		GameTooltip:Show()
	end)

	Stat:SetScript("OnLeave", function() GameTooltip:Hide() end)

	Stat:RegisterEvent("GUILD_ROSTER_SHOW")
	Stat:RegisterEvent("PLAYER_ENTERING_WORLD")
	Stat:RegisterEvent("GUILD_ROSTER_UPDATE")
	Stat:RegisterEvent("GUILD_XP_UPDATE")
	Stat:RegisterEvent("PLAYER_GUILD_UPDATE")
	Stat:RegisterEvent("GUILD_MOTD")
	Stat:RegisterEvent("CHAT_MSG_SYSTEM")
	Stat:SetScript("OnEvent", Update)
end

local function BuildDurability()
	local Slots = {
		[1] = {1, L["头部"], 1000},
		[2] = {3, L["肩部"], 1000},
		[3] = {5, L["胸部"], 1000},
		[4] = {6, L["腰部"], 1000},
		[5] = {9, L["手腕"], 1000}, 
		[6] = {10, L["手"], 1000},
		[7] = {7, L["腿部"], 1000},
		[8] = {8, L["脚"], 1000},
		[9] = {16, L["主手"], 1000},
		[10] = {17, L["副手"], 1000}, 
	}
	local Stat = CreateFrame("Frame", "InfoPanelBottom4", BottomInfoPanel)
	local Text = S.MakeFontString(Stat)
	Text:SetPoint("LEFT", InfoPanelBottom3 or InfoPanelBottom2 or InfoPanelBottom1, "RIGHT", 3, 0)
	Stat:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
	Stat:RegisterEvent("MERCHANT_SHOW")
	Stat:RegisterEvent("PLAYER_ENTERING_WORLD")
	Stat:SetAllPoints(Text)
	Stat:SetScript("OnEvent", function(self)
			for i = 1, 10 do
				if GetInventoryItemLink("player", Slots[i][1]) ~= nil then
					local durability, max = GetInventoryItemDurability(Slots[i][1])
					if durability then 
						Slots[i][3] = durability/max
					end
				end
			end
			table.sort(Slots, function(a, b) return a[3] < b[3] end)
			local value = floor(Slots[1][3]*100)
			if value < 40 then
				Text:SetText("|cffff0000".."警告: |r "..Slots[1][2].."耐久过低!")
			else
				Text:SetText("      ")
			end
	end)
	Stat:SetScript("OnEnter", function(self)
		if not InCombatLockdown() then
			GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT", 0, 0)
			GameTooltip:ClearLines()
			GameTooltip:AddLine(L["耐久度"], 0.4, 0.78, 1)
			GameTooltip:AddLine(" ")
			for i = 1, 10 do
				if Slots[i][3] ~= 1000 then
					green = Slots[i][3]/1
					red = 1-green
					GameTooltip:AddDoubleLine(Slots[i][2], format("%d %%", floor(Slots[i][3]*100)), 1 , 1 , 1, red, green, 0)
				end
			end
			GameTooltip:Show()
		end
	end)
	Stat:SetScript("OnLeave", function() GameTooltip:Hide() end)
	Stat:SetScript("OnMouseDown", function(self, button)
	ToggleCharacter("PaperDollFrame") end)
end

local function BuildStat2()

	local Stat = CreateFrame("Frame", "InfoPanelBottom5", BottomInfoPanel)
	Stat:EnableMouse(true)
	Stat:SetFrameStrata("MEDIUM")
	Stat:SetFrameLevel(3)

	Text  = S.MakeFontString(Stat)
	Text:SetTextColor(DB.MyClassColor.r,DB.MyClassColor.g,DB.MyClassColor.b)
	Text:SetShadowOffset(S.mult, -S.mult)
	Text:SetShadowColor(0, 0, 0, 0.4)
	Text:SetPoint("RIGHT", BottomInfoPanel, "RIGHT", -10, 2)
	Stat:SetAllPoints(Text)
	
	local _G = getfenv(0)
	local format = string.format
	local chanceString = "%.2f%%"
	local armorString = ARMOR..": "
	local modifierString = string.join("", "%d (+", chanceString, ")")
	local baseArmor, effectiveArmor, armor, posBuff, negBuff
	local displayNumberString = string.join("", "%s%d|r")
	local displayFloatString = string.join("", "%s%.2f%%|r")

	local function CalculateMitigation(level, effective)
		local mitigation
		
		if not effective then
			_, effective, _, _, _ = UnitArmor("player")
		end
		
		if level < 60 then
			mitigation = (effective/(effective + 400 + (85 * level)));
		else
			mitigation = (effective/(effective + (467.5 * level - 22167.5)));
		end
		if mitigation > .75 then
			mitigation = .75
		end
		return mitigation
	end

	local function AddTooltipHeader(description)
		GameTooltip:AddLine(description)
	end

	local function ShowTooltip(self)
		GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
		GameTooltip:ClearLines()
		
		if DB.Role == "Tank" then
			AddTooltipHeader(L["等级缓和"]..": ")
			local lv = DB.level +3
			for i = 1, 4 do
				GameTooltip:AddDoubleLine(lv,format(chanceString, CalculateMitigation(lv, effectiveArmor) * 100),1,1,1)
				lv = lv - 1
			end
			lv = UnitLevel("target")
			if lv and lv > 0 and (lv > DB.level + 3 or lv < DB.level) then
				GameTooltip:AddDoubleLine(lv, format(chanceString, CalculateMitigation(lv, effectiveArmor) * 100),1,1,1)
			end	
		end
		GameTooltip:Show()
	end

	local function UpdateTank(self)
		baseArmor, effectiveArmor, armor, posBuff, negBuff = UnitArmor("player");
		
		Text:SetFormattedText(displayNumberString, S.RGBToHex(DB.MyClassColor.r,DB.MyClassColor.g,DB.MyClassColor.b)..armorString.."|r", effectiveArmor)
		--Setup Tooltip
		self:SetAllPoints(Text)
	end

	local function UpdateCaster(self)
		local spellcrit = GetSpellCritChance(1)
				haste = UnitSpellHaste("player")
		num = max(spellcrit, haste)
		if num == spellcrit then
		Text:SetFormattedText(displayFloatString, S.RGBToHex(DB.MyClassColor.r,DB.MyClassColor.g,DB.MyClassColor.b)..SPELL_CRIT_CHANCE..": ".."|r", spellcrit)
		else
		Text:SetFormattedText(displayFloatString, S.RGBToHex(DB.MyClassColor.r,DB.MyClassColor.g,DB.MyClassColor.b)..STAT_HASTE..": ".."|r", haste)
		end
		--Setup Tooltip
		self:SetAllPoints(Text)
	end

	local function UpdateMelee(self)
		local meleecrit = GetCritChance()
		local rangedcrit = GetRangedCritChance()
		local critChance
			
		if DB.MyClass == "HUNTER" then    
			critChance = rangedcrit
		else
			critChance = meleecrit
		end
		
		Text:SetFormattedText(displayFloatString, S.RGBToHex(DB.MyClassColor.r,DB.MyClassColor.g,DB.MyClassColor.b)..MELEE_CRIT_CHANCE..": ".."|r", critChance)
		--Setup Tooltip
		self:SetAllPoints(Text)
	end

	-- initial delay for update (let the ui load)
	local int = 5	
	local function Update(self, t)
		int = int - t
		if int > 0 then return end
		
		if DB.Role == "Tank" then
			UpdateTank(self)
		elseif DB.Role == "Caster" then
			UpdateCaster(self)
		elseif DB.Role == "Melee" then
			UpdateMelee(self)		
		end
		int = 2
	end

	Stat:SetScript("OnEnter", function() ShowTooltip(Stat) end)
	Stat:SetScript("OnLeave", function() GameTooltip:Hide() end)
	Stat:SetScript("OnUpdate", Update)
	Update(Stat, 6)
end

local function BuildStat1()
	local Stat = CreateFrame("Frame", "InfoPanelBottom6", BottomInfoPanel)
	Stat:EnableMouse(true)
	Stat:SetFrameStrata("MEDIUM")
	Stat:SetFrameLevel(3)

	local Text  = S.MakeFontString(Stat)
	Text:SetTextColor(DB.MyClassColor.r,DB.MyClassColor.g,DB.MyClassColor.b)
	Text:SetShadowOffset(S.mult, -S.mult)
	Text:SetShadowColor(0, 0, 0, 0.4)
	Text:SetPoint("RIGHT", InfoPanelBottom5, "LEFT", -3, 0)
	Stat:SetAllPoints(Text)
	
	local format = string.format
	local targetlv, playerlv
	local basemisschance, leveldifference, dodge, parry, block
	local chanceString = "%.2f%%"
	local modifierString = string.join("", "%d (+", chanceString, ")")
	local manaRegenString = "%d / %d"
	local displayNumberString = string.join("", "%s%d|r")
	local displayFloatString = string.join("", "%s%.2f%%|r")
	local spellpwr, avoidance, pwr
	local haste, hasteBonus

	local function ShowTooltip(self)
		GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
		GameTooltip:ClearLines()
		GameTooltip:AddLine(STATS_LABEL)
		
		if DB.Role == "Tank" then
			if targetlv > 1 then
				GameTooltip:AddDoubleLine(L["免伤分析"], string.join("", " (", LEVEL, " ", targetlv, ")"))
			elseif targetlv == -1 then
				GameTooltip:AddDoubleLine(L["免伤分析"], string.join("", " (", BOSS, ")"))
			else
				GameTooltip:AddDoubleLine(L["免伤分析"], string.join("", " (", LEVEL, " ", playerlv, ")"))
			end
			GameTooltip:AddLine' '
			GameTooltip:AddDoubleLine(DODGE_CHANCE, format(chanceString, dodge),1,1,1)
			GameTooltip:AddDoubleLine(PARRY_CHANCE, format(chanceString, parry),1,1,1)
			GameTooltip:AddDoubleLine(BLOCK_CHANCE, format(chanceString, block),1,1,1)
			GameTooltip:AddDoubleLine(MISS_CHANCE, format(chanceString, basemisschance),1,1,1)
			GameTooltip:AddDoubleLine(STAT_MASTERY,  format(modifierString, GetCombatRating(CR_MASTERY), GetCombatRatingBonus(CR_MASTERY)), 1, 1, 1)
		elseif DB.Role == "Caster" then
			GameTooltip:AddDoubleLine(STAT_HIT_CHANCE, format(modifierString, GetCombatRating(CR_HIT_SPELL), GetCombatRatingBonus(CR_HIT_SPELL)), 1, 1, 1)
			GameTooltip:AddDoubleLine(STAT_HASTE, format(modifierString, GetCombatRating(CR_HASTE_SPELL), GetCombatRatingBonus(CR_HASTE_SPELL)), 1, 1, 1)
			GameTooltip:AddDoubleLine(SPELL_CRIT_CHANCE, format(modifierString, GetCombatRating(CR_CRIT_SPELL), GetCombatRatingBonus(CR_CRIT_SPELL)), 1, 1, 1)
			local base, combat = GetManaRegen()
			GameTooltip:AddDoubleLine(MANA_REGEN, format(manaRegenString, base * 5, combat * 5), 1, 1, 1)
			GameTooltip:AddDoubleLine(STAT_MASTERY,  format(modifierString, GetCombatRating(CR_MASTERY), GetCombatRatingBonus(CR_MASTERY)), 1, 1, 1)
		elseif DB.Role == "Melee" then
			local hit = DB.MyClass == "HUNTER" and GetCombatRating(CR_HIT_RANGED) or GetCombatRating(CR_HIT_MELEE)
			local hitBonus = DB.MyClass == "HUNTER" and GetCombatRatingBonus(CR_HIT_RANGED) or GetCombatRatingBonus(CR_HIT_MELEE)
		
			GameTooltip:AddDoubleLine(STAT_HIT_CHANCE, format(modifierString, hit, hitBonus), 1, 1, 1)
			GameTooltip:AddDoubleLine(STAT_MASTERY,  format(modifierString, GetCombatRating(CR_MASTERY), GetCombatRatingBonus(CR_MASTERY)), 1, 1, 1)
			--Hunters don't use expertise
			if DB.MyClass ~= "HUNTER" then
				local expertisePercent, offhandExpertisePercent = GetExpertise()
				expertisePercent = format("%.2f", expertisePercent)
				offhandExpertisePercent = format("%.2f", offhandExpertisePercent)
				
				local expertisePercentDisplay
				if IsDualWielding() then
					expertisePercentDisplay = expertisePercent.."% / "..offhandExpertisePercent.."%"
				else
					expertisePercentDisplay = expertisePercent.."%"
				end
				GameTooltip:AddDoubleLine(COMBAT_RATING_NAME24, format('%d (+%s)', GetCombatRating(CR_EXPERTISE), expertisePercentDisplay), 1, 1, 1)
			end
			
			local haste = DB.MyClass == "HUNTER" and GetCombatRating(CR_HASTE_RANGED) or GetCombatRating(CR_HASTE_MELEE)
			local hasteBonus = DB.MyClass == "HUNTER" and GetCombatRatingBonus(CR_HASTE_RANGED) or GetCombatRatingBonus(CR_HASTE_MELEE)
			
			GameTooltip:AddDoubleLine(STAT_HASTE, format(modifierString, haste, hasteBonus), 1, 1, 1)
		end
		GameTooltip:Show()
	end

	local function UpdateTank(self)
		targetlv, playerlv = UnitLevel("target"), UnitLevel("player")
				
		-- the 5 is for base miss chance
		if targetlv == -1 then
			basemisschance = (5 - (3*.2))
			leveldifference = 3
		elseif targetlv > playerlv then
			basemisschance = (5 - ((targetlv - playerlv)*.2))
			leveldifference = (targetlv - playerlv)
		elseif targetlv < playerlv and targetlv > 0 then
			basemisschance = (5 + ((playerlv - targetlv)*.2))
			leveldifference = (targetlv - playerlv)
		else
			basemisschance = 5
			leveldifference = 0
		end
		
		if select(2, UnitRace("player")) == "NightElf" then basemisschance = basemisschance + 2 end
		
		if leveldifference >= 0 then
			dodge = (GetDodgeChance()-leveldifference*.2)
			parry = (GetParryChance()-leveldifference*.2)
			block = (GetBlockChance()-leveldifference*.2)
		else
			dodge = (GetDodgeChance()+abs(leveldifference*.2))
			parry = (GetParryChance()+abs(leveldifference*.2))
			block = (GetBlockChance()+abs(leveldifference*.2))
		end
		
		if dodge <= 0 then dodge = 0 end
		if parry <= 0 then parry = 0 end
		if block <= 0 then block = 0 end
		
		if DB.MyClass == "DRUID" then
			parry = 0
			block = 0
		elseif DB.MyClass == "DEATHKNIGHT" then
			block = 0
		end
		avoidance = (dodge+parry+block+basemisschance)
		
		Text:SetFormattedText(displayFloatString, S.RGBToHex(DB.MyClassColor.r,DB.MyClassColor.g,DB.MyClassColor.b)..L["免伤"]..": ".."|r", avoidance)
		--Setup Tooltip
		self:SetAllPoints(Text)
	end

	local function UpdateCaster(self)
		if GetSpellBonusHealing() > GetSpellBonusDamage(7) then
			spellpwr = GetSpellBonusHealing()
		else
			spellpwr = GetSpellBonusDamage(7)
		end
		
		Text:SetFormattedText(displayNumberString, S.RGBToHex(DB.MyClassColor.r,DB.MyClassColor.g,DB.MyClassColor.b)..STAT_SPELLPOWER..": ".."|r", spellpwr)
		--Setup Tooltip
		self:SetAllPoints(Text)
	end

	local function UpdateMelee(self)
		local base, posBuff, negBuff = UnitAttackPower("player");
		local effective = base + posBuff + negBuff;
		local Rbase, RposBuff, RnegBuff = UnitRangedAttackPower("player");
		local Reffective = Rbase + RposBuff + RnegBuff;
			
		if DB.MyClass == "HUNTER" then
			pwr = Reffective
		else
			pwr = effective
		end
		
		Text:SetFormattedText(displayNumberString, S.RGBToHex(DB.MyClassColor.r,DB.MyClassColor.g,DB.MyClassColor.b)..STAT_ATTACK_POWER..": ".."|r", pwr)      
		--Setup Tooltip
		self:SetAllPoints(Text)
	end

	-- initial delay for update (let the ui load)
	local int = 5	
	local function Update(self, t)
		int = int - t
		if int > 0 then return end
		if DB.Role == "Tank" then 
			UpdateTank(self)
		elseif DB.Role == "Caster" then
			UpdateCaster(self)
		elseif DB.Role == "Melee" then
			UpdateMelee(self)
		end
		int = 2
	end

	Stat:SetScript("OnEnter", function() ShowTooltip(Stat) end)
	Stat:SetScript("OnLeave", function() GameTooltip:Hide() end)
	Stat:SetScript("OnUpdate", Update)
	Update(Stat, 6)
end

local function BuildSpecswitch()
	local Stat = CreateFrame("Frame", "InfoPanelBottom7", BottomInfoPanel)
	Stat:SetFrameStrata("MEDIUM")
	Stat:SetFrameLevel(3)
	local Text  = S.MakeFontString(Stat)
	Text:SetTextColor(DB.MyClassColor.r,DB.MyClassColor.g,DB.MyClassColor.b)
	Text:SetShadowOffset(S.mult, -S.mult)
	Text:SetShadowColor(0, 0, 0, 0.4)
	Text:SetPoint("RIGHT", InfoPanelBottom6, "LEFT", -3, 0)
	Text:SetText(NONE..TALENTS)
	Stat:SetAllPoints(Text)
	
	local function OnEvent(self)
		if not GetSpecialization() then
			Text:SetText(NONE..TALENTS) 
		else		
			Text:SetText(select(2,GetSpecializationInfo(GetSpecialization())))
		end
	end

	local function Checktalentgroup(index)
		return GetSpecialization(false,false,index)
	end


	Stat:RegisterEvent("PLAYER_ENTERING_WORLD")
	Stat:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
	Stat:SetScript("OnEvent", OnEvent)
	Stat:SetScript("OnEnter", function(self)
		local c = GetActiveSpecGroup(false,false)
		local majorTree1 = GetSpecialization(false,false,1)
		local spec1 = { }
		for i = 1, 18 do 
			local name, iconTexture, tier, column, selected, available = GetTalentInfo(i,false,1)
			if selected then
				table.insert(spec1,name)
			end
		end
		local majorTree2 = GetSpecialization(false,false,2)
		local spec2 = { }
		for i = 1, 18 do 
			local name, iconTexture, tier, column, selected, available = GetTalentInfo(i,false,2)
			if selected then
				table.insert(spec2,name)
			end
		end
		GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 6)
		GameTooltip:ClearLines()
		GameTooltip:AddLine(TALENTS_BUTTON,0,.6,1)
		GameTooltip:AddLine(" ")
		if GetNumSpecGroups() == 1 then
			GameTooltip:AddLine("|cff00FF00* |r" .. (GetSpecialization() and select(2,GetSpecializationInfo(majorTree1)) or infoL["none"])..": ",1,1,1)
			for i = 1, #spec1 do
				GameTooltip:AddDoubleLine(" ", spec1[i],1,1,1,1,1,1)
			end
		else
			GameTooltip:AddLine("|cff00FF00"..(c == 1 and "* " or "   ") .. "|r" .. select(2,GetSpecializationInfo(majorTree1))..": ",1,1,1)
			for i = 1, #spec1 do
				GameTooltip:AddDoubleLine(" ", spec1[i],1,1,1,1,1,1)
			end
			GameTooltip:AddLine("|cff00FF00"..(c == 2 and "* " or "   ") .. "|r" .. select(2,GetSpecializationInfo(majorTree2))..": ",1,1,1)
			for i = 1, #spec2 do
				GameTooltip:AddDoubleLine(" ", spec2[i],1,1,1,1,1,1)
			end
		end
		GameTooltip:Show()
	end)
	Stat:SetScript("OnLeave", function() GameTooltip:Hide() end)
	Stat:SetScript("OnMouseDown", function(_,btn)
		if btn == "LeftButton" then
			ToggleTalentFrame()
		else
			c = GetActiveSpecGroup(false,false)
			SetActiveSpecGroup(c == 1 and 2 or 1)
		end
	end)
	
end

function Module:OnEnable()
	if C["InfoPanelDB"]["OpenBottom"] == true then
		BuildClock()
		BuildFriend()
		BuildGuild()
		BuildDurability()
		BuildStat2()
		BuildStat1()
		BuildSpecswitch()
	end
end