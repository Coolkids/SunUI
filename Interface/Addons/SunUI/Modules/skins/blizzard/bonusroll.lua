local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local A = S:GetModule("Skins")

local function LoadSkin()
	--[[BonusRollFrame:StripTextures()
	A:CreateBD(BonusRollFrame)
	BonusRollFrame.PromptFrame.Icon:SetTexCoord(.08, .92, .08, .92)
	BonusRollFrame.PromptFrame.IconBackdrop = CreateFrame("Frame", nil, BonusRollFrame.PromptFrame)
	BonusRollFrame.PromptFrame.IconBackdrop:SetFrameLevel(BonusRollFrame.PromptFrame.IconBackdrop:GetFrameLevel() - 1)
	BonusRollFrame.PromptFrame.IconBackdrop:SetOutside(BonusRollFrame.PromptFrame.Icon, 1, 1)
	A:CreateBD(BonusRollFrame.PromptFrame.IconBackdrop)
	BonusRollFrame.BlackBackgroundHoist:Kill()
	BonusRollFrame.PromptFrame.Timer.Bar:SetTexture(A["media"].blank)
	BonusRollFrame.PromptFrame.Timer.Bar:SetVertexColor(0, .6, 1)
	BonusRollFrame.PromptFrame.Timer.border = CreateFrame("Frame", nil, BonusRollFrame.PromptFrame.Timer)
	BonusRollFrame.PromptFrame.Timer.border:SetFrameLevel(BonusRollFrame.PromptFrame.Timer:GetFrameLevel() - 1)
	BonusRollFrame.PromptFrame.Timer.border:SetOutside(BonusRollFrame.PromptFrame.Timer, 1, 1)
	A:CreateBD(BonusRollFrame.PromptFrame.Timer.border)

	BonusRollMoneyWonFrame:SetAlpha(1)
	BonusRollMoneyWonFrame.SetAlpha = S.dummy
	if not BonusRollMoneyWonFrame.bg then
		BonusRollMoneyWonFrame.bg = CreateFrame("Frame", nil, BonusRollMoneyWonFrame)
		BonusRollMoneyWonFrame.bg:SetPoint("TOPLEFT", BonusRollMoneyWonFrame, "TOPLEFT", 8, -8)
		BonusRollMoneyWonFrame.bg:SetPoint("BOTTOMRIGHT", BonusRollMoneyWonFrame, "BOTTOMRIGHT", -6, 8)
		BonusRollMoneyWonFrame.bg:SetFrameLevel(BonusRollMoneyWonFrame:GetFrameLevel()-1)

		-- Icon border
		if not BonusRollMoneyWonFrame.Icon.b then
			BonusRollMoneyWonFrame.Icon.b = A:CreateBG(BonusRollMoneyWonFrame.Icon)
		end

		BonusRollMoneyWonFrame:HookScript("OnEnter", function()
			A:CreateBD(BonusRollMoneyWonFrame.bg)
		end)

		BonusRollMoneyWonFrame.animIn:HookScript("OnFinished", function()
			A:CreateBD(BonusRollMoneyWonFrame.bg)
		end)
	end
	BonusRollMoneyWonFrame.Background:Kill()
	BonusRollMoneyWonFrame.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	BonusRollMoneyWonFrame.IconBorder:Kill()


	BonusRollMoneyWonFrame:SetAlpha(1)
	BonusRollMoneyWonFrame.SetAlpha = S.dummy
	if not BonusRollLootWonFrame.bg then
		BonusRollLootWonFrame.bg = CreateFrame("Frame", nil, BonusRollLootWonFrame)
		BonusRollLootWonFrame.bg:SetPoint("TOPLEFT", BonusRollLootWonFrame, "TOPLEFT", 8, -8)
		BonusRollLootWonFrame.bg:SetPoint("BOTTOMRIGHT", BonusRollLootWonFrame, "BOTTOMRIGHT", -6, 8)
		BonusRollLootWonFrame.bg:SetFrameLevel(BonusRollLootWonFrame:GetFrameLevel()-1)

		-- Icon border
		if not BonusRollLootWonFrame.Icon.b then
			BonusRollLootWonFrame.Icon.b = A:CreateBG(BonusRollLootWonFrame.Icon)
		end

		BonusRollLootWonFrame:HookScript("OnEnter", function()
			A:CreateBD(BonusRollLootWonFrame.bg)
		end)

		BonusRollLootWonFrame.animIn:HookScript("OnFinished", function()
			A:CreateBD(BonusRollLootWonFrame.bg)
		end)
	end
	BonusRollLootWonFrame.Background:Kill()
	BonusRollLootWonFrame.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	BonusRollLootWonFrame.IconBorder:Kill()
	BonusRollFrame.SpecIcon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	A:CreateBG(BonusRollFrame.SpecIcon) --]]
	BonusRollFrame.Background:SetAlpha(0)
	BonusRollFrame.IconBorder:Hide()
	BonusRollFrame.BlackBackgroundHoist.Background:Hide()

	BonusRollFrame.PromptFrame.Icon:SetTexCoord(.08, .92, .08, .92)
	A:CreateBG(BonusRollFrame.PromptFrame.Icon)

	BonusRollFrame.PromptFrame.Timer.Bar:SetTexture(A.media.backdrop)

	A:CreateBD(BonusRollFrame)
	A:CreateBDFrame(BonusRollFrame.PromptFrame.Timer, .25)
end

A:RegisterSkin("SunUI", LoadSkin)
