-- Engines
local S, C, L, DB = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("Core"):NewModule("ExpBar", "AceEvent-3.0")
local ExpBar = nil
local FactionInfo = {
	[1] = {{ 170/255, 70/255,  70/255 }, L["³ðºÞ"], "FFaa4646"},
	[2] = {{ 170/255, 70/255,  70/255 }, L["µÐ¶Ô"], "FFaa4646"},
	[3] = {{ 170/255, 70/255,  70/255 }, L["²»ÓÑºÃ"], "FFaa4646"},
	[4] = {{ 200/255, 180/255, 100/255 }, L["ÖÐÁ¢"], "FFc8b464"},
	[5] = {{ 75/255,  175/255, 75/255 }, L["ÓÑºÃ"], "FF4baf4b"},
	[6] = {{ 75/255,  175/255, 75/255 }, L["×ð¾´"], "FF4baf4b"},
	[7] = {{ 75/255,  175/255, 75/255 }, L["³ç¾´"], "FF4baf4b"},
	[8] = {{ 155/255,  255/255, 155/255 }, L["³ç°Ý"],"FF9bff9b"},
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
	ExpBar = CreateFrame("StatusBar", nil, BottomRightBar)
	--ExpBar:CreateShadow("Background")
	ExpBar:SetStatusBarTexture(DB.Statusbar)
	ExpBar:SetPoint("TOPLEFT", 0, 0)
	ExpBar:SetPoint("BOTTOM", 0, 0)
	ExpBar:SetFrameLevel(1)
	ExpBar.Rest = CreateFrame("StatusBar", nil, ExpBar)
	ExpBar.Rest:SetAllPoints()
	ExpBar.Rest:SetStatusBarTexture(DB.Statusbar)
	ExpBar.Rest:SetFrameLevel(ExpBar:GetFrameLevel()-1)
	Text = CreateFrame("Frame", nil, ExpBar)
	Text:SetAllPoints()
	Text:SetFrameLevel(2)
	ExpBar.Text = S.MakeFontString(Text, 10)
	ExpBar.Text:SetPoint("CENTER")
	--ExpBar.Text:SetFrameLevel(11)
	ExpBar.Text:SetAlpha(0)
	ExpBar:SetStatusBarTexture(DB.Statusbar)
	ExpBar:SetScript("OnEnter",function(self)
		self.Text:SetAlpha(1)
		--ExpBar:SetFrameLevel(11)
	end)
	ExpBar:SetScript("OnLeave",function(self)
		self.Text:SetAlpha(0)
		--ExpBar:SetFrameLevel(9)
	end)
end

function Module:Register()
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
function Module:OnInitialize()
	C = InfoPanelDB
end
function Module:OnEnable()
	if C["OpenBottom"] ~= true then return end
	Module:BuildExpBar()
	Module:Register()
end




