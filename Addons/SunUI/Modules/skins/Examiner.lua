local S, L, DB, _, C = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("SkinExaminer", "AceEvent-3.0")
local style = false
local function Skin()
	if not IsAddOnLoaded("Examiner") then return end
	if not style then
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
		style = true
	end
end

function Module:OnEnable()
	Module:RegisterEvent("ADDON_LOADED", Skin)
end