local S, L, DB, _, C = unpack(select(2, ...))
if DB.zone ~= "zhTW" and DB.zone ~= "zhCN" then return end
local Module = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("Cbutton", "AceTimer-3.0")
function Module:OnEnable()
	local colectorbutton = CreateFrame("Button", nil, UIParent)
	colectorbutton:Size(15)
	colectorbutton:Point("TOPLEFT", ChatFrame1, "TOPRIGHT", 5, 0)
	UIFrameFadeIn(colectorbutton, 1, 1, 0.2)
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
	colectorbutton:SetScript("OnMouseUp", function(self)
		if not ColectorButton:IsShown() then 
			colector:Show()
			UIFrameFadeIn(colector, 0.5, colector:GetAlpha(), 1)
			local Timer = 0
			self:SetScript("OnUpdate", function(self, elasped)
				Timer = Timer + elasped
				if Timer > 6 then
					UIFrameFadeOut(colector, 0.5, colector:GetAlpha(), 0)
				end
				if Timer > 8 then
					colector:Hide()
				end
			end)
		else
			colector:Hide()
		end
	end)
	colectorbutton:SetScript("OnEnter",  function(self)
			UIFrameFadeIn(self, 0.5, self:GetAlpha(), 1)
			GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
			GameTooltip:AddLine("按钮集合")
			GameTooltip:Show()  
	end)
	colectorbutton:SetScript("OnLeave", function(self) UIFrameFadeOut(self, 1, self:GetAlpha(), 0) GameTooltip:Hide() end)
	S.Reskin(colectorbutton)
end