local S, C, L, DB = unpack(select(2, ...))
local Core = LibStub("AceAddon-3.0"):GetAddon("Core")
local Module = Core:NewModule("bottomleftbarmail")


function Module:OnEnable()		
local Stat = CreateFrame("Frame")
Stat:EnableMouse(true)
Stat:SetFrameStrata("MEDIUM")
Stat:SetFrameLevel(3)

local text  = Stat:CreateFontString(nil, "OVERLAY")
text:SetFont(DB.Font, 12*S.Scale(1)*MiniDB["FontScale"], "THINOUTLINE")
text:SetShadowOffset(1.25, -1.25)
text:SetShadowColor(0, 0, 0, 0.4)
text:Point("BOTTOMLEFT", BottomLeftBar, "BOTTOMLEFT", 15, -8)
Stat:SetParent(BottomLeftBar)

local function Update(self)	
	local mail = HasNewMail()
	if mail == 1 then text:SetText(L["新邮件"]) else text:SetText(L["无邮件"]) end
	self:SetAllPoints(text)
end

local function ShowTooltip(self)

	GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
	GameTooltip:ClearLines()
		GameTooltip:AddLine(L["邮件"], 0.4, 0.78, 1)
		GameTooltip:AddLine(" ")
	local mail = HasNewMail()
	if mail == 1 then
		GameTooltip:AddLine(L["新邮件"],  0.75, 0.9, 1)
	else
		GameTooltip:AddLine(L["无邮件"], 0.75, 0.9, 1)
	end
	GameTooltip:Show()
end

Stat:RegisterEvent("CLOSE_INBOX_ITEM")
Stat:RegisterEvent("CLOSE_WORLD_MAP")
Stat:RegisterEvent("CHANNEL_COUNT_UPDATE")
Stat:RegisterEvent("MAIL_INBOX_UPDATE")
Stat:RegisterEvent("MAIL_CLOSED")
Stat:SetScript("OnEnter", function() ShowTooltip(Stat) end)
Stat:SetScript("OnLeave", function() GameTooltip:Hide() end)
Stat:SetScript("OnUpdate", Update)
Update(Stat)
end