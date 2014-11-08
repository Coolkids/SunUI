local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local CT = S:NewModule("ClassTools", "AceEvent-3.0", "AceHook-3.0", "AceConsole-3.0")
local datebase

CT.ButtonList = {}

function CT:initFrame()
	if not self.Frame then
		local Data = S:GetModule("ClassAT")
		self.Frame = CreateFrame("Frame", nil, UIParent)
		self.Frame:Hide()
		self.Frame:SetPoint("TOP", "UIParent", "TOP", 0, -35)
		self.Frame:SetSize(Data.db.Size, Data.db.Size)
		self.Frame.Cooldown = CreateFrame("Cooldown", nil, self.Frame)
		self.Frame.Cooldown:SetAllPoints()
		self.Frame.Cooldown:SetReverse(true)

		self.Frame.Icon = self.Frame:CreateTexture(nil, "ARTWORK") 
		self.Frame.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
		self.Frame.Icon:SetAllPoints(self.Frame)
		
		self.Frame:CreateShadow()
		S:CreateMover(self.Frame, "ClassToolsMover", L["斩杀提示"], true, nil, "ALL,MINITOOLS")
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
		self:setIconTexture()
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
	local Data = S:GetModule("ClassAT")
	self:initFrame();
	
	if Data.db.Enable then
		self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
		self:RegisterEvent("PLAYER_ENTERING_WORLD", function()
			self:UnregisterEvent("PLAYER_ENTERING_WORLD")
			self:ACTIVE_TALENT_GROUP_CHANGED()
		end)
		if self.Frame then
			self.Frame:SetSize(Data.db.Size, Data.db.Size)
		end
		if not Data.db.Icon then
			self:disFrame();
		end
	else
		self:UnregisterAllEvents()
		self:disFrame();
	end
end

function CT:ShowOverlayGlow()
	if self.SunUIShowOverlayGlow then return end
	local Data = S:GetModule("ClassAT")
	for i=1, #(self.ButtonList) do
		ActionButton_ShowOverlayGlow(self.ButtonList[i].shadow)
	end
	if self.Frame and (not self.Frame:IsShown()) and Data.db.Icon then
		self.Frame:Show()
	end
	self.SunUIShowOverlayGlow = true
end

function CT:HideOverlayGlow()
	if self.SunUIShowOverlayGlow == false then return end
	for i=1, #(self.ButtonList) do
		ActionButton_HideOverlayGlow(self.ButtonList[i].shadow)
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
		CooldownFrame_SetTimer(self.Frame.Cooldown, start, duration, 1)
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
	local Data = S:GetModule("ClassAT")
	datebase = Data.ClassTools
	self:UpdateSet()
	self:ScanButton()
end
