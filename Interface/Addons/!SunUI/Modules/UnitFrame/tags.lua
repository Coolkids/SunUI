local addon, ns = ...
local oUF = ns.oUF or oUF 
-- shorten value
local SVal = function(val)
if val then
	if (val >= 1e6) then
        return ("%.1fm"):format(val / 1e6)
	elseif (val >= 1e3) then
		return ("%.1fk"):format(val / 1e3)
	else
		return ("%d"):format(val)
	end
end
end
-- calculating the ammount of latters
local function utf8sub(string, i, dots)
	if string then
	local bytes = string:len()
	if bytes <= i then
		return string
	else
		local len, pos = 0, 1
		while pos <= bytes do
			len = len + 1
			local c = string:byte(pos)
			if c > 0 and c <= 127 then
				pos = pos + 1
			elseif c >= 192 and c <= 223 then
				pos = pos + 2
			elseif c >= 224 and c <= 239 then
				pos = pos + 3
			elseif c >= 240 and c <= 247 then
				pos = pos + 4
			end
			if len == i then break end
		end
		if len == i and pos <= bytes then
			return string:sub(1, pos - 1)..(dots and '..' or '')
		else
			return string
		end
	end
	end
end
-- turn hex colors into RGB format
local function hex(r, g, b)
	if r then
		if (type(r) == 'table') then
			if(r.r) then r, g, b = r.r, r.g, r.b else r, g, b = unpack(r) end
		end
		return ('|cff%02x%02x%02x'):format(r * 255, g * 255, b * 255)
	end
end
-- adjusting set of default colors
pcolors = setmetatable({
	power = setmetatable({
		['MANA']            = { 95/255, 155/255, 255/255 }, 
		['RAGE']            = { 250/255,  75/255,  60/255 }, 
		['FOCUS']           = { 255/255, 209/255,  71/255 },
		['ENERGY']          = { 200/255, 255/255, 200/255 }, 
		['RUNIC_POWER']     = {   0/255, 209/255, 255/255 },
		["AMMOSLOT"]		= { 200/255, 255/255, 200/255 },
		["FUEL"]			= { 250/255,  75/255,  60/255 },
		["POWER_TYPE_STEAM"] = {0.55, 0.57, 0.61},
		["POWER_TYPE_PYRITE"] = {0.60, 0.09, 0.17},	
		["POWER_TYPE_HEAT"] = {0.55,0.57,0.61},
      	["POWER_TYPE_OOZE"] = {0.76,1,0},
      	["POWER_TYPE_BLOOD_POWER"] = {0.7,0,1},
	}, {__index = oUF.colors.power}),
}, {__index = oUF.colors})
-- name color tags
oUF.Tags['mono:color'] = function(u, r)
	local _, class = UnitClass(u)
	local reaction = UnitReaction(u, "player")
	
	if (UnitIsTapped(u) and not UnitIsTappedByPlayer(u)) then
		return hex(oUF.colors.tapped)
	elseif (UnitIsPlayer(u)) then
		return hex(oUF.colors.class[class])
	elseif reaction then
		return hex(oUF.colors.reaction[reaction])
	else
		return hex(1, 1, 1)
	end
end
oUF.TagEvents['mono:color'] = 'UNIT_REACTION UNIT_HEALTH UNIT_POWER'

oUF.Tags['mono:gridcolor'] = function(u, r)
	local _, class = UnitClass(u)
	if (UnitIsPlayer(u)) then
		return hex(oUF.colors.class[class])
	else
		return hex(1, 1, 1)
	end
end
oUF.TagEvents['mono:gridcolor'] = 'UNIT_HEALTH'

-- type and level information
oUF.Tags['mono:info'] = function(u) 
	local level = UnitLevel(u)
    local race = UnitRace(u) or nil
	local typ = UnitClassification(u)
	local color = GetQuestDifficultyColor(level)
	if level <= 0 then
		level = "??" 
		color.r, color.g, color.b = 1, 0, 0
	end
	if typ=="rareelite" then
		return hex(color)..level..'r+'
	elseif typ=="elite" then
		return hex(color)..level..'+'
	elseif typ=="rare" then
		return hex(color)..level..'r'
	else
		if u=="target" and UnitIsPlayer("target") then
			--if level == 80 then level = "" end
			return hex(color)..level.." |cffFFFFFF"..race.."|r"
		else
			return hex(color)..level
		end
    end
