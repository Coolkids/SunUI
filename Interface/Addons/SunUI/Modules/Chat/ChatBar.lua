local S, L, DB, _, C = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("ChatFramePanel", "AceTimer-3.0")
local Channel = {
	{"/s", "/e ", "/y"},
	{"/g", "/o"},
	{"/p", "/i", "/bg"},
	{"/ra", "/rw"},
	{"/1", "/2"},
	{"/3", "/4", "/5"},
}
local Color = {
	{255/255, 255/255, 255/255}, 	--说
	{ 64/255, 255/255,  64/255}, --工会
	{170/255, 170/255, 255/255}, --小队
	{255/255, 127/255,   0/255}, --RAID
	{210/255, 180/255, 140/255},  --1
	{160/255, 120/255,  90/255},  --2
	--{255/255, 255/255,   0/255},  --roll
	--{255/255,  64/255,  64/255}, --大喊
}
local ChannelColor = {
	{{255/255, 255/255, 255/255}, {242/255, 135/255, 79/255}, {255/255,  64/255,  64/255}},--说
	{{ 64/255, 255/255,  64/255}, { 64/255, 194/255,  58/255}},
	{{170/255, 170/255, 255/255}, {248/255, 129/255, 9/255}, {248/255, 129/255, 9/255}},
	{{255/255, 127/255,   0/255}, {239/255, 83/255,   34/255}},
	{{210/255, 180/255, 140/255}, {210/255, 180/255, 140/255}},
	{{210/255, 180/255, 140/255}, {210/255, 180/255, 140/255}, {210/255, 180/255, 140/255}}
}


local function ShowGameTip(self,i)
	GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
	GameTooltip:ClearLines()
	GameTooltip:AddLine(CHANNEL)
	GameTooltip:AddLine(" ")
	GameTooltip:AddDoubleLine(KEY_BUTTON1, Channel[i][1], 0.40, 0.78, 1, ChannelColor[i][1][1], ChannelColor[i][1][2], ChannelColor[i][1][3])
	GameTooltip:AddDoubleLine(KEY_BUTTON2, Channel[i][2], 0.40, 0.78, 1, ChannelColor[i][2][1], ChannelColor[i][2][2], ChannelColor[i][2][3])
	if Channel[i][3] then
		GameTooltip:AddDoubleLine(KEY_BUTTON3, Channel[i][3], 0.40, 0.78, 1, ChannelColor[i][3][1], ChannelColor[i][3][2], ChannelColor[i][3][3])
	end
	GameTooltip:Show()
end
function Module:BuildChatbar()
	local PreButton = nil
	local Parent = CreateFrame("Frame", nil, UIParent)
	Parent:SetAlpha(0)
	for i = 1, 6 do
		local Button = nil
		Button = CreateFrame("Button", nil, Parent)
		Button:RegisterForClicks("AnyUp")
		Button:SetScript("OnClick", function(self, b)
			if b == "LeftButton" then
				ChatFrame_OpenChat(Channel[i][1], SELECTED_DOCK_FRAME)
			elseif b == "RightButton" then
				ChatFrame_OpenChat(Channel[i][2], SELECTED_DOCK_FRAME)
			elseif Channel[i][3] and b == "MiddleButton" then
				ChatFrame_OpenChat(Channel[i][3], SELECTED_DOCK_FRAME)
			end
		end)
		Button:SetSize((ChatFrame1:GetWidth()-(4*5))/6, 6)
		local bg = Button:CreateTexture(nil, "BACKGROUND")
		bg:SetAllPoints(Button)
		bg:SetTexture(DB.Statusbar)
		S.CreateTop(bg, Color[i][1], Color[i][2], Color[i][3])
		Button:CreateShadow()
		Button:SetScript("OnEnter", function(self)
			UIFrameFadeIn(Parent, 0.5, Parent:GetAlpha(), 1)
			ShowGameTip(self,i)
		end)
		Button:SetScript("OnLeave", function(self)
			GameTooltip:Hide()
			UIFrameFadeOut(Parent, 0.5, self:GetAlpha(), 0)
		end)
		if i == 1 then
			Button:Point("TOPLEFT", ChatFrame1, "BOTTOMLEFT", 0, -7)
		else
			Button:SetPoint("LEFT", PreButton, "RIGHT", 4, 0)
		end
		PreButton = Button;
	end
end

function Module:OnEnable()
	Module:BuildChatbar()
end
