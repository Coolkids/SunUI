local addon = CreateFrame("Frame")

-- Used to detect 4.0, 5.0 and 6.0 clients
local cata = select(4, GetBuildInfo()) >= 40000
local mop  = select(4, GetBuildInfo()) >= 50000
local wod  = select(4, GetBuildInfo()) >= 60000
local leg  = select(4, GetBuildInfo()) >= 70000

-- Based on the frame list from NDragIt by Nemes.
-- These frames are hooked on login.
local frames = {
  -- ["FrameName"] = true (the parent frame should be moved) or false (the frame itself should be moved)
  -- for child frames (i.e. frames that don't have a name, but only a parentKey="XX" use
  -- "ParentFrameName.XX" as frame name. more than one level is supported, e.g. "Foo.Bar.Baz")

  -- Blizzard Frames
  ["SpellBookFrame"] = false,
  ["QuestLogFrame"] = false,
  ["QuestLogDetailFrame"] = false,
  ["FriendsFrame"] = false,
  ["KnowledgeBaseFrame"] = true,
  ["HelpFrame"] = false,
  ["GossipFrame"] = false,
  ["MerchantFrame"] = false,
  ["MailFrame"] = false,
  ["OpenMailFrame"] = false,
  ["GuildRegistrarFrame"] = false,
  ["DressUpFrame"] = false,
  ["TabardFrame"] = false,
  ["TaxiFrame"] = false,
  ["QuestFrame"] = false,
  ["TradeFrame"] = false,
  ["LootFrame"] = false,
  ["PetStableFrame"] = false,
  ["StackSplitFrame"] = false,
  ["PetitionFrame"] = false,
  ["WorldStateScoreFrame"] = false,
  ["BattlefieldFrame"] = false,
  ["ArenaFrame"] = false,
  ["ItemTextFrame"] = false,
  ["GameMenuFrame"] = false,
  ["InterfaceOptionsFrame"] = false,
  ["MacOptionsFrame"] = false,
  ["PetPaperDollFrame"] = true,
  ["PetPaperDollFrameCompanionFrame"] = "CharacterFrame",
  ["PetPaperDollFramePetFrame"] = "CharacterFrame",
  ["PaperDollFrame"] = true,
  ["ReputationFrame"] = true,
  ["SkillFrame"] = true,
  ["PVPFrame"] = not cata, -- changed in cataclysm
  ["PVPBattlegroundFrame"] = true,
  ["SendMailFrame"] = true,
  ["TokenFrame"] = true,
  ["InterfaceOptionsFrame"] = false,
  ["VideoOptionsFrame"] = false,
  ["AudioOptionsFrame"] = false,
  ["BankFrame"] = false,
  ["StaticPopup1"] = false,
  ["EncounterJournal"] = false, -- only in 4.2
  ["RaidParentFrame"] = false,
  ["TutorialFrame"] = false,
  ["MissingLootFrame"] = false,
  ["ScrollOfResurrectionSelectionFrame"] = false,
  ["AddFriendFrame"] = false,
  -- New frames in MoP
  ["PVPBannerFrame"] = false,
  ["PVEFrame"] = false, -- dungeon finder + challenges
  ["GuildInviteFrame"] = false,
  ["QuestLogPopupDetailFrame"] = false,

  -- WOD
  ["AddonList"] = false,
  ["SplashFrame"] = false,

  -- AddOns
  ["LudwigFrame"] = false,

}

if not wod then
  -- Dungeon Finder was changed in 5.0, this would break the new interface
  frames["LFGParentFrame"] = false
  frames["LFDQueueFrame"] = true
  frames["LFRQueueFrame"] = true
  frames["LFRBrowseFrame"] = true
end

if leg then
  frames["WorldMapFrame"] = false
  frames["WorldMapTitleButton"] = true
  frames["QuestMapFrame"] = true
end

