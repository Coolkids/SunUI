local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local

local UF = S:NewModule("UnitFrames", "AceEvent-3.0", "AceHook-3.0", "AceConsole-3.0")
UF.modName = L["头像美化"]
UF.order = 6
function UF:GetOptions()
	local options = {
		group1 = {
			type = "group", order = 1,
			name = " ",guiInline = true,
			args = {
				layout = {
					type = "select",
					name = L["显示模式"],
					desc = L["显示模式"],
					order = 1,
					values = {[1] = L["治疗模式"], [2] = L["DPS/Tank模式"]},
				},
				healerClasscolours = {
					type = "toggle",
					name = L["治疗模式下职业着色"],
					desc = L["治疗模式下职业着色"],
					order = 2,
				},
				absorb = {
					type = "toggle",
					name = L["显示吸收"],
					desc = L["显示吸收"],
					order = 3,
				},
				castbarSeparate = {
					type = "toggle",
					name = L["独立施法条"],
					desc = L["独立施法条"],
					order = 4,
				},
				castbarSeparateOnlyCasters = {
					type = "toggle",
					name = L["布衣职业施法条"],
					desc = L["仅仅布衣职业使用独立施法条"],
					order = 5,
				},
				targettarget = {
					type = "toggle",
					name = L["显示目标的目标"],
					desc = L["显示目标的目标"],
					order = 6,
				},
				enableArena = {
					type = "toggle",
					name = L["显示竞技场"],
					desc = L["显示竞技场"],
					order = 7,
				},
			},
		},
		group2 = {
			type = "group", order = 2,
			name = " ",guiInline = true,
			args = {
				altPowerHeight = {
					type = "range",
					name = L["特殊boss能量条高度"],
					order = 1,
					min = 1, max = 30, step = 1,
				},
				powerHeight = {
					type = "range",
					name = L["能量条高度"],
					order = 2,
					min = 1, max = 30, step = 1,
				},
				playerWidth = {
					type = "range",
					name = L["玩家宽度"],
					order = 3,
					min = 1, max = 400, step = 1,
				},
				playerHeight = {
					type = "range",
					name = L["玩家高度"],
					order = 4,
					min = 1, max = 100, step = 1,
				},
				targetWidth = {
					type = "range",
					name = L["目标宽度"],
					order = 5,
					min = 1, max = 400, step = 1,
				},
				targetHeight = {
					type = "range",
					name = L["目标高度"],
					order = 6,
					min = 1, max = 100, step = 1,
				},
				targettargetWidth = {
					type = "range",
					name = L["目标的目标宽度"],
					order = 7,
					min = 1, max = 400, step = 1,
				},
				targettargetHeight = {
					type = "range",
					name = L["目标的目标高度"],
					order = 8,
					min = 1, max = 100, step = 1,
				},
				focusWidth = {
					type = "range",
					name = L["焦点宽度"],
					order = 9,
					min = 1, max = 400, step = 1,
				},
				focusHeight = {
					type = "range",
					name = L["焦点高度"],
					order = 10,
					min = 1, max = 100, step = 1,
				},
				petWidth = {
					type = "range",
					name = L["宠物宽度"],
					order = 11,
					min = 1, max = 400, step = 1,
				},
				petHeight = {
					type = "range",
					name = L["宠物高度"],
					order = 12,
					min = 1, max = 100, step = 1,
				},
				bossWidth = {
					type = "range",
					name = L["boss宽度"],
					order = 13,
					min = 1, max = 400, step = 1,
				},
				bossHeight = {
					type = "range",
					name = L["boss高度"],
					order = 14,
					min = 1, max = 100, step = 1,
				},
				arenaWidth = {
					type = "range",
					name = L["竞技场宽度"],
					order = 15,
					min = 1, max = 400, step = 1,
				},
				arenaHeight = {
					type = "range",
					name = L["竞技场高度"],
					order = 16,
					min = 1, max = 100, step = 1,
				},
			},
		},
		group3 = {
			type = "group", order = 3,
			name = " ",guiInline = true,
			args = {
				num_player_debuffs = {
					type = "range",
					name = L["玩家debuff数量"],
					order = 1,
					min = 1, max = 40, step = 1,
				},
				num_target_debuffs = {
					type = "range",
					name = L["目标debuff数量"],
					order = 2,
					min = 1, max = 40, step = 1,
				},
				num_target_buffs = {
					type = "range",
					name = L["目标buff数量"],
					order = 3,
					min = 1, max = 40, step = 1,
				},
				num_boss_buffs = {
					type = "range",
					name = L["boss buff数量"],
					order = 4,
					min = 1, max = 40, step = 1,
				},
				num_arena_buffs = {
					type = "range",
					name = L["竞技场buff数量"],
					order = 5,
					min = 1, max = 40, step = 1,
				},
				num_focus_debuffs = {
					type = "range",
					name = L["焦点debuff数量"],
					order = 6,
					min = 1, max = 40, step = 1,
				},
			},
		},
	}
	return options
end

function UF:Initialize()
	UF:initLayout()
	UF:hideBlizzframes()
end

S:RegisterModule(UF:GetName())