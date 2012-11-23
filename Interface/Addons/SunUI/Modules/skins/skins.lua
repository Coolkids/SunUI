local S, C, L, DB = unpack(select(2, ...))
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
		UnitPopupMenus["PLAYER"] = { "SET_FOCUS", "WHISPER", "INSPECT", "ACHIEVEMENTS", "INVITE", "TRADE", "FOLLOW", "DUEL", "PET_BATTLE_PVP_DUEL", "RAID_TARGET_ICON", "RAF_SUMMON", "RAF_GRANT_LEVEL", "MOVE_PLAYER_FRAME", "MOVE_TARGET_FRAME", "CANCEL" };
	end
	--[[ hooksecurefunc("ShowUIPanel", function(frame)
		if frame and frame ~= InspectFrame and frame ~= TaxiFrame and frame ~= FriendsFrame then
			frame:Show()
			UIFrameFadeIn(frame, 0.3, 0, 1)
		end
	end)
	hooksecurefunc("HideUIPanel", function(frame)
		if frame and frame ~= InspectFrame and frame ~= TaxiFrame and frame ~= FriendsFrame and frame ~= MasterLooterFrame then
			S.FadeOutFrameDamage(frame, 0.3)
			frame:SetAlpha(1)
		end
	end) ]]
	DEFAULT_CHAT_FRAME:AddMessage("|cffDDA0DDSun|r|cff44CCFFUI|r已加载，详细设置请输入/sunui")
	DEFAULT_CHAT_FRAME:AddMessage("更新下载请到个人主页:http://url.cn/5YbLQe")
end)
local isCoolkid = false --S.IsCoolkid()
local damageframe = {
	"alDamageMeterFrame",
	"SkadaBarWindowSkada",
	"NumerationFrame",
}
if isCoolkid then
	local Coolkid = CreateFrame("Frame")
	Coolkid:RegisterEvent("PLAYER_ENTERING_WORLD")
	Coolkid:RegisterEvent("PLAYER_REGEN_ENABLED")
	Coolkid:RegisterEvent("PLAYER_REGEN_DISABLED")
	Coolkid:SetScript("OnEvent", function(self, event)
		if event == "PLAYER_ENTERING_WORLD" then
			self:UnregisterEvent("PLAYER_ENTERING_WORLD")
			for k,v in pairs(damageframe) do
				if _G[v] and _G[v]:IsShown() then
					S.FadeOutFrameDamage(_G[v], 1)
				end
			end
		end
		if event == "PLAYER_REGEN_DISABLED" then
			for k,v in pairs(damageframe) do
				if _G[v] and not _G[v]:IsShown() then
					self:Show()
					UIFrameFadeIn(self, 1, self:GetAlpha(), 1)	
				end
			end
		end
		if event == "PLAYER_REGEN_ENABLED" then
			for k,v in pairs(damageframe) do
				if _G[v] and _G[v]:IsShown() then
					S.FadeOutFrameDamage(_G[v], 1)
				end
			end
		end
	end)
end