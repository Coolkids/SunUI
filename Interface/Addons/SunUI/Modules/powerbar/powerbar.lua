local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local

local PB = S:NewModule("PowerBar", "AceEvent-3.0", "AceHook-3.0", "AceConsole-3.0")
local space = (S.myclass == "DEATHKNIGHT" or S.myclass == "SHAMAN") and 3 or 6
PB.modName = L["PowerBar"]
PB.order = 13
local powercolor = {}
for power, color in next, PowerBarColor do
	if (type(power) == "string") then
		if power == "MANA" then 
			powercolor[power] = {0, 0.76, 1} 
		elseif power ==  "FUEL" then 
			powercolor[power] = {0, 0.55, 0.5}
		elseif  power ==  "FOCUS" then
			powercolor[power] = {.7,.45,.25}
		elseif  power ==  "RAGE" then
			powercolor[power] = {.7,.3,.3}
		else
			powercolor[power] = {color.r, color.g, color.b}
		end
	end
end

------------------------------------------------------------------------
------holder :锚点
------holder.health: 血量
------holder.mana: 魔法
------holder.power: 特殊能量

--[[需要设置的frame
	self.holder = {
		power = {[1] ....  [n]
			anticipationBar = {[1]..[5]}
		}
		eb = {[LunarBar], [SolarBar]}

}
]]
------------------------------------------------------------------------
local maxPowerNumber = setmetatable ({
	["PRIEST"] = 5,    		--暗牧  do
	["MONK"] = 6,			--武僧  do
	["DEATHKNIGHT"] = 6,	--DK    do
	["PALADIN"] = 5,		--圣骑士  do
	["ROGUE"] = 5,			--连击点 盗贼/野德
	["DRUID"] = 5,			--日/月能
	["WARLOCK"] = 4,		--术士
	["MAGE"] = 4,			--法师
	["SHAMAN"] = 4,			--萨满

},{__index=function() return -1 end})

local powerTypeList = setmetatable ({
	["PRIEST"] = SPELL_POWER_SHADOW_ORBS,
	["MONK"] = SPELL_POWER_CHI,
	["PALADIN"] = SPELL_POWER_HOLY_POWER,
}, {__index=function() return nil end})

local powerType2List = setmetatable ({
	["PRIEST"] = "SHADOW_ORBS",
	["MONK"] = "CHI",
	["PALADIN"] = "HOLY_POWER",
}, {__index=function() return nil end})

function PB:GetOptions()
	local options = {
		group1 = {
			type = "group", order = 1,
			name = "",guiInline = true,
			args = {
				Open = {
					type = "toggle",
					name = L["启用职业能量条"],
					order = 1,
					get = function() return self.db.Open end,
					set = function(_, value)
						self.db.Open = value
						self:UpdateEnable()
					end,
				},
			}
		},
		group2 = {
			type = "group", order = 2, guiInline = true, disabled = function(info) return not self.db.Open end,
			name = "",
			args = {
				Width = {
					type = "input",
					name = L["框体宽度"],
					order = 1,
					get = function() return tostring(self.db.Width) end,
					set = function(_, value)
						self.db.Width = tonumber(value)
						self:UpdateSize()
					end,
				},
				Height = {
					type = "input",
					name = L["框体高度"],
					order = 2,
					get = function() return tostring(self.db.Height) end,
					set = function(_, value) 
						self.db.Height = tonumber(value)
						self:UpdateSize()
					end,
				},
				Fade = {
					type = "toggle",
					name = L["渐隐"],
					order = 4,
					get = function() return self.db.Fade end,
					set = function(_, value)
						self.db.Fade = value
						self:UpdateFade()
					end,
				},
				HealthPower = {
					type = "toggle",
					name = L["生命值"],
					order = 5,
					get = function() return self.db.HealthPower end,
					set = function(_, value)
						self.db.HealthPower = value
						self:SetHealthManaScript()
					end,
				},
				DisableText = {
					type = "toggle",
					name = L["不显示文字"],
					order = 6,
					get = function() return self.db.DisableText end,
					set = function(_, value)
						self.db.DisableText = value
					end,
				},
				HealthPowerPer = {
					type = "toggle",
					name = L["生命值用百分比替代"],
					order = 7,
					disabled = function() return self.db.DisableText end,
					get = function() return self.db.HealthPowerPer end,
					set = function(_, value)
						self.db.HealthPowerPer = value
					end,
				},
				
				ManaPowerPer = {
					type = "toggle",
					name = L["魔法值用百分比替代"],
					order = 8,
					disabled = function() return self.db.DisableText end,
					get = function() return self.db.ManaPowerPer end,
					set = function(_, value)
						self.db.ManaPowerPer = value
					end,
				},
			}
		},
	}
	return options
end

function PB:CheckMaxBarNumber()
	return maxPowerNumber[S.myclass]
end

function PB:CheckPowerType()
	return powerTypeList[S.myclass]
end

function PB:ChechCommonClass()
	if self:CheckPowerType() == nil then
		return false
	else
		return true
	end
end

