local E, L, V, P, G = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local mod=E:NewModule("SunUI-Modules", 'AceTimer-3.0', 'AceHook-3.0', 'AceEvent-3.0')


function mod:Initialize()
	self.db = E.db.SunUI_Modules
	mod:initCooldownFlash()
	mod:CreateMiniFlash()
end

function mod:GetOptions()
	local options = {
		type = "group", order = -95,
		name = "SunUI增加功能",
		get = function(info) return E.db.SunUI_Modules[ info[#info] ] end,
		set = function(info, value) E.db.SunUI_Modules[ info[#info] ] = value end,
		args = {
			group1 = {
				type = "group", order = 1,
				name = " ",guiInline = true,
				args = {
					CooldownFlash = {
						type = "toggle", order = 1,
						name = "冷却闪光",	
						set = function(info, value) E.db.SunUI_Modules.CooldownFlash = value
							mod:UpdateSetCoolDownFlashUpdate()
						end,
					},
					CooldownFlashSize = {
						type = "input",
						name = "冷却闪光图标大小",
						desc = "冷却闪光图标大小",
						order = 2,
						disabled = function(info) return not E.db.SunUI_Modules.CooldownFlash end,
						get = function() return tostring(E.db.SunUI_Modules.CooldownFlashSize) end,
						set = function(_, value) 
							self.db.CooldownFlashSize = tonumber(value) 
							mod:UpdateSetCoolDownFlashUpdate()
						end,
					},
				}
			},
		}
	}
	return options
end

E:RegisterModule(mod:GetName())