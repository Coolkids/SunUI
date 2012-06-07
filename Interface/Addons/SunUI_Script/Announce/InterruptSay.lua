local S, C, L, DB = unpack(SunUI)
local Module = LibStub("AceAddon-3.0"):GetAddon("Core"):NewModule("Interrupt")

function Module:OnInitialize()
	C = C["MiniDB"]
	if C["Interrupt"] ~= true then return end
	
	local frame = CreateFrame('Frame')
	frame:Hide()
	frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	frame:SetScript('OnEvent', function(self, event, ...)
		local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, arg16 = ...
		if arg2 ~= "SPELL_INTERRUPT" or arg5 ~= UnitName("player") then
			return
		end
		local channel = GetNumRaidMembers() > 0 and "RAID" or GetNumPartyMembers() > 0 and "PARTY"
		if channel then
			SendChatMessage(GetSpellLink(arg12).." 打断了 "..GetSpellLink(arg15), channel)
		end
	end)
end