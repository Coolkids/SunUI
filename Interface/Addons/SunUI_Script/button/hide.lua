local S, _, L, DB = unpack(SunUI)
if DB.Nuke == true then return end
local Module = LibStub("AceAddon-3.0"):GetAddon("Core"):NewModule("Hide", "AceTimer-3.0")
function Module:OnInitialize()
local button = CreateFrame("Button", "ButtonH", ColectorButton)
		button:Point("BOTTOM", ButtonA, "TOP", 0, 5)
		button:Size(15)
		button.text = button:CreateFontString(nil, 'OVERLAY')
		button.text:SetFont(DB.Font, 10*S.Scale(1), "THINOUTLINE")
		button.text:SetText("H")
		button.text:SetPoint("CENTER", 3, 0)
		button.text:SetTextColor(23/255, 132/255, 209/255)
		local click = 0 
		button:SetScript("OnMouseUp", function(self, button)
		
			if click == 0 then 
			tmp1,tmp2,tmp3,tmp4,tmp5 = NumerationFrame:GetPoint()
				ChatFrame1:Hide()
				ChatBarFrame:Hide()
				Minimap:Hide()
				XP:Hide()
				BottomLeftBar:Hide()
				ChatFrame1Tab:Hide()
				ChatFrame2Tab:Hide()
				self:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 10, 10)
				NumerationFrame:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -5, 5)
				click = 1 
			else
				ChatFrame1:Show()
				ChatBarFrame:Show()
				Minimap:Show()
				XP:Show()
				BottomLeftBar:Show()
				self:Point("BOTTOMLEFT", ChatFrame1, "BOTTOMRIGHT", 5, 0)
				NumerationFrame:SetPoint(tmp1,tmp2,tmp3,tmp4,tmp5)
				click = 0
			end
		end)
		button:SetScript("OnEnter",  function(self)
		GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
		GameTooltip:AddLine("隐藏模式", 0.75, 0.9, 1)
		GameTooltip:Show()  end)
		button:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
		S.MakeBG(button, 0)
		S.Reskin(button)
end