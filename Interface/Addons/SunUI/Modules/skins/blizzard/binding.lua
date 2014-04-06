local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local A = S:GetModule("Skins")

local function LoadSkin()
	A:SetBD(KeyBindingFrame, 2, 0, -38, 10)
	KeyBindingFrame:DisableDrawLayer("BACKGROUND")
	KeyBindingFrameOutputText:SetDrawLayer("OVERLAY")
	KeyBindingFrameHeader:SetTexture("")
	A:Reskin(KeyBindingFrameDefaultButton)
	A:Reskin(KeyBindingFrameUnbindButton)
	A:Reskin(KeyBindingFrameOkayButton)
	A:Reskin(KeyBindingFrameCancelButton)
	KeyBindingFrameOkayButton:ClearAllPoints()
	KeyBindingFrameOkayButton:SetPoint("RIGHT", KeyBindingFrameCancelButton, "LEFT", -1, 0)
	KeyBindingFrameUnbindButton:ClearAllPoints()
	KeyBindingFrameUnbindButton:SetPoint("RIGHT", KeyBindingFrameOkayButton, "LEFT", -1, 0)

	for i = 1, KEY_BINDINGS_DISPLAYED do
		local button1 = _G["KeyBindingFrameBinding"..i.."Key1Button"]
		local button2 = _G["KeyBindingFrameBinding"..i.."Key2Button"]

		button2:SetPoint("LEFT", button1, "RIGHT", 1, 0)
		A:Reskin(button1)
		A:Reskin(button2)
	end

	A:ReskinScroll(KeyBindingFrameScrollFrameScrollBar)
	A:ReskinCheck(KeyBindingFrameCharacterButton)
end

A:RegisterSkin("Blizzard_BindingUI", LoadSkin)