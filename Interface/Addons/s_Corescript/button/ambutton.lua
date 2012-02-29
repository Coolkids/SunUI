local S, _, L, DB = unpack(s_Core)
if DB.Nuke == true then return end
local button = CreateFrame("Button", "ButtonA", ChatFrame1)
		button:Point("BOTTOMLEFT", ChatFrame1, "BOTTOMRIGHT", 5, 50)
		button:Size(20)
		button.text = button:CreateFontString(nil, 'OVERLAY')
		button.text:SetFont(DB.Font, 10*S.Scale(1), "THINOUTLINE")
		button.text:SetText("A")
		button.text:SetPoint("CENTER", 3, 0)
		button.text:SetTextColor(23/255, 132/255, 209/255)
		local click = 0 
		button:SetScript("OnMouseUp", function(self, button)
			if click == 0 then 
				stAddonManager:LoadWindow()
				click = 1 
			else
				stAddonManager:Hide()
				click = 0
			end
		end)
		button:SetScript("OnEnter",  function(self)
		GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
		GameTooltip:AddLine(L["插件管理"], 0.75, 0.9, 1)
		GameTooltip:AddLine("|cffDDA0DDSun|r|cff44CCFFUI|r"..""..L["插件管理"], 0.75, 0.9, 1)
		GameTooltip:Show()  end)
		button:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
		S.MakeBG(button, 0)
		S.Reskin(button)