local S, C, L, DB, _ = unpack(SunUI)
 
local Delay = CreateFrame("Frame")
Delay:RegisterEvent("PLAYER_ENTERING_WORLD")
Delay:SetScript("OnEvent", function()
	Delay:UnregisterEvent("PLAYER_ENTERING_WORLD")
	
	if FriendsMenuXPSecure then
		FriendsMenuXPSecureMenuBackdrop:StripTextures()
		FriendsMenuXPSecure:CreateShadow("Background")
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
		ItemRefShoppingTooltip1:CreateShadow("Background")
	end
	if ItemRefShoppingTooltip2 then 
		ItemRefShoppingTooltip2:StripTextures()
		ItemRefShoppingTooltip2:CreateShadow("Background")
	end
	
	if UnitPopupMenus then
		UnitPopupMenus["PLAYER"] = { "SET_FOCUS", "WHISPER", "INSPECT", "ACHIEVEMENTS", "INVITE", "TRADE", "FOLLOW", "DUEL", "RAID_TARGET_ICON", "RAF_SUMMON", "RAF_GRANT_LEVEL", "MOVE_PLAYER_FRAME", "MOVE_TARGET_FRAME", "CANCEL" };
	end

	DEFAULT_CHAT_FRAME:AddMessage("|cffDDA0DDSun|r|cff44CCFFUI|r已加载，详细设置请输入/sunui")
end)