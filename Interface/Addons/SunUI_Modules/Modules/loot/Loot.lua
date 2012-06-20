local S, C, L, DB = unpack(SunUI)

local config = {
	font = {DB.Font, 14, "OUTLINE" }, --普通字体
	bigfont = {DB.Font, 18, "OUTLINE" },  --标题字体
	iconsize = 32, --图标大小
	framescale = 1, --缩放
	point = { "CENTER", },  --坐标
}

local function CreateTwinkling(f)
	if f.twinkling then return end
	local twinkling = f:CreateAnimationGroup()
	local fadeIn = twinkling:CreateAnimation( "Alpha" );
	fadeIn:SetOrder(1)
	fadeIn:SetSmoothing("IN_OUT")
	fadeIn:SetChange( -1 );
	fadeIn:SetDuration( .5 );
	local fadeOut = twinkling:CreateAnimation( "Alpha" );
	fadeOut:SetOrder( 2 );
	fadeOut:SetChange( 1 );
	fadeOut:SetDuration( .5 );
	fadeOut:SetSmoothing("OUT")
	twinkling:SetScript("OnFinished", function(self) self:Play() end)
	f.twinkling = twinkling
	return twinkling
end

local fish, empty = "Fish", "empty"
local addon = CreateFrame("Button", "Butsu")
addon:CreateShadow("Background")


local title = addon:CreateFontString(nil, "OVERLAY")
local iconSize = config.iconsize
local frameScale = config.scale

local sq, ss, sn

local OnEnter = function(self)
	--self.twinkling:Play()
	self.glow:Show()
	local slot = self:GetID()
	if(LootSlotIsItem(slot)) then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetLootItem(slot)
		CursorUpdate(self)
	end
	LootFrame.selectedSlot = self:GetID()
end

local OnLeave = function(self)
	--self.twinkling:Stop()
	self.glow:Hide()
	GameTooltip:Hide()
	ResetCursor()
end

local OnClick = function(self)
	if(IsModifiedClick()) then
		HandleModifiedItemClick(GetLootSlotLink(self:GetID()))
	else
		StaticPopup_Hide"CONFIRM_LOOT_DISTRIBUTION"
		ss = self:GetID()
		sq = self.quality
		sn = self.name:GetText()
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
	local iconsize = iconSize
	local frame = CreateFrame("Button", "ButsuSlot"..id, addon)
	frame:SetPoint("LEFT", 5, 0)
	frame:SetPoint("RIGHT", -5, 0)
	frame:SetHeight(iconsize)
	CreateTwinkling(frame)
	frame:SetID(id)

	frame:RegisterForClicks("LeftButtonUp", "RightButtonUp")

	frame:SetScript("OnEnter", OnEnter)
	frame:SetScript("OnLeave", OnLeave)
	frame:SetScript("OnClick", OnClick)
	frame:SetScript("OnUpdate", OnUpdate)
	
	local iconFrame = CreateFrame("Frame", tostring(frame:GetName()).."IconFrame", frame)
	iconFrame:SetHeight(iconsize)
	iconFrame:SetWidth(iconsize)
	iconFrame:ClearAllPoints()
	iconFrame:SetPoint("LEFT", frame)
	h = CreateFrame("Frame", nil, iconFrame)
	h:SetPoint("TOPLEFT", 1, -1)
	h:SetPoint("BOTTOMRIGHT", -1, 1)
	h:CreateBorder()
	frame.iconFrame = h
	
	local icon = iconFrame:CreateTexture(nil, "ARTWORK")
	icon:SetAlpha(.8)
	icon:SetTexCoord(.07, .93, .07, .93)
	icon:SetPoint("TOPLEFT", 2, -2)
	icon:SetPoint("BOTTOMRIGHT", -2, 2)
	frame.icon = icon

	local count = iconFrame:CreateFontString(nil, "OVERLAY")
	count:ClearAllPoints()
	count:SetJustifyH"RIGHT"
	count:SetPoint("BOTTOMRIGHT", iconFrame, -1, 2)
	count:SetFont(unpack(config.font))
	count:SetShadowOffset(1, 1)
	count:SetShadowColor(.3, .3, .3, .7)
	count:SetText(1)
	frame.count = count

	local name = frame:CreateFontString(nil, "OVERLAY")
	name:SetJustifyH("LEFT")
	name:ClearAllPoints()
	name:SetPoint("RIGHT", frame)
	name:SetPoint("LEFT", icon, "RIGHT", 5, 0)
	name:SetNonSpaceWrap(true)
	name:SetFont(unpack(config.font))
	name:SetShadowOffset(1, -1)
	name:SetShadowColor(.3, .3, .3, .7)
	frame.name = name

	local glow = frame:CreateTexture(nil, "ARTWORK")
	glow:SetAlpha(.4)
	glow:SetPoint("TOPLEFT", icon, "TOPRIGHT", 2, 0)
	glow:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 2)
	--glow:SetHeight(config.iconsize)
	glow:SetTexture("Interface\\Buttons\\WHITE8x8")
	glow:SetVertexColor(.8, .8, 0)
	glow:Hide()
	frame.glow = glow
	
	addon.slots[id] = frame
	return frame
