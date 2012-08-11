local S, C, L, DB = unpack(SunUI)
local Module = LibStub("AceAddon-3.0"):GetAddon("Core"):NewModule("Settings")

SlashCmdList['RELOADUI'] = function() ReloadUI() end
SLASH_RELOADUI1 = '/rl'

SlashCmdList["TICKET"] = function() ToggleHelpFrame() end
SLASH_TICKET1 = "/gm"

SlashCmdList["READYCHECK"] = function() DoReadyCheck() end
SLASH_READYCHECK1 = '/rc'

SlashCmdList["CHECKROLE"] = function() InitiateRolePoll() end
SLASH_CHECKROLE1 = '/cr'

SlashCmdList["DISABLE_ADDON"] = function(s) DisableAddOn(s) print(s, format("|cffd36b6b disabled")) end
SLASH_DISABLE_ADDON1 = "/dis"   -- You need to reload UI after enabling/disabling addon

SlashCmdList["ENABLE_ADDON"] = function(s) EnableAddOn(s) print(s, format("|cfff07100 enabled")) end
SLASH_ENABLE_ADDON1 = "/en"   -- You need to reload UI after enabling/disabling addon

SlashCmdList["CLCE"] = function() CombatLogClearEntries() end
SLASH_CLCE1 = "/clc"


-- simple spec and equipment switching
SlashCmdList["SPEC"] = function() 
	if GetActiveTalentGroup()==1 then SetActiveTalentGroup(2) elseif GetActiveTalentGroup()==2 then SetActiveTalentGroup(1) end
end
SLASH_SPEC1 = "/ss"

---------------- > Proper Ready Check sound
local ShowReadyCheckHook = function(self, initiator, timeLeft)
	if initiator ~= "player" then PlaySound("ReadyCheck") end
end
hooksecurefunc("ShowReadyCheck", ShowReadyCheckHook)
function Module:OnInitialize()
-- Quest tracker(by Tukz)
local wf = WatchFrame
local wfmove = false 

wf:SetMovable(true);
wf:SetClampedToScreen(false); 
wf:ClearAllPoints()
wf:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -35, -200)
wf:SetUserPlaced(true)
wf:SetSize(180, 500)
wf.SetPoint = function() end
wfg = CreateFrame("Frame")
wfg:SetPoint("TOPLEFT", wf, "TOPLEFT")
wfg:SetPoint("BOTTOMRIGHT", wf, "BOTTOMRIGHT")
wfg.text = S.MakeFontString(wfg, 14)
wfg.text:SetText("点我拖动")
wfg.text:SetPoint("TOP", wfg, "TOP")
wfg:CreateShadow("Background")
wfg:Hide()
local function WATCHFRAMELOCK()
	if wfmove == false then
		wfmove = true
		wfg:Show()
		print("|cffFFD700任务追踪框|r |cff228B22解锁|r")
		wf:EnableMouse(true);
		wf:RegisterForDrag("LeftButton"); 
		wf:SetScript("OnDragStart", wf.StartMoving); 
		wf:SetScript("OnDragStop", wf.StopMovingOrSizing);
	elseif wfmove == true then
		wf:EnableMouse(false);
		wfmove = false
		wfg:Hide()
		print("|cffFFD700任务追踪框|r |cffFF0000锁定|r")
	end
end
SLASH_WATCHFRAMELOCK1 = "/wf"
SlashCmdList["WATCHFRAMELOCK"] = WATCHFRAMELOCK
-- VS移动(by Coolkid)
local vs = VehicleSeatIndicator
local vsmove = false 

vs:SetMovable(true);
vs:SetClampedToScreen(false);
vs:ClearAllPoints()
vs:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -150, 250)


