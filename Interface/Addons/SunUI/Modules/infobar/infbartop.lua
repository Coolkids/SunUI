local S, L, DB, _, C = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("InfoPanelTop", "AceTimer-3.0")
local SunUIDB = LibStub("AceAddon-3.0"):GetAddon("SunUI"):GetModule("SunUIConfig")
local InfoBarStatusColor = {{1, 0, 0}, {1, 1, 0}, {0, 0.4, 1}}
local bandwidthString = "%.2f Mbps"
local percentageString = "%.2f%%"
local wm = CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton
local damageframe = {
	"alDamageMeterFrame",
	"SkadaBarWindowSkada",
	"NumerationFrame",
}
--团队工具
local function RaidTools()
	if SunUIDB.db.profile.MiniDB.MiniMapPanels ~= true then return end
	wm = CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton
	wm:SetParent(UIParent) 
	wm:SetFrameLevel(3)
	wm:ClearAllPoints() 
	wm:SetPoint("TOP", 0, -5)
	wm:SetSize(150, 8)
	wm:Hide()
	wm:SetAlpha(0)
	wm:SetScript("OnEnter", function(self)
		UIFrameFadeIn(self, 0.5, self:GetAlpha(), 1)
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
		GameTooltip:AddLine(L["团队工具"], .6,.8,1)
		GameTooltip:Show()
	end)
	wm:SetScript("OnLeave", function(self) 
		UIFrameFadeOut(self, 0.5, self:GetAlpha(), 0)
		GameTooltip:Hide()
	end)
		
	CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButtonLeft:SetAlpha(0) 
	CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButtonMiddle:SetAlpha(0) 
	CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButtonRight:SetAlpha(0) 
	wm:RegisterEvent("PLAYER_ENTERING_WORLD") 
	wm:RegisterEvent("GROUP_ROSTER_UPDATE") 
	wm:HookScript("OnEvent", function(self) 
		local raid =  IsInRaid()
		if (raid and (UnitIsGroupLeader("player") or UnitIsGroupAssistant("player"))) or (GetNumSubgroupMembers() > 0 and not raid) then 
			self:Show()
		else 
			self:Hide() 
		end 
	end) 

	local wmmenuFrame = CreateFrame("Frame", "wmRightClickMenu", UIParent, "UIDropDownMenuTemplate") 
	local wmmenuList = { 
	{text = READY_CHECK, 
	func = function() DoReadyCheck() end}, 
	{text = ROLE_POLL, 
	func = function() InitiateRolePoll() end}, 
	{text = CONVERT_TO_RAID, 
	func = function() ConvertToRaid() end}, 
	{text = CONVERT_TO_PARTY, 
	func = function() ConvertToParty() end}, 
	} 

	wm:SetScript('OnMouseUp', function(self, button) 
		wm:StopMovingOrSizing() 
		if (button=="RightButton") then 
			EasyMenu(wmmenuList, wmmenuFrame, "cursor", -150, 0, "MENU", 2) 
		end 
	end)
	
	S.Reskin(wm)
