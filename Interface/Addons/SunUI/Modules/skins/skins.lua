local S, C, L, DB, _ = unpack(select(2, ...))
 
local Delay = CreateFrame("Frame")
Delay:RegisterEvent("PLAYER_ENTERING_WORLD")
Delay:SetScript("OnEvent", function()
	Delay:UnregisterEvent("PLAYER_ENTERING_WORLD")
	
	if FriendsMenuXPSecure then
		FriendsMenuXPSecureMenuBackdrop:StripTextures()
		S.CreateBD(FriendsMenuXPSecure)
	end
	
	if BaudErrorFrame then
		BaudErrorFrame:StripTextures()
		S.Reskin(BaudErrorFrameCloseButton)
		S.Reskin(BaudErrorFrameClearButton)
		S.SetBD(BaudErrorFrame)
	end
	
	if BuyEmAllFrame then
		BuyEmAllFrame:StripTextures()
		S.Reskin(BuyEmAllStackButton)
		S.Reskin(BuyEmAllMaxButton)
		S.Reskin(BuyEmAllOkayButton)
		S.Reskin(BuyEmAllCancelButton)
		S.SetBD(BuyEmAllFrame)
	end
	
	if ItemRefShoppingTooltip1 then 
		ItemRefShoppingTooltip1:StripTextures()
		S.CreateBD(ItemRefShoppingTooltip1)
	end
	if ItemRefShoppingTooltip2 then 
		ItemRefShoppingTooltip2:StripTextures()
		S.CreateBD(ItemRefShoppingTooltip2)
	end
	
	if UnitPopupMenus then
		UnitPopupMenus["PLAYER"] = { "SET_FOCUS", "WHISPER", "INSPECT", "ACHIEVEMENTS", "INVITE", "TRADE", "FOLLOW", "DUEL", "RAID_TARGET_ICON", "RAF_SUMMON", "RAF_GRANT_LEVEL", "MOVE_PLAYER_FRAME", "MOVE_TARGET_FRAME", "CANCEL" };
	end

	DEFAULT_CHAT_FRAME:AddMessage("|cffDDA0DDSun|r|cff44CCFFUI|r已加载，详细设置请输入/sunui")
end)