vs:SetUserPlaced(true)
vs.SetPoint = function() end
vsg = CreateFrame("Frame")
vsg:SetPoint("TOPLEFT", vs, "TOPLEFT")
vsg:SetPoint("BOTTOMRIGHT", vs, "BOTTOMRIGHT")
vsg.text = S.MakeFontString(vsg, 14)
vsg.text:SetText("点我拖动")
vsg.text:SetPoint("TOP", vsg, "TOP")
vsg:CreateShadow("Background")
vsg:Hide()
local function VSLOCK()
	if vsmove == false then
		vsmove = true
		vsg:Show()
		print("|cffFFD700载具框|r |cff228B22解锁|r")
		vs:EnableMouse(true);
		vs:RegisterForDrag("LeftButton"); 
		vs:SetScript("OnDragStart", vs.StartMoving); 
		vs:SetScript("OnDragStop", vs.StopMovingOrSizing);
	elseif vsmove == true then
		vs:EnableMouse(false);
		vsmove = false
		vsg:Hide()
		print("|cffFFD700载具框|r |cffFF0000锁定|r")
	end
end

SLASH_VehicleSeatIndicatorLOCK1 = "/vs"
SlashCmdList["VehicleSeatIndicatorLOCK"] = VSLOCK

--隐藏团队报警
--RaidBossEmoteFrame:UnregisterEvent("RAID_BOSS_EMOTE")  --Disable Boss Emote Frame
--RaidBossEmoteFrame:UnregisterEvent("RAID_BOSS_WHISPER") --Disable Boss Whisper Frame
--分解不必再点确定

if C["MiniDB"]["Disenchat"] then
	local aotuClick = CreateFrame("Frame")
	aotuClick:RegisterEvent("CONFIRM_DISENCHANT_ROLL")
	aotuClick:RegisterEvent("CONFIRM_LOOT_ROLL")
	aotuClick:RegisterEvent("LOOT_BIND_CONFIRM")      
	aotuClick:SetScript("OnEvent", function(self, event, ...)
	   for i = 1, STATICPOPUP_NUMDIALOGS do
		  local frame = _G["StaticPopup"..i]
		  if (frame.which == "CONFIRM_LOOT_ROLL" or frame.which == "LOOT_BIND" or frame.which == "LOOT_BIND_CONFIRM") and frame:IsVisible() then 
		  StaticPopup_OnClick(frame, 1) 
		  end
	   end
	end)
end
if C["MiniDB"]["Resurrect"] then
	local function ResurrectEvent()
			if not UnitAffectingCombat("player") then
				local delay = GetCorpseRecoveryDelay()
				if delay == 0 then
					AcceptResurrect()
					DoEmote('thanks')
				else
					local b = CreateFrame("Button")
					local formattedText = b:GetText(b:SetFormattedText("%d |4second:seconds", delay))
					AddMessage("还有"..formattedText.."才能起来。")
				end
			end
		end
	local Resurrect = CreateFrame("Frame")
	Resurrect:RegisterEvent("RESURRECT_REQUEST")
	Resurrect:SetScript("OnEvent", ResurrectEvent)
end

---------------- > SetupUI
SetCVar("screenshotQuality", 7)
if GetCVar("scriptProfile") == "1" then SetCVar("scriptProfile", 0) end

---------------- > ALT+RightClick to buy a stack
hooksecurefunc("MerchantItemButton_OnModifiedClick", function(self, button)
    if MerchantFrame.selectedTab == 1 then
        if IsAltKeyDown() and button=="RightButton" then
            local id=self:GetID()
			local quantity = select(4, GetMerchantItemInfo(id))
            local extracost = select(7, GetMerchantItemInfo(id))
            if not extracost then
                local stack 
				if quantity > 1 then
					stack = quantity*GetMerchantItemMaxStack(id)
				else
					stack = GetMerchantItemMaxStack(id)
				end
                local amount = 1
                if self.count < stack then
                    amount = stack / self.count
                end
                if self.numInStock ~= -1 and self.numInStock < amount then
                    amount = self.numInStock
                end
                local money = GetMoney()
                if (self.price * amount) > money then
                    amount = floor(money / self.price)
                end
                if amount > 0 then
                    BuyMerchantItem(id, amount)
                end
            end
        end
    end
end)

