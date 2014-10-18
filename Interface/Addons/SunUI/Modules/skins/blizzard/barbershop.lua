local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local A = S:GetModule("Skins")

local function LoadSkin()
	BarberShopFrame:GetRegions():Hide()
	BarberShopFrameMoneyFrame:GetRegions():Hide()
	BarberShopAltFormFrameBackground:Hide()
	BarberShopAltFormFrameBorder:Hide()

	BarberShopAltFormFrame:ClearAllPoints()
	BarberShopAltFormFrame:SetPoint("BOTTOM", BarberShopFrame, "TOP", 0, -74)

	A:SetBD(BarberShopFrame, 44, -75, -40, 44)
	A:SetBD(BarberShopAltFormFrame, 0, 0, 2, -2)

	A:Reskin(BarberShopFrameOkayButton)
	A:Reskin(BarberShopFrameCancelButton)
	A:Reskin(BarberShopFrameResetButton)

	for i = 1, 5 do
		A:ReskinArrow(_G["BarberShopFrameSelector"..i.."Prev"], "left")
		A:ReskinArrow(_G["BarberShopFrameSelector"..i.."Next"], "right")
	end

	-- [[ Banner frame ]]

	BarberShopBannerFrameBGTexture:Hide()

	A:SetBD(BarberShopBannerFrame, 25, -80, -20, 75)
end

A:RegisterSkin("Blizzard_BarbershopUI", LoadSkin)