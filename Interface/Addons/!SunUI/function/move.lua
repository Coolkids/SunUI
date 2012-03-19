local S, C, L, DB = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("Core"):NewModule("castbarmove")

function Module:OnInitialize()

	if not UnitFrameDB["playerCBuserplaced"] then 
		local Castbarplay = CreateFrame("Frame", "Castbarplay", UIParent) 
		Castbarplay:SetWidth(UnitFrameDB["PlayerCastBarWidth"]) 
		Castbarplay:SetHeight(UnitFrameDB["PlayerCastBarHeight"]) 
		Castbarplay:SetPoint(unpack(MoveHandleDB["PlayerCastbar"]))
		Castbarplay:Hide()
		MoveHandle.Castbarplay = S.MakeMoveHandle(Castbarplay, L["玩家施法条"], "PlayerCastbar")
	end
	if not UnitFrameDB["targetCBuserplaced"] then 
		local Castbartarget = CreateFrame("Frame", "Castbartarget", UIParent) 
		Castbartarget:SetWidth(UnitFrameDB["TargetCastBarWidth"]) 
		Castbartarget:SetHeight(UnitFrameDB["TargetCastBarHeight"]) 
		Castbartarget:SetPoint(unpack(MoveHandleDB["TargetCastbar"]))
		Castbartarget:Hide()
		MoveHandle.Castbartarget = S.MakeMoveHandle(Castbartarget, L["目标施法条"], "TargetCastbar")
	end
	if not UnitFrameDB["focusCBuserplaced"] then 
		local Castbarfouce = CreateFrame("Frame", "Castbarfouce", UIParent) 
		Castbarfouce:SetWidth(UnitFrameDB["FocusCastBarWidth"]) 
		Castbarfouce:SetHeight(UnitFrameDB["FocusCastBarHeight"]) 
		Castbarfouce:SetPoint(unpack(MoveHandleDB["FocusCastbar"]))
		Castbarfouce:Hide()
		MoveHandle.Castbarfouce = S.MakeMoveHandle(Castbarfouce, L["焦点施法条"], "FocusCastbar")
	end
	if DB.MyClass == "PRIEST" then
		local ShadowPet = CreateFrame("Frame", "ShadowPet", UIParent) 
		ShadowPet:SetWidth(110) 
		ShadowPet:SetHeight(10) 
		ShadowPet:SetPoint(unpack(MoveHandleDB["ShadowPet"]))
		ShadowPet:Hide()
		MoveHandle.ShadowPet = S.MakeMoveHandle(ShadowPet, L["暗影魔计时条"], "ShadowPet")
	end

	local ClassCD = CreateFrame("Frame", "ClassCD", UIParent) 
	ClassCD:SetWidth(MiniDB["ClassCDWidth"]+MiniDB["ClassCDHeight"]*2+5)
	ClassCD:SetHeight(MiniDB["ClassCDHeight"]*2) 
	ClassCD:SetPoint(unpack(MoveHandleDB["ClassCD"]))
	ClassCD:Hide()
	MoveHandle.ClassCD = S.MakeMoveHandle(ClassCD, L["内置CD监视"], "ClassCD")

	local Threat = CreateFrame("Frame", "Threat", UIParent) 
	Threat:SetWidth(ThreatDB["ThreatBarWidth"]) 
	Threat:SetHeight(6) 
	Threat:SetPoint(unpack(MoveHandleDB["Threat"]))
	Threat:Hide()
	MoveHandle.Threat = S.MakeMoveHandle(Threat, L["仇恨监视"], "Threat")

	local Reminder = CreateFrame("Frame", "Reminder", UIParent) 
		if ReminderDB["RaidBuffDirection"] == 1 then 
			Reminder:SetWidth(ReminderDB["RaidBuffSize"]*7+5) 
			Reminder:SetHeight(ReminderDB["RaidBuffSize"]) 
			else
			Reminder:SetWidth(ReminderDB["RaidBuffSize"]) 
			Reminder:SetHeight(ReminderDB["RaidBuffSize"]*7+5) 
		end
	Reminder:SetPoint(unpack(MoveHandleDB["Reminder"]))
	Reminder:Hide()
	MoveHandle.Reminder = S.MakeMoveHandle(Reminder, L["药水"], "Reminder")

	local Class = CreateFrame("Frame", "Class", UIParent) 
	Class:SetWidth(ReminderDB["ClassBuffSize"]) 
	Class:SetHeight(ReminderDB["ClassBuffSize"]) 
	Class:SetPoint(unpack(MoveHandleDB["Class"]))
	Class:Hide()
	MoveHandle.Class = S.MakeMoveHandle(Class, L["缺少药剂buff提示"], "Class")

	local RollFrame = CreateFrame("Frame", "RollFrame", UIParent) 
	RollFrame:SetWidth(340) 
	RollFrame:SetHeight(22) 
	RollFrame:SetPoint(unpack(MoveHandleDB["RollFrame"]))
	RollFrame:Hide()
	MoveHandle.RollFrame = S.MakeMoveHandle(RollFrame, "Roll", "RollFrame")

	if ActionBarDB["CooldownFlash"] then
		local CooldownFlash = CreateFrame("Frame", "CooldownFlash", UIParent) 
		CooldownFlash:SetWidth(ActionBarDB["CooldownFlashSize"])
		CooldownFlash:SetHeight(ActionBarDB["CooldownFlashSize"])
		CooldownFlash:SetPoint(unpack(MoveHandleDB["CooldownFlash"]))
		CooldownFlash:Hide()
		MoveHandle.CooldownFlash = S.MakeMoveHandle(CooldownFlash, L["冷却闪光"], "CooldownFlash")
	end

	if DB.MyClass == "ROGUE" or DB.MyClass == "DRUID" then  
		local Combatpoint = CreateFrame("Frame", "Combatpoint", UIParent) 
		Combatpoint:SetWidth(180) 
		Combatpoint:SetHeight(45) 
		Combatpoint:SetPoint(unpack(MoveHandleDB["Combatpoint"]))
		Combatpoint:Hide()
		MoveHandle.Combatpoint = S.MakeMoveHandle(Combatpoint, L["连击点"], "Combatpoint")
	end
	
end