-- Engines
local S, C, L, DB = unpack(select(2, ...))
local Core = LibStub("AceAddon-3.0"):GetAddon("Core")

-- Init
DB["Modules"]["Reminder"] = {}
local Module = DB["Modules"]["Reminder"]

-- LoadSettings
function Module.LoadSettings()
	local Default = {
	["ShowClassBuff"] = true,
	["ClassBuffSound"] = false,
	["ShowRaidBuff"] = true,
	["RaidBuffSize"] = 15,
	["ClassBuffSize"] = 32,
	["ShowOnlyInParty"] = true,
	["RaidBuffDirection"] = 1,
	}
	if not ReminderDB then ReminderDB = {} end
	for key, value in pairs(Default) do
		if ReminderDB[key] == nil then ReminderDB[key] = value end
	end
	wipe(Default)
end

-- ResetToDefault
function Module.ResetToDefault()
	wipe(ReminderDB)
end

-- BuildGUI
function Module.BuildGUI()
	if DB["Config"] then
		DB["Config"]["Reminder"] =  {
			type = "group", order = 7,
			name = L["缺失提醒"],
			args = {
				ShowRaidBuff = {
					type = "toggle", order = 1,
					name = L["显示团队增益缺失提醒"],
					get = function() return ReminderDB.ShowRaidBuff end,
					set = function(_, value) ReminderDB.ShowRaidBuff = value end,
				},
				Gruop_1 = {
					type = "group", order = 2,
					name = " ", guiInline = true, disabled = not ReminderDB.ShowRaidBuff,
					args = {
						ShowOnlyInParty = {
							type = "toggle", order = 1,
							name = L["只在队伍中显示"],
							get = function() return ReminderDB.ShowOnlyInParty end,
							set = function(_, value) ReminderDB.ShowOnlyInParty = value end,
						}, 
						RaidBuffSize = {
							type = "input", order = 2,
							name = L["团队增益图标大小"], desc = L["团队增益图标大小"],
							get = function() return tostring(ReminderDB.RaidBuffSize) end,
							set = function(_, value) ReminderDB.RaidBuffSize = tonumber(value) end,
						},
						RaidBuffDirection = {
							type = "select", order = 5,
							name = L["团队增益图标排列方式"], desc = L["团队增益图标排列方式"],
							values = {[1] = L["横排"], [2] = L["竖排"]},
							get = function() return ReminderDB.RaidBuffDirection end,
							set = function(_, value) ReminderDB.RaidBuffDirection = value end,
						},
					},
				},
				ShowClassBuff = {
					type = "toggle", order = 3,
					name = L["显示职业增益缺失提醒"],
					get = function() return ReminderDB.ShowClassBuff end,
					set = function(_, value) ReminderDB.ShowClassBuff = value end,
				},
				Gruop_2 = {
					type = "group", order = 4,
					name = " ", guiInline = true, disabled = not ReminderDB.ShowClassBuff,
					args = {
						ClassBuffSound = {
							type = "toggle", order = 1,
							name = L["开启声音警报"],
							get = function() return ReminderDB.ClassBuffSound end,
							set = function(_, value) ReminderDB.ClassBuffSound = value end,
						},
						ClassBuffSize = {
							type = "input", order = 2,
							name = L["职业增益图标大小"], desc = L["职业增益图标大小"],
							get = function() return tostring(ReminderDB.ClassBuffSize) end,
							set = function(_, value) ReminderDB.ClassBuffSize = tonumber(value) end,
						},
						--[[ ClassBuffSpace = {
							type = "input", order = 3,
							name = L["职业增益图标间距"], desc = L["职业增益图标间距"],
							get = function() return tostring(ReminderDB.ClassBuffSpace) end,
							set = function(_, value) ReminderDB.ClassBuffSpace = tonumber(value) end,
						}, --]]
					},
				},
			},
		}
	end
end