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
		["MemNum"] = 5,
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
			type = "group", order = 15,
			name = L["信息面板"],
			args = {
				OpenTop = {
					type = "toggle",
					name = L["启用顶部信息条"],
					order = 1,
					get = function() return InfoPanelDB.OpenTop end,
					set = function(_, value) InfoPanelDB.OpenTop = value end,
				},
				MemNum = {
					type = "input",
					name = L["一次显示插件数目"],
					desc = L["一次显示插件数目"],
					disabled = not InfoPanelDB.OpenTop,
					order = 4,
					get = function() return tostring(InfoPanelDB.MemNum) end,
					set = function(_, value) InfoPanelDB.MemNum = tonumber(value) end,
				},
				OpenBottom = {
					type = "toggle",
					name = L["启用底部信息条"],
					order = 3,
					get = function() return InfoPanelDB.OpenBottom end,
					set = function(_, value) InfoPanelDB.OpenBottom = value end,
				},
				BottomWidth = {
					type = "input",
					name = L["底部信息条宽度"],
					desc = L["底部信息条宽度"],
					disabled = not InfoPanelDB.OpenBottom,
					order = 4,
					get = function() return tostring(InfoPanelDB.BottomWidth) end,
					set = function(_, value) InfoPanelDB.BottomWidth = tonumber(value) end,
				},
				BottomHeight = {
					type = "input",
					name = L["底部信息条高度"],
					desc = L["底部信息条高度"],
					disabled = not InfoPanelDB.OpenBottom,
					order = 5,
					get = function() return tostring(InfoPanelDB.BottomHeight) end,
					set = function(_, value) InfoPanelDB.BottomHeight = tonumber(value) end,
				},
			}
		}
		DB["Config"]["Filgter"] =  {
			type = "group", order = 16,
			name = "技能监视",
			args = {
					UnlockRiad = {
					type = "execute",
					name = "技能监视",
					order = 1,
					func = function()
						if not UnitAffectingCombat("player") then
							if IsAddOnLoaded("RayWatcher") then 
								local bF = LibStub and LibStub("AceConfigDialog-3.0", true)
										bF:Open("RayWatcherConfig")
										bF:Close("SunUI Config")
							end
						end
					end
					},
			}
		}
	end
end

