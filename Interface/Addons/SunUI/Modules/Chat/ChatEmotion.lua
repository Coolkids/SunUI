-- Engines
local S, L, DB, _, C = unpack(select(2, ...))
 
if DB.zone ~= "zhTW" and DB.zone ~= "zhCN" then return end
local Module = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("chatemotion", "AceTimer-3.0")
local IconSize = S.Scale(23)					 -- 表情IconSize
local fdir = "Interface\\Addons\\SunUI\\Modules\\chat\\Icon\\"			 -- 表情材质路径
----------------------------------------------------------------------------------------
local customEmoteStartIndex = 9
if DB.zone == "zhCN" then  
	emotes = {
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
	elseif DB.zone == "zhTW" then
		emotes = {
		{"{rt1}",	[[Interface\TargetingFrame\UI-RaidTargetingIcon_1]]},
		{"{rt2}",	[[Interface\TargetingFrame\UI-RaidTargetingIcon_2]]},
		{"{rt3}",	[[Interface\TargetingFrame\UI-RaidTargetingIcon_3]]},
		{"{rt4}",	[[Interface\TargetingFrame\UI-RaidTargetingIcon_4]]},
		{"{rt5}",	[[Interface\TargetingFrame\UI-RaidTargetingIcon_5]]},
		{"{rt6}",	[[Interface\TargetingFrame\UI-RaidTargetingIcon_6]]},
		{"{rt7}",	[[Interface\TargetingFrame\UI-RaidTargetingIcon_7]]},
		{"{rt8}",	[[Interface\TargetingFrame\UI-RaidTargetingIcon_8]]},
		{"{天使}",	fdir.."Angel"},
		{"{生氣}",	fdir.."Angry"},

		{"{大笑}",	fdir.."Biglaugh"},
		{"{鼓掌}",	fdir.."Clap"},
		{"{酷}",	fdir.."Cool"},
		{"{哭}",	fdir.."Cry"},
		{"{可愛}",	fdir.."Cutie"},
		{"{鄙視}",	fdir.."Despise"},
		{"{美夢}",	fdir.."Dreamsmile"},
		{"{尷尬}",	fdir.."Embarrass"},
		{"{邪惡}",	fdir.."Evil"},
		{"{興奮}",	fdir.."Excited"},

		{"{暈}",	fdir.."Faint"},
		{"{打架}",	fdir.."Fight"},
		{"{流感}",	fdir.."Flu"},
		{"{呆}",	fdir.."Freeze"},
		{"{皺眉}",	fdir.."Frown"},
		{"{致敬}",	fdir.."Greet"},
		{"{鬼臉}",	fdir.."Grimace"},
		{"{齜牙}",	fdir.."Growl"},
		{"{開心}",	fdir.."Happy"},
		{"{心}",	fdir.."Heart"},

		{"{恐懼}",	fdir.."Horror"},
		{"{生病}",	fdir.."Ill"},
		{"{無辜}",	fdir.."Innocent"},
		{"{功夫}",	fdir.."Kongfu"},
		{"{花癡}",	fdir.."Love"},
		{"{郵件}",	fdir.."Mail"},
		{"{化妝}",	fdir.."Makeup"},
		{"{馬裏奧}",	fdir.."Mario"},
		{"{沈思}",	fdir.."Meditate"},
		{"{可憐}",	fdir.."Miserable"},

		{"{好}",	fdir.."Okay"},
		{"{漂亮}",	fdir.."Pretty"},
		{"{吐}",	fdir.."Puke"},
		{"{握手}",	fdir.."Shake"},
		{"{喊}",	fdir.."Shout"},
		{"{閉嘴}",	fdir.."Shuuuu"},
		{"{害羞}",	fdir.."Shy"},
		{"{睡覺}",	fdir.."Sleep"},
		{"{微笑}",	fdir.."Smile"},
		{"{吃驚}",	fdir.."Suprise"},

		{"{失敗}",	fdir.."Surrender"},
		{"{流汗}",	fdir.."Sweat"},
		{"{流淚}",	fdir.."Tear"},
		{"{悲劇}",	fdir.."Tears"},
		{"{想}",	fdir.."Think"},
		{"{偷笑}",	fdir.."Titter"},
		{"{猥瑣}",	fdir.."Ugly"},
		{"{勝利}",	fdir.."Victory"},
		{"{雷鋒}",	fdir.."Volunteer"},
		{"{委屈}",	fdir.."Wronged"},
	}
	else return
end
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

local function CreateEmoteTableFrame()
	EmoteTableFrame = CreateFrame("Frame", "EmoteTableFrame", UIParent)
	EmoteTableFrame:CreateShadow("Background")
	EmoteTableFrame:SetWidth((IconSize+2) * 12+4)
	EmoteTableFrame:SetHeight((IconSize+2) * 5+4)
	EmoteTableFrame:SetPoint("BOTTOMRIGHT", ChatFrame1, "TOPRIGHT", 0, 5)
	EmoteTableFrame:Hide()
	EmoteTableFrame:SetFrameStrata("DIALOG")

	local icon, row, col
	row = 1
	col = 1
	for i=1,#emotes do 
		text = emotes[i][1]
		texture = emotes[i][2]
		icon = CreateFrame("Frame", format("IconButton%d",i), EmoteTableFrame)
		icon:SetWidth(IconSize)
		icon:SetHeight(IconSize)
		icon.text = text
		
		icon.texture = icon:CreateTexture(nil,"ARTWORK")
		icon.texture:SetTexture(texture)
		icon.texture:SetAllPoints(icon)
		icon:Show()
		icon:SetPoint("TOPLEFT", (col-1)*(IconSize+2)+2, -(row-1)*(IconSize+2)-2)
		icon:SetScript("OnMouseUp", function(self)   
		local ChatFrame1EditBox = ChatEdit_ChooseBoxForSend()
		if (not ChatFrame1EditBox:IsShown()) then
			ChatEdit_ActivateChat(ChatFrame1EditBox)
		end
		ChatFrame1EditBox:Insert(self.text)
		EmoteTableFrame:Hide()
		end)
		icon:SetScript("OnEnter",  function(self)
		GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
		GameTooltip:AddLine(self.text)
		GameTooltip:Show()  end)
		icon:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
		icon:EnableMouse(true)
		col = col + 1 
		if (col>12) then
			row = row + 1
			col = 1
		end
	end
end

local function ToggleEmoteTable()
	if (not EmoteTableFrame) then CreateEmoteTableFrame() end
	if (EmoteTableFrame:IsShown()) then
		EmoteTableFrame:Hide()
	else
		EmoteTableFrame:Show()
	end

end

local function EmoteIconMouseUp(self, button)
	if (button == "LeftButton") then
		ChatFrameEditBox:Show()
		ChatFrameEditBox:Insert(text)
	end
	--ToggleEmoteTable()
end
function Module:OnEnable()
local button = CreateFrame("Button", "ButtonE", ColectorButton)
		button:Point("TOPLEFT", ColectorButton, "TOPLEFT", 5, -5)
		button:Size(15)
		button.text = button:CreateFontString(nil, 'OVERLAY')
		button.text:SetFont(DB.Font, 10*S.Scale(1), "THINOUTLINE")
		button.text:SetText("E")
		button.text:SetPoint("CENTER", 3, 0)
		button.text:SetTextColor(23/255, 132/255, 209/255)
		button:SetScript("OnMouseUp", function(self, btn)
			ToggleEmoteTable()
		end)
		button:SetScript("OnEnter",  function(self)
		GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
		GameTooltip:AddLine("表情")
		GameTooltip:Show()  end)
		button:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
		S.Reskin(button)
end