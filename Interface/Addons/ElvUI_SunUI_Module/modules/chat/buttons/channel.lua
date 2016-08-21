local E, L, V, P, G = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local B = E:GetModule("Chat-SunUI")

local customChannelName

if E.zone == "zhCN" then 
	customChannelName = "大脚世界频道"
elseif E.zone == "zhTW" then
	customChannelName = "大腳世界頻道"
end

function B:BigFootChannel()
	local A = E:GetModule("Skins-SunUI")
	local button = CreateFrame("Button", "ButtonP", CollectorButton)
	button:Point("TOPLEFT", CollectorButton, "TOPLEFT", 5, -25)
	button:Size(15, 15)
	button.text = button:CreateFontString(nil, 'OVERLAY')
	button.text:SetFont(P["media"].font, P["media"].fontsize-2, "THINOUTLINE")
	button.text:SetText("C")
	button.text:Point("CENTER")
	button.text:SetTextColor(23/255, 132/255, 209/255)
	button:SetScript("OnMouseUp", function(self)
		local channels = {GetChannelList()}
		local isInCustomChannel = false
		
		for i =1, #channels do
			if channels[i] == customChannelName then
				isInCustomChannel = true
			end
		end
		if isInCustomChannel then
			E:Print("离开大脚频道")
			LeaveChannelByName(customChannelName)
		else
			JoinPermanentChannel(customChannelName,nil,1)
			E:Print("加入大脚世界频道")
			ChatFrame_AddChannel(ChatFrame1,customChannelName)
			ChatFrame_RemoveMessageGroup(ChatFrame1,"CHANNEL")
	   end
	end)
	button:SetScript("OnEnter",  function(self)
		local channels = {GetChannelList()}
		local inchannel = "关闭"
		for i =1, #channels do
				if channels[i] == customChannelName then
					 inchannel = "开启"
					 else
					 inchannel = "关闭"
				end
			end
		GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
		GameTooltip:AddLine("大脚世界频道开关", 0.75, 0.9, 1)
		GameTooltip:AddLine("点击进入或者离开")
		GameTooltip:AddLine("您现在大脚世界频道处于"..inchannel.."状态")
		GameTooltip:Show()  
	end)
	button:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	A:Reskin(button)
end