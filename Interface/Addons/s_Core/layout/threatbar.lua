local S, C, L, DB = unpack(select(2, ...))
local Core = LibStub("AceAddon-3.0"):GetAddon("Core")
local Module = Core:NewModule("bottomleftbar")
local InfoBarStatusColor = {{1, 0, 0}, {1, 1, 0}, {0, 0.4, 1}}

function Module:OnEnable()
	C = InfoPanelDB
	--[[local bottomleftbarpos = CreateFrame("Frame", nil, UIParent)
	bottomleftbarpos:SetHeight(C["BottomHeight"])	
	bottomleftbarpos:SetWidth(C["BottomWidth"])
	bottomleftbarpos:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 5 , 5)--]]
	local frame = CreateFrame("Frame", "BottomLeftBar", UIParent)
	
	frame:SetPoint("TOPLEFT", ChatFrame1, "BOTTOMLEFT", 0 , -5)
	frame:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE")
	frame:RegisterEvent("UNIT_THREAT_LIST_UPDATE")
	frame:RegisterEvent("PLAYER_TARGET_CHANGED")
	frame:RegisterEvent("PARTY_MEMBERS_CHANGED")

	local threatbar = CreateFrame("StatusBar", "ThreatBar", frame)
	threatbar:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
	threatbar:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)
	threatbar:SetStatusBarTexture(DB.Statusbar)
	S.MakeShadow(threatbar, 3)
	S.MakeBG(threatbar, 0)
	threatbar:SetMinMaxValues(0, 100)
	text = S.MakeFontString(frame, 10)
	text:SetPoint("TOPRIGHT", -15, 8)

	local function GetThreat(unitId, mobId)
	local _, _, threatpct, _, _ = UnitDetailedThreatSituation(unitId, mobId)
	if not threatpct then threatpct = 0 end
	return floor(threatpct)
	end

	local function GetThreatStatus(unitId, mobId)
		local _,status,_,_, _ = UnitDetailedThreatSituation(unitId, mobId)
		return status
	end

	local function GetTank(unitId, mobId)
		local isTanking,_,_,_, _ = UnitDetailedThreatSituation(unitId, mobId)
		if not isTanking then isTanking = 0 end
		return isTanking
	end

	local function GetThreatValue(unitId, mobId)
		local _, _, _, _, threatvalue = UnitDetailedThreatSituation(unitId, mobId)
		if not threatvalue then threatvalue = 0 end
		return threatvalue
	end

	local function UpdateDisplay()
	frame:SetHeight(C["BottomHeight"])	
	frame:SetWidth(ChatFrame1:GetWidth()) --C["BottomWidth"]
	threatbar:SetValue(0)
	text:SetText("")
	local status = nil
	local highUnit = ""
	local unitThreat = 0
	local highThreat = 0
	local tankName = nil
	local unitThreatValue = 0
	local playerThreatValue = 0
	local partynum = GetNumPartyMembers()
	local raidnum = GetNumRaidMembers()

	if (partynum == 0 and raidnum == 0) and UnitCanAttack("player", "target") and not(UnitIsDead("target") or UnitIsFriend("player", "target") or UnitPlayerControlled("target")) -- Solo Target
	then			
		status = GetThreatStatus("player", "target")
		threatpct = GetThreat("player", "target")
		playerThreatValue = GetThreatValue("player", "target")
		if HasPetUI() then
			unitThreatValue = GetThreatValue("pet", "target")
			highThreat = GetThreat("pet", "target")
			highUnit = UnitName("pet")
			unitTanking = GetTank("pet", "target")
			if unitTanking == 1 then
			tankName = UnitName("pet")
			end
		end
	elseif (partynum == 0 and raidnum == 0) and UnitCanAttack("player", "targettarget") and not (UnitCanAttack("player", "target") or UnitIsDead("targettarget") or UnitIsFriend("player", "targettarget") or UnitPlayerControlled("targettarget")) -- Solo Target of Target
	then
		status = GetThreatStatus("player", "targettarget")
		threatpct = GetThreat("player", "targettarget")
		playerThreatValue = GetThreatValue("player", "targettarget")
		if HasPetUI() then
			unitThreatValue = GetThreatValue("pet", "targettarget")
			highThreat = GetThreat("pet", "targettarget")
			highUnit = UnitName("pet")
			unitTanking = GetTank("pet", "targettarget")
			if unitTanking == 1 then
			tankName = UnitName("pet")
			end
		end
	elseif (raidnum > 0) and UnitCanAttack("player", "target") and not (UnitIsDead("target") or UnitIsFriend("player", "target") or UnitPlayerControlled("target")) --Raid Target
	then 
		status = GetThreatStatus("player", "target")
		threatpct = GetThreat("player", "target")
		playerThreatValue = GetThreatValue("player", "target")
		for i = 1, (raidnum -1) do
			unitThreat = GetThreat("raid"..i, "target") 	
				if unitThreat > highThreat then 
					highThreat = unitThreat	
					highUnit = UnitName("raid"..i)
					unitThreatValue = GetThreatValue("raid"..i, "target")
				end
			unitThreat = GetThreat("raidpet"..i, "target")	
				if unitThreat > highThreat then 
					highThreat = unitThreat	
					highUnit = UnitName("raidpet"..i)
					unitThreatValue = GetThreatValue("raidpet"..i, "target")
				end
			unitThreat = GetThreat("pet", "target")
				if unitThreat > highThreat then
					highThreat = unitThreat
					highUnit = UnitName("pet")
					unitThreatValue = GetThreatValue("pet", "target")
				end
			unitTanking = GetTank("raid"..i, "target")
			if unitTanking == 1 then
				tankName = UnitName("raid"..i)
			end
			unitTanking = GetTank("raidpet"..i, "target")
			if unitTanking == 1 then
				tankName = UnitName("raidpet"..i)
			end
			unitTanking = GetTank("pet", "target")
			if unitTanking == 1 then
				tankName = UnitName("pet")
			end
		end
	elseif (raidnum > 0) and UnitCanAttack("player", "targettarget") and not (UnitCanAttack("player", "target") or UnitIsDead("targettarget") or UnitIsFriend("player", "targettarget") or UnitPlayerControlled("targettarget")) --Raid Target of Target
	then
		status = GetThreatStatus("player", "targettarget")
		threatpct = GetThreat("player", "targettarget")
		playerThreatValue = GetThreatValue("player", "targettarget")		
		for i = 1, (raidnum -1) do
			unitThreat = GetThreat("raid"..i, "targettarget") 	
				if unitThreat > highThreat then 
					highThreat = unitThreat	
					highUnit = UnitName("raid"..i)
					unitThreatValue = GetThreatValue("raid"..i, "targettarget")
				end
			unitThreat = GetThreat("raidpet"..i, "targettarget")	
				if unitThreat > highThreat then 
					highThreat = unitThreat	
					highUnit = UnitName("raidpet"..i)
					unitThreatValue = GetThreatValue("raidpet"..i, "targettarget")
				end
			unitThreat = GetThreat("pet", "targettarget")
				if unitThreat > highThreat then
					highThreat = unitThreat
					highUnit = UnitName("pet")
					unitThreatValue = GetThreatValue("pet", "targettarget")
				end
			unitTanking = GetTank("raid"..i, "targettarget")
			if unitTanking == 1 then
				tankName = UnitName("raid"..i)
			end
			unitTanking = GetTank("raidpet"..i, "targettarget")
			if unitTanking == 1 then
				tankName = UnitName("raidpet"..i)
			end
			unitTanking = GetTank("pet", "targettarget")
			if unitTanking == 1 then
				tankName = UnitName("pet")
			end
		end
	elseif (partynum > 0) and UnitCanAttack("player", "target") and not (UnitIsDead("target") or UnitIsFriend("player", "target") or UnitPlayerControlled("target")) -- Party Target
	then 
		status = GetThreatStatus("player", "target")
		threatpct = GetThreat("player", "target")
		playerThreatValue = GetThreatValue("player", "target")
		for i = 1, partynum do
			unitThreat = GetThreat("party"..i, "target") 	
				if unitThreat > highThreat then 
					highThreat = unitThreat	
					highUnit = UnitName("party"..i)
					unitThreatValue = GetThreatValue("party"..i, "target")
				end
			unitThreat = GetThreat("partypet"..i, "target")	
				if unitThreat > highThreat then 
					highThreat = unitThreat	
					highUnit = UnitName("partypet"..i)
					unitThreatValue = GetThreatValue("partypet"..i, "target")
				end
			unitThreat = GetThreat("pet", "target")
				if unitThreat > highThreat then
					highThreat = unitThreat
					highUnit = UnitName("pet")
					unitThreatValue = GetThreatValue("pet", "target")
				end
			unitTanking = GetTank("party"..i, "target")
			if unitTanking == 1 then
				tankName = UnitName("party"..i)
			end
			unitTanking = GetTank("partypet"..i, "target")
			if unitTanking == 1 then
				tankName = UnitName("partypet"..i)
			end
			unitTanking = GetTank("pet", "target")
			if unitTanking == 1 then
				tankName = UnitName("pet")
			end
		end
	elseif (partynum > 0) and UnitCanAttack("player", "targettarget") and not (UnitCanAttack("player", "target") or UnitIsDead("targettarget") or UnitIsFriend("player", "targettarget") or UnitPlayerControlled("targettarget")) --Party Target of Target
	then
		status = GetThreatStatus("player", "targettarget")
		threatpct = GetThreat("player", "targettarget")
		playerThreatValue = GetThreatValue("player", "targettarget")
		for i = 1, partynum do
			unitThreat = GetThreat("party"..i, "targettarget") 	
				if unitThreat > highThreat then 
					highThreat = unitThreat	
					highUnit = UnitName("party"..i)
					unitThreatValue = GetThreatValue("party"..i, "targettarget")
				end
			unitThreat = GetThreat("partypet"..i, "targettarget")	
				if unitThreat > highThreat then 
					highThreat = unitThreat	
					highUnit = UnitName("partypet"..i)
					unitThreatValue = GetThreatValue("partypet"..i, "targettarget")
				end
			unitThreat = GetThreat("pet", "targettarget")
				if unitThreat > highThreat then
					highThreat = unitThreat
					highUnit = UnitName("pet")
					unitThreatValue = GetThreatValue("pet", "targettarget")
				end
			unitTanking = GetTank("party"..i, "targettarget")
			if unitTanking == 1 then
				tankName = UnitName("party"..i)
			end
			unitTanking = GetTank("partypet"..i, "targettarget")
			if unitTanking == 1 then
				tankName = UnitName("partypet"..i)
			end
			unitTanking = GetTank("pet", "target")
			if unitTanking == 1 then
				tankName = UnitName("pet")
			end
		end
	end
	if status then -- show frame
		--icon:Show()
		if hidden == true and not frame:IsShown() then
			frame:Show()
		end
	end
	if status == 0
	then
		--icon:SetTexCoord(GetTexCoordsForRoleSmallCircle("DAMAGER"))
		threatbar:SetValue(threatpct)
		text:SetText(threatpct.."%")
		local r, g, b = S.ColorGradient((100-threatpct)/100, InfoBarStatusColor[1][1], InfoBarStatusColor[1][2], InfoBarStatusColor[1][3], 
																		InfoBarStatusColor[2][1], InfoBarStatusColor[2][2], InfoBarStatusColor[2][3],
																		InfoBarStatusColor[3][1], InfoBarStatusColor[3][2], InfoBarStatusColor[3][3])
		threatbar:SetStatusBarColor(r, g, b)
		
		if tankName
		then
			threatValuediff = ((unitThreatValue - playerThreatValue) / 100000 )
			threatbar:SetValue(threatpct)
			text:SetText(string.format("%2.1fk | %d %%", threatValuediff, threatpct ))
			local r, g, b = S.ColorGradient(threatValuediff/100, InfoBarStatusColor[1][1], InfoBarStatusColor[1][2], InfoBarStatusColor[1][3], 
																		InfoBarStatusColor[2][1], InfoBarStatusColor[2][2], InfoBarStatusColor[2][3],
																		InfoBarStatusColor[3][1], InfoBarStatusColor[3][2], InfoBarStatusColor[3][3])
			threatbar:SetStatusBarColor(r, g, b)
		end
	elseif status == 1
	then
		--icon:SetTexCoord(GetTexCoordsForRoleSmallCircle("DAMAGER"))
		threatbar:SetValue(threatpct)
		text:SetText(threatpct.."%")
		local r, g, b = S.ColorGradient((100-threatpct)/100, InfoBarStatusColor[1][1], InfoBarStatusColor[1][2], InfoBarStatusColor[1][3], 
																		InfoBarStatusColor[2][1], InfoBarStatusColor[2][2], InfoBarStatusColor[2][3],
																		InfoBarStatusColor[3][1], InfoBarStatusColor[3][2], InfoBarStatusColor[3][3])
		threatbar:SetStatusBarColor(r, g, b)
		if tankName
		then
			threatValuediff = ((unitThreatValue - playerThreatValue) / 100000 )
			threatbar:SetValue(threatpct)
			text:SetText(string.format("%2.1fk | %d %%", threatValuediff, threatpct ))
			local r, g, b = S.ColorGradient(threatValuediff/100, InfoBarStatusColor[1][1], InfoBarStatusColor[1][2], InfoBarStatusColor[1][3], 
																		InfoBarStatusColor[2][1], InfoBarStatusColor[2][2], InfoBarStatusColor[2][3],
																		InfoBarStatusColor[3][1], InfoBarStatusColor[3][2], InfoBarStatusColor[3][3])
			threatbar:SetStatusBarColor(r, g, b)
		end
	elseif status == 2
	then
		--icon:SetTexCoord(GetTexCoordsForRoleSmallCircle("TANK"))
		threatbar:SetValue(threatpct)
		text:SetText(threatpct.."%")
		local r, g, b = S.ColorGradient((100-threatpct)/100, InfoBarStatusColor[1][1], InfoBarStatusColor[1][2], InfoBarStatusColor[1][3], 
																		InfoBarStatusColor[2][1], InfoBarStatusColor[2][2], InfoBarStatusColor[2][3],
																		InfoBarStatusColor[3][1], InfoBarStatusColor[3][2], InfoBarStatusColor[3][3])
		threatbar:SetStatusBarColor(r, g, b)
		if highThreat ~= 0
		then
			threatValuediff = ((playerThreatValue - unitThreatValue) / 100000 )
			threatdiff = (100 - highThreat)
			threatbar:SetValue(threatdiff)
			text:SetText(string.format("%2.1fk | %d %%", threatValuediff, threatpct ))
			local r, g, b = S.ColorGradient(threatValuediff/100, InfoBarStatusColor[1][1], InfoBarStatusColor[1][2], InfoBarStatusColor[1][3], 
																		InfoBarStatusColor[2][1], InfoBarStatusColor[2][2], InfoBarStatusColor[2][3],
																		InfoBarStatusColor[3][1], InfoBarStatusColor[3][2], InfoBarStatusColor[3][3])
			threatbar:SetStatusBarColor(r, g, b)
		end	
	elseif status == 3
	then
		--icon:SetTexCoord(GetTexCoordsForRoleSmallCircle("TANK"))
		threatbar:SetValue(threatpct)
		text:SetText(threatpct.."%")
		local r, g, b = S.ColorGradient((100-threatpct)/100, InfoBarStatusColor[1][1], InfoBarStatusColor[1][2], InfoBarStatusColor[1][3], 
																		InfoBarStatusColor[2][1], InfoBarStatusColor[2][2], InfoBarStatusColor[2][3],
																		InfoBarStatusColor[3][1], InfoBarStatusColor[3][2], InfoBarStatusColor[3][3])
		threatbar:SetStatusBarColor(r, g, b)
		if highThreat ~= 0
		then
			threatValuediff = ((playerThreatValue - unitThreatValue) / 100000 )
			threatdiff = (100 - highThreat)
			threatbar:SetValue(threatdiff)
			text:SetText(string.format("%2.1fk | %d %%", threatValuediff, threatpct ))
			local r, g, b = S.ColorGradient(threatValuediff/100, InfoBarStatusColor[1][1], InfoBarStatusColor[1][2], InfoBarStatusColor[1][3], 
																		InfoBarStatusColor[2][1], InfoBarStatusColor[2][2], InfoBarStatusColor[2][3],
																		InfoBarStatusColor[3][1], InfoBarStatusColor[3][2], InfoBarStatusColor[3][3])
			threatbar:SetStatusBarColor(r, g, b)
		end
	end
end
	
frame:SetScript("OnEvent", function() UpdateDisplay() end)
end