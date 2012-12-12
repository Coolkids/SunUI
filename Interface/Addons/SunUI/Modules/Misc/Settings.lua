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

hooksecurefunc("DoEmote", function(emote)
	if emote == "READ" and UnitChannelInfo("player") then
		CancelEmote()
	end
end)

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
			if (not UnitExists("party1") or UnitIsGroupLeader("player")) and arg1:lower():match(C["MiniDB"]["INVITE_WORD"]) then
				InviteUnit(arg2)
			end
		end)
	end

	if C["MiniDB"]["HideRaidWarn"] then
		_G["RaidWarningFrame"]:ClearAllPoints()
		_G["RaidWarningFrame"]:UnregisterAllEvents()
		RaidWarningFrame.Show = function() end
		RaidWarningFrame.SetPoint = function() end
		_G["RaidWarningFrame"]:Kill()
	end
	if not C["UnitFrameDB"]["showparty"] then
		for i = 1, MAX_PARTY_MEMBERS do
			local PartyMemberFrame = _G["PartyMemberFrame"..i]
			PartyMemberFrame:Kill()
		end
	end
end
function Module:OnEnable()
	_G["TimeManagerClockButton"]:Hide()
	GameTimeFrame:Hide()
end