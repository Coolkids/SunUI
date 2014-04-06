local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local A = S:GetModule("Skins")

local function LoadSkin()
	TabardFrameMoneyInset:DisableDrawLayer("BORDER")
    TabardFrameCustomizationBorder:Hide()
    TabardFrameMoneyBg:Hide()
    TabardFrameMoneyInsetBg:Hide()

    for i = 19, 28 do
        select(i, TabardFrame:GetRegions()):Hide()
    end

    for i = 1, 5 do
        _G["TabardFrameCustomization"..i.."Left"]:Hide()
        _G["TabardFrameCustomization"..i.."Middle"]:Hide()
        _G["TabardFrameCustomization"..i.."Right"]:Hide()
        A:ReskinArrow(_G["TabardFrameCustomization"..i.."LeftButton"], "left")
        A:ReskinArrow(_G["TabardFrameCustomization"..i.."RightButton"], "right")
    end

    A:ReskinPortraitFrame(TabardFrame, true)
    A:CreateBD(TabardFrameCostFrame, .25)
    A:Reskin(TabardFrameAcceptButton)
    A:Reskin(TabardFrameCancelButton)
end

A:RegisterSkin("SunUI", LoadSkin)
