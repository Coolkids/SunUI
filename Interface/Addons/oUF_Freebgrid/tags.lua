local _, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, "oUF_Freebgrid was unable to locate oUF install.")

local spellcache = setmetatable({}, {__index=function(t,v) local a = {GetSpellInfo(v)} if GetSpellInfo(v) then t[v] = a end return a end})
local function GetSpellInfo(a)
    return unpack(spellcache[a])
end

local numberize = ns.numberize
local colorCache = ns.colorCache
local floor = floor
local timer = {}
local GetTime = GetTime
local x = "M"

local AfkTime = function(s)
    local minute = 60
    local min = floor(s/minute)
    local sec = floor(s-(min*minute))
    if sec < 10 then sec = "0"..sec end
    if min < 10 then min = "0"..min end
    return min..":"..sec
end

local numberize = function(val)
    if (val >= 1e6) then
        return ("%.1fm"):format(val / 1e6)
    elseif (val >= 1e3) then
        return ("%.1fk"):format(val / 1e3)
    else
        return ("%d"):format(val)
    end
end
ns.numberize = numberize

local getTime = function(expirationTime)
    local expire = (expirationTime-GetTime())
    local timeleft = numberize(expire)
    if expire > 0.5 then
        return ("|cffffff00"..timeleft.."|r")
    end
end

oUF.Tags['freebgrid:name'] = function(u, r)
	local name = UnitName(u)
	if r then
		local playername = UnitName(r) 
	end
	
	local namecache = ns.nameCache[name] or ns.nameCache[playername]
    if namecache then
        return namecache
    end
end
oUF.TagEvents['freebgrid:name'] = 'UNIT_NAME_UPDATE'

oUF.Tags['freebgrid:afk'] = function(u)
    local name = UnitName(u)
    if(UnitIsAFK(u) or not UnitIsConnected(u)) then
        if not timer[name] then
            timer[name] = GetTime()
        end   
		if ns.db.afk then
			local time = (GetTime()-timer[name])
			return AfkTime(time)
		end
    elseif timer[name] then
        timer[name] = nil
    end
end
oUF.TagEvents['freebgrid:afk'] = 'PLAYER_FLAGS_CHANGED UNIT_CONNECTION'

oUF.Tags['freebgrid:altpower'] = function(u)
	local cur = UnitPower(u, ALTERNATE_POWER_INDEX)
    if cur > 0 then
	    local max = UnitPowerMax(u, ALTERNATE_POWER_INDEX)
        local per = floor(cur/max*100)

        local tPath, r, g, b = UnitAlternatePowerTextureInfo(u, 2)
    
        if not r then
            r, g, b = 1, 1, 1
        end

        return ns:hex(r,g,b)..format("%d", per).."|r"
    end
end
oUF.TagEvents['freebgrid:altpower'] = "UNIT_POWER UNIT_MAXPOWER"

oUF.Tags['freebgrid:def'] = function(u)

	if not UnitIsConnected(u) then  
        return "|cffCFCFCF离线|r"
    elseif UnitIsDead(u) then
        return "|cffCFCFCF死亡|r"
    elseif UnitIsGhost(u) then
        return "|cffCFCFCF幽灵|r"
	elseif UnitIsAFK(u) then
        return "|cffCFCFCF离开|r"
    end

    if ns.db.altpower then
        local altpp = oUF.Tags['freebgrid:altpower'](u)
        if altpp then
            return altpp
        end
    end
	
	local _, class = UnitClass(u)
    local color = colorCache[class]
	
    if ns.db.hptext == "PERC" then
        local perc = oUF.Tags['perhp'](u)
        if perc < ns.db.hppercent then
            return color..perc.."%|r"
        end
    elseif ns.db.hptext == "DEFICIT" or ns.db.hptext == "ACTUAL" then
		local cur = UnitHealth(u)
        local max = UnitHealthMax(u)
        local per = cur/max
        if color and per < ns.db.hppercent / 100  then
                return color..(ns.db.hptext == "DEFICIT" and "-"..numberize(max-cur) or numberize(cur)).."|r"
        end
    end 
