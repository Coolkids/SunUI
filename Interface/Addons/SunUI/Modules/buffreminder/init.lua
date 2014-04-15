local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local

local BR = S:NewModule("BufferReminder", "AceEvent-3.0", "AceHook-3.0", "AceConsole-3.0")
BR.modName = L["Buff提醒"]
BR.order = 11
function BR:GetOptions()
	local options = {
		ShowRaidBuff = {
			type = "toggle", order = 1,
			name = L["显示团队增益缺失提醒"],
		},
		Gruop_1 = {
			type = "group", order = 2,
			name = " ", guiInline = true, disabled = function(info) return not self.db.ShowRaidBuff end,
			args = {
				ShowOnlyInParty = {
					type = "toggle", order = 1,
					name = L["只在队伍中显示"],
				}, 
				RaidBuffDirection = {
					type = "select", order = 3,
					name = L["团队增益图标排列方式"], desc = L["团队增益图标排列方式"],
					values = {[1] = L["横排"], [2] = L["竖排"]},
					get = function() return self.db.RaidBuffDirection end,
					set = function(_, value) self.db.RaidBuffDirection = value end,
				},
			},
		},
		ShowClassBuff = {
			type = "toggle", order = 3,
			name = L["显示职业增益缺失提醒"],
		},
		Gruop_2 = {
			type = "group", order = 4,
			name = " ", guiInline = true, disabled = function(info) return not self.db.ShowClassBuff end,
			args = {
				ClassBuffSize = {
					type = "input", order = 1,
					name = L["职业增益图标大小"], desc = L["职业增益图标大小"],
					get = function() return tostring(self.db.ClassBuffSize) end,
					set = function(_, value) self.db.ClassBuffSize = tonumber(value) end,
				},
			},
		},
	}
	return options
end

function BR:Initialize()
	self:initBuffReminder()
	self:initRaidBuffReminder()
end

S:RegisterModule(BR:GetName())