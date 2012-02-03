local Event = CreateFrame("Frame")
Event:RegisterEvent("PLAYER_ENTERING_WORLD")
Event:SetScript("OnEvent", function(self, elasped)
	local Timer = 0
	UIParent:SetAlpha(0)
	self:SetScript("OnUpdate", function(self, elasped)
		Timer = Timer + elasped
		if Timer > 4 then
			UIFrameFadeIn(UIParent, 2, 0, 1)
			self:SetScript("OnUpdate", nil)
		end
	end)
end)
UIParent:HookScript("OnShow", function(self, elasped)
	UIFrameFadeIn(UIParent, 2, 0, 1)
end)