end 
--BuildSystem
local function BuildSystem()
local Stat = CreateFrame("Frame", "InfoPanel1", TopInfoPanel)
	Stat:SetFrameStrata("BACKGROUND")
	Stat:SetFrameLevel(3)
	Stat:EnableMouse(true)
	
	local Text = S.MakeFontString(Stat)
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
	local fps = 0
	local function Update(self, t)
		int = int - t
		local fpscolor
		local latencycolor

		if int < 0 then
			local _, _, latencyHome, latencyWorld = GetNetStats()
			fps = floor(GetFramerate())
			if fps >= 30 then
				fpscolor = "|cff0CD809"
			elseif (fps > 15 and fps < 30) then
				fpscolor = "|cffE8DA0F"
			else
				fpscolor = "|cffD80909"
			end
			Text:SetText(fpscolor..fps.."|r".."FPS  "..colorlatency(latencyHome).."|r/"..colorlatency(latencyWorld).."|r".."ms")
			int = 0.8
		end
	end
	Stat:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
		GameTooltip:ClearLines()
		GameTooltip:AddLine("System",0,.6,1)
		GameTooltip:AddLine(" ")
		local free, total = 0, 0
		for i = 0, NUM_BAG_SLOTS do
			free, total = free + GetContainerNumFreeSlots(i), total + GetContainerNumSlots(i)
		end
		local _, _, latencyHome, latencyWorld = GetNetStats()
		local bandwidth = GetAvailableBandwidth()
		local r1, g1, b1 = S.ColorGradient(latencyHome/900, 0, 1, 0, 1, 1, 0, 1, 0, 0)
		local r2, g2, b2 = S.ColorGradient(latencyWorld/900, 0, 1, 0, 1, 1, 0, 1, 0, 0)
		GameTooltip:ClearLines()
		GameTooltip:AddLine("System", 0.4, 0.78, 1)
		GameTooltip:AddLine(" ")
		GameTooltip:AddDoubleLine(FRAMERATE_LABEL, fps, 0.75, 0.9, 1)
		GameTooltip:AddDoubleLine(L["本地延迟"], latencyHome.."ms", 0.75, 0.9, 1, r1, g1, b1)
		GameTooltip:AddDoubleLine(L["世界延迟"], latencyWorld.."ms", 0.75, 0.9, 1, r2, g2, b2)
		if bandwidth ~= 0 then
			GameTooltip:AddDoubleLine(L["带宽"]..": " , string.format("%.2f Mbps", bandwidth),0.69, 0.31, 0.31,0.84, 0.75, 0.65)
			GameTooltip:AddDoubleLine(L["下载"]..": " , string.format("%.2f%%", GetDownloadedPercentage() *100),0.69, 0.31, 0.31, 0.84, 0.75, 0.65)
		end
		GameTooltip:AddLine(" ")
		GameTooltip:AddDoubleLine(format(NUM_FREE_SLOTS, free), L["总计"]..total, 0.69, 0.31, 0.31,0.84, 0.75, 0.65)
		GameTooltip:Show()
	end)
	Stat:SetScript("OnLeave", function() GameTooltip:Hide() end)
	Stat:SetScript("OnMouseDown", function(self, button) 
		ToggleFrame(GameMenuFrame)
	end)
	
	Stat:SetScript("OnUpdate", Update) 
end
-- BuildMemory
local L_MB = "mb"
local L_KB = "kb"
local Mem = {}
local MemUse
local gtotal
local format = string.format
local Memtext
local memTbl = {}
local IsAddOnLoaded = _G.IsAddOnLoaded
local GetAddOnMemoryUsage = _G.GetAddOnMemoryUsage
local GetAddOnInfo = _G.GetAddOnInfo
local function mySort(x,y)
	return x.mem > y.mem
end
local function MemUseCalc()
	wipe(memTbl)
	UpdateAddOnMemoryUsage()
	local total = 0
	for i = 1, GetNumAddOns() do
		if IsAddOnLoaded(i) then
			local memused = GetAddOnMemoryUsage(i)
			total = total + memused
			local addon, name = GetAddOnInfo(i)
			tinsert(memTbl, {addon = name or addon, mem = GetAddOnMemoryUsage(i)})
		end
	end
	gtotal = total
	if total > 1024 then
		MemUse = format("%.2f "..L_MB, total / 1024)
	else
		MemUse = format("%.1f "..L_KB, total)
	end
	table.sort(memTbl, mySort)
end
function Module:Update()
	local current = format("%.1f", _G.collectgarbage("count") / 1024)
	MemUseCalc()
	local color = gtotal <= 1024*3 and {0,1} -- 1
				or gtotal <= 1024*7 and {0.75,1} -- 5
				or gtotal <= 1024*10 and {1,1} -- 12
				or gtotal <= 1024*15  and {1,0.75} -- 18
				or gtotal <= 1024*18 and {1,0.5} -- 25
				or {1,0.1}
	if gtotal < 1024 then
		Memtext:SetText(string.format("|cff%02x%02x%02x", color[1]*255, color[2]*255, 0)..format("%.2f", gtotal).."|rkb")
	else
		Memtext:SetText(string.format("|cff%02x%02x%02x", color[1]*255, color[2]*255, 0)..format("%.2f", gtotal/1024).."|rmb")
	end
end

Module:ScheduleRepeatingTimer("Update", 10)

local function formatMemory(n)
	if n > 1024 then
		return format("%.2f "..L_MB, n / 1024)
	else
		return format("%.2f "..L_KB, n)
	end
end

