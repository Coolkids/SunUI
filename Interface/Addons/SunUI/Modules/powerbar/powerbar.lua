local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local

local PB = S:NewModule("PowerBar", "AceEvent-3.0", "AceHook-3.0", "AceConsole-3.0")
local powercolor = {}
local space = (S.myclass == "DEATHKNIGHT" or S.myclass == "SHAMAN") and 3 or 6
local Holder = CreateFrame("Statusbar", nil, UIParent)
local mainframe = {}
local threeframe = {}
local fourframe = {}
local fiveframe = {}
local sixframe = {}
local healthbar
PB.order = 13
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

local ShadowOrbs,eb,MageBars
if S.myclass == "PRIEST" then
	ShadowOrbs = CreateFrame("Frame", nil, Holder)
elseif S.myclass == "DRUID" then
	eb = CreateFrame("Frame", nil, Holder)
elseif S.myclass == "MAGE" then
	MageBars = CreateFrame("Frame", nil, Holder)
end
PB.modName = L["PowerBar"]

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
						self:UpdateHealthBar()
					end,
				},
				DisableText = {
					type = "toggle",
					name = L["不显示文字"],
					order = 6,
					get = function() return self.db.DisableText end,
					set = function(_, value)
						self.db.DisableText = value
						self:UpdateHealthBar()
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
						self:UpdateHealthBar()
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
						self:UpdateHealthBar()
					end,
				},
			}
		},
	}
	return options
end

function PB:CreateShadowOrbs()
	if S.myclass ~= "PRIEST" then return end
	ShadowOrbs:SetSize(self.db.Width, self.db.Height)
	ShadowOrbs:SetPoint("CENTER", Holder)
	tinsert(mainframe, ShadowOrbs)
	local maxShadowOrbs = 3
	--local maxShadowOrbs = UnitPowerMax('player', SPELL_POWER_SHADOW_ORBS) = 3
	--print(maxShadowOrbs)
	for i = 1,maxShadowOrbs do  --maxShadowOrbs
		ShadowOrbs[i] = CreateFrame("StatusBar", nil, ShadowOrbs)
		tinsert(threeframe, ShadowOrbs[i])
		ShadowOrbs[i]:SetSize((self.db.Width-space*(maxShadowOrbs-1))/maxShadowOrbs, self.db.Height)
		ShadowOrbs[i]:SetStatusBarTexture(S["media"].normal)
		ShadowOrbs[i]:SetStatusBarColor(.86,.22,1)
		ShadowOrbs[i]:CreateShadow()
		ShadowOrbs[i]:Hide()
		if (i == 1) then
			ShadowOrbs[i]:SetPoint("LEFT", ShadowOrbs, "LEFT")
		else
			ShadowOrbs[i]:SetPoint("LEFT", ShadowOrbs[i-1], "RIGHT", space, 0)
		end
	end
	ShadowOrbs:RegisterEvent("UNIT_POWER")
	ShadowOrbs:RegisterEvent("UNIT_DISPLAYPOWER")
	ShadowOrbs:RegisterEvent("PLAYER_ENTERING_WORLD")
	ShadowOrbs:SetScript("OnEvent",function(self, event, unit, powerType)
		if(event=="PLAYER_ENTERING_WORLD") then 
			local numShadowOrbs = UnitPower('player', SPELL_POWER_SHADOW_ORBS)
			for i = 1,maxShadowOrbs do
				if i <= numShadowOrbs then
					ShadowOrbs[i]:Show()
				else
					ShadowOrbs[i]:Hide()
				end
			end
		end
		if( unit ~= "player" or (powerType and powerType ~= 'SHADOW_ORBS')) then return end
		local numShadowOrbs = UnitPower('player', SPELL_POWER_SHADOW_ORBS)
		for i = 1,maxShadowOrbs do
			if i <= numShadowOrbs then
				ShadowOrbs[i]:Show()
			else
				ShadowOrbs[i]:Hide()
			end
		end
	end)
