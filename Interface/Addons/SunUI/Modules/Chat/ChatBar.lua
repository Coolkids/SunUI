local S, C, L, DB = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("ChatFramePanel", "AceTimer-3.0")

function Module:BuildChatbar()
	local Channel = {
		{"/s", "/e ", "/y"},
		{"/g", "/o"},
		{"/p", "/bg"},
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
			UIFrameFadeIn(Parent, 1, Parent:GetAlpha(), 1)
		end)
		Button:SetScript("OnLeave", function(self)
			UIFrameFadeOut(Parent, 1, self:GetAlpha(), 0)
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
