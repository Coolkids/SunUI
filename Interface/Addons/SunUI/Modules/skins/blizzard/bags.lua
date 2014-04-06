local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local A = S:GetModule("Skins")

local function LoadSkin()
	local r, g, b = RAID_CLASS_COLORS[S.myclass].r, RAID_CLASS_COLORS[S.myclass].g, RAID_CLASS_COLORS[S.myclass].b
	A:ReskinCheck(TokenFramePopupInactiveCheckBox)
	A:ReskinCheck(TokenFramePopupBackpackCheckBox)
	A:ReskinClose(TokenFramePopupCloseButton)
	A:ReskinScroll(TokenFrameContainerScrollBar)
	TokenFramePopupCorner:Hide()
	TokenFramePopup:SetPoint("TOPLEFT", TokenFrame, "TOPRIGHT", 1, -28)
	local function updateButtons()
		local buttons = TokenFrameContainer.buttons
		for i = 1, #buttons do

			local button = buttons[i]

			if button and not button.reskinned then
				button.highlight:SetPoint("TOPLEFT", 1, 0)
				button.highlight:SetPoint("BOTTOMRIGHT", -1, 0)
				button.highlight.SetPoint = S.dummy
				button.highlight:SetTexture(r, g, b, .2)
				button.highlight.SetTexture = S.dummy
				button.categoryMiddle:SetAlpha(0)
				button.categoryLeft:SetAlpha(0)
				button.categoryRight:SetAlpha(0)

				button.icon:SetTexCoord(.08, .92, .08, .92)
				button.bg = A:CreateBG(button.icon)
				button.reskinned = true
			end

			if button.isHeader then
				button.bg:Hide()
			else
				button.bg:Show()
			end
		end
	end
	TokenFrame:HookScript("OnShow", updateButtons)
	hooksecurefunc(TokenFrameContainer, "update", updateButtons)
end

A:RegisterSkin("SunUI", LoadSkin)