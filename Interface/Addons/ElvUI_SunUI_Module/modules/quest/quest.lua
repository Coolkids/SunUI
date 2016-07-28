local E, L, V, P, G = unpack(ElvUI) --Import: Engine, Locales, ProfileDB, local

local QT = E:NewModule("Quest-SunUI", "AceEvent-3.0", "AceHook-3.0", "AceConsole-3.0")

function QT:Initialize()
	self.db = E.db.quest_sunui
	self:initAutoAccept()
end

function QT:GetOptions()
	local options = {
		type = "group",
		name = "任务增强",
		order = -97,
		get = function(info) return E.db.quest_sunui[ info[#info] ] end,
		set = function(info, value) E.db.quest_sunui[ info[#info] ] = value end,
		args = {
			group2 = {
				type = "group", order = 1, guiInline = true,
				name = "",
				args = {
					autoquest = {
						type = "toggle",
						name = "自动交接任务",
						order = 1,
					},
				}
			},
		}
	}
	return options
end

E:RegisterModule(QT:GetName())