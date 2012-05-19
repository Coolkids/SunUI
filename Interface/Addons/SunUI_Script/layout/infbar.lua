
-- Engines
local S, C, L, DB = unpack(SunUI)
local Core = LibStub("AceAddon-3.0"):GetAddon("Core")
local Module = Core:NewModule("InfoPanel")
local InfoBarStatusColor = {{1, 0, 0}, {1, 1, 0}, {0, 0.4, 1}}
local CurrencyTable = {}
local bandwidthString = "%.2f Mbps"
local percentageString = "%.2f%%"
local function AltUpdate(self)
	if not self.hovered then return end
	if IsAltKeyDown() and not self.altdown then self.altdown = true self:GetScript("OnEnter")(self)
	elseif not IsAltKeyDown() and self.altdown then self.altdown = false self:GetScript("OnEnter")(self) end
end
-- BuildMemory
local MemoryTable = {}
local function RebuildAddonList(self)
	local addOnCount = GetNumAddOns()
	if addOnCount == #MemoryTable then return end
	MemoryTable = {}
	for i = 1, addOnCount do 
		MemoryTable[i] = {i, select(2, GetAddOnInfo(i)), 0, IsAddOnLoaded(i)} 
	end
end
local function UpdateMemory()
	UpdateAddOnMemoryUsage()
	local addOnMem = 0
	local TotalMemory = 0
	local num = 0
	for i = 1, #MemoryTable do
		addOnMem = GetAddOnMemoryUsage(MemoryTable[i][1])
		MemoryTable[i][3] = addOnMem
		TotalMemory = TotalMemory + addOnMem
		if IsAddOnLoaded(i) then
		num = num + 1
		end
	end
	table.sort(MemoryTable, function(a, b)
		if a and b then
			return a[3] > b[3]
		end
	end)
	return TotalMemory, num
