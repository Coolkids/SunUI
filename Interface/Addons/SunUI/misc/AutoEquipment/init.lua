local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local

local A = S:NewModule("AutoEquipment", "AceEvent-3.0", "AceHook-3.0", "AceConsole-3.0")
A.equipments = {}
A.modName = L["自动换装"]

function A:GetOptions()
	local options = {
		group1 = {
			type = "group", order = 1, guiInline = true,
			name = "",
			args = {
				Enable = {
					type = "toggle",
					name = L["自动换装"],
					order = 1,
					get = function()
						return self.db.Enable
					end,
					set = function(info, value)
						self.db.Enable = value
						self:UpdataSet()
					end,
				},
			}
		},
		group2 = {
			type = "group", order = 2, guiInline = true, disabled = function(info) return not self.db.Enable end,
			name = "",
			args = {
				FirstName = {
					type = "select",
					name = L["选择主天赋装备"],
					order = 1,
					get = function()
						return self.db.FirstName
					end,
					set = function(info, value)
						self.db.FirstName = value
						self:Equipment()
					end,
					values = self.equipments,	
				},
				SecondName = {
					type = "select",
					name = L["选择副天赋装备"],
					order = 2,
					get = function()
						return self.db.SecondName
					end,
					set = function(info, value)
						self.db.SecondName = value
						self:Equipment()
					end,
					values = self.equipments,	
				},
			}
		},
	}
	return options
end

function A:Info()
	return L["自动换装"]
end
function A:Initialize()
	self:init()
end

S:RegisterModule(A:GetName())