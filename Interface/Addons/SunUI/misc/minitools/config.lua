local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local

local MT = S:NewModule("MiniTools", "AceEvent-3.0", "AceHook-3.0", "AceConsole-3.0")
MT.modName = L["小工具"]
function MT:Info()
	return L["小工具"]
end
function MT:GetOptions()
	local options = {
		AutoSell = {
			type = "toggle",
			name = L["启用出售垃圾"],
			order = 1,
			set = function(info, value) self.db.AutoSell = value
				self:UpdateMTSet()
			end,
		},
		AutoRepair = {
			type = "toggle",
			name = L["启用自动修理"],
			order = 2,
			set = function(info, value) self.db.AutoRepair = value
				self:UpdateMTSet()
			end,
		},
		FastError = {
			type = "toggle",
			name = L["启用系统红字屏蔽"],
			order = 4,
			set = function(info, value) self.db.FastError = value
				self:UpdateFastErrorSet()
			end,
		},
		HideRaidWarn = {
			type = "toggle",
			name = L["隐藏团队警告"],
			order = 13,
		},
		Disenchat = {
			type = "toggle",
			name = L["快速分解"],
			order = 14,
			set = function(info, value) self.db.Disenchat = value
				self:UpdateMTSet()
			end,
		},
		Resurrect = {
			type = "toggle",
			name = L["自动接受复活"],
			order = 15,
			set = function(info, value) self.db.Resurrect = value
				self:UpdateMTSet()
			end,
		},
		LowHealth = {
			type = "toggle",
			name = L["低血量报警"],
			order = 14,
			set = function(info, value) self.db.LowHealth = value
				self:UpdateLowHealthSet()
			end,
		},
		afklock  = {
			type = "toggle",
			name = L["AFK界面"],
			order = 14,
			set = function(info, value) self.db.afklock = value
				self:UpdateAFKSet()
			end,
		},
	}
	return options
end


---------------- > Proper Ready Check sound
local ShowReadyCheckHook = function(self, initiator, timeLeft)
	if initiator ~= "player" then PlaySound("ReadyCheck") end
end
hooksecurefunc("ShowReadyCheck", ShowReadyCheckHook)

---------------- > SetupUI
SetCVar("screenshotQuality", 7)


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
function MT:FixBNFrame()
	BNToastFrame:HookScript("OnShow", function(self)
		self:ClearAllPoints()
		self:SetPoint("BOTTOMLEFT", ChatFrame1Tab, "TOPLEFT", 0, 25)
	end)
end
--装备红人
function MT:FixDurabilityFrame()
	local DurabilityFrame = _G["DurabilityFrame"]
	DurabilityFrame:UnregisterAllEvents()
	DurabilityFrame:Kill()
	DurabilityFrame.OnShow  = function() end
end
--头盔披风
function MT:CreateHELM()
	local GameTooltip = GameTooltip
	local helmcb = CreateFrame("CheckButton", nil, PaperDollFrame)
	helmcb:ClearAllPoints()
	helmcb:SetSize(22,22)
	helmcb:SetFrameLevel(10)
	helmcb:SetPoint("TOPLEFT", CharacterHeadSlot, "BOTTOMRIGHT", 5, 5)
	helmcb:SetScript("OnClick", function() ShowHelm(not ShowingHelm()) end)
	helmcb:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText(SHOW_HELM)
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
		GameTooltip:SetText(SHOW_CLOAK)
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
	local A = S:GetModule("Skins")
	A:ReskinCheck(helmcb)
	A:ReskinCheck(cloakcb)
end
function MT:banRaidMessage()
	if self.db.HideRaidWarn then
		_G["RaidWarningFrame"]:ClearAllPoints()
		_G["RaidWarningFrame"]:UnregisterAllEvents()
		RaidWarningFrame.Show = function() end
		RaidWarningFrame.SetPoint = function() end
		_G["RaidWarningFrame"]:Kill()
	end
end
local function aotuClick()
	for i = 1, STATICPOPUP_NUMDIALOGS do
		local frame = _G["StaticPopup"..i]
		if (frame.which == "CONFIRM_LOOT_ROLL" or frame.which == "LOOT_BIND" or frame.which == "LOOT_BIND_CONFIRM") and frame:IsVisible() then 
			StaticPopup_OnClick(frame, 1) 
		end
	end
