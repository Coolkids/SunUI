-- Engines
local S, C, L, DB = unpack(select(2, ...))
local Core = LibStub("AceAddon-3.0"):GetAddon("Core")

-- Init
DB["Modules"]["Threat"] = {}
local Module = DB["Modules"]["Threat"]

-- LoadSettings
function Module.LoadSettings()
	local Default = {
	["ThreatBarWidth"] = 180,
	["NameTextL"] = 3,
	["ThreatLimited"] = 3,
	}
	if not ThreatDB then ThreatDB = {} end
	for key, value in pairs(Default) do
		if ThreatDB[key] == nil then ThreatDB[key] = value end
	end
	wipe(Default)
end

-- ResetToDefault
function Module.ResetToDefault()
	wipe(ThreatDB)
end

-- BuildGUI
function Module.BuildGUI()
	if DB["Config"] then
		DB["Config"]["Threat"] =  {
			type = "group", order = 5,
			name = L["仇恨监视"],
			args = {
				ThreatBarWidth = {
					type = "input",
					name = L["仇恨条宽度"],
					desc = L["仇恨条宽度"],
					order = 1,
					get = function() return tostring(ThreatDB.ThreatBarWidth) end,
					set = function(_, value) ThreatDB.ThreatBarWidth = tonumber(value) end,
				},
				NameTextL = {
					type = "input",
					name = L["仇恨条姓名长度"],
					desc = L["仇恨条姓名长度"],
					order = 2,
					get = function() return tostring(ThreatDB.NameTextL) end,
					set = function(_, value) ThreatDB.NameTextL = tonumber(value) end,
				},
				ThreatLimited = {
					type = "input",
					name = L["显示仇恨人数"],
					desc = L["显示仇恨人数"],
					order = 3,
					get = function() return tostring(ThreatDB.ThreatLimited) end,
					set = function(_, value) ThreatDB.ThreatLimited = tonumber(value) end,
				},
			},
		}
	end
end

