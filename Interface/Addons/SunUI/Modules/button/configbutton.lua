local S, L, DB, _, C = unpack(select(2, ...))
local CB = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("CB", "AceTimer-3.0")
if DB.zone ~= "zhTW" and DB.zone ~= "zhCN" then return end
function CB:OnEnable()
local Module = LibStub("AceAddon-3.0"):GetAddon("SunUI"):GetModule("SunUIConfig", "AceConsole-3.0")
local AceConfigDialog = LibStub and LibStub("AceConfigDialog-3.0", true)
local button = CreateFrame("Button", "ButtonS", ColectorButton)
		button:Point("BOTTOMLEFT", ColectorButton, "BOTTOMLEFT", 5, 5)
		button:Size(15)
		button.text = button:CreateFontString(nil, 'OVERLAY')
		button.text:SetFont(DB.Font, 10*S.Scale(1), "THINOUTLINE")
		button.text:SetText("S")
		button.text:SetPoint("CENTER", 3, 0)
		button.text:SetTextColor(23/255, 132/255, 209/255)
		local click = 0
		button:SetScript("OnMouseUp", function(self, button)
			if click == 0 then 
				Module:ShowConfig()
				click = 1 
			else
				AceConfigDialog:CloseAll()
				click = 0
			end
				
		end)
		button:SetScript("OnEnter",  function(self)
		GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
		GameTooltip:AddLine("控制台", 0.75, 0.9, 1)
		GameTooltip:AddLine("点击显示控制台")
		GameTooltip:Show()  end)
		button:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
		S.Reskin(button)
end