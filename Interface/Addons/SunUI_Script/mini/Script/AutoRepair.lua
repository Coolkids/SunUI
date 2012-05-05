local S, C, L, DB = unpack(SunUI)
local Module = LibStub("AceAddon-3.0"):GetAddon("Core"):NewModule("AutoRepair")

function Module:OnInitialize()
	C = MiniDB
	if C["AutoRepair"] ~= true then return end
	-- Event
	local Event = CreateFrame("Frame")
	Event:RegisterEvent("MERCHANT_SHOW")
	Event:SetScript("OnEvent", function(self)
		if CanMerchantRepair() then
			local cost, possible = GetRepairAllCost()
			if cost>0 then
				local c = cost%100
				local s = math.floor((cost%10000)/100)
				local g = math.floor(cost/10000)
				if IsInGuild() then
					local guildMoney = GetGuildBankWithdrawMoney()
					if GetGuildBankMoney() ~= 0 then
						if guildMoney > GetGuildBankMoney() then
							guildMoney = GetGuildBankMoney()
						end
					end
					if guildMoney > cost and CanGuildBankRepair() then
						RepairAllItems(1)
						DEFAULT_CHAT_FRAME:AddMessage("|cffffff00您修理装备花费了公会：|r"..format(GOLD_AMOUNT_TEXTURE, g, 0, 0).." "..format(SILVER_AMOUNT_TEXTURE, s, 0, 0).." "..format(COPPER_AMOUNT_TEXTURE, c, 0, 0),255,255,255)
						return
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
	end)
end