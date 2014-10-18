local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local EP = S:NewModule("EXPBAR", "AceEvent-3.0", "AceHook-3.0", "AceConsole-3.0")
local ExpBar = nil
local exptitle1 , exptitle2, exptext1, exptext2 = "", "", "", ""
local FactionInfo = {
	[1] = {{ 170/255, 70/255,  70/255 }, FACTION_STANDING_LABEL1, "FFaa4646"},
	[2] = {{ 170/255, 70/255,  70/255 }, FACTION_STANDING_LABEL2, "FFaa4646"},
	[3] = {{ 170/255, 70/255,  70/255 }, FACTION_STANDING_LABEL3, "FFaa4646"},
	[4] = {{ 200/255, 180/255, 100/255 }, FACTION_STANDING_LABEL4, "FFc8b464"},
	[5] = {{ 75/255,  175/255, 75/255 }, FACTION_STANDING_LABEL5, "FF4baf4b"},
	[6] = {{ 75/255,  175/255, 75/255 }, FACTION_STANDING_LABEL6, "FF4baf4b"},
	[7] = {{ 75/255,  175/255, 75/255 }, FACTION_STANDING_LABEL7, "FF4baf4b"},
	[8] = {{ 155/255,  255/255, 155/255 }, FACTION_STANDING_LABEL8,"FF9bff9b"},
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
function EP:BuildExpBar()
	ExpBar = CreateFrame("StatusBar", "SunUIExpBar", Minimap)
	ExpBar:SetFrameLevel(3)
	ExpBar:CreateShadow(0.5)
	ExpBar:SetStatusBarTexture(S["media"].normal)
	local A = S:GetModule("Skins")
	A:CreateMark(ExpBar)
	
	ExpBar.Rest = CreateFrame("StatusBar", nil, ExpBar)
	ExpBar.Rest:SetAllPoints()
	ExpBar.Rest:SetStatusBarTexture(S["media"].normal)
	ExpBar.Rest:SetFrameLevel(2)
	
	ExpBar:SetSize(120, 3)
	ExpBar:SetPoint("BOTTOM", Minimap, "TOP", 0, 5)

	ExpBar:SetScript("OnEnter", function(self)
		if InCombatLockdown() then return end
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
		GameTooltip:Hide()
	end)
end

function EP:Register()
	EP:RegisterEvent("PLAYER_ENTERING_WORLD", "OnEvent")
	EP:RegisterEvent("PLAYER_XP_UPDATE", "OnEvent")
	EP:RegisterEvent("PLAYER_LEVEL_UP", "OnEvent")
	EP:RegisterEvent("UPDATE_EXHAUSTION", "OnEvent")
	EP:RegisterEvent("UPDATE_FACTION", "OnEvent")
end

function EP:OnEvent()
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
			exptitle1 = S:RGBToHex(FactionInfo[standingID][1][1], FactionInfo[standingID][1][2], FactionInfo[standingID][1][3])..name.."|r"
			exptitle2 = S:RGBToHex(FactionInfo[standingID][1][1], FactionInfo[standingID][1][2], FactionInfo[standingID][1][3]).._G["FACTION_STANDING_LABEL"..standingID].."|r"
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
		ExpBar:SetMinMaxValues(0, playerMaxXP)
		ExpBar.Rest:SetMinMaxValues(0, playerMaxXP)
		if exhaustionXP then
			exptitle1 = "|cffFFD700"..SVal(currXP).." / "..SVal(playerMaxXP).."|r"..S:RGBToHex(0.0, 0.4, 0.8).."+"..SVal(exhaustionXP).."|r"
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
			exptitle1 = S:RGBToHex(0.4, 0.1, 0.6)..SVal(currXP).." / "..SVal(playerMaxXP).."|r"
			exptitle2 = floor((currXP/playerMaxXP)*1000)/10 .."%"
			exptext1 = ""
			exptext2 = ""
		end
	end
end

function EP:Initialize()
	self:BuildExpBar()
	self:Register()
end

S:RegisterModule(EP:GetName())