local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local

local LOOT = S:NewModule("Loot", "AceEvent-3.0", "AceHook-3.0", "AceConsole-3.0")
local cfg = {
	iconsize = 32, 					-- loot frame icon's size
}

local addon = CreateFrame("Button", "SunUI_Loot")
addon.slots = {}
	
local lb = CreateFrame("Button", "Loot_D", addon, "UIPanelScrollDownButtonTemplate")		-- Link button
local LDD = CreateFrame("Frame", "Loot_b", addon, "UIDropDownMenuTemplate")				-- Link dropdown menu frame

local OnEnter = function(self)
	local slot = self:GetID()
	if GetLootSlotType(slot) == 1 then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetLootItem(slot)
		CursorUpdate(self)
	end 
end

local function OnLinkClick(self)
    ToggleDropDownMenu(1, nil, LDD, lb, 0, 0)
end

local function Announce(chn)
    local nums = GetNumLootItems()
    if(nums == 0) then return end
    if UnitIsPlayer("target") or not UnitExists("target") then -- Chests are hard to identify!
		SendChatMessage("*** Loot from chest ***", chn)
	else
		SendChatMessage("*** "..UnitName("target").." ***", chn)
	end
    for i = 1, GetNumLootItems() do
        if GetLootSlotType(i) == 1 then
            local link = GetLootSlotLink(i)
            SendChatMessage(link, chn)
        end
    end
end

local function LDD_OnClick(self)
    local val = self.value
	Announce(val)
end

local function LDD_Initialize()  
	local info = {}
    
    info.text = TitleText
    info.notCheckable = true
    info.isTitle = true
    UIDropDownMenu_AddButton(info)
    
    --announce chanels
    info = {}
    info.text = CHAT_MSG_RAID
    info.value = "raid"
    info.notCheckable = 1
    info.func = LDD_OnClick
    UIDropDownMenu_AddButton(info)
    
    info = {}
    info.text = CHAT_MSG_GUILD
    info.value = "guild"
    info.notCheckable = 1
    info.func = LDD_OnClick
    UIDropDownMenu_AddButton(info)
	
	info = {}
    info.text = CHAT_MSG_PARTY
    info.value = "party"
    info.notCheckable = 1
    info.func = LDD_OnClick
    UIDropDownMenu_AddButton(info)

    info = {}
    info.text = CHAT_MSG_SAY
    info.value = "say"
    info.notCheckable = 1
    info.func = LDD_OnClick
    UIDropDownMenu_AddButton(info)
    
    info = nil
end

local OnLeave = function(self)	
	GameTooltip:Hide()
	ResetCursor()
end

local OnClick = function(self)
	if(IsModifiedClick()) then
		HandleModifiedItemClick(GetLootSlotLink(self:GetID()))
	else
		LootFrame.selectedLootButton = self
		LootFrame.selectedTexture = self.icon:GetTexture()
		LootFrame.selectedSlot = self:GetID()
		LootFrame.selectedQuality = self.quality
		LootFrame.selectedItemName = self.name:GetText()
		LootSlot(self:GetID())
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
	local frame = CreateFrame("Button", 'SunUI_LootSlot'..id, addon)
	frame:SetPoint("LEFT", cfg.iconsize+8, 0)
	frame:SetPoint("RIGHT", -8, 0)
	frame:SetHeight(cfg.iconsize+2)
	frame:SetID(id)
	frame:SetScript("OnEnter", OnEnter)
	frame:SetScript("OnLeave", OnLeave)
	frame:SetScript("OnClick", OnClick)
	frame:SetScript("OnUpdate", OnUpdate)
	frame:SetFrameStrata("DIALOG")
	
	local A = S:GetModule("Skins")
	A:ReskinFrame(frame)
	
	local iconFrame = CreateFrame("Button", nil, frame)
	iconFrame:SetHeight(cfg.iconsize)
	iconFrame:SetWidth(cfg.iconsize)
	iconFrame:ClearAllPoints()
	iconFrame:SetPoint("RIGHT", frame, "LEFT", -3,0)
	
	iconFrame:SetScript("OnEnter", function() OnEnter(frame) end)
	iconFrame:SetScript("OnLeave", function() OnLeave(frame) end)
	iconFrame:SetScript("OnClick", function() OnClick(frame) end)
	iconFrame:SetScript("OnUpdate",function()  OnUpdate(frame) end)
	
	local icon = iconFrame:CreateTexture(nil, "BACKGROUND")
	icon:SetAlpha(.8)
	icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	icon:SetAllPoints(iconFrame)
	frame.icon = icon
    
	local overlay = CreateFrame("Frame", nil, iconFrame)  
	overlay:SetPoint("TOPLEFT",iconFrame,"TOPLEFT",-1,1)
	overlay:SetPoint("BOTTOMRIGHT",iconFrame,"BOTTOMRIGHT",1,-1)
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
	name:SetPoint("LEFT", frame, 8, 0)
	name:SetNonSpaceWrap(true)
	name:SetFontObject(GameFontWhite)
	name:SetHeight(cfg.iconsize)
	name:SetWidth(120)
	frame.name = name
	
	frame:SetPoint("TOP", addon, 8, (-5+cfg.iconsize)-(id*(cfg.iconsize+10))-10)
	addon.slots[id] = frame
	frame:CreateBorder()
		
	return frame
end

