local S, C, L, DB, _ = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("Warnning")

local warn = CreateFrame("Frame", nil, UIParent)
warn:SetSize(128 ,64)
local texture = warn:CreateTexture(nil, "BACKGROUND")
texture:SetAllPoints()
texture:SetTexture("Interface\\Addons\\SunUI\\Media\\Warning_hp25")
warn:Hide()
warn:RegisterEvent("PLAYER_DEAD")
warn:RegisterEvent("UNIT_HEALTH")
warn:SetScript("OnEvent", function(self, event, unit)
	if unit ~= "player" then return end
	if ( UnitHealth("player")/UnitHealthMax("player") < 0.25 ) and not UnitIsDead("player") then
		self:Show()
	else
		self:Hide()
	end
end)

function Module:OnEnable()
	if C["WarnDB"]["Open"] then
		warn:SetSize(C["WarnDB"]["Width"] ,C["WarnDB"]["Height"])
		MoveHandle.Warn = S.MakeMoveHandle(warn, "Warning", "Warn")
	else
		warn:UnregisterAllEvents()
		warn:Hide()
		warn = nil
		texture = nil
	end
end