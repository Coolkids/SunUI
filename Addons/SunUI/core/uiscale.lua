local S, L, DB, _, C = unpack(select(2, ...))
--  自动设置聊天框体和UI缩放
local function SetChatFrame()
	ChatFrame1:ClearAllPoints()
	ChatFrame1:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 3, 33)
	ChatFrame1:SetWidth(327)
	ChatFrame1:SetHeight(122)
	-- 聊天频道职业染色
	local channels = {"SAY","EMOTE","YELL","GUILD","OFFICER","GUILD_ACHIEVEMENT","ACHIEVEMENT","WHISPER","PARTY","PARTY_LEADER","RAID","RAID_LEADER","RAID_WARNING","INSTANCE_CHAT","INSTANCE_CHAT_LEADER","CHANNEL1","CHANNEL2","CHANNEL3","CHANNEL4","CHANNEL5","CHANNEL6","CHANNEL7",}	
	for i, v in ipairs(channels) do
		ToggleChatColorNamesByClassGroup(true, v)
	end
	ChatFrame1:SetClampedToScreen(false)
end

SlashCmdList["AutoSet"] = function()
	if not UnitAffectingCombat("player") then
		SetChatFrame()
		SetCVar("useUiScale", 0)
		ReloadUI()
	end
end
SLASH_AutoSet1 = "/AutoSet"
SlashCmdList["SetChat"] = function()
	SetChatFrame()
end
SLASH_SetChat1 = "/setchat"