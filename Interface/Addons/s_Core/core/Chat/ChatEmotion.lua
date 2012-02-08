-- Engines
local _, _, _, DB = unpack(select(2, ...))

local IconSize = 20					 -- 表情IconSize
local fdir = "Interface\\Addons\\s_Core\\core\\Chat\\Icon\\"			 -- 表情材质路径
----------------------------------------------------------------------------------------
local customEmoteStartIndex = 9
local emotes = {
	{"{rt1}",	[[Interface\TargetingFrame\UI-RaidTargetingIcon_1]]},
	{"{rt2}",	[[Interface\TargetingFrame\UI-RaidTargetingIcon_2]]},
	{"{rt3}",	[[Interface\TargetingFrame\UI-RaidTargetingIcon_3]]},
	{"{rt4}",	[[Interface\TargetingFrame\UI-RaidTargetingIcon_4]]},
	{"{rt5}",	[[Interface\TargetingFrame\UI-RaidTargetingIcon_5]]},
	{"{rt6}",	[[Interface\TargetingFrame\UI-RaidTargetingIcon_6]]},
	{"{rt7}",	[[Interface\TargetingFrame\UI-RaidTargetingIcon_7]]},
	{"{rt8}",	[[Interface\TargetingFrame\UI-RaidTargetingIcon_8]]},
	{"{天使}",	fdir.."Angel"},
	{"{生气}",	fdir.."Angry"},

	{"{大笑}",	fdir.."Biglaugh"},
	{"{鼓掌}",	fdir.."Clap"},
	{"{酷}",	fdir.."Cool"},
	{"{哭}",	fdir.."Cry"},
	{"{可爱}",	fdir.."Cutie"},
	{"{鄙视}",	fdir.."Despise"},
	{"{美梦}",	fdir.."Dreamsmile"},
	{"{尴尬}",	fdir.."Embarrass"},
	{"{邪恶}",	fdir.."Evil"},
	{"{兴奋}",	fdir.."Excited"},

	{"{晕}",	fdir.."Faint"},
	{"{打架}",	fdir.."Fight"},
	{"{流感}",	fdir.."Flu"},
	{"{呆}",	fdir.."Freeze"},
	{"{皱眉}",	fdir.."Frown"},
	{"{致敬}",	fdir.."Greet"},
	{"{鬼脸}",	fdir.."Grimace"},
	{"{龇牙}",	fdir.."Growl"},
	{"{开心}",	fdir.."Happy"},
	{"{心}",	fdir.."Heart"},

	{"{恐惧}",	fdir.."Horror"},
	{"{生病}",	fdir.."Ill"},
	{"{无辜}",	fdir.."Innocent"},
	{"{功夫}",	fdir.."Kongfu"},
	{"{花痴}",	fdir.."Love"},
	{"{邮件}",	fdir.."Mail"},
	{"{化妆}",	fdir.."Makeup"},
	{"{马里奥}",	fdir.."Mario"},
	{"{沉思}",	fdir.."Meditate"},
	{"{可怜}",	fdir.."Miserable"},

	{"{好}",	fdir.."Okay"},
	{"{漂亮}",	fdir.."Pretty"},
	{"{吐}",	fdir.."Puke"},
	{"{握手}",	fdir.."Shake"},
	{"{喊}",	fdir.."Shout"},
	{"{闭嘴}",	fdir.."Shuuuu"},
	{"{害羞}",	fdir.."Shy"},
	{"{睡觉}",	fdir.."Sleep"},
	{"{微笑}",	fdir.."Smile"},
	{"{吃惊}",	fdir.."Suprise"},

	{"{失败}",	fdir.."Surrender"},
	{"{流汗}",	fdir.."Sweat"},
	{"{流泪}",	fdir.."Tear"},
	{"{悲剧}",	fdir.."Tears"},
	{"{想}",	fdir.."Think"},
	{"{偷笑}",	fdir.."Titter"},
	{"{猥琐}",	fdir.."Ugly"},
	{"{胜利}",	fdir.."Victory"},
	{"{雷锋}",	fdir.."Volunteer"},
	{"{委屈}",	fdir.."Wronged"},
}

local fmtstring = format("\124T%%s:%d\124t",max(floor(select(2,SELECTED_CHAT_FRAME:GetFont())),IconSize))

local function myChatFilter(self, event, msg, ...)
	for i = customEmoteStartIndex, #emotes do
		if msg:find(emotes[i][1]) then
			msg = msg:gsub(emotes[i][1],format(fmtstring,emotes[i][2]),1)
			break
		end
	end
	return false, msg, ...
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", myChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", myChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", myChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", myChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER", myChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", myChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", myChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", myChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", myChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", myChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", myChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_BATTLEGROUND", myChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_AFK", myChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_DND", myChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_OFFICER", myChatFilter)
