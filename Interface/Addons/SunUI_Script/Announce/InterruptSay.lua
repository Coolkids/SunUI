local S, C, L, DB, _ = unpack(SunUI)
local Module = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("Interrupt")

function Module:OnInitialize()
	C = C["MiniDB"]
	if C["Interrupt"] ~= true then return end
end	
function Module:OnEnable()
	local frame = CreateFrame('Frame')
	frame:Hide()
	frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	frame:SetScript('OnEvent', function(self, event, ...)
		local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, arg16 = ...
		if arg2 ~= "SPELL_INTERRUPT" or arg5 ~= UnitName("player") then
			return
		end
		local channel = GetNumGroupMembers() > 0 and "RAID" or GetNumSubgroupMembers() > 0 and "PARTY"
		if channel then
			SendChatMessage(GetSpellLink(arg12).." 打断了 "..arg9.."的"..GetSpellLink(arg15), channel)
		end
	end)
end	