local S, L, DB, _, C = unpack(select(2, ...))

local r, g, b = DB.MyClassColor.r, DB.MyClassColor.g, DB.MyClassColor.b
local AuroraConfig = DB.AuroraConfig
DB.AuroraModules["Blizzard_ItemUpgradeUI"] = function()
	local ItemUpgradeFrame = ItemUpgradeFrame
	local ItemButton = ItemUpgradeFrame.ItemButton

	ItemUpgradeFrame:DisableDrawLayer("BACKGROUND")
	ItemUpgradeFrame:DisableDrawLayer("BORDER")
	ItemUpgradeFrameMoneyFrameLeft:Hide()
	ItemUpgradeFrameMoneyFrameMiddle:Hide()
	ItemUpgradeFrameMoneyFrameRight:Hide()
	ItemUpgradeFrame.ButtonFrame:GetRegions():Hide()
	ItemUpgradeFrame.ButtonFrame.ButtonBorder:Hide()
	ItemUpgradeFrame.ButtonFrame.ButtonBottomBorder:Hide()
	ItemButton.Frame:Hide()
	ItemButton.Grabber:Hide()
	ItemButton.TextFrame:Hide()
	ItemButton.TextGrabber:Hide()

	S.CreateBD(ItemButton, .25)
	ItemButton:SetHighlightTexture("")
	ItemButton:SetPushedTexture("")
	ItemButton.IconTexture:Point("TOPLEFT", 1, -1)
	ItemButton.IconTexture:Point("BOTTOMRIGHT", -1, 1)

	local bg = CreateFrame("Frame", nil, ItemButton)
	bg:SetSize(341, 50)
	bg:Point("LEFT", ItemButton, "RIGHT", -1, 0)
	bg:SetFrameLevel(ItemButton:GetFrameLevel()-1)
	S.CreateBD(bg, .25)

	ItemButton:HookScript("OnEnter", function(self)
		self:SetBackdropBorderColor(1, .56, .85)
	end)
	ItemButton:HookScript("OnLeave", function(self)
		self:SetBackdropBorderColor(0, 0, 0)
	end)

	ItemButton.Cost.Icon:SetTexCoord(.08, .92, .08, .92)
	ItemButton.Cost.Icon.bg = S.CreateBG(ItemButton.Cost.Icon)

	hooksecurefunc("ItemUpgradeFrame_Update", function()
		if GetItemUpgradeItemInfo() then
			ItemButton.IconTexture:SetTexCoord(.08, .92, .08, .92)
			ItemButton.Cost.Icon.bg:Show()
		else
			ItemButton.IconTexture:SetTexture("")
			ItemButton.Cost.Icon.bg:Hide()
		end
	end)

	local currency = ItemUpgradeFrameMoneyFrame.Currency
	currency.icon:Point("LEFT", currency.count, "RIGHT", 1, 0)
	currency.icon:SetTexCoord(.08, .92, .08, .92)
	S.CreateBG(currency.icon)

	local bg = CreateFrame("Frame", nil, ItemUpgradeFrame)
	bg:SetAllPoints(ItemUpgradeFrame)
	bg:SetFrameLevel(ItemUpgradeFrame:GetFrameLevel()-1)
	S.CreateBD(bg)

	S.ReskinPortraitFrame(ItemUpgradeFrame)
	S.Reskin(ItemUpgradeFrameUpgradeButton)
end