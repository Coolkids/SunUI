local S, C, L, DB = unpack(select(2, ...))
if DB.Nuke == true then return end
local Delay = CreateFrame("Frame")
Delay:RegisterEvent("PLAYER_ENTERING_WORLD")
Delay:SetScript("OnEvent", function()
	Delay:UnregisterEvent("PLAYER_ENTERING_WORLD")
	--SetCVar("UnitNameNPC", 0)  --给我不显示任何NPC名字
	if FriendsMenuXPSecure then
		S.StripTextures(FriendsMenuXPSecureMenuBackdrop)
		FriendsMenuXPSecure:CreateShadow("Background")
	end
end)