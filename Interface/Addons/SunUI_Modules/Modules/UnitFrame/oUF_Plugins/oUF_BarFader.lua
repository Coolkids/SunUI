local S, C, L, DB = unpack(SunUI)

local _, ns = ...
local oUF = ns.oUF or oUF

local function pending(self, unit)
	local num, str = UnitPowerType(unit)
	if(self.Castbar and UnitCastingInfo(unit)) then return true end
	if(UnitAffectingCombat(unit)) then return true end
	if(unit == 'pet' and GetPetHappiness() and GetPetHappiness() < 3) then return true end
	if(UnitExists(unit..'target')) then	return true end
	if(UnitHealth(unit) < UnitHealthMax(unit)) then return true end
	if((str == 'RAGE' or str == 'RUNIC_POWER') and UnitPower(unit) > 0) then return true end
	if((str ~= 'RAGE' and str ~= 'RUNIC_POWER') and UnitMana(unit) < UnitManaMax(unit)) then return true end
end

local function update(self, event, unit)
	if(unit and unit ~= self.unit) then return end

	if(not pending(self, self.unit)) then
		UIFrameFadeOut(self, 1.5, self:GetAlpha(), self.BarFaderMinAlpha or 0.25)
	elseif not InCombatLockdown() then
		UIFrameFadeIn(self, 0.8, self:GetAlpha(), self.BarFaderMaxAlpha or 1)
	else
		self:SetAlpha(self.BarFaderMaxAlpha or 1)
	end
end

local function enable(self, unit)
	if(unit and self.BarFade) then
		update(self)

		self:RegisterEvent('UNIT_COMBAT', update)
		self:RegisterEvent('UNIT_HAPPINESS', update)
		self:RegisterEvent('UNIT_TARGET', update)
		self:RegisterEvent('UNIT_FOCUS', update)
		self:RegisterEvent('UNIT_HEALTH', update)
		self:RegisterEvent('UNIT_POWER', update)
		self:RegisterEvent('UNIT_ENERGY', update)
		self:RegisterEvent('UNIT_RAGE', update)
		self:RegisterEvent('UNIT_MANA', update)
		self:RegisterEvent('UNIT_RUNIC_POWER', update)
		self:HookScript("OnEnter", function(self)
			if not InCombatLockdown() then
				UIFrameFadeIn(self, 0.8, self:GetAlpha(), self.BarFaderMaxAlpha or 1)
--[[ 				UIFrameFadeIn(rABS_MultiBarBottomLeft, 0.8, rABS_MultiBarBottomLeft:GetAlpha(), self.BarFaderMaxAlpha or 1)
				
				UIFrameFadeIn(rABS_MultiBarBottomRight, 0.8, rABS_MultiBarBottomRight:GetAlpha(), self.BarFaderMaxAlpha or 1)
				UIFrameFadeIn(rABS_MultiBarLeft, 0.8, rABS_MultiBarLeft:GetAlpha(), self.BarFaderMaxAlpha or 1)
				UIFrameFadeIn(rABS_MultiBarRight, 0.8, rABS_MultiBarRight:GetAlpha(), self.BarFaderMaxAlpha or 1)
				UIFrameFadeIn(rABS_PetBar, 0.8, rABS_PetBar:GetAlpha(), self.BarFaderMaxAlpha or 1)
				UIFrameFadeIn(rABS_StanceBar, 0.8, rABS_StanceBar:GetAlpha(), self.BarFaderMaxAlpha or 1) ]]
			else
				self:SetAlpha(self.BarFaderMaxAlpha or 1)
			end
		end)
		self:HookScript("OnLeave", function(self)
			if(not pending(self, self.unit)) then
				UIFrameFadeOut(self, 1.5, self:GetAlpha(), self.BarFaderMinAlpha or 0.25)
--[[ 				UIFrameFadeOut(rABS_MultiBarBottomLeft, 1.5, rABS_MultiBarBottomLeft:GetAlpha(), self.BarFaderMinAlpha or 0)
				
				UIFrameFadeOut(rABS_MultiBarBottomRight, 1.5, rABS_MultiBarBottomRight:GetAlpha(), self.BarFaderMinAlpha or 0)
				UIFrameFadeIn(rABS_MultiBarLeft, 1.5, rABS_MultiBarLeft:GetAlpha(), self.BarFaderMaxAlpha or 0)
				UIFrameFadeIn(rABS_MultiBarRight, 1.5, rABS_MultiBarRight:GetAlpha(), self.BarFaderMaxAlpha or 0)
				UIFrameFadeOut(rABS_PetBar, 1.5, rABS_PetBar:GetAlpha(), self.BarFaderMinAlpha or 0)
				UIFrameFadeOut(rABS_StanceBar, 1.5, rABS_StanceBar:GetAlpha(), self.BarFaderMinAlpha or 0)
				if DB.MyClass == "SHAMAN" then
				UIFrameFadeOut(rABS_TotemBar, 1.5, rABS_TotemBar:GetAlpha(), self.BarFaderMinAlpha or 0) 
        end ]]
			end
		end)

		if(self.Castbar) then
			self:RegisterEvent('UNIT_SPELLCAST_START', update)
			self:RegisterEvent('UNIT_SPELLCAST_FAILED', update)
			self:RegisterEvent('UNIT_SPELLCAST_STOP', update)
			self:RegisterEvent('UNIT_SPELLCAST_INTERRUPTED', update)
			self:RegisterEvent('UNIT_SPELLCAST_DELAYED', update)
			self:RegisterEvent('UNIT_SPELLCAST_CHANNEL_START', update)
			self:RegisterEvent('UNIT_SPELLCAST_CHANNEL_UPDATE', update)
			self:RegisterEvent('UNIT_SPELLCAST_CHANNEL_INTERRUPTED', update)
			self:RegisterEvent('UNIT_SPELLCAST_CHANNEL_STOP', update)
		end

		return true
	end
end

local function disable(self)
	if(self.BarFade) then
		self:UnregisterEvent('UNIT_COMBAT', update)
		self:UnregisterEvent('UNIT_HAPPINESS', update)
		self:UnregisterEvent('UNIT_TARGET', update)
		self:UnregisterEvent('UNIT_FOCUS', update)
		self:UnregisterEvent('UNIT_HEALTH', update)
		self:UnregisterEvent('UNIT_POWER', update)
		self:UnregisterEvent('UNIT_ENERGY', update)
		self:UnregisterEvent('UNIT_RAGE', update)
		self:UnregisterEvent('UNIT_MANA', update)
		self:UnregisterEvent('UNIT_RUNIC_POWER', update)

		if(self.Castbar) then
			self:UnregisterEvent('UNIT_SPELLCAST_START', update)
			self:UnregisterEvent('UNIT_SPELLCAST_FAILED', update)
			self:UnregisterEvent('UNIT_SPELLCAST_STOP', update)
			self:UnregisterEvent('UNIT_SPELLCAST_INTERRUPTED', update)
			self:UnregisterEvent('UNIT_SPELLCAST_DELAYED', update)
			self:UnregisterEvent('UNIT_SPELLCAST_CHANNEL_START', update)
			self:UnregisterEvent('UNIT_SPELLCAST_CHANNEL_UPDATE', update)
			self:UnregisterEvent('UNIT_SPELLCAST_CHANNEL_INTERRUPTED', update)
			self:UnregisterEvent('UNIT_SPELLCAST_CHANNEL_STOP', update)
		end
	end
end

oUF:AddElement('BarFader', update, enable, disable)