local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local

local A = S:NewModule("ClassAT", "AceEvent-3.0", "AceHook-3.0", "AceConsole-3.0")
A.equipments = {}
A.modName = L["职业助手"]

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
				Size = {
					type = "range", order = 2, disabled = function(info) return not self.db.Enable end,
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
		group2 = {
			type = "group", order = 2, guiInline = true,
			name = "",
			args = {
				EnableIgniteWatch = {
					type = "toggle",
					name = L["燃火监视"],
					order = 1,
					set = function(info, value) 
						self.db.EnableIgniteWatch = value 
						local IW = S:GetModule("IgniteWatch")
						IW:UpdateSet()
					end,
				},
				IgniteWatchSize = {
					type = "range", order = 2, disabled = function(info) return not self.db.EnableIgniteWatch end,
					name = L["图标大小"],
					min = 20, max = 100, step = 1,
					set = function(info, value) 
						self.db.IgniteWatchSize = value 
						local IW = S:GetModule("IgniteWatch")
						IW:UpdateSet()
					end,
				},
			}
		},
		group3 = {
			type = "group", order = 3, guiInline = true,
			name = "",
			args = {
				EnableSpiritShellWatch = {
					type = "toggle",
					name = L["精神护罩监视"],
					order = 1,
					set = function(info, value) 
						self.db.EnableSpiritShellWatch = value 
						local SSW = S:GetModule("SpiritShell_Watch")
						SSW:UpdateSet()
					end,
				},
				SpiritShellWatchSize = {
					type = "range", order = 2, disabled = function(info) return not self.db.EnableSpiritShellWatch end,
					name = L["图标大小"],
					min = 20, max = 100, step = 1,
					set = function(info, value) 
						self.db.SpiritShellWatchSize = value 
						local SSW = S:GetModule("SpiritShell_Watch")
						SSW:UpdateSet()
					end,
				},
			}
		},		
	}
	return options
end

function A:Info()
	return L["职业助手"]
end
function A:Initialize()
	local CT = S:GetModule("ClassTools")
	CT:Init()
	if S.myclass == "MAGE" then 
		local IW = S:GetModule("IgniteWatch")
		IW:Init()
	end
	if S.myclass == "PRIEST" then 
		local SW = S:GetModule("SpiritShell_Watch")
		SW:Init() 
	end
	local PT = S:GetModule("PetTime")
	PT:Init()
end

S:RegisterModule(A:GetName())