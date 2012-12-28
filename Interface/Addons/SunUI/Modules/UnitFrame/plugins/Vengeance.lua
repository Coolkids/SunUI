local S, L, DB, _, C = unpack(select(2, ...))
local _, ns = ...
local oUF = ns.oUF or oUF

local vengeance = GetSpellInfo(132365)
local function valueChanged(self, event, unit)
	if unit ~= "player" then return end
	local bar = self.Vengeance
	--print(DB.Role)
	if DB.Role ~= "Tank" then
		bar:Hide()
		return
	end

	local name = UnitAura("player", vengeance, nil, "PLAYER|HELPFUL")

	if name then
		local value = select(15, UnitAura("player", vengeance, nil, "PLAYER|HELPFUL")) or -1
		if value > 0 then
			if value > bar.max then bar.max = value end
			-- if value > bar.max then value = bar.max end
			if value == bar.value then return end

			bar:SetMinMaxValues(0, bar.max)
			bar:SetValue(value)
			bar.value = value
			bar:Show()

			if bar.Text then
				bar.Text:SetText(value)
			end
		end
	elseif bar.showInfight and InCombatLockdown() then
		bar:Show()
		bar:SetMinMaxValues(0, 1)
		bar:SetValue(0)
		bar.value = 0
	else
		bar:Hide()
		bar.value = 0
	end
end

local function maxChanged(self, event, unit)
	if unit ~= "player" then return end
	local bar = self.Vengeance

	if DB.Role ~= "Tank" then
		bar:Hide()
		return
	end

	local health = UnitHealthMax("player")
	local stat, _, posBuff = UnitStat("player", 3)

	if not health or not stat then return end

	local basehealth = health - (posBuff*UnitHPPerStamina("player"))
	bar.max = basehealth/10 + stat
	bar:SetMinMaxValues(0, bar.max)
	valueChanged(self, event, unit)
end

local function Enable(self, unit)
	local bar = self.Vengeance

	if bar and unit == "player" then
		bar.max = 0
		bar.value = 0
		maxChanged(self, nil, unit)
		self:RegisterEvent("UNIT_AURA", valueChanged)
		self:RegisterEvent("PLAYER_ENTERING_WORLD", maxChanged)
		self:RegisterEvent("UNIT_MAXHEALTH", maxChanged)
		self:RegisterEvent("UNIT_LEVEL", maxChanged)

		bar:Hide()
		bar:SetScript("OnEnter", function(self)
			GameTooltip:ClearLines()
			GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 5)
			if self.value > 0 then
				GameTooltip:SetUnitBuff("player", vengeance)
			end
			GameTooltip:Show()
		end)
		bar:SetScript("OnLeave", function(self)
			GameTooltip:Hide()
		end)
		return true
	end
end

local function Disable(self)
	local bar = self.Vengeance

	if bar then
		self:UnregisterEvent("UNIT_AURA", valueChanged)
		self:UnregisterEvent("PLAYER_ENTERING_WORLD", maxChanged)
		self:UnregisterEvent("UNIT_MAXHEALTH", maxChanged)
		self:UnregisterEvent("UNIT_LEVEL", maxChanged)
	end
end

oUF:AddElement("Vengeance", nil, Enable, Disable)