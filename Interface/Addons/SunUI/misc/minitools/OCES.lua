local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local OCE = S:GetModule("MiniTools")
local TEXT = "Scroll" --button text
local VZ = GetSpellInfo(7411)
local loc = GetLocale()
local upgrades = S.ItemUpgrade
if loc == "deDE" then
	TEXT = "Rolle"
elseif loc == "frFR" then
	TEXT = "Parchemin"
elseif (loc == "esES") or (loc == "esMX") then
	TEXT = "Pergamino"
elseif loc == "ruRU" then
	TEXT = "Свиток"
elseif loc == "koKR" then
elseif loc == "zhCN" then
	TEXT = "附魔羊皮纸"
elseif loc == "zhTW" then
	TEXT = "附魔皮紙"
end
local slots = {
	"HeadSlot", "NeckSlot", "ShoulderSlot", "BackSlot", "ChestSlot", "ShirtSlot", "TabardSlot",
	"WristSlot", "MainHandSlot", "SecondaryHandSlot", "HandsSlot", "WaistSlot",
	"LegsSlot", "FeetSlot", "Finger0Slot", "Finger1Slot", "Trinket0Slot", "Trinket1Slot"
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
			local upgrade = tonumber(item:match(":(%d+)\124h%["))

			if ilevel then
				if ilevel ~= oldilevel then
					if heirloom == 7 then
						text:SetText("")
					else
						if upgrades[upgrade] == nil then upgrades[upgrade] = 0 end
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
function OCE:PLAYER_TARGET_CHANGED()
	UpdateButtonsText("Inspect")
end
function OCE:INSPECT_READY()
	UpdateButtonsText("Inspect")
end
local isTradeSkillUI,isInspectUI = true, true
function OCE:ADDON_LOADED(event, addon)
	if addon == "Blizzard_TradeSkillUI" and isTradeSkillUI then
		isTradeSkillUI = false
		local oldfunc = TradeSkillFrame_SetSelection
		local f=CreateFrame("Button","TradeSkillCreateScrollButton",TradeSkillFrame,"UIPanelButtonTemplate")
		f:SetPoint("TOPRIGHT",TradeSkillCreateButton,"TOPLEFT", -5, 0)
		f:SetSize(130,TradeSkillCreateButton:GetHeight())
		f:SetScript("OnClick",function()
			DoTradeSkill(TradeSkillFrame.selectedSkill)
			UseItemByName(38682)
		end)
		local A = S:GetModule("Skins")
		A:Reskin(f)
		
		function TradeSkillFrame_SetSelection(id)
			oldfunc(id)
			local skillName,_,_,_,altVerb = GetTradeSkillInfo(id)
			if IsTradeSkillGuild() or IsTradeSkillLinked() then
				f:Hide()
			elseif (altVerb and CURRENT_TRADESKILL==VZ) or (altVerb and loc:find("zh")) then
				f:Show()
				local creatable = 1
				if not skillName then
					creatable = nil
				end
				local scrollnum = GetItemCount(38682)
				TradeSkillCreateScrollButton:SetText(TEXT.." ("..scrollnum..")")
				if scrollnum == 0 then
					creatable = nil
				end
				for i=1,GetTradeSkillNumReagents(id) do
					local _,_,reagentCount,playerReagentCount = GetTradeSkillReagentInfo(id,i)
					if playerReagentCount < reagentCount then
						creatable = nil
					end
				end
				if creatable then
					TradeSkillCreateScrollButton:Enable()
				else
					TradeSkillCreateScrollButton:Disable()
				end
			else
				f:Hide()
			end
		end
	end
	if addon == "Blizzard_InspectUI" then
		isInspectUI = false
		CreateButtonsText("Inspect")
		InspectFrame:HookScript("OnShow", function(self) UpdateButtonsText("Inspect") end)
		self:RegisterEvent("PLAYER_TARGET_CHANGED")
		self:RegisterEvent("INSPECT_READY")
	end
end