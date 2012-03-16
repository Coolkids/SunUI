local S, C, L, DB = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("Core"):NewModule("castbarmove")

function Module:OnInitialize()
C = MoveHandleDB
D = ThreatDB
M = ReminderDB
A = UnitFrameDB
B = MiniDB
E = ActionBarDB
if not A["playerCBuserplaced"] then 
	local Castbarplay = CreateFrame("Frame", "Castbarplay", UIParent) 
	Castbarplay:SetWidth(A["PlayerCastBarWidth"]) 
	Castbarplay:SetHeight(A["PlayerCastBarHeight"]) 
	Castbarplay:SetPoint(unpack(C["PlayerCastbar"]))
	Castbarplay:Hide()
	MoveHandle.Castbarplay = S.MakeMoveHandle(Castbarplay, L["玩家施法条"], "PlayerCastbar")
end
if not A["targetCBuserplaced"] then 
	local Castbartarget = CreateFrame("Frame", "Castbartarget", UIParent) 
	Castbartarget:SetWidth(A["TargetCastBarWidth"]) 
	Castbartarget:SetHeight(A["TargetCastBarHeight"]) 
	Castbartarget:SetPoint(unpack(C["TargetCastbar"]))
	Castbartarget:Hide()
	MoveHandle.Castbartarget = S.MakeMoveHandle(Castbartarget, L["目标施法条"], "TargetCastbar")
end
if not A["focusCBuserplaced"] then 
	local Castbarfouce = CreateFrame("Frame", "Castbarfouce", UIParent) 
	Castbarfouce:SetWidth(A["FocusCastBarWidth"]) 
	Castbarfouce:SetHeight(A["FocusCastBarHeight"]) 
	Castbarfouce:SetPoint(unpack(C["FocusCastbar"]))
	Castbarfouce:Hide()
	MoveHandle.Castbarfouce = S.MakeMoveHandle(Castbarfouce, L["焦点施法条"], "FocusCastbar")
end
local ShadowPet = CreateFrame("Frame", "ShadowPet", UIParent) 
ShadowPet:SetWidth(110) 
ShadowPet:SetHeight(10) 
ShadowPet:SetPoint(unpack(C["ShadowPet"]))
ShadowPet:Hide()

local ClassCD = CreateFrame("Frame", "ClassCD", UIParent) 
ClassCD:SetWidth(B["ClassCDWidth"]+B["ClassCDHeight"]*2+5)
ClassCD:SetHeight(B["ClassCDHeight"]*2) 
ClassCD:SetPoint(unpack(C["ClassCD"]))
ClassCD:Hide()
local Threat = CreateFrame("Frame", "Threat", UIParent) 
Threat:SetWidth(D["ThreatBarWidth"]) 
Threat:SetHeight(6) 
Threat:SetPoint(unpack(C["Threat"]))
Threat:Hide()
local Reminder = CreateFrame("Frame", "Reminder", UIParent) 
	if M["RaidBuffDirection"] == 1 then 
		Reminder:SetWidth(M["RaidBuffSize"]*7+5) 
		Reminder:SetHeight(M["RaidBuffSize"]) 
		else
		Reminder:SetWidth(M["RaidBuffSize"]) 
		Reminder:SetHeight(M["RaidBuffSize"]*7+5) 
	end
Reminder:SetPoint(unpack(C["Reminder"]))
Reminder:Hide()
local Class = CreateFrame("Frame", "Class", UIParent) 
Class:SetWidth(M["ClassBuffSize"]) 
Class:SetHeight(M["ClassBuffSize"]) 
Class:SetPoint(unpack(C["Class"]))
Class:Hide()
local RollFrame = CreateFrame("Frame", "RollFrame", UIParent) 
RollFrame:SetWidth(340) 
RollFrame:SetHeight(22) 
RollFrame:SetPoint(unpack(C["RollFrame"]))
RollFrame:Hide()
local CooldownFlash = CreateFrame("Frame", "CooldownFlash", UIParent) 
CooldownFlash:SetWidth(E["CooldownFlashSize"]*S.Scale(1))
CooldownFlash:SetHeight(E["CooldownFlashSize"]*S.Scale(1))
CooldownFlash:SetPoint(unpack(C["CooldownFlash"]))
CooldownFlash:Hide()
	if DB.MyClass == "ROGUE" or DB.MyClass == "DRUID" then  
		local Combatpoint = CreateFrame("Frame", "Combatpoint", UIParent) 
		Combatpoint:SetWidth(180) 
		Combatpoint:SetHeight(45) 
		Combatpoint:SetPoint(unpack(C["Combatpoint"]))
		Combatpoint:Hide()
	end

	
	
	
	
	MoveHandle.ClassCD = S.MakeMoveHandle(ClassCD, L["内置CD监视"], "ClassCD")
	MoveHandle.Threat = S.MakeMoveHandle(Threat, L["仇恨监视"], "Threat")
	MoveHandle.Reminder = S.MakeMoveHandle(Reminder, L["药水"], "Reminder")
	MoveHandle.Class = S.MakeMoveHandle(Class, L["缺少药剂buff提示"], "Class")
	MoveHandle.CooldownFlash = S.MakeMoveHandle(CooldownFlash, L["冷却闪光"], "CooldownFlash")
	MoveHandle.RollFrame = S.MakeMoveHandle(RollFrame, "Roll", "RollFrame")
	
		if DB.MyClass == "ROGUE" or DB.MyClass == "DRUID" then  
			MoveHandle.Combatpoint = S.MakeMoveHandle(Combatpoint, L["连击点"], "Combatpoint")
		end
		if DB.MyClass == "PRIEST" then
			MoveHandle.ShadowPet = S.MakeMoveHandle(ShadowPet, L["暗影魔计时条"], "ShadowPet")
		end
end