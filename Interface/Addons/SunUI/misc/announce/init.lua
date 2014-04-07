local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local

local A = S:NewModule("Announce", "AceEvent-3.0", "AceHook-3.0", "AceConsole-3.0")

A.modName = L["施法通告"]

function A:GetOptions()
	local options = {
		group1 = {
			type = "group", order = 1,
			name = "",guiInline = true,
			args = {
				Open = {
				type = "toggle",
				name = L["施法通告"],
				desc = L["只是通告自己施放的法术"],
				order = 1,
				get = function(info) return self.db.Open end,
				set = function(info, value) 
					self.db.Open = value
					self:UpdateSet() 
				end,
				},
			}
		},
		group2 = {
			type = "group", order = 2, guiInline = true, disabled = function(info) return not self.db.Open end,
			name = "",
			args = {
				Interrupt = {
					type = "toggle",
					name = L["启用打断通告"],
					order = 1,
				},
				Channel = {
					type = "toggle",
					name = L["启用治疗大招通告"],
					order = 2,
				},
				Mislead = {
					type = "toggle",
					name = L["启用误导通告"],
					order = 3,
				},
				BaoM = {
					type = "toggle",
					name = L["启用保命技能通告"],
					order = 4,
				},
				Give = {
					type = "toggle",
					name = L["启用给出大招通告"],
					desc = L["包含天使,痛苦压制,保护等等"],
					order = 5,
				},
				Resurrect = {
					type = "toggle",
					name = L["启用复活技能通告"],
					order = 6,
				},
				Heal = {
					type = "toggle",
					name = L["启用团队减伤通告"],
					order = 7,
				},
			}
		},
	}
	return options
end

function A:Initialize()
	self:UpdateSet()
end

S:RegisterModule(A:GetName())