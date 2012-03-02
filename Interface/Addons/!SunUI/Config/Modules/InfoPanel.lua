-- Engines
local S, C, L, DB = unpack(select(2, ...))
local Core = LibStub("AceAddon-3.0"):GetAddon("Core")

-- Init
DB["Modules"]["InfoPanel"] = {}
local Module = DB["Modules"]["InfoPanel"]

-- LoadSettings
function Module.LoadSettings()
	local Default = {
		["OpenTop"] = true,
		["OpenBottom"] = true,
		["BottomWidth"] = 440,
		["BottomHeight"] = 13,
	}
	if not InfoPanelDB then InfoPanelDB = {} end
	for key, value in pairs(Default) do
		if InfoPanelDB[key] == nil then InfoPanelDB[key] = value end
	end
	wipe(Default)
end

-- ResetToDefault
function Module.ResetToDefault()
	wipe(InfoPanelDB)
end

-- BuildGUI
function Module.BuildGUI()
	if DB["Config"] then
		DB["Config"]["InfoPanel"] =  {
			type = "group", order = 14,
			name = L["信息面板"],
			args = {
				OpenTop = {
					type = "toggle",
					name = L["启用顶部信息条"],
					order = 1,
					get = function() return InfoPanelDB.OpenTop end,
					set = function(_, value) InfoPanelDB.OpenTop = value end,
				},
				OpenBottom = {
					type = "toggle",
					name = L["启用底部信息条"],
					order = 2,
					get = function() return InfoPanelDB.OpenBottom end,
					set = function(_, value) InfoPanelDB.OpenBottom = value end,
				},
				BottomWidth = {
					type = "input",
					name = L["底部信息条宽度"],
					desc = L["底部信息条宽度"],
					disabled = not InfoPanelDB.OpenBottom,
					order = 3,
					get = function() return tostring(InfoPanelDB.BottomWidth) end,
					set = function(_, value) InfoPanelDB.BottomWidth = tonumber(value) end,
				},
				BottomHeight = {
					type = "input",
					name = L["底部信息条宽度"],
					desc = L["底部信息条宽度"],
					disabled = not InfoPanelDB.OpenBottom,
					order = 4,
					get = function() return tostring(InfoPanelDB.BottomHeight) end,
					set = function(_, value) InfoPanelDB.BottomHeight = tonumber(value) end,
				},
			}
		}
	end
end