end
--Monk harmony bar
function PB:CreateMonkBar()
	if S.myclass ~= "MONK" then return end
	local chibar = CreateFrame("Frame",nil,Holder)
	chibar:SetSize(self.db.Width, self.db.Height)
	chibar:SetPoint("CENTER", Holder)
	tinsert(mainframe, chibar)
	local maxChi = 5
	for i=1,maxChi do
		chibar[i] = CreateFrame("StatusBar",nil,chibar)
		chibar[i]:SetSize((self.db.Width-space*(maxChi-1))/maxChi, self.db.Height)
		tinsert(fiveframe, chibar[i])
		chibar[i]:SetStatusBarTexture(S["media"].normal)
		chibar[i]:SetStatusBarColor(0.0, 1.00 , 0.59)
		chibar[i]:CreateShadow()
		if i==1 then
			chibar[i]:SetPoint("LEFT", chibar, "LEFT")
		else
			chibar[i]:SetPoint("LEFT", chibar[i-1], "RIGHT", space, 0)
		end
		chibar[i]:Hide()
	end
	chibar:RegisterEvent("UNIT_POWER")
	chibar:RegisterEvent("UNIT_DISPLAYPOWER")
	chibar:RegisterEvent("PLAYER_ENTERING_WORLD")
	chibar:SetScript("OnEvent",function(self, event, unit, powerType)
		if(event=="PLAYER_ENTERING_WORLD") then 
			local chinum = UnitPower("player",SPELL_POWER_CHI)
			local chimax = UnitPowerMax("player",SPELL_POWER_CHI)
			if chinum ~= chimax then
				if chimax == 4 then
					chibar[maxChi]:Hide()
					for i = 1,4 do
						chibar[i]:SetWidth((PB.db.Width-space*(4-1))/4)
					end
				elseif chimax == maxChi then
					chibar[maxChi]:Show()
					for i = 1,maxChi do
						chibar[i]:SetWidth((PB.db.Width-space*(maxChi-1))/maxChi)
					end
				end
			end
			for i = 1,chimax do
				if i <= chinum then
					chibar[i]:Show()
				else
					chibar[i]:Hide()
				end
			end
		end
		if( unit ~= "player" or (powerType and powerType ~= 'CHI')) then return end
		local chinum = UnitPower("player",SPELL_POWER_CHI)
		local chimax = UnitPowerMax("player",SPELL_POWER_CHI)
		if chinum ~= chimax then
			if chimax == 4 then
				chibar[maxChi]:Hide()
				for i = 1,4 do
					chibar[i]:SetWidth((PB.db.Width-space*(4-1))/4)
				end
			elseif chimax == maxChi then
				chibar[maxChi]:Show()
				for i = 1,maxChi do
					chibar[i]:SetWidth((PB.db.Width-space*(maxChi-1))/maxChi)
				end
			end
		end
		for i = 1,chimax do
			if i <= chinum then
				chibar[i]:Show()
			else
				chibar[i]:Hide()
			end
		end
	end)
end
--DK and QS
--下面是DK的,,,
local runes = {
	{1, 0, 0},   -- blood
	{0, .5, 0},  -- unholy
	{0, 1, 1},   -- frost
	{.9, .1, 1}, -- death
}
local runemap = { 1, 2, 5, 6, 3, 4 }
local OnUpdate = function(self, elapsed)
	local duration = self.duration + elapsed
	if(duration >= self.max) then
		return self:SetScript("OnUpdate", nil)
	else
		self.duration = duration
		return self:SetValue(duration)
	end