--隐藏团队
if C["MiniDB"]["HideRaid"] then
CompactRaidFrameManager:UnregisterAllEvents()
CompactRaidFrameManager.Show = function() end
CompactRaidFrameManager:Hide()
CompactRaidFrameContainer:UnregisterAllEvents()
CompactRaidFrameContainer.Show = function() end
CompactRaidFrameContainer:Hide()	
end
-- 隐藏小队框体
if not C["UnitFrameDB"]["showparty"] then
for i = 1, MAX_PARTY_MEMBERS do
	local PartyMemberFrame = _G["PartyMemberFrame"..i]
	PartyMemberFrame:UnregisterAllEvents()
	PartyMemberFrame:Hide()
	PartyMemberFrame.Show = function() end
end
UIParent:UnregisterEvent("RAID_ROSTER_UPDATE")
end
---------------- > Autoinvite by whisper
if C["MiniDB"]["Autoinvite"] then
local f = CreateFrame("frame")
f:RegisterEvent("CHAT_MSG_WHISPER")
f:SetScript("OnEvent", function(self,event,arg1,arg2)
    if (not UnitExists("party1") or IsPartyLeader("player")) and arg1:lower():match(C["MiniDB"]["INVITE_WORD"]) then
        InviteUnit(arg2)
    end
end)
end

if C["MiniDB"]["HideRaidWarn"] then
	RaidWarningFrame:ClearAllPoints()
	RaidWarningFrame:Hide()
	RaidWarningFrame:UnregisterAllEvents()
	RaidWarningFrame.Show = function() end
	RaidWarningFrame.SetPoint = function() end
end

if C["MiniDB"]["AutoQuest"] then
	local addon = CreateFrame('Frame')
	addon.completed_quests = {}
	addon.incomplete_quests = {}

	function addon:canAutomate ()
	  if IsShiftKeyDown() then
		return false
	  else
		return true
	  end
	end

	function addon:strip_text (text)
	  if not text then return end
	  text = text:gsub('|c%x%x%x%x%x%x%x%x(.-)|r','%1')
	  text = text:gsub('%[.*%]%s*','')
	  text = text:gsub('(.+) %(.+%)', '%1')
	  text = text:trim()
	  return text
	end

	function addon:QUEST_PROGRESS ()
	  if not self:canAutomate() then return end
	  if IsQuestCompletable() then
		CompleteQuest()
	  end
	end

	function addon:QUEST_LOG_UPDATE ()
	  if not self:canAutomate() then return end
	  local start_entry = GetQuestLogSelection()
	  local num_entries = GetNumQuestLogEntries()
	  local title
	  local is_complete
	  local no_objectives

	  self.completed_quests = {}
	  self.incomplete_quests = {}

	  if num_entries > 0 then
		for i = 1, num_entries do
		  SelectQuestLogEntry(i)
		  title, _, _, _, _, _, is_complete = GetQuestLogTitle(i)
		  no_objectives = GetNumQuestLeaderBoards(i) == 0
		  if title then
			if is_complete or no_objectives then
			  self.completed_quests[title] = true
			else
			  self.incomplete_quests[title] = true
			end
		  end
		end
	  end

	  SelectQuestLogEntry(start_entry)
	end

	function addon:GOSSIP_SHOW ()
	  if not self:canAutomate() then return end

	  local button
	  local text

	  for i = 1, 32 do
		button = _G['GossipTitleButton' .. i]
		if button:IsVisible() then
		  text = self:strip_text(button:GetText())
		  ABCDE={button:GetText(), text}
		  if button.type == 'Available' then
			button:Click()
		  elseif button.type == 'Active' then
			if self.completed_quests[text] then
			  button:Click()
			end
		  end
		end
	  end
	end

	function addon:QUEST_GREETING (...)
	  if not self:canAutomate() then return end

	  local button
	  local text

	  for i = 1, 32 do
		button = _G['QuestTitleButton' .. i]
		if button:IsVisible() then
		  text = self:strip_text(button:GetText())
		  if self.completed_quests[text] then
			button:Click()
		  elseif not self.incomplete_quests[text] then
			button:Click()
		  end
		end
	  end
	end

	function addon:QUEST_DETAIL ()
	  if not self:canAutomate() then return end
	  AcceptQuest()
	end

	function addon:QUEST_COMPLETE (event)
	  if not self:canAutomate() then return end
	  if GetNumQuestChoices() <= 1 then
		GetQuestReward(QuestFrameRewardPanel.itemChoice)
	  end
	end

	function addon.onevent (self, event, ...)
	  if self[event] then
		self[event](self, ...)
	  end
	end

	addon:SetScript('OnEvent', addon.onevent)
	addon:RegisterEvent('GOSSIP_SHOW')
	addon:RegisterEvent('QUEST_COMPLETE')
	addon:RegisterEvent('QUEST_DETAIL')
	addon:RegisterEvent('QUEST_FINISHED')
	addon:RegisterEvent('QUEST_GREETING')
	addon:RegisterEvent('QUEST_LOG_UPDATE')
	addon:RegisterEvent('QUEST_PROGRESS')

	_G.idQuestAutomation = addon
	QuestInfoDescriptionText.SetAlphaGradient=function() return false end
