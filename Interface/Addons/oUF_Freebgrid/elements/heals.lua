local _, ns = ...
local oUF =  ns.oUF or oUF
assert(oUF, "oUF_Freebgrid was unable to locate oUF install.")

local numberize = ns.numberize
local colorCache = ns.colorCache

oUF.Tags.Methods['freebgrid:altpower'] = function(u)
	local cur = UnitPower(u, ALTERNATE_POWER_INDEX)
	if cur > 0 then
		local max = UnitPowerMax(u, ALTERNATE_POWER_INDEX)
		local per = floor(cur/max*100)

		local tPath, r, g, b = UnitAlternatePowerTextureInfo(u, 2)

		if not r then
			r, g, b = 1, 1, 1
		end

		return ns:hex(r,g,b)..format("%d", per).."|r"
	end
end
oUF.Tags.Events['freebgrid:altpower'] = "UNIT_POWER UNIT_MAXPOWER"

oUF.Tags.Methods['freebgrid:def'] = function(u)
	if UnitIsAFK(u) then
		return CHAT_FLAG_AFK
	elseif UnitIsDead(u) then
		return "|cffCFCFCFDead|r"
	elseif UnitIsGhost(u) then
		return "|cffCFCFCFGhost|r"
	elseif not UnitIsConnected(u) then
		return "|cffCFCFCFD/C|r"
	end

	if ns.db.altpower then
		local altpp = oUF.Tags.Methods['freebgrid:altpower'](u)
		if altpp then
			return altpp
		end
	end

	if ns.db.perc then
		local perc = oUF.Tags.Methods['perhp'](u)
		if perc < 90 then
			local _, class = UnitClass(u)
			local color = colorCache[class]

			if color then 
				return color..perc.."%|r" 
			else
				return perc.."%|r" 
			end
		end
	elseif ns.db.deficit or ns.db.actual then
		local cur = UnitHealth(u)
		local max = UnitHealthMax(u)
		local per = cur/max

		if per < 0.9 then
			local _, class = UnitClass(u)
			local color = colorCache[class]
			if color then
				return color..(ns.db.deficit and "-"..numberize(max-cur) or numberize(cur)).."|r"
			end
		end
	end 
end
oUF.Tags.Events['freebgrid:def'] = 'UNIT_MAXHEALTH UNIT_HEALTH UNIT_HEALTH_FREQUENT UNIT_CONNECTION PLAYER_FLAGS_CHANGED '..oUF.Tags.Events['freebgrid:altpower']

oUF.Tags.Methods['freebgrid:heals'] = function(u)
	local incheal = UnitGetIncomingHeals(u) or 0
	if incheal > 0 then
		return "|cff00FF00"..numberize(incheal).."|r"
	else
		local def = oUF.Tags.Methods['freebgrid:def'](u)
		return def
	end
end
oUF.Tags.Events['freebgrid:heals'] = 'UNIT_HEAL_PREDICTION '..oUF.Tags.Events['freebgrid:def']

oUF.Tags.Methods['freebgrid:othersheals'] = function(u)
	local incheal = UnitGetIncomingHeals(u) or 0
	local player = UnitGetIncomingHeals(u, "player") or 0

	incheal = incheal - player

	if incheal > 0 then
		return "|cff00FF00"..numberize(incheal).."|r"
	else
		local def = oUF.Tags.Methods['freebgrid:def'](u)
		return def
	end
end
oUF.Tags.Events['freebgrid:othersheals'] = oUF.Tags.Events['freebgrid:heals']

local Update = function(self, event, unit)
	if self.unit ~= unit then return end

	local overflow = ns.db.healoverflow and 1.20 or 1
	local myIncomingHeal = UnitGetIncomingHeals(unit, "player") or 0
	local allIncomingHeal = UnitGetIncomingHeals(unit) or 0

	local health = self.Health:GetValue()
	local _, maxHealth = self.Health:GetMinMaxValues()

	if ( health + allIncomingHeal > maxHealth * overflow ) then
		allIncomingHeal = maxHealth * overflow - health
	end

	if ( allIncomingHeal < myIncomingHeal ) then
		myIncomingHeal = allIncomingHeal
		allIncomingHeal = 0
	else
		allIncomingHeal = allIncomingHeal - myIncomingHeal
	end

	self.myHealPredictionBar:SetMinMaxValues(0, maxHealth) 
	if ns.db.healothersonly then
		self.myHealPredictionBar:SetValue(0)
	else
		self.myHealPredictionBar:SetValue(myIncomingHeal)
	end
	self.myHealPredictionBar:Show()

	self.otherHealPredictionBar:SetMinMaxValues(0, maxHealth)
	self.otherHealPredictionBar:SetValue(allIncomingHeal)
	self.otherHealPredictionBar:Show()
end

