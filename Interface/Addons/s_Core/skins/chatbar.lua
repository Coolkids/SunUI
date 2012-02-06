local S, C, L, DB = unpack(select(2, ...))

local Chatbar = CreateFrame("Frame")
Chatbar:RegisterEvent("PLAYER_ENTERING_WORLD")
Chatbar:SetScript("OnEvent", function()
Chatbar:UnregisterEvent("PLAYER_ENTERING_WORLD")
		S.StripTextures(ChatBarFrame, Kill)
		S.MakeShadow(ChatBarFrame, 3)
		S.StripTextures(ChatBarFrameBackground, Kill)
		S.SetBD(ChatBarFrameBackground)

end)