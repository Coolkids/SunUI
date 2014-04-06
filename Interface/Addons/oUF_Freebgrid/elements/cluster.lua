local parent, ns = ...
local oUF = ns.oUF or oUF

local MapData = LibStub("LibMapData-1.0")
local mapwidth, mapheight = 0, 0
local strsplit = string.split
local update
local healrange
local clusterPerc
local units = {}
--freebroster = units

oUF.Tags.Methods['freebgrid:cluster'] = function(u)
    --print(u)
    if units[u] then
        local num = units[u].numInRange
        if num > 2 then
            if num > 6 then
                num = "6+"
            end

            return num
        end
    end
end

local function getDistance(x1, y1, x2, y2)
    local xx = (x2 - x1) * mapwidth
    local yy = (y2 - y1) * mapheight

    return (xx*xx + yy*yy)^0.5
end

local validUnit = function(unit)
    return UnitExists(unit) and not UnitIsDeadOrGhost(unit) and UnitIsConnected(unit)
    and not (UnitIsCharmed(unit) and UnitIsEnemy("player", unit))
end

local clearDataid = function(id, id2)
    if units[id][id2] then
        units[id][id2] = nil
        units[id].numInRange = units[id].numInRange-1
    end
    if units[id2][id] then
        units[id2][id] = nil
        units[id2].numInRange = units[id2].numInRange-1
    end
end

local timer = 0
local updatePos = function(self, elapsed)
    timer = timer + elapsed

    if(timer >= update) then
        for id, _ in next, units do
            if validUnit(id) then
                local x, y = GetPlayerMapPosition(id)
                units[id].pos = ""..x.."\\"..y..""

                local cur, max = UnitHealth(id), UnitHealthMax(id)
                if max > 0 then
                    local per = cur/max
                    units[id].hp = per
                end
            end
        end

        for id, _ in next, units do
            if validUnit(id) then
                local pos = units[id].pos
                local hp = units[id].hp

                for id2, _ in next, units do
                    if validUnit(id2) and (id ~= id2) then
                        local pos2 = units[id2].pos
                        local hp2 = units[id2].hp

                        local x1, y1 = strsplit("\\", pos)
                        local x2, y2 = strsplit("\\", pos2)
                        local xxyy = x1 + x2 + y1 + y2

                        local dist = getDistance(x1, y1, x2, y2)
                        if dist < healrange and xxyy > 0 and hp < clusterPerc and hp2 < clusterPerc then
                            --if dist < healrange and xxyy > 0 then
                            if not units[id][id2] then
                                units[id][id2] = true
                                units[id].numInRange = units[id].numInRange+1
                            end
                            if not units[id2][id] then
                                units[id2][id] = true
                                units[id2].numInRange = units[id2].numInRange+1
                            end
                        else
                            clearDataid(id, id2)
                        end
                    else
                        clearDataid(id, id2)
                    end
                end
            end
        end

        timer = 0
    end
end

local px, py = 0, 0
local updateMapFiles = function()
    px, py = GetPlayerMapPosition("player")
    if((px or 0)+(py or 0) <= 0) then
        if WorldMapFrame:IsVisible() then return end
        SetMapToCurrentZone()
        px, py = GetPlayerMapPosition("player")
        if((px or 0)+(py or 0) <= 0) then return end
    end

    if px > 0 or py > 0 then
        local map, level = GetMapInfo(), GetCurrentMapDungeonLevel()
        mapwidth, mapheight = MapData:MapArea(map, level)
    end
end

local fillroster = function(unit)
    units[unit] = { 
        ["pos"] = "",
        ["numInRange"] = 1,
        ["hp"] = 0,
    }
end

local updateRoster = function()
    wipe(units)

    local numRaid = GetNumGroupMembers()
    if numRaid > 1 then
        for i=1, numRaid do
            local name = GetRaidRosterInfo(i)
            if name then
                local unit = "raid"..i
                fillroster(unit)
            end
        end
    else
        fillroster("player")

        local numParty = GetNumSubgroupMembers()
        for i=1, numParty do
            local unit = "party"..i
            fillroster(unit)
        end
    end
end

local frame = CreateFrame"Frame"
frame:SetScript("OnEvent", function(self, event)
    if event == "ZONE_CHANGED_NEW_AREA" or event == "PLAYER_ENTERING_WORLD" then
        --print("zoneevent")
        updateMapFiles()
    end

    if event ~= "ZONE_CHANGED_NEW_AREA" then
        --print("rosterevent")
        updateRoster()
    end
end)

local Enable = function(self)
    if self.IsFreebgrid and ns.db.cluster.enabled then
        update = ns.db.cluster.freq / 1000
        healrange = ns.db.cluster.range
        clusterPerc = ns.db.cluster.perc / 100

        self.freebCluster = self.Health:CreateFontString(nil, "OVERLAY")
        self.freebCluster:SetPoint("RIGHT", 0, 8)
        self.freebCluster:SetJustifyH("RIGHT")
        self.freebCluster:SetFont(ns.db.fontPath, ns.db.fontsizeEdge, ns.db.outline)
        self.freebCluster:SetTextColor(ns.db.cluster.textcolor.r, ns.db.cluster.textcolor.g, ns.db.cluster.textcolor.b)
        self.freebCluster:SetShadowOffset(1.25, -1.25)
        self.freebCluster:SetWidth(ns.db.width)
        self.freebCluster.frequentUpdates = update
        self:Tag(self.freebCluster, "[freebgrid:cluster]")
        self.freebCluster:Show()

        frame:RegisterEvent("GROUP_ROSTER_UPDATE")
        frame:RegisterEvent("PLAYER_ENTERING_WORLD")
        frame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
        frame:SetScript("OnUpdate", updatePos)
        updateRoster()

        return true
    end

end

local Disable = function(self)
    if self.IsFreebgrid and not ns.db.cluster.enabled then
        if self.freebCluster then
            self.freebCluster.frequentUpdates = false
            self.freebCluster:Hide()
        end

        frame:UnregisterEvent("GROUP_ROSTER_UPDATE")
        frame:UnregisterEvent("PLAYER_ENTERING_WORLD")
        frame:UnregisterEvent("ZONE_CHANGED_NEW_AREA")
        frame:SetScript("OnUpdate", nil)
        wipe(units)
    end
end

oUF:AddElement('freebCluster', nil, Enable, Disable)