local Enable = function(self)
	if self.freebHeals then
		self.myHealPredictionBar = CreateFrame('StatusBar', nil, self.Health)
		if ns.db.orientation == "VERTICAL" then
			if ns.db.hpreversed then
				self.myHealPredictionBar:SetPoint("TOPLEFT", self.Health:GetStatusBarTexture(), "BOTTOMLEFT", 0, 0)
				self.myHealPredictionBar:SetPoint("TOPRIGHT", self.Health:GetStatusBarTexture(), "BOTTOMRIGHT", 0, 0)
				self.myHealPredictionBar:SetReverseFill(true)
			else
				self.myHealPredictionBar:SetPoint("BOTTOMLEFT", self.Health:GetStatusBarTexture(), "TOPLEFT", 0, 0)
				self.myHealPredictionBar:SetPoint("BOTTOMRIGHT", self.Health:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
			end
			self.myHealPredictionBar:SetSize(0, ns.db.height)
			self.myHealPredictionBar:SetOrientation"VERTICAL"
		else
			if ns.db.hpreversed then
				self.myHealPredictionBar:SetPoint("TOPRIGHT", self.Health:GetStatusBarTexture(), "TOPLEFT", 0, 0)
				self.myHealPredictionBar:SetPoint("BOTTOMRIGHT", self.Health:GetStatusBarTexture(), "BOTTOMLEFT", 0, 0)
				self.myHealPredictionBar:SetReverseFill(true)
			else
				self.myHealPredictionBar:SetPoint("TOPLEFT", self.Health:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
				self.myHealPredictionBar:SetPoint("BOTTOMLEFT", self.Health:GetStatusBarTexture(), "BOTTOMRIGHT", 0, 0)
			end
			self.myHealPredictionBar:SetSize(ns.db.width, 0)
		end
		self.myHealPredictionBar:SetStatusBarTexture("Interface\\BUTTONS\\WHITE8X8", "BORDER")
		self.myHealPredictionBar:GetStatusBarTexture():SetTexture(ns.db.myhealcolor.r, ns.db.myhealcolor.g, ns.db.myhealcolor.b, ns.db.myhealcolor.a)
		self.myHealPredictionBar:Hide()

		self.otherHealPredictionBar = CreateFrame('StatusBar', nil, self.Health)
		if ns.db.orientation == "VERTICAL" then
			if ns.db.hpreversed then
				self.otherHealPredictionBar:SetPoint("TOPLEFT", self.myHealPredictionBar:GetStatusBarTexture(), "BOTTOMLEFT", 0, 0)
				self.otherHealPredictionBar:SetPoint("TOPRIGHT", self.myHealPredictionBar:GetStatusBarTexture(), "BOTTOMRIGHT", 0, 0)
				self.otherHealPRedictionBar:SetReverseFill(true)
			else
				self.otherHealPredictionBar:SetPoint("BOTTOMLEFT", self.myHealPredictionBar:GetStatusBarTexture(), "TOPLEFT", 0, 0)
				self.otherHealPredictionBar:SetPoint("BOTTOMRIGHT", self.myHealPredictionBar:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
			end
			self.otherHealPredictionBar:SetSize(0, ns.db.height)
			self.otherHealPredictionBar:SetOrientation"VERTICAL"
		else
			if ns.db.hpreversed then
				self.otherHealPredictionBar:SetPoint("TOPRIGHT", self.myHealPredictionBar:GetStatusBarTexture(), "TOPLEFT", 0, 0)
				self.otherHealPredictionBar:SetPoint("BOTTOMRIGHT", self.myHealPredictionBar:GetStatusBarTexture(), "BOTTOMLEFT", 0, 0)
				self.otherHealPredictionBar:SetReverseFill(true)
			else
				self.otherHealPredictionBar:SetPoint("TOPLEFT", self.myHealPredictionBar:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
				self.otherHealPredictionBar:SetPoint("BOTTOMLEFT", self.myHealPredictionBar:GetStatusBarTexture(), "BOTTOMRIGHT", 0, 0)
			end
			self.otherHealPredictionBar:SetSize(ns.db.width, 0)
		end
		self.otherHealPredictionBar:SetStatusBarTexture("Interface\\BUTTONS\\WHITE8X8", "BORDER")
		self.otherHealPredictionBar:GetStatusBarTexture():SetTexture(ns.db.otherhealcolor.r, ns.db.otherhealcolor.g, ns.db.otherhealcolor.b, ns.db.otherhealcolor.a)
		self.otherHealPredictionBar:Hide() 

		if ns.db.healbar then
			self:RegisterEvent('UNIT_HEAL_PREDICTION', Update)
			self:RegisterEvent('UNIT_MAXHEALTH', Update)
			self:RegisterEvent('UNIT_HEALTH', Update)
		end

		local healtext = self.Health:CreateFontString(nil, "OVERLAY")
		healtext:SetPoint("BOTTOM")
		healtext:SetShadowOffset(1.25, -1.25)
		healtext:SetFont(ns.db.fontPath, ns.db.fontsizeEdge, ns.db.outline)
		healtext:SetWidth(ns.db.width)
		self.Healtext = healtext

		if ns.db.healtext then
			if ns.db.healothersonly then
				self:Tag(healtext, "[freebgrid:othersheals]")
			else
				self:Tag(healtext, "[freebgrid:heals]")
			end
		else
			self:Tag(healtext, "[freebgrid:def]")
		end

		return true
	end
end

local Disable = function(self)
	if self.freebHeals then
		if not ns.db.healbar then
			self:UnregisterEvent('UNIT_HEAL_PREDICTION', Update)
			self:UnregisterEvent('UNIT_MAXHEALTH', Update)
			self:UnregisterEvent('UNIT_HEALTH', Update)
		end
	end
end

oUF:AddElement('freebHeals', Update, Enable, Disable)
