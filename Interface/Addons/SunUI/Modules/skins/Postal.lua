local S, C, L, DB, _ = unpack(select(2, ...))
local F =unpack(select(2, ...))
if not IsAddOnLoaded("Postal") then return end
local Delay = CreateFrame("Frame")
Delay:RegisterEvent("PLAYER_ENTERING_WORLD")
Delay:SetScript("OnEvent", function()
	Delay:UnregisterEvent("PLAYER_ENTERING_WORLD")
	if MailFrame then
		S.Reskin(PostalSelectOpenButton)
		S.Reskin(PostalSelectReturnButton)
		S.Reskin(PostalOpenAllButton)
	end
end)