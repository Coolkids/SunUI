local S, L, DB, _, C = unpack(select(2, ...))
local r, g, b = DB.MyClassColor.r, DB.MyClassColor.g, DB.MyClassColor.b
local AuroraConfig = DB.AuroraConfig

DB.AuroraModules["Blizzard_BindingUI"] = function()
		S.SetBD(KeyBindingFrame, 2, 0, -38, 10)
		KeyBindingFrame:DisableDrawLayer("BACKGROUND")
		KeyBindingFrameOutputText:SetDrawLayer("OVERLAY")
		KeyBindingFrameHeader:SetTexture("")
		S.Reskin(KeyBindingFrameDefaultButton)
		S.Reskin(KeyBindingFrameUnbindButton)
		S.Reskin(KeyBindingFrameOkayButton)
		S.Reskin(KeyBindingFrameCancelButton)
		KeyBindingFrameOkayButton:ClearAllPoints()
		KeyBindingFrameOkayButton:Point("RIGHT", KeyBindingFrameCancelButton, "LEFT", -1, 0)
		KeyBindingFrameUnbindButton:ClearAllPoints()
		KeyBindingFrameUnbindButton:Point("RIGHT", KeyBindingFrameOkayButton, "LEFT", -1, 0)

		for i = 1, KEY_BINDINGS_DISPLAYED do
			local button1 = _G["KeyBindingFrameBinding"..i.."Key1Button"]
			local button2 = _G["KeyBindingFrameBinding"..i.."Key2Button"]

			button2:Point("LEFT", button1, "RIGHT", 1, 0)
			S.Reskin(button1)
			S.Reskin(button2)
		end

		S.ReskinScroll(KeyBindingFrameScrollFrameScrollBar)
		S.ReskinCheck(KeyBindingFrameCharacterButton)
end