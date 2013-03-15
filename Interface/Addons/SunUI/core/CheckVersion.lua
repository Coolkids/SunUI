local S, L, DB, _, C = unpack(select(2, ...))
----------------------------------------------------------------------------------------
--	Check outdated UI version
----------------------------------------------------------------------------------------
local version = tonumber(GetAddOnMetadata("SunUI", "Version"))
local check = function(self, event, prefix, message, channel, sender)
	if event == "CHAT_MSG_ADDON" then
		if prefix ~= "SunUIVersion" or sender == UnitName("player") then return end
		if tonumber(message) == nil then return end
		if tonumber(message) > tonumber(GetAddOnMetadata("SunUI", "Version")) then
			print("|cffad2424"..L["过期"].."|r")
			self:UnregisterEvent("CHAT_MSG_ADDON")
		end
	else
		if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
			SendAddonMessage("SunUIVersion", version, "INSTANCE_CHAT")
		elseif IsInRaid() then
			SendAddonMessage("SunUIVersion", version, "RAID")
		elseif IsInGroup() then
			SendAddonMessage("SunUIVersion", version, "PARTY")
		elseif IsInGuild() then
			SendAddonMessage("SunUIVersion", version, "GUILD")
		end
	end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("GROUP_ROSTER_UPDATE")
frame:RegisterEvent("CHAT_MSG_ADDON")
frame:SetScript("OnEvent", check)
RegisterAddonMessagePrefix("SunUIVersion")