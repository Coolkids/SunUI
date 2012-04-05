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
		GameTooltip:AddLine(L["新邮件"].."來自",  0.75, 0.9, 1)
		local sender1, sender2, sender3 = GetLatestThreeSenders()
		GameTooltip:AddLine(sender1)
		if sender2 then 
			GameTooltip:AddLine(sender2)
		end
		if sender3 then 
			GameTooltip:AddLine(sender3)
		end
	else
		GameTooltip:AddLine(L["无邮件"], 0.75, 0.9, 1)
	end
	GameTooltip:Show()
end

Stat:SetScript("OnEnter", function() ShowTooltip(Stat) end)
Stat:SetScript("OnLeave", function() GameTooltip:Hide() end)
Stat:SetScript("OnUpdate", Update)
Update(Stat)
end