local E, L, V, P, G = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local CT = E:NewModule("ClassTools", "AceEvent-3.0", "AceHook-3.0", "AceConsole-3.0")
local datebase = setmetatable ({
		["PRIEST"] = {
		[0] = {},
		[1] = {},
		[2] = {},
		[3] = {
			["spellid"] = 32379,	--暗言术:灭
			["per"] = 0.2,
			["level"] = 47,
		},
	},
	["HUNTER"] = {
		[0] = {},
		[1] = {},
		[2] = {},
		[3] = {},
	},
	["MAGE"] = {
		[0] = {},
		[1] = {},
		[2] = {},
		[3] = {},
	},
	["WARLOCK"] = {
		[0] = {},
		[1] = {},
		[2] = {},
		[3] = {},
	},
	["PALADIN"] = {
		[0] = {},
		[1] = {},
		[2] = {},
		[3] = {},
	},
	["ROGUE"] = {
		[0] = {},
		[1] = {},
		[2] = {},
		[3] = {},
	},
	["DRUID"] = {
		[0] = {},
		[1] = {},
		[2] = {},
		[3] = {},
		[4] = {},
	},
	["SHAMAN"] = {
		[0] = {},
		[1] = {},
		[2] = {},
		[3] = {},
	},
	["WARRIOR"] = {
		[0] = {},
		[1] = {
			["spellid"] = 163201,	--斩杀
			["per"] = 0.2,
			["level"] = 7,
		},
		[2] = {
			["spellid"] = 5308,		--斩杀
			["per"] = 0.2,
			["level"] = 7,
		},
		[3] = {
		},
	},
	["DEATHKNIGHT"] = {
		[0] = {},
		[1] = {},
		[2] = {},
		[3] = {},
	},
	["MONK"] = {
		[0] = {},
		[1] = {},
		[2] = {},
		[3] = {},
	},
},{__index=function() return -1 end})

CT.ButtonList = {}

function CT:initFrame()
	if not self.Frame then
		local Data = P["ClassAT"]
		self.Frame = CreateFrame("Frame", nil, UIParent)
		self.Frame:Hide()
		self.Frame:SetPoint("TOP", "UIParent", "TOP", 0, -35)
		self.Frame:SetSize(Data.Size, Data.Size)
		self.Frame.Cooldown = CreateFrame("Cooldown", nil, self.Frame)
		self.Frame.Cooldown:SetAllPoints()
		self.Frame.Cooldown:SetReverse(true)

		self.Frame.Icon = self.Frame:CreateTexture(nil, "ARTWORK") 
		self.Frame.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
		self.Frame.Icon:SetAllPoints(self.Frame)
		
		self.Frame:CreateShadow()
		E:CreateMover(self.Frame, "ClassToolsMover", "斩杀提示", nil, nil, nil, "ALL,SunUI")
	end
end

function CT:disFrame()
	if self.Frame then
		self.Frame:Hide()
	end
end

function CT:setIconTexture()
	local texture;
	if self.spellid then
		texture = GetSpellTexture(self.spellid);
	end
	if texture then
		self.Frame.Icon:SetTexture(texture) 
	end
end


function CT:ACTIVE_TALENT_GROUP_CHANGED()
	
	local spec = GetSpecialization()
	if not spec then return end
	--print(#datebase[E.myclass])
	if datebase[E.myclass] == -1 then 
		self:UnregisterAllEvents()
		return
	end
	--print(datebase[E.myclass][0].spellid)
	if datebase[E.myclass][0].spellid then
		self.spellid = datebase[E.myclass][0].spellid
		self.per = datebase[E.myclass][0].per
		self.level = datebase[E.myclass][0].level
		self:RegisterEvent("UNIT_HEALTH")
		self:RegisterEvent("PLAYER_TARGET_CHANGED")
		self:RegisterEvent("SPELL_UPDATE_COOLDOWN")
		self:RegisterEvent("ACTIONBAR_SLOT_CHANGED")
		self:setIconTexture()
		return
	end

	if datebase[E.myclass][spec].spellid then
		self.spellid = datebase[E.myclass][spec].spellid
		self.per = datebase[E.myclass][spec].per
		self.level = datebase[E.myclass][spec].level
		self:RegisterEvent("UNIT_HEALTH")
		self:RegisterEvent("PLAYER_TARGET_CHANGED")
		self:RegisterEvent("SPELL_UPDATE_COOLDOWN")
		self:RegisterEvent("ACTIONBAR_SLOT_CHANGED")
		self:setIconTexture()
		return
	else
		self:UnregisterEvent("UNIT_HEALTH")
		self:UnregisterEvent("PLAYER_TARGET_CHANGED")
		self:UnregisterEvent("SPELL_UPDATE_COOLDOWN")
		self:UnregisterEvent("ACTIONBAR_SLOT_CHANGED")
	end
end

function CT:UpdateSet()
	local Data = P["ClassAT"]
	self:initFrame();
	
	if Data.Enable then
		self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
		self:ACTIVE_TALENT_GROUP_CHANGED()
		
		if self.Frame then
			self.Frame:SetSize(Data.Size, Data.Size)
		end
		if not Data.Icon then
			self:disFrame();
		end
	else
		self:UnregisterAllEvents()
		self:disFrame();
	end
end

function CT:ShowOverlayGlow()
	if self.SunUIShowOverlayGlow then return end
	local Data = P["ClassAT"]
	for i=1, #(self.ButtonList) do
		ActionButton_ShowOverlayGlow(self.ButtonList[i])
	end
	if self.Frame and (not self.Frame:IsShown()) and Data.Icon then
		self.Frame:Show()
	end
	self.SunUIShowOverlayGlow = true
end

function CT:HideOverlayGlow()
	if self.SunUIShowOverlayGlow == false then return end
	for i=1, #(self.ButtonList) do
		ActionButton_HideOverlayGlow(self.ButtonList[i])
	end
	if self.Frame and self.Frame:IsShown() then
		self.Frame:Hide()
	end
	self.SunUIShowOverlayGlow = false
end

function CT:UNIT_HEALTH(event, unit)
	if unit ~= "target" then return end
	if ( UnitCanAttack("player", "target") and not UnitIsDead("target") and ( UnitHealth("target")/UnitHealthMax("target") < self.per and UnitLevel("player") > self.level ) and not UnitIsDead("player") ) then
		self:ShowOverlayGlow()
	else
		self:HideOverlayGlow()
	end
	if UnitIsDead("target") then
		self:HideOverlayGlow()
	end
end
function CT:SPELL_UPDATE_COOLDOWN()
	local start, duration = GetSpellCooldown(self.spellid)
	if duration > 0 then
		self:HideOverlayGlow()
	end
	if self.Frame.Cooldown then
		self.Frame.Cooldown:SetReverse(false)
		CooldownFrame_Set(self.Frame.Cooldown, start, duration, 1)
	end
	self:UNIT_HEALTH("", "target" )
end
function CT:PLAYER_TARGET_CHANGED()
	self:UNIT_HEALTH("", "target")
end

function CT:GetSpellID(button)
	local type,id,subtype = GetActionInfo(button.action)
	return button.action, button, id
end

function CT:InsertTable(button)
	local action, button, id = self:GetSpellID(button)
	if id and self.spellid and id == self.spellid then
		tinsert(self.ButtonList, button)
	end
end

function CT:ScanButton()
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
function CT:PLAYER_ENTERING_WORLD()
	self:ScanButton()
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end
function CT:Init()
	self:UpdateSet()
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
end

function CT:Initialize()
	self:Init()
end

E:RegisterModule(CT:GetName())