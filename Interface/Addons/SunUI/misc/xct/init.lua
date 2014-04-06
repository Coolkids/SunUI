local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local XT = S:NewModule("xCT", "AceEvent-3.0", "AceHook-3.0", "AceConsole-3.0")

XT.modName = "xCT"

function XT:Info()
	return "xCT"
end
function XT:Initialize()
	self:init()
end

S:RegisterModule(XT:GetName())