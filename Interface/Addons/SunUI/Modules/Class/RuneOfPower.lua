local S, L, DB, _, C = unpack(select(2, ...))
if DB.MyClass ~= "MAGE" then return end
local ROP = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("RuneOfPower", "AceEvent-3.0")
local SunUIConfig = LibStub("AceAddon-3.0"):GetAddon("SunUI"):GetModule("SunUIConfig")
local spellid = 116011
local index = 1
local button1 = CreateFrame("Button", nil, UIParent)
button1:SetNormalTexture(GetSpellTexture(spellid))
button1:GetNormalTexture():SetTexCoord(0.1, 0.9, 0.1, 0.9)
button1.cooldown = CreateFrame("Cooldown", nil, button1)
button1.cooldown:SetAllPoints()
button1.cooldown:SetReverse(true)
button1:CreateShadow("Background")
button1:Hide()

local button2 = CreateFrame("Button", nil, UIParent)
button2:SetPoint("LEFT", button1, "RIGHT", 3, 0)
button2:SetNormalTexture(GetSpellTexture(spellid))
button2:GetNormalTexture():SetTexCoord(0.1, 0.9, 0.1, 0.9)
button2.cooldown = CreateFrame("Cooldown", nil, button2)
button2.cooldown:SetAllPoints()
button2.cooldown:SetReverse(true)
button2:CreateShadow("Background")
button2:Hide()

local function StopTimer(button)
	button:Hide()
end

local function BarUpdate(self, elapsed)
	local curTime = GetTime()
	if self.endtime < curTime then
		StopTimer(self)
		return
	end
end

local function StartTime()
	if index == 1 then
		button1.endtime = GetTime() + 60
		button1:Show()
		CooldownFrame_SetTimer(button1.cooldown, GetTime(), 60, 1)
		button1:SetScript("OnUpdate", BarUpdate)
		index = index +1
	else
		button2.endtime = GetTime() + 60
		button2:Show()
		CooldownFrame_SetTimer(button2.cooldown, GetTime(), 60, 1)
		button2:SetScript("OnUpdate", BarUpdate)
		index = 1
	end
end

function ROP:COMBAT_LOG_EVENT_UNFILTERED(times, temp, event, ...)
	local _, sourceGUID, _, _, _, destGUID, _, _, _, spellID = ...
	--if sourceGUID == UnitGUID("player") then print(event, spellID) end
	if event == "SPELL_SUMMON" and sourceGUID == UnitGUID("player") and spellID == spellid then
		StartTime()
	end
end
function ROP:UpdateSize()
	button1:SetSize(C["ROPSize"], C["ROPSize"])
	button2:SetSize(C["ROPSize"], C["ROPSize"])
end
function ROP:UpdateSet()
	if C["ROPEnable"] then
		self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		self:RegisterEvent("PLAYER_TALENT_UPDATE")
	else
		button1:Hide()
		button2:Hide()
		self:UnregisterEvent("PLAYER_TALENT_UPDATE")
		self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	end
end
function ROP:PLAYER_TALENT_UPDATE()
	if IsSpellKnown(spellid) then
		self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	else
		self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	end
end
function ROP:OnInitialize()
	C = SunUIConfig.db.profile.ClassToolsDB
	self:UpdateSize()
	self:UpdateSet()
	MoveHandle.ROP = S.MakeMoveHandle(button1, select(1, GetSpellInfo(spellid)), "RuneOfPower")
end