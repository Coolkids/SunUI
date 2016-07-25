local E, L, V, P, G = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local mod=E:NewModule("SunUI-GUI", 'AceTimer-3.0', 'AceHook-3.0', 'AceEvent-3.0')

function mod:ADDON_LOADED(event, addon)
	
	if addon=="ElvUI_Config" then
		
	
	end
end

function mod:Initialize()
	--self:RegisterEvent('ADDON_LOADED')
end

E:RegisterModule(mod:GetName())