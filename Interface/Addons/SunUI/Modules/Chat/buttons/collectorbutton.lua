local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local B = S:NewModule("Cbutton", "AceEvent-3.0", "AceHook-3.0", "AceConsole-3.0")
if S.zone ~= "zhTW" and S.zone ~= "zhCN" then return end
function B:CreateMainButton()
	local A = S:GetModule("Skins")
	local collectorButton = CreateFrame("Button", nil, UIParent)
	collectorButton:SetSize(15, 15)
	collectorButton:SetPoint("TOPLEFT", ChatFrame1, "TOPRIGHT", 5, 0)
	UIFrameFadeIn(collectorButton, 1, 1, 0.2)
	local collector = CreateFrame("Frame", "CollectorButton", UIParent)
	collector:SetWidth(45)
	collector:SetHeight(85)
	collector:SetPoint("TOPLEFT", collectorButton, "BOTTOMLEFT", -5, -5)
	collector:Hide()

	collectorButton.text = collectorButton:CreateFontString(nil, 'OVERLAY')
	collectorButton.text:SetFont(S["media"].font, S["media"].fontsize-2, "THINOUTLINE")
	collectorButton.text:SetText("B")
	collectorButton.text:SetPoint("CENTER")
	collectorButton.text:SetTextColor(23/255, 132/255, 209/255)
	collectorButton:SetScript("OnMouseUp", function(self)
		if not CollectorButton:IsShown() then 
			collector:Show()
			UIFrameFadeIn(collector, 0.5, collector:GetAlpha(), 1)
			local Timer = 0
			self:SetScript("OnUpdate", function(self, elasped)
				Timer = Timer + elasped
				if Timer > 6 then
					UIFrameFadeOut(collector, 0.5, collector:GetAlpha(), 0)
				end
				if Timer > 8 then
					collector:Hide()
				end
			end)
		else
			collector:Hide()
		end
	end)
	collectorButton:SetScript("OnEnter",  function(self)
			UIFrameFadeIn(self, 0.5, self:GetAlpha(), 1)
			GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
			GameTooltip:AddLine(L["按钮集合"])
			GameTooltip:Show()  
	end)
	collectorButton:SetScript("OnLeave", function(self) UIFrameFadeOut(self, 1, self:GetAlpha(), 0) GameTooltip:Hide() end)
	A:Reskin(collectorButton)
end

B.modName = L["其他按钮"]
function B:Info()
	return L["其他按钮"]
end

function B:Initialize()
	self:CreateMainButton()
	self:BigFootChannel()
	self:CreateRaidCheck()
	self:CreateStatReport()
	self:CreateEmoteTableFrame()
end

S:RegisterModule(B:GetName())