end
oUF.TagEvents['freebgrid:def'] = 'UNIT_MAXHEALTH UNIT_HEALTH UNIT_HEALTH_FREQUENT UNIT_CONNECTION PLAYER_FLAGS_CHANGED '..oUF.TagEvents['freebgrid:altpower']

oUF.Tags['freebgrid:heals'] = function(u)
    local incheal = UnitGetIncomingHeals(u) or 0
    if incheal > 0 then
        return "|cff00FF00"..numberize(incheal).."|r"
    else
        local def = oUF.Tags['freebgrid:def'](u)
        return def
    end
end
oUF.TagEvents['freebgrid:heals'] = 'UNIT_HEAL_PREDICTION '..oUF.TagEvents['freebgrid:def']

oUF.Tags['freebgrid:othersheals'] = function(u)
    local incheal = UnitGetIncomingHeals(u) or 0
    local player = UnitGetIncomingHeals(u, "player") or 0

    incheal = incheal - player

    if incheal > 0 then
        return "|cff00FF00"..numberize(incheal).."|r"
    else
        local def = oUF.Tags['freebgrid:def'](u)
        return def
    end
end
oUF.TagEvents['freebgrid:othersheals'] = oUF.TagEvents['freebgrid:heals']

-- dispel
oUF.Tags['freebgrid:dispel'] = function(u)
	if ns.db.dispel ~= "INDICATOR" then return end
	local dispellist = ns.dispellist or {}
	local color = ns.debuffColor or {}
    local index = 1
    while true do
        local name,_,_,_, dtype = UnitAura(u, index, 'HARMFUL')
        if not name then break end
		if dispellist[dtype] then return color[dtype].."a" end
        index = index+1
    end
end
oUF.TagEvents['freebgrid:dispel'] = "UNIT_AURA"

-- Priest
local pomCount = {"i","h","g","f","Z","Y"}	--愈合祷言
oUF.Tags['freebgrid:pom'] = function(u) 
    local name, _,_, c, _,_,_, fromwho = UnitAura(u, GetSpellInfo(41635)) 
    if fromwho == "player" then
        if(c) then return "|cff66FFFF"..pomCount[c].."|r" end 
    else
        if(c) then return "|cffFFCF7F"..pomCount[c].."|r" end 
    end
end
oUF.TagEvents['freebgrid:pom'] = "UNIT_AURA"

oUF.Tags['freebgrid:rnw'] = function(u)
    local name, _,_,_,_,_, expirationTime, fromwho = UnitAura(u, GetSpellInfo(139))
    if ns.ISHealer and (fromwho == "player") then
        local spellTimer = GetTime()-expirationTime
        if spellTimer > -2 then
            return "|cffFF0000"..x.."|r"
        elseif spellTimer > -4 then
            return "|cffFF9900"..x.."|r"
        else
            return "|cff33FF33"..x.."|r"
        end
    end
end
oUF.TagEvents['freebgrid:rnw'] = "UNIT_AURA"

oUF.Tags['freebgrid:rnwTime'] = function(u)
    local name, _,_,_,_,_, expirationTime, fromwho = UnitAura(u, GetSpellInfo(139))
    if ns.ISHealer and (fromwho == "player") then return getTime(expirationTime) end 
end
oUF.TagEvents['freebgrid:rnwTime'] = "UNIT_AURA"

oUF.Tags['freebgrid:pws'] = function(u) if UnitAura(u, GetSpellInfo(17)) then return "|cff33FF33"..x.."|r" end end
oUF.TagEvents['freebgrid:pws'] = "UNIT_AURA"

oUF.Tags['freebgrid:ws'] = function(u) if UnitDebuff(u, GetSpellInfo(6788)) then return "|cffFF9900"..x.."|r" end end
oUF.TagEvents['freebgrid:ws'] = "UNIT_AURA"

oUF.Tags['freebgrid:fw'] = function(u) if UnitAura(u, GetSpellInfo(6346)) then return "|cff8B4513"..x.."|r" end end
oUF.TagEvents['freebgrid:fw'] = "UNIT_AURA"

