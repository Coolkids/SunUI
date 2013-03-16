local S, L, DB, _, C = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("SunUIPowerBar", "AceTimer-3.0", "AceEvent-3.0")
local SunUIConfig = LibStub("AceAddon-3.0"):GetAddon("SunUI"):GetModule("SunUIConfig")
local powercolor = {}
local space = (DB.MyClass == "DEATHKNIGHT" or DB.MyClass == "SHAMAN") and 2 or 6
local Holder = CreateFrame("Statusbar", nil, UIParent)
local mainframe = {}
local threeframe = {}
local fourframe = {}
local fiveframe = {}
local sixframe = {}
local healthbar
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
local ShadowOrbs
local eb
local MageBars
function Module:CreateShadowOrbs()
	if DB.MyClass ~= "PRIEST" then return end
	ShadowOrbs = CreateFrame("Frame", nil, Holder)
	ShadowOrbs:SetSize(C["Width"], C["Height"])
	ShadowOrbs:SetScale(C["Scale"])
	ShadowOrbs:SetPoint("CENTER", Holder)
	tinsert(mainframe, ShadowOrbs)
	local maxShadowOrbs = UnitPowerMax('player', SPELL_POWER_SHADOW_ORBS)

	for i = 1,maxShadowOrbs do
		ShadowOrbs[i] = CreateFrame("StatusBar", nil, ShadowOrbs)
		tinsert(threeframe, ShadowOrbs[i])
		ShadowOrbs[i]:SetSize((C["Width"]-space*(maxShadowOrbs-1))/maxShadowOrbs, C["Height"])
		ShadowOrbs[i]:SetScale(C["Scale"])
		ShadowOrbs[i]:SetStatusBarTexture(SunUIConfig.db.profile.MiniDB.uitexturePath)
		local s = ShadowOrbs[i]:GetStatusBarTexture()
		S.CreateTop(s, .86,.22,1)
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
	ShadowOrbs:SetScript("OnEvent",function(self, event, unit, powerType)
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
function Module:CreateMonkBar()
	if DB.MyClass ~= "MONK" then return end
	local chibar = CreateFrame("Frame",nil,Holder)
	chibar:SetSize(C["Width"], C["Height"])
	chibar:SetScale(C["Scale"])
	chibar:SetPoint("CENTER", Holder)
	tinsert(mainframe, chibar)
	for i=1,5 do
		chibar[i] = CreateFrame("StatusBar",nil,chibar)
		chibar[i]:SetSize((C["Width"]-space*(5-1))/5, C["Height"])
		chibar[i]:SetScale(C["Scale"])
		tinsert(fiveframe, chibar[i])
		chibar[i]:SetStatusBarTexture(SunUIConfig.db.profile.MiniDB.uitexturePath)
		local s = chibar[i]:GetStatusBarTexture()
		S.CreateTop(s, 0.0, 1.00 , 0.59)
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
	chibar:SetScript("OnEvent",function(self, event, unit, powerType)
		if( unit ~= "player" or (powerType and powerType ~= 'CHI')) then return end
		local chinum = UnitPower("player",SPELL_POWER_CHI)
		local chimax = UnitPowerMax("player",SPELL_POWER_CHI)
		if chinum ~= chimax then
			if chimax == 4 then
				chibar[5]:Hide()
				for i = 1,4 do
					chibar[i]:SetWidth((C["Width"]-space*(4-1))/4)
				end
			elseif chimax == 5 then
				chibar[5]:Show()
				for i = 1,5 do
					chibar[i]:SetWidth((C["Width"]-space*(5-1))/5)
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
	local s = rune:GetStatusBarTexture()
	S.CreateTop(s, r, g, b)
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
					rune.duration = GetTime() - start
					rune.max = duration
					rune:SetMinMaxValues(1, duration)
					rune:SetScript("OnUpdate", OnUpdate)
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
function Module:CreateQSDKPower()
	if  DB.MyClass ~= "PALADIN" and DB.MyClass ~= "DEATHKNIGHT" then return end
    local count
	if DB.MyClass == "DEATHKNIGHT" then 
		count = 6
		RuneFrame.Show = RuneFrame.Hide
		RuneFrame:Hide()
	elseif DB.MyClass == "PALADIN" then
		count = 5
	end
	local bars = CreateFrame("Frame", nil, Holder)
	bars:SetSize(C["Width"], C["Height"])
	bars:SetScale(C["Scale"])
	bars:SetPoint("CENTER", Holder)
	tinsert(mainframe, bars)
	for i = 1, count do
		bars[i] =CreateFrame("StatusBar", nil, bars)
		bars[i]:SetStatusBarTexture(SunUIConfig.db.profile.MiniDB.uitexturePath)
		bars[i]:GetStatusBarTexture():SetHorizTile(false)
		bars[i]:SetSize((C["Width"]-space*(count-1))/count, C["Height"])
		if count == 6 then tinsert(sixframe, bars[i]) else tinsert(sixframe, fiveframe[i]) end
		bars[i]:SetScale(C["Scale"])
		if (i == 1) then
			bars[i]:SetPoint("LEFT", bars, "LEFT")
		else
			bars[i]:SetPoint("LEFT", bars[i-1], "RIGHT", space, 0)
		end
        if DB.MyClass == "PALADIN" then
			local s = bars[i]:GetStatusBarTexture()
			S.CreateTop(s, 0.9, 0.9, 0)
			bars[i]:Hide()
		end
		bars[i]:CreateShadow()
	end
	if DB.MyClass == "DEATHKNIGHT" then
		for i=1,6 do
			UpdateType(bars, i, math.floor((runemap[i]+1)/2))
		end
	end
	if DB.MyClass == "DEATHKNIGHT" then
		bars:RegisterEvent("RUNE_POWER_UPDATE")
		bars:RegisterEvent("RUNE_TYPE_UPDATE")
		bars:SetScript("OnEvent", OnEvent)
	elseif DB.MyClass == "PALADIN" then
		bars:RegisterEvent("UNIT_POWER")
		bars:RegisterEvent("UNIT_DISPLAYPOWER")
		bars:SetScript("OnEvent",function(self, event, unit)
			if( unit ~= "player" or (powerType and powerType ~= 'HOLY_POWER')) then return end
			local num = UnitPower('player', SPELL_POWER_HOLY_POWER)
			local maxnum = UnitPowerMax('player', SPELL_POWER_HOLY_POWER)
			if num ~= maxnum then
				if maxnum == 3 then
					bars[4]:Hide()
					bars[5]:Hide()
					for i = 1,3 do
						bars[i]:SetWidth((C["Width"]-space*(3-1))/3)
					end
				elseif maxnum == 5 then
					bars[4]:Show()
					bars[5]:Show()
					for i = 1,5 do
						bars[i]:SetWidth((C["Width"]-space*(5-1))/5)
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
function Module:CreateCombatPoint()
	if DB.MyClass ~= "ROGUE" and DB.MyClass ~= "DRUID" then return end
	local CombatPointBar = CreateFrame("Frame", nil, Holder)
	CombatPointBar:SetSize(C["Width"], C["Height"])
	CombatPointBar:SetPoint("CENTER", Holder)
	tinsert(mainframe, CombatPointBar)
	for i = 1, 5 do
		CombatPointBar[i] =CreateFrame("StatusBar", nil, CombatPointBar)
		CombatPointBar[i]:SetStatusBarTexture(SunUIConfig.db.profile.MiniDB.uitexturePath)
		CombatPointBar[i]:GetStatusBarTexture():SetHorizTile(false)
		CombatPointBar[i]:SetSize((C["Width"]-space*4)/5, C["Height"])
		CombatPointBar[i]:SetScale(C["Scale"])
		tinsert(fiveframe, CombatPointBar[i])
		if (i == 1) then
			CombatPointBar[i]:SetPoint("LEFT", CombatPointBar, "LEFT")
		else
			CombatPointBar[i]:SetPoint("LEFT", CombatPointBar[i-1], "RIGHT", space, 0)
		end
		local s = CombatPointBar[i]:GetStatusBarTexture()
		if i ~= 5 then 
			S.CreateTop(s, 0.9, 0.9, 0)
		else
			S.CreateTop(s, 1, 0.2, 0.2)
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
			if DB.MyClass == "DRUID" then 
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
function Module:CreateEclipse()
	if DB.MyClass ~= "DRUID" then return end
	local ECLIPSE_BAR_SOLAR_BUFF_ID = ECLIPSE_BAR_SOLAR_BUFF_ID
	local ECLIPSE_BAR_LUNAR_BUFF_ID = ECLIPSE_BAR_LUNAR_BUFF_ID
	local SPELL_POWER_ECLIPSE = SPELL_POWER_ECLIPSE
	local MOONKIN_FORM = MOONKIN_FORM
	local showBar = false
	eb = CreateFrame('Frame', nil, Holder)
	eb:SetSize(C["Width"], C["Height"])
	eb:SetPoint("CENTER", Holder)
	eb:CreateShadow()
	tinsert(mainframe, eb)
	local lb = CreateFrame('StatusBar', nil, eb)
	lb:SetPoint('LEFT', eb, 'LEFT')
	lb:SetSize(C["Width"], C["Height"])
	tinsert(mainframe, lb)
	S.SmoothBar(lb)
	lb:SetStatusBarTexture(SunUIConfig.db.profile.MiniDB.uitexturePath)
	local s = lb:GetStatusBarTexture()
	S.CreateTop(s, 0.27, 0.47, 0.74)
	S.CreateMark(lb)
	eb.LunarBar = lb
	local sb = CreateFrame('StatusBar', nil, eb)
	sb:SetPoint('LEFT', lb:GetStatusBarTexture(), 'RIGHT', 0, 0)
	sb:SetPoint('TOPRIGHT', eb, 'TOPRIGHT', 0, 0)
	sb:SetSize(C["Width"], C["Height"])
	sb:SetStatusBarTexture(SunUIConfig.db.profile.MiniDB.uitexturePath)
	local s = sb:GetStatusBarTexture()
	S.CreateTop(s, 0.9, 0.6, 0.3)
	eb.SolarBar = sb
	local h = CreateFrame("Frame", nil, eb)
	h:SetFrameLevel(eb:GetFrameLevel()+1)
	h:SetAllPoints(eb)
	local ebInd = S.MakeFontString(h, 10*S.Scale(1), "THINOUTLINE")
	ebInd:SetPoint('CENTER', h, 'CENTER', 0, 0)

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
				ebInd:SetText("|cff4478BC-->|r")
			elseif dir=="moon" then
				ebInd:SetText("|cffE5994C<--|r")
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
			end

			if(self.SolarBar) then
				self.SolarBar:SetPoint('LEFT', lb:GetStatusBarTexture(), 'RIGHT', 0, 0)
				self.SolarBar:SetPoint('TOPRIGHT', eb, 'TOPRIGHT', 0, 0)
			end
		end
	end)
end
function Module:FuckWarlock()
	if DB.MyClass ~= "WARLOCK" then return end
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
	bars:SetSize(C["Width"], C["Height"])
	bars:SetPoint("CENTER", Holder)
	tinsert(mainframe, bars)
	for i = 1, 4 do
		bars[i] = CreateFrame("StatusBar", nil, bars)
		bars[i]:SetSize((C["Width"]-space*(4-1))/4, C["Height"])
		bars[i]:SetStatusBarTexture(SunUIConfig.db.profile.MiniDB.uitexturePath)
		tinsert(fourframe, bars[i])
		S.CreateBack(bars[i])
		bars[i]:CreateShadow()
		if i == 1 then
			S.CreateMark(bars[i])
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
						local s = wsb[i]:GetStatusBarTexture()
						S.CreateTop(s, Colors[SPEC_WARLOCK_DESTRUCTION][1], Colors[SPEC_WARLOCK_DESTRUCTION][2], Colors[SPEC_WARLOCK_DESTRUCTION][3])
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
						local s = wsb[i]:GetStatusBarTexture()
						S.CreateTop(s, Colors[SPEC_WARLOCK_AFFLICTION][1], Colors[SPEC_WARLOCK_AFFLICTION][2], Colors[SPEC_WARLOCK_AFFLICTION][3])
					end

				elseif spec == SPEC_WARLOCK_DEMONOLOGY then
					wsb[2]:Hide()
					wsb[3]:Hide()
					wsb[4]:Hide()
					wsb[1]:SetWidth(wsb:GetWidth())
					local s = wsb[1]:GetStatusBarTexture()
					S.CreateTop(s, Colors[SPEC_WARLOCK_DEMONOLOGY][1], Colors[SPEC_WARLOCK_DEMONOLOGY][2], Colors[SPEC_WARLOCK_DEMONOLOGY][3])
				end
			else
				if wsb:IsShown() then
					wsb:Hide()
				end
			end
		end

		if (event == "UNIT_POWER" or event == "UNIT_DISPLAYPOWER") and UnitAffectingCombat("player") then
			if(unit ~= "player" or (powerType ~= "BURNING_EMBERS" and powerType ~= "SOUL_SHARDS" and powerType ~= "DEMONIC_FURY")) then return end
			local wsb = self
			local spec = GetSpecialization()

			if spec then
				if (spec == SPEC_WARLOCK_DESTRUCTION) then
					local maxPower = UnitPowerMax("player", SPELL_POWER_BURNING_EMBERS, true)
					local power = UnitPower("player", SPELL_POWER_BURNING_EMBERS, true)
					local numEmbers = power / MAX_POWER_PER_EMBER
					local numBars = floor(maxPower / MAX_POWER_PER_EMBER)

					for i = 1, numBars do
						wsb[i]:SetMinMaxValues((MAX_POWER_PER_EMBER * i) - MAX_POWER_PER_EMBER, MAX_POWER_PER_EMBER * i)
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
function Module:Mage()
	if DB.MyClass ~= "MAGE" then return end
	MageBars = CreateFrame("Frame", nil, Holder)
	MageBars:SetSize(C["Width"], C["Height"])
	MageBars:SetPoint("CENTER", Holder)
	tinsert(mainframe, MageBars)
	for i = 1,4 do
		MageBars[i] = CreateFrame("StatusBar", nil, MageBars)
		MageBars[i]:SetSize((C["Width"]-space*(4-1))/4, C["Height"])
		MageBars[i]:SetStatusBarTexture(SunUIConfig.db.profile.MiniDB.uitexturePath)
		tinsert(fourframe, MageBars[i])
		local s = MageBars[i]:GetStatusBarTexture()
		S.CreateTop(s, DB.MyClassColor.r, DB.MyClassColor.g, DB.MyClassColor.b)
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

function Module:Shaman()
	if DB.MyClass ~= "SHAMAN" then return end
	local bars = {}
	local total = 0
	local delay = 0.01

	-- In the order, fire, earth, water, air
	local colors = {
		[1] = {0.752,0.172,0.02},
		[2] = {0.741,0.580,0.04},
		[3] = {0,0.443,0.631},
		[4] = {0.6,1,0.945},
	}
	for i = 1, 4 do
		bars[i] = CreateFrame("StatusBar", nil, Holder)
		bars[i]:SetStatusBarTexture(SunUIConfig.db.profile.MiniDB.uitexturePath)
		bars[i]:SetSize((C["Width"]-space*(4-1))/4, C["Height"])
		bars[i]:GetStatusBarTexture():SetHorizTile(false)

		bars[i]:CreateShadow()
		S.CreateBack(bars[i])
		S.CreateMark(bars[i])
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

		--totem[slot]:SetStatusBarColor(unpack(colors[slot]))
		S.CreateTop(totem[slot]:GetStatusBarTexture(), unpack(colors[slot]))
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

function Module:HealthPowerBar()
	healthbar = CreateFrame("Statusbar", nil, Holder)
	healthbar:SetSize(C["Width"], C["Height"])
	healthbar:SetPoint("CENTER", Holder)
	healthbar:SetStatusBarTexture(SunUIConfig.db.profile.MiniDB.uitexturePath)
	healthbar:SetMinMaxValues(0, UnitHealthMax("player"))
	healthbar:SetValue(UnitHealth("player"))
	healthbar:SetStatusBarColor(0.1, 0.8, 0.1, 0)
	if DB.MyClass ~= "WARLOCK" and DB.MyClass ~= "SHAMAN" then
		S.CreateBack(healthbar)
		S.CreateBD(healthbar, 0)
	end
	tinsert(mainframe, healthbar)
	local spar =  healthbar:CreateTexture(nil, "OVERLAY")
	spar:SetTexture("Interface\\Addons\\SunUI\\Media\\Arrow")
	spar:SetVertexColor(1, 0, 0, 1) 
	spar:SetSize(16, 16)
	spar:SetPoint("TOP", healthbar:GetStatusBarTexture(), "BOTTOMRIGHT", 0, -2)
	
	healthbar.healthtext = S.MakeFontString(healthbar)
	healthbar.healthtext:SetPoint("TOP", spar, "BOTTOM", 0, 7)
	healthbar.healthtext:SetTextColor(1, 0.22, 0.52)

	healthbar.power = CreateFrame("Statusbar", nil, healthbar)
	healthbar.power:SetSize(C["Width"], C["Height"])
	healthbar.power:SetStatusBarTexture(SunUIConfig.db.profile.MiniDB.uitexturePath)
	healthbar.power:SetAllPoints(healthbar)
	healthbar.power:SetStatusBarColor(0.1, 0.8, 0.1, 0)
	healthbar.power:SetMinMaxValues(0, UnitPowerMax("player"))
	local powerspar =  healthbar.power:CreateTexture(nil, "OVERLAY")
	powerspar:SetTexture("Interface\\Addons\\SunUI\\Media\\ArrowT")
	powerspar:SetVertexColor(.3,.45,.65, 1) 
	powerspar:SetSize(16, 16)
	powerspar:SetPoint("BOTTOM", healthbar.power:GetStatusBarTexture(), "TOPRIGHT", 0, 2)
	
	healthbar.powertext = S.MakeFontString(healthbar)
	healthbar.powertext:SetPoint("BOTTOM", powerspar, "TOP", 0, -5)
	tinsert(mainframe, healthbar.power)
	S.SmoothBar(healthbar)
	S.SmoothBar(healthbar.power)
	
	healthbar:SetScript("OnEvent", function(self, event)
		if event == "UPDATE_SHAPESHIFT_FORM" or event == "PLAYER_ENTERING_WORLD" or event == "ACTIVE_TALENT_GROUP_CHANGED" then
			self:SetMinMaxValues(0, UnitHealthMax("player"))
			self.power:SetMinMaxValues(0, UnitPowerMax("player"))
			local _, powerclass = UnitPowerType("player")
			healthbar.powertext:SetTextColor(unpack(powercolor[powerclass]))
		end
		if event == "PLAYER_LEVEL_UP" or event == "UNIT_INVENTORY_CHANGED" then
				self:SetMinMaxValues(0, UnitHealthMax("player"))
				self.power:SetMinMaxValues(0, UnitPowerMax("player"))
		end
	end)
	
	self:UpdateHealthBar()
end

function Module:UpdateHealthBar()
	if C["HealthPower"] then 
		healthbar:Show() 
		healthbar:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
		healthbar:RegisterEvent("PLAYER_ENTERING_WORLD")
		healthbar:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
		healthbar:RegisterEvent("PLAYER_LEVEL_UP")
		healthbar:RegisterEvent("UNIT_INVENTORY_CHANGED")
		healthbar:SetScript("OnUpdate", function(self, elapsed)
			self.elapsed = (self.elapsed or 0) + elapsed
			if self.elapsed < .2 then
				local healthnum = UnitHealth("player")
				local powernum = UnitPower("player")
				self:SetValue(healthnum)
				self.power:SetValue(powernum)
				self.healthtext:SetText(S.ShortValue(healthnum))
				self.powertext:SetText(S.ShortValue(powernum))
			return end
			self.elapsed = 0
		end)
	else
		healthbar:Hide()
		healthbar:SetScript("OnUpdate", nil)
		healthbar:UnregisterAllEvents()
	end
end
function Module:UpdateSize()
	for k, v in ipairs(mainframe) do 
		if v then 
			v:SetSize(C["Width"], C["Height"])
		end
	end
	for k, v in ipairs(threeframe) do 
		if v then 
			v:SetSize((C["Width"]-space*(3-1))/3, C["Height"])
		end
	end
	for k, v in ipairs(fourframe) do 
		if v then 
			v:SetSize((C["Width"]-space*(4-1))/4, C["Height"])
		end
	end
	for k, v in ipairs(fiveframe) do 
		if v then 
			v:SetSize((C["Width"]-space*(5-1))/5, C["Height"])
		end
	end
	for k, v in ipairs(sixframe) do 
		if v then 
			v:SetSize((C["Width"]-space*(6-1))/6, C["Height"])
		end
	end
end
function Module:PLAYER_REGEN_DISABLED()
	Holder:Show()
	UIFrameFadeIn(Holder, 1, Holder:GetAlpha(), 1)
end
function Module:PLAYER_REGEN_ENABLED()
	S.FadeOutFrameDamage(Holder, 1)
end
function Module:UpdateFade()
	if C["Fade"] then
		Module:RegisterEvent("PLAYER_REGEN_ENABLED")
		Module:RegisterEvent("PLAYER_REGEN_DISABLED")
		Module:PLAYER_REGEN_ENABLED()
	else
		Module:UnregisterEvent("PLAYER_REGEN_ENABLED")
		Module:UnregisterEvent("PLAYER_REGEN_DISABLED")
		Module:PLAYER_REGEN_DISABLED()
	end
end
function Module:ACTIVE_TALENT_GROUP_CHANGED()
	local spec = GetSpecialization()
	local talent = (DB.MyClass == "PRIEST") and 3 or (DB.MyClass == "DRUID") and 1 or (DB.MyClass == "MAGE") and 1
	if DB.MyClass == "PRIEST" and spec ~= 3 then
		for i = 1,3 do
			ShadowOrbs[i]:Hide()
		end
		ShadowOrbs:UnregisterAllEvents()
	elseif DB.MyClass == "PRIEST" and spec == 3 then
		ShadowOrbs:RegisterEvent("UNIT_POWER")
		ShadowOrbs:RegisterEvent("UNIT_DISPLAYPOWER")
	end
	if DB.MyClass == "DRUID" and spec ~= 1 then
		eb:Hide()
		eb:UnregisterAllEvents()
	elseif DB.MyClass == "DRUID" and spec == 1 then
		eb:RegisterEvent("ECLIPSE_DIRECTION_CHANGE")
		eb:RegisterEvent("PLAYER_TALENT_UPDATE")
		eb:RegisterEvent("UNIT_POWER")
		eb:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
		eb:RegisterEvent("PLAYER_ENTERING_WORLD")
		eb:RegisterEvent("PLAYER_REGEN_DISABLED")
	end
	if DB.MyClass == "MAGE" and spec ~= 1 then
		for i = 1,6 do
			MageBars[i]:Hide()
		end
		MageBars:UnregisterEvent("UNIT_AURA")
	elseif DB.MyClass == "MAGE"  and spec == 1 then
		MageBars:RegisterEvent("UNIT_AURA")
	end
end
function Module:OnEnable()
	C = SunUIConfig.db.profile.PowerBarDB
	if not C["Open"] then Holder = nil return end
	Holder:SetSize(C["Width"], C["Height"])
	MoveHandle.PowerBar = S.MakeMove(Holder, "SunUIPowerBar", "PowerBar", C["Scale"])
	Module:CreateShadowOrbs()
	Module:CreateMonkBar()
	Module:CreateQSDKPower()
	Module:CreateCombatPoint()
	Module:CreateEclipse()
	Module:FuckWarlock()
	Module:Mage()
	Module:Shaman()
	Module:HealthPowerBar()
	Module:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
	if C["Fade"] then
		Module:RegisterEvent("PLAYER_ENTERING_WORLD", function()
			Module:UnregisterEvent("PLAYER_ENTERING_WORLD")
			Module:PLAYER_REGEN_ENABLED()
		end)
		Module:RegisterEvent("PLAYER_REGEN_ENABLED")
		Module:RegisterEvent("PLAYER_REGEN_DISABLED")
	end
end