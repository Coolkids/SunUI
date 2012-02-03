local function SetUIScale()
	SetCVar("useUiScale", 1)
	SetCVar("uiScale", 0.69999998807907)
	SetCVar("cameraDistanceMax", 50)
	SetCVar("cameraDistanceMaxFactor", 3.4)
end
SlashCmdList["AutoSet"] = function()
	if not UnitAffectingCombat("player") then
		SetUIScale()
	end
end
SLASH_AutoSet1 = "/AutoSet"