end
oUF.TagEvents['mono:info'] = 'UNIT_LEVEL PLAYER_LEVEL_UP UNIT_CLASSIFICATION_CHANGED'

-- health value tags
oUF.Tags['mono:hp']  = function(u) -- THIS IS FUCKING MADNESS!!! 
  if UnitIsDead(u) or UnitIsGhost(u) or not UnitIsConnected(u) then
    return oUF.Tags['mono:DDG'](u)
  else
	local per = oUF.Tags['perhp'](u).."%" or 0
	local def = oUF.Tags['missinghp'](u) or 0
    local min, max = UnitHealth(u), UnitHealthMax(u)
    if u == "player" then
      if min~=max then 
        --return SVal(min).." | |cffe15f8b"..-def.."|r"
		return SVal(min).." - |cffe15f8b"..per.."|r"
      else
        return SVal(min).." - "..per 
      end
    elseif u == "target" then
      if min~=max then 
        if UnitIsPlayer("target") then
          if UnitIsEnemy("player","target") then
            return per.." - "..min
          else
            if def then return per.." - "..SVal(min) end
          end
        else
          return  per.." - "..SVal(min)
        end
      else
        return  per.." - "..SVal(min)
      end
    elseif u == "focus" or u == "pet" or u == "focustarget" or u == "targettarget" then
      return per
    else
      if UnitIsPlayer(u) and not UnitIsEnemy("player",u) then
        if min~=max then 
          return SVal(min)..per
        else
          return SVal(min).." - ".. per
        end
      else    
        return SVal(min).." - ".."|cffe15f8b"..per.."|r"
      end
    end
  end
end
oUF.TagEvents['mono:hp'] = 'UNIT_HEALTH UNIT_CONNECTION'

oUF.Tags['mono:hpperc']  = function(u) 
	local per = oUF.Tags['perhp'](u)
	if UnitIsDead(u) or UnitIsGhost(u) or not UnitIsConnected(u) then
		return oUF.Tags['mono:DDG'](u)
	elseif min~=max and per < 90 then
		return per.."%"
	end
end
oUF.TagEvents['mono:hpperc'] = 'UNIT_HEALTH UNIT_CONNECTION'

oUF.Tags['mono:hpraid']  = function(u) 
	local min, max = UnitHealth(u), UnitHealthMax(u)
	local per = oUF.Tags['perhp'](u)
	local def = oUF.Tags['missinghp'](u)
	if UnitIsDead(u) or UnitIsGhost(u) or not UnitIsConnected(u) then
		return oUF.Tags['mono:DDG'](u)
	elseif min~=max and per < 90 then
		return "|cffe15f8b - "..SVal(def).."|r"
	end
end
oUF.TagEvents['mono:hpraid'] = 'UNIT_HEALTH UNIT_CONNECTION'

-- power value tags
oUF.Tags['mono:pp'] = function(u)
	local _, str = UnitPowerType(u)
	local per = oUF.Tags['perpp'](u).."%" or 0
	if str then
		if str == "MANA" then 
 		return hex(pcolors.power[str] or {250/255,  75/255,  60/255})..SVal(UnitPower(u)).." - "..per
		else
		return hex(pcolors.power[str] or {250/255,  75/255,  60/255})..SVal(UnitPower(u))
		end
	end
end
oUF.TagEvents['mono:pp'] = 'UNIT_POWER UNIT_MAXPOWER'

oUF.Tags['mono:druidpower'] = function(u)
	local min, max = UnitPower(u, 0), UnitPowerMax(u, 0)
	return u == 'player' and UnitPowerType(u) ~= 0 and min ~= max and ('|cff5F9BFF%d%%|r |'):format(min / max * 100)
end
oUF.TagEvents['mono:druidpower'] = 'UNIT_POWER UNIT_MAXPOWER UPDATE_SHAPESHIFT_FORM'

-- name tags
oUF.Tags['mono:name'] = function(u, r)
	local name = UnitName(r or u)
	return utf8sub(name, 12, true)
end
oUF.TagEvents['mono:name'] = 'UNIT_NAME_UPDATE UNIT_CONNECTION'

oUF.Tags['mono:longname'] = function(u, r)
	local name = UnitName(r or u)
	return utf8sub(name, 20, true)
end
oUF.TagEvents['mono:longname'] = 'UNIT_NAME_UPDATE UNIT_CONNECTION'

