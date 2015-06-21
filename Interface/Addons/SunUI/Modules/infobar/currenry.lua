local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local IB = S:GetModule("InfoBar")

function IB:CreateCurrenry()
	local A = S:GetModule("Skins")
	local stat = CreateFrame("Frame", "InfoPanel4", TopInfoPanel or UIParent)
	stat:SetFrameStrata("BACKGROUND")
	stat:SetFrameLevel(3)
	stat:EnableMouse(true)

	stat.text = S:CreateFS(stat, nil, nil, IB.font)
	stat.text:SetPoint("LEFT", InfoPanel3 or InfoPanel2 or InfoPanel1, "RIGHT", 20, 0)
	
	stat.icon = stat:CreateTexture(nil, "OVERLAY")
	stat.icon:SetSize(8, 8)
	stat.icon:SetPoint("RIGHT", stat.text, "LEFT", -5, 0)
	stat.icon:SetTexture(IB.backdrop)
	stat.icon:SetVertexColor(unpack(IB.InfoBarStatusColor[3]))
	A:CreateShadow(stat, stat.icon)

	stat:SetPoint("TOPLEFT", stat.icon)
	stat:SetPoint("BOTTOMLEFT", stat.icon)
	stat:SetPoint("TOPRIGHT", stat.text)
	stat:SetPoint("BOTTOMRIGHT", stat.text)

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
		
		stat.text:SetText(formatTextMoney(NewMoney))
		
		local myPlayerRealm = GetRealmName();
		local myPlayerName  = UnitName("player");				
		if (S.global == nil) then S.global = {}; end
		if (S.global.gold == nil) then S.global.gold = {}; end
		if (S.global.gold[myPlayerRealm]==nil) then S.global.gold[myPlayerRealm]={}; end
		S.global.gold[myPlayerRealm][myPlayerName] = GetMoney();
		self:SetScript("OnEnter", function()
				GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
				GameTooltip:ClearLines()
				GameTooltip:AddLine(CURRENCY,.6,.8,1)
				GameTooltip:AddLine(" ")
				GameTooltip:AddLine(L["目前"],.6,.8,1)
				GameTooltip:AddDoubleLine(L["收入"], formatMoney(Profit), 1, 1, 1, 0, 1, 0)
				GameTooltip:AddDoubleLine(L["花费"], formatMoney(Spent), 1, 1, 1, 1, 0, 0)
				if Profit < Spent then
					GameTooltip:AddDoubleLine(L["亏损"], formatMoney(Profit-Spent), 1, 1, 1, 1, 0, 0)
				elseif (Profit-Spent)>0 then
					GameTooltip:AddDoubleLine("利润:", formatMoney(Profit-Spent), 1, 1, 1, 0, 1, 0)
				end				
				GameTooltip:AddLine' '								
			
				local totalGold = 0				
				GameTooltip:AddLine("ID: ",.6,.8,1)			
				local thisRealmList = S.global.gold[myPlayerRealm];
				for k,v in pairs(thisRealmList) do
					GameTooltip:AddDoubleLine(k, FormatTooltipMoney(v), 1, 1, 1, 1, 1, 1)
					totalGold=totalGold+v;
				end 
				GameTooltip:AddLine' '
				GameTooltip:AddLine(L["服务器"],.6,.8,1)
				GameTooltip:AddDoubleLine(L["总计"], FormatTooltipMoney(totalGold), 1, 1, 1, 1, 1, 1)

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

	stat:RegisterEvent("PLAYER_MONEY")
	stat:RegisterEvent("SEND_MAIL_MONEY_CHANGED")
	stat:RegisterEvent("SEND_MAIL_COD_CHANGED")
	stat:RegisterEvent("PLAYER_TRADE_MONEY")
	stat:RegisterEvent("TRADE_MONEY_CHANGED")
	stat:RegisterEvent("PLAYER_ENTERING_WORLD")
	stat:SetScript("OnMouseDown", function(self, button) 
		if button == "LeftButton" then
			ToggleAllBags()
		else
			ToggleCharacter("TokenFrame")
		end
	end)
	stat:SetScript("OnEvent", OnEvent)
end