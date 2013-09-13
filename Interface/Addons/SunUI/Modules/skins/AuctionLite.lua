local S, L, DB, _, C = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("SkinAuctionLite", "AceEvent-3.0")
local style = false
local function Skin()
	if not IsAddOnLoaded("AuctionLite") then return end
	if not style then
		S.Reskin(BuyScanButton)
		S.Reskin(BuySearchButton)
		S.Reskin(BuySummaryButton, true)
		BuySummaryButton:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Up")
		S.Reskin(BuyBidButton)
		S.Reskin(BuyBuyoutButton)
		S.Reskin(BuyCancelAuctionButton)
		S.Reskin(SellCreateAuctionButton)
		S.ReskinRadio(SellShortAuctionButton)
		S.ReskinRadio(SellMediumAuctionButton)
		S.ReskinRadio(SellLongAuctionButton)
		S.ReskinRadio(SellPerItemButton)
		S.ReskinRadio(SellPerStackButton)
		style = true
	end
end

function Module:OnEnable()
	Module:RegisterEvent("ADDON_LOADED", Skin)
end