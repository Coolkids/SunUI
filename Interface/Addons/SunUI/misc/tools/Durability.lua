local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local DUR = S:NewModule("Durability", "AceEvent-3.0", "AceHook-3.0", "AceConsole-3.0")
-- Based on tekability by Tekkub
local SLOTIDS = {}

local function RYGColorGradient(perc)
	local relperc = perc*2 % 1
	if perc <= 0 then       return           1,       0, 0
	elseif perc < 0.5 then  return           1, relperc, 0
	elseif perc == 0.5 then return           1,       1, 0
	elseif perc < 1.0 then  return 1 - relperc,       1, 0
	else                    return           0,       1, 0 end
end

local fontstrings = setmetatable({}, {
	__index = function(t,i)
		local gslot = _G["Character"..i.."Slot"]
		assert(gslot, "Character"..i.."Slot does not exist")
		local fstr = S:CreateFS(gslot)
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

function DUR:Initialize()
	for _, slot in pairs({"Head", "Shoulder", "Chest", "Waist", "Legs", "Feet", "Wrist", "Hands", "MainHand", "SecondaryHand"}) do 
		SLOTIDS[slot] = GetInventorySlotInfo(slot .. "Slot") 
	end
	self:RegisterEvent("UNIT_INVENTORY_CHANGED", onEvent)
	self:RegisterEvent("UPDATE_INVENTORY_DURABILITY", onEvent)
end

S:RegisterModule(DUR:GetName())