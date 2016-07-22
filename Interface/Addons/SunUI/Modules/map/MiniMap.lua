local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local

local MAP = S:NewModule("MINIMAP", "AceEvent-3.0", "AceHook-3.0", "AceConsole-3.0")
MAP.modName = L["地图美化"]
local function SkinMiniMap()
	Minimap:SetMaskTexture("Interface\\ChatFrame\\ChatFrameBackground")
	Minimap:SetFrameStrata("MEDIUM")
	Minimap:ClearAllPoints()
	Minimap:SetSize(160, 160)
	Minimap:CreateShadow()
	Minimap:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", 5, -15)
	S:CreateMover(Minimap, "MinimapMover", L["小地图"], true, nil, "ALL,GENERAL")
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
	PMinimap.texture:SetVertexColor(S.myclasscolor.r, S.myclasscolor.g, S.myclasscolor.b)
	PMinimap.texture:SetBlendMode("ADD")
	
	PMinimap.texture.anim = PMinimap.texture:CreateAnimationGroup()
	
	PMinimap.texture.anim.fadeout = PMinimap.texture.anim:CreateAnimation("ALPHA", "FadeOut")
	PMinimap.texture.anim.fadeout:SetFromAlpha(1)
	PMinimap.texture.anim.fadeout:SetToAlpha(0)
	PMinimap.texture.anim.fadeout:SetOrder(1)
	PMinimap.texture.anim.fadeout:SetDuration(3)

	PMinimap.texture.anim.fade = PMinimap.texture.anim:CreateAnimation("ALPHA", "FadeOut")
	PMinimap.texture.anim.fade:SetFromAlpha(0)
	PMinimap.texture.anim.fade:SetToAlpha(0)
	PMinimap.texture.anim.fade:SetOrder(2)
	PMinimap.texture.anim.fade:SetDuration(2)
	
	PMinimap.texture.anim.fadein = PMinimap.texture.anim:CreateAnimation("ALPHA", "FadeIn")
	PMinimap.texture.anim.fadein:SetFromAlpha(0)
	PMinimap.texture.anim.fadein:SetToAlpha(1)
	PMinimap.texture.anim.fadein:SetOrder(3)
	PMinimap.texture.anim.fadein:SetDuration(3)
	
	PMinimap.texture.anim.fade2 = PMinimap.texture.anim:CreateAnimation("ALPHA", "FadeIn")
	PMinimap.texture.anim.fade2:SetFromAlpha(1)
	PMinimap.texture.anim.fade2:SetToAlpha(1)
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

	
	-- Garrison icon
	GarrisonLandingPageMinimapButton:SetScale(0.5)
	--GarrisonLandingPageMinimapButton:SetAlpha(0)
	GarrisonLandingPageMinimapButton:ClearAllPoints()
	GarrisonLandingPageMinimapButton:SetPoint("BOTTOM", MiniMapTracking, "TOP", 0, 8)
	
	if FeedbackUIButton then
		FeedbackUIButton:ClearAllPoints()
		FeedbackUIButton:SetPoint("TOPLEFT", Minimap, "TOPLEFT", -6, -26)
		FeedbackUIButton:SetScale(0.8)
	end

	if StreamingIcon then
		StreamingIcon:ClearAllPoints()
		StreamingIcon:SetPoint("TOPLEFT", Minimap, "TOPLEFT", -6, -46)
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
		{text = CHARACTER_BUTTON,
		func = function() ToggleCharacter("PaperDollFrame") end},
		{text = SPELLBOOK_ABILITIES_BUTTON,
		func = function() if not SpellBookFrame:IsShown() then ShowUIPanel(SpellBookFrame) else HideUIPanel(SpellBookFrame) end end},
		{text = TALENTS_BUTTON,
		func = function()
			if not PlayerTalentFrame then
				TalentFrame_LoadUI()
			end
			if not PlayerTalentFrame:IsShown() then
				ShowUIPanel(PlayerTalentFrame)
			else
				HideUIPanel(PlayerTalentFrame)
			end
		end},	
		{text = COLLECTIONS, 
		func = function() 
			ToggleCollectionsJournal(); 
		end},
		{text = TIMEMANAGER_TITLE,
		func = function() ToggleFrame(TimeManagerFrame) end},		
		{text = ACHIEVEMENT_BUTTON,
		func = function() ToggleAchievementFrame() end},
		{text = SOCIAL_BUTTON,
		func = function() ToggleFriendsFrame() end},
		{text = SLASH_CALENDAR2:gsub("/(.*)","%1"), func = function() if(not CalendarFrame) then LoadAddOn("Blizzard_Calendar") end Calendar_Toggle() end},
		{text = ACHIEVEMENTS_GUILD_TAB,
		func = function()
			if IsInGuild() then
				if not GuildFrame then GuildFrame_LoadUI() end
				GuildFrame_Toggle()
			else
				if not LookingForGuildFrame then LookingForGuildFrame_LoadUI() end
				if not LookingForGuildFrame then return end
				LookingForGuildFrame_Toggle()
			end
		end},
		{text = QUESTLOG_BUTTON, func = function()
			ToggleQuestLog()
		end},
		{text = LFG_TITLE,
		func = function() PVEFrame_ToggleFrame(); end},
		{text = ENCOUNTER_JOURNAL, 
		func = function() if not IsAddOnLoaded('Blizzard_EncounterJournal') then EncounterJournal_LoadUI(); end ToggleFrame(EncounterJournal) end},
		{text = GARRISON_LANDING_PAGE_TITLE, 
		func = function() 
			GarrisonLandingPage_Toggle()
		end},
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
	SubText:FontTemplate(nil, 14)
	SubText:SetPoint("TOP", Minimap, "TOP", 0, -5)
	SubLoc:SetAllPoints(SubText)
	SubText2:SetPoint("TOP", SubLoc, "BOTTOM", 0,-3)
	SubText2:FontTemplate()
	SubLoc:Hide()
	SubText2:SetText("")
	SubText:SetText("")
	Minimap:HookScript('OnEnter', function()
		SubLoc:Show() 
		SubText2:SetText(GetZoneText())
		SubText:SetText(GetSubZoneText()) 
		UIFrameFadeIn(SubLoc, 0.3, SubLoc:GetAlpha(), 1)
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
		S:FadeOutFrame(SubLoc, 0.3)
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
	local rdt = rd:CreateFontString(nil, "OVERLAY")
	rdt:FontTemplate(nil, 12, "THINOUTLINE")
	rdt:SetPoint("BOTTOM", Minimap, "BOTTOM", 0, 3)
	rd:SetAllPoints(rdt)
	local function diff()
		local text = ""
		if not IsInInstance()  then rdt:SetText(text) return end
		local _, instanceType, difficulty, difficultyName, maxPlayers, _, dynamic  = GetInstanceInfo()
	 	if (instanceType=='pvp') or (instanceType=='arena') then rdt:SetText(text) return end
		
		if difficultyName~=nil then text = difficultyName end
		--[[if instanceType == 'party' then
			text = difficultyName
		elseif instanceType == 'raid' and dynamic then
			text = difficultyName
		else
			text = difficultyName
		end]]
		if GuildInstanceDifficulty:IsShown() then
			rdt:SetTextColor(0.40, 0.78, 1)
		else
			rdt:SetTextColor(1, 1, 1)
		end
		rdt:SetText(text)
	end
	rd:SetScript("OnEvent", diff)
end

function MAP:Initialize()
	SkinMiniMap()
	CreateFlash()
	HideMinimapButton()
	MouseScroll()
	RightClickMenu()
	LocationInfo()
	Difficultyflag()
end

S:RegisterModule(MAP:GetName())
