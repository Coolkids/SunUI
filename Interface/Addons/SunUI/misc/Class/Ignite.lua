local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local

local IW = S:NewModule("IgniteWatch", "AceEvent-3.0")
local spellid = 12654
local damage
local spellname = GetSpellInfo(spellid)
local frame
function IW:UpdateSet()
	local Data = S:GetModule("ClassAT")
	if frame == nil then return end
	if Data.db.EnableIgniteWatch then 
		frame:SetSize(Data.db.IgniteWatchSize, Data.db.IgniteWatchSize)
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
	value = S:ShortValue(value)
	if name then
		frame:Show()
		damage:SetText(value)
	else
		frame:Hide()
	end
end
function IW:Init()
	if S.myclass ~= "MAGE" then return end
	frame = CreateFrame("Button", nil, UIParent)
	frame:Hide()
	frame:SetPoint("BOTTOM", "UIParent", "BOTTOM",  325,  168)
	damage = S:CreateFS(frame)
	damage:SetPoint("BOTTOMLEFT",  frame, "BOTTOMRIGHT", 3, -3)
	damage:SetText("")
	frame:SetNormalTexture(GetSpellTexture(spellid))
	frame:GetNormalTexture():SetTexCoord(0.1, 0.9, 0.1, 0.9)
	frame:CreateShadow()
	
	frame.text = S:CreateFS(frame)
	frame.text:SetPoint("TOPLEFT",  frame, "TOPRIGHT", 3, 3)
	frame.text:SetText(GetSpellInfo(spellid))
	self:UpdateSet()
	S:CreateMover(frame, "IgniteWatchMover", L["燃火监视"], true, nil, "MINITOOLS")
end