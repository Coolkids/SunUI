local S, L, DB, _, C = unpack(select(2, ...))
local r, g, b = DB.MyClassColor.r, DB.MyClassColor.g, DB.MyClassColor.b
local AuroraConfig = DB.AuroraConfig

DB.AuroraModules["Blizzard_TimeManager"] = function()
	TimeManagerGlobe:Hide()
	StopwatchFrameBackgroundLeft:Hide()
	select(2, StopwatchFrame:GetRegions()):Hide()
	StopwatchTabFrameLeft:Hide()
	StopwatchTabFrameMiddle:Hide()
	StopwatchTabFrameRight:Hide()

	TimeManagerStopwatchCheck:GetNormalTexture():SetTexCoord(.08, .92, .08, .92)
	TimeManagerStopwatchCheck:SetCheckedTexture(DB.media.checked)
	S.CreateBG(TimeManagerStopwatchCheck)

	TimeManagerAlarmHourDropDown:Width(80)
	TimeManagerAlarmMinuteDropDown:Width(80)
	TimeManagerAlarmAMPMDropDown:Width(90)

	S.ReskinPortraitFrame(TimeManagerFrame, true)
	select(9, TimeManagerFrame:GetChildren()):Hide()

	S.CreateBD(StopwatchFrame)
	S.ReskinDropDown(TimeManagerAlarmHourDropDown)
	S.ReskinDropDown(TimeManagerAlarmMinuteDropDown)
	S.ReskinDropDown(TimeManagerAlarmAMPMDropDown)
	S.ReskinInput(TimeManagerAlarmMessageEditBox)
	S.ReskinCheck(TimeManagerAlarmEnabledButton)
	S.ReskinCheck(TimeManagerMilitaryTimeCheck)
	S.ReskinCheck(TimeManagerLocalTimeCheck)
	S.ReskinClose(StopwatchCloseButton, "TOPRIGHT", StopwatchFrame, "TOPRIGHT", -2, -2)
end