end

local anchorSlots = function(self)
	local iconsize = iconSize
	local shownSlots = 0
	for i=1, #self.slots do
		local frame = self.slots[i]
		if(frame:IsShown()) then
			shownSlots = shownSlots + 1

			-- We don't have to worry about the previous slots as they're already hidden.
			frame:SetPoint("TOP", addon, 0, ( -5 + iconsize) - (shownSlots * iconsize) - (shownSlots - 1) * 5)
		end
	end

	self:SetHeight(math.max(shownSlots * iconsize + 10 + ( shownSlots - 1) * 5 , iconsize))
end

title:SetFont(unpack(config.bigfont))
title:SetShadowOffset(1, -1)
title:SetShadowColor(.3, .3, .3, .7)
title:SetPoint("BOTTOMLEFT", addon, "TOPLEFT", 4, 4)
addon:RegisterForDrag("LeftButton")
addon:SetScale(config.framescale)
addon:SetScript("OnMouseDown", function(self) if(IsAltKeyDown()) then self:StartMoving() end end)
addon:SetScript("OnMouseUp", function(self) self:StopMovingOrSizing() end)
addon:SetScript("OnHide", function(self)
	StaticPopup_Hide"CONFIRM_LOOT_DISTRIBUTION"
	CloseLoot()
end)
addon:SetMovable(true)
addon:RegisterForClicks"anyup"
addon:SetUserPlaced(true)
addon:SetParent(UIParent)
addon:SetScript("OnDragStart", function(self) self:StartMoving() end)
addon:SetScript("OnDragStop", function(self)
	self:StopMovingOrSizing()
end)
--addon:SetPoint(unpack(config.point))		
addon:SetWidth(256)
addon:SetHeight(64)

addon:SetClampedToScreen(true)
addon:SetClampRectInsets(0, 0, 14, 0)
addon:SetHitRectInsets(0, 0, -14, 0)
addon:SetFrameStrata("HIGH")
addon:SetToplevel(true)

local chn = { "say", "party", "guild", "raid"}
local chnc = {
	{1, 1, 1, .7},
	{.1, .5, .7, .7},
	{0, .8, 0, .7},
	{.85, .2, .1, .7},
}
local pos = {
{"TOPRIGHT", Butsu, "BOTTOM", -28, -5},
{"TOPRIGHT", Butsu, "BOTTOM", -2, -5},
{"TOPLEFT", Butsu, "BOTTOM", 2, -5},
{"TOPLEFT", Butsu, "BOTTOM", 28, -5},
}

local function Announce(chn)
    local nums = GetNumLootItems()
    if(nums == 0) then return end
    if UnitIsPlayer("target") or not UnitExists("target") then -- Chests are hard to identify!
		SendChatMessage("*** Loot from chest ***", chn)
	else
		SendChatMessage("*** Loot from "..UnitName("target").." ***", chn)
	end
    for i = 1, GetNumLootItems() do
        if(LootSlotIsItem(i)) then     --判断，只发送物品
            local link = GetLootSlotLink(i)
            local messlink = "- %s"
            SendChatMessage(format(messlink, link), chn)
        end
    end