function PB:CreateMainFrame()
	self.holder = CreateFrame("Statusbar", nil, oUF_PetBattleFrameHider)
	self.holder:SetSize(self.db.Width, self.db.Height)
	self.holder:SetPoint("CENTER", "UIParent", "CENTER", 0, -120)
	S:CreateMover(self.holder, "PowerBarMover", L["PowerBar"], true, nil, "ALL,MINITOOLS")
	self.holder.power = CreateFrame("Statusbar", nil, self.holder)
	self.holder.power:SetAllPoints()
	
	local A = S:GetModule("Skins")
	if S.myclass ~= "WARLOCK" and S.myclass ~= "SHAMAN" and S.myclass ~= "DEATHKNIGHT" then
		A:CreateBD(self.holder, 0.6)
	end
end

function PB:CreateHealthFrame()
	self.holder.health = CreateFrame("Statusbar", nil, self.holder)
	self.holder.health:SetAllPoints()
	self.holder.health:SetStatusBarTexture(S["media"].normal)
	self.holder.health:SetMinMaxValues(0, UnitHealthMax("player"))
	self.holder.health:SetValue(UnitHealth("player"))
	self.holder.health:SetStatusBarColor(0.1, 0.8, 0.1, 0)

	self.holder.health.spar = self.holder.health:CreateTexture(nil, "OVERLAY")
	self.holder.health.spar:SetTexture("Interface\\Addons\\SunUI\\Media\\textureArrowBelow.tga")
	self.holder.health.spar:SetVertexColor(1, 0, 0, 1) 
	self.holder.health.spar:SetSize(12, 12)
	self.holder.health.spar:SetPoint("TOP", self.holder.health:GetStatusBarTexture(), "BOTTOMRIGHT", -1, -2)

	self.holder.health.text = S:CreateFS(self.holder.health)
	self.holder.health.text:SetPoint("TOP", self.holder.health.spar, "BOTTOM", 0, 3)
	self.holder.health.text:SetTextColor(210/255, 100/255, 100/255)
	
	S:SmoothBar(self.holder.health)
end

function PB:CreateManaFrame()
	self.holder.mana = CreateFrame("Statusbar", nil, self.holder)
	self.holder.mana:SetSize(self.db.Width, self.db.Height)
	self.holder.mana:SetStatusBarTexture(S["media"].normal)
	self.holder.mana:SetAllPoints()
	self.holder.mana:SetStatusBarColor(0.1, 0.8, 0.1, 0)
	self.holder.mana:SetMinMaxValues(0, UnitPowerMax("player"))
	
	self.holder.mana.spar =  self.holder.mana:CreateTexture(nil, "OVERLAY")
	self.holder.mana.spar:SetTexture("Interface\\Addons\\SunUI\\Media\\textureArrowAbove.tga")
	self.holder.mana.spar:SetVertexColor(.3,.45,.65) 
	self.holder.mana.spar:SetSize(12, 12)
	self.holder.mana.spar:SetPoint("BOTTOM", self.holder.mana:GetStatusBarTexture(), "TOPRIGHT", -1, 2)
	
	self.holder.mana.text = S:CreateFS(self.holder.mana)
	self.holder.mana.text:SetPoint("BOTTOM", self.holder.mana.spar, "TOP", 0, -3)
	
	S:SmoothBar(self.holder.mana)
end

local function HealthMana_OnUpdate(self, elapsed)
	self.elapsed = (self.elapsed or 0) + elapsed
	if self.elapsed >= 0.2 then
		local _, powerclass = UnitPowerType("player")
		local healthnum, powernum = UnitHealth("player"), UnitPower("player")
		local maxHealth, maxMana = UnitHealthMax("player"), UnitPowerMax("player")
		
		self.health:SetMinMaxValues(0, maxHealth)
		self.mana:SetMinMaxValues(0, maxMana)
		
		self.mana.text:SetTextColor(unpack(powercolor[powerclass]))
		self.mana.spar:SetVertexColor(unpack(powercolor[powerclass]))
		
		self.health:SetValue(healthnum)
		self.mana:SetValue(powernum)
		
		if not PB.db.DisableText then
			if PB.db.HealthPowerPer then
				self.health.text:SetText(format("%d|cffffd700%%|r", healthnum/maxHealth*100))
			else
				self.health.text:SetText(S:ShortValue(healthnum))
			end
			if PB.db.ManaPowerPer then
				self.mana.text:SetText(format("%d|cffffd700%%|r", powernum/maxMana*100))
			else
				self.mana.text:SetText(S:ShortValue(powernum))
			end
		else
			self.health.text:SetText("")
			self.mana.text:SetText("")
		end
		self.elapsed = 0
	end
end

function PB:SetHealthManaScript()
	if self.db.HealthPower then
		if not self.holder.health then
			self:CreateHealthFrame()
			self:CreateManaFrame()
		end
		self.holder:SetScript("OnUpdate", HealthMana_OnUpdate)
	else
		self.holder:SetScript("OnUpdate", nil)
		self.holder.health.text:SetText("")
		self.holder.mana.text:SetText("")
		self.holder.health:Hide()
		self.holder.mana:Hide()
		self.holder.health = nil
		self.holder.mana = nil
	end
end

