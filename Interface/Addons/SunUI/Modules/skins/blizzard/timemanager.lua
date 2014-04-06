local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local A = S:GetModule("Skins")

local function LoadSkin()
    TimeManagerGlobe:Hide()
    StopwatchFrameBackgroundLeft:Hide()
    select(2, StopwatchFrame:GetRegions()):Hide()
    StopwatchTabFrameLeft:Hide()
    StopwatchTabFrameMiddle:Hide()
    StopwatchTabFrameRight:Hide()

    TimeManagerStopwatchCheck:GetNormalTexture():SetTexCoord(.08, .92, .08, .92)
    TimeManagerStopwatchCheck:SetCheckedTexture(A["media"].checked)
    A:CreateBG(TimeManagerStopwatchCheck)

    TimeManagerAlarmHourDropDown:SetWidth(80)
    TimeManagerAlarmMinuteDropDown:SetWidth(80)
    TimeManagerAlarmAMPMDropDown:SetWidth(90)

    A:ReskinPortraitFrame(TimeManagerFrame, true)
    A:CreateBD(StopwatchFrame)
    A:ReskinDropDown(TimeManagerAlarmHourDropDown)
    A:ReskinDropDown(TimeManagerAlarmMinuteDropDown)
    A:ReskinDropDown(TimeManagerAlarmAMPMDropDown)
    A:ReskinInput(TimeManagerAlarmMessageEditBox)
    A:ReskinCheck(TimeManagerMilitaryTimeCheck)
    A:ReskinCheck(TimeManagerLocalTimeCheck)
    A:ReskinCheck(TimeManagerAlarmEnabledButton)
    A:ReskinClose(StopwatchCloseButton, "TOPRIGHT", StopwatchFrame, "TOPRIGHT", -2, -2)
end

A:RegisterSkin("Blizzard_TimeManager", LoadSkin)
