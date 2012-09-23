-- Engines
local S, C, L, DB = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("ChatFramePanel", "AceTimer-3.0")
local _G =_G
function Module:BuildChatbar()
	local Channel = {"/s ","/y ","/p ","/g ","/raid ","/1 ","/2 "}
	local Color = {
		{255/255, 255/255, 255/255}, 
		{255/255,  64/255,  64/255}, 
		{170/255, 170/255, 255/255}, 
		{ 64/255, 255/255,  64/255}, 
		{255/255, 127/255,   0/255}, 
		{210/255, 180/255, 140/255}, 
		{160/255, 120/255,  90/255}, 
		{255/255, 255/255,   0/255}, 
	}
	
	local PreButton = nil
	local Parent = CreateFrame("Frame", nil, UIParent)
	Parent:SetAlpha(0)
	for i = 1, 8 do
		local Button = nil
		if i <= 7 then
			Button = CreateFrame("Button", nil, Parent)
			Button:SetScript("OnClick", function()
				ChatFrame_OpenChat(Channel[i], chatFrame)
			end)
		end
		if i == 8 then
			Button = CreateFrame("Button", nil, Parent, "SecureActionButtonTemplate")
			Button:SetAttribute("*type*", "macro")
			Button:SetAttribute("macrotext", "/roll")
		end
		Button:SetSize((ChatFrame1:GetWidth()-14)/8, 4)
		Button:SetBackdrop({ 
			bgFile = DB.Statusbar, --insets = {left = 1, right = 1, top = 1, bottom = 2}, 
		})
		Button:SetBackdropColor(unpack(Color[i]))
		Button:CreateShadow()
		if C["MiniDB"]["ChatBarFade"] then 
			Button:SetScript("OnEnter", function(self)
				if InCombatLockdown() then return end
				UIFrameFadeIn(Parent, 2, Parent:GetAlpha(), 1)
			end)
			Button:SetScript("OnLeave", function(self)
				if InCombatLockdown() then return end
				UIFrameFadeOut(Parent, 2, self:GetAlpha(), 0)
			end)
		else
			Parent:SetAlpha(1)
		end
		if i == 1 then
			Button:Point("TOPLEFT", ChatFrame1, "BOTTOMLEFT", 0, -2)
		else
			Button:SetPoint("LEFT", PreButton, "RIGHT", 2, 0)
		end
		
		PreButton = Button;
	end
end

function Module:OnEnable()
	Module:BuildChatbar()
end
