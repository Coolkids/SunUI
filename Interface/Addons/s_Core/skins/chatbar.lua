local S, C, L, DB = unpack(select(2, ...))

local Chatbar = CreateFrame("Frame")
Chatbar:RegisterEvent("PLAYER_ENTERING_WORLD")
Chatbar:SetScript("OnEvent", function()
Chatbar:UnregisterEvent("PLAYER_ENTERING_WORLD")
	if WorldMapFrame then
		S.StripTextures(ChatBarFrame, Kill)
		S.StripTextures(ChatBarFrameBackground, Kill)
		ChatBarFrameBackground:CreateShadow("Background")
	end
	if DB.Nuke == true then
		for i = 1,20 do
			print("|cffFFD700SunUI提示您: 侦测到您正在使用|r|cff308014大脚|r|cffFFD700或者|r|cff308014魔盒|r,|cffFFD700触发|r|cffFF0000Nuke参数|r,|cffFFD700为了让您用的舒适所以插件|r|cffFF0000自我关闭|r.|cffFFD700如想使用本插件请|r|cffFF0000完全删除|r|cff308014大脚|r|cffFFD700或者|r|cff308014魔盒|r")
		end
	end
end)