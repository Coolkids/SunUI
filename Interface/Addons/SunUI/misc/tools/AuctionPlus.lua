local function FormatPrice(value)
	local COLOR_COPPER = "eda55f"
	local COLOR_SILVER = "c7c7cf"
	local COLOR_GOLD = "ffd700"
	local gold = floor(math.abs(value) / 10000)
	local silver = mod(floor(math.abs(value) / 100), 100)
	local copper = mod(floor(math.abs(value)), 100)
	return format("|cff%s%s|r|cff%s%s|r|cff%s%s|r", COLOR_GOLD, format(GOLD_AMOUNT_TEXTURE, gold, 0, 0),COLOR_SILVER, format(SILVER_AMOUNT_TEXTURE, silver, 0, 0), COLOR_COPPER, format(COPPER_AMOUNT_TEXTURE, copper, 0, 0))
	--[[
	if gold ~= 0 then
		if copper ~= 0 then 
			
			return format("|cff%s%d|r.|cff%s%02d|r.|cff%s%02d|r", COLOR_GOLD, gold, COLOR_SILVER, silver, COLOR_COPPER, copper)
		elseif silver ~= 0 then
			return format("|cff%s%d|r.|cff%s%02d|r", COLOR_GOLD, gold, COLOR_SILVER, silver)
		else
			return format("|cff%s%d|r", COLOR_GOLD, gold)
		end
	elseif silver ~= 0 then 
		if copper ~= 0 then
			return format("|cff%s%d|r.|cff%s%02d|r", COLOR_SILVER, silver, COLOR_COPPER, copper)
		else
			return format("|cff%s%d|r", COLOR_SILVER, silver)
		end
	elseif copper ~= 0 then
		return format("|cff%s%d|r", COLOR_COPPER, copper)
	else
		return
	end ]]
end

hooksecurefunc("AuctionFrame_LoadUI", function()
    if AuctionFrameBrowse_Update then
        hooksecurefunc("AuctionFrameBrowse_Update", function()
            local numBatchAuctions = GetNumAuctionItems("list")
            local offset = FauxScrollFrame_GetOffset(BrowseScrollFrame)
            for i=1, NUM_BROWSE_TO_DISPLAY do
                local index = offset + i + (NUM_AUCTION_ITEMS_PER_PAGE * AuctionFrameBrowse.page)
                if index <= numBatchAuctions + (NUM_AUCTION_ITEMS_PER_PAGE * AuctionFrameBrowse.page) then
                    local name, _, count, _, _, _, _, _, _, buyoutPrice, bidAmount =  GetAuctionItemInfo("list", offset + i)
                    local alpha = 0.5
                    local color = "yellow"
                    if name then
                        local itemName = _G["BrowseButton"..i.."Name"]
                        local moneyFrame = _G["BrowseButton"..i.."MoneyFrame"]
                        local buyoutMoney = _G["BrowseButton"..i.."BuyoutFrameMoney"]
						--价格大于5000时显示为红色
                        if (buyoutPrice/10000) >= 5000 then color = "red" end
						--显示是否已被竞拍
                        if bidAmount > 0 then
                            if string.len(name) > 40 then
                                name = string.sub(name, 0, 36) .. "..."
                            end
                            name = "|cffffff00*|r" .. name
                            alpha = 1.0
                        end
                        itemName:SetText(name)
                        moneyFrame:SetAlpha(alpha)
                        SetMoneyFrameColor(buyoutMoney:GetName(), color)
						--显示单价
						if (buyoutPrice > 0) and (count > 1) then
							local peText = "\n|cffffffff单价:|r"..FormatPrice(floor(buyoutPrice / count))..""
							itemName:SetText(name..peText)
						end
					end
                end
            end
        end)
    end
end)
