﻿----------------------------------------------------------------------------------------
--	Auto popup for currency cap(EnoughPoints by gi2k15)
----------------------------------------------------------------------------------------
local E, L, V, P, G = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB

local CC = S:GetModule("MiniTools")
StaticPopupDialogs.EnoughPoints = {
	button1 = OKAY,
	hideOnEscape = true,
	whileDead = false,
	timeout = 0,
	preferredIndex = 5,
}

local badge = {
	["justice"] = JUSTICE_CURRENCY,
	["valor"] = VALOR_CURRENCY,
	["honor"] = HONOR_CURRENCY,
}

local hasShown = false
local isValor = false
local logging = true

local defaults = {
	["justice"] = {
		max = 4000,
		queueing = true,
		logging = true,
	},
	["valor"] = {
		max = 3000,
		queueing = true,
		logging = true,
	},
	["honor"] = {
		max = 4000,
		logging = true,
	},
}


function CC:UpdateCCSet()
	if self.db.currencycap then
		self:RegisterEvent("PLAYER_LOGIN")
		self:RegisterEvent("PLAYER_ENTERING_WORLD")
		self:RegisterEvent("LFG_UPDATE")
		self:RegisterEvent("LFG_PROPOSAL_SHOW")
	else
		self:UnregisterEvent("PLAYER_LOGIN")
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		self:UnregisterEvent("LFG_UPDATE")
		self:UnregisterEvent("LFG_PROPOSAL_SHOW")
	end
end

function CC:CheckBadges(kind)
	if isValor then
		isValor = false
		StaticPopupDialogs.EnoughPoints.OnHide = nil
	end
	local name, currentAmount = GetCurrencyInfo(badge[kind])
	if (currentAmount >= (defaults[kind].max - 200)) then
		StaticPopupDialogs.EnoughPoints.text = "|r |cff00aa00["..name.."]|r".."|cffffff00"..tostring(currentAmount).."/"..tostring(defaults[kind].max)
		StaticPopup_Show("EnoughPoints")
	end
end

function CC:PLAYER_ENTERING_WORLD()
	local inInstance, instanceType = IsInInstance()
	local difficulty = select(3, GetInstanceInfo())
	if inInstance and (instanceType == "raid" or difficulty == 2) then
		self:CheckBadges("valor")
	elseif inInstance and instanceType == "party" then
		self:CheckBadges("justice")
	end
end

function CC:PLAYER_LOGIN()
	if defaults.honor.logging then
		self:CheckBadges("honor")
	end
	if defaults.justice.logging then
		StaticPopupDialogs.EnoughPoints.OnHide = function() self:CheckBadges("valor") end
		self:CheckBadges("justice")
		isValor = true
		return
	end
	if defaults.valor.logging then
		self:CheckBadges("valor")
	end
end

function CC:LFG_UPDATE()
	if hasShown == false and logging == false then
		if defaults.justice.queueing then
			StaticPopupDialogs.EnoughPoints.OnHide = function() self:CheckBadges("valor") end
			self:CheckBadges("justice")
			isValor = true
			hasShown = true
			return
		end
		if defaults.valor.queueing then
			self:CheckBadges("valor")
			hasShown = true
		end
	elseif logging and hasShown == false then
		logging = false
	end
end

function CC:LFG_PROPOSAL_SHOW()
	hasShown = false
end