
-- Engines
local S, C, L, DB, _ = unpack(SunUI)
local Core = LibStub("AceAddon-3.0"):GetAddon("SunUI")
local Module = Core:NewModule("InfoPanelTop")
local InfoBarStatusColor = {{1, 0, 0}, {1, 1, 0}, {0, 0.4, 1}}
local bandwidthString = "%.2f Mbps"
local percentageString = "%.2f%%"

--BuildSystem
local function BuildSystem()
local Stat = CreateFrame("Frame", "InfoPanel1", UIParent)
	Stat:SetFrameStrata("BACKGROUND")
	Stat:SetFrameLevel(3)
	Stat:EnableMouse(true)
	
	local Text = S.MakeFontString(Stat, 11)
	Text:SetPoint("LEFT", InfoPanelPos)
	Text:SetShadowOffset(S.mult, -S.mult)
	Text:SetShadowColor(0, 0, 0, 0.4)
	
	Stat:SetAllPoints(Text)
	local function colorlatency(latency)
		if latency < 300 then
			return "|cff0CD809"..latency
		elseif (latency >= 300 and latency < 500) then
			return "|cffE8DA0F"..latency
		else
			return "|cffD80909"..latency
		end
	end
	local int = 1
	local function Update(self, t)
		int = int - t
		local fpscolor
		local latencycolor

		if int < 0 then
			local _, _, latencyHome, latencyWorld = GetNetStats()
			if floor(GetFramerate()) >= 30 then
				fpscolor = "|cff0CD809"
			elseif (floor(GetFramerate()) > 15 and floor(GetFramerate()) < 30) then
				fpscolor = "|cffE8DA0F"
			else
				fpscolor = "|cffD80909"
			end
			Text:SetText(fpscolor..floor(GetFramerate()).."|r".."fps  "..colorlatency(latencyHome).."|r/"..colorlatency(latencyWorld).."|r".."ms")
			int = 0.8
		end
	end
	Stat:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 6);
		GameTooltip:ClearAllPoints()
		GameTooltip:SetPoint("BOTTOM", self, "TOP", 0, 1)
		GameTooltip:ClearLines()
		GameTooltip:AddLine("System",0,.6,1)
		GameTooltip:AddLine(" ")
	
		local _, _, latencyHome, latencyWorld = GetNetStats()
		local bandwidth = GetAvailableBandwidth()
		local r1, g1, b1 = S.ColorGradient(latencyHome/900, 0, 1, 0, 1, 1, 0, 1, 0, 0)
		local r2, g2, b2 = S.ColorGradient(latencyWorld/900, 0, 1, 0, 1, 1, 0, 1, 0, 0)
		GameTooltip:ClearLines()
		GameTooltip:AddLine(L["延迟"], 0.4, 0.78, 1)
		GameTooltip:AddLine(" ")
		GameTooltip:AddDoubleLine(L["本地延迟"], latencyHome.."ms", 0.75, 0.9, 1, r1, g1, b1)
		GameTooltip:AddDoubleLine(L["世界延迟"], latencyWorld.."ms", 0.75, 0.9, 1, r2, g2, b2)
		if bandwidth ~= 0 then
			GameTooltip:AddDoubleLine(L["带宽"]..": " , string.format("%.2f Mbps", bandwidth),0.69, 0.31, 0.31,0.84, 0.75, 0.65)
			GameTooltip:AddDoubleLine(L["下载"]..": " , string.format("%.2f%%", GetDownloadedPercentage() *100),0.69, 0.31, 0.31, 0.84, 0.75, 0.65)
			GameTooltip:AddLine(" ")
		end
		GameTooltip:Show()
	end)
	Stat:SetScript("OnLeave", function() GameTooltip:Hide() end)
	Stat:SetScript("OnUpdate", Update) 
end
-- BuildMemory
local tTotal, tMem
local function RefreshText()
	UpdateAddOnMemoryUsage()
	tTotal = 0
	for i = 1, GetNumAddOns() do
		tMem = GetAddOnMemoryUsage(i)
		tTotal = tTotal + tMem
	end
