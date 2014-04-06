local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local A = S:GetModule("Skins")

local function LoadSkin()
    GuildRegistrarFrameTop:Hide()
    GuildRegistrarFrameBottom:Hide()
    GuildRegistrarFrameMiddle:Hide()
    select(19, GuildRegistrarFrame:GetRegions()):Hide()
    select(6, GuildRegistrarFrameEditBox:GetRegions()):Hide()
    select(7, GuildRegistrarFrameEditBox:GetRegions()):Hide()

    GuildRegistrarFrameEditBox:SetHeight(20)

    A:ReskinPortraitFrame(GuildRegistrarFrame, true)
    A:CreateBD(GuildRegistrarFrameEditBox, .25)
    A:Reskin(GuildRegistrarFrameGoodbyeButton)
    A:Reskin(GuildRegistrarFramePurchaseButton)
    A:Reskin(GuildRegistrarFrameCancelButton)
end

A:RegisterSkin("SunUI", LoadSkin)
