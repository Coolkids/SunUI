local S, L, DB, _, C = unpack(select(2, ...))
local _G = _G
local L = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("Loot", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")
local cfg = {
	iconsize = 32, 					-- loot frame icon's size
}
local TitleText = "Items"
if GetLocale() == "zhCN" then
    TitleText = "战利品"
end
if GetLocale() == "zhTW" then
    TitleText = "戰利品"
end
local L = {
	fish = "钓鱼",
	empty = "空",
}
local addon = CreateFrame("Button", "SunUI_Loot")

local title = CreateFrame("Button", nil, addon)
title.text = S.MakeFontString(addon)
title.text:SetPoint("CENTER", title, "CENTER")
title:SetHeight(25)
title:SetPoint("BOTTOMLEFT", addon, "TOPLEFT", 0, 11)
title:SetPoint("BOTTOMRIGHT", addon, "TOPRIGHT", 0, 11)
title:CreateShadow("Background")
LootTargetPortrait=CreateFrame("PlayerModel",nil,addon)
LootTargetPortrait:SetPoint("TOPRIGHT",title,"TOPLEFT",-11,0)
LootTargetPortrait:SetHeight(50)
LootTargetPortrait:SetWidth(50)
LootTargetPortrait:CreateShadow("Background")
	
local lb = CreateFrame("Button", "Loot_D", addon, "UIPanelScrollDownButtonTemplate")		-- Link button
local LDD = CreateFrame("Frame", "Loot_b", addon, "UIDropDownMenuTemplate")				-- Link dropdown menu frame
lb:SetFrameStrata("DIALOG")
LDD:SetFrameStrata("DIALOG")
local sq, ss, sn
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
	local color = ITEM_QUALITY_COLORS[self.quality]
	GameTooltip:Hide()
	ResetCursor()
end

local OnClick = function(self)
	if(IsModifiedClick()) then
		HandleModifiedItemClick(GetLootSlotLink(self:GetID()))
	else
		ss = self:GetID()
		sq = self.quality
		sn = self.name:GetText()
		LootFrame.selectedLootButton = self
		LootFrame.selectedTexture = self.icon:GetTexture()
		LootFrame.selectedSlot = ss
		LootFrame.selectedQuality = sq
		LootFrame.selectedItemName = sn
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
	frame:SetPoint("LEFT", cfg.iconsize+8, 0)
	frame:SetPoint("RIGHT", -8, 0)
	frame:SetHeight(cfg.iconsize+2)
	frame:SetID(id)
	frame:SetScript("OnEnter", OnEnter)
	frame:SetScript("OnLeave", OnLeave)
	frame:SetScript("OnClick", OnClick)
	frame:SetScript("OnUpdate", OnUpdate)
	frame:SetFrameStrata("DIALOG")
	local gradient = frame:CreateTexture(nil, "BACKGROUND")
	gradient:SetPoint("TOPLEFT")
	gradient:SetPoint("BOTTOMRIGHT")
	gradient:SetTexture(DB.Statusbar)
	gradient:SetGradientAlpha("VERTICAL", .3, .3, .3, .6, .1, .1, .1, .6)
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
title.text:SetTextColor(DB.MyClassColor.r, DB.MyClassColor.g, DB.MyClassColor.b)
title.text:SetJustifyH"CENTER"
addon:SetScript("OnMouseDown", function(self) self:StartMoving() end)
addon:SetScript("OnMouseUp", function(self) self:StopMovingOrSizing() end)
title:SetScript("OnMouseDown", function() addon:StartMoving() end)
title:SetScript("OnMouseUp", function() addon:StopMovingOrSizing() end)
addon:SetScript("OnHide", function(self)
	StaticPopup_Hide"CONFIRM_LOOT_DISTRIBUTION"
	CloseLoot()
end)
addon:SetMovable(true)
addon:RegisterForClicks"anyup"
title:SetMovable(true)
title:RegisterForClicks"anyup"
addon:SetParent(UIParent)
addon:SetUserPlaced(true)
title:SetUserPlaced(true)

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
title:SetToplevel(true)
lb:ClearAllPoints()
lb:SetWidth(20)
lb:SetHeight(14)
lb:SetScale(0.9)
lb:SetPoint("TOPRIGHT", addon, "TOPRIGHT", -30, -5)
lb:SetFrameStrata("TOOLTIP")
lb:RegisterForClicks("RightButtonUp", "LeftButtonUp")
lb:SetScript("OnClick", OnLinkClick)
function L:OnInitialize()
	S.ReskinArrow(lb, "down")
end
UIDropDownMenu_Initialize(LDD, LDD_Initialize, "MENU")
MasterLooterFrame:SetFrameStrata("FULLSCREEN")

addon.slots = {}
addon.LOOT_CLOSED = function(self)
	StaticPopup_Hide"LOOT_BIND"
	S.FadeOutFrameDamage(self, 0.3)
	for _, v in pairs(self.slots) do
		v:Hide()
	end
	lb:Hide()
end
addon.LOOT_OPENED = function(self, event, autoloot)
	self:Show()
	UIFrameFadeIn(self, 0.3, 0, 1)
	lb:Show()
	if(not self:IsShown()) then
		CloseLoot(not autoLoot)
	end

	local items = GetNumLootItems()

	if(IsFishingLoot()) then
		title.text:SetText(L.fish)
	elseif(not UnitIsFriend("player", "target") and UnitIsDead"target") then
		title.text:SetText(UnitName("target"))
	else
		title.text:SetText(LOOT)
	end
	if(UnitExists("target") and not IsFishingLoot()) then
		LootTargetPortrait:SetUnit("target")
		LootTargetPortrait:SetCamera(0)
	elseif IsFishingLoot() then
		LootTargetPortrait:ClearModel()
		LootTargetPortrait:SetUnit("player")
		--LootTargetPortrait:SetModel("PARTICLES\\Lootfx.m2")
		LootTargetPortrait:SetCamera(0)
	else
		LootTargetPortrait:ClearModel()
		LootTargetPortrait:SetUnit("player")
		LootTargetPortrait:SetCamera(0)
		--LootTargetPortrait:SetModel("PARTICLES\\Lootfx.m2")
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
		title.text:SetText(TitleText.." x "..items)
		for i=1, items do
			local slot = addon.slots[i] or createSlot(i)
			local texture, item, quantity, quality, locked = GetLootSlotInfo(i)
			local color = ITEM_QUALITY_COLORS[quality or 1]

			if(quantity and quantity > 1) then
				slot.count:SetText(quantity)
				slot.count:Show()
			else
				slot.count:Hide()
			end
			if (quality and quality <= 1) then 
				slot.overlay:SetBackdropBorderColor(0, 0, 0)
				slot:SetBackdropBorderColor(0, 0, 0)
			else
				slot.overlay:SetBackdropBorderColor(color.r , color.g, color.b)
				slot:SetBackdropBorderColor(color.r or 0, color.g or 0, color.b or 0)
			end
			slot.quality = quality or 0
			slot.name:SetText(item)
			slot.name:SetTextColor(color.r or 0, color.g or 0, color.b or 0)
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
	self:SetWidth(210)
	
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
table.insert(UISpecialFrames, "SunUI_Loot")
