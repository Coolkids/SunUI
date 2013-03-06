local S, L, DB, _, C = unpack(select(2, ...))
local r, g, b = DB.MyClassColor.r, DB.MyClassColor.g, DB.MyClassColor.b
local AuroraConfig = DB.AuroraConfig

DB.AuroraModules["Blizzard_BarbershopUI"] = function()
	S.SetBD(BarberShopFrame, 44, -75, -40, 44)
	BarberShopFrameBackground:Hide()
	BarberShopFrameMoneyFrame:GetRegions():Hide()
	S.Reskin(BarberShopFrameOkayButton)
	S.Reskin(BarberShopFrameCancelButton)
	S.Reskin(BarberShopFrameResetButton)
	S.ReskinArrow(BarberShopFrameSelector1Prev, "left")
	S.ReskinArrow(BarberShopFrameSelector1Next, "right")
	S.ReskinArrow(BarberShopFrameSelector2Prev, "left")
	S.ReskinArrow(BarberShopFrameSelector2Next, "right")
	S.ReskinArrow(BarberShopFrameSelector3Prev, "left")
	S.ReskinArrow(BarberShopFrameSelector3Next, "right")
end