-- Frames provided by load on demand addons, hooked when the addon is loaded.
local lodFrames = {
  -- AddonName = { list of frames, same syntax as above }
  Blizzard_AuctionUI = { ["AuctionFrame"] = false },
  Blizzard_BindingUI = { ["KeyBindingFrame"] = false },
  Blizzard_CraftUI = { ["CraftFrame"] = false },
  Blizzard_GMSurveyUI = { ["GMSurveyFrame"] = false },
  Blizzard_InspectUI = { ["InspectFrame"] = false, ["InspectPVPFrame"] = true, ["InspectTalentFrame"] = true },
  Blizzard_ItemSocketingUI = { ["ItemSocketingFrame"] = false },
  Blizzard_MacroUI = { ["MacroFrame"] = false },
  Blizzard_TalentUI = { ["PlayerTalentFrame"] = false },
  Blizzard_TradeSkillUI = { ["TradeSkillFrame"] = false },
  Blizzard_TrainerUI = { ["ClassTrainerFrame"] = false },
  Blizzard_GuildBankUI = { ["GuildBankFrame"] = false, ["GuildBankEmblemFrame"] = true },
  Blizzard_TimeManager = { ["TimeManagerFrame"] = false },
  Blizzard_AchievementUI = { ["AchievementFrame"] = false, ["AchievementFrameHeader"] = false,  ["AchievementFrame.searchBox"] = false, ["AchievementFrameCategoriesContainer"] = "AchievementFrame" },
  Blizzard_TokenUI = { ["TokenFrame"] = true },
  Blizzard_ItemSocketingUI = { ["ItemSocketingFrame"] = false },
  --Blizzard_GlyphUI = { ["GlyphFrame"] = true },
  Blizzard_BarbershopUI = { ["BarberShopFrame"] = false },
  Blizzard_Calendar = { ["CalendarFrame"] = false, ["CalendarCreateEventFrame"] = true },
  Blizzard_GuildUI = { ["GuildFrame"] = false, ["GuildRosterFrame"] = true, ["GuildFrame.TitleMouseover"] = true },
  Blizzard_ReforgingUI = { ["ReforgingFrame"] = false, ["ReforgingFrameInvisibleButton"] = true, ["ReforgingFrame.InvisibleButton"] = true },
  Blizzard_ArchaeologyUI = { ["ArchaeologyFrame"] = false },
  Blizzard_LookingForGuildUI = { ["LookingForGuildFrame"] = false },
  Blizzard_VoidStorageUI = { ["VoidStorageFrame"] = false, ["VoidStorageBorderFrameMouseBlockFrame"] = "VoidStorageFrame" },
  Blizzard_ItemAlterationUI = { ["TransmogrifyFrame"] = false },
  Blizzard_EncounterJournal = { ["EncounterJournal"] = false }, -- as of 4.3
  Blizzard_GarrisonUI = { ["GarrisonLandingPage"] = false, ["GarrisonLandingPageReport"] = true, ["GarrisonMissionFrame"] = false, ["GarrisonMissionFrame.MissionTab"] = true, ["GarrisonBuildingFrame"] = false, GarrisonRecruiterFrame = false,GarrisonRecruitSelectFrame = false, GarrisonCapacitiveDisplayFrame = false, GarrisonShipyardFrame = false},

  -- New frames in LEG
  Blizzard_TalkingHeadUI= { ["TalkingHeadFrame"] = false},
  Blizzard_OrderHallUI= { ["OrderHallMissionFrame"] = false, ["OrderHallMissionFrame.MissionTab"] = true,["OrderHallTalentFrame"] = false},
  Blizzard_ArtifactUI= { ["ArtifactFrame"] = false},

  -- New frames in MoP
  Blizzard_Collections = { ["CollectionsJournal"] = false },
  Blizzard_BlackMarketUI = { ["BlackMarketFrame"] = false }, -- UNTESTED
  Blizzard_ChallengesUI = { ["ChallengesLeaderboardFrame"] = false }, -- UNTESTED
  Blizzard_ItemUpgradeUI = { ["ItemUpgradeFrame"] = false, }, -- UNTESTED
}

if not leg then
  lodFrames["Blizzard_PVPUI"] = { ["PVPUIFrame"] = false }
end

local parentFrame = {}
local hooked = {}

local function print(msg)
  DEFAULT_CHAT_FRAME:AddMessage("DragEmAll: " .. msg)
end

function addon:PLAYER_LOGIN()
  self:HookFrames(frames)
end

function addon:ADDON_LOADED(name)
  local frameList = lodFrames[name]
  if frameList then
    self:HookFrames(frameList)
  end
end

local function MouseDownHandler(frame, button)
  frame = parentFrame[frame] or frame
  if frame and button == "LeftButton" then
    frame:StartMoving()
    frame:SetUserPlaced(false)
  end
end

local function MouseUpHandler(frame, button)
  frame = parentFrame[frame] or frame
  if frame and button == "LeftButton" then
    frame:StopMovingOrSizing()
  end
end

function addon:HookFrames(list)
  for name, child in pairs(list) do
    self:HookFrame(name, child)
  end
end
