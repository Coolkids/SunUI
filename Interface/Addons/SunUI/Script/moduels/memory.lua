local eventcount = 0 
local a = CreateFrame("Frame") 
a:RegisterAllEvents() 
a:SetScript("OnEvent", function(self, event, ...) 
	--print(event)
	eventcount = eventcount + 1 
   --if InCombatLockdown() then return end 
  -- if eventcount > 10000 or event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_REGEN_ENABLED" then 
      --collectgarbage("collect") 
      --eventcount = 0 
   --end 
	if (InCombatLockdown() and eventcount > 25000) or eventcount > 10000 or event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_REGEN_ENABLED" then
		collectgarbage("collect")
		--print(eventcount)
		eventcount = 0
	end
end)	