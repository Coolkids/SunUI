local S, L, DB, _, C = unpack(select(2, ...))
local r, g, b = DB.MyClassColor.r, DB.MyClassColor.g, DB.MyClassColor.b
local AuroraConfig = DB.AuroraConfig

DB.AuroraModules["Blizzard_MacroUI"] = function()
	select(18, MacroFrame:GetRegions()):Hide()
	MacroHorizontalBarLeft:Hide()
	select(21, MacroFrame:GetRegions()):Hide()

	for i = 1, 6 do
		select(i, MacroFrameTab1:GetRegions()):Hide()
		select(i, MacroFrameTab2:GetRegions()):Hide()
		select(i, MacroFrameTab1:GetRegions()).Show = S.dummy
		select(i, MacroFrameTab2:GetRegions()).Show = S.dummy
	end
	for i = 1, 5 do
		select(i, MacroPopupFrame:GetRegions()):Hide()
	end
	MacroPopupScrollFrame:GetRegions():Hide()
	select(2, MacroPopupScrollFrame:GetRegions()):Hide()
	MacroPopupNameLeft:Hide()
	MacroPopupNameMiddle:Hide()
	MacroPopupNameRight:Hide()
	MacroFrameTextBackground:SetBackdrop(nil)
	select(2, MacroFrameSelectedMacroButton:GetRegions()):Hide()
	MacroFrameSelectedMacroBackground:SetAlpha(0)
	MacroButtonScrollFrameTop:Hide()
	MacroButtonScrollFrameBottom:Hide()

	MacroFrameSelectedMacroButton:Point("TOPLEFT", MacroFrameSelectedMacroBackground, "TOPLEFT", 12, -16)
	MacroFrameSelectedMacroButtonIcon:Point("TOPLEFT", 1, -1)
	MacroFrameSelectedMacroButtonIcon:Point("BOTTOMRIGHT", -1, 1)
	MacroFrameSelectedMacroButtonIcon:SetTexCoord(.08, .92, .08, .92)

	MacroPopupFrame:Point("TOPLEFT", MacroFrame, "TOPRIGHT", 1, 0)

	MacroNewButton:ClearAllPoints()
	MacroNewButton:Point("RIGHT", MacroExitButton, "LEFT", -1, 0)

	for i = 1, MAX_ACCOUNT_MACROS do
		local bu = _G["MacroButton"..i]
		local ic = _G["MacroButton"..i.."Icon"]

		bu:SetCheckedTexture(DB.media.checked)
		select(2, bu:GetRegions()):Hide()

		ic:Point("TOPLEFT", 1, -1)
		ic:Point("BOTTOMRIGHT", -1, 1)
		ic:SetTexCoord(.08, .92, .08, .92)

		S.CreateBD(bu, .25)
	end

	for i = 1, NUM_MACRO_ICONS_SHOWN do
		local bu = _G["MacroPopupButton"..i]
		local ic = _G["MacroPopupButton"..i.."Icon"]

		bu:SetCheckedTexture(DB.media.checked)
		select(2, bu:GetRegions()):Hide()

		ic:Point("TOPLEFT", 1, -1)
		ic:Point("BOTTOMRIGHT", -1, 1)
		ic:SetTexCoord(.08, .92, .08, .92)

		S.CreateBD(bu, .25)
	end

	S.ReskinPortraitFrame(MacroFrame, true)
	S.CreateBD(MacroFrameScrollFrame, .25)
	S.CreateBD(MacroPopupFrame)
	S.CreateBD(MacroPopupEditBox, .25)
	S.CreateBD(MacroFrameSelectedMacroButton, .25)
	S.Reskin(MacroDeleteButton)
	S.Reskin(MacroNewButton)
	S.Reskin(MacroExitButton)
	S.Reskin(MacroEditButton)
	S.Reskin(MacroPopupOkayButton)
	S.Reskin(MacroPopupCancelButton)
	S.Reskin(MacroSaveButton)
	S.Reskin(MacroCancelButton)
	S.ReskinScroll(MacroButtonScrollFrameScrollBar)
	S.ReskinScroll(MacroFrameScrollFrameScrollBar)
	S.ReskinScroll(MacroPopupScrollFrameScrollBar)
end