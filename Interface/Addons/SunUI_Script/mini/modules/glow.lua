--------------------------
-- Durability.lua
-- Author: Sayoc
-- Mod By: Neavo
--------------------------

local q, vl
local G = getfenv(0)
local SlotDurStrs = {}
local items = {
	"Head 1",
	"Neck",
	"Shoulder 2",
	"Shirt",
	"Chest 3",
	"Waist 4",
	"Legs 5",
	"Feet 6",
	"Wrist 7",
	"Hands 8",
	"Finger0",
	"Finger1",
	"Trinket0",
	"Trinket1",
	"Back",
	"MainHand 9",
	"SecondaryHand 10",
	"Ranged 11",
	"Tabard",
}

-------------------------------- Durability show ---------------------------------

local tooltip = CreateFrame("GameTooltip")
tooltip:SetOwner(WorldFrame, "ANCHOR_NONE")

local function GetDurStrings(name)
	if not SlotDurStrs[name] then
		local slot = getglobal("Character" .. name .. "Slot")
		SlotDurStrs[name] = slot:CreateFontString(nil, "OVERLAY", "NumberFontNormal")
		SlotDurStrs[name]:SetPoint("CENTER", slot, "BOTTOM", 2, 8)
	end
	return SlotDurStrs[name]
end

local function UpdateDurability()

	for id, vl in pairs(items) do
		local slot, index = string.split(" ", vl)
		if index then
			local has = tooltip:SetInventoryItem("player", id);
			local value, max = GetInventoryItemDurability(id)
			local SlotDurStr = GetDurStrings(slot)
			if(has and value and max and max ~= 0) then
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

----------------------------------- Event --------------------------------------

local f = CreateFrame("Frame")
f:Hide()
f:RegisterEvent("UNIT_INVENTORY_CHANGED")
f:RegisterEvent("UPDATE_INVENTORY_DURABILITY")

f:SetScript("OnEvent", function(self, event, ...)
	if event == "UPDATE_INVENTORY_DURABILITY" then
			UpdateDurability()
	elseif event == "UNIT_INVENTORY_CHANGED" then
			UpdateDurability()
	end	
end)
