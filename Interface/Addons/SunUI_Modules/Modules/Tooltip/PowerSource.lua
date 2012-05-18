local S, C, L, DB = unpack(SunUI)
local function addAuraSource(self, func, unit, index, filter)
	local srcUnit = select(8, func(unit, index, filter))
	if srcUnit then
		self:AddLine(" ")
		
		local src = GetUnitName(srcUnit, true)
		if srcUnit == "pet" or srcUnit == "vehicle" then
			src = format("%s (%s)", src, GetUnitName("player", true))
		else
			local partypet = srcUnit:match("^partypet(%d+)$")
			local raidpet = srcUnit:match("^raidpet(%d+)$")
			if partypet then
				src = format("%s (%s)", src, GetUnitName("party"..partypet, true))
			elseif raidpet then
				src = format("%s (%s)", src, GetUnitName("raid"..raidpet, true))
			end
		end
		
		self:AddLine(L["释放者"]..format("|cff70C0F5%s|r",src))
		self:Show()
	end
end


local funcs = {
	SetUnitAura = UnitAura,
	SetUnitBuff = UnitBuff,
	SetUnitDebuff = UnitDebuff,
}

for k, v in pairs(funcs) do
	hooksecurefunc(GameTooltip, k, function(self, unit, index, filter)
		addAuraSource(self, v, unit, index, filter)
	end)
end