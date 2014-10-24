local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local CT = S:NewModule("ClassTools", "AceEvent-3.0", "AceHook-3.0", "AceConsole-3.0")

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
CT.ButtonList = {}
function CT:ACTIVE_TALENT_GROUP_CHANGED()
	local spec = GetSpecialization()
	if not spec then return end
	--print(#datebase[S.myclass])
	if #datebase[S.myclass] == 0 then 
		self:UnregisterAllEvents()
		return
	end
	if datebase[S.myclass][0].spellid then
		self.spellid = datebase[S.myclass][0].spellid
		self.per = datebase[S.myclass][0].per
		self.level = datebase[S.myclass][0].level
		self:RegisterEvent("UNIT_HEALTH")
		self:RegisterEvent("PLAYER_TARGET_CHANGED")
		self:RegisterEvent("SPELL_UPDATE_COOLDOWN")
		self:RegisterEvent("ACTIONBAR_SLOT_CHANGED")
		return
	end
	if datebase[S.myclass][spec].spellid then 
		self.spellid = datebase[S.myclass][spec].spellid
		self.per = datebase[S.myclass][spec].per
		self.level = datebase[S.myclass][spec].level
		self:RegisterEvent("UNIT_HEALTH")
		self:RegisterEvent("PLAYER_TARGET_CHANGED")
		self:RegisterEvent("SPELL_UPDATE_COOLDOWN")
		self:RegisterEvent("ACTIONBAR_SLOT_CHANGED")
		return
	else
		self:UnregisterEvent("UNIT_HEALTH")
		self:UnregisterEvent("PLAYER_TARGET_CHANGED")
		self:UnregisterEvent("SPELL_UPDATE_COOLDOWN")
		self:UnregisterEvent("ACTIONBAR_SLOT_CHANGED")
	end
end

function CT:UpdateSet()
	local Data = S:GetModule("ClassAT")
	if Data.db.Enable then
		self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
		self:RegisterEvent("PLAYER_ENTERING_WORLD", function()
			self:UnregisterEvent("PLAYER_ENTERING_WORLD")
			self:ACTIVE_TALENT_GROUP_CHANGED()
		end)
	else
		self:UnregisterAllEvents()
	end
end

function CT:ShowOverlayGlow()
	if self.SunUIShowOverlayGlow then return end
	for i=1, #(self.ButtonList) do
		ActionButton_ShowOverlayGlow(self.ButtonList[i].shadow)
		self.SunUIShowOverlayGlow = true
	end
end

function CT:HideOverlayGlow()
	for i=1, #(self.ButtonList) do
		ActionButton_HideOverlayGlow(self.ButtonList[i].shadow)
		self.SunUIShowOverlayGlow = false
	end
end

function CT:UNIT_HEALTH(event, unit)
	if unit ~= "target" then return end
	if ( UnitCanAttack("player", "target") and not UnitIsDead("target") and ( UnitHealth("target")/UnitHealthMax("target") < self.per and UnitLevel("player") > self.level ) and not UnitIsDead("player") ) then
		self:ShowOverlayGlow()
	else
		self:HideOverlayGlow()
	end
end
function CT:SPELL_UPDATE_COOLDOWN()
	local start, duration = GetSpellCooldown(self.spellid)
	if duration > 0 then
		self:HideOverlayGlow()
	end
	self:UNIT_HEALTH("", "target" )
end
function CT:PLAYER_TARGET_CHANGED()
	self:UNIT_HEALTH("", "target")
end

function CT:GetSpellID(button)
	local type,id,subtype = GetActionInfo(button.action)
	if id then 
		return button.action, button, id
	end
end

function CT:InsertTable(button)
	local action, button, id = self:GetSpellID(button)
	if id and self.spellid and id == self.spellid then
		tinsert(self.ButtonList, button)
	end
end

function CT:ScanButton()
	self:ACTIVE_TALENT_GROUP_CHANGED()
	self:HideOverlayGlow()
	wipe(self.ButtonList)
	for i = 1, 12 do
		self:InsertTable(_G[format("ActionButton%d", i)])
		self:InsertTable(_G[format("MultiBarRightButton%d", i)])
		self:InsertTable(_G[format("MultiBarBottomRightButton%d", i)])
		self:InsertTable(_G[format("MultiBarLeftButton%d", i)])
		self:InsertTable(_G[format("MultiBarBottomLeftButton%d", i)])
	end
end

function CT:ACTIONBAR_SLOT_CHANGED()
	self:ScanButton()
	self:UNIT_HEALTH("", "target")
end

function CT:Init()
	self:UpdateSet()
	self:ScanButton()
end