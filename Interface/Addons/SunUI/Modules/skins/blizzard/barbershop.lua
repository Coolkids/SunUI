local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local A = S:GetModule("Skins")

local function LoadSkin()
	A:SetBD(BarberShopFrame, 44, -75, -40, 44)
	BarberShopFrameBackground:Hide()
	BarberShopFrameMoneyFrame:GetRegions():Hide()
	A:Reskin(BarberShopFrameOkayButton)
	A:Reskin(BarberShopFrameCancelButton)
	A:Reskin(BarberShopFrameResetButton)
	A:ReskinArrow(BarberShopFrameSelector1Prev, "left")
	A:ReskinArrow(BarberShopFrameSelector1Next, "right")
	A:ReskinArrow(BarberShopFrameSelector2Prev, "left")
	A:ReskinArrow(BarberShopFrameSelector2Next, "right")
	A:ReskinArrow(BarberShopFrameSelector3Prev, "left")
	A:ReskinArrow(BarberShopFrameSelector3Next, "right")
	A:ReskinArrow(BarberShopFrameSelector4Prev, "left")
	A:ReskinArrow(BarberShopFrameSelector4Next, "right")
end

A:RegisterSkin("Blizzard_BarbershopUI", LoadSkin)