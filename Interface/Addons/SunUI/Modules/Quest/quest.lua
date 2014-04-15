local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local

local QT = S:NewModule("Quest", "AceEvent-3.0", "AceHook-3.0", "AceConsole-3.0")
QT.modName = L["任务增强"]
QT.order = 12
function QT:GetOptions()
	local options = {
		AutoQuest = {
			type = "toggle",
			name = L["自动交接任务"],
			desc = L["自动交接任务"],
			order = 17,
			set = function(info, value) self.db.AutoQuest = value
				self:UpdateAutoAccept()
			end,
		},
	}
	return options
end

function QT:Initialize()
	self:initAutoAccept()
end

S:RegisterModule(QT:GetName())