end
local function BuildMemory()
	local Stat = CreateFrame("Frame", "InfoPanel2", UIParent)
	Stat:SetFrameStrata("BACKGROUND")
	Stat:SetFrameLevel(3)
	Stat:EnableMouse(true)
	
	local Text = S.MakeFontString(Stat, 11)
	Text:SetPoint("LEFT", InfoPanel1, "RIGHT", 2, 0)
	Text:SetShadowOffset(S.mult, -S.mult)
	Text:SetShadowColor(0, 0, 0, 0.4)
	
	Stat:SetAllPoints(Text)
	Stat:SetScript("OnMouseDown", function(self, button)
		if button == "LeftButton" then 
			UpdateAddOnMemoryUsage()
			local Before = gcinfo()
			collectgarbage()
			UpdateAddOnMemoryUsage()
			print(format("|cff66C6FF%s:|r %s", L["共释放内存"], S.FormatMemory(Before - gcinfo())))
			RefreshText()
			local color = tTotal/1024 <= 102.4 and {0,1} -- 1
				or tTotal/1024 <= 512 and {0.75,1} -- 5
				or tTotal/1024 <= 1024 and {1,1} -- 12
				or tTotal/1024 <= 2560 and {1,0.75} -- 18
				or tTotal/1024 <= 5120 and {1,0.5} -- 25
				or {1,0.1}
			Text:SetText(string.format("|cff%02x%02x%02x", color[1]*255, color[2]*255, 0)..format("%.2f", tTotal/1024).."|rm")
		else
			if stAddonManager:IsShown() then 
				stAddonManager:Hide()
				stAddonManager:UnregisterAllEvents()
			else
				stAddonManager:LoadWindow()
			end
		end
	end)
	Stat.Timer = 0
	Stat:SetScript("OnUpdate", function(self, elapsed)
		self.Timer = self.Timer + elapsed
		if self.Timer > 5 then
			RefreshText()
			local color = tTotal/1024 <= 1 and {0,1} -- 1
				or tTotal/1024 <= 5 and {0.75,1} -- 5
				or tTotal/1024 <= 12 and {1,1} -- 12
				or tTotal/1024 <= 18 and {1,0.75} -- 18
				or tTotal/1024 <= 25 and {1,0.5} -- 25
				or {1,0.1}
			Text:SetText(string.format("|cff%02x%02x%02x", color[1]*255, color[2]*255, 0)..format("%.2f", tTotal/1024).."|rm")
			self.Timer = 0
		end
	end)
	Stat:SetScript("OnEnter", function(self)
		UpdateAddOnMemoryUsage()
		local memory = {}
		local total = 0
		for i = 1, GetNumAddOns() do
			if IsAddOnLoaded(i) then
				local mem = GetAddOnMemoryUsage(i)
				tinsert (memory, {select(2, GetAddOnInfo(i)), mem})
				total = total + mem
			end
		end
		table.sort(memory, function(a, b)
			return a[2] > b[2]
		end)
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
		GameTooltip:AddDoubleLine('Mem Total Usage', S.FormatMemory(total), .6,.8,1, 1, 1, 1)
		GameTooltip:AddLine(' ')
		for i = 1, #memory do
			local color = memory[i][2] <= 102.4 and {0,1} -- 0 - 100
				or memory[i][2] <= 512 and {0.75,1} -- 100 - 512
				or memory[i][2] <= 1024 and {1,1} -- 512 - 1mb
				or memory[i][2] <= 2560 and {1,0.75} -- 1mb - 2.5mb
				or memory[i][2] <= 5120 and {1,0.5} -- 2.5mb - 5mb
				or {1,0.1}
			GameTooltip:AddDoubleLine(memory[i][1], S.FormatMemory(memory[i][2]), 1, 1, 1, color[1], color[2], 0)
		end
		GameTooltip:Show()
	end)
	Stat:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