function PB:CreateCommonPowerBar()
	local maxBar = self:CheckMaxBarNumber()
	if maxBar < 0 then
		return
	end
	for i = 1,maxBar do
		self.holder.power[i] = CreateFrame("StatusBar", nil, self.holder.power)
		self.holder.power[i]:SetSize((self.db.Width-space*(maxBar-1))/maxBar, self.db.Height)
		self.holder.power[i]:SetStatusBarTexture(S["media"].normal)
		self.holder.power[i]:SetStatusBarColor(.86,.22,1) --TODO 后期颜色处理 萨满/术士/日月能/DK已经处理
		self.holder.power[i]:CreateShadow(0.6)
		self.holder.power[i]:Hide()
		if (i == 1) then
			self.holder.power[i]:SetPoint("LEFT", self.holder.power, "LEFT")
		else
			self.holder.power[i]:SetPoint("LEFT", self.holder.power[i-1], "RIGHT", space, 0)
		end
		self:ColorPowerBar(i)
	end
end

function PB:Common_OnEvent_IMPL()
	local powerType = PB:CheckPowerType()
	if powerType == nil then return end
	local numBar = UnitPower('player', powerType)
	local maxBar = UnitPowerMax("player", powerType)
	local trueMaxBar = PB:CheckMaxBarNumber()
	
	if maxBar == trueMaxBar then
		for i = 1,trueMaxBar do
			self.holder.power[i]:SetWidth((PB.db.Width-space*(trueMaxBar-1))/trueMaxBar)
		end
	else
		for i = 1,maxBar do
			self.holder.power[i]:SetWidth((PB.db.Width-space*(maxBar-1))/maxBar)
		end
	end
	
	for i = 1,trueMaxBar do
		if i <= numBar then
			self.holder.power[i]:Show()
		else
			self.holder.power[i]:Hide()
		end
	end
end

local function Common_OnEvent(self, event, unit, powerType)
	if(event=="PLAYER_ENTERING_WORLD") then
		PB:Common_OnEvent_IMPL()
	end
	if( unit ~= "player" or (powerType and powerType ~= powerType2List[S.myclass]) ) then 
		return 
	end
	PB:Common_OnEvent_IMPL()
end

function PB:CommonPowerBarEvent()
	self.holder.power:RegisterEvent("UNIT_POWER")
	self.holder.power:RegisterEvent("UNIT_DISPLAYPOWER")
	self.holder.power:RegisterEvent("PLAYER_ENTERING_WORLD")
	self.holder.power:SetScript("OnEvent", Common_OnEvent)
end

function PB:DEATHKNIGHT()
	RuneFrame.Show = RuneFrame.Hide
	RuneFrame:Hide()
	local runes = {
		{1, 0, 0},   -- blood
		{0, .5, 0},  -- unholy
		{0, 1, 1},   -- frost
		{.9, .1, 1}, -- death
	}
	local runemap = { 1, 2, 5, 6, 3, 4 }
	local function OnUpdate(self, elapsed)
		local duration = self.duration + elapsed
		if(duration >= self.max) then
			return self:SetScript("OnUpdate", nil)
		else
			self.duration = duration
			return self:SetValue(duration)
		end
	end
	local function UpdateType(self, rid, alt)
		local rune = self[runemap[rid]]
		local colors = runes[GetRuneType(rid) or alt]
		local r, g, b = colors[1], colors[2], colors[3]
		rune:SetStatusBarColor(r, g, b)
	end
	local function OnEvent(self, event, unit)
		if event == "RUNE_POWER_UPDATE" or "PLAYER_ENTERING_WORLD" then 
			for i=1, 6 do
				local rune = self[runemap[i]]
				if(rune) then
					local start, duration, runeReady = GetRuneCooldown(i)
					if(runeReady) then
						rune:SetMinMaxValues(0, 1)
						rune:SetValue(1)
						rune:SetScript("OnUpdate", nil)
					else
						if start then
							rune.duration = GetTime() - start
							rune.max = duration
							rune:SetMinMaxValues(1, duration)
							rune:SetScript("OnUpdate", OnUpdate)
						end
					end
				end
			end
		end
		if event == "RUNE_TYPE_UPDATE" then
			for i=1, 6 do
				UpdateType(self, i, math.floor((runemap[i]+1)/2))
			end
		end
	end
	
	for i=1,6 do
		self.holder.power[i]:Show()
		UpdateType(self.holder.power, i, math.floor((runemap[i]+1)/2))
	end
	self.holder.power:RegisterEvent("RUNE_POWER_UPDATE")
	self.holder.power:RegisterEvent("RUNE_TYPE_UPDATE")
	self.holder.power:SetScript("OnEvent", OnEvent)
end

function PB:CreateCombatPoint()
	--盗贼跟小德都会把power作为连击点
	self.holder.power:RegisterEvent("UNIT_COMBO_POINTS")
	self.holder.power:RegisterEvent("PLAYER_TARGET_CHANGED")
	self.holder.power:SetScript("OnEvent", function(self, event)
		if event == "UNIT_COMBO_POINTS" or event == "PLAYER_TARGET_CHANGED" then
			local cp = GetComboPoints('player', 'target')
			for i=1, MAX_COMBO_POINTS do
				if(i <= cp) then
					self[i]:Show()
				else
					self[i]:Hide()
				end
			end
		end
	end)