function LOOT:SetFrame()
	local A = S:GetModule("Skins")

	lb:SetFrameStrata("DIALOG")
	LDD:SetFrameStrata("DIALOG")
	
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
	
	addon.text = S:CreateFS(addon)
	addon.text:SetText(BUTTON_LAG_LOOT)
	addon.text:SetPoint("TOPLEFT", addon, "TOPLEFT", 5, -5)
	
	addon:SetPoint("TOPLEFT", 0, -104)
	addon:CreateShadow("Background")
	addon:SetWidth(210)
	addon:SetHeight(64)
	addon:SetBackdropColor(0, 0, 0, 1)
	addon:SetFrameStrata("DIALOG")


	addon:SetClampedToScreen(true)
	addon:SetClampRectInsets(0, 0, 14, 0)
	addon:SetHitRectInsets(0, 0, -14, 0)
	addon:SetToplevel(true)

	lb:ClearAllPoints()
	lb:SetWidth(20)
	lb:SetHeight(14)
	lb:SetScale(0.9)
	lb:SetPoint("TOPRIGHT", addon, "TOPRIGHT", -30, -5)
	lb:SetFrameStrata("TOOLTIP")
	lb:RegisterForClicks("RightButtonUp", "LeftButtonUp")
	lb:SetScript("OnClick", OnLinkClick)
	A:ReskinArrow(lb, "down")
	UIDropDownMenu_Initialize(LDD, LDD_Initialize, "MENU")
	MasterLooterFrame:SetFrameStrata("FULLSCREEN")
	addon:RegisterEvent("LOOT_OPENED")
	addon:RegisterEvent("LOOT_SLOT_CLEARED")
	addon:RegisterEvent("LOOT_CLOSED")
	addon:RegisterEvent("OPEN_MASTER_LOOT_LIST")
	addon:RegisterEvent("UPDATE_MASTER_LOOT_LIST")
	addon:Hide()

	-- Fuzz
	LootFrame:UnregisterAllEvents()
	table.insert(UISpecialFrames, "SunUI_Loot")
end

addon.LOOT_CLOSED = function(self)
	StaticPopup_Hide"LOOT_BIND"
	for _, v in pairs(self.slots) do
		v:Hide()
	end
	lb:Hide()
	self:Hide()
end
addon.LOOT_OPENED = function(self, event, autoloot)
	self:Show()
	lb:Show()
	if(not self:IsShown()) then
		CloseLoot(not autoLoot)
	end
	
	local items = GetNumLootItems()
	
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

	if(items > 0) then
		
		for i=1, items do
			local slot = addon.slots[i] or createSlot(i)
			local texture, item, quantity, quality, locked = GetLootSlotInfo(i)
			local color = ITEM_QUALITY_COLORS[quality or 1]
			--local color = ITEM_QUALITY_COLORS[3]
			if(quantity and quantity > 1) then
				slot.count:SetText(quantity)
				slot.count:Show()
			else
				slot.count:Hide()
			end
			if (quality and quality <= 1) then 
				slot.overlay:SetBackdropBorderColor(0, 0, 0)
				--slot:SetBackdropBorderColor(0, 0, 0)
			else
				slot.overlay:SetBackdropBorderColor(color.r , color.g, color.b)
				--slot:SetBackdropBorderColor(color.r or 0, color.g or 0, color.b or 0)
			end
			slot.quality = quality or 0
			slot.name:SetText(item)
			slot.name:SetTextColor(color.r or 0, color.g or 0, color.b or 0)
			slot.icon:SetTexture(texture)

			slot:Enable()
			slot:Show()
		end
	else
		local slot = addon.slots[1] or createSlot(1)
		local color = ITEM_QUALITY_COLORS[0]

		slot.name:SetText(EMPTY)
		slot.name:SetTextColor(color.r, color.g, color.b)
		slot.icon:SetTexture[[Interface\Icons\INV_Misc_Herb_AncientLichen]]

		items = 1

		slot.count:Hide()
		slot:Disable()
		slot:Show()
	end

	self:SetHeight(math.max((items*(cfg.iconsize+10))+27), 20)
	self:SetWidth(210)
	
	local closebutton = CreateFrame("Button", nil)
	closebutton:SetParent( self )
	closebutton:SetWidth(20)
	closebutton:SetHeight(14)
	closebutton:SetScale(0.9)
	closebutton:SetPoint("TOPRIGHT", self, "TOPRIGHT", -6, -7)
	closebutton:SetScript("OnClick", function(self) self:GetParent():Hide() end)
	local A = S:GetModule("Skins")
	A:ReskinClose(closebutton)
end

addon.LOOT_SLOT_CLEARED = function(self, event, slot)
	if(not self:IsShown()) then return end
	addon.slots[slot]:Hide()
end



addon.OPEN_MASTER_LOOT_LIST = function(self)
	ToggleDropDownMenu(1, nil, GroupLootDropDown, addon.slots[ss], 0, 0)
end

addon.UPDATE_MASTER_LOOT_LIST = function(self)
	UIDropDownMenu_Refresh(GroupLootDropDown)
end

addon:SetScript("OnEvent", function(self, event, ...)
	self[event](self, event, ...)
end)

LOOT.modName = L["拾取美化"]

function LOOT:Initialize()
	self:SetFrame()
	self:initRool()
end

S:RegisterModule(LOOT:GetName())