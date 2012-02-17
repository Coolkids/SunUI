local S, C, L, DB = unpack(select(2, ...))

local Delay = CreateFrame("Frame")
Delay:RegisterEvent("PLAYER_ENTERING_WORLD")
Delay:SetScript("OnEvent", function()
	Delay:UnregisterEvent("PLAYER_ENTERING_WORLD")
	--SetCVar("UnitNameNPC", 0)  --给我不显示任何NPC名字
	if FriendsMenuXPSecure then
		S.StripTextures(FriendsMenuXPSecureMenuBackdrop)
		S.MakeShadow(FriendsMenuXPSecure, 3)
		FriendsMenuXPSecure:SetBackdrop({
		bgFile = DB.bgFile, insets = {left = 0, right = 0, top = 0, bottom = 0},
	})
	FriendsMenuXPSecure:SetBackdropColor(0, 0, 0, 0.9)
	end
end)