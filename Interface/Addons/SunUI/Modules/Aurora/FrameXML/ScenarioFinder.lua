local S, L, DB, _, C = unpack(select(2, ...))

local r, g, b = DB.MyClassColor.r, DB.MyClassColor.g, DB.MyClassColor.b
local AuroraConfig = DB.AuroraConfig

tinsert(DB.AuroraModules["SunUI"], function()
	ScenarioFinderFrameInset:DisableDrawLayer("BORDER")
	ScenarioFinderFrame.TopTileStreaks:Hide()
	ScenarioFinderFrameBtnCornerRight:Hide()
	ScenarioFinderFrameButtonBottomBorder:Hide()
	ScenarioQueueFrameRandomScrollFrameScrollBackground:Hide()
	ScenarioQueueFrameRandomScrollFrameScrollBackgroundTopLeft:Hide()
	ScenarioQueueFrameRandomScrollFrameScrollBackgroundBottomRight:Hide()
	ScenarioQueueFrameSpecificScrollFrameScrollBackgroundTopLeft:Hide()
	ScenarioQueueFrameSpecificScrollFrameScrollBackgroundBottomRight:Hide()
	ScenarioQueueFrame.Bg:Hide()
	ScenarioFinderFrameInset:GetRegions():Hide()

	ScenarioQueueFrameRandomScrollFrame:SetWidth(304)

	hooksecurefunc("ScenarioQueueFrameRandom_UpdateFrame", function()
		for i = 1, 2 do
			local button = _G["ScenarioQueueFrameRandomScrollFrameChildFrameItem"..i]

			if button and not button.styled then
				local icon = _G["ScenarioQueueFrameRandomScrollFrameChildFrameItem"..i.."IconTexture"]
				local cta = _G["ScenarioQueueFrameRandomScrollFrameChildFrameItem"..i.."ShortageBorder"]
				local count = _G["ScenarioQueueFrameRandomScrollFrameChildFrameItem"..i.."Count"]
				local na = _G["ScenarioQueueFrameRandomScrollFrameChildFrameItem"..i.."NameFrame"]

				S.CreateBG(icon)
				icon:SetTexCoord(.08, .92, .08, .92)
				icon:SetDrawLayer("OVERLAY")
				count:SetDrawLayer("OVERLAY")
				na:SetTexture(0, 0, 0, .25)
				na:SetSize(118, 39)
				cta:SetAlpha(0)

				button.bg2 = CreateFrame("Frame", nil, button)
				button.bg2:SetPoint("TOPLEFT", na, "TOPLEFT", 10, 0)
				button.bg2:SetPoint("BOTTOMRIGHT", na, "BOTTOMRIGHT")
				S.CreateBD(button.bg2, 0)

				button.styled = true
			end
		end
	end)

	local bonusValor = ScenarioQueueFrameRandomScrollFrameChildFrameBonusValor
	bonusValor.Border:Hide()
	bonusValor.Icon:SetTexCoord(.08, .92, .08, .92)
	bonusValor.Icon:SetPoint("CENTER", bonusValor.Border, -3, 0)
	bonusValor.Icon:SetSize(24, 24)
	bonusValor.BonusText:SetPoint("LEFT", bonusValor.Border, "RIGHT", -5, -1)
	S.CreateBG(bonusValor.Icon)

	S.Reskin(ScenarioQueueFrameFindGroupButton)
	S.Reskin(ScenarioQueueFrameRandomScrollFrameChildFrame.bonusRepFrame.ChooseButton)
	S.ReskinDropDown(ScenarioQueueFrameTypeDropDown)
	S.ReskinScroll(ScenarioQueueFrameRandomScrollFrameScrollBar)
	S.ReskinScroll(ScenarioQueueFrameSpecificScrollFrameScrollBar)
end)