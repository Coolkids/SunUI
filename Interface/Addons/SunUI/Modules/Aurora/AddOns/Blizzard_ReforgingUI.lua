local S, L, DB, _, C = unpack(select(2, ...))
local r, g, b = DB.MyClassColor.r, DB.MyClassColor.g, DB.MyClassColor.b
local AuroraConfig = DB.AuroraConfig

DB.AuroraModules["Blizzard_ReforgingUI"] = function()
	for i = 15, 25 do
		select(i, ReforgingFrame:GetRegions()):Hide()
	end
	ReforgingFrame.Lines:SetAlpha(0)
	ReforgingFrame.ReceiptBG:SetAlpha(0)
	ReforgingFrame.MissingFadeOut:SetAlpha(0)
	ReforgingFrame.ButtonFrame:GetRegions():Hide()
	ReforgingFrame.ButtonFrame.ButtonBorder:Hide()
	ReforgingFrame.ButtonFrame.ButtonBottomBorder:Hide()
	ReforgingFrame.ButtonFrame.MoneyLeft:Hide()
	ReforgingFrame.ButtonFrame.MoneyRight:Hide()
	ReforgingFrame.ButtonFrame.MoneyMiddle:Hide()
	ReforgingFrame.ItemButton.Frame:Hide()
	ReforgingFrame.ItemButton.Grabber:Hide()
	ReforgingFrame.ItemButton.TextFrame:Hide()
	ReforgingFrame.ItemButton.TextGrabber:Hide()

	S.CreateBD(ReforgingFrame.ItemButton, .25)
	ReforgingFrame.ItemButton:SetHighlightTexture("")
	ReforgingFrame.ItemButton:SetPushedTexture("")
	ReforgingFrame.ItemButton.IconTexture:Point("TOPLEFT", 1, -1)
	ReforgingFrame.ItemButton.IconTexture:Point("BOTTOMRIGHT", -1, 1)

	ReforgingFrame.ItemButton:HookScript("OnEnter", function(self)
		self:SetBackdropBorderColor(1, .56, .85)
	end)
	ReforgingFrame.ItemButton:HookScript("OnLeave", function(self)
		self:SetBackdropBorderColor(0, 0, 0)
	end)

	local bg = CreateFrame("Frame", nil, ReforgingFrame.ItemButton)
	bg:SetSize(341, 50)
	bg:Point("LEFT", ReforgingFrame.ItemButton, "RIGHT", -1, 0)
	bg:SetFrameLevel(ReforgingFrame.ItemButton:GetFrameLevel()-1)
	S.CreateBD(bg, .25)

	ReforgingFrame.RestoreMessage:SetTextColor(.9, .9, .9)

	hooksecurefunc("ReforgingFrame_Update", function()
		local _, icon = GetReforgeItemInfo()
		if not icon then
			ReforgingFrame.ItemButton.IconTexture:SetTexture("")
		else
			ReforgingFrame.ItemButton.IconTexture:SetTexCoord(.08, .92, .08, .92)
		end
	end)

	ReforgingFrameRestoreButton:Point("LEFT", ReforgingFrameMoneyFrame, "RIGHT", 0, 1)

	S.ReskinPortraitFrame(ReforgingFrame)
	S.Reskin(ReforgingFrameRestoreButton)
	S.Reskin(ReforgingFrameReforgeButton)
end