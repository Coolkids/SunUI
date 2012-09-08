local S, C, L, DB, _ = unpack(SunUI)
local Core = LibStub("AceAddon-3.0"):GetAddon("SunUI")
local Module = Core:NewModule("AFKLock")

local function AltzFrame()
	--新建框体
	local altztop = CreateFrame("Frame", nil, WorldFrame)
		altztop:SetFrameStrata("FULLSCREEN_DIALOG")
		altztop:SetHeight(80)
		altztop:SetPoint("TOP", 0, 3)
		altztop:SetPoint("LEFT")
		altztop:SetPoint("RIGHT")
		altztop:CreateShadow("Background")
		altztop.clock = altztop:CreateFontString(nil, "OVERLAY")
		altztop.clock:SetPoint("BOTTOMRIGHT", altztop, "BOTTOMRIGHT", -200, 10)
		altztop.clock:SetFont(DB.Font, 27, "NONE")
		altztop.clock:SetTextColor(0.7, 0.7, 0.7)
		
		altztop.date = altztop:CreateFontString(nil, "OVERLAY")
		altztop.date:SetPoint("BOTTOMRIGHT", altztop, "BOTTOMRIGHT", -200, 34)
		altztop.date:SetFont(DB.Font, 17, "NONE")
		altztop.date:SetTextColor(0.7, 0.7, 0.7)
		
		altztop.text = altztop:CreateFontString(nil, "OVERLAY")
		altztop.text:SetPoint("LEFT", altztop, "LEFT", 200, 6)
		altztop.text:SetFont(DB.Font, 32, "NONE")
		altztop.text:SetText("|cffb3b3b3欢迎使用|r|cff00d2ffSun|r|cffb3b3b3UI|r")
		
	local week = {"Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"}
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
		
	local altzcenter = CreateFrame("Frame", nil, WorldFrame)
		altzcenter:SetFrameStrata("FULLSCREEN")
		altzcenter:SetPoint("TOPLEFT")
		altzcenter:SetPoint("BOTTOMRIGHT")
		altzcenter:CreateShadow("UnitFrame")
	local altzbottom = CreateFrame("Frame", nil, WorldFrame)
		altzbottom:SetFrameStrata("FULLSCREEN_DIALOG")
		altzbottom:SetHeight(80)
		altzbottom:SetPoint("BOTTOM", 0, -3)
		altzbottom:SetPoint("LEFT")
		altzbottom:SetPoint("RIGHT")
		altzbottom:CreateShadow("Background")
		
		altzbottom.text = altzbottom:CreateFontString(nil, "OVERLAY")
		altzbottom.text:SetPoint("TOP", altzbottom, "TOP", 0, -10)
		altzbottom.text:SetFont(DB.Font, 28, "NONE")
		altzbottom.text:SetText("|cffb3b3b3您现在处于|r|cff00d2ffAFK|r|cffb3b3b3状态|r")
		
	--先隐藏
		altztop:Hide()
		altzcenter:Hide()
		altzbottom:Hide()
		altztop:SetAlpha(0)
		altzcenter:SetAlpha(0)
		altzbottom:SetAlpha(0)
	--隐藏
	local function FadeOutFrame()
			if altzbottom:GetAlpha()>0 then
				local fadeInfo = {}
				fadeInfo.mode = "OUT"
				fadeInfo.timeToFade = 2
				fadeInfo.finishedFunc = function() altzbottom:Hide() end  --隐藏并且终止update
				fadeInfo.startAlpha = altzbottom:GetAlpha()
				fadeInfo.endAlpha = 0
				UIFrameFade(altzbottom, fadeInfo)
			end 
			if altzcenter:GetAlpha()>0 then
				local fadeInfo = {}
				fadeInfo.mode = "OUT"
				fadeInfo.timeToFade = 2
				fadeInfo.finishedFunc = function() altzcenter:Hide() end	--隐藏并且终止update
				fadeInfo.startAlpha = altzcenter:GetAlpha()
				fadeInfo.endAlpha = 0
				UIFrameFade(altzcenter, fadeInfo)
			end 
			if altztop:GetAlpha()>0 then
				local fadeInfo = {}
				fadeInfo.mode = "OUT"
				fadeInfo.timeToFade = 2
				fadeInfo.finishedFunc = function() altztop:Hide() end	--隐藏并且终止update
				fadeInfo.startAlpha = altztop:GetAlpha()
				fadeInfo.endAlpha = 0
				UIFrameFade(altztop, fadeInfo)
			end 
	end
	local t = 0
	local launcher = CreateFrame("Frame")
	launcher:RegisterEvent("PLAYER_FLAGS_CHANGED")
	--手动离开
	local outaltz = CreateFrame("Frame")
	outaltz:SetAllPoints(altzbottom.text)
	outaltz:SetParent(altzbottom)
	outaltz:SetScript("OnMouseDown", function(self)
		FadeOutFrame()
		UIFrameFadeIn(UIParent, 3, UIParent:GetAlpha(), 1)
	end)
	--滚起来
	launcher:SetScript("OnEvent", function(self)
		if UnitAffectingCombat("player") then return end
		if UnitIsAFK("player") then 
			launcher:Show()
			t = 0
			local fadeInfo1 = {}
				fadeInfo1.mode = "OUT"
				fadeInfo1.timeToFade = 2
				fadeInfo1.finishedFunc = function() UIParent:Hide() end	--隐藏
				fadeInfo1.startAlpha = UIParent:GetAlpha()
				fadeInfo1.endAlpha = 0
				UIFrameFade(UIParent, fadeInfo1)
			self:SetScript("OnUpdate", function(self, elapsed) --update渐隐动画
				t = t + elapsed
				if t > 0.1 then
					altztop:Show()
					altzcenter:Show()
					altzbottom:Show()
					outaltz:Show()
				end
				if t > 1.7 then 
					UIFrameFadeIn(altztop, 3, 0, 1)
					UIFrameFadeIn(altzcenter, 3, 0, 1)
					UIFrameFadeIn(altzbottom, 3, 0, 1)
				end
				if t > 2 then
					launcher:Hide()		--隐藏并且终止update
				end
				--print("显示:"..t) --测试内存泄漏
			end)
		else
			launcher:Show()
			t = 0
			self:SetScript("OnUpdate", function(self, elapsed) --update渐隐动画
				t = t + elapsed
				if t > 0 then
					FadeOutFrame()
				end
				if t > 1.9 then 
					UIFrameFadeIn(UIParent, 3, UIParent:GetAlpha(), 1)
				end
				if t > 2 then
					launcher:Hide()		--隐藏并且终止update
				end
				--print("隐藏:"..t) --测试内存泄漏
			end)
		end
	end)
end

function Module:OnEnable()
	if C["MiniDB"]["IPhoneLock"] == true then
		AltzFrame()
	end
end