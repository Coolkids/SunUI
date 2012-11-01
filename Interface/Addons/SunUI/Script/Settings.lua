local S, C, L, DB = unpack(select(2, ...))
local _
local Module = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("Settings")
local _G = _G
--if true then return end
---------------- > Proper Ready Check sound
local ShowReadyCheckHook = function(self, initiator, timeLeft)
	if initiator ~= "player" then PlaySound("ReadyCheck") end
end
hooksecurefunc("ShowReadyCheck", ShowReadyCheckHook)


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
-- 实名好友弹窗位置修正
BNToastFrame:HookScript("OnShow", function(self)
	self:ClearAllPoints()
	self:SetPoint("BOTTOMLEFT", ChatFrame1Tab, "TOPLEFT", 0, 25)
end)
--装备红人
local DurabilityFrame = _G["DurabilityFrame"]
DurabilityFrame:UnregisterAllEvents()
DurabilityFrame:Kill()
DurabilityFrame:HookScript("OnShow", function(self)
	self:Hide()
end)
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
	GameTooltip:SetText("显示头盔")
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
	GameTooltip:SetText("显示披风")
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
S.ReskinCheck(helmcb)
S.ReskinCheck(cloakcb)
function Module:OnInitialize()
	if TimeManagerClockButton then TimeManagerClockButton:Hide() end
	GameTimeFrame:Hide()
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
		_G["RaidWarningFrame"]:ClearAllPoints()
		_G["RaidWarningFrame"]:Kill()
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
			GetQuestReward(1)
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
end