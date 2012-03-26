local S, C, L, DB = unpack(select(2, ...))
if DB.Nuke == true then return end
local Delay = CreateFrame("Frame")
Delay:RegisterEvent("PLAYER_ENTERING_WORLD")
Delay:SetScript("OnEvent", function()
	Delay:UnregisterEvent("PLAYER_ENTERING_WORLD")
	
	if FriendsMenuXPSecure then
		S.StripTextures(FriendsMenuXPSecureMenuBackdrop)
		FriendsMenuXPSecure:CreateShadow("Background")
	end
	
	if BaudErrorFrame then
		S.StripTextures(BaudErrorFrame)
		S.Reskin(BaudErrorFrameCloseButton)
		S.Reskin(BaudErrorFrameClearButton)
		--BaudErrorFrame:CreateShadow("Background") 
		S.SetBD(BaudErrorFrame)
	end
	
	if BuyEmAllFrame then
		S.StripTextures(BuyEmAllFrame)
		S.Reskin(BuyEmAllStackButton)
		S.Reskin(BuyEmAllMaxButton)
		S.Reskin(BuyEmAllOkayButton)
		S.Reskin(BuyEmAllCancelButton)
		S.SetBD(BuyEmAllFrame)
		--BuyEmAllFrame:CreateShadow("Background") 
	end
	
	if WorldMapFrame then
		S.StripTextures(WorldMapFrame, Kill)
		S.SetBD(WorldMapFrame,-S.mult,S.mult,S.mult,-S.mult)
	end
	
	if ChatBarFrameBackground then
		S.StripTextures(ChatBarFrame, Kill)
		S.StripTextures(ChatBarFrameBackground, Kill)
		ChatBarFrameBackground:CreateShadow("Background")
	end
	
	if ItemRefShoppingTooltip1 then 
		S.StripTextures(ItemRefShoppingTooltip1)
		ItemRefShoppingTooltip1:CreateShadow("Background")
	end
	if ItemRefShoppingTooltip2 then 
		S.StripTextures(ItemRefShoppingTooltip2)
		ItemRefShoppingTooltip2:CreateShadow("Background")
	end

	
	if DB.Nuke == true then
		for i = 1,20 do
			print("|cffFFD700SunUI提示您: 侦测到您正在使用|r|cff308014大脚|r|cffFFD700或者|r|cff308014魔盒|r,|cffFFD700触发|r|cffFF0000Nuke参数|r,|cffFFD700为了让您用的舒适所以插件|r|cffFF0000自我关闭|r.|cffFFD700如想使用本插件请|r|cffFF0000完全删除|r|cff308014大脚|r|cffFFD700或者|r|cff308014魔盒|r")
		end
	end
	MiniDB["uiScale"] = GetCVar("uiScale")
end)