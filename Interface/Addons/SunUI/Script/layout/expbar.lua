-- Engines
local S, C, L, DB, _ = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("ExpBar", "AceEvent-3.0")
local ExpBar = nil
local FactionInfo = {
	[1] = {{ 170/255, 70/255,  70/255 }, L["仇恨"], "FFaa4646"},
	[2] = {{ 170/255, 70/255,  70/255 }, L["敌对"], "FFaa4646"},
	[3] = {{ 170/255, 70/255,  70/255 }, L["不友好"], "FFaa4646"},
	[4] = {{ 200/255, 180/255, 100/255 }, L["中立"], "FFc8b464"},
	[5] = {{ 75/255,  175/255, 75/255 }, L["友好"], "FF4baf4b"},
	[6] = {{ 75/255,  175/255, 75/255 }, L["尊敬"], "FF4baf4b"},
	[7] = {{ 75/255,  175/255, 75/255 }, L["崇敬"], "FF4baf4b"},
	[8] = {{ 155/255,  255/255, 155/255 }, L["崇拜"],"FF9bff9b"},
}
local function SVal(Val)
    if Val >= 1e6 then
        return ("%.1fm"):format(Val/1e6):gsub("%.?0+([km])$", "%1")
    elseif Val >= 1e4 then
        return ("%.1fk"):format(Val/1e3):gsub("%.?0+([km])$", "%1")
    else
        return Val
    end
end
function Module:BuildExpBar()
	ExpBar = CreateFrame("StatusBar", nil, BottomBar)
	ExpBar:SetFrameLevel(2)
	ExpBar:CreateShadow()
	local gradient = ExpBar:CreateTexture(nil, "BACKGROUND")
	gradient:SetPoint("TOPLEFT")
	gradient:SetPoint("BOTTOMRIGHT")
	gradient:SetTexture(DB.Statusbar)
	gradient:SetGradientAlpha("VERTICAL", .3, .3, .3, .6, .1, .1, .1, .6)
	ExpBar:SetStatusBarTexture(DB.Statusbar)
	ExpBar:SetFrameLevel(2)
	ExpBar.Rest = CreateFrame("StatusBar", nil, ExpBar)
	ExpBar.Rest:SetAllPoints()
	ExpBar.Rest:SetStatusBarTexture(DB.Statusbar)
	ExpBar.Rest:SetFrameLevel(ExpBar:GetFrameLevel()-1)
	local Text = CreateFrame("Frame", nil, ExpBar)
	Text:SetAllPoints()
	Text:SetFrameLevel(4)
	ExpBar.Text = S.MakeFontString(Text, 10)
	ExpBar.Text:SetPoint("CENTER")
	ExpBar.Text:SetAlpha(0)
	if C["ActionBarDB"]["ExpbarFadeOut"] then
		ExpBar:SetAlpha(0)
	end
	ExpBar:SetScript("OnEnter",function(self)
		if InCombatLockdown() then return end
		self.Text:SetAlpha(1)
		if C["ActionBarDB"]["ExpbarFadeOut"] then
			UIFrameFadeIn(self, 2, self:GetAlpha(), 1)
		end
	end)
	ExpBar:SetScript("OnLeave",function(self)
		if InCombatLockdown() then return end
		self.Text:SetAlpha(0)
		if C["ActionBarDB"]["ExpbarFadeOut"] then
			UIFrameFadeOut(self, 2, self:GetAlpha(), 0)
		end
	end)
	if not C["ActionBarDB"]["ExpbarUp"] then
		ExpBar:SetSize(C["ActionBarDB"]["ExpbarWidth"], C["ActionBarDB"]["ExpbarHeight"])
	else
		ExpBar:SetSize(C["ActionBarDB"]["ExpbarHeight"], C["ActionBarDB"]["ExpbarWidth"])
		ExpBar:SetOrientation("VERTICAL")
		ExpBar.Rest:SetOrientation("VERTICAL")
	end
	MoveHandle.ExpBar = S.MakeMoveHandle(ExpBar, "经验条", "expbar")
end

function Module:Register()
	Module:RegisterEvent("PLAYER_ENTERING_WORLD", "OnEvent")
	Module:RegisterEvent("PLAYER_XP_UPDATE", "OnEvent")
	Module:RegisterEvent("PLAYER_LEVEL_UP", "OnEvent")
	Module:RegisterEvent("UPDATE_EXHAUSTION", "OnEvent")
	Module:RegisterEvent("UPDATE_FACTION", "OnEvent")
end


function Module:OnEvent()
	local currXP = UnitXP("player")
	local playerMaxXP = UnitXPMax("player")
	local exhaustionXP  = GetXPExhaustion("player")
	local name, standingID, barMin, barMax, barValue = GetWatchedFactionInfo()
	if UnitLevel("player") == MAX_PLAYER_LEVEL or IsXPUserDisabled == true then
		ExpBar.Rest:SetMinMaxValues(0, 1)
		ExpBar.Rest:SetValue(0)
		if name then
			ExpBar:SetStatusBarColor(unpack(FactionInfo[standingID][1]))
			ExpBar:SetMinMaxValues(barMin, barMax)
			ExpBar:SetValue(barValue)
			ExpBar.Text:SetText(barValue-barMin.." / "..barMax-barMin.."    "..floor(((barValue-barMin)/(barMax-barMin))*1000)/10 .."% | ".. name.. "(".._G["FACTION_STANDING_LABEL"..standingID]..")")
		else
			ExpBar:SetStatusBarColor(0.0, 0.4, 0.8, 1)
			ExpBar:SetMinMaxValues(0, 1)
			ExpBar:SetValue(1)
			ExpBar.Text:SetText("")
		end
	else
		ExpBar:SetStatusBarColor(0.4, 0.1, 0.6, 1)
		ExpBar.Rest:SetStatusBarColor(0.0, 0.4, 0.8, 1)
		ExpBar:SetMinMaxValues(0, playerMaxXP)
		ExpBar.Rest:SetMinMaxValues(0, playerMaxXP)
		if exhaustionXP then
			ExpBar.Text:SetText(SVal(currXP).." / "..SVal(playerMaxXP).."    "..floor((currXP/playerMaxXP)*1000)/10 .."%" .. " (+"..SVal(exhaustionXP )..")")
			if exhaustionXP+currXP >= playerMaxXP then
				ExpBar:SetValue(currXP)
				ExpBar.Rest:SetValue(playerMaxXP)
			else
				ExpBar:SetValue(currXP)
				ExpBar.Rest:SetValue(exhaustionXP+currXP)
			end
		else
			ExpBar:SetValue(currXP)
			ExpBar.Rest:SetValue(0)
			ExpBar.Text:SetText(SVal(currXP).." / "..SVal(playerMaxXP).."    "..floor((currXP/playerMaxXP)*1000)/10 .."%")
		end
	end
end

function Module:OnEnable()
	if C["InfoPanelDB"]["OpenBottom"] ~= true then return end
	Module:BuildExpBar()
	Module:Register()
end




