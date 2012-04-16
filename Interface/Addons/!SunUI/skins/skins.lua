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
		S.SetBD(BaudErrorFrame)
	end
	
	if BuyEmAllFrame then
		S.StripTextures(BuyEmAllFrame)
		S.Reskin(BuyEmAllStackButton)
		S.Reskin(BuyEmAllMaxButton)
		S.Reskin(BuyEmAllOkayButton)
		S.Reskin(BuyEmAllCancelButton)
		S.SetBD(BuyEmAllFrame)
	end
	
	if WorldMapFrame then
		S.StripTextures(WorldMapFrame, Kill)
		S.CreateSD(WorldMapFrame,6)
	end
	
	if ItemRefShoppingTooltip1 then 
		S.StripTextures(ItemRefShoppingTooltip1)
		ItemRefShoppingTooltip1:CreateShadow("Background")
	end
	if ItemRefShoppingTooltip2 then 
		S.StripTextures(ItemRefShoppingTooltip2)
		ItemRefShoppingTooltip2:CreateShadow("Background")
	end
	
	if UnitPopupMenus then
		UnitPopupMenus["PLAYER"] = { "SET_FOCUS", "WHISPER", "INSPECT", "ACHIEVEMENTS", "INVITE", "TRADE", "FOLLOW", "DUEL", "RAID_TARGET_ICON", "RAF_SUMMON", "RAF_GRANT_LEVEL", "MOVE_PLAYER_FRAME", "MOVE_TARGET_FRAME", "CANCEL" };
	end
	
	if DB.Nuke == true then
		print("|cffFFD700SunUI提示您: 侦测到您正在使用|r|cff308014大脚|r|cffFFD700或者|r|cff308014魔盒|r,|cffFFD700触发|r|cffFF0000Nuke参数|r,|cffFFD700为了让您用的舒适所以插件|r|cffFF0000自我关闭|r.|cffFFD700如想使用本插件请|r|cffFF0000完全删除|r|cff308014大脚|r|cffFFD700或者|r|cff308014魔盒|r")
	end
	DEFAULT_CHAT_FRAME:AddMessage("|cffDDA0DDSun|r|cff44CCFFUI|r已加载，发布网址:\124cff7f7fffhttp://bbs.ngacn.cc/read.php?tid=4743077&_fp=1&_ff=200\124r")
	MiniDB["uiScale"] = GetCVar("uiScale")
end)