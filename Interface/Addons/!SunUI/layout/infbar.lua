
-- Engines
local S, C, L, DB = unpack(select(2, ...))
local Core = LibStub("AceAddon-3.0"):GetAddon("Core")
local Module = Core:NewModule("InfoPanel")
local InfoBarStatusColor = {{1, 0, 0}, {1, 1, 0}, {0, 0.4, 1}}
local CurrencyTable = {}
local bandwidthString = "%.2f Mbps"
local percentageString = "%.2f%%"
local Slots = {
	[1] = {1, L["头部"], 1000},
	[2] = {3, L["肩部"], 1000},
	[3] = {5, L["胸部"], 1000},
	[4] = {6, L["腰部"], 1000},
	[5] = {9, L["手腕"], 1000}, 
	[6] = {10, L["手"], 1000},
	[7] = {7, L["腿部"], 1000},
	[8] = {8, L["脚"], 1000},
	[9] = {16, L["主手"], 1000},
	[10] = {17, L["副手"], 1000}, 
	[11] = {18, L["远程"], 1000}
}

-- BuildClock
local function BuildClock()
	local Clock = CreateFrame("Frame", nil, UIParent)
	Clock.Text = S.MakeFontString(Clock, 14)
	Clock.Text:Point("RIGHT", MoveHandle.InfoPanel, "RIGHT")
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
	return Clock
end
-- BuildMemory
local MemoryTable = {}
local function RebuildAddonList(self)
	local addOnCount = GetNumAddOns()
	if addOnCount == #MemoryTable then return end
	MemoryTable = {}
	local a = 0
	for i = 1, addOnCount do MemoryTable[i] = {i, select(2, GetAddOnInfo(i)), 0, IsAddOnLoaded(i)} end
	
end
local function UpdateMemory()
	UpdateAddOnMemoryUsage()
	local addOnMem = 0
	local TotalMemory = 0
	for i = 1, #MemoryTable do
		addOnMem = GetAddOnMemoryUsage(MemoryTable[i][1])
		MemoryTable[i][3] = addOnMem
		TotalMemory = TotalMemory + addOnMem
	end
	table.sort(MemoryTable, function(a, b)
		if a and b then
			return a[3] > b[3]
		end
	end)
	return TotalMemory
