local E, L, V, P, G = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB

local function SkinOther(self)
	local A = E:GetModule("Skins-SunUI")
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	
	if FriendsMenuXPSecure then
		FriendsMenuXPSecureMenuBackdrop:StripTextures()
		A:CreateBD(FriendsMenuXPSecure)
	end
	
	if BaudErrorFrame then
		BaudErrorFrame:StripTextures()
		A:Reskin(BaudErrorFrameCloseButton)
		A:Reskin(BaudErrorFrameClearButton)
		A:SetBD(BaudErrorFrame)
		A:ReskinScroll(BaudErrorFrameDetailScrollFrameScrollBar)
	end
	
	if BuyEmAllFrame then
		BuyEmAllFrame:StripTextures()
		A:Reskin(BuyEmAllStackButton)
		A:Reskin(BuyEmAllMaxButton)
		A:Reskin(BuyEmAllOkayButton)
		A:Reskin(BuyEmAllCancelButton)
		A:SetBD(BuyEmAllFrame)
	end
	
	if ItemRefShoppingTooltip1 then 
		ItemRefShoppingTooltip1:StripTextures()
		A:CreateBD(ItemRefShoppingTooltip1)
	end
	if ItemRefShoppingTooltip2 then 
		ItemRefShoppingTooltip2:StripTextures()
		A:CreateBD(ItemRefShoppingTooltip2)
	end
	
	--[[if UnitPopupMenus then
		UnitPopupMenus["PLAYER"] = {"WHISPER", "INSPECT", "ACHIEVEMENTS", "INVITE", "TRADE", "FOLLOW", "DUEL", "PET_BATTLE_PVP_DUEL", "RAID_TARGET_ICON", "RAF_SUMMON", "RAF_GRANT_LEVEL", "MOVE_PLAYER_FRAME", "MOVE_TARGET_FRAME", "CANCEL" };
	end]]
	--local MB = S:GetModule("MirrorBar")
	--MB:PLAYER_ENTERING_WORLD()
	
	if CloseUpUndressButton then
		local a,b,c,d,e = CloseUpUndressButton:GetPoint()
		CloseUpUndressButton:SetPoint(a, b, c, d+3, e)
		A:Reskin(CloseUpUndressButton)
	end
	
	_G["TimeManagerClockButton"]:Hide()
	GameTimeFrame:Hide()
end

local STFrame = CreateFrame("Frame")
STFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
STFrame:SetScript("OnEvent", SkinOther)
