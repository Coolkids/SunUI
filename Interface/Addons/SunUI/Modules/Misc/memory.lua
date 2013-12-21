local eventcount = 0 
local a = CreateFrame("Frame") 
a:RegisterAllEvents() 
a:SetScript("OnEvent", function(self, event, ...) 
	--if strfind(event, "BAG_UPDATE_COOLDOWN") then
		--print(event)
	--end
	if InCombatLockdown() then return end
	eventcount = eventcount + 1
	if eventcount > 40000 or event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_REGEN_ENABLED" then
	--if (InCombatLockdown() and eventcount > 1000000) or (not InCombatLockdown() and eventcount > 10000) or event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_REGEN_ENABLED" then
		collectgarbage("collect")
		--print("------------"..eventcount.."-------"..GameTime_GetLocalTime(true))
		eventcount = 0
	end
end)	