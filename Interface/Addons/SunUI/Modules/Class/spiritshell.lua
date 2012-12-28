local S, L, DB, _, C = unpack(select(2, ...))
if DB.MyClass ~= "PRIEST" then return end
local SW = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("SpiritShell_Watch", "AceEvent-3.0")
local SunUIConfig = LibStub("AceAddon-3.0"):GetAddon("SunUI"):GetModule("SunUIConfig")
local spellid = 114908
local frame, damage, name
local spellname = GetSpellInfo(spellid)
frame = CreateFrame("Button", nil, UIParent)
damage = S.MakeFontString(frame)
damage:SetPoint("BOTTOMLEFT",  frame, "BOTTOMRIGHT", 3, -3)
frame:SetNormalTexture(GetSpellTexture(spellid))
frame:GetNormalTexture():SetTexCoord(0.1, 0.9, 0.1, 0.9)
frame:CreateShadow()
damage:SetText("")
frame.text = S.MakeFontString(frame)
frame.text:SetPoint("TOPLEFT",  frame, "TOPRIGHT", 3, 3)
frame.text:SetText(GetSpellInfo(spellid))
frame:Hide()

function SW:UpdateSet()
	if C["EnableSpiritShellWatch"] then
		frame:SetSize(C["SpiritShellWatchSize"], C["SpiritShellWatchSize"])
		self:ACTIVE_TALENT_GROUP_CHANGED()
	else
		frame:Hide()
		self:UnregisterAllEvents()
	end
end

function SW:ACTIVE_TALENT_GROUP_CHANGED()
	local tree = GetSpecialization()
	if tree ~= 1 then
		self:UnregisterEvent("UNIT_AURA")
		self:UnregisterEvent("PLAYER_TARGET_CHANGED")
		frame:Hide()
	else
		self:RegisterEvent("UNIT_AURA")
		self:RegisterEvent("PLAYER_TARGET_CHANGED")
	end
end

function SW:UNIT_AURA(event, unit)
	if unit ~= "target" then return end
	local name = UnitBuff("target", spellname, _, "PLAYER")
	local max = S.ShortValue(UnitHealthMax("player") * 0.6)
	local value = select(15, UnitBuff("target", spellname, _, "PLAYER")) or 0
	value = S.ShortValue(value)
	if name then
		frame:Show()
		damage:SetText(value.."/"..max)
	else
		frame:Hide()
	end
end
function SW:PLAYER_TARGET_CHANGED()
	self:UNIT_AURA(event, "target")
end

function SW:OnInitialize()
	C = SunUIConfig.db.profile.ClassToolsDB
	self:UpdateSet()
	MoveHandle.Ignite = S.MakeMoveHandle(frame, spellname, "Ignite")
end