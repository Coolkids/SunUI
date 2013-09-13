local S, L, DB, _, C = unpack(select(2, ...))
if DB.MyClass ~= "MAGE" then return end
local IW = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("IgniteWatch", "AceEvent-3.0")
local SunUIConfig = LibStub("AceAddon-3.0"):GetAddon("SunUI"):GetModule("SunUIConfig")
local spellid = 12654
local frame, damage
local spellname = GetSpellInfo(spellid)
frame = CreateFrame("Button", nil, UIParent)
damage = S.MakeFontString(frame)
damage:SetPoint("BOTTOMLEFT",  frame, "BOTTOMRIGHT", 3, -3)
frame:SetNormalTexture(GetSpellTexture(spellid))
frame:GetNormalTexture():SetTexCoord(0.1, 0.9, 0.1, 0.9)
frame:CreateShadow()
frame:Hide()
damage:SetText("")
frame.text = S.MakeFontString(frame)
frame.text:SetPoint("TOPLEFT",  frame, "TOPRIGHT", 3, 3)
frame.text:SetText(GetSpellInfo(spellid))
function IW:UpdateSet()
	if C["EnableIgniteWatch"] then 
		frame:SetSize(C["IgniteWatchSize"], C["IgniteWatchSize"])
		self:ACTIVE_TALENT_GROUP_CHANGED()
	else
		frame:Hide()
		self:UnregisterAllEvents()
	end
end

function IW:ACTIVE_TALENT_GROUP_CHANGED()
	local tree = GetSpecialization()
	if tree ~= 2 then
		self:UnregisterEvent("UNIT_AURA")
		self:UnregisterEvent("PLAYER_TARGET_CHANGED")
		frame:Hide()
	else
		self:RegisterEvent("UNIT_AURA")
		self:RegisterEvent("PLAYER_TARGET_CHANGED")
	end
end
function IW:PLAYER_TARGET_CHANGED()
	self:UNIT_AURA(nil, "target")
end
function IW:UNIT_AURA(event, unit)
	if unit ~= "target" then return end
	local name = UnitDebuff("target", spellname, _, "PLAYER")
	local value = select(15, UnitDebuff("target", spellname, _, "PLAYER")) or 0
	value = S.ShortValue(value)
	if name then
		frame:Show()
		damage:SetText(value)
	else
		frame:Hide()
	end
end
function IW:OnInitialize()
	C = SunUIConfig.db.profile.ClassToolsDB
	self:UpdateSet()
	MoveHandle.Ignite = S.MakeMoveHandle(frame, spellname, "Ignite")
end