end
local function BuildMemory(Anchor)
	local StatusBar = CreateFrame("StatusBar", nil, UIParent)
	StatusBar:SetHeight(6)	
	StatusBar:SetWidth(40)
	--StatusBar:SetStatusBarTexture(DB.Statusbar)
	--StatusBar:SetMinMaxValues(0, 30000)
	--StatusBar:SetStatusBarColor(0, 0.4, 1, 0.6)
	StatusBar:SetPoint("LEFT", Anchor, "RIGHT", 13, 0)
	--StatusBar:CreateShadow("Background")
	StatusBar.Text = S.MakeFontString(StatusBar, 11)
	StatusBar.Text:SetPoint("CENTER")
	StatusBar.Text:SetShadowOffset(S.mult, -S.mult)
	StatusBar.Text:SetShadowColor(0, 0, 0, 0.4)
	StatusBar:SetScript("OnMouseDown", function(self, button)
		if button == "LeftButton" then 
			UpdateAddOnMemoryUsage()
			local Before = gcinfo()
			collectgarbage()
			UpdateAddOnMemoryUsage()
			print(format("|cff66C6FF%s:|r %s", L["共释放内存"], S.FormatMemory(Before - gcinfo())))
		else
		stAddonManager:LoadWindow()
		end
	end)
	StatusBar.Timer = 0
	StatusBar:SetScript("OnUpdate", function(self, elapsed)
		self.Timer = self.Timer + elapsed
		if self.Timer > 5 then
			RebuildAddonList(self)
			local total = UpdateMemory()
			local r, g, b = S.ColorGradient((30000-total)/30000, InfoBarStatusColor[1][1], InfoBarStatusColor[1][2], InfoBarStatusColor[1][3], 
																					InfoBarStatusColor[2][1], InfoBarStatusColor[2][2], InfoBarStatusColor[2][3],
																					InfoBarStatusColor[3][1], InfoBarStatusColor[3][2], InfoBarStatusColor[3][3])
			self.Text:SetText(S.ToHex(r, g, b)..format("%.2f", total/1024).."|r"..S.RGBToHex(DB.MyClassColor.r,DB.MyClassColor.g,DB.MyClassColor.b).." m|r")
			--StatusBar:SetValue(total)
			--self:SetStatusBarColor(r, g, b)
			self.Timer = 0
		end
		AltUpdate(self)
	end)
	StatusBar:SetScript("OnEnter", function(self)
			self.hovered = true
			GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
			GameTooltip:ClearLines()
			local TotalMemory, num = UpdateMemory()
			local maxadd = 0
			local maxAddOns
			maxadd = #MemoryTable
			if IsAltKeyDown() then
					maxAddOns = #MemoryTable
				else
					maxAddOns = math.min(C["MemNum"], #MemoryTable)
			end
			
			GameTooltip:AddDoubleLine(L["总共内存使用"], S.FormatMemory(TotalMemory), 0.4, 0.78, 1, 0.84, 0.75, 0.65)
			GameTooltip:AddLine(" ")
			GameTooltip:AddDoubleLine("Name","Use")
			local more = 0
			for i = 1, maxAddOns do
				if MemoryTable[i][4] then
				if  MemoryTable[i][3] <= 102.4 then r, g, b = 0, 1, 0 -- 0 - 100
					elseif  MemoryTable[i][3] <= 512 then r, g, b = 0.75, 1, 0 -- 100 - 512
					elseif  MemoryTable[i][3] <= 1024 then r, g, b = 1, 1, 0 -- 512 - 1mb
					elseif  MemoryTable[i][3] <= 2560 then r, g, b = 1, 0.75, 0 -- 1mb - 2.5mb
					elseif  MemoryTable[i][3] <= 5120 then r, g, b = 1, 0.5, 0 -- 2.5mb - 5mb
				end
					GameTooltip:AddDoubleLine(MemoryTable[i][2], S.FormatMemory(MemoryTable[i][3]), 1, 1, 1, r, g, b)
				end						
			end
			local moreMem = 0
				if not IsAltKeyDown() then
					for i = 1, GetNumAddOns() do
						if  MemoryTable[i][3] then
							moreMem = moreMem +  MemoryTable[i][3]
						end
					end
					local mor = 0
					mor = num - maxAddOns
					GameTooltip:AddDoubleLine(format("%d %s (%s)",mor,L["Hidden"],L["Alt"]),S.FormatMemory(moreMem),.6,.8,1,.6,.8,1)
				end
				GameTooltip:AddLine(" ")
				GameTooltip:AddDoubleLine(L["Default UI Memory Usage:"],S.FormatMemory(gcinfo() - TotalMemory),.6,.8,1,1,1,1)
				GameTooltip:AddDoubleLine(L["Total Memory Usage:"],S.FormatMemory(collectgarbage'count'),.6,.8,1,1,1,1)
				GameTooltip:Show()
	end)
	StatusBar:SetScript("OnLeave", function(self) GameTooltip:Hide() self.hovered = false  end)
	return StatusBar
end
-- BuildPing
local function BuildPing(Anchor)
	local StatusBar = CreateFrame("StatusBar", nil, UIParent)
	StatusBar:SetHeight(6)	
	StatusBar:SetWidth(40)
	--StatusBar:SetStatusBarTexture(DB.Statusbar)
	--StatusBar:SetMinMaxValues(0, 300)
	--StatusBar:SetStatusBarColor(0, 0.4, 1, 0.6)
	StatusBar:SetPoint("LEFT", Anchor, "RIGHT", 13, 0)
	--StatusBar:CreateShadow("Background")
	StatusBar.Text = S.MakeFontString(StatusBar, 11)
	StatusBar.Text:SetPoint("CENTER")
	StatusBar.Text:SetShadowOffset(S.mult, -S.mult)
	StatusBar.Text:SetShadowColor(0, 0, 0, 0.4)
	StatusBar.Text:SetText("Ping: 0")
	StatusBar.Timer = 0
	StatusBar:SetScript("OnUpdate", function(self, elapsed)
		self.Timer = self.Timer + elapsed
		if self.Timer > 5 then
			local _, _, latencyHome, latencyWorld = GetNetStats()
			local value = (latencyHome > latencyWorld) and latencyHome or latencyWorld	
			local r, g, b = S.ColorGradient((300-value)/300, InfoBarStatusColor[1][1], InfoBarStatusColor[1][2], InfoBarStatusColor[1][3], 
																		InfoBarStatusColor[2][1], InfoBarStatusColor[2][2], InfoBarStatusColor[2][3],
																		InfoBarStatusColor[3][1], InfoBarStatusColor[3][2], InfoBarStatusColor[3][3])
			--self:SetValue(value)
			self.Text:SetText(S.RGBToHex(DB.MyClassColor.r,DB.MyClassColor.g,DB.MyClassColor.b).."Ping: ".."|r"..S.ToHex(r, g, b)..value.."|r")			
			
			--self:SetStatusBarColor(r, g, b)
			self.Timer = 0
		end
	end)
	StatusBar:SetScript("OnEnter", function(self)
		 
		local _, _, latencyHome, latencyWorld = GetNetStats()
		local bandwidth = GetAvailableBandwidth()
		local r1, g1, b1 = S.ColorGradient(latencyHome/900, 0, 1, 0, 1, 1, 0, 1, 0, 0)
		local r2, g2, b2 = S.ColorGradient(latencyWorld/900, 0, 1, 0, 1, 1, 0, 1, 0, 0)
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
		GameTooltip:ClearLines()
			GameTooltip:AddLine(L["延迟"], 0.4, 0.78, 1)
			GameTooltip:AddLine(" ")
		GameTooltip:AddDoubleLine(L["本地延迟"], latencyHome.."ms", 0.75, 0.9, 1, r1, g1, b1)
		GameTooltip:AddDoubleLine(L["世界延迟"], latencyWorld.."ms", 0.75, 0.9, 1, r2, g2, b2)
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
-- local function BuildDurability(Anchor)
	-- local StatusBar = CreateFrame("StatusBar", nil, UIParent)
	-- StatusBar:SetHeight(6)	
	-- StatusBar:SetWidth(40)
	--StatusBar:SetStatusBarTexture(DB.Statusbar)
	--StatusBar:SetMinMaxValues(0, 100)
	--StatusBar:SetStatusBarColor(0, 0.4, 1, 0.6)
	-- StatusBar:SetPoint("LEFT", Anchor, "RIGHT", 13, 0)
	--StatusBar:CreateShadow("Background")
	-- StatusBar.Text = S.MakeFontString(StatusBar, 11)
	-- StatusBar.Text:SetPoint("CENTER")
	-- StatusBar.Text:SetShadowOffset(S.mult, -S.mult)
	-- StatusBar.Text:SetShadowColor(0, 0, 0, 0.4)
	-- StatusBar:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
	-- StatusBar:RegisterEvent("MERCHANT_SHOW")
	-- StatusBar:RegisterEvent("PLAYER_ENTERING_WORLD")
	-- StatusBar:SetScript("OnEvent", function(self)
		-- local Total = 0
		-- for i = 1, 11 do
			-- if GetInventoryItemLink("player", Slots[i][1]) ~= nil then
				-- local durability, max = GetInventoryItemDurability(Slots[i][1])
				-- if durability then 
					-- Slots[i][3] = durability/max
					-- Total = Total + 1
				-- end
			-- end
		-- end
		-- table.sort(Slots, function(a, b) return a[3] < b[3] end)
		-- local value = floor(Slots[1][3]*100)
		--self:SetValue(100-value)
		-- local r, g, b = S.ColorGradient(value/100, InfoBarStatusColor[1][1], InfoBarStatusColor[1][2], InfoBarStatusColor[1][3], 
																		-- InfoBarStatusColor[2][1], InfoBarStatusColor[2][2], InfoBarStatusColor[2][3],
																		-- InfoBarStatusColor[3][1], InfoBarStatusColor[3][2], InfoBarStatusColor[3][3])
		-- self.Text:SetText(S.RGBToHex(DB.MyClassColor.r,DB.MyClassColor.g,DB.MyClassColor.b).."D: ".."|r"..S.ToHex(r, g, b)..value.."|r".." %")
		--self:SetStatusBarColor(r, g, b)
	-- end)
	-- StatusBar:SetScript("OnEnter", function(self)
		-- if not InCombatLockdown() then
			-- GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT", 0, 0)
			-- GameTooltip:ClearLines()
			-- GameTooltip:AddLine(L["耐久度"], 0.4, 0.78, 1)
			-- GameTooltip:AddLine(" ")
			-- for i = 1, 11 do
				-- if Slots[i][3] ~= 1000 then
					-- green = Slots[i][3]/1
					-- red = 1-green
					-- GameTooltip:AddDoubleLine(Slots[i][2], format("%d %%", floor(Slots[i][3]*100)), 1 , 1 , 1, red, green, 0)
				-- end
			-- end
			-- GameTooltip:Show()
		-- end
	-- end)
	-- StatusBar:SetScript("OnLeave", function() GameTooltip:Hide() end)
	-- StatusBar:SetScript("OnMouseDown", function(self, button)
	-- ToggleCharacter("PaperDollFrame") end)
	-- return StatusBar
-- end

-- BuildCurrency
local function BuildCurrency(Anchor)
	local StatusBar = CreateFrame("StatusBar", "Currency", UIParent)
	StatusBar:SetHeight(6)	
	StatusBar:SetWidth(40)
	--StatusBar:SetStatusBarTexture(DB.Statusbar)
	--StatusBar:SetMinMaxValues(0, 99999)
	--StatusBar:SetStatusBarColor(0, 0.4, 1, 0.6)
	StatusBar:SetPoint("LEFT", Anchor, "RIGHT", 13, 0)
	--StatusBar:CreateShadow("Background")
	StatusBar.Text = S.MakeFontString(StatusBar, 12)
	StatusBar.Text:SetPoint("CENTER")
	StatusBar.Text:SetShadowOffset(S.mult, -S.mult)
	StatusBar.Text:SetShadowColor(0, 0, 0, 0.4)
	return StatusBar
end

--BuildFPS
local function BuildFPS(Anchor)
local StatusBar = CreateFrame("StatusBar", "FPS", UIParent)
	StatusBar:SetHeight(6)	
	StatusBar:SetWidth(40)
	--StatusBar:SetStatusBarTexture(DB.Statusbar)
	--StatusBar:SetStatusBarColor(0, 0.4, 1, 0.6)
	StatusBar:SetPoint("LEFT", MoveHandle.InfoPanel, "LEFT", 5, 0)
	--StatusBar:CreateShadow("Background")
	StatusBar.Text = S.MakeFontString(StatusBar, 11)
	StatusBar.Text:SetPoint("CENTER")
	StatusBar.Text:SetShadowOffset(S.mult, -S.mult)
	StatusBar.Text:SetShadowColor(0, 0, 0, 0.4)
	StatusBar.Text:SetText("FPS: 0")
	StatusBar.LastUpdate = 0
	StatusBar:SetScript("OnUpdate", function(self, elapsed)
		self.LastUpdate = self.LastUpdate + elapsed
		if self.LastUpdate > 5 then
		--self:SetMinMaxValues(0, 100)
		local value = floor(GetFramerate())
		local max = GetCVar("MaxFPS")
		--self:SetValue(value)
		local r, g, b = S.ColorGradient(value/100, InfoBarStatusColor[1][1], InfoBarStatusColor[1][2], InfoBarStatusColor[1][3], 
																		InfoBarStatusColor[2][1], InfoBarStatusColor[2][2], InfoBarStatusColor[2][3],
																		InfoBarStatusColor[3][1], InfoBarStatusColor[3][2], InfoBarStatusColor[3][3])
		self.Text:SetText(S.RGBToHex(DB.MyClassColor.r,DB.MyClassColor.g,DB.MyClassColor.b).."FPS: ".."|r"..S.ToHex(r, g, b)..value.."|r")
		--self:SetStatusBarColor(r, g, b)
		self.LastUpdate = 0
		end
	end)
	StatusBar:SetScript("OnEnter", function(self)
		 
		local value = floor(GetFramerate())
		local r, g, b = S.ColorGradient(value/100, 1, 0, 0, 1, 1, 0, 0, 1, 0)
		if not InCombatLockdown() then
			GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT", 0, 0)
			GameTooltip:ClearLines()
			GameTooltip:AddLine("System", 0.4, 0.78, 1)
			GameTooltip:AddLine(" ")
			GameTooltip:AddDoubleLine("FPS",value, 0.4, 0.78, 1, r, g, b)
			GameTooltip:Show()
		end
	end)
	StatusBar:SetScript("OnLeave", function() GameTooltip:Hide() end)
	return StatusBar
end

--BuildFriend
-- function BuildFriend(Anchor)
	-- local StatusBar = CreateFrame("StatusBar", "Friend", UIParent)
		-- StatusBar:SetHeight(6)	
		-- StatusBar:SetWidth(40)
		-- StatusBar:SetStatusBarTexture(DB.Statusbar)
		-- StatusBar:SetStatusBarColor(0, 0.4, 1, 0.6)
		-- StatusBar:SetPoint("LEFT", Anchor, "RIGHT", 15, 0)
		-- StatusBar:CreateShadow("Background")
		-- StatusBar.Text = S.MakeFontString(StatusBar, 11)
		-- StatusBar.Text:SetPoint("CENTER")
		-- StatusBar.Text:SetShadowOffset(S.mult, -S.mult)
		-- StatusBar.Text:SetShadowColor(0, 0, 0, 0.4)
	-- return StatusBar
-- end
--BuildGuild

--[[ local function BuildGuild(Anchor)
	local StatusBar = CreateFrame("StatusBar", "Guild", UIParent)
		StatusBar:SetHeight(6)	
		StatusBar:SetWidth(40)
		--StatusBar:SetStatusBarTexture(DB.Statusbar)
		--StatusBar:SetStatusBarColor(0, 0.4, 1, 0.6)
		StatusBar:SetPoint("LEFT", MoveHandle.InfoPanel, "LEFT")
		--StatusBar:CreateShadow("Background")
		StatusBar.Text = S.MakeFontString(StatusBar, 11)
		StatusBar.Text:SetPoint("CENTER")
		StatusBar.Text:SetShadowOffset(S.mult, -S.mult)
		StatusBar.Text:SetShadowColor(0, 0, 0, 0.4)
	return StatusBar
end ]]

function Module:OnInitialize()
	C = C["InfoPanelDB"]
	if C["OpenTop"] == true then
		local top = CreateFrame("Frame", nil, UIParent)
		top:SetHeight(20)
		top:SetFrameStrata("BACKGROUND")
		top:SetFrameLevel(0)
		top:CreateShadow("Background")
		top:SetPoint("TOP", 0, 3)
		top:SetPoint("LEFT")
		top:SetPoint("RIGHT")
	end
	local InfoPanelPos = CreateFrame("Frame", nil, UIParent)
	InfoPanelPos:SetSize(350, 12)
	InfoPanelPos:Hide()
	MoveHandle.InfoPanel = S.MakeMoveHandle(InfoPanelPos, L["信息面板"], "InfoPanel")
	
	if C["OpenBottom"] == true then
		local bottom = CreateFrame("Frame", "BottomBar", UIParent)
		bottom:SetHeight(20)
		bottom:SetFrameLevel(0)
		bottom:CreateShadow("Background")
		bottom:SetPoint("BOTTOM", 0, -3)
		bottom:SetPoint("LEFT")
		bottom:SetPoint("RIGHT")
	end

end

function Module:OnEnable()
	if C["OpenTop"] == true then
		local FPS = BuildFPS(Friend)
		local Memory = BuildMemory(FPS)
		local Ping = BuildPing(Memory)
		local Currency = BuildCurrency(Ping)
		--local Durability = BuildDurability(Currency)		
	end
end

