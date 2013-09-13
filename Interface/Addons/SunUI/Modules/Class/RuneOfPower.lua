local S, L, DB, _, C = unpack(select(2, ...))
if DB.MyClass ~= "MAGE" then return end
local ROP = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("RuneOfPower", "AceEvent-3.0")
local SunUIConfig = LibStub("AceAddon-3.0"):GetAddon("SunUI"):GetModule("SunUIConfig")
local spellid = 116011
local index, num = 1, 0
local Holder = CreateFrame("Frame", nil, UIParent)
local buttons = {}


function ROP:StopTimer(button)
	--print("Stop")
	button:SetScript("OnUpdate", nil)
	tremove(buttons, button.id)
	button:Hide()
	button = nil
	self:UpdatePoint()
end
local function BarUpdate(self, elapsed)
	local curTime = GetTime()
	if self.endtime < curTime then
		ROP:StopTimer(self)
		return
	end
end
function ROP:UpdatePoint()
	if #buttons > 2 then 
		self:StopTimer(buttons[1])
	end
	for i = 1, #buttons do
		buttons[i]:ClearAllPoints()
		if i == 1 then
			buttons[i]:SetPoint("CENTER", Holder)
		else
			buttons[i]:SetPoint("LEFT", buttons[i-1], "RIGHT", 5, 0)
		end
		buttons[i].id = i
	end
end

local OnMouseDown = function(self, button)
	if button == "RightButton" then
		ROP:StopTimer(self)
	end
end
local function CreateButton()
	local button = CreateFrame("Button", nil, UIParent)
	button:SetSize(C["ROPSize"], C["ROPSize"])
	button:SetNormalTexture(GetSpellTexture(spellid))
	button:GetNormalTexture():SetTexCoord(0.1, 0.9, 0.1, 0.9)
	button.cooldown = CreateFrame("Cooldown", nil, button)
	button.cooldown:SetAllPoints()
	button.cooldown:SetReverse(true)
	button:CreateShadow()
	return button
end

local function StartTime()
	local button = CreateButton()
	button.endtime = GetTime() + 60
	CooldownFrame_SetTimer(button.cooldown, GetTime(), 60, 1)
	button:SetScript("OnUpdate", BarUpdate)
	button:SetScript("OnMouseDown", OnMouseDown)
	tinsert(buttons, button)
	ROP:UpdatePoint()
end

function ROP:COMBAT_LOG_EVENT_UNFILTERED(times, temp, event, ...)
	local _, sourceGUID, _, _, _, destGUID, _, _, _, spellID = ...
	--if sourceGUID == UnitGUID("player") then print(event, spellID) end
	if event == "SPELL_SUMMON" and sourceGUID == UnitGUID("player") and spellID == spellid then
		StartTime()
	end
end
function ROP:UpdateSize()
	Holder:SetSize(C["ROPSize"], C["ROPSize"])
	for i = 1, #buttons do
		buttons[i]:SetSize(C["ROPSize"], C["ROPSize"])
	end
end
function ROP:UpdateSet()
	if C["ROPEnable"] then
		self:RegisterEvent("PLAYER_TALENT_UPDATE")
	else
		button1:Hide()
		button2:Hide()
		self:UnregisterEvent("PLAYER_TALENT_UPDATE")
		self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	end
end
function ROP:PLAYER_TALENT_UPDATE()
	local study
	local name, iconTexture, tier, column, selected, available = GetTalentInfo(17,false,GetActiveSpecGroup(false,false))
	if selected and name == select(1, GetSpellInfo(spellid)) then
		study = true
	else
		study =false
	end
	if study then
		self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	else
		self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	end
end
function ROP:OnInitialize()
	C = SunUIConfig.db.profile.ClassToolsDB
	self:UpdateSize()
	self:UpdateSet()
	MoveHandle.ROP = S.MakeMoveHandle(Holder, select(1, GetSpellInfo(spellid)), "RuneOfPower")
end