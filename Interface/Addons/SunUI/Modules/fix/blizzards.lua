local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local B = S:NewModule("Blizzards", "AceEvent-3.0", "AceHook-3.0", "AceConsole-3.0")

function B:Initialize()
	self:FixDeathPopup()
end

S:RegisterModule(B:GetName())