end
local function BuildMemory(Anchor)
	local StatusBar = CreateFrame("StatusBar", nil, UIParent)
	StatusBar:Height(6)	
	StatusBar:Width(80)
	StatusBar:SetStatusBarTexture(DB.Statusbar)
	StatusBar:SetMinMaxValues(0, 30000)
	StatusBar:SetStatusBarColor(0, 0.4, 1, 0.6)
	StatusBar:Point("RIGHT", Anchor, "LEFT", -20, 0)
	StatusBar:CreateShadow("Background")
	StatusBar.Text = S.MakeFontString(StatusBar, 10)
	StatusBar.Text:Point("CENTER", 0, -5)
	StatusBar:SetScript("OnMouseDown", function(self)
		UpdateAddOnMemoryUsage()
		local Before = gcinfo()
		collectgarbage()
		UpdateAddOnMemoryUsage()
		print(format("|cff66C6FF%s:|r %s", L["共释放内存"], S.FormatMemory(Before - gcinfo())))
	end)
	StatusBar.Timer = 0
	StatusBar:SetScript("OnUpdate", function(self, elapsed)
		self.Timer = self.Timer + elapsed
		if self.Timer > 5 then
			RebuildAddonList(self)
			local total = UpdateMemory()
			self.Text:SetText(S.FormatMemory(total))
			StatusBar:SetValue(total)
			local r, g, b = S.ColorGradient((30000-total)/30000, InfoBarStatusColor[1][1], InfoBarStatusColor[1][2], InfoBarStatusColor[1][3], 
																					InfoBarStatusColor[2][1], InfoBarStatusColor[2][2], InfoBarStatusColor[2][3],
																					InfoBarStatusColor[3][1], InfoBarStatusColor[3][2], InfoBarStatusColor[3][3])
			self:SetStatusBarColor(r, g, b)
			self.Timer = 0
		end
	end)
	StatusBar:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
		GameTooltip:ClearLines()
		local maxadd = 0
		maxadd = #MemoryTable
		if IsAltKeyDown() then
				maxAddOns = #MemoryTable
				
			else
				maxAddOns = InfoPanelDB["MemNum"]
		end
		local TotalMemory = UpdateMemory()
		GameTooltip:AddDoubleLine(L["总共内存使用"], S.FormatMemory(TotalMemory), 0.4, 0.78, 1, 0.84, 0.75, 0.65)
		GameTooltip:AddLine(" ")
		local more = 0
		for i = 1, maxAddOns do
			if MemoryTable[i][4] then
			if  MemoryTable[i][3] <= 102.4 then r, g, b = 0, 1, 0 -- 0 - 100
				elseif  MemoryTable[i][3] <= 512 then r, g, b = 0.75, 1, 0 -- 100 - 512
				elseif  MemoryTable[i][3] <= 1024 then r, g, b = 1, 1, 0 -- 512 - 1mb
				elseif  MemoryTable[i][3] <= 2560 then r, g, b = 1, 0.75, 0 -- 1mb - 2.5mb
				elseif  MemoryTable[i][3] <= 5120 then r, g, b = 1, 0.5, 0 -- 2.5mb - 5mb
			end
			more = more + 1
				GameTooltip:AddDoubleLine(MemoryTable[i][2], S.FormatMemory(MemoryTable[i][3]), 1, 1, 1, r, g, b)
			end						
		end
		local moreMem = 0
			if not IsAltKeyDown() then
				for i = 11, GetNumAddOns() do
					if  MemoryTable[i][3] then
						moreMem = moreMem +  MemoryTable[i][3]
					end
				end
				local mor = 0
				mor = maxadd - more
				GameTooltip:AddDoubleLine(format("%d %s (%s)",mor,L["Hidden"],L["Alt"]),S.FormatMemory(moreMem),.6,.8,1,.6,.8,1)
			end
			GameTooltip:AddLine(" ")
			GameTooltip:AddDoubleLine(L["Default UI Memory Usage:"],S.FormatMemory(gcinfo() - TotalMemory),.6,.8,1,1,1,1)
			GameTooltip:AddDoubleLine(L["Total Memory Usage:"],S.FormatMemory(collectgarbage'count'),.6,.8,1,1,1,1)
		GameTooltip:Show()
	end)
	StatusBar:SetScript("OnLeave", function() GameTooltip:Hide() end)
	return StatusBar
