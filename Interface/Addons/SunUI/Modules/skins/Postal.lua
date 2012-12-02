local S, C, L, DB = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("SkinPostal", "AceEvent-3.0")

local function Skin()
	if not IsAddOnLoaded("Postal") then return end
	if MailFrame then
		S.Reskin(PostalSelectOpenButton)
		S.Reskin(PostalSelectReturnButton)
		S.Reskin(PostalOpenAllButton)
		Postal_ModuleMenuButton:SetPoint("TOPRIGHT", MailFrame, "TOPRIGHT", -22, -4)
		Postal_OpenAllMenuButton:SetPoint("LEFT", PostalOpenAllButton, "RIGHT", 3, 0)
		S.ReskinArrow(Postal_ModuleMenuButton, "down")
		S.ReskinArrow(Postal_OpenAllMenuButton, "down")
		--Postal_OpenAllMenuButton:SetSize(Postal_ModuleMenuButton:GetHeight()+6, Postal_ModuleMenuButton:GetHeight()+7)
		Postal_BlackBookButton:SetPoint("LEFT", SendMailNameEditBox, "RIGHT", 3, 0)
		S.ReskinArrow(Postal_BlackBookButton, "down")
	end
end

function Module:OnEnable()
	Module:RegisterEvent("ADDON_LOADED", Skin)
end