local function OnTooltipShow(self)
	GameTooltip:AddLine("MEMORY", .6,.8,1)
	GameTooltip:AddLine(" ")
	local grandtotal = collectgarbage("count")
	local txt = "|cffFFD700%d|r|cffffffff.|r %s"
	for k, v in pairs(memTbl) do
		local color = v.mem <= 102.4 and {0,1} -- 0 - 100
					or v.mem <= 512 and {0.75,1} -- 100 - 512
					or v.mem <= 1024 and {1,1} -- 512 - 1mb
					or v.mem <= 2560 and {1,0.75} -- 1mb - 2.5mb
					or v.mem <= 5120 and {1,0.5} -- 2.5mb - 5mb
					or {1,0.1}
		GameTooltip:AddDoubleLine(format(txt, k, v.addon), formatMemory(v.mem), 1,1,1, color[1], color[2], 0)
	end
	local color = gtotal <= 1024*3 and {0,1} -- 1
				or gtotal <= 1024*7 and {0.75,1} -- 5
				or gtotal <= 1024*10 and {1,1} -- 12
				or gtotal <= 1024*15  and {1,0.75} -- 18
				or gtotal <= 1024*18 and {1,0.5} -- 25
				or {1,0.1}
	GameTooltip:AddLine(" ")
	GameTooltip:AddDoubleLine(L["非暴雪插件总计"], formatMemory(gtotal), .6,.8,1, color[1], color[2], 0)
	GameTooltip:AddDoubleLine(L["一共占用"], formatMemory(grandtotal), .6,.8,1, 1, 0.75, 0)
	GameTooltip:AddLine(L["回收内存"], 1, 1, 1)
end

local function BuildMemory()
	local Stat = CreateFrame("Frame", "InfoPanel2", TopInfoPanel)
	Stat:SetFrameStrata("BACKGROUND")
	Stat:SetFrameLevel(3)
	Stat:EnableMouse(true)
	
	local Text = S.MakeFontString(Stat)
	Text:SetPoint("LEFT", InfoPanel1, "RIGHT", 2, 0)
	Text:SetShadowOffset(S.mult, -S.mult)
	Text:SetShadowColor(0, 0, 0, 0.4)
	Memtext = Text
	Stat:SetAllPoints(Text)
	Stat:SetScript("OnMouseDown", function(self, button)
		if button == "LeftButton" then 
			UpdateAddOnMemoryUsage()
			local Before = gcinfo()
			collectgarbage()
			UpdateAddOnMemoryUsage()
			print(format("|cff66C6FF%s:|r %s", L["共释放内存"], S.FormatMemory(Before - gcinfo())))
			Module:Update()
		else
			if stAddonManager:IsShown() then 
				stAddonManager:Hide()
				stAddonManager:UnregisterAllEvents()
			else
				stAddonManager:LoadWindow()
			end
		end
	end)
	
	Stat:SetScript("OnEnter", function(self)
		--if not InCombatLockdown() then collectgarbage() end
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
		OnTooltipShow(self)
		GameTooltip:Show()
	end)
	Stat:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
end
-- BuildGold
local function BuildGold()
	local Stat = CreateFrame("Frame", "InfoPanel3", TopInfoPanel)
	Stat:SetFrameStrata("BACKGROUND")
	Stat:SetFrameLevel(3)
	Stat:EnableMouse(true)
	
	local Text = S.MakeFontString(Stat)
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
				GameTooltip:ClearLines()
				GameTooltip:AddLine(CURRENCY,.6,.8,1)
				GameTooltip:AddLine(" ")
				GameTooltip:AddLine(L["目前"],.6,.8,1)
				GameTooltip:AddDoubleLine(L["收入"], formatMoney(Profit), 1, 1, 1, 0, 1, 0)
				GameTooltip:AddDoubleLine(L["花费"], formatMoney(Spent), 1, 1, 1, 1, 0, 0)
				if Profit < Spent then
					GameTooltip:AddDoubleLine(L["亏损"], formatMoney(Profit-Spent), 1, 1, 1, 1, 0, 0)
				elseif (Profit-Spent)>0 then
					GameTooltip:AddDoubleLine("利润:", formatMoney(Profit-Spent), 1, 1, 1, 0, 1, 0)
				end				
				GameTooltip:AddLine' '								
			
				local totalGold = 0				
				GameTooltip:AddLine("ID: ",.6,.8,1)			
				local thisRealmList = SunUIConfig.gold[myPlayerRealm];
				for k,v in pairs(thisRealmList) do
					GameTooltip:AddDoubleLine(k, FormatTooltipMoney(v), 1, 1, 1, 1, 1, 1)
					totalGold=totalGold+v;
				end 
				GameTooltip:AddLine' '
				GameTooltip:AddLine(L["服务器"],.6,.8,1)
				GameTooltip:AddDoubleLine(L["总计"], FormatTooltipMoney(totalGold), 1, 1, 1, 1, 1, 1)

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
	
