local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local CT = S:NewModule("ClassTools", "AceEvent-3.0", "AceHook-3.0", "AceConsole-3.0")
local start, duration

local datebase = {
	["PRIEST"] = {
		[0] = {},
		[1] = {},
		[2] = {},
		[3] = {
			["spellid"] = 32379,	--暗言术：死
			["per"] = 0.2,
			["level"] = 50,
		},
	},
	["HUNTER"] = {
		[0] = {
			["spellid"] = 53351,	--杀戮射击
			["per"] = 0.2,
			["level"] = 50,
		},
		[1] = {},
		[2] = {},
		[3] = {},
	},
	["MAGE"] = {},
	["WARLOCK"] = {
		[0] = {},
		[1] = {
			["spellid"] = 1120,	--灵魂吸取
			["per"] = 0.2,
			["level"] = 85,
		},
		[2] = {},
		[3] = {
			["spellid"] = 17877,	--暗影灼烧
			["per"] = 0.2,
			["level"] = 85,
		},
	},
	["PALADIN"] = {
		[0] = {},
		[1] = {},
		[2] = {},
		[3] = {
			["spellid"] = 24275,	--愤怒之锤
			["per"] = 0.2,
			["level"] = 50,
		},
	},
	["ROGUE"] = {
		[0] = {
			["spellid"] = 111240,	--斩击
			["per"] = 0.35,
			["level"] = 85,
		},
		[1] = {},
		[2] = {},
		[3] = {},
	},
	["DRUID"] = {},
	["SHAMAN"] = {},
	["WARRIOR"] = {
		[0] = {},
		[1] = {
			["spellid"] = 5308,	--斩杀
			["per"] = 0.2,
			["level"] = 85,
		},
		[2] = {
			["spellid"] = 5308,	--斩杀
			["per"] = 0.2,
			["level"] = 85,
		},
		[3] = {},
	},
	["DEATHKNIGHT"] = {
		[0] = {},
		[1] = {},
		[2] = {
			["spellid"] = 130736,	--灵魂收割
			["per"] = 0.35,
			["level"] = 85,
		},
		[3] = {
			["spellid"] = 130736,	--灵魂收割
			["per"] = 0.35,
			["level"] = 85,
		},
	},
	["MONK"] = {},
}
--Parent
local Frame = CreateFrame("Frame", nil, UIParent)
Frame:Hide()
Frame:SetPoint("TOP", "UIParent", "TOP", 0, -35)
--Children
	--CooldownFrame
Frame.Cooldown = CreateFrame("Cooldown", nil, Frame)
Frame.Cooldown:SetAllPoints()
Frame.Cooldown:SetReverse(true)
	-- IconTexture
Frame.Icon = Frame:CreateTexture(nil, "ARTWORK") 
Frame.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
Frame.Icon:SetAllPoints(Frame)
function CT:ACTIVE_TALENT_GROUP_CHANGED()
	local spec = GetSpecialization()
	local texture
	if not spec then return end
	--print(#datebase[S.myclass])
	if #datebase[S.myclass] == 0 then 
		CT:UnregisterAllEvents()
		return
	end
	if datebase[S.myclass][0].spellid then
		texture = GetSpellTexture(datebase[S.myclass][0].spellid)
		Frame.spellid = datebase[S.myclass][0].spellid
		Frame.per = datebase[S.myclass][0].per
		Frame.level = datebase[S.myclass][0].level
		CT:RegisterEvent("UNIT_HEALTH")
		CT:RegisterEvent("PLAYER_TARGET_CHANGED")
		CT:RegisterEvent("SPELL_UPDATE_COOLDOWN")
		Frame.Icon:SetTexture(texture) 
		return
	end
	if datebase[S.myclass][spec].spellid then 
		texture = GetSpellTexture(datebase[S.myclass][spec].spellid)
		Frame.spellid = datebase[S.myclass][spec].spellid
		Frame.per = datebase[S.myclass][spec].per
		Frame.level = datebase[S.myclass][spec].level
		CT:RegisterEvent("UNIT_HEALTH")
		CT:RegisterEvent("PLAYER_TARGET_CHANGED")
		CT:RegisterEvent("SPELL_UPDATE_COOLDOWN")
		Frame.Icon:SetTexture(texture) 
		return
	else
		CT:UnregisterEvent("UNIT_HEALTH")
		CT:UnregisterEvent("PLAYER_TARGET_CHANGED")
		CT:UnregisterEvent("SPELL_UPDATE_COOLDOWN")
		Frame:Hide()
	end
end
function CT:UpdateSet()
	local Data = S:GetModule("ClassAT")
	if Data.db.Enable then
		Frame:SetSize(Data.db.Size, Data.db.Size)
		CT:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
		CT:RegisterEvent("PLAYER_ENTERING_WORLD", function()
			CT:UnregisterEvent("PLAYER_ENTERING_WORLD")
			CT:ACTIVE_TALENT_GROUP_CHANGED()
		end)
	else
		Frame:Hide()
		CT:UnregisterAllEvents()
	end
end
function CT:UNIT_HEALTH(event, unit)
	if unit ~= "target" then return end
	if ( UnitCanAttack("player", "target") and not UnitIsDead("target") and ( UnitHealth("target")/UnitHealthMax("target") < Frame.per and UnitLevel("player") > Frame.level ) and not UnitIsDead("player") ) then
		if not Frame:IsShown() then
			Frame:Show()
		end
	else
		if Frame:IsShown() then
			Frame:Hide()
		end
	end
end
function CT:SPELL_UPDATE_COOLDOWN()
	local start, duration = GetSpellCooldown(Frame.spellid)
	Frame.Cooldown:SetReverse(false)
	CooldownFrame_SetTimer(Frame.Cooldown, start, duration, 1)
end
function CT:PLAYER_TARGET_CHANGED()
	self:UNIT_HEALTH(event, "target")
end
function CT:Init()
	local Data = S:GetModule("ClassAT")
	C = Data.db
	Frame:CreateShadow()
	self:UpdateSet()
	S:CreateMover(Frame, "ClassToolsMover", L["斩杀提示"], true, nil, "ALL,MINITOOLS")
end