end
-- BuildPing
local function BuildPing(Anchor)
	local StatusBar = CreateFrame("StatusBar", nil, UIParent)
	StatusBar:Height(6)	
	StatusBar:Width(80)
	StatusBar:SetStatusBarTexture(DB.Statusbar)
	StatusBar:SetMinMaxValues(0, 300)
	StatusBar:SetStatusBarColor(0, 0.4, 1, 0.6)
	StatusBar:Point("RIGHT", Anchor, "LEFT", -20, 0)
	StatusBar:CreateShadow("Background")
	StatusBar.Text = S.MakeFontString(StatusBar, 10)
	StatusBar.Text:Point("CENTER", 0, -5)
	StatusBar.Text:SetText("Ping: 0")
	StatusBar.Timer = 0
	StatusBar:SetScript("OnUpdate", function(self, elapsed)
		self.Timer = self.Timer + elapsed
		if self.Timer > 1 then
			local _, _, latencyHome, latencyWorld = GetNetStats()
			local value = (latencyHome > latencyWorld) and latencyHome or latencyWorld	
			self:SetValue(value)
			self.Text:SetText("Ping: "..value)			
			local r, g, b = S.ColorGradient((300-value)/300, InfoBarStatusColor[1][1], InfoBarStatusColor[1][2], InfoBarStatusColor[1][3], 
																		InfoBarStatusColor[2][1], InfoBarStatusColor[2][2], InfoBarStatusColor[2][3],
																		InfoBarStatusColor[3][1], InfoBarStatusColor[3][2], InfoBarStatusColor[3][3])
			self:SetStatusBarColor(r, g, b)
			self.Timer = 0
		end
	end)
	StatusBar:SetScript("OnEnter", function(self)
		local _, _, latencyHome, latencyWorld = GetNetStats()
		local bandwidth = GetAvailableBandwidth()
		local r1, g1, b1 = S.ColorGradient((300-latencyHome)/300, InfoBarStatusColor[1][1], InfoBarStatusColor[1][2], InfoBarStatusColor[1][3], 
																		InfoBarStatusColor[2][1], InfoBarStatusColor[2][2], InfoBarStatusColor[2][3],
																		InfoBarStatusColor[3][1], InfoBarStatusColor[3][2], InfoBarStatusColor[3][3])
		local r2, g2, b2 = S.ColorGradient((300-latencyWorld)/300, InfoBarStatusColor[1][1], InfoBarStatusColor[1][2], InfoBarStatusColor[1][3], 
																		InfoBarStatusColor[2][1], InfoBarStatusColor[2][2], InfoBarStatusColor[2][3],
																		InfoBarStatusColor[3][1], InfoBarStatusColor[3][2], InfoBarStatusColor[3][3])
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
		GameTooltip:ClearLines()
			GameTooltip:AddLine(L["延迟"], 0.4, 0.78, 1)
			GameTooltip:AddLine(" ")
		GameTooltip:AddDoubleLine(L["本地延迟"], latencyHome, 0.75, 0.9, 1, r1, g1, b1)
		GameTooltip:AddDoubleLine(L["世界延迟"], latencyWorld, 0.75, 0.9, 1, r2, g2, b2)
		if bandwidth ~= 0 then
		GameTooltip:AddDoubleLine(L["带宽"]..": " , string.format(bandwidthString, bandwidth),0.69, 0.31, 0.31,0.84, 0.75, 0.65)
		GameTooltip:AddDoubleLine(L["下载"]..": " , string.format(percentageString, GetDownloadedPercentage() *100),0.69, 0.31, 0.31, 0.84, 0.75, 0.65)
		GameTooltip:AddLine(" ")
	end
		GameTooltip:Show()
	end)
	StatusBar:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	return StatusBar
