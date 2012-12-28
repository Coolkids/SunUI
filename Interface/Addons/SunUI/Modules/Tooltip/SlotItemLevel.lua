local S, L, DB, _, C = unpack(select(2, ...))
local SIL = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("SlotItemLevel", "AceEvent-3.0", "AceTimer-3.0")

----------------------------------------------------------------------------------------
--	Item level on slot buttons in Character/InspectFrame(by Tukz)
----------------------------------------------------------------------------------------
local time = 3
local slots = {
	"HeadSlot", "NeckSlot", "ShoulderSlot", "BackSlot", "ChestSlot", "ShirtSlot", "TabardSlot",
	"WristSlot", "MainHandSlot", "SecondaryHandSlot", "HandsSlot", "WaistSlot",
	"LegsSlot", "FeetSlot", "Finger0Slot", "Finger1Slot", "Trinket0Slot", "Trinket1Slot"
}

local upgrades = {
	["0"] = 0, ["1"] = 8, ["373"] = 4, ["374"] = 8, ["375"] = 4, ["376"] = 4,
	["377"] = 4, ["379"] = 4, ["380"] = 4, ["445"] = 0, ["446"] = 4, ["447"] = 8,
	["451"] = 0, ["452"] = 8, ["453"] = 0, ["454"] = 4, ["455"] = 8, ["456"] = 0,
	["457"] = 8, ["458"] = 0, ["459"] = 4, ["460"] = 8, ["461"] = 12, ["462"] = 16
}

local function CreateButtonsText(frame)
	for _, slot in pairs(slots) do
		local button = _G[frame..slot]
		button.t = button:CreateFontString(nil, "OVERLAY", "SystemFont_Outline_Small")
		button.t:SetPoint("TOP", button, "TOP", 0, -2)
		button.t:SetText("")
	end
end

local function UpdateButtonsText(frame)
	if frame == "Inspect" and not InspectFrame:IsShown() then return end

	for _, slot in pairs(slots) do
		local id = GetInventorySlotInfo(slot)
		local item
		local text = _G[frame..slot].t

		if frame == "Inspect" then
			item = GetInventoryItemLink("target", id)
		else
			item = GetInventoryItemLink("player", id)
		end

		if slot == "ShirtSlot" or slot == "TabardSlot" then
			text:SetText("")
		elseif item then
			local oldilevel = text:GetText()
			local ilevel = select(4, GetItemInfo(item))
			local heirloom = select(3, GetItemInfo(item))
			local upgrade = item:match(":(%d+)\124h%[")

			if ilevel then
				if ilevel ~= oldilevel then
					if heirloom == 7 then
						text:SetText("")
					else
						if upgrades[upgrade] > 0 then
							text:SetText("|cffffd200"..ilevel + upgrades[upgrade])
						else
							text:SetText("|cFFFFFF00"..ilevel + upgrades[upgrade])
						end
					end
				end
			else
				text:SetText("")
			end
		else
			text:SetText("")
		end
	end
end

function SIL:PLAYER_LOGIN()
	CreateButtonsText("Character")
	UpdateButtonsText("Character")
	self:UnregisterEvent("PLAYER_LOGIN")
end
function SIL:PLAYER_EQUIPMENT_CHANGED()
	UpdateButtonsText("Character")
end
function SIL:PLAYER_TARGET_CHANGED()
	UpdateButtonsText("Inspect")
end
function SIL:INSPECT_READY()
	UpdateButtonsText("Inspect")
end

function SIL:ADDON_LOADED(event, addon)
	if addon == "Blizzard_InspectUI" then
		CreateButtonsText("Inspect")
		InspectFrame:HookScript("OnShow", function(self) UpdateButtonsText("Inspect") end)
		self:RegisterEvent("PLAYER_TARGET_CHANGED")
		self:RegisterEvent("INSPECT_READY")
		self:UnregisterEvent("ADDON_LOADED")
	end
end
function SIL:OnUpdate()
	if InspectFrame and InspectFrame:IsShown() then
		UpdateButtonsText("Inspect")
	else
		UpdateButtonsText("Character")
	end
end
function SIL:OnInitialize()
	self:RegisterEvent("ADDON_LOADED")
	self:RegisterEvent("PLAYER_LOGIN")
	self:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
	self:ScheduleRepeatingTimer("OnUpdate", 3)
end