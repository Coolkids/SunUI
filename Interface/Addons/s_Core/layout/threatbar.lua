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
	local frame = CreateFrame("Frame", nil, UIParent)
	frame:SetHeight(C["BottomHeight"])	
	frame:SetWidth(ChatFrame1:GetWidth()) --C["BottomWidth"]
	frame:SetPoint("TOPLEFT", ChatFrame1, "BOTTOMLEFT", 0 , -5)
	frame:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE")
	frame:RegisterEvent("UNIT_THREAT_LIST_UPDATE")
	frame:RegisterEvent("PLAYER_TARGET_CHANGED")
	frame:RegisterEvent("PARTY_MEMBERS_CHANGED")
	frame:RegisterEvent("PLAYER_ENTERING_WORLD")
	frame:RegisterEvent("ZONE_CHANGED")
	frame:RegisterEvent("ZONE_CHANGED_INDOORS")
	frame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	frame:RegisterEvent("PLAYER_LOGIN BAG_UPDATE")
	frame:RegisterEvent("CLOSE_INBOX_ITEM")
	frame:RegisterEvent("CLOSE_WORLD_MAP")
	frame:RegisterEvent("CHANNEL_COUNT_UPDATE")
	frame:RegisterEvent("MAIL_INBOX_UPDATE")
	frame:RegisterEvent("MAIL_CLOSED")
	
	local threatbar = CreateFrame("StatusBar", "ThreatBar", frame)
	threatbar:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
	threatbar:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)
	threatbar:SetStatusBarTexture(DB.Statusbar)
	S.MakeShadow(threatbar, 3)
	S.MakeBG(threatbar, 0)
	threatbar:SetMinMaxValues(0, 100)
	text = S.MakeFontString(threatbar, 10)
	text:SetPoint("CENTER", 50, 0)
	text2 = S.MakeFontString(threatbar, 10)
	text2:SetPoint("TOPLEFT", 15, -8)
	text2:SetText("")
	text3 = S.MakeFontString(threatbar, 10)
	text3:SetPoint("TOP", 0, -8)
	text3:SetText("")
	text4 = S.MakeFontString(threatbar, 10)
	text4:SetPoint("TOPRIGHT", -15, -8)
	text4:SetText("")
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
			local r, g, b = S.ColorGradient((100-threatpct)/100, InfoBarStatusColor[1][1], InfoBarStatusColor[1][2], InfoBarStatusColor[1][3], 
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
			text:SetText(threatpct.."%")
			local r, g, b = S.ColorGradient((100-threatpct)/100, InfoBarStatusColor[1][1], InfoBarStatusColor[1][2], InfoBarStatusColor[1][3], 
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
			text:SetText(threatpct.."%")
			local r, g, b = S.ColorGradient((100-threatpct)/100, InfoBarStatusColor[1][1], InfoBarStatusColor[1][2], InfoBarStatusColor[1][3], 
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
			text:SetText(threatpct.."%")
			local r, g, b = S.ColorGradient((100-threatpct)/100, InfoBarStatusColor[1][1], InfoBarStatusColor[1][2], InfoBarStatusColor[1][3], 
																		InfoBarStatusColor[2][1], InfoBarStatusColor[2][2], InfoBarStatusColor[2][3],
																		InfoBarStatusColor[3][1], InfoBarStatusColor[3][2], InfoBarStatusColor[3][3])
			threatbar:SetStatusBarColor(r, g, b)
		end
	end
end

	local function Getmail()
		local mail = HasNewMail()
		if mail == 1 then text2:SetText("New Mail") else text2:SetText("No Mail") end
	end
	
	local function Location()

		pvp,_,_ = GetZonePVPInfo()
		if pvp == "friendly" then r,g,b = 0.1,1,0.1 elseif pvp == "sanctuary" then r,g,b = 0.41,0.8,0.94 elseif pvp =="arena" then r,g,b = 1,0.1,0.1 elseif pvp == "hostile" then r,g,b = 1,0.1,0.1 elseif pvp == "contested" then r,g,b = 1,0.7,0 elseif pvp == "combat" then r,g,b = 1,0.1,0.1 else r,g,b = 1,1,1 end
		text3:SetText(GetMinimapZoneText())
		text3:SetTextColor(r,g,b)
	end
	
	local function Bag()

		local free, total = 0, 0
		for i = 0, NUM_BAG_SLOTS do
				free, total = free + GetContainerNumFreeSlots(i), total + GetContainerNumSlots(i)
		end
		text4:SetText(free.."/"..total)
	end
	
frame:SetScript("OnEvent", function() UpdateDisplay()  Getmail() Location() Bag() end)
end