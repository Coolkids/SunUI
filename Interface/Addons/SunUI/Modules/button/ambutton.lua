local S, L, DB, _, C = unpack(select(2, ...))
if DB.zone ~= "zhTW" and DB.zone ~= "zhCN" then return end
local Module = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("ambutton", "AceTimer-3.0")
function Module:OnEnable()
	local button = CreateFrame("Button", "ButtonA",  ColectorButton)
	button:Point("BOTTOMRIGHT", ColectorButton, "BOTTOMRIGHT", -5, 5)
	button:Size(15)
	button.text = button:CreateFontString(nil, 'OVERLAY')
	button.text:SetFont(DB.Font, 10*S.Scale(1), "THINOUTLINE")
	button.text:SetText("A")
	button.text:SetPoint("CENTER", 3, 0)
	button.text:SetTextColor(23/255, 132/255, 209/255)
	local click = 0 
	button:SetScript("OnMouseUp", function(self, button)
		if not stAddonManager:IsShown() then 
			stAddonManager:LoadWindow()
		else
			stAddonManager:Hide()
		end
	end)
	button:SetScript("OnEnter",  function(self)
	GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
	GameTooltip:AddLine(L["插件管理"], 0.75, 0.9, 1)
	GameTooltip:AddLine("|cffDDA0DDSun|r|cff44CCFFUI|r"..""..L["插件管理"], 0.75, 0.9, 1)
	GameTooltip:Show()  end)
	button:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	S.Reskin(button)
end