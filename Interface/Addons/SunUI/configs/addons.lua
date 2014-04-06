local S, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB

local AddOn = {}
--[[
function AddOn.插件名字()

end
--]]
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:SetScript("OnEvent", function(self, event, addon)
	if event == "PLAYER_ENTERING_WORLD" then
		for addon in pairs(AddOn) do
			if IsAddOnLoaded(addon) then
				AddOn[addon]()
				AddOn[addon] = nil
			end
		end
	elseif event == "ADDON_LOADED" then
		if AddOn[addon] then
			AddOn[addon]()
			AddOn[addon] = nil
		end
	end
end)