oUF.Tags['mono:shortname'] = function(u, r)
	local name = UnitName(r or u)
	return utf8sub(name, 3, false)
end
oUF.TagEvents['mono:shortname'] = 'UNIT_NAME_UPDATE UNIT_CONNECTION'

oUF.Tags['mono:gridname'] = function(u, r)
	local namelength = 4
	local name = UnitName(r or u)
	return utf8sub(name, namelength, false)
end
oUF.TagEvents['mono:gridname'] = 'UNIT_NAME_UPDATE UNIT_CONNECTION'

-- unit status tag
oUF.Tags['mono:DDG'] = function(u)
	if not UnitIsConnected(u) then
		return "|cffCFCFCF offline|r"
	elseif UnitIsGhost(u) then
		return "|cffCFCFCF ghost|r"
	elseif UnitIsDead(u) then
		return "|cffCFCFCF dead|r"
	end
end
oUF.TagEvents['mono:DDG'] = 'UNIT_NAME_UPDATE UNIT_HEALTH UNIT_CONNECTION'--'UNIT_MAXHEALTH'

-- current target indicator tag
oUF.Tags['mono:targeticon'] = function(u)
	if UnitIsUnit(u, 'target') then
		return "|cffE6A743 >|r"
	end
end
oUF.TagEvents['mono:targeticon'] = 'PLAYER_TARGET_CHANGED'

-- LFD role tag
oUF.Tags['mono:LFD'] = function(u)
	local role = UnitGroupRolesAssigned(u)
	if role == "HEALER" then
		return "|cff8AFF30H|r"
	elseif role == "TANK" then
		return "|cffFFF130T|r"
	elseif role == "DAMAGER" then
		return "|cffFF6161D|r"
	end
end
oUF.TagEvents['mono:LFD'] = 'PLAYER_ROLES_ASSIGNED PARTY_MEMBERS_CHANGED'

-- heal prediction value tag
oUF.Tags['mono:heal'] = function(u)
    local incheal = UnitGetIncomingHeals(u, 'player') or 0
    if incheal > 0 then
        return "|cff8AFF30+"..SVal(incheal).."|r"
    end
end
oUF.TagEvents['mono:heal'] = 'UNIT_HEAL_PREDICTION'

-- AltPower value tag
oUF.Tags['mono:altpower'] = function(unit)
	local cur = UnitPower(unit, ALTERNATE_POWER_INDEX)
	local max = UnitPowerMax(unit, ALTERNATE_POWER_INDEX)
	if(max > 0 and not UnitIsDeadOrGhost(unit)) then
		return ("%s%%"):format(math.floor(cur/max*100+.5))
	end
end
oUF.TagEvents['mono:altpower'] = 'UNIT_POWER'

