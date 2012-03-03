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
	Castbarplay:Width(A["PlayerCastBarWidth"]) 
	Castbarplay:Height(A["PlayerCastBarHeight"]) 
	Castbarplay:Point(unpack(C["PlayerCastbar"]))
	Castbarplay:Hide()
	MoveHandle.Castbarplay = S.MakeMoveHandle(Castbarplay, L["玩家施法条"], "PlayerCastbar")
end
if not A["targetCBuserplaced"] then 
	local Castbartarget = CreateFrame("Frame", "Castbartarget", UIParent) 
	Castbartarget:Width(A["TargetCastBarWidth"]) 
	Castbartarget:Height(A["TargetCastBarHeight"]) 
	Castbartarget:Point(unpack(C["TargetCastbar"]))
	Castbartarget:Hide()
	MoveHandle.Castbartarget = S.MakeMoveHandle(Castbartarget, L["目标施法条"], "TargetCastbar")
end
if not A["focusCBuserplaced"] then 
	local Castbarfouce = CreateFrame("Frame", "Castbarfouce", UIParent) 
	Castbarfouce:Width(A["FocusCastBarWidth"]) 
	Castbarfouce:Height(A["FocusCastBarHeight"]) 
	Castbarfouce:Point(unpack(C["FocusCastbar"]))
	Castbarfouce:Hide()
	MoveHandle.Castbarfouce = S.MakeMoveHandle(Castbarfouce, L["焦点施法条"], "FocusCastbar")
end
local ShadowPet = CreateFrame("Frame", "ShadowPet", UIParent) 
ShadowPet:Width(140) 
ShadowPet:Height(20) 
ShadowPet:Point(unpack(C["ShadowPet"]))
ShadowPet:Hide()

local ClassCD = CreateFrame("Frame", "ClassCD", UIParent) 
ClassCD:Width(B["ClassCDWidth"]+B["ClassCDHeight"]*2+5)
ClassCD:Height(B["ClassCDHeight"]*2) 
ClassCD:Point(unpack(C["ClassCD"]))
ClassCD:Hide()
local Threat = CreateFrame("Frame", "Threat", UIParent) 
Threat:Width(D["ThreatBarWidth"]) 
Threat:Height(6) 
Threat:Point(unpack(C["Threat"]))
Threat:Hide()
local Reminder = CreateFrame("Frame", "Reminder", UIParent) 
	if M["RaidBuffDirection"] == 1 then 
		Reminder:Width(M["RaidBuffSize"]*7+5) 
		Reminder:Height(M["RaidBuffSize"]) 
		else
		Reminder:Width(M["RaidBuffSize"]) 
		Reminder:Height(M["RaidBuffSize"]*7+5) 
	end
Reminder:Point(unpack(C["Reminder"]))
Reminder:Hide()
local Class = CreateFrame("Frame", "Class", UIParent) 
Class:Width(M["ClassBuffSize"]) 
Class:Height(M["ClassBuffSize"]) 
Class:Point(unpack(C["Class"]))
Class:Hide()
local RollFrame = CreateFrame("Frame", "RollFrame", UIParent) 
RollFrame:Width(340) 
RollFrame:Height(22) 
RollFrame:Point(unpack(C["RollFrame"]))
RollFrame:Hide()
local CooldownFlash = CreateFrame("Frame", "CooldownFlash", UIParent) 
CooldownFlash:Width(E["CooldownFlashSize"]*S.Scale(1))
CooldownFlash:Height(E["CooldownFlashSize"]*S.Scale(1))
CooldownFlash:Point(unpack(C["CooldownFlash"]))
CooldownFlash:Hide()
	if DB.MyClass == "ROGUE" or DB.MyClass == "DRUID" then  
		local Combatpoint = CreateFrame("Frame", "Combatpoint", UIParent) 
		Combatpoint:Width(180) 
		Combatpoint:Height(45) 
		Combatpoint:Point(unpack(C["Combatpoint"]))
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