end

function PB:ROGUE()
	------------------------------------------------------------------------------
	-------from NGA - chuan45 33539090--------------------------------------------
	------------------------------------------------------------------------------
	self.holder.power.anticipationBar = CreateFrame("Frame", nil, self.holder.power)
	self.holder.power.anticipationBar:SetAllPoints(self.holder.power)
	for i = 1, 5 do
		self.holder.power.anticipationBar[i] = CreateFrame("StatusBar", nil, anticipationBar)
		self.holder.power.anticipationBar[i]:SetStatusBarTexture(S["media"].normal)
		self.holder.power.anticipationBar[i]:GetStatusBarTexture():SetHorizTile(false)
		self.holder.power.anticipationBar[i]:SetFrameLevel(self.holder.power[i]:GetFrameLevel()+1)
		self.holder.power.anticipationBar[i]:SetSize(((self.db.Width-2*4)/5)/1.2, self.db.Height/1.5)
		self.holder.power.anticipationBar[i]:SetPoint("CENTER", self.holder.power[i], 0, 0)
		if i ~= 5 then 
			self.holder.power.anticipationBar[i]:SetStatusBarColor(0.8, 0.2, 0.2)
		else
			self.holder.power.anticipationBar[i]:SetStatusBarColor(102/255, 204/255, 102/255)
		end
		self.holder.power.anticipationBar[i]:CreateShadow()
		self.holder.power.anticipationBar[i]:Hide()
	end
	self.holder.power.anticipationBar:RegisterEvent("UNIT_AURA")
	self.holder.power.anticipationBar:SetScript("OnEvent", function(self, event, unit)
		if unit ~= "player" then return end
		local count = select(4, UnitBuff("player", GetSpellInfo(115189))) or 0
		for i = 1, 5 do
			if i <= count then
				self[i]:Show()
			else
				self[i]:Hide()
			end
		end
	end)
end

function PB:DRUID()
	local ECLIPSE_BAR_SOLAR_BUFF_ID = ECLIPSE_BAR_SOLAR_BUFF_ID
	local ECLIPSE_BAR_LUNAR_BUFF_ID = ECLIPSE_BAR_LUNAR_BUFF_ID
	local SPELL_POWER_ECLIPSE = SPELL_POWER_ECLIPSE
	local MOONKIN_FORM = MOONKIN_FORM
	local showBar, showCombatBar = false, false
	local A = S:GetModule("Skins")
	self.holder.eb = CreateFrame('Frame', nil, self.holder)
	self.holder.eb:SetSize(self.db.Width, self.db.Height)
	self.holder.eb:SetAllPoints()
	self.holder.eb:CreateShadow()
	
	self.holder.eb.LunarBar = CreateFrame('StatusBar', nil, self.holder.eb)
	self.holder.eb.LunarBar:SetPoint('LEFT', self.holder.eb, 'LEFT')
	self.holder.eb.LunarBar:SetSize(self.db.Width, self.db.Height)
	self.holder.eb.LunarBar:SetStatusBarTexture(S["media"].normal)
	self.holder.eb.LunarBar:SetStatusBarColor(0.27, 0.47, 0.74)
	
	S:SmoothBar(self.holder.eb.LunarBar)
	A:CreateMark(self.holder.eb.LunarBar)

	self.holder.eb.SolarBar = CreateFrame('StatusBar', nil, self.holder.eb)
	self.holder.eb.SolarBar:SetPoint('LEFT', self.holder.eb.LunarBar:GetStatusBarTexture(), 'RIGHT', 0, 0)
	self.holder.eb.SolarBar:SetPoint('TOPRIGHT', self.holder.eb, 'TOPRIGHT', 0, 0)
	self.holder.eb.SolarBar:SetSize(self.db.Width, self.db.Height)
	self.holder.eb.SolarBar:SetStatusBarTexture(S["media"].normal)
	self.holder.eb.SolarBar:SetStatusBarColor(0.9, 0.6, 0.3)

	local help = CreateFrame('Frame', nil, self.holder.eb)
	help:SetAllPoints(self.holder.eb)
	help:SetFrameLevel(self.holder.eb:GetFrameLevel()+1)
	local ebInd = help:CreateFontString(nil, "OVERLAY")
	ebInd:FontTemplate(nil, nil, "OUTLINEMONOCHROME")
	ebInd:SetPoint('CENTER', help, 'CENTER', 0, 0)
	ebInd:SetJustifyV("MIDDLE")
	self.holder.eb.LunarBar.text = ebInd
	self.holder.eb:RegisterEvent("ECLIPSE_DIRECTION_CHANGE")
	self.holder.eb:RegisterEvent("PLAYER_TALENT_UPDATE")
	self.holder.eb:RegisterEvent("UNIT_POWER")
	self.holder.eb:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
	self.holder.eb:RegisterEvent("PLAYER_ENTERING_WORLD")
	self.holder.eb:RegisterEvent("PLAYER_REGEN_DISABLED")
	self.holder.eb:SetScript("OnEvent", function(self, event, unit, powerType)
		if event == "ECLIPSE_DIRECTION_CHANGE" or event == "PLAYER_ENTERING_WORLD" then
			local dir = GetEclipseDirection()
			if dir=="sun" then
				ebInd:SetTextColor(68/255, 120/255, 188/255)
				fx = ">>"
			elseif dir=="moon" then
				ebInd:SetTextColor(229/255, 153/255, 76/255)
				fx = "<<"
			end
		end
		if event == "PLAYER_TALENT_UPDATE" or event == "UPDATE_SHAPESHIFT_FORM" or event == "PLAYER_REGEN_DISABLED" then
			local form = GetShapeshiftFormID()
			if(not form) then
				showBar = false
				showCombatBar = false
			elseif(form == MOONKIN_FORM) then
				showBar = true
				showCombatBar = false
			elseif(form ==CAT_FORM) then
				showBar = false
				showCombatBar = true
			else
				showBar = false
				showCombatBar = false
			end

			if showBar then
				self:Show()
			else
				self:Hide()
			end
			
			if showCombatBar then
				PB.holder.power:Show()
			else
				PB.holder.power:Hide()
			end
			
		end
		if event == "UNIT_POWER" then
			if(unit ~= "player" or (powerType and powerType ~= 'ECLIPSE')) then return end

			local power = UnitPower('player', SPELL_POWER_ECLIPSE)
			local maxPower = UnitPowerMax('player', SPELL_POWER_ECLIPSE)
			
			local dir, fx = GetEclipseDirection(), ""
			if dir=="sun" then
				fx = ">>"
			elseif dir=="moon" then
				fx = "<<"
			end
			
			if(self.LunarBar) then
				self.LunarBar:SetMinMaxValues(-maxPower, maxPower)
				self.LunarBar:SetValue(power)
				self.LunarBar.text:SetText(fx.." "..(power))
			end

			if(self.SolarBar) then
				self.SolarBar:SetPoint('LEFT', self.LunarBar:GetStatusBarTexture(), 'RIGHT', 0, 0)
				self.SolarBar:SetPoint('TOPRIGHT', self, 'TOPRIGHT', 0, 0)
				--self.SolarBar:SetMinMaxValues(-maxPower, maxPower)
				--self.SolarBar:SetValue(power * -1)
			end
		end
		if event == "PLAYER_ENTERING_WORLD" then 
			local power = UnitPower('player', SPELL_POWER_ECLIPSE)
			local maxPower = UnitPowerMax('player', SPELL_POWER_ECLIPSE)

			if(self.LunarBar) then
				self.LunarBar:SetMinMaxValues(-maxPower, maxPower)
				self.LunarBar:SetValue(power)
				self.LunarBar.text:SetText(power)
			end

			if(self.SolarBar) then
				self.SolarBar:SetPoint('LEFT', self.LunarBar:GetStatusBarTexture(), 'RIGHT', 0, 0)
				self.SolarBar:SetPoint('TOPRIGHT', self, 'TOPRIGHT', 0, 0)
			end
		end
	end)



