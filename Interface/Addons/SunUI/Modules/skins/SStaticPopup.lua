local S, L, DB, _, C = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("SkinFixStaticPopup", "AceEvent-3.0")
local function Skin()
	if IsAddOnLoaded("!FixStaticPopup") then
		for i = 1, 2 do
			local bu = _G["SStaticPopup"..i.."ItemFrame"]
			_G["SStaticPopup"..i.."ItemFrameNameFrame"]:Hide()
			_G["SStaticPopup"..i.."ItemFrameIconTexture"]:SetTexCoord(.08, .92, .08, .92)

			bu:SetNormalTexture("")
			S.CreateBG(bu)
		end
		for i = 1, 2 do
			for j = 1, 3 do
				S.Reskin(_G["SStaticPopup"..i.."Button"..j])
			end
		end
		S.ReskinClose(SStaticPopup1CloseButton)
				
		local inputs = {"StaticPopup1MoneyInputFrameGold", "StaticPopup1MoneyInputFrameSilver", "StaticPopup1MoneyInputFrameCopper", "StaticPopup2MoneyInputFrameGold", "StaticPopup2MoneyInputFrameSilver", "StaticPopup2MoneyInputFrameCopper"}
		for i = 1, #inputs do
			local input = _G[inputs[i]]
			if input then
				S.ReskinInput(input)
			else
				print("Aurora: "..inputs[i].." was not found.")
			end
		end
		S.ReskinInput(SStaticPopup1EditBox, 20)
		S.ReskinInput(SStaticPopup2EditBox, 20)
			
		local FrameBDs = {"SStaticPopup1", "SStaticPopup2"}
		for i = 1, #FrameBDs do
			FrameBD = _G[FrameBDs[i]]
			S.CreateBD(FrameBD)
			S.CreateSD(FrameBD)
		end
	end
end
function Module:OnEnable()
	Skin()
end