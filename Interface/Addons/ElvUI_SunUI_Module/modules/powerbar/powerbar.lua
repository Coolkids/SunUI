local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local PB = E:NewModule('PowerBar-SunUI', "AceEvent-3.0", "AceHook-3.0", "AceConsole-3.0");

--Cache global variables
--Lua functions
local select = select
local floor = math.floor
--WoW API / Variables
local CreateFrame = CreateFrame

--[[
整体有个Frame做Parent
然后每个模块独立一个Frame主体 根据不同职业初始化不同框体
health跟power为2个Frame但是由一个OnUpdate事件控制

其他独立模块在模块内加载
天赋控制系统
显隐控制系统
姿态控制系统

好吧以上都是幻想...没时间重构了.....
]]

local space = (E.myclass == "DEATHKNIGHT" or E.myclass == "SHAMAN") and 3 or 6

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

local color = {


}

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
	["PRIEST"] = 1,    		--暗牧  do
	["MONK"] = 6,			--武僧  do
	["DEATHKNIGHT"] = 6,	--DK    do
	["PALADIN"] = 5,		--圣骑士  do
	["ROGUE"] = 8,			--连击点 盗贼/野德
	["DRUID"] = 5,			--日/月能
	["WARLOCK"] = 5,		--术士
	["MAGE"] = 4,			--法师
	["SHAMAN"] = 4,			--萨满

},{__index=function() return -1 end})

local maxp = 0

local powerTypeList = setmetatable ({
	--["PRIEST"] = SPELL_POWER_SHADOW_ORBS,
	["MONK"] = SPELL_POWER_CHI,
	["PALADIN"] = SPELL_POWER_HOLY_POWER,
	["ROGUE"] = SPELL_POWER_COMBO_POINTS,
	["DRUID"] = SPELL_POWER_COMBO_POINTS,
	["MAGE"] = SPELL_POWER_ARCANE_CHARGES,
	["WARLOCK"] = SPELL_POWER_SOUL_SHARDS,
}, {__index=function() return nil end})

local powerType2List = setmetatable ({
	--["PRIEST"] = "INSANITY",
	["MONK"] = "CHI",
	["PALADIN"] = "HOLY_POWER",
	["ROGUE"] = "COMBO_POINTS",
	["DRUID"] = "COMBO_POINTS",
	["MAGE"] = "ARCANE_CHARGES",
	["WARLOCK"] = "SOUL_SHARDS",
}, {__index=function() return nil end})


local powerType3List = setmetatable ({
	["PRIEST"] = "INSANITY",
	["DRUID"] = "LUNAR_POWER",
}, {__index=function() return nil end})

local needSkin = setmetatable ({
	["SHAMAN"] = false,
	["DEATHKNIGHT"] = false,
	["PRIEST"] = false,
}, {__index=function() return true end})