end
-- BuildDurability
local function BuildDurability(Anchor)
	local StatusBar = CreateFrame("StatusBar", nil, UIParent)
	StatusBar:Height(6)	
	StatusBar:Width(80)
	StatusBar:SetStatusBarTexture(DB.Statusbar)
	StatusBar:SetMinMaxValues(0, 100)
	StatusBar:SetStatusBarColor(0, 0.4, 1, 0.6)
	StatusBar:Point("RIGHT", Anchor, "LEFT", -20, 0)
	StatusBar:CreateShadow("Background")
	StatusBar.Text = S.MakeFontString(StatusBar, 10)
	StatusBar.Text:Point("CENTER", 0, -5)
	StatusBar:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
	StatusBar:RegisterEvent("MERCHANT_SHOW")
	StatusBar:RegisterEvent("PLAYER_ENTERING_WORLD")
	StatusBar:SetScript("OnEvent", function(self)
		local Total = 0
		for i = 1, 11 do
			if GetInventoryItemLink("player", Slots[i][1]) ~= nil then
				local durability, max = GetInventoryItemDurability(Slots[i][1])
				if durability then 
					Slots[i][3] = durability/max
					Total = Total + 1
				end
			end
		end
		table.sort(Slots, function(a, b) return a[3] < b[3] end)
		local value = floor(Slots[1][3]*100)
		self:SetValue(100-value)
		self.Text:SetText("D: "..value.."%")
		local r, g, b = S.ColorGradient(value/100, InfoBarStatusColor[1][1], InfoBarStatusColor[1][2], InfoBarStatusColor[1][3], 
																		InfoBarStatusColor[2][1], InfoBarStatusColor[2][2], InfoBarStatusColor[2][3],
																		InfoBarStatusColor[3][1], InfoBarStatusColor[3][2], InfoBarStatusColor[3][3])
		self:SetStatusBarColor(r, g, b)
	end)
	StatusBar:SetScript("OnEnter", function(self)
		if not InCombatLockdown() then
			GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT", 0, 0)
			GameTooltip:ClearLines()
			GameTooltip:AddLine(L["耐久度"], 0.4, 0.78, 1)
			GameTooltip:AddLine(" ")
			--[[for i = 1, 11 do
				if Slots[i][3] ~= 1000 then
					green = Slots[i][3]*2
					red = 1-green
					GameTooltip:AddDoubleLine(Slots[i][2], format("%d %%", floor(Slots[i][3]*100)), 1 , 1 , 1, red + 1, green, 0)
				end
			end--]]
			for i = 1, 11 do
				if Slots[i][3] ~= 1000 then
					green = Slots[i][3]/1
					red = 1-green
					GameTooltip:AddDoubleLine(Slots[i][2], format("%d %%", floor(Slots[i][3]*100)), 1 , 1 , 1, red, green, 0)
				end
			end
			GameTooltip:Show()
		end
	end)
	StatusBar:SetScript("OnLeave", function() GameTooltip:Hide() end)
	StatusBar:SetScript("OnMouseDown", function(self, button)
	ToggleCharacter("PaperDollFrame") end)
	return StatusBar
end

-- BuildCurrency
local function BuildCurrency(Anchor)
	local StatusBar = CreateFrame("StatusBar", "Currency", UIParent)
	StatusBar:Height(6)	
	StatusBar:Width(80)
	StatusBar:SetStatusBarTexture(DB.Statusbar)
	StatusBar:SetMinMaxValues(0, 99999)
	StatusBar:SetStatusBarColor(0, 0.4, 1, 0.6)
	StatusBar:Point("RIGHT", Anchor, "LEFT", -20, 0)
	StatusBar:CreateShadow("Background")
	StatusBar.Text = S.MakeFontString(StatusBar, 10)
	StatusBar.Text:Point("CENTER", 0, -5)
	StatusBar.Timer = 0
	StatusBar:SetScript("OnUpdate",function(self,elapsed)
		self.Timer = self.Timer + elapsed
		if self.Timer > 1 then
			self.Timer = 0
			local Gold = GetMoney()	
			self:SetValue(Gold/100/100)
		end
	end)
	return StatusBar
end

