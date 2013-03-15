local S, L, DB, _, C = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("CombatNotification", "AceEvent-3.0")
local SunUIConfig = LibStub("AceAddon-3.0"):GetAddon("SunUI"):GetModule("SunUIConfig")
local wgtimenoti = true
local combatnoti = true
function Module:OnInitialize()
	C = SunUIConfig.db.profile.MiniDB
end
function Module:OnEnable()
	if not C["Combat"] then return end

	local GetNextChar = function(word,num)
		local c = word:byte(num)
		local shift
		if not c then return "",num end
			if (c > 0 and c <= 127) then
				shift = 1
			elseif (c >= 192 and c <= 223) then
				shift = 2
			elseif (c >= 224 and c <= 239) then
				shift = 3
			elseif (c >= 240 and c <= 247) then
				shift = 4
			end
		return word:sub(num,num+shift-1),(num+shift)
	end

	local updaterun = CreateFrame("Frame")

	local flowingframe = CreateFrame("Frame",nil,UIParent)
		flowingframe:SetFrameStrata("HIGH")
		flowingframe:SetPoint("CENTER",UIParent,0,230)
		flowingframe:SetHeight(64)
		flowingframe:SetScript("OnUpdate", FadingFrame_OnUpdate)
		flowingframe:Hide()
		flowingframe.fadeInTime = 0
		flowingframe.holdTime = 2
		flowingframe.fadeOutTime = .5
		
	local flowingtext = flowingframe:CreateFontString(nil,"OVERLAY")
		flowingtext:SetPoint("Left")
		flowingtext:SetFont(DB.Font,30*S.Scale(1),"OUTLINE")
		flowingtext:SetShadowOffset(0,0)
		flowingtext:SetJustifyH("LEFT")
		
	local rightchar = flowingframe:CreateFontString(nil,"OVERLAY")
		rightchar:SetPoint("LEFT",flowingtext,"RIGHT")
		rightchar:SetFont(DB.Font,50,"OUTLINE")
		rightchar:SetShadowOffset(0,0)
		rightchar:SetJustifyH("LEFT")

	local count,len,step,word,stringE,a

	local speed = .03333

	local nextstep = function()
		a,step = GetNextChar (word,step)
		flowingtext:SetText(stringE)
		stringE = stringE..a
		a = string.upper(a)
		rightchar:SetText(a)
	end

	local updatestring = function(self,t)
		count = count - t
			if count < 0 then
				if step > len then 
					self:Hide()
					flowingtext:SetText(stringE)
					FadingFrame_Show(flowingframe)
					rightchar:SetText("")
					word = ""
				else 
					nextstep()
					FadingFrame_Show(flowingframe)
					count = speed
				end
			end
	end

	updaterun:SetScript("OnUpdate",updatestring)
	updaterun:Hide()

	local EuiAlertRun = function(f,r,g,b)
		flowingframe:Hide()
		updaterun:Hide()
		
			flowingtext:SetText(f)
			local l = flowingtext:GetWidth()
			
		local color1 = r or 1
		local color2 = g or 1
		local color3 = b or 1
		
		flowingtext:SetTextColor(color1*.95,color2*.95,color3*.95)
		rightchar:SetTextColor(color1,color2,color3)
		
		word = f
		len = f:len()
		step = 1
		count = speed
		stringE = ""
		a = ""
		
			flowingtext:SetText("")
			flowingframe:SetWidth(l)
			
		rightchar:SetText("")
		FadingFrame_Show(flowingframe)
		updaterun:Show()
	end

	local CombatNotification = CreateFrame ("Frame")
	local L = {}
	if(GetLocale()=="zhCN") then
		L.INFO_WOWTIME_TIP4 = "进入战斗状态"
		L.INFO_WOWTIME_TIP5 = "离开战斗状态"
	elseif (GetLocale()=="zhTW") then
		L.INFO_WOWTIME_TIP4 = "進入戰鬥狀態"
		L.INFO_WOWTIME_TIP5 = "離開戰鬥狀態"
	else
		L.INFO_WOWTIME_TIP4 = "ENTERING COMBAT"
		L.INFO_WOWTIME_TIP5 = "LEAVING COMBAT"
	end

	if combatnoti == true then
		CombatNotification:RegisterEvent("PLAYER_REGEN_ENABLED")
		CombatNotification:RegisterEvent("PLAYER_REGEN_DISABLED")
		CombatNotification:SetScript("OnEvent", function (self,event)
			if (UnitIsDead("player")) then return end
			if event == "PLAYER_REGEN_ENABLED" then
				EuiAlertRun(L.INFO_WOWTIME_TIP5,0.1,1,0.1)
			else
				EuiAlertRun(L.INFO_WOWTIME_TIP4,1,0.1,0.1)
			end	
		end)
	end

	if wgtimenoti == true then

		local int = 1

		local clocks_update = function(self,t)
			int = int - t
			if int > 0 then return end
				
			int = 1
			local _,localizedName,_,canQueue,wgtime = GetWorldPVPAreaInfo(2)
			if(GetLocale()=="zhCN") then
				L.INFO_WOWTIME_TIP1 = localizedName.. "即将在1分钟内开始"
				L.INFO_WOWTIME_TIP2 = localizedName.. "即将在5分钟内开始"
				L.INFO_WOWTIME_TIP3 = localizedName.. "即将在15分钟内开始"
			elseif (GetLocale()=="zhTW") then
				L.INFO_WOWTIME_TIP1 = localizedName.. "即將在1分鐘內開始"
				L.INFO_WOWTIME_TIP2 = localizedName.. "即將在5分鐘內開始"
				L.INFO_WOWTIME_TIP3 = localizedName.. "即將在15分鐘內開始"
			else
				L.INFO_WOWTIME_TIP1 = localizedName.. "will start within 1 minute"
				L.INFO_WOWTIME_TIP2 = localizedName.. "will start within 5 minute"
				L.INFO_WOWTIME_TIP3 = localizedName.. "will start within 15 minute"
			end		
			if canQueue == false then
				if wgtime == 60 then 
					EuiAlertRun (L.INFO_WOWTIME_TIP1)
				elseif wgtime == 300 then 
					EuiAlertRun (L.INFO_WOWTIME_TIP2)
				elseif wgtime == 900 then 
					EuiAlertRun (L.INFO_WOWTIME_TIP3)
				end
			end
		end

		CombatNotification:SetScript("OnUpdate",clocks_update)
	end
end