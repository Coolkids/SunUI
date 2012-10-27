local S, C, L, DB = unpack(select(2, ...))
local _
local Module = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("SunUIPowerBar", "AceTimer-3.0")
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
function Module:CreateShadowOrbs()
	if DB.MyClass ~= "PRIEST" then return end
	local ShadowOrbs = CreateFrame("Frame", nil, UIParent)
	ShadowOrbs:SetSize(C["Width"], C["Height"])
	ShadowOrbs:SetScale(C["Scale"])
	MoveHandle.PowerBar = S.MakeMove(ShadowOrbs, "SunUIPowerBar", "PowerBar", C["Scale"])
	local maxShadowOrbs = UnitPowerMax('player', SPELL_POWER_SHADOW_ORBS)
	
	for i = 1,maxShadowOrbs do
		ShadowOrbs[i] = CreateFrame("StatusBar", nil, ShadowOrbs)
		ShadowOrbs[i]:SetSize((C["Width"]-2*(maxShadowOrbs-1))/maxShadowOrbs, C["Height"])
		ShadowOrbs[i]:SetScale(C["Scale"])
		ShadowOrbs[i]:SetStatusBarTexture(DB.Statusbar)
		ShadowOrbs[i]:SetStatusBarColor(.86,.22,1)
		ShadowOrbs[i]:CreateShadow()
		ShadowOrbs[i]:Hide()
		if (i == 1) then
			ShadowOrbs[i]:SetPoint("LEFT", ShadowOrbs, "LEFT")
		else
			ShadowOrbs[i]:SetPoint("LEFT", ShadowOrbs[i-1], "RIGHT", 2, 0)
		end
	end
	ShadowOrbs:RegisterEvent("PLAYER_ENTERING_WORLD")
	ShadowOrbs:RegisterEvent("UNIT_POWER")
	ShadowOrbs:RegisterEvent("UNIT_DISPLAYPOWER")
	ShadowOrbs:RegisterEvent("PLAYER_REGEN_ENABLED")
	ShadowOrbs:RegisterEvent("PLAYER_REGEN_DISABLED")
	ShadowOrbs:SetScript("OnEvent",function(self, event, unit)
		local numShadowOrbs = UnitPower('player', SPELL_POWER_SHADOW_ORBS)
		if unit == "player" then
			for i = 1,maxShadowOrbs do
				if i <= numShadowOrbs then
					ShadowOrbs[i]:Show()
				else
					ShadowOrbs[i]:Hide()
				end
			end
			-- if numShadowOrbs == numShadowOrbs then
				-- UIFrameFlash(ShadowOrbs, 0.5, 0.5, 1.5, false, 0.5, 0.5)
			-- else
				-- UIFrameFlashStop(ShadowOrbs)
			-- end
		end
		if C["Fade"] then 
			if event == "PLAYER_REGEN_DISABLED" then
				UIFrameFadeIn(ShadowOrbs, 1, ShadowOrbs:GetAlpha(), 1)	
			end
			if event == "PLAYER_REGEN_ENABLED" or event == "PLAYER_ENTERING_WORLD" then
				UIFrameFadeOut(ShadowOrbs, 1, ShadowOrbs:GetAlpha(), 0)
			end
		end
	end)
