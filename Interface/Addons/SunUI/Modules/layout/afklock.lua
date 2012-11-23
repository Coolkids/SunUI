local S, C, L, DB = unpack(select(2, ...))
local Core = LibStub("AceAddon-3.0"):GetAddon("SunUI")
local Module = Core:NewModule("AFKLock")
local resolution = GetCVar('gxResolution')
local screenheight = tonumber(string.match(resolution, "%d+x(%d+)"))
local isAfk = false
local function AltzFrame()
	--新建框体
	local altztop = CreateFrame("Frame", nil, WorldFrame)
		altztop:SetFrameStrata("FULLSCREEN_DIALOG")
		altztop:SetHeight(80)
		altztop:SetPoint("LEFT", 0, -screenheight/4)
		altztop:SetPoint("RIGHT", 0, -screenheight/4)
		altztop:CreateShadow("Background")
		altztop.clock = altztop:CreateFontString(nil, "OVERLAY")
		altztop.clock:SetPoint("TOPRIGHT", altztop, "TOPRIGHT", -200, -10)
		altztop.clock:SetFont(DB.Font, 20, "NONE")
		altztop.clock:SetTextColor(0.7, 0.7, 0.7)
		
		altztop.date = altztop:CreateFontString(nil, "OVERLAY")
		altztop.date:SetPoint("TOP", altztop.clock, "BOTTOM", 0, -3)
		altztop.date:SetFont(DB.Font, 17, "NONE")
		altztop.date:SetTextColor(0.7, 0.7, 0.7)
		
		altztop.text = altztop:CreateFontString(nil, "OVERLAY")
		altztop.text:SetPoint("CENTER", altztop, "CENTER", 0, 25)
		altztop.text:SetFont(DB.Font, 30, "NONE")
		altztop.text:SetText("|cffb3b3b3"..L["欢迎使用"].."|r|cff00d2ffSun|r|cffb3b3b3UI|r")
		
		altztop.logo = altztop:CreateFontString(nil, "OVERLAY")
		altztop.logo:SetPoint("LEFT", altztop, "LEFT", 30, -10)
		altztop.logo:SetFont(DB.Font, 12, "NONE")
		altztop.logo:SetText("|cffb3b3b3SunUI @Coolkid 天空之牆-TW|r")
		
		altztop.url = altztop:CreateFontString(nil, "OVERLAY")
		altztop.url:SetPoint("TOP", altztop.logo, "BOTTOM", 0, -3)
		altztop.url:SetFont(DB.Font, 12, "NONE")
		altztop.url:SetText("|cffb3b3b3"..L["个人主页"].."http://url.cn/5YbLQe|r")
		
		altztop.afk = altztop:CreateFontString(nil, "OVERLAY")
		altztop.afk:SetPoint("TOP", altztop.text, "BOTTOM", 0, -5)
		altztop.afk:SetFont(DB.Font, 24, "NONE")
		altztop.afk:SetText("|cffb3b3b3"..L["您现在处于"].."|r|cff00d2ffAFK|r|cffb3b3b3"..L["状态"].."|r")
		
		altztop.text2 = altztop:CreateFontString(nil, "OVERLAY")
		altztop.text2:SetPoint("BOTTOM", altztop, "BOTTOM", 0, 5)
		altztop.text2:SetFont(DB.Font, 12, "NONE")
		altztop.text2:SetText("|cffb3b3b3"..L["点我解锁"].."|r")
		
	local week = {L["星期天"], L["星期一"], L["星期二"], L["星期三"], L["星期四"], L["星期五"], L["星期六"]}
	local w,m,d,y = CalendarGetDate()
	local interval = 0
	altztop:SetScript('OnUpdate', function(self, elapsed)
		interval = interval - elapsed
		if interval <= 0 then
			self.clock:SetText(format("%s:%s:%s",date("%H"),date("%M"),date("%S")))
			self.date:SetText(format("%s,%s/%s",week[w],m,d))
			interval = .5
		end
	end)
		
	--手动离开
	local outaltz = CreateFrame("Frame")
	outaltz:SetAllPoints(altztop.text2)
	outaltz:SetParent(altztop)
	outaltz:SetScript("OnMouseDown", function(self)
		S.FadeOutFrameDamage(altztop, 0.5)
		UIFrameFadeIn(UIParent, 1, UIParent:GetAlpha(), 1)
	end)
	--先隐藏
	altztop:Hide()
	altztop:SetAlpha(0)
	local launcher = CreateFrame("Frame")
	launcher:RegisterEvent("PLAYER_FLAGS_CHANGED")
	launcher:Hide()
	--滚起来
	launcher:SetScript("OnEvent", function(self)
		if UnitIsAFK("player") then
			altztop:Show()
			outaltz:Show()
			S.FadeOutFrameDamage(UIParent, 0.5)
			UIFrameFadeIn(altztop, 1, 0, 1)
			isAfk = true
		else
			if isAfk then 
				S.FadeOutFrameDamage(altztop, 0.5)
				UIFrameFadeIn(UIParent, 1, UIParent:GetAlpha(), 1)
			end
		end
	end)
end

function Module:OnEnable()
	if C["MiniDB"]["IPhoneLock"] == true then
		AltzFrame()
	end
end