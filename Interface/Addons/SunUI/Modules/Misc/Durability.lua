﻿local S, L, DB, _, C = unpack(select(2, ...))
local _
-- Based on tekability by Tekkub
local SLOTIDS = {}
for _, slot in pairs({"Head", "Shoulder", "Chest", "Waist", "Legs", "Feet", "Wrist", "Hands", "MainHand", "SecondaryHand"}) do SLOTIDS[slot] = GetInventorySlotInfo(slot .. "Slot") end

local function RYGColorGradient(perc)
	local relperc = perc*2 % 1
	if perc <= 0 then       return           1,       0, 0
	elseif perc < 0.5 then  return           1, relperc, 0
	elseif perc == 0.5 then return           1,       1, 0
	elseif perc < 1.0 then  return 1 - relperc,       1, 0
	else                    return           0,       1, 0 end
end

local CreateFS = function(parent, size, justify)
    local f = parent:CreateFontString(nil, "OVERLAY", "NumberFontNormal")
    f:SetShadowColor(0, 0, 0, 0)
    if(justify) then f:SetJustifyH(justify) end
    return f
end
local fontstrings = setmetatable({}, {
	__index = function(t,i)
		local gslot = _G["Character"..i.."Slot"]
		assert(gslot, "Character"..i.."Slot does not exist")
		local fstr = CreateFS(gslot)
		fstr:SetPoint("CENTER", gslot, "BOTTOM", 1, 8)
		t[i] = fstr
		return fstr
	end,
})

local onEvent = function()
	for slot, id in pairs(SLOTIDS) do
		local v1, v2 = GetInventoryItemDurability(id)

		if v1 and v2 and v2 ~= 0 then
			local str = fontstrings[slot]
			str:SetTextColor(RYGColorGradient(v1/v2))
			str:SetText(string.format("%d%%", v1/v2*100))
		else
			local str = rawget(fontstrings, slot)
			if str then str:SetText(nil) end
		end
	end
end
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("UNIT_INVENTORY_CHANGED")
eventFrame:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
eventFrame:SetScript("OnEvent", onEvent)