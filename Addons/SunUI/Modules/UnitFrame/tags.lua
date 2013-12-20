local addon, ns = ...
local oUF = ns.oUF or oUF 
if IsAddOnLoaded("Stuf") or IsAddOnLoaded("PitBull4") or IsAddOnLoaded("ShadowedUnitFrames") then
	return
end
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
oUF.Tags.Methods['sunui:color'] = function(u, r)
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
oUF.Tags.Events['sunui:color'] = 'UNIT_REACTION UNIT_HEALTH UNIT_POWER'

-- type and level information
oUF.Tags.Methods['sunui:info'] = function(u) 
	local level = UnitLevel(u)
    local race = UnitRace(u) or ""
	local typ = UnitClassification(u)
	local color = GetQuestDifficultyColor(level)
	if level <= 0 then
		level = "??" 
		color.r, color.g, color.b = 1, 0.1, 0.1
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
oUF.Tags.Events['sunui:info'] = 'UNIT_LEVEL PLAYER_LEVEL_UP UNIT_CLASSIFICATION_CHANGED'

-- health value tags
oUF.Tags.Methods['sunui:hp']  = function(u) -- THIS IS FUCKING MADNESS!!! 
	if UnitIsDead(u) or UnitIsGhost(u) or not UnitIsConnected(u) then
		return oUF.Tags.Methods['sunui:DDG'](u)
	else
		local per = oUF.Tags.Methods['perhp'](u)
		if per < 25 then
			return "|cffe15f8b"..SVal(oUF.Tags.Methods['curhp'](u)).."|r".."-"..oUF.Tags.Methods['perhp'](u).."%"
		else
			return SVal(oUF.Tags.Methods['curhp'](u)).."-"..oUF.Tags.Methods['perhp'](u).."%"
		end
	end
end
oUF.Tags.Events['sunui:hp'] = 'UNIT_HEALTH UNIT_CONNECTION'

-- power value tags
oUF.Tags.Methods['sunui:pp'] = function(u)
	local _, str = UnitPowerType(u)
	local per = oUF.Tags.Methods['perpp'](u).."%" or 0
	if str then
		if str == "MANA" then 
			return hex(pcolors.power[str] or {250/255,  75/255,  60/255})..per
		else
			return hex(pcolors.power[str] or {250/255,  75/255,  60/255})..SVal(oUF.Tags.Methods['curpp'](u))
		end
	end
end
oUF.Tags.Events['sunui:pp'] = 'UNIT_POWER UNIT_MAXPOWER'

oUF.Tags.Methods['sunui:druidpower'] = function(u)
	local min, max = UnitPower(u, 0), UnitPowerMax(u, 0)
	return u == 'player' and UnitPowerType(u) ~= 0 and min ~= max and ('|cff5F9BFF%d%%|r |'):format(min / max * 100)
end
oUF.Tags.Events['sunui:druidpower'] = 'UNIT_POWER UNIT_MAXPOWER UPDATE_SHAPESHIFT_FORM'

-- name tags
oUF.Tags.Methods['sunui:name'] = function(u, r)
	local name = UnitName(r or u)
	return utf8sub(name, 12, true)
end
oUF.Tags.Events['sunui:name'] = 'UNIT_NAME_UPDATE UNIT_CONNECTION'

oUF.Tags.Methods['sunui:longname'] = function(u, r)
	local name = UnitName(r or u)
	return utf8sub(name, 18, true)
end
oUF.Tags.Events['sunui:longname'] = 'UNIT_NAME_UPDATE UNIT_CONNECTION'

oUF.Tags.Methods['sunui:shortname'] = function(u, r)
	local name = UnitName(r or u)
	return utf8sub(name, 3, false)
end
oUF.Tags.Events['sunui:shortname'] = 'UNIT_NAME_UPDATE UNIT_CONNECTION'

-- unit status tag
oUF.Tags.Methods['sunui:DDG'] = function(u)
	if not UnitIsConnected(u) then
		return "|cffCFCFCF 离线|r"
	elseif UnitIsGhost(u) then
		return "|cffCFCFCF 灵魂|r"
	elseif UnitIsDead(u) then
		return "|cffCFCFCF 死亡|r"
	end
end
oUF.Tags.Events['sunui:DDG'] = 'UNIT_NAME_UPDATE UNIT_HEALTH UNIT_CONNECTION'--'UNIT_MAXHEALTH'

-- current target indicator tag
oUF.Tags.Methods['sunui:targeticon'] = function(u)
	if UnitIsUnit(u, 'target') then
		return "|cffE6A743 >|r"
	end
end
oUF.Tags.Events['sunui:targeticon'] = 'PLAYER_TARGET_CHANGED'