oUF.Tags['freebgrid:sp'] = function(u) if not UnitAura(u, GetSpellInfo(79107)) then return "|cff9900FF"..x.."|r" end end
oUF.TagEvents['freebgrid:sp'] = "UNIT_AURA"

oUF.Tags['freebgrid:fort'] = function(u) if not(UnitAura(u, GetSpellInfo(79105)) or UnitAura(u, GetSpellInfo(6307)) or UnitAura(u, GetSpellInfo(469))) then return "|cff00A1DE"..x.."|r" end end
oUF.TagEvents['freebgrid:fort'] = "UNIT_AURA"

oUF.Tags['freebgrid:pwb'] = function(u) if UnitAura(u, GetSpellInfo(81782)) then return "|cffEEEE00"..x.."|r" end end
oUF.TagEvents['freebgrid:pwb'] = "UNIT_AURA"

-- Druid
local lbCount = { "C", "A", "B"}
oUF.Tags['freebgrid:lb'] = function(u) 
    local name, _,_, c,_,_, expirationTime, fromwho = UnitAura(u, GetSpellInfo(33763))
    if(fromwho == "player") then
        local spellTimer = GetTime()-expirationTime
        if spellTimer > -2 then
            return "|cffFF0000"..lbCount[c].."|r"
        elseif spellTimer > -4 then
            return "|cffFF9900"..lbCount[c].."|r"
        else
            return "|cffA7FD0A"..lbCount[c].."|r"
        end
    end
end
oUF.TagEvents['freebgrid:lb'] = "UNIT_AURA"

oUF.Tags['freebgrid:rejuv'] = function(u)
    local name, _,_,_,_,_, expirationTime, fromwho = UnitAura(u, GetSpellInfo(774))
    if(fromwho == "player") then
        local spellTimer = GetTime()-expirationTime
        if spellTimer > -2 then
            return "|cffFF0000"..x.."|r"
        elseif spellTimer > -4 then
            return "|cffFF9900"..x.."|r"
        else
            return "|cff33FF33"..x.."|r"
        end
    end
end
oUF.TagEvents['freebgrid:rejuv'] = "UNIT_AURA"

oUF.Tags['freebgrid:rejuvTime'] = function(u)
    local name, _,_,_,_,_, expirationTime, fromwho = UnitAura(u, GetSpellInfo(774))
    if(fromwho == "player") then return getTime(expirationTime) end 
end
oUF.TagEvents['freebgrid:rejuvTime'] = "UNIT_AURA"

oUF.Tags['freebgrid:regrow'] = function(u) if UnitAura(u, GetSpellInfo(8936)) then return "|cff00FF10"..x.."|r" end end
oUF.TagEvents['freebgrid:regrow'] = "UNIT_AURA"

oUF.Tags['freebgrid:wg'] = function(u) if UnitAura(u, GetSpellInfo(48438)) then return "|cff33FF33"..x.."|r" end end
oUF.TagEvents['freebgrid:wg'] = "UNIT_AURA"

oUF.Tags['freebgrid:motw'] = function(u) if not(UnitAura(u, GetSpellInfo(79060)) or UnitAura(u,GetSpellInfo(79063))) then return "|cff00A1DE"..x.."|r" end end
oUF.TagEvents['freebgrid:motw'] = "UNIT_AURA"

-- Warrior
oUF.Tags['freebgrid:stragi'] = function(u) if not(UnitAura(u, GetSpellInfo(6673)) or UnitAura(u, GetSpellInfo(57330)) or UnitAura(u, GetSpellInfo(8076))) then return "|cffFF0000"..x.."|r" end end
oUF.TagEvents['freebgrid:stragi'] = "UNIT_AURA"

oUF.Tags['freebgrid:vigil'] = function(u) if UnitAura(u, GetSpellInfo(50720)) then return "|cff8B4513"..x.."|r" end end
oUF.TagEvents['freebgrid:vigil'] = "UNIT_AURA"

-- Shaman
oUF.Tags['freebgrid:xz'] = function(u) if UnitAura(u, GetSpellInfo(16236)) then return "|cff00FF10"..x.."|r" end end
oUF.TagEvents['freebgrid:xz'] = "UNIT_AURA"

