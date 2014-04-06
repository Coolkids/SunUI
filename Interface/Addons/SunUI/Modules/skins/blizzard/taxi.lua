local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local A = S:GetModule("Skins")

local function LoadSkin()
    TaxiFrame:DisableDrawLayer("BORDER")
    TaxiFrame:DisableDrawLayer("OVERLAY")
    TaxiFrame.Bg:Hide()
    TaxiFrame.TitleBg:Hide()
    TaxiFrame.TopTileStreaks:Hide()

    A:SetBD(TaxiFrame, 3, -23, -5, 3)
    A:ReskinClose(TaxiFrame.CloseButton, "TOPRIGHT", TaxiRouteMap, "TOPRIGHT", -4, -4)
end

A:RegisterSkin("SunUI", LoadSkin)