end
if C["MiniDB"]["FatigueWarner"] then
	local function FatigueWarner_OnUpdate(self) 
		local timer, value, maxvalue, scale, paused, label = GetMirrorTimerInfo(1) 
		if timer == "EXHAUSTION" then 
			PlaySoundFile("Sound\\Creature\\XT002Deconstructor\\UR_XT002_Special01.wav", "Master")
		end 
		self:SetScript("OnUpdate", nil) 
	end 
	 
	local function FatigueWarner_OnEvent(self) 
		self:SetScript("OnUpdate", FatigueWarner_OnUpdate) 
	end 
		  
	-- Sinnlos; strip bringt ja irgendwie nichts fiel mir dann auf :>
	local function FatigueWarner_Strip()
		local FatigueWarner_StripTable = {16, 17, 18, 5, 7, 1, 3, 10, 8, 6, 9}
		local start = 1
		local finish = table.getn(FatigueWarner_StripTable)

		for bag = 0, 4 do
			for slot=1, GetContainerNumSlots(bag) do
				if not GetContainerItemLink(bag, slot) then
					for i = start, finish do
						if GetInventoryItemLink("player", FatigueWarner_StripTable[i]) then
							PickupInventoryItem(FatigueWarner_StripTable[i])
							PickupContainerItem(bag, slot)
							start = i + 1
							break
						end
					end
				end
			end
		end
	end

	local FatigueWarnerFrame = CreateFrame("frame")
	FatigueWarnerFrame:RegisterEvent("MIRROR_TIMER_START")
	FatigueWarnerFrame:RegisterEvent("MIRROR_TIMER_STOP")
	FatigueWarnerFrame:SetScript("OnEvent", FatigueWarner_OnEvent)
end

-- 实名好友弹窗位置修正
BNToastFrame:HookScript("OnShow", function(self)
	self:ClearAllPoints()
	self:SetPoint("BOTTOMLEFT", ChatFrame1Tab, "TOPLEFT", 0, 25)
end)
--装备红人
DurabilityFrame = _G["DurabilityFrame"]
DurabilityFrame:HookScript("OnShow", function(self)
	self:Hide()
	self:UnregisterAllEvents()
end)

---------------- > Disband Group
local GroupDisband = function()
	local pName = UnitName("player")
	if UnitInRaid("player") then
	SendChatMessage("Disbanding group.", "RAID")
		for i = 1, GetNumRaidMembers() do
			local name, _, _, _, _, _, _, online = GetRaidRosterInfo(i)
			if online and name ~= pName then
				UninviteUnit(name)
			end
		end
	else
		SendChatMessage("Disbanding group.", "PARTY")
		for i = MAX_PARTY_MEMBERS, 1, -1 do
			if GetPartyMember(i) then
				UninviteUnit(UnitName("party"..i))
			end
		end
	end
	LeaveParty()