end
-- BuildGold
local function BuildGold()
	local Stat = CreateFrame("Frame", "InfoPanel3", UIParent)
	Stat:SetFrameStrata("BACKGROUND")
	Stat:SetFrameLevel(3)
	Stat:EnableMouse(true)
	
	local Text = S.MakeFontString(Stat, 12)
	Text:SetPoint("LEFT", InfoPanel2, "RIGHT", 2, 0)
	Text:SetShadowOffset(S.mult, -S.mult)
	Text:SetShadowColor(0, 0, 0, 0.4)
	Stat:SetAllPoints(Text)
	
	local Profit	= 0
	local Spent		= 0
	local OldMoney	= 0

	local function formatMoney(money)
		local gold = floor(math.abs(money) / 10000)
		local silver = mod(floor(math.abs(money) / 100), 100)
		local copper = mod(floor(math.abs(money)), 100)
		if gold ~= 0 then
			return format("%s".."|cffffd700g|r".." %s".."|cffc7c7cfs|r".." %s".."|cffeda55fc|r", gold, silver, copper)
		elseif silver ~= 0 then
			return format("%s".."|cffc7c7cfs|r".." %s".."|cffeda55fc|r", silver, copper)
		else
			return format("%s".."|cffeda55fc|r", copper)
		end
	end
	
	local function formatTextMoney(money)
		return format("%.0f|cffffd700%s|r", money * 0.0001, "g")
	end

	local function FormatTooltipMoney(money)
		local gold, silver, copper = abs(money / 10000), abs(mod(money / 100, 100)), abs(mod(money, 100))
		local cash = ""
		cash = format("%d".."|cffffd700g|r".." %d".."|cffc7c7cfs|r".." %d".."|cffeda55fc|r", gold, silver, copper)		
		return cash
	end	

	local function OnEvent(self, event)
		if event == "PLAYER_ENTERING_WORLD" then
			OldMoney = GetMoney()
		end
		
		local NewMoney	= GetMoney()
		local Change = NewMoney-OldMoney -- Positive if we gain money
		
		if OldMoney > NewMoney then		-- Lost Money
			Spent = Spent - Change
		else							-- Gained Moeny
			Profit = Profit + Change
		end
		
		Text:SetText(formatTextMoney(NewMoney))
		-- Setup Money Tooltip
		self:SetAllPoints(Text)

		local myPlayerRealm = GetCVar("realmName");
		local myPlayerName  = UnitName("player");				
		if (SunUIConfig == nil) then SunUIConfig = {}; end
		if (SunUIConfig.gold == nil) then SunUIConfig.gold = {}; end
		if (SunUIConfig.gold[myPlayerRealm]==nil) then SunUIConfig.gold[myPlayerRealm]={}; end
		SunUIConfig.gold[myPlayerRealm][myPlayerName] = GetMoney();
		self:SetScript("OnEnter", function()
			 
				GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
				self.hovered = true 
				GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 6);
				GameTooltip:ClearAllPoints()
				GameTooltip:SetPoint("BOTTOM", self, "TOP", 0, 1)
				GameTooltip:ClearLines()
				GameTooltip:AddLine(CURRENCY,0,.6,1)
				GameTooltip:AddLine(" ")
				GameTooltip:AddLine("目前: ",.6,.8,1)
				GameTooltip:AddDoubleLine("收入:", formatMoney(Profit), 1, 1, 1, 0, 1, 0)
				GameTooltip:AddDoubleLine("花费:", formatMoney(Spent), 1, 1, 1, 1, 0, 0)
				if Profit < Spent then
					GameTooltip:AddDoubleLine("亏损:", formatMoney(Profit-Spent), 1, 1, 1, 1, 0, 0)
				elseif (Profit-Spent)>0 then
					GameTooltip:AddDoubleLine("利润:", formatMoney(Profit-Spent), 1, 1, 1, 0, 1, 0)
				end				
				GameTooltip:AddLine' '								
			
				local totalGold = 0				
				GameTooltip:AddLine("当前ID: ",.6,.8,1)			
				local thisRealmList = SunUIConfig.gold[myPlayerRealm];
				for k,v in pairs(thisRealmList) do
					GameTooltip:AddDoubleLine(k, FormatTooltipMoney(v), 1, 1, 1, 1, 1, 1)
					totalGold=totalGold+v;
				end 
				GameTooltip:AddLine' '
				GameTooltip:AddLine("服务器: ",.6,.8,1)
				GameTooltip:AddDoubleLine("总计: ", FormatTooltipMoney(totalGold), 1, 1, 1, 1, 1, 1)

				for i = 1, MAX_WATCHED_TOKENS do
					local name, count, extraCurrencyType, icon, itemID = GetBackpackCurrencyInfo(i)
					if name and i == 1 then
						GameTooltip:AddLine(" ")
						GameTooltip:AddLine(CURRENCY)
					end
					local r, g, b = 1,1,1
					if itemID then r, g, b = GetItemQualityColor(select(3, GetItemInfo(itemID))) end
					if name and count then GameTooltip:AddDoubleLine(name, count, r, g, b, 1, 1, 1) end
				end
				GameTooltip:Show()
			
		end)
		self:SetScript("OnLeave", function() GameTooltip:Hide() end)
		
		OldMoney = NewMoney
	end

	Stat:RegisterEvent("PLAYER_MONEY")
	Stat:RegisterEvent("SEND_MAIL_MONEY_CHANGED")
	Stat:RegisterEvent("SEND_MAIL_COD_CHANGED")
	Stat:RegisterEvent("PLAYER_TRADE_MONEY")
	Stat:RegisterEvent("TRADE_MONEY_CHANGED")
	Stat:RegisterEvent("PLAYER_ENTERING_WORLD")
	Stat:SetScript("OnMouseDown", function(self, button) 
		if button == "LeftButton" then
			ToggleAllBags()
		else
			ToggleCharacter("TokenFrame")
		end
	end)
	Stat:SetScript("OnEvent", OnEvent)
