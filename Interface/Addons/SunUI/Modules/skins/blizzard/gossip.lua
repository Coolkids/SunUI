local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local A = S:GetModule("Skins")

local function LoadSkin()
	A:SetBD(GossipFrame)

	GossipFrame:DisableDrawLayer("BORDER")
	GossipFrameInset:DisableDrawLayer("BORDER")
	GossipFrameInsetBg:Hide()
	GossipGreetingScrollFrameTop:Hide()
	GossipGreetingScrollFrameBottom:Hide()
	GossipGreetingScrollFrameMiddle:Hide()

	for i = 1, 7 do
		select(i, GossipFrame:GetRegions()):Hide()
	end
	select(19, GossipFrame:GetRegions()):Hide()

	GossipGreetingText:SetTextColor(1, 1, 1)

	A:ReskinScroll(GossipGreetingScrollFrameScrollBar)

	GreetingText:SetTextColor(1, 1, 1)
	GreetingText.SetTextColor = S.dummy

	A:Reskin(GossipFrameGreetingGoodbyeButton)
	A:ReskinClose(GossipFrameCloseButton)
	hooksecurefunc("GossipFrameUpdate", function()
		for i=1, NUMGOSSIPBUTTONS do
			local button = _G["GossipTitleButton"..i]
			local text = button:GetText()
			if text and text:find("|cff000000") then
				text = string.gsub(text, "|cff000000", "|cffFFFF00")
				button:SetText(text)
			elseif text then
				text = string.gsub(text, "|cff......", "|cffFFFFFF")
				button:SetText(text)
				button:GetFontString():SetTextColor(1, 1, 1)
			end
			
		end
	end)
	hooksecurefunc(ItemTextPageText, "SetTextColor", function(self, r, g, b)
		if r ~= 1 or g ~= 1 or b ~= 1 then
			ItemTextPageText:SetTextColor(1, 1, 1)
		end
	end)
	select(18, ItemTextFrame:GetRegions()):Hide()
	InboxFrameBg:Hide()
	ItemTextScrollFrameMiddle:SetAlpha(0)
	ItemTextScrollFrameTop:SetAlpha(0)
	ItemTextScrollFrameBottom:SetAlpha(0)
	ItemTextPrevPageButton:GetRegions():Hide()
	ItemTextNextPageButton:GetRegions():Hide()
	ItemTextMaterialTopLeft:SetAlpha(0)
	ItemTextMaterialTopRight:SetAlpha(0)
	ItemTextMaterialBotLeft:SetAlpha(0)
	ItemTextMaterialBotRight:SetAlpha(0)

	A:ReskinPortraitFrame(ItemTextFrame, true)
	A:ReskinScroll(ItemTextScrollFrameScrollBar)
	A:ReskinArrow(ItemTextPrevPageButton, "left")
	A:ReskinArrow(ItemTextNextPageButton, "right")

	ItemTextPageText:SetTextColor(1, 1, 1)
	ItemTextPageText.SetTextColor = S.dummy

    NPCFriendshipStatusBar:GetRegions():Hide()
    NPCFriendshipStatusBarNotch1:SetTexture(0, 0, 0)
    NPCFriendshipStatusBarNotch1:Size(1, 16)
    NPCFriendshipStatusBarNotch2:SetTexture(0, 0, 0)
    NPCFriendshipStatusBarNotch2:Size(1, 16)
    NPCFriendshipStatusBarNotch3:SetTexture(0, 0, 0)
    NPCFriendshipStatusBarNotch3:Size(1, 16)
    NPCFriendshipStatusBarNotch4:SetTexture(0, 0, 0)
    NPCFriendshipStatusBarNotch4:Size(1, 16)
    select(7, NPCFriendshipStatusBar:GetRegions()):Hide()

    NPCFriendshipStatusBar.icon:SetPoint("TOPLEFT", -30, 7)
    NPCFriendshipStatusBar.bd = CreateFrame("Frame", nil, NPCFriendshipStatusBar)
    NPCFriendshipStatusBar.bd:SetOutside(nil, 1, 1)
    NPCFriendshipStatusBar.bd:SetFrameLevel(NPCFriendshipStatusBar:GetFrameLevel() - 1)
    A:CreateBD(NPCFriendshipStatusBar.bd, .25)
end

A:RegisterSkin("SunUI", LoadSkin)
