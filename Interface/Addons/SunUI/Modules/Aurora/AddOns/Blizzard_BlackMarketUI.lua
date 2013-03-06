local S, L, DB, _, C = unpack(select(2, ...))
local r, g, b = DB.MyClassColor.r, DB.MyClassColor.g, DB.MyClassColor.b
local AuroraConfig = DB.AuroraConfig

DB.AuroraModules["Blizzard_BlackMarketUI"] = function()

		BlackMarketFrame:DisableDrawLayer("BACKGROUND")
		BlackMarketFrame:DisableDrawLayer("BORDER")
		BlackMarketFrame:DisableDrawLayer("OVERLAY")
		BlackMarketFrame.Inset:DisableDrawLayer("BORDER")
		select(9, BlackMarketFrame.Inset:GetRegions()):Hide()
		BlackMarketFrame.MoneyFrameBorder:Hide()
		BlackMarketFrame.HotDeal.Left:Hide()
		BlackMarketFrame.HotDeal.Right:Hide()
		select(4, BlackMarketFrame.HotDeal:GetRegions()):Hide()

		S.CreateBG(BlackMarketFrame.HotDeal.Item)
		BlackMarketFrame.HotDeal.Item.IconTexture:SetTexCoord(.08, .92, .08, .92)

		local headers = {"ColumnName", "ColumnLevel", "ColumnType", "ColumnDuration", "ColumnHighBidder", "ColumnCurrentBid"}
		for _, header in pairs(headers) do
			local header = BlackMarketFrame[header]
			header.Left:Hide()
			header.Middle:Hide()
			header.Right:Hide()

			local bg = CreateFrame("Frame", nil, header)
			bg:Point("TOPLEFT", 2, 0)
			bg:Point("BOTTOMRIGHT", -1, 0)
			bg:SetFrameLevel(header:GetFrameLevel()-1)
			S.CreateBD(bg, .25)
		end

		S.SetBD(BlackMarketFrame)
		S.CreateBD(BlackMarketFrame.HotDeal, .25)
		S.Reskin(BlackMarketFrame.BidButton)
		S.ReskinClose(BlackMarketFrame.CloseButton)
		S.ReskinInput(BlackMarketBidPriceGold)
		S.ReskinScroll(BlackMarketScrollFrameScrollBar)

		hooksecurefunc("BlackMarketScrollFrame_Update", function()
			local buttons = BlackMarketScrollFrame.buttons
			for i = 1, #buttons do
				local bu = buttons[i]

				bu.Item.IconTexture:SetTexCoord(.08, .92, .08, .92)
				if not bu.reskinned then
					bu.Left:Hide()
					bu.Right:Hide()
					select(3, bu:GetRegions()):Hide()

					bu.Item:SetNormalTexture("")
					bu.Item:SetPushedTexture("")
					S.CreateBG(bu.Item)

					local bg = CreateFrame("Frame", nil, bu)
					bg:SetPoint("TOPLEFT")
					bg:Point("BOTTOMRIGHT", 0, 5)
					bg:SetFrameLevel(bu:GetFrameLevel()-1)
					S.CreateBD(bg, 0)

					local tex = bu:CreateTexture(nil, "BACKGROUND")
					tex:SetPoint("TOPLEFT")
					tex:Point("BOTTOMRIGHT", 0, 5)
					tex:SetTexture(0, 0, 0, .25)

					bu:SetHighlightTexture(DB.media.backdrop)
					local hl = bu:GetHighlightTexture()
					hl:SetVertexColor(r, g, b, .2)
					hl.SetAlpha = S.dummy
					hl:ClearAllPoints()
					hl:Point("TOPLEFT", 0, -1)
					hl:Point("BOTTOMRIGHT", -1, 6)

					bu.Selection:ClearAllPoints()
					bu.Selection:Point("TOPLEFT", 0, -1)
					bu.Selection:Point("BOTTOMRIGHT", -1, 6)
					bu.Selection:SetTexture(DB.media.backdrop)
					bu.Selection:SetVertexColor(r, g, b, .1)

					bu.reskinned = true
				end

				if bu:IsShown() and bu.itemLink then
					local _, _, quality = GetItemInfo(bu.itemLink)
					bu.Name:SetTextColor(GetItemQualityColor(quality))
				end
			end
		end)

		hooksecurefunc("BlackMarketFrame_UpdateHotItem", function(self)
			local hotDeal = self.HotDeal
			if hotDeal:IsShown() and hotDeal.itemLink then
				local _, _, quality = GetItemInfo(hotDeal.itemLink)
				hotDeal.Name:SetTextColor(GetItemQualityColor(quality))
			end
		end)
end