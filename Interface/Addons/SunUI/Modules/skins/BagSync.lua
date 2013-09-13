local S, L, DB, _, C = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("SkinBagSync", "AceEvent-3.0")
local style = false
local function Skin()
	if not style then
		BagSync_SearchFrame:StripTextures()
		S.SetBD(BagSync_SearchFrame)
		S.ReskinInput(BagSync_SearchFrameEdit1)
		BagSync_TokensFrame:StripTextures()
		S.SetBD(BagSync_TokensFrame)
		style = true
	end
end

function Module:OnInitialize()
	if not IsAddOnLoaded("BagSync") then return end
	Skin()
end