end

function PB:WARLOCK()
	local MAX_POWER_PER_EMBER = 10
	local SPELL_POWER_DEMONIC_FURY = SPELL_POWER_DEMONIC_FURY
	local SPELL_POWER_BURNING_EMBERS = SPELL_POWER_BURNING_EMBERS
	local SPELL_POWER_SOUL_SHARDS = SPELL_POWER_SOUL_SHARDS
	local SPEC_WARLOCK_DESTRUCTION = SPEC_WARLOCK_DESTRUCTION
	local SPEC_WARLOCK_DESTRUCTION_GLYPH_EMBERS = 63304
	local SPEC_WARLOCK_AFFLICTION = SPEC_WARLOCK_AFFLICTION
	local SPEC_WARLOCK_AFFLICTION_GLYPH_SHARDS = 63302
	local SPEC_WARLOCK_DEMONOLOGY = SPEC_WARLOCK_DEMONOLOGY
	local LATEST_SPEC = 0

	local Colors = {
		[1] = {148/255, 130/255, 201/255, 1},
		[2] = {95/255, 222/255,  95/255, 1},
		[3] = {222/255, 95/255,  95/255, 1},
	}
	
	self.holder.power.text = S:CreateFS(self.holder.power)
	self.holder.power.text:SetPoint("RIGHT", self.holder.power, "LEFT", -5, 0)
	self.holder.power.text:SetText("")
	self.holder.power.text:SetTextColor(Colors[SPEC_WARLOCK_DEMONOLOGY][1], Colors[SPEC_WARLOCK_DEMONOLOGY][2], Colors[SPEC_WARLOCK_DEMONOLOGY][3])

	
	self.holder.power:RegisterEvent("UNIT_POWER")
	self.holder.power:RegisterEvent("UNIT_DISPLAYPOWER")
	self.holder.power:RegisterEvent("PLAYER_ENTERING_WORLD")
	self.holder.power:RegisterEvent("PLAYER_TALENT_UPDATE")
	self.holder.power:RegisterEvent("PLAYER_REGEN_DISABLED")
	self.holder.power:RegisterEvent("PLAYER_REGEN_ENABLED")
	self.holder.power:SetScript("OnEvent", function(self,event,unit, powerType)
		if event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_TALENT_UPDATE" then
			local wsb = self
			local spacing = select(4, wsb[4]:GetPoint())
			local w = wsb:GetWidth()
			local s = 0
			
			local spec = GetSpecialization()
			if spec then
				if not wsb:IsShown() then
					wsb:Show()
				end

				if LATEST_SPEC ~= spec then
					for i = 1, 4 do
						local max = select(2, wsb[i]:GetMinMaxValues())
						if spec == SPEC_WARLOCK_AFFLICTION then
							wsb[i]:SetValue(max)
						else
							wsb[i]:SetValue(0)
						end
						wsb[i]:Show()
					end
				end

				if spec == SPEC_WARLOCK_DESTRUCTION then
					local maxembers = 4

					for i = 1, maxembers do
						if i ~= maxembers then
							wsb[i]:SetWidth(w / maxembers - spacing)
							s = s + (w / maxembers)
						else
							wsb[i]:SetWidth(w - s)
						end
						wsb[i]:SetStatusBarColor(Colors[SPEC_WARLOCK_DESTRUCTION][1], Colors[SPEC_WARLOCK_DESTRUCTION][2], Colors[SPEC_WARLOCK_DESTRUCTION][3])
					end

				elseif spec == SPEC_WARLOCK_AFFLICTION then
					local maxshards = 4

					for i = 1, maxshards do
						if i ~= maxshards then
							wsb[i]:SetWidth(w / maxshards - spacing)
							s = s + (w / maxshards)
						else
							wsb[i]:SetWidth(w - s)
						end
						wsb[i]:SetStatusBarColor(Colors[SPEC_WARLOCK_AFFLICTION][1], Colors[SPEC_WARLOCK_AFFLICTION][2], Colors[SPEC_WARLOCK_AFFLICTION][3])
					end

				elseif spec == SPEC_WARLOCK_DEMONOLOGY then
					wsb[2]:Hide()
					wsb[3]:Hide()
					wsb[4]:Hide()
					wsb[1]:SetWidth(wsb:GetWidth())
					wsb[1]:SetStatusBarColor(Colors[SPEC_WARLOCK_DEMONOLOGY][1], Colors[SPEC_WARLOCK_DEMONOLOGY][2], Colors[SPEC_WARLOCK_DEMONOLOGY][3])
				end
			else
				if wsb:IsShown() then
					wsb:Hide()
				end
			end
			
			wsb.text:SetText("") --数字0
		end

		if (event == "UNIT_POWER" or event == "UNIT_DISPLAYPOWER" or event == "PLAYER_ENTERING_WORLD") then
			if ( event == "UNIT_POWER" or event == "UNIT_DISPLAYPOWER") then
				if(unit ~= "player" or (powerType ~= "BURNING_EMBERS" and powerType ~= "SOUL_SHARDS" and powerType ~= "DEMONIC_FURY")) then return end
			else
				--print(UnitPower("player", SPELL_POWER_BURNING_EMBERS, true))
			end
			local wsb = self
			local spec = GetSpecialization()
	
			if spec then
				if (spec == SPEC_WARLOCK_DESTRUCTION) then
					local maxPower = UnitPowerMax("player", SPELL_POWER_BURNING_EMBERS, true)
					local power = UnitPower("player", SPELL_POWER_BURNING_EMBERS, true)
					local numEmbers = power / MAX_POWER_PER_EMBER
					local numBars = floor(maxPower / MAX_POWER_PER_EMBER)
					--print(maxPower.."  "..power.."  "..numEmbers.."  "..numBars)
					for i = 1, numBars do
						wsb[i]:SetMinMaxValues((MAX_POWER_PER_EMBER * i) - MAX_POWER_PER_EMBER , MAX_POWER_PER_EMBER * i)
						wsb[i]:SetValue(power)
					end
				elseif ( spec == SPEC_WARLOCK_AFFLICTION ) then
					local numShards = UnitPower("player", SPELL_POWER_SOUL_SHARDS)
					local maxShards = UnitPowerMax("player", SPELL_POWER_SOUL_SHARDS)

					for i = 1, maxShards do
						if i <= numShards then
							wsb[i]:SetAlpha(1)
						else
							wsb[i]:SetAlpha(0)
						end
					end
				elseif spec == SPEC_WARLOCK_DEMONOLOGY then
					local power = UnitPower("player", SPELL_POWER_DEMONIC_FURY)
					local maxPower = UnitPowerMax("player", SPELL_POWER_DEMONIC_FURY)
					wsb[1]:SetAlpha(1)
					wsb[1]:SetMinMaxValues(0, maxPower)
					wsb[1]:SetValue(power)
					wsb.text:SetText(power)
				end
			end
		end
	end)

