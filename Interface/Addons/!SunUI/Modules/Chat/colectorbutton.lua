local S, _, _, DB = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("Core"):NewModule("Cbutton", "AceTimer-3.0")
function Module:OnInitialize()
local colectorbutton = CreateFrame("Button", nil, UIParent)
colectorbutton:Size(20)
colectorbutton:Point("TOPLEFT", ChatFrame1, "TOPRIGHT", 5, 0)
local colector = CreateFrame("Frame", "ColectorButton", colectorbutton)
colector:Width(60)
colector:Height(105)
colector:Point("TOPLEFT", colectorbutton, "BOTTOMLEFT", 0, -5)
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
		click = 0
		else
		colector:Hide()
		click = 1
	end
end)
colectorbutton:SetScript("OnEnter",  function(self)
		GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
		GameTooltip:AddLine("按钮集合")
		GameTooltip:Show()  
end)
colectorbutton:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
S.MakeBG(colectorbutton, 0)
S.Reskin(colectorbutton)
end