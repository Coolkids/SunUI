 	local _G = _G
	local AchievementHolder = CreateFrame("Frame", "AchievementHolder", UIParent)
	AchievementHolder:SetWidth(180)
	AchievementHolder:SetHeight(20)
	AchievementHolder:SetPoint("TOP", UIParent, "TOP", 0, -35)
	AchievementHolder:Hide()
	AchievementHolder:RegisterEvent("ADDON_LOADED")
	AchievementHolder:SetScript("OnEvent", function(event, addon)
		if addon=="Blizzard_AchievementUI" then 
			local previousFrame
			for i=1, MAX_ACHIEVEMENT_ALERTS do
				local aFrame = _G["AchievementFrameTab"..i]
				if ( aFrame ) then
					aFrame:ClearAllPoints()
					if ( previousFrame and previousFrame:IsShown() ) then
						aFrame:SetPoint("TOP", previousFrame, "BOTTOM", 0, -10)
					else
						aFrame:SetPoint("TOP", AchievementHolder, "BOTTOM")
					end
					previousFrame = aFrame
				end
			end
		end
	end)

	

	hooksecurefunc("AlertFrame_SetDungeonCompletionAnchors", function()
		for i=MAX_ACHIEVEMENT_ALERTS, 1, -1 do
			local aFrame = _G["AchievementAlertFrame"..i]
			if ( aFrame and aFrame:IsShown() ) then
				DungeonCompletionAlertFrame1:ClearAllPoints()
				DungeonCompletionAlertFrame1:SetPoint("TOP", aFrame, "BOTTOM", 0, -10)
				return
			end		
			DungeonCompletionAlertFrame1:ClearAllPoints()	
			DungeonCompletionAlertFrame1:SetPoint("TOP", AchievementHolder, "BOTTOM")
		end
	end)
