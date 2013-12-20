local S, L, DB, _, C = unpack(select(2, ...))
local AR = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("AutoRepair", "AceEvent-3.0")
local SunUIConfig = LibStub("AceAddon-3.0"):GetAddon("SunUI"):GetModule("SunUIConfig")

function AR:MERCHANT_SHOW()
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

function AR:UpdateSet()
	if C["AutoRepair"] then
		self:RegisterEvent("MERCHANT_SHOW")
	else
		self:UnregisterEvent("MERCHANT_SHOW")
	end
end
function AR:OnInitialize()
	C = SunUIConfig.db.profile.MiniDB
	self:UpdateSet()
end