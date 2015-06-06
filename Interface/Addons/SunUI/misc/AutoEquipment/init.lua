local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local

local A = S:NewModule("AutoEquipment", "AceEvent-3.0", "AceHook-3.0", "AceConsole-3.0")
A.equipments = {}
A.modName = L["切换天赋"]
A.order = 20
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
					order = 3,
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
		group3 = {
			type = "group", order = 3, guiInline = true,
			name = "",
			args = {
				bindLayout = {
					type = "toggle",
					name = L["绑定布局"],
					order = 1,
					disabled = function(info) return not self.db.Enable end,
					get = function()
						return self.db.bindLayout
					end,
					set = function(info, value)
						self.db.bindLayout = value
						self:UpdataSet()
					end,
				}
			}
		},
		group4 = {
			type = "group", order = 4, guiInline = true,
			name = "",
			disabled = function(info) return not self.db.bindLayout end,
			args = {
				FirstLayout = {
					type = "select",
					name = L["选择主天赋布局"],
					order = 1,
					get = function()
						return self.db.FirstLayout
					end,
					set = function(info, value)
						self.db.FirstLayout = value
					end,
					values = {
						[1] = 1,
						[2] = 2,
						[3] = 3,
						[4] = 4,
						[5] = 5,
						[6] = 6,
						[7] = 7,
						[8] = 8,
						[9] = 9,
						[10] = 10,
					},
				},
				SecondLayout = {
					type = "select",
					name = L["选择副天赋布局"],
					order = 2,
					get = function()
						return self.db.SecondLayout
					end,
					set = function(info, value)
						self.db.SecondLayout = value
					end,
					values = {
						[1] = 1,
						[2] = 2,
						[3] = 3,
						[4] = 4,
						[5] = 5,
						[6] = 6,
						[7] = 7,
						[8] = 8,
						[9] = 9,
						[10] = 10,
					},
				},
			}
		}
	}
	return options
end

function A:Initialize()
	self:init()
end

S:RegisterModule(A:GetName())