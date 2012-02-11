local S, C, L, DB = unpack(select(2, ...))

local Chatbar = CreateFrame("Frame")
Chatbar:RegisterEvent("PLAYER_ENTERING_WORLD")
Chatbar:SetScript("OnEvent", function()
Chatbar:UnregisterEvent("PLAYER_ENTERING_WORLD")
	if WorldMapFrame then
		S.StripTextures(ChatBarFrame, Kill)
		S.StripTextures(ChatBarFrameBackground, Kill)
		S.SetBD(ChatBarFrameBackground)
	end
end)