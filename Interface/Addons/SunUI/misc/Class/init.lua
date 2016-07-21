local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local

local A = S:NewModule("ClassAT", "AceEvent-3.0", "AceHook-3.0", "AceConsole-3.0")
A.equipments = {}
A.modName = L["职业助手"]
A.order = 16
function A:GetOptions()
	local options = {
		group1 = {
			type = "group", order = 1, guiInline = true,
			name = "",
			args = {
				Enable = {
					type = "toggle",
					name = L["斩杀提示"],
					order = 1,
					set = function(info, value) 
						self.db.Enable = value 
						local CT = S:GetModule("ClassTools")
						CT:UpdateSet()
					end,
				},
				
				Icon = {
					type = "toggle", disabled = function(info) return not self.db.Enable end,
					name = L["启用图标模式"],
					order = 2,
					set = function(info, value)
						self.db.Icon = value
						local CT = S:GetModule("ClassTools")
						CT:UpdateSet()
					end,
				
				},
				
				Size = {
					type = "range", order = 3, disabled = function(info) return not self.db.Enable or not self.db.Icon end,
					name = L["图标大小"],
					min = 20, max = 100, step = 1,
					set = function(info, value) 
						self.db.Size = value 
						local CT = S:GetModule("ClassTools")
						CT:UpdateSet()
					end,
				},
			}
		},
	}
	return options
end


A.ClassTools = setmetatable ({
		["PRIEST"] = {
		[0] = {},
		[1] = {},
		[2] = {},
		[3] = {
			["spellid"] = 32379,	--暗言术:灭
			["per"] = 0.2,
			["level"] = 47,
		},
	},
	["HUNTER"] = {
		[0] = {},
		[1] = {},
		[2] = {},
		[3] = {},
	},
	["MAGE"] = {
		[0] = {},
		[1] = {},
		[2] = {},
		[3] = {},
	},
	["WARLOCK"] = {
		[0] = {},
		[1] = {},
		[2] = {},
		[3] = {},
	},
	["PALADIN"] = {
		[0] = {},
		[1] = {},
		[2] = {},
		[3] = {},
	},
	["ROGUE"] = {
		[0] = {},
		[1] = {},
		[2] = {},
		[3] = {},
	},
	["DRUID"] = {
		[0] = {},
		[1] = {},
		[2] = {},
		[3] = {},
		[4] = {},
	},
	["SHAMAN"] = {
		[0] = {},
		[1] = {},
		[2] = {},
		[3] = {},
	},
	["WARRIOR"] = {
		[0] = {},
		[1] = {
			["spellid"] = 163201,	--斩杀
			["per"] = 0.2,
			["level"] = 7,
		},
		[2] = {
			["spellid"] = 5308,		--斩杀
			["per"] = 0.2,
			["level"] = 7,
		},
		[3] = {
		},
	},
	["DEATHKNIGHT"] = {
		[0] = {},
		[1] = {},
		[2] = {},
		[3] = {},
	},
	["MONK"] = {
		[0] = {},
		[1] = {},
		[2] = {},
		[3] = {},
	},
},{__index=function() return -1 end})


function A:Initialize()
	local CT = S:GetModule("ClassTools")
	CT:Init()
	
	local PT = S:GetModule("PetTime")
	PT:Init()
end

function A:Info()
	return "\n\n 斩杀提示改为 动作条技能闪光 当达到触发血量后动作条上相应按钮会出现闪光 图标模式可选"

end

S:RegisterModule(A:GetName())
