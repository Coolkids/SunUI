local S, _, _, DB = unpack(SunUI)
local Module = LibStub("AceAddon-3.0"):GetAddon("Core"):NewModule("Cbutton", "AceTimer-3.0")
function Module:OnInitialize()
local colectorbutton = CreateFrame("Button", nil, UIParent)
colectorbutton:Size(15)
colectorbutton:Point("TOPLEFT", ChatFrame1, "TOPRIGHT", 5, 0)
UIFrameFadeIn(colectorbutton, 5, 1, 0.2)
local colector = CreateFrame("Frame", "ColectorButton", UIParent)
colector:Width(45)
colector:Height(85)
colector:SetPoint("TOPLEFT", colectorbutton, "BOTTOMLEFT", -5, -5)
colector:Hide()

colectorbutton.text = colectorbutton:CreateFontString(nil, 'OVERLAY')
colectorbutton.text:SetFont(DB.Font, 10*S.Scale(1), "THINOUTLINE")
colectorbutton.text:SetText("B")
colectorbutton.text:SetPoint("CENTER", 3, 0)
colectorbutton.text:SetTextColor(23/255, 132/255, 209/255)
local click = 1
colectorbutton:SetScript("OnMouseUp", function(self)
	if click == 1 then 
		colector:Show()
		UIFrameFadeIn(colector, 0.5, colector:GetAlpha(), 1)
		click = 0
		local Timer = 0
		self:SetScript("OnUpdate", function(self, elasped)
			Timer = Timer + elasped
			if Timer > 6 then
				UIFrameFadeOut(colector, 2, colector:GetAlpha(), 0)
			end
			if Timer > 8 then
				colector:Hide()
				click = 1
				return click
			end
		end)
	else
		colector:Hide()
		click = 1
	end
end)

colectorbutton:SetScript("OnEnter",  function(self)
		UIFrameFadeIn(self, 2, self:GetAlpha(), 1)
		GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
		GameTooltip:AddLine("按钮集合")
		GameTooltip:Show()  
end)
colectorbutton:SetScript("OnLeave", function(self) UIFrameFadeOut(self, 2, self:GetAlpha(), 0) GameTooltip:Hide() end)
S.CreateBG(colectorbutton, 0)
S.Reskin(colectorbutton)
end