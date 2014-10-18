local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local A = S:GetModule("Skins")

local function LoadSkin()
	A:ReskinPortraitFrame(AddonList, true)
	A:Reskin(AddonListEnableAllButton)
	A:Reskin(AddonListDisableAllButton)
	A:Reskin(AddonListCancelButton)
	A:Reskin(AddonListOkayButton)
	A:ReskinCheck(AddonListForceLoad)
	A:ReskinDropDown(AddonCharacterDropDown)

	AddonCharacterDropDown:SetWidth(170)

	for i = 1, MAX_ADDONS_DISPLAYED do
		A:ReskinCheck(_G["AddonListEntry"..i.."Enabled"])
	end
end

A:RegisterSkin("SunUI", LoadSkin)