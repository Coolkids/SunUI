local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local A = S:GetModule("Skins")

local function LoadSkin()
	A:CreateBD(GuildControlUI)
	A:CreateSD(GuildControlUI)
	A:CreateBD(GuildControlUIRankBankFrameInset, .25)

	for i = 1, 9 do
		select(i, GuildControlUI:GetRegions()):Hide()
	end

	for i = 1, 8 do
		select(i, GuildControlUIRankBankFrameInset:GetRegions()):Hide()
	end

	GuildControlUIRankSettingsFrameChatBg:SetAlpha(0)
	GuildControlUIRankSettingsFrameRosterBg:SetAlpha(0)
	GuildControlUIRankSettingsFrameInfoBg:SetAlpha(0)
	GuildControlUIRankSettingsFrameBankBg:SetAlpha(0)
	GuildControlUITopBg:Hide()
	GuildControlUIHbar:Hide()
	GuildControlUIRankBankFrameInsetScrollFrameTop:SetAlpha(0)
	GuildControlUIRankBankFrameInsetScrollFrameBottom:SetAlpha(0)

	hooksecurefunc("GuildControlUI_RankOrder_Update", function()
		if not reskinnedranks then
			for i = 1, GuildControlGetNumRanks() do
				A:ReskinInput(_G["GuildControlUIRankOrderFrameRank"..i.."NameEditBox"], 20)
			end
			reskinnedranks = true
		end
	end)

	hooksecurefunc("GuildControlUI_BankTabPermissions_Update", function()
		for i = 1, GetNumGuildBankTabs()+1 do
			local tab = "GuildControlBankTab"..i
			local bu = _G[tab]
			if bu and not bu.reskinned then
				_G[tab.."Bg"]:Hide()
				A:CreateBD(bu, .12)
				A:Reskin(_G[tab.."BuyPurchaseButton"])
				A:ReskinInput(_G[tab.."OwnedStackBox"])

				bu.reskinned = true
			end
		end
	end)

	A:Reskin(GuildControlUIRankOrderFrameNewButton)

	A:ReskinClose(GuildControlUICloseButton)
	A:ReskinScroll(GuildControlUIRankBankFrameInsetScrollFrameScrollBar)
	A:ReskinDropDown(GuildControlUINavigationDropDown)
	A:ReskinDropDown(GuildControlUIRankSettingsFrameRankDropDown)
	A:ReskinDropDown(GuildControlUIRankBankFrameRankDropDown)
	A:ReskinInput(GuildControlUIRankSettingsFrameGoldBox, 20)
end

A:RegisterSkin("Blizzard_GuildControlUI", LoadSkin)