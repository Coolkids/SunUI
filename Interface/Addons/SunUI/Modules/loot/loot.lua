local S, C, L, DB, _ = unpack(select(2, ...))
local _G = _G
local cfg = {
	iconsize = 32, 					-- loot frame icon's size
}

local L = {
	fish = "Fishy loot",
	empty = "Empty slot",
}
local addon = CreateFrame("Button", "m_Loot")
local title = addon:CreateFontString(nil, "OVERLAY")
local lb = CreateFrame("Button", "m_LootAdv", addon, "UIPanelScrollDownButtonTemplate")		-- Link button
local LDD = CreateFrame("Frame", "m_LootLDD", addon, "UIDropDownMenuTemplate")				-- Link dropdown menu frame

local sq, ss, sn
local OnEnter = function(self)
	local slot = self:GetID()
	if GetLootSlotType(slot) == 1 then
-- 	if(LootSlotIsItem(slot)) then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetLootItem(slot)
		CursorUpdate(self)
	end 
end


local function OnLinkClick(self)
    ToggleDropDownMenu(1, nil, LDD, lb, 0, 0)
end

local function LDD_OnClick(self)
    local val = self.value
	Announce(val)
end

function Announce(chn)
    local nums = GetNumLootItems()
    if(nums == 0) then return end
    if UnitIsPlayer("target") or not UnitExists("target") then -- Chests are hard to identify!
		SendChatMessage("*** Loot from chest ***", chn)
	else
		SendChatMessage("*** Loot from "..UnitName("target").." ***", chn)
	end
    for i = 1, GetNumLootItems() do
        if GetLootSlotType(i) == 1 then
            local link = GetLootSlotLink(i)
            --local messlink = "- %s" -- testing
            SendChatMessage(link, chn)
        end
    end
end

local function LDD_Initialize()  
    local info = {}
    
    info.text = "Announce to"
    info.notCheckable = true
    info.isTitle = true
    UIDropDownMenu_AddButton(info)
    
    --announce chanels
    info = {}
    info.text = "  raid"
    info.value = "raid"
    info.notCheckable = 1
    info.func = LDD_OnClick
    UIDropDownMenu_AddButton(info)
    
    info = {}
    info.text = "  guild"
    info.value = "guild"
    info.notCheckable = 1
    info.func = LDD_OnClick
    UIDropDownMenu_AddButton(info)
	
	info = {}
    info.text = "  party"
    info.value = "party"
    info.notCheckable = 1
    info.func = LDD_OnClick
    UIDropDownMenu_AddButton(info)

    info = {}
    info.text = "  say"
    info.value = "say"
    info.notCheckable = 1
    info.func = LDD_OnClick
    UIDropDownMenu_AddButton(info)
    
    info = nil
end

local OnLeave = function(self)
	--if(self.quality > 1) then
		local color = ITEM_QUALITY_COLORS[self.quality]
		--self.drop:SetVertexColor(color.r, color.g, color.b)
	--else
	--	self.drop:Hide()
	--end

	GameTooltip:Hide()
	ResetCursor()
end

local OnClick = function(self)
	if(IsModifiedClick()) then
		HandleModifiedItemClick(GetLootSlotLink(self:GetID()))
	else
		--StaticPopup_Hide"CONFIRM_LOOT_DISTRIBUTION"
		ss = self:GetID()
		sq = self.quality
		sn = self.name:GetText()
		
		LootFrame.selectedLootButton = self
		--LootFrame.selectedTexture = self.texture
		LootFrame.selectedSlot = self:GetID()
		LootFrame.selectedQuality = self.quality
		LootFrame.selectedItemName = self.name:GetText()
		LootSlot(ss)
	end
end

local OnUpdate = function(self)
	if(GameTooltip:IsOwned(self)) then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetLootItem(self:GetID())
		CursorOnUpdate(self)
	end
end

