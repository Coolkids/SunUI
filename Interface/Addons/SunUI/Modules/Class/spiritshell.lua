local S, C, L, DB = unpack(select(2, ...))
if DB.MyClass ~= "PRIEST" then return end
local _
local Module = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("Spirit_Shell_Watch")
local spellid = 114908
local frame, damage, name
local spellname = GetSpellInfo(spellid)
frame = CreateFrame("Button", nil, UIParent)
damage = S.MakeFontString(frame)
damage:SetPoint("BOTTOMLEFT",  frame, "BOTTOMRIGHT", 3, -3)
frame:SetScript("OnEvent", function() end)
local function CreateModule()
	frame:SetSize(24, 24)
	MoveHandle.Ignite = S.MakeMoveHandle(frame, spellname, "Ignite")
	frame:SetNormalTexture(select(3, GetSpellInfo(spellid)))
	frame:GetNormalTexture():SetTexCoord(0.1, 0.9, 0.1, 0.9)
	frame:CreateShadow()
	frame:Hide()
	damage:SetText("")
	frame.text = S.MakeFontString(frame)
	frame.text:SetPoint("TOPLEFT",  frame, "TOPRIGHT", 3, 3)
	frame.text:SetText(GetSpellInfo(spellid))
end

local function TalentUpdate()
	frame:RegisterEvent("PLAYER_TALENT_UPDATE")
	frame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
	frame:RegisterEvent("PLAYER_ENTERING_WORLD")
	frame:HookScript("OnEvent", function(self, event)
		if event == "PLAYER_TALENT_UPDATE" or event == "ACTIVE_TALENT_GROUP_CHANGED" or event == "PLAYER_ENTERING_WORLD" then
			if event == "PLAYER_ENTERING_WORLD" then
				self:UnregisterEvent("PLAYER_ENTERING_WORLD")
			end
			local tree = GetSpecialization()
			if tree ~= 1 then
				self:UnregisterEvent("UNIT_AURA")
				self:UnregisterEvent("PLAYER_TARGET_CHANGED")
			else
				self:RegisterEvent("UNIT_AURA")
				self:RegisterEvent("PLAYER_TARGET_CHANGED")
				self:Hide()
			end
		end
	end)
end

local function UpdateDamage()
	frame:HookScript("OnEvent", function(self, event, unit)
		if event == "PLAYER_TARGET_CHANGED" or (event == "UNIT_AURA" and unit == "target")  then
			local name = UnitBuff("target", spellname, _, "PLAYER")
			local max = S.ShortValue(UnitHealthMax("player") * 0.6)
			local value = select(15, UnitBuff("target", spellname, _, "PLAYER")) or 0
			value = S.ShortValue(value)
			if name then
				self:Show()
				damage:SetText(value.."/"..max)
			else
				self:Hide()
			end
		end
	end)
end

function Module:OnEnable()
	CreateModule()
	TalentUpdate()
	UpdateDamage()
end