end
StaticPopupDialogs["DISBAND_RAID"] = {
	text = "Do you really want to disband this group?",
	button1 = YES,
	button2 = NO,
	OnAccept = GroupDisband,
	timeout = 0,
	whileDead = 1,}
SlashCmdList["GROUPDISBAND"] = function()
	StaticPopup_Show("DISBAND_RAID")
end
SLASH_GROUPDISBAND1 = '/rd'
-- convert group from raid to party
SlashCmdList["RAIDTOPARTY"] = function()
	if GetNumRaidMembers()==0 then
		print("You are not in a raid.")
	elseif GetNumRaidMembers() <= MEMBERS_PER_RAID_GROUP then
		ConvertToParty()
		print("Converting raid into a party complete.")
	else
		print("Unable to convert the raid into a party.")
	end
end
SLASH_RAIDTOPARTY1 = '/rtp'
-- convert group from party to raid
SlashCmdList["PARTYTORAID"] = function()
	if GetNumRaidMembers() > 0 then
		print("You are in a raid.")
	elseif GetNumPartyMembers() > 0 then
		ConvertToRaid()
		print("Converting party into a raid complete.")
	else
		print("You are not in a party.")
	end
end
SLASH_PARTYTORAID1 = '/ptr'

----------------- > Cloak / Helm toggle check boxes at PaperDollFrame
local GameTooltip = GameTooltip
local helmcb = CreateFrame("CheckButton", nil, PaperDollFrame)
helmcb:ClearAllPoints()
helmcb:SetSize(22,22)
helmcb:SetFrameLevel(10)
helmcb:SetPoint("TOPLEFT", CharacterHeadSlot, "BOTTOMRIGHT", 5, 5)
helmcb:SetScript("OnClick", function() ShowHelm(not ShowingHelm()) end)
helmcb:SetScript("OnEnter", function(self)
 	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:SetText("Toggle helm")
end)
helmcb:SetScript("OnLeave", function() GameTooltip:Hide() end)
helmcb:SetScript("OnEvent", function() helmcb:SetChecked(ShowingHelm()) end)
helmcb:SetNormalTexture("Interface\\Buttons\\UI-CheckBox-Up")
helmcb:SetPushedTexture("Interface\\Buttons\\UI-CheckBox-Down")
helmcb:SetHighlightTexture("Interface\\Buttons\\UI-CheckBox-Highlight")
helmcb:SetDisabledCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check-Disabled")
helmcb:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check")
helmcb:RegisterEvent("UNIT_MODEL_CHANGED")

local cloakcb = CreateFrame("CheckButton", nil, PaperDollFrame)
cloakcb:ClearAllPoints()
cloakcb:SetSize(22,22)
cloakcb:SetFrameLevel(10)
cloakcb:SetPoint("TOPLEFT", CharacterBackSlot, "BOTTOMRIGHT", 5, 5)
cloakcb:SetScript("OnClick", function() ShowCloak(not ShowingCloak()) end)
cloakcb:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:SetText("Toggle cloak")
end)
cloakcb:SetScript("OnLeave", function() GameTooltip:Hide() end)
cloakcb:SetScript("OnEvent", function() cloakcb:SetChecked(ShowingCloak()) end)
cloakcb:SetNormalTexture("Interface\\Buttons\\UI-CheckBox-Up")
cloakcb:SetPushedTexture("Interface\\Buttons\\UI-CheckBox-Down")
cloakcb:SetHighlightTexture("Interface\\Buttons\\UI-CheckBox-Highlight")
cloakcb:SetDisabledCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check-Disabled")
cloakcb:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check")
cloakcb:RegisterEvent("UNIT_MODEL_CHANGED")

helmcb:SetChecked(ShowingHelm())
cloakcb:SetChecked(ShowingCloak())
end