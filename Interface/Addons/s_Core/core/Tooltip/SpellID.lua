local S, C, L, DB = unpack(select(2, ...))

hooksecurefunc(GameTooltip, "SetUnitBuff", function(self,...)
	local id = select(11,UnitBuff(...))
	if id then
		self:AddDoubleLine(L["法术ID"],format("|cff70C0F5%s|r",id))
		self:Show()
	end
end)

hooksecurefunc(GameTooltip, "SetUnitDebuff", function(self,...)
	local id = select(11,UnitDebuff(...))
	if id then
		self:AddDoubleLine(L["法术ID"],format("|cff70C0F5%s|r",id))
		self:Show()
	end
end)

hooksecurefunc(GameTooltip, "SetUnitAura", function(self,...)
	local id = select(11,UnitAura(...))
	if id then
		self:AddDoubleLine(L["法术ID"],format("|cff70C0F5%s|r",id))
		self:Show()
	end
end)

hooksecurefunc("SetItemRef", function(link, text, button, chatFrame)
	if string.find(link,"^spell:") then
		local id = string.sub(link,7)
		ItemRefTooltip:AddDoubleLine(L["法术ID"],format("|cff70C0F5%s|r",id))
		ItemRefTooltip:Show()
	end
end)

GameTooltip:HookScript("OnTooltipSetSpell", function(self)
	local id = select(3,self:GetSpell())
	if id then
		self:AddDoubleLine(L["法术ID"],format("|cff70C0F5%s|r",id))
		self:Show()
	end
end)