end
--Monk harmony bar
function Module:CreateMonkBar()
	if DB.MyClass ~= "MONK" then return end
	local chibar = CreateFrame("Frame",nil,UIParent)
	chibar:SetSize(C["Width"], C["Height"])
	chibar:SetScale(C["Scale"])
	MoveHandle.PowerBar = S.MakeMove(chibar, "SunUIPowerBar", "PowerBar", C["Scale"])
	for i=1,5 do
		chibar[i] = CreateFrame("StatusBar",nil,chibar)
		chibar[i]:SetSize((C["Width"]-8)/5, C["Height"])
		chibar[i]:SetScale(C["Scale"])
		chibar[i]:SetStatusBarTexture(DB.Statusbar)
		chibar[i]:SetStatusBarColor(0.0, 1.00 , 0.59)
		chibar[i]:CreateShadow()
		if i==1 then
			chibar[i]:SetPoint("LEFT", chibar, "LEFT")
		else
			chibar[i]:SetPoint("LEFT", chibar[i-1], "RIGHT", 2, 0)
		end
		chibar[i]:Hide()
	end
	chibar:RegisterEvent("PLAYER_ENTERING_WORLD")
	chibar:RegisterEvent("UNIT_POWER")
	chibar:RegisterEvent("UNIT_DISPLAYPOWER")
	chibar:RegisterEvent("PLAYER_REGEN_DISABLED")
	chibar:RegisterEvent("PLAYER_REGEN_ENABLED")
	chibar:SetScript("OnEvent",function(self, event, unit)
		local chinum = UnitPower("player",SPELL_POWER_LIGHT_FORCE)
		local chimax = UnitPowerMax("player",SPELL_POWER_LIGHT_FORCE)
		if unit == "player" then
			if chinum ~= chimax then
				if chimax == 4 then
					chibar[5]:Hide()
					for i = 1,4 do
						chibar[i]:SetWidth((C["Width"]-6)/4)
					end
				elseif chimax == 5 then
					chibar[5]:Show()
					for i = 1,5 do
						chibar[i]:SetWidth((C["Width"]-8)/5)
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
		if C["Fade"] then 
			if event == "PLAYER_REGEN_DISABLED" then
				UIFrameFadeIn(chibar, 1, chibar:GetAlpha(), 1)
			end
			if event == "PLAYER_REGEN_ENABLED" or event == "PLAYER_ENTERING_WORLD" then
				UIFrameFadeOut(chibar, 1, chibar:GetAlpha(), 0)
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
	if C["Fade"] then 
		if event == "PLAYER_REGEN_DISABLED" then
			UIFrameFadeIn(self, 1, self:GetAlpha(), 1)
		end
		if event == "PLAYER_REGEN_ENABLED" or event == "PLAYER_ENTERING_WORLD" then
			UIFrameFadeOut(self, 1, self:GetAlpha(), 0)
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
		count = UnitPowerMax('player', SPELL_POWER_HOLY_POWER)
	end
	local bars = CreateFrame("Frame", nil, UIParent)
	bars:SetSize(C["Width"], C["Height"])
	bars:SetScale(C["Scale"])
	MoveHandle.PowerBar = S.MakeMove(bars, "SunUIPowerBar", "PowerBar", C["Scale"])
	for i = 1, count do
		bars[i] =CreateFrame("StatusBar", nil, bars)
		bars[i]:SetStatusBarTexture(DB.Statusbar)
		bars[i]:GetStatusBarTexture():SetHorizTile(false)
		bars[i]:SetSize((C["Width"]-2*(count-1))/count, C["Height"])
		bars[i]:SetScale(C["Scale"])
		if (i == 1) then
			bars[i]:SetPoint("LEFT", bars, "LEFT")
		else
			bars[i]:SetPoint("LEFT", bars[i-1], "RIGHT", 2, 0)
		end
        if DB.MyClass == "PALADIN" then
            bars[i]:SetStatusBarColor(0.9, 0.9, 0)
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
		bars:RegisterEvent("PLAYER_ENTERING_WORLD")
		bars:RegisterEvent("PLAYER_REGEN_ENABLED")
		bars:RegisterEvent("PLAYER_REGEN_DISABLED")
		bars:SetScript("OnEvent", OnEvent)
	elseif DB.MyClass == "PALADIN" then
		bars:RegisterEvent("PLAYER_ENTERING_WORLD")
		bars:RegisterEvent("UNIT_POWER")
		bars:RegisterEvent("UNIT_DISPLAYPOWER")
		bars:RegisterEvent("PLAYER_REGEN_ENABLED")
		bars:RegisterEvent("PLAYER_REGEN_DISABLED")
		bars:SetScript("OnEvent",function(self, event, unit)
			if unit == "player" then
				local num = UnitPower('player', SPELL_POWER_HOLY_POWER)
				for i = 1,count do
					if i <= num then
						bars[i]:Show()
					else
						bars[i]:Hide()
					end
				end
			end
			if C["Fade"] then 
				if event == "PLAYER_REGEN_DISABLED" then
					UIFrameFadeIn(bars, 1, bars:GetAlpha(), 1)
				end
				if event == "PLAYER_REGEN_ENABLED" then
					UIFrameFadeOut(bars, 1, bars:GetAlpha(), 0)
				end
			end
		end)
	end
end
function Module:CreateCombatPoint()
	if DB.MyClass ~= "ROGUE" and DB.MyClass ~= "DRUID" then return end
	local CombatPointBar = CreateFrame("Frame", nil, UIParent)
	CombatPointBar:SetSize(C["Width"], C["Height"])
	CombatPointBar:SetScale(C["Scale"])
	MoveHandle.PowerBar = S.MakeMove(CombatPointBar, "SunUIPowerBar", "PowerBar", C["Scale"])
	for i = 1, 5 do
		CombatPointBar[i] =CreateFrame("StatusBar", nil, CombatPointBar)
		CombatPointBar[i]:SetStatusBarTexture(DB.Statusbar)
		CombatPointBar[i]:GetStatusBarTexture():SetHorizTile(false)
		CombatPointBar[i]:SetSize((C["Width"]-2*4)/5, C["Height"])
		CombatPointBar[i]:SetScale(C["Scale"])
		if (i == 1) then
			CombatPointBar[i]:SetPoint("LEFT", CombatPointBar, "LEFT")
		else
			CombatPointBar[i]:SetPoint("LEFT", CombatPointBar[i-1], "RIGHT", 2, 0)
		end
		if i ~= 5 then 
			CombatPointBar[i]:SetStatusBarColor(0.9, 0.9, 0)
		else
			CombatPointBar[i]:SetStatusBarColor(1, 0.2, 0.2)
		end
		CombatPointBar[i]:CreateShadow()
		CombatPointBar[i]:Hide()
	end
	CombatPointBar:RegisterEvent("PLAYER_ENTERING_WORLD")
	CombatPointBar:RegisterEvent("UNIT_COMBO_POINTS")
	CombatPointBar:RegisterEvent("PLAYER_TARGET_CHANGED")
	CombatPointBar:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
	CombatPointBar:RegisterEvent("PLAYER_TALENT_UPDATE")
	CombatPointBar:RegisterEvent("PLAYER_REGEN_DISABLED")
	CombatPointBar:SetScript("OnEvent", function(self, event)
		if event == "PLAYER_TALENT_UPDATE" or event == "UPDATE_SHAPESHIFT_FORM" or event == "PLAYER_ENTERING_WORLD" or event == "UNIT_COMBO_POINTS" then
			if DB.MyClass == "DRUID" then 
				local form = GetShapeshiftFormID()
				if(not form) then
					local ptt = GetSpecialization()
					if(ptt and ptt == 1) then -- player has balance spec
						self:Hide()
					end
				elseif(form ~= CAT_FORM) then
					self:Hide()
				else
					self:Show()
				end
			end
		end
		if event == "UNIT_COMBO_POINTS" or event == "PLAYER_TARGET_CHANGED" or event == "PLAYER_ENTERING_WORLD" then
			cp = GetComboPoints('player', 'target')
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
	local eb = CreateFrame('Frame', nil, UIParent)
	eb:SetSize(C["Width"], C["Height"])
	MoveHandle.PowerBar = S.MakeMove(eb, "SunUIPowerBar", "PowerBar", C["Scale"])
	eb:CreateShadow()
	local lb = CreateFrame('StatusBar', nil, eb)
	lb:SetPoint('LEFT', eb, 'LEFT')
	lb:SetSize(C["Width"], C["Height"])
	lb:SetStatusBarTexture(DB.Statusbar)
	lb:SetStatusBarColor(0.27, 0.47, 0.74)
	eb.LunarBar = lb
	local sb = CreateFrame('StatusBar', nil, eb)
	sb:SetPoint('LEFT', lb:GetStatusBarTexture(), 'RIGHT', 0, 0)
	sb:SetSize(C["Width"], C["Height"])
	sb:SetStatusBarTexture(DB.Statusbar)
	sb:SetStatusBarColor(0.9, 0.6, 0.3)
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
	eb:RegisterEvent("PLAYER_REGEN_ENABLED")
	eb:SetScript("OnEvent", function(self, event, unit, powerType)
		if event == "ECLIPSE_DIRECTION_CHANGE" or event == "PLAYER_ENTERING_WORLD" then
			local dir = GetEclipseDirection()
			if dir=="sun" then
				ebInd:SetText("|cff4478BC>>>|r")
			elseif dir=="moon" then
				ebInd:SetText("|cffE5994C<<<|r")
			end
		end
		if event == "PLAYER_TALENT_UPDATE" or event == "UPDATE_SHAPESHIFT_FORM" or event == "PLAYER_REGEN_DISABLED" then
			local form = GetShapeshiftFormID()
			if(not form) then
				local ptt = GetSpecialization()
				if(ptt and ptt == 1) then -- player has balance spec
					showBar = true
				end
			elseif(form == MOONKIN_FORM) then
				showBar = true
			end

			if(showBar) then
				eb:Show()
				if eb:GetAlpha() < 1 then
					UIFrameFadeIn(eb, 1, eb:GetAlpha(), 1)
				end
			else
				eb:Hide()
			end
		end
		if event == "UNIT_POWER" then
			if(unit ~= "player" or (event == 'UNIT_POWER' and powerType ~= 'ECLIPSE')) then return end
	
			local power = UnitPower('player', SPELL_POWER_ECLIPSE)
			local maxPower = UnitPowerMax('player', SPELL_POWER_ECLIPSE)

			if(self.LunarBar) then
				self.LunarBar:SetMinMaxValues(-maxPower, maxPower)
				self.LunarBar:SetValue(power)
			end

			if(self.SolarBar) then
				self.SolarBar:SetMinMaxValues(-maxPower, maxPower)
				self.SolarBar:SetValue(power * -1)
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
				self.SolarBar:SetMinMaxValues(-maxPower, maxPower)
				self.SolarBar:SetValue(power * -1)
			end
		end
		if C["Fade"] then 
			if event == "PLAYER_REGEN_ENABLED" or event == "PLAYER_ENTERING_WORLD" or event == "UPDATE_SHAPESHIFT_FORM" then
				UIFrameFadeOut(eb, 2, eb:GetAlpha(), 0)
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
	local bars = CreateFrame('Frame', nil, UIParent)
	bars:SetSize(C["Width"], C["Height"])
	MoveHandle.PowerBar = S.MakeMove(bars, "SunUIPowerBar", "PowerBar", C["Scale"])
	for i = 1, 4 do
		bars[i] = CreateFrame("StatusBar", nil, bars)
		bars[i]:SetSize((C["Width"]-2*(4-1))/4, C["Height"])
		bars[i]:SetStatusBarTexture(DB.Statusbar)
		local gradient = bars[i]:CreateTexture(nil, "BACKGROUND")
		gradient:SetPoint("TOPLEFT")
		gradient:SetPoint("BOTTOMRIGHT")
		gradient:SetTexture(DB.Statusbar)
		gradient:SetGradientAlpha("VERTICAL", .3, .3, .3, .6, .1, .1, .1, .6)
		bars[i]:CreateShadow()
		if i == 1 then
			bars[i]:SetPoint("LEFT", bars)
		else
			bars[i]:SetPoint("LEFT", bars[i-1], "RIGHT", 2, 0)
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
					local maxembers = 3

					for i = 1, GetNumGlyphSockets() do
						local glyphID = select(4, GetGlyphSocketInfo(i))
						if glyphID == SPEC_WARLOCK_DESTRUCTION_GLYPH_EMBERS then maxembers = 4 end
					end

					for i = 1, maxembers do
						if i ~= maxembers then
							wsb[i]:SetWidth(w / maxembers - spacing)
							s = s + (w / maxembers)
						else
							wsb[i]:SetWidth(w - s)
						end
						wsb[i]:SetStatusBarColor(unpack(Colors[SPEC_WARLOCK_DESTRUCTION]))
					end

					if maxembers == 3 then wsb[4]:Hide() else wsb[4]:Show() end
				elseif spec == SPEC_WARLOCK_AFFLICTION then
					local maxshards = 3

					for i = 1, GetNumGlyphSockets() do
						local glyphID = select(4, GetGlyphSocketInfo(i))
						if glyphID == SPEC_WARLOCK_AFFLICTION_GLYPH_SHARDS then maxshards = 4 end
					end

					for i = 1, maxshards do
						if i ~= maxshards then
							wsb[i]:SetWidth(w / maxshards - spacing)
							s = s + (w / maxshards)
						else
							wsb[i]:SetWidth(w - s)
						end
						wsb[i]:SetStatusBarColor(unpack(Colors[SPEC_WARLOCK_AFFLICTION]))
					end

					if maxshards == 3 then wsb[4]:Hide() else wsb[4]:Show() end
				elseif spec == SPEC_WARLOCK_DEMONOLOGY then
					wsb[2]:Hide()
					wsb[3]:Hide()
					wsb[4]:Hide()
					wsb[1]:SetWidth(wsb:GetWidth())
					wsb[1]:SetStatusBarColor(unpack(Colors[SPEC_WARLOCK_DEMONOLOGY]))
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
		if C["Fade"] then 
			if event == "PLAYER_REGEN_DISABLED" then
				UIFrameFadeIn(self, 1, self:GetAlpha(), 1)
			end
			if event == "PLAYER_REGEN_ENABLED" or event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_TALENT_UPDATE" then
				UIFrameFadeOut(self, 1, self:GetAlpha(), 0)
			end
		end
	end)
end
function Module:Mage()
	if DB.MyClass ~= "MAGE" then return end
	
	local bars = CreateFrame("Frame", nil, UIParent)
	bars:SetSize(C["Width"], C["Height"])
	MoveHandle.PowerBar = S.MakeMove(bars, "SunUIPowerBar", "PowerBar", C["Scale"])
	
	for i = 1,6 do
		bars[i] = CreateFrame("StatusBar", nil, f)
		bars[i]:SetSize((C["Width"]-2*(6-1))/6, C["Height"])
		bars[i]:SetStatusBarTexture(DB.Statusbar)
		bars[i]:SetStatusBarColor(DB.MyClassColor.r, DB.MyClassColor.g, DB.MyClassColor.b)
		bars[i]:CreateShadow()
		bars[i]:Hide()
		if (i == 1) then
			bars[i]:SetPoint("LEFT", bars)
		else
			bars[i]:SetPoint("LEFT", bars[i-1], "RIGHT", 2, 0)
		end
	end
	bars:RegisterEvent("PLAYER_ENTERING_WORLD")
	bars:RegisterEvent("UNIT_AURA")
	
	bars:SetScript("OnEvent",function(self,event,unit)
		local num = select(4, UnitDebuff("player", GetSpellInfo(36032)))
		if num == nil then num = 0 end
		if unit ~= "player" then return end
		for i = 1,6 do
			if i <= num then
				self[i]:Show()
			else
				self[i]:Hide()
			end
		end
	end)
end
local function Smooth(self, value)
	if value == self:GetValue() then
        self.smoothing = nil
    else
        self.smoothing = value
    end
end
local function UpdateHealthSmooth(self)
	if self.smoothing == nil then return end
	local val = self.smoothing
	local limit = 30/GetFramerate()
    local cur = self:GetValue()
    local new = cur + min((val-cur)/3, max(val-cur, limit))

    if new ~= new then
        new = val
    end

    self:SetValue_(new)
    if cur == val or abs(new - val) < 2 then
        self:SetValue_(val)
        self.smoothing = nil
    end
end

function Module:HealthPowerBar()
	local bars = CreateFrame("Statusbar", nil, UIParent)
	bars:SetSize(C["Width"], 5)
	MoveHandle.HealthBar	= S.MakeMove(bars, "SunUIHealthBar", "HealthBar", 1)
	bars:SetStatusBarTexture(DB.Statusbar)
	bars:SetMinMaxValues(0, UnitHealthMax("player"))
	bars:SetValue(UnitHealth("player"))
	bars:CreateShadow()
	bars:SetStatusBarColor(0.1, 0.8, 0.1, 0)
	local gradient = bars:CreateTexture(nil, "BACKGROUND")
	gradient:SetPoint("TOPLEFT")
	gradient:SetPoint("BOTTOMRIGHT")
	gradient:SetTexture(DB.Statusbar)
	gradient:SetGradientAlpha("VERTICAL", .3, .3, .3, .6, .1, .1, .1, .6)
	
	local spar =  bars:CreateTexture(nil, "OVERLAY")
	spar:SetTexture("Interface\\Addons\\SunUI\\Media\\Arrow")
	--spar:SetBlendMode("ADD")
	spar:SetVertexColor(1, 0, 0, 1) 
	spar:SetSize(16, 16)
	spar:SetPoint("CENTER", bars:GetStatusBarTexture(), "RIGHT", 0, -14)
	local healthtext = S.MakeFontString(bars, select(2, GameFontNormalSmall:GetFont()))
	healthtext:SetPoint("TOP", spar, "BOTTOM", 0, 5)
	healthtext:SetTextColor(1, 0.22, 0.52)
	
	bars.SetValue_ = bars.SetValue
	bars.SetValue = Smooth
	
	local power = CreateFrame("Statusbar", nil, bars)
	power:SetSize(C["Width"], 5)
	power:SetStatusBarTexture(DB.Statusbar)
	power:SetAllPoints(bars)
	power:SetStatusBarColor(0.1, 0.8, 0.1, 0)
	power:SetMinMaxValues(0, UnitPowerMax("player"))
	local powerspar =  power:CreateTexture(nil, "OVERLAY")
	powerspar:SetTexture("Interface\\Addons\\SunUI\\Media\\ArrowT")
	--powerspar:SetBlendMode("ADD")
	powerspar:SetVertexColor(.3,.45,.65, 1) 
	powerspar:SetSize(16, 16)
	powerspar:SetPoint("CENTER", power:GetStatusBarTexture(), "RIGHT", 0, 14)
	local powertext = S.MakeFontString(bars, select(2, GameFontNormalSmall:GetFont()))
	powertext:SetPoint("BOTTOM", powerspar, "TOP", 0, -5)
	
	power.SetValue_ = power.SetValue
	power.SetValue = Smooth
	
	bars:SetScript("OnUpdate", function(self, elapsed)
		self.elapsed = (self.elapsed or 0) + elapsed
		if self.elapsed < .2 then
			local healthnum = UnitHealth("player")
			local powernum = UnitPower("player")
			self:SetValue(healthnum)
			power:SetValue(powernum)
			healthtext:SetText(S.ShortValue(healthnum))
			powertext:SetText(S.ShortValue(powernum))
			UpdateHealthSmooth(bars)
			UpdateHealthSmooth(power)
		return end
		self.elapsed = 0
	end)
	bars:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
	bars:RegisterEvent("PLAYER_ENTERING_WORLD")
	bars:RegisterEvent("PLAYER_REGEN_ENABLED")
	bars:RegisterEvent("PLAYER_REGEN_DISABLED")
	bars:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
	bars:SetScript("OnEvent", function(self, event)
		if C["Fade"] then 
			if event == "PLAYER_REGEN_DISABLED" then
				self:Show()
				UIFrameFadeIn(self, 1, self:GetAlpha(), 1)	
			end
			if event == "PLAYER_REGEN_ENABLED" or event == "PLAYER_ENTERING_WORLD" then
				S.FadeOutFrameDamage(self, 1)
			end
			if event == "UPDATE_SHAPESHIFT_FORM" or event == "PLAYER_ENTERING_WORLD" or event == "ACTIVE_TALENT_GROUP_CHANGED" then
				power:SetMinMaxValues(0, UnitPowerMax("player"))
				local _, powerclass = UnitPowerType("player")
				powertext:SetTextColor(unpack(powercolor[powerclass]))
			end
		end
	end)
end
function Module:OnEnable()
	C = C["PowerBarDB"]
	if not C["Open"] then return end
	Module:CreateShadowOrbs()
	Module:CreateMonkBar()
	Module:CreateQSDKPower()
	Module:CreateCombatPoint()
	Module:CreateEclipse()
	Module:FuckWarlock()
	Module:Mage()
	Module:HealthPowerBar()
end