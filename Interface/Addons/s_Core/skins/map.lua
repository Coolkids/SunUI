local S, C, L, DB = unpack(select(2, ...))

local Map = CreateFrame("Frame")
Map:RegisterEvent("PLAYER_ENTERING_WORLD")
Map:SetScript("OnEvent", function()
Map:UnregisterEvent("PLAYER_ENTERING_WORLD")
	if WorldMapFrame then
		S.StripTextures(WorldMapFrame, Kill)
		WorldMapFrame.backdrop = CreateFrame("Frame", nil, WorldMapFrame)
		WorldMapFrame.backdrop:SetPoint("TOPLEFT", -2, 2)
		WorldMapFrame.backdrop:SetPoint("BOTTOMRIGHT", 2, -2)
		S.SetBD(WorldMapFrame.backdrop)
	end
end)