local createSlot = function(id)
	local frame = CreateFrame("Button", 'm_LootSlot'..id, addon)
	frame:SetPoint("LEFT", 8, 0)
	frame:SetPoint("RIGHT", -8, 0)
	frame:SetHeight(cfg.iconsize)
	frame:SetID(id)
	
	frame:SetScript("OnEnter", OnEnter)
	frame:SetScript("OnLeave", OnLeave)
	frame:SetScript("OnClick", OnClick)
	frame:SetScript("OnUpdate", OnUpdate)

	local iconFrame = CreateFrame("Frame", nil, frame)
	iconFrame:SetHeight(cfg.iconsize)
	iconFrame:SetWidth(cfg.iconsize)
	iconFrame:ClearAllPoints()
	iconFrame:SetPoint("LEFT", frame, 3,0)
	
	local icon = iconFrame:CreateTexture(nil, "BACKGROUND")
	icon:SetAlpha(.8)
	icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	icon:SetAllPoints(iconFrame)
	frame.icon = icon
    
	local overlay = CreateFrame("Frame", nil, iconFrame)  
	overlay:Point("TOPLEFT",iconFrame,"TOPLEFT",-1,1)
	overlay:Point("BOTTOMRIGHT",iconFrame,"BOTTOMRIGHT",1,-1)
	overlay:CreateBorder()
	frame.overlay = overlay
	
	local count = iconFrame:CreateFontString(nil, "OVERLAY")
	count:ClearAllPoints()
	count:SetJustifyH"RIGHT"
	count:SetPoint("BOTTOMRIGHT", iconFrame, 2, 2)
	count:SetFontObject(NumberFontNormal)
	count:SetShadowOffset(.8, -.8)
	count:SetShadowColor(0, 0, 0, 1)
	count:SetText(1)
	frame.count = count

	local name = frame:CreateFontString(nil, "OVERLAY")
	name:SetJustifyH"LEFT"
	name:ClearAllPoints()
	name:SetPoint("RIGHT", frame)
	name:SetPoint("LEFT", icon, "RIGHT",8,0)
	name:SetNonSpaceWrap(true)
	--name:SetFont(DB.Font, S.Scale(12), "OUTLINE")
	name:SetFontObject(GameFontWhite)

	name:SetWidth(120)
	frame.name = name
	
	frame:SetPoint("TOP", addon, 8, (-5+cfg.iconsize)-(id*(cfg.iconsize+10))-10)
	frame:SetBackdrop{
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 10,
	--insets = {left = 0, right = 0, top = 0, bottom = 0},
	}
	addon.slots[id] = frame
	
	return frame

end
--title:SetFontObject(GameFontNormalLarge)
title:SetFont(DB.Font, S.Scale(20), "OUTLINE")
title:SetTextColor(GameFontNormalLarge:GetTextColor())
title:SetJustifyH"LEFT"
title:SetPoint("TOPLEFT", addon, "TOPLEFT", 6, -4)

addon:SetScript("OnMouseDown", function(self) self:StartMoving() end)
addon:SetScript("OnMouseUp", function(self) self:StopMovingOrSizing() end)
addon:SetScript("OnHide", function(self)
	StaticPopup_Hide"CONFIRM_LOOT_DISTRIBUTION"
	CloseLoot()
end)
addon:SetMovable(true)
addon:RegisterForClicks"anyup"

addon:SetParent(UIParent)
addon:SetUserPlaced(true)
addon:SetPoint("TOPLEFT", 0, -104)
addon:CreateShadow("Background")
addon:SetWidth(256)
addon:SetHeight(64)
addon:SetBackdropColor(0, 0, 0, 1)



addon:SetClampedToScreen(true)
addon:SetClampRectInsets(0, 0, 14, 0)
addon:SetHitRectInsets(0, 0, -14, 0)
addon:SetFrameStrata"HIGH"
addon:SetToplevel(true)

lb:ClearAllPoints()
lb:SetWidth(20)
lb:SetHeight(14)
lb:SetScale(0.85)
lb:SetPoint("TOPRIGHT", addon, "TOPRIGHT", -35, -9)
lb:SetFrameStrata("TOOLTIP")
lb:RegisterForClicks("RightButtonUp", "LeftButtonUp")
lb:SetScript("OnClick", OnLinkClick)
lb:Hide()
UIDropDownMenu_Initialize(LDD, LDD_Initialize, "MENU")

addon.slots = {}
addon.LOOT_CLOSED = function(self)
	StaticPopup_Hide"LOOT_BIND"
	self:Hide()

	for _, v in pairs(self.slots) do
		v:Hide()
	end
	lb:Hide()
