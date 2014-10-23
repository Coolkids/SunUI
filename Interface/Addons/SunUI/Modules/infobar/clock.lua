local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local IB = S:GetModule("InfoBar")
local week
if (GetLocale() == "zhTW" or GetLocale() == "zhCN") then
	week = {"星期天","星期一","星期二","星期三","星期四","星期五","星期六"}
else
	week = {"Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"}
end
function IB:CreateClock()
	local A = S:GetModule("Skins")
	local stat = CreateFrame("Frame", "InfoPanelBottom1", BottomInfoPanel or UIParent)
	stat:SetFrameStrata("BACKGROUND")
	stat:SetFrameLevel(3)
	stat:EnableMouse(true)

	stat.text = S:CreateFS(stat, nil, nil, IB.font)
	stat.text:SetPoint("LEFT", BottomInfoMoveHeader, "LEFT", 0, 0)
	stat:SetAllPoints(stat.text)
	
	stat.icon = stat:CreateTexture(nil, "OVERLAY")
	stat.icon:SetSize(8, 8)
	stat.icon:SetPoint("RIGHT", stat, "LEFT", -5, 0)
	stat.icon:SetTexture(IB.backdrop)
	stat.icon:SetVertexColor(unpack(IB.InfoBarStatusColor[3]))
	A:CreateShadow(stat, stat.icon)
	
	stat:SetScript("OnEnter", function(self)
		if InCombatLockdown() then return end
		local w,m,d,y = CalendarGetDate()
		GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
		GameTooltip:ClearLines()
		if (GetLocale() == "zhTW" or GetLocale() == "zhCN") then
			GameTooltip:AddLine(format("%s年%s月%s日 %s", y, m, d, week[w]), 0.40, 0.78, 1)
		else
			GameTooltip:AddLine(format("%s-%s-%s %s", m, d, y, week[w]), 0.40, 0.78, 1)
		end
		GameTooltip:AddLine(" ")
		GameTooltip:AddDoubleLine(TIMEMANAGER_TOOLTIP_LOCALTIME, GameTime_GetLocalTime(true), 0.75, 0.9, 1, 1, 1, 1)
		GameTooltip:AddDoubleLine(TIMEMANAGER_TOOLTIP_REALMTIME, GameTime_GetGameTime(true), 0.75, 0.9, 1, 1, 1, 1)
		GameTooltip:AddLine(" ")
		for i = 1, 2 do
			local _, localizedName, isActive, _, startTime, _ = GetWorldPVPAreaInfo(i)
			GameTooltip:AddDoubleLine(format(localizedName, ""), isActive and WINTERGRASP_IN_PROGRESS or startTime==0 and "N/A" or S:FormatTime(startTime), 0.75, 0.9, 1, 1, 1, 1)
		end
		local oneraid = false
		for i = 1, GetNumSavedInstances() do
			local name, _, reset, difficulty, locked, extended, _, isRaid, maxPlayers, diff = GetSavedInstanceInfo(i)
			if isRaid and (locked or extended) then
				local tr, tg, tb
				if not oneraid then
					GameTooltip:AddLine(" ")
					GameTooltip:AddLine(RAID_INFO, 0.75, 0.9, 1)
					oneraid = true
				end
				if extended then tr, tg, tb = 0.3, 1, 0.3 else tr, tg, tb = 1, 1, 1 end
				GameTooltip:AddDoubleLine(format("%s |cffaaaaaa(%s%s)", name, maxPlayers, diff), S:FormatTime(reset), 1, 1, 1, tr, tg, tb)
			end
		end
		local killbossnum = GetNumSavedWorldBosses()
		GameTooltip:AddLine(" ")
		if killbossnum == 0 then
			GameTooltip:AddLine(L["您没有击杀任何野外boss"], 1, 0.1, 0.1)
		else
			--GameTooltip:AddDoubleLine("您已经击杀的野外boss", "下次重置时间", 1, 1, 1, 1, 1, 1)
			for i=1, killbossnum do
				local name, _, reset = GetSavedWorldBossInfo(i)
				GameTooltip:AddDoubleLine(name, S:FormatTime(reset), 1, 1, 1, 1, 1, 1)
			end
		end
		GameTooltip:Show()
	end)
	stat:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	stat:SetScript("OnMouseDown", function(self, button)
		if button == "LeftButton" then
			ToggleTimeManager()
		elseif button == "RightButton" then
			ToggleCalendar()
		end
	end)
	stat.Timer = 0
	stat:SetScript("OnUpdate", function(self, elapsed)
		self.Timer = self.Timer + elapsed
		if self.Timer > 1 then
			self.Timer = 0
			local Text = GameTime_GetLocalTime(true)
			local index = Text:find(":")
			self.text:SetText(Text:sub(index-2, index-1).." : "..Text:sub(index+1, index+2))
		end
	end)
	RequestRaidInfo()
end