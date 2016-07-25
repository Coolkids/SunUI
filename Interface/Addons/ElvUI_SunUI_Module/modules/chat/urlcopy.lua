local E, L, V, P, G = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
----------------------------------------------------------------------------------------
--	Copy url from chat(module from Gibberish by p3lim)
----------------------------------------------------------------------------------------
local patterns = {
	"(https://%S+)",
	"(http://%S+)",
	"(www%.%S+)",
	"(%d+%.%d+%.%d+%.%d+:?%d*)"
}

for _, event in pairs({
	"CHAT_MSG_GUILD",
	"CHAT_MSG_PARTY",
	"CHAT_MSG_PARTY_LEADER",
	"CHAT_MSG_RAID",
	"CHAT_MSG_RAID_LEADER",
	"CHAT_MSG_CHANNEL",
	"CHAT_MSG_WHISPER",
	"CHAT_MSG_BN_WHISPER",
	"CHAT_MSG_SAY",
	"CHAT_MSG_INSTANCE_CHAT",
	"CHAT_MSG_INSTANCE_CHAT_LEADER"
}) do
	ChatFrame_AddMessageEventFilter(event, function(self, event, str, ...)
		for _, pattern in pairs(patterns) do
			local result, match = string.gsub(str, pattern, "|cff00FF00|Hurl:%1|h[%1]|h|r")
			if match > 0 then
				return false, result, ...
			end
		end
	end)
end

local orig = SetItemRef
function SetItemRef(link, str, ...)
	if string.sub(link, 1, 3) ~= "url" then return orig(link, str, ...) end

	local editbox = ChatEdit_ChooseBoxForSend()
	ChatEdit_ActivateChat(editbox)
	editbox:Insert(string.sub(link, 5))
	editbox:HighlightText()
end