end
local UpdateType = function(self, rid, alt)
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
function PB:CreateQSDKPower()
	if  S.myclass ~= "PALADIN" and S.myclass ~= "DEATHKNIGHT" then return end
    local count
	if S.myclass == "DEATHKNIGHT" then 
		count = 6
		RuneFrame.Show = RuneFrame.Hide
		RuneFrame:Hide()
	elseif S.myclass == "PALADIN" then
		count = 5
	end
	local bars = CreateFrame("Frame", nil, Holder)
	bars:SetSize(self.db.Width, self.db.Height)
	bars:SetPoint("CENTER", Holder)
	tinsert(mainframe, bars)
	for i = 1, count do
		bars[i] =CreateFrame("StatusBar", nil, bars)
		bars[i]:SetStatusBarTexture(S["media"].normal)
		bars[i]:GetStatusBarTexture():SetHorizTile(false)
		bars[i]:SetSize((self.db.Width-space*(count-1))/count, self.db.Height)
		if count == 6 then tinsert(sixframe, bars[i]) else tinsert(sixframe, fiveframe[i]) end
		
		if (i == 1) then
			bars[i]:SetPoint("LEFT", bars, "LEFT")
		else
			bars[i]:SetPoint("LEFT", bars[i-1], "RIGHT", space, 0)
		end
        if S.myclass == "PALADIN" then
			bars[i]:SetStatusBarColor(0.9, 0.9, 0)
			bars[i]:Hide()
		else
			local A = S:GetModule("Skins")
			S:SmoothBar(bars[i])
			A:CreateMark(bars[i])
		end
		bars[i]:CreateShadow(0.5)
	end
	if S.myclass == "DEATHKNIGHT" then
		for i=1,6 do
			UpdateType(bars, i, math.floor((runemap[i]+1)/2))
		end
	end
	if S.myclass == "DEATHKNIGHT" then
		bars:RegisterEvent("RUNE_POWER_UPDATE")
		bars:RegisterEvent("RUNE_TYPE_UPDATE")
		bars:SetScript("OnEvent", OnEvent)
	elseif S.myclass == "PALADIN" then
		bars:RegisterEvent("UNIT_POWER")
		bars:RegisterEvent("UNIT_DISPLAYPOWER")
		bars:RegisterEvent("PLAYER_ENTERING_WORLD")
		bars:SetScript("OnEvent",function(self, event, unit)
			if(event=="PLAYER_ENTERING_WORLD") then 
				local num = UnitPower('player', SPELL_POWER_HOLY_POWER)
				local maxnum = UnitPowerMax('player', SPELL_POWER_HOLY_POWER)
				if num ~= maxnum then
					if maxnum == 3 then
						bars[4]:Hide()
						bars[5]:Hide()
						for i = 1,3 do
							bars[i]:SetWidth((PB.db.Width-space*(3-1))/3)
						end
					elseif maxnum == 5 then
						bars[4]:Show()
						bars[5]:Show()
						for i = 1,5 do
							bars[i]:SetWidth((PB.db.Width-space*(5-1))/5)
						end
					end
				end
				for i = 1,count do
					if i <= num then
						bars[i]:Show()
					else
						bars[i]:Hide()
					end
				end
			end
			if( unit ~= "player" or (powerType and powerType ~= 'HOLY_POWER')) then return end
			local num = UnitPower('player', SPELL_POWER_HOLY_POWER)
			local maxnum = UnitPowerMax('player', SPELL_POWER_HOLY_POWER)
			if num ~= maxnum then
				if maxnum == 3 then
					bars[4]:Hide()
					bars[5]:Hide()
					for i = 1,3 do
						bars[i]:SetWidth((PB.db.Width-space*(3-1))/3)
					end
				elseif maxnum == 5 then
					bars[4]:Show()
					bars[5]:Show()
					for i = 1,5 do
						bars[i]:SetWidth((PB.db.Width-space*(5-1))/5)
					end
				end
			end
			for i = 1,count do
				if i <= num then
					bars[i]:Show()
				else
					bars[i]:Hide()
				end
			end
		end)
	end