oUF.Tags['freebgrid:rip'] = function(u) 
    local name, _,_,_,_,_,_, fromwho = UnitAura(u, GetSpellInfo(61295))
    if(fromwho == 'player') then return "|cff00FEBF"..x.."|r" end
end
oUF.TagEvents['freebgrid:rip'] = 'UNIT_AURA'

oUF.Tags['freebgrid:ripTime'] = function(u)
    local name, _,_,_,_,_, expirationTime, fromwho = UnitAura(u, GetSpellInfo(61295))
    if(fromwho == "player") then return getTime(expirationTime) end 
end
oUF.TagEvents['freebgrid:ripTime'] = 'UNIT_AURA'

oUF.Tags['freebgrid:earth'] = function(u) 
	local name, _,_,count,_,_,_, fromwho = UnitAura(u, GetSpellInfo(974))
	if name then
		if (fromwho == "player") then
			return '|cffFFFFFF'..count..'|r'
		else
			--return '|cff8B4513'..count..'|r'
		end
	end
end
oUF.TagEvents['freebgrid:earth'] = 'UNIT_AURA'

-- Paladin
oUF.Tags['freebgrid:protect'] = function(u) 
if (UnitAura(u, GetSpellInfo(1022)) or UnitAura(u, GetSpellInfo(1038)) or UnitAura(u, GetSpellInfo(1044)) or UnitAura(u, GetSpellInfo(6940))) then return "|cff00FEBF"..x.."|r" end end
oUF.TagEvents['freebgrid:protect'] = "UNIT_AURA"

oUF.Tags['freebgrid:might'] = function(u) 
if not(UnitAura(u, GetSpellInfo(53138)) or UnitAura(u, GetSpellInfo(79102))) then return "|cffFF0000"..x.."|r" end end
oUF.TagEvents['freebgrid:might'] = "UNIT_AURA"

oUF.Tags['freebgrid:beacon'] = function(u)	--道标
    local name, _,_,_,_,_, expirationTime,fromwho = UnitAura(u, GetSpellInfo(53563))
    if  name and fromwho ~= "player" then return "|cff00FEBF"..x.."|r" end
end
oUF.TagEvents['freebgrid:beacon'] = "UNIT_AURA"
--[[
oUF.Tags['freebgrid:beaconTime'] = function(u)
    local name, _,_,_,_,_, expirationTime, fromwho = UnitAura(u, GetSpellInfo(53563))
    if(fromwho == "player") then return getTime(expirationTime) end 
end
oUF.TagEvents['freebgrid:beaconTime'] = 'UNIT_AURA'
--]]
oUF.Tags['freebgrid:beaconTime'] = function(u)	--道标
    local name, _,_,_,_,_, expirationTime, fromwho = UnitAura(u, GetSpellInfo(53563))
    if not name then return end
	 local spellTimer =math.ceil( (expirationTime-GetTime())/60)
    if(fromwho == "player") then
        if spellTimer > 1 then
            return "|cff00FEBF"..spellTimer.."|r"
        else
            return "|cffFFCC00"..spellTimer.."|r"
        end
    else
        return "|cffFFFFFF"..spellTimer.."|r"-- other pally's beacon
    end
end
oUF.TagEvents['freebgrid:beaconTime'] = "UNIT_AURA"


--释放保护等技能造成的自律debuff
oUF.Tags['freebgrid:forbearance'] = function(u) if UnitDebuff(u, GetSpellInfo(25771)) then return "|cffFF9900"..x.."|r" end end
oUF.TagEvents['freebgrid:forbearance'] = "UNIT_AURA"

-- Warlock
oUF.Tags['freebgrid:di'] = function(u) 
    local name, _,_,_,_,_,_, fromwho = UnitAura(u, GetSpellInfo(85767)) 
    if fromwho == "player" then
        return "|cff6600FF"..x.."|r"
    elseif name then
        return "|cffCC00FF"..x.."|r"
    end