end

local function FadeOutFrameMap()  --隐藏
	if Minimap:GetAlpha()>0 then
		local fadeInfo = {}
		fadeInfo.mode = "OUT"
		fadeInfo.timeToFade = 2
		fadeInfo.finishedFunc = function() Minimap:Hide() end 
		fadeInfo.startAlpha = Minimap:GetAlpha()
		fadeInfo.endAlpha = 0
		UIFrameFade(Minimap, fadeInfo)
	end 
end
local function FadeOutFrameDamage()  --隐藏
	if alDamageMeterFrame:GetAlpha()>0 then
		local fadeInfo = {}
		fadeInfo.mode = "OUT"
		fadeInfo.timeToFade = 2
		fadeInfo.finishedFunc = function() alDamageMeterFrame:Hide() end 
		fadeInfo.startAlpha = alDamageMeterFrame:GetAlpha()
		fadeInfo.endAlpha = 0
		UIFrameFade(alDamageMeterFrame, fadeInfo)
	end 
end
	
function Module:OnInitialize()
	if C["InfoPanelDB"]["OpenTop"] == true then
		local top = CreateFrame("Frame", nil, UIParent)
		top:SetHeight(20)
		top:SetFrameStrata("BACKGROUND")
		top:SetFrameLevel(0)
		top:CreateShadow("Background")
		top:SetPoint("TOP", 0, 3)
		top:SetPoint("LEFT")
		top:SetPoint("RIGHT")
		local InfoPanelPos = CreateFrame("Frame", "InfoPanelPos", UIParent)
		InfoPanelPos:SetSize(350, 12)
		InfoPanelPos:Hide()
		MoveHandle.InfoPanel = S.MakeMoveHandle(InfoPanelPos, L["信息面板"], "InfoPanel")
		
		local maphide = CreateFrame("Button", nil, UIParent)
		maphide:SetHeight(8)
		maphide:SetWidth(100)
		maphide:SetFrameStrata("BACKGROUND")
		maphide:SetFrameLevel(1)
		maphide:SetPoint("TOP", 0, -5)
		maphide:SetAlpha(0)
		maphide:SetScript("OnMouseDown", function(self, button)
			if Minimap:IsShown() then 
				FadeOutFrameMap()
			else
				Minimap:Show()
				UIFrameFadeIn(Minimap, 3, 0, 1)
			end
		end)
		maphide:SetScript("OnEnter", function(self)
			UIFrameFadeIn(self, 2, self:GetAlpha(), 1)
			GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
			GameTooltip:AddLine("隐藏小地图", .6,.8,1)
			GameTooltip:Show()
		end)
		maphide:SetScript("OnLeave", function(self) 
			UIFrameFadeOut(self, 2, self:GetAlpha(), 0)
			GameTooltip:Hide()
		end)
		S.Reskin(maphide)
		
		local mapdamage = CreateFrame("Button", nil, UIParent)
		mapdamage:SetHeight(8)
		mapdamage:SetWidth(50)
		mapdamage:SetFrameStrata("BACKGROUND")
		mapdamage:SetFrameLevel(1)
		mapdamage:SetPoint("TOP", 90, -5)
		mapdamage:SetAlpha(0)
		mapdamage:SetScript("OnMouseDown", function(self, button)
			if alDamageMeterFrame:IsShown() then 
				FadeOutFrameDamage()
			else
				alDamageMeterFrame:Show()
				UIFrameFadeIn(alDamageMeterFrame, 3, 0, 1)
			end
		end)
		mapdamage:SetScript("OnEnter", function(self)
			UIFrameFadeIn(self, 2, self:GetAlpha(), 1)
			GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
			GameTooltip:AddLine("隐藏伤害统计", .6,.8,1)
			GameTooltip:Show()
		end)
		mapdamage:SetScript("OnLeave", function(self) 
			UIFrameFadeOut(self, 2, self:GetAlpha(), 0)
			GameTooltip:Hide()
		end)
		S.Reskin(mapdamage)
	end
	if C["InfoPanelDB"]["OpenBottom"] == true then
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
	if C["InfoPanelDB"]["OpenTop"] == true then
		BuildSystem()
		BuildMemory()
		BuildGold()
	end
end