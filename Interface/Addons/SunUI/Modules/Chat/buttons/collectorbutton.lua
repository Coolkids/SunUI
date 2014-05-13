local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local B = S:NewModule("Cbutton", "AceEvent-3.0", "AceHook-3.0", "AceConsole-3.0")
if S.zone ~= "zhTW" and S.zone ~= "zhCN" then return end
local isFocus = false
local collectorButton = CreateFrame("Button", nil, UIParent)
local collector = CreateFrame("Frame", "CollectorButton", UIParent)
local function getFouse()
	local frame = GetMouseFocus():GetParent():GetName()
	if frame == "CollectorButton" or frame == "EmoteTableFrame" then
		isFocus = true
		collectorButton.time = 0
	else
		isFocus = false
	end
end

function B:CreateMainButton()
	local A = S:GetModule("Skins")
	
	collectorButton:SetSize(15, 15)
	collectorButton:SetPoint("TOPLEFT", ChatFrame1, "TOPRIGHT", 5, 0)
	collectorButton:SetAlpha(0.3)
	
	collector:SetWidth(45)
	collector:SetHeight(85)
	collector:SetPoint("TOPLEFT", collectorButton, "BOTTOMLEFT", -5, -5)
	collector.time = 0
	collector:Hide()

	collectorButton.text = collectorButton:CreateFontString(nil, 'OVERLAY')
	collectorButton.text:SetFont(S["media"].font, S["media"].fontsize-2, "THINOUTLINE")
	collectorButton.text:SetText("B")
	collectorButton.text:SetPoint("CENTER")
	collectorButton.text:SetTextColor(23/255, 132/255, 209/255)
	collectorButton.time = 0
	
	collectorButton:SetScript("OnMouseUp", function(self)
		if not CollectorButton:IsShown() then 
			collector:Show()
			UIFrameFadeIn(collector, 0.3, collector:GetAlpha(), 1)
			collector:SetScript("OnUpdate", function(self, elasped)
				self.time = self.time + elasped
				if self.time > 1 then
					local _, catch = pcall(getFouse)
					if catch then
						isFocus = false
					end
					--S:Debug("collector:Call",isFocus, self.time)
					self.time = 0
				end
			end)
			collectorButton:SetScript("OnUpdate", function(self, elasped)
				if isFocus then return end
				self.time = self.time + elasped
				if self.time > 6 then
					--S:Debug("collectorButton:Call",self.time)
					S:FadeOutFrame(collector, 0.3, false)  
					collector:SetScript("OnUpdate", nil)
					self.time = 0
					self:SetScript("OnUpdate", nil)
				end
			end)
		else
			collector:SetScript("OnUpdate", nil)
			collectorButton:SetScript("OnUpdate", nil)
			S:FadeOutFrame(collector, 0.3, false)
			collectorButton.time = 0
		end
	end)
	collectorButton:SetScript("OnEnter",  function(self)
		GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
		GameTooltip:AddLine(L["按钮集合"])
		GameTooltip:Show()  
			
		UIFrameFadeIn(collectorButton, 0.3, collector:GetAlpha(), 1)
	end)
	collectorButton:SetScript("OnLeave", function(self) 
		GameTooltip:Hide() 
		UIFrameFadeOut(collectorButton, 0.3, collector:GetAlpha(), 0.3)
	end)
	
	A:Reskin(collectorButton)
end

B.modName = L["其他按钮"]

function B:Initialize()
	self:CreateMainButton()
	self:BigFootChannel()
	self:CreateRaidCheck()
	self:CreateStatReport()
	self:CreateEmoteTableFrame()
	self:RegisterEvent("PLAYER_REGEN_DISABLED", function()
		S:FadeOutFrame(collectorButton, 0.3, false)
		if _G["EmoteTableFrame"] and _G["EmoteTableFrame"]:IsShown() then
			S:FadeOutFrame(EmoteTableFrame, 0.3, false)
		end
		if collector:IsShown() then
			S:FadeOutFrame(collector, 0.3, false)
		end
	end)	

	self:RegisterEvent("PLAYER_REGEN_ENABLED", function()
		collectorButton:Show()
		UIFrameFadeIn(collectorButton, 0.3, collectorButton:GetAlpha(), 1)
		
	end)
end

S:RegisterModule(B:GetName())