local E, L, V, P, G = unpack(ElvUI) --Import: Engine, Locales, ProfileDB, local

local QT = E:NewModule("Quest-SunUI", "AceEvent-3.0", "AceHook-3.0", "AceConsole-3.0")

function QT:Initialize()
	self.db = E.db.quest_sunui
	self:initAutoAccept()
end

E:RegisterModule(QT:GetName())