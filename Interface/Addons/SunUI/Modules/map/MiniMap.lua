-- Engines
local S, L, DB, _, C = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("MiniMap", "AceTimer-3.0")

local function SkinMiniMap()
	Minimap:SetMaskTexture("Interface\\ChatFrame\\ChatFrameBackground")
	Minimap:SetFrameStrata("MEDIUM")
	Minimap:ClearAllPoints()
	Minimap:SetSize(120, 120)
	
	MoveHandle.Minimap = S.MakeMoveHandle(Minimap, L["小地图"], "Minimap")
	Minimap:CreateShadow()
end
local function CreateFlash()
	local PMinimap = CreateFrame("Frame", nil, Minimap)
	PMinimap:SetFrameStrata("BACKGROUND")
	PMinimap:SetFrameLevel(0)
	PMinimap:SetPoint("TOPLEFT", Minimap, "TOPLEFT", -100, 100)
	PMinimap:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 100, -100)
	PMinimap.texture = PMinimap:CreateTexture(nil)
	PMinimap.texture:SetAllPoints(PMinimap)
	PMinimap.texture:SetTexture("World\\GENERIC\\ACTIVEDOODADS\\INSTANCEPORTAL\\GENERICGLOW2.BLP")
	PMinimap.texture:SetVertexColor(DB.MyClassColor.r, DB.MyClassColor.g, DB.MyClassColor.b)
	PMinimap.texture:SetBlendMode("ADD")
	
	PMinimap.texture.anim = PMinimap.texture:CreateAnimationGroup()
	
	PMinimap.texture.anim.fadeout = PMinimap.texture.anim:CreateAnimation("ALPHA")
	PMinimap.texture.anim.fadeout:SetChange(-1)
	PMinimap.texture.anim.fadeout:SetOrder(1)
	PMinimap.texture.anim.fadeout:SetDuration(3)

	PMinimap.texture.anim.fade = PMinimap.texture.anim:CreateAnimation("ALPHA")
	PMinimap.texture.anim.fade:SetChange(0)
	PMinimap.texture.anim.fade:SetOrder(2)
	PMinimap.texture.anim.fade:SetDuration(2)
	
	PMinimap.texture.anim.fadein = PMinimap.texture.anim:CreateAnimation("ALPHA")
	PMinimap.texture.anim.fadein:SetChange(1)
	PMinimap.texture.anim.fadein:SetOrder(3)
	PMinimap.texture.anim.fadein:SetDuration(3)
	
	PMinimap.texture.anim.fade2 = PMinimap.texture.anim:CreateAnimation("ALPHA")
	PMinimap.texture.anim.fade2:SetChange(0)
	PMinimap.texture.anim.fade2:SetOrder(4)
	PMinimap.texture.anim.fade2:SetDuration(2)
	
	PMinimap.texture.anim:SetLooping("REPEAT")
	PMinimap.texture.anim:Play()
end
local function HideMinimapButton()
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
	}

	for i in pairs(frames) do
		if _G[frames[i]] then
			_G[frames[i]]:Hide()
			_G[frames[i]].Show = function() end
		end
	end
	MinimapCluster:EnableMouse(false)
	-- Tracking
	MiniMapTrackingBackground:SetAlpha(0)
	MiniMapTrackingButton:SetAlpha(0)
	MiniMapTracking:ClearAllPoints()
	MiniMapTracking:SetPoint("BOTTOMLEFT", Minimap, -5, -5)
	MiniMapTracking:SetScale(1)

	--Random Group icon
	QueueStatusMinimapButton:ClearAllPoints()
	QueueStatusMinimapButtonBorder:SetAlpha(0)
	QueueStatusMinimapButton:SetPoint("TOP", Minimap, "TOP", 1, 8)
	QueueStatusMinimapButton:SetFrameStrata("MEDIUM")

	-- Instance Difficulty flag
	MiniMapInstanceDifficulty:ClearAllPoints()
	MiniMapInstanceDifficulty:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", 2, 2)
	MiniMapInstanceDifficulty:SetScale(0.1)
	MiniMapInstanceDifficulty:SetAlpha(0)
	MiniMapInstanceDifficulty:SetFrameStrata("LOW")

	-- Guild Instance Difficulty flag
	GuildInstanceDifficulty:ClearAllPoints()
	GuildInstanceDifficulty:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", 2, 2)
	GuildInstanceDifficulty:SetScale(0.1)
	GuildInstanceDifficulty:SetAlpha(0)
	GuildInstanceDifficulty:SetFrameStrata("LOW")

	-- Mail icon
	MiniMapMailFrame:ClearAllPoints()
	MiniMapMailFrame:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 2, -6)
	MiniMapMailIcon:SetTexture("Interface\\AddOns\\SunUI\\media\\mail")

	-- Invites Icon
	GameTimeCalendarInvitesTexture:ClearAllPoints()
	GameTimeCalendarInvitesTexture:SetParent("Minimap")
	GameTimeCalendarInvitesTexture:SetPoint("TOPRIGHT")

	if FeedbackUIButton then
		FeedbackUIButton:ClearAllPoints()
		FeedbackUIButton:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 6, -6)
		FeedbackUIButton:SetScale(0.8)
	end

	if StreamingIcon then
		StreamingIcon:ClearAllPoints()
		StreamingIcon:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", 8, 8)
		StreamingIcon:SetScale(0.8)
	end
