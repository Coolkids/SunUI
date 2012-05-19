local S, C, L, DB = unpack(SunUI)
local Core = LibStub("AceAddon-3.0"):GetAddon("Core")
local Module = Core:NewModule("InfoPanel-Time")
-- BuildClock
local function BuildClock()
	local Clock = CreateFrame("Frame", nil, UIParent)
	Clock.Text = S.MakeFontString(Clock, 14)
	Clock.Text:SetTextColor(DB.MyClassColor.r,DB.MyClassColor.g,DB.MyClassColor.b)
	Clock.Text:SetPoint("LEFT", BottomBar, "LEFT", 10, 2)
	Clock.Text:SetShadowOffset(S.mult, -S.mult)
	Clock.Text:SetShadowColor(0, 0, 0, 0.4)
	Clock:SetAllPoints(Clock.Text)
	Clock:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
		GameTooltip:ClearLines()
		GameTooltip:AddLine(date"%A, %B %d", 0.40, 0.78, 1)
		GameTooltip:AddLine(" ")
		GameTooltip:AddDoubleLine(TIMEMANAGER_TOOLTIP_LOCALTIME, GameTime_GetLocalTime(true), 0.75, 0.9, 1, 1, 1, 1)
		GameTooltip:AddDoubleLine(TIMEMANAGER_TOOLTIP_REALMTIME, GameTime_GetGameTime(true), 0.75, 0.9, 1, 1, 1, 1)
		GameTooltip:AddLine(" ")
		for i = 1, 2 do
			local _, localizedName, isActive, _, startTime, _ = GetWorldPVPAreaInfo(i)
			GameTooltip:AddDoubleLine(format(localizedName, ""), isActive and WINTERGRASP_IN_PROGRESS or startTime==0 and "N/A" or S.FormatTime(startTime), 0.75, 0.9, 1, 1, 1, 1)
		end
		local oneraid = false
			for i = 1, GetNumSavedInstances() do
				local name, _, reset, difficulty, locked, extended, _, isRaid, maxPlayers = GetSavedInstanceInfo(i)
				if isRaid and (locked or extended) then
					local tr, tg, tb, diff
					if not oneraid then
						GameTooltip:AddLine(" ")
						GameTooltip:AddLine(RAID_INFO, 0.75, 0.9, 1)
						oneraid = true
					end
					if extended then tr, tg, tb = 0.3, 1, 0.3 else tr, tg, tb = 1, 1, 1 end
					if difficulty == 3 or difficulty == 4 then diff = "H" else diff = "N" end
					GameTooltip:AddDoubleLine(format("%s |cffaaaaaa(%s%s)", name, maxPlayers, diff), S.FormatTime(reset), 1, 1, 1, tr, tg, tb)
				end
			end	
		GameTooltip:Show()
	end)
	Clock:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	Clock:SetScript("OnMouseDown", function(self, button)
		if button == "LeftButton" then
			ToggleTimeManager()
		elseif button == "RightButton" then
			ToggleCalendar()
		end
	end)
	Clock.Timer = 0
	Clock:SetScript("OnUpdate", function(self, elapsed)
		self.Timer = self.Timer + elapsed
		if self.Timer > 1 then
			self.Timer = 0
			local Text = GameTime_GetLocalTime(true)
			local index = Text:find(":")
			self.Text:SetText(Text:sub(index-2, index-1).." : "..Text:sub(index+1, index+2))
		end
	end)
	RequestRaidInfo()
	TimeManagerClockButton:Hide()
	GameTimeFrame:Hide()
end
function Module:OnEnable()
	if C["InfoPanelDB"]["OpenBottom"] == true then
		BuildClock()
	end
end