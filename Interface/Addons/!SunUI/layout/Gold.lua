local S, C, L, DB = unpack(select(2, ...))
local Core = LibStub("AceAddon-3.0"):GetAddon("Core")
local Module = Core:NewModule("Gold")

function Module:OnEnable()
	local Stat = CreateFrame("Frame")
	Stat:EnableMouse(true)
	Stat:SetFrameStrata("BACKGROUND")
	Stat:SetFrameLevel(3)
	
	local Text  = Stat:CreateFontString(nil, "OVERLAY")
	Text:SetFont(DB.Font, 11*S.Scale(1)*MiniDB["FontScale"], "THINOUTLINE")
	Text:SetShadowOffset(1.25, -1.25)
	Text:SetShadowColor(0, 0, 0, 0.4)
	Text:Point("BOTTOMRIGHT", Currency, "BOTTOMRIGHT", -5, -8)
	Stat:SetParent(Currency)

	local Profit	= 0
	local Spent		= 0
	local OldMoney	= 0

	local function formatMoney(money)
		local gold = floor(math.abs(money) / 10000)
		local silver = mod(floor(math.abs(money) / 100), 100)
		local copper = mod(floor(math.abs(money)), 100)
		if gold ~= 0 then
			return format("%s".."|cffffd700g|r".." %s".."|cffc7c7cfs|r".." %s".."|cffeda55fc|r", gold, silver, copper)
		elseif silver ~= 0 then
			return format("%s".."|cffc7c7cfs|r".." %s".."|cffeda55fc|r", silver, copper)
		else
			return format("%s".."|cffeda55fc|r", copper)
		end
	end
	
	local function formatTextMoney(money)
		return format("%.0f|cffffd700%s|r", money * 0.0001, "g")
	end

	local function FormatTooltipMoney(money)
		local gold, silver, copper = abs(money / 10000), abs(mod(money / 100, 100)), abs(mod(money, 100))
		local cash = ""
		cash = format("%d".."|cffffd700g|r".." %d".."|cffc7c7cfs|r".." %d".."|cffeda55fc|r", gold, silver, copper)		
		return cash
	end	

	local function OnEvent(self, event)
		if event == "PLAYER_ENTERING_WORLD" then
			OldMoney = GetMoney()
		end
		
		local NewMoney	= GetMoney()
		local Change = NewMoney-OldMoney -- Positive if we gain money
		
		if OldMoney > NewMoney then		-- Lost Money
			Spent = Spent - Change
		else							-- Gained Moeny
			Profit = Profit + Change
		end
		
		Text:SetText(formatTextMoney(NewMoney))
		-- Setup Money Tooltip
		self:SetAllPoints(Text)

		local myPlayerRealm = GetCVar("realmName");
		local myPlayerName  = UnitName("player");				
		if (MiniDB == nil) then MiniDB = {}; end
		if (MiniDB.gold == nil) then MiniDB.gold = {}; end
		if (MiniDB.gold[myPlayerRealm]==nil) then MiniDB.gold[myPlayerRealm]={}; end
		MiniDB.gold[myPlayerRealm][myPlayerName] = GetMoney();
		
		self:SetScript("OnEnter", function()
				GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
				self.hovered = true 
				GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 6);
				GameTooltip:ClearAllPoints()
				GameTooltip:SetPoint("BOTTOM", self, "TOP", 0, 1)
				GameTooltip:ClearLines()
				GameTooltip:AddLine(CURRENCY,0,.6,1)
				GameTooltip:AddLine(" ")
				GameTooltip:AddLine("目前: ",.6,.8,1)
				GameTooltip:AddDoubleLine("收入:", formatMoney(Profit), 1, 1, 1, 0, 1, 0)
				GameTooltip:AddDoubleLine("花费:", formatMoney(Spent), 1, 1, 1, 1, 0, 0)
				if Profit < Spent then
					GameTooltip:AddDoubleLine("亏损:", formatMoney(Profit-Spent), 1, 1, 1, 1, 0, 0)
				elseif (Profit-Spent)>0 then
					GameTooltip:AddDoubleLine("利润:", formatMoney(Profit-Spent), 1, 1, 1, 0, 1, 0)
				end				
				GameTooltip:AddLine' '								
			
				local totalGold = 0				
				GameTooltip:AddLine("当前ID: ",.6,.8,1)			
				local thisRealmList = MiniDB.gold[myPlayerRealm];
				for k,v in pairs(thisRealmList) do
					GameTooltip:AddDoubleLine(k, FormatTooltipMoney(v), 1, 1, 1, 1, 1, 1)
					totalGold=totalGold+v;
				end 
				GameTooltip:AddLine' '
				GameTooltip:AddLine("服务器: ",.6,.8,1)
				GameTooltip:AddDoubleLine("总计: ", FormatTooltipMoney(totalGold), 1, 1, 1, 1, 1, 1)

				for i = 1, MAX_WATCHED_TOKENS do
					local name, count, extraCurrencyType, icon, itemID = GetBackpackCurrencyInfo(i)
					if name and i == 1 then
						GameTooltip:AddLine(" ")
						GameTooltip:AddLine(CURRENCY)
					end
					local r, g, b = 1,1,1
					if itemID then r, g, b = GetItemQualityColor(select(3, GetItemInfo(itemID))) end
					if name and count then GameTooltip:AddDoubleLine(name, count, r, g, b, 1, 1, 1) end
				end
				GameTooltip:Show()
			
		end)
		self:SetScript("OnLeave", function() GameTooltip:Hide() end)
		
		OldMoney = NewMoney
	end

	Stat:RegisterEvent("PLAYER_MONEY")
	Stat:RegisterEvent("SEND_MAIL_MONEY_CHANGED")
	Stat:RegisterEvent("SEND_MAIL_COD_CHANGED")
	Stat:RegisterEvent("PLAYER_TRADE_MONEY")
	Stat:RegisterEvent("TRADE_MONEY_CHANGED")
	Stat:RegisterEvent("PLAYER_ENTERING_WORLD")
	Stat:SetScript("OnMouseDown", function() ToggleCharacter("TokenFrame") end)
	Stat:SetScript("OnEvent", OnEvent)
end