--BuildFPS
local function BuildFPS(Anchor)
local StatusBar = CreateFrame("StatusBar", "FPS", UIParent)
	StatusBar:Height(6)	
	StatusBar:Width(80)
	StatusBar:SetStatusBarTexture(DB.Statusbar)
	StatusBar:SetStatusBarColor(0, 0.4, 1, 0.6)
	StatusBar:Point("RIGHT", Anchor, "LEFT", -20, 0)
	StatusBar:CreateShadow("Background")
	StatusBar.Text = S.MakeFontString(StatusBar, 10)
	StatusBar.Text:Point("CENTER", 0, -5)
	StatusBar.Text:SetText("FPS: 0")
	StatusBar.LastUpdate = 1
	StatusBar:SetScript("OnUpdate", function(self, elapsed)
		self.LastUpdate = self.LastUpdate - elapsed
		if self.LastUpdate < 0 then
		self:SetMinMaxValues(0, 100)
		local value = floor(GetFramerate())
		local max = GetCVar("MaxFPS")
		self:SetValue(value)
		self.Text:SetText("FPS: "..value)
		local r, g, b = S.ColorGradient(value/100, InfoBarStatusColor[1][1], InfoBarStatusColor[1][2], InfoBarStatusColor[1][3], 
																		InfoBarStatusColor[2][1], InfoBarStatusColor[2][2], InfoBarStatusColor[2][3],
																		InfoBarStatusColor[3][1], InfoBarStatusColor[3][2], InfoBarStatusColor[3][3])
		self:SetStatusBarColor(r, g, b)
		self.LastUpdate = 1
		end
	end)
	StatusBar:SetScript("OnEnter", function(self)
		local value = floor(GetFramerate())
		local r, g, b = S.ColorGradient(value/100, 1, 0, 0, 0, 1, 0, 0, 0.4, 1)
		if not InCombatLockdown() then
			GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT", 0, 0)
			GameTooltip:ClearLines()
			GameTooltip:AddLine("FPS", 0.4, 0.78, 1)
			GameTooltip:AddLine(" ")
			GameTooltip:AddDoubleLine("FPS",value, 0.4, 0.78, 1, r, g, b)
			GameTooltip:Show()
		end
	end)
	StatusBar:SetScript("OnLeave", function() GameTooltip:Hide() end)
end

--BuildFriend
function BuildFriend()
	local StatusBar = CreateFrame("StatusBar", "Friend", UIParent)
		StatusBar:Height(6)	
		StatusBar:Width(80)
		StatusBar:SetStatusBarTexture(DB.Statusbar)
		StatusBar:SetStatusBarColor(0, 0.4, 1, 0.6)
		StatusBar:Point("RIGHT", "FPS", "LEFT", -20, 0)
		StatusBar:CreateShadow("Background")
		StatusBar.Text = S.MakeFontString(StatusBar, 10)
		StatusBar.Text:Point("CENTER", 0, -5)
end
--BuildGuild

local function BuildGuild()
	local StatusBar = CreateFrame("StatusBar", "Guild", UIParent)
		StatusBar:Height(6)	
		StatusBar:Width(80)
		StatusBar:SetStatusBarTexture(DB.Statusbar)
		StatusBar:SetStatusBarColor(0, 0.4, 1, 0.6)
		StatusBar:Point("RIGHT", "Friend", "LEFT", -20, 0)
		StatusBar:CreateShadow("Background")
		StatusBar.Text = S.MakeFontString(StatusBar, 10)
		StatusBar.Text:Point("CENTER", 0, -5)
end

function Module:OnInitialize()
	C = InfoPanelDB
end

function Module:OnEnable()
	local InfoPanelPos = CreateFrame("Frame", nil, UIParent)
	InfoPanelPos:Size(772, 20)
	InfoPanelPos:Hide()
	MoveHandle.InfoPanel = S.MakeMoveHandle(InfoPanelPos, L["信息面板"], "InfoPanel")
	local BottomInfoPanelPos = CreateFrame("Frame", nil, UIParent)
	BottomInfoPanelPos:Size(C["BottomWidth"], C["BottomHeight"])
	BottomInfoPanelPos:Hide()
	MoveHandle.BottomInfoPanelPos = S.MakeMoveHandle(BottomInfoPanelPos, L["信息面板"], "InfoPanel2")
	
	if C["OpenBottom"] == true then
	XP = CreateFrame("Frame", XP, UIParent)
	XP:Height(C["BottomHeight"])	
	XP:Width(C["BottomWidth"])
	XP:Point("BOTTOM", BottomInfoPanelPos, "BOTTOM", 0, 0)
	XP:SetFrameLevel(10)
	end
	
	if C["OpenTop"] == true then
	local Clock = BuildClock()
	local Durability = BuildDurability(Clock)
	local Currency = BuildCurrency(Durability)
	local Ping = BuildPing(Currency)
	local Memory = BuildMemory(Ping)
	local FPS = BuildFPS(Memory)
	local Friend = BuildFriend()
	local Guild = BuildGuild()
	end
end