end
local function MouseScroll()
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
end
local function RightClickMenu()
	local menuFrame = CreateFrame("Frame", "MinimapRightClickMenu", UIParent, "UIDropDownMenuTemplate")
	local menuList = {
		{text = CHARACTER_BUTTON, func = function() ToggleCharacter("PaperDollFrame") end},
		{text = SPELLBOOK_ABILITIES_BUTTON, func = function() ToggleSpellBook("spell") end},
		{text = TALENTS_BUTTON, func = function() ToggleTalentFrame() end},
		{text = ACHIEVEMENT_BUTTON, func = function() ToggleAchievementFrame() end},
		{text = QUESTLOG_BUTTON, func = function() ToggleFrame(QuestLogFrame) end},
		{text = SOCIAL_BUTTON, func = function() ToggleFriendsFrame(1) end},
		{text = GUILD, func = function() ToggleGuildFrame(1) end},
		{text = PLAYER_V_PLAYER, func = function() TogglePVPUI() end},
		{text = LFG_TITLE, func = function() ToggleFrame(PVEFrame) end},
		{text = HELP_BUTTON, func = function() ToggleHelpFrame() end},
		{text = SLASH_CALENDAR2:gsub("/(.*)","%1"), func = function() if(not CalendarFrame) then LoadAddOn("Blizzard_Calendar") end Calendar_Toggle() end},
		{text = PET_JOURNAL,func = function() TogglePetJournal() end},
		{text = ENCOUNTER_JOURNAL,func = function() ToggleEncounterJournal() end},
		{text = MAINMENU_BUTTON,func = function() ToggleFrame(GameMenuFrame) end},
		{text = INVTYPE_BAG,func = function() ToggleAllBags() end},
	}

	Minimap:SetScript("OnMouseUp", function(self, button)
		if button == "RightButton" then
			EasyMenu(menuList, menuFrame, "cursor", 0, 0, "MENU", 2)
		else
			Minimap_OnClick(self)
		end
	end)
end
local function LocationInfo()
	local SubLoc = CreateFrame("Frame", "Sub Location", Minimap)
	local SubText = SubLoc:CreateFontString(nil)
	local SubText2 = SubLoc:CreateFontString(nil)
	SubText:SetFont(DB.Font, 14*S.mult, "OUTLINE")
	SubText:SetPoint("TOP", Minimap, "TOP", 0, -5)
	SubLoc:SetAllPoints(SubText)
	SubText2:SetPoint("TOP", SubLoc, "BOTTOM", 0,-3)
	SubText2:SetFont(DB.Font, 12*S.mult, "OUTLINE")
	SubLoc:Hide()
	SubText2:SetText("")
	SubText:SetText("")
	Minimap:HookScript('OnEnter', function() 
		SubLoc:Show() 
		SubText2:SetText(GetZoneText())
		SubText:SetText(GetSubZoneText()) 
		UIFrameFadeIn(SubLoc, 1, SubLoc:GetAlpha(), 1)
		local pvp = GetZonePVPInfo()
		if pvp == "friendly" then r,g,b = 0.1,1,0.1 
			elseif pvp == "sanctuary" then r,g,b = 0.41,0.8,0.94 
			elseif pvp =="arena" then r,g,b = 1,0.1,0.1 
			elseif pvp == "hostile" then r,g,b = 1,0.1,0.1 
			elseif pvp == "contested" then r,g,b = 1,0.7,0 
			elseif pvp == "combat" then r,g,b = 1,0.1,0.1 
			else r,g,b = 1,1,1 
		end
		SubText:SetTextColor(r,g,b) 
	end)
	Minimap:HookScript('OnLeave', function() 
		S.FadeOutFrameDamage(SubLoc)
	end)
end	
local function Difficultyflag()
		---Hide Instance Difficulty flag 隐藏难度标志
	MiniMapInstanceDifficulty:ClearAllPoints()
	MiniMapInstanceDifficulty:Hide()

	local rd = CreateFrame("Frame", nil, Minimap)
	rd:RegisterEvent("PLAYER_ENTERING_WORLD")
	rd:RegisterEvent("PLAYER_DIFFICULTY_CHANGED")
	rd:RegisterEvent("GUILD_PARTY_STATE_UPDATED")
	rd:RegisterEvent("UPDATE_INSTANCE_INFO")
	local rdt = S.MakeFontString(rd)
	rdt:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", -5, -5)
	rdt:SetJustifyH('RIGHT')
	rdt:SetTextColor()
	rdt:SetShadowOffset(S.mult, -S.mult)
	rdt:SetShadowColor(0, 0, 0, 0.4)
	rd:SetAllPoints(rdt)
	local function diff()
		local text = ""
		if not IsInInstance()  then rdt:SetText(text) return end
		local _, instanceType, difficulty, _, maxPlayers, _, dynamic  = GetInstanceInfo()
	 	if (instanceType=='pvp') or (instanceType=='arena') then rdt:SetText(text) return end
		
		if instanceType == 'party' then
			if GetChallengeMode() then 
				text = maxPlayers..'C'
			elseif difficulty >= 2 then
				text = maxPlayers..'H'
			else
				text = maxPlayers..'N'
			end
		elseif instanceType == 'raid' and dynamic then
			if difficulty >= 7 then
				text = 'LFR'
			elseif difficulty >= 5 then
				text = maxPlayers..'H'
			else
				text = maxPlayers..'N'
			end
		else
			text = maxPlayers..'N'
		end
		if GuildInstanceDifficulty:IsShown() then
			rdt:SetTextColor(0.40, 0.78, 1)
		else
			rdt:SetTextColor(1, 1, 1)
		end
		rdt:SetText(text)
	end
	rd:SetScript("OnEvent", diff)
end
function Module:OnEnable()
	SkinMiniMap()
	CreateFlash()
	HideMinimapButton()
	MouseScroll()
	RightClickMenu()
	LocationInfo()
	Difficultyflag()
end