end
addon.LOOT_OPENED = function(self, event, autoloot)
	self:Show()
	lb:Show()
	if(not self:IsShown()) then
		CloseLoot(not autoLoot)
	end

	local items = GetNumLootItems()

	if(IsFishingLoot()) then
		title:SetText(L.fish)
	elseif(not UnitIsFriend("player", "target") and UnitIsDead"target") then
		title:SetText(UnitName"target")
	else
		title:SetText(LOOT)
	end

	-- Blizzard uses strings here
	if(GetCVar("lootUnderMouse") == "1") then
		local x, y = GetCursorPosition()
		x = x / self:GetEffectiveScale()
		y = y / self:GetEffectiveScale()

		self:ClearAllPoints()
		self:SetPoint("TOPLEFT", nil, "BOTTOMLEFT", x-40, y+20)
		self:GetCenter()
		self:Raise()
	end

	local m = 0
	if(items > 0) then
		for i=1, items do
			local slot = addon.slots[i] or createSlot(i)
			local texture, item, quantity, quality, locked = GetLootSlotInfo(i)
			local color = ITEM_QUALITY_COLORS[quality]
--[[ 
			if(LootSlotIsCoin(i)) then
				item = item:gsub("\n", ", ")
			end 
]]

			if(quantity and quantity > 1) then
				slot.count:SetText(quantity)
				slot.count:Show()
			else
				slot.count:Hide()
				
			end
			if quality <= 1 then 
				slot.overlay:SetBackdropBorderColor(0, 0, 0)
			else
				slot.overlay:SetBackdropBorderColor(color.r, color.g, color.b)
			end
			slot:SetBackdropBorderColor(color.r, color.g, color.b)

			slot.quality = quality
			slot.name:SetText(item)
			slot.name:SetTextColor(color.r, color.g, color.b)
			slot.icon:SetTexture(texture)
			m = math.max(m, quality)

			slot:Enable()
			slot:Show()
		end
	else
		local slot = addon.slots[1] or createSlot(1)
		local color = ITEM_QUALITY_COLORS[0]

		slot.name:SetText(L.empty)
		slot.name:SetTextColor(color.r, color.g, color.b)
		slot.icon:SetTexture[[Interface\Icons\INV_Misc_Herb_AncientLichen]]

		items = 1

		slot.count:Hide()
		slot:Disable()
		slot:Show()
	end

	local color = ITEM_QUALITY_COLORS[m]
	self:SetBackdropBorderColor(color.r, color.g, color.b, .8)
	self:SetHeight(math.max((items*(cfg.iconsize+10))+27), 20)
	self:SetWidth(250)
	title:SetWidth(220)
	title:SetHeight(16)
	

	local closebutton = CreateFrame("Button", nil)
	closebutton:SetParent( self )
	closebutton:SetWidth(20)
	closebutton:SetHeight(14)
	closebutton:SetScale(0.9)
	closebutton:SetPoint("TOPRIGHT", self, "TOPRIGHT", -6, -7)
	closebutton:SetScript("OnClick", function(self) self:GetParent():Hide() end)
	S.ReskinClose(closebutton)
end

addon.LOOT_SLOT_CLEARED = function(self, event, slot)
	if(not self:IsShown()) then return end

	addon.slots[slot]:Hide()
	
end



addon.OPEN_MASTER_LOOT_LIST = function(self)
	ToggleDropDownMenu(1, nil, GroupLootDropDown, addon.slots[ss], 0, 0)
	--ToggleDropDownMenu(1, nil, GroupLootDropDown, LootFrame.selectedLootButton, 0, 0)
end

addon.UPDATE_MASTER_LOOT_LIST = function(self)
	UIDropDownMenu_Refresh(GroupLootDropDown)
end

addon:SetScript("OnEvent", function(self, event, ...)
	self[event](self, event, ...)
end)

addon:RegisterEvent"LOOT_OPENED"
addon:RegisterEvent"LOOT_SLOT_CLEARED"
addon:RegisterEvent"LOOT_CLOSED"
addon:RegisterEvent"OPEN_MASTER_LOOT_LIST"
addon:RegisterEvent"UPDATE_MASTER_LOOT_LIST"
addon:Hide()

-- Fuzz
LootFrame:UnregisterAllEvents()
table.insert(UISpecialFrames, "m_Loot")

--[[ StaticPopupDialogs["CONFIRM_LOOT_DISTRIBUTION"].OnAccept = function(self, data)
	GiveMasterLoot(self:GetID(), data)
end ]]