local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local LM = S:NewModule("SunUI_LayoutManger", "AceEvent-3.0", "AceHook-3.0", "AceConsole-3.0")
LM.modName = L["布局管理器"]
LM.order = 25

function LM:GetOptions()
	local options = {
		desc = {
			order = 1,
			type = "description",
			name = L["在这里你可以对角色的页面布局配置文件进行设置."],
		},
		reloaddesc = {
			order = 2,
			type = "description",
			name = function(info) return L["当前布局为: \"|cffFF0000"]..S.db.layout.mainLayout..L["|r\"号布局.\n"] end,
		},
		group1 = {
			type = "group", order = 3,
			name = " ",guiInline = true,
			args = {

				intlist = {
					name = "从",
					type = "select",
					order = 1,
					desc = L["从当前可用的配置文件里面选择一个进行配置."],
					values = S.layoutList,
					set = function(info, value)
						self.db.intlist = value
					end,
				},
				tolist = {
					name = L["复制到"],
					type = "select",
					order = 2,
					values = S.layoutList,
					set = function(info, value)
						self.db.tolist = value
					end,
				},

				copy = {
					name = L["复制布局"],
					type = "execute",
					order = 3,
					confirm = true,
					confirmText = L["将会清空目标布局,你确认要复制这个布局?"],
					--hidden = function(info) return  end,
					func = function()
						if not S.db["movers"] then S.db["movers"] = {} end
						if not S.db["movers"][self.db.tolist] then S.db["movers"][self.db.tolist] = {} end
						if not S.db["movers"][self.db.intlist] then S.db["movers"][self.db.intlist] = {} end
						S.db["movers"][self.db.tolist] = table.deepcopy(S.db["movers"][self.db.intlist])
						if self.db.tolist == S.db.mainLayout then
							S:SetMoversPositions()
						end
					end,
					
				},
			},
		},
		group2 = {
			type = "group", order = 4,
			name = " ",guiInline = true,
			args = {

				dellist = {
					name = L["重置"],
					type = "select",
					order = 4,
					desc = L["从当前可用的配置文件里面选择一个进行配置."],
					values = S.layoutList,
					set = function(info, value)
						self.db.dellist = value
					end,
				},
				clear = {
					name = L["重置布局"],
					type = "execute",
					order = 10,
					confirm = true,
					confirmText = L["将会清空目标布局,你确认要重置这个布局?"],
					--hidden = function(info) return  end,
					func = function()
						if not S.db["movers"] then return end
						if not S.db["movers"][self.db.dellist] then return end
						S.db["movers"][self.db.dellist] = {}
						if self.db.dellist == S.db.layout.mainLayout then
							S:SetMoversPositions()
						end
					end,
					
				},
			},
		},
	}
	return options
end

function LM:Info()
	return L["布局管理器"]
end
local function SetDefault()
	LM.db.dellist = nil
	LM.db.intlist = nil
	LM.db.tolist = nil
end
function LM:Initialize()
	SetDefault()
	self:RegisterEvent("PLAYER_LOGOUT", "SetDefault")
	self:RegisterEvent("PLAYER_QUITING", "SetDefault")
end

S:RegisterModule(LM:GetName())