end

function PB:MAGE()
	self.holder.power:RegisterEvent("UNIT_AURA")

	self.holder.power:SetScript("OnEvent",function(self,event,unit)
		if unit ~= "player" then return end
		local num = select(4, UnitDebuff("player", GetSpellInfo(36032))) or 0
		for i = 1,4 do
			if i <= num then
				self[i]:Show()
			else
				self[i]:Hide()
			end
		end
	end)
end

function PB:SHAMAN()
	local total = 0
	local delay = 0.01
	-- In the order, fire, earth, water, air
	local colors = {
		[1] = {0.752,0.172,0.02},
		[2] = {0.741,0.580,0.04},
		[3] = {0,0.443,0.631},
		[4] = {0.6,1,0.945},
	}
	
	local function UpdateSlot(self, slot)
		if not slot or slot < 1 or slot > 4 then return end

		local totem = self

		haveTotem, name, startTime, duration, totemIcon = GetTotemInfo(slot)

		totem[slot]:SetStatusBarColor(unpack(colors[slot]))
		totem[slot]:SetValue(0)
		
		totem[slot].ID = slot
		totem[slot]:SetMinMaxValues(0, 1)
		-- If we have a totem then set his value 
		if(haveTotem) then
			
			if totem[slot].Name then
				totem[slot].Name:SetText(name)
			end
			if(duration >= 0) then
				if duration == 0 then
					totem[slot]:SetValue(0)
				else
					totem[slot]:SetValue(1 - ((GetTime() - startTime) / duration))
				end

				-- Status bar update
				totem[slot]:SetScript("OnUpdate",function(self,elapsed)
						total = total + elapsed
						if total >= delay then
							total = 0
							haveTotem, name, startTime, duration, totemIcon = GetTotemInfo(self.ID)
							if duration == 0 then
								self:SetValue(0)
							else
								self:SetValue(1 - ((GetTime() - startTime) / duration))
							end
						end
					end)
			else
				-- There's no need to update because it doesn't have any duration
				totem[slot]:SetScript("OnUpdate",nil)
				totem[slot]:SetValue(0)
			end 
		else
			-- No totem = no time 
			if totem[slot].Name then
				totem[slot].Name:SetText(" ")
			end
			totem[slot]:SetValue(0)
		end

	end
	self.holder.power:RegisterEvent("PLAYER_TOTEM_UPDATE")
	self.holder.power:RegisterEvent("PLAYER_ENTERING_WORLD")
	self.holder.power:SetScript("OnEvent",function(self,event,unit)
		for i = 1, 4 do 
			self[i]:Show()
			UpdateSlot(self, i)
		end
	end)
