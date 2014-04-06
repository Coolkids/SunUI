local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local

local AL = S:GetModule("MiniTools")
local resolution = GetCVar('gxResolution')
local screenheight = tonumber(string.match(resolution, "%d+x(%d+)"))
local isAfk = false
local altztop = CreateFrame("Frame", nil, WorldFrame)
local outaltz = CreateFrame("Frame", nil, altztop)
function AL:Init()
	altztop:SetFrameStrata("FULLSCREEN_DIALOG")
	altztop:SetHeight(80)
	altztop:SetPoint("LEFT", 0, -screenheight/4)
	altztop:SetPoint("RIGHT", 0, -screenheight/4)
	altztop:CreateShadow("Background")
	altztop.border:SetBackdropBorderColor(S.myclasscolor.r, S.myclasscolor.g, S.myclasscolor.b, 1)
	altztop.clock = altztop:CreateFontString(nil, "OVERLAY")
	altztop.clock:SetPoint("TOPRIGHT", altztop, "TOPRIGHT", -200, -10)
	altztop.clock:SetFont(S["media"].font, 20, "NONE")
	altztop.clock:SetTextColor(0.7, 0.7, 0.7)

	altztop.date = altztop:CreateFontString(nil, "OVERLAY")
	altztop.date:SetPoint("TOP", altztop.clock, "BOTTOM", 0, -3)
	altztop.date:SetFont(S["media"].font, 17, "NONE")
	altztop.date:SetTextColor(0.7, 0.7, 0.7)
	altztop.date:SetText(date"%A, %B %d")

	altztop.text = altztop:CreateFontString(nil, "OVERLAY")
	altztop.text:SetPoint("CENTER", altztop, "CENTER", 0, 25)
	altztop.text:SetFont(S["media"].font, 30, "NONE")
	altztop.text:SetText("|cffb3b3b3"..L["欢迎使用"].."|r|cff00d2ffSun|r|cffb3b3b3UI|r")

	altztop.logo = altztop:CreateFontString(nil, "OVERLAY")
	altztop.logo:SetPoint("LEFT", altztop, "LEFT", 30, -15)
	altztop.logo:SetFont(S["media"].font, 12, "NONE")
	altztop.logo:SetText("|cffb3b3b3SunUI @Coolkid 天空之牆-TW|r")

	altztop.afk = altztop:CreateFontString(nil, "OVERLAY")
	altztop.afk:SetPoint("TOP", altztop.text, "BOTTOM", 0, -5)
	altztop.afk:SetFont(S["media"].font, 24, "NONE")
	altztop.afk:SetText("|cffb3b3b3"..L["您现在处于"].."|r|cff00d2ffAFK|r|cffb3b3b3"..L["状态"].."|r")

	altztop.text2 = altztop:CreateFontString(nil, "OVERLAY")
	altztop.text2:SetPoint("BOTTOM", altztop, "BOTTOM", 0, 5)
	altztop.text2:SetFont(S["media"].font, 12, "NONE")
	altztop.text2:SetText("|cffb3b3b3"..L["点我解锁"].."|r")
	
	local interval = 0
	altztop:SetScript('OnUpdate', function(self, elapsed)
		interval = interval - elapsed
		if interval <= 0 then
			self.clock:SetText(format("%s:%s:%s",date("%H"),date("%M"),date("%S")))
			interval = .5
		end
	end)

	outaltz:SetAllPoints(altztop.text2)
	outaltz:SetParent(altztop)
	outaltz:SetScript("OnMouseDown", function(self)
		S:FadeOutFrame(altztop, 0.5)
		UIFrameFadeIn(UIParent, 1, UIParent:GetAlpha(), 0.5)
	end)

	altztop:Hide()
	altztop:SetAlpha(0)
end


function AL:PLAYER_FLAGS_CHANGED(event, unit)
	if unit ~= "player" then return end
	if UnitIsAFK("player") then
		altztop:Show()
		S:FadeOutFrame(UIParent, 0.5)
		UIFrameFadeIn(altztop, 1, 0, 1)
		isAfk = true
	else
		if isAfk then 
			S:FadeOutFrame(altztop, 0.5)
			UIFrameFadeIn(UIParent, 1, UIParent:GetAlpha(), 1)
		end
	end
end

local isInit = false
function AL:UpdateAFKSet()
	if not isInit then
		self:Init()
		isInit = true
	end
	if self.db.afklock then
		self:RegisterEvent("PLAYER_FLAGS_CHANGED")
	else
		self:UnregisterEvent("PLAYER_FLAGS_CHANGED")
	end
end