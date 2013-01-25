local S, L, DB, _, C = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("ExpBar", "AceEvent-3.0")
local SunUIConfig = LibStub("AceAddon-3.0"):GetAddon("SunUI"):GetModule("SunUIConfig")
local ExpBar = nil
local es, hs
local exptitle1 , exptitle2, exptext1, exptext2 = "", "", "", ""
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
	ExpBar = CreateFrame("StatusBar", "SunUIExpBar", UIParent)
	ExpBar:SetFrameLevel(3)
	ExpBar:CreateShadow()
	ExpBar:SetStatusBarTexture(SunUIConfig.db.profile.MiniDB.uitexturePath)
	S.SmoothBar(ExpBar)
	es = ExpBar:GetStatusBarTexture()
	ExpBar.Rest = CreateFrame("StatusBar", nil, ExpBar)
	ExpBar.Rest:SetAllPoints()
	ExpBar.Rest:SetStatusBarTexture(SunUIConfig.db.profile.MiniDB.uitexturePath)
	ExpBar.Rest:SetFrameLevel(2)
	hs = ExpBar.Rest:GetStatusBarTexture()
	local h = CreateFrame("StatusBar", nil, ExpBar)
	h:SetFrameLevel(1)
	h:SetAllPoints()
	if C["ExpbarFadeOut"] then
		ExpBar:SetAlpha(0)
	end
	if not C["ExpbarUp"] then
		ExpBar:SetSize(C["ExpbarWidth"], C["ExpbarHeight"])
		S.CreateBack(h)
		S.CreateMark(ExpBar)
	else
		ExpBar:SetSize(C["ExpbarHeight"], C["ExpbarWidth"])
		ExpBar:SetOrientation("VERTICAL")
		ExpBar.Rest:SetOrientation("VERTICAL")
		S.CreateBack(h, true)
		S.CreateMark(ExpBar, true)
	end
	MoveHandle.ExpBar = S.MakeMoveHandle(ExpBar, L["经验条"], "expbar")

	ExpBar:SetScript("OnEnter", function(self)
		if InCombatLockdown() then return end
		if C["ExpbarFadeOut"] then
			UIFrameFadeIn(self, 0.5, self:GetAlpha(), 1)
		end
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
		GameTooltip:ClearLines()
		GameTooltip:AddDoubleLine(exptitle1, exptitle2)
		if exptext1 ~= "" or exptext2 ~= "" then
			GameTooltip:AddLine(" ")
			GameTooltip:AddDoubleLine(exptext1, exptext2)
		end
		GameTooltip:Show()
	end)
	ExpBar:SetScript("OnMouseDown", function(self, button)
		ToggleCharacter("ReputationFrame")
	end)
	ExpBar:SetScript("OnLeave",function(self)
		if InCombatLockdown() then return end
		if C["ExpbarFadeOut"] then
			UIFrameFadeOut(self, 0.5, self:GetAlpha(), 0)
		end
		GameTooltip:Hide()
	end)
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
			if not C["ExpbarUp"] then
				S.CreateTop(es, FactionInfo[standingID][1][1], FactionInfo[standingID][1][2], FactionInfo[standingID][1][3])
			else
				S.CreateTop(es, FactionInfo[standingID][1][1], FactionInfo[standingID][1][2], FactionInfo[standingID][1][3], true)
			end
			ExpBar:SetMinMaxValues(barMin, barMax)
			ExpBar:SetValue(barValue)
			exptitle1 = S.ToHex(FactionInfo[standingID][1][1], FactionInfo[standingID][1][2], FactionInfo[standingID][1][3])..name.."|r"
			exptitle2 = S.ToHex(FactionInfo[standingID][1][1], FactionInfo[standingID][1][2], FactionInfo[standingID][1][3]).._G["FACTION_STANDING_LABEL"..standingID].."|r"
			exptext1 = barValue-barMin.." / "..barMax-barMin
			exptext2 = floor(((barValue-barMin)/(barMax-barMin))*1000)/10 .."%"
		else
			ExpBar:SetStatusBarColor(0.0, 0.4, 0.8, 1)
			ExpBar:SetMinMaxValues(0, 1)
			ExpBar:SetValue(1)
			exptitle1 = ""
			exptitle2 = ""
			exptext1 = ""
			exptext2 = ""
		end
	else
		ExpBar:SetStatusBarColor(0.4, 0.1, 0.6, 1)
		ExpBar.Rest:SetStatusBarColor(0.0, 0.4, 0.8, 1)
		if not C["ExpbarUp"] then
			S.CreateTop(es, 0.4, 0.1, 0.6)
			S.CreateTop(hs, 0.0, 0.4, 0.8)
		else
			S.CreateTop(es, 0.4, 0.1, 0.6, true)
			S.CreateTop(hs, 0.0, 0.4, 0.8, true)
		end
		ExpBar:SetMinMaxValues(0, playerMaxXP)
		ExpBar.Rest:SetMinMaxValues(0, playerMaxXP)
		if exhaustionXP then
			exptitle1 = "|cffFFD700"..SVal(currXP).." / "..SVal(playerMaxXP).."|r"..S.ToHex(0.0, 0.4, 0.8).."+"..SVal(exhaustionXP).."|r"
			exptitle2 = floor((currXP/playerMaxXP)*1000)/10 .."%"
			exptext1 = ""
			exptext2 = ""
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
			exptitle1 = S.ToHex(0.4, 0.1, 0.6)..SVal(currXP).." / "..SVal(playerMaxXP).."|r"
			exptitle2 = floor((currXP/playerMaxXP)*1000)/10 .."%"
			exptext1 = ""
			exptext2 = ""
		end
	end
end
function Module:UpdateSize()
	if not C["ExpbarUp"] then
		ExpBar:SetSize(C["ExpbarWidth"], C["ExpbarHeight"])
		ExpBar:SetOrientation("HORIZONTAL")
		ExpBar.Rest:SetOrientation("HORIZONTAL")
	else
		ExpBar:SetSize(C["ExpbarHeight"], C["ExpbarWidth"])
		ExpBar:SetOrientation("VERTICAL")
		ExpBar.Rest:SetOrientation("VERTICAL")
	end
end
function Module:UpdateFade()
	if C["ExpbarFadeOut"] then
		UIFrameFadeOut(ExpBar, 1, ExpBar:GetAlpha(), 0)
	else
		UIFrameFadeIn(ExpBar, 1, ExpBar:GetAlpha(), 1)
	end
end
function Module:OnInitialize()
	C = SunUIConfig.db.profile.ActionBarDB
	Module:BuildExpBar()
	Module:Register()
end