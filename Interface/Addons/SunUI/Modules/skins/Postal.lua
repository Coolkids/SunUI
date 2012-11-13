local S, C, L, DB = unpack(select(2, ...))
local _
local Delay = CreateFrame("Frame")
Delay:RegisterEvent("PLAYER_ENTERING_WORLD")
Delay:SetScript("OnEvent", function()
	Delay:UnregisterEvent("PLAYER_ENTERING_WORLD")
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
end)