function PB:GetOptions()
	local options = {
		type = "group",
		name = "职业能量条",
		order = -96,
		get = function(info) return E.db.PowerBar[ info[#info] ] end,
		set = function(info, value) E.db.PowerBar[ info[#info] ] = value 
			PB:UpdateConfig()
		end,
		args = {
			Open = {
				type = "toggle",
				name = "启用职业能量条",
				order = 1,
			},
			group2 = {
				type = "group", order = 2, guiInline = true, disabled = function(info) return not E.db.PowerBar.Open end,
				name = "",
				args = {
					Width = {
						type = "input",
						name = "框体宽度",
						order = 1,
						get = function() return tostring(E.db.PowerBar.Width) end,
						set = function(_, value) E.db.PowerBar.Width = tonumber(value) end,
					},
					Height = {
						type = "input",
						name = "框体高度",
						order = 2,
						get = function() return tostring(E.db.PowerBar.Height) end,
						set = function(_, value) E.db.PowerBar.Height = tonumber(value) end,
					},
					Fade = {
						type = "toggle",
						name = "渐隐",
						order = 4,
					},
					HealthPower = {
						type = "toggle",
						name = "生命值",
						order = 5,
					},
					DisableText = {
						type = "toggle",
						name = "不显示文字",
						order = 6,
					},
					HealthPowerPer = {
						type = "toggle",
						name = "生命值用百分比替代",
						order = 7,
						disabled = function() return E.db.PowerBar.DisableText end,
					},
					
					ManaPowerPer = {
						type = "toggle",
						name = "魔法值用百分比替代",
						order = 8,
						disabled = function() return E.db.PowerBar.DisableText end,
					},
				}
			},
		}
	}
	return options
end

function PB:CheckMaxBarNumber()
	maxp = maxPowerNumber[E.myclass]
	return maxPowerNumber[E.myclass]
end

function PB:CheckPowerType()
	return powerTypeList[E.myclass]
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
	E:CreateMover(self.holder, "PowerBarMover", "PowerBar", nil, nil, nil, "ALL,SunUI")
	self.holder.power = CreateFrame("Statusbar", nil, self.holder)
	self.holder.power:SetAllPoints()
	self.holder.skin = CreateFrame("Statusbar", nil, self.holder)
	self.holder.skin:SetAllPoints()
	local temp = CreateFrame("Frame", nil, self.holder.power)
	temp:SetAllPoints()
	temp:SetFrameLevel(self.holder.power:GetFrameLevel()+1)
	
	
	self.holder.power.text = E:CreateFS(temp)
	self.holder.power.text:SetPoint("CENTER")
	self.holder.power.text:SetText("")
	
	local A = E:GetModule("Skins-SunUI")
	if needSkin[E.myclass] then
		A:CreateBD(self.holder.skin, 0.6)
	end
end

function PB:CreateHealthFrame()
	self.holder.health = CreateFrame("Statusbar", nil, self.holder)
	self.holder.health:SetAllPoints()
	self.holder.health:SetStatusBarTexture(P["media"].normal)
	self.holder.health:SetMinMaxValues(0, UnitHealthMax("player"))
	self.holder.health:SetValue(UnitHealth("player"))
	self.holder.health:SetStatusBarColor(0.1, 0.8, 0.1, 0)

	self.holder.health.spar = self.holder.health:CreateTexture(nil, "OVERLAY")
	self.holder.health.spar:SetTexture("Interface\\Addons\\ElvUI_SunUI_Module\\Media\\textureArrowBelow.tga")
	self.holder.health.spar:SetVertexColor(1, 0, 0, 1) 
	self.holder.health.spar:SetSize(12, 12)
	self.holder.health.spar:SetPoint("TOP", self.holder.health:GetStatusBarTexture(), "BOTTOMRIGHT", -1, -2)

	self.holder.health.text = E:CreateFS(self.holder.health)
	self.holder.health.text:SetPoint("TOP", self.holder.health.spar, "BOTTOM", 0, 3)
	self.holder.health.text:SetTextColor(210/255, 100/255, 100/255)
	
	E:SmoothBar(self.holder.health)
end

function PB:CreateManaFrame()
	self.holder.mana = CreateFrame("Statusbar", nil, self.holder)
	self.holder.mana:SetSize(self.db.Width, self.db.Height)
	self.holder.mana:SetStatusBarTexture(P["media"].normal)
	self.holder.mana:SetAllPoints()
	self.holder.mana:SetStatusBarColor(0.1, 0.8, 0.1, 0)
	self.holder.mana:SetMinMaxValues(0, UnitPowerMax("player"))
	
	self.holder.mana.spar =  self.holder.mana:CreateTexture(nil, "OVERLAY")
	self.holder.mana.spar:SetTexture("Interface\\Addons\\ElvUI_SunUI_Module\\Media\\textureArrowAbove.tga")
	self.holder.mana.spar:SetVertexColor(.3,.45,.65) 
	self.holder.mana.spar:SetSize(12, 12)
	self.holder.mana.spar:SetPoint("BOTTOM", self.holder.mana:GetStatusBarTexture(), "TOPRIGHT", -1, 2)
	
	self.holder.mana.text = E:CreateFS(self.holder.mana)
	self.holder.mana.text:SetPoint("BOTTOM", self.holder.mana.spar, "TOP", 0, -3)
	
	E:SmoothBar(self.holder.mana)
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
				--E:Print(E:ShortValue(healthnum))
				self.health.text:SetText(E:ShortValue(healthnum))
			end
			if PB.db.ManaPowerPer then
				self.mana.text:SetText(format("%d|cffffd700%%|r", powernum/maxMana*100))
			else
				self.mana.text:SetText(E:ShortValue(powernum))
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
		self.holder.power[i]:SetStatusBarTexture(P["media"].normal)
		self.holder.power[i]:SetStatusBarColor(.86,.22,1) --TODO 后期颜色处理 萨满/术士/日月能/DK已经处理
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
	if( unit ~= "player" or (powerType and powerType ~= powerType2List[E.myclass]) ) then 
		return 
	end
	PB:Common_OnEvent_IMPL()
end

function PB:CommonPowerBarEvent()
	self.holder.power:RegisterEvent("UNIT_POWER_FREQUENT")
	self.holder.power:RegisterEvent("UNIT_DISPLAYPOWER")
	self.holder.power:RegisterEvent("PLAYER_ENTERING_WORLD")
	self.holder.power:SetScript("OnEvent", Common_OnEvent)
end

function PB:DEATHKNIGHT()
	local function OnUpdate(self, elapsed)
		local duration = self.duration + elapsed
		if(duration >= self.max) then
			return self:SetScript("OnUpdate", nil)
		else
			self.duration = duration
			return self:SetValue(duration)
		end
	end
	
	local function OnEvent(self, event, rid)
		if event == "RUNE_POWER_UPDATE" or "PLAYER_ENTERING_WORLD" then 
			local rune = self[rid]
			if(rune) then
				local start, duration, runeReady = GetRuneCooldown(rid)
					if(not start) then
					-- As of 6.2.0 GetRuneCooldown returns nil values when zoning
					return
				end
				if(runeReady) then
					rune:SetMinMaxValues(0, 1)
					rune:SetValue(1)
					rune:SetScript("OnUpdate", nil)
				else
					rune.duration = GetTime() - start
					rune.max = duration
					rune:SetMinMaxValues(1, duration)
					rune:SetScript("OnUpdate", OnUpdate)
				end
			end
		end
	end
	
	for i=1,6 do
		self.holder.power[i]:Show()
	end
	self.holder.power:RegisterEvent("RUNE_POWER_UPDATE")
	self.holder.power:RegisterEvent("PLAYER_ENTERING_WORLD")
	self.holder.power:SetScript("OnEvent", OnEvent)
end

function PB:DRUID()
	local ECLIPSE_BAR_SOLAR_BUFF_ID = ECLIPSE_BAR_SOLAR_BUFF_ID
	local ECLIPSE_BAR_LUNAR_BUFF_ID = ECLIPSE_BAR_LUNAR_BUFF_ID
	local SPELL_POWER_ECLIPSE = SPELL_POWER_ECLIPSE
	local MOONKIN_FORM = MOONKIN_FORM
	local showBar, showCombatBar = false, false
	local A = E:GetModule("Skins-SunUI")
	self.holder.eb = CreateFrame('StatusBar', nil, self.holder)
	self.holder.eb:SetStatusBarTexture(P["media"].normal)
	self.holder.eb:SetSize(self.db.Width, self.db.Height)
	self.holder.eb:SetMinMaxValues(0, 100)
	self.holder.eb:SetValue(0)
	self.holder.eb:SetAllPoints()
	A:CreateShadow2(self.holder.eb, 0.6)
	E:SmoothBar(self.holder.eb)
	A:CreateMark(self.holder.eb)
	self.holder.eb:SetStatusBarColor(0.9, 0.9, 0)
	
	local temp = CreateFrame("Frame", nil, self.holder.eb)
	temp:SetAllPoints()
	temp:SetFrameLevel(self.holder.eb:GetFrameLevel()+1)
	
	
	self.holder.eb.text = E:CreateFS(temp)
	self.holder.eb.text:SetPoint("CENTER")
	self.holder.eb.text:SetText("")
	
	self.holder.eb:SetScript("OnEvent", function(self, event, unit, powerType)
		if event == "UNIT_POWER_FREQUENT" then
			if(unit ~= "player" or (powerType and powerType ~= 'LUNAR_POWER')) then return end
			
			local maxPower = UnitPowerMax("player", powerType, true)
			local power = UnitPower("player", powerType, true)
			
			self:SetMinMaxValues(0, maxPower)
			self:SetValue(power)
			self.text:SetFormattedText("%d", power*100/maxPower)
		end
		if event == "PLAYER_ENTERING_WORLD" then 
			local maxPower = UnitPowerMax("player", 'LUNAR_POWER', true)
			local power = UnitPower("player", 'LUNAR_POWER', true)
			self:SetMinMaxValues(0, maxPower)
			self:SetValue(power)
			self.text:SetFormattedText("%d", power*100/maxPower)
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

function PB:PRIEST()
	local A = E:GetModule("Skins-SunUI")
	A:CreateMark(self.holder.power[1])
	E:SmoothBar(self.holder.power[1])
	self.holder.power:RegisterEvent("UNIT_POWER_FREQUENT")
	self.holder.power:RegisterEvent("UNIT_DISPLAYPOWER")
	self.holder.power:RegisterEvent("PLAYER_ENTERING_WORLD")
	self.holder.power:Show()

	self.holder.power:SetScript("OnEvent", function(self, event, unit, powerType)
		if not self[1].isShow then
			self[1]:Show()
			self[1].isShow = true
		end
		
		if event == "PLAYER_ENTERING_WORLD" then
			local maxPower = UnitPowerMax("player", SPELL_POWER_SHADOW_ORBS, true)
			local power = UnitPower("player", SPELL_POWER_SHADOW_ORBS, true)
			self[1]:SetMinMaxValues(0, maxPower)
			self[1]:SetValue(power)	
			--self.text:SetFormattedText("%d", power*100/maxPower)
		end
		if unit ~= "player" and powerType ~= "INSANITY" then return end
		local maxPower = UnitPowerMax("player", SPELL_POWER_SHADOW_ORBS, true)
		local power = UnitPower("player", SPELL_POWER_SHADOW_ORBS, true)
		self[1]:SetMinMaxValues(0, maxPower)
		self[1]:SetValue(power)	
		--self.text:SetFormattedText("%d", power*100/maxPower)
	end)
end

function PB:ColorPowerBar(i)
	local bar = self.holder.power
	if E.myclass == "PRIEST" then 			
		bar[i]:SetStatusBarColor(.86,.22,1)
	elseif E.myclass == "ROGUE" or E.myclass == "DRUID" then
		if i ~= 5 and i ~= 6 and i ~= 8 then
			bar[i]:SetStatusBarColor(0.9, 0.9, 0)
		elseif i == 5 then
			bar[i]:SetStatusBarColor(1, 0.2, 0.2)
		elseif i == 6 then
			bar[i]:SetStatusBarColor(148/255, 130/255, 201/255)
		elseif i == 8 then
			bar[i]:SetStatusBarColor(0, 181/255, 181/255)
		end
	elseif E.myclass == "DEATHKNIGHT" then
		bar[i]:SetStatusBarColor(0, 181/255, 181/255)
	elseif E.myclass == "WARLOCK" then
		bar[i]:SetStatusBarColor(148/255, 130/255, 201/255)
	elseif E.myclass == "MONK" then				
		bar[i]:SetStatusBarColor(0.0, 1.00 , 0.59)
	elseif E.myclass == "PALADIN" then				
		bar[i]:SetStatusBarColor(0.9, 0.9, 0)
	elseif E.myclass == "MAGE" then				
		bar[i]:SetStatusBarColor(E.myclasscolor.r, E.myclasscolor.g, E.myclasscolor.b)
	end
	local A = E:GetModule("Skins-SunUI")
	if E.myclass ~= "DEATHKNIGHT" or E.myclass ~= "SHAMAN" then
		A:CreateMark(bar[i])
	end
	A:CreateShadow2(bar[i], 0.6)
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
	--E:ShowAnima(self.holder)
	UIFrameFadeIn(self.holder, 0.15, self.holder:GetAlpha(), 1)
end
function PB:On_Hide()
	if not self.holder:IsShown() then return end
	--E:HideAnima(self.holder)
	E:FadeOutFrame(self.holder, 0.15)
	
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
	if E.myclass == "PRIEST" and spec ~= SPEC_PRIEST_SHADOW then
		for i = 1,maxp do
			bar[i]:Hide()
		end
		bar:UnregisterEvent("UNIT_POWER_FREQUENT")
		bar:UnregisterEvent("UNIT_DISPLAYPOWER")
	elseif E.myclass == "PRIEST" and spec == SPEC_PRIEST_SHADOW then
		bar:RegisterEvent("UNIT_POWER_FREQUENT")
		bar:RegisterEvent("UNIT_DISPLAYPOWER")
	end
	if E.myclass == "PALADIN" and spec ~= SPEC_PALADIN_RETRIBUTION then
		for i = 1,maxp do
			bar[i]:Hide()
		end
		bar:UnregisterEvent("UNIT_POWER_FREQUENT")
		bar:UnregisterEvent("UNIT_DISPLAYPOWER")
	elseif E.myclass == "PALADIN" and spec == SPEC_PALADIN_RETRIBUTION then
		bar:RegisterEvent("UNIT_POWER_FREQUENT")
		bar:RegisterEvent("UNIT_DISPLAYPOWER")
	end
	
	if E.myclass == "MAGE" and spec ~= SPEC_MAGE_ARCANE then
		for i = 1,maxp do
			bar[i]:Hide()
		end
		bar:UnregisterEvent("UNIT_POWER_FREQUENT")
		bar:UnregisterEvent("UNIT_DISPLAYPOWER")
	elseif E.myclass == "MAGE" and spec == SPEC_MAGE_ARCANE then
		bar:RegisterEvent("UNIT_POWER_FREQUENT")
		bar:RegisterEvent("UNIT_DISPLAYPOWER")
	end
	
	if E.myclass == "MONK" and spec ~= SPEC_MONK_WINDWALKER then
		for i = 1,maxp do
			bar[i]:Hide()
		end
		bar:UnregisterEvent("UNIT_POWER_FREQUENT")
		bar:UnregisterEvent("UNIT_DISPLAYPOWER")
	elseif E.myclass == "MONK" and spec == SPEC_MONK_WINDWALKER then
		bar:RegisterEvent("UNIT_POWER_FREQUENT")
		bar:RegisterEvent("UNIT_DISPLAYPOWER")
	end
	
	

	
	if E.myclass == "DRUID" and spec ~= 1 then
		self.holder.eb:Hide()
		self.holder.skin:Show()
		self.holder.eb:UnregisterAllEvents()
	elseif E.myclass == "DRUID" and spec == 1 then
		self.holder.eb:Show()
		self.holder.skin:Hide()
		self.holder.eb:RegisterEvent("UNIT_POWER_FREQUENT")
		self.holder.eb:RegisterEvent("UNIT_DISPLAYPOWER")
		self.holder.eb:RegisterEvent("PLAYER_ENTERING_WORLD")
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

function PB:UpdateConfig()
	self:UpdateEnable()
end

function PB:Initialize()
	self.db = E.db.PowerBar
	self:CreateMainFrame()    					--新建主体
	self:CreateHealthFrame()  					--hp条
	self:CreateManaFrame() 						--mana条
	self:CreateCommonPowerBar()					--power
	self:SetHealthManaScript()					--设置hp/mana
	if self:ChechCommonClass() then         	--圣骑士/武僧/法师/术士/连击点
		self:CommonPowerBarEvent()
	end
	if E.myclass == "DEATHKNIGHT" then 			--DK
		self:DEATHKNIGHT()
	elseif E.myclass == "DRUID" then				--小德
		self:DRUID()
	elseif E.myclass == "SHAMAN" then				--萨满
		self:SHAMAN()
	elseif E.myclass == "PRIEST" then
		self:PRIEST()
	end
	self:UpdateEnable()
end

E:RegisterModule(PB:GetName())