end
oUF.TagEvents['freebgrid:di'] = "UNIT_AURA"

oUF.Tags['freebgrid:ss'] = function(u) 
    local name, _,_,_,_,_,_, fromwho = UnitAura(u, GetSpellInfo(20707)) 
    if fromwho == "player" then
        return "|cff6600FFY|r"
    elseif name then
        return "|cffCC00FFY|r"
    end
end
oUF.TagEvents['freebgrid:ss'] = "UNIT_AURA"

-- Mage
oUF.Tags['freebgrid:int'] = function(u) if not(UnitAura(u, GetSpellInfo(1459))) and not UnitAura(u, GetSpellInfo(79038))then return "|cff00A1DE"..x.."|r" end end
oUF.TagEvents['freebgrid:int'] = "UNIT_AURA"

oUF.Tags['freebgrid:fmagic'] = function(u) if UnitAura(u, GetSpellInfo(54648)) then return "|cffCC00FF"..x.."|r" end end
oUF.TagEvents['freebgrid:fmagic'] = "UNIT_AURA"

ns.classIndicators={
    ["DRUID"] = {
        ["TL"] = "",
        ["TR"] = "[freebgrid:motw]",
        ["BL"] = "[freebgrid:regrow][freebgrid:wg]",
		["RC"] = "[freebgrid:dispel]",
        ["BR"] = "[freebgrid:lb]",
        ["Cen"] = "[freebgrid:rejuvTime]",
    },
    ["PRIEST"] = {
        ["TL"] = "[freebgrid:pws][freebgrid:ws]",
        ["TR"] = "[freebgrid:fw][freebgrid:sp][freebgrid:fort]",
        ["BL"] = "[freebgrid:rnw][freebgrid:pwb]",
		["RC"] = "[freebgrid:dispel]",
        ["BR"] = "[freebgrid:pom]",
        ["Cen"] = "[freebgrid:rnwTime]",
    },
    ["PALADIN"] = {
        ["TL"] = "[freebgrid:forbearance]",
        ["TR"] = "[freebgrid:might][freebgrid:motw][freebgrid:protect]",
        ["BL"] = "[freebgrid:beacon]",
		["RC"] = "[freebgrid:dispel]",
        ["BR"] = "[freebgrid:beaconTime]",
        ["Cen"] = "",
    },
    ["WARLOCK"] = {
        ["TL"] = "",
        ["TR"] = "[freebgrid:di]",
        ["BL"] = "",
		["RC"] = "",
        ["BR"] = "[freebgrid:ss]",
        ["Cen"] = "",
    },
    ["WARRIOR"] = {
        ["TL"] = "[freebgrid:vigil]",
        ["TR"] = "[freebgrid:stragi][freebgrid:fort]",
        ["BL"] = "",
		["RC"] = "",
        ["BR"] = "",
        ["Cen"] = "",
    },
    ["DEATHKNIGHT"] = {
        ["TL"] = "",
        ["TR"] = "",
        ["BL"] = "",
		["RC"] = "",
        ["BR"] = "",
        ["Cen"] = "",
    },
    ["SHAMAN"] = {
        ["TL"] = "[freebgrid:rip]",
        ["TR"] = "[freebgrid:xz]",
        ["BL"] = "[freebgrid:beacon]",
		["RC"] = "[freebgrid:dispel]",
        ["BR"] = "[freebgrid:earth]",
        ["Cen"] = "[freebgrid:ripTime]",
    },
    ["HUNTER"] = {
        ["TL"] = "",
        ["TR"] = "",
        ["BL"] = "",
		["RC"] = "",
        ["BR"] = "",
        ["Cen"] = "",
    },
    ["ROGUE"] = {
        ["TL"] = "",
        ["TR"] = "",
        ["BL"] = "",
		["RC"] = "",
        ["BR"] = "",
        ["Cen"] = "",
    },
    ["MAGE"] = {
        ["TL"] = "",
        ["TR"] = "[freebgrid:int]",
        ["BL"] = "",
		["RC"] = "[freebgrid:dispel]",
        ["BR"] = "",
        ["Cen"] = "",
    }
}