end
function PB:CreateCombatPoint()
	if S.myclass ~= "ROGUE" and S.myclass ~= "DRUID" then return end
	local CombatPointBar = CreateFrame("Frame", nil, Holder)
	CombatPointBar:SetSize(self.db.Width, self.db.Height)
	CombatPointBar:SetPoint("CENTER", Holder)
	tinsert(mainframe, CombatPointBar)
	for i = 1, 5 do
		CombatPointBar[i] =CreateFrame("StatusBar", nil, CombatPointBar)
		CombatPointBar[i]:SetStatusBarTexture(S["media"].normal)
		CombatPointBar[i]:GetStatusBarTexture():SetHorizTile(false)
		CombatPointBar[i]:SetSize((self.db.Width-space*4)/5, self.db.Height)
		tinsert(fiveframe, CombatPointBar[i])
		if (i == 1) then
			CombatPointBar[i]:SetPoint("LEFT", CombatPointBar, "LEFT")
		else
			CombatPointBar[i]:SetPoint("LEFT", CombatPointBar[i-1], "RIGHT", space, 0)
		end
		if i ~= 5 then 
			CombatPointBar[i]:SetStatusBarColor(0.9, 0.9, 0)
		else
			CombatPointBar[i]:SetStatusBarColor(1, 0.2, 0.2)
		end
		CombatPointBar[i]:CreateShadow()
		CombatPointBar[i]:Hide()
	end
	CombatPointBar:RegisterEvent("UNIT_COMBO_POINTS")
	CombatPointBar:RegisterEvent("PLAYER_TARGET_CHANGED")
	CombatPointBar:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
	CombatPointBar:RegisterEvent("PLAYER_TALENT_UPDATE")
	CombatPointBar:RegisterEvent("PLAYER_REGEN_DISABLED")
	CombatPointBar:SetScript("OnEvent", function(self, event)
		if event == "PLAYER_TALENT_UPDATE" or event == "UPDATE_SHAPESHIFT_FORM" or event == "UNIT_COMBO_POINTS" then
			if S.myclass == "DRUID" then 
				local form = GetShapeshiftFormID()
				if(not form) then
					self:Hide()
				elseif(form ~= CAT_FORM) then
					self:Hide()
				else
					self:Show()
				end
			end
		end
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
--鸟德
function PB:CreateEclipse()
	if S.myclass ~= "DRUID" then return end
	local ECLIPSE_BAR_SOLAR_BUFF_ID = ECLIPSE_BAR_SOLAR_BUFF_ID
	local ECLIPSE_BAR_LUNAR_BUFF_ID = ECLIPSE_BAR_LUNAR_BUFF_ID
	local SPELL_POWER_ECLIPSE = SPELL_POWER_ECLIPSE
	local MOONKIN_FORM = MOONKIN_FORM
	local showBar = false
	local A = S:GetModule("Skins")
	eb = CreateFrame('Frame', nil, Holder)
	eb:SetSize(self.db.Width, self.db.Height)
	eb:SetPoint("CENTER", Holder)
	eb:CreateShadow()
	tinsert(mainframe, eb)
	local lb = CreateFrame('StatusBar', nil, eb)
	lb:SetPoint('LEFT', eb, 'LEFT')
	lb:SetSize(self.db.Width, self.db.Height)
	tinsert(mainframe, lb)
	S:SmoothBar(lb)
	lb:SetStatusBarTexture(S["media"].normal)
	lb:SetStatusBarColor(0.27, 0.47, 0.74)
	A:CreateMark(lb)
	eb.LunarBar = lb
	local sb = CreateFrame('StatusBar', nil, eb)
	sb:SetPoint('LEFT', lb:GetStatusBarTexture(), 'RIGHT', 0, 0)
	sb:SetPoint('TOPRIGHT', eb, 'TOPRIGHT', 0, 0)
	sb:SetSize(self.db.Width, self.db.Height)
	sb:SetStatusBarTexture(S["media"].normal)
	sb:SetStatusBarColor(0.9, 0.6, 0.3)
	eb.SolarBar = sb
	local help = CreateFrame('Frame', nil, eb)
	help:SetAllPoints(eb)
	help:SetFrameLevel(eb:GetFrameLevel()+1)
	local ebInd = help:CreateFontString(nil, "OVERLAY")
	ebInd:FontTemplate(nil, nil, "OUTLINEMONOCHROME")
	ebInd:SetPoint('CENTER', help, 'CENTER', 0, 0)
	ebInd:SetJustifyV("MIDDLE")
	eb.LunarBar.text = ebInd
	eb:RegisterEvent("ECLIPSE_DIRECTION_CHANGE")
	eb:RegisterEvent("PLAYER_TALENT_UPDATE")
	eb:RegisterEvent("UNIT_POWER")
	eb:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
	eb:RegisterEvent("PLAYER_ENTERING_WORLD")
	eb:RegisterEvent("PLAYER_REGEN_DISABLED")
	eb:SetScript("OnEvent", function(self, event, unit, powerType)
		if event == "ECLIPSE_DIRECTION_CHANGE" or event == "PLAYER_ENTERING_WORLD" then
			local dir = GetEclipseDirection()
			if dir=="sun" then
				ebInd:SetTextColor(68/255, 120/255, 188/255)
			elseif dir=="moon" then
				ebInd:SetTextColor(229/255, 153/255, 76/255)
			end
		end
		if event == "PLAYER_TALENT_UPDATE" or event == "UPDATE_SHAPESHIFT_FORM" or event == "PLAYER_REGEN_DISABLED" then
			local form = GetShapeshiftFormID()
			if(not form) then
				showBar = false
			elseif(form == MOONKIN_FORM) then
				showBar = true
			end

			if(showBar) then
				eb:Show()
			else
				eb:Hide()
			end
		end
		if event == "UNIT_POWER" then
			if(unit ~= "player" or (powerType and powerType ~= 'ECLIPSE')) then return end

			local power = UnitPower('player', SPELL_POWER_ECLIPSE)
			local maxPower = UnitPowerMax('player', SPELL_POWER_ECLIPSE)

			if(self.LunarBar) then
				self.LunarBar:SetMinMaxValues(-maxPower, maxPower)
				self.LunarBar:SetValue(power)
				self.LunarBar.text:SetText(power)
			end

			if(self.SolarBar) then
				self.SolarBar:SetPoint('LEFT', lb:GetStatusBarTexture(), 'RIGHT', 0, 0)
				self.SolarBar:SetPoint('TOPRIGHT', eb, 'TOPRIGHT', 0, 0)
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
				self.SolarBar:SetPoint('LEFT', lb:GetStatusBarTexture(), 'RIGHT', 0, 0)
				self.SolarBar:SetPoint('TOPRIGHT', eb, 'TOPRIGHT', 0, 0)
			end
		end
	end)
end
function PB:FuckWarlock()
	if S.myclass ~= "WARLOCK" then return end
	local A = S:GetModule("Skins")
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
	local bars = CreateFrame('Frame', nil, Holder)
	bars:SetSize(self.db.Width, self.db.Height)
	bars:SetPoint("CENTER", Holder)
	tinsert(mainframe, bars)
	for i = 1, 4 do
		bars[i] = CreateFrame("StatusBar", nil, bars)
		bars[i]:SetSize((self.db.Width-space*(4-1))/4, self.db.Height)
		bars[i]:SetStatusBarTexture(S["media"].normal)
		tinsert(fourframe, bars[i])
		S:SmoothBar(bars[i])
		bars[i]:CreateShadow(0.5)
		A:CreateMark(bars[i])
		if i == 1 then
			bars[i]:SetPoint("LEFT", bars)
		else
			bars[i]:SetPoint("LEFT", bars[i-1], "RIGHT", space, 0)
		end
	end
	bars:RegisterEvent("UNIT_POWER")
	bars:RegisterEvent("UNIT_DISPLAYPOWER")
	bars:RegisterEvent("PLAYER_ENTERING_WORLD")
	bars:RegisterEvent("PLAYER_TALENT_UPDATE")
	bars:RegisterEvent("PLAYER_REGEN_DISABLED")
	bars:RegisterEvent("PLAYER_REGEN_ENABLED")
	bars:SetScript("OnEvent", function(self,event,unit, powerType)
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
		end

		if (event == "UNIT_POWER" or event == "UNIT_DISPLAYPOWER") then
			if(unit ~= "player" or (powerType ~= "BURNING_EMBERS" and powerType ~= "SOUL_SHARDS" and powerType ~= "DEMONIC_FURY")) then return end
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
				end
			end
		end
	end)
end
function PB:Mage()
	if S.myclass ~= "MAGE" then return end
	MageBars:SetSize(self.db.Width, self.db.Height)
	MageBars:SetPoint("CENTER", Holder)
	tinsert(mainframe, MageBars)
	for i = 1,4 do
		MageBars[i] = CreateFrame("StatusBar", nil, MageBars)
		MageBars[i]:SetSize((self.db.Width-space*(4-1))/4, self.db.Height)
		MageBars[i]:SetStatusBarTexture(S["media"].normal)
		tinsert(fourframe, MageBars[i])
		MageBars[i]:SetStatusBarColor(S.myclasscolor.r, S.myclasscolor.g, S.myclasscolor.b)
		MageBars[i]:CreateShadow()
		MageBars[i]:Hide()
		if (i == 1) then
			MageBars[i]:SetPoint("LEFT", MageBars)
		else
			MageBars[i]:SetPoint("LEFT", MageBars[i-1], "RIGHT", space, 0)
		end
	end

	MageBars:RegisterEvent("UNIT_AURA")

	MageBars:SetScript("OnEvent",function(self,event,unit)
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

function PB:Shaman()
	if S.myclass ~= "SHAMAN" then return end
	local bars = {}
	local total = 0
	local delay = 0.01
	local A = S:GetModule("Skins")
	-- In the order, fire, earth, water, air
	local colors = {
		[1] = {0.752,0.172,0.02},
		[2] = {0.741,0.580,0.04},
		[3] = {0,0.443,0.631},
		[4] = {0.6,1,0.945},
	}
	for i = 1, 4 do
		bars[i] = CreateFrame("StatusBar", nil, Holder)
		bars[i]:SetStatusBarTexture(S["media"].normal)
		bars[i]:SetSize((self.db.Width-space*(4-1))/4, self.db.Height)
		bars[i]:GetStatusBarTexture():SetHorizTile(false)

		bars[i]:CreateShadow(0.5)
		A:CreateMark(bars[i])
		bars[i]:SetMinMaxValues(0, 1)
		tinsert(fourframe, bars[i])
		if (i == 1) then
			bars[i]:SetPoint("LEFT", Holder)
		else
			bars[i]:SetPoint("LEFT", bars[i-1], "RIGHT", space, 0)
		end
	end
	
	local function UpdateSlot(self, slot)
		if not slot or slot < 1 or slot > 4 then return end

		local totem = bars

		haveTotem, name, startTime, duration, totemIcon = GetTotemInfo(slot)

		totem[slot]:SetStatusBarColor(unpack(colors[slot]))
		totem[slot]:SetValue(0)

		-- Multipliers
		-- if (totem[slot].bg.multiplier) then
			-- local mu = totem[slot].bg.multiplier
			-- local r, g, b = totem[slot]:GetStatusBarColor()
			-- r, g, b = r*mu, g*mu, b*mu
			-- totem[slot].bg:SetVertexColor(r, g, b) 
		-- end

		totem[slot].ID = slot

		-- If we have a totem then set his value 
		if(haveTotem) then

			if totem[slot].Name then
				totem[slot].Name:SetText(Abbrev(name))
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
	local Event = CreateFrame("Frame", nil, Holder)
	Event:RegisterEvent("PLAYER_TOTEM_UPDATE")
	Event:RegisterEvent("PLAYER_ENTERING_WORLD")
	Event:SetScript("OnEvent",function(self,event,unit)
		for i = 1, 4 do 
			UpdateSlot(bars, i)
		end
	end)
end

function PB:HealthPowerBar()
	local A = S:GetModule("Skins")
	healthbar = CreateFrame("Statusbar", nil, Holder)
	healthbar:SetSize(self.db.Width, self.db.Height)
	healthbar:SetPoint("CENTER", Holder)
	healthbar:SetStatusBarTexture(S["media"].normal)
	healthbar:SetMinMaxValues(0, UnitHealthMax("player"))
	healthbar:SetValue(UnitHealth("player"))
	healthbar:SetStatusBarColor(0.1, 0.8, 0.1, 0)
	if S.myclass ~= "WARLOCK" and S.myclass ~= "SHAMAN" and S.myclass ~= "DEATHKNIGHT" then
		A:CreateBD(healthbar, 0.6)
	end
	tinsert(mainframe, healthbar)
	local spar = healthbar:CreateTexture(nil, "OVERLAY")
	spar:SetTexture("Interface\\Addons\\SunUI\\Media\\textureArrowBelow.tga")
	spar:SetVertexColor(1, 0, 0, 1) 
	spar:SetSize(12, 12)
	spar:SetPoint("TOP", healthbar:GetStatusBarTexture(), "BOTTOMRIGHT", -1, -2)
	
	healthbar.healthtext = healthbar:CreateFontString(nil, "OVERLAY")
	healthbar.healthtext:FontTemplate()
	healthbar.healthtext:SetPoint("TOP", spar, "BOTTOM", 0, 3)
	healthbar.healthtext:SetTextColor(210/255, 100/255, 100/255)

	healthbar.power = CreateFrame("Statusbar", nil, healthbar)
	healthbar.power:SetSize(self.db.Width, self.db.Height)
	healthbar.power:SetStatusBarTexture(S["media"].normal)
	healthbar.power:SetAllPoints(healthbar)
	healthbar.power:SetStatusBarColor(0.1, 0.8, 0.1, 0)
	healthbar.power:SetMinMaxValues(0, UnitPowerMax("player"))
	local powerspar =  healthbar.power:CreateTexture(nil, "OVERLAY")
	powerspar:SetTexture("Interface\\Addons\\SunUI\\Media\\textureArrowAbove.tga")
	powerspar:SetVertexColor(.3,.45,.65) 
	powerspar:SetSize(12, 12)
	powerspar:SetPoint("BOTTOM", healthbar.power:GetStatusBarTexture(), "TOPRIGHT", -1, 2)
	
	healthbar.powertext = healthbar:CreateFontString(nil, "OVERLAY")
	healthbar.powertext:FontTemplate()
	healthbar.powertext:SetPoint("BOTTOM", powerspar, "TOP", 0, -3)
	tinsert(mainframe, healthbar.power)
	S:SmoothBar(healthbar)
	S:SmoothBar(healthbar.power)
	
	self:UpdateHealthBar()
end

function PB:UpdateHealthBar()
	if self.db.HealthPower then 
		healthbar:Show() 
		healthbar:SetScript("OnUpdate", function(self, elapsed)
			self.elapsed = (self.elapsed or 0) + elapsed
			if self.elapsed < .2 then
				self:SetMinMaxValues(0, UnitHealthMax("player"))
				self.power:SetMinMaxValues(0, UnitPowerMax("player"))
				local _, powerclass = UnitPowerType("player")
				self.powertext:SetTextColor(unpack(powercolor[powerclass]))
				local healthnum = UnitHealth("player")
				local powernum = UnitPower("player")
				self:SetValue(healthnum)
				self.power:SetValue(powernum)
				if not PB.db.DisableText then
					local maxnum = 0
					if PB.db.HealthPowerPer then
						maxnum = UnitHealthMax("player")
						self.healthtext:SetText(format("%d", healthnum/maxnum*100).."%")
					else
						self.healthtext:SetText(S:ShortValue(healthnum))
					end
					if PB.db.ManaPowerPer then
						maxnum = UnitPowerMax("player")
						self.powertext:SetText(format("%d", powernum/maxnum*100).."%")
					else
						self.powertext:SetText(S:ShortValue(powernum))
					end
				else
					self.healthtext:SetText("")
					self.powertext:SetText("")
				end
			return end
			self.elapsed = 0
		end)
	else
		healthbar:Hide()
		healthbar:SetScript("OnUpdate", nil)
	end
end
function PB:UpdateSize()
	for k, v in ipairs(mainframe) do 
		if v then 
			v:SetSize(self.db.Width, self.db.Height)
		end
	end
	for k, v in ipairs(threeframe) do 
		if v then 
			v:SetSize((self.db.Width-space*(3-1))/3, self.db.Height)
		end
	end
	for k, v in ipairs(fourframe) do 
		if v then 
			v:SetSize((self.db.Width-space*(4-1))/4, self.db.Height)
		end
	end
	for k, v in ipairs(fiveframe) do 
		if v then 
			v:SetSize((self.db.Width-space*(5-1))/5, self.db.Height)
		end
	end
	for k, v in ipairs(sixframe) do 
		if v then 
			v:SetSize((self.db.Width-space*(6-1))/6, self.db.Height)
		end
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
	if Holder:IsShown() then return end
	Holder:Show()
	UIFrameFadeIn(Holder, 0.3, Holder:GetAlpha(), 1)
end
function PB:On_Hide()
	if not Holder:IsShown() then return end
	S:FadeOutFrame(Holder, 0.3)
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
	local spec = GetSpecialization() or -1
	if S.myclass == "PRIEST" and spec ~= 3 then
		for i = 1,3 do
			ShadowOrbs[i]:Hide()
		end
		ShadowOrbs:UnregisterAllEvents()
	elseif S.myclass == "PRIEST" and spec == 3 then
		ShadowOrbs:RegisterEvent("UNIT_POWER")
		ShadowOrbs:RegisterEvent("UNIT_DISPLAYPOWER")
	end
	if S.myclass == "DRUID" and spec ~= 1 then
		eb:Hide()
		eb:UnregisterAllEvents()
	elseif S.myclass == "DRUID" and spec == 1 then
		eb:RegisterEvent("ECLIPSE_DIRECTION_CHANGE")
		eb:RegisterEvent("PLAYER_TALENT_UPDATE")
		eb:RegisterEvent("UNIT_POWER")
		eb:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
		eb:RegisterEvent("PLAYER_ENTERING_WORLD")
		eb:RegisterEvent("PLAYER_REGEN_DISABLED")
	end
	if S.myclass == "MAGE" and spec ~= 1 then
		for i = 1,4 do
			MageBars[i]:Hide()
		end
		MageBars:UnregisterEvent("UNIT_AURA")
	elseif S.myclass == "MAGE"  and spec == 1 then
		MageBars:RegisterEvent("UNIT_AURA")
	end
end

function PB:PLAYER_ENTERING_WORLD()
	self:ACTIVE_TALENT_GROUP_CHANGED()
end
function PB:Initialize()
	
	if not self.db.Open then Holder = nil return end
	Holder:SetSize(self.db.Width, self.db.Height)
	Holder:SetPoint("CENTER", "UIParent", "CENTER", 0, -120)
	S:CreateMover(Holder, "PowerBarMover", L["PowerBar"], true, nil, "ALL,MINITOOLS")
	self:CreateShadowOrbs()
	self:CreateMonkBar()
	self:CreateQSDKPower()
	self:CreateCombatPoint()
	self:CreateEclipse()
	self:FuckWarlock()
	self:Mage()
	self:Shaman()
	self:HealthPowerBar()
	self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:UpdateFade()
end

S:RegisterModule(PB:GetName())