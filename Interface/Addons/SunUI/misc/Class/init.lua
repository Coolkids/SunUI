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
			}
		},
	}
	return options
end

function A:Initialize()
	local CT = S:GetModule("ClassTools")
	CT:Init()
	
	local PT = S:GetModule("PetTime")
	PT:Init()
end

function A:Info()
	return "\n\n 斩杀提示改为 动作条技能闪光 当达到触发血量后动作条上相应按钮会出现闪光 "

end

S:RegisterModule(A:GetName())