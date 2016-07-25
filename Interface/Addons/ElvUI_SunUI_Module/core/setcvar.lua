local E, L, V, P, G = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB

local mod = E:NewModule("SetCVarMod", "AceEvent-3.0")

function mod:PLAYER_ENTERING_WORLD()
	--E:Print(GetCVar("floatingCombatTextCombatDamage"))
	if GetCVar("floatingCombatTextCombatDamage") ~= 1 then
		SetCVar("floatingCombatTextCombatHealing", 1)
		SetCVar("floatingCombatTextCombatDamage", 1)
	end
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end

function mod:Initialize()
	mod:RegisterEvent("PLAYER_ENTERING_WORLD")
end

E:RegisterModule(mod:GetName())
