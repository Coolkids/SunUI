local S, C, L, DB = unpack(select(2, ...))
local Delay = CreateFrame("Frame")
Delay:RegisterEvent("PLAYER_ENTERING_WORLD")
Delay:SetScript("OnEvent", function()
	Delay:UnregisterEvent("PLAYER_ENTERING_WORLD")
	if not IsAddOnLoaded("BagSync") then return end
	if BagSync_SearchFrame then
		BagSync_SearchFrame:StripTextures()
		S.SetBD(BagSync_SearchFrame)
		S.ReskinInput(BagSync_SearchFrameEdit1)
	end
	if BagSync_TokensFrame then
		BagSync_TokensFrame:StripTextures()
		S.SetBD(BagSync_TokensFrame)
	end
end)