function Module:OnInitialize()
	C = SunUIDB.db.profile.InfoPanelDB
	if C["OpenTop"] == true then
		local top = CreateFrame("Frame", "TopInfoPanel", UIParent)
		top:SetHeight(20)
		top:SetFrameStrata("BACKGROUND")
		top:SetFrameLevel(0)
		top:CreateShadow("Background")
		top:SetPoint("TOP", 0, 3)
		top:SetPoint("LEFT")
		top:SetPoint("RIGHT")
		top:RegisterEvent("PET_BATTLE_OPENING_START")
		top:RegisterEvent("PET_BATTLE_CLOSE")
		top:SetScript("OnEvent", function(self, event)
			if event == "PET_BATTLE_OPENING_START" then
				S.FadeOutFrameDamage(self, 1, false)
			else
				self:Show()
				UIFrameFadeIn(self, 1, self:GetAlpha(), 1)
			end
		end)
		
		local InfoPanelPos = CreateFrame("Frame", "InfoPanelPos", UIParent)
		InfoPanelPos:SetSize(350, 12)
		InfoPanelPos:Hide()
		MoveHandle.InfoPanel = S.MakeMoveHandle(InfoPanelPos, L["信息面板"], "InfoPanel")
		
		--[[ local maphide = CreateFrame("Button", nil, UIParent)
		maphide:SetHeight(8)
		maphide:SetWidth(100)
		maphide:SetFrameStrata("BACKGROUND")
		maphide:SetFrameLevel(1)
		maphide:SetPoint("TOP", 0, -5)
		maphide:SetAlpha(0)
		maphide:SetScript("OnMouseDown", function(self, button)
			if Minimap:IsShown() then 
				S.FadeOutFrameDamage(Minimap, 1.5)
			else
				Minimap:Show()
				UIFrameFadeIn(Minimap, 1.5, 0, 1)
			end
		end)
		maphide:SetScript("OnEnter", function(self)
			UIFrameFadeIn(self, 0.5, self:GetAlpha(), 1)
			GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
			GameTooltip:AddLine(L["隐藏小地图"], .6,.8,1)
			GameTooltip:Show()
		end)
		maphide:SetScript("OnLeave", function(self) 
			UIFrameFadeOut(self, 1, self:GetAlpha(), 0)
			GameTooltip:Hide()
		end)
		S.Reskin(maphide)
		local findframe = false
		local mapdamage = CreateFrame("Button", nil, UIParent)
		mapdamage:SetHeight(8)
		mapdamage:SetWidth(50)
		mapdamage:SetFrameStrata("BACKGROUND")
		mapdamage:SetFrameLevel(1)
		mapdamage:SetPoint("TOP", 90, -5)
		mapdamage:SetAlpha(0)
		mapdamage:SetScript("OnMouseDown", function(self, button)
			for k,v in pairs(damageframe) do
				if _G[v] then
					findframe = true
					if _G[v]:IsShown() then 
						S.FadeOutFrameDamage(_G[v], 1.5)
					else
						_G[v]:Show()
						UIFrameFadeIn(_G[v], 1.5, _G[v]:GetAlpha(), 1)
					end
				end
			end
			if not findframe then
				DEFAULT_CHAT_FRAME:AddMessage(L["暂时不兼容其他伤害统计"])
			end
		end)
		mapdamage:SetScript("OnEnter", function(self)
			UIFrameFadeIn(self, 2, self:GetAlpha(), 1)
			GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
			GameTooltip:AddLine(L["隐藏伤害统计"], .6,.8,1)
			GameTooltip:Show()
		end)
		mapdamage:SetScript("OnLeave", function(self) 
			UIFrameFadeOut(self, 2, self:GetAlpha(), 0)
			GameTooltip:Hide()
		end)
		S.Reskin(mapdamage)
	 ]]	
		top:SetScript("OnEnter", function()
			if wm:IsShown() then
				UIFrameFadeIn(wm, 0.5, wm:GetAlpha(), 1)
			end
		end)
		top:SetScript("OnLeave", function() 
			if wm:IsShown() then
				UIFrameFadeOut(wm, 0.5, wm:GetAlpha(), 0)
			end
		end)
	end
	
	if C["OpenBottom"] == true then
		local bottom = CreateFrame("Frame", "BottomInfoPanel", UIParent)
		bottom:SetHeight(20)
		bottom:SetFrameLevel(0)
		bottom:CreateShadow("Background")
		bottom:SetPoint("BOTTOM", 0, -3)
		bottom:SetPoint("LEFT")
		bottom:SetPoint("RIGHT")
	end
end
function Module:OnEnable()
	RaidTools()
	if C["OpenTop"] == true then
		BuildSystem()
		BuildMemory()
		BuildGold()
	end
end