local E, L, V, P, G = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local mod = E:NewModule("Chat-SunUI", "AceEvent-3.0", "AceHook-3.0", "AceConsole-3.0", "AceTimer-3.0")

function mod:Initialize()
	self.db = E.db.Chat_SunUI
	self:UpdateChatbar()
	self:initTabChannel()
	self:InitCollectorButton()
end
E:RegisterModule(mod:GetName())