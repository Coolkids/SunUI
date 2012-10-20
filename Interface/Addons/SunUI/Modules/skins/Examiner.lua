if not IsAddOnLoaded("Examiner") then return end
local S, C, L, DB = unpack(select(2, ...))
local _
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