-------------[[ class specific tags ]]-------------
-- special powers
--[[ oUF.Tags['mono:sp'] = function(u)
	local _, class = UnitClass(u)
	local SP, spcol = 0,{}
	if class == "PALADIN" then
		SP = UnitPower("player", SPELL_POWER_HOLY_POWER )
		spcol = {"8AFF30","FFF130","FF6161"}
	elseif class == "WARLOCK" then
		SP = UnitPower("player", SPELL_POWER_SOUL_SHARDS)
		spcol = {"FF6161","FFF130","8AFF30"}
	end
	if SP == 1 then
		return ">".."|cff"..spcol[1].."1|r".."<"
	elseif SP == 2 then
		return ">".."|cff"..spcol[2].."2|r".."<"
	elseif SP == 3 then
		return ">".."|cff"..spcol[3].."3|r".."<"
	end
end
oUF.TagEvents['mono:sp'] = 'UNIT_POWER'
-- combo points
oUF.Tags['mono:cp'] = function(u)
	local cp = UnitExists("vehicle") and GetComboPoints("vehicle", "target") or GetComboPoints("player", "target")
	cpcol = {"8AFF30","FFF130","FF6161"}
	if       cp == 1 then	return ">".."|cff"..cpcol[1].."1|r".."<"
	elseif cp == 2 then	return ">".."|cff"..cpcol[1].."2|r".."<"
	elseif cp == 3 then	return ">".."|cff"..cpcol[2].."3|r".."<"
	elseif cp == 4 then	return ">".."|cff"..cpcol[2].."4|r".."<"
	elseif cp == 5 then	return ">".."|cff"..cpcol[3].."5|r".."<"
	end
end
oUF.TagEvents['mono:cp'] = 'UNIT_COMBO_POINTS'
-- shadow orbs
oUF.Tags['mono:orbs'] = function(u)
	local name, _, _, count, _, duration = UnitBuff("player",GetSpellInfo(77487))
	if count == 1 then
		return ">".."|cffFF61611|r".."<"
	elseif count == 2 then
		return ">".."|cffFFF1302|r".."<"
	elseif count == 3 then
		return ">".."|cff8AFF303|r".."<"
	end
end
oUF.TagEvents['mono:orbs'] = 'UNIT_AURA'
-- water shield
oUF.Tags['mono:ws'] = function(u)
	local name, _, _, count, _, duration = UnitBuff("player",GetSpellInfo(52127)) 
	if count == 1 then
		return ">".."|cffFF61611|r".."<"
	elseif count == 2 then
		return ">".."|cff8AFF302|r".."<"
	elseif count == 3 then
		return ">".."|cff8AFF303|r".."<"
	end
end
oUF.TagEvents['mono:ws'] = 'UNIT_AURA'
-- lightning shield / maelstrom weapon
oUF.Tags['mono:ls'] = function(u)
	local lsn, _, _, lsc = UnitBuff("player",GetSpellInfo(324))
	local mw, _, _, mwc = UnitBuff("player",GetSpellInfo(53817))
	if mw and not UnitBuff("player",GetSpellInfo(52127)) then
		if mwc == 1 then
			return ">".."|cff8AFF301|r".."<"
		elseif mwc == 2 then
			return ">".."|cff8AFF302|r".."<"
		elseif mwc == 3 then
			return ">".."|cffFFF1303|r".."<"
		elseif mwc == 4 then
			return ">".."|cffFFF1304|r".."<"
		elseif mwc == 5 then
			return ">".."|cffFF61615|r".."<"
		end
	else
		if lsc == 1 then
			return ">".."|cff4343431|r".."<"
		elseif lsc == 2 then
			return ">".."|cff4343432|r".."<"
		elseif lsc == 7 then
			return ">".."|cff4343437|r".."<"
		elseif lsc == 8 then
			return ">".."|cff4343438|r".."<"
		elseif lsc == 9 then
			return ">".."|cffFF61619|r".."<"
		elseif lsc then
			return ">".."|cff4343433|r".."<"
		end
	end
end
oUF.TagEvents['mono:ls'] = 'UNIT_AURA'
-- earth shield
oUF.earthCount = {1,2,3,4,5,6,7,8,9}
oUF.Tags['raid:earth'] = function(u) 
	local c = select(4, UnitAura(u, GetSpellInfo(974))) 
	if c then return '|cffFFCF7F'..oUF.earthCount[c]..'|r' end end
oUF.TagEvents['raid:earth'] = 'UNIT_AURA'
-- Prayer of Mending
oUF.pomCount = {1,2,3,4,5,6}
oUF.Tags['raid:pom'] = function(u) local c = select(4, UnitAura(u, GetSpellInfo(33076))) if c then return "|cffFFCF7F"..oUF.pomCount[c].."|r" end end
oUF.TagEvents['raid:pom'] = "UNIT_AURA"
-- Lifebloom
oUF.lbCount = { 1, 2, 3 }
oUF.Tags['raid:lb'] = function(u) 
	local name, _,_, c,_,_, expirationTime, fromwho,_ = UnitAura(u, GetSpellInfo(33763))
	if not (fromwho == "player") then return end
	local spellTimer = GetTime()-expirationTime
	if spellTimer > -2 then
		return "|cffFF0000"..oUF.lbCount[c].."|r"
	elseif spellTimer > -4 then
		return "|cffFF9900"..oUF.lbCount[c].."|r"
	else
		return "|cffA7FD0A"..oUF.lbCount[c].."|r"
	end
end
oUF.TagEvents['raid:lb'] = "UNIT_AURA"
-- shrooooooooooooms (Wild Mushroom)
if select(2, UnitClass("player")) == "DRUID" then
	for i=1,3 do
		oUF.Tags['mono:wm'..i] = function(u)
			_,_,_,dur = GetTotemInfo(i)
			if dur > 0 then
				return "|cffFF6161❤ |r"
			end
		end
		oUF.TagEvents['mono:wm'..i] = 'PLAYER_TOTEM_UPDATE'
		oUF.UnitlessTagEvents.PLAYER_TOTEM_UPDATE = true
	end
end ]]