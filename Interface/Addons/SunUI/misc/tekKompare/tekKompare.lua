
-- Force the CVar to the setting we want
SetCVar("alwaysCompareItems", 1)


local orig = ItemRefTooltip:GetScript("OnTooltipSetItem")
ItemRefTooltip:SetScript("OnTooltipSetItem", function(self, ...)
	GameTooltip_ShowCompareItem(self, 1)
	self.comparing = true
	if orig then return orig(self, ...) end
end)


-- Don't let ItemRefTooltip fuck with the compare tips
ItemRefTooltip:SetScript("OnEnter", nil)
ItemRefTooltip:SetScript("OnLeave", nil)
ItemRefTooltip:SetScript("OnDragStart", function(self)
	ItemRefShoppingTooltip1:Hide()
	ItemRefShoppingTooltip2:Hide()
	if ItemRefShoppingTooltip3 then ItemRefShoppingTooltip3:Hide() end
	self:StartMoving()
end)
ItemRefTooltip:SetScript("OnDragStop", function(self)
	self:StopMovingOrSizing()
	ValidateFramePosition(self)
	GameTooltip_ShowCompareItem(self, 1)
end)
