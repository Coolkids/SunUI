local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local A = S:GetModule("Skins")

local function LoadSkin()
	MacroFrameText:SetFont(S["media"].font, 14)
	A:ReskinPortraitFrame(MacroFrame, true)
	A:CreateBD(MacroFrameScrollFrame, .25)
	A:CreateBD(MacroPopupFrame)
	A:CreateBD(MacroPopupEditBox, .25)
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

	for i = 1, MAX_ACCOUNT_MACROS do
		local bu = _G["MacroButton"..i]
		local ic = _G["MacroButton"..i.."Icon"]

		select(2, bu:GetRegions()):Hide()
		bu:StyleButton(1)
		bu:SetPushedTexture(nil)

		ic:Point("TOPLEFT", 1, -1)
		ic:Point("BOTTOMRIGHT", -1, 1)
		ic:SetTexCoord(.08, .92, .08, .92)

		A:CreateBD(bu, .25)
	end

	for i = 1, NUM_MACRO_ICONS_SHOWN do
		local bu = _G["MacroPopupButton"..i]
		local ic = _G["MacroPopupButton"..i.."Icon"]

		select(2, bu:GetRegions()):Hide()
		bu:StyleButton(1)
		bu:SetPushedTexture(nil)

		ic:Point("TOPLEFT", 1, -1)
		ic:Point("BOTTOMRIGHT", -1, 1)
		ic:SetTexCoord(.08, .92, .08, .92)

		A:CreateBD(bu, .25)
	end

	MacroFrameSelectedMacroButton:StyleButton(true)
	MacroFrameSelectedMacroButton:SetPoint("TOPLEFT", MacroFrameSelectedMacroBackground, "TOPLEFT", 12, -16)
	MacroFrameSelectedMacroButtonIcon:SetPoint("TOPLEFT", 1, -1)
	MacroFrameSelectedMacroButtonIcon:SetPoint("BOTTOMRIGHT", -1, 1)
	MacroFrameSelectedMacroButtonIcon:SetTexCoord(.08, .92, .08, .92)

	A:CreateBD(MacroFrameSelectedMacroButton, .25)

	A:Reskin(MacroDeleteButton)
	A:Reskin(MacroNewButton)
	A:Reskin(MacroExitButton)
	A:Reskin(MacroEditButton)
	A:Reskin(MacroSaveButton)
	A:Reskin(MacroCancelButton)
	A:Reskin(MacroPopupOkayButton)
	A:Reskin(MacroPopupCancelButton)
	MacroPopupFrame:ClearAllPoints()
	MacroPopupFrame:SetPoint("TOPLEFT", MacroFrame, "TOPRIGHT", -32, -40)

	A:ReskinClose(MacroFrameCloseButton, "TOPRIGHT", MacroFrame, "TOPRIGHT", -38, -14)
	A:ReskinScroll(MacroButtonScrollFrameScrollBar)
	A:ReskinScroll(MacroFrameScrollFrameScrollBar)
	A:ReskinScroll(MacroPopupScrollFrameScrollBar)
end

A:RegisterSkin("Blizzard_MacroUI", LoadSkin)