end

function PB:ColorPowerBar(i)
	local bar = self.holder.power
	if S.myclass == "PRIEST" then 			--DK
		bar[i]:SetStatusBarColor(.86,.22,1)
	elseif S.myclass == "ROGUE" or S.myclass == "DRUID" then				--盗贼
		if i ~= 5 then 
			bar[i]:SetStatusBarColor(0.9, 0.9, 0)
		else
			bar[i]:SetStatusBarColor(1, 0.2, 0.2)
		end
	elseif S.myclass == "MONK" then				--小德
		bar[i]:SetStatusBarColor(0.0, 1.00 , 0.59)
	elseif S.myclass == "PALADIN" then				--术士
		bar[i]:SetStatusBarColor(0.9, 0.9, 0)
	elseif S.myclass == "MAGE" then				--萨满
		bar[i]:SetStatusBarColor(S.myclasscolor.r, S.myclasscolor.g, S.myclasscolor.b)
	end
	local A = S:GetModule("Skins")
	if S.myclass == "WARLOCK" or S.myclass ~= "DEATHKNIGHT" or S.myclass ~= "SHAMAN" then
		A:CreateMark(bar[i])
	end
	if S.myclass == "WARLOCK" then
		S:SmoothBar(bar[i])
	end
end

function PB:UpdateSize()
	local maxBar = self:CheckMaxBarNumber()
	
	self.holder:SetSize(self.db.Width, self.db.Height)
	
	for k, v in ipairs(self.holder.power) do 
		if v then 
			v:SetSize((self.db.Width-space*(maxBar-1))/maxBar, self.db.Height)
		end
	end
	if self.holder.power.anticipationBar then
		for k, v in ipairs(self.holder.power.anticipationBar) do 
			if v then 
				v:SetSize(((self.db.Width-2*4)/5)/1.2, self.db.Height/1.5)
			end
		end
	end
	if self.holder.eb then
		self.holder.eb.LunarBar:SetSize(self.db.Width, self.db.Height)
		self.holder.eb.SolarBar:SetSize(self.db.Width, self.db.Height)
	end
end

local function FaderUpdate()
	if
		(UnitCastingInfo("player") or UnitChannelInfo("player")) or
		UnitAffectingCombat("player") or
		UnitExists("target")
	then
		PB:On_Show()
	else
		PB:On_Hide()
	end
end

function PB:On_Show()
	if self.holder:IsShown() then return end
	self.holder:Show()
	--S:ShowAnima(self.holder)
	UIFrameFadeIn(self.holder, 0.15, self.holder:GetAlpha(), 1)
end
function PB:On_Hide()
	if not self.holder:IsShown() then return end
	S:FadeOutFrame(self.holder, 0.15)
	--S:HideAnima(self.holder)
end

