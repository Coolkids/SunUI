--local R, C, DB = unpack(select(2, ...))

local _, ns = ...
local oUF = oUF_Freeb or ns.oUF or oUF

local siValue = function(val)
    if(val >= 1e6) then
        return ('%.1fm'):format(val / 1e6):gsub('%.?0+([km])$', '%1')
    elseif(val >= 1e4) then
        return ('%.1fk'):format(val / 1e3):gsub('%.?0+([km])$', '%1')
    else
        return val
    end
end

local utf8sub = function(string, i, dots)
	local bytes = string:len()
	if (bytes <= i) then
		return string
	else
		local len, pos = 0, 1
		while(pos <= bytes) do
			len = len + 1
			local c = string:byte(pos)
			if c > 240 then
				pos = pos + 4
			elseif c > 225 then
				pos = pos + 3
			elseif c > 192 then
				pos = pos + 2
			else
				pos = pos + 1
			end
			if (len == i) then break end
		end

		if (len == i and pos <= bytes) then
			return string:sub(1, pos - 1)..(dots and "..." or "")
		else
			return string
		end
	end
end

local function hex(r, g, b)
    if not r then return "|cffFFFFFF" end

    if(type(r) == 'table') then
        if(r.r) then r, g, b = r.r, r.g, r.b else r, g, b = unpack(r) end
    end
    return ('|cff%02x%02x%02x'):format(r * 255, g * 255, b * 255)
end

oUF.colors.power['MANA'] = { 78/255,  150/255,  222/255}
oUF.colors.power['RAGE'] = {.69,.31,.31}

oUF.Tags['freeb:lvl'] = function(u) 
    local level = UnitLevel(u)
    local typ = UnitClassification(u)
    local color = GetQuestDifficultyColor(level)

    if level <= 0 then
        level = "??" 
        color.r, color.g, color.b = 1, 0, 0
    end

    if typ=="rareelite" then
        return hex(color)..level..'r+|r'
    elseif typ=="elite" then
        return hex(color)..level..'+|r'
    elseif typ=="rare" then
        return hex(color)..level..'r|r'
    else
        return hex(color)..level..'|r'
    end
end

oUF.Tags['freeb:hp']  = function(u) 
    local min, max = UnitHealth(u), UnitHealthMax(u)
    return siValue(min).." | "..math.floor(min/max*100+.5).."%"
end
oUF.TagEvents['freeb:hp'] = 'UNIT_HEALTH'

oUF.Tags['freeb:pp'] = function(u)
    local _, str = UnitPowerType(u)
    local power = UnitPower(u)

    if str and power > 0 then
	local min, max = UnitPower(u), UnitPowerMax(u)
        return hex(oUF.colors.power[str])..siValue(min).." | "..math.floor(min/max*100+.5).."%".."|r"
    end
end
oUF.TagEvents['freeb:pp'] = 'UNIT_POWER'

oUF.Tags['freeb:color'] = function(u, r)
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
--oUF.TagEvents['freeb:color'] = 'UNIT_REACTION UNIT_HEALTH UNIT_HAPPINESS'

oUF.Tags['freeb:name'] = function(u, r)
    local name = UnitName(r or u)
    return name
end
oUF.TagEvents['freeb:name'] = 'UNIT_NAME_UPDATE'

oUF.Tags['raid:name'] = function(u, r)
    local name = UnitName(realUnit or u or r)
    return utf8sub(name, 4, false)
end
oUF.TagEvents['raid:name'] = 'UNIT_NAME_UPDATE'

oUF.Tags['freeb:info'] = function(u)
    if UnitIsDead(u) then
        return oUF.Tags['freeb:lvl'](u).."|cffCFCFCF 死亡|r"
    elseif UnitIsGhost(u) then
        return oUF.Tags['freeb:lvl'](u).."|cffCFCFCF 靈魂|r"
    elseif not UnitIsConnected(u) then
        return oUF.Tags['freeb:lvl'](u).."|cffCFCFCF 離線|r"
    else
        return oUF.Tags['freeb:lvl'](u)
    end
end
oUF.TagEvents['freeb:info'] = 'UNIT_HEALTH'

oUF.Tags['freebraid:info'] = function(u)
    local _, class = UnitClass(u)

    if class then
        if UnitIsDead(u) then
            return hex(oUF.colors.class[class]).."DEAD|r"
        elseif UnitIsGhost(u) then
            return hex(oUF.colors.class[class]).."GHO|r"
        elseif not UnitIsConnected(u) then
            return hex(oUF.colors.class[class]).."離線|r"
        end
    end
end
oUF.TagEvents['freebraid:info'] = 'UNIT_HEALTH UNIT_CONNECTION'

oUF.Tags['freeb:curxp'] = function(unit)
    return siValue(UnitXP(unit))
end

oUF.Tags['freeb:maxxp'] = function(unit)
    return siValue(UnitXPMax(unit))
end

oUF.Tags['freeb:perxp'] = function(unit)
    return math.floor(UnitXP(unit) / UnitXPMax(unit) * 100 + 0.5)
end

oUF.TagEvents['freeb:curxp'] = 'PLAYER_XP_UPDATE PLAYER_LEVEL_UP'
oUF.TagEvents['freeb:maxxp'] = 'PLAYER_XP_UPDATE PLAYER_LEVEL_UP'
oUF.TagEvents['freeb:perxp'] = 'PLAYER_XP_UPDATE PLAYER_LEVEL_UP'

oUF.Tags['freeb:altpower'] = function(u)
	local cur = UnitPower(u, ALTERNATE_POWER_INDEX)
	local max = UnitPowerMax(u, ALTERNATE_POWER_INDEX)
    local per = floor(cur/max*100)
    
    return format("%d", per > 0 and per or 0).."%"
end
oUF.TagEvents['freeb:altpower'] = "UNIT_POWER UNIT_MAXPOWER"
oUF.Tags['healpredictionself'] = function(unit)
	local myIncomingHeal = UnitGetIncomingHeals(unit, 'player') or 0

	if myIncomingHeal == 0 then
		return nil
	else
		return myIncomingHeal
	end
end
oUF.TagEvents['healpredictionself'] = 'UNIT_HEAL_PREDICTION'

oUF.Tags['healpredictionother'] = function(unit)
	local myIncomingHeal = UnitGetIncomingHeals(unit, 'player') or 0
	local allIncomingHeal = UnitGetIncomingHeals(unit) or 0

	if(allIncomingHeal < myIncomingHeal) then
		myIncomingHeal = allIncomingHeal
		allIncomingHeal = 0
	else
		allIncomingHeal = allIncomingHeal - myIncomingHeal
	end

	if allIncomingHeal == 0 then
		return nil
	else
		return allIncomingHeal
	end
end
oUF.TagEvents['healpredictionother'] = 'UNIT_HEAL_PREDICTION'

oUF.Tags['healpredictionall'] = function(unit)
	local allIncomingHeal = UnitGetIncomingHeals(unit) or 0

	if allIncomingHeal == 0 then
		return nil
	else
		return allIncomingHeal
	end
end
oUF.TagEvents['healpredictionall'] = 'UNIT_HEAL_PREDICTION'
