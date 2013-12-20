local S, L, DB, _, C = unpack(select(2, ...))
local _
local _G = _G
local SunUIConfig = LibStub("AceAddon-3.0"):GetAddon("SunUI"):GetModule("SunUIConfig")
local AchievementHolder = CreateFrame("Frame", "AchievementHolder", UIParent)
AchievementHolder:SetWidth(180)
AchievementHolder:SetHeight(20)
AchievementHolder:SetPoint("CENTER", UIParent, "CENTER", 0, 130)
AchievementHolder:Hide()
local POSITION, ANCHOR_POINT, YOFFSET = "BOTTOM", "TOP", 10
SlashCmdList.TEST_ACHIEVEMENT = function()
	PlaySound("LFG_Rewards")
	AchievementFrame_LoadUI()
	AchievementAlertFrame_ShowAlert(5780)
	AchievementAlertFrame_ShowAlert(5000)
	GuildChallengeAlertFrame_ShowAlert(3, 2, 5)
	ChallengeModeAlertFrame_ShowAlert()
	CriteriaAlertFrame_GetAlertFrame()
	AlertFrame_AnimateIn(CriteriaAlertFrame1)
	AlertFrame_AnimateIn(DungeonCompletionAlertFrame1)
	AlertFrame_AnimateIn(ScenarioAlertFrame1)
	local _, itemLink = GetItemInfo(6948)
	LootWonAlertFrame_ShowAlert(itemLink, -1, 1, 1)
	MoneyWonAlertFrame_ShowAlert(1)
	
	AlertFrame_FixAnchors()
end
SLASH_TEST_ACHIEVEMENT1 = "/testalerts"

hooksecurefunc("AlertFrame_FixAnchors", function()
	AlertFrame:ClearAllPoints()
	AlertFrame:SetAllPoints(AchievementHolder)
	local a, _, _, _, _ = unpack(SunUIConfig.db.profile.MoveHandleDB.AchievementHolder)
	if string.find(a, "TOP") then POSITION, ANCHOR_POINT, YOFFSET = "TOP", "BOTTOM", -10 end
	GroupLootContainer:ClearAllPoints()
	GroupLootContainer:SetPoint(POSITION, AlertFrame, ANCHOR_POINT)
	
	MissingLootFrame:ClearAllPoints()
	MissingLootFrame:SetPoint(POSITION, AlertFrame, ANCHOR_POINT)
	local alertAnchor = AlertFrame;
	alertAnchor = AlertFrame_SetLootAnchors(alertAnchor);
	alertAnchor = AlertFrame_SetLootWonAnchors(alertAnchor);
	alertAnchor = AlertFrame_SetMoneyWonAnchors(alertAnchor);
	alertAnchor = AlertFrame_SetAchievementAnchors(alertAnchor);
	alertAnchor = AlertFrame_SetCriteriaAnchors(alertAnchor);
	alertAnchor = AlertFrame_SetChallengeModeAnchors(alertAnchor);
	alertAnchor = AlertFrame_SetDungeonCompletionAnchors(alertAnchor);
	alertAnchor = AlertFrame_SetScenarioAnchors(alertAnchor);
	alertAnchor = AlertFrame_SetGuildChallengeAnchors(alertAnchor);
end)

hooksecurefunc("AlertFrame_SetLootWonAnchors", function(alertAnchor)
	for i=1, #LOOT_WON_ALERT_FRAMES do
		local frame = LOOT_WON_ALERT_FRAMES[i];
		if ( frame:IsShown() ) then
			frame:ClearAllPoints()
			frame:SetPoint(POSITION, alertAnchor, ANCHOR_POINT, 0, YOFFSET);
			alertAnchor = frame
		end
	end
end)

hooksecurefunc("AlertFrame_SetMoneyWonAnchors", function(alertAnchor)
	for i=1, #MONEY_WON_ALERT_FRAMES do
		local frame = MONEY_WON_ALERT_FRAMES[i];
		if ( frame:IsShown() ) then
			frame:ClearAllPoints()
			frame:SetPoint(POSITION, alertAnchor, ANCHOR_POINT, 0, YOFFSET);
			alertAnchor = frame
		end
	end
end)

hooksecurefunc("AlertFrame_SetAchievementAnchors", function(alertAnchor)
	if ( AchievementAlertFrame1 ) then
		for i = 1, MAX_ACHIEVEMENT_ALERTS do
			local frame = _G["AchievementAlertFrame"..i];
			if ( frame and frame:IsShown() ) then
				frame:ClearAllPoints()
				frame:SetPoint(POSITION, alertAnchor, ANCHOR_POINT, 0, YOFFSET);
				alertAnchor = frame
			end
		end
	end
end)

hooksecurefunc("AlertFrame_SetCriteriaAnchors", function(alertAnchor)
	if ( CriteriaAlertFrame1 ) then
		for i = 1, MAX_ACHIEVEMENT_ALERTS do
			local frame = _G["CriteriaAlertFrame"..i];
			if ( frame and frame:IsShown() ) then
				frame:ClearAllPoints()
				frame:SetPoint(POSITION, alertAnchor, ANCHOR_POINT, 0, YOFFSET);
				alertAnchor = frame
			end
		end
	end
end)

hooksecurefunc("AlertFrame_SetChallengeModeAnchors", function(alertAnchor)
	local frame = ChallengeModeAlertFrame1;
	if ( frame:IsShown() ) then
		frame:ClearAllPoints()
		frame:SetPoint(POSITION, alertAnchor, ANCHOR_POINT, 0, YOFFSET);
	end
end)

hooksecurefunc("AlertFrame_SetDungeonCompletionAnchors", function(alertAnchor)
	local frame = DungeonCompletionAlertFrame1;
	if ( frame:IsShown() ) then
		frame:ClearAllPoints()
		frame:SetPoint(POSITION, alertAnchor, ANCHOR_POINT, 0, YOFFSET);
	end
end)

hooksecurefunc("AlertFrame_SetScenarioAnchors", function(alertAnchor)
	local frame = ScenarioAlertFrame1;
	if ( frame:IsShown() ) then
		frame:ClearAllPoints()
		frame:SetPoint(POSITION, alertAnchor, ANCHOR_POINT, 0, YOFFSET);
	end
end)

hooksecurefunc("AlertFrame_SetGuildChallengeAnchors", function(alertAnchor)
	local frame = GuildChallengeAlertFrame;
	if ( frame:IsShown() ) then
		frame:ClearAllPoints()
		frame:SetPoint(POSITION, alertAnchor, ANCHOR_POINT, 0, YOFFSET);
	end
end)

AchievementHolder:RegisterEvent("ADDON_LOADED")
AchievementHolder:SetScript("OnEvent", function(self, event)
	AchievementHolder:UnregisterEvent("PLAYER_ENTERING_WORLD")
	MoveHandle.AchievementHolder = S.MakeMoveHandle(self, "成就移动", "AchievementHolder")
end)