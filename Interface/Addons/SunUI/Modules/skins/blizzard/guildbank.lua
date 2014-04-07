local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local A = S:GetModule("Skins")

local function LoadSkin()
    A:SetBD(GuildBankFrame)
	GuildBankPopupFrame:SetPoint("TOPLEFT", GuildBankFrame, "TOPRIGHT", 2, -30)

	local bd = CreateFrame("Frame", nil, GuildBankPopupFrame)
	bd:SetPoint("TOPLEFT")
	bd:SetPoint("BOTTOMRIGHT", -28, 26)
	bd:SetFrameLevel(GuildBankPopupFrame:GetFrameLevel()-1)
	A:CreateBD(bd)
	A:CreateBD(GuildBankPopupEditBox, .25)

    GuildBankFrame:DisableDrawLayer("BACKGROUND")
    GuildBankFrame:DisableDrawLayer("BORDER")
    GuildBankFrame:DisableDrawLayer("OVERLAY")
    GuildBankTabTitle:SetDrawLayer("ARTWORK")
	GuildBankEmblemFrame:Hide()
	GuildBankPopupFrameTopLeft:Hide()
	GuildBankPopupFrameBottomLeft:Hide()
	select(2, GuildBankPopupFrame:GetRegions()):Hide()
	select(4, GuildBankPopupFrame:GetRegions()):Hide()
    GuildBankMoneyFrameBackground:Hide()
	GuildBankPopupNameLeft:Hide()
	GuildBankPopupNameMiddle:Hide()
	GuildBankPopupNameRight:Hide()
	GuildBankPopupScrollFrame:GetRegions():Hide()
	select(2, GuildBankPopupScrollFrame:GetRegions()):Hide()
	GuildBankTabTitleBackground:SetAlpha(0)
	GuildBankTabTitleBackgroundLeft:SetAlpha(0)
	GuildBankTabTitleBackgroundRight:SetAlpha(0)
	GuildBankTabLimitBackground:SetAlpha(0)
	GuildBankTabLimitBackgroundLeft:SetAlpha(0)
	GuildBankTabLimitBackgroundRight:SetAlpha(0)
	local a, b = GuildBankTransactionsScrollFrame:GetRegions()
	a:Hide()
	b:Hide()

	for i = 1, 4 do
		local tab = _G["GuildBankFrameTab"..i]
		A:CreateTab(tab)

		if i ~= 1 then
			tab:SetPoint("LEFT", _G["GuildBankFrameTab"..i-1], "RIGHT", -15, 0)
		end
	end

	A:Reskin(GuildBankFrameWithdrawButton)
	A:Reskin(GuildBankFrameDepositButton)
	A:Reskin(GuildBankFramePurchaseButton)
	A:Reskin(GuildBankPopupOkayButton)
	A:Reskin(GuildBankPopupCancelButton)
	A:Reskin(GuildBankInfoSaveButton)
	A:ReskinClose(GuildBankFrame.CloseButton)
	A:ReskinInput(GuildItemSearchBox)

	GuildBankFrameWithdrawButton:ClearAllPoints()
	GuildBankFrameWithdrawButton:Point("RIGHT", GuildBankFrameDepositButton, "LEFT", -1, 0)

	for i = 1, NUM_GUILDBANK_COLUMNS do
		_G["GuildBankColumn"..i]:GetRegions():Hide()
		for j = 1, NUM_SLOTS_PER_GUILDBANK_GROUP do
			local bu = _G["GuildBankColumn"..i.."Button"..j]
			bu:StyleButton(true)

			_G["GuildBankColumn"..i.."Button"..j.."IconTexture"]:SetTexCoord(.08, .92, .08, .92)
			_G["GuildBankColumn"..i.."Button"..j.."NormalTexture"]:SetAlpha(0)

			local glow = CreateFrame("Frame", nil, bu)
			glow:SetAllPoints()
			glow:CreateBorder()
			bu.glow = glow
			bu:SetBackdrop({
					bgFile = A["media"].blank,
					insets = { left = -S.mult, right = -S.mult, top = -S.mult, bottom = -S.mult }
				})
		end
	end

	for i = 1, 8 do
		local tb = _G["GuildBankTab"..i]
		local bu = _G["GuildBankTab"..i.."Button"]
		local ic = _G["GuildBankTab"..i.."ButtonIconTexture"]
		local nt = _G["GuildBankTab"..i.."ButtonNormalTexture"]

		A:CreateBG(bu)
		A:CreateSD(bu, 5, 0, 0, 0, 1, 1)

		local a1, p, a2, x, y = bu:GetPoint()
		bu:Point(a1, p, a2, x + 11, y)

		ic:SetTexCoord(.08, .92, .08, .92)
		tb:GetRegions():Hide()
		nt:SetAlpha(0)

		_G["GuildBankTab"..i]:StripTextures()

		bu:StyleButton(true)
	end

	local function ColorBorder()
		local tab = GetCurrentGuildBankTab()
		for i=1, MAX_GUILDBANK_SLOTS_PER_TAB do
			local index = mod(i, NUM_SLOTS_PER_GUILDBANK_GROUP)
			local column = ceil((i-0.5)/NUM_SLOTS_PER_GUILDBANK_GROUP)
			if ( index == 0 ) then
				index = NUM_SLOTS_PER_GUILDBANK_GROUP
			end
			local button = _G["GuildBankColumn"..column.."Button"..index]
			local icontexture = _G["GuildBankColumn"..column.."Button"..index.."IconTexture"]
			local glow = button.glow
			local link = GetGuildBankItemLink(tab, i)
			if link then
				local _, _, quality, _, _, _, _, _, _, texture = GetItemInfo(link)
				if S:IsItemUnusable(link) then
					icontexture:SetVertexColor(1, 0, 0)
				else
					icontexture:SetVertexColor(1, 1, 1)
				end
				if quality and quality > 1 then
					icontexture:Point("TOPLEFT", 2, -2)
					icontexture:Point("BOTTOMRIGHT", -2, 2)
					button:StyleButton(2)
					glow:SetBackdropBorderColor(GetItemQualityColor(quality))
					button:SetBackdropColor(0, 0, 0)
				else
					icontexture:SetAllPoints()
					button:StyleButton(true)
					glow:SetBackdropBorderColor(0, 0, 0)
					button:SetBackdropColor(0, 0, 0, 0)
				end
			else
				button:StyleButton(true)
				glow:SetBackdropBorderColor(0, 0, 0)
				button:SetBackdropColor(0, 0, 0, 0)
			end
		end
	end
	hooksecurefunc("GuildBankFrame_Update", ColorBorder)
end

A:RegisterSkin("Blizzard_GuildBankUI", LoadSkin)
