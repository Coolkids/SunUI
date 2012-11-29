local S, C, L, DB = unpack(select(2, ...))
local Delay = CreateFrame("Frame")
Delay:RegisterEvent("PLAYER_ENTERING_WORLD")
Delay:SetScript("OnEvent", function()
	Delay:UnregisterEvent("PLAYER_ENTERING_WORLD")
	if not IsAddOnLoaded("Examiner") then return end
	Examiner:StripTextures()
	S.SetBD(Examiner)
	Examiner.portrait:Hide()
	local numBtn = 0
	for index, mod in ipairs(Examiner.modules) do
		numBtn = (numBtn + 1);
		if Examiner.buttons[numBtn] then
			S.Reskin(Examiner.buttons[numBtn])
		end
	end
end)