end

local AnnounceButton = {}
for i = 1, #chn do
	AnnounceButton[i] = CreateFrame("Button", "AnnounceButton"..i, Butsu)
	AnnounceButton[i]:SetSize(22, 10)
	AnnounceButton[i]:SetPoint(unpack(pos[i]))
	AnnounceButton[i]:SetScript("OnClick", function() Announce(chn[i]) end)
	AnnounceButton[i]:CreateShadow("")
	AnnounceButton[i].shadow:SetBackdropColor(unpack(chnc[i]))
end

addon.slots = {}
addon.LOOT_OPENED = function(self, event, autoloot)
	self:Show()

	if(not self:IsShown()) then
		CloseLoot(not autoLoot)
	end

	local items = GetNumLootItems()

	if(IsFishingLoot()) then
		title:SetText(fish)
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
		self:SetPoint("TOPLEFT", nil, "BOTTOMLEFT", x - 40, y + 20)
		self:RegisterForDrag("LeftButton")
		self:SetScript("OnMouseDown", function(self) self:StartMoving() end)
		self:SetScript("OnMouseUp", function(self) self:StopMovingOrSizing() end)
		self:GetCenter()
		self:Raise()
	else
		self:ClearAllPoints()
		self:SetUserPlaced(false)
		self:SetPoint(unpack(config.point))		
	end

	local m, w, t = 0, 0, title:GetStringWidth()
	if(items > 0) then
		for i=1, items do
			local slot = addon.slots[i] or createSlot(i)
			local texture, item, quantity, quality, locked = GetLootSlotInfo(i)
			local color = ITEM_QUALITY_COLORS[quality]

			if(LootSlotIsCoin(i)) then
				item = item:gsub("\n", ", ")
			end

			if(quantity > 1) then
				slot.count:SetText(quantity)
				slot.count:Show()
			else
				slot.count:Hide()
			end
			
			if(quality > 1) then
				slot.iconFrame:SetBackdropBorderColor(color.r, color.g, color.b)
			else
				slot.iconFrame:SetBackdropBorderColor(0, 0, 0)
			end

			slot.quality = quality
			slot.name:SetText(item)
			slot.name:SetTextColor(color.r, color.g, color.b)
			slot.icon:SetTexture(texture)
			w = math.max(w, slot.name:GetStringWidth())
			
			slot:Enable()
			slot:Show()
		end
	else
		local slot = addon.slots[1] or createSlot(1)
		local color = ITEM_QUALITY_COLORS[0]

		slot.name:SetText(empty)
		slot.name:SetTextColor(color.r, color.g, color.b)
		slot.icon:SetTexture(nil)

		items = 1
		w = math.max(w, slot.name:GetStringWidth())

		slot.count:Hide()
		slot:Disable()
		slot:Show()
	end
	anchorSlots(self)

	w = w + 70
	t = t + 15

	self:SetWidth(math.max(w, t))
end

addon.LOOT_SLOT_CLEARED = function(self, event, slot)
	if(not self:IsShown()) then return end

	addon.slots[slot]:Hide()
	anchorSlots(self)
end

addon.LOOT_CLOSED = function(self)
	StaticPopup_Hide"LOOT_BIND"
	self:Hide()

	for _, v in pairs(self.slots) do
		v:Hide()
	end
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
table.insert(UISpecialFrames, "Butsu")

function _G.GroupLootDropDown_GiveLoot(self)
	if ( sq >= MASTER_LOOT_THREHOLD ) then
		local dialog = StaticPopup_Show("CONFIRM_LOOT_DISTRIBUTION", ITEM_QUALITY_COLORS[sq].hex..sn..FONT_COLOR_CODE_CLOSE, self:GetText())
		if (dialog) then
			dialog.data = self.value
		end
	else
		GiveMasterLoot(ss, self.value)
	end
	CloseDropDownMenus()
end

StaticPopupDialogs["CONFIRM_LOOT_DISTRIBUTION"].OnAccept = function(self, data)
	GiveMasterLoot(ss, data)
end