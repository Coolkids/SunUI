local S, C, L, DB = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("SkinBagSync", "AceEvent-3.0")

local function Skin()
	if BagSync_SearchFrame then
		BagSync_SearchFrame:StripTextures()
		S.SetBD(BagSync_SearchFrame)
		S.ReskinInput(BagSync_SearchFrameEdit1)
	end
	if BagSync_TokensFrame then
		BagSync_TokensFrame:StripTextures()
		S.SetBD(BagSync_TokensFrame)
	end
end

function Module:OnInitialize()
	if not IsAddOnLoaded("BagSync") then return end
	Skin()
end