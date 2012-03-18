local S, C, L, DB = unpack(select(2, ...))

local function TimeManagerSkin(_, _, addon)
	if addon == "Blizzard_TimeManager" then
		local r, g, b = DB.MyClassColor.r, DB.MyClassColor.g, DB.MyClassColor.b
		S.StripTextures(TimeManagerFrame)
		S.SetBD(TimeManagerFrame, 5, -10, -48, 10)
		S.ReskinClose(TimeManagerCloseButton, "TOPRIGHT", TimeManagerFrame, "TOPRIGHT", -51, -13)
		S.ReskinDropDown(TimeManagerAlarmHourDropDown)
		TimeManagerAlarmHourDropDown:SetWidth(80)
		S.ReskinDropDown(TimeManagerAlarmMinuteDropDown)
		TimeManagerAlarmMinuteDropDown:SetWidth(80)
		S.ReskinDropDown(TimeManagerAlarmAMPMDropDown)
		TimeManagerAlarmAMPMDropDown:SetWidth(90)
		S.ReskinCheck(TimeManagerMilitaryTimeCheck)
		S.ReskinCheck(TimeManagerLocalTimeCheck)
		S.ReskinInput(TimeManagerAlarmMessageEditBox)
		TimeManagerAlarmEnabledButton:SetNormalTexture(nil)
		TimeManagerAlarmEnabledButton.SetNormalTexture = DB.dummy
		S.Reskin(TimeManagerAlarmEnabledButton)
		
		S.StripTextures(TimeManagerStopwatchFrame)
		TimeManagerStopwatchCheck:CreateBorder()
		TimeManagerStopwatchCheck:GetNormalTexture():SetTexCoord(.08, .92, .08, .92)
		TimeManagerStopwatchCheck:GetNormalTexture():ClearAllPoints()
		TimeManagerStopwatchCheck:GetNormalTexture():SetPoint("TOPLEFT", 2, -2)
		TimeManagerStopwatchCheck:GetNormalTexture():SetPoint("BOTTOMRIGHT", -2, 2)
		local hover = TimeManagerStopwatchCheck:CreateTexture("frame", nil, TimeManagerStopwatchCheck) -- hover
		hover:SetTexture(1, 1, 1, 0.3)
		hover:Point("TOPLEFT", TimeManagerStopwatchCheck, 2, -2)
		hover:Point("BOTTOMRIGHT", TimeManagerStopwatchCheck, -2, 2)
		TimeManagerStopwatchCheck:SetHighlightTexture(hover)
		
		S.StripTextures(StopwatchFrame)
		--S.SetBD(StopwatchFrame)
		StopwatchFrame:CreateShadow("Background")
		S.StripTextures(StopwatchTabFrame)
		S.ReskinClose(StopwatchCloseButton)
		-- S:HandleNextPrevButton(StopwatchPlayPauseButton)
		-- S:HandleNextPrevButton(StopwatchResetButton)
		-- StopwatchPlayPauseButton:Point("RIGHT", StopwatchResetButton, "LEFT", -4, 0)
		-- StopwatchResetButton:Point("BOTTOMRIGHT", StopwatchFrame, "BOTTOMRIGHT", -4, 6)
	end
end

local load = CreateFrame("Frame")
load:SetScript("OnEvent", TimeManagerSkin)
load:RegisterEvent("ADDON_LOADED")