end
function MT:RESURRECT_REQUEST()
	if not UnitAffectingCombat("player") then
		local delay = GetCorpseRecoveryDelay()
		if delay == 0 then
			AcceptResurrect()
			DoEmote('thanks')
		else
			local b = CreateFrame("Button")
			local formattedText = b:GetText(b:SetFormattedText("%d |4second:seconds", delay))
			AddMessage(string.format(AREA_SPIRIT_HEAL,formattedText))
		end
	end
end
function MT:MERCHANT_SHOW()
	if self.db.AutoRepair then
		if CanMerchantRepair() then
			local cost, possible = GetRepairAllCost()
			if cost>0 then
				local c = cost%100
				local s = math.floor((cost%10000)/100)
				local g = math.floor(cost/10000)
				if IsInGuild() then
					local guildMoney = GetGuildBankWithdrawMoney()
					if guildMoney > cost and CanGuildBankRepair() then
						RepairAllItems(1)
						DEFAULT_CHAT_FRAME:AddMessage("|cffffff00您修理装备花费了公会：|r"..format(GOLD_AMOUNT_TEXTURE, g, 0, 0).." "..format(SILVER_AMOUNT_TEXTURE, s, 0, 0).." "..format(COPPER_AMOUNT_TEXTURE, c, 0, 0),255,255,255)
						return
					else
						RepairAllItems()
					end
				end
				if possible and not CanGuildBankRepair() then
					RepairAllItems()
					DEFAULT_CHAT_FRAME:AddMessage("|cffffff00您修理装备花费了：|r"..format(GOLD_AMOUNT_TEXTURE, g, 0, 0).." "..format(SILVER_AMOUNT_TEXTURE, s, 0, 0).." "..format(COPPER_AMOUNT_TEXTURE, c, 0, 0),255,255,255)
				else
					DEFAULT_CHAT_FRAME:AddMessage("您没有足够的金币以完成修理！",255,0,0)
				end
			end
		end
	end
	if self.db.AutoSell then
		local c = 0
		for b=0,4 do
			for s=1,GetContainerNumSlots(b) do
				local l = GetContainerItemLink(b, s)
				if l then
					local t1 = select(11, GetItemInfo(l))
					local t2 = select(2, GetContainerItemInfo(b, s))
					if t1 then
						local p = t1*t2
						if select(3, GetItemInfo(l))==0 and p>0 then
							UseContainerItem(b, s)
							PickupMerchantItem()
							c = c+p
						end
					end
				end
			end
		end
		if c>0 then
			local g, s, c = math.floor(c/10000) or 0, math.floor((c%10000)/100) or 0, c%100
			DEFAULT_CHAT_FRAME:AddMessage("共售出："..format(GOLD_AMOUNT_TEXTURE, g, 0, 0).." "..format(SILVER_AMOUNT_TEXTURE, s, 0, 0).." "..format(COPPER_AMOUNT_TEXTURE, c, 0, 0),255,255,255)
		end
	end
end

function MT:UpdateMTSet()
	if self.db.Disenchat then
		self:RegisterEvent("CONFIRM_DISENCHANT_ROLL", aotuClick)
		self:RegisterEvent("CONFIRM_LOOT_ROLL", aotuClick)
		self:RegisterEvent("LOOT_BIND_CONFIRM", aotuClick)
	else
		self:UnregisterEvent("CONFIRM_DISENCHANT_ROLL")
		self:UnregisterEvent("CONFIRM_LOOT_ROLL")
		self:UnregisterEvent("LOOT_BIND_CONFIRM")
	end
	if self.db.Resurrect then
		self:RegisterEvent("RESURRECT_REQUEST")
	else
		self:UnregisterEvent("RESURRECT_REQUEST")
	end
	if self.db.AutoRepair or self.db.AutoSell then
		self:RegisterEvent("MERCHANT_SHOW")
	else
		self:UnregisterEvent("MERCHANT_SHOW")
	end
end
function MT:Initialize()
	self:UpdateMTSet()
	self:banRaidMessage()
	self:FixBNFrame()
	self:CreateHELM()
	self:UpdateFastErrorSet()
	self:UpdateLowHealthSet()
	self:UpdateAFKSet()
	self:RegisterEvent("ADDON_LOADED")
end

S:RegisterModule(MT:GetName())