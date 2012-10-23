local S, C, L, DB = unpack(select(2, ...))
----------------------------------------------------------------------------------------
--	Check outdated UI version
----------------------------------------------------------------------------------------
local check = function(self, event, prefix, message, channel, sender)
	if event == "CHAT_MSG_ADDON" then
		if prefix ~= "SunUIVersion" or sender == UnitName("player") then return end
		if tonumber(message) == nil then return end
		if tonumber(message) > tonumber(GetAddOnMetadata("SunUI", "Version")) then
			print("|cffad2424"..L_MISC_UI_OUTDATED.."|r")
			self:UnregisterEvent("CHAT_MSG_ADDON")
		end
	else
		if UnitInRaid("player") then
			SendAddonMessage("SunUIVersion", tonumber(GetAddOnMetadata("SunUI", "Version")), "RAID")
		elseif UnitInParty("player") then
			SendAddonMessage("SunUIVersion", tonumber(GetAddOnMetadata("SunUI", "Version")), "PARTY")
		elseif IsInGuild() then
			SendAddonMessage("SunUIVersion", tonumber(GetAddOnMetadata("SunUI", "Version")), "GUILD")
		end
	end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("GROUP_ROSTER_UPDATE")
frame:RegisterEvent("CHAT_MSG_ADDON")
frame:SetScript("OnEvent", check)
RegisterAddonMessagePrefix("SunUIVersion")