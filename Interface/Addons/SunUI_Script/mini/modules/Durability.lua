
------------------------
-- Durability.lua
-- Author: Sayoc
-- Mod By: Neavo
------------------------
local SlotDurStrs = {}
local slotDB = {
					["Head"] = "HeadSlot",
					["Shoulder"] = "ShoulderSlot",
					["Chest"] = "ChestSlot",
					["Wrist"] = "WristSlot",
					["MainHand"] = "MainHandSlot",
					["SecondaryHand"] = "SecondaryHandSlot",
					["Ranged"] = "RangedSlot",
					["Hands"] = "HandsSlot",
					["Waist"] = "WaistSlot",
					["Legs"] = "LegsSlot",
					["Feet"] = "FeetSlot",
				}
------------------------------ Durability show ---------------------------------
local function Dura(slotName)
	local slotId, _, _ = GetInventorySlotInfo(slotName)
		if slotId then
			local itemDurability, itemMaxDurability = GetInventoryItemDurability(slotId)
			if itemDurability then
				return itemDurability, itemMaxDurability
			end
		end
end
local function GetDurStrings(name)
	if not SlotDurStrs[name] then
		local slot = getglobal("Character" .. name)
		SlotDurStrs[name] = slot:CreateFontString(nil, "OVERLAY", "NumberFontNormal")
		SlotDurStrs[name]:SetPoint("CENTER", slot, "BOTTOM", 2, 8)
	end
	return SlotDurStrs[name]
end
local function UpdateDurability()
	for k, v in pairs(slotDB) do
		if v then
			local value, max = Dura(v)
			local SlotDurStr = GetDurStrings(v)
			if(value and max and max ~= 0) then
				local percent = value / max				
				SlotDurStr:SetText('')
				if(ceil(percent * 100) < 100)then
					SlotDurStr:SetTextColor(1 - percent, percent, 0)
					SlotDurStr:SetText(ceil(percent * 100) .. "%")
				end
			else
				 SlotDurStr:SetText("")
			end
		end
	end
end

--------------------------------- Event --------------------------------------

local f = CreateFrame("Frame")
f:Hide()
f:RegisterEvent("UNIT_INVENTORY_CHANGED")
f:RegisterEvent("UPDATE_INVENTORY_DURABILITY")

f:SetScript("OnEvent", function(self, event, ...)
	UpdateDurability()
end)
