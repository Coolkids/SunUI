local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local A = S:GetModule("Skins")

local function LoadSkin()
    select(18, PetitionFrame:GetRegions()):Hide()
    select(19, PetitionFrame:GetRegions()):Hide()
    select(23, PetitionFrame:GetRegions()):Hide()
    select(24, PetitionFrame:GetRegions()):Hide()
    PetitionFrameTop:Hide()
    PetitionFrameBottom:Hide()
    PetitionFrameMiddle:Hide()

    A:ReskinPortraitFrame(PetitionFrame, true)
    A:Reskin(PetitionFrameSignButton)
    A:Reskin(PetitionFrameRequestButton)
    A:Reskin(PetitionFrameRenameButton)
    A:Reskin(PetitionFrameCancelButton)
end

A:RegisterSkin("SunUI", LoadSkin)
