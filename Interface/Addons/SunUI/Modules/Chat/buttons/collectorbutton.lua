﻿local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local B = S:NewModule("Cbutton", "AceEvent-3.0", "AceHook-3.0", "AceConsole-3.0", "AceTimer-3.0")
if S.zone ~= "zhTW" and S.zone ~= "zhCN" then return end
local isFocus = false
local collectorButton = CreateFrame("Button", nil, UIParent)
local collector = CreateFrame("Frame", "CollectorButton", UIParent)

local function getFouse()
	local frame = GetMouseFocus():GetParent():GetName()
	if frame == "CollectorButton" or frame == "EmoteTableFrame" then
		isFocus = true
	else
		isFocus = false
	end
end

function B:CreateMainButton()
	local A = S:GetModule("Skins")
	
	collectorButton:SetSize(15, 15)
	collectorButton:SetPoint("TOPLEFT", ChatFrame1, "TOPRIGHT", 5, 0)
	collectorButton:SetAlpha(0.3)
	
	collector:SetWidth(45)
	collector:SetHeight(85)
	collector:SetPoint("TOPLEFT", collectorButton, "BOTTOMLEFT", -5, -5)
	collector.time = 0
	collector:Hide()

	collectorButton.text = collectorButton:CreateFontString(nil, 'OVERLAY')
	collectorButton.text:SetFont(S["media"].font, S["media"].fontsize-2, "THINOUTLINE")
	collectorButton.text:SetText(">")
	collectorButton.text:SetPoint("CENTER")
	collectorButton.text:SetTextColor(23/255, 132/255, 209/255)
	
	collectorButton:SetScript("OnMouseUp", function(self)
		if not CollectorButton:IsShown() then 
			S:ShowAnima(collector)
			self.Timer = B:ScheduleRepeatingTimer("CheckPoint", 1)
		else
			S:HideAnima(collector)
			collector.time = 0
			B:CancelTimer(self.Timer)
			UIFrameFadeOut(self, 0.3, self:GetAlpha(), 0.3)
		end
	end)
	collectorButton:SetScript("OnEnter",  function(self)
		GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
		GameTooltip:AddLine(L["按钮集合"])
		GameTooltip:Show()
		
		UIFrameFadeIn(self, 0.3, self:GetAlpha(), 1)
	end)
	collectorButton:SetScript("OnLeave", function(self) 
		GameTooltip:Hide()
	end)
	
	A:Reskin(collectorButton)
end

function B:CheckPoint()
  	local _, catch = pcall(getFouse)
	if catch then
		isFocus = false
	end
	if not isFocus then
		collector.time = collector.time + 1
	else
		collector.time = 0
	end
	if collector.time >= 5 then
		S:HideAnima(collector)
		collector.time = 0
		self:CancelTimer(collectorButton.Timer)
		UIFrameFadeOut(collectorButton, 0.3, collectorButton:GetAlpha(), 0.3)
	end
end

B.modName = L["其他按钮"]

function B:Initialize()
	self:CreateMainButton()
	self:BigFootChannel()
	self:CreateEmoteTableFrame()
	self:RegisterEvent("PLAYER_REGEN_DISABLED", function()
		S:FadeOutFrame(collectorButton, 0.3, false)
		if _G["EmoteTableFrame"] and _G["EmoteTableFrame"]:IsShown() then
			S:FadeOutFrame(EmoteTableFrame, 0.3, false)
		end
		if collector:IsShown() then
			S:FadeOutFrame(collector, 0.3, false)
		end
	end)	

	self:RegisterEvent("PLAYER_REGEN_ENABLED", function()
		collectorButton:Show()
		UIFrameFadeIn(collectorButton, 0.3, collectorButton:GetAlpha(), 1)
		
	end)
end

S:RegisterModule(B:GetName())