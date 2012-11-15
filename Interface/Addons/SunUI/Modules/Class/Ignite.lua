local S, C, L, DB = unpack(select(2, ...))
if DB.MyClass ~= "MAGE" then return end
local _
local Module = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("IgniteWatch")
local spellid = 12654
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
			if tree ~= 2 then
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
		if unit ~= "target" then return end
		if event == "PLAYER_TARGET_CHANGED" or event == "UNIT_AURA" then
			local name = UnitDebuff("target", spellname, _, "PLAYER")
			local value = select(14, UnitDebuff("target", spellname, _, "PLAYER"))
			if name then 
				self:Show()
				damage:SetText(value)
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