function PB:UpdateFade()
	if self.db.Fade then
		self:RegisterEvent("PLAYER_REGEN_ENABLED", FaderUpdate)
		self:RegisterEvent("PLAYER_REGEN_DISABLED", FaderUpdate)
		self:RegisterEvent('UNIT_TARGET', FaderUpdate)
		self:RegisterEvent('PLAYER_TARGET_CHANGED', FaderUpdate)

		self:RegisterEvent('UNIT_SPELLCAST_START', FaderUpdate)
		self:RegisterEvent('UNIT_SPELLCAST_FAILED', FaderUpdate)
		self:RegisterEvent('UNIT_SPELLCAST_STOP', FaderUpdate)
		self:RegisterEvent('UNIT_SPELLCAST_INTERRUPTED', FaderUpdate)
		self:RegisterEvent('UNIT_SPELLCAST_CHANNEL_START', FaderUpdate)
		self:RegisterEvent('UNIT_SPELLCAST_CHANNEL_INTERRUPTED', FaderUpdate)
		self:RegisterEvent('UNIT_SPELLCAST_CHANNEL_STOP', FaderUpdate)
		self:On_Hide()
	else
		self:UnregisterEvent("PLAYER_REGEN_ENABLED", FaderUpdate)
		self:UnregisterEvent("PLAYER_REGEN_DISABLED", FaderUpdate)
		self:UnregisterEvent('UNIT_TARGET', FaderUpdate)
		self:UnregisterEvent('PLAYER_TARGET_CHANGED', FaderUpdate)

		self:UnregisterEvent('UNIT_SPELLCAST_START', FaderUpdate)
		self:UnregisterEvent('UNIT_SPELLCAST_FAILED', FaderUpdate)
		self:UnregisterEvent('UNIT_SPELLCAST_STOP', FaderUpdate)
		self:UnregisterEvent('UNIT_SPELLCAST_INTERRUPTED', FaderUpdate)
		self:UnregisterEvent('UNIT_SPELLCAST_CHANNEL_START', FaderUpdate)
		self:UnregisterEvent('UNIT_SPELLCAST_CHANNEL_INTERRUPTED', FaderUpdate)
		self:UnregisterEvent('UNIT_SPELLCAST_CHANNEL_STOP', FaderUpdate)
		self:On_Show()
	end
end

function PB:ACTIVE_TALENT_GROUP_CHANGED()
	local bar = self.holder.power
	local spec = GetSpecialization() or -1
	if S.myclass == "PRIEST" and spec ~= 3 then
		for i = 1,5 do
			bar[i]:Hide()
		end
		bar:UnregisterAllEvents()
	elseif S.myclass == "PRIEST" and spec == 3 then
		bar:RegisterEvent("UNIT_POWER")
		bar:RegisterEvent("UNIT_DISPLAYPOWER")
	end
	if S.myclass == "DRUID" and spec ~= 1 then
		self.holder.eb:Hide()
		self.holder.eb:UnregisterAllEvents()
	elseif S.myclass == "DRUID" and spec == 1 then
		self.holder.eb:RegisterEvent("ECLIPSE_DIRECTION_CHANGE")
		self.holder.eb:RegisterEvent("PLAYER_TALENT_UPDATE")
		self.holder.eb:RegisterEvent("UNIT_POWER")
		self.holder.eb:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
		self.holder.eb:RegisterEvent("PLAYER_ENTERING_WORLD")
		self.holder.eb:RegisterEvent("PLAYER_REGEN_DISABLED")
	end
	if S.myclass == "MAGE" and spec ~= 1 then
		for i = 1,4 do
			bar[i]:Hide()
		end
		bar:UnregisterEvent("UNIT_AURA")
	elseif S.myclass == "MAGE"  and spec == 1 then
		bar:RegisterEvent("UNIT_AURA")
	end
end

function PB:PLAYER_ENTERING_WORLD()
	self:ACTIVE_TALENT_GROUP_CHANGED()
end

function PB:UpdateEnable()
	if self.db.Open then
		self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
		self:RegisterEvent("PLAYER_ENTERING_WORLD")
		self:UpdateFade()
	else
		self:UnregisterAllEvents()
		self:On_Hide()
	end
end

function PB:Initialize()
	self:CreateMainFrame()    					--新建主体
	self:CreateHealthFrame()  					--hp条
	self:CreateManaFrame() 						--mana条
	self:CreateCommonPowerBar()					--power
	self:SetHealthManaScript()					--设置hp/mana
	if self:ChechCommonClass() then         	--牧师/圣骑士/武僧
		self:CommonPowerBarEvent()
	elseif S.myclass == "DEATHKNIGHT" then 			--DK
		self:DEATHKNIGHT()
	elseif S.myclass == "ROGUE" then				--盗贼
		self:CreateCombatPoint()
		self:ROGUE()
	elseif S.myclass == "DRUID" then				--小德
		self:CreateCombatPoint()
		self:DRUID()
	elseif S.myclass == "WARLOCK" then				--术士
		self:WARLOCK()
	elseif S.myclass == "SHAMAN" then				--萨满
		self:SHAMAN()
	elseif S.myclass == "MAGE" then					--法师
		self:MAGE()
	end
	self:UpdateEnable()
	
end

S:RegisterModule(PB:GetName())