local E, L, V, P, G = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local mod=E:NewModule("SunUI-GUI", 'AceTimer-3.0', 'AceHook-3.0', 'AceEvent-3.0')
local LEP = LibStub("LibElvUIPlugin-1.0")

function mod:Initialize()
	LEP:RegisterPlugin("ElvUI_SunUI_Module")
	self:RegisterEvent("ADDON_LOADED")
end

function mod:ADDON_LOADED(event, addon)
	if addon ~= "ElvUI_Config" then return end
	local PB = E:GetModule("PowerBar-SunUI").GetOptions()
	ElvUI[1].Options.args.PowerBar = PB
	
	local QT = E:GetModule("Quest-SunUI").GetOptions()
	ElvUI[1].Options.args.quest_sunui = QT
	
	local SunUI_Mod = E:GetModule("SunUI-Modules").GetOptions()
	ElvUI[1].Options.args.SunUI_Modules = SunUI_Mod
	
	local An = E:GetModule("Announce").GetOptions()
	ElvUI[1].Options.args